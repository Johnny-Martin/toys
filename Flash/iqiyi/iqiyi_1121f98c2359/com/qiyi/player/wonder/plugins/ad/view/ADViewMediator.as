package com.qiyi.player.wonder.plugins.ad.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.cupid.adplayer.base.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.hint.model.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import com.qiyi.player.wonder.plugins.tips.*;
    import flash.events.*;
    import flash.external.*;
    import flash.utils.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class ADViewMediator extends Mediator
    {
        private var _ADProxy:ADProxy;
        private var _ADView:ADView;
        private var _log:ILogger;
        private var _adAutoPlay:Boolean = true;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.ad.view.ADViewMediator";

        public function ADViewMediator(param1:ADView)
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.plugins.ad.view.ADViewMediator");
            super(NAME, param1);
            this._ADView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._ADProxy = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            this._ADView.addEventListener(ADEvent.Evt_Open, this.onADViewOpen);
            this._ADView.addEventListener(ADEvent.Evt_Close, this.onADViewClose);
            this._ADView.addEventListener(ADEvent.Evt_LoadSuccess, this.onLoadSuccess);
            this._ADView.addEventListener(ADEvent.Evt_LoadFailed, this.onLoadFailed);
            this._ADView.addEventListener(ADEvent.Evt_StartPlay, this.onStartPlay);
            this._ADView.addEventListener(ADEvent.Evt_AskVideoPause, this.onAskVideoPause);
            this._ADView.addEventListener(ADEvent.Evt_AskVideoResume, this.onAskVideoResume);
            this._ADView.addEventListener(ADEvent.Evt_AskVideoStartLoad, this.onAskVideoStartLoad);
            this._ADView.addEventListener(ADEvent.Evt_AskVideoStartPlay, this.onAskVideoStartPlay);
            this._ADView.addEventListener(ADEvent.Evt_ViewPoints, this.onAskVideoViewPoints);
            this._ADView.addEventListener(ADEvent.Evt_AskVideoEnd, this.onAskVideoEnd);
            this._ADView.addEventListener(ADEvent.Evt_AdBlock, this.onAdBlock);
            this._ADView.addEventListener(ADEvent.Evt_AdUnloaded, this.onAdUnloaded);
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [ADDef.NOTIFIC_ADD_STATUS, ADDef.NOTIFIC_REMOVE_STATUS, ADDef.NOTIFIC_PAUSE, ADDef.NOTIFIC_RESUME, ADDef.NOTIFIC_POPUP_OPEN, ADDef.NOTIFIC_POPUP_CLOSE, ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO, ADDef.NOTIFIC_AD_VOLUMN_CHANGED, ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID, ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER, ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED, ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED, BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS, BodyDef.NOTIFIC_PLAYER_RUNNING, BodyDef.NOTIFIC_JS_LIGHT_CHANGED, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE, BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO, BodyDef.NOTIFIC_MOUSE_LAYER_CLICK, BodyDef.NOTIFIC_JS_CALL_PAUSE, BodyDef.NOTIFIC_JS_CALL_RESUME, BodyDef.NOTIFIC_JS_CALL_REPLAY, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:Object = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    this._ADView.onAddStatus(int(_loc_2));
                    break;
                }
                case ADDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._ADView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_PAUSE:
                case ADDef.NOTIFIC_PAUSE:
                {
                    if (!this.checkSkipPauseAD())
                    {
                        PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                    }
                    if (this._ADProxy.hasStatus(ADDef.STATUS_PLAYING))
                    {
                        this._ADProxy.addStatus(ADDef.STATUS_PAUSED);
                        sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_AD_PAUSED);
                    }
                    this._ADView.onPause();
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_RESUME:
                case ADDef.NOTIFIC_RESUME:
                {
                    if (this._ADProxy.hasStatus(ADDef.STATUS_PAUSED))
                    {
                        this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
                        sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_AD_RESUMED);
                    }
                    this._ADView.onResume();
                    break;
                }
                case ADDef.NOTIFIC_POPUP_OPEN:
                {
                    this._ADView.onPopupOpen();
                    break;
                }
                case ADDef.NOTIFIC_POPUP_CLOSE:
                {
                    this._ADView.onPopupClose();
                    break;
                }
                case ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO:
                {
                    this.onRequestReplayVideo(_loc_2);
                    break;
                }
                case ADDef.NOTIFIC_AD_VOLUMN_CHANGED:
                {
                    this.onVolumeChanged();
                    break;
                }
                case ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID:
                {
                    this._ADProxy.cupId = _loc_2 as String;
                    break;
                }
                case ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER:
                {
                    this.unloadAdPlayer();
                    this.removeAllAdStatus();
                    break;
                }
                case ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED:
                {
                    this.onContinueListChanged();
                    break;
                }
                case ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED:
                {
                    this.onNoticePrepareSwitchVideo(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._ADView.onResize(_loc_2.w, _loc_2.h);
                    break;
                }
                case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
                {
                    this.onCheckUserComplete();
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
                {
                    this.onPlayerStatusChanged(int(_loc_2), true, _loc_4);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS:
                {
                    this.onPlayerStatusChanged(int(_loc_2), false, _loc_4);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    this.onPlayerRunning(_loc_2.currentTime, _loc_2.bufferTime, _loc_2.duration);
                    break;
                }
                case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
                {
                    this._ADView.onLightStateChanged(Boolean(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_FULL_SCREEN:
                {
                    this._ADView.onFullScreenChanged(Boolean(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:
                {
                    this.onJSCallSetContinuePlayState(Boolean(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:
                {
                    _loc_5 = new Object();
                    _loc_5.hasNext = Boolean(_loc_2.continuePlay) ? ("1") : ("0");
                    this._ADView.onSendNotific(_loc_5);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.onPlayerDefinitionSwitched(int(_loc_2));
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this.onPlayerSwitchPreActor();
                    break;
                }
                case BodyDef.NOTIFIC_MOUSE_LAYER_CLICK:
                {
                    this.onMouseLayerClick();
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_REPLAY:
                {
                    this.onRequestReplayVideo();
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
                {
                    if (Boolean(_loc_2))
                    {
                        this.hideDock();
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

        private function onPlayerDefinitionSwitched(param1:int) : void
        {
            var _loc_2:PlayerProxy = null;
            var _loc_3:Object = null;
            if (param1 >= 0)
            {
                _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                _loc_3 = new Object();
                _loc_3.videoDefinitionId = _loc_2.curActor.movieModel ? (_loc_2.curActor.movieModel.curDefinitionInfo.type.id) : (Settings.instance.definition.id);
                this._ADView.onSendNotific(_loc_3);
            }
            return;
        }// end function

        private function onNoticePrepareSwitchVideo(param1:int) : void
        {
            this._ADProxy.switchVideoType = param1;
            if (param1 != ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO)
            {
                this._ADProxy.curAdContextPlayDuration = 0;
                this._ADProxy.curAdContext15PlayDuration = 0;
                this._ADProxy.curPlayCount = 0;
                this._ADProxy.preAdContextPlayDuration = 0;
                this._ADProxy.preAdContext15PlayDuration = 0;
                this._ADProxy.prePlayCount = 0;
                this.unloadAdPlayer();
                this.removeAllAdStatus();
            }
            return;
        }// end function

        private function onContinueListChanged() : void
        {
            var _loc_2:ContinuePlayProxy = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:Object = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.loadMovieParams)
            {
                _loc_2 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
                _loc_3 = _loc_1.curActor.loadMovieParams.vid;
                _loc_4 = _loc_1.curActor.loadMovieParams.tvid;
                _loc_5 = new Object();
                if (_loc_2.continueInfoCount > 0 && _loc_2.isContinue && _loc_2.findNextContinueInfo(_loc_4, _loc_3))
                {
                    _loc_5.hasNext = "1";
                }
                else
                {
                    _loc_5.hasNext = "0";
                }
                this._ADView.onSendNotific(_loc_5);
            }
            return;
        }// end function

        private function onJSCallSetContinuePlayState(param1:Boolean) : void
        {
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:ContinuePlayProxy = null;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = new Object();
            if (_loc_2.curActor.loadMovieParams && param1)
            {
                _loc_4 = _loc_2.curActor.loadMovieParams.tvid;
                _loc_5 = _loc_2.curActor.loadMovieParams.vid;
                _loc_6 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
                if (_loc_6.continueInfoCount > 0 && _loc_6.findNextContinueInfo(_loc_4, _loc_5))
                {
                    _loc_3.hasNext = "1";
                }
                else
                {
                    _loc_3.hasNext = "0";
                }
            }
            else
            {
                _loc_3.hasNext = "0";
            }
            this._ADView.onSendNotific(_loc_3);
            return;
        }// end function

        private function createADPlayer() : void
        {
            sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
            ProcessesTimeRecord.STime_adInit = getTimer();
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_3:* = new CupidParam();
            _loc_3.playerUrl = FlashVarConfig.adPlayerURL;
            _loc_3.videoId = _loc_1.curActor.loadMovieParams.vid;
            _loc_3.tvId = _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_1.curActor.movieModel.qipuId) : (_loc_1.curActor.loadMovieParams.tvid);
            _loc_3.channelId = _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_1.curActor.movieModel.channelID) : (0);
            _loc_3.playerId = FlashVarConfig.cupId;
            _loc_3.albumId = _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_1.curActor.movieModel.albumId) : (_loc_1.curActor.loadMovieParams.albumId);
            _loc_3.dispatcher = null;
            _loc_3.adContainer = this._ADView;
            _loc_3.stageWidth = GlobalStage.stage.stageWidth;
            _loc_3.stageHeight = GlobalStage.stage.stageHeight;
            _loc_3.userId = _loc_1.curActor.uuid;
            _loc_3.webEventId = UUIDManager.instance.getWebEventID();
            _loc_3.videoEventId = UUIDManager.instance.getVideoEventID();
            _loc_3.vipRight = _loc_2.userLevel != UserDef.USER_LEVEL_NORMAL ? ("1") : ("0");
            _loc_3.vipFalseReason = UserManager.getInstance().user ? (UserManager.getInstance().user.vipFalseReason) : ("");
            _loc_3.terminal = "iqiyiw";
            _loc_3.duration = _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_1.curActor.movieModel.duration / 1000) : (0);
            _loc_3.passportId = _loc_2.passportID;
            _loc_3.passportCookie = _loc_2.P00001;
            _loc_3.passportKey = KeyUtils.getPassportKey(0);
            _loc_3.enableVideoCore = false;
            _loc_3.disableSkipAd = _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_1.curActor.movieModel.forceAD) : (false);
            _loc_3.volume = Settings.instance.mute ? (0) : (Settings.instance.volumn);
            _loc_3.isUGC = UGCUtils.isUGC(_loc_1.curActor.loadMovieParams.tvid);
            _loc_3.collectionId = FlashVarConfig.collectionID;
            _loc_3.videoDefinitionId = _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_1.curActor.movieModel.curDefinitionInfo.type.id) : (Settings.instance.definition.id);
            _loc_3.cacheMachineIp = _loc_1.curActor.VInfoDisIP;
            _loc_3.couponCode = FlashVarConfig.couponCode;
            _loc_3.couponVer = FlashVarConfig.couponVer;
            _loc_3.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
            _loc_3.language = FlashVarConfig.localize;
            _loc_3.isMuteMode = FlashVarConfig.masflag;
            _loc_3.autoPlay = this._adAutoPlay;
            _loc_3.videoPlayerVersion = WonderVersion.VERSION_WONDER;
            this._ADView.createAdPlayer(_loc_3);
            return;
        }// end function

        private function unloadAdPlayer() : void
        {
            this._ADView.unloadAdPlayer();
            this._ADProxy.blocked = false;
            return;
        }// end function

        private function removeAllAdStatus() : void
        {
            this._ADProxy.removeStatus(ADDef.STATUS_PLAY_END, false);
            this._ADProxy.removeStatus(ADDef.STATUS_LOADING, false);
            this._ADProxy.removeStatus(ADDef.STATUS_PLAYING, false);
            this._ADProxy.removeStatus(ADDef.STATUS_PAUSED, false);
            this._ADProxy.removeStatus(ADDef.STATUS_PRE_LOADING, false);
            this._ADProxy.removeStatus(ADDef.STATUS_PRE_SUCCESS, false);
            this._ADProxy.removeStatus(ADDef.STATUS_PRE_FAILED, false);
            this._ADProxy.removeStatus(ADDef.STATUS_PRE_STARTED, false);
            return;
        }// end function

        private function onADViewOpen(event:ADEvent) : void
        {
            if (!this._ADProxy.hasStatus(ADDef.STATUS_OPEN))
            {
                this._ADProxy.addStatus(ADDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onADViewClose(event:ADEvent) : void
        {
            if (this._ADProxy.hasStatus(ADDef.STATUS_OPEN))
            {
                this._ADProxy.removeStatus(ADDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onRequestReplayVideo(param1:Object = null) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
            {
                sendNotification(HintDef.NOTIFIC_HINT_CHECK, true);
                sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_READY);
                sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_START_PLAY);
                if (param1)
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_SEEK, {time:param1});
                }
            }
            return;
        }// end function

        private function onCheckUserComplete() : void
        {
            var _loc_1:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_2:* = new UserInfoVO();
            _loc_2.isLogin = _loc_1.isLogin;
            _loc_2.passportID = _loc_1.passportID;
            _loc_2.userID = _loc_1.userID;
            _loc_2.userName = _loc_1.userName;
            _loc_2.userLevel = _loc_1.userLevel;
            _loc_2.userType = _loc_1.userType;
            this._ADView.onUserInfoChanged(_loc_2);
            var _loc_3:* = new Object();
            _loc_3.vipRight = _loc_1.userLevel != UserDef.USER_LEVEL_NORMAL ? ("1") : ("0");
            _loc_3.vipFalseReason = UserManager.getInstance().user ? (UserManager.getInstance().user.vipFalseReason) : ("");
            if (_loc_1.isLogin)
            {
                _loc_3.passportId = _loc_1.passportID;
                _loc_3.passportCookie = _loc_1.P00001;
            }
            else
            {
                _loc_3.passportId = "";
                _loc_3.passportCookie = "";
            }
            this._ADView.onSendNotific(_loc_3);
            return;
        }// end function

        private function checkSkipTitleAD() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.isPlayRefreshed || _loc_1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || _loc_1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D)
            {
                return true;
            }
            return false;
        }// end function

        private function checkSkipTitlePreAD() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            return true;
        }// end function

        private function checkSkipPauseAD() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            if (_loc_1.curActor.movieModel == null || _loc_2.isLogin && _loc_2.userLevel != UserDef.USER_LEVEL_NORMAL && !_loc_1.curActor.movieModel.forceAD || _loc_1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D || _loc_1.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D)
            {
                return true;
            }
            return false;
        }// end function

        private function showSkipADTip() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            if (_loc_2.isLogin && _loc_2.userLevel != UserDef.USER_LEVEL_NORMAL)
            {
                sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_PRO_SKIP_AD);
            }
            return;
        }// end function

        private function showCopyrightForceADTip() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            if (_loc_2.isLogin && _loc_2.userLevel != UserDef.USER_LEVEL_NORMAL && !_loc_1.curActor.movieModel.member && _loc_1.curActor.movieModel.forceAD)
            {
                sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_COPYRIGHT_FORCE_AD_TIP);
            }
            return;
        }// end function

        private function onPlayerSwitchPreActor() : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:Boolean = false;
            var _loc_4:Boolean = false;
            this.hideDock();
            this._ADProxy.clearADViewPoints();
            this._ADProxy.setADViewPoints();
            sendNotification(ADDef.NOTIFIC_AD_RECEIVE_VIEW_POINTS);
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
            {
                this.unloadAdPlayer();
                this.removeAllAdStatus();
            }
            else if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                _loc_2 = this.checkSkipTitleAD();
                if (_loc_2)
                {
                    this.unloadAdPlayer();
                    this.removeAllAdStatus();
                    this.sendNotification(HintDef.NOTIFIC_HINT_CHECK, false);
                    sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_READY);
                    sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_START_PLAY);
                    this.trySendSkipADPingBack();
                }
                else if (this._ADProxy.hasStatus(ADDef.STATUS_PRE_FAILED))
                {
                    this.unloadAdPlayer();
                    this.removeAllAdStatus();
                    this._ADProxy.addStatus(ADDef.STATUS_LOADING);
                    this.createADPlayer();
                }
                else
                {
                    _loc_3 = this._ADProxy.hasStatus(ADDef.STATUS_PRE_LOADING);
                    _loc_4 = this._ADProxy.hasStatus(ADDef.STATUS_PRE_SUCCESS);
                    this.removeAllAdStatus();
                    if (this._ADView.adPlayer && (_loc_3 || _loc_4))
                    {
                        if (!_loc_4)
                        {
                            sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
                            this._ADProxy.addStatus(ADDef.STATUS_LOADING);
                        }
                        this._log.info("ad switch pre on player switch pre!");
                        this._ADView.onSwitchPre();
                    }
                    else
                    {
                        this._ADProxy.addStatus(ADDef.STATUS_LOADING);
                        this.createADPlayer();
                    }
                }
                this.showSkipADTip();
            }
            this._ADProxy.mute = Settings.instance.mute;
            return;
        }// end function

        private function onMouseLayerClick() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(HintProxy.NAME) as HintProxy;
            var _loc_3:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (_loc_1.curActor.movieModel && _loc_1.curActor.movieModel.multiAngle)
            {
                return;
            }
            if (_loc_3.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
            {
                return;
            }
            if (!this._ADProxy.hasStatus(ADDef.STATUS_LOADING) && !this._ADProxy.hasStatus(ADDef.STATUS_PLAYING) && !this._ADProxy.hasStatus(ADDef.STATUS_PAUSED))
            {
                if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) || _loc_2.hasStatus(HintDef.STATUS_PAUSED))
                {
                    if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
                    {
                        sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
                        GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
                    }
                    else
                    {
                        sendNotification(HintDef.NOTIFIC_HINT_RESUME);
                    }
                    this._ADView.onResume();
                }
                else
                {
                    if (!this.checkSkipPauseAD())
                    {
                        PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                    }
                    if (_loc_2.hasStatus(HintDef.STATUS_PLAYING))
                    {
                        sendNotification(HintDef.NOTIFIC_HINT_PAUSE);
                    }
                    else
                    {
                        sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE, PauseTypeEnum.USER);
                        GlobalStage.stage.dispatchEvent(new Event("tmp_dis_pause_to_p2p"));
                    }
                    this._ADView.onPause();
                }
            }
            return;
        }// end function

        private function onPlayerRunning(param1:int, param2:int, param3:int) : void
        {
            this._ADView.onUpdateCurrentTime(param1);
            var _loc_4:* = new Object();
            _loc_4.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
            this._ADView.onSendNotific(_loc_4);
            this.executeTryADPre();
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            var _loc_4:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_5:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2)
                    {
                        if (param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                        {
                            this._ADProxy.clearADViewPoints();
                            this.hideDock();
                            this.unloadAdPlayer();
                            this.removeAllAdStatus();
                            this._ADProxy.setADViewPoints();
                            if (uint(_loc_5.curActor.loadMovieParams.tvid) > 90000000)
                            {
                                this._adAutoPlay = false;
                                this.onAddReady(param3, ADDef.INIT_AD_ORDER_BEFORE_VMS);
                            }
                            sendNotification(ADDef.NOTIFIC_AD_RECEIVE_VIEW_POINTS);
                        }
                        else if (param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE)
                        {
                            this._ADProxy.removeStatus(ADDef.STATUS_PRE_LOADING, false);
                            this._ADProxy.removeStatus(ADDef.STATUS_PRE_SUCCESS, false);
                            this._ADProxy.removeStatus(ADDef.STATUS_PRE_FAILED, false);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    if (param2)
                    {
                        this.onAddReady(param3, ADDef.INIT_AD_ORDER_AFTER_VMS);
                        sendNotification(ADDef.NOTIFIC_AD_RECEIVE_VIEW_POINTS);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPPING:
                {
                    if (param2 && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.hideDock();
                        var _loc_6:* = this._ADProxy;
                        var _loc_7:* = this._ADProxy.curPlayCount + 1;
                        _loc_6.curPlayCount = _loc_7;
                        this._ADProxy.curAdContextPlayDuration = this._ADProxy.curAdContextPlayDuration + _loc_5.curActor.playingDuration;
                        this._ADProxy.curAdContext15PlayDuration = this._ADProxy.curAdContext15PlayDuration + _loc_5.curActor.playingDuration;
                        var _loc_6:* = this._ADProxy;
                        var _loc_7:* = this._ADProxy.prePlayCount + 1;
                        _loc_6.prePlayCount = _loc_7;
                        this._ADProxy.preAdContextPlayDuration = this._ADProxy.preAdContextPlayDuration + _loc_5.curActor.playingDuration;
                        this._ADProxy.preAdContext15PlayDuration = this._ADProxy.preAdContext15PlayDuration + _loc_5.curActor.playingDuration;
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2 && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this._ADProxy.removeStatus(ADDef.STATUS_PLAY_END, false);
                        this._ADProxy.removeStatus(ADDef.STATUS_LOADING, false);
                        this._ADProxy.removeStatus(ADDef.STATUS_PLAYING, false);
                        this._ADProxy.removeStatus(ADDef.STATUS_PAUSED, false);
                        if (this._ADView.adPlayer)
                        {
                            this.onVolumeChanged();
                            this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
                            this._ADView.onVideoStop();
                        }
                        else
                        {
                            this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2 && param3 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.hideDock();
                        if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && _loc_5.curActor.errorCode == 5000)
                        {
                            this.unloadAdPlayer();
                            this.removeAllAdStatus();
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

        private function onAddReady(param1:String, param2:uint) : void
        {
            var _loc_4:Boolean = false;
            var _loc_5:Object = null;
            var _loc_6:Boolean = false;
            var _loc_7:Boolean = false;
            var _loc_3:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_3.curActor.startLoadHistory();
            if (param1 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                if (param2 == ADDef.INIT_AD_ORDER_AFTER_VMS)
                {
                    if (_loc_3.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_3.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
                    {
                        this._log.info("ad init after at vms");
                        PingBack.getInstance().sendBeforeADInit();
                        _loc_4 = this.checkSkipTitleAD();
                        if (_loc_4)
                        {
                            this.unloadAdPlayer();
                            this.removeAllAdStatus();
                            this.sendNotification(HintDef.NOTIFIC_HINT_CHECK, false);
                            sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_READY);
                            sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_START_PLAY);
                            this.trySendSkipADPingBack();
                        }
                        else if (this._ADProxy.hasStatus(ADDef.STATUS_PLAY_END))
                        {
                            this.unloadAdPlayer();
                            this.removeAllAdStatus();
                            sendNotification(HintDef.NOTIFIC_HINT_CHECK, false);
                            sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_READY);
                            sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_START_PLAY);
                        }
                        else if (this._ADProxy.hasStatus(ADDef.STATUS_PRE_FAILED))
                        {
                            this.unloadAdPlayer();
                            this.removeAllAdStatus();
                            this._ADProxy.addStatus(ADDef.STATUS_LOADING);
                            this.createADPlayer();
                        }
                        else
                        {
                            _loc_6 = this._ADProxy.hasStatus(ADDef.STATUS_PRE_LOADING);
                            _loc_7 = this._ADProxy.hasStatus(ADDef.STATUS_PRE_SUCCESS);
                            this.removeAllAdStatus();
                            if (this._ADView.adPlayer && (_loc_6 || _loc_7))
                            {
                                if (!_loc_7)
                                {
                                    sendNotification(BodyDef.NOTIFIC_PLAYER_STOP_LOAD);
                                    this._ADProxy.addStatus(ADDef.STATUS_LOADING);
                                }
                                this._log.info("ad switch pre on player all ready");
                                this._ADView.onSwitchPre();
                            }
                            else if (this._adAutoPlay)
                            {
                                this._ADProxy.addStatus(ADDef.STATUS_LOADING);
                                this.createADPlayer();
                            }
                        }
                        this._adAutoPlay = true;
                        _loc_5 = new Object();
                        _loc_5.autoPlay = this._adAutoPlay;
                        this._ADView.onSendNotific(_loc_5);
                    }
                }
                else if (param2 == ADDef.INIT_AD_ORDER_BEFORE_VMS)
                {
                    this._log.info("ad init before at vms");
                    this.unloadAdPlayer();
                    this.removeAllAdStatus();
                    this._ADProxy.addStatus(ADDef.STATUS_LOADING);
                    this.createADPlayer();
                }
            }
            else if (param1 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_PRE)
            {
                if (_loc_3.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_3.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
                }
                this.executeTryADPre();
            }
            return;
        }// end function

        private function executeTryADPre() : void
        {
            var _loc_1:PlayerProxy = null;
            var _loc_2:IMovieModel = null;
            var _loc_3:UserProxy = null;
            var _loc_4:int = 0;
            var _loc_5:ContinuePlayProxy = null;
            var _loc_6:ContinueInfo = null;
            var _loc_7:Object = null;
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE && !this._ADProxy.hasStatus(ADDef.STATUS_PRE_STARTED))
            {
                _loc_1 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                _loc_2 = _loc_1.curActor.movieModel;
                _loc_3 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                if (_loc_2)
                {
                    _loc_4 = 0;
                    if (Settings.instance.skipTrailer && _loc_2.trailerTime > 0)
                    {
                        _loc_4 = _loc_2.trailerTime;
                    }
                    else
                    {
                        _loc_4 = _loc_2.duration;
                    }
                    if (_loc_4 - _loc_1.curActor.currentTime < ADDef.PRE_LOAD_TIME)
                    {
                        if (_loc_1.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE) && _loc_1.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_1.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
                        {
                            if (!this.checkSkipTitlePreAD())
                            {
                                sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_STOP_LOAD);
                                _loc_5 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
                                _loc_6 = _loc_5.findContinueInfo(_loc_1.preActor.loadMovieParams.tvid, _loc_1.preActor.loadMovieParams.vid);
                                _loc_7 = {};
                                _loc_7.videoId = _loc_1.preActor.loadMovieParams.vid;
                                _loc_7.tvId = _loc_1.preActor.movieModel.qipuId;
                                _loc_7.channelId = _loc_1.preActor.movieModel.channelID.toString();
                                _loc_7.albumId = _loc_1.preActor.movieModel.albumId.toString();
                                if (_loc_6)
                                {
                                    _loc_7.playerId = _loc_6.cupId;
                                }
                                else
                                {
                                    _loc_7.playerId = "";
                                }
                                _loc_7.userId = UUIDManager.instance.uuid;
                                _loc_7.videoEventId = _loc_1.preActor.videoEventID;
                                _loc_7.duration = _loc_1.preActor.movieModel.duration / 1000;
                                _loc_7.isUGC = UGCUtils.isUGC(_loc_1.preActor.movieModel.tvid);
                                _loc_7.disableSkipAd = _loc_1.preActor.movieModel.forceAD;
                                _loc_7.collectionId = FlashVarConfig.collectionID;
                                _loc_7.videoPlaySecondsOfDay = int(Statistics.instance.playDuration / 1000);
                                _loc_7.videoDefinitionId = _loc_1.preActor.movieModel.curDefinitionInfo.type.id;
                                this._ADProxy.addStatus(ADDef.STATUS_PRE_LOADING);
                                this._log.info("start preload next AD,tvid:" + _loc_7.tvId + ",vid:" + _loc_7.videoId + ",cupId:" + _loc_7.playerId + ",videoPlaySecondsOfDay:" + _loc_7.videoPlaySecondsOfDay + ",disablePreroll:" + _loc_7.disablePreroll);
                                this._ADProxy.addStatus(ADDef.STATUS_PRE_STARTED);
                                this._ADView.onPreloadNextAD(_loc_7);
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        private function onLoadSuccess(event:ADEvent) : void
        {
            WonderVersion.VERSION_AD_PLAYER = String(event.data.version);
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = event.data.tvid;
            var _loc_4:* = event.data.vid;
            var _loc_5:* = _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.curActor.movieModel.qipuId) : (_loc_2.curActor.loadMovieParams.tvid);
            this._log.info("success to load adplayer,tvid:" + _loc_3 + ",vid:" + _loc_4);
            if (_loc_5 == _loc_3 && _loc_2.curActor.loadMovieParams.vid == _loc_4)
            {
                this.onCurLoadSuccess();
            }
            else if (_loc_2.preActor.loadMovieParams)
            {
                if (_loc_5 == _loc_3 && _loc_2.preActor.loadMovieParams.vid == _loc_4)
                {
                    this.onPreLoadSuccess();
                }
                else
                {
                    this._log.error("success to load adplayer,but has error,tvid and vid is invalid!");
                }
            }
            else
            {
                this._log.error("success to load adplayer,but has error,loadMovieParams is null!");
            }
            return;
        }// end function

        private function onCurLoadSuccess() : void
        {
            var _loc_1:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_4:* = new Object();
            if (this._ADProxy.curPlayCount >= ADDef.AD_CONTEXT_COUNT_LIMIT)
            {
                _loc_4.adContext = "1";
            }
            else
            {
                _loc_4.adContext = "0";
            }
            if (this._ADProxy.curAdContext15PlayDuration >= ADDef.AD_CONTEXT_DURATION_15_LIMIT)
            {
                _loc_4.adContext15 = "1";
            }
            else
            {
                _loc_4.adContext15 = "0";
            }
            _loc_4.videoid = _loc_2.curActor.loadMovieParams.vid;
            _loc_4.tvid = _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.curActor.movieModel.qipuId) : (_loc_2.curActor.loadMovieParams.tvid);
            _loc_4.channelid = _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.curActor.movieModel.channelID) : ("");
            _loc_4.videoname = encodeURI(_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY) ? (_loc_2.curActor.movieInfo.title) : (""));
            _loc_4.playerid = this._ADProxy.cupId;
            _loc_4.webEventId = UUIDManager.instance.getWebEventID();
            _loc_4.videoEventId = _loc_2.curActor.videoEventID;
            _loc_4.userid = UUIDManager.instance.uuid;
            _loc_4.albumid = _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.curActor.movieModel.albumId) : (_loc_2.curActor.loadMovieParams.albumId);
            _loc_4.adDepot = this._ADView.adDepot;
            _loc_4.duration = String(_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.curActor.movieModel.duration) : (0));
            _loc_4.vipRight = _loc_1.userLevel != UserDef.USER_LEVEL_NORMAL ? ("1") : ("0");
            _loc_4.vipFalseReason = UserManager.getInstance().user ? (UserManager.getInstance().user.vipFalseReason) : ("");
            _loc_4.autoPlay = this._adAutoPlay;
            if (_loc_3.isJSContinue || _loc_3.continueInfoCount > 0 && _loc_3.isContinue && _loc_3.findNextContinueInfo(_loc_2.curActor.loadMovieParams.tvid, _loc_4.videoid))
            {
                _loc_4.hasNext = "1";
            }
            else
            {
                _loc_4.hasNext = "0";
            }
            if (this._ADProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO)
            {
                _loc_4.continuingPlay = "1";
            }
            else
            {
                _loc_4.continuingPlay = "0";
            }
            _loc_4.passportKey = KeyUtils.getPassportKey(0);
            if (_loc_1.isLogin)
            {
                _loc_4.passportId = _loc_1.passportID;
                _loc_4.passportCookie = _loc_1.P00001;
            }
            else
            {
                _loc_4.passportId = "";
                _loc_4.passportCookie = "";
            }
            this._log.info("success to load cur adplayer: " + "cupId(" + _loc_4.playerid + ")," + "hasNext(" + _loc_4.hasNext + ")," + "adContext(" + _loc_4.adContext + ")," + "adContext15(" + _loc_4.adContext15 + ")," + "adDepot(" + _loc_4.adDepot + ")," + "vipRight(" + _loc_4.vipRight + ")," + "switchOperatorType(" + _loc_4.continuingPlay + ")," + "autoPlay(" + this._adAutoPlay + ")");
            this._ADView.onCurInfoChanged(_loc_4);
            this._ADView.onFullScreenChanged(GlobalStage.isFullScreen());
            this._ADProxy.addStatus(ADDef.STATUS_APPEARS, false);
            return;
        }// end function

        private function onPreLoadSuccess() : void
        {
            var _loc_1:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_4:* = _loc_2.curActor.playingDuration;
            var _loc_5:* = new Object();
            if ((this._ADProxy.prePlayCount + 1) >= ADDef.AD_CONTEXT_COUNT_LIMIT)
            {
                _loc_5.adContext = "1";
            }
            else
            {
                _loc_5.adContext = "0";
            }
            if (this._ADProxy.preAdContext15PlayDuration + _loc_4 >= ADDef.AD_CONTEXT_DURATION_15_LIMIT)
            {
                _loc_5.adContext15 = "1";
            }
            else
            {
                _loc_5.adContext15 = "0";
            }
            var _loc_6:* = _loc_3.findContinueInfo(_loc_2.preActor.loadMovieParams.tvid, _loc_2.preActor.loadMovieParams.vid);
            _loc_5.videoid = _loc_2.preActor.loadMovieParams.vid;
            _loc_5.tvid = _loc_2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.preActor.movieModel.qipuId) : (_loc_2.preActor.loadMovieParams.tvid);
            _loc_5.channelid = _loc_2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.preActor.movieModel.channelID) : ("");
            _loc_5.videoname = encodeURI(_loc_2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY) ? (_loc_2.preActor.movieInfo.title) : (""));
            if (_loc_6)
            {
                _loc_5.playerid = _loc_6.cupId;
            }
            else
            {
                _loc_5.playerid = "";
            }
            _loc_5.webEventId = UUIDManager.instance.getWebEventID();
            _loc_5.videoEventId = _loc_2.preActor.videoEventID;
            _loc_5.userid = UUIDManager.instance.uuid;
            _loc_5.albumid = _loc_2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.preActor.movieModel.albumId) : (_loc_2.preActor.loadMovieParams.albumId);
            _loc_5.duration = String(_loc_2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_2.preActor.movieModel.duration) : (""));
            _loc_5.vipRight = _loc_1.userLevel != UserDef.USER_LEVEL_NORMAL ? ("1") : ("0");
            _loc_5.vipFalseReason = UserManager.getInstance().user ? (UserManager.getInstance().user.vipFalseReason) : ("");
            _loc_5.autoPlay = this._adAutoPlay;
            if (_loc_3.isJSContinue || _loc_3.continueInfoCount > 0 && _loc_3.isContinue && _loc_3.findNextContinueInfo(_loc_2.preActor.loadMovieParams.tvid, _loc_5.videoid))
            {
                _loc_5.hasNext = "1";
            }
            else
            {
                _loc_5.hasNext = "0";
            }
            _loc_5.continuingPlay = "1";
            _loc_5.passportKey = KeyUtils.getPassportKey(0);
            if (_loc_1.isLogin)
            {
                _loc_5.passportId = _loc_1.passportID;
                _loc_5.passportCookie = _loc_1.P00001;
            }
            else
            {
                _loc_5.passportId = "";
                _loc_5.passportCookie = "";
            }
            this._log.info("success to load pre adplayer: " + "cupId(" + _loc_5.playerid + ")," + "hasNext(" + _loc_5.hasNext + ")," + "adContext(" + _loc_5.adContext + ")," + "adContext15(" + _loc_5.adContext15 + ")," + "vipRight(" + _loc_5.vipRight + ")," + "autoPlay(" + this._adAutoPlay + ")");
            this._ADView.onPreInfoChanged(_loc_5);
            this._ADView.onFullScreenChanged(GlobalStage.isFullScreen());
            return;
        }// end function

        private function onLoadFailed(event:ADEvent) : void
        {
            var _loc_2:* = event.data.tvid;
            var _loc_3:* = event.data.vid;
            this._log.warn("failed to load adplayer,tvid:" + _loc_2 + ",vid:" + _loc_3);
            ProcessesTimeRecord.needRecord = false;
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_5:* = _loc_4.curActor.movieModel ? (_loc_4.curActor.movieModel.qipuId) : (_loc_4.curActor.loadMovieParams.tvid);
            if (_loc_5 == _loc_2 && _loc_4.curActor.loadMovieParams.vid == _loc_3)
            {
                this._log.warn("failed to load cur adplayer!");
                this.unloadAdPlayer();
                this.removeAllAdStatus();
                this.sendNotification(HintDef.NOTIFIC_HINT_CHECK, false);
                this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
                sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_READY);
                sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_START_PLAY);
                this.showSkipADTip();
            }
            else if (_loc_4.preActor.loadMovieParams)
            {
                if (_loc_5 == _loc_2 && _loc_4.preActor.loadMovieParams.vid == _loc_3)
                {
                    this._log.warn("failed to load pre adplayer!");
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
                    this._ADProxy.addStatus(ADDef.STATUS_PRE_FAILED);
                }
                else
                {
                    this._log.error("failed to load adplayer,has error,tvid and vid is invalid!");
                }
            }
            else
            {
                this._log.error("failed to load adplayer,has error,loadMovieParams is null!");
            }
            return;
        }// end function

        private function onStartPlay(event:ADEvent) : void
        {
            var _loc_6:JavascriptAPIProxy = null;
            var _loc_7:Date = null;
            var _loc_8:Number = NaN;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = event.data.tvid;
            var _loc_4:* = event.data.vid;
            var _loc_5:* = _loc_2.curActor.movieModel ? (_loc_2.curActor.movieModel.qipuId) : (_loc_2.curActor.loadMovieParams.tvid);
            this._log.info("Adplayer start play ad,tvid:" + _loc_3 + ",vid:" + _loc_4);
            if (_loc_5 == _loc_3 && _loc_2.curActor.loadMovieParams.vid == _loc_4)
            {
                this._log.info("Adplayer start play cur ad!");
                if (ProcessesTimeRecord.usedTime_showVideo == 0)
                {
                    ProcessesTimeRecord.usedTime_adInit = getTimer() - ProcessesTimeRecord.STime_adInit;
                    ProcessesTimeRecord.usedTime_showVideo = getTimer() - ProcessesTimeRecord.STime_showVideo;
                    if (FlashVarConfig.pageCTime > 0)
                    {
                        _loc_7 = new Date();
                        _loc_8 = _loc_7.getTime() - FlashVarConfig.pageCTime;
                        if (_loc_8 > 0)
                        {
                            ProcessesTimeRecord.usedTime_pageShowVideo = _loc_8;
                        }
                    }
                }
                if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
                {
                    try
                    {
                        ExternalInterface.call("adStartPlay");
                    }
                    catch (error:Error)
                    {
                    }
                }
                this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
                this.onVolumeChanged();
                _loc_2.curActor.startLoadMeta();
                _loc_2.curActor.startLoadHistory();
                _loc_2.curActor.startLoadP2P();
                if (_loc_2.curActor.movieModel && _loc_2.curActor.movieModel.forceAD)
                {
                    this.showCopyrightForceADTip();
                }
                sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_AD_PLAYING);
                _loc_6 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                _loc_6.callJsFollowUpNextLoad();
                PingBack.getInstance().sendFirstVideo();
            }
            else
            {
                this._log.error("Adplayer start play pre ad!");
            }
            return;
        }// end function

        private function onAskVideoPause(event:ADEvent) : void
        {
            var _loc_2:* = event.data.tvid;
            var _loc_3:* = event.data.vid;
            this._log.info("ADPlayer ask Video Pause,tvid:" + _loc_2 + ",vid:" + _loc_3);
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_4.curActor.movieModel.qipuId == _loc_2 && _loc_4.curActor.loadMovieParams.vid == _loc_3)
            {
                this._log.info("ADPlayer cur ask Video Pause!");
                this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
                PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                this._ADView.onVolumeChanged(Settings.instance.mute ? (0) : (Settings.instance.volumn));
                sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
            }
            else
            {
                this._log.error("ADPlayer pre ask Video Pause!");
            }
            return;
        }// end function

        private function onAskVideoResume(event:ADEvent) : void
        {
            var _loc_2:* = event.data.tvid;
            var _loc_3:* = event.data.vid;
            this._log.info("Adplayer ask Video Resume,tvid:" + _loc_2 + ",vid:" + _loc_3);
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_4.curActor.movieModel.qipuId == _loc_2 && _loc_4.curActor.loadMovieParams.vid == _loc_3)
            {
                this._log.info("Adplayer cur ask Video Resume!");
                this.onVolumeChanged();
                sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
                this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
            }
            else
            {
                this._log.error("Adplayer pre ask Video Resume!");
            }
            return;
        }// end function

        private function onAskVideoStartLoad(event:ADEvent) : void
        {
            var _loc_2:* = event.data.tvid;
            var _loc_3:* = event.data.vid;
            this._log.info("Adplayer ask Video StartLoad,tvid:" + _loc_2 + ",vid:" + _loc_3);
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_5:* = _loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_4.curActor.movieModel.qipuId) : (_loc_4.curActor.loadMovieParams.tvid);
            if (_loc_5 == _loc_2 && _loc_4.curActor.loadMovieParams.vid == _loc_3)
            {
                this._log.info("Adplayer cur ask Video StartLoad!");
                _loc_4.curActor.setADRemainTime(int(event.data.delay) * 1000);
                sendNotification(BodyDef.NOTIFIC_PLAYER_START_LOAD);
            }
            else if (_loc_4.preActor.loadMovieParams)
            {
                if (_loc_4.preActor.movieModel.qipuId == _loc_2 && _loc_4.preActor.loadMovieParams.vid == _loc_3)
                {
                    this._log.info("Adplayer pre ask Video StartLoad!");
                    _loc_4.preActor.setADRemainTime(int(event.data.delay) * 1000);
                    this._ADProxy.addStatus(ADDef.STATUS_PRE_SUCCESS);
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD);
                }
                else
                {
                    this._log.error("Adplayer ask Video StartLoad,has error,tvid and vid is invalid!");
                }
            }
            else
            {
                this._log.error("Adplayer ask Video StartLoad,has error,loadMovieParams is null!");
            }
            return;
        }// end function

        private function onAskVideoStartPlay(event:ADEvent) : void
        {
            var _loc_2:* = event.data.tvid;
            var _loc_3:* = event.data.vid;
            var _loc_4:* = event.data.viewPoints as Array;
            this._log.info("Adplayer ask Video StartPlay,tvid:" + _loc_2 + ",vid:" + _loc_3);
            var _loc_5:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_6:* = _loc_5.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) ? (_loc_5.curActor.movieModel.qipuId) : (_loc_5.curActor.loadMovieParams.tvid);
            if (_loc_6 == _loc_2 && _loc_5.curActor.loadMovieParams.vid == _loc_3)
            {
                this._log.info("Adplayer cur ask Video StartPlay!");
                if (_loc_4 && _loc_4.length > 0)
                {
                    this._ADProxy.setADViewPoints(_loc_4);
                    sendNotification(ADDef.NOTIFIC_AD_RECEIVE_VIEW_POINTS);
                }
                this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
                if (!_loc_5.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED) && _loc_5.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_5.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
                {
                    this.sendNotification(HintDef.NOTIFIC_HINT_CHECK, false);
                    sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_READY);
                    sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_START_PLAY);
                    this.trySendSkipADPingBack();
                    this.showSkipADTip();
                    if (this._ADProxy.blocked)
                    {
                        this._log.info("Adplayer blocked,unload ad player on ask video start player!");
                        this.unloadAdPlayer();
                        this.removeAllAdStatus();
                    }
                }
            }
            else
            {
                this._log.error("Adplayer pre ask Video StartPlay!");
            }
            return;
        }// end function

        private function onAskVideoViewPoints(event:ADEvent) : void
        {
            var _loc_2:* = event.data.viewPoints as Array;
            this._log.info("Adplayer ask Video adplayer_ad_info");
            this._ADProxy.setADViewPoints(_loc_2);
            sendNotification(ADDef.NOTIFIC_AD_RECEIVE_VIEW_POINTS);
            return;
        }// end function

        private function onAskVideoEnd(event:ADEvent) : void
        {
            var _loc_5:Object = null;
            var _loc_2:* = event.data.tvid;
            var _loc_3:* = event.data.vid;
            this._log.info("Adplayer ask Video VideoEnd,tvid:" + _loc_2 + ",vid:" + _loc_3);
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_4.curActor.movieModel.qipuId == _loc_2 && _loc_4.curActor.loadMovieParams.vid == _loc_3)
            {
                this._log.info("Adplayer cur Video VideoEnd!");
                _loc_5 = new Object();
                _loc_5.adDepot = this._ADView.adDepot;
                this._ADView.onSendNotific(_loc_5);
                this._ADProxy.addStatus(ADDef.STATUS_PLAY_END);
            }
            else
            {
                this._log.error("Adplayer pre Video VideoEnd!");
            }
            return;
        }// end function

        private function onAdBlock(event:ADEvent) : void
        {
            var _loc_2:* = event.data.tvid;
            var _loc_3:* = event.data.vid;
            var _loc_4:* = event.data.isCidErr;
            this._log.info("Adplayer ask AD Block,tvid:" + _loc_2 + ",vid:" + _loc_3 + ",isCidErr:" + _loc_4);
            var _loc_5:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_5.invalid = _loc_4;
            ProcessesTimeRecord.needRecord = false;
            var _loc_6:* = _loc_5.curActor.movieModel ? (_loc_5.curActor.movieModel.qipuId) : (_loc_5.curActor.loadMovieParams.tvid);
            if (_loc_6 == _loc_2 && _loc_5.curActor.loadMovieParams.vid == _loc_3)
            {
                this._log.info("Adplayer cur AD Block!");
                this._ADProxy.blocked = true;
                this._ADProxy.addStatus(ADDef.STATUS_PLAYING);
                sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_AD_PLAYING);
            }
            else if (_loc_5.preActor.loadMovieParams)
            {
                if (_loc_6 == _loc_2 && _loc_5.preActor.loadMovieParams.vid == _loc_3)
                {
                    this._log.info("Adplayer pre AD Block!");
                    this._ADProxy.addStatus(ADDef.STATUS_PRE_SUCCESS);
                }
                else
                {
                    this._log.error("Adplayer ask AD Block,has error,tvid and vid is invalid!");
                }
            }
            else
            {
                this._log.error("Adplayer ask AD Block,has error,loadMovieParams is null!");
            }
            return;
        }// end function

        private function onAdUnloaded(event:ADEvent) : void
        {
            sendNotification(ADDef.NOTIFIC_AD_UNLOADED);
            return;
        }// end function

        private function onVolumeChanged() : void
        {
            if (this._ADProxy.mute || Settings.instance.mute)
            {
                this._ADView.onVolumeChanged(0);
            }
            else
            {
                this._ADView.onVolumeChanged(Settings.instance.volumn);
            }
            return;
        }// end function

        private function trySendSkipADPingBack() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            if (_loc_2.isLogin && _loc_2.userLevel != UserDef.USER_LEVEL_NORMAL)
            {
                PingBack.getInstance().skipAD(_loc_2.passportID, _loc_1.curActor.uuid, _loc_1.curActor.movieModel.tvid, _loc_1.curActor.movieModel.albumId);
            }
            return;
        }// end function

        private function onMouseMove(event:MouseEvent) : void
        {
            if (this.checkDockShowStatus())
            {
                this._ADView.onDockShowChanged(true);
                TweenLite.killTweensOf(this.hideDock);
                TweenLite.delayedCall(ADDef.DOCK_HIND_DELAY / 1000, this.hideDock);
            }
            return;
        }// end function

        private function hideDock() : void
        {
            this._ADView.onDockShowChanged(false);
            return;
        }// end function

        private function checkDockShowStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) || _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING)) && !this._ADProxy.hasStatus(ADDef.STATUS_LOADING) && !this._ADProxy.hasStatus(ADDef.STATUS_PLAYING) && !this._ADProxy.hasStatus(ADDef.STATUS_PAUSED) && !_loc_1.curActor.smallWindowMode)
            {
                return true;
            }
            return false;
        }// end function

    }
}
