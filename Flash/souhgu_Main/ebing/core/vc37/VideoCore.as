package ebing.core.vc37
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

    public class VideoCore extends Sprite
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
        protected var _audioRate:Number;
        protected var _fileType:String;
        protected var _video_c:Sprite;
        protected var _soundTransform:SoundTransform;
        protected var _timeeee:Number = -1;
        protected var _lastoutBuffer:Boolean = false;
        protected var _isBufferFlush:Boolean = false;
        protected var _preloadTime:uint = 30;
        private var K1026044EB31EC02A5E480B8724F16C2AF4A751373567K:Boolean = false;
        protected var _sysStatus_str:String = "5";
        public static const AUTHOR:String = "闪族e冰-QQ:16521603";

        public function VideoCore(param1:Object)
        {
            if (param1.doInit)
            {
                this.init(param1);
            }
            return;
        }// end function

        public function init(param1:Object) : void
        {
            this._buffer_num = param1.buffer;
            this._width_num = param1.width;
            this._height_num = param1.height;
            this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K = param1.isWriteLog;
            this.sysInit("start");
            this.newFunc();
            return;
        }// end function

        protected function sysInit(param1:String = null) : void
        {
            if (param1 == "start")
            {
                this._my_nc = new NetConnection();
                this._my_nc.connect(null);
                this._client_obj = new Object();
                this._clientTem_obj = new Object();
                this._client_obj.onMetaData = this.onMetaData;
                this._clientTem_obj.onMetaData = this.onMetaDataTem;
                this._bg_spr = new Sprite();
                this._video_c = new Sprite();
                Utils.drawRect(this._bg_spr, 0, 0, this._width_num, this._height_num, 0, 1);
                addChild(this._bg_spr);
                this._screenMode_str = "normal";
                this.resize(this._width_num, this._height_num);
            }
            this._sysStatus_str = "5";
            this._played_boo = false;
            var _loc_2:int = -1;
            this._videoRate = -1;
            this._audioRate = _loc_2;
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
                
                this._video_arr[_loc_8] = {flv:_loc_5[_loc_8], video:new Video(), start:_loc_8 == 0 ? (0) : ((this._vTotTime_num + 1)), end:_loc_8 == 0 ? (_loc_6[_loc_8]) : (this._vTotTime_num + Number(_loc_6[_loc_8])), download:"no", ns:new NetStreamUtil(this._my_nc), time:Number(_loc_6[_loc_8]), size:Number(_loc_7[_loc_8]), iserr:false, datastart:0, dataend:0, duration:Number(_loc_6[_loc_8]), gotMetaData:false, bytesTotal:0, isAbend:false, metadata:new Object()};
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

        protected function onMetaDataTem(param1:Object) : void
        {
            Utils.debug("onMetaDataTem");
            return;
        }// end function

        protected function onMetaData(param1:Object) : void
        {
            var _loc_2:Number = NaN;
            if (!this._isGained)
            {
                this._isGained = true;
                if (this._video_arr.length == 1 && !this._video_arr[0].ns.isDrag)
                {
                    this._vTotTime_num = param1.duration;
                    var _loc_3:* = this._video_arr[0].ns.bytesTotal;
                    this._video_arr[0].size = this._video_arr[0].ns.bytesTotal;
                    this._fileSize_num = _loc_3;
                    var _loc_3:* = param1.duration;
                    this._video_arr[0].time = param1.duration;
                    this._video_arr[0].end = _loc_3;
                }
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
                this.resize(this._width_num, this._height_num);
            }
            if (this._tow && !this._video_arr[this._downloadIndex_uint].ns.gotMetaData)
            {
                if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                {
                    LogManager.msg("第" + this._downloadIndex_uint + "段MetaData获取！obj.duration:" + param1.duration + " size:" + this._video_arr[this._downloadIndex_uint].ns.bytesTotal + " nstime:" + this._video_arr[this._downloadIndex_uint].ns.time);
                }
                if (this._fileType == "mp4")
                {
                    this._video_arr[this._downloadIndex_uint].bytesTotal = this._video_arr[this._downloadIndex_uint].ns.bytesTotal;
                    this._video_arr[this._downloadIndex_uint].duration = param1.duration;
                    this._video_arr[this._downloadIndex_uint].datastart = this._video_arr[this._downloadIndex_uint].time - param1.duration;
                    this._playedTime_num = this._playedTime_num + this._video_arr[this._downloadIndex_uint].datastart;
                    this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[this._downloadIndex_uint].size - this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
                }
                else
                {
                    this._video_arr[this._downloadIndex_uint].bytesTotal = this._video_arr[this._downloadIndex_uint].ns.bytesTotal;
                    _loc_2 = this._video_arr[this._downloadIndex_uint].ns.time;
                    this._video_arr[this._downloadIndex_uint].duration = this._video_arr[this._downloadIndex_uint].time - _loc_2;
                    this._video_arr[this._downloadIndex_uint].datastart = _loc_2;
                    this._playedTime_num = this._playedTime_num + this._video_arr[this._downloadIndex_uint].datastart;
                    this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[this._downloadIndex_uint].size - this._video_arr[this._downloadIndex_uint].ns.bytesTotal);
                    Utils.debug("------------++++++++++++++videoType:" + this._fileType + " nstime:" + this._video_arr[this._downloadIndex_uint].ns.time + " _nowLoadedSize_num:" + this._nowLoadedSize_num);
                }
                this._video_arr[this._downloadIndex_uint].ns.gotMetaData = true;
            }
            this.dispatch(MediaEvent.DRAG_END);
            this._video_arr[this._downloadIndex_uint].metadata = param1;
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

        public function get downloadIndex() : uint
        {
            return this._downloadIndex_uint;
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
                    if (!this._so.hasEventListener(NetStatusEvent.NET_STATUS))
                    {
                        this._so.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                    }
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
            this.aboutDownload();
            if (this.getNSTime(this._now_ns) >= 1 && !this._played_boo && this._sysStatus_str == "3")
            {
                this._played_boo = true;
                this.dispatch(MediaEvent.PLAYED);
            }
            if (Math.ceil(this.getNSTime(this._now_ns) * 10) >= Math.floor(this._video_arr[this._currentIndex_uint].duration * 10) && this._video_arr[this._currentIndex_uint].duration != 0)
            {
                Utils.debug("timerHandler:" + this._stopFlag_boo + " _now_ns.time:" + this._now_ns.time + " duration:" + this._video_arr[this._currentIndex_uint].duration);
                if (this._currentIndex_uint != this._downloadIndex_uint || this._video_arr[this._downloadIndex_uint].ns.gotMetaData)
                {
                    if (this._stopFlag_boo)
                    {
                        this.judgeStop();
                    }
                    else
                    {
                        this._stopFlag_boo = true;
                    }
                }
            }
            event.updateAfterEvent();
            return;
        }// end function

        protected function download(param1:uint, param2 = null) : void
        {
            var _loc_3:uint = 0;
            while (_loc_3 < this._video_arr.length)
            {
                
                this._video_arr[_loc_3].ns.client = this._clientTem_obj;
                _loc_3 = _loc_3 + 1;
            }
            this._video_arr[param1].ns.client = this._client_obj;
            var _loc_4:* = param2 == null ? (this._video_arr[param1].flv) : (this._video_arr[param1].flv + "?start=" + param2);
            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
            {
                LogManager.msg("预加载视频执行了(" + param1 + ")url:" + _loc_4);
            }
            this._downloadIndex_uint = param1;
            if (param2 == null || param2 == 0)
            {
                this._video_arr[param1].download = "loading";
            }
            else
            {
                this._video_arr[param1].download = "part_loading";
            }
            this._video_arr[param1].ns.play(_loc_4);
            this._video_arr[param1].ns.pause();
            return;
        }// end function

        protected function aboutTime() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (this._sysStatus_str != "4" && this._currentIndex_uint < this._video_arr.length)
            {
                _loc_1 = !this._tow ? (Math.floor(this._video_arr[this._currentIndex_uint].time - this.getNSTime(this._now_ns))) : (Math.floor(this._video_arr[this._currentIndex_uint].time - (this._video_arr[this._currentIndex_uint].datastart + this.getNSTime(this._now_ns))));
                if (_loc_1 <= this._preloadTime && (this._video_arr[this._currentIndex_uint].download == "loaded" || this._video_arr[this._currentIndex_uint].download == "part_loaded") && this._currentIndex_uint < (this._video_arr.length - 1))
                {
                    if (this._video_arr[(this._currentIndex_uint + 1)].download == "no")
                    {
                        this.download((this._currentIndex_uint + 1));
                    }
                }
                _loc_2 = this.getNSTime(this._now_ns);
                this._nowTime_num = _loc_2 + this._playedTime_num;
                if (this._timeeee != -1)
                {
                    if (this._video_arr[this._currentIndex_uint].ns.time != 0)
                    {
                        Utils.debug("second seek " + this._video_arr[this._currentIndex_uint].ns.time);
                        this._now_ns.seek(this._timeeee);
                        this._timeeee = -1;
                    }
                }
                else if (_loc_2 != 0)
                {
                    _loc_3 = this._nowTime_num < 0 ? (0) : (this._nowTime_num);
                    this.dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:_loc_3, totTime:this._vTotTime_num, isSeek:false});
                }
            }
            return;
        }// end function

        protected function aboutDownload() : void
        {
            var by_num:Number;
            var tot_num:Number;
            var metaByTot_num:Number;
            var loaded:Number;
            var download:String;
            var index:uint;
            var i:uint;
            if (this._video_arr[this._downloadIndex_uint].download != "abend" && (this._video_arr[this._downloadIndex_uint].download == "loading" || this._video_arr[this._downloadIndex_uint].download == "part_loading"))
            {
                by_num = this._video_arr[this._downloadIndex_uint].ns.bytesLoaded;
                tot_num = this._video_arr[this._downloadIndex_uint].ns.bytesTotal;
                metaByTot_num = this._video_arr[this._downloadIndex_uint].bytesTotal;
                var _loc_2:* = this._nowLoadedSize_num + by_num;
                this._nowLoadedSize2_num = this._nowLoadedSize_num + by_num;
                loaded = _loc_2;
                if (this._tow)
                {
                    this._video_arr[this._downloadIndex_uint].dataend = this._video_arr[this._downloadIndex_uint].datastart + this._video_arr[this._downloadIndex_uint].duration * by_num / tot_num;
                }
                if (by_num >= tot_num && tot_num > 0)
                {
                    if (tot_num == metaByTot_num)
                    {
                        download;
                        if (this._video_arr[this._downloadIndex_uint].ns.isDrag)
                        {
                            download;
                        }
                        this._video_arr[this._downloadIndex_uint].download = download;
                        this._nowLoadedSize_num = this._nowLoadedSize_num + tot_num;
                        try
                        {
                            Utils.debug("_downloadIndex_uint:" + this._downloadIndex_uint + "_video_arr[_downloadIndex_uint].download:" + this._video_arr[this._downloadIndex_uint].download);
                            index = (this._downloadIndex_uint + 1);
                            i = index;
                            while (i < this._video_arr.length)
                            {
                                
                                if (this._video_arr[i].download == "loaded")
                                {
                                    this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[i].size;
                                    this._downloadIndex_uint = i;
                                }
                                else
                                {
                                    break;
                                }
                                i = (i + 1);
                            }
                            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
                            {
                                LogManager.msg("当前视频加载完毕了(" + this._downloadIndex_uint + ") by_num:" + by_num + " tot_num:" + tot_num + " metaByTot_num:" + metaByTot_num);
                            }
                            var _loc_2:int = 0;
                            tot_num;
                            by_num = _loc_2;
                            this.checkLastoutBuffer();
                        }
                        catch (evt)
                        {
                            Utils.debug(evt);
                        }
                    }
                    else if (!this._video_arr[this._downloadIndex_uint].isAbend)
                    {
                        this._video_arr[this._downloadIndex_uint].isAbend = true;
                        this.downloadAbend({nowSize:by_num, totSize:tot_num, metaTotSize:metaByTot_num, clipIndex:this._downloadIndex_uint});
                    }
                }
                this.dispatch(MediaEvent.LOAD_PROGRESS, {nowSize:this._nowLoadedSize_num + by_num, totSize:this._fileSize_num});
            }
            return;
        }// end function

        protected function downloadAbend(param1:Object) : void
        {
            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
            {
                LogManager.msg("当前视频加载完毕[异常中断](" + param1.clipIndex + ") by_num:" + param1.nowSize + " tot_num:" + param1.totSize + " metaByTot_num:" + param1.metaTotSize);
            }
            this.dispatch(MediaEvent.LOAD_ABEND, {nowSize:param1.nowSize, totSize:param1.totSize, metaTotSize:param1.metaTotSize, clipIndex:param1.clipIndex});
            return;
        }// end function

        protected function checkLastoutBuffer() : void
        {
            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
            {
                LogManager.msg("检测预加载状态！clip:" + this._downloadIndex_uint + " downloadState:" + this._video_arr[this._downloadIndex_uint].download + " lb:" + this._lastoutBuffer + " <:" + (this._downloadIndex_uint < (this._video_arr.length - 1)));
            }
            if (this._lastoutBuffer && (this._video_arr[this._downloadIndex_uint].download == "loaded" || this._video_arr[this._downloadIndex_uint].download == "part_loaded") && this._downloadIndex_uint < (this._video_arr.length - 1))
            {
                if (this._video_arr[(this._downloadIndex_uint + 1)].download == "no")
                {
                    this.download((this._downloadIndex_uint + 1));
                }
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
            trace("onStatus:" + event.info.code);
            var _loc_2:* = this._video_arr[this._currentIndex_uint].ns;
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    this._video_arr[this._currentIndex_uint].isAbend = false;
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
                    break;
                }
                case "NetStream.Play.FileStructureInvalid":
                {
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
                    this.dispatch(MediaEvent.SEEKED);
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
            var _loc_2:Number = NaN;
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
                _loc_2 = this._startTime > 0 ? (this._startTime) : (null);
                if (this._video_arr[this._currentIndex_uint].download == "no")
                {
                    this.download(this._currentIndex_uint, _loc_2);
                    this.dispatch(MediaEvent.CONNECTING);
                }
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
                    this._video_arr[_loc_2].download = "no";
                    Utils.debug("close() in stop");
                    _loc_2 = _loc_2 + 1;
                }
                this._sysStatus_str = "5";
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

        protected function initSectState(param1:uint) : void
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

        private function initProHaveData(param1:uint) : Boolean
        {
            var _loc_2:String = "1";
            var _loc_3:Boolean = true;
            var _loc_4:* = param1;
            this._playedTime_num = 0;
            this._nowLoadedSize_num = 0;
            var _loc_5:uint = 0;
            while (_loc_5 < this._video_arr.length)
            {
                
                if (param1 != _loc_5)
                {
                    this._video_arr[_loc_5].video.visible = false;
                }
                if (_loc_5 < param1)
                {
                    this._playedTime_num = this._playedTime_num + this._video_arr[_loc_5].time;
                    this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc_5].size;
                }
                else if (_loc_5 == param1)
                {
                    if (this._video_arr[_loc_5].download == "part_loaded" || this._video_arr[_loc_5].download == "loaded")
                    {
                        this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc_5].size;
                    }
                    else if (this._video_arr[_loc_5].download == "part_loading" || this._video_arr[_loc_5].download == "loading")
                    {
                        this._nowLoadedSize_num = this._nowLoadedSize_num + (this._video_arr[_loc_5].size - this._video_arr[_loc_5].ns.bytesTotal);
                    }
                }
                else if (_loc_5 > param1)
                {
                    if (this._video_arr[_loc_5].download == "loaded")
                    {
                        if (_loc_2 == "1")
                        {
                            this._nowLoadedSize_num = this._nowLoadedSize_num + this._video_arr[_loc_5].size;
                            _loc_4 = _loc_5;
                        }
                    }
                    else
                    {
                        _loc_2 = "0";
                        if (this._video_arr[_loc_5].download != "loading" || this._video_arr[(_loc_5 - 1)].download != "loaded")
                        {
                            this.initSectState(_loc_5);
                        }
                    }
                }
                if (this._video_arr[_loc_5].download == "part_loading" || this._video_arr[_loc_5].download == "loading")
                {
                    _loc_3 = false;
                }
                _loc_5 = _loc_5 + 1;
            }
            if (_loc_3)
            {
                this._downloadIndex_uint = _loc_4;
            }
            return _loc_3;
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
            if (this.K1026044EB31EC02A5E480B8724F16C2AF4A751373567K)
            {
                LogManager.msg("-----------drag---------------");
            }
            this.dispatch(MediaEvent.DRAG_START);
            this.K1026043DB3C4729D2C49DD8DF29CB1BC5D1968373567K(param2);
            this.changeNS(this._currentIndex_uint, param2);
            var _loc_3:* = param2;
            this._downloadIndex_uint = param2;
            this._currentIndex_uint = _loc_3;
            this._startTime = Math.abs(Math.round(param1));
            this._startTime = this._startTime <= this._optimize ? (0) : (this._startTime);
            return;
        }// end function

        public function seek(param1:Number, param2 = null) : void
        {
            var _loc_6:uint = 0;
            var _loc_7:Number = NaN;
            var _loc_8:Boolean = false;
            var _loc_9:String = null;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_3:* = this._playedTime_num;
            this._playedTime_num = 0;
            var _loc_4:Boolean = false;
            var _loc_5:Boolean = false;
            if (param1 > this._vTotTime_num)
            {
                param1 = this._vTotTime_num;
            }
            if (param1 >= 0 && param1 <= this._vTotTime_num)
            {
                _loc_6 = 0;
                while (_loc_6 < this._video_arr.length)
                {
                    
                    if (param1 >= this._video_arr[_loc_6].start && param1 <= this._video_arr[_loc_6].end)
                    {
                        _loc_7 = param1 - this._video_arr[_loc_6].start;
                        this._now_ns.pause();
                        this._sysStatus_str = "4";
                        _loc_4 = true;
                        if (this._tow)
                        {
                            if ((_loc_7 < this._video_arr[_loc_6].datastart || _loc_7 > this._video_arr[_loc_6].dataend) && param2 != 0)
                            {
                                Utils.debug("------------------------------------diff:" + _loc_7 + " start:" + this._video_arr[_loc_6].datastart + " end:" + this._video_arr[_loc_6].dataend + " sign:" + param2);
                                this.tow(_loc_7, _loc_6);
                            }
                            else
                            {
                                if (param2 != 0)
                                {
                                    if (this._video_arr[_loc_6].download != "part_loading" && this._video_arr[_loc_6].download != "loading")
                                    {
                                        _loc_5 = this.initProHaveData(_loc_6);
                                        this.dispatch(MediaEvent.LOAD_PROGRESS, {nowSize:this._nowLoadedSize_num, totSize:this._fileSize_num});
                                    }
                                }
                                Utils.debug("_playedTime_num1:" + this._playedTime_num);
                                this._playedTime_num = this._playedTime_num + this._video_arr[_loc_6].datastart;
                                Utils.debug("_playedTime_num2:" + this._playedTime_num + " seeksec:" + _loc_7 + " _fileType:" + this._fileType);
                                _loc_8 = this._currentIndex_uint == _loc_6;
                                this.changeNS(this._currentIndex_uint, _loc_6);
                                _loc_9 = this._fileType;
                                if (_loc_9 == "mp4")
                                {
                                    _loc_10 = _loc_7 - this._video_arr[_loc_6].datastart;
                                    if (_loc_10 >= 1 && _loc_10 <= (this._video_arr[_loc_6].dataend - 1))
                                    {
                                        Utils.debug("+++++++++-----+++++++++++++++_now_ns.time:" + this._now_ns.time + " getNSTime:" + this.getNSTime(this._now_ns) + " sign:" + param2 + " isSame:" + _loc_8);
                                        if (param2 == 0 || _loc_8)
                                        {
                                            this._now_ns.seek(_loc_10);
                                        }
                                        else
                                        {
                                            this._now_ns.seek(0);
                                            this._timeeee = _loc_10;
                                        }
                                        Utils.debug("最终mp4-seek:" + _loc_10 + " _video_arr[i].datastart:" + this._video_arr[_loc_6].datastart + " _video_arr[i].dataend:" + this._video_arr[_loc_6].dataend + " sign:" + param2 + " isSame:" + _loc_8);
                                        if (_loc_5)
                                        {
                                            this.checkLastoutBuffer();
                                        }
                                    }
                                }
                                else if (--_loc_7 >= (this._video_arr[_loc_6].datastart + 1) && --_loc_7 <= (this._video_arr[_loc_6].dataend - 1))
                                {
                                    if (param2 == 0 || _loc_8)
                                    {
                                        this._now_ns.seek(_loc_10);
                                    }
                                    else
                                    {
                                        this._now_ns.seek(0);
                                        this._timeeee = _loc_10;
                                    }
                                    Utils.debug("最终seek:" + _loc_10 + " _video_arr[i].datastart:" + this._video_arr[_loc_6].datastart + " _video_arr[i].dataend:" + this._video_arr[_loc_6].dataend);
                                    if (_loc_5)
                                    {
                                        this.checkLastoutBuffer();
                                    }
                                }
                            }
                        }
                        else
                        {
                            this.changeNS(this._currentIndex_uint, _loc_6);
                            _loc_11 = param1 - this._video_arr[_loc_6].start;
                            this._now_ns.seek(_loc_11);
                        }
                        break;
                    }
                    else
                    {
                        this._playedTime_num = this._playedTime_num + this._video_arr[_loc_6].time;
                    }
                    _loc_6 = _loc_6 + 1;
                }
                if (!_loc_4)
                {
                    this._playedTime_num = _loc_3;
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

        public function get arate() : Number
        {
            return this._audioRate;
        }// end function

        public function get vrate() : Number
        {
            if (this._videoRate == -1)
            {
                return Math.round(this._fileSize_num / this._vTotTime_num);
            }
            return this._videoRate;
        }// end function

        public function set lastoutBuffer(param1:Boolean) : void
        {
            this._lastoutBuffer = param1;
            this.checkLastoutBuffer();
            return;
        }// end function

        public function get lastoutBuffer() : Boolean
        {
            return this._lastoutBuffer;
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

        public function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new MediaEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

    }
}
