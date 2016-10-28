package com.qiyi.player.wonder.plugins.share.view
{
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.share.*;
    import com.qiyi.player.wonder.plugins.share.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class ShareViewMediator extends Mediator
    {
        private var _shareProxy:ShareProxy;
        private var _shareView:ShareView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.share.view.ShareViewMediator";

        public function ShareViewMediator(param1:ShareView)
        {
            super(NAME, param1);
            this._shareView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._shareProxy = facade.retrieveProxy(ShareProxy.NAME) as ShareProxy;
            this._shareView.addEventListener(ShareEvent.Evt_Open, this.onShareViewOpen);
            this._shareView.addEventListener(ShareEvent.Evt_Close, this.onShareViewClose);
            this._shareView.addEventListener(ShareEvent.Evt_ShareBtnClick, this.onShareBtnClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [ShareDef.NOTIFIC_ADD_STATUS, ShareDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case ShareDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ShareDef.STATUS_OPEN)
                    {
                        this.addOpenParam();
                        sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
                    }
                    this._shareView.onAddStatus(int(_loc_2));
                    break;
                }
                case ShareDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == ShareDef.STATUS_OPEN)
                    {
                        sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
                    }
                    this._shareView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._shareView.onResize(_loc_2.w, _loc_2.h);
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
                    this._shareProxy.removeStatus(ShareDef.STATUS_OPEN);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onShareViewOpen(event:ShareEvent) : void
        {
            if (!this._shareProxy.hasStatus(ShareDef.STATUS_OPEN))
            {
                this._shareProxy.addStatus(ShareDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onShareViewClose(event:ShareEvent) : void
        {
            if (this._shareProxy.hasStatus(ShareDef.STATUS_OPEN))
            {
                this._shareProxy.removeStatus(ShareDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onShareBtnClick(event:ShareEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = _loc_2.curActor.movieModel;
            PingBack.getInstance().videoSharePing(event.data.toString(), 0, _loc_3.duration);
            sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
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
                case BodyDef.PLAYER_STATUS_STOPED:
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        this._shareProxy.removeStatus(ShareDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
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
            this._shareView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function addOpenParam() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = _loc_1.curActor.movieModel;
            var _loc_3:* = _loc_1.curActor.movieInfo;
            var _loc_4:Boolean = true;
            if (_loc_3.infoJSON && _loc_3.infoJSON.plc && _loc_3.infoJSON.plc[14] && _loc_3.infoJSON.plc[14].coa != 1)
            {
                _loc_4 = false;
            }
            this._shareView.updateOpenParam(_loc_1.curActor.getHtmlUrl(), _loc_1.curActor.getSwfUrl(), _loc_2.duration, Utility.getItemById(ChannelEnum.ITEMS, _loc_2.channelID), _loc_3.pageUrl, _loc_3.title, _loc_4);
            return;
        }// end function

    }
}
