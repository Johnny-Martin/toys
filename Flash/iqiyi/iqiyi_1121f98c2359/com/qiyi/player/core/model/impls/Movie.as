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
    import com.qiyi.player.core.model.impls.subtitle.*;
    import com.qiyi.player.core.model.remote.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import flash.events.*;
    import flash.utils.*;

    public class Movie extends EventDispatcher implements IMovie
    {
        private var _ver:String = "0";
        private var _nextVid:String;
        private var _nextTvid:String;
        private var _status:String;
        private var _source:Object;
        private var _audioTrackVec:Vector.<AudioTrack>;
        private var _curAudioTrack:AudioTrack;
        private var _curDefinition:Definition;
        private var _curSegment:Segment;
        private var _streamType:EnumItem;
        private var _screenType:EnumItem;
        private var _screenInfoVec:Vector.<ScreenInfo>;
        private var _tvid:String;
        private var _qipuId:String;
        private var _albumId:String;
        private var _logoId:String = "";
        private var _logoPosition:int;
        private var _ctgId:int;
        private var _ipLimited:Boolean = false;
        private var _titleTime:int = -1;
        private var _trailerTime:int = -1;
        private var _member:Boolean = false;
        private var _channelID:int;
        private var _forceAD:Boolean = false;
        private var _multiAngle:Boolean = false;
        private var _renderType:int = 0;
        private var _skipPointVec:Vector.<SkipPointInfo>;
        private var _enjoyableMap:Dictionary;
        private var _enjoyableDurationMap:Dictionary;
        private var _skipPointAnalysisData:Object;
        private var _curEnjoyableSubType:EnumItem;
        private var _curEnjoyableSubDurationIndex:int = -1;
        private var _requestEnjoyableSkipPointsRemote:RequestEnjoyableSkipPointsRemote;
        private var _uploaderID:String = "";
        private var _exclusive:Boolean = false;
        private var _subtitles:Vector.<Language>;
        private var _defaultSubtitle:Language;
        private var _curSubtitlesType:EnumItem;
        private var _hasSubtitle:Boolean = false;
        private var _hintUrl:String = "";
        private var _holder:ICorePlayer;
        private var _seekTime:Number = 0;
        private var _defControlList:Array;
        private var _log:ILogger;

        public function Movie(param1:Object, param2:Boolean, param3:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.impls.Movie");
            this._source = param1;
            this._member = param2;
            this._holder = param3;
            this._enjoyableMap = new Dictionary();
            this._enjoyableDurationMap = new Dictionary();
            this._defControlList = new Array();
            this.parse();
            return;
        }// end function

        public function get ver() : String
        {
            return this._ver;
        }// end function

        public function get subtitles() : Vector.<Language>
        {
            return this._subtitles;
        }// end function

        public function get defaultSubtitle() : Language
        {
            return this._defaultSubtitle;
        }// end function

        public function get curSubtitlesType() : EnumItem
        {
            return this._curSubtitlesType;
        }// end function

        public function get hasSubtitle() : Boolean
        {
            return this._hasSubtitle;
        }// end function

        public function get hintUrl() : String
        {
            return this._hintUrl;
        }// end function

        public function get nextVid() : String
        {
            return this._nextVid;
        }// end function

        public function get nextTvid() : String
        {
            return this._nextTvid;
        }// end function

        public function get status() : String
        {
            return this._status;
        }// end function

        public function get source() : Object
        {
            return this._source;
        }// end function

        public function get audioTrackCount() : int
        {
            if (this._audioTrackVec)
            {
                return this._audioTrackVec.length;
            }
            return 0;
        }// end function

        public function get curAudioTrack() : AudioTrack
        {
            return this._curAudioTrack;
        }// end function

        public function get curAudioTrackInfo() : IAudioTrackInfo
        {
            return this._curAudioTrack;
        }// end function

        public function get curDefinition() : Definition
        {
            return this._curDefinition;
        }// end function

        public function get curDefinitionInfo() : IDefinitionInfo
        {
            return this._curDefinition;
        }// end function

        public function get ready() : Boolean
        {
            if (this._curDefinition)
            {
                return this._curDefinition.ready;
            }
            return false;
        }// end function

        public function get logoId() : String
        {
            return this._logoId;
        }// end function

        public function get logoPosition() : int
        {
            return this._logoPosition;
        }// end function

        public function get ctgId() : int
        {
            return this._ctgId;
        }// end function

        public function get channelID() : int
        {
            return this._channelID;
        }// end function

        public function get member() : Boolean
        {
            return this._member;
        }// end function

        public function get vid() : String
        {
            if (this._curDefinition)
            {
                return this._curDefinition.vid;
            }
            return "";
        }// end function

        public function get tvid() : String
        {
            return this._tvid;
        }// end function

        public function get qipuId() : String
        {
            return this._qipuId;
        }// end function

        public function get albumId() : String
        {
            return this._albumId;
        }// end function

        public function get curSegment() : Segment
        {
            return this._curSegment;
        }// end function

        public function get ipLimited() : Boolean
        {
            return this._ipLimited;
        }// end function

        public function get duration() : Number
        {
            if (this._curDefinition)
            {
                return this._curDefinition.duration;
            }
            return 0;
        }// end function

        public function get streamType() : EnumItem
        {
            return this._streamType;
        }// end function

        public function get screenType() : EnumItem
        {
            return this._screenType;
        }// end function

        public function get screenInfoCount() : int
        {
            if (this._screenInfoVec)
            {
                return this._screenInfoVec.length;
            }
            return 0;
        }// end function

        public function get skipPointInfoCount() : int
        {
            if (this._skipPointVec)
            {
                return this._skipPointVec.length;
            }
            return 0;
        }// end function

        public function get curEnjoyableSubDurationIndex() : int
        {
            return this._curEnjoyableSubDurationIndex;
        }// end function

        public function get width() : int
        {
            if (this._curDefinition)
            {
                return this._curDefinition.flvWidth;
            }
            return 0;
        }// end function

        public function get height() : int
        {
            if (this._curDefinition)
            {
                return this._curDefinition.flvHeight;
            }
            return 0;
        }// end function

        public function get titlesTime() : Number
        {
            return this._titleTime;
        }// end function

        public function get trailerTime() : Number
        {
            return this._trailerTime;
        }// end function

        public function get forceAD() : Boolean
        {
            return this._forceAD;
        }// end function

        public function get multiAngle() : Boolean
        {
            return this._multiAngle;
        }// end function

        public function get renderType() : int
        {
            return this._renderType;
        }// end function

        public function get uploaderID() : String
        {
            return this._uploaderID;
        }// end function

        public function get exclusive() : Boolean
        {
            return this._exclusive;
        }// end function

        public function get curEnjoyableSubType() : EnumItem
        {
            return this._curEnjoyableSubType;
        }// end function

        public function get qualityDefinitionControlList() : Array
        {
            return this._defControlList;
        }// end function

        public function updateCurSubtitlesType(param1:EnumItem) : void
        {
            this._curSubtitlesType = param1;
            return;
        }// end function

        public function setCurAudioTrack(param1:EnumItem, param2:EnumItem) : void
        {
            var _loc_3:* = this.getAudioTrackByType(param1);
            if (_loc_3 && _loc_3 != this._curAudioTrack)
            {
                this._curAudioTrack = _loc_3;
                this.setCurDefinition(param2);
            }
            return;
        }// end function

        public function setCurDefinition(param1:EnumItem) : void
        {
            var _loc_2:Definition = null;
            if (this._curAudioTrack)
            {
                _loc_2 = this._curAudioTrack.findDefinitionByType(param1);
                if (_loc_2 && _loc_2 != this._curDefinition)
                {
                    if (this._curDefinition)
                    {
                        this._curDefinition.removeEventListener(MovieEvent.Evt_Ready, this.onDefinitionReady);
                        this._curDefinition.removeEventListener(MovieEvent.Evt_Meta_Ready, this.onDefinitionMetaReady);
                    }
                    this._curDefinition = _loc_2;
                    this._curDefinition.addEventListener(MovieEvent.Evt_Ready, this.onDefinitionReady);
                    this._curDefinition.addEventListener(MovieEvent.Evt_Meta_Ready, this.onDefinitionMetaReady);
                    if (this._curDefinition.metaIsReady)
                    {
                        this.updateSkipPointInfo();
                        dispatchEvent(new MovieEvent(MovieEvent.Evt_UpdateSkipPoint));
                    }
                    this.seek(this._seekTime);
                }
            }
            return;
        }// end function

        public function hasVid(param1:String) : Boolean
        {
            var _loc_2:Definition = null;
            if (this._curAudioTrack)
            {
                _loc_2 = this._curAudioTrack.findDefinitionByVid(param1);
                return _loc_2 != null;
            }
            return false;
        }// end function

        public function hasDefinitionByType(param1:EnumItem) : Boolean
        {
            var _loc_2:Definition = null;
            if (this._curAudioTrack)
            {
                _loc_2 = this._curAudioTrack.findDefinitionByType(param1, true);
                return _loc_2 != null;
            }
            return false;
        }// end function

        public function seek(param1:Number) : void
        {
            this._seekTime = param1;
            this._curSegment = this.getSegmentByTime(param1);
            if (this._curSegment)
            {
                this._curSegment.seek(param1);
            }
            return;
        }// end function

        public function getSeekTime() : Number
        {
            return this._seekTime;
        }// end function

        public function getAudioTrackAt(param1:int) : AudioTrack
        {
            var _loc_2:int = 0;
            if (this._audioTrackVec)
            {
                _loc_2 = this._audioTrackVec.length;
                if (param1 >= 0 && param1 < _loc_2)
                {
                    return this._audioTrackVec[param1];
                }
            }
            return null;
        }// end function

        public function getAudioTrackInfoAt(param1:int) : IAudioTrackInfo
        {
            return this.getAudioTrackAt(param1);
        }// end function

        public function getAudioTrackByType(param1:EnumItem) : AudioTrack
        {
            var _loc_2:int = 0;
            var _loc_3:AudioTrack = null;
            var _loc_4:int = 0;
            if (this._audioTrackVec)
            {
                _loc_2 = this._audioTrackVec.length;
                _loc_3 = null;
                _loc_4 = 0;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_3 = this._audioTrackVec[_loc_4];
                    if (_loc_3 && _loc_3.type == param1)
                    {
                        return _loc_3;
                    }
                    _loc_4++;
                }
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_3 = this._audioTrackVec[_loc_4];
                    if (_loc_3 && _loc_3.isDefault)
                    {
                        return _loc_3;
                    }
                    _loc_4++;
                }
                if (_loc_2 > 0)
                {
                    return this._audioTrackVec[0];
                }
            }
            return null;
        }// end function

        public function getAudioTrackInfoByType(param1:EnumItem) : IAudioTrackInfo
        {
            return this.getAudioTrackByType(param1);
        }// end function

        public function getSegmentByTime(param1:Number) : Segment
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_2:Segment = null;
            if (this._curDefinition)
            {
                _loc_3 = this._curDefinition.segmentCount;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    _loc_2 = this._curDefinition.findSegmentAt(_loc_4);
                    if (_loc_2 && param1 <= _loc_2.endTime)
                    {
                        return _loc_2;
                    }
                    _loc_4++;
                }
                _loc_2 = this._curDefinition.findSegmentAt((_loc_3 - 1));
            }
            return _loc_2;
        }// end function

        public function getKeyframeByTime(param1:Number) : Keyframe
        {
            var _loc_2:* = this.getSegmentByTime(param1);
            if (_loc_2)
            {
                return _loc_2.getKeyframeByTime(param1);
            }
            return null;
        }// end function

        public function getVidByDefinition(param1:EnumItem, param2:Boolean = false) : String
        {
            var _loc_3:Definition = null;
            if (this._curAudioTrack)
            {
                _loc_3 = this._curAudioTrack.findDefinitionByType(param1, param2);
                if (_loc_3)
                {
                    return _loc_3.vid;
                }
            }
            return "";
        }// end function

        public function getScreenInfoAt(param1:int) : ScreenInfo
        {
            if (this._screenInfoVec)
            {
                if (param1 >= 0 && param1 < this.screenInfoCount)
                {
                    return this._screenInfoVec[param1];
                }
            }
            return null;
        }// end function

        public function getSkipPointInfoAt(param1:int) : ISkipPointInfo
        {
            if (this._skipPointVec)
            {
                if (param1 >= 0 && param1 < this.skipPointInfoCount)
                {
                    return this._skipPointVec[param1];
                }
            }
            return null;
        }// end function

        public function startLoadAddedSkipPoints() : void
        {
            if (this._requestEnjoyableSkipPointsRemote)
            {
                this._requestEnjoyableSkipPointsRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onRequestAddedSkipPoints);
                this._requestEnjoyableSkipPointsRemote.destroy();
            }
            this._requestEnjoyableSkipPointsRemote = new RequestEnjoyableSkipPointsRemote(this._holder, this._tvid);
            this._requestEnjoyableSkipPointsRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onRequestAddedSkipPoints);
            this._requestEnjoyableSkipPointsRemote.initialize();
            return;
        }// end function

        public function hasEnjoyableSubType(param1:EnumItem) : Boolean
        {
            return this._enjoyableMap[param1] != null;
        }// end function

        public function getEnjoyableSubDurationList(param1:EnumItem) : Array
        {
            if (this._enjoyableDurationMap[param1] != null)
            {
                return this._enjoyableDurationMap[param1] as Array;
            }
            return null;
        }// end function

        public function getSkipPointAnalysisData() : Object
        {
            return this._skipPointAnalysisData;
        }// end function

        public function setEnjoyableSubType(param1:EnumItem, param2:int = -1) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:Vector.<SkipPointInfo> = null;
            var _loc_7:int = 0;
            var _loc_8:Boolean = false;
            var _loc_3:* = UserManager.getInstance().userLocalSex;
            if (_loc_3.state == UserDef.USER_LOCAL_SEX_STATE_NONE || _loc_3.state == UserDef.USER_LOCAL_SEX_STATE_COMPLETE)
            {
                if (!this.hasEnjoyableSubType(param1))
                {
                    return;
                }
                _loc_4 = this.adjustDurationIndexOfCurEnjoyableSubType(param1, param2);
                if (_loc_4 < 0)
                {
                    return;
                }
                _loc_5 = this._enjoyableDurationMap[param1][_loc_4];
                _loc_6 = this._enjoyableMap[param1][_loc_5];
                if (_loc_6 && _loc_6.length > 0)
                {
                    this._curEnjoyableSubType = param1;
                    this._curEnjoyableSubDurationIndex = _loc_4;
                    _loc_7 = 0;
                    _loc_7 = this._skipPointVec.length - 1;
                    while (_loc_7 >= 0)
                    {
                        
                        if (this._skipPointVec[_loc_7].skipPointType == SkipPointEnum.ENJOYABLE)
                        {
                            this._skipPointVec[_loc_7].reset();
                            this._skipPointVec.splice(_loc_7, 1);
                        }
                        _loc_7 = _loc_7 - 1;
                    }
                    _loc_7 = 0;
                    while (_loc_7 < _loc_6.length)
                    {
                        
                        this._skipPointVec.push(_loc_6[_loc_7]);
                        _loc_7++;
                    }
                    _loc_8 = false;
                    if (_loc_6.length > 0)
                    {
                        this._skipPointVec.sort(this.compare);
                        if (this._curDefinition.metaIsReady)
                        {
                            this.updateSkipPointInfo();
                            _loc_8 = true;
                        }
                    }
                    this._log.info("movie dispatchEvent: Evt_EnjoyableSubTypeChanged");
                    dispatchEvent(new MovieEvent(MovieEvent.Evt_EnjoyableSubTypeChanged));
                    if (_loc_8)
                    {
                        this._log.info("movie dispatchEvent: Evt_UpdateSkipPoint");
                        dispatchEvent(new MovieEvent(MovieEvent.Evt_UpdateSkipPoint));
                    }
                }
            }
            return;
        }// end function

        public function startLoadMeta() : void
        {
            if (this._curDefinition)
            {
                this._curDefinition.startLoadMeta();
            }
            return;
        }// end function

        public function startLoadLicense() : void
        {
            if (this._curDefinition)
            {
                this._curDefinition.startLoadLicense();
            }
            return;
        }// end function

        private function onDefinitionReady(event:Event) : void
        {
            dispatchEvent(new MovieEvent(MovieEvent.Evt_Ready));
            return;
        }// end function

        private function onDefinitionMetaReady(event:Event) : void
        {
            this.updateSkipPointInfo();
            dispatchEvent(new MovieEvent(MovieEvent.Evt_Meta_Ready));
            dispatchEvent(new MovieEvent(MovieEvent.Evt_UpdateSkipPoint));
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:int = 0;
            var _loc_2:AudioTrack = null;
            var _loc_3:int = 0;
            if (this._audioTrackVec)
            {
                _loc_1 = this._audioTrackVec.length;
                _loc_2 = null;
                _loc_3 = 0;
                while (_loc_3 < _loc_1)
                {
                    
                    _loc_2 = this._audioTrackVec[_loc_3];
                    if (_loc_2)
                    {
                        _loc_2.destroy();
                    }
                    _loc_3++;
                }
                this._audioTrackVec = null;
            }
            this._screenInfoVec = null;
            this._skipPointVec = null;
            this._curAudioTrack = null;
            if (this._curDefinition)
            {
                this._curDefinition.removeEventListener(MovieEvent.Evt_Ready, this.onDefinitionReady);
                this._curDefinition.removeEventListener(MovieEvent.Evt_Meta_Ready, this.onDefinitionMetaReady);
                this._curDefinition = null;
            }
            this._curSegment = null;
            this._enjoyableMap = null;
            this._enjoyableDurationMap = null;
            UserManager.getInstance().userLocalSex.removeEventListener(UserManagerEvent.Evt_LocalSexInitComplete, this.onLocalSexInitComplete);
            return;
        }// end function

        private function parse() : void
        {
            var _loc_9:ScreenInfo = null;
            var _loc_10:SkipPointInfo = null;
            var _loc_11:String = null;
            var _loc_12:Object = null;
            var _loc_13:Language = null;
            var _loc_14:Object = null;
            var _loc_15:String = null;
            var _loc_1:Boolean = false;
            if (this._source.ver != undefined)
            {
                this._ver = this._source.ver;
            }
            this._status = this._source.st;
            this._ipLimited = this._status == "109";
            this._streamType = Utility.getItemById(StreamEnum.ITEMS, int(this._source.t));
            if (this._holder && this._streamType == StreamEnum.RTMP && this._holder.runtimeData.smallOperators && this._source.du)
            {
                this._streamType = StreamEnum.HTTP;
                _loc_1 = true;
            }
            this._nextVid = String(this._source.nvid);
            this._nextTvid = String(this._source.ntvd);
            this._tvid = String(this._source.tvid);
            this._qipuId = this._source.tvQipuId != undefined ? (String(this._source.tvQipuId)) : (this._tvid);
            this._albumId = String(this._source.aid);
            this._titleTime = (int(this._source.bt) <= 0 ? (0) : (int(this._source.bt))) * 1000;
            this._trailerTime = (int(this._source.et) <= 0 ? (0) : (int(this._source.et))) * 1000;
            this._logoId = String(this._source.lgd);
            this._logoPosition = int(this._source.lgp);
            this._ctgId = int(this._source.ctgid);
            this._channelID = int(this._source.cid);
            this._screenType = Utility.getItemById(ScreenEnum.ITEMS, int(this._source.tht));
            if (this._source.pano != undefined)
            {
                this._multiAngle = int(this._source.pano.type) == 2;
                if (this._source.pano.rType != undefined)
                {
                    this._renderType = int(this._source.pano.rType);
                }
                this._log.info("movie pano: " + this._multiAngle + ", type:" + this._renderType);
            }
            if (this._source.ca != undefined)
            {
                this._forceAD = int(this._source.ca) == 1;
            }
            if (this._source.uid != undefined)
            {
                this._uploaderID = String(this._source.uid);
            }
            if (this._source.exclusive != undefined)
            {
                this._exclusive = int(this._source.exclusive) == 1;
            }
            if (this._holder)
            {
                this._holder.runtimeData.albumId = this._albumId;
            }
            if (this._source.ctl != undefined)
            {
                this.parseDefinitionControl(this._source.ctl);
            }
            if (this._source.isRs != undefined)
            {
                this._hasSubtitle = int(this._source.isRs) == 1;
            }
            var _loc_2:* = String(this._source.dm);
            var _loc_3:* = _loc_1 ? (String(this._source.du)) : (String(this._source.dd));
            var _loc_4:* = String(this._source.drm);
            var _loc_5:* = this._source.tkl as Array;
            var _loc_6:AudioTrack = null;
            var _loc_7:* = _loc_5.length;
            var _loc_8:int = 0;
            this._audioTrackVec = new Vector.<AudioTrack>(_loc_7);
            _loc_8 = 0;
            while (_loc_8 < _loc_7)
            {
                
                _loc_6 = new AudioTrack(this._holder, this);
                _loc_6.initAudioTrack(_loc_5[_loc_8], _loc_2, _loc_3, _loc_4, _loc_1);
                this._audioTrackVec[_loc_8] = _loc_6;
                _loc_8++;
            }
            this._screenInfoVec = new Vector.<ScreenInfo>;
            _loc_5 = this._source.t3d as Array;
            if (_loc_5)
            {
                _loc_7 = _loc_5.length;
                _loc_9 = null;
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    if (_loc_5[_loc_8].tid != 0 && _loc_5[_loc_8].vtp != 0 && _loc_5[_loc_8].vid != "")
                    {
                        _loc_9 = new ScreenInfo();
                        _loc_9.screenType = Utility.getItemById(ScreenEnum.ITEMS, int(_loc_5[_loc_8].vtp));
                        _loc_9.tvid = _loc_5[_loc_8].tid;
                        _loc_9.vid = _loc_5[_loc_8].vid;
                        this._screenInfoVec.push(_loc_9);
                    }
                    _loc_8++;
                }
            }
            this._skipPointVec = new Vector.<SkipPointInfo>;
            _loc_5 = this._source.tsl as Array;
            if (_loc_5)
            {
                _loc_7 = _loc_5.length;
                _loc_10 = null;
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    _loc_10 = new SkipPointInfo();
                    _loc_10.skipPointType = Utility.getItemById(SkipPointEnum.ITEMS, int(_loc_5[_loc_8].stp));
                    _loc_10.startTime = Number(_loc_5[_loc_8].stm) * 1000;
                    _loc_10.endTime = Number(_loc_5[_loc_8].etm) * 1000;
                    if (_loc_10.skipPointType == SkipPointEnum.TITLE)
                    {
                        if (_loc_10.startTime == 0)
                        {
                            this._titleTime = _loc_10.endTime;
                            ;
                        }
                        else
                        {
                            this._titleTime = 0;
                        }
                    }
                    else if (_loc_10.skipPointType == SkipPointEnum.TRAILER)
                    {
                        if (_loc_10.endTime == -1)
                        {
                            this._trailerTime = _loc_10.startTime;
                            ;
                        }
                        else
                        {
                            this._trailerTime = 0;
                        }
                    }
                    this._skipPointVec.push(_loc_10);
                    _loc_8++;
                }
            }
            this._subtitles = new Vector.<Language>;
            if (this._source.stl && this._hasSubtitle)
            {
                _loc_5 = this._source.stl.stl_xml as Array;
                if (_loc_5 && _loc_5.length > 0)
                {
                    _loc_11 = String(this._source.stl.d);
                    _loc_12 = null;
                    for each (_loc_12 in _loc_5)
                    {
                        
                        _loc_13 = new Language();
                        _loc_13.isDefault = int(_loc_12.pre) == 1;
                        _loc_13.url = _loc_11 + String(_loc_12.l);
                        _loc_13.lang = Utility.getItemById(LanguageEnum.ITEMS, int(_loc_12.lid));
                        this._subtitles.push(_loc_13);
                        if (_loc_13.isDefault)
                        {
                            this._defaultSubtitle = _loc_13;
                        }
                    }
                }
            }
            if (this._source.hasOwnProperty("parts") && this._source["parts"].length > 0)
            {
                try
                {
                    _loc_14 = this._source["parts"][0];
                    _loc_15 = _loc_14["dfs"];
                    _loc_14 = _loc_14["vs"][0];
                    _loc_14 = _loc_14["fs"][0];
                    if (_loc_14.l != "")
                    {
                        this._hintUrl = _loc_15 + _loc_14.l;
                    }
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        private function parseDefinitionControl(param1:Object) : void
        {
            var _loc_2:Array = null;
            var _loc_3:EnumItem = null;
            var _loc_4:int = 0;
            this._holder.runtimeData.serverTime = uint(param1.timestamp * 0.001);
            this._holder.runtimeData.serverTimeGetTimer = getTimer();
            if (param1.vip && param1.vip.bids)
            {
                _loc_2 = param1.vip.bids as Array;
                _loc_4 = 0;
                while (_loc_4 < _loc_2.length)
                {
                    
                    _loc_3 = Utility.getItemById(DefinitionEnum.ITEMS, int(_loc_2[_loc_4]));
                    if (_loc_3 && param1.configs && param1.configs[int(_loc_2[_loc_4])] && param1.configs[int(_loc_2[_loc_4])].s == 1)
                    {
                        this._defControlList.push(_loc_3);
                    }
                    _loc_4++;
                }
            }
            return;
        }// end function

        private function updateSkipPointInfo() : void
        {
            var _loc_1:Segment = null;
            var _loc_2:Keyframe = null;
            var _loc_3:int = 0;
            var _loc_4:SkipPointInfo = null;
            var _loc_5:SkipPointInfo = null;
            var _loc_6:int = 0;
            if (this._skipPointVec && this._curDefinition.metaIsReady)
            {
                _loc_1 = null;
                _loc_2 = null;
                _loc_3 = this.skipPointInfoCount;
                _loc_4 = null;
                _loc_5 = null;
                _loc_6 = 0;
                _loc_6 = _loc_3 - 1;
                while (_loc_6 >= 0)
                {
                    
                    _loc_4 = this.getSkipPointInfoAt(_loc_6) as SkipPointInfo;
                    _loc_1 = this.getSegmentByTime(_loc_4.endTime);
                    _loc_2 = _loc_1.getKeyframeByTime(_loc_4.endTime);
                    _loc_4.endTime = _loc_2.time;
                    _loc_1 = this.getSegmentByTime(_loc_4.startTime);
                    _loc_2 = _loc_1.getKeyframeByTime(_loc_4.startTime);
                    if (_loc_2.time < _loc_4.endTime)
                    {
                        _loc_4.startTime = _loc_2.time;
                    }
                    else if (_loc_2.index != 0)
                    {
                        _loc_4.startTime = _loc_1.keyframes[(_loc_2.index - 1)].time;
                        if (_loc_4.endTime <= _loc_4.startTime)
                        {
                            this._skipPointVec.splice(_loc_6, 1);
                        }
                    }
                    else if (_loc_1.index != 0)
                    {
                        _loc_1 = this._curDefinition.findSegmentAt((_loc_1.index - 1));
                        _loc_4.startTime = _loc_1.keyframes[(_loc_1.keyframes.length - 1)].time;
                        if (_loc_4.endTime <= _loc_4.startTime)
                        {
                            this._skipPointVec.splice(_loc_6, 1);
                        }
                    }
                    else
                    {
                        this._skipPointVec.splice(_loc_6, 1);
                    }
                    _loc_6 = _loc_6 - 1;
                }
                _loc_3 = this.skipPointInfoCount;
                _loc_6 = _loc_3 - 1;
                while (_loc_6 > 0)
                {
                    
                    _loc_4 = this.getSkipPointInfoAt(_loc_6) as SkipPointInfo;
                    _loc_5 = this.getSkipPointInfoAt((_loc_6 - 1)) as SkipPointInfo;
                    if (_loc_5.endTime > _loc_4.startTime)
                    {
                        _loc_4.startTime = _loc_5.endTime;
                        if (_loc_4.startTime >= _loc_4.endTime)
                        {
                            this._skipPointVec.splice(_loc_6, 1);
                        }
                    }
                    _loc_6 = _loc_6 - 1;
                }
            }
            return;
        }// end function

        private function onRequestAddedSkipPoints(event:RemoteObjectEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:UserLocalSex = null;
            if (this._requestEnjoyableSkipPointsRemote.status == RemoteObjectStatusEnum.Success)
            {
                _loc_2 = this._requestEnjoyableSkipPointsRemote.skipPointTypeArr.length;
                if (_loc_2 > 0)
                {
                    this._enjoyableMap = this._requestEnjoyableSkipPointsRemote.skipPointMap;
                    this._enjoyableDurationMap = this._requestEnjoyableSkipPointsRemote.skipPointInfoDurationMap;
                    this._skipPointAnalysisData = this._requestEnjoyableSkipPointsRemote.skipPointAnalysisData;
                    _loc_3 = UserManager.getInstance().userLocalSex;
                    if (_loc_3.state == UserDef.USER_LOCAL_SEX_STATE_NONE || _loc_3.state == UserDef.USER_LOCAL_SEX_STATE_COMPLETE)
                    {
                        this.initEnjoyableSubSkipPoint();
                    }
                    else if (_loc_3.state == UserDef.USER_LOCAL_SEX_STATE_LOADING)
                    {
                        _loc_3.addEventListener(UserManagerEvent.Evt_LocalSexInitComplete, this.onLocalSexInitComplete);
                    }
                }
            }
            return;
        }// end function

        private function initEnjoyableSubSkipPoint() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            var _loc_3:Vector.<SkipPointInfo> = null;
            var _loc_4:int = 0;
            var _loc_5:Boolean = false;
            if (this._holder && this._holder.runtimeData.userEnjoyableSubType)
            {
                if (this.hasEnjoyableSubType(this._holder.runtimeData.userEnjoyableSubType))
                {
                    this._curEnjoyableSubType = this._holder.runtimeData.userEnjoyableSubType;
                }
                else
                {
                    this.initCurEnjoyableSubTypeBySex();
                }
            }
            else
            {
                this.initCurEnjoyableSubTypeBySex();
            }
            if (this._curEnjoyableSubType)
            {
                _loc_1 = this.adjustDurationIndexOfCurEnjoyableSubType(this._curEnjoyableSubType, this._holder ? (this._holder.runtimeData.userEnjoyableDurationIndex) : (-1));
                if (_loc_1 >= 0)
                {
                    this._curEnjoyableSubDurationIndex = _loc_1;
                    _loc_2 = this._enjoyableDurationMap[this._curEnjoyableSubType][_loc_1];
                    _loc_3 = this._enjoyableMap[this._curEnjoyableSubType][_loc_2];
                    if (_loc_3 && _loc_3.length > 0)
                    {
                        _loc_4 = 0;
                        while (_loc_4 < _loc_3.length)
                        {
                            
                            this._skipPointVec.push(_loc_3[_loc_4]);
                            _loc_4++;
                        }
                        _loc_5 = false;
                        if (_loc_3.length > 0)
                        {
                            this._skipPointVec.sort(this.compare);
                            if (this._curDefinition.metaIsReady)
                            {
                                this.updateSkipPointInfo();
                                _loc_5 = true;
                            }
                        }
                        this._log.info("movie dispatchEvent: Evt_EnjoyableSubTypeInited");
                        dispatchEvent(new MovieEvent(MovieEvent.Evt_EnjoyableSubTypeInited));
                        if (_loc_5)
                        {
                            this._log.info("movie dispatchEvent: Evt_UpdateSkipPoint");
                            dispatchEvent(new MovieEvent(MovieEvent.Evt_UpdateSkipPoint));
                        }
                    }
                }
            }
            return;
        }// end function

        private function initCurEnjoyableSubTypeBySex() : void
        {
            var _loc_1:* = UserManager.getInstance().userLocalSex;
            if (_loc_1.getSex() == UserDef.USER_SEX_MALE)
            {
                if (this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE))
                {
                    this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_MALE;
                }
                else if (this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_COMMON))
                {
                    this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_COMMON;
                }
                else if (this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE))
                {
                    this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_FEMALE;
                }
                else
                {
                    this._curEnjoyableSubType = null;
                }
            }
            else if (this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE))
            {
                this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_FEMALE;
            }
            else if (this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_COMMON))
            {
                this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_COMMON;
            }
            else if (this.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE))
            {
                this._curEnjoyableSubType = SkipPointEnum.ENJOYABLE_SUB_MALE;
            }
            else
            {
                this._curEnjoyableSubType = null;
            }
            return;
        }// end function

        private function adjustDurationIndexOfCurEnjoyableSubType(param1:EnumItem, param2:int = -1) : int
        {
            var _loc_3:* = this.getEnjoyableSubDurationList(param1);
            if (_loc_3 == null || _loc_3.length == 0)
            {
                return -1;
            }
            var _loc_4:* = param2;
            if (_loc_4 < 0 || _loc_4 >= _loc_3.length || this._enjoyableMap[param1][_loc_3[_loc_4]] == null)
            {
                _loc_4 = _loc_3.length > 2 ? (int(_loc_3.length * 0.5)) : (0);
            }
            return _loc_4;
        }// end function

        private function compare(param1:SkipPointInfo, param2:SkipPointInfo) : int
        {
            return param1.startTime - param2.startTime;
        }// end function

        private function onLocalSexInitComplete(event:Event) : void
        {
            UserManager.getInstance().userLocalSex.removeEventListener(UserManagerEvent.Evt_LocalSexInitComplete, this.onLocalSexInitComplete);
            this.initEnjoyableSubSkipPoint();
            return;
        }// end function

    }
}
