package com.sohu.tv.mediaplayer.netstream
{
    import com.sohu.tv.mediaplayer.video.*;
    import ebing.utils.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class Segment extends EventDispatcher
    {
        private var video:Video;
        private var con:NetConnection;
        private var stream:NetStream;
        private var url:String;
        private var fileByteRange:Array;
        private var fileTimeRage:Array;
        private var codecH:Array;
        private var seekStartByte:Number = 0;
        private var seekStartTime:Number = 0;
        private var is_activate:Boolean = false;
        private const PRE_LOAD_MODE:String = "PRE_LOAD_MODE";
        private const START_LOAD_AND_PLAY:String = "START_LOAD_AND_PLAY";
        private const PLAYING:String = "PLAYING";
        private const PAUSE:String = "PAUSE";
        private const STOP:String = "STOP";
        private var segment_status:String = "";
        private var is_use_segment_mode:Boolean = true;
        private var isSohu:Boolean = false;
        private var nowSeekTime:Number = 0;
        private var isJumpSeek:Boolean = false;
        private var clientObj:Object;
        protected var _nc:NetConnection;
        private var isOver:Boolean = false;

        public function Segment(param1:NetConnection, param2:Boolean = false, param3:Boolean = false)
        {
            this.fileByteRange = [0, 0];
            this.fileTimeRage = [0, 0];
            this.codecH = [0, 0];
            this.clientObj = new Object();
            this._nc = param1;
            param2 = param2;
            this.isSohu = param3;
            super(param1);
            return;
        }// end function

        public function init(param1:String) : void
        {
            var _url:* = param1;
            this.url = _url;
            this.nowSeekTime = 0;
            this.isJumpSeek = false;
            this.stream = new NetStream(this._nc);
            this.stream.bufferTime = 3;
            this.stream.checkPolicyFile = true;
            this.stream.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent) : void
            {
                sendStreamStatus(event.info.code);
                return;
            }// end function
            );
            return;
        }// end function

        public function setClient(param1:Object) : void
        {
            this.clientObj = param1;
            this.stream.client = this.clientObj;
            return;
        }// end function

        public function getClient() : Object
        {
            return this.clientObj;
        }// end function

        public function attachVideoToStream(param1:Video) : void
        {
            this.video = param1;
            if (TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE)
            {
                var _loc_2:* = this.video;
                _loc_2.this.video["attachSvdCurStream"](this.stream);
            }
            else
            {
                this.video.attachNetStream(this.stream);
            }
            return;
        }// end function

        public function setSeekInitData(param1:Array, param2:Array, param3:Array) : void
        {
            this.seekStartByte = param1[0];
            this.codecH = param3;
            this.fileByteRange = param1;
            this.fileTimeRage = param2;
            return;
        }// end function

        public function playToUrl(param1:Number = -1, param2:Number = -1) : void
        {
            var _loc_3:* = this.getParamUrl(param1, param2);
            this.stream.play(_loc_3);
            this.segment_status = this.START_LOAD_AND_PLAY;
            return;
        }// end function

        private function loadUrl(param1:Number = -1, param2:Number = -1) : void
        {
            this.stream.play(this.getParamUrl(param1, param2));
            LogManager.msg("尝试预加载时stream byte：" + this.stream.bytesTotal);
            this.segment_status = this.PRE_LOAD_MODE;
            return;
        }// end function

        public function preLoad() : void
        {
            if (this.segment_status != this.PRE_LOAD_MODE)
            {
                this.loadUrl(this.fileByteRange[0], this.fileByteRange[1]);
                LogManager.msg("预加载下一段视频" + this.fileByteRange[0] + " : : " + this.fileByteRange[1]);
            }
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            this.dispatchEvent(new MyVideoEvent("__onStreamMetaDataGet", param1));
            return;
        }// end function

        public function onLastSecond(param1 = null) : void
        {
            return;
        }// end function

        public function pause() : void
        {
            this.stream.pause();
            return;
        }// end function

        public function resume() : void
        {
            this.stream.resume();
            return;
        }// end function

        public function seekStartToEnd(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Boolean = true) : void
        {
            this.nowSeekTime = param1;
            var _loc_5:* = param2;
            var _loc_6:* = this.stream == null || isNaN(this.stream.bytesLoaded) ? (0) : (this.stream.bytesLoaded);
            this.seekStartTime = param1;
            this.stream.resume();
            if (_loc_5 >= this.seekStartByte && _loc_5 <= this.seekStartByte + _loc_6 - 5 * 1024)
            {
                LogManager.msg("内部SEEK-----------issohu:" + this.isSohu);
                this.isJumpSeek = false;
                this.stream.seek(param1);
            }
            else
            {
                this.isJumpSeek = true;
                if (this.isSohu)
                {
                    LogManager.msg("isSohu跳跃播放,根据时间-----------_newSeekStartTime : " + param1);
                    this.playToUrl(param1);
                }
                else
                {
                    LogManager.msg("跳跃播放结束SEEK-----------");
                    this.seekStartByte = _loc_5;
                    this.playToUrl(this.seekStartByte, param3);
                }
            }
            return;
        }// end function

        public function setVolume(param1:Number = 0) : void
        {
            var _loc_2:* = param1 < 0 ? (0) : (param1);
            var _loc_3:* = new SoundTransform(_loc_2);
            this.stream.soundTransform = _loc_3;
            return;
        }// end function

        public function get soundTransform() : SoundTransform
        {
            return this.stream.soundTransform;
        }// end function

        public function set soundTransform(param1:SoundTransform) : void
        {
            this.stream.soundTransform = param1;
            return;
        }// end function

        public function get checkPolicyFile() : Boolean
        {
            return this.stream.checkPolicyFile;
        }// end function

        public function get currentFPS() : Number
        {
            return this.stream.currentFPS;
        }// end function

        public function getVolume() : Number
        {
            return this.stream.soundTransform.volume;
        }// end function

        public function stop() : void
        {
            this.stream.close();
            return;
        }// end function

        public function close() : void
        {
            this.stream.close();
            return;
        }// end function

        private function sendStreamStatus(param1:String, param2:Object = null) : void
        {
            var _loc_3:uint = 0;
            LogManager.msg("状态：" + param1 + " : 时间：" + this.stream.time);
            if (String(param1) == "NetStream.Buffer.Full")
            {
                this.dispatchEvent(new Event("netstream_buffer_full"));
            }
            if (this.segment_status == this.PRE_LOAD_MODE)
            {
                this.pause();
                return;
            }
            switch(param1)
            {
                case "NetStream.Play.Start":
                {
                    LogManager.msg("---------下一段播放Start时间：" + this.stream.time);
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    LogManager.msg("--- empty");
                    this.dispatchEvent(new Event("netstream_buffer_empty"));
                    break;
                }
                case "NetStream.Buffer.Flush":
                {
                    LogManager.msg("--- flush");
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
                    LogManager.msg("本段停止时间：" + this.stream.time);
                    LogManager.msg("停止 本段stream 起始：" + this.fileByteRange[0]);
                    LogManager.msg("停止 本段 byte  大小：" + this.stream.bytesTotal);
                    _loc_3 = this.stream.bytesTotal + this.fileByteRange[0];
                    LogManager.msg("停止 本段stream 位置：" + this.stream.bytesTotal);
                    this.segment_status = this.STOP;
                    if (!this.isOver)
                    {
                        this.isOver = true;
                    }
                    else
                    {
                        return;
                    }
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
            if (this.is_activate)
            {
                this.dispatchEvent(new MyVideoEvent("__onStreamStatus", {code:param1, param:param2}));
            }
            return;
        }// end function

        private function getParamUrl(param1:Number = -1, param2:Number = -1) : String
        {
            var _loc_3:String = "";
            var _loc_4:String = "";
            if (this.isSohu)
            {
                if (this.url.indexOf("&start=") == -1)
                {
                    _loc_4 = "&start=" + param1;
                }
                if (this.url.indexOf("?") == -1)
                {
                    _loc_4 = "?" + _loc_4;
                }
                _loc_3 = this.url + _loc_4;
                LogManager.msg("isSohu:播放器地址:" + _loc_3);
                return _loc_3;
            }
            if (!this.is_use_segment_mode)
            {
                if (param1 > 0)
                {
                    _loc_4 = "start=" + param1 + "&";
                }
                else
                {
                    _loc_4 = "start=0&";
                }
                if (this.url.indexOf("?") == -1)
                {
                    _loc_4 = "?" + _loc_4;
                }
                else if (this.url.charAt((this.url.length - 1)) != "&")
                {
                    _loc_4 = "&" + _loc_4;
                }
                _loc_3 = this.url + _loc_4;
                return _loc_3;
            }
            _loc_4 = "m=s&";
            if (param1 != -1)
            {
                _loc_4 = _loc_4 + ("h=" + this.codecH[0] + "&h1=" + this.codecH[1] + "&start=" + param1 + "&");
            }
            if (param2 != -1)
            {
                _loc_4 = _loc_4 + ("end=" + param2);
            }
            if (this.url.indexOf("?") == -1)
            {
                _loc_4 = "?" + _loc_4;
            }
            else if (this.url.charAt((this.url.length - 1)) != "&")
            {
                _loc_4 = "&" + _loc_4;
            }
            _loc_3 = this.url + _loc_4;
            LogManager.msg("分段请求播放地址：" + _loc_3);
            return _loc_3;
        }// end function

        public function getStream() : NetStream
        {
            return this.stream;
        }// end function

        public function getActivate() : Boolean
        {
            return this.is_activate;
        }// end function

        public function setActivate(param1:Boolean = true, param2 = null) : void
        {
            if (param1)
            {
                this.segment_status = "";
                LogManager.msg("setActivate : stream :" + this.stream + " : isOk :" + param2);
                if (this.stream != null)
                {
                    if (param2 != null && param2)
                    {
                        this.resume();
                        LogManager.msg("boo :" + param1 + " isOk :" + param2 + " : resume()");
                    }
                    else
                    {
                        this.pause();
                        LogManager.msg("boo :" + param1 + " pause()");
                    }
                }
            }
            else if (this.stream.bytesTotal > 0 && this.stream.bytesLoaded != this.stream.bytesTotal)
            {
                this.stream.close();
                this.segment_status = "";
            }
            else
            {
                this.pause();
            }
            this.is_activate = param1;
            return;
        }// end function

        public function getSeekStartByte() : Number
        {
            return this.seekStartByte;
        }// end function

        public function getSeekStartTime() : Number
        {
            return this.seekStartTime;
        }// end function

        public function getFileByteRange() : Array
        {
            return this.fileByteRange;
        }// end function

        public function getFileTimeRange() : Array
        {
            return this.fileTimeRage;
        }// end function

        public function getBytesLoaded() : uint
        {
            return this.stream.bytesLoaded;
        }// end function

        public function getTotalBytes() : uint
        {
            return this.stream.bytesTotal;
        }// end function

        public function getBufferLength() : Number
        {
            return this.stream.bufferLength;
        }// end function

        public function getBufferTime() : Number
        {
            return this.stream.bufferTime;
        }// end function

        public function set bufferTime(param1:Number) : void
        {
            this.stream.bufferTime = param1;
            return;
        }// end function

        public function getPlayHeadTime() : Number
        {
            if (this.stream != null && this.stream.time > 0)
            {
                if (Number(this.stream.time) >= Number(this.fileTimeRage[1]))
                {
                    if (!this.isOver)
                    {
                        this.stream.pause();
                        this.sendStreamStatus("NetStream.Play.Stop");
                    }
                }
                else
                {
                    this.isOver = false;
                }
                if (this.url.indexOf(".mp4") != -1 && this.isJumpSeek)
                {
                    return this.stream.time + this.nowSeekTime;
                }
                return this.stream.time;
            }
            return 0;
        }// end function

        public function getBufferPercent() : Number
        {
            var _loc_1:* = this.stream.bufferLength / this.stream.bufferTime;
            _loc_1 = _loc_1 > 1 ? (1) : (_loc_1);
            return _loc_1;
        }// end function

        public function onPlayStatus(param1 = null) : void
        {
            return;
        }// end function

        public function gc() : void
        {
            try
            {
                if (this.stream != null)
                {
                    this.stream.close();
                }
            }
            catch (evt)
            {
            }
            this.stream = null;
            try
            {
                if (this.con != null)
                {
                    this.con.close();
                }
            }
            catch (evt)
            {
            }
            this.con = null;
            this.video = null;
            return;
        }// end function

    }
}
