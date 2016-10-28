package com.qiyi.player.wonder.plugins.setting.view
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class FilterViewMediator extends Mediator
    {
        private var _settingProxy:SettingProxy;
        private var _filterView:FilterView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.FilterViewMediator";

        public function FilterViewMediator(param1:FilterView)
        {
            super(NAME, param1);
            this._filterView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._settingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            this._filterView.addEventListener(SettingEvent.Evt_FilterOpen, this.onFilterViewOpen);
            this._filterView.addEventListener(SettingEvent.Evt_FilterClose, this.onFilterViewClose);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [SettingDef.NOTIFIC_ADD_STATUS, SettingDef.NOTIFIC_REMOVE_STATUS, SettingDef.NOTIFIC_FILTER_SHOW_BMD, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_PLAYER_RUNNING];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_6:ControllBarProxy = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            var _loc_5:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            switch(_loc_3)
            {
                case SettingDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == SettingDef.STATUS_FILTER_SHOW_BMD)
                    {
                        sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
                    }
                    this._filterView.onAddStatus(int(_loc_2));
                    break;
                }
                case SettingDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._filterView.onRemoveStatus(int(_loc_2));
                    if (int(_loc_2) == SettingDef.STATUS_FILTER_OPEN)
                    {
                        sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
                        this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_SHOW_BMD);
                        this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_SHOW_UI);
                    }
                    break;
                }
                case SettingDef.NOTIFIC_FILTER_SHOW_BMD:
                {
                    _loc_6 = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
                    if (_loc_2 == true)
                    {
                        this._filterView.showBmd(_loc_6.filterBitmapData.getFilterbmd(_loc_6.filterBitmapData.showBmdIndex));
                        if (!this._settingProxy.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
                        {
                            this._settingProxy.addStatus(SettingDef.STATUS_FILTER_SHOW_BMD);
                            sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
                        }
                    }
                    else if (this._settingProxy.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
                    {
                        this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_SHOW_BMD);
                        sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._filterView.onResize(_loc_2.w, _loc_2.h);
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
                    this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
                    break;
                }
                case BodyDef.NOTIFIC_FULL_SCREEN:
                {
                    this._filterView.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    this._filterView.videoSize(_loc_5.curActor.realArea.width, _loc_5.curActor.realArea.height);
                    break;
                }
                default:
                {
                    break;
                }
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
                case BodyDef.PLAYER_STATUS_STOPPING:
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
                        this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_SHOW_BMD);
                        this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
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

        private function onFilterViewOpen(event:SettingEvent) : void
        {
            if (!this._settingProxy.hasStatus(SettingDef.STATUS_FILTER_OPEN))
            {
                this._settingProxy.addStatus(SettingDef.STATUS_FILTER_OPEN);
            }
            return;
        }// end function

        private function onFilterViewClose(event:SettingEvent) : void
        {
            if (this._settingProxy.hasStatus(SettingDef.STATUS_FILTER_OPEN))
            {
                this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_SHOW_UI);
                this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
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
            this._filterView.onUserInfoChanged(_loc_2);
            return;
        }// end function

    }
}
