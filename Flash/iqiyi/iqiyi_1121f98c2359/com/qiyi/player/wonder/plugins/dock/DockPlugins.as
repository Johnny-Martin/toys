package com.qiyi.player.wonder.plugins.dock
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.dock.model.*;
    import com.qiyi.player.wonder.plugins.dock.view.*;
    import flash.display.*;

    public class DockPlugins extends AbstractPlugins
    {
        private static var _instance:DockPlugins;

        public function DockPlugins(param1:SingletonClass)
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
                        case DockProxy.NAME:
                        {
                            if (!facade.hasProxy(DockProxy.NAME))
                            {
                                facade.registerProxy(new DockProxy());
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
            else if (!facade.hasProxy(DockProxy.NAME))
            {
                facade.registerProxy(new DockProxy());
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
                        case DockViewMediator.NAME:
                        {
                            this.createDockViewMediator(param1);
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
                this.createDockViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            return;
        }// end function

        private function createDockViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:PlayerProxy = null;
            var _loc_3:UserProxy = null;
            var _loc_4:UserInfoVO = null;
            var _loc_5:SwitchManager = null;
            var _loc_6:DockProxy = null;
            var _loc_7:DockView = null;
            if (!facade.hasMediator(DockViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                _loc_3 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                _loc_4 = new UserInfoVO();
                _loc_4.isLogin = _loc_3.isLogin;
                _loc_4.passportID = _loc_3.passportID;
                _loc_4.userID = _loc_3.userID;
                _loc_4.userName = _loc_3.userName;
                _loc_4.userLevel = _loc_3.userLevel;
                _loc_4.userType = _loc_3.userType;
                _loc_5 = SwitchManager.getInstance();
                _loc_6 = facade.retrieveProxy(DockProxy.NAME) as DockProxy;
                if (_loc_5.getStatus(SwitchDef.ID_SHOW_DOCK_SHARE))
                {
                    _loc_6.addStatus(DockDef.STATUS_SHARE_SHOW, false);
                }
                if (_loc_5.getStatus(SwitchDef.ID_SHOW_DOCK_LIGHT) && !GlobalStage.isFullScreen())
                {
                    _loc_6.addStatus(DockDef.STATUS_LIGHT_SHOW, false);
                }
                if (_loc_2.curActor.movieInfo && _loc_2.curActor.movieInfo.allowDownload)
                {
                    _loc_6.addStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE, false);
                }
                _loc_7 = new DockView(param1, _loc_6.status.clone(), _loc_4);
                PanelManager.getInstance().register(_loc_7);
                facade.registerMediator(new DockViewMediator(_loc_7));
                if (!LocalizaEnum.isTWLocalize(FlashVarConfig.localize))
                {
                    _loc_6.addStatus(DockDef.STATUS_OPEN);
                }
            }
            return;
        }// end function

        public static function getInstance() : DockPlugins
        {
            if (_instance == null)
            {
                _instance = new DockPlugins(new SingletonClass());
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

