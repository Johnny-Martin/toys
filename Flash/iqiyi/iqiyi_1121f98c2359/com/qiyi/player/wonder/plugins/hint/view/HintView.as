package com.qiyi.player.wonder.plugins.hint.view
{
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class HintView extends BasePanel
    {
        private var _log:ILogger;
        private var _video:Video;
        private var _stream:NetStream;
        private var _urlStream:URLStream;
        private var _hintUrl:String = "";
        private var _init:Boolean = false;
        private var _paused:Boolean = false;
        private var _bufferEmplty:Boolean = true;
        private var _stop:Boolean = false;
        private var _loadCompelte:Boolean = false;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.hint.view.HintView";

        public function HintView(param1:DisplayObjectContainer)
        {
            this._log = Log.getLogger(NAME);
            super(NAME, param1);
            return;
        }// end function

        private function init() : void
        {
            if (this._init)
            {
                return;
            }
            this._init = true;
            var _loc_1:* = new NetConnection();
            _loc_1.connect(null);
            _loc_1.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.onError);
            _loc_1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            this._stream = new NetStream(_loc_1);
            this._stream.client = {onMetaData:this.onMetaData()};
            this._stream.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            this._stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            this._stream.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
            this._stream.useHardwareDecoder = false;
            this._video = new Video();
            this._video.attachNetStream(this._stream);
            this.addChild(this._video);
            this._urlStream = new URLStream();
            this._urlStream.addEventListener(ProgressEvent.PROGRESS, this.onProgress);
            this._urlStream.addEventListener(Event.COMPLETE, this.onComplete);
            this._urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            this._urlStream.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
            return;
        }// end function

        private function onError(event:ErrorEvent) : void
        {
            this.sendstop();
            return;
        }// end function

        private function onMetaData() : void
        {
            return;
        }// end function

        protected function onNetStatus(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    dispatchEvent(new HintEvent(HintEvent.Evt_Status_Playing));
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (this._loadCompelte)
                    {
                        this.sendstop();
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    if (this._paused)
                    {
                        dispatchEvent(new HintEvent(HintEvent.Evt_Status_Paused));
                    }
                    else
                    {
                        dispatchEvent(new HintEvent(HintEvent.Evt_Status_Playing));
                    }
                    break;
                }
                case "NetStream.Play.Failed":
                case "NetStream.Play.FileStructureInvalid":
                case "NetStream.Play.NoSupportedTrackFound":
                case "NetStream.Play.StreamNotFound":
                case "NetStream.Seek.InvalidTime":
                {
                    this.sendstop();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function sendstop() : void
        {
            dispatchEvent(new HintEvent(HintEvent.Evt_Status_Stop));
            this._stop = true;
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            switch(param1)
            {
                case HintDef.STATUS_OPEN:
                {
                    this.open();
                    break;
                }
                case HintDef.STATUS_PLAYING:
                {
                    this.resume();
                    break;
                }
                case HintDef.STATUS_PAUSED:
                {
                    this.pause();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onRemoveStatus(param1:int) : void
        {
            switch(param1)
            {
                case HintDef.STATUS_OPEN:
                {
                    this.close();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onResize(param1:Rectangle) : void
        {
            if (this._video)
            {
                this._video.x = param1.x;
                this._video.y = param1.y;
                this._video.width = param1.width;
                this._video.height = param1.height;
            }
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                this.init();
                this.play();
                dispatchEvent(new HintEvent(HintEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                this._stream.close();
                this._urlStream.close();
                dispatchEvent(new HintEvent(HintEvent.Evt_Close));
            }
            return;
        }// end function

        private function onProgress(event:ProgressEvent) : void
        {
            var _loc_2:* = new ByteArray();
            if (this._urlStream.bytesAvailable > 0)
            {
                this._urlStream.readBytes(_loc_2);
                this._stream.appendBytes(_loc_2);
            }
            return;
        }// end function

        private function onComplete(event:Event) : void
        {
            this._loadCompelte = true;
            return;
        }// end function

        private function play() : void
        {
            if (this._hintUrl == "")
            {
                return;
            }
            this._stop = false;
            this._paused = false;
            this._bufferEmplty = true;
            this._stream.play(null);
            this._stream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
            this._loadCompelte = false;
            this._urlStream.load(new URLRequest(this._hintUrl));
            return;
        }// end function

        private function pause() : void
        {
            this._stream.pause();
            this._paused = true;
            return;
        }// end function

        private function resume() : void
        {
            this._stream.resume();
            this._paused = false;
            return;
        }// end function

        public function onVolumeChanged(param1:Boolean, param2:Number) : void
        {
            var _loc_3:SoundTransform = null;
            if (this._stream)
            {
                _loc_3 = new SoundTransform();
                _loc_3.volume = param1 ? (0) : (param2 / 100);
                this._stream.soundTransform = _loc_3;
            }
            return;
        }// end function

        public function set hintURL(param1:String) : void
        {
            this._hintUrl = param1;
            return;
        }// end function

    }
}
