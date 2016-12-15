package com.qiyi.player.core.video.decoder
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.events.*;
    import flash.events.*;
    import flash.net.*;

    public class Decoder extends NetStream implements IDecoder
    {
        private var _paused:Boolean = false;
        private var _bufferEmplty:Boolean = true;
        private var _metadata:Object;
        private var _status:EnumItem;
        protected var _log:ILogger;

        public function Decoder(param1:NetConnection, param2:String = "connectToFMS")
        {
            this._status = DecoderStatusEnum.STOPPED;
            this._log = Log.getLogger("com.qiyi.player.core.video.decoder.Decoder");
            super(param1, param2);
            client = new NetClient(this);
            addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus, false, int.MAX_VALUE);
            return;
        }// end function

        public function get status() : EnumItem
        {
            return this._status;
        }// end function

        public function get paused() : Boolean
        {
            return this._paused;
        }// end function

        public function get netstream() : NetStream
        {
            return this;
        }// end function

        public function get metadata() : Object
        {
            return this._metadata;
        }// end function

        public function destroy() : void
        {
            this.stop();
            removeEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            return;
        }// end function

        override public function play(... args) : void
        {
            if (this._status != DecoderStatusEnum.STOPPED)
            {
                return;
            }
            super.play.apply(null, args);
            this._paused = false;
            this._bufferEmplty = true;
            this.setStatus(DecoderStatusEnum.WAITING);
            return;
        }// end function

        override public function pause() : void
        {
            if (this._status == DecoderStatusEnum.STOPPED || this._paused)
            {
                return;
            }
            super.pause();
            this._paused = true;
            this.setStatus(DecoderStatusEnum.PAUSED);
            return;
        }// end function

        override public function resume() : void
        {
            if (this._status == DecoderStatusEnum.STOPPED || !this._paused)
            {
                return;
            }
            super.resume();
            this._paused = false;
            if (!this._bufferEmplty)
            {
                this.setStatus(DecoderStatusEnum.PLAYING);
            }
            else
            {
                this.setStatus(DecoderStatusEnum.WAITING);
            }
            return;
        }// end function

        override public function togglePause() : void
        {
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            if (this.status == DecoderStatusEnum.SEEKING || this.status == DecoderStatusEnum.STOPPED)
            {
                return;
            }
            this._bufferEmplty = true;
            this.setStatus(DecoderStatusEnum.SEEKING);
            super.seek(param1 / 1000);
            return;
        }// end function

        protected function onNetStatus(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetStream.Seek.Notify":
                {
                    if (super.bufferLength < super.bufferTime)
                    {
                        this._bufferEmplty = true;
                        this.setStatus(DecoderStatusEnum.WAITING);
                    }
                    else if (this._paused)
                    {
                        this.setStatus(DecoderStatusEnum.PAUSED);
                    }
                    else
                    {
                        this.setStatus(DecoderStatusEnum.PLAYING);
                    }
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (super.bufferLength < super.bufferTime)
                    {
                        this._bufferEmplty = true;
                        this.setStatus(DecoderStatusEnum.WAITING);
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    if (this._paused)
                    {
                        this.setStatus(DecoderStatusEnum.PAUSED);
                    }
                    else
                    {
                        this.setStatus(DecoderStatusEnum.PLAYING);
                    }
                    this._bufferEmplty = false;
                    break;
                }
                case "NetStream.Play.FileStructureInvalid":
                case "NetStream.Play.NoSupportedTrackFound":
                case "NetStream.Play.StreamNotFound":
                case "NetStream.Seek.InvalidTime":
                {
                    this.setStatus(DecoderStatusEnum.FAILED);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function setStatus(param1:EnumItem) : void
        {
            if (this._status == param1)
            {
                return;
            }
            this._log.info("decoder status changed: " + param1.name);
            this._status = param1;
            dispatchEvent(new DecoderEvent(DecoderEvent.Evt_StatusChanged));
            return;
        }// end function

        public function stop() : void
        {
            this._status = DecoderStatusEnum.STOPPED;
            super.close();
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            this._metadata = param1;
            dispatchEvent(new DecoderEvent(DecoderEvent.Evt_MetaData));
            return;
        }// end function

    }
}
