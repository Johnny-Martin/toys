package com.qiyi.player.wonder.plugins.loading
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.loading.model.*;
    import com.qiyi.player.wonder.plugins.loading.view.*;
    import flash.display.*;

    public class LoadingPlugins extends AbstractPlugins
    {
        private static var _instance:LoadingPlugins;

        public function LoadingPlugins(param1:SingletonClass)
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
                        case LoadingProxy.NAME:
                        {
                            if (!facade.hasProxy(LoadingProxy.NAME))
                            {
                                facade.registerProxy(new LoadingProxy());
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
            else if (!facade.hasProxy(LoadingProxy.NAME))
            {
                facade.registerProxy(new LoadingProxy());
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
                        case LoadingViewMediator.NAME:
                        {
                            this.createLoadingViewMediator(param1);
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
                this.createLoadingViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            return;
        }// end function

        private function createLoadingViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:UserProxy = null;
            var _loc_3:UserInfoVO = null;
            var _loc_4:LoadingProxy = null;
            var _loc_5:LoadingView = null;
            if (!facade.hasMediator(LoadingViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                _loc_3 = new UserInfoVO();
                _loc_3.isLogin = _loc_2.isLogin;
                _loc_3.passportID = _loc_2.passportID;
                _loc_3.userID = _loc_2.userID;
                _loc_3.userName = _loc_2.userName;
                _loc_3.userLevel = _loc_2.userLevel;
                _loc_3.userType = _loc_2.userType;
                _loc_4 = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
                _loc_5 = new LoadingView(param1, _loc_4.status.clone(), _loc_3);
                PanelManager.getInstance().register(_loc_5);
                facade.registerMediator(new LoadingViewMediator(_loc_5));
                if (FlashVarConfig.isMemberMovie)
                {
                    _loc_5.updatePreloaderURL(FlashVarConfig.preloaderVipURL);
                }
                else if (FlashVarConfig.qiyiProduced == "1" && FlashVarConfig.qiyiProducedPreloader != "")
                {
                    _loc_5.updatePreloaderURL(FlashVarConfig.qiyiProducedPreloader);
                }
                else if (FlashVarConfig.exclusive == "1" && FlashVarConfig.exclusivePreloader != "")
                {
                    _loc_5.updatePreloaderURL(FlashVarConfig.exclusivePreloader);
                }
                else
                {
                    _loc_5.updatePreloaderURL(FlashVarConfig.preloaderURL);
                }
                if (FlashVarConfig.autoPlay)
                {
                    _loc_4.addStatus(LoadingDef.STATUS_OPEN);
                }
            }
            return;
        }// end function

        public static function getInstance() : LoadingPlugins
        {
            if (_instance == null)
            {
                _instance = new LoadingPlugins(new SingletonClass());
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

