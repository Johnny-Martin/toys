package com.sohu.tv.mediaplayer.netstream
{
    import ebing.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class SegmentManager extends TvSohuNetStream
    {
        private var SEGMENT_FILE_SIZE:Number = 3.14573e+007;
        private var PRE_LOAD_TIME:Number = 15;
        private var PLAY_END_NOTICE_TIME:Number = 10;
        private var videoContainer:MovieClip;
        private var segmentList:Array;
        private var volume:SoundTransform;
        private var is_start_render:Boolean = false;
        private var url:String;
        private var activeSegment:Segment;
        private var playHeadTime:Number = 0;
        private var playHeadTimeCheckSt:Number = 0;
        private var metaData:Object;
        private var hasSendMetaData:Boolean = false;
        private var codecH:Array;
        private var codecStatus:String = "h.263";
        private var is_use_segment_mode:Boolean = true;
        private var duration:Number = 0;
        private var times:Array;
        private var positions:Array;
        private var bitRate:Number = 0;
        private var fileSize:Number = 0;
        private var _nc:NetConnection;
        private var _video:Video = null;
        private var checkTimer:Timer;
        private var timer:Timer;
        private var errorType:String = "";
        private var clientObj:Object;
        private var __onStreamPlayStop:Boolean = false;
        private var seekTime:Number = 0;
        private var isSohu:Boolean = false;
        private var sohuKeyframes:Array;

        public function SegmentManager(param1:NetConnection, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false)
        {
            this.segmentList = new Array();
            this.codecH = [0, 0];
            this.clientObj = new Object();
            this.isSohu = param4;
            this._nc = param1;
            super(param1, param2, param3);
            return;
        }// end function

        public function init(param1:String, param2:Boolean = true, param3:Number = 40) : void
        {
            this.SEGMENT_FILE_SIZE = param3 * 1024 * 1024;
            this.url = param1;
            this.is_use_segment_mode = param2;
            this.activeSegment = new Segment(this._nc, this.is_use_segment_mode, this.isSohu);
            this.activeSegment.addEventListener("__onStreamStatus", this.__onStreamStatus);
            this.activeSegment.init(this.url);
            this.timer = new Timer(100);
            this.timer.addEventListener(TimerEvent.TIMER, this.render);
            this.timer.start();
            return;
        }// end function

        private function onCheckTimeoutHandler(event:TimerEvent) : void
        {
            this.checkTimer.stop();
            this.checkTimer.removeEventListener(TimerEvent.TIMER, this.onCheckTimeoutHandler);
            if (this.metaData == null && !this.isSohu)
            {
                this.errorType = "0";
                this.dispatchEvent(new Event("PFVNetStreamError"));
            }
            return;
        }// end function

        public function get PFVErrorType() : String
        {
            return this.errorType;
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
            this.checkTimer = new Timer(10000, 1);
            this.checkTimer.addEventListener(TimerEvent.TIMER, this.onCheckTimeoutHandler);
            this.checkTimer.start();
            this.activeSegment.setActivate(true, _isPlay);
            this.activeSegment.playToUrl();
            this.__onStreamPlayStop = false;
            return;
        }// end function

        public function attachVideoToStream(param1:Video) : void
        {
            this._video = param1;
            this.activeSegment.attachVideoToStream(this._video);
            return;
        }// end function

        public function onMetaDataGet(param1:Object) : void
        {
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Segment = null;
            this.checkTimer.stop();
            this.checkTimer.removeEventListener(TimerEvent.TIMER, this.onCheckTimeoutHandler);
            if (this.metaData != null)
            {
                return;
            }
            this.metaData = param1;
            var _loc_2:* = this.metaData;
            if (!this.isSohu)
            {
                this.times = _loc_2.keyframes.times;
                this.positions = _loc_2.keyframes.filepositions;
                this.bitRate = _loc_2.videodatarate;
                this.fileSize = _loc_2.filesize;
                _loc_5 = _loc_2.videocodecid;
                this.codecH = [this.positions[0], this.positions[1]];
                if (this.times[0] == 0 && this.times[1] == 0 && _loc_5 == 7)
                {
                    this.codecH = [this.positions[0], this.positions[1]];
                    this.codecStatus = "h264";
                }
                else if (_loc_5 == 7)
                {
                    this.codecH = [this.positions[0], this.positions[1]];
                    this.codecStatus = "error";
                    if (this.is_use_segment_mode)
                    {
                        this.is_use_segment_mode = false;
                        try
                        {
                            this.activeSegment.removeEventListener("__onStreamStatus", this.__onStreamStatus);
                        }
                        catch (evt)
                        {
                        }
                        this.activeSegment.gc();
                        this.dispatchEvent(new Event("__onStreamH264Error"));
                        return;
                    }
                }
                else
                {
                    this.codecH = [0, 0];
                    this.codecStatus = "h263";
                }
            }
            else
            {
                this.is_use_segment_mode = false;
                this.bitRate = 0;
                this.sohuKeyframes = _loc_2.seekpoints;
            }
            this.duration = _loc_2.duration;
            var _loc_3:* = this.activeSegment;
            _loc_3.setSeekInitData([0, -1], [0, this.duration], this.codecH);
            this.configSegmentEvent(_loc_3);
            this.segmentList.push(_loc_3);
            if (this.is_use_segment_mode)
            {
                if (this.fileSize > this.activeSegment.getTotalBytes())
                {
                    _loc_6 = 0;
                    _loc_7 = 0;
                    while (_loc_6 < this.positions[(this.positions.length - 1)])
                    {
                        
                        if (_loc_6 == 0)
                        {
                            _loc_8 = this.getSegmentEndByteByPos(_loc_3.getTotalBytes());
                            _loc_3.setSeekInitData([0, this.positions[_loc_8]], [0, this.times[_loc_8]], this.codecH);
                            _loc_6 = this.positions[_loc_8];
                            _loc_7 = this.times[_loc_8];
                            continue;
                        }
                        _loc_9 = _loc_6;
                        _loc_10 = _loc_7;
                        _loc_8 = this.getSegmentEndByteByPos(_loc_6 + this.SEGMENT_FILE_SIZE);
                        _loc_11 = this.times[_loc_8];
                        _loc_6 = this.positions[_loc_8];
                        _loc_7 = this.times[_loc_8];
                        _loc_12 = _loc_6;
                        if (_loc_6 >= this.positions[(this.positions.length - 1)])
                        {
                            _loc_12 = -1;
                        }
                        _loc_13 = new Segment(this._nc, this.is_use_segment_mode, this.isSohu);
                        _loc_13.init(this.url);
                        _loc_13.setSeekInitData([_loc_9, _loc_12], [_loc_10, _loc_11], this.codecH);
                        this.segmentList.push(_loc_13);
                        this.configSegmentEvent(_loc_13);
                    }
                }
                else
                {
                    this.is_use_segment_mode = false;
                }
            }
            var _loc_4:int = 0;
            while (_loc_4 < this.segmentList.length)
            {
                
                _loc_13 = this.segmentList[_loc_4];
                _loc_13.addEventListener("netstream_buffer_full", this.netstream_buffer);
                _loc_13.addEventListener("netstream_buffer_empty", this.netstream_buffer);
                _loc_4++;
            }
            this.setActivateSegment(_loc_3);
            if (!this.isSohu)
            {
            }
            this.is_start_render = true;
            if (this.codecStatus == "error")
            {
            }
            else
            {
                this.hasSendMetaData = true;
                this.dispatchEvent(new MyVideoEvent("__onStreamMetaDataGet", _loc_2));
            }
            if (this.duration != 0 && this.seekTime != 0)
            {
                this.seek(this.seekTime);
                this.seekTime = 0;
            }
            return;
        }// end function

        private function netstream_buffer(event:Event) : void
        {
            this.dispatchEvent(new Event(event.type));
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            var _loc_8:Number = NaN;
            var _loc_9:Segment = null;
            var _loc_10:Array = null;
            var _loc_11:uint = 0;
            var _loc_12:uint = 0;
            if (this.metaData == null)
            {
                this.seekTime = param1;
                return;
            }
            var _loc_2:* = this.activeSegment;
            var _loc_3:* = param1;
            _loc_3 = _loc_3 < 0 ? (0) : (_loc_3);
            _loc_3 = _loc_3 > this.duration ? (this.duration) : (_loc_3);
            var _loc_4:Number = 0;
            var _loc_5:Number = 0;
            if (this.isSohu)
            {
                if (this.sohuKeyframes != null && this.sohuKeyframes.length >= 2)
                {
                    _loc_8 = this.sohuKeyframes.length;
                    LogManager.msg("sohu mp4 seek ---------------:" + _loc_3);
                    _loc_4 = this.getPositionIndexByTimeSohu(_loc_3);
                    _loc_4 = _loc_4 == (_loc_8 - 1) ? (_loc_8 - 2) : (_loc_4);
                    _loc_5 = this.sohuKeyframes[_loc_4].offset;
                }
                _loc_2.seekStartToEnd(_loc_3, _loc_5);
                this.setActivateSegment(_loc_2);
                return;
            }
            if (this.metaData == null)
            {
                return;
            }
            _loc_4 = this.getPositionIndexByTime(_loc_3);
            _loc_4 = _loc_4 == (this.positions.length - 1) ? (this.positions.length - 2) : (_loc_4);
            _loc_5 = this.positions[_loc_4];
            var _loc_6:int = 0;
            while (_loc_6 < this.segmentList.length)
            {
                
                _loc_9 = this.segmentList[_loc_6] as Segment;
                _loc_10 = _loc_9.getFileByteRange();
                _loc_11 = _loc_10[0];
                _loc_12 = _loc_10[1];
                _loc_12 = _loc_12 == -1 ? (this.fileSize) : (_loc_12);
                if (_loc_5 >= _loc_11 && _loc_5 < _loc_12)
                {
                    _loc_2 = _loc_9;
                    break;
                }
                _loc_6++;
            }
            var _loc_7:* = _loc_2.getFileByteRange()[1];
            this.activeSegment.pause();
            _loc_2.seekStartToEnd(this.times[_loc_4], _loc_5, _loc_7, this.is_use_segment_mode);
            this.setActivateSegment(_loc_2);
            return;
        }// end function

        private function configSegmentEvent(param1:Segment) : void
        {
            if (!param1.hasEventListener("__onStreamStatus"))
            {
                param1.setClient(this.clientObj);
                param1.addEventListener("__onStreamStatus", this.__onStreamStatus);
            }
            return;
        }// end function

        private function setActivateSegment(param1:Segment) : void
        {
            var _loc_3:Segment = null;
            var _loc_2:int = 0;
            while (_loc_2 < this.segmentList.length)
            {
                
                _loc_3 = this.segmentList[_loc_2] as Segment;
                if (_loc_3 != param1)
                {
                    _loc_3.setActivate(false);
                }
                _loc_2++;
            }
            param1.setActivate(true, _isPlay);
            param1.soundTransform = this.volume;
            this.activeSegment = param1;
            this.activeSegment.attachVideoToStream(this._video);
            return;
        }// end function

        private function __onStreamStatus(event:MyVideoEvent) : void
        {
            var _loc_4:Number = NaN;
            var _loc_5:Segment = null;
            var _loc_2:* = event.param.code;
            var _loc_3:* = event.param.param;
            switch(_loc_2)
            {
                case "NetStream.Play.Stop":
                {
                    if (this.activeSegment != this.segmentList[(this.segmentList.length - 1)])
                    {
                        LogManager.msg("切换下一分段视频");
                        this.__onStreamPlayStop = false;
                        _loc_4 = this.segmentList.indexOf(this.activeSegment) + 1;
                        _loc_5 = this.segmentList[_loc_4];
                        this.setActivateSegment(_loc_5);
                    }
                    else
                    {
                        this.__onStreamPlayStop = true;
                        this.dispatchEvent(new Event("__onStreamPlayStop"));
                        LogManager.msg("整段视频结束...");
                    }
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    this.dispatchEvent(new Event("__onStreamBufferEmpty"));
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    this.dispatchEvent(new Event("__onStreamPlayFail"));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get onStreamPlayStop() : Boolean
        {
            return this.__onStreamPlayStop;
        }// end function

        public function render(param1 = null) : void
        {
            if (this.is_start_render)
            {
                this.updatePlayHeadTime();
                this.updateLoadPorgress();
                this.updateBufferProgress();
            }
            return;
        }// end function

        private function updatePlayHeadTime() : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_1:* = this.activeSegment.getPlayHeadTime();
            if (getTimer() - this.playHeadTimeCheckSt >= 100)
            {
                if (_loc_1 > 0)
                {
                    if (this.playHeadTime != _loc_1)
                    {
                        if (!this.hasSendMetaData && this.metaData != null)
                        {
                            this.hasSendMetaData = true;
                        }
                        this.playHeadTime = _loc_1;
                        if (this.activeSegment != this.segmentList[(this.segmentList.length - 1)])
                        {
                            _loc_2 = this.activeSegment.getFileTimeRange()[1];
                            if (_loc_2 - _loc_1 <= this.PRE_LOAD_TIME)
                            {
                                this.preLoadNextSegment();
                            }
                        }
                        else if (this.duration - _loc_1 <= this.PLAY_END_NOTICE_TIME)
                        {
                            var _loc_4:* = this.duration - _loc_1;
                            _loc_3 = this.duration - _loc_1;
                            _loc_3 = _loc_4;
                        }
                    }
                }
            }
            return;
        }// end function

        private function updateLoadPorgress() : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_1:* = this.activeSegment.getPlayHeadTime();
            var _loc_2:Number = 0;
            if (_loc_1 != -1)
            {
                _loc_3 = this.activeSegment.getSeekStartByte();
                _loc_4 = _loc_3 + this.activeSegment.getBytesLoaded();
                _loc_5 = _loc_4 / this.fileSize;
                _loc_2 = _loc_5;
            }
            return;
        }// end function

        private function updateBufferProgress() : void
        {
            var _loc_1:* = this.activeSegment.getBufferPercent();
            return;
        }// end function

        private function preLoadNextSegment() : void
        {
            var _loc_1:* = this.segmentList.indexOf(this.activeSegment) + 1;
            var _loc_2:* = this.segmentList[_loc_1];
            _loc_2.setClient(this.clientObj);
            _loc_2.preLoad();
            return;
        }// end function

        override public function get bufferLength() : Number
        {
            return this.activeSegment.getBufferLength();
        }// end function

        override public function get bufferTime() : Number
        {
            return this.activeSegment.getBufferTime();
        }// end function

        override public function set bufferTime(param1:Number) : void
        {
            this.activeSegment.bufferTime = param1;
            return;
        }// end function

        override public function get bytesLoaded() : uint
        {
            var _loc_1:* = this.activeSegment.getSeekStartByte();
            var _loc_2:* = _loc_1 + this.activeSegment.getBytesLoaded();
            return _loc_2;
        }// end function

        override public function get bytesTotal() : uint
        {
            return this.fileSize;
        }// end function

        override public function get client() : Object
        {
            return this.activeSegment.getClient();
        }// end function

        override public function set client(param1:Object) : void
        {
            this.clientObj = param1;
            this.activeSegment.setClient(this.clientObj);
            return;
        }// end function

        override public function get time() : Number
        {
            return this.activeSegment.getPlayHeadTime();
        }// end function

        override public function get checkPolicyFile() : Boolean
        {
            return this.activeSegment.checkPolicyFile;
        }// end function

        override public function get currentFPS() : Number
        {
            return this.activeSegment.currentFPS;
        }// end function

        override public function close() : void
        {
            this.activeSegment.close();
            _isPlay = false;
            return;
        }// end function

        override public function pause() : void
        {
            _isPlay = false;
            this.activeSegment.pause();
            return;
        }// end function

        override public function resume() : void
        {
            _isPlay = true;
            this.activeSegment.resume();
            return;
        }// end function

        public function stopVideo() : void
        {
            this.activeSegment.stop();
            return;
        }// end function

        public function rePlayVideo() : void
        {
            this.seek(0);
            return;
        }// end function

        public function pauseVideo() : void
        {
            this.activeSegment.pause();
            return;
        }// end function

        public function resumeVideo() : void
        {
            this.activeSegment.resume();
            return;
        }// end function

        override public function get soundTransform() : SoundTransform
        {
            return this.activeSegment.soundTransform;
        }// end function

        override public function set soundTransform(param1:SoundTransform) : void
        {
            this.volume = param1;
            this.activeSegment.soundTransform = this.volume;
            return;
        }// end function

        private function getSegmentEndByteByPos(param1:Number) : Number
        {
            var _loc_2:Number = -1;
            if (param1 >= this.positions[(this.positions.length - 1)])
            {
                return (this.positions.length - 1);
            }
            var _loc_3:int = 0;
            while (_loc_3 < this.positions.length)
            {
                
                if (this.positions[_loc_3] >= param1)
                {
                    _loc_2 = _loc_3 - 1;
                    break;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        private function getPositionIndexByTimeSohu(param1:Number) : Number
        {
            var _loc_2:Number = -1;
            var _loc_3:* = this.sohuKeyframes.length;
            if (param1 >= this.sohuKeyframes[_loc_3 - 2].time)
            {
                return _loc_3 - 2;
            }
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3 - 2)
            {
                
                if (param1 >= this.sohuKeyframes[_loc_4].time && param1 < this.sohuKeyframes[(_loc_4 + 1)].time)
                {
                    _loc_2 = _loc_4;
                    break;
                }
                _loc_4++;
            }
            return _loc_2;
        }// end function

        private function getPositionIndexByTime(param1:Number) : Number
        {
            var _loc_2:Number = -1;
            if (param1 >= this.times[this.times.length - 2])
            {
                return this.times.length - 2;
            }
            var _loc_3:int = 0;
            while (_loc_3 < this.times.length - 2)
            {
                
                if (param1 >= this.times[_loc_3] && param1 < this.times[(_loc_3 + 1)])
                {
                    _loc_2 = _loc_3;
                    break;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function getStream()
        {
            if (this.activeSegment != null)
            {
                return this.activeSegment.getStream();
            }
            return null;
        }// end function

        private function __onStreamBufferTooFrequent(event:Event) : void
        {
            dispatchEvent(new Event("__onStreamBufferTooFrequent"));
            return;
        }// end function

        private function __onStreamBufferBlockOver(event:Event) : void
        {
            dispatchEvent(new Event("__onStreamBufferBlockOver"));
            return;
        }// end function

        private function __onStreamLoadTimeOut(event:Event) : void
        {
            dispatchEvent(new Event("__onStreamLoadTimeOut"));
            return;
        }// end function

        public function updateScreenMode(param1:String) : void
        {
            return;
        }// end function

        public function gc() : void
        {
            var _loc_1:int = 0;
            var _loc_2:Segment = null;
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER, this.render);
            this.timer = null;
            try
            {
                this.activeSegment.removeEventListener("__onStreamStatus", this.__onStreamStatus);
            }
            catch (e)
            {
            }
            if (this.segmentList.length > 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this.segmentList.length)
                {
                    
                    _loc_2 = this.segmentList[_loc_1];
                    try
                    {
                        _loc_2.removeEventListener("__onStreamStatus", this.__onStreamStatus);
                    }
                    catch (e)
                    {
                    }
                    _loc_2.gc();
                    _loc_2 = null;
                    _loc_1++;
                }
            }
            this.segmentList = null;
            this.activeSegment = null;
            if (this.checkTimer)
            {
                this.checkTimer.stop();
                this.checkTimer.removeEventListener(TimerEvent.TIMER, this.onCheckTimeoutHandler);
            }
            return;
        }// end function

    }
}
