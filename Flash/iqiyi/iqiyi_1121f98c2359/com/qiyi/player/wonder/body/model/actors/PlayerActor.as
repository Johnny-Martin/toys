package com.qiyi.player.wonder.body.model.actors
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.player.events.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.view.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.status.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;

    public class PlayerActor extends Object
    {
        private var _facade:IFacade;
        private var _status:Status;
        private var _isInit:Boolean = false;
        private var _isPreload:Boolean = false;
        private var _isPlayRefreshed:Boolean = false;
        private var _smallWindowMode:Boolean = false;
        private var _player:IPlayer;
        private var _loadMovieParams:LoadMovieParams;
        private var _loadMovieType:String = "";
        private var _playStartTime:int = 0;
        private var _playingDuration:int = 0;
        private var _waitingDuration:int = 0;
        private var _focusTipsMap:Dictionary;
        private var _needTryWatchArrCheck:Boolean = true;
        private var _timer:Timer;
        private var _playerStatusDelay:TweenLite;
        private var _log:ILogger;

        public function PlayerActor(param1:IFacade)
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.body.model.actors.PlayerActor");
            this._facade = param1;
            this._status = new Status(BodyDef.PLAYER_STATUS_BEGIN, BodyDef.PLAYER_STATUS_END);
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
            {
                this._player = CoreManager.getInstance().createPlayer(PlayerUseTypeEnum.MAIN);
            }
            this._player.needFilterQualityDefinition = FlashVarConfig.outsite;
            this._player.isPreload = this._isPreload;
            this._player.pbPlayListID = FlashVarConfig.playListID;
            this._player.pbVVFrom = FlashVarConfig.videoFrom;
            this._player.pbVVFromtp = PingBackDef.VVPING_USER_CLICK;
            this._player.pbVFrm = FlashVarConfig.vfrm;
            this._player.pbOpenBarrage = FlashVarConfig.openBarrage;
            this._player.localize = FlashVarConfig.localize;
            switch(FlashVarConfig.localize)
            {
                case LocalizaEnum.LOCALIZE_TW_T.name:
                case LocalizaEnum.LOCALIZE_TW_S.name:
                {
                    this._player.areaPlatform = PlatformEnum.TW_PF;
                    break;
                }
                case LocalizaEnum.LOCALIZE_CN_S.name:
                case LocalizaEnum.LOCALIZE_CN_T.name:
                {
                    this._player.areaPlatform = PlatformEnum.CN_PF;
                    break;
                }
                default:
                {
                    this._player.areaPlatform = PlatformEnum.CN_PF;
                    break;
                    break;
                }
            }
            this._timer = new Timer(BodyDef.PLAYER_TIMER_TIME);
            return;
        }// end function

        public function init(param1:Sprite, param2:Boolean = true) : void
        {
            if (!this._isInit)
            {
                this._player.initialize(param1, param2);
                this._player.addEventListener(PlayerEvent.Evt_Error, this.onPlayerError);
                this._player.addEventListener(PlayerEvent.Evt_DefinitionSwitched, this.onPlayerDefinitionSwitched);
                this._player.addEventListener(PlayerEvent.Evt_AudioTrackSwitched, this.onPlayerAudioTrackSwitched);
                this._player.addEventListener(PlayerEvent.Evt_MovieInfoReady, this.onPlayerMovieInfoReady);
                this._player.addEventListener(PlayerEvent.Evt_GPUChanged, this.onPlayerGPUChanged);
                this._player.addEventListener(PlayerEvent.Evt_PreparePlayEnd, this.onPlayerPreparePlayEnd);
                this._player.addEventListener(PlayerEvent.Evt_SkipTrailer, this.onPlayerSkipTrailer);
                this._player.addEventListener(PlayerEvent.Evt_StartFromHistory, this.onPlayerStartFromHistory);
                this._player.addEventListener(PlayerEvent.Evt_SkipTitle, this.onPlayerSkipTitle);
                this._player.addEventListener(PlayerEvent.Evt_StatusChanged, this.onPlayerStatusChanged);
                this._player.addEventListener(PlayerEvent.Evt_Stuck, this.onPlayerStuck);
                this._player.addEventListener(PlayerEvent.Evt_EnterPrepareSkipPoint, this.onPlayerEnterPrepareSkipPoint);
                this._player.addEventListener(PlayerEvent.Evt_OutPrepareSkipPoint, this.onPlayerOutPrepareSkipPoint);
                this._player.addEventListener(PlayerEvent.Evt_OutPrepareSkipPoint, this.onPreparePlayEndSkipPoint);
                this._player.addEventListener(PlayerEvent.Evt_EnterSkipPoint, this.onPlayerEnterSkipPoint);
                this._player.addEventListener(PlayerEvent.Evt_OutSkipPoint, this.onPlayerOutSkipPoint);
                this._player.addEventListener(PlayerEvent.Evt_FreshedSkipPoints, this.onFreshedSkipPoints);
                this._player.addEventListener(PlayerEvent.Evt_EnterPrepareLeaveSkipPoint, this.onEnterPrepareLeaveSkipPoint);
                this._player.addEventListener(PlayerEvent.Evt_OutPrepareLeaveSkipPoint, this.onOutPrepareLeaveSkipPoint);
                this._player.addEventListener(PlayerEvent.Evt_EnjoyableSubTypeInited, this.onEnjoyableSubTypeInited);
                this._timer.addEventListener(TimerEvent.TIMER, this.onTimer);
                this._timer.start();
                this._isInit = true;
            }
            return;
        }// end function

        public function get corePlayer() : IPlayer
        {
            return this._player;
        }// end function

        public function set openSelectPlay(param1:Boolean) : void
        {
            this._player.openSelectPlay = param1;
            return;
        }// end function

        public function set pbVVFromtp(param1:String) : void
        {
            this._player.pbVVFromtp = param1;
            return;
        }// end function

        public function set vfrm(param1:String) : void
        {
            this._player.pbVFrm = param1;
            return;
        }// end function

        public function set openBarrage(param1:Boolean) : void
        {
            this._player.pbOpenBarrage = param1;
            return;
        }// end function

        public function set isStarBarrage(param1:Boolean) : void
        {
            this._player.pbIsStarBarrage = param1;
            return;
        }// end function

        public function get openSelectPlay() : Boolean
        {
            return this._player.openSelectPlay;
        }// end function

        public function set isPreload(param1:Boolean) : void
        {
            this._isPreload = param1;
            this._player.isPreload = this._isPreload;
            return;
        }// end function

        public function panVideo(param1:Number) : void
        {
            this._player.panVideo(param1);
            return;
        }// end function

        public function tiltVideo(param1:Number) : void
        {
            this._player.tiltVideo(param1);
            return;
        }// end function

        public function zoomVideo(param1:Number) : void
        {
            this._player.zoomVideo(param1);
            return;
        }// end function

        public function uploadHistory() : void
        {
            this._player.uploadHistory();
            return;
        }// end function

        public function get isPreload() : Boolean
        {
            return this._isPreload;
        }// end function

        public function get isPlayRefreshed() : Boolean
        {
            return this._isPlayRefreshed;
        }// end function

        public function get loadMovieParams() : LoadMovieParams
        {
            return this._loadMovieParams;
        }// end function

        public function get loadMovieType() : String
        {
            return this._loadMovieType;
        }// end function

        public function get strategy() : IStrategy
        {
            return this._player.strategy;
        }// end function

        public function get floatLayer() : ILayer
        {
            return this._player.layer;
        }// end function

        public function get uuid() : String
        {
            return this._player.uuid;
        }// end function

        public function get videoEventID() : String
        {
            return this._player.videoEventID;
        }// end function

        public function get serverTime() : uint
        {
            return this._player.serverTime;
        }// end function

        public function set visits(param1:String) : void
        {
            this._player.visits = param1;
            return;
        }// end function

        public function setEnjoyableSubType(param1:EnumItem, param2:int) : void
        {
            this._player.setEnjoyableSubType(param1, param2);
            return;
        }// end function

        public function get movieModel() : IMovieModel
        {
            return this._player.movieModel;
        }// end function

        public function get movieInfo() : IMovieInfo
        {
            return this._player.movieInfo;
        }// end function

        public function get errorCode() : int
        {
            return this._player.errorCode;
        }// end function

        public function get errorCodeValue() : Object
        {
            return this._player.errorCodeValue;
        }// end function

        public function get authenticationResult() : Object
        {
            return this._player.authenticationResult;
        }// end function

        public function get authenticationError() : Boolean
        {
            return this._player.authenticationError;
        }// end function

        public function get accStatus() : EnumItem
        {
            return this._player.accStatus;
        }// end function

        public function get currentTime() : int
        {
            return this._player.currentTime;
        }// end function

        public function get bufferTime() : int
        {
            return this._player.bufferTime;
        }// end function

        public function get loadComplete() : Boolean
        {
            return this._player.loadComplete;
        }// end function

        public function get speed() : int
        {
            return this._player.currentSpeed;
        }// end function

        public function get playingDuration() : int
        {
            if (this._status.hasStatus(BodyDef.PLAYER_STATUS_STOPPING))
            {
                return this._playingDuration;
            }
            return this._player.playingDuration;
        }// end function

        public function get waitingDuration() : int
        {
            if (this._status.hasStatus(BodyDef.PLAYER_STATUS_STOPPING))
            {
                return this._waitingDuration;
            }
            return this._player.waitingDuration;
        }// end function

        public function get stopReason() : EnumItem
        {
            return this._player.stopReason;
        }// end function

        public function get isNaturalStopReason() : Boolean
        {
            return this._player.stopReason == StopReasonEnum.SKIP_TRAILER || this._player.stopReason == StopReasonEnum.REACH_ASSIGN || this._player.stopReason == StopReasonEnum.STOP;
        }// end function

        public function get isTryWatch() : Boolean
        {
            return this._player.isTryWatch;
        }// end function

        public function get tryWatchType() : EnumItem
        {
            return this._player.tryWatchType;
        }// end function

        public function get tryWatchTime() : int
        {
            return this._player.tryWatchTime;
        }// end function

        public function get frameRate() : int
        {
            return this._player.frameRate;
        }// end function

        public function get settingArea() : Rectangle
        {
            return this._player.settingArea;
        }// end function

        public function get realArea() : Rectangle
        {
            return this._player.realArea;
        }// end function

        public function get authenticationTipType() : int
        {
            return this._player.authenticationTipType;
        }// end function

        public function get smallWindowMode() : Boolean
        {
            return this._smallWindowMode;
        }// end function

        public function set smallWindowMode(param1:Boolean) : void
        {
            this._smallWindowMode = param1;
            this._player.smallWindowMode = param1;
            return;
        }// end function

        public function set ugcAuthKey(param1:String) : void
        {
            this._player.ugcAuthKey = param1;
            return;
        }// end function

        public function get VInfoDisIP() : String
        {
            return this._player.VInfoDisIP;
        }// end function

        public function getCaptureURL(param1:Number = -1, param2:int = 1) : String
        {
            return this._player.getCaptureURL(param1, param2);
        }// end function

        public function getSwfUrl() : String
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                if (this._player.movieInfo.infoJSON.vu.split("/")[2] == "yule.iqiyi.com" || this._player.movieInfo.infoJSON.vu.split("/")[2] == "yule.qiyi.com")
                {
                    return SystemConfig.PLAYER_URI + this._player.movieModel.vid + "/0/" + Math.floor(this._player.movieModel.duration / 1000) + "/" + this._player.movieInfo.infoJSON.vu.split("/")[2].split(".")[0] + "/" + this._player.movieInfo.infoJSON.vu.split("qiyi.com/")[1].split(".html")[0] + ".swf" + "-albumId=" + this._player.movieModel.albumId + "-tvId=" + this._player.movieModel.tvid + "-isPurchase=" + (this._player.movieModel.member ? ("1") : ("0")) + "-cnId=" + this._player.movieModel.channelID;
                }
                else
                {
                    return SystemConfig.PLAYER_URI + this._player.movieModel.vid + "/0/" + Math.floor(this._player.movieModel.duration / 1000) + "/" + this._player.movieInfo.infoJSON.vu.split("qiyi.com/")[1].split(".html")[0] + ".swf" + "-albumId=" + this._player.movieModel.albumId + "-tvId=" + this._player.movieModel.tvid + "-isPurchase=" + (this._player.movieModel.member ? ("1") : ("0")) + "-cnId=" + this._player.movieModel.channelID;
                }
            }
            return "";
        }// end function

        public function getHtmlUrl() : String
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                return "<embed src=\"" + this.getSwfUrl() + "\" quality=\"high\" width=\"480\" height=\"400\" align=\"middle\" " + "allowScriptAccess=\"always\" type=\"application/x-shockwave-flash\"></embed>";
            }
            return "";
        }// end function

        public function get3DScreenInfo() : ScreenInfo
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_1 = this._player.movieModel.screenInfoCount;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    if (this._player.movieModel.getScreenInfoAt(_loc_2).screenType == ScreenEnum.THREE_D)
                    {
                        return this._player.movieModel.getScreenInfoAt(_loc_2);
                    }
                    _loc_2++;
                }
            }
            return null;
        }// end function

        public function get2DScreenInfo() : ScreenInfo
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_1 = this._player.movieModel.screenInfoCount;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    if (this._player.movieModel.getScreenInfoAt(_loc_2).screenType == ScreenEnum.TWO_D)
                    {
                        return this._player.movieModel.getScreenInfoAt(_loc_2);
                    }
                    _loc_2++;
                }
            }
            return null;
        }// end function

        public function loadMovie(param1:LoadMovieParams, param2:String) : void
        {
            if (this._playerStatusDelay)
            {
                TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete, true);
                this._playerStatusDelay = null;
            }
            this._playStartTime = 0;
            this._needTryWatchArrCheck = true;
            switch(param2)
            {
                case BodyDef.LOAD_MOVIE_TYPE_ORIGINAL:
                {
                    this._loadMovieType = param2;
                    this._loadMovieParams = param1;
                    break;
                }
                case BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D:
                case BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D:
                {
                    this._loadMovieType = param2;
                    if (this.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || this.hasStatus(BodyDef.PLAYER_STATUS_SEEKING) || this.hasStatus(BodyDef.PLAYER_STATUS_WAITING) || this.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
                    {
                        this._playStartTime = this.currentTime;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.clearLoadMovieStatus();
            this._isPlayRefreshed = false;
            this._player.loadMovie(param1);
            this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE);
            return;
        }// end function

        public function startLoad() : void
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE) && this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && !this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD) && !this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
            {
                this._player.startLoad();
                this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
            }
            return;
        }// end function

        public function stopLoad() : void
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD) || this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
            {
                this._player.stopLoad();
                this.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
            }
            return;
        }// end function

        public function play() : void
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE) && this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && !this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !this.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
            {
                this._log.debug("PlayerActor call play!");
                this._player.play();
                this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY);
                if (this._player.hasStatus(StatusEnum.WAITING))
                {
                    this._log.info("PlayerActor enter play,core cur status:waiting");
                    this.addStatus(BodyDef.PLAYER_STATUS_WAITING);
                }
                else if (this._player.hasStatus(StatusEnum.SEEKING))
                {
                    this._log.info("PlayerActor enter play,core cur status:seeking");
                    this.addStatus(BodyDef.PLAYER_STATUS_SEEKING);
                }
                if (this._loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || this._loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D)
                {
                    if (this._playStartTime > 0)
                    {
                        this._log.info("PlayerActor play start execute playStartTime:" + this._playStartTime);
                        this.resetFocusTipsMap();
                        this._player.seek(this._playStartTime);
                    }
                }
            }
            return;
        }// end function

        public function pause(param1:int = 0) : void
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || this.hasStatus(BodyDef.PLAYER_STATUS_SEEKING) || this.hasStatus(BodyDef.PLAYER_STATUS_WAITING))
            {
                this._player.pause(param1);
                this.addStatus(BodyDef.PLAYER_STATUS_PAUSED);
            }
            return;
        }// end function

        public function resume() : void
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
            {
                this._player.resume();
                this.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
            }
            return;
        }// end function

        public function seek(param1:uint, param2:int = 0) : void
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE) && this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
            {
                if (this.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || this.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) || this.hasStatus(BodyDef.PLAYER_STATUS_WAITING) || this.hasStatus(BodyDef.PLAYER_STATUS_SEEKING))
                {
                    if (!this._needTryWatchArrCheck && this._player.isTryWatch && this._player.tryWatchType == TryWatchEnum.PART)
                    {
                        if (this._player.tryWatchTime > 0 && this._player.currentTime < this._player.tryWatchTime)
                        {
                            this._needTryWatchArrCheck = true;
                        }
                    }
                    this.resetFocusTipsMap();
                    this._player.seek(param1, param2);
                }
            }
            return;
        }// end function

        public function replay() : void
        {
            var _loc_1:int = 0;
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE) && this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !this.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !this.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
            {
                this._needTryWatchArrCheck = true;
                if (this.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
                {
                    this.resetFocusTipsMap();
                    this._player.replay();
                    if (this._isPreload)
                    {
                        this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAYED, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
                    }
                    else
                    {
                        this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAYED, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
                    }
                }
                else if (this.movieModel)
                {
                    _loc_1 = 0;
                    if (Settings.instance.skipTitle && this.movieModel.titlesTime > 0)
                    {
                        _loc_1 = this.movieModel.titlesTime;
                    }
                    this.resetFocusTipsMap();
                    this._player.seek(_loc_1);
                }
            }
            return;
        }// end function

        public function refresh() : void
        {
            if (this._status.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
            {
                this._isPlayRefreshed = true;
            }
            if (this._playerStatusDelay)
            {
                TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete, true);
                this._playerStatusDelay = null;
            }
            this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_READY);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
            this._needTryWatchArrCheck = true;
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_START_REFRESH, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_START_REFRESH, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            this._player.refresh();
            return;
        }// end function

        public function clearSurface() : void
        {
            this._player.clearSurface();
            return;
        }// end function

        public function stop() : void
        {
            if (this._playerStatusDelay)
            {
                TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete, true);
                this._playerStatusDelay = null;
            }
            this._needTryWatchArrCheck = true;
            this._player.stop();
            this.clearLoadMovieStatus();
            return;
        }// end function

        public function setArea(param1:int, param2:int, param3:int, param4:int) : void
        {
            this._player.setArea(param1, param2, param3, param4);
            return;
        }// end function

        public function setPuman(param1:Boolean) : void
        {
            this._player.setPuman(param1);
            return;
        }// end function

        public function setZoom(param1:int) : void
        {
            this._player.setZoom(param1);
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

        public function setADRemainTime(param1:int) : void
        {
            this._player.setADRemainTime(param1);
            return;
        }// end function

        public function startLoadMeta() : void
        {
            this._player.startLoadMeta();
            return;
        }// end function

        public function startLoadHistory() : void
        {
            this._player.startLoadHistory();
            return;
        }// end function

        public function startLoadP2P() : void
        {
            this._player.startLoadP2PCore();
            return;
        }// end function

        private function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= BodyDef.PLAYER_STATUS_BEGIN && param1 < BodyDef.PLAYER_STATUS_END && !this._status.hasStatus(param1))
            {
                switch(param1)
                {
                    case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                    {
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_READY);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_ALREADY_READY:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_ALREADY_START_LOAD:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_LOAD_COMPLETE:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_PLAYING:
                    {
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_PAUSED:
                    {
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_SEEKING:
                    {
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_WAITING:
                    {
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_STOPPING:
                    {
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_STOPED:
                    {
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_FAILED:
                    {
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
                        this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._status.addStatus(param1);
                this._log.debug("Player Actor add status,status:" + param1 + ",isPreload:" + this._isPreload);
                if (param2)
                {
                    if (this._isPreload)
                    {
                        this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ADD_STATUS, param1, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
                    }
                    else
                    {
                        this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ADD_STATUS, param1, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
                    }
                }
            }
            return;
        }// end function

        private function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= BodyDef.PLAYER_STATUS_BEGIN && param1 < BodyDef.PLAYER_STATUS_END && this._status.hasStatus(param1))
            {
                switch(param1)
                {
                    case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_ALREADY_READY:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_ALREADY_START_LOAD:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_LOAD_COMPLETE:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_PLAYING:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_PAUSED:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_SEEKING:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_WAITING:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_STOPPING:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_STOPED:
                    {
                        break;
                    }
                    case BodyDef.PLAYER_STATUS_FAILED:
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._status.removeStatus(param1);
                if (param2)
                {
                    if (this._isPreload)
                    {
                        this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS, param1, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
                    }
                    else
                    {
                        this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS, param1, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
                    }
                }
            }
            return;
        }// end function

        private function resetFocusTipsMap() : void
        {
            var _loc_1:Vector.<FocusTip> = null;
            var _loc_2:int = 0;
            var _loc_3:FocusTip = null;
            var _loc_4:int = 0;
            this._focusTipsMap = new Dictionary();
            if (this._player.movieInfo)
            {
                _loc_1 = this._player.movieInfo.focusTips;
                if (_loc_1)
                {
                    _loc_2 = _loc_1.length;
                    _loc_3 = null;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_2)
                    {
                        
                        _loc_3 = _loc_1[_loc_4] as FocusTip;
                        if (_loc_3)
                        {
                            this._focusTipsMap[_loc_3] = false;
                        }
                        _loc_4++;
                    }
                }
            }
            return;
        }// end function

        private function clearLoadMovieStatus() : void
        {
            this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_READY);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_START_LOAD);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_PLAYING);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_PAUSED);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_SEEKING);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_WAITING);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPPING);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_STOPED);
            this._status.removeStatus(BodyDef.PLAYER_STATUS_FAILED);
            this.removeStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE);
            return;
        }// end function

        private function asyncPlayerStatus(param1:int) : void
        {
            if (this._playerStatusDelay)
            {
                TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete, true);
            }
            this._playerStatusDelay = TweenLite.delayedCall(0.03, this.onAsyncPlayerStatusComplete, [param1]);
            return;
        }// end function

        private function onAsyncPlayerStatusComplete(param1:int) : void
        {
            this._playerStatusDelay = null;
            switch(param1)
            {
                case StatusEnum.ALREADY_READY:
                {
                    if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
                    {
                        if (this._player.movieInfo.ready)
                        {
                            this.resetFocusTipsMap();
                            this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
                        }
                        this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_READY);
                    }
                    break;
                }
                case StatusEnum.PLAYING:
                {
                    if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
                    {
                        this.addStatus(BodyDef.PLAYER_STATUS_PLAYING);
                    }
                    break;
                }
                case StatusEnum.PAUSED:
                {
                    if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
                    {
                        this.addStatus(BodyDef.PLAYER_STATUS_PAUSED);
                    }
                    break;
                }
                case StatusEnum.SEEKING:
                {
                    if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
                    {
                        this.addStatus(BodyDef.PLAYER_STATUS_SEEKING);
                    }
                    break;
                }
                case StatusEnum.WAITING:
                {
                    if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
                    {
                        this.addStatus(BodyDef.PLAYER_STATUS_WAITING);
                    }
                    break;
                }
                case StatusEnum.STOPPING:
                {
                    if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
                    {
                        if (this._player.stopReason == StopReasonEnum.SKIP_TRAILER || this._player.stopReason == StopReasonEnum.REACH_ASSIGN || this._player.stopReason == StopReasonEnum.STOP)
                        {
                            this.addStatus(BodyDef.PLAYER_STATUS_STOPPING);
                        }
                        else
                        {
                            this.addStatus(BodyDef.PLAYER_STATUS_STOPPING, false);
                        }
                    }
                    break;
                }
                case StatusEnum.STOPED:
                {
                    if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
                    {
                        if (this._player.stopReason == StopReasonEnum.SKIP_TRAILER || this._player.stopReason == StopReasonEnum.REACH_ASSIGN || this._player.stopReason == StopReasonEnum.STOP)
                        {
                            this.addStatus(BodyDef.PLAYER_STATUS_STOPED);
                        }
                        else
                        {
                            this.addStatus(BodyDef.PLAYER_STATUS_STOPED, false);
                        }
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

        private function onPlayerStatusChanged(event:PlayerEvent) : void
        {
            if (!(event.data.isAdd as Boolean))
            {
                return;
            }
            var _loc_2:* = event.data.status;
            if (_loc_2 == StatusEnum.STOPPING)
            {
                this._playingDuration = this._player.playingDuration;
                this._waitingDuration = this._player.waitingDuration;
                if (this._player.movieModel)
                {
                    if (this._player.stopReason == StopReasonEnum.SKIP_TRAILER || this._player.stopReason == StopReasonEnum.REACH_ASSIGN || this._player.stopReason == StopReasonEnum.STOP)
                    {
                        if (this._isPreload)
                        {
                            this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_UPDATE_OVER_BONUS, this._player.movieModel.duration, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
                        }
                        else
                        {
                            this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_UPDATE_OVER_BONUS, this._player.movieModel.duration, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
                        }
                    }
                }
            }
            this.asyncPlayerStatus(_loc_2);
            return;
        }// end function

        private function onPlayerError(event:PlayerEvent) : void
        {
            if (this._playerStatusDelay)
            {
                TweenLite.killTweensOf(this.onAsyncPlayerStatusComplete, true);
                this._playerStatusDelay = null;
            }
            this._log.info("playe error,error code:" + this.errorCode + ", authenticationError:" + this.authenticationError + ", isPreload:" + this._isPreload);
            this.addStatus(BodyDef.PLAYER_STATUS_FAILED);
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ERROR, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ERROR, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerDefinitionSwitched(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerAudioTrackSwitched(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerMovieInfoReady(event:PlayerEvent) : void
        {
            if (this.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
            {
                this.resetFocusTipsMap();
                this.addStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY);
            }
            return;
        }// end function

        private function onPlayerGPUChanged(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_GPU_CHANGED, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_GPU_CHANGED, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerPreparePlayEnd(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PREPARE_PLAY_END, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PREPARE_PLAY_END, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerSkipTrailer(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_SKIP_TRAILER, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_SKIP_TRAILER, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerStartFromHistory(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_START_FROM_HISTORY, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_START_FROM_HISTORY, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerSkipTitle(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_SKIP_TITLE, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_SKIP_TITLE, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerStuck(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_STUCK, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_STUCK, null, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerEnterPrepareSkipPoint(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PREPARE_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PREPARE_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerOutPrepareSkipPoint(event:PlayerEvent) : void
        {
            return;
        }// end function

        private function onPlayerEnterSkipPoint(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENTER_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENTER_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPreparePlayEndSkipPoint(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_OUT_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_OUT_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onPlayerOutSkipPoint(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_OUT_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_OUT_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onFreshedSkipPoints(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_FRESHED_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_FRESHED_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onEnterPrepareLeaveSkipPoint(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onOutPrepareLeaveSkipPoint(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_OUT_LEAVE_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_OUT_LEAVE_SKIP_POINT, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onEnjoyableSubTypeInited(event:PlayerEvent) : void
        {
            if (this._isPreload)
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENJOY_TYPE_INITED, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE);
            }
            else
            {
                this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ENJOY_TYPE_INITED, event.data, BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR);
            }
            return;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:Object = null;
            var _loc_7:Vector.<FocusTip> = null;
            var _loc_8:int = 0;
            var _loc_9:FocusTip = null;
            var _loc_10:int = 0;
            if (!this._isPreload)
            {
                if (this._status.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || this._status.hasStatus(BodyDef.PLAYER_STATUS_SEEKING) || this._status.hasStatus(BodyDef.PLAYER_STATUS_WAITING) || this._status.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
                {
                    _loc_2 = this.currentTime;
                    _loc_3 = this.bufferTime;
                    _loc_4 = this._player.movieModel.duration;
                    _loc_5 = this._player.playingDuration;
                    _loc_6 = new Object();
                    _loc_6.currentTime = _loc_2;
                    _loc_6.bufferTime = _loc_3;
                    _loc_6.duration = _loc_4;
                    _loc_6.playingDuration = _loc_5;
                    this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_RUNNING, _loc_6);
                    if (this._player.loadComplete)
                    {
                        this.addStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
                    }
                    else
                    {
                        this.removeStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE);
                    }
                    if (this._status.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) && this._focusTipsMap && this._player.movieInfo)
                    {
                        _loc_7 = this._player.movieInfo.focusTips;
                        if (_loc_7)
                        {
                            _loc_8 = _loc_7.length;
                            _loc_9 = null;
                            _loc_10 = 0;
                            while (_loc_10 < _loc_8)
                            {
                                
                                _loc_9 = _loc_7[_loc_10] as FocusTip;
                                if (_loc_9 && int(_loc_9.timestamp / 1000) == int(_loc_2 / 1000) && this._focusTipsMap[_loc_9] == false)
                                {
                                    this._focusTipsMap[_loc_9] = true;
                                    this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_TO_FOCUS_TIP, _loc_9);
                                }
                                _loc_10++;
                            }
                        }
                    }
                    if (this._player.isTryWatch && this._player.tryWatchType == TryWatchEnum.PART)
                    {
                        if (this._needTryWatchArrCheck && this._player.tryWatchTime > 0 && _loc_2 >= this._player.tryWatchTime)
                        {
                            this._log.info("PlayerActor check timer, arrive try watch time!");
                            this._needTryWatchArrCheck = false;
                            this._facade.sendNotification(BodyDef.NOTIFIC_PLAYER_ARRIVE_TRYWATCH_TIME);
                        }
                    }
                }
            }
            return;
        }// end function

    }
}
