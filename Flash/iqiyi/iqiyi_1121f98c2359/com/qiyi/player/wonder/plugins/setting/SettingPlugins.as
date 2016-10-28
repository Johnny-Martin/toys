package com.qiyi.player.wonder.plugins.setting
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.setting.controller.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import com.qiyi.player.wonder.plugins.setting.view.*;
    import flash.display.*;

    public class SettingPlugins extends AbstractPlugins
    {
        private static var _instance:SettingPlugins;

        public function SettingPlugins(param1:SingletonClass)
        {
            return;
        }// end function

        override public function initModel(param1:Vector.<String> = null) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            super.initModel(param1);
            if (param1)
            {
                _loc_2 = param1.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    switch(param1[_loc_3])
                    {
                        case SettingProxy.NAME:
                        {
                            if (!facade.hasProxy(SettingProxy.NAME))
                            {
                                facade.registerProxy(new SettingProxy());
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_3++;
                }
            }
            else if (!facade.hasProxy(SettingProxy.NAME))
            {
                facade.registerProxy(new SettingProxy());
            }
            return;
        }// end function

        override public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            super.initView(param1, param2);
            if (param2)
            {
                _loc_3 = param2.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_3)
                {
                    
                    switch(param2[_loc_4])
                    {
                        case SettingViewMediator.NAME:
                        {
                            this.createSettingViewMediator(param1);
                            break;
                        }
                        case DefinitionViewMediator.NAME:
                        {
                            this.createDefinitionViewMediator(param1);
                            break;
                        }
                        case FilterViewMediator.NAME:
                        {
                            this.createFilterViewMediator(param1);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_4++;
                }
            }
            else
            {
                this.createSettingViewMediator(param1);
                this.createDefinitionViewMediator(param1);
                this.createFilterViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            facade.registerCommand(SettingDef.NOTIFIC_OPEN_CLOSE, SettingOpenCloseCommand);
            facade.registerCommand(SettingDef.NOTIFIC_DEFINITION_OPEN_CLOSE, DefinitionOpenCloseCommand);
            facade.registerCommand(SettingDef.NOTIFIC_FILTER_OPEN_CLOSE, FilterOpenCloseCommand);
            return;
        }// end function

        private function createSettingViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:SettingProxy = null;
            var _loc_3:SettingView = null;
            if (!facade.hasMediator(SettingViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
                _loc_3 = new SettingView(param1, _loc_2.status.clone(), this.createUserInfoVO());
                PanelManager.getInstance().register(_loc_3);
                facade.registerMediator(new SettingViewMediator(_loc_3));
            }
            return;
        }// end function

        private function createDefinitionViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:SettingProxy = null;
            var _loc_3:DefinitionView = null;
            if (!facade.hasMediator(DefinitionViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
                _loc_3 = new DefinitionView(param1, _loc_2.status.clone(), this.createUserInfoVO());
                PanelManager.getInstance().register(_loc_3);
                facade.registerMediator(new DefinitionViewMediator(_loc_3));
            }
            return;
        }// end function

        private function createFilterViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:SettingProxy = null;
            var _loc_3:FilterView = null;
            if (!facade.hasMediator(FilterViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
                _loc_3 = new FilterView(param1, _loc_2.status.clone(), this.createUserInfoVO());
                PanelManager.getInstance().register(_loc_3);
                facade.registerMediator(new FilterViewMediator(_loc_3));
            }
            return;
        }// end function

        private function createUserInfoVO() : UserInfoVO
        {
            var _loc_1:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_2:* = new UserInfoVO();
            _loc_2.isLogin = _loc_1.isLogin;
            _loc_2.passportID = _loc_1.passportID;
            _loc_2.userID = _loc_1.userID;
            _loc_2.userName = _loc_1.userName;
            _loc_2.userLevel = _loc_1.userLevel;
            _loc_2.userType = _loc_1.userType;
            return _loc_2;
        }// end function

        public static function getInstance() : SettingPlugins
        {
            if (_instance == null)
            {
                _instance = new SettingPlugins(new SingletonClass());
            }
            return _instance;
        }// end function

    }
}

class SingletonClass extends Object
{

    function SingletonClass()
    {
        return;
    }// end function

}

