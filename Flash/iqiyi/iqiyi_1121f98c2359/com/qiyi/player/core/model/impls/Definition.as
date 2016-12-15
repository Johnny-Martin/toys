package com.qiyi.player.core.model.impls
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.events.*;
    import com.qiyi.player.core.model.remote.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import flash.events.*;
    import flash.utils.*;

    public class Definition extends EventDispatcher implements IDestroy, IDefinitionInfo
    {
        private var _audioTrack:AudioTrack;
        private var _movie:IMovie;
        private var _source:Object;
        private var _meta:Object;
        private var _type:EnumItem;
        private var _vid:String = "";
        private var _metaURL:String = "";
        private var _segmentVec:Vector.<Segment>;
        private var _duration:Number = 0;
        private var _flvWidth:Number = 0;
        private var _flvHeight:Number = 0;
        private var _videoConfigTag:String = "";
        private var _audioConfigTag:String = "";
        private var _ready:Boolean = false;
        private var _timer:Timer;
        private var _rm:RequestMetaRemote;
        private var _timeout:uint = 0;
        private var _timestampContinuous:Boolean = false;
        private var _pingBackFlag:Boolean = false;
        private var _holder:ICorePlayer;
        private var _log:ILogger;

        public function Definition(param1:ICorePlayer, param2:AudioTrack, param3:IMovie)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.impls.Definition");
            this._holder = param1;
            this._audioTrack = param2;
            this._movie = param3;
            return;
        }// end function

        public function get type() : EnumItem
        {
            return this._type;
        }// end function

        public function get vid() : String
        {
            return this._vid;
        }// end function

        public function get duration() : Number
        {
            return this._duration;
        }// end function

        public function get flvWidth() : Number
        {
            return this._flvWidth;
        }// end function

        public function get flvHeight() : Number
        {
            return this._flvHeight;
        }// end function

        public function get segmentCount() : int
        {
            if (this._segmentVec)
            {
                return this._segmentVec.length;
            }
            return 0;
        }// end function

        public function get videoConfigTag() : String
        {
            return this._videoConfigTag;
        }// end function

        public function get audioConfigTag() : String
        {
            return this._audioConfigTag;
        }// end function

        public function get meta() : Object
        {
            return this._meta;
        }// end function

        public function get ready() : Boolean
        {
            return this._ready;
        }// end function

        public function get metaIsReady() : Boolean
        {
            return this._meta != null;
        }// end function

        public function get timestampContinuous() : Boolean
        {
            return this._timestampContinuous;
        }// end function

        public function initDefinition(param1:Object, param2:String, param3:String, param4:Boolean) : void
        {
            var _loc_6:Object = null;
            var _loc_7:int = 0;
            var _loc_8:Segment = null;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:String = null;
            var _loc_12:Number = NaN;
            var _loc_13:int = 0;
            if (this._source != null)
            {
                return;
            }
            this._source = param1;
            this._type = Utility.getItemById(DefinitionEnum.ITEMS, int(param1.bid));
            this._vid = param1.vid.toString();
            this._metaURL = param2 + param1.mu.toString();
            if (param1.tag)
            {
                if (param1.tag.vt)
                {
                    this._videoConfigTag = param1.tag.vt;
                }
                if (param1.tag.at)
                {
                    this._audioConfigTag = param1.tag.at;
                }
            }
            this._duration = 0;
            var _loc_5:Array = null;
            if (param4)
            {
                _loc_5 = param1.flvs as Array;
            }
            else
            {
                _loc_5 = param1.fs as Array;
            }
            if (_loc_5)
            {
                _loc_6 = null;
                _loc_7 = _loc_5.length;
                _loc_8 = null;
                this._segmentVec = new Vector.<Segment>(_loc_7);
                _loc_9 = 0;
                _loc_10 = 0;
                _loc_11 = "";
                _loc_12 = 0;
                _loc_13 = 0;
                while (_loc_13 < _loc_7)
                {
                    
                    _loc_6 = _loc_5[_loc_13];
                    _loc_11 = param3 + _loc_6.l.toString();
                    _loc_12 = Number(_loc_6.d.toString());
                    if (this._movie.streamType == StreamEnum.RTMP)
                    {
                        _loc_12 = _loc_12 * 1000;
                    }
                    _loc_8 = new Segment(this._holder, this._vid, _loc_13, _loc_9, _loc_10, _loc_11, Number(_loc_6.b.toString()), _loc_12);
                    _loc_9 = _loc_9 + (_loc_8.totalTime + 30);
                    _loc_10 = _loc_10 + _loc_8.totalBytes;
                    this._segmentVec[_loc_13] = _loc_8;
                    this._duration = this._duration + _loc_8.totalTime;
                    _loc_13++;
                }
            }
            return;
        }// end function

        public function findSegmentAt(param1:int) : Segment
        {
            if (param1 < 0 || param1 >= this.segmentCount)
            {
                throw new Error("out of range segments");
            }
            return this._segmentVec[param1];
        }// end function

        public function findSegmentByRid(param1:String) : Segment
        {
            var _loc_2:int = 0;
            var _loc_3:Segment = null;
            var _loc_4:int = 0;
            if (this._segmentVec && param1)
            {
                _loc_2 = this.segmentCount;
                _loc_3 = null;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_3 = this._segmentVec[_loc_4];
                    if (_loc_3 && _loc_3.rid == param1)
                    {
                        return _loc_3;
                    }
                    _loc_4++;
                }
            }
            return null;
        }// end function

        public function startLoadMeta() : void
        {
            if (this._rm == null && this._timer == null)
            {
                if (this._movie.streamType == StreamEnum.RTMP)
                {
                    this._ready = true;
                }
                else if (this._movie.streamType == StreamEnum.HTTP)
                {
                    if (this._meta == null)
                    {
                        if (this._timeout)
                        {
                            clearTimeout(this._timeout);
                        }
                        ProcessesTimeRecord.STime_meta = getTimer();
                        this.reLoadMeta();
                        this._timeout = setTimeout(this.setReady, 2000);
                    }
                }
            }
            return;
        }// end function

        private function reLoadMeta() : void
        {
            if (this._rm)
            {
                this._rm.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onMetaStatusChanged);
                this._rm.destroy();
            }
            this._rm = new RequestMetaRemote(this._metaURL + "?tn=" + Math.random());
            this._rm.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onMetaStatusChanged);
            this._rm.initialize();
            return;
        }// end function

        private function initMeta() : void
        {
            var _loc_1:* = this._meta.flv.keyframesequences.keyframes;
            var _loc_2:Segment = null;
            var _loc_3:* = this.segmentCount;
            this._flvWidth = int(this._meta.flv.width.toString());
            this._flvHeight = int(this._meta.flv.height.toString());
            this._timestampContinuous = int(this._meta.flv.timestampcontinuous) == 1;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2 = this._segmentVec[_loc_4];
                _loc_2.setKeyframesByXML(_loc_1[_loc_4], int(this._meta.flv.timestampcontinuous) == 1);
                _loc_4++;
            }
            this._duration = this._segmentVec[(_loc_3 - 1)].endTime;
            return;
        }// end function

        private function onMetaStatusChanged(event:RemoteObjectEvent) : void
        {
            var errorCode:int;
            var event:* = event;
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
                this._timer.stop();
                this._timer = null;
            }
            errorCode;
            try
            {
                if (this._rm.status == RemoteObjectStatusEnum.Success)
                {
                    this._meta = this._rm.getData() as XML;
                    this.initMeta();
                    dispatchEvent(new MovieEvent(MovieEvent.Evt_Meta_Ready));
                }
                else if (this._rm.status != RemoteObjectStatusEnum.Processing)
                {
                    errorCode = ErrorCodeUtils.getErrorCodeByRemoteObject(this._rm, this._rm.status);
                    if (this._holder && !this._pingBackFlag)
                    {
                        this._holder.pingBack.sendError(errorCode);
                        this._pingBackFlag = true;
                    }
                    this._timer = new Timer(5000, 1);
                    this._timer.addEventListener(TimerEvent.TIMER, this.onTimer);
                    this._timer.start();
                }
            }
            catch (e:Error)
            {
                errorCode = ErrorCodeUtils.getErrorCodeByRemoteObject(_rm, _rm.status);
                if (_holder && !_pingBackFlag)
                {
                    _holder.pingBack.sendError(errorCode);
                    _pingBackFlag = true;
                }
                _timer = new Timer(5000, 1);
                _timer.addEventListener(TimerEvent.TIMER, onTimer);
                _timer.start();
            }
            this._rm.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onMetaStatusChanged);
            this._rm.destroy();
            this._rm = null;
            this.setReady();
            return;
        }// end function

        private function setReady() : void
        {
            if (ProcessesTimeRecord.STime_meta > 0)
            {
                ProcessesTimeRecord.usedTime_meta = getTimer() - ProcessesTimeRecord.STime_meta;
            }
            if (this._timeout)
            {
                clearTimeout(this._timeout);
            }
            this._timeout = 0;
            if (!this._ready)
            {
                this._ready = true;
                dispatchEvent(new MovieEvent(MovieEvent.Evt_Ready));
            }
            return;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            this.reLoadMeta();
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:Segment = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            this._audioTrack = null;
            this._movie = null;
            this._source = null;
            this._meta = null;
            this._type = null;
            this._vid = "";
            this._metaURL = "";
            if (this._segmentVec)
            {
                _loc_1 = null;
                _loc_2 = this._segmentVec.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1 = this._segmentVec[_loc_3];
                    if (_loc_1)
                    {
                        _loc_1.destroy();
                    }
                    _loc_3++;
                }
                this._segmentVec = null;
            }
            this._duration = 0;
            this._flvWidth = 0;
            this._flvHeight = 0;
            this._ready = false;
            this._pingBackFlag = false;
            if (this._timeout)
            {
                clearTimeout(this._timeout);
            }
            this._timeout = 0;
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
                this._timer.stop();
                this._timer = null;
            }
            if (this._rm)
            {
                this._rm.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onMetaStatusChanged);
                this._rm.destroy();
                this._rm = null;
            }
            return;
        }// end function

    }
}
