package com.qiyi.player.wonder.plugins.feedback.view
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.lso.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.feedback.model.*;
    import flash.net.*;
    import flash.system.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class FeedbackViewMediator extends Mediator
    {
        private var _feedbackProxy:FeedbackProxy;
        private var _feedbackView:FeedbackView;
        private var _log:ILogger;
        private var _privateVideoTvid:String = "";
        public static const NAME:String = "com.qiyi.player.wonder.plugins.feedback.view.FeedbackViewMediator";

        public function FeedbackViewMediator(param1:FeedbackView)
        {
            this._log = Log.getLogger(NAME);
            super(NAME, param1);
            this._feedbackView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._feedbackProxy = facade.retrieveProxy(FeedbackProxy.NAME) as FeedbackProxy;
            this._feedbackView.addEventListener(FeedbackEvent.Evt_Open, this.onFeedbackViewOpen);
            this._feedbackView.addEventListener(FeedbackEvent.Evt_Close, this.onFeedbackViewClose);
            this._feedbackView.addEventListener(FeedbackEvent.Evt_Refresh, this.onFeedbackRefresh);
            this._feedbackView.addEventListener(FeedbackEvent.Evt_DownloadBtnClick, this.onDownClientBtnClick);
            this._feedbackView.addEventListener(FeedbackEvent.Evt_PrivateNestVideo, this.onNestVideoLink);
            this._feedbackView.addEventListener(FeedbackEvent.Evt_PrivateConfirmBtnClick, this.onConfirmBtnClick);
            this._feedbackView.addEventListener(FeedbackEvent.Evt_SkipMemberAuthBtnClick, this.onSkipMemberAuthBtnClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [FeedbackDef.NOTIFIC_ADD_STATUS, FeedbackDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_CHECK_USER_COMPLETE];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:PlayerProxy = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case FeedbackDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == FeedbackDef.STATUS_OPEN)
                    {
                        this.initFeedbackView();
                    }
                    this._feedbackView.onAddStatus(int(_loc_2));
                    break;
                }
                case FeedbackDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._feedbackView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._feedbackView.onResize(_loc_2.w, _loc_2.h);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
                {
                    this.onPlayerStatusChanged(int(_loc_2), true, _loc_4);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    _loc_5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (!_loc_5.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
                    {
                        this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
                {
                    this.onCheckUserComplete();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onFeedbackViewOpen(event:FeedbackEvent) : void
        {
            if (!this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
            {
                this._feedbackProxy.addStatus(FeedbackDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onFeedbackViewClose(event:FeedbackEvent) : void
        {
            if (this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
            {
                this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            var _loc_4:PlayerProxy = null;
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
                        this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    if (param2)
                    {
                        this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    if (param2)
                    {
                        _loc_4 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                        if (_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED) && this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
                        {
                            this._feedbackView.videoName = _loc_4.curActor.movieInfo.title;
                        }
                    }
                }
                default:
                {
                    break;
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
            this._feedbackView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function initFeedbackView() : void
        {
            var _loc_8:Boolean = false;
            var _loc_9:String = null;
            var _loc_10:String = null;
            var _loc_11:String = null;
            var _loc_12:String = null;
            var _loc_13:String = null;
            var _loc_14:String = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_3:* = _loc_1.curActor.movieModel && _loc_1.curActor.movieInfo ? (_loc_1.curActor.movieModel.vid) : ("");
            var _loc_4:* = _loc_1.curActor.movieModel && _loc_1.curActor.movieInfo ? (_loc_1.curActor.movieInfo.title) : ("");
            var _loc_5:* = LogManager.getLifeLogs().length <= 0 ? ("log file is empty") : (LogManager.getLifeLogs().join("<br />"));
            var _loc_6:* = _loc_1.curActor.movieModel && _loc_1.curActor.movieInfo ? (_loc_1.curActor.movieModel.channelID.toString()) : ("");
            FeedbackInfo.instance.updataVideoInfo("fault", _loc_3, _loc_4, Settings.instance.volumn, _loc_5, WonderVersion.VERSION_WONDER, _loc_6);
            var _loc_7:* = UserManager.getInstance().user;
            if (_loc_7 && _loc_7.limitationType == UserDef.USER_LIMITATION_UPPER)
            {
                if (FlashVarConfig.isMemberMovie)
                {
                    PingBack.getInstance().showActionPing_4_0(PingBackDef.CONCUR_LIMIT_VIP_SHOW);
                }
                else
                {
                    PingBack.getInstance().showActionPing_4_0(PingBackDef.CONCUR_LIMIT_SHOW);
                }
                this._feedbackView.createConcurrencyLimit(FlashVarConfig.isMemberMovie, "Q00501");
            }
            else if (_loc_1.curActor.authenticationError && _loc_1.curActor.authenticationResult && _loc_1.curActor.authenticationResult.code == "Q00501")
            {
                PingBack.getInstance().showActionPing_4_0(PingBackDef.CONCUR_LIMIT_VIP_SHOW);
                this._feedbackView.createConcurrencyLimit(FlashVarConfig.isMemberMovie, _loc_1.curActor.authenticationResult.code);
            }
            else if (_loc_1.curActor.errorCode == 707 || FlashVarConfig.vid == "")
            {
                this._feedbackView.createMaliceErrorView(String(_loc_1.curActor.errorCode));
            }
            else if (_loc_1.curActor.errorCode == 5000)
            {
                this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_AREA, String(_loc_1.curActor.errorCode));
            }
            else if (_loc_1.curActor.errorCode == 708 || _loc_1.curActor.errorCode == 709)
            {
                _loc_8 = false;
                if (_loc_2.isContinue && _loc_1.curActor.loadMovieParams && _loc_2.findNextContinueInfo(_loc_1.curActor.loadMovieParams.tvid, _loc_1.curActor.loadMovieParams.vid))
                {
                    _loc_8 = true;
                }
                this._feedbackView.createPrivatevideo(_loc_1.curActor.errorCode, _loc_8, this._privateVideoTvid == _loc_1.curActor.loadMovieParams.tvid);
                this._privateVideoTvid = _loc_1.curActor.loadMovieParams.tvid;
            }
            else if (_loc_1.curActor.errorCode == 104 && _loc_1.curActor.errorCodeValue && _loc_1.curActor.errorCodeValue.st)
            {
                _loc_9 = "";
                if (_loc_1.curActor.errorCodeValue.hasOwnProperty("cid"))
                {
                    _loc_9 = _loc_9 + _loc_1.curActor.errorCodeValue.cid;
                }
                _loc_10 = "";
                if (_loc_1.curActor.errorCodeValue.hasOwnProperty("tvid"))
                {
                    _loc_10 = _loc_10 + _loc_1.curActor.errorCodeValue.tvid;
                }
                _loc_11 = "";
                if (_loc_1.curActor.errorCodeValue.hasOwnProperty("aid"))
                {
                    _loc_11 = _loc_11 + _loc_1.curActor.errorCodeValue.aid;
                }
                _loc_12 = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
                _loc_13 = SystemConfig.RECOMMEND_URL + "area=" + SystemConfig.COPY_RIGHT_AREA + "&referenceId=" + _loc_10 + "&channelId=" + _loc_9 + "&albumId=" + _loc_11 + "&page=1" + "&type=video" + "&withRefer=true" + "&profileId=" + _loc_12 + "&play_platform=PC_IQIYI" + "&size=20";
                if (LocalizaEnum.isComplexFontLocalize(FlashVarConfig.localize))
                {
                    _loc_13 = _loc_13 + "&locale=zh_tw";
                }
                _loc_14 = "";
                if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY) && _loc_1.curActor.movieInfo)
                {
                    _loc_14 = _loc_1.curActor.movieInfo.title;
                }
                if (int(_loc_1.curActor.errorCodeValue.st) == 405 || int(_loc_1.curActor.errorCodeValue.st) == 406 || int(_loc_1.curActor.errorCodeValue.st) == 401)
                {
                    this._feedbackView.createCopyrightExpiredView(_loc_13, _loc_1.curActor.errorCodeValue.st, true, _loc_14);
                }
                else if (int(_loc_1.curActor.errorCodeValue.st) == 304)
                {
                    this._feedbackView.createCopyrightExpiredView(_loc_13, _loc_1.curActor.errorCodeValue.st, false, _loc_14);
                }
                else if (_loc_1.curActor.errorCodeValue.st == 501)
                {
                    this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_PLATFORM, _loc_1.curActor.errorCodeValue.st);
                }
                else if (_loc_1.curActor.errorCodeValue.st == 502)
                {
                    this._feedbackView.createCopyrightLimitedView(FeedbackDef.FEEDBACK_LIMITED_AREA, _loc_1.curActor.errorCodeValue.st);
                }
                else if (_loc_1.curActor.errorCodeValue.st == 601 || _loc_1.curActor.errorCodeValue.st == 602 || _loc_1.curActor.errorCodeValue.st == 701)
                {
                    this._feedbackView.createDrmCopyrightLimitedView(_loc_1.curActor.errorCodeValue.st);
                }
                else
                {
                    this.createNetworkFaultView(_loc_1.curActor.errorCodeValue.st);
                }
            }
            else
            {
                this.createNetworkFaultView("A00001");
            }
            return;
        }// end function

        private function onFeedbackRefresh(event:FeedbackEvent) : void
        {
            if (this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
            {
                this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
            }
            sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
            return;
        }// end function

        private function onDownClientBtnClick(event:FeedbackEvent) : void
        {
            GlobalStage.setNormalScreen();
            PingBack.getInstance().userActionPing(PingBackDef.DOWNLOAD_CLIENT);
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = _loc_2.curActor.movieModel;
            if (_loc_3)
            {
                LSO.getInstance().setClientFlashInfo([{tvid:_loc_3.tvid, vid:_loc_3.vid, curtime:_loc_2.curActor.currentTime.toString(), albumid:_loc_3.albumId.toString(), definition:_loc_3.curDefinitionInfo.type.id.toString(), member:_loc_3.member.toString()}]);
            }
            var _loc_4:String = "";
            if (Capabilities.version.indexOf("WIN") == 0)
            {
                _loc_4 = SystemConfig.CLIENT_DOWNLOAD_URL + "?id=&pubplatform=" + 1 + "&pubarea=pcltdown_5061622" + "&srcchannel=&qipuid=&useragent=&u=&pu=" + "&rn=" + Math.random();
                navigateToURL(new URLRequest(_loc_4), "_blank");
            }
            else
            {
                _loc_4 = SystemConfig.CLIENT_DOWNLOAD_URL + "?id=&pubplatform=" + 6 + "&pubarea=pcltdown_5061622" + "&srcchannel=&qipuid=&useragent=&u=&pu=" + "&rn=" + Math.random();
                navigateToURL(new URLRequest(_loc_4), "_blank");
            }
            return;
        }// end function

        private function onNestVideoLink(event:FeedbackEvent) : void
        {
            if (this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
            {
                this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
            }
            sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
            return;
        }// end function

        private function onConfirmBtnClick(event:FeedbackEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_2.curActor.ugcAuthKey = String(event.data);
            if (this._feedbackProxy.hasStatus(FeedbackDef.STATUS_OPEN))
            {
                this._feedbackProxy.removeStatus(FeedbackDef.STATUS_OPEN);
            }
            sendNotification(BodyDef.NOTIFIC_PLAYER_REFRESH);
            return;
        }// end function

        private function onSkipMemberAuthBtnClick(event:FeedbackEvent) : void
        {
            sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
            return;
        }// end function

        private function createNetworkFaultView(param1:String) : void
        {
            this._feedbackView.createNetWorkFaultView(param1);
            return;
        }// end function

    }
}
