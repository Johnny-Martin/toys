package com.qiyi.player.wonder.plugins.offlinewatch
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.controller.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.model.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.view.*;
    import flash.display.*;

    public class OfflineWatchPlugins extends AbstractPlugins
    {
        private static var _instance:OfflineWatchPlugins;

        public function OfflineWatchPlugins(param1:SingletonClass)
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
                        case OfflineWatchProxy.NAME:
                        {
                            if (!facade.hasProxy(OfflineWatchProxy.NAME))
                            {
                                facade.registerProxy(new OfflineWatchProxy());
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
            else if (!facade.hasProxy(OfflineWatchProxy.NAME))
            {
                facade.registerProxy(new OfflineWatchProxy());
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
                        case OfflineWatchViewMediator.NAME:
                        {
                            this.createOfflineWatchViewMediator(param1);
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
                this.createOfflineWatchViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            facade.registerCommand(OfflineWatchDef.NOTIFIC_OPEN_CLOSE, OfflineWatchOpenCloseCommand);
            return;
        }// end function

        private function createOfflineWatchViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:UserProxy = null;
            var _loc_3:UserInfoVO = null;
            var _loc_4:OfflineWatchProxy = null;
            var _loc_5:OfflineWatchView = null;
            if (!facade.hasMediator(OfflineWatchViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                _loc_3 = new UserInfoVO();
                _loc_3.isLogin = _loc_2.isLogin;
                _loc_3.passportID = _loc_2.passportID;
                _loc_3.userID = _loc_2.userID;
                _loc_3.userName = _loc_2.userName;
                _loc_3.userLevel = _loc_2.userLevel;
                _loc_3.userType = _loc_2.userType;
                _loc_4 = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
                _loc_5 = new OfflineWatchView(param1, _loc_4.status.clone(), _loc_3);
                PanelManager.getInstance().register(_loc_5);
                facade.registerMediator(new OfflineWatchViewMediator(_loc_5));
            }
            return;
        }// end function

        public static function getInstance() : OfflineWatchPlugins
        {
            if (_instance == null)
            {
                _instance = new OfflineWatchPlugins(new SingletonClass());
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

