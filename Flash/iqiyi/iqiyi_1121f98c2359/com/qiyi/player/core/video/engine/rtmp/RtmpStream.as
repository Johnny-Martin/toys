package com.qiyi.player.core.video.engine.rtmp
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.engine.dispatcher.*;
    import com.qiyi.player.core.video.events.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class RtmpStream extends EventDispatcher implements IDestroy
    {
        private var _holder:ICorePlayer;
        private var _segment:Segment;
        private var _dispatcher:Dispatcher;
        private var _cn:NetConnection;
        private var _ns:Decoder;
        private var _streamFileName:String;
        private var _seeking:Boolean = false;
        private var _seeked:Boolean = false;
        private var _seekTime:int;
        private var _retryCount:int;
        private var _firstFull:Boolean = false;
        private var _paused:Boolean = false;
        private var _isStart:Boolean = false;
        private var _isStop:Boolean = false;
        private var _stopTime:int;
        private var _timeoutForEmpty:uint = 0;
        private var _log:ILogger;
        public static const Evt_Stuck:String = "stuck";

        public function RtmpStream(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.video.engine.rtmp.RtmpStream");
            this._holder = param1;
            this._dispatcher = new Dispatcher(this._holder);
            this._dispatcher.addEventListener(DispatcherEvent.Evt_Success, this.onDispatcherSuccess);
            this._dispatcher.addEventListener(DispatcherEvent.Evt_Failed, this.onDispatcherFailed);
            Settings.instance.addEventListener(Settings.Evt_MuteChanged, this.onVolumeChanged);
            Settings.instance.addEventListener(Settings.Evt_VolumeChanged, this.onVolumeChanged);
            return;
        }// end function

        public function get decoder() : Decoder
        {
            return this._ns;
        }// end function

        public function get bufferTime() : Number
        {
            if (this._seeking)
            {
                return this._seekTime;
            }
            if (this._ns == null)
            {
                return 0;
            }
            return this.time + this._ns.bufferLength * 1000;
        }// end function

        public function get time() : Number
        {
            if (this._seeking)
            {
                return this._seekTime;
            }
            if (this._ns == null)
            {
                return 0;
            }
            return this._ns.time * 1000;
        }// end function

        public function bind(param1:Segment) : void
        {
            this._segment = param1;
            this._streamFileName = "mp4:fms/" + this._segment.url.split("fms/")[1];
            this._retryCount = 0;
            this._isStop = false;
            this._stopTime = 0;
            this._seeking = true;
            this._seekTime = this._segment.startTime;
            this._dispatcher.stop();
            this._dispatcher.start(this._segment);
            return;
        }// end function

        public function pause() : void
        {
            this._paused = true;
            if (this._ns)
            {
                this._ns.pause();
            }
            return;
        }// end function

        public function resume() : void
        {
            this._paused = false;
            if (this._ns)
            {
                this._ns.resume();
            }
            return;
        }// end function

        private function createNetConnection(param1:String) : void
        {
            this.destroyNetConnection();
            this._cn = new NetConnection();
            this._cn.client = new NetClient(this);
            this._cn.addEventListener(NetStatusEvent.NET_STATUS, this.onConnectionNetStatus);
            this._cn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConnectionSecurityError);
            this._cn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onConnectionAasyncError);
            this._cn.addEventListener(IOErrorEvent.IO_ERROR, this.onConnectionIOError);
            this._cn.connect(param1);
            return;
        }// end function

        private function createDecoder() : void
        {
            this.destroyDecoder();
            this._ns = new Decoder(this._cn);
            this._ns.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            this._ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onAsyncError);
            this._ns.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._ns.bufferTime = Config.STREAM_NORMAL_BUFFER_TIME / 1000;
            this.onVolumeChanged();
            return;
        }// end function

        private function destroyNetConnection() : void
        {
            if (this._cn)
            {
                this._cn.removeEventListener(NetStatusEvent.NET_STATUS, this.onConnectionNetStatus);
                this._cn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConnectionSecurityError);
                this._cn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onConnectionAasyncError);
                this._cn.removeEventListener(IOErrorEvent.IO_ERROR, this.onConnectionIOError);
                this._cn.close();
                this._cn = null;
            }
            return;
        }// end function

        private function destroyDecoder() : void
        {
            if (this._ns)
            {
                this._ns.removeEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
                this._ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onAsyncError);
                this._ns.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
                this._ns.destroy();
                this._ns = null;
            }
            this._isStart = false;
            return;
        }// end function

        public function destroy() : void
        {
            if (this._dispatcher)
            {
                this._dispatcher.removeEventListener(DispatcherEvent.Evt_Success, this.onDispatcherSuccess);
                this._dispatcher.removeEventListener(DispatcherEvent.Evt_Failed, this.onDispatcherFailed);
                this._dispatcher.stop();
                this._dispatcher = null;
            }
            if (this._ns)
            {
                this._ns.removeEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
                this._ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onAsyncError);
                this._ns.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
                this._ns.close();
                this._ns = null;
            }
            if (this._cn)
            {
                this._cn.removeEventListener(NetStatusEvent.NET_STATUS, this.onConnectionNetStatus);
                this._cn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConnectionSecurityError);
                this._cn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onConnectionAasyncError);
                this._cn.removeEventListener(IOErrorEvent.IO_ERROR, this.onConnectionIOError);
                this._cn.close();
                this._cn = null;
            }
            if (this._timeoutForEmpty)
            {
                clearTimeout(this._timeoutForEmpty);
                this._timeoutForEmpty = 0;
            }
            Settings.instance.removeEventListener(Settings.Evt_MuteChanged, this.onVolumeChanged);
            Settings.instance.removeEventListener(Settings.Evt_VolumeChanged, this.onVolumeChanged);
            return;
        }// end function

        private function onVolumeChanged(event:Event = null) : void
        {
            var _loc_2:SoundTransform = null;
            if (this._ns)
            {
                _loc_2 = new SoundTransform();
                _loc_2.volume = Settings.instance.mute ? (0) : (Settings.instance.volumn / 100);
                this._ns.soundTransform = _loc_2;
            }
            return;
        }// end function

        private function onDispatcherFailed(event:DispatcherEvent) : void
        {
            dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
            return;
        }// end function

        public function seek(param1:int) : void
        {
            this._log.debug("RtmpStream(index: " + this._segment.index + ") seek: " + param1);
            if (this._segment.endTime - param1 <= 1000 || this._isStop && param1 > this._stopTime)
            {
                dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Stop));
            }
            else
            {
                this._isStop = false;
                this._stopTime = 0;
                this._seeking = true;
                this._seeked = true;
                this._seekTime = param1;
                this._segment.seek(this._seekTime);
                if (this._ns)
                {
                    this._ns.seek(this._seekTime);
                }
            }
            return;
        }// end function

        private function onDispatcherSuccess(event:DispatcherEvent) : void
        {
            var _loc_2:* = (event.data as String).substr(7);
            this.createNetConnection("rtmpe://" + _loc_2.substring(0, _loc_2.indexOf("/")) + "/flvwww");
            return;
        }// end function

        private function onConnectionNetStatus(event:NetStatusEvent) : void
        {
            this._log.info(event.info.code);
            switch(event.info.code)
            {
                case "NetConnection.Connect.NetworkChange":
                {
                    break;
                }
                case "NetConnection.Connect.Success":
                {
                    this.createDecoder();
                    dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Connected));
                    this._ns.play(this._streamFileName);
                    if (this._paused)
                    {
                        this._ns.pause();
                    }
                    else
                    {
                        this._ns.resume();
                    }
                    break;
                }
                default:
                {
                    this._holder.runtimeData.preErrorCode = "4100";
                    this.retry();
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function onConnectionSecurityError(event:SecurityErrorEvent) : void
        {
            this._log.info("RtmpStream: NetConnection SecurityError");
            this._holder.runtimeData.preErrorCode = "4100";
            this.retry();
            return;
        }// end function

        private function onConnectionAasyncError(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function onConnectionIOError(event:IOErrorEvent) : void
        {
            this._log.info("RtmpStream: NetConnection IOError");
            this._holder.runtimeData.preErrorCode = "4100";
            this.retry();
            return;
        }// end function

        protected function onAsyncError(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        protected function onIOError(event:IOErrorEvent) : void
        {
            this._log.info("RtmpStream (" + this._segment.index + ") trigger IOError: " + event.type);
            dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
            return;
        }// end function

        private function onNetStatus(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    if (this._seeking && !this._isStart)
                    {
                        this._firstFull = true;
                        this._ns.seek(this._seekTime);
                    }
                    this._isStart = true;
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (this._isStop)
                    {
                        dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Stop));
                    }
                    else if (!this._seeked)
                    {
                        clearTimeout(this._timeoutForEmpty);
                        this._timeoutForEmpty = setTimeout(this.sendEmptyPingback, 1000);
                        dispatchEvent(new Event(Evt_Stuck));
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    clearTimeout(this._timeoutForEmpty);
                    this._timeoutForEmpty = 0;
                    this._seeked = false;
                    if (this._firstFull)
                    {
                        this._firstFull = false;
                        this._ns.seek(this._seekTime);
                    }
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (this._segment.endTime - this.time <= 1000)
                    {
                        dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Stop));
                    }
                    else
                    {
                        this._isStop = true;
                        this._stopTime = this.time;
                    }
                    clearTimeout(this._timeoutForEmpty);
                    this._timeoutForEmpty = 0;
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    this._seeking = false;
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    this._holder.runtimeData.preErrorCode = "4100";
                    this.retry();
                    break;
                }
                case "NetStream.Play.FileStructureInvalid":
                {
                    this._holder.runtimeData.preErrorCode = "4100";
                    this.retry();
                    break;
                }
                case "NetStream.Play.NoSupportedTrackFound":
                {
                    this._holder.runtimeData.preErrorCode = "4100";
                    this.retry();
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    this._holder.runtimeData.preErrorCode = "4100";
                    this.retry();
                    break;
                }
                case "NetStream.Seek.Failed":
                case "NetStream.Seek.InvalidTime":
                {
                    this._holder.runtimeData.preErrorCode = "4100";
                    this.retry();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function sendEmptyPingback() : void
        {
            clearTimeout(this._timeoutForEmpty);
            this._timeoutForEmpty = 0;
            var _loc_1:* = this._holder.runtimeData;
            var _loc_2:* = this._holder.runtimeData.bufferEmpty + 1;
            _loc_1.bufferEmpty = _loc_2;
            this._holder.pingBack.sendError(4015);
            return;
        }// end function

        private function retry() : void
        {
            this._holder.runtimeData.currentSpeed = 0;
            this._log.info("RtmpStream(index: " + this._segment.index + ") failed, errno=" + this._holder.runtimeData.preErrorCode);
            if (this._retryCount >= Config.STREAM_MAX_RETRY)
            {
                dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
            }
            else
            {
                var _loc_1:String = this;
                var _loc_2:* = this._retryCount + 1;
                _loc_1._retryCount = _loc_2;
                this._holder.runtimeData.retryCount = this._retryCount;
                if (this._ns)
                {
                    this._seekTime = this._ns.time * 1000 + this._segment.startTime;
                    this._segment.seek(this._seekTime);
                }
                this._seeking = true;
                dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Retry));
                this._dispatcher.stop();
                this._dispatcher.start(this._segment);
                this._log.info("RtmpStream retry NO: " + this._retryCount);
            }
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            return;
        }// end function

    }
}
