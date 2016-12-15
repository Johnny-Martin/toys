package com.qiyi.player.wonder.body.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.ad.view.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.continueplay.view.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.*;
    import com.qiyi.player.wonder.plugins.dock.*;
    import com.qiyi.player.wonder.plugins.dock.model.*;
    import com.qiyi.player.wonder.plugins.dock.view.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.feedback.model.*;
    import com.qiyi.player.wonder.plugins.feedback.view.*;
    import com.qiyi.player.wonder.plugins.loading.*;
    import com.qiyi.player.wonder.plugins.loading.model.*;
    import com.qiyi.player.wonder.plugins.loading.view.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.model.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.view.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import com.qiyi.player.wonder.plugins.recommend.model.*;
    import com.qiyi.player.wonder.plugins.recommend.view.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import com.qiyi.player.wonder.plugins.setting.view.*;
    import com.qiyi.player.wonder.plugins.share.*;
    import com.qiyi.player.wonder.plugins.share.model.*;
    import com.qiyi.player.wonder.plugins.share.view.*;
    import com.qiyi.player.wonder.plugins.subscribe.*;
    import com.qiyi.player.wonder.plugins.subscribe.model.*;
    import com.qiyi.player.wonder.plugins.subscribe.view.*;
    import com.qiyi.player.wonder.plugins.tips.*;
    import com.qiyi.player.wonder.plugins.tips.model.*;
    import com.qiyi.player.wonder.plugins.tips.view.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import com.qiyi.player.wonder.plugins.topbar.model.*;
    import com.qiyi.player.wonder.plugins.topbar.view.*;
    import com.qiyi.player.wonder.plugins.videolink.*;
    import com.qiyi.player.wonder.plugins.videolink.model.*;
    import com.qiyi.player.wonder.plugins.videolink.view.*;
    import flash.events.*;
    import flash.external.*;
    import flash.system.*;
    import flash.ui.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class AppViewMediator extends Mediator
    {
        private var _appView:AppView;
        private var _playerProxy:PlayerProxy;
        private var _userProxy:UserProxy;
        private var _javascriptAPIProxy:JavascriptAPIProxy;
        private var _sceneTileProxy:SceneTileProxy;
        private var _continuePlayProxy:ContinuePlayProxy;
        private var _log:ILogger;
        private var _isNoticeJSCollectionGoods:Boolean = false;
        private var _timeListenerObj:Object = "";
        private var _curNotifiTimes:uint = 0;
        private var _apiType:String = "";
        public static const NAME:String = "com.qiyi.player.wonder.body.view.AppViewMediator";

        public function AppViewMediator(param1:AppView)
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.body.view.AppViewMediator");
            super(NAME, param1);
            this._appView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            var _loc_2:String = null;
            var _loc_3:ContextMenu = null;
            super.onRegister();
            this._log.info("wonder version : " + WonderVersion.VERSION_WONDER);
            var _loc_1:String = "Flash Vars:";
            for (_loc_2 in FlashVarConfig.flashVarSource)
            {
                
                _loc_1 = _loc_1 + (", " + _loc_2 + " = " + FlashVarConfig.flashVarSource[_loc_2]);
            }
            this._log.info(_loc_1);
            this._playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            this._userProxy = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            this._javascriptAPIProxy = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            this._continuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                GlobalStage.initCustomStage(this._playerProxy.curActor.corePlayer as ICustomStage);
            }
            this._appView.addEventListener(BodyEvent.Evt_StageResize, this.onStageResize);
            this._appView.addEventListener(BodyEvent.Evt_FullScreen, this.onFullScreen);
            this._appView.addEventListener(BodyEvent.Evt_LeaveStage, this.onLeaveStage);
            this._appView.addEventListener(BodyEvent.Evt_MouseLayerClick, this.onMouseLayerClick);
            this._appView.addEventListener(BodyEvent.Evt_MouseLayerDoubleClick, this.onMouseLayerDoubleClick);
            this.checkInitTipsPluginsView();
            this.checkInitControllBarPluginsView();
            this.checkInitDockPluginsView();
            this.checkInitFeedbackPluginsView();
            this.checkInitLoadingPluginsView();
            this.checkInitOfflineWatchPluginsView();
            this.checkInitRecommendPluginsView();
            this.checkInitSceneTilePluginsToolView();
            this.checkInitBarragePluginsView();
            this.checkInitScorePluginsView();
            this.checkInitSettingPluginsView();
            this.checkInitFilterPluginsView();
            this.checkInitDefinitionPluginsView();
            this.checkInitSharePluginsView();
            this.checkInitTopBarPluginsView();
            this.checkInitVideoLinkPluginsView();
            this.checkInitSubscribePluginsView();
            this.checkInitADPluginsView();
            this.checkInitContinuePlayPluginsView();
            try
            {
                this._apiType = ExternalInterface.call("eval", "(function() {var e = \"application/x-shockwave-flash\"," + "t = navigator.mimeTypes;if (t && t[e] && t[e].enabledPlugin){var n = t[e].enabledPlugin.filename;" + "return n.match(/pepflashplayer|Pepper/gi)?\"ppapi\":\"npapi\";}else{return \"npapi\";}})()");
            }
            catch (error:Error)
            {
                try
                {
                }
                _loc_3 = new ContextMenu();
                _loc_3.hideBuiltInItems();
                _loc_3.addEventListener(ContextMenuEvent.MENU_SELECT, this.onOpenMenu);
                this._appView.contextMenu = _loc_3;
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [BodyDef.NOTIFIC_REQUEST_INIT_PLAYER, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_PLAYER_RUNNING, BodyDef.NOTIFIC_PLAYER_UPDATE_OVER_BONUS, BodyDef.NOTIFIC_PLAYER_REPLAYED, BodyDef.NOTIFIC_PLAYER_TO_FOCUS_TIP, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, BodyDef.NOTIFIC_JS_CALL_SET_TIME_LISTENER, BodyDef.NOTIFIC_PLAYER_ARRIVE_TRYWATCH_TIME, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_JS_CALL_GET_COMMENT_CONFIG, ADDef.NOTIFIC_ADD_STATUS, ADDef.NOTIFIC_REMOVE_STATUS, ContinuePlayDef.NOTIFIC_ADD_STATUS, ContinuePlayDef.NOTIFIC_REMOVE_STATUS, ControllBarDef.NOTIFIC_ADD_STATUS, ControllBarDef.NOTIFIC_REMOVE_STATUS, DockDef.NOTIFIC_ADD_STATUS, DockDef.NOTIFIC_REMOVE_STATUS, FeedbackDef.NOTIFIC_ADD_STATUS, FeedbackDef.NOTIFIC_REMOVE_STATUS, LoadingDef.NOTIFIC_ADD_STATUS, LoadingDef.NOTIFIC_REMOVE_STATUS, OfflineWatchDef.NOTIFIC_ADD_STATUS, OfflineWatchDef.NOTIFIC_REMOVE_STATUS, RecommendDef.NOTIFIC_ADD_STATUS, RecommendDef.NOTIFIC_REMOVE_STATUS, SceneTileDef.NOTIFIC_ADD_STATUS, SceneTileDef.NOTIFIC_REMOVE_STATUS, SettingDef.NOTIFIC_ADD_STATUS, SettingDef.NOTIFIC_REMOVE_STATUS, ShareDef.NOTIFIC_ADD_STATUS, ShareDef.NOTIFIC_REMOVE_STATUS, TipsDef.NOTIFIC_ADD_STATUS, TipsDef.NOTIFIC_REMOVE_STATUS, TopBarDef.NOTIFIC_ADD_STATUS, TopBarDef.NOTIFIC_REMOVE_STATUS, VideoLinkDef.NOTIFIC_ADD_STATUS, VideoLinkDef.NOTIFIC_REMOVE_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:UserProxy = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case BodyDef.NOTIFIC_REQUEST_INIT_PLAYER:
                {
                    sendNotification(BodyDef.NOTIFIC_INIT_PLAYER, this._appView);
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this.onResize(_loc_2.w, _loc_2.h);
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
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this.onPlayerSwitchPreActor();
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    this.onPlayerRunning(_loc_2.currentTime, _loc_2.bufferTime, _loc_2.duration, _loc_2.playingDuration);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
                {
                    var _loc_8:* = _loc_2;
                    this._playerProxy.curActor.smallWindowMode = _loc_2;
                    this._playerProxy.preActor.smallWindowMode = _loc_8;
                    this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    if (this._playerProxy.curActor.smallWindowMode)
                    {
                        PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_TIME_LISTENER:
                {
                    this._timeListenerObj = _loc_2;
                    this._curNotifiTimes = 0;
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ARRIVE_TRYWATCH_TIME:
                {
                    GlobalStage.setNormalScreen();
                    _loc_5 = "";
                    _loc_6 = "";
                    if (this._playerProxy.curActor.loadMovieParams)
                    {
                        _loc_5 = this._playerProxy.curActor.loadMovieParams.tvid;
                        _loc_6 = this._playerProxy.curActor.loadMovieParams.vid;
                    }
                    this._javascriptAPIProxy.callJsRecharge(_loc_5, _loc_6, "Q00304");
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_UPDATE_OVER_BONUS:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        if (FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
                        {
                            _loc_7 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                            _loc_7.savePlayOverBonus(this._playerProxy.curActor.playingDuration, int(_loc_2));
                        }
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REPLAYED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.sendPlayListPing();
                        this._userProxy.bonusCompleted = false;
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_TO_FOCUS_TIP:
                {
                    this._javascriptAPIProxy.callJsFocusTips(FocusTip(_loc_2).timestamp);
                    break;
                }
                case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
                {
                    this.onCheckUserComplete();
                    break;
                }
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    this.onADStatusChanged(int(_loc_2), true);
                    break;
                }
                case ADDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onADStatusChanged(int(_loc_2), false);
                    break;
                }
                case ContinuePlayDef.NOTIFIC_ADD_STATUS:
                {
                    this.onContinuePlayStatusChanged(int(_loc_2), true);
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onContinuePlayStatusChanged(int(_loc_2), false);
                    break;
                }
                case ControllBarDef.NOTIFIC_ADD_STATUS:
                {
                    this.onControllBarStatusChanged(int(_loc_2), true);
                    break;
                }
                case ControllBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onControllBarStatusChanged(int(_loc_2), false);
                    break;
                }
                case DockDef.NOTIFIC_ADD_STATUS:
                {
                    this.onDockStatusChanged(int(_loc_2), true);
                    break;
                }
                case DockDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onDockStatusChanged(int(_loc_2), false);
                    break;
                }
                case FeedbackDef.NOTIFIC_ADD_STATUS:
                {
                    this.onFeedbackStatusChanged(int(_loc_2), true);
                    break;
                }
                case FeedbackDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onFeedbackStatusChanged(int(_loc_2), false);
                    break;
                }
                case LoadingDef.NOTIFIC_ADD_STATUS:
                {
                    this.onLoadingStatusChanged(int(_loc_2), true);
                    break;
                }
                case LoadingDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onLoadingStatusChanged(int(_loc_2), false);
                    break;
                }
                case OfflineWatchDef.NOTIFIC_ADD_STATUS:
                {
                    this.onOfflineWatchStatusChanged(int(_loc_2), true);
                    break;
                }
                case OfflineWatchDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onOfflineWatchStatusChanged(int(_loc_2), false);
                    break;
                }
                case RecommendDef.NOTIFIC_ADD_STATUS:
                {
                    this.onRecommendStatusChanged(int(_loc_2), true);
                    break;
                }
                case RecommendDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onRecommendStatusChanged(int(_loc_2), false);
                    break;
                }
                case SceneTileDef.NOTIFIC_ADD_STATUS:
                {
                    this.onSceneTileStatusChanged(int(_loc_2), true);
                    break;
                }
                case SceneTileDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onSceneTileStatusChanged(int(_loc_2), false);
                    break;
                }
                case SettingDef.NOTIFIC_ADD_STATUS:
                {
                    this.onSettingStatusChanged(int(_loc_2), true);
                    break;
                }
                case SettingDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onSettingStatusChanged(int(_loc_2), false);
                    break;
                }
                case ShareDef.NOTIFIC_ADD_STATUS:
                {
                    this.onShareStatusChanged(int(_loc_2), true);
                    break;
                }
                case ShareDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onShareStatusChanged(int(_loc_2), false);
                    break;
                }
                case TipsDef.NOTIFIC_ADD_STATUS:
                {
                    this.onTipsStatusChanged(int(_loc_2), true);
                    break;
                }
                case TipsDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onTipsStatusChanged(int(_loc_2), false);
                    break;
                }
                case TopBarDef.NOTIFIC_ADD_STATUS:
                {
                    this.onTopBarStatusChanged(int(_loc_2), true);
                    break;
                }
                case TopBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onTopBarStatusChanged(int(_loc_2), false);
                    break;
                }
                case VideoLinkDef.NOTIFIC_ADD_STATUS:
                {
                    this.onVideoLinkStatusChanged(int(_loc_2), true);
                    break;
                }
                case VideoLinkDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onVideoLinkStatusChanged(int(_loc_2), false);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_GET_COMMENT_CONFIG:
                {
                    if (this._playerProxy.curActor && this._playerProxy.curActor.movieInfo)
                    {
                        this._javascriptAPIProxy.callJsCommentAllowed(this._playerProxy.curActor.movieInfo.commentAllowed, this._playerProxy.curActor.movieInfo.qtId);
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

        private function onResize(param1:int, param2:int) : void
        {
            var _loc_3:* = GlobalStage.isFullScreen() || SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE) || this._playerProxy.curActor.smallWindowMode ? (param2) : (param2 - BodyDef.VIDEO_BOTTOM_RESERVE);
            this._playerProxy.curActor.setArea(0, 0, param1, _loc_3);
            this._playerProxy.preActor.setArea(0, 0, param1, _loc_3);
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            var _loc_5:String = null;
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            var _loc_4:* = UserManager.getInstance().user;
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2 && _loc_4)
                    {
                        _loc_4.tvid = this._playerProxy.curActor.loadMovieParams.tvid;
                        _loc_4.closeHeartBeat();
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    if (param2)
                    {
                        this._javascriptAPIProxy.callJsCommentAllowed(this._playerProxy.curActor.movieInfo.commentAllowed, this._playerProxy.curActor.movieInfo.qtId);
                        if (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
                        {
                            this._isNoticeJSCollectionGoods = false;
                            this._userProxy.bonusCompleted = false;
                            this._timeListenerObj = "";
                            this._curNotifiTimes = 0;
                            if (this._playerProxy.curActor.movieModel.member)
                            {
                                _loc_5 = "";
                                if (this._playerProxy.curActor.loadMovieParams)
                                {
                                    _loc_5 = this._playerProxy.curActor.loadMovieParams.tvid;
                                }
                                this._javascriptAPIProxy.callJsAuthenticationResult(_loc_5, this._playerProxy.curActor.isTryWatch);
                            }
                            this.sendPlayListPing();
                            sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_DATA_READY);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_LOAD_COMPLETE:
                {
                    if (param2)
                    {
                        this._javascriptAPIProxy.callJsLoadComplete();
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_SEEKING:
                {
                    if (param2)
                    {
                        sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_SEEKING);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_WAITING:
                {
                    if (param2)
                    {
                        if (_loc_4)
                        {
                            _loc_4.closeHeartBeat();
                        }
                        sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_WAITING);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PAUSED:
                {
                    if (param2)
                    {
                        if (_loc_4)
                        {
                            _loc_4.closeHeartBeat();
                        }
                        sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_PAUSED);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    if (param2)
                    {
                        if (_loc_4)
                        {
                            _loc_4.openHeartBeat();
                        }
                        sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_PLAYING);
                        PingBack.getInstance().sendVideoStart();
                        PingBack.getInstance().sendFirstVideo();
                        this._javascriptAPIProxy.callJsFollowUpNextLoad();
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2)
                    {
                        if (_loc_4)
                        {
                            _loc_4.closeHeartBeat();
                        }
                        sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_STOPED);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        if (_loc_4)
                        {
                            _loc_4.closeHeartBeat();
                        }
                        this.showError();
                        this._javascriptAPIProxy.callJsFollowUpNextLoad();
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
                {
                    if (param2)
                    {
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

        private function onPlayerSwitchPreActor() : void
        {
            var _loc_2:String = null;
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                GlobalStage.initCustomStage(this._playerProxy.curActor.corePlayer as ICustomStage);
            }
            var _loc_1:* = UserManager.getInstance().user;
            if (_loc_1 && this._playerProxy.curActor.loadMovieParams)
            {
                _loc_1.tvid = this._playerProxy.curActor.loadMovieParams.tvid;
            }
            this._appView.switchPreLayer();
            if (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                this._isNoticeJSCollectionGoods = false;
                this._userProxy.bonusCompleted = false;
                this._timeListenerObj = "";
                this._curNotifiTimes = 0;
                if (this._playerProxy.curActor.movieModel.member)
                {
                    _loc_2 = "";
                    if (this._playerProxy.curActor.loadMovieParams)
                    {
                        _loc_2 = this._playerProxy.curActor.loadMovieParams.tvid;
                    }
                    this._javascriptAPIProxy.callJsAuthenticationResult(_loc_2, this._playerProxy.curActor.isTryWatch);
                }
                sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_DATA_READY);
            }
            if (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
            {
                this.showError();
            }
            this.sendPlayListPing();
            return;
        }// end function

        private function showError() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            if (this._playerProxy.curActor.authenticationError && this._playerProxy.curActor.authenticationResult)
            {
                if (this._playerProxy.curActor.authenticationResult.code == "Q00501" || this._playerProxy.curActor.authenticationResult.code == "Q00507")
                {
                    sendNotification(FeedbackDef.NOTIFIC_OPEN_CLOSE, true);
                }
                else
                {
                    try
                    {
                        GlobalStage.setNormalScreen();
                    }
                    catch (error:Error)
                    {
                    }
                    _loc_1 = "";
                    _loc_2 = "";
                    if (this._playerProxy.curActor.loadMovieParams)
                    {
                        _loc_1 = this._playerProxy.curActor.loadMovieParams.tvid;
                        _loc_2 = this._playerProxy.curActor.loadMovieParams.vid;
                    }
                    this._javascriptAPIProxy.callJsRecharge(_loc_1, _loc_2, this._playerProxy.curActor.authenticationResult.code);
                }
            }
            else
            {
                sendNotification(FeedbackDef.NOTIFIC_OPEN_CLOSE, true);
            }
            sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_ERROR);
            return;
        }// end function

        private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:Number = NaN;
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
            {
                this._userProxy.saveOneMinusBonus(param4);
            }
            this.checkShowScorePanel(param1, param2, param3, param4);
            this.checkJsCallTimeListener(param1, param2, param3, param4);
            if (Settings.instance.skipTrailer && this._playerProxy.curActor.movieModel.trailerTime > 0)
            {
                _loc_5 = this._playerProxy.curActor.movieModel.trailerTime;
            }
            else
            {
                _loc_5 = param3;
            }
            if (!this._isNoticeJSCollectionGoods && param3 > 30 * 1000 && _loc_5 - param1 <= 30 * 1000)
            {
                this._isNoticeJSCollectionGoods = true;
                this._javascriptAPIProxy.callJsDoSomething(BodyDef.JS_DOSAMETHING_SHOW_COLLECTION_GOODS);
            }
            return;
        }// end function

        private function checkShowScorePanel(param1:int, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:* = this._continuePlayProxy.findContinueInfo(this._playerProxy.curActor.loadMovieParams.tvid, this._playerProxy.curActor.loadMovieParams.vid);
            var _loc_6:Number = 0;
            if (_loc_5 && _loc_5.canScore)
            {
                if (!this._sceneTileProxy.isScored && !this._playerProxy.curActor.smallWindowMode && param4 >= param3 * SceneTileDef.SCORE_PLAYING_DURATION)
                {
                    _loc_6 = this._playerProxy.curActor.movieModel.trailerTime == 0 ? (param3) : (this._playerProxy.curActor.movieModel.trailerTime);
                    if (!this._sceneTileProxy.isOpen && param1 >= _loc_6 * SceneTileDef.SCORE_PLAYING_POINT - 500 && param1 <= _loc_6 * SceneTileDef.SCORE_PLAYING_POINT + 500)
                    {
                        this._sceneTileProxy.isOpen = true;
                        sendNotification(SceneTileDef.NOTIFIC_OPEN_CLOSE_SCORE, true);
                    }
                }
            }
            else if (FlashVarConfig.canScore && !this._sceneTileProxy.isScored && !this._playerProxy.curActor.smallWindowMode && param4 >= param3 * SceneTileDef.SCORE_PLAYING_DURATION)
            {
                _loc_6 = this._playerProxy.curActor.movieModel.trailerTime == 0 ? (param3) : (this._playerProxy.curActor.movieModel.trailerTime);
                if (!this._sceneTileProxy.isOpen && param1 >= _loc_6 * SceneTileDef.SCORE_PLAYING_POINT - 500 && param1 <= _loc_6 * SceneTileDef.SCORE_PLAYING_POINT + 500)
                {
                    this._sceneTileProxy.isOpen = true;
                    sendNotification(SceneTileDef.NOTIFIC_OPEN_CLOSE_SCORE, true);
                }
            }
            return;
        }// end function

        private function checkJsCallTimeListener(param1:int, param2:int, param3:int, param4:int) : void
        {
            if (this._timeListenerObj && this._timeListenerObj.curTime && this._timeListenerObj.floatTime && this._timeListenerObj.times)
            {
                if (this._curNotifiTimes < this._timeListenerObj.times && param1 >= this._timeListenerObj.curTime - this._timeListenerObj.floatTime && param1 <= this._timeListenerObj.curTime + this._timeListenerObj.floatTime)
                {
                    this._javascriptAPIProxy.callJsDoSomething(BodyDef.JS_CALL_TIME_LISTENER_CALLBACK);
                    var _loc_5:String = this;
                    var _loc_6:* = this._curNotifiTimes + 1;
                    _loc_5._curNotifiTimes = _loc_6;
                }
            }
            return;
        }// end function

        private function checkInitTipsPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(TipsProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(TipsDef.STATUS_VIEW_INIT))
            {
                TipsPlugins.getInstance().initView(this._appView.fixSub1Layer, this.Vector.<String>([TipsViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitControllBarPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(ControllBarProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(ControllBarDef.STATUS_VIEW_INIT))
            {
                ControllBarPlugins.getInstance().initView(this._appView.fixLayer, this.Vector.<String>([ControllBarViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitDockPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(DockProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(DockDef.STATUS_VIEW_INIT))
            {
                DockPlugins.getInstance().initView(this._appView.fixLayer, this.Vector.<String>([DockViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitFeedbackPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(FeedbackProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(FeedbackDef.STATUS_VIEW_INIT))
            {
                FeedbackPlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([FeedbackViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitLoadingPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(LoadingProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(LoadingDef.STATUS_VIEW_INIT))
            {
                LoadingPlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([LoadingViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitOfflineWatchPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(OfflineWatchProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(OfflineWatchDef.STATUS_VIEW_INIT))
            {
                OfflineWatchPlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([OfflineWatchViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitRecommendPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(RecommendProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT))
            {
                RecommendPlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([RecommendViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitSceneTilePluginsToolView() : void
        {
            var _loc_1:* = facade.retrieveProxy(SceneTileProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(SceneTileDef.STATUS_TOOL_VIEW_INIT))
            {
                SceneTilePlugins.getInstance().initView(this._appView.sceneTileToolLayer, this.Vector.<String>([SceneTileToolViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitBarragePluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(SceneTileProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(SceneTileDef.STATUS_BARRAGE_VIEW_INIT))
            {
                SceneTilePlugins.getInstance().initView(this._appView.barrageLayer, this.Vector.<String>([SceneTileBarrageViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitScorePluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(SceneTileProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(SceneTileDef.STATUS_SCORE_VIEW_INIT))
            {
                SceneTilePlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([SceneTileScoreViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitSettingPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(SettingProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(SettingDef.STATUS_VIEW_INIT))
            {
                SettingPlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([SettingViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitFilterPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(SettingProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(SettingDef.STATUS_FILTER_VIEW_INIT))
            {
                SettingPlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([FilterViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitDefinitionPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(SettingProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(SettingDef.STATUS_DEFINITION_VIEW_INIT))
            {
                SettingPlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([DefinitionViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitSharePluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(ShareProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(ShareDef.STATUS_VIEW_INIT))
            {
                SharePlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([ShareViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitTopBarPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(TopBarProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(TopBarDef.STATUS_VIEW_INIT))
            {
                TopBarPlugins.getInstance().initView(this._appView.fixLayer, this.Vector.<String>([TopBarViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitVideoLinkPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(VideoLinkProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(VideoLinkDef.STATUS_VIEW_INIT))
            {
                VideoLinkPlugins.getInstance().initView(this._appView.popupLayer, this.Vector.<String>([VideoLinkViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitSubscribePluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(SubscribeProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(SubscribeDef.STATUS_VIEW_INIT))
            {
                SubscribePlugins.getInstance().initView(this._appView.barrageLayer, this.Vector.<String>([SubscribeViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitADPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(ADProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(ADDef.STATUS_VIEW_INIT))
            {
                ADPlugins.getInstance().initView(this._appView.ADLayer, this.Vector.<String>([ADViewMediator.NAME]));
            }
            return;
        }// end function

        private function checkInitContinuePlayPluginsView() : void
        {
            var _loc_1:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as IStatus;
            if (_loc_1.hasStatus(ContinuePlayDef.STATUS_VIEW_INIT))
            {
                ContinuePlayPlugins.getInstance().initView(this._appView.fixLayer, this.Vector.<String>([ContinuePlayViewMediator.NAME]));
            }
            return;
        }// end function

        private function onADStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ADDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitADPluginsView();
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

        private function onContinuePlayStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ContinuePlayDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitContinuePlayPluginsView();
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

        private function onControllBarStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ControllBarDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitControllBarPluginsView();
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

        private function onDockStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case DockDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitDockPluginsView();
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

        private function onFeedbackStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case FeedbackDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitFeedbackPluginsView();
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

        private function onLoadingStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case LoadingDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitLoadingPluginsView();
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

        private function onOfflineWatchStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case OfflineWatchDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitOfflineWatchPluginsView();
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

        private function onRecommendStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitRecommendPluginsView();
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

        private function onSceneTileStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case SceneTileDef.STATUS_TOOL_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitSceneTilePluginsToolView();
                    }
                    break;
                }
                case SceneTileDef.STATUS_BARRAGE_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitBarragePluginsView();
                    }
                    break;
                }
                case SceneTileDef.STATUS_SCORE_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitScorePluginsView();
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

        private function onSettingStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case SettingDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitSettingPluginsView();
                    }
                    break;
                }
                case SettingDef.STATUS_DEFINITION_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitDefinitionPluginsView();
                    }
                    break;
                }
                case SettingDef.STATUS_FILTER_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitFilterPluginsView();
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

        private function onShareStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ShareDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitSharePluginsView();
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

        private function onTipsStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case TipsDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitTipsPluginsView();
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

        private function onTopBarStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case TopBarDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitTopBarPluginsView();
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

        private function onVideoLinkStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case VideoLinkDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitVideoLinkPluginsView();
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

        private function onSubscribeStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case SubscribeDef.STATUS_VIEW_INIT:
                {
                    if (param2)
                    {
                        this.checkInitSubscribePluginsView();
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

        private function onStageResize(event:BodyEvent) : void
        {
            sendNotification(BodyDef.NOTIFIC_RESIZE, {w:GlobalStage.stage.stageWidth, h:GlobalStage.stage.stageHeight});
            return;
        }// end function

        private function onFullScreen(event:BodyEvent) : void
        {
            if (Boolean(event.data))
            {
                PingBack.getInstance().userActionPing(PingBackDef.FULL_SCREEN, this._playerProxy.curActor.currentTime);
            }
            this._javascriptAPIProxy.callJsSwitchFullScreen(Boolean(event.data));
            sendNotification(BodyDef.NOTIFIC_FULL_SCREEN, event.data);
            return;
        }// end function

        private function onLeaveStage(event:BodyEvent) : void
        {
            sendNotification(BodyDef.NOTIFIC_LEAVE_STAGE);
            return;
        }// end function

        private function onMouseLayerClick(event:BodyEvent) : void
        {
            if (this._playerProxy.curActor.smallWindowMode)
            {
                return;
            }
            sendNotification(BodyDef.NOTIFIC_MOUSE_LAYER_CLICK);
            return;
        }// end function

        private function onMouseLayerDoubleClick(event:BodyEvent) : void
        {
            if (this._playerProxy.curActor.smallWindowMode)
            {
                return;
            }
            if (!GlobalStage.isFullScreen())
            {
                GlobalStage.setFullScreen();
            }
            else
            {
                GlobalStage.setNormalScreen();
            }
            return;
        }// end function

        private function onOpenMenu(event:Event) : void
        {
            var _loc_2:ContextMenu = null;
            var _loc_3:ContextMenuItem = null;
            var _loc_4:String = null;
            var _loc_5:ContextMenuItem = null;
            var _loc_6:ContextMenuItem = null;
            var _loc_7:ContextMenuItem = null;
            var _loc_8:Boolean = false;
            var _loc_9:ContextMenuItem = null;
            var _loc_10:ContextMenuItem = null;
            var _loc_11:ContextMenuItem = null;
            try
            {
                if (this._apiType && this._apiType == "ppapi" && !this._appView.hasEventListener(MouseEvent.RIGHT_CLICK))
                {
                    this._appView.addEventListener(MouseEvent.RIGHT_CLICK, this.onRightClick);
                    TweenLite.delayedCall(10, this.onDelayedCall);
                }
                _loc_2 = this._appView.contextMenu;
                _loc_2.customItems = [];
                _loc_3 = new ContextMenuItem("iQiyiPlayer " + WonderVersion.VERSION_WONDER + "-" + WonderVersion.VERSION_AD_PLUGINS);
                _loc_2.customItems.push(_loc_3);
                _loc_4 = "Kernel " + Version.VERSION;
                if (Version.VERSION_FLASH_P2P)
                {
                    _loc_4 = _loc_4 + ("_" + Version.VERSION_FLASH_P2P);
                }
                _loc_5 = new ContextMenuItem(_loc_4);
                _loc_2.customItems.push(_loc_5);
                if (WonderVersion.VERSION_AD_PLAYER)
                {
                    _loc_11 = new ContextMenuItem(WonderVersion.VERSION_AD_PLAYER);
                    _loc_2.customItems.push(_loc_11);
                }
                _loc_6 = new ContextMenuItem("复制视频swf地址", true);
                _loc_6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onCopyVideoSwfUrl);
                _loc_7 = new ContextMenuItem("复制视频html地址");
                _loc_7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onCopyVideoHtmlUrl);
                _loc_8 = true;
                if (this._playerProxy.curActor && this._playerProxy.curActor.movieInfo && this._playerProxy.curActor.movieInfo.infoJSON && this._playerProxy.curActor.movieInfo.infoJSON.plc && this._playerProxy.curActor.movieInfo.infoJSON.plc[14] && this._playerProxy.curActor.movieInfo.infoJSON.plc[14].coa != 1 || this._playerProxy.curActor.getSwfUrl() == "")
                {
                    _loc_8 = false;
                }
                if (_loc_8)
                {
                    _loc_2.customItems.push(_loc_6);
                    _loc_2.customItems.push(_loc_7);
                }
                _loc_9 = new ContextMenuItem("显示视频信息", true);
                _loc_9.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onToggleVideoInfo);
                _loc_2.customItems.push(_loc_9);
                _loc_10 = null;
                if (this._playerProxy.curActor.accStatus == VideoAccEnum.GPU_ACCELERATED || this._playerProxy.curActor.accStatus == VideoAccEnum.GPU_RENDERING)
                {
                    _loc_10 = new ContextMenuItem("关闭硬件加速");
                }
                else
                {
                    _loc_10 = new ContextMenuItem("尝试开启硬件加速");
                }
                _loc_10.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onSettingGPU);
                _loc_10.enabled = true;
                _loc_2.customItems.push(_loc_10);
                this._appView.contextMenu = _loc_2;
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function onRightClick(event:MouseEvent) : void
        {
            return;
        }// end function

        private function onDelayedCall() : void
        {
            try
            {
                if (this._appView.hasEventListener(MouseEvent.RIGHT_CLICK))
                {
                    TweenLite.killDelayedCallsTo();
                    this._appView.removeEventListener(MouseEvent.RIGHT_CLICK, this.onRightClick);
                }
            }
            catch ($error:Error)
            {
            }
            return;
        }// end function

        private function onToggleVideoInfo(event:ContextMenuEvent) : void
        {
            this._playerProxy.curActor.floatLayer.toggleVideoInfo();
            return;
        }// end function

        private function onSettingGPU(event:ContextMenuEvent) : void
        {
            Settings.instance.useGPU = !Settings.instance.useGPU;
            return;
        }// end function

        private function onCopyVideoSwfUrl(event:ContextMenuEvent) : void
        {
            System.setClipboard(this._playerProxy.curActor.getSwfUrl());
            return;
        }// end function

        private function onCopyVideoHtmlUrl(event:ContextMenuEvent) : void
        {
            System.setClipboard(this._playerProxy.curActor.getHtmlUrl());
            return;
        }// end function

        private function sendPlayListPing() : void
        {
            if (FlashVarConfig.isFloatPlayer != "")
            {
                PingBack.getInstance().floatPlayerPing();
            }
            if (FlashVarConfig.isheadmap != "")
            {
                PingBack.getInstance().headmapPing();
            }
            return;
        }// end function

        private function onCheckUserComplete() : void
        {
            var _loc_1:* = UserManager.getInstance().user;
            if (this._userProxy.isLogin && _loc_1 && this._playerProxy.curActor.loadMovieParams)
            {
                _loc_1.tvid = this._playerProxy.curActor.loadMovieParams.tvid;
                if (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING))
                {
                    _loc_1.openHeartBeat();
                }
            }
            return;
        }// end function

    }
}
