package com.qiyi.player.core.model.utils
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.player.events.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.utils.*;
    import loader.vod.*;

    public class PingBack extends Object implements IDestroy
    {
        private var _playListID:String = "";
        private var _VVFrom:String = "";
        private var _VFrm:String = "";
        private var _VVFromtp:String = "";
        private var _vfm:String = "";
        private var _src:String = "";
        private var _refer:String = "";
        private var _holder:ICorePlayer;
        private var _decoder:IDecoder;
        private var _playingMovieTVId:String;
        private var _activePlayMovieTVId:String;
        private var _startPlayLtm:int;
        private var _loadMovieTime:int;
        private var _bufferCount:int = 0;
        private var _timer1:Timer;
        private var _timer2:Timer;
        private var _timer3:Timer;
        private var _CDNStatistics:uint;
        private var _flashP2PErro:Boolean = false;
        private var _irs:IRS;
        private var _irsTvid:String = "";
        private var _irsPostponeUpdate:Boolean = false;
        private var _openBarrage:Boolean = false;
        private var _isStarBarrage:Boolean = false;
        private var _log:ILogger;
        private var _lastSecondDroppedFrames:int = 0;
        private var _droppedFramesSeconds:int = 0;
        private var _droppedFrames:int = 0;
        private static const PING_BACK_ERR_URL:String = "http://msg.71.am/err.gif";
        private static const PING_BACK_URL:String = "http://msg.71.am/vpb.gif";
        private static const PING_SAVE_BANDWIDTH:String = "http://msg.71.am/vcache.gif";
        private static const PING_KA_URL:String = "http://uestat.video.qiyi.com/stat.html";
        private static const PING_TMP_STATS_URL:String = "http://msg.71.am/tmpstats.gif";
        private static const PING_BACK_QOE_URL:String = "http://activity.m.iqiyi.com/qoe.gif";
        private static const QOE_USERCHECK:String = "player_usercheck_succ";
        private static const QOE_VMS:String = "player_vms_succ";
        private static const QOE_SELF_LOAD:String = "player_self_succ";
        private static const QOE_P2P_LOAD:String = "player_p2p_succ";
        private static const QOE_META_LOAD:String = "player_meta_succ";
        private static const QOE_HISTORY:String = "player_history_succ";
        private static const QOE_PAGE_SHOW_VIDEO:String = "player_page_startplay_succ";
        private static const QOE_AD_INIT:String = "player_ad_init_succ";
        private static const QOE_SHOW_VIDEO:String = "player_startplay_succ";
        private static var _visits:String = "";
        private static var _source:String = "";
        private static var _coop:String = "";

        public function PingBack()
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.utils.pingback.PingBack");
            return;
        }// end function

        public function set loadMovieTime(param1:int) : void
        {
            this._loadMovieTime = param1;
            return;
        }// end function

        public function set source(param1:String) : void
        {
            _source = param1;
            return;
        }// end function

        public function set coop(param1:String) : void
        {
            _coop = param1;
            return;
        }// end function

        public function set playListID(param1:String) : void
        {
            this._playListID = param1;
            return;
        }// end function

        public function set VVFrom(param1:String) : void
        {
            this._VVFrom = param1;
            return;
        }// end function

        public function set VFrm(param1:String) : void
        {
            this._VFrm = param1;
            return;
        }// end function

        public function set VVFromtp(param1:String) : void
        {
            this._VVFromtp = param1;
            return;
        }// end function

        public function set vfm(param1:String) : void
        {
            this._vfm = param1;
            return;
        }// end function

        public function set refer(param1:String) : void
        {
            this._refer = param1;
            return;
        }// end function

        public function set src(param1:String) : void
        {
            this._src = param1;
            return;
        }// end function

        public function set visits(param1:String) : void
        {
            _visits = param1;
            return;
        }// end function

        public function set flashP2PErro(param1:Boolean) : void
        {
            this._flashP2PErro = param1;
            return;
        }// end function

        public function set openBarrage(param1:Boolean) : void
        {
            this._openBarrage = param1;
            return;
        }// end function

        public function set isStarBarrage(param1:Boolean) : void
        {
            this._isStarBarrage = param1;
            return;
        }// end function

        public function initHolder(param1:ICorePlayer) : void
        {
            if (param1.runtimeData.playerUseType != PlayerUseTypeEnum.MAIN)
            {
                return;
            }
            if (param1 && this._holder == null)
            {
                this._holder = param1;
                this._holder.addEventListener(PlayerEvent.Evt_StatusChanged, this.onStatusChanged);
                this._timer1 = new Timer(1000);
                this._timer1.addEventListener(TimerEvent.TIMER, this.onTimer1);
            }
            return;
        }// end function

        public function setReplay() : void
        {
            this._playingMovieTVId = "";
            this._activePlayMovieTVId = "";
            this.updateIRS();
            return;
        }// end function

        public function setPreloadStatus(param1:Boolean) : void
        {
            if (this._irsPostponeUpdate && !param1)
            {
                this.updateIRS();
                this._irsPostponeUpdate = false;
            }
            return;
        }// end function

        public function startFlashP2PFailedCDN() : void
        {
            if (this._timer3 == null)
            {
                this._timer3 = new Timer(2 * 60 * 1000);
                this._timer3.addEventListener(TimerEvent.TIMER, this.onTimer3);
            }
            if (!this._timer3.running)
            {
                this._timer3.start();
            }
            this._CDNStatistics = 0;
            return;
        }// end function

        public function stopFlashP2PFailedCDN() : void
        {
            if (this._timer3)
            {
                this._timer3.stop();
            }
            this._CDNStatistics = 0;
            return;
        }// end function

        public function addCDNStatistics(param1:int) : void
        {
            if (this._holder && this._holder.movie && !this._holder.movie.member && this._holder.runtimeData.playerType == PlayerTypeEnum.MAIN_STATION)
            {
                this._CDNStatistics = this._CDNStatistics + param1;
            }
            return;
        }// end function

        private function onStatusChanged(event:PlayerEvent) : void
        {
            if (event.data.isAdd as Boolean)
            {
                switch(event.data.status)
                {
                    case StatusEnum.IDLE:
                    {
                        break;
                    }
                    case StatusEnum.ALREADY_READY:
                    {
                        this._timer1.reset();
                        this._bufferCount = 0;
                        this.sendStartLoad();
                        if (this._timer2 == null)
                        {
                            this._timer2 = new Timer(60000);
                            this._timer2.addEventListener(TimerEvent.TIMER, this.onTimer2);
                        }
                        if (this._holder.movie && this._irsTvid != this._holder.movie.tvid)
                        {
                            this._irsTvid = this._holder.movie.tvid;
                            this.updateIRS();
                        }
                        break;
                    }
                    case StatusEnum.STOPPING:
                    {
                        this.setMovieStopTiming();
                        if (this._holder.stopReason == StopReasonEnum.SKIP_TRAILER || this._holder.stopReason == StopReasonEnum.STOP || this._holder.stopReason == StopReasonEnum.REACH_ASSIGN)
                        {
                            this._playingMovieTVId = "";
                            this._activePlayMovieTVId = "";
                            this._irsTvid = "";
                            this.sendStopPlay("t");
                            if (this._timer2)
                            {
                                this._timer2.stop();
                            }
                            this.noticeIRSEnd();
                            this.destroyIRS();
                        }
                        else if (this._holder.stopReason == StopReasonEnum.USER)
                        {
                            this._playingMovieTVId = "";
                            this._activePlayMovieTVId = "";
                            this._irsTvid = "";
                            this.sendStopPlay("f");
                            if (this._timer2)
                            {
                                this._timer2.stop();
                            }
                            this.noticeIRSEnd();
                            this.destroyIRS();
                        }
                        else if (this._holder.stopReason == StopReasonEnum.REFRESH)
                        {
                            this.sendStopPlay("f");
                        }
                        break;
                    }
                    case StatusEnum.FAILED:
                    {
                        this.setMovieStopTiming();
                        if (this._timer2 && this._timer2.running)
                        {
                            this._timer2.stop();
                        }
                        ProcessesTimeRecord.needRecord = false;
                        break;
                    }
                    case StatusEnum.PLAYING:
                    {
                        if (ProcessesTimeRecord.usedTime_showVideo == 0)
                        {
                        }
                        if (ProcessesTimeRecord.needRecord)
                        {
                            this.sendProcessesTimeRecord();
                        }
                        if (this._holder.runtimeData.vmsBackupUsed)
                        {
                            this._holder.runtimeData.vmsBackupUsed = false;
                            this.sendVMSError();
                        }
                        if (this._holder.movie && this._playingMovieTVId != this._holder.movie.tvid)
                        {
                            this._startPlayLtm = getTimer() - this._loadMovieTime;
                            this._playingMovieTVId = this._holder.movie.tvid;
                            this.sendStartPlay(String(int(this._startPlayLtm / 1000)));
                            Statistics.instance.addVV();
                        }
                        this.noticeIRSPlay();
                        if (!this._timer2.running)
                        {
                            this._timer2.start();
                        }
                        break;
                    }
                    case StatusEnum.PAUSED:
                    {
                        if (this._timer2.running)
                        {
                            this._timer2.stop();
                        }
                        this.noticeIRSPause();
                        break;
                    }
                    case StatusEnum.WAITING:
                    {
                        var _loc_2:String = this;
                        var _loc_3:* = this._bufferCount + 1;
                        _loc_2._bufferCount = _loc_3;
                        if (this._bufferCount == 3)
                        {
                            this.sendBuffer();
                        }
                        if (this._timer2.running)
                        {
                            this._timer2.stop();
                        }
                        this.noticeIRSPause();
                        break;
                    }
                    case StatusEnum.SEEKING:
                    {
                        this.noticeIRSSeek();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (this._holder.hasStatus(StatusEnum.PLAYING))
                {
                    this._timer1.start();
                }
                else
                {
                    this._timer1.stop();
                }
            }
            return;
        }// end function

        private function onTimer2(event:TimerEvent) : void
        {
            this.sendUEStatus();
            this._holder.runtimeData.bufferEmpty = 0;
            return;
        }// end function

        private function onTimer1(event:TimerEvent) : void
        {
            var _loc_3:int = 0;
            if (this._holder.decoderInfo)
            {
                _loc_3 = this._holder.decoderInfo.droppedFrames;
                if (_loc_3 != this._lastSecondDroppedFrames && _loc_3 > this._lastSecondDroppedFrames)
                {
                    if (_loc_3 - this._lastSecondDroppedFrames >= 5)
                    {
                        var _loc_4:String = this;
                        var _loc_5:* = this._droppedFramesSeconds + 1;
                        _loc_4._droppedFramesSeconds = _loc_5;
                    }
                    this._droppedFrames = this._droppedFrames + (_loc_3 - this._lastSecondDroppedFrames);
                    this._lastSecondDroppedFrames = _loc_3;
                }
            }
            var _loc_2:Number = 0;
            if (this._timer1.currentCount < 120)
            {
                if (this._timer1.currentCount == 15)
                {
                    _loc_2 = 15;
                }
                if (this._timer1.currentCount == 60)
                {
                    _loc_2 = 60;
                }
            }
            else if (this._timer1.currentCount % 120 == 0)
            {
                _loc_2 = 120;
            }
            if (_loc_2 != 0)
            {
                this.sendTiming(String(_loc_2));
            }
            if (this._timer1.currentCount % 60 == 0)
            {
                this._droppedFramesSeconds = 0;
                this._droppedFrames = 0;
            }
            return;
        }// end function

        private function setMovieStopTiming() : void
        {
            var _loc_1:Number = 0;
            if (this._timer1.currentCount < 15)
            {
                _loc_1 = this._timer1.currentCount;
            }
            else if (this._timer1.currentCount < 60 && this._timer1.currentCount > 15)
            {
                _loc_1 = this._timer1.currentCount - 15;
            }
            else if (this._timer1.currentCount < 120 && this._timer1.currentCount > 60)
            {
                _loc_1 = this._timer1.currentCount - 60;
            }
            else if (this._timer1.currentCount % 120 != 0)
            {
                _loc_1 = this._timer1.currentCount % 120;
            }
            if (_loc_1 != 0)
            {
                this.sendTiming(String(_loc_1));
            }
            this._timer1.stop();
            this._timer1.reset();
            return;
        }// end function

        private function onTimer3(event:TimerEvent) : void
        {
            var _loc_3:String = null;
            if (!P2PFileLoader.instance.isLoading && !P2PFileLoader.instance.loadDone && !P2PFileLoader.instance.loadErr)
            {
                return;
            }
            if (this._holder == null)
            {
                return;
            }
            var _loc_2:* = this._holder.movie;
            if (_loc_2 == null)
            {
                return;
            }
            if (!_loc_2.member && this._holder.runtimeData.playerType == PlayerTypeEnum.MAIN_STATION)
            {
                _loc_3 = "http://msg.video.qiyi.com/vodpb.gif?tag=share&p2p=0" + "&cdn=" + this._CDNStatistics + "&md=cdn" + (this._flashP2PErro ? ("_err") : ("")) + "&mi=" + _loc_2.channelID + "_" + _loc_2.albumId + "_" + _loc_2.tvid + "_" + _loc_2.vid + "&peerId=" + "&ran=" + Math.random();
                this._CDNStatistics = 0;
                this.fireData(_loc_3);
            }
            return;
        }// end function

        public function sendError(param1:int) : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:IMovie = null;
            var _loc_10:String = null;
            var _loc_11:Segment = null;
            var _loc_12:Object = null;
            if (this._holder && param1 > 0)
            {
                _loc_2 = "";
                _loc_3 = "";
                _loc_4 = "";
                _loc_5 = "";
                _loc_6 = 0;
                _loc_7 = "";
                _loc_8 = "";
                _loc_9 = this._holder.movie;
                if (_loc_9)
                {
                    _loc_2 = _loc_9.channelID.toString();
                    _loc_3 = _loc_9.tvid;
                    if (_loc_9.curDefinition && _loc_9.curDefinition.type)
                    {
                        _loc_8 = _loc_9.curDefinition.type.id.toString();
                    }
                    if (this._holder.hasStatus(StatusEnum.PLAYING) || this._holder.hasStatus(StatusEnum.PAUSED) || this._holder.hasStatus(StatusEnum.SEEKING) || this._holder.hasStatus(StatusEnum.WAITING))
                    {
                        _loc_6 = int(this._holder.currentTime / 1000);
                        _loc_11 = _loc_9.getSegmentByTime(this._holder.currentTime);
                        if (_loc_11 && this._holder.runtimeData.userDisInfo)
                        {
                            _loc_12 = this._holder.runtimeData.userDisInfo[_loc_11.index];
                            if (_loc_12)
                            {
                                _loc_4 = _loc_12.t;
                                _loc_5 = _loc_12.z;
                            }
                        }
                    }
                }
                else
                {
                    _loc_3 = this._holder.runtimeData.tvid;
                }
                if (this._holder.runtimeData.errorCodeValue && param1 == 104)
                {
                    _loc_7 = this._holder.runtimeData.errorCodeValue.st;
                }
                _loc_10 = "?flag=" + PingBackFlagEnum.ERROR.name + "&plyrver=" + Version.VERSION + "&errcode=" + param1 + "&vrsrtcode=" + _loc_7 + "&suid=" + this._holder.uuid + "&cid=" + _loc_2 + "&tvid=" + _loc_3 + "&pla=" + this._holder.runtimeData.platform.name + "&sttntp=" + this._holder.runtimeData.station.id.toString() + "&plyrtp=" + this._holder.runtimeData.playerType.id.toString() + "&z=" + _loc_5 + "&diaoduuip=" + _loc_4 + "&prgr=" + _loc_6 + "&dwnldspd=" + this._holder.runtimeData.currentAverageSpeed + "&lev=" + _loc_8 + "&as=" + this.getMD5Code(_loc_3, this._holder.runtimeData.platform.name, this._holder.uuid, this._holder.videoEventID) + "&veid=" + this._holder.videoEventID + "&weid=" + UUIDManager.instance.getWebEventID() + "&puid=" + (UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("")) + "&hu=" + this.getVipUserType() + "&tn=" + String(Math.random());
                if (_coop != "")
                {
                    _loc_10 = _loc_10 + ("&coop=" + _coop);
                }
                else if (_source != "")
                {
                    _loc_10 = _loc_10 + ("&source=" + _source);
                }
                this.fireData(PING_BACK_ERR_URL + _loc_10);
                this._log.info("Core PingBack,ErrorCode is " + param1);
            }
            return;
        }// end function

        public function sendErrorAuto(param1:int, param2:int = 0, param3:Object = null) : void
        {
            var f4vStr:String;
            var jsonObject:Object;
            var jsonStr:String;
            var jsonBytes:ByteArray;
            var loader:URLLoader;
            var request:URLRequest;
            var $errorCode:* = param1;
            var $st:* = param2;
            var $f4vObject:* = param3;
            if (this._holder && $errorCode > 0)
            {
                try
                {
                    f4vStr;
                    if ($f4vObject)
                    {
                        f4vStr = JSON.encode($f4vObject);
                    }
                    jsonObject = new Object();
                    jsonObject._bizType = "vrs_logRecord";
                    jsonObject.tvid = this._holder.runtimeData.tvid;
                    jsonObject.version = Version.VERSION;
                    jsonObject.errorcode = String($errorCode);
                    jsonObject.st = String($st);
                    jsonObject.f4v = f4vStr;
                    jsonObject.log_content = LogManager.getLifeLogs().join("\n");
                    jsonStr = JSON.encode(jsonObject);
                    jsonBytes = new ByteArray();
                    jsonBytes.writeMultiByte(jsonStr, "utf-8");
                    jsonBytes.compress();
                    loader = new URLLoader();
                    loader.addEventListener(Event.COMPLETE, function (event:Event) : void
            {
                return;
            }// end function
            );
                    loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function (event:Event) : void
            {
                return;
            }// end function
            );
                    loader.addEventListener(IOErrorEvent.IO_ERROR, function (event:Event) : void
            {
                return;
            }// end function
            );
                    loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (event:Event) : void
            {
                return;
            }// end function
            );
                    request = new URLRequest("http://tracker.sns.iqiyi.com/naja/log/collect_log");
                    request.method = URLRequestMethod.POST;
                    request.requestHeaders = [new URLRequestHeader("Content-Encoding", "zlib")];
                    request.contentType = "application/octet-stream";
                    request.data = jsonBytes;
                    loader.load(request);
                }
                catch (error:Error)
                {
                }
            }
            return;
        }// end function

        public function sendBuffer() : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_1:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.BUFFER_EMPTY.name + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_1);
            return;
        }// end function

        public function sendStartLoad() : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_1:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.START_LOAD + "&prgr=" + int(this._holder.strategy.getStartTime());
            _loc_1 = _loc_1 + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_1);
            return;
        }// end function

        public function sendStartPlay(param1:String) : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_2:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.START_PLAY.name + "&prgr=" + int(this._holder.currentTime / 1000) + "&ltm=" + param1 + "&purl=" + this.getPageLocationHref() + "&vvfrmtp=" + this._VVFromtp + "&clltid=" + this._holder.runtimeData.collectionID + "&src=" + this._src + "&rfr=" + this.getPageReferrer() + this.commonParam();
            UUIDManager.instance.isNewUser = false;
            this.fireData(PING_BACK_URL + _loc_2);
            return;
        }// end function

        private function sendReady() : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_1:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.READY.name + "&purl=" + this.getPageLocationHref() + "&vvfrmtp=" + this._VVFromtp + "&rfr=" + this.getPageReferrer() + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_1);
            return;
        }// end function

        private function sendVMSError() : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_1:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.VMS_ERROR.name + "&purl=" + this.getPageLocationHref() + "&vvfrmtp=" + this._VVFromtp + "&rfr=" + this.getPageReferrer() + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_1);
            return;
        }// end function

        public function sendActivePlay() : void
        {
            var _loc_1:String = null;
            if (this._holder == null)
            {
                return;
            }
            if (this._holder.movie && this._activePlayMovieTVId != this._holder.movie.tvid)
            {
                this._activePlayMovieTVId = this._holder.movie.tvid;
                _loc_1 = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.ACTIVE_PLAY.name + this.commonParam();
                this.fireData(PING_BACK_URL + _loc_1);
            }
            return;
        }// end function

        public function sendSaveBandWidth(param1:int, param2:int) : void
        {
            var _loc_3:String = null;
            if (this._holder == null || param1 <= 0 || param1 >= 360000)
            {
                return;
            }
            try
            {
                if (Math.abs(this._holder.currentTime - this._holder.runtimeData.startPlayTime) < 1000)
                {
                    return;
                }
                _loc_3 = PING_SAVE_BANDWIDTH;
                _loc_3 = _loc_3 + ("?pt=" + this._holder.runtimeData.playerType.id.toString());
                _loc_3 = _loc_3 + ("&cv=" + Version.VERSION);
                _loc_3 = _loc_3 + ("&cid=" + this._holder.movie.channelID.toString());
                _loc_3 = _loc_3 + ("&aid=" + this._holder.movie.albumId);
                _loc_3 = _loc_3 + ("&tvid=" + this._holder.movie.tvid);
                _loc_3 = _loc_3 + ("&lev=" + this._holder.movie.curDefinition.type.id);
                _loc_3 = _loc_3 + ("&dtl=" + int(param1 / 1000).toString());
                _loc_3 = _loc_3 + ("&type=" + param2.toString());
                this.fireData(_loc_3);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function sendStopPlay(param1:String = "") : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_2:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.STOP_PLAY.name + "&prgr=" + int(this._holder.currentTime / 1000) + "&src=" + this._src + "&finish=" + param1 + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_2);
            return;
        }// end function

        public function sendTiming(param1:String) : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_2:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.TIMMING.name + "&prgr=" + int(this._holder.currentTime / 1000) + "&lostfrm=" + this._droppedFrames.toString() + "&lostfrmsec=" + this._droppedFramesSeconds.toString() + "&tl=" + param1 + "&src=" + this._src + "&purl=" + this.getPageLocationHref() + "&rfr=" + this.getPageReferrer() + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_2);
            return;
        }// end function

        public function sendAutoDefinition(param1:int, param2:int) : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_3:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.DOWN_DEFINITION.name + "&dwnfrom=" + param1 + "&dwnto=" + param2 + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_3);
            return;
        }// end function

        private function sendComScorePing() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:String = null;
            if (this._holder)
            {
                try
                {
                    _loc_1 = "1";
                    _loc_2 = "7290408";
                    _loc_3 = "";
                    _loc_4 = "11";
                    _loc_5 = "";
                    _loc_6 = "";
                    _loc_7 = "";
                    _loc_8 = this._holder.uuid;
                    if (this._holder.movieInfo)
                    {
                        _loc_7 = encodeURIComponent(this._holder.movieInfo.pageUrl);
                    }
                    if (this._holder.movieModel)
                    {
                        _loc_3 = this._holder.movieModel.channelID.toString();
                    }
                    _loc_9 = "http://b.scorecardresearch.com/b?" + new Array("c1=", _loc_1, "&c2=", _loc_2, "&c3=", _loc_3, "&c4=", _loc_4, "&c5=", _loc_5, "&c6=", _loc_6, "&c7=", _loc_7, "&c8=&c9=&c10=&c11=", _loc_8).join("");
                    this.fireData(_loc_9);
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        private function sendComScoreTWPing() : void
        {
            return;
        }// end function

        public function sendVRSRequestTime(param1:int) : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_2:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.VRS_REQUEST_TIME.name + "&vms=" + "1" + "&tl=" + param1 + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_2);
            return;
        }// end function

        public function sendStartLoadVrs() : void
        {
            if (this._holder == null)
            {
                return;
            }
            var _loc_1:* = "?flag=" + PingBackFlagEnum.PLAYER_ACT.name + "&plyract=" + PingBackPlayerActionEnum.VRS_START_LOAD.name;
            _loc_1 = _loc_1 + this.commonParam();
            this.fireData(PING_BACK_URL + _loc_1);
            return;
        }// end function

        private function sendProcessesTimeRecord() : void
        {
            var _loc_1:String = null;
            if (this._holder == null)
            {
                return;
            }
            if (ProcessesTimeRecord.needRecord)
            {
                ProcessesTimeRecord.needRecord = false;
                _loc_1 = "?type=plypfmc140109";
                if (ProcessesTimeRecord.usedTime_userInfo > 0)
                {
                    _loc_1 = _loc_1 + ("&tm1=" + ProcessesTimeRecord.usedTime_userInfo + "," + ProcessesTimeRecord.STime_userInfo);
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_USERCHECK, ProcessesTimeRecord.usedTime_userInfo);
                    }
                }
                if (ProcessesTimeRecord.usedTime_P2PCore > 0)
                {
                    _loc_1 = _loc_1 + ("&tm2=" + ProcessesTimeRecord.usedTime_P2PCore + "," + ProcessesTimeRecord.STime_P2PCore);
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_P2P_LOAD, ProcessesTimeRecord.usedTime_P2PCore);
                    }
                }
                if (ProcessesTimeRecord.usedTime_VInfo > 0)
                {
                    _loc_1 = _loc_1 + ("&tm3=" + ProcessesTimeRecord.usedTime_VInfo + "," + ProcessesTimeRecord.STime_VInfo);
                }
                if (ProcessesTimeRecord.usedTime_VP > 0)
                {
                    _loc_1 = _loc_1 + ("&tm4=" + ProcessesTimeRecord.usedTime_VP + "," + ProcessesTimeRecord.STime_VP);
                }
                if (ProcessesTimeRecord.usedTime_VI > 0)
                {
                    _loc_1 = _loc_1 + ("&tm5=" + ProcessesTimeRecord.usedTime_VI + "," + ProcessesTimeRecord.STime_VI);
                }
                if (ProcessesTimeRecord.usedTime_meta > 0)
                {
                    _loc_1 = _loc_1 + ("&tm6=" + ProcessesTimeRecord.usedTime_meta + "," + ProcessesTimeRecord.STime_meta);
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_META_LOAD, ProcessesTimeRecord.usedTime_meta);
                    }
                }
                if (ProcessesTimeRecord.usedTime_history > 0)
                {
                    _loc_1 = _loc_1 + ("&tm7=" + ProcessesTimeRecord.usedTime_history + "," + ProcessesTimeRecord.STime_history);
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_HISTORY, ProcessesTimeRecord.usedTime_history);
                    }
                }
                if (ProcessesTimeRecord.usedTime_pageShowVideo > 0 && ProcessesTimeRecord.usedTime_pageShowVideo < 120000 && ProcessesTimeRecord.usedTime_userInfo == 0)
                {
                    _loc_1 = _loc_1 + ("&tm8=" + ProcessesTimeRecord.usedTime_pageShowVideo + ",0");
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_PAGE_SHOW_VIDEO, ProcessesTimeRecord.usedTime_pageShowVideo, 12000);
                    }
                }
                if (ProcessesTimeRecord.usedTime_showVideo > 0 && ProcessesTimeRecord.usedTime_showVideo < 60000 && ProcessesTimeRecord.usedTime_userInfo == 0)
                {
                    _loc_1 = _loc_1 + ("&tm9=" + ProcessesTimeRecord.usedTime_showVideo + "," + ProcessesTimeRecord.STime_showVideo);
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_SHOW_VIDEO, ProcessesTimeRecord.usedTime_showVideo, 12000);
                    }
                }
                if (ProcessesTimeRecord.usedTime_vms > 0)
                {
                    _loc_1 = _loc_1 + ("&tm10=" + ProcessesTimeRecord.usedTime_vms + "," + ProcessesTimeRecord.STime_vms);
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_VMS, ProcessesTimeRecord.usedTime_vms);
                    }
                }
                if (ProcessesTimeRecord.usedTime_adInit > 0)
                {
                    _loc_1 = _loc_1 + ("&tm11=" + ProcessesTimeRecord.usedTime_adInit + "," + ProcessesTimeRecord.STime_adInit);
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_AD_INIT, ProcessesTimeRecord.usedTime_adInit);
                    }
                }
                if (ProcessesTimeRecord.usedTime_selfLoaded > 0 && ProcessesTimeRecord.usedTime_selfLoaded < 60000)
                {
                    _loc_1 = _loc_1 + ("&tm12=" + ProcessesTimeRecord.usedTime_selfLoaded + ",0");
                    if (int(Math.random() * 100) == 55)
                    {
                        this.sendQoeData(QOE_SELF_LOAD, ProcessesTimeRecord.usedTime_selfLoaded);
                    }
                }
                if (ProcessesTimeRecord.browserType)
                {
                    _loc_1 = _loc_1 + ("&brs=" + ProcessesTimeRecord.browserType);
                }
                if (ProcessesTimeRecord.pageTmpltType)
                {
                    _loc_1 = _loc_1 + ("&tmplt=" + ProcessesTimeRecord.pageTmpltType);
                }
                _loc_1 = _loc_1 + this.commonParam();
                this.fireData(PING_TMP_STATS_URL + _loc_1);
            }
            return;
        }// end function

        private function commonParam() : String
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:String = null;
            var _loc_10:String = null;
            var _loc_11:String = null;
            var _loc_12:String = null;
            var _loc_13:IMovie = null;
            var _loc_14:String = null;
            var _loc_15:String = null;
            var _loc_16:String = null;
            var _loc_17:String = null;
            var _loc_18:String = null;
            var _loc_19:IUser = null;
            var _loc_20:String = null;
            var _loc_21:Segment = null;
            var _loc_22:Object = null;
            if (this._holder)
            {
                _loc_1 = "";
                _loc_2 = "";
                _loc_3 = "";
                _loc_4 = "";
                _loc_5 = "";
                _loc_6 = this._holder.uuid;
                _loc_7 = UUIDManager.instance.isNewUser ? ("1") : ("0");
                _loc_8 = "";
                _loc_9 = "";
                _loc_10 = "";
                _loc_11 = "";
                _loc_12 = "";
                _loc_13 = this._holder.movie;
                if (_loc_13)
                {
                    _loc_1 = _loc_13.vid;
                    _loc_2 = _loc_13.albumId;
                    _loc_5 = _loc_13.tvid;
                    _loc_3 = _loc_13.channelID.toString();
                    _loc_12 = _loc_13.uploaderID;
                    if (_loc_13.curDefinition && _loc_13.curDefinition.type)
                    {
                        _loc_4 = _loc_13.curDefinition.type.id.toString();
                    }
                    if (this._holder.hasStatus(StatusEnum.PLAYING) || this._holder.hasStatus(StatusEnum.PAUSED) || this._holder.hasStatus(StatusEnum.SEEKING) || this._holder.hasStatus(StatusEnum.WAITING))
                    {
                        _loc_21 = _loc_13.getSegmentByTime(this._holder.currentTime);
                        if (_loc_21 && this._holder.runtimeData.userDisInfo)
                        {
                            _loc_22 = this._holder.runtimeData.userDisInfo[_loc_21.index];
                            if (_loc_22)
                            {
                                _loc_8 = _loc_22.t;
                                _loc_9 = _loc_22.z;
                            }
                        }
                    }
                    _loc_10 = _loc_13.member ? ("1") : ("0");
                    _loc_11 = _loc_13.streamType == StreamEnum.RTMP ? ("1") : ("2");
                }
                else
                {
                    _loc_5 = this._holder.runtimeData.tvid;
                    _loc_1 = this._holder.runtimeData.vid;
                }
                _loc_14 = this._holder.runtimeData.platform.name;
                _loc_15 = this._holder.runtimeData.station.id.toString();
                _loc_16 = this._holder.runtimeData.playerType.id.toString();
                _loc_17 = Version.VERSION;
                _loc_18 = this.getVipUserType();
                _loc_19 = UserManager.getInstance().user;
                _loc_20 = "&aid=" + _loc_2 + "&tvid=" + _loc_5 + "&vid=" + _loc_1 + "&cid=" + _loc_3 + "&lev=" + _loc_4 + "&puid=" + (_loc_19 ? (_loc_19.passportID) : ("")) + "&pru=" + (_loc_19 ? (_loc_19.profileID) : ("")) + "&veid=" + this._holder.videoEventID + "&weid=" + UUIDManager.instance.getWebEventID() + "&newusr=" + _loc_7 + "&pla=" + _loc_14 + "&visits=" + _visits + "&sttntp=" + _loc_15 + "&plyrtp=" + _loc_16 + "&plyrver=" + _loc_17 + "&z=" + _loc_9 + "&suid=" + _loc_6 + "&diaoduuip=" + _loc_8 + "&plid=" + this._playListID + "&vvfrom=" + this._VVFrom + "&vfrm=" + this._VFrm + "&vfm=" + this._vfm + "&restp=" + _loc_11 + "&ispur=" + _loc_10 + "&as=" + this.getMD5Code(_loc_5, _loc_14, _loc_6, this._holder.videoEventID) + "&isdm=" + (this._openBarrage ? ("1") : ("0")) + "&isstar=" + (this._isStarBarrage ? ("1") : ("0")) + "&hu=" + _loc_18 + "&mod=" + this._holder.runtimeData.localize + "&tn=" + String(Math.random());
                if (_coop != "")
                {
                    _loc_20 = _loc_20 + ("&coop=" + _coop);
                }
                else if (_source != "")
                {
                    _loc_20 = _loc_20 + ("&source=" + _source);
                }
                if (_loc_12 && _loc_12 != "0")
                {
                    _loc_20 = _loc_20 + ("&upderid=" + _loc_12);
                }
                if (this._holder.runtimeData.playerType == PlayerTypeEnum.SHARE && this._holder.runtimeData.tg != "")
                {
                    _loc_20 = _loc_20 + ("&tg=" + this._holder.runtimeData.tg);
                }
                if (this._holder.runtimeData.movieIsMember && this._holder.authenticationResult && this._holder.authenticationResult.data && this._holder.authenticationResult.data.u)
                {
                    _loc_20 = _loc_20 + ("&qy_uid=" + this._holder.authenticationResult.data.u);
                    _loc_20 = _loc_20 + ("&qy_cid=" + this._holder.authenticationResult.data.cid);
                    _loc_20 = _loc_20 + ("&qy_user_type=" + this._holder.authenticationResult.data.u_type);
                    _loc_20 = _loc_20 + ("&qy_prv=" + this._holder.authenticationResult.data.prv);
                    _loc_20 = _loc_20 + ("&qy_vip_level=" + this._holder.authenticationResult.data.v_level);
                    _loc_20 = _loc_20 + ("&qy_chl_uid=" + this._holder.authenticationResult.data.chl_u);
                }
                return _loc_20;
            }
            return "";
        }// end function

        private function getPageReferrer() : String
        {
            var referrer:String;
            try
            {
                referrer = ExternalInterface.call("function(){return window.document.referrer;}");
                if (referrer)
                {
                    referrer = encodeURIComponent(referrer);
                }
            }
            catch (e:Error)
            {
                referrer;
            }
            return referrer;
        }// end function

        private function getPageLocationHref() : String
        {
            var location:String;
            try
            {
                location = ExternalInterface.call("function(){return window.location.href;}");
                if (location)
                {
                    location = encodeURIComponent(location);
                }
            }
            catch (e:Error)
            {
                location;
            }
            if (location == "")
            {
                location = encodeURIComponent(this._refer);
            }
            return location;
        }// end function

        public function sendUEStatus() : void
        {
            if (this._holder == null)
            {
                return;
            }
            if (this._holder.runtimeData.bufferEmpty == 0 && !this._holder.hasStatus(StatusEnum.PLAYING))
            {
                return;
            }
            var _loc_1:* = PING_KA_URL;
            _loc_1 = _loc_1 + ("?pt=" + (this._holder.movie.streamType == StreamEnum.HTTP ? ("web") : ("fms")));
            _loc_1 = _loc_1 + ("&uid=" + this._holder.uuid);
            _loc_1 = _loc_1 + ("&vid=" + this._holder.movie.vid);
            _loc_1 = _loc_1 + ("&ds=" + this._holder.runtimeData.preDispatchArea);
            _loc_1 = _loc_1 + ("&ul=" + this._holder.runtimeData.currentUserArea);
            _loc_1 = _loc_1 + ("&bk=" + this._holder.runtimeData.bufferEmpty.toString());
            _loc_1 = _loc_1 + ("&tn=" + getTimer());
            this.fireData(_loc_1);
            return;
        }// end function

        private function getMD5Code(param1:String, param2:String, param3:String, param4:String) : String
        {
            return MD5.calculate(param1 + param2 + param3 + param4 + "gOzRI9CPVgObCIj0rpjuX1gOs");
        }// end function

        private function fireData(param1:String) : void
        {
            var _loc_2:URLRequest = null;
            if (this._holder)
            {
                _loc_2 = new URLRequest();
                _loc_2.url = param1;
                sendToURL(_loc_2);
            }
            return;
        }// end function

        private function sendQoeData(param1:String, param2:uint, param3:uint = 5000) : void
        {
            var _loc_4:* = PING_BACK_QOE_URL + "?groupname=www_if_" + param1 + "&" + param1 + "=" + param2 + "&limit=" + param3;
            this.fireData(_loc_4);
            return;
        }// end function

        private function updateIRS() : void
        {
            var _loc_1:uint = 0;
            if (this._holder && this._holder.movie)
            {
                if (this._holder.isPreload)
                {
                    this._irsPostponeUpdate = true;
                }
                else
                {
                    this.sendReady();
                    try
                    {
                        _loc_1 = getTimer();
                        if (this._irs == null)
                        {
                            this._irs = new IRS();
                            this._irs._IWT_Debug = false;
                            if (this._holder.runtimeData.playerType == PlayerTypeEnum.MAIN_STATION)
                            {
                                this._irs._IWT_UAID = "UA-iqiyi-100009";
                            }
                            else
                            {
                                this._irs._IWT_UAID = "UA-iqiyi-100008";
                            }
                        }
                        this._irs.IRS_NewPlay(this._holder.movie.tvid, int(this._holder.movie.duration / 1000), false, this._holder.runtimeData.originalVid, "", this._holder.uuid);
                        this._log.info("IRS IRS_NewPlay Elapsed Time:" + (getTimer() - _loc_1) + "ms");
                    }
                    catch (e:Error)
                    {
                    }
                    this._irsPostponeUpdate = false;
                    this.sendComScoreTWPing();
                    this.sendComScorePing();
                }
            }
            return;
        }// end function

        private function noticeIRSPlay() : void
        {
            if (this._irs)
            {
                try
                {
                    this._irs.IRS_UserACT("play");
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        private function noticeIRSPause() : void
        {
            if (this._irs)
            {
                try
                {
                    this._irs.IRS_UserACT("pause");
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        private function noticeIRSSeek() : void
        {
            if (this._irs)
            {
                try
                {
                    this._irs.IRS_UserACT("drag");
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        private function noticeIRSEnd() : void
        {
            if (this._irs)
            {
                try
                {
                    this._irs.IRS_UserACT("end");
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        private function destroyIRS() : void
        {
            if (this._irs)
            {
                try
                {
                    this._irs.destroy();
                }
                catch (e:Error)
                {
                }
                this._irs = null;
            }
            return;
        }// end function

        private function getVipUserType() : String
        {
            var _loc_1:String = "";
            var _loc_2:* = UserManager.getInstance().user;
            if (_loc_2)
            {
                if (_loc_2.limitationType == UserDef.USER_LIMITATION_UPPER || _loc_2.limitationType == UserDef.USER_LIMITATION_CLOSING)
                {
                    _loc_1 = "0";
                }
                else if (_loc_2.level != UserDef.USER_LEVEL_NORMAL)
                {
                    _loc_1 = "1";
                }
                else
                {
                    _loc_1 = "-1";
                }
            }
            return _loc_1;
        }// end function

        public function destroy() : void
        {
            this._playingMovieTVId = "";
            this._activePlayMovieTVId = "";
            this._bufferCount = 0;
            if (this._holder)
            {
                this._holder.removeEventListener(PlayerEvent.Evt_StatusChanged, this.onStatusChanged);
                this._holder = null;
            }
            if (this._timer1)
            {
                this._timer1.stop();
                this._timer1.removeEventListener(TimerEvent.TIMER, this.onTimer1);
                this._timer1 = null;
            }
            if (this._timer2)
            {
                this._timer2.removeEventListener(TimerEvent.TIMER, this.onTimer2);
                this._timer2.stop();
                this._timer2 = null;
            }
            if (this._timer3)
            {
                this._timer3.removeEventListener(TimerEvent.TIMER, this.onTimer3);
                this._timer3.stop();
                this._timer3 = null;
            }
            this.destroyIRS();
            return;
        }// end function

    }
}
