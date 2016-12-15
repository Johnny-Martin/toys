package com.qiyi.player.core.model.impls
{
    import __AS3__.vec.*;
    import com.qiyi.player.core.player.coreplayer.*;

    public class Segment extends Object implements ISegment, IDestroy
    {
        private var _vid:String;
        private var _rid:String;
        private var _index:int;
        private var _keyframes:Vector.<Keyframe>;
        private var _firstKeyframe:Keyframe;
        private var _url:String;
        private var _startTime:Number;
        private var _startPosition:Number;
        private var _endTime:Number;
        private var _totalTime:Number;
        private var _totalBytes:Number;
        private var _currentKeyframeIndex:int = 0;
        private var _keyframeInited:Boolean = false;
        private var _keyframeAdjusted:Boolean = false;
        private var _holder:ICorePlayer;

        public function Segment(param1:ICorePlayer, param2:String, param3:int, param4:Number, param5:Number, param6:String, param7:Number, param8:Number)
        {
            var _loc_9:Array = null;
            var _loc_10:String = null;
            var _loc_11:String = null;
            this._holder = param1;
            this._vid = param2;
            this._index = param3;
            this._startTime = param4;
            this._startPosition = param5;
            this._url = param6;
            if (this._url != "" && this._url != null)
            {
                if (this._holder && this._holder.runtimeData.cacheServerIP != "" && this._holder.runtimeData.cacheServerIP != null)
                {
                    _loc_10 = "http://" + this._holder.runtimeData.cacheServerIP + "/";
                    this._url = this._url.replace(/http:\/\/(\w|\.)*\/""http:\/\/(\w|\.)*\//, _loc_10);
                }
                _loc_9 = this._url.split("/");
                if (_loc_9 && _loc_9.length > 0)
                {
                    _loc_11 = _loc_9[(_loc_9.length - 1)];
                    _loc_9 = _loc_11.split(".");
                    if (_loc_9 && _loc_9.length > 0)
                    {
                        this._rid = _loc_9[0];
                    }
                }
            }
            this._totalBytes = param7;
            this._totalTime = param8;
            this._endTime = this._startTime + this._totalTime;
            return;
        }// end function

        public function get vid() : String
        {
            return this._vid;
        }// end function

        public function get currentKeyframe() : Keyframe
        {
            if (this._keyframes)
            {
                return this._keyframes[this._currentKeyframeIndex];
            }
            return null;
        }// end function

        public function get keyframeInited() : Boolean
        {
            return this._keyframeInited;
        }// end function

        public function get keyframeAdjusted() : Boolean
        {
            return this._keyframeAdjusted;
        }// end function

        public function get startPosition() : Number
        {
            return this._startPosition;
        }// end function

        public function get index() : int
        {
            return this._index;
        }// end function

        public function get keyframes() : Vector.<Keyframe>
        {
            return this._keyframes;
        }// end function

        public function get firstKeyframe() : Keyframe
        {
            return this._firstKeyframe;
        }// end function

        public function get url() : String
        {
            return this._url;
        }// end function

        public function get rid() : String
        {
            return this._rid;
        }// end function

        public function get totalTime() : Number
        {
            return this._totalTime;
        }// end function

        public function get startTime() : Number
        {
            return this._startTime;
        }// end function

        public function get endTime() : Number
        {
            return this._endTime;
        }// end function

        public function get totalBytes() : Number
        {
            return this._totalBytes;
        }// end function

        public function getCaptureKeyFrames(param1:Number) : Vector.<Keyframe>
        {
            var _loc_3:Keyframe = null;
            var _loc_4:Keyframe = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_2:* = new Vector.<Keyframe>;
            if (this._keyframes)
            {
                _loc_3 = null;
                _loc_4 = null;
                _loc_5 = this._keyframes.length;
                _loc_6 = 1;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_4 = this._keyframes[_loc_6];
                    if (_loc_4.time >= param1)
                    {
                        _loc_2.push(this._keyframes[(_loc_6 - 1)]);
                        _loc_2.push(this._keyframes[_loc_6]);
                        break;
                    }
                    else if (_loc_6 == (_loc_5 - 1))
                    {
                        _loc_2.push(this._keyframes[_loc_6]);
                        break;
                    }
                    _loc_6++;
                }
            }
            return _loc_2;
        }// end function

        public function setKeyframesByXML(param1:XML, param2:Boolean) : void
        {
            var _loc_3:Keyframe = null;
            var _loc_4:XMLList = null;
            var _loc_5:XMLList = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if (param1 == null || this._keyframes)
            {
                return;
            }
            try
            {
                _loc_4 = param1.times.value;
                _loc_5 = param1.filepositions.value;
                this._keyframes = new Vector.<Keyframe>(_loc_4.length());
                _loc_6 = 1;
                _loc_7 = _loc_4.length();
                while (_loc_6 < _loc_7)
                {
                    
                    _loc_3 = new Keyframe();
                    _loc_3.index = Number(_loc_4[_loc_6].@id) - 1;
                    if (param2)
                    {
                        _loc_3.position = Number(_loc_5[_loc_6].toString());
                        _loc_3.time = Number(_loc_4[_loc_6].toString()) * 1000;
                        if (_loc_6 == 1)
                        {
                            this._startTime = _loc_3.time;
                            this._endTime = this._startTime + this._totalTime;
                        }
                        _loc_3.segmentTime = _loc_3.time - this._startTime;
                        if (_loc_3.segmentTime < 0)
                        {
                            _loc_3.segmentTime = 0;
                        }
                    }
                    else
                    {
                        _loc_3.position = Number(_loc_5[_loc_6].toString()) + 30;
                        _loc_3.segmentTime = Number(_loc_4[_loc_6].toString()) * 1000;
                        _loc_3.time = _loc_3.segmentTime + this._startTime;
                    }
                    if (_loc_6 != 1)
                    {
                        this._keyframes[(_loc_6 - 1)].lenTime = _loc_3.segmentTime - this._keyframes[(_loc_6 - 1)].segmentTime;
                        this._keyframes[(_loc_6 - 1)].lenPos = _loc_3.position - this._keyframes[(_loc_6 - 1)].position;
                    }
                    this._keyframes[_loc_6] = _loc_3;
                    _loc_6++;
                }
                this._keyframes[(this._keyframes.length - 1)].lenTime = this.totalTime - this._keyframes[(this._keyframes.length - 1)].segmentTime;
                this._keyframes[(this._keyframes.length - 1)].lenPos = this.totalBytes - this._keyframes[(this._keyframes.length - 1)].position;
                this._keyframes.shift();
                this._firstKeyframe = new Keyframe();
                this._firstKeyframe.segmentTime = 0;
                if (param2)
                {
                    this._firstKeyframe.position = Number(_loc_5[0].toString());
                }
                else
                {
                    this._firstKeyframe.position = Number(_loc_5[0].toString()) + 30;
                }
                this._keyframeAdjusted = param2;
                this._keyframeInited = true;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function setKeyframesByObject(param1:Object) : void
        {
            var _loc_2:Keyframe = null;
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            if (this._keyframes || param1 == null || param1.keyframes == null)
            {
                return;
            }
            try
            {
                _loc_3 = param1.keyframes.times;
                _loc_4 = param1.keyframes.filepositions;
                if (_loc_3 && _loc_4 && _loc_3.length > 0 && _loc_4.length > 0)
                {
                    if (this._index == 0)
                    {
                        this._keyframeAdjusted = true;
                    }
                    else if (int(Number(_loc_3[1]) * 1000) == 0)
                    {
                        this._keyframeAdjusted = false;
                    }
                    else
                    {
                        this._keyframeAdjusted = true;
                    }
                    this._keyframes = new Vector.<Keyframe>(_loc_3.length);
                    _loc_5 = 1;
                    _loc_6 = _loc_3.length;
                    while (_loc_5 < _loc_6)
                    {
                        
                        _loc_2 = new Keyframe();
                        _loc_2.index = _loc_5 - 1;
                        _loc_2.position = Number(_loc_4[_loc_5]);
                        if (this._keyframeAdjusted)
                        {
                            _loc_2.time = Number(_loc_3[_loc_5]) * 1000;
                            if (_loc_5 == 1)
                            {
                                this._startTime = _loc_2.time;
                                this._endTime = this._startTime + this._totalTime;
                            }
                            _loc_2.segmentTime = _loc_2.time - this._startTime;
                            if (_loc_2.segmentTime < 0)
                            {
                                _loc_2.segmentTime = 0;
                            }
                        }
                        else
                        {
                            _loc_2.segmentTime = Number(_loc_3[_loc_5]) * 1000;
                            _loc_2.time = _loc_2.segmentTime + this._startTime;
                        }
                        if (_loc_5 != 1)
                        {
                            this._keyframes[(_loc_5 - 1)].lenTime = _loc_2.segmentTime - this._keyframes[(_loc_5 - 1)].segmentTime;
                            this._keyframes[(_loc_5 - 1)].lenPos = _loc_2.position - this._keyframes[(_loc_5 - 1)].position;
                        }
                        this._keyframes[_loc_5] = _loc_2;
                        _loc_5++;
                    }
                    this._keyframes[(this._keyframes.length - 1)].lenTime = this.totalTime - this._keyframes[(this._keyframes.length - 1)].segmentTime;
                    this._keyframes[(this._keyframes.length - 1)].lenPos = this.totalBytes - this._keyframes[(this._keyframes.length - 1)].position;
                    this._keyframes.shift();
                    this._firstKeyframe = new Keyframe();
                    this._firstKeyframe.segmentTime = 0;
                    this._firstKeyframe.position = Number(_loc_4[0]);
                }
                this._keyframeInited = true;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function getKeyframeByTime(param1:Number) : Keyframe
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (this._keyframes == null)
            {
                return null;
            }
            if (param1 < this._startTime)
            {
                return this._keyframes[0];
            }
            if (param1 <= this._endTime)
            {
                _loc_2 = 1;
                _loc_3 = this._keyframes.length;
                while (_loc_2 < _loc_3)
                {
                    
                    if (this._keyframes[_loc_2].time >= param1)
                    {
                        return Math.abs(this._keyframes[_loc_2].time - param1) > Math.abs(this._keyframes[(_loc_2 - 1)].time - param1) ? (this._keyframes[(_loc_2 - 1)]) : (this._keyframes[_loc_2]);
                    }
                    _loc_2++;
                }
            }
            return this._keyframes[(this._keyframes.length - 1)];
        }// end function

        public function getKeyframeByPosition(param1:Number) : Keyframe
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (this._keyframes == null)
            {
                return null;
            }
            if (param1 >= 0 && param1 < this.totalBytes)
            {
                _loc_2 = 1;
                _loc_3 = this._keyframes.length;
                while (_loc_2 < _loc_3)
                {
                    
                    if (this._keyframes[_loc_2].position == param1)
                    {
                        return this._keyframes[_loc_2];
                    }
                    if (this._keyframes[_loc_2].position > param1)
                    {
                        return this._keyframes[(_loc_2 - 1)];
                    }
                    _loc_2++;
                }
            }
            return this._keyframes[(this._keyframes.length - 1)];
        }// end function

        public function seek(param1:Number) : void
        {
            var _loc_2:* = this.getKeyframeByTime(param1);
            if (_loc_2)
            {
                this._currentKeyframeIndex = _loc_2.index;
                if (this._holder && this._holder.runtimeData.originalEndTime > 0 && _loc_2.time > this._holder.runtimeData.originalEndTime)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this._currentKeyframeIndex - 1;
                    _loc_3._currentKeyframeIndex = _loc_4;
                }
                _loc_2 = this._keyframes[this._currentKeyframeIndex];
                if (this._totalBytes - _loc_2.position < 10000)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this._currentKeyframeIndex - 1;
                    _loc_3._currentKeyframeIndex = _loc_4;
                }
            }
            return;
        }// end function

        public function destroy() : void
        {
            return;
        }// end function

    }
}
