package com.qiyi.player.core.video.engine.http
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.*;
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

    public class HttpStream extends EventDispatcher implements IDestroy
    {
        private var _holder:ICorePlayer;
        private var _movie:IMovie;
        private var _segment:Segment;
        private var _cn:NetConnection;
        private var _ns:Decoder;
        private var _ready:Boolean = false;
        private var _paused:Boolean = false;
        private var _bufferEmpty:Boolean = false;
        private var _loadComplete:Boolean = false;
        private var _failed:Boolean = false;
        private var _stopped:Boolean = false;
        private var _seeking:Boolean = false;
        private var _startKeyframe:Keyframe;
        private var _retryCount:int = 0;
        private var _timer:Timer;
        private var _dispatcher:Dispatcher;
        private var _log:ILogger;

        public function HttpStream(param1:ICorePlayer, param2:IMovie)
        {
            this._log = Log.getLogger("com.qiyi.player.core.video.engine.http.HttpStream");
            this._holder = param1;
            this._movie = param2;
            this._dispatcher = new Dispatcher(this._holder);
            this._dispatcher.addEventListener(DispatcherEvent.Evt_Success, this.onDispatcherSuccess);
            this._dispatcher.addEventListener(DispatcherEvent.Evt_Failed, this.onDispatcherFailed);
            Settings.instance.addEventListener(Settings.Evt_MuteChanged, this.onVolumeChanged);
            Settings.instance.addEventListener(Settings.Evt_VolumeChanged, this.onVolumeChanged);
            return;
        }// end function

        public function get ready() : Boolean
        {
            return this._ready;
        }// end function

        public function get loadComplete() : Boolean
        {
            return this._loadComplete;
        }// end function

        public function get segment() : Segment
        {
            return this._segment;
        }// end function

        public function get time() : Number
        {
            if (this._seeking || this._ns == null || this._ns.time == 0)
            {
                if (this._startKeyframe)
                {
                    return this._startKeyframe.time;
                }
                return this._segment.startTime;
            }
            return this._ns.time * 1000;
        }// end function

        public function get bufferTime() : Number
        {
            if (this._ns == null)
            {
                if (this._startKeyframe)
                {
                    return this._startKeyframe.time;
                }
                return this._segment.startTime;
            }
            if (this._ns.bytesLoaded == this._ns.bytesTotal)
            {
                return this._segment.startTime + this._segment.totalTime;
            }
            if (this._startKeyframe == null || this._segment.keyframes == null)
            {
                return this._segment.startTime + this._segment.totalTime * this._ns.bytesLoaded / this._ns.bytesTotal;
            }
            var _loc_1:* = this._startKeyframe.position + this._ns.bytesLoaded - this._segment.keyframes[0].position;
            var _loc_2:* = this._segment.getKeyframeByPosition(_loc_1);
            return _loc_2.time + (_loc_1 - _loc_2.position) / _loc_2.lenPos * _loc_2.lenTime;
        }// end function

        public function get bufferRate() : Number
        {
            var _loc_1:* = this._ns ? (this._ns.bufferLength / this._ns.bufferTime) : (0);
            return _loc_1 >= 1 ? (1) : (_loc_1);
        }// end function

        public function get failed() : Boolean
        {
            return this._failed;
        }// end function

        public function get startTime() : int
        {
            return this._startKeyframe ? (this._startKeyframe.segmentTime) : (0);
        }// end function

        public function get decoder() : Decoder
        {
            return this._ns;
        }// end function

        public function bind(param1:Segment) : void
        {
            this._segment = param1;
            return;
        }// end function

        public function pause() : void
        {
            this._paused = true;
            if (this._ready)
            {
                this._ns.pause();
                this._log.debug("HttpStream (" + this._segment.index + ") is paused");
            }
            return;
        }// end function

        public function resume() : void
        {
            this._paused = false;
            if (this._ready)
            {
                this._ns.resume();
                this._log.debug("HttpStream (" + this._segment.index + ") is resume");
            }
            return;
        }// end function

        public function seek(param1:int = -1) : void
        {
            var _loc_2:Keyframe = null;
            var _loc_3:int = 0;
            if (this._failed)
            {
                return;
            }
            this._stopped = false;
            this._seeking = true;
            if (this._ns)
            {
                _loc_2 = this._segment.currentKeyframe;
                if (_loc_2 == null)
                {
                    this._seeking = false;
                    this.reload();
                }
                else
                {
                    _loc_3 = this._startKeyframe ? (this._startKeyframe.position) : (0);
                    if (_loc_2.position >= _loc_3 && _loc_2.position <= _loc_3 + this._ns.bytesLoaded)
                    {
                        this._ns.seek(this._segment.startTime + _loc_2.segmentTime);
                    }
                    else
                    {
                        this.reload();
                    }
                }
            }
            else
            {
                this.reload();
            }
            return;
        }// end function

        public function stopLoad() : void
        {
            this.destroyStream();
            return;
        }// end function

        public function destroy() : void
        {
            this.destroyStream();
            this._holder = null;
            this._movie = null;
            this._segment = null;
            this._startKeyframe = null;
            if (this._dispatcher)
            {
                this._dispatcher.removeEventListener(DispatcherEvent.Evt_Success, this.onDispatcherSuccess);
                this._dispatcher.removeEventListener(DispatcherEvent.Evt_Failed, this.onDispatcherFailed);
                this._dispatcher.stop();
                this._dispatcher = null;
            }
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
                this._timer.stop();
                this._timer = null;
            }
            Settings.instance.removeEventListener(Settings.Evt_MuteChanged, this.onVolumeChanged);
            Settings.instance.removeEventListener(Settings.Evt_VolumeChanged, this.onVolumeChanged);
            return;
        }// end function

        private function createStream() : void
        {
            this.destroyStream();
            this._cn = new NetConnection();
            this._cn.client = this;
            this._cn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onConnectionAasyncError);
            this._cn.connect(null);
            this._ns = new Decoder(this._cn);
            this._ns.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            this._ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onAsyncError);
            this._ns.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._ns.bufferTime = Config.STREAM_NORMAL_BUFFER_TIME / 1000;
            this.onVolumeChanged();
            return;
        }// end function

        private function destroyStream() : void
        {
            if (this._ns)
            {
                this._ns.removeEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
                this._ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onAsyncError);
                this._ns.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
                this._ns.destroy();
                this._ns = null;
            }
            if (this._cn)
            {
                this._cn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onConnectionAasyncError);
                this._cn.close();
                this._cn = null;
            }
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

        private function onConnectionAasyncError(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            if (!this._ns)
            {
                return;
            }
            if (this._bufferEmpty)
            {
                if (this._ns.bufferLength >= this._ns.bufferTime || this._ns.bytesLoaded > 2 << 20 && this._ns.time < 1)
                {
                    this.onBufferFull();
                }
            }
            if (!this._loadComplete && this._ns.bytesLoaded == this._ns.bytesTotal)
            {
                this._log.info("HttpStream(" + this._segment.index + ") load complete!");
                this._timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
                this._timer.stop();
                this._timer = null;
                this._loadComplete = true;
            }
            return;
        }// end function

        private function onNetStatus(event:NetStatusEvent) : void
        {
            this._log.debug(event.info.code);
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    this.onStart();
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    if (this._stopped)
                    {
                        return;
                    }
                    this.onBufferFull();
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (this._stopped)
                    {
                        return;
                    }
                    this._bufferEmpty = true;
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    this._seeking = false;
                    this.onSeekSuccess();
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    this._stopped = true;
                    this.dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Stop));
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    this.retry();
                    break;
                }
                case "NetStream.Play.FileStructureInvalid":
                {
                    this.retry();
                    break;
                }
                case "NetStream.Play.NoSupportedTrackFound":
                {
                    this.retry();
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    this.retry();
                    break;
                }
                case "NetStream.Seek.Failed":
                case "NetStream.Seek.InvalidTime":
                {
                    this.onSeekFailed(event.info);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onStart() : void
        {
            if (!this._ready)
            {
                this._ready = true;
                if (this._paused)
                {
                    this._ns.pause();
                }
                else
                {
                    this._ns.resume();
                }
                if (this._timer == null)
                {
                    this._timer = new Timer(100);
                    this._timer.addEventListener(TimerEvent.TIMER, this.onTimer);
                }
                this._timer.start();
                dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Connected));
            }
            return;
        }// end function

        private function onBufferFull() : void
        {
            this._bufferEmpty = false;
            this._seeking = false;
            return;
        }// end function

        private function onSeekSuccess() : void
        {
            this._retryCount = 0;
            this._bufferEmpty = this._ns.bufferLength < this._ns.bufferTime;
            return;
        }// end function

        private function onDispatcherSuccess(event:DispatcherEvent) : void
        {
            var _loc_2:* = event.data as String;
            this._ns.play(_loc_2);
            return;
        }// end function

        private function onDispatcherFailed(event:DispatcherEvent) : void
        {
            this._failed = true;
            dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
            return;
        }// end function

        private function onSeekFailed(param1:Object) : void
        {
            this._log.info("HttpStream failed to seek: " + param1.code + ", " + param1.details);
            var _loc_2:String = this;
            var _loc_3:* = this._retryCount + 1;
            _loc_2._retryCount = _loc_3;
            if (this._retryCount >= Config.STREAM_MAX_RETRY)
            {
                this._failed = true;
                dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
            }
            else
            {
                this._ns.seek(parseFloat(param1.details));
            }
            return;
        }// end function

        private function retry() : void
        {
            this._log.info("HttpStream(index: " + this._segment.index + ") failed, errno=" + this._holder.runtimeData.preErrorCode);
            if (this._retryCount >= Config.STREAM_MAX_RETRY)
            {
                this._failed = true;
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
                    this._movie.seek(this._ns.time * 1000 + this._segment.startTime);
                }
                this.reload();
            }
            return;
        }// end function

        private function onAsyncError(event:AsyncErrorEvent) : void
        {
            return;
        }// end function

        private function onIOError(event:IOErrorEvent) : void
        {
            this.retry();
            return;
        }// end function

        private function reload() : void
        {
            this._ready = false;
            this._bufferEmpty = true;
            this._loadComplete = false;
            this._failed = false;
            this._stopped = false;
            this._seeking = false;
            this._startKeyframe = this._segment.currentKeyframe;
            this.createStream();
            if (this._holder.runtimeData.cacheServerIP == "" || this._holder.runtimeData.cacheServerIP == null)
            {
                this._dispatcher.stop();
                this._dispatcher.start(this._segment);
            }
            else
            {
                this._ns.play(this._segment.url);
            }
            dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Retry));
            return;
        }// end function

    }
}
