package com.qiyi.player.wonder.plugins.offlinewatch.view
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class OfflineWatchViewMediator extends Mediator
    {
        private var _offlineWatchProxy:OfflineWatchProxy;
        private var _offlineWatchView:OfflineWatchView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.offlinewatch.view.OfflineWatchViewMediator";

        public function OfflineWatchViewMediator(param1:OfflineWatchView)
        {
            super(NAME, param1);
            this._offlineWatchView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._offlineWatchProxy = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
            this._offlineWatchView.addEventListener(OfflineWatchEvent.Evt_Open, this.onOfflineWatchViewOpen);
            this._offlineWatchView.addEventListener(OfflineWatchEvent.Evt_Close, this.onOfflineWatchViewClose);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [OfflineWatchDef.NOTIFIC_ADD_STATUS, OfflineWatchDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case OfflineWatchDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == OfflineWatchDef.STATUS_OPEN)
                    {
                        sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
                    }
                    this._offlineWatchView.onAddStatus(int(_loc_2));
                    break;
                }
                case OfflineWatchDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == OfflineWatchDef.STATUS_OPEN)
                    {
                        sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
                    }
                    this._offlineWatchView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._offlineWatchView.onResize(_loc_2.w, _loc_2.h);
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
                    this._offlineWatchProxy.removeStatus(OfflineWatchDef.STATUS_OPEN);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onOfflineWatchViewOpen(event:OfflineWatchEvent) : void
        {
            if (!this._offlineWatchProxy.hasStatus(OfflineWatchDef.STATUS_OPEN))
            {
                this._offlineWatchProxy.addStatus(OfflineWatchDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onOfflineWatchViewClose(event:OfflineWatchEvent) : void
        {
            if (this._offlineWatchProxy.hasStatus(OfflineWatchDef.STATUS_OPEN))
            {
                this._offlineWatchProxy.removeStatus(OfflineWatchDef.STATUS_OPEN);
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
                case BodyDef.PLAYER_STATUS_STOPED:
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        this._offlineWatchProxy.removeStatus(OfflineWatchDef.STATUS_OPEN);
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
            this._offlineWatchView.onUserInfoChanged(_loc_2);
            return;
        }// end function

    }
}
