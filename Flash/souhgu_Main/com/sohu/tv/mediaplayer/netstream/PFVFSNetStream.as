package com.sohu.tv.mediaplayer.netstream
{
    import com.adobe.crypto.*;
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.video.*;
    import com.ws.event.*;
    import com.ws.video.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class PFVFSNetStream extends TvSohuNetStream
    {
        protected var _nc:NetConnection;
        private var stream:Object;
        private const PRE_LOAD_MODE:String = "PRE_LOAD_MODE";
        private const START_LOAD_AND_PLAY:String = "START_LOAD_AND_PLAY";
        private const PLAYING:String = "PLAYING";
        private const PAUSE:String = "PAUSE";
        private const STOP:String = "STOP";
        private var segment_status:String = "";
        private var duration:Number = 0;
        private var isOver:Boolean = false;
        private var metaData:Object;
        private var _video:Video = null;
        private var bitRate:Number = 0;
        private var fileSize:Number = 0;
        private var clientObj:Object;
        private var seekTime:Number = 0;
        private var errorType:String = "";
        private var checkMetadataTime:Timer;
        private var isMetaDataGet:Boolean = false;
        private static var url:String = "";
        private static var domain:String = "56.com";
        private static var videoId:String = "";

        public function PFVFSNetStream(param1:NetConnection, param2:Boolean = false, param3:Boolean = false)
        {
            this.clientObj = new Object();
            this._nc = param1;
            this.stream = new NetStream(this._nc);
            super(param1, param2, param3);
            return;
        }// end function

        public function init(param1:String, param2:Boolean = true, param3:Number = 40) : void
        {
            url = param1;
            this.isMetaDataGet = false;
            return;
        }// end function

        override public function play(... args) : void
        {
            args = new activation;
            var p:URLVariables;
            var arguments:* = args;
            _isPlay = true;
            _gslbUrl = [0];
            try
            {
                p = new URLVariables(_gslbUrl.split("?")[1]);
                _dragTime = start != undefined ? (Number(start)) : (_dragTime);
            }
            catch (evt:Error)
            {
                _dragTime = 0;
            }
            this.doPlay(_gslbUrl);
            return;
        }// end function

        override protected function doPlay(param1:String) : void
        {
            param1 = _url;
            this.playToUrl();
            this.checkMetadataTime = new Timer(10000, 1);
            this.checkMetadataTime.addEventListener(TimerEvent.TIMER, this.onCheckTimerGet);
            this.checkMetadataTime.start();
            return;
        }// end function

        public function playToUrl() : void
        {
            var _loc_1:* = url;
            this.stream.play(videoId, _loc_1);
            this.segment_status = this.START_LOAD_AND_PLAY;
            return;
        }// end function

        public function attachVideoToStream(param1:Video) : void
        {
            this._video = param1;
            if (TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE)
            {
                var _loc_2:* = this._video;
                _loc_2.this._video["attachSvdCurStream"](this.stream);
            }
            else
            {
                this._video.attachNetStream(this.stream);
            }
            return;
        }// end function

        private function loadUrl() : void
        {
            this.stream.play(url);
            this.segment_status = this.PRE_LOAD_MODE;
            return;
        }// end function

        private function onPFVHandler(event:PFVEvent = null) : void
        {
            switch(event.info.code)
            {
                case "PFVNetStream.Internal.Error":
                {
                    this.gc();
                    this.errorType = "2";
                    this.dispatchEvent(new Event("PFVNetStreamError"));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function stop() : void
        {
            this.stream.close();
            return;
        }// end function

        public function getPlayHeadTime() : Number
        {
            if (this.stream != null && this.stream.time >= 0)
            {
                return this.stream.time;
            }
            return 0;
        }// end function

        public function getBufferFull() : Boolean
        {
            if (this.stream.bufferLength > 4)
            {
                return true;
            }
            return false;
        }// end function

        public function getProgressPercent() : Number
        {
            var _loc_1:* = (this.stream.bufferLength + this.stream.time) / this.duration;
            _loc_1 = _loc_1 > 1 ? (1) : (_loc_1);
            return _loc_1;
        }// end function

        public function getBufferPercent() : Number
        {
            var _loc_1:* = this.stream.bufferLength / this.stream.bufferTime;
            _loc_1 = _loc_1 > 1 ? (1) : (_loc_1);
            return _loc_1;
        }// end function

        private function __onStreamStatus(event:NetStatusEvent) : void
        {
            var _loc_2:* = event.info.code;
            if (_loc_2 == "NetStream.Buffer.Full")
            {
                this.dispatchEvent(new Event("netstream_buffer_full"));
            }
            if (this.segment_status == this.PRE_LOAD_MODE)
            {
                this.pause();
                return;
            }
            switch(_loc_2)
            {
                case "NetStream.Play.Start":
                {
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    this.dispatchEvent(new Event("netstream_buffer_empty"));
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    this.dispatchEvent(new Event("netstream_buffer_empty"));
                    break;
                }
                case "NetStream.Buffer.Flush":
                {
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this.segment_status = this.PLAYING;
                    break;
                }
                case "NetStream.Seek.Failed":
                {
                    break;
                }
                case "NetStream.Seek.InvalidTime":
                {
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    this.segment_status = this.STOP;
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get PFVErrorType() : String
        {
            return this.errorType;
        }// end function

        public function onMetaDataGet(param1:Object) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:Object = null;
            for (_loc_2 in param1)
            {
                
            }
            this.metaData = param1;
            _loc_3 = this.metaData;
            this.isMetaDataGet = true;
            this.checkMetadataTime.stop();
            this.checkMetadataTime.removeEventListener(TimerEvent.TIMER, this.onCheckTimerGet);
            this.duration = _loc_3.duration;
            this.bitRate = _loc_3.videodatarate;
            this.fileSize = _loc_3.filesize;
            if (this.duration != 0 && this.seekTime != 0)
            {
                this.seek(this.seekTime);
                this.seekTime = 0;
            }
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            if (this.metaData == null)
            {
                this.seekTime = param1;
                return;
            }
            var _loc_2:* = param1;
            _loc_2 = _loc_2 < 0 ? (0) : (_loc_2);
            _loc_2 = _loc_2 > this.duration - 3 ? (this.duration - 3) : (_loc_2);
            if (PFVNetStream.ServiceAvailable)
            {
                this.stream.seek(_loc_2);
                if (_isPlay)
                {
                    this.stream.resume();
                }
                else
                {
                    this.stream.pause();
                }
            }
            else
            {
                this.gc();
                this.errorType = "3";
                this.dispatchEvent(new Event("PFVNetStreamError"));
            }
            return;
        }// end function

        override public function get bufferLength() : Number
        {
            if (this.stream != null)
            {
                return this.stream.bufferLength;
            }
            return 0;
        }// end function

        override public function get bufferTime() : Number
        {
            if (this.stream != null)
            {
                return this.stream.bufferTime;
            }
            return 0;
        }// end function

        override public function set bufferTime(param1:Number) : void
        {
            this.stream.bufferTime = param1;
            return;
        }// end function

        override public function get bytesLoaded() : uint
        {
            if (this.stream != null)
            {
                return this.stream.bytesLoaded;
            }
            return 0;
        }// end function

        override public function get bytesTotal() : uint
        {
            if (this.stream != null)
            {
                return this.stream.bytesTotal;
            }
            return 0;
        }// end function

        override public function get client() : Object
        {
            return this.stream.client;
        }// end function

        override public function set client(param1:Object) : void
        {
            this.clientObj = param1;
            if (PFVNetStream.ServiceAvailable)
            {
                this.stream = new PFVNetStream(this._nc);
                this.stream.bufferTime = 3;
                this.stream.client = this.clientObj;
                this.stream.addEventListener(NetStatusEvent.NET_STATUS, this.__onStreamStatus);
                this.stream.addEventListener(PFVEvent.SVC_STATUS, this.onPFVHandler);
                if (this._video != null)
                {
                    this.stream.attachVideo(this._video);
                }
            }
            return;
        }// end function

        private function onCheckTimerGet(event:TimerEvent) : void
        {
            this.checkMetadataTime.stop();
            this.checkMetadataTime.removeEventListener(TimerEvent.TIMER, this.onCheckTimerGet);
            if (this.isOver)
            {
                return;
            }
            if (!this.isMetaDataGet)
            {
                this.gc();
                this.errorType = "0";
                this.dispatchEvent(new Event("PFVNetStreamError"));
            }
            return;
        }// end function

        override public function get time() : Number
        {
            return this.getPlayHeadTime();
        }// end function

        override public function get checkPolicyFile() : Boolean
        {
            return this.stream.checkPolicyFile;
        }// end function

        override public function get currentFPS() : Number
        {
            return this.stream.currentFPS;
        }// end function

        override public function close() : void
        {
            _isPlay = false;
            if (this.stream != null)
            {
                this.stream.close();
            }
            return;
        }// end function

        override public function pause() : void
        {
            _isPlay = false;
            if (this.stream != null)
            {
                this.stream.pause();
            }
            return;
        }// end function

        override public function resume() : void
        {
            _isPlay = true;
            if (this.stream != null)
            {
                this.stream.resume();
            }
            return;
        }// end function

        override public function get soundTransform() : SoundTransform
        {
            return this.stream.soundTransform;
        }// end function

        override public function set soundTransform(param1:SoundTransform) : void
        {
            this.stream.soundTransform = param1;
            return;
        }// end function

        public function getStream()
        {
            if (this.stream != null)
            {
                return this.stream;
            }
            return null;
        }// end function

        public function gc() : void
        {
            this.isOver = true;
            try
            {
                if (this.stream != null)
                {
                    this.stream.removeEventListener(NetStatusEvent.NET_STATUS, this.__onStreamStatus);
                    this.stream.removeEventListener(PFVEvent.SVC_STATUS, this.onPFVHandler);
                    this.stream.close();
                }
            }
            catch (e:Event)
            {
            }
            this.stream = null;
            try
            {
                if (this._nc != null)
                {
                    this._nc.close();
                }
            }
            catch (e:Event)
            {
            }
            if (this.checkMetadataTime)
            {
                this.checkMetadataTime.stop();
                this.checkMetadataTime.removeEventListener(TimerEvent.TIMER, this.onCheckTimerGet);
            }
            return;
        }// end function

        public static function initService(param1:Function) : void
        {
            var _loc_2:* = getToken();
            videoId = getVid(PlayerConfig.currentPlayUrl);
            PFVNetStream.Load(param1, domain, _loc_2, videoId);
            return;
        }// end function

        private static function getToken() : String
        {
            var _loc_1:String = "56pfv@998#@!";
            var _loc_2:* = int(new Date().getTime() / 1000);
            var _loc_3:* = MD5.hash(domain + _loc_2 + _loc_1);
            var _loc_4:* = _loc_3 + _loc_2;
            return _loc_3 + _loc_2;
        }// end function

        private static function getVid(param1:String) : String
        {
            var _loc_2:* = String(param1.split(".com")[(param1.split(".com").length - 1)]).split("?")[0];
            return _loc_2;
        }// end function

        public static function get available() : Boolean
        {
            return PFVNetStream.ServiceAvailable;
        }// end function

    }
}
