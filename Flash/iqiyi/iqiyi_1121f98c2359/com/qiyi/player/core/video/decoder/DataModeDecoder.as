package com.qiyi.player.core.video.decoder
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.engine.dm.provider.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class DataModeDecoder extends Decoder
    {
        private var _startTime:int = 0;
        private var _allowGetTime:Boolean = true;
        private var _endOfFile:Boolean = false;
        private var _holder:ICorePlayer;
        private static const RESET_BEGIN:String = "resetBegin";
        private static const RESET_SEEK:String = "resetSeek";
        private static const END_SEQUENCE:String = "endSequence";

        public function DataModeDecoder(param1:ICorePlayer = null)
        {
            this._holder = param1;
            var _loc_2:* = new NetConnection();
            _loc_2.connect(null);
            super(_loc_2);
            Settings.instance.addEventListener(Settings.Evt_MuteChanged, this.onVolumeChanged);
            Settings.instance.addEventListener(Settings.Evt_VolumeChanged, this.onVolumeChanged);
            this.onVolumeChanged(null);
            return;
        }// end function

        override public function get time() : Number
        {
            if (this._allowGetTime)
            {
                return this._startTime + super.time * 1000;
            }
            return this._startTime;
        }// end function

        private function onVolumeChanged(event:Event) : void
        {
            var _loc_2:* = new SoundTransform();
            if (Settings.instance.mute || this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.PREVIEW)
            {
                _loc_2.volume = 0;
            }
            else
            {
                _loc_2.volume = Settings.instance.volumn / 100;
            }
            soundTransform = _loc_2;
            return;
        }// end function

        override public function play(... args) : void
        {
            super.play(null);
            this._allowGetTime = true;
            return;
        }// end function

        override public function destroy() : void
        {
            Settings.instance.removeEventListener(Settings.Evt_MuteChanged, this.onVolumeChanged);
            Settings.instance.removeEventListener(Settings.Evt_VolumeChanged, this.onVolumeChanged);
            super.destroy();
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            if (param1 < 100 || Math.ceil(param1) != param1)
            {
                return;
            }
            this._startTime = param1;
            this._endOfFile = false;
            this._allowGetTime = false;
            _log.info("decoder seek:" + param1);
            super.seek(param1);
            return;
        }// end function

        public function endSequence() : void
        {
            if (this._endOfFile)
            {
                return;
            }
            this._endOfFile = true;
            this.tryAppendBytesAction(END_SEQUENCE);
            _log.debug("appendByteAction:" + END_SEQUENCE);
            return;
        }// end function

        public function appendData(param1:MediaData) : void
        {
            if (param1 == null)
            {
                return;
            }
            this._endOfFile = false;
            if (param1.headers)
            {
                this.tryAppendBytesAction(RESET_BEGIN);
                _log.debug("appendByteAction:" + RESET_BEGIN);
                this.tryAppendBytes(param1.headers);
                _log.debug("append headers");
                this.tryAppendBytesAction(RESET_SEEK);
                _log.debug("appendByteAction:" + RESET_SEEK);
            }
            if (param1.bytes && param1.bytes.length)
            {
                this.tryAppendBytes(param1.bytes);
                _log.debug("append bytes: " + param1.bytes.length);
            }
            return;
        }// end function

        private function tryAppendBytesAction(param1:String) : void
        {
            var action:* = param1;
            if (this.hasOwnProperty("appendBytesAction"))
            {
                try
                {
                    var _loc_3:String = this;
                    _loc_3.this["appendBytesAction"](action);
                }
                catch (e:Error)
                {
                    _log.warn("appendBytesAction Error: " + action);
                }
            }
            return;
        }// end function

        private function tryAppendBytes(param1:ByteArray) : void
        {
            if (this.hasOwnProperty("appendBytes"))
            {
                var _loc_2:String = this;
                _loc_2.this["appendBytes"](param1);
            }
            return;
        }// end function

        override protected function setStatus(param1:EnumItem) : void
        {
            if (param1 == DecoderStatusEnum.PLAYING)
            {
                this._allowGetTime = true;
            }
            super.setStatus(param1);
            return;
        }// end function

        override public function stop() : void
        {
            this._allowGetTime = true;
            super.stop();
            return;
        }// end function

        override protected function onNetStatus(event:NetStatusEvent) : void
        {
            _log.debug(event.info.code);
            switch(event.info.code)
            {
                case "NetStream.Buffer.Empty":
                {
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    this.tryAppendBytesAction(RESET_SEEK);
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this._allowGetTime = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            super.onNetStatus(event);
            return;
        }// end function

    }
}
