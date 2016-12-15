package com.qiyi.player.wonder.plugins.setting.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import com.qiyi.player.wonder.plugins.tips.*;
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
            this._filterView.addEventListener(SettingEvent.Evt_FilterSexRadioClick, this.onFilterFilterSexRadioClick);
            this._filterView.addEventListener(SettingEvent.Evt_FilterConfirmBtnClick, this.onFilterConfirmBtnClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [SettingDef.NOTIFIC_ADD_STATUS, SettingDef.NOTIFIC_REMOVE_STATUS, SettingDef.NOTIFIC_FILTER_SKIP_MOVIECLIP, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_FULL_SCREEN];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case SettingDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == SettingDef.STATUS_FILTER_OPEN)
                    {
                        this.setCommonPanelAttribute();
                        sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
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
                    }
                    break;
                }
                case SettingDef.NOTIFIC_FILTER_SKIP_MOVIECLIP:
                {
                    this._filterView.playSkipMovieClip();
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
                this._settingProxy.removeStatus(SettingDef.STATUS_FILTER_OPEN);
            }
            return;
        }// end function

        private function onFilterConfirmBtnClick(event:SettingEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = _loc_2.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
            var _loc_4:* = _loc_2.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
            var _loc_5:* = event.data.curSex as EnumItem;
            var _loc_6:* = event.data.timeIndex;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && (_loc_5 != _loc_2.curActor.movieModel.curEnjoyableSubType || _loc_6 != _loc_2.curActor.movieModel.curEnjoyableSubDurationIndex))
            {
                _loc_2.curActor.setEnjoyableSubType(_loc_5, _loc_6);
                _loc_2.preActor.setEnjoyableSubType(_loc_5, _loc_6);
                switch(_loc_5)
                {
                    case SkipPointEnum.ENJOYABLE_SUB_MALE:
                    {
                        sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR, {attr:TipsDef.TIP_ATTR_NAME_FILTER_TYPE, value:_loc_3 || _loc_4 ? (TipsDef.CONSTANT_FILTER_MALE) : ("")});
                        break;
                    }
                    case SkipPointEnum.ENJOYABLE_SUB_FEMALE:
                    {
                        sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR, {attr:TipsDef.TIP_ATTR_NAME_FILTER_TYPE, value:_loc_3 || _loc_4 ? (TipsDef.CONSTANT_FILTER_FEMALE) : ("")});
                        break;
                    }
                    default:
                    {
                        sendNotification(TipsDef.NOTIFIC_UPDATE_TIP_ATTR, {attr:TipsDef.TIP_ATTR_NAME_FILTER_TYPE, value:_loc_3 || _loc_4 ? (TipsDef.CONSTANT_FILTER_COMMON) : ("")});
                        break;
                        break;
                    }
                }
                sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_FILTER_OPEN_TIP);
            }
            return;
        }// end function

        private function onFilterFilterSexRadioClick(event:SettingEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                this._filterView.setPanelTimeAttribute(_loc_2.curActor.movieModel.getEnjoyableSubDurationList(event.data as EnumItem));
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

        private function checkHavNestEnjoyableSkip() : Boolean
        {
            var _loc_2:uint = 0;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_1.curActor.movieModel.skipPointInfoCount)
                {
                    
                    if (_loc_1.curActor.movieModel.getSkipPointInfoAt(_loc_2).skipPointType == SkipPointEnum.ENJOYABLE)
                    {
                        if (_loc_1.curActor.currentTime < _loc_1.curActor.movieModel.getSkipPointInfoAt(_loc_2).endTime)
                        {
                            return true;
                        }
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            return false;
        }// end function

        private function setCommonPanelAttribute() : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:Boolean = false;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            this._filterView.guessSex = UserManager.getInstance().userLocalSex.getSex();
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_2 = _loc_1.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
                _loc_3 = _loc_1.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
                this._filterView.setPanelSexAttribute(_loc_1.curActor.movieModel.curEnjoyableSubType, this.getSexList());
                this._filterView.setPanelTimeAttribute(this.getSexData(_loc_1.curActor.movieModel.curEnjoyableSubType), _loc_1.curActor.movieModel.curEnjoyableSubDurationIndex);
            }
            return;
        }// end function

        private function getSexList() : Vector.<EnumItem>
        {
            var _loc_3:Boolean = false;
            var _loc_4:Boolean = false;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = new Vector.<EnumItem>;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_3 = _loc_1.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_MALE);
                _loc_4 = _loc_1.curActor.movieModel.hasEnjoyableSubType(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
                if (_loc_3 && _loc_4)
                {
                    _loc_2.push(SkipPointEnum.ENJOYABLE_SUB_MALE);
                    _loc_2.push(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
                }
                else if (_loc_3 && !_loc_4)
                {
                    _loc_2.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
                    _loc_2.push(SkipPointEnum.ENJOYABLE_SUB_MALE);
                }
                else if (!_loc_3 && _loc_4)
                {
                    _loc_2.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
                    _loc_2.push(SkipPointEnum.ENJOYABLE_SUB_FEMALE);
                }
                else
                {
                    _loc_2.push(SkipPointEnum.ENJOYABLE_SUB_COMMON);
                }
            }
            return _loc_2;
        }// end function

        private function getSexData(param1:EnumItem) : Array
        {
            var _loc_3:Array = null;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_3 = _loc_2.curActor.movieModel.getEnjoyableSubDurationList(param1);
            }
            return _loc_3;
        }// end function

    }
}
