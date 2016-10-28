package com.qiyi.player.wonder.plugins.videolink.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.core.model.def.*;
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
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.videolink.*;
    import com.qiyi.player.wonder.plugins.videolink.model.*;
    import flash.net.*;
    import flash.system.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class VideoLinkViewMediator extends Mediator
    {
        private var _videoLinkProxy:VideoLinkProxy;
        private var _videoLinkView:VideoLinkView;
        private var _noticeID:String = "";
        public static const NAME:String = "com.qiyi.player.wonder.plugins.videolink.view.VideoLinkViewMediator";

        public function VideoLinkViewMediator(param1:VideoLinkView)
        {
            super(NAME, param1);
            this._videoLinkView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._videoLinkProxy = facade.retrieveProxy(VideoLinkProxy.NAME) as VideoLinkProxy;
            this._videoLinkView.addEventListener(VideoLinkEvent.Evt_Open, this.onVideoLinkViewOpen);
            this._videoLinkView.addEventListener(VideoLinkEvent.Evt_Close, this.onVideoLinkViewClose);
            this._videoLinkView.addEventListener(VideoLinkEvent.Evt_BtnAndIconClick, this.onWatchVideoLinkBtnClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [ADDef.NOTIFIC_ADD_STATUS, VideoLinkDef.NOTIFIC_ADD_STATUS, VideoLinkDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_PLAYER_RUNNING, BodyDef.NOTIFIC_PLAYER_STUCK, BodyDef.NOTIFIC_PLAYER_REPLAYED, BodyDef.NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, ContinuePlayDef.NOTIFIC_ADD_STATUS, ContinuePlayDef.NOTIFIC_REMOVE_STATUS, ControllBarDef.NOTIFIC_ADD_STATUS, ControllBarDef.NOTIFIC_REMOVE_STATUS, SceneTileDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:PlayerProxy = null;
            var _loc_6:VideoLinkInfo = null;
            var _loc_7:ADProxy = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case VideoLinkDef.NOTIFIC_ADD_STATUS:
                {
                    this._videoLinkView.onAddStatus(int(_loc_2));
                    break;
                }
                case VideoLinkDef.NOTIFIC_REMOVE_STATUS:
                {
                    _loc_5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    _loc_6 = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(_loc_5.curActor.currentTime / 1000));
                    if (_loc_6 == null && int(_loc_2) == VideoLinkDef.STATUS_OPEN)
                    {
                        this._videoLinkProxy.resetIsShow();
                    }
                    this._videoLinkView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._videoLinkView.onResize(_loc_2.w, _loc_2.h);
                    if (!GlobalStage.isFullScreen() && this._videoLinkView.panelType == VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE)
                    {
                        this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
                    }
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
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this.onPlayerSwitchPreActor();
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REPLAYED:
                {
                    this._videoLinkView.isShowClientDownloadPanel = false;
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    this.onPlayerRunning(_loc_2.currentTime, _loc_2.bufferTime, _loc_2.duration, _loc_2.playingDuration);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_STUCK:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.onPlayerStuck();
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO:
                {
                    this.onReceiveActivityNotice(_loc_2);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
                {
                    if (Boolean(_loc_2))
                    {
                        this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ContinuePlayDef.STATUS_OPEN)
                    {
                        this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
                {
                    break;
                }
                case ControllBarDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW)
                    {
                        this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
                    }
                    break;
                }
                case ControllBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    break;
                }
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    _loc_7 = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
                    if (_loc_7.hasStatus(ADDef.STATUS_LOADING) || _loc_7.hasStatus(ADDef.STATUS_PLAYING) || _loc_7.hasStatus(ADDef.STATUS_PAUSED))
                    {
                        this._videoLinkView.visible = false;
                    }
                    break;
                }
                case SceneTileDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == SceneTileDef.STATUS_SCORE_OPEN)
                    {
                        this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
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

        private function onVideoLinkViewOpen(event:VideoLinkEvent) : void
        {
            if (!this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN))
            {
                this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onVideoLinkViewClose(event:VideoLinkEvent) : void
        {
            if (this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN))
            {
                this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2)
                    {
                        this._videoLinkView.isShowClientDownloadPanel = false;
                        TweenLite.killTweensOf(this.onWaitingTimeOut);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                {
                    if (param2)
                    {
                        this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    if (param2)
                    {
                        this.getVideoLinkInfo();
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_WAITING:
                {
                    if (param2)
                    {
                        TweenLite.delayedCall(VideoLinkDef.WAITING_TIME / 1000, this.onWaitingTimeOut);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2)
                    {
                        TweenLite.killTweensOf(this.onWaitingTimeOut);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    if (param2)
                    {
                        TweenLite.killTweensOf(this.onWaitingTimeOut);
                        this._videoLinkView.visible = true;
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        TweenLite.killTweensOf(this.onWaitingTimeOut);
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
            this.getVideoLinkInfo();
            this._videoLinkView.isShowClientDownloadPanel = false;
            return;
        }// end function

        private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:VideoLinkInfo = null;
            var _loc_6:PlayerProxy = null;
            if (!LocalizaEnum.isTWLocalize(FlashVarConfig.localize) && this._videoLinkProxy.isHasLink && !SwitchManager.getInstance().getStatus(SwitchDef.ID_HIDE_VIDEO_LINK))
            {
                _loc_5 = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(param1 / 1000));
                if (_loc_5)
                {
                    _loc_6 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (!_loc_5.isShow && !_loc_6.curActor.smallWindowMode)
                    {
                        this._videoLinkProxy.resetIsShow();
                        _loc_5.isShow = true;
                        this._videoLinkView.initVideoLinkPanel(VideoLinkDef.PANEL_TYPE_VIDEOLINK, _loc_5);
                        PingBack.getInstance().videoLinkShowPing();
                        this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
                    }
                }
                else
                {
                    this._videoLinkProxy.resetIsShow();
                    if (this._videoLinkView.panelType == VideoLinkDef.PANEL_TYPE_VIDEOLINK)
                    {
                        this._videoLinkProxy.removeStatus(VideoLinkDef.STATUS_OPEN);
                    }
                }
            }
            return;
        }// end function

        private function onPlayerStuck() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (!LocalizaEnum.isTWLocalize(FlashVarConfig.localize) && this._videoLinkProxy.lagDownClient(VideoLinkDef.LAG_TIME_SWAP_PRO_ACCELERATE) && !_loc_1.curActor.smallWindowMode && !this._videoLinkView.isShowClientDownloadPanel)
            {
                PingBack.getInstance().playerActionPing(PingBackDef.SHOW_DOWNLOAD_ACC_TIPS);
                this._videoLinkView.initClientDownloadPanel(VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT);
                this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onWaitingTimeOut() : void
        {
            TweenLite.killTweensOf(this.onWaitingTimeOut);
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (!LocalizaEnum.isTWLocalize(FlashVarConfig.localize) && !this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !_loc_1.curActor.smallWindowMode && !this._videoLinkView.isShowClientDownloadPanel && (!_loc_2.hasStatus(ADDef.STATUS_PLAYING) && !_loc_2.hasStatus(ADDef.STATUS_PAUSED) && !_loc_2.hasStatus(ADDef.STATUS_LOADING)))
            {
                PingBack.getInstance().playerActionPing(PingBackDef.SHOW_DOWNLOAD_ACC_TIPS);
                this._videoLinkView.initClientDownloadPanel(VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT);
                this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onReceiveActivityNotice(param1:Object) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (!LocalizaEnum.isTWLocalize(FlashVarConfig.localize) && !this._videoLinkProxy.hasStatus(VideoLinkDef.STATUS_OPEN) && GlobalStage.isFullScreen() && _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !_loc_2.curActor.smallWindowMode && (!_loc_3.hasStatus(ADDef.STATUS_PLAYING) && !_loc_3.hasStatus(ADDef.STATUS_PAUSED) && !_loc_3.hasStatus(ADDef.STATUS_LOADING)) && param1.activityContent && param1.linkUrl)
            {
                this._noticeID = param1.noticeid;
                PingBack.getInstance().noticeShowActionPing_4_0(PingBackDef.ACTIVITY_NOTICE_PANEL_SHOW, this._noticeID);
                this._videoLinkView.initActivityNoticePanel(VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE, param1.activityContent, param1.linkUrl);
                this._videoLinkProxy.addStatus(VideoLinkDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function getVideoLinkInfo() : void
        {
            var _loc_3:Object = null;
            var _loc_4:VideoLinkInfo = null;
            var _loc_5:Object = null;
            TweenLite.killTweensOf(this.onWaitingTimeOut);
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = new Vector.<VideoLinkInfo>;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                _loc_3 = _loc_1.curActor.movieInfo.infoJSON;
                if (_loc_3.tpl != undefined)
                {
                    for each (_loc_5 in _loc_3.tpl as Array)
                    {
                        
                        if (_loc_5.tp != undefined && _loc_5.tp == 2)
                        {
                            _loc_4 = new VideoLinkInfo(_loc_5);
                            _loc_2.push(_loc_4);
                        }
                    }
                }
            }
            this._videoLinkProxy.addVideoLinkInfo(_loc_2);
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
            this._videoLinkView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function onWatchVideoLinkBtnClick(event:VideoLinkEvent) : void
        {
            var _loc_2:PlayerProxy = null;
            var _loc_3:VideoLinkInfo = null;
            var _loc_4:String = null;
            switch(this._videoLinkView.panelType)
            {
                case VideoLinkDef.PANEL_TYPE_VIDEOLINK:
                {
                    _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    _loc_3 = this._videoLinkProxy.getVideoLinkInfoByCurrentTime(int(_loc_2.curActor.currentTime / 1000));
                    if (_loc_3)
                    {
                        GlobalStage.setNormalScreen();
                        sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
                        PingBack.getInstance().videoLinkUserClickPing();
                        navigateToURL(new URLRequest(_loc_3.titleUrl), "_blank");
                    }
                    break;
                }
                case VideoLinkDef.PANEL_TYPE_DOWNLOADCLIENT:
                {
                    GlobalStage.setNormalScreen();
                    PingBack.getInstance().userActionPing(PingBackDef.CLICK_DOWNLOAD_ACC_TIPS);
                    _loc_4 = "";
                    if (Capabilities.version.indexOf("WIN") == 0)
                    {
                        _loc_4 = SystemConfig.CLIENT_DOWNLOAD_URL + "?id=&pubplatform=" + 1 + "&pubarea=pcltdown_5061621" + "&srcchannel=&qipuid=&useragent=&u=&pu=" + "&rn=" + Math.random();
                        navigateToURL(new URLRequest(_loc_4), "_blank");
                    }
                    else
                    {
                        _loc_4 = SystemConfig.CLIENT_DOWNLOAD_URL + "?id=&pubplatform=" + 6 + "&pubarea=pcltdown_5061621" + "&srcchannel=&qipuid=&useragent=&u=&pu=" + "&rn=" + Math.random();
                        navigateToURL(new URLRequest(_loc_4), "_blank");
                    }
                    break;
                }
                case VideoLinkDef.PANEL_TYPE_ACTIVITYNOTICE:
                {
                    GlobalStage.setNormalScreen();
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
                    PingBack.getInstance().noticeUserActionPing_4_0(PingBackDef.ACTIVITY_NOTICE_PANEL_CLICK, this._noticeID);
                    if (this._videoLinkView.activityNoticeLink != "")
                    {
                        navigateToURL(new URLRequest(this._videoLinkView.activityNoticeLink), "_blank");
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

        private function checkIsShowVideoLink(param1:VideoLinkInfo) : Boolean
        {
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_3:* = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            if (param1 && !param1.isShow && !_loc_2.hasStatus(ContinuePlayDef.STATUS_OPEN) && !_loc_3.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW))
            {
                return true;
            }
            return false;
        }// end function

    }
}
