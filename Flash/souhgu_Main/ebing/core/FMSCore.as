package ebing.core
{
    import ebing.*;
    import ebing.events.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class FMSCore extends Sprite
    {
        protected var _width_num:Number;
        protected var _height_num:Number;
        protected var _metaWidth_num:Number = 0;
        protected var _metaHeight_num:Number = 0;
        protected var _buffer_num:Number;
        protected var _volume_num:Number;
        protected var _bg_spr:Sprite;
        protected var _video_arr:Array;
        protected var _my_nc:NetConnection;
        protected var _now_ns:NetStreamUtil;
        protected var _vTotTime_num:Number;
        protected var _stopFlag_boo:Boolean = false;
        protected var _currentIndex_uint:uint = 0;
        protected var _downloadIndex_uint:uint = 0;
        protected var _fileSize_num:Number = 0;
        protected var _nowLoadedSize_num:Number = 0;
        protected var _nowLoadedSize2_num:Number = 0;
        protected var _playedTime_num:Number = 0;
        protected var _nowTime_num:Number = 0;
        protected var _so:SharedObject;
        protected var _client_obj:Object;
        protected var _clientTem_obj:Object;
        protected var _played_boo:Boolean = false;
        protected var _finish_boo:Boolean = false;
        protected var _screenMode_str:String;
        protected var _tow:Boolean = true;
        protected var _timer:Timer;
        protected var _isGained:Boolean = false;
        protected var _startTime:Number = -1;
        protected var _optimize:uint = 6;
        protected var _isStart:Boolean = false;
        protected var _videoRate:Number;
        protected var _fileType:String;
        protected var _video_c:Sprite;
        protected var _soundTransform:SoundTransform;
        protected var _timeeee:Number = -1;
        protected var _isBufferFlush:Boolean = false;
        protected var _hardInitHandler:Function;
        protected var _seeking:Boolean;
        protected var _ttttt:Number = 0;
        protected var _sysInited:Boolean = false;
        protected var _rtmpeUrl:String;
        protected var _doNCClose:Boolean = false;
        protected var _preloadTime:uint = 30;
        private var K1026044EB31EC02A5E480B8724F16C2AF4A751373567K:Boolean = false;
        protected var _sysStatus_str:String = "5";

        public function FMSCore(param1:Object)
        {
            if (param1.doInit)
            {
                this.hardInit(param1);
            }
            return;
        }// end function

        public function hardInit(param1:Object) : void
        {
            this._buffer_num = param1.buffer;
            this._width_num = param1.width;
            this._height_num = param1.height;
            this._rtmpeUrl = param1.rtmpeUrl;
            this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K = param1.isWriteLog;
            this._hardInitHandler = param1.hardInitHandler;
            this.connectNC();
            return;
        }// end function

        protected function connectNC() : void
        {
            if (this._my_nc == null)
            {
                this._my_nc = new NetConnection();
                this._my_nc.client = this;
                this._my_nc.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
                this._my_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            }
            this._doNCClose = false;
            this._my_nc.connect(this._rtmpeUrl);
            return;
        }// end function

        public function onBWDone() : void
        {
            return;
        }// end function

        protected function netStatusHandler(event:NetStatusEvent) : void
        {
            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
            {
                LogManager.msg("FMS服务器连接状态：" + event.info.code);
            }
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    if (!this._sysInited)
                    {
                        this.sysInit("start");
                    }
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    this.dispatch(MediaEvent.NC_CONNECT_CLOSED);
                    break;
                }
                case "NetConnection.Connect.Failed":
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

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            trace("securityErrorHandler: " + event);
            return;
        }// end function

        protected function sysInit(param1:String = null) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
                this._sysInited = true;
                this._client_obj = new Object();
                this._clientTem_obj = new Object();
                this._client_obj.onMetaData = this.onMetaData;
                this._bg_spr = new Sprite();
                this._video_c = new Sprite();
                Utils.drawRect(this._bg_spr, 0, 0, this._width_num, this._height_num, 0, 1);
                addChild(this._bg_spr);
                this._screenMode_str = "normal";
                this.resize(this._width_num, this._height_num);
                this._hardInitHandler({info:"success"});
            }
            this._sysStatus_str = "5";
            this._played_boo = false;
            this._isStart = false;
            var _loc_2:int = 0;
            this._currentIndex_uint = 0;
            this._downloadIndex_uint = _loc_2;
            var _loc_2:int = 0;
            this._playedTime_num = 0;
            var _loc_2:* = _loc_2;
            this._nowLoadedSize_num = _loc_2;
            this._nowLoadedSize2_num = _loc_2;
            this._startTime = -1;
            return;
        }// end function

        public function initMedia(param1:Object) : void
        {
            var _loc_9:uint = 0;
            var _loc_2:* = param1.flv;
            var _loc_3:* = param1.time;
            var _loc_4:* = param1.size;
            this._isGained = false;
            this._vTotTime_num = 0;
            this._fileSize_num = 0;
            if (this._video_arr != null)
            {
                _loc_9 = 0;
                while (_loc_9 < this._video_arr.length)
                {
                    
                    this._video_arr[_loc_9].ns.removeEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
                    this._video_arr[_loc_9].ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
                    this._video_arr[_loc_9].ns.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
                    this._video_c.removeChild(this._video_arr[_loc_9].video);
                    _loc_9 = _loc_9 + 1;
                }
                this._video_arr.splice(0);
            }
            var _loc_5:* = _loc_2.split(",");
            var _loc_6:* = _loc_3.split(",");
            var _loc_7:* = _loc_4.split(",");
            this._video_arr = new Array();
            var _loc_8:uint = 0;
            while (_loc_8 < _loc_5.length)
            {
                
                this._video_arr[_loc_8] = {flv:_loc_5[_loc_8], video:new Video(), start:_loc_8 == 0 ? (0) : ((this._vTotTime_num + 1)), end:_loc_8 == 0 ? (_loc_6[_loc_8]) : (this._vTotTime_num + Number(_loc_6[_loc_8])), download:"no", ns:new NetStreamUtil(this._my_nc), time:Number(_loc_6[_loc_8]), size:Number(_loc_7[_loc_8]), iserr:false, datastart:0, dataend:0, duration:Number(_loc_6[_loc_8]), gotMetaData:false};
                this._vTotTime_num = this._vTotTime_num + Number(_loc_6[_loc_8]);
                this._fileSize_num = this._fileSize_num + Number(_loc_7[_loc_8]);
                this._video_arr[_loc_8].video.smoothing = true;
                this._video_arr[_loc_8].video.attachNetStream(this._video_arr[_loc_8].ns);
                this._video_arr[_loc_8].ns.bufferTime = this._buffer_num;
                this._video_arr[_loc_8].video.visible = false;
                this._video_arr[_loc_8].ns.client = this._clientTem_obj;
                this._video_arr[_loc_8].ns.clipNo = _loc_8;
                this._video_c.addChild(this._video_arr[_loc_8].video);
                _loc_8 = _loc_8 + 1;
            }
            addChild(this._video_c);
            this.resize(this._width_num, this._height_num);
            this._video_arr[0].ns.addEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
            this._video_arr[0].ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this._video_arr[0].ns.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._video_arr[0].ns.client = this._client_obj;
            this._now_ns = this._video_arr[0].ns;
            this._video_arr[0].video.visible = true;
            this.initVolume();
            this.sysInit();
            return;
        }// end function

        protected function getClipInfo(param1:uint) : String
        {
            return "clip:" + param1 + " start:" + this._video_arr[param1].start + " end:" + this._video_arr[param1].end + " time:" + this._video_arr[param1].time + " size:" + this._video_arr[param1].size + " duration:" + this._video_arr[param1].duration;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            var _loc_3:* = param1;
            this._bg_spr.width = param1;
            this._width_num = _loc_3;
            var _loc_3:* = param2;
            this._bg_spr.height = param2;
            this._height_num = _loc_3;
            if (this._video_arr != null)
            {
                if (this._metaWidth_num != 0)
                {
                    this._video_c.width = this._metaWidth_num;
                    this._video_c.height = this._metaHeight_num;
                }
                else
                {
                    this._video_c.width = this._width_num;
                    this._video_c.height = this._height_num;
                }
                Utils.prorata(this._video_c, this._bg_spr.width, this._bg_spr.height);
                Utils.setCenter(this._video_c, this._bg_spr);
            }
            return;
        }// end function

        protected function onMetaData(param1:Object) : void
        {
            var _loc_2:Number = NaN;
            if (!this._isGained)
            {
                this._isGained = true;
                this._metaWidth_num = param1.width;
                this._metaHeight_num = param1.height;
                if (param1.keyframes != null)
                {
                    this._fileType = "flv";
                }
                else if (param1.seekpoints != null)
                {
                    this._fileType = "mp4";
                }
                else
                {
                    this._fileType = "unknown";
                }
                this._fileType = "mp4";
                this.resize(this._width_num, this._height_num);
            }
            if (this._tow && !this._video_arr[this._downloadIndex_uint].ns.gotMetaData)
            {
                if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                {
                    LogManager.msg("第" + this._downloadIndex_uint + "段MetaData获取！obj.duration:" + param1.duration + " size:" + this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
                }
                this._video_arr[this._downloadIndex_uint].ns.gotMetaData = true;
                if (this._fileType == "mp4")
                {
                    this._video_arr[this._downloadIndex_uint].duration = param1.duration;
                    this._video_arr[this._downloadIndex_uint].datastart = this._video_arr[this._downloadIndex_uint].time - param1.duration;
                    this._playedTime_num = this._playedTime_num + this._video_arr[this._downloadIndex_uint].datastart;
                    this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[this._downloadIndex_uint].size - this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
                }
                else
                {
                    _loc_2 = this._video_arr[this._downloadIndex_uint].ns.time;
                    this._video_arr[this._downloadIndex_uint].duration = this._video_arr[this._downloadIndex_uint].time - _loc_2;
                    this._video_arr[this._downloadIndex_uint].datastart = _loc_2;
                    this._playedTime_num = this._playedTime_num + this._video_arr[this._downloadIndex_uint].datastart;
                    this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[this._downloadIndex_uint].size - this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
                    Utils.debug("------------++++++++++++++videoType:" + this._fileType + " nstime:" + this._video_arr[this._downloadIndex_uint].ns.time + " _nowLoadedSize_num:" + this._nowLoadedSize_num);
                }
            }
            this.dispatch(MediaEvent.DRAG_END);
            return;
        }// end function

        public function initVolume() : void
        {
            var _loc_2:String = null;
            var _loc_1:* = SharedObject.getLocal("so", "/");
            if (_loc_1.data.volume < 0 || String(_loc_1.data.volume) == "NaN" || _loc_1.data.volume == undefined)
            {
                _loc_1.data.volume = 0.8;
                try
                {
                    _loc_2 = _loc_1.flush();
                    if (_loc_2 == SharedObjectFlushStatus.PENDING)
                    {
                        _loc_1.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                    }
                    else if (_loc_2 == SharedObjectFlushStatus.FLUSHED)
                    {
                    }
                }
                catch (e:Error)
                {
                }
            }
            this.volume = _loc_1.data.volume;
            return;
        }// end function

        public function get volume() : Number
        {
            return this._volume_num;
        }// end function

        public function get curIndex() : uint
        {
            return this._currentIndex_uint;
        }// end function

        public function get videoArr() : Array
        {
            return this._video_arr;
        }// end function

        public function set volume(param1:Number) : void
        {
            this._soundTransform.volume = param1;
            var _loc_2:uint = 0;
            while (_loc_2 < this._video_arr.length)
            {
                
                this._video_arr[_loc_2].ns.soundTransform = this._soundTransform;
                _loc_2 = _loc_2 + 1;
            }
            this._volume_num = param1;
            return;
        }// end function

        public function get sTransform() : SoundTransform
        {
            Utils.debug("get sTransform:" + this._soundTransform);
            return this._soundTransform;
        }// end function

        public function set sTransform(param1:SoundTransform) : void
        {
            var _loc_2:uint = 0;
            Utils.debug("set sTransform:" + this._soundTransform);
            this._soundTransform = param1;
            if (this._video_arr != null)
            {
                _loc_2 = 0;
                while (_loc_2 < this._video_arr.length)
                {
                    
                    this._video_arr[_loc_2].ns.soundTransform = this._soundTransform;
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        public function saveVolume() : void
        {
            var _loc_1:String = null;
            this._so = SharedObject.getLocal("so", "/");
            this._so.data.volume = this._volume_num;
            try
            {
                _loc_1 = this._so.flush();
                if (_loc_1 == SharedObjectFlushStatus.PENDING)
                {
                    this._so.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                }
                else if (_loc_1 == SharedObjectFlushStatus.FLUSHED)
                {
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        protected function onStatusShare(event:NetStatusEvent) : void
        {
            if (event.info.code == "SharedObject.Flush.Success")
            {
            }
            else if (event.info.code == "SharedObject.Flush.Failed")
            {
            }
            return;
        }// end function

        protected function newFunc() : void
        {
            this._timer = new Timer(100, 0);
            this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            this._soundTransform = new SoundTransform();
            return;
        }// end function

        protected function getNSTime(param1:NetStreamUtil) : Number
        {
            return this._fileType == "mp4" ? (param1.time) : (param1.time - this._video_arr[this._currentIndex_uint].datastart);
        }// end function

        protected function timerHandler(event:TimerEvent) : void
        {
            this.aboutTime();
            if (Math.ceil(this.getNSTime(this._now_ns) * 10) >= Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) && this._video_arr[this._currentIndex_uint].duration != 0)
            {
                Utils.debug("timerHandler:" + this._stopFlag_boo + " _now_ns.time:" + this._now_ns.time + " duration:" + this._video_arr[this._currentIndex_uint].duration);
                if (this._stopFlag_boo)
                {
                    this.judgeStop();
                }
                else
                {
                    this._stopFlag_boo = true;
                }
            }
            event.updateAfterEvent();
            return;
        }// end function

        protected function aboutTime() : void
        {
            var _loc_1:Number = NaN;
            if (this._sysStatus_str != "4" && this._currentIndex_uint < this._video_arr.length)
            {
                _loc_1 = this.getNSTime(this._now_ns);
                this._nowTime_num = this._seeking ? (this._nowTime_num) : (_loc_1);
                Utils.debug("_now_ns.time:" + this._now_ns.time + " _nowTime_num:" + this._nowTime_num + " _seeking:" + this._seeking + " nstime:" + _loc_1 + " _fileType:" + this._fileType);
                this.dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:this._nowTime_num, totTime:this._vTotTime_num, isSeek:false});
            }
            return;
        }// end function

        protected function asyncErrorHandler(event:AsyncErrorEvent) : void
        {
            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
            {
                LogManager.msg("asyncErrorHandler:" + event);
            }
            return;
        }// end function

        protected function ioErrorHandler(event:IOErrorEvent) : void
        {
            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
            {
                LogManager.msg("ioErrorHandler:" + event);
            }
            return;
        }// end function

        protected function onStatus(event:NetStatusEvent) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            Utils.debug("onStatus:" + event);
            var _loc_2:* = this._video_arr[this._currentIndex_uint].ns;
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                    {
                        LogManager.msg("evt.info.code:" + event.info.code + " _isStart:" + this._isStart + " _currentIndex_uint:" + this._currentIndex_uint);
                    }
                    this._startTime = 0;
                    _loc_2.dragTime = 0;
                    if (!this._isStart)
                    {
                        this._isStart = true;
                        this._timer.start();
                        if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                        {
                            LogManager.msg("加载中...");
                        }
                        this.dispatch(MediaEvent.START);
                    }
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                    {
                        LogManager.msg("缓冲中(" + this._currentIndex_uint + ")...nstimeCeil:" + Math.ceil(this.getNSTime(this._now_ns) * 10) + " durationFloor:" + Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) + " getNSTime:" + this.getNSTime(this._now_ns) + " stopflag:" + this._stopFlag_boo + " " + this.getClipInfo(this._currentIndex_uint));
                    }
                    if (!this._isBufferFlush && _loc_2.bufferLength < _loc_2.bufferTime)
                    {
                        this.dispatch(MediaEvent.BUFFER_EMPTY);
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    this._isBufferFlush = false;
                    _loc_3 = 0;
                    while (_loc_3 < this._video_arr.length)
                    {
                        
                        this._video_arr[_loc_3].video.visible = false;
                        _loc_3 = _loc_3 + 1;
                    }
                    this._video_arr[this._currentIndex_uint].video.visible = true;
                    if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                    {
                        LogManager.msg("播放中(" + this._currentIndex_uint + ")...");
                    }
                    this.dispatch(MediaEvent.FULL);
                    this.dispatch(MediaEvent.DRAG_END);
                    this._seeking = false;
                    if (!this._played_boo)
                    {
                        this._played_boo = true;
                        this.dispatch(MediaEvent.PLAYED);
                    }
                    if (this._ttttt > 0)
                    {
                        this.seek(this._ttttt);
                        this.play();
                    }
                    break;
                }
                case "NetStream.Buffer.Flush":
                {
                    this._isBufferFlush = true;
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                    {
                        LogManager.msg("第" + this._currentIndex_uint + "段Stop事件触发了！nstimeCeil:" + Math.ceil(this.getNSTime(this._now_ns) * 10) + " durationFloor:" + Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) + " getNSTime:" + this.getNSTime(this._now_ns) + " stopflag:" + this._stopFlag_boo + " " + this.getClipInfo(this._currentIndex_uint));
                    }
                    if (this._stopFlag_boo)
                    {
                        this.judgeStop();
                    }
                    else
                    {
                        this._stopFlag_boo = true;
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                    {
                        LogManager.msg("视频不存在!");
                    }
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    _loc_4 = 0;
                    while (_loc_4 < this._video_arr.length)
                    {
                        
                        this._video_arr[_loc_4].video.visible = false;
                        _loc_4 = _loc_4 + 1;
                    }
                    this._video_arr[this._currentIndex_uint].video.visible = true;
                    if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                    {
                        LogManager.msg("NetStream.Seek.Notify");
                    }
                    break;
                }
                case "NetStream.Seek.InvalidTime":
                {
                    if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                    {
                        LogManager.msg("Seek.InvalidTime");
                    }
                    break;
                }
                case "NetStream.Seek.Failed":
                {
                    if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                    {
                        LogManager.msg("Seek.Failed");
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function changeNS(param1:uint, param2:uint) : void
        {
            this._video_arr[param1].ns.removeEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
            this._video_arr[param1].ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this._video_arr[param1].ns.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._video_arr[param1].ns.client = this._clientTem_obj;
            this._video_arr[param2].ns.addEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
            this._video_arr[param2].ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorHandler);
            this._video_arr[param2].ns.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._video_arr[param2].ns.client = this._client_obj;
            this._now_ns = this._video_arr[param2].ns;
            this._currentIndex_uint = param2;
            return;
        }// end function

        protected function judgeStop() : void
        {
            this._now_ns.pause();
            if (this._tow)
            {
                this._playedTime_num = this._playedTime_num + this._video_arr[this._currentIndex_uint].duration;
            }
            else
            {
                this._playedTime_num = this._playedTime_num + this._video_arr[this._currentIndex_uint].time;
            }
            if (this._currentIndex_uint < (this._video_arr.length - 1))
            {
                this._video_arr[this._currentIndex_uint].video.visible = false;
                this.changeNS(this._currentIndex_uint, (this._currentIndex_uint + 1));
                this._now_ns.seek(0);
                this._video_arr[this._currentIndex_uint].video.visible = true;
                if (this._video_arr[this._currentIndex_uint].iserr)
                {
                }
                else
                {
                    this._now_ns.resume();
                }
            }
            else
            {
                Utils.debug("结束");
                this._finish_boo = true;
                this.stop();
            }
            this._stopFlag_boo = false;
            return;
        }// end function

        public function play(param1 = null) : void
        {
            if (this._sysStatus_str == "5")
            {
                this._now_ns.play(this._video_arr[0].flv);
                this._video_arr[this._downloadIndex_uint].download = "loading";
                if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                {
                    LogManager.msg("开始播放:" + this._video_arr[0].flv);
                }
                this.dispatch(MediaEvent.CONNECTING);
            }
            if (this._sysStatus_str == "4")
            {
                if (this._video_arr[this._currentIndex_uint].download == "no")
                {
                    if (this._startTime > 0)
                    {
                        this._now_ns.play(this._video_arr[0].flv);
                        this._video_arr[this._downloadIndex_uint].download = "part_loading";
                        this._ttttt = this._startTime;
                    }
                    else
                    {
                        this._now_ns.play(this._video_arr[0].flv);
                        this._video_arr[this._downloadIndex_uint].download = "loading";
                    }
                    this.dispatch(MediaEvent.DRAG_START);
                    this.dispatch(MediaEvent.CONNECTING);
                }
                trace("_now_ns.resume();");
                this._now_ns.resume();
            }
            this._sysStatus_str = "3";
            this.dispatch(MediaEvent.PLAY);
            return;
        }// end function

        public function stop(param1 = null) : void
        {
            var _loc_2:uint = 0;
            if (this._sysStatus_str != "5")
            {
                _loc_2 = 0;
                while (_loc_2 < this._video_arr.length)
                {
                    
                    this._video_arr[_loc_2].ns.seek(0);
                    this._video_arr[_loc_2].ns.close();
                    Utils.debug("close() in stop");
                    _loc_2 = _loc_2 + 1;
                }
                this._sysStatus_str = "5";
                this._doNCClose = true;
                this._timer.stop();
                this.changeNS(this._currentIndex_uint, 0);
                if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                {
                    LogManager.msg("停止了_now_ns:" + this._now_ns);
                }
                Utils.debug("display stop");
                this._now_ns = this._video_arr[0].ns;
                this.sysInit();
                if (param1 != "noevent")
                {
                    if (this._finish_boo)
                    {
                        this.dispatch(MediaEvent.STOP, {finish:true});
                        this._finish_boo = false;
                    }
                    else
                    {
                        this.dispatch(MediaEvent.STOP, {finish:false});
                    }
                }
            }
            return;
        }// end function

        public function destroy() : void
        {
            this._now_ns.close();
            this.stop();
            this._my_nc.close();
            this._my_nc = null;
            Utils.debug("close() in destroy");
            return;
        }// end function

        public function sleep(param1 = null) : void
        {
            this.pause("0");
            return;
        }// end function

        public function pause(param1 = null) : void
        {
            this._now_ns.pause();
            this._sysStatus_str = "4";
            if (param1 != "0")
            {
                this.dispatch(MediaEvent.PAUSE, {isHard:param1 == null ? (false) : (true)});
            }
            return;
        }// end function

        private function initSectState(param1:uint) : void
        {
            var _loc_2:* = this._video_arr[param1];
            _loc_2.ns.close();
            Utils.debug("close() in initSectState");
            _loc_2.download = "no";
            _loc_2.datastart = 0;
            _loc_2.dataend = 0;
            Utils.debug("---------第" + param1 + "段清掉了!");
            return;
        }// end function

        private function initProHaveData(param1:uint) : void
        {
            var _loc_2:String = "1";
            this._playedTime_num = 0;
            this._nowLoadedSize_num = 0;
            var _loc_3:uint = 0;
            while (_loc_3 < this._video_arr.length)
            {
                
                if (param1 != _loc_3)
                {
                    this._video_arr[_loc_3].video.visible = false;
                }
                if (_loc_3 < param1)
                {
                    this._playedTime_num = this._playedTime_num + this._video_arr[_loc_3].time;
                    this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc_3].size;
                }
                else if (_loc_3 == param1)
                {
                    if (this._video_arr[_loc_3].download == "part_loaded" || this._video_arr[_loc_3].download == "loaded")
                    {
                        this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc_3].size;
                    }
                    else if (this._video_arr[_loc_3].download == "part_loading" || this._video_arr[_loc_3].download == "loading")
                    {
                        this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[_loc_3].size - this._video_arr[_loc_3].ns.bytesTotal);
                    }
                }
                else if (_loc_3 > param1)
                {
                    if (this._video_arr[_loc_3].download == "loaded")
                    {
                        if (_loc_2 == "1")
                        {
                            this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc_3].size;
                        }
                    }
                    else
                    {
                        _loc_2 = "0";
                        if (this._video_arr[_loc_3].download != "loading" || this._video_arr[(_loc_3 - 1)].download != "loaded")
                        {
                            this.initSectState(_loc_3);
                        }
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        private function K1026043DB3C4729D2C49DD8DF29CB1BC5D1968373567K(param1:uint) : void
        {
            this._playedTime_num = 0;
            this._nowLoadedSize_num = 0;
            var _loc_2:uint = 0;
            while (_loc_2 < this._video_arr.length)
            {
                
                if (this._video_arr[_loc_2].download != "loaded")
                {
                    this.initSectState(_loc_2);
                }
                if (_loc_2 < param1)
                {
                    this._playedTime_num = this._playedTime_num + this._video_arr[_loc_2].time;
                    this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc_2].size;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        protected function tow(param1:Number, param2:uint) : void
        {
            this.dispatch(MediaEvent.DRAG_START);
            Utils.debug("MediaEvent.DRAG_START:" + MediaEvent.DRAG_START);
            this.K1026043DB3C4729D2C49DD8DF29CB1BC5D1968373567K(param2);
            Utils.debug("_playedTime:" + this._playedTime_num + " _nowLoadedSize_num:" + this._nowLoadedSize_num);
            this.changeNS(this._currentIndex_uint, param2);
            var _loc_3:* = param2;
            this._downloadIndex_uint = param2;
            this._currentIndex_uint = _loc_3;
            Utils.debug("_startTime111111111111111:" + this._startTime);
            this._startTime = Math.abs(Math.round(param1));
            Utils.debug("_startTime222222222222222:" + this._startTime);
            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
            {
                LogManager.msg("--------========++++++++");
            }
            this._startTime = this._startTime <= this._optimize ? (0) : (this._startTime);
            Utils.debug("_startTime333333333333333:" + this._startTime);
            return;
        }// end function

        public function seek(param1:Number, param2 = null) : void
        {
            this._playedTime_num = 0;
            trace("sec:" + param1 + " _vTotTime_num:" + this._vTotTime_num);
            if (param1 >= 0 && param1 <= this._vTotTime_num && param2 != 0)
            {
                this._now_ns.pause();
                this._sysStatus_str = "4";
                this._seeking = true;
                this._nowTime_num = param1;
                this._startTime = param1;
                if (this._video_arr[this._currentIndex_uint].download != "no")
                {
                    trace("_now_ns.seek(sec)");
                    this._now_ns.seek(param1);
                    this._ttttt = 0;
                    this.dispatch(MediaEvent.DRAG_START);
                    this.dispatch(MediaEvent.CONNECTING);
                }
            }
            return;
        }// end function

        public function changeScreenMode(param1 = null) : void
        {
            stage.displayState = stage.displayState == StageDisplayState.FULL_SCREEN ? (StageDisplayState.NORMAL) : (StageDisplayState.FULL_SCREEN);
            return;
        }// end function

        public function playOrPause(param1 = null) : void
        {
            if (this._sysStatus_str == "4")
            {
                this.play();
            }
            else if (this._sysStatus_str == "3")
            {
                this.pause(param1);
            }
            return;
        }// end function

        public function get fileType() : String
        {
            return this._fileType;
        }// end function

        public function get videoContainer() : Sprite
        {
            return this._video_c;
        }// end function

        public function get metaWidth() : Number
        {
            return this._metaWidth_num;
        }// end function

        public function get metaHeight() : Number
        {
            return this._metaHeight_num;
        }// end function

        public function get ns() : NetStreamUtil
        {
            return this._now_ns;
        }// end function

        public function get streamState() : String
        {
            var _loc_1:String = null;
            switch(this._sysStatus_str)
            {
                case "5":
                {
                    _loc_1 = "stop";
                    break;
                }
                case "4":
                {
                    _loc_1 = "pause";
                    break;
                }
                case "3":
                {
                    _loc_1 = "play";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_1;
        }// end function

        public function get sTime() : Number
        {
            return Math.round(this._video_arr[this._currentIndex_uint].datastart + this.getNSTime(this._now_ns));
        }// end function

        public function get screenMode() : String
        {
            return this._screenMode_str;
        }// end function

        public function get filePlayedTime() : Number
        {
            return this._nowTime_num;
        }// end function

        public function get fileTotTime() : Number
        {
            return this._vTotTime_num;
        }// end function

        public function get fileLoadedSize() : Number
        {
            return this._nowLoadedSize2_num;
        }// end function

        public function get fileTotSize() : Number
        {
            return this._fileSize_num;
        }// end function

        public function set screenMode(param1:String) : void
        {
            this._screenMode_str = param1;
            return;
        }// end function

        public function get downloadIndex() : Number
        {
            return this._downloadIndex_uint;
        }// end function

        public function get vrate() : Number
        {
            if (this._videoRate == -1)
            {
                return Math.round(this._fileSize_num / this._vTotTime_num);
            }
            return this._videoRate;
        }// end function

        public function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new MediaEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

    }
}
