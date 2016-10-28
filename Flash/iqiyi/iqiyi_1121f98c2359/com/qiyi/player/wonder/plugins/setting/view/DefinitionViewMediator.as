package com.qiyi.player.wonder.plugins.setting.view
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import com.qiyi.player.wonder.plugins.tips.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import flash.net.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class DefinitionViewMediator extends Mediator
    {
        private var _settingProxy:SettingProxy;
        private var _definitionView:DefinitionView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.DefinitionViewMediator";

        public function DefinitionViewMediator(param1:DefinitionView)
        {
            super(NAME, param1);
            this._definitionView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._settingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            this._definitionView.addEventListener(SettingEvent.Evt_DefinitionOpen, this.onDefinitionViewOpen);
            this._definitionView.addEventListener(SettingEvent.Evt_DefinitionClose, this.onDefinitionViewClose);
            this._definitionView.addEventListener(SettingEvent.Evt_DefinitionChangeClick, this.onDefinitionViewChangeClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [SettingDef.NOTIFIC_ADD_STATUS, SettingDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:ControllBarProxy = null;
            var _loc_6:PlayerProxy = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case SettingDef.NOTIFIC_ADD_STATUS:
                {
                    _loc_5 = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
                    _loc_6 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (int(_loc_2) == SettingDef.STATUS_DEFINITION_OPEN)
                    {
                        this._definitionView.initUI(_loc_5.definitionBtnX, _loc_5.definitionBtnY, this.getDefinitionArray(), this.getLimitDefinitionArray(), Settings.instance.autoMatchRate ? (DefinitionEnum.NONE) : (null), _loc_6.curActor.movieModel.curDefinitionInfo.type.id);
                        sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
                    }
                    this._definitionView.onAddStatus(int(_loc_2));
                    break;
                }
                case SettingDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._definitionView.onRemoveStatus(int(_loc_2));
                    if (int(_loc_2) == SettingDef.STATUS_DEFINITION_OPEN)
                    {
                        sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
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
                    TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                    this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
                    break;
                }
                case BodyDef.NOTIFIC_FULL_SCREEN:
                {
                    this.onFullScreen(Boolean(_loc_2));
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
                {
                    if (param2)
                    {
                        TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                    }
                }
                case BodyDef.PLAYER_STATUS_STOPED:
                case BodyDef.PLAYER_STATUS_STOPPING:
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
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

        private function onFullScreen(param1:Boolean) : void
        {
            var _loc_2:PlayerProxy = null;
            var _loc_3:EnumItem = null;
            if (param1)
            {
                _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                if (_loc_2.curActor.movieModel)
                {
                    _loc_3 = _loc_2.curActor.movieModel.curDefinitionInfo.type;
                    if (_loc_3 == DefinitionEnum.LIMIT)
                    {
                        sendNotification(TopBarDef.NOTIFIC_REQUEST_SCALE, TopBarDef.SCALE_VALUE_75);
                        sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_CHANG_SIZE_75);
                    }
                }
            }
            return;
        }// end function

        private function onPlayerDefinitionSwitched(param1:int) : void
        {
            if (param1 >= 0)
            {
                TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                TweenLite.delayedCall(param1 / 1000, this.onPlayerDefinitionSwitchComplete);
            }
            return;
        }// end function

        private function onPlayerDefinitionSwitchComplete() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.movieModel)
            {
                this._definitionView.setChangeVidComplete(_loc_1.curActor.movieModel.curDefinitionInfo.type);
            }
            return;
        }// end function

        private function onDefinitionViewOpen(event:SettingEvent) : void
        {
            if (!this._settingProxy.hasStatus(SettingDef.STATUS_DEFINITION_OPEN))
            {
                this._settingProxy.addStatus(SettingDef.STATUS_DEFINITION_OPEN);
            }
            return;
        }// end function

        private function onDefinitionViewClose(event:SettingEvent) : void
        {
            if (this._settingProxy.hasStatus(SettingDef.STATUS_DEFINITION_OPEN))
            {
                this._settingProxy.removeStatus(SettingDef.STATUS_DEFINITION_OPEN);
            }
            return;
        }// end function

        private function onDefinitionViewChangeClick(event:SettingEvent) : void
        {
            var _loc_4:EnumItem = null;
            var _loc_5:JavascriptAPIProxy = null;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            if (event.data as EnumItem == DefinitionEnum.NONE)
            {
                Settings.instance.autoMatchRate = true;
            }
            else if (_loc_2.curActor.movieModel.hasDefinitionByType(event.data as EnumItem))
            {
                if (_loc_2.curActor.movieModel)
                {
                    _loc_4 = _loc_2.curActor.movieModel.curDefinitionInfo.type;
                    if (event.data && _loc_4 && _loc_4 != event.data)
                    {
                        PingBack.getInstance().switchDefinition(_loc_4.id, EnumItem(event.data).id);
                    }
                }
                Settings.instance.autoMatchRate = false;
                Settings.instance.definition = event.data as EnumItem;
                if (FlashVarConfig.outsite && (event.data == DefinitionEnum.SUPER_HIGH || event.data == DefinitionEnum.FULL_HD))
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
                    Settings.update();
                    GlobalStage.setNormalScreen();
                    navigateToURL(new URLRequest(_loc_2.curActor.movieInfo.pageUrl), "_blank");
                }
            }
            else
            {
                GlobalStage.setNormalScreen();
                sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
                _loc_5 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                _loc_5.callJsDoSomething(BodyDef.JS_CALL_DEFINITION_LIMIT);
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
            this._definitionView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function getLimitDefinitionArray() : Array
        {
            var _loc_3:EnumItem = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = new Array();
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_1.curActor.movieModel.qualityDefinitionControlList.length)
            {
                
                _loc_3 = _loc_1.curActor.movieModel.qualityDefinitionControlList[_loc_4];
                if (_loc_3 != null)
                {
                    _loc_2.push(_loc_3);
                }
                _loc_4 = _loc_4 + 1;
            }
            _loc_2.sortOn("id", Array.DESCENDING | Array.NUMERIC);
            return _loc_2;
        }// end function

        private function getDefinitionArray() : Array
        {
            var _loc_3:EnumItem = null;
            var _loc_6:uint = 0;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = new Array();
            var _loc_4:Boolean = false;
            var _loc_5:uint = 0;
            while (_loc_5 < _loc_1.curActor.movieModel.curAudioTrackInfo.definitionCount)
            {
                
                _loc_4 = false;
                _loc_3 = _loc_1.curActor.movieModel.curAudioTrackInfo.findDefinitionInfoAt(_loc_5).type;
                if (_loc_3 != null)
                {
                    _loc_6 = 0;
                    while (_loc_6 < _loc_1.curActor.movieModel.qualityDefinitionControlList.length)
                    {
                        
                        if (_loc_3.id == (_loc_1.curActor.movieModel.qualityDefinitionControlList[_loc_6] as EnumItem).id)
                        {
                            _loc_4 = true;
                        }
                        _loc_6 = _loc_6 + 1;
                    }
                    if (!_loc_4)
                    {
                        _loc_2.push(_loc_3);
                    }
                }
                _loc_5 = _loc_5 + 1;
            }
            _loc_2.sortOn("id", Array.DESCENDING | Array.NUMERIC);
            if (_loc_2[0] == DefinitionEnum.LIMIT)
            {
                _loc_2.push(_loc_2.shift());
            }
            _loc_2.push(DefinitionEnum.NONE);
            return _loc_2;
        }// end function

    }
}
