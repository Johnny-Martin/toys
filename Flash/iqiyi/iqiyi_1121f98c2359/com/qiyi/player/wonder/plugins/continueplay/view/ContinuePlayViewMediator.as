package com.qiyi.player.wonder.plugins.continueplay.view
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.videolink.*;
    import flash.events.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class ContinuePlayViewMediator extends Mediator
    {
        private var _continuePlayProxy:ContinuePlayProxy;
        private var _continuePlayView:ContinuePlayView;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.continueplay.view.ContinuePlayViewMediator";

        public function ContinuePlayViewMediator(param1:ContinuePlayView)
        {
            this._log = Log.getLogger(NAME);
            super(NAME, param1);
            this._continuePlayView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._continuePlayProxy = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_Open, this.onContinuePlayViewOpen);
            this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_Close, this.onContinuePlayViewClose);
            this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_ListItemClick, this.onListItemClick);
            this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_ArrowClick, this.onArrowClick);
            this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_SwitchPageTriggerRequest, this.onPageTriggerRequest);
            this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_SwitchOverPage, this.onSwitchOverPage);
            this._continuePlayView.addEventListener(ContinuePlayEvent.Evt_SwitchOverPageDone, this.onSwitchOverPageDone);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [ContinuePlayDef.NOTIFIC_ADD_STATUS, ContinuePlayDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE, BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO, BodyDef.NOTIFIC_JS_CALL_SWITCH_VIDEO, BodyDef.NOTIFIC_JS_CALL_SWITCH_NEXT_VIDEO, BodyDef.NOTIFIC_JS_CALL_SWITCH_PRE_VIDEO, BodyDef.NOTIFIC_PLAYER_RUNNING, BodyDef.NOTIFIC_JS_CALL_SET_CYCLE_PLAY, BodyDef.NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, ADDef.NOTIFIC_ADD_STATUS, ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO, ContinuePlayDef.NOTIFIC_REQUEST_PRE_VIDEO, ContinuePlayDef.NOTIFIC_REQUEST_SWITCH_VIDEO, ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED, ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE, SceneTileDef.NOTIFIC_REMOVE_STATUS, SettingDef.NOTIFIC_ADD_STATUS, VideoLinkDef.NOTIFIC_ADD_STATUS, ControllBarDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            var _loc_5:PlayerProxy = null;
            var _loc_6:LoadMovieParams = null;
            var _loc_7:ContinueInfo = null;
            switch(_loc_3)
            {
                case ContinuePlayDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ContinuePlayDef.STATUS_OPEN)
                    {
                        _loc_5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                        this.requestVideoList(_loc_5.curActor.loadMovieParams.tvid, _loc_5.curActor.loadMovieParams.vid);
                        this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(), true, this._continuePlayProxy.hasPreNeedLoad, this._continuePlayProxy.hasNextNeedLoad);
                        this._continuePlayView.updateOpenView();
                        this._continuePlayView.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
                        this.onOpenDelayedCloseDock();
                    }
                    this._continuePlayView.onAddStatus(int(_loc_2));
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == ContinuePlayDef.STATUS_OPEN)
                    {
                        this._continuePlayView.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
                    }
                    this._continuePlayView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._continuePlayView.onResize(_loc_2.w, _loc_2.h);
                    break;
                }
                case BodyDef.NOTIFIC_FULL_SCREEN:
                {
                    if (!Boolean(_loc_2) && FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
                    {
                        this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
                {
                    this.onCheckUserComplete();
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:
                {
                    this._continuePlayProxy.isContinue = Boolean(_loc_2);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:
                {
                    this._continuePlayProxy.isJSContinue = Boolean(_loc_2.continuePlay);
                    this._continuePlayProxy.JSContinueTitle = _loc_2.nextVideoTitle;
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SWITCH_VIDEO:
                {
                    _loc_5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    _loc_6 = _loc_5.curActor.loadMovieParams;
                    if (_loc_6 == null || _loc_6 && _loc_6.vid != _loc_2.vid)
                    {
                        _loc_7 = this._continuePlayProxy.findContinueInfo(_loc_2.tvid, _loc_2.vid);
                        sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID, _loc_7.cupId);
                        this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_JS_LIST;
                        _loc_5.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO ? (PingBackDef.VVPING_AUTO_PLAY) : (PingBackDef.VVPING_USER_CLICK);
                        _loc_5.curActor.vfrm = _loc_7.vfrm;
                        this.onSwitchVideo(_loc_7);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    this.onPlayerRunning(_loc_2.currentTime, _loc_2.bufferTime, _loc_2.duration);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_CYCLE_PLAY:
                {
                    this._continuePlayProxy.isCyclePlay = Boolean(_loc_2);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO:
                {
                    this.onJSCallLoadQiyiVideo(_loc_2);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
                {
                    this.onPlayerStatusChanged(int(_loc_2), true, _loc_4);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this.onPlayerSwitchPreActor();
                    break;
                }
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    this.onADStatusChanged(int(_loc_2), true);
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO:
                {
                    this.onRequestNextVideo(false);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SWITCH_NEXT_VIDEO:
                {
                    this.onRequestNextVideo(true);
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REQUEST_PRE_VIDEO:
                {
                    this.onRequestPreVideo(false);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SWITCH_PRE_VIDEO:
                {
                    this.onRequestPreVideo(true);
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REQUEST_SWITCH_VIDEO:
                {
                    _loc_5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    _loc_6 = _loc_5.curActor.loadMovieParams;
                    if (_loc_6 == null || _loc_6 && _loc_6.vid != _loc_2.vid)
                    {
                        _loc_7 = this._continuePlayProxy.findContinueInfo(_loc_2.tvid, _loc_2.vid);
                        sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID, _loc_7.cupId);
                        if (_loc_2.switchVideoType != undefined)
                        {
                            this._continuePlayProxy.switchVideoType = int(_loc_2.switchVideoType);
                        }
                        else
                        {
                            this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PROGRAM_FREE_SWITCHING;
                        }
                        _loc_5.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO ? (PingBackDef.VVPING_AUTO_PLAY) : (PingBackDef.VVPING_USER_CLICK);
                        _loc_5.curActor.vfrm = _loc_7.vfrm;
                        this.onSwitchVideo(_loc_7);
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED:
                {
                    this.onInfoListChanged(_loc_2);
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE:
                {
                    this._continuePlayProxy.switchVideoType = int(_loc_2);
                    break;
                }
                case SceneTileDef.NOTIFIC_REMOVE_STATUS:
                {
                    break;
                }
                case SettingDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == SettingDef.STATUS_DEFINITION_OPEN)
                    {
                        this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
                    }
                    break;
                }
                case VideoLinkDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == VideoLinkDef.STATUS_OPEN)
                    {
                        this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
                    }
                    break;
                }
                case ControllBarDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW)
                    {
                        this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
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

        private function onContinuePlayViewOpen(event:ContinuePlayEvent) : void
        {
            if (!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN))
            {
                this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onContinuePlayViewClose(event:ContinuePlayEvent) : void
        {
            if (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN))
            {
                this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2)
                    {
                        this._continuePlayView.setCurPlaying(_loc_4.curActor.loadMovieParams.tvid, _loc_4.curActor.loadMovieParams.vid);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                {
                    if (param2)
                    {
                        if (this._continuePlayProxy.continueInfoCount)
                        {
                            this.requestVideoList(_loc_4.curActor.loadMovieParams.tvid, _loc_4.curActor.loadMovieParams.vid);
                        }
                        else if (this._continuePlayProxy.isContinue)
                        {
                            this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
                            this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
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

        private function onADStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ADDef.STATUS_PLAY_END:
                {
                    if (param2)
                    {
                        this.onADPlayEnd();
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
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
            {
                this._continuePlayView.setCurPlaying(_loc_1.curActor.loadMovieParams.tvid, _loc_1.curActor.loadMovieParams.vid);
            }
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                if (this._continuePlayProxy.continueInfoCount)
                {
                    this.requestVideoList(_loc_1.curActor.loadMovieParams.tvid, _loc_1.curActor.loadMovieParams.vid);
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
            this._continuePlayView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function onADPlayEnd() : void
        {
            var _loc_3:LoadMovieParams = null;
            var _loc_4:ContinueInfo = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            if (this._continuePlayProxy.isCyclePlay)
            {
                if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
                {
                    this._log.info("ContinuePlayViewMediator >> onADPlayEnd:send request replay notifi!");
                    sendNotification(ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO);
                    PingBack.getInstance().cyclePlayPing(PingBackDef.PLAYER_ACTION, PingBackDef.PLAYER_ACTION);
                }
            }
            else if (this._continuePlayProxy.isContinue && this._continuePlayProxy.continueInfoCount > 0)
            {
                if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
                {
                    _loc_3 = _loc_1.curActor.loadMovieParams;
                    _loc_4 = this._continuePlayProxy.findNextContinueInfo(_loc_3.tvid, _loc_3.vid);
                    if (_loc_4)
                    {
                        this._log.info("ContinuePlayViewMediator >> onADPlayEnd:send load movie tvid:" + _loc_4.loadMovieParams.tvid + ", vid:" + _loc_4.loadMovieParams.vid);
                        sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID, _loc_4.cupId);
                        this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO;
                        _loc_1.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO ? (PingBackDef.VVPING_AUTO_PLAY) : (PingBackDef.VVPING_USER_CLICK);
                        _loc_1.curActor.vfrm = _loc_4.vfrm;
                        _loc_1.preActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO ? (PingBackDef.VVPING_AUTO_PLAY) : (PingBackDef.VVPING_USER_CLICK);
                        _loc_1.preActor.vfrm = _loc_4.vfrm;
                        _loc_2.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
                        this.onSwitchVideo(_loc_4);
                        PingBack.getInstance().continuityPlayPing();
                    }
                    else
                    {
                        if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_RECOMMEND))
                        {
                            this._log.info("ContinuePlayViewMediator >> onADPlayEnd:open recommend!");
                            sendNotification(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE, true);
                        }
                        this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
                        sendNotification(ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER);
                        sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_END_PLAY);
                    }
                }
            }
            else if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
            {
                if (!this._continuePlayProxy.isJSContinue)
                {
                    if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_RECOMMEND))
                    {
                        this._log.info("ContinuePlayViewMediator >> onADPlayEnd:open recommend!");
                        sendNotification(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE, true);
                    }
                    this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
                    sendNotification(ADDef.NOTIFIC_REQUEST_UNLOAD_AD_PLAYER);
                    sendNotification(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, BodyDef.JS_STATUS_END_PLAY);
                }
            }
            return;
        }// end function

        private function onRequestNextVideo(param1:Boolean) : void
        {
            var _loc_2:PlayerProxy = null;
            var _loc_3:LoadMovieParams = null;
            var _loc_4:ContinueInfo = null;
            var _loc_5:JavascriptAPIProxy = null;
            if (this._continuePlayProxy.isContinue && this._continuePlayProxy.continueInfoCount > 0)
            {
                _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                _loc_3 = _loc_2.curActor.loadMovieParams;
                _loc_4 = this._continuePlayProxy.findNextContinueInfo(_loc_3.tvid, _loc_3.vid);
                if (_loc_4)
                {
                    this._log.info("ContinuePlayViewMediator >> onRequestNextVideo,tvid:" + _loc_4.loadMovieParams.tvid + ", vid:" + _loc_4.loadMovieParams.vid);
                    sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID, _loc_4.cupId);
                    this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PRE_NEXT_BTN;
                    _loc_2.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO ? (PingBackDef.VVPING_AUTO_PLAY) : (PingBackDef.VVPING_USER_CLICK);
                    _loc_2.curActor.vfrm = _loc_4.vfrm;
                    this.onSwitchVideo(_loc_4);
                }
            }
            else if (this._continuePlayProxy.isJSContinue && !param1)
            {
                _loc_5 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                _loc_5.callJsPlayNextVideo();
            }
            return;
        }// end function

        private function onRequestPreVideo(param1:Boolean) : void
        {
            var _loc_2:PlayerProxy = null;
            var _loc_3:LoadMovieParams = null;
            var _loc_4:ContinueInfo = null;
            var _loc_5:JavascriptAPIProxy = null;
            if (this._continuePlayProxy.isContinue && this._continuePlayProxy.continueInfoCount > 0)
            {
                _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                _loc_3 = _loc_2.curActor.loadMovieParams;
                _loc_4 = this._continuePlayProxy.findPreContinueInfo(_loc_3.tvid, _loc_3.vid);
                if (_loc_4)
                {
                    this._log.info("ContinuePlayViewMediator >> onRequestPreVideo,tvid:" + _loc_4.loadMovieParams.tvid + ", vid:" + _loc_4.loadMovieParams.vid);
                    sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID, _loc_4.cupId);
                    this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_PRE_NEXT_BTN;
                    _loc_2.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO ? (PingBackDef.VVPING_AUTO_PLAY) : (PingBackDef.VVPING_USER_CLICK);
                    _loc_2.curActor.vfrm = _loc_4.vfrm;
                    this.onSwitchVideo(_loc_4);
                }
            }
            else if (this._continuePlayProxy.isJSContinue && !param1)
            {
                _loc_5 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                _loc_5.callJsPlayPreVideo();
            }
            return;
        }// end function

        private function onListItemClick(event:ContinuePlayEvent) : void
        {
            var _loc_4:JavascriptAPIProxy = null;
            var _loc_2:* = event.data as ContinueInfo;
            var _loc_3:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.loadMovieParams.tvid != _loc_3.curActor.loadMovieParams.tvid && _loc_2.loadMovieParams.vid != _loc_3.curActor.loadMovieParams.vid)
            {
                this._log.info("ContinuePlayViewMediator >> onListItemClick,tvid:" + _loc_2.loadMovieParams.tvid + ", vid:" + _loc_2.loadMovieParams.vid);
                sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID, _loc_2.cupId);
                this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_FLASH_LIST;
                _loc_3.curActor.pbVVFromtp = this._continuePlayProxy.switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO ? (PingBackDef.VVPING_AUTO_PLAY) : (PingBackDef.VVPING_USER_CLICK);
                _loc_3.curActor.vfrm = _loc_2.vfrm;
                _loc_4 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                _loc_4.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
                this.onSwitchVideo(_loc_2);
            }
            return;
        }// end function

        private function onArrowClick(event:ContinuePlayEvent) : void
        {
            this._log.info("=====================================>onArrowClick isBefore = " + Boolean(event.data));
            this.addVideoList(Boolean(event.data), true);
            return;
        }// end function

        private function onPageTriggerRequest(event:ContinuePlayEvent) : void
        {
            var _loc_2:* = Boolean(event.data);
            if (_loc_2)
            {
                if (!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING))
                {
                    this.addVideoList(true);
                    this._log.info("=====================================>onPageTriggerRequest isBefore true");
                }
            }
            else if (!this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING))
            {
                this.addVideoList(false);
                this._log.info("=====================================>onPageTriggerRequest isBefore false");
            }
            return;
        }// end function

        private function addVideoList(param1:Boolean, param2:Boolean = false) : void
        {
            var _loc_3:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_3.callJsRequestVideoList(param1);
            if (param1)
            {
                if (param2)
                {
                    this._continuePlayView.isShowLeftTip = true;
                }
                this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
            }
            else
            {
                if (param2)
                {
                    this._continuePlayView.isShowRightTip = true;
                }
                this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
            }
            return;
        }// end function

        private function onSwitchOverPage(event:ContinuePlayEvent) : void
        {
            TweenLite.killTweensOf(this.delayedCloseDock);
            var _loc_2:* = event.data as Boolean;
            if (_loc_2)
            {
                this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
                this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
            }
            else
            {
                this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
                this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
            }
            return;
        }// end function

        private function onSwitchOverPageDone(event:ContinuePlayEvent) : void
        {
            this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW);
            this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW);
            return;
        }// end function

        private function onSwitchVideo(param1:ContinueInfo) : void
        {
            var _loc_2:PlayerProxy = null;
            if (param1 && this._continuePlayProxy.continueInfoCount > 0)
            {
                ProcessesTimeRecord.needRecord = false;
                _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                if (_loc_2.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
                {
                    if (_loc_2.preActor.loadMovieParams.tvid == param1.loadMovieParams.tvid && _loc_2.preActor.loadMovieParams.vid == param1.loadMovieParams.vid)
                    {
                        this._log.info("ContinuePlayViewMediator >> onSwitchVideo:switchPreActor!");
                        _loc_2.switchPreActor();
                    }
                    else
                    {
                        sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_STOP);
                        this._log.info("ContinuePlayViewMediator >> onSwitchVideo:send load movie tvid:" + param1.loadMovieParams.tvid + ", vid:" + param1.loadMovieParams.vid);
                        sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE, param1.loadMovieParams, BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
                    }
                }
                else
                {
                    this._log.info("ContinuePlayViewMediator >> onSwitchVideo:send load movie tvid:" + param1.loadMovieParams.tvid + ", vid:" + param1.loadMovieParams.vid);
                    sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE, param1.loadMovieParams, BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
                }
            }
            return;
        }// end function

        private function onJSCallLoadQiyiVideo(param1:Object) : void
        {
            var _loc_2:LoadMovieParams = null;
            if (this._continuePlayProxy.continueInfoCount == 0)
            {
                _loc_2 = new LoadMovieParams();
                _loc_2.albumId = param1.albumId;
                _loc_2.tvid = param1.tvId;
                _loc_2.vid = param1.vid;
                _loc_2.movieIsMember = param1.isMember == "true";
                this._log.info("ContinuePlayViewMediator >> onJSCallLoadQiyiVideo:send load movie tvid:" + _loc_2.tvid + ", vid:" + _loc_2.vid);
                PingBack.getInstance().continuityPlayPing();
                sendNotification(ADDef.NOTIFIC_REQUEST_CHANGED_CUP_ID, param1.cid);
                this._continuePlayProxy.switchVideoType = ContinuePlayDef.SWITCH_VIDEO_TYPE_NONE;
                sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE, _loc_2, BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
            }
            return;
        }// end function

        private function onPlayerRunning(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:PlayerProxy = null;
            var _loc_5:IMovieModel = null;
            var _loc_6:int = 0;
            var _loc_7:LoadMovieParams = null;
            var _loc_8:ContinueInfo = null;
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE && this._continuePlayProxy.isContinue && this._continuePlayProxy.continueInfoCount > 0)
            {
                _loc_4 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                if (_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE) && !_loc_4.preActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
                {
                    _loc_5 = _loc_4.curActor.movieModel;
                    _loc_6 = 0;
                    if (Settings.instance.skipTrailer && _loc_5.trailerTime > 0)
                    {
                        _loc_6 = _loc_5.trailerTime;
                    }
                    else
                    {
                        _loc_6 = _loc_5.duration;
                    }
                    if (_loc_6 - param1 < ContinuePlayDef.PRE_LOAD_TIME)
                    {
                        _loc_7 = _loc_4.curActor.loadMovieParams;
                        _loc_8 = this._continuePlayProxy.findNextContinueInfo(_loc_7.tvid, _loc_7.vid);
                        if (_loc_8)
                        {
                            this._log.info("start pre load,tvid:" + _loc_8.loadMovieParams.tvid + ", vid:" + _loc_8.loadMovieParams.vid);
                            sendNotification(BodyDef.NOTIFIC_PLAYER_PRE_LOAD_MOVIE, _loc_8.loadMovieParams, BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
                        }
                    }
                }
            }
            return;
        }// end function

        private function onMouseMove(event:MouseEvent) : void
        {
            this.onOpenDelayedCloseDock();
            return;
        }// end function

        private function onOpenDelayedCloseDock() : void
        {
            TweenLite.killTweensOf(this.delayedCloseDock);
            TweenLite.delayedCall(ContinuePlayDef.AUTO_HIND_DELAY / 1000, this.delayedCloseDock);
            return;
        }// end function

        private function delayedCloseDock() : void
        {
            this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
            return;
        }// end function

        private function onInfoListChanged(param1:Object) : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:int = 0;
            if (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_OPEN))
            {
                _loc_2 = Boolean(param1.add);
                if (this._continuePlayProxy.continueInfoCount > 0)
                {
                    if (_loc_2)
                    {
                        _loc_3 = int(param1.addCount);
                        if (_loc_3 > 0)
                        {
                            if (this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_ASK_PRE_PAGE_SHOW) && this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS) || this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_ASK_NEXT_PAGE_SHOW) && this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS))
                            {
                                this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(), false, this._continuePlayProxy.hasPreNeedLoad, this._continuePlayProxy.hasNextNeedLoad);
                                this._continuePlayView.switchPageInfo();
                                this._continuePlayView.updateOpenView();
                            }
                            else
                            {
                                this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(), false, this._continuePlayProxy.hasPreNeedLoad, this._continuePlayProxy.hasNextNeedLoad);
                                this._continuePlayView.updateCurrentPageIndex();
                                this._continuePlayView.updateArrowBtn();
                            }
                        }
                        else
                        {
                            this._continuePlayView.updateArrowBtn();
                        }
                    }
                    else
                    {
                        this._continuePlayView.updateOpenParam(this._continuePlayProxy.cloneContinueInfoList(), true, this._continuePlayProxy.hasPreNeedLoad, this._continuePlayProxy.hasNextNeedLoad);
                        this._continuePlayView.updateOpenView();
                    }
                }
                else
                {
                    this._continuePlayProxy.removeStatus(ContinuePlayDef.STATUS_OPEN);
                }
            }
            return;
        }// end function

        private function requestVideoList(param1:String, param2:String) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:JavascriptAPIProxy = null;
            var _loc_3:* = this._continuePlayProxy.findContinueInfo(param1, param2);
            if (_loc_3)
            {
                _loc_4 = _loc_3.index;
                _loc_5 = _loc_4;
                _loc_6 = this._continuePlayProxy.continueInfoCount - _loc_4 - 1;
                _loc_7 = null;
                if (this._continuePlayProxy.hasPreNeedLoad && _loc_5 < ContinuePlayDef.REMAIN_NUM_TO_REQUEST && !this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING))
                {
                    _loc_7 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    _loc_7.callJsRequestVideoList(true);
                    this._continuePlayView.isShowLeftTip = false;
                    this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
                }
                if (this._continuePlayProxy.hasNextNeedLoad && _loc_6 < ContinuePlayDef.REMAIN_NUM_TO_REQUEST && !this._continuePlayProxy.hasStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING))
                {
                    _loc_7 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    _loc_7.callJsRequestVideoList(false);
                    this._continuePlayView.isShowRightTip = false;
                    this._continuePlayProxy.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
                }
            }
            return;
        }// end function

    }
}
