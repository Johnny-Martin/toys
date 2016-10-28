package com.qiyi.player.wonder.plugins.recommend.view
{
    import com.adobe.serialization.json.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import com.qiyi.player.wonder.plugins.recommend.model.*;
    import flash.events.*;
    import flash.net.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class RecommendViewMediator extends Mediator
    {
        private var _recommendProxy:RecommendProxy;
        private var _recommendView:RecommendView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.recommend.view.RecommendViewMediator";

        public function RecommendViewMediator(param1:RecommendView)
        {
            super(NAME, param1);
            this._recommendView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._recommendProxy = facade.retrieveProxy(RecommendProxy.NAME) as RecommendProxy;
            this._recommendView.addEventListener(RecommendEvent.Evt_Finish_Open, this.onRecommendViewOpen);
            this._recommendView.addEventListener(RecommendEvent.Evt_Finish_Close, this.onRecommendViewClose);
            this._recommendView.addEventListener(RecommendEvent.Evt_ReplayVideo, this.onRecommendReplayVideo);
            this._recommendView.addEventListener(RecommendEvent.Evt_OpenVideo, this.onRecommendOpenVideo);
            this._recommendView.addEventListener(RecommendEvent.Evt_CustomizeItemClick, this.onCustomizeItemClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [RecommendDef.NOTIFIC_ADD_STATUS, RecommendDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_PLAYER_REPLAYED];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case RecommendDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == RecommendDef.STATUS_FINISH_RECOMMEND_OPEN)
                    {
                        this.createRecommend();
                    }
                    this._recommendView.onAddStatus(int(_loc_2));
                    break;
                }
                case RecommendDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._recommendView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._recommendView.onResize(_loc_2.w, _loc_2.h);
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
                    this._recommendProxy.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REPLAYED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this._recommendProxy.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
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

        private function onRecommendViewOpen(event:RecommendEvent) : void
        {
            if (!this._recommendProxy.hasStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN))
            {
                this._recommendProxy.addStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
            }
            return;
        }// end function

        private function onRecommendViewClose(event:RecommendEvent) : void
        {
            if (this._recommendProxy.hasStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN))
            {
                this._recommendProxy.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
            }
            return;
        }// end function

        private function onRecommendReplayVideo(event:RecommendEvent) : void
        {
            sendNotification(ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO);
            PingBack.getInstance().userActionPing(PingBackDef.REPLAY);
            return;
        }// end function

        private function onRecommendOpenVideo(event:RecommendEvent) : void
        {
            var _loc_2:* = event.data as RecommendVO;
            GlobalStage.setNormalScreen();
            PingBack.getInstance().recommendSelectionPing(_loc_2.playUrl, String(_loc_2.seatID));
            PingBack.getInstance().recommendClick4QiyuPing(_loc_2.albumID, this._recommendProxy.getEventID(this._recommendProxy.playFinishJson), this._recommendProxy.getBkt(this._recommendProxy.playFinishJson), this._recommendProxy.getArea(this._recommendProxy.playFinishJson), _loc_2.seatID.toString(), _loc_2.playUrl, _loc_2.channel);
            navigateToURL(new URLRequest(_loc_2.playUrl), "_self");
            return;
        }// end function

        private function onCustomizeItemClick(event:RecommendEvent) : void
        {
            if (GlobalStage.isFullScreen())
            {
                GlobalStage.setNormalScreen();
            }
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                if (_loc_2.curActor.movieInfo.channel == ChannelEnum.FINANCE)
                {
                    navigateToURL(new URLRequest(SystemConfig.RECOMMEND_CUSTOMIZE_FINANCE_URL), "_blank");
                }
                else if (_loc_2.curActor.movieInfo.channel == ChannelEnum.ENTERTAINMENT)
                {
                    navigateToURL(new URLRequest(SystemConfig.RECOMMEND_CUSTOMIZE_ENTERTAINMENT_URL), "_blank");
                }
                else
                {
                    navigateToURL(new URLRequest(SystemConfig.RECOMMEND_CUSTOMIZE_NEWS_URL), "_blank");
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
            this._recommendView.onUserInfoChanged(_loc_2);
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
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    if (param2)
                    {
                        this._recommendProxy.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
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

        private function createRecommend() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_3:* = _loc_1.curActor.movieModel;
            var _loc_4:* = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
            var _loc_5:* = SystemConfig.RECOMMEND_URL + "area=" + SystemConfig.RECOMMEND_PPC_AREA + "&referenceId=" + _loc_3.tvid + "&channelId=" + (_loc_2.taid != "" ? (int(_loc_2.tcid)) : (_loc_3.channelID)) + "&albumId=" + (_loc_2.tcid != "" ? (_loc_2.taid) : (_loc_3.albumId)) + "&page=1" + "&type=video" + "&withRefer=true" + "&profileId=" + _loc_4 + "&play_platform=PC_IQIYI" + "&size=27";
            if (LocalizaEnum.isComplexFontLocalize(FlashVarConfig.localize))
            {
                _loc_5 = _loc_5 + "&locale=zh_tw";
            }
            var _loc_6:* = new URLLoader();
            _loc_6.addEventListener(Event.COMPLETE, this.onUrlLoaderComplete);
            _loc_6.addEventListener(IOErrorEvent.IO_ERROR, this.onUrlLoaderError);
            _loc_6.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUrlLoaderError);
            _loc_6.load(new URLRequest(_loc_5));
            return;
        }// end function

        private function onUrlLoaderComplete(event:Event) : void
        {
            var _loc_3:PlayerProxy = null;
            var _loc_2:* = event.target as URLLoader;
            try
            {
                this._recommendProxy.playFinishJson = JSON.decode(_loc_2.data);
                _loc_3 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                this._recommendView.recommendData(this._recommendProxy.playFinishDataVector, _loc_3.curActor.movieInfo.channel.id);
                PingBack.getInstance().recommendLoadDoneSend(this._recommendProxy.getRecommendIDString(this._recommendProxy.playFinishDataVector), this._recommendProxy.getEventID(this._recommendProxy.playFinishJson), this._recommendProxy.getBkt(this._recommendProxy.playFinishJson), this._recommendProxy.getArea(this._recommendProxy.playFinishJson));
            }
            catch (e:Error)
            {
            }
            _loc_2.removeEventListener(Event.COMPLETE, this.onUrlLoaderComplete);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onUrlLoaderError);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUrlLoaderError);
            _loc_2 = null;
            return;
        }// end function

        private function onUrlLoaderError(event:Event) : void
        {
            var _loc_2:* = event.target as URLLoader;
            _loc_2.removeEventListener(Event.COMPLETE, this.onUrlLoaderComplete);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onUrlLoaderError);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUrlLoaderError);
            _loc_2 = null;
            return;
        }// end function

    }
}
