package com.sohu.tv.mediaplayer.video
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.ads.*;
    import com.sohu.tv.mediaplayer.netstream.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.core.vc37.*;
    import ebing.events.*;
    import ebing.external.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.utils.*;

    public class TvSohuVideoCore extends VideoCore
    {
        private var _qfStat:ErrorSenderPQ;
        private var _totBufferNum:Number = 0;
        private var _bufferEmptyTime:Number = 0;
        private var _retryNum:int = 3;
        private var _webP2pRetryNum:int = 0;
        private var _owner:TvSohuVideoCore;
        private var _previousIndex_int:int = -1;
        private var _displayRate:Number = 1;
        private var _scaleWidth:Number = 0;
        private var _scaleHeight:Number = 0;
        private var _scaleState:String = "meta";
        private var _bufferSpend:uint = 0;
        private var _intervalRetry:Number = 0;
        private var _rotateType:int = 0;
        private var _videoArr:Array;
        private var _isDirectRotation:Boolean = false;
        private var _isped:String = "0";
        private var _fbt:Number = 0;
        private var _dragNum:Number = 0;
        private var _softInitObj:Object;
        private var _coreTempTime:Number = 0;
        private var _vvBytesTotal:Number = 0;
        private var _clipBytesAugmenter:Number = 0;
        private var _stage:Stage;
        private var _lastTimeCDNBytes:Number = 0;
        private var _lastTimePeerBytes:Number = 0;
        private var _lastTimeIfoxPBytes:Number = 0;
        private var _is200:Boolean = false;
        private var _isPFVNetStreamError:Boolean = false;

        public function TvSohuVideoCore(param1:Object)
        {
            this._videoArr = new Array();
            this._owner = this;
            this._qfStat = ErrorSenderPQ.getInstance();
            if (param1.stage != null)
            {
                this._stage = param1.stage;
            }
            super(param1);
            setInterval(this.sendP2PStat, 30000);
            return;
        }// end function

        override public function initMedia(param1:Object) : void
        {
            var _loc_11:uint = 0;
            var _loc_12:Object = null;
            var _loc_13:uint = 0;
            var _loc_14:Object = null;
            this._softInitObj = param1;
            var _loc_15:* = param1.is200;
            this._is200 = param1.is200;
            var _loc_2:* = _loc_15;
            var _loc_3:* = param1.flv;
            var _loc_4:* = param1.time;
            var _loc_5:* = param1.size;
            var _loc_6:* = new Array();
            _isGained = false;
            _vTotTime_num = 0;
            _fileSize_num = 0;
            if (_video_arr != null)
            {
                _loc_11 = 0;
                while (_loc_11 < _video_arr.length)
                {
                    
                    _video_arr[_loc_11].ns.removeEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
                    _video_arr[_loc_11].ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
                    _video_c.removeChild(_video_arr[_loc_11].video);
                    _video_arr[_loc_11].video.dispose();
                    _loc_11 = _loc_11 + 1;
                }
                _video_arr.splice(0);
            }
            _video_arr = new Array();
            var _loc_7:* = new Array();
            var _loc_8:* = new Array();
            var _loc_9:* = new Array();
            if (!PlayerConfig.is56)
            {
                LogManager.msg("isWebP2p:" + PlayerConfig.isWebP2p);
                LogManager.msg("==========播放器初始化数据开始==========");
                _loc_7 = _loc_3.split(",");
                _loc_8 = _loc_4.split(",");
                _loc_9 = _loc_5.split(",");
            }
            else
            {
                this._isPFVNetStreamError = false;
                LogManager.msg("isWSP2p:" + PlayerConfig.isWSP2p);
                LogManager.msg("==========播放器初始化数据开始==========");
                _loc_7[0] = _loc_3;
                _loc_8[0] = _loc_4;
                _loc_9[0] = _loc_5;
            }
            var _loc_10:uint = 0;
            while (_loc_10 < _loc_7.length)
            {
                
                _video_arr[_loc_10] = {flv:_loc_7[_loc_10], video:new TvSohuVideo(this._stage), start:_loc_10 == 0 ? (0) : ((_vTotTime_num + 1)), end:_loc_10 == 0 ? (_loc_8[_loc_10]) : (_vTotTime_num + Number(_loc_8[_loc_10])), download:"no", ns:PlayerConfig.isWebP2p ? (new PeerNS(_my_nc)) : (PlayerConfig.is56 ? (PlayerConfig.isWSP2p ? (new PFVFSNetStream(_my_nc, _loc_2, true)) : (new SegmentManager(_my_nc, _loc_2, true, PlayerConfig.isSohuFor56))) : (new TvSohuNetStream(_my_nc, _loc_2, true))), time:Number(_loc_8[_loc_10]), size:Number(_loc_9[_loc_10]), iserr:false, datastart:0, dataend:0, duration:Number(_loc_8[_loc_10]), gotMetaData:false, datarate:Math.floor(Number(_loc_9[_loc_10]) * 8 / 1024 / Number(_loc_8[_loc_10])), isnp:false, sendVV:false, retryNum:PlayerConfig.isWebP2p ? (this._webP2pRetryNum) : (this._retryNum), laRetryNum:3, bytesTotal:0, isSentQF:false, isAbend:false};
                _vTotTime_num = _vTotTime_num + Number(_loc_8[_loc_10]);
                _fileSize_num = _fileSize_num + Number(_loc_9[_loc_10]);
                _video_arr[_loc_10].video.smoothing = true;
                if (PlayerConfig.is56)
                {
                    if (PlayerConfig.isSohuFor56)
                    {
                        _video_arr[_loc_10].ns.init(_video_arr[_loc_10].flv + "&prod=56&pt=1&pg=1", true, PlayerConfig.SEGSIZE);
                    }
                    else
                    {
                        _video_arr[_loc_10].ns.init(_video_arr[_loc_10].flv, true, PlayerConfig.SEGSIZE);
                    }
                }
                if (PlayerConfig.isWebP2p)
                {
                    _loc_12 = new Object();
                    _loc_12.cdnfilename = PlayerConfig.synUrl[_loc_10];
                    _loc_12.filename = PlayerConfig.hashId[_loc_10];
                    _loc_12.fileidx = _loc_10;
                    _loc_12.duration = Number(_loc_8[_loc_10]);
                    _loc_12.size = Number(_loc_9[_loc_10]);
                    _loc_12.byteRate = _loc_12.size / _loc_12.duration;
                    _loc_12.byteloaded = 0;
                    _loc_12.ns = _video_arr[_loc_10].ns;
                    _loc_12.video = _video_arr[_loc_10].video;
                    _loc_12.clipsurl = PlayerConfig.clipsUrl[_loc_10];
                    _video_arr[_loc_10].ns.init(_loc_12);
                    _video_arr[_loc_10].ns.attachVideoToStream(_video_arr[_loc_10].video);
                    _loc_6.push(_loc_12);
                }
                else if (PlayerConfig.is56)
                {
                    _video_arr[_loc_10].ns.attachVideoToStream(_video_arr[_loc_10].video);
                }
                else
                {
                    _video_arr[_loc_10].video.attachNetStream(_video_arr[_loc_10].ns);
                    _video_arr[_loc_10].ns.clipNo = _loc_10;
                }
                _video_arr[_loc_10].ns.bufferTime = _buffer_num;
                _video_arr[_loc_10].video.visible = false;
                _video_arr[_loc_10].ns.client = _clientTem_obj;
                _video_c.addChild(_video_arr[_loc_10].video);
                this._videoArr.push(_video_arr[_loc_10].video);
                LogManager.msg(getClipInfo(_loc_10));
                if (PlayerConfig.isWebP2p && _loc_10 == 0)
                {
                    break;
                }
                _loc_10 = _loc_10 + 1;
            }
            if (PlayerConfig.isWebP2p)
            {
                _loc_13 = 1;
                while (_loc_13 < _loc_7.length)
                {
                    
                    if (_loc_7.length > 1)
                    {
                        _loc_14 = new Object();
                        _loc_14.cdnfilename = PlayerConfig.synUrl[_loc_13];
                        _loc_14.filename = PlayerConfig.hashId[_loc_13];
                        _loc_14.fileidx = _loc_13;
                        _loc_14.duration = Number(_loc_8[_loc_13]);
                        _loc_14.size = Number(_loc_9[_loc_13]);
                        _loc_14.byteRate = _loc_14.size / _loc_14.duration;
                        _loc_14.byteloaded = 0;
                        _loc_14.clipsurl = PlayerConfig.clipsUrl[_loc_13];
                        _vTotTime_num = _vTotTime_num + Number(_loc_8[_loc_13]);
                        _fileSize_num = _fileSize_num + Number(_loc_9[_loc_13]);
                        _loc_6.push(_loc_14);
                    }
                    _loc_13 = _loc_13 + 1;
                }
                P2pSohuLib.getInstance().referPeerNs(_loc_6[0].ns);
                if (P2pSohuLib.getInstance().allFile == null || P2pSohuLib.getInstance().allFile[0].cdnfilename != PlayerConfig.synUrl[0])
                {
                    P2pSohuLib.getInstance().addFileData(_loc_6);
                    var _loc_15:int = 0;
                    this._lastTimeIfoxPBytes = 0;
                    var _loc_15:* = _loc_15;
                    this._lastTimePeerBytes = _loc_15;
                    this._lastTimeCDNBytes = _loc_15;
                }
            }
            if (PlayerConfig.isUgcPreview)
            {
                _vTotTime_num = PlayerConfig.totalDuration;
            }
            addChild(_video_c);
            this.refresh(false);
            this.resize(_width_num, _height_num);
            LogManager.msg("==========播放器初始化数据结束==========");
            _video_arr[0].ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            _video_arr[0].ns.client = _client_obj;
            if (PlayerConfig.is56)
            {
                _video_arr[0].ns.getStream().addEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
                _video_arr[0].ns.addEventListener("PFVNetStreamError", this.PFVNetStreamError);
            }
            else
            {
                _video_arr[0].ns.addEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
            }
            _now_ns = _video_arr[0].ns;
            this.setPredictMode();
            _video_arr[0].video.visible = true;
            _video_c.addChild(_video_arr[0].video);
            this.initVolume();
            sysInit();
            return;
        }// end function

        public function changeDefinition() : void
        {
            this.stop();
            return;
        }// end function

        private function PFVNetStreamError(event:Event) : void
        {
            if (!this._isPFVNetStreamError && _now_ns["PFVErrorType"] != "")
            {
                this._isPFVNetStreamError = true;
                LogManager.msg("PFVNetStreamError广播错误，错误类型是 " + "PFVErrorType: " + _now_ns["PFVErrorType"]);
                this.dispatchEvent(new Event("PFVNetStreamError"));
            }
            _video_arr[0].ns.removeEventListener("PFVNetStreamError", this.PFVNetStreamError);
            return;
        }// end function

        public function get PFVNetStreamErrorType() : String
        {
            if (PlayerConfig.is56)
            {
                return _now_ns["PFVErrorType"];
            }
            return "";
        }// end function

        override protected function onMetaData(param1:Object) : void
        {
            var _loc_2:Number = NaN;
            if (PlayerConfig.is56)
            {
                var _loc_3:* = _now_ns;
                _loc_3._now_ns["onMetaDataGet"](param1);
            }
            if (!_isGained)
            {
                _isGained = true;
                if (_video_arr.length == 1 && !_video_arr[0].ns.isDrag && !PlayerConfig.isUgcPreview)
                {
                    var _loc_3:* = _video_arr[0].ns.bytesTotal;
                    _video_arr[0].size = _video_arr[0].ns.bytesTotal;
                    _fileSize_num = _loc_3;
                    var _loc_3:* = PlayerConfig.isWebP2p ? (_video_arr[0].ns.duration) : (param1.duration);
                    _video_arr[0].time = PlayerConfig.isWebP2p ? (_video_arr[0].ns.duration) : (param1.duration);
                    var _loc_3:* = _loc_3;
                    _video_arr[0].end = _loc_3;
                    _vTotTime_num = _loc_3;
                }
                _metaWidth_num = param1.width;
                _metaHeight_num = param1.height;
                if (param1.keyframes != null)
                {
                    _fileType = "flv";
                }
                else if (param1.seekpoints != null)
                {
                    _fileType = "mp4";
                }
                else
                {
                    _fileType = "unknown";
                }
                this.resize(_width_num, _height_num);
            }
            if (_tow && !_video_arr[_downloadIndex_uint].ns.gotMetaData)
            {
                LogManager.msg("第" + _downloadIndex_uint + "段MetaData获取！obj.duration:" + param1.duration + " size:" + _video_arr[_downloadIndex_uint].ns.bytesTotal + " nstime:" + _video_arr[_downloadIndex_uint].ns.time);
                if (_fileType == "mp4")
                {
                    _video_arr[_downloadIndex_uint].bytesTotal = _video_arr[_downloadIndex_uint].ns.bytesTotal;
                    _video_arr[_downloadIndex_uint].duration = param1.duration;
                    _video_arr[_downloadIndex_uint].datastart = _video_arr[_downloadIndex_uint].time - param1.duration;
                    _playedTime_num = _playedTime_num + _video_arr[_downloadIndex_uint].datastart;
                    _nowLoadedSize_num = _nowLoadedSize_num + (_video_arr[_downloadIndex_uint].size - _video_arr[_downloadIndex_uint].ns.bytesTotal);
                }
                else
                {
                    _video_arr[_downloadIndex_uint].bytesTotal = _video_arr[_downloadIndex_uint].ns.bytesTotal;
                    _loc_2 = _video_arr[_downloadIndex_uint].ns.time;
                    _video_arr[_downloadIndex_uint].duration = _video_arr[_downloadIndex_uint].time - _loc_2;
                    _video_arr[_downloadIndex_uint].datastart = _loc_2;
                    _playedTime_num = _playedTime_num + _video_arr[_downloadIndex_uint].datastart;
                    _nowLoadedSize_num = _nowLoadedSize_num + (_video_arr[_downloadIndex_uint].size - _video_arr[_downloadIndex_uint].ns.bytesTotal);
                    Utils.debug("------------++++++++++++++videoType:" + _fileType + " nstime:" + _video_arr[_downloadIndex_uint].ns.time + " _nowLoadedSize_num:" + _nowLoadedSize_num);
                }
                _video_arr[_downloadIndex_uint].ns.gotMetaData = true;
            }
            dispatch(MediaEvent.DRAG_END);
            _video_arr[_downloadIndex_uint].metadata = param1;
            return;
        }// end function

        private function webP2PRollback() : void
        {
            this._qfStat.sendPQStat({error:0, code:PlayerConfig.ROLLBACK_CODE, split:(_currentIndex_uint + 1), dom:ns.playUrl, drag:ns.dragTime, allno:PlayerConfig.allErrNo, errno:ns.cdnNum + ns.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate});
            PlayerConfig.isWebP2p = false;
            PlayerConfig.isRollback = true;
            var _loc_1:* = filePlayedTime;
            var _loc_2:* = _sysStatus_str;
            this.stop("noevent");
            this.initMedia(this._softInitObj);
            this.seek(_loc_1);
            if (_loc_2 == "3")
            {
                this.play();
            }
            else if (_loc_2 == "4")
            {
                this.pause();
            }
            return;
        }// end function

        override public function pause(param1 = null) : void
        {
            super.pause(param1);
            if (param1 != "0" && param1 != null)
            {
                this._isped = "1";
            }
            return;
        }// end function

        override public function initVolume() : void
        {
            if (!PlayerConfig.isMute)
            {
                super.initVolume();
            }
            else
            {
                volume = 0;
            }
            return;
        }// end function

        override public function seek(param1:Number, param2 = null) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Boolean = false;
            var _loc_5:Boolean = false;
            if (PlayerConfig.isWebP2p)
            {
                _loc_3 = _playedTime_num;
                _playedTime_num = 0;
                _loc_4 = false;
                _loc_5 = false;
                if (param1 >= 0 && param1 <= _vTotTime_num)
                {
                    _now_ns.seek(param1);
                }
            }
            else if (PlayerConfig.is56)
            {
                _now_ns.seek(param1);
            }
            else
            {
                super.seek(param1, param2);
            }
            return;
        }// end function

        override protected function aboutTime() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (PlayerConfig.isWebP2p)
            {
                if (_sysStatus_str != "4" && _sysStatus_str != "5" && _currentIndex_uint < _video_arr.length)
                {
                    _loc_1 = !_tow ? (Math.floor(_video_arr[_currentIndex_uint].time - getNSTime(_now_ns))) : (Math.floor(_video_arr[_currentIndex_uint].time - (_video_arr[_currentIndex_uint].datastart + getNSTime(_now_ns))));
                    if (_loc_1 <= _preloadTime && (_video_arr[_currentIndex_uint].download == "loaded" || _video_arr[_currentIndex_uint].download == "part_loaded") && _currentIndex_uint < (_video_arr.length - 1))
                    {
                        if (_video_arr[(_currentIndex_uint + 1)].download == "no")
                        {
                            this.download((_currentIndex_uint + 1));
                        }
                    }
                    _loc_2 = getNSTime(_now_ns);
                    if (PlayerConfig.isWebP2p)
                    {
                        _nowTime_num = _now_ns.time;
                    }
                    else
                    {
                        _nowTime_num = _loc_2 + _playedTime_num;
                    }
                    if (_timeeee != -1)
                    {
                        if (_video_arr[_currentIndex_uint].ns.time != 0)
                        {
                            Utils.debug("second seek " + _video_arr[_currentIndex_uint].ns.time);
                            _now_ns.seek(_timeeee);
                            _timeeee = -1;
                        }
                    }
                    else if (_loc_2 != 0)
                    {
                        _loc_3 = _now_ns.time;
                        dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:_loc_3, totTime:_vTotTime_num, isSeek:false});
                    }
                }
            }
            else
            {
                super.aboutTime();
            }
            return;
        }// end function

        override protected function timerHandler(event:TimerEvent) : void
        {
            if (!PlayerConfig.isLive || PlayerConfig.isP2PLive)
            {
                super.timerHandler(event);
            }
            else
            {
                this.aboutTime();
                if (getNSTime(_now_ns) >= 1 && !_played_boo && _sysStatus_str == "3")
                {
                    _played_boo = true;
                    dispatch(MediaEvent.PLAYED);
                }
            }
            return;
        }// end function

        override public function stop(param1 = null) : void
        {
            if (_sysStatus_str != "5")
            {
                this.closeDownNextVideo();
            }
            this.saveSvdMode();
            super.stop(param1);
            if (PlayerConfig.is56)
            {
                var _loc_2:* = _now_ns;
                _loc_2._now_ns["gc"]();
                _my_nc = new NetConnection();
                _my_nc.connect(null);
            }
            this.initMedia(this._softInitObj);
            return;
        }// end function

        override public function destroy() : void
        {
            this.closeDownNextVideo();
            super.destroy();
            return;
        }// end function

        private function closeDownNextVideo() : void
        {
            new URLLoaderUtil().send(PlayerConfig.CHECKP2PPATH + "stoppreload?uuid=" + PlayerConfig.uuid);
            return;
        }// end function

        override protected function newFunc() : void
        {
            super.newFunc();
            P2PExplorer.getInstance();
            return;
        }// end function

        override public function get vrate() : Number
        {
            return _video_arr[_downloadIndex_uint].datarate;
        }// end function

        public function get coreTempTime() : Number
        {
            return this._coreTempTime;
        }// end function

        public function displayZoom(param1:Number = 1) : void
        {
            if (param1 > 0 && param1 <= 1)
            {
                this._displayRate = param1;
                Utils.prorata(_video_c, this._displayRate * _bg_spr.width, this._displayRate * _bg_spr.height);
                Utils.setCenter(_video_c, _bg_spr);
                this.changeStvWHXY();
            }
            return;
        }// end function

        public function displayTo4_3(event:Event = null) : void
        {
            this._scaleState = "4_3";
            if (this._rotateType % 2 != 0)
            {
                this._scaleWidth = 3;
                this._scaleHeight = 4;
            }
            else
            {
                this._scaleWidth = 4;
                this._scaleHeight = 3;
            }
            this.resize(_width_num, _height_num);
            return;
        }// end function

        public function displayTo16_9(event:Event = null) : void
        {
            this._scaleState = "16_9";
            if (this._rotateType % 2 != 0)
            {
                this._scaleWidth = 9;
                this._scaleHeight = 16;
            }
            else
            {
                this._scaleWidth = 16;
                this._scaleHeight = 9;
            }
            this.resize(_width_num, _height_num);
            return;
        }// end function

        public function displayToMeta(event:Event = null) : void
        {
            this._scaleState = "meta";
            var _loc_2:int = 0;
            this._scaleHeight = 0;
            this._scaleWidth = _loc_2;
            this.resize(_width_num, _height_num);
            return;
        }// end function

        public function displayToFull(event:Event = null) : void
        {
            this._scaleState = "full";
            this._scaleWidth = _width_num;
            this._scaleHeight = _height_num;
            this.resize(_width_num, _height_num);
            return;
        }// end function

        public function setR(param1:int) : void
        {
            this._rotateType = param1;
            this._isDirectRotation = true;
            this.refresh();
            this.resize(_width_num, _height_num);
            return;
        }// end function

        public function get vvBytesTotal() : Number
        {
            return this._vvBytesTotal;
        }// end function

        public function get scaleState() : String
        {
            return this._scaleState;
        }// end function

        public function get rotateType() : int
        {
            return this._rotateType;
        }// end function

        public function get loadingClipIndex() : Number
        {
            return _downloadIndex_uint;
        }// end function

        override public function resize(param1:Number, param2:Number) : void
        {
            var _loc_3:int = 0;
            var _loc_4:* = param1;
            _bg_spr.width = param1;
            _width_num = _loc_4;
            var _loc_4:* = param2;
            _bg_spr.height = param2;
            _height_num = _loc_4;
            if (this._scaleState == "full")
            {
                if (this._rotateType % 2 != 0)
                {
                    this._scaleWidth = _height_num;
                    this._scaleHeight = _width_num;
                }
                else
                {
                    this._scaleWidth = _width_num;
                    this._scaleHeight = _height_num;
                }
            }
            if (_video_arr != null)
            {
                if (this._scaleWidth != 0)
                {
                    _video_c.width = this._scaleWidth;
                    _video_c.height = this._scaleHeight;
                }
                else if (_metaWidth_num != 0)
                {
                    if (this._rotateType % 2 != 0)
                    {
                        _video_c.width = _metaHeight_num;
                        _video_c.height = _metaWidth_num;
                    }
                    else
                    {
                        _video_c.width = _metaWidth_num;
                        _video_c.height = _metaHeight_num;
                    }
                }
                else
                {
                    _video_c.width = _width_num;
                    _video_c.height = _height_num;
                }
                if (this._displayRate == 1)
                {
                    Utils.prorata(_video_c, _bg_spr.width, _bg_spr.height);
                    Utils.setCenter(_video_c, _bg_spr);
                    this.changeStvWHXY();
                }
                else
                {
                    this.displayZoom(this._displayRate);
                }
                if (this._isDirectRotation)
                {
                    _loc_3 = 0;
                    if (this._rotateType == 1)
                    {
                        _loc_3 = 0;
                        while (_loc_3 < this._videoArr.length)
                        {
                            
                            this._videoArr[_loc_3].x = this._videoArr[_loc_3].width;
                            this._videoArr[_loc_3].y = 0;
                            _loc_3++;
                        }
                    }
                    else if (this._rotateType == 2)
                    {
                        _loc_3 = 0;
                        while (_loc_3 < this._videoArr.length)
                        {
                            
                            this._videoArr[_loc_3].x = this._videoArr[_loc_3].width;
                            this._videoArr[_loc_3].y = this._videoArr[_loc_3].height;
                            _loc_3++;
                        }
                    }
                    else if (this._rotateType == 3)
                    {
                        _loc_3 = 0;
                        while (_loc_3 < this._videoArr.length)
                        {
                            
                            this._videoArr[_loc_3].x = 0;
                            this._videoArr[_loc_3].y = this._videoArr[_loc_3].height;
                            _loc_3++;
                        }
                    }
                    else if (this._rotateType == 0)
                    {
                        _loc_3 = 0;
                        while (_loc_3 < this._videoArr.length)
                        {
                            
                            this._videoArr[_loc_3].x = 0;
                            this._videoArr[_loc_3].y = 0;
                            _loc_3++;
                        }
                    }
                }
            }
            return;
        }// end function

        private function refresh(param1:Boolean = true) : void
        {
            var _loc_3:Number = NaN;
            if (param1)
            {
                _loc_3 = this._scaleWidth;
                this._scaleWidth = this._scaleHeight;
                this._scaleHeight = _loc_3;
            }
            var _loc_2:uint = 0;
            while (_loc_2 < this._videoArr.length)
            {
                
                this._videoArr[_loc_2].rotation = this._rotateType * 90;
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        override public function play(param1 = null) : void
        {
            var _loc_2:* = undefined;
            Utils.debug("play:" + _sysStatus_str);
            this._coreTempTime = new Date().getTime();
            if (_sysStatus_str == "5")
            {
                if (!PlayerConfig.sendRealVV)
                {
                    PlayerConfig.videoDownloadTime = getTimer();
                }
                _now_ns.play(_video_arr[0].flv);
                _video_arr[_downloadIndex_uint].download = "loading";
                dispatch(MediaEvent.CONNECTING);
            }
            if (_sysStatus_str == "4")
            {
                _loc_2 = _startTime > 0 ? (_startTime) : (null);
                if (_video_arr[_currentIndex_uint].download == "no")
                {
                    this.download(_currentIndex_uint, _loc_2);
                    _video_arr[_downloadIndex_uint].ns.removeEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
                    dispatch(MediaEvent.CONNECTING);
                }
                _now_ns.resume();
            }
            _sysStatus_str = "3";
            dispatch(MediaEvent.PLAY);
            return;
        }// end function

        override protected function aboutDownload() : void
        {
            var by_num:Number;
            var tot_num:Number;
            var metaByTot_num:Number;
            var loaded:Number;
            var download:String;
            var index:uint;
            var i:uint;
            var vid:String;
            if (_video_arr[_downloadIndex_uint].download != "abend" && (_video_arr[_downloadIndex_uint].download == "loading" || _video_arr[_downloadIndex_uint].download == "part_loading"))
            {
                by_num = _video_arr[_downloadIndex_uint].ns.bytesLoaded;
                tot_num = _video_arr[_downloadIndex_uint].ns.bytesTotal;
                metaByTot_num = _video_arr[_downloadIndex_uint].bytesTotal;
                var _loc_2:* = _nowLoadedSize_num + by_num;
                _nowLoadedSize2_num = _nowLoadedSize_num + by_num;
                loaded = _loc_2;
                if (this._clipBytesAugmenter > by_num)
                {
                    this._vvBytesTotal = this._vvBytesTotal + by_num;
                }
                else
                {
                    this._vvBytesTotal = this._vvBytesTotal + (by_num - this._clipBytesAugmenter);
                }
                this._clipBytesAugmenter = by_num;
                if (_tow)
                {
                    _video_arr[_downloadIndex_uint].dataend = _video_arr[_downloadIndex_uint].datastart + _video_arr[_downloadIndex_uint].duration * by_num / tot_num;
                }
                if (by_num >= tot_num && tot_num > 0)
                {
                    if (metaByTot_num - tot_num <= 200)
                    {
                        download;
                        if (_video_arr[_downloadIndex_uint].ns.isDrag)
                        {
                            download;
                        }
                        _video_arr[_downloadIndex_uint].download = download;
                        _nowLoadedSize_num = _nowLoadedSize_num + tot_num;
                        try
                        {
                            Utils.debug("_downloadIndex_uint:" + _downloadIndex_uint + "_video_arr[_downloadIndex_uint].download:" + _video_arr[_downloadIndex_uint].download);
                            index = (_downloadIndex_uint + 1);
                            i = index;
                            while (i < _video_arr.length)
                            {
                                
                                if (_video_arr[i].download == "loaded")
                                {
                                    _nowLoadedSize_num = _nowLoadedSize_num + _video_arr[i].size;
                                    _downloadIndex_uint = i;
                                }
                                else
                                {
                                    break;
                                }
                                i = (i + 1);
                            }
                            LogManager.msg("当前视频加载完毕了(" + _downloadIndex_uint + ") by_num:" + by_num + " tot_num:" + tot_num + " metaByTot_num:" + metaByTot_num);
                            var _loc_2:int = 0;
                            tot_num;
                            by_num = _loc_2;
                            _video_arr[_downloadIndex_uint].ns.sendCloseEvent();
                            if (_downloadIndex_uint == (_video_arr.length - 1) && Eif.available)
                            {
                                ExternalInterface.call("playerMovieLoaded");
                                dispatchEvent(new Event("allLoaded"));
                                if (Eif.available)
                                {
                                    vid = ExternalInterface.call("getNextVideo")["videoId"];
                                    if (vid != null)
                                    {
                                        new URLLoaderUtil().load(8, null, "http://127.0.0.1:8828/preload?uuid=" + PlayerConfig.uuid + "&vid=" + vid + "&ptime=" + _nowTime_num + "&duration=" + _vTotTime_num + "&definition=" + (PlayerConfig.autoFix == "1" ? ("3") : (PlayerConfig.superVid == PlayerConfig.currentVid ? ("0") : (PlayerConfig.oriVid == PlayerConfig.currentVid ? ("4") : (PlayerConfig.hdVid == PlayerConfig.currentVid ? ("1") : ("2"))))) + "&r=" + new Date().getTime());
                                    }
                                }
                            }
                            this.checkLastoutBuffer();
                        }
                        catch (evt)
                        {
                            Utils.debug(evt);
                        }
                    }
                    else if (!_video_arr[_downloadIndex_uint].isAbend)
                    {
                        _video_arr[_downloadIndex_uint].isAbend = true;
                        this.downloadAbend({nowSize:by_num, totSize:tot_num, metaTotSize:metaByTot_num, clipIndex:_downloadIndex_uint});
                    }
                }
                dispatch(MediaEvent.LOAD_PROGRESS, {nowSize:_nowLoadedSize_num + by_num, totSize:_fileSize_num});
            }
            return;
        }// end function

        override protected function downloadAbend(param1:Object) : void
        {
            super.downloadAbend(param1);
            this.downLoadStreamStatus(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Load.abend"}));
            return;
        }// end function

        override protected function initSectState(param1:uint) : void
        {
            var _loc_2:Boolean = false;
            if (param1 == _downloadIndex_uint && _video_arr[param1].download == "loading")
            {
                _loc_2 = true;
            }
            super.initSectState(param1);
            if (_loc_2)
            {
                _video_arr[param1].ns.sendCloseEvent();
            }
            return;
        }// end function

        override protected function download(param1:uint, param2 = null) : void
        {
            clearTimeout(this._intervalRetry);
            if (!PlayerConfig.sendRealVV)
            {
                PlayerConfig.videoDownloadTime = getTimer();
            }
            _video_arr[param1].retryNum = PlayerConfig.isWebP2p ? (this._webP2pRetryNum) : (this._retryNum);
            _video_arr[param1].isSentQF = false;
            Utils.debug("*download*:" + this._previousIndex_int + "|" + _currentIndex_uint + "|" + param1 + "|" + _video_arr[param1].sendVV);
            if (this._previousIndex_int >= 0 && this._previousIndex_int != _currentIndex_uint && _video_arr[this._previousIndex_int] != null)
            {
                _video_arr[this._previousIndex_int].sendVV = false;
            }
            super.download(param1, param2);
            _video_arr[_downloadIndex_uint].ns.addEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
            return;
        }// end function

        override protected function changeNS(param1:uint, param2:uint) : void
        {
            if (param1 != param2)
            {
                this._previousIndex_int = param1;
                Utils.debug("*changeNS*preInd:" + this._previousIndex_int.toString() + "/newInd:" + param2.toString());
            }
            _video_arr[param2].ns.removeEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
            super.changeNS(param1, param2);
            PlayerConfig.playingSplit = _currentIndex_uint;
            return;
        }// end function

        override protected function judgeStop() : void
        {
            var _loc_1:* = Eif.available ? (new RegExp("GoogleTV", "i").test(ExternalInterface.call("eval", "window.navigator.userAgent"))) : (false);
            if (PlayerConfig.isLive && PlayerConfig.isP2PLive || _loc_1)
            {
                _now_ns.close();
            }
            else
            {
                _now_ns.pause();
            }
            if (_tow)
            {
                _playedTime_num = _playedTime_num + _video_arr[_currentIndex_uint].duration;
            }
            else
            {
                _playedTime_num = _playedTime_num + _video_arr[_currentIndex_uint].time;
            }
            if (_currentIndex_uint < (_video_arr.length - 1))
            {
                _video_arr[_currentIndex_uint].video.visible = false;
                LogManager.msg("第" + _currentIndex_uint + "段结束！下段的错误状态是：" + _video_arr[(_currentIndex_uint + 1)].iserr + " 下载状态是：" + _video_arr[(_currentIndex_uint + 1)].download);
                this.changeNS(_currentIndex_uint, (_currentIndex_uint + 1));
                _now_ns.seek(0);
                this.setSvdNextStream();
                _video_arr[_currentIndex_uint].video.visible = true;
                if (_video_arr[_currentIndex_uint].iserr)
                {
                    dispatch(MediaEvent.RETRY_FAILED);
                }
                else
                {
                    _now_ns.resume();
                    LogManager.msg("第" + _currentIndex_uint + "段开始播放！");
                }
                this.downNewVideoInfo();
            }
            else
            {
                _finish_boo = true;
                this.stop();
            }
            _stopFlag_boo = false;
            return;
        }// end function

        public function retry() : void
        {
            _video_arr[_currentIndex_uint].retryNum = PlayerConfig.isWebP2p ? (this._webP2pRetryNum) : (this._retryNum);
            this.bbb();
            return;
        }// end function

        public function retry2() : void
        {
            _startTime = getNSTime(_now_ns);
            this.bbb();
            return;
        }// end function

        private function bbb() : void
        {
            clearTimeout(this._intervalRetry);
            _video_arr[_currentIndex_uint].iserr = false;
            _video_arr[_currentIndex_uint].ns.removeEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
            if (_startTime > 0)
            {
                _video_arr[_currentIndex_uint].download = "part_loading";
            }
            else
            {
                _video_arr[_currentIndex_uint].download = "loading";
            }
            if (PlayerConfig.isWebP2p)
            {
                _video_arr[_currentIndex_uint].ns.seek(_startTime);
            }
            else
            {
                _video_arr[_currentIndex_uint].ns.play(_video_arr[_currentIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
            }
            if (TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing" || _sysStatus_str == "4")
            {
                _video_arr[_currentIndex_uint].ns.pause();
            }
            dispatch(MediaEvent.CONNECTING);
            return;
        }// end function

        override protected function onStatus(event:NetStatusEvent) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:Object = null;
            var _loc_2:* = _video_arr[_currentIndex_uint].ns;
            if (event.info.code == "NetStream.Play.Stop" && Math.abs(getNSTime(_now_ns) - _video_arr[_currentIndex_uint].duration) > 1 && _sysStatus_str == "3" && !PlayerConfig.is56)
            {
                if (!PlayerConfig.isLive)
                {
                    _stopFlag_boo = false;
                    _video_arr[_currentIndex_uint].ns.close();
                    LogManager.msg("第" + _currentIndex_uint + "段Stop事件触发了(异常中断)！nstimeCeil:" + Math.ceil(getNSTime(_now_ns) * 10) + " durationFloor:" + Math.floor(_video_arr[_currentIndex_uint].duration * 10) + " getNSTime:" + getNSTime(_now_ns) + " stopflag:" + _stopFlag_boo + " " + getClipInfo(_currentIndex_uint));
                    _video_arr[_currentIndex_uint].ns.addErrIp();
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_8:* = PlayerConfig;
                        var _loc_9:* = PlayerConfig.allErrNo + 1;
                        _loc_8.allErrNo = _loc_9;
                        var _loc_8:* = _loc_2;
                        var _loc_9:* = _loc_2.cdnNum + 1;
                        _loc_8.cdnNum = _loc_9;
                        this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_NOTFOUND, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else if (_video_arr[_currentIndex_uint].retryNum > 0)
                    {
                        _startTime = !PlayerConfig.isLive ? (getNSTime(_now_ns)) : (0);
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_8:* = _video_arr[_currentIndex_uint];
                        var _loc_9:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_8.retryNum = _loc_9;
                        this._owner.bbb();
                    }
                }
            }
            else
            {
                if (_loc_2.dragTime != 0)
                {
                    this._dragNum = _loc_2.dragTime;
                }
                LogManager.msg(event.info.code);
                switch(event.info.code)
                {
                    case "NetStream.Play.Start":
                    {
                        _video_arr[_currentIndex_uint].isAbend = false;
                        LogManager.msg("evt.info.code:" + event.info.code + " _isStart:" + _isStart + " _currentIndex_uint:" + _currentIndex_uint);
                        _startTime = 0;
                        _loc_2.dragTime = 0;
                        if (!_isStart)
                        {
                            _isStart = true;
                            _timer.start();
                            LogManager.msg("加载中...");
                            dispatch(MediaEvent.START);
                        }
                        break;
                    }
                    case "NetStream.Buffer.Empty":
                    {
                        LogManager.msg("缓冲中(" + _currentIndex_uint + ")...nstimeCeil:" + Math.ceil(getNSTime(_now_ns) * 10) + " durationFloor:" + Math.floor(_video_arr[_currentIndex_uint].duration * 10) + " getNSTime:" + getNSTime(_now_ns) + " stopflag:" + _stopFlag_boo + " " + getClipInfo(_currentIndex_uint) + " ns.time:" + _loc_2.time);
                        if (!_isBufferFlush && _loc_2.bufferLength < _loc_2.bufferTime && Math.abs(_video_arr[_currentIndex_uint].duration - _loc_2.time) > 2)
                        {
                            dispatch(MediaEvent.BUFFER_EMPTY);
                        }
                        break;
                    }
                    case "NetStream.Buffer.Full":
                    {
                        _isBufferFlush = false;
                        _loc_3 = 0;
                        while (_loc_3 < _video_arr.length)
                        {
                            
                            if (_loc_3 != _currentIndex_uint)
                            {
                                _video_arr[_loc_3].video.visible = false;
                            }
                            _loc_3 = _loc_3 + 1;
                        }
                        this.setSvdNextStream();
                        _video_arr[_currentIndex_uint].video.visible = true;
                        LogManager.msg("播放中(" + _currentIndex_uint + ")...");
                        dispatch(MediaEvent.FULL);
                        break;
                    }
                    case "NetStream.Buffer.Flush":
                    {
                        _isBufferFlush = true;
                        break;
                    }
                    case "NetStream.Play.Stop":
                    {
                        LogManager.msg("第" + _currentIndex_uint + "段Stop事件触发了！nstimeCeil:" + Math.ceil(getNSTime(_now_ns) * 10) + " durationFloor:" + Math.floor(_video_arr[_currentIndex_uint].duration * 10) + " getNSTime:" + getNSTime(_now_ns) + " stopflag:" + _stopFlag_boo + " " + getClipInfo(_currentIndex_uint));
                        if (_stopFlag_boo && !PlayerConfig.is56 || PlayerConfig.is56 && !PlayerConfig.isWSP2p && _now_ns["onStreamPlayStop"] || PlayerConfig.is56 && PlayerConfig.isWSP2p)
                        {
                            this.judgeStop();
                        }
                        else
                        {
                            _stopFlag_boo = true;
                        }
                        break;
                    }
                    case "NetStream.Play.StreamNotFound":
                    {
                        LogManager.msg("视频不存在!");
                        break;
                    }
                    case "NetStream.Play.FileStructureInvalid":
                    {
                        break;
                    }
                    case "NetStream.Seek.Notify":
                    {
                        _loc_4 = 0;
                        while (_loc_4 < _video_arr.length)
                        {
                            
                            if (_loc_4 != _currentIndex_uint)
                            {
                                _video_arr[_loc_4].video.visible = false;
                            }
                            _loc_4 = _loc_4 + 1;
                        }
                        _video_arr[_currentIndex_uint].video.visible = true;
                        dispatch(MediaEvent.SEEKED);
                        break;
                    }
                    case "NetStream.Seek.InvalidTime":
                    {
                        break;
                    }
                    case "NetStream.Seek.Failed":
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            switch(event.info.code)
            {
                case "NetStream.Buffer.Empty":
                {
                    if (!_isBufferFlush && _loc_2.bufferLength < _loc_2.bufferTime && Math.abs(_video_arr[_currentIndex_uint].duration - _loc_2.time) > 2)
                    {
                        var _loc_8:* = _loc_2;
                        var _loc_9:* = _loc_2.bufferNum + 1;
                        _loc_8.bufferNum = _loc_9;
                        var _loc_8:String = this;
                        var _loc_9:* = this._totBufferNum + 1;
                        _loc_8._totBufferNum = _loc_9;
                        this._bufferSpend = getTimer();
                        this._qfStat.sendPQStat({error:1, code:PlayerConfig.BUFFER_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, ontime:_loc_2.time, bufno:_loc_2.bufferNum, fbt:(getTimer() - this._fbt) / 1000, isped:this._isped, drag:this._dragNum, allbufno:this._totBufferNum, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0), isdl:_video_arr[_currentIndex_uint].download == "part_loaded" || _video_arr[_currentIndex_uint].download == "loaded" ? ("1") : ("0")});
                    }
                    if (PlayerConfig.isWebP2p)
                    {
                        P2pSohuLib.getInstance().sendBufEmpStat();
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    if (this._totBufferNum == 1 && this._bufferSpend > 0)
                    {
                        this._qfStat.sendPQStat({error:0, code:PlayerConfig.BUFFER_FULL_CODE, bd:getTimer() - this._bufferSpend, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, ontime:_loc_2.time, bufno:_loc_2.bufferNum, allbufno:this._totBufferNum, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                        this._bufferSpend = 0;
                    }
                    if (!_played_boo)
                    {
                        this._fbt = getTimer();
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    var _loc_8:* = _loc_2;
                    _loc_8._loc_2["clearCdnTimeout"]();
                    _video_arr[_currentIndex_uint].ns.destroyLocation();
                    LogManager.msg("第" + _currentIndex_uint + "段[视频]未找到！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
                    _video_arr[_currentIndex_uint].ns.addErrIp();
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_8:* = PlayerConfig;
                        var _loc_9:* = PlayerConfig.allErrNo + 1;
                        _loc_8.allErrNo = _loc_9;
                        var _loc_8:* = _loc_2;
                        var _loc_9:* = _loc_2.cdnNum + 1;
                        _loc_8.cdnNum = _loc_9;
                        this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_NOTFOUND, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else if (_video_arr[_currentIndex_uint].retryNum > 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_8:* = _video_arr[_currentIndex_uint];
                        var _loc_9:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_8.retryNum = _loc_9;
                        var _loc_8:* = _loc_2;
                        _loc_8._loc_2["setP2PTimeLimit"]();
                        this._owner.bbb();
                    }
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    var _loc_8:* = _loc_2;
                    _loc_8._loc_2["clearCdnTimeout"]();
                    LogManager.msg("第" + _currentIndex_uint + "段[视频]加载失败！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_8:* = PlayerConfig;
                        var _loc_9:* = PlayerConfig.allErrNo + 1;
                        _loc_8.allErrNo = _loc_9;
                        var _loc_8:* = _loc_2;
                        var _loc_9:* = _loc_2.cdnNum + 1;
                        _loc_8.cdnNum = _loc_9;
                        this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_FAILED, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else if (_video_arr[_currentIndex_uint].retryNum > 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_8:* = _video_arr[_currentIndex_uint];
                        var _loc_9:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_8.retryNum = _loc_9;
                        var _loc_8:* = _loc_2;
                        _loc_8._loc_2["setP2PTimeLimit"]();
                        this._owner.bbb();
                    }
                    break;
                }
                case "NetStream.Play.FileStructureInvalid":
                {
                    var _loc_8:* = _loc_2;
                    _loc_8._loc_2["clearCdnTimeout"]();
                    LogManager.msg("第" + _currentIndex_uint + "段[视频]文件结构无效！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_8:* = PlayerConfig;
                        var _loc_9:* = PlayerConfig.allErrNo + 1;
                        _loc_8.allErrNo = _loc_9;
                        var _loc_8:* = _loc_2;
                        var _loc_9:* = _loc_2.cdnNum + 1;
                        _loc_8.cdnNum = _loc_9;
                        this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_FILESTRUCTUREINVALID, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else if (_video_arr[_currentIndex_uint].retryNum > 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_8:* = _video_arr[_currentIndex_uint];
                        var _loc_9:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_8.retryNum = _loc_9;
                        var _loc_8:* = _loc_2;
                        _loc_8._loc_2["setP2PTimeLimit"]();
                        this._owner.bbb();
                    }
                    break;
                }
                case "CDNTimeout":
                {
                    LogManager.msg("第" + _currentIndex_uint + "段[视频]CDN超时！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
                    _video_arr[_currentIndex_uint].ns.addErrIp();
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_8:* = PlayerConfig;
                        var _loc_9:* = PlayerConfig.allErrNo + 1;
                        _loc_8.allErrNo = _loc_9;
                        var _loc_8:* = _loc_2;
                        var _loc_9:* = _loc_2.cdnNum + 1;
                        _loc_8.cdnNum = _loc_9;
                        this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_TIMEOUT, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else if (_video_arr[_currentIndex_uint].retryNum > 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_8:* = _video_arr[_currentIndex_uint];
                        var _loc_9:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_8.retryNum = _loc_9;
                        var _loc_8:* = _loc_2;
                        _loc_8._loc_2["setP2PTimeLimit"]();
                        this._owner.bbb();
                    }
                    break;
                }
                case "GSLB.Failed":
                {
                    LogManager.msg("第" + _currentIndex_uint + "段[视频]调度失败！retryNum:" + _video_arr[_currentIndex_uint].retryNum + " reason:" + event.info.reason);
                    if (event.info.reason == "overload")
                    {
                        dispatchEvent(new Event("live_overload"));
                        return;
                    }
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        _loc_7 = {index:_currentIndex_uint, reason:event.info.reason};
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND, _loc_7);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_8:* = PlayerConfig;
                        var _loc_9:* = PlayerConfig.all700ErrNo + 1;
                        _loc_8.all700ErrNo = _loc_9;
                        if (event.info.reason == "timeout")
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.GSLB_ERROR_TIMEOUT, code:PlayerConfig.GSLB_CODE, split:(_currentIndex_uint + 1), dom:PlayerConfig.gslbIp, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, all700no:PlayerConfig.all700ErrNo, errno:_loc_2.gslbNum + _loc_2.cdnNum, datarate:_video_arr[_currentIndex_uint].datarate});
                        }
                        else if (event.info.reason == "ioerror")
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.GSLB_ERROR_FAILED, code:PlayerConfig.GSLB_CODE, split:(_currentIndex_uint + 1), dom:PlayerConfig.gslbIp, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, all700no:PlayerConfig.all700ErrNo, errno:_loc_2.gslbNum + _loc_2.cdnNum, datarate:_video_arr[_currentIndex_uint].datarate});
                        }
                        else if (event.info.reason == "returnError")
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.GSLB_ERROR_RETURN, code:PlayerConfig.GSLB_CODE, split:(_currentIndex_uint + 1), dom:PlayerConfig.gslbIp, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, all700no:PlayerConfig.all700ErrNo, errno:_loc_2.gslbNum + _loc_2.cdnNum, datarate:_video_arr[_currentIndex_uint].datarate});
                        }
                        else if (event.info.reason == "302Error10Times")
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_302_10TIMES, code:PlayerConfig.GSLB_CODE, split:(_currentIndex_uint + 1), dom:PlayerConfig.gslbIp, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, all700no:PlayerConfig.all700ErrNo, errno:_loc_2.gslbNum + _loc_2.cdnNum, datarate:_video_arr[_currentIndex_uint].datarate});
                        }
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else if (_video_arr[_currentIndex_uint].retryNum > 0)
                    {
                        if ((_video_arr[_currentIndex_uint].retryNum - 1) <= 1)
                        {
                            _video_arr[_currentIndex_uint].ns.changeGSLBIP = true;
                        }
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_8:* = _video_arr[_currentIndex_uint];
                        var _loc_9:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_8.retryNum = _loc_9;
                        this._owner.bbb();
                    }
                    break;
                }
                case "GSLB.Success":
                {
                    _loc_5 = _video_arr[_currentIndex_uint].iserr ? ("2") : ("1");
                    break;
                }
                case "NetStream.Play.Start":
                {
                    _video_arr[_currentIndex_uint].isAbend = false;
                    var _loc_8:* = _loc_2;
                    _loc_8._loc_2["clearCdnTimeout"]();
                    _video_arr[_currentIndex_uint].cdnuse = _loc_2.cdnuse;
                    _video_arr[_currentIndex_uint].iserr = false;
                    dispatchEvent(new Event("NS.Play.Start"));
                    break;
                }
                case "NetStream.PQStat.Upload":
                {
                    this._qfStat.sendPQStat({isClipsVV:true, error:0, code:PlayerConfig.CDN_CODE, split:event.info.index, dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, cdnip:PlayerConfig.cdnIp, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                    break;
                }
                case "NoData.Drag.Start":
                {
                    dispatch(MediaEvent.DRAG_START);
                    dispatch(MediaEvent.CONNECTING);
                    break;
                }
                case "NoData.Drag.End":
                {
                    dispatch(MediaEvent.DRAG_END);
                    dispatch(MediaEvent.FULL);
                    break;
                }
                case "Webp2p.Rollback":
                {
                    LogManager.msg("Webp2p.Rollback:" + event.info.reason);
                    _loc_6 = event.info.cdnip != null ? (event.info.cdnip) : ("");
                    switch(event.info.reason)
                    {
                        case "rtmfpError":
                        {
                            this.sendP2PStat("1", _loc_6);
                            break;
                        }
                        case "trackError":
                        {
                            this.sendP2PStat("2", _loc_6);
                            break;
                        }
                        case "smallSuppliers":
                        {
                            this.sendP2PStat("3", _loc_6);
                            break;
                        }
                        case "blackscreen":
                        {
                            this.sendP2PStat("4", _loc_6);
                            break;
                        }
                        case "302Error":
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_302, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                            this.sendP2PStat("5", _loc_6);
                            break;
                        }
                        case "301cdnConError":
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_301_CONNECT_FAILED, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                            this.sendP2PStat("6", _loc_6);
                            break;
                        }
                        case "cdnConError":
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_CONNECT_FAILED, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate, isp2p:_loc_2.hasP2P ? (1) : (0)});
                            this.sendP2PStat("7", _loc_6);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    this.webP2PRollback();
                    break;
                }
                case "Webp2p.Rollback.InitFail":
                {
                    this.sendRBStat("0", event.info.reason ? (event.info.reason) : (""));
                    this.webP2PRollback();
                    break;
                }
                case "P2pcore.Init.Success":
                {
                    if (P2pSohuLib.getInstance().clientIp != null)
                    {
                        PlayerConfig.clientIp = String(P2pSohuLib.getInstance().clientIp);
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

        private function downLoadStreamStatus(event:NetStatusEvent) : void
        {
            var ns:TvSohuNetStream;
            var obj:Object;
            var evt:* = event;
            ns = _video_arr[_downloadIndex_uint].ns;
            switch(evt.info.code)
            {
                case "NetStream.Play.StreamNotFound":
                {
                    LogManager.msg("第" + _downloadIndex_uint + "段视频未找到！retryNum:" + _video_arr[_downloadIndex_uint].retryNum);
                    var _loc_3:* = ns;
                    _loc_3.ns["clearCdnTimeout"]();
                    _video_arr[_downloadIndex_uint].ns.addErrIp();
                    if (_video_arr[_downloadIndex_uint].retryNum == 0)
                    {
                        if (!_video_arr[_downloadIndex_uint].isSentQF)
                        {
                            _video_arr[_downloadIndex_uint].isSentQF = true;
                            var _loc_3:* = PlayerConfig;
                            var _loc_4:* = PlayerConfig.allErrNo + 1;
                            _loc_3.allErrNo = _loc_4;
                            var _loc_3:* = ns;
                            var _loc_4:* = ns.cdnNum + 1;
                            _loc_3.cdnNum = _loc_4;
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_NOTFOUND, code:PlayerConfig.CDN_CODE, split:(_downloadIndex_uint + 1), dom:ns.playUrl, allno:PlayerConfig.allErrNo, errno:ns.cdnNum + ns.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_downloadIndex_uint].datarate, isp2p:ns.hasP2P ? (1) : (0)});
                        }
                        if (_currentIndex_uint != _downloadIndex_uint && lastoutBuffer)
                        {
                            clearTimeout(this._intervalRetry);
                            this._intervalRetry = setTimeout(function () : void
            {
                LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
                _video_arr[_downloadIndex_uint].iserr = false;
                var _loc_1:* = ns;
                _loc_1.ns["setP2PTimeLimit"]();
                ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                return;
            }// end function
            , 10000);
                        }
                        else
                        {
                            _video_arr[_downloadIndex_uint].iserr = true;
                            dispatch(MediaEvent.DRAG_END);
                            ns.removeEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
                            dispatch(MediaEvent.NOTFOUND);
                            _video_arr[_downloadIndex_uint].retryNum = -1;
                        }
                    }
                    else
                    {
                        _video_arr[_downloadIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_downloadIndex_uint];
                        var _loc_4:* = _video_arr[_downloadIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                        var _loc_3:* = ns;
                        _loc_3.ns["setP2PTimeLimit"]();
                        ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                    }
                    break;
                }
                case "NetStream.Play.Start":
                {
                    _video_arr[_downloadIndex_uint].isAbend = false;
                    clearTimeout(this._intervalRetry);
                    var _loc_3:* = ns;
                    _loc_3.ns["clearCdnTimeout"]();
                    ns.dragTime = 0;
                    _video_arr[_downloadIndex_uint].cdnuse = ns.cdnuse;
                    _video_arr[_downloadIndex_uint].iserr = false;
                    if (_video_arr[_downloadIndex_uint].ns.isnp && _video_arr[_downloadIndex_uint].sendVV == false)
                    {
                        this._qfStat.sendPQStat({isClipsVV:true, error:0, code:PlayerConfig.CDN_CODE, split:(_downloadIndex_uint + 1), dom:ns.playUrl, drag:ns.dragTime, allno:PlayerConfig.allErrNo, errno:ns.cdnNum + ns.gslbNum, cdnid:PlayerConfig.cdnId, cdnip:PlayerConfig.cdnIp, datarate:_video_arr[_downloadIndex_uint].datarate, isp2p:ns.hasP2P ? (1) : (0)});
                        _video_arr[_downloadIndex_uint].ns.isnp = false;
                        _video_arr[_downloadIndex_uint].sendVV = true;
                    }
                    ns.removeEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
                    dispatchEvent(new Event("NS.Play.Start"));
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    LogManager.msg("第" + _downloadIndex_uint + "段视频加载失败！retryNum:" + _video_arr[_downloadIndex_uint].retryNum);
                    var _loc_3:* = ns;
                    _loc_3.ns["clearCdnTimeout"]();
                    if (_video_arr[_downloadIndex_uint].retryNum == 0)
                    {
                        if (!_video_arr[_downloadIndex_uint].isSentQF)
                        {
                            _video_arr[_downloadIndex_uint].isSentQF = true;
                            var _loc_3:* = PlayerConfig;
                            var _loc_4:* = PlayerConfig.allErrNo + 1;
                            _loc_3.allErrNo = _loc_4;
                            var _loc_3:* = ns;
                            var _loc_4:* = ns.cdnNum + 1;
                            _loc_3.cdnNum = _loc_4;
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_FAILED, code:PlayerConfig.CDN_CODE, split:(_downloadIndex_uint + 1), dom:ns.playUrl, allno:PlayerConfig.allErrNo, errno:ns.cdnNum + ns.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_downloadIndex_uint].datarate, isp2p:ns.hasP2P ? (1) : (0)});
                        }
                        if (_currentIndex_uint != _downloadIndex_uint && lastoutBuffer)
                        {
                            clearTimeout(this._intervalRetry);
                            this._intervalRetry = setTimeout(function () : void
            {
                LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
                _video_arr[_downloadIndex_uint].iserr = false;
                var _loc_1:* = ns;
                _loc_1.ns["setP2PTimeLimit"]();
                ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                return;
            }// end function
            , 10000);
                        }
                        else
                        {
                            _video_arr[_downloadIndex_uint].iserr = true;
                            dispatch(MediaEvent.DRAG_END);
                            ns.removeEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
                            dispatch(MediaEvent.NOTFOUND);
                            _video_arr[_downloadIndex_uint].retryNum = -1;
                        }
                    }
                    else
                    {
                        _video_arr[_downloadIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_downloadIndex_uint];
                        var _loc_4:* = _video_arr[_downloadIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                        var _loc_3:* = ns;
                        _loc_3.ns["setP2PTimeLimit"]();
                        ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                    }
                    break;
                }
                case "NetStream.Play.FileStructureInvalid":
                {
                    LogManager.msg("第" + _downloadIndex_uint + "段视频文件结构无效！retryNum:" + _video_arr[_downloadIndex_uint].retryNum);
                    var _loc_3:* = ns;
                    _loc_3.ns["clearCdnTimeout"]();
                    if (_video_arr[_downloadIndex_uint].retryNum == 0)
                    {
                        if (!_video_arr[_downloadIndex_uint].isSentQF)
                        {
                            _video_arr[_downloadIndex_uint].isSentQF = true;
                            var _loc_3:* = PlayerConfig;
                            var _loc_4:* = PlayerConfig.allErrNo + 1;
                            _loc_3.allErrNo = _loc_4;
                            var _loc_3:* = ns;
                            var _loc_4:* = ns.cdnNum + 1;
                            _loc_3.cdnNum = _loc_4;
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_FILESTRUCTUREINVALID, code:PlayerConfig.CDN_CODE, split:(_downloadIndex_uint + 1), dom:ns.playUrl, allno:PlayerConfig.allErrNo, errno:ns.cdnNum + ns.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_downloadIndex_uint].datarate, isp2p:ns.hasP2P ? (1) : (0)});
                        }
                        if (_currentIndex_uint != _downloadIndex_uint && lastoutBuffer)
                        {
                            clearTimeout(this._intervalRetry);
                            this._intervalRetry = setTimeout(function () : void
            {
                LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
                _video_arr[_downloadIndex_uint].iserr = false;
                var _loc_1:* = ns;
                _loc_1.ns["setP2PTimeLimit"]();
                ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                return;
            }// end function
            , 10000);
                        }
                        else
                        {
                            _video_arr[_downloadIndex_uint].iserr = true;
                            dispatch(MediaEvent.DRAG_END);
                            ns.removeEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
                            dispatch(MediaEvent.NOTFOUND);
                            _video_arr[_downloadIndex_uint].retryNum = -1;
                        }
                    }
                    else
                    {
                        _video_arr[_downloadIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_downloadIndex_uint];
                        var _loc_4:* = _video_arr[_downloadIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                        var _loc_3:* = ns;
                        _loc_3.ns["setP2PTimeLimit"]();
                        ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                    }
                    break;
                }
                case "Load.abend":
                {
                    if (_currentIndex_uint != _downloadIndex_uint)
                    {
                        LogManager.msg("第" + _downloadIndex_uint + "段视频加载异常终止！laRetryNum:" + _video_arr[_downloadIndex_uint].laRetryNum);
                        if (_video_arr[_downloadIndex_uint].laRetryNum == 0)
                        {
                            if (_currentIndex_uint != _downloadIndex_uint && lastoutBuffer)
                            {
                                clearTimeout(this._intervalRetry);
                                this._intervalRetry = setTimeout(function () : void
            {
                LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
                ns.removeEventListener(NetStatusEvent.NET_STATUS, downLoadStreamStatus);
                download(_downloadIndex_uint);
                return;
            }// end function
            , 10000);
                            }
                        }
                        else
                        {
                            var _loc_3:* = _video_arr[_downloadIndex_uint];
                            var _loc_4:* = _video_arr[_downloadIndex_uint].laRetryNum - 1;
                            _loc_3.laRetryNum = _loc_4;
                            ns.removeEventListener(NetStatusEvent.NET_STATUS, this.downLoadStreamStatus);
                            this.download(_downloadIndex_uint);
                        }
                    }
                    break;
                }
                case "CDNTimeout":
                {
                    LogManager.msg("第" + _downloadIndex_uint + "段视频CDN超时！retryNum:" + _video_arr[_downloadIndex_uint].retryNum);
                    if (_video_arr[_downloadIndex_uint].retryNum == 0)
                    {
                        if (!_video_arr[_downloadIndex_uint].isSentQF)
                        {
                            _video_arr[_downloadIndex_uint].isSentQF = true;
                            var _loc_3:* = PlayerConfig;
                            var _loc_4:* = PlayerConfig.allErrNo + 1;
                            _loc_3.allErrNo = _loc_4;
                            var _loc_3:* = ns;
                            var _loc_4:* = ns.cdnNum + 1;
                            _loc_3.cdnNum = _loc_4;
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_TIMEOUT, code:PlayerConfig.CDN_CODE, split:(_downloadIndex_uint + 1), dom:ns.playUrl, allno:PlayerConfig.allErrNo, errno:ns.cdnNum + ns.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_downloadIndex_uint].datarate, isp2p:ns.hasP2P ? (1) : (0)});
                        }
                        if (_currentIndex_uint != _downloadIndex_uint && lastoutBuffer)
                        {
                            clearTimeout(this._intervalRetry);
                            this._intervalRetry = setTimeout(function () : void
            {
                LogManager.msg("第" + _downloadIndex_uint + "段视频10秒循环重试！");
                _video_arr[_downloadIndex_uint].iserr = false;
                var _loc_1:* = ns;
                _loc_1.ns["setP2PTimeLimit"]();
                ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                return;
            }// end function
            , 10000);
                        }
                        else
                        {
                            _video_arr[_downloadIndex_uint].iserr = true;
                            dispatch(MediaEvent.NOTFOUND);
                            dispatch(MediaEvent.DRAG_END);
                            _video_arr[_downloadIndex_uint].retryNum = -1;
                        }
                    }
                    else
                    {
                        _video_arr[_downloadIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_downloadIndex_uint];
                        var _loc_4:* = _video_arr[_downloadIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                        var _loc_3:* = ns;
                        _loc_3.ns["setP2PTimeLimit"]();
                        ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                    }
                    break;
                }
                case "GSLB.Success":
                {
                    break;
                }
                case "GSLB.Failed":
                {
                    LogManager.msg("第" + _downloadIndex_uint + "段视频调度失败！retryNum:" + _video_arr[_downloadIndex_uint].retryNum + " reason:" + evt.info.reason);
                    if (_video_arr[_downloadIndex_uint].retryNum == 0)
                    {
                        _video_arr[_downloadIndex_uint].iserr = true;
                        obj;
                        dispatch(MediaEvent.NOTFOUND, obj);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_3:* = PlayerConfig;
                        var _loc_4:* = PlayerConfig.all700ErrNo + 1;
                        _loc_3.all700ErrNo = _loc_4;
                        if (evt.info.reason == "timeout")
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.GSLB_ERROR_TIMEOUT, code:PlayerConfig.GSLB_CODE, split:(_downloadIndex_uint + 1), dom:PlayerConfig.gslbIp, allno:PlayerConfig.allErrNo, all700no:PlayerConfig.all700ErrNo, errno:ns.gslbNum + ns.cdnNum, datarate:_video_arr[_downloadIndex_uint].datarate});
                        }
                        else if (evt.info.reason == "ioerror")
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.GSLB_ERROR_FAILED, code:PlayerConfig.GSLB_CODE, split:(_downloadIndex_uint + 1), dom:PlayerConfig.gslbIp, allno:PlayerConfig.allErrNo, all700no:PlayerConfig.all700ErrNo, errno:ns.gslbNum + ns.cdnNum, datarate:_video_arr[_downloadIndex_uint].datarate});
                        }
                        _video_arr[_downloadIndex_uint].retryNum = -1;
                    }
                    else
                    {
                        if ((_video_arr[_downloadIndex_uint].retryNum - 1) <= 1)
                        {
                            _video_arr[_downloadIndex_uint].ns.changeGSLBIP = true;
                        }
                        _video_arr[_downloadIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_downloadIndex_uint];
                        var _loc_4:* = _video_arr[_downloadIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                        ns.retry(_video_arr[_downloadIndex_uint].flv + (_startTime > 0 ? ("?start=" + _startTime) : ("")));
                    }
                    break;
                }
                case "Webp2p.Rollback":
                {
                    this.webP2PRollback();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function sendRBStat(param1:String, param2:String = "") : void
        {
            var _loc_3:* = param2 != "" ? ("&cdnip=" + param2) : ("");
            var _loc_4:* = "&channelId=" + String(PlayerConfig.catcode).substr(0, 3);
            var _loc_5:* = "http://pv.hd.sohu.com/p.gif?pid=" + PlayerConfig.pid + "&playlistid=" + PlayerConfig.vrsPlayListId + "&vid=" + PlayerConfig.currentVid + "&cateid=" + PlayerConfig.plcatid + "&c=0" + "&nid=" + PlayerConfig.channel + "&ua=" + (PlayerConfig.SOHUTEST ? ("sohutest") : ("wp3")) + "&t=0" + "&yid=" + PlayerConfig.yyid + "&cnt=" + "&uid=" + PlayerConfig.userId + "&errType=" + param1 + _loc_4 + "&url=" + PlayerConfig.currentPageUrl + "&n=" + new Date().getTime() + "&uuid=" + PlayerConfig.uuid + _loc_3;
            new URLLoaderUtil().send(_loc_5);
            return;
        }// end function

        private function downNewVideoInfo() : void
        {
            if (PlayerConfig.isLive && PlayerConfig.isP2PLive && PlayerConfig.hashId[(_downloadIndex_uint + 1)] == undefined)
            {
                new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                var _loc_3:uint = 0;
                var _loc_4:String = null;
                if (param1.info == "success")
                {
                    LogManager.msg("追加内容下载成功， 追加内容：" + param1.data);
                    _loc_2 = new JSON().parse(param1.data);
                    if (_loc_2 != null && _loc_2.status == 1)
                    {
                        _loc_3 = 0;
                        while (_loc_3 < _loc_2.clipsURL.length)
                        {
                            
                            PlayerConfig.hashId.push(_loc_2.hc.shift());
                            PlayerConfig.key.push(_loc_2.ck.shift());
                            PlayerConfig.synUrl.push(_loc_2.su.shift());
                            _loc_4 = _loc_2.clipsBytes.shift();
                            PlayerConfig.fileSize.push(_loc_4);
                            addClipItem(_loc_2.clipsURL.shift(), _loc_2.clipsDuration.shift(), _loc_2.clipsBytes.shift(), _video_arr.length);
                            _loc_3 = _loc_3 + 1;
                        }
                    }
                    else
                    {
                        LogManager.msg("无可追加内容：" + param1.data);
                    }
                }
                else
                {
                    LogManager.msg("追加内容下载失败，下载段号：" + _downloadIndex_uint + " 失败原因：" + param1.info);
                }
                return;
            }// end function
            , "http://live.tv.sohu.com/live/currSplit_json.jhtml?lid=" + PlayerConfig.vid + "&hashid=" + PlayerConfig.hashId[(PlayerConfig.hashId.length - 1)] + "&type=" + PlayerConfig.liveType + "&m=" + getTimer());
            }
            return;
        }// end function

        private function addClipItem(param1:String, param2:String, param3:String, param4:uint) : void
        {
            return;
        }// end function

        override protected function checkLastoutBuffer() : void
        {
            if (PlayerConfig.isLive && PlayerConfig.isP2PLive)
            {
                if ((_video_arr[_downloadIndex_uint].download == "loaded" || _video_arr[_downloadIndex_uint].download == "part_loaded") && _downloadIndex_uint < (_video_arr.length - 1) && PlayerConfig.hashId[(_downloadIndex_uint + 1)] != "")
                {
                    if (_video_arr[(_downloadIndex_uint + 1)].download == "no")
                    {
                        this.download((_downloadIndex_uint + 1));
                    }
                }
            }
            else
            {
                super.checkLastoutBuffer();
            }
            return;
        }// end function

        private function setPredictMode() : void
        {
            if (PlayerConfig.availableStvd && PlayerConfig.recordSvdMode != 0)
            {
                TvSohuVideo.predictMode = TvSohuVideo.STG_VIDEO_MODE;
                PlayerConfig.stvdInUse = true;
                _bg_spr.visible = false;
                this.changeStvWHXY();
                this.setSvdNextStream();
            }
            else
            {
                TvSohuVideo.predictMode = TvSohuVideo.VIDEO_MODE;
                PlayerConfig.stvdInUse = false;
                _bg_spr.visible = true;
            }
            return;
        }// end function

        private function setSvdNextStream() : void
        {
            if (PlayerConfig.availableStvd && PlayerConfig.recordSvdMode != 0)
            {
                if (TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE)
                {
                    if (PlayerConfig.isWebP2p || PlayerConfig.is56)
                    {
                        _video_arr[_currentIndex_uint].ns.attachVideoToStream(_video_arr[_currentIndex_uint].video);
                    }
                    else
                    {
                        _video_arr[_currentIndex_uint].video.attachSvdCurStream(_video_arr[_currentIndex_uint].ns);
                    }
                    if (_currentIndex_uint < (_video_arr.length - 1))
                    {
                        _video_arr[_currentIndex_uint].video.attachSvdNextStream(_video_arr[(_currentIndex_uint + 1)].ns);
                    }
                    else
                    {
                        _video_arr[_currentIndex_uint].video.attachSvdNextStream(null);
                    }
                }
                else if (PlayerConfig.isWebP2p || PlayerConfig.is56)
                {
                    _video_arr[_currentIndex_uint].ns.attachVideoToStream(_video_arr[_currentIndex_uint].video);
                }
                else
                {
                    _video_arr[_currentIndex_uint].video.attachNetStream(_now_ns);
                }
            }
            return;
        }// end function

        public function toggleVideoMode() : void
        {
            PlayerConfig.recordSvdMode = -1;
            if (PlayerConfig.availableStvd && !PlayerConfig.stvdInUse)
            {
                if (TvSohuVideo.predictMode == TvSohuVideo.VIDEO_MODE)
                {
                    PlayerConfig.stvdInUse = true;
                    TvSohuVideo.predictMode = TvSohuVideo.STG_VIDEO_MODE;
                    _bg_spr.visible = false;
                    this.changeStvWHXY();
                }
                else
                {
                    PlayerConfig.stvdInUse = false;
                    TvSohuVideo.predictMode = TvSohuVideo.VIDEO_MODE;
                    _bg_spr.visible = true;
                }
            }
            else
            {
                TvSohuVideo.predictMode = TvSohuVideo.VIDEO_MODE;
                PlayerConfig.stvdInUse = false;
                _bg_spr.visible = true;
            }
            this.setSvdNextStream();
            _video_arr[_currentIndex_uint].video.visible = true;
            return;
        }// end function

        private function saveSvdMode() : void
        {
            if (TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE && PlayerConfig.stvdInUse)
            {
                PlayerConfig.recordSvdMode = 1;
            }
            else if (TvSohuVideo.predictMode == TvSohuVideo.VIDEO_MODE && !PlayerConfig.stvdInUse)
            {
                PlayerConfig.recordSvdMode = 0;
            }
            return;
        }// end function

        private function changeStvWHXY() : void
        {
            if (PlayerConfig.availableStvd && PlayerConfig.stvdInUse && TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE && PlayerConfig.recordSvdMode != 0)
            {
                TvSohuVideo.updateSvdWHXY(_video_c.width, _video_c.height, _video_c.x, _video_c.y);
            }
            return;
        }// end function

        private function sendP2PStat(param1:String = "", param2:String = "") : void
        {
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:String = null;
            var _loc_13:String = null;
            var _loc_14:String = null;
            var _loc_15:String = null;
            var _loc_16:String = null;
            var _loc_3:Number = 0;
            var _loc_4:* = new URLLoaderUtil();
            var _loc_5:Number = 0;
            var _loc_6:Number = 0;
            var _loc_7:Number = 0;
            var _loc_8:Number = 0;
            _loc_3 = _loc_3 + 1;
            try
            {
                if (P2pSohuLib.getInstance() != null && P2pSohuLib.getInstance().filesManager != null && P2pSohuLib.getInstance().filesManager.staticO != null)
                {
                    _loc_9 = P2pSohuLib.getInstance().filesManager.staticO.c;
                    _loc_10 = P2pSohuLib.getInstance().filesManager.staticO.p;
                    _loc_11 = P2pSohuLib.getInstance().filesManager.staticO.ifoxp;
                    _loc_5 = _loc_9 - this._lastTimeCDNBytes;
                    _loc_6 = _loc_10 - this._lastTimePeerBytes;
                    _loc_7 = _loc_5 + _loc_6;
                    _loc_8 = _loc_11 - this._lastTimeIfoxPBytes;
                    this._lastTimeCDNBytes = _loc_9;
                    this._lastTimePeerBytes = _loc_10;
                    this._lastTimeIfoxPBytes = _loc_11;
                }
            }
            catch (evt)
            {
            }
            if (PlayerConfig.isWebP2p && (_loc_5 > 0 || _loc_6 > 0 || _loc_11 > 0 || param1 == "4" || param1 == "6"))
            {
                if (param1 != "")
                {
                    var _loc_17:int = 0;
                    _loc_6 = 0;
                    var _loc_17:* = _loc_17;
                    _loc_5 = _loc_17;
                    _loc_8 = _loc_17;
                }
                _loc_12 = "";
                _loc_13 = String(PlayerConfig.catcode).substr(0, 3);
                if (_loc_13 == "115" || _loc_13 == "106" || _loc_13 == "100")
                {
                    _loc_12 = "&channelId=" + _loc_13;
                }
                _loc_14 = PlayerConfig.ta_jm != "" ? ("&ta=" + escape(PlayerConfig.ta_jm)) : ("");
                _loc_15 = param2 != "" ? ("&cdnip=" + param2) : ("");
                _loc_16 = "http://pv.hd.sohu.com/p.gif?pid=" + PlayerConfig.pid + "&playlistid=" + PlayerConfig.vrsPlayListId + "&vid=" + PlayerConfig.currentVid + "&clientIp=" + PlayerConfig.clientIp + "&cateid=" + PlayerConfig.plcatid + "&ifoxp=" + _loc_8 + "&c=" + _loc_5 + "&nid=" + PlayerConfig.channel + "&ua=" + (PlayerConfig.SOHUTEST ? ("sohutest") : ("wp3")) + "&t=" + _loc_7 + "&yid=" + PlayerConfig.yyid + "&cnt=" + "&uid=" + PlayerConfig.userId + _loc_14 + "&errType=" + param1 + _loc_12 + "&url=" + PlayerConfig.currentPageUrl + "&n=" + new Date().getTime() + "&uuid=" + PlayerConfig.uuid + _loc_15;
                if (!PlayerConfig.ISTEST || PlayerConfig.ISTEST && (PlayerConfig.currentVid == "717990" || PlayerConfig.currentVid == "1782553" || PlayerConfig.currentVid == "1710392"))
                {
                    _loc_4.send(_loc_16);
                }
            }
            return;
        }// end function

    }
}
