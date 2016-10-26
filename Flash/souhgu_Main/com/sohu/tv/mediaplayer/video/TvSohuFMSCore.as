package com.sohu.tv.mediaplayer.video
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.core.*;
    import ebing.events.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.events.*;
    import flash.media.*;
    import flash.utils.*;

    public class TvSohuFMSCore extends FMSCore
    {
        private var _addChildId:Number = 0;
        private var _ncRetryNum:Number = 2;
        private var _totBufferNum:Number = 0;
        private var _qfStat:ErrorSenderPQ;
        private var _displayRate:Number = 1;
        private var _scaleWidth:Number = 0;
        private var _scaleHeight:Number = 0;
        private var _scaleState:String = "meta";
        private var _connectTimer:Number = 0;
        private var _bufferSpend:uint = 0;
        private var _rotateType:int = 0;
        private var _videoArr:Array;
        private var _isDirectRotation:Boolean = false;
        private var _coreTempTime:Number = 0;
        private var _softInitObj:Object;

        public function TvSohuFMSCore(param1:Object)
        {
            this._videoArr = new Array();
            super(param1);
            this._qfStat = ErrorSenderPQ.getInstance();
            return;
        }// end function

        public function get lastoutBuffer() : Boolean
        {
            return false;
        }// end function

        override public function initMedia(param1:Object) : void
        {
            var _loc_9:uint = 0;
            this._softInitObj = param1;
            var _loc_2:* = param1.flv;
            var _loc_3:* = param1.time;
            var _loc_4:* = param1.size;
            _isGained = false;
            _vTotTime_num = 0;
            _fileSize_num = 0;
            if (_video_arr != null)
            {
                _loc_9 = 0;
                while (_loc_9 < _video_arr.length)
                {
                    
                    _video_arr[_loc_9].ns.removeEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
                    _video_arr[_loc_9].ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
                    _video_arr[_loc_9].ns.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                    _video_c.removeChild(_video_arr[_loc_9].video);
                    _loc_9 = _loc_9 + 1;
                }
                _video_arr.splice(0);
            }
            var _loc_5:* = _loc_2.split(",");
            var _loc_6:* = _loc_3.split(",");
            var _loc_7:* = _loc_4.split(",");
            _video_arr = new Array();
            var _loc_8:uint = 0;
            while (_loc_8 < _loc_5.length)
            {
                
                _video_arr[_loc_8] = {flv:_loc_5[_loc_8], video:new Video(), start:_loc_8 == 0 ? (0) : ((_vTotTime_num + 1)), end:_loc_8 == 0 ? (_loc_6[_loc_8]) : (_vTotTime_num + Number(_loc_6[_loc_8])), download:"no", ns:new NetStreamUtil(_my_nc), time:Number(_loc_6[_loc_8]), size:Number(_loc_7[_loc_8]), iserr:false, datastart:0, dataend:0, duration:Number(_loc_6[_loc_8]), gotMetaData:false, isnp:true, sendVV:false, datarate:Math.floor(Number(_loc_7[_loc_8]) * 8 / 1000 / Number(_loc_6[_loc_8]))};
                _vTotTime_num = _vTotTime_num + Number(_loc_6[_loc_8]);
                _fileSize_num = _fileSize_num + Number(_loc_7[_loc_8]);
                _video_arr[_loc_8].video.smoothing = true;
                _video_arr[_loc_8].video.attachNetStream(_video_arr[_loc_8].ns);
                _video_arr[_loc_8].ns.bufferTime = _buffer_num;
                _video_arr[_loc_8].video.visible = false;
                _video_arr[_loc_8].ns.client = _clientTem_obj;
                _video_arr[_loc_8].ns.clipNo = _loc_8;
                _video_c.addChild(_video_arr[_loc_8].video);
                this._videoArr.push(_video_arr[_loc_8].video);
                _loc_8 = _loc_8 + 1;
            }
            addChild(_video_c);
            this.refresh(false);
            this.resize(_width_num, _height_num);
            _video_arr[0].ns.addEventListener(NetStatusEvent.NET_STATUS, this.onStatus);
            _video_arr[0].ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            _video_arr[0].ns.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _video_arr[0].ns.client = _client_obj;
            _now_ns = _video_arr[0].ns;
            _video_arr[0].video.visible = true;
            this.initVolume();
            sysInit();
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

        override protected function connectNC() : void
        {
            LogManager.msg("开始连接FMS服务器！ 地址：" + _rtmpeUrl);
            super.connectNC();
            clearTimeout(this._connectTimer);
            this._connectTimer = setTimeout(this.connectTimeout, 10 * 1000);
            return;
        }// end function

        private function connectTimeout() : void
        {
            _my_nc.close();
            return;
        }// end function

        override protected function netStatusHandler(event:NetStatusEvent) : void
        {
            var evt:* = event;
            Utils.debug(evt.info.code);
            switch(evt.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    clearTimeout(this._connectTimer);
                    if (_sysInited)
                    {
                        if (_sysStatus_str == "3")
                        {
                            seek(_startTime);
                            this.play();
                        }
                        else if (_sysStatus_str == "4")
                        {
                            seek(_startTime);
                        }
                    }
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    if (!_doNCClose)
                    {
                        var _loc_3:String = this;
                        _loc_3._ncRetryNum = this._ncRetryNum - 1;
                        if (this._ncRetryNum-- > 0)
                        {
                            setTimeout(function () : void
            {
                _rtmpeUrl = _rtmpeUrl.replace("rtmpe", "rtmpte");
                connectNC();
                return;
            }// end function
            , 500);
                        }
                        else if (this._ncRetryNum <= 0)
                        {
                            this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_NETCONNECTION, code:PlayerConfig.CDN_CODE, split:0, dom:_rtmpeUrl ? (_rtmpeUrl) : (""), drag:-1, allno:1, errno:1, cdnid:PlayerConfig.cdnId, datarate:0});
                            dispatch(MediaEvent.NC_RETRY_FAILED);
                        }
                    }
                    break;
                }
                case "NetConnection.Connect.Failed":
                {
                    var _loc_3:String = this;
                    _loc_3._ncRetryNum = this._ncRetryNum - 1;
                    if (this._ncRetryNum-- > 0)
                    {
                        setTimeout(function () : void
            {
                _rtmpeUrl = _rtmpeUrl.replace("rtmpe", "rtmpte");
                connectNC();
                return;
            }// end function
            , 500);
                    }
                    else if (this._ncRetryNum <= 0)
                    {
                        this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_NCFAILED, code:PlayerConfig.CDN_CODE, split:0, dom:_rtmpeUrl ? (_rtmpeUrl) : (""), drag:-1, allno:1, errno:1, cdnid:PlayerConfig.cdnId, datarate:0});
                        dispatch(MediaEvent.NC_RETRY_FAILED);
                    }
                    break;
                }
                case "NetConnection.Connect.IdleTimeout":
                {
                    LogManager.msg("FMS服务器超时!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                    break;
                }
                default:
                {
                    break;
                }
            }
            super.netStatusHandler(evt);
            return;
        }// end function

        override protected function timerHandler(event:TimerEvent) : void
        {
            aboutTime();
            if (Math.ceil(getNSTime(_now_ns) * 10) >= Math.floor(_video_arr[_currentIndex_uint].duration * 10) && _video_arr[_currentIndex_uint].duration != 0 || Math.ceil(getNSTime(_now_ns) * 10) >= Math.floor(fileTotTime * 10))
            {
                Utils.debug("timerHandler:" + _stopFlag_boo + " _now_ns.time:" + _now_ns.time + " duration:" + _video_arr[_currentIndex_uint].duration);
                if (_stopFlag_boo)
                {
                    judgeStop();
                }
                else
                {
                    _stopFlag_boo = true;
                }
            }
            event.updateAfterEvent();
            return;
        }// end function

        override public function get vrate() : Number
        {
            return _video_arr[_downloadIndex_uint].datarate;
        }// end function

        public function displayZoom(param1:Number = 1) : void
        {
            if (param1 > 0 && param1 <= 1)
            {
                this._displayRate = param1;
                Utils.prorata(_video_c, this._displayRate * _bg_spr.width, this._displayRate * _bg_spr.height);
                Utils.setCenter(_video_c, _bg_spr);
            }
            return;
        }// end function

        public function displayTo4_3(event:Event) : void
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

        public function displayTo16_9(event:Event) : void
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

        public function displayToMeta(event:Event) : void
        {
            this._scaleState = "meta";
            var _loc_2:int = 0;
            this._scaleHeight = 0;
            this._scaleWidth = _loc_2;
            this.resize(_width_num, _height_num);
            return;
        }// end function

        public function displayToFull(event:Event) : void
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

        override public function play(param1 = null) : void
        {
            this._coreTempTime = new Date().getTime();
            super.play(param1);
            return;
        }// end function

        public function get coreTempTime() : Number
        {
            return this._coreTempTime;
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

        override public function stop(param1 = null) : void
        {
            super.stop(param1);
            this.initMedia(this._softInitObj);
            return;
        }// end function

        override protected function onStatus(event:NetStatusEvent) : void
        {
            super.onStatus(event);
            var _loc_2:* = _video_arr[_currentIndex_uint].ns;
            switch(event.info.code)
            {
                case "NetStream.Buffer.Empty":
                {
                    if (!_isBufferFlush && _loc_2.bufferLength < _loc_2.bufferTime)
                    {
                        var _loc_3:* = _loc_2;
                        var _loc_4:* = _loc_2.bufferNum + 1;
                        _loc_3.bufferNum = _loc_4;
                        var _loc_3:String = this;
                        var _loc_4:* = this._totBufferNum + 1;
                        _loc_3._totBufferNum = _loc_4;
                        this._bufferSpend = getTimer();
                        this._qfStat.sendPQStat({error:1, code:PlayerConfig.BUFFER_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, ontime:_loc_2.time, bufno:_loc_2.bufferNum, allbufno:this._totBufferNum, datarate:_video_arr[_currentIndex_uint].datarate});
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    if (this._totBufferNum == 1 && this._bufferSpend > 0)
                    {
                        this._qfStat.sendPQStat({error:0, code:PlayerConfig.BUFFER_FULL_CODE, bd:getTimer() - this._bufferSpend, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, ontime:_loc_2.time, bufno:_loc_2.bufferNum, allbufno:this._totBufferNum, datarate:_video_arr[_currentIndex_uint].datarate});
                        this._bufferSpend = 0;
                    }
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (PlayerConfig.allErrNo == 0 && this._totBufferNum == 0 && _video_arr[_currentIndex_uint].ns.time > 0 && _video_arr[_currentIndex_uint].ns.time + 30 < _video_arr[_currentIndex_uint].time)
                    {
                        this._qfStat.sendPQStat({error:0, code:99, ontime:_video_arr[_currentIndex_uint].ns.time, dom:_loc_2.playUrl, drag:_loc_2.dragTime, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId});
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    _video_arr[_currentIndex_uint].ns.destroyLocation();
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_3:* = PlayerConfig;
                        var _loc_4:* = PlayerConfig.allErrNo + 1;
                        _loc_3.allErrNo = _loc_4;
                        var _loc_3:* = _loc_2;
                        var _loc_4:* = _loc_2.cdnNum + 1;
                        _loc_3.cdnNum = _loc_4;
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else
                    {
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_currentIndex_uint];
                        var _loc_4:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                    }
                    this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_NOTFOUND, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate});
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    LogManager.msg("第" + _currentIndex_uint + "段[视频]加载失败！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_3:* = PlayerConfig;
                        var _loc_4:* = PlayerConfig.allErrNo + 1;
                        _loc_3.allErrNo = _loc_4;
                        var _loc_3:* = _loc_2;
                        var _loc_4:* = _loc_2.cdnNum + 1;
                        _loc_3.cdnNum = _loc_4;
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else
                    {
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_currentIndex_uint];
                        var _loc_4:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                    }
                    this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_FAILED, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate});
                    break;
                }
                case "NetStream.Play.FileStructureInvalid":
                {
                    LogManager.msg("第" + _currentIndex_uint + "段[视频]文件结构无效！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_3:* = PlayerConfig;
                        var _loc_4:* = PlayerConfig.allErrNo + 1;
                        _loc_3.allErrNo = _loc_4;
                        var _loc_3:* = _loc_2;
                        var _loc_4:* = _loc_2.cdnNum + 1;
                        _loc_3.cdnNum = _loc_4;
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else
                    {
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_currentIndex_uint];
                        var _loc_4:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                    }
                    this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_FAILED, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate});
                    break;
                }
                case "CDNTimeout":
                {
                    LogManager.msg("第" + _currentIndex_uint + "段[视频]CDN超时！retryNum:" + _video_arr[_currentIndex_uint].retryNum);
                    if (_video_arr[_currentIndex_uint].retryNum == 0)
                    {
                        _video_arr[_currentIndex_uint].iserr = true;
                        dispatch(MediaEvent.RETRY_FAILED);
                        dispatch(MediaEvent.NOTFOUND);
                        dispatch(MediaEvent.DRAG_END);
                        var _loc_3:* = PlayerConfig;
                        var _loc_4:* = PlayerConfig.allErrNo + 1;
                        _loc_3.allErrNo = _loc_4;
                        var _loc_3:* = _loc_2;
                        var _loc_4:* = _loc_2.cdnNum + 1;
                        _loc_3.cdnNum = _loc_4;
                        _video_arr[_currentIndex_uint].retryNum = -1;
                    }
                    else
                    {
                        _video_arr[_currentIndex_uint].iserr = false;
                        var _loc_3:* = _video_arr[_currentIndex_uint];
                        var _loc_4:* = _video_arr[_currentIndex_uint].retryNum - 1;
                        _loc_3.retryNum = _loc_4;
                    }
                    this._qfStat.sendPQStat({error:PlayerConfig.CDN_ERROR_TIMEOUT, code:PlayerConfig.CDN_CODE, split:(_currentIndex_uint + 1), dom:_loc_2.playUrl, drag:_loc_2.dragTime, allno:PlayerConfig.allErrNo, errno:_loc_2.cdnNum + _loc_2.gslbNum, cdnid:PlayerConfig.cdnId, datarate:_video_arr[_currentIndex_uint].datarate});
                    break;
                }
                case "NetStream.Play.Start":
                {
                    _video_arr[_currentIndex_uint].cdnuse = _loc_2.cdnuse;
                    _video_arr[_currentIndex_uint].iserr = false;
                    if (_video_arr[_currentIndex_uint].isnp && _video_arr[_currentIndex_uint].sendVV == false)
                    {
                        _video_arr[_currentIndex_uint].isnp = false;
                        _video_arr[_currentIndex_uint].sendVV = true;
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

    }
}
