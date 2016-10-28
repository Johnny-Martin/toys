package com.qiyi.player.wonder.plugins.topbar
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.topbar.model.*;
    import com.qiyi.player.wonder.plugins.topbar.view.*;
    import flash.display.*;

    public class TopBarPlugins extends AbstractPlugins
    {
        private static var _instance:TopBarPlugins;

        public function TopBarPlugins(param1:SingletonClass)
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
                        case TopBarProxy.NAME:
                        {
                            if (!facade.hasProxy(TopBarProxy.NAME))
                            {
                                facade.registerProxy(new TopBarProxy());
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
            else if (!facade.hasProxy(TopBarProxy.NAME))
            {
                facade.registerProxy(new TopBarProxy());
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
                        case TopBarViewMediator.NAME:
                        {
                            this.createTopBarViewMediator(param1);
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
                this.createTopBarViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            return;
        }// end function

        private function createTopBarViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:UserProxy = null;
            var _loc_3:UserInfoVO = null;
            var _loc_4:TopBarProxy = null;
            var _loc_5:TopBarView = null;
            if (!facade.hasMediator(TopBarViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                _loc_3 = new UserInfoVO();
                _loc_3.isLogin = _loc_2.isLogin;
                _loc_3.passportID = _loc_2.passportID;
                _loc_3.userID = _loc_2.userID;
                _loc_3.userName = _loc_2.userName;
                _loc_3.userLevel = _loc_2.userLevel;
                _loc_3.userType = _loc_2.userType;
                _loc_4 = facade.retrieveProxy(TopBarProxy.NAME) as TopBarProxy;
                _loc_5 = new TopBarView(param1, _loc_4.status.clone(), _loc_3);
                PanelManager.getInstance().register(_loc_5);
                facade.registerMediator(new TopBarViewMediator(_loc_5));
                _loc_4.addStatus(TopBarDef.STATUS_OPEN);
                _loc_4.addStatus(TopBarDef.STATUS_SCALE_BAR_SHOW);
            }
            return;
        }// end function

        public static function getInstance() : TopBarPlugins
        {
            if (_instance == null)
            {
                _instance = new TopBarPlugins(new SingletonClass());
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

