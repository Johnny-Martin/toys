package com.qiyi.player.wonder.plugins.controllbar
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.*;
    import flash.display.*;

    public class ControllBarPlugins extends AbstractPlugins
    {
        private static var _instance:ControllBarPlugins;

        public function ControllBarPlugins(param1:SingletonClass)
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
                        case ControllBarProxy.NAME:
                        {
                            if (!facade.hasProxy(ControllBarProxy.NAME))
                            {
                                facade.registerProxy(new ControllBarProxy());
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
            else if (!facade.hasProxy(ControllBarProxy.NAME))
            {
                facade.registerProxy(new ControllBarProxy());
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
                        case ControllBarViewMediator.NAME:
                        {
                            this.createControllBarViewMediator(param1);
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
                this.createControllBarViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            return;
        }// end function

        private function createControllBarViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:UserProxy = null;
            var _loc_3:UserInfoVO = null;
            var _loc_4:ADProxy = null;
            var _loc_5:SwitchManager = null;
            var _loc_6:ControllBarProxy = null;
            var _loc_7:ControllBarView = null;
            if (!facade.hasMediator(ControllBarViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                _loc_3 = new UserInfoVO();
                _loc_3.isLogin = _loc_2.isLogin;
                _loc_3.passportID = _loc_2.passportID;
                _loc_3.userID = _loc_2.userID;
                _loc_3.userName = _loc_2.userName;
                _loc_3.userLevel = _loc_2.userLevel;
                _loc_3.userType = _loc_2.userType;
                _loc_4 = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
                _loc_5 = SwitchManager.getInstance();
                _loc_6 = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
                _loc_6.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW, false);
                if (_loc_5.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR))
                {
                    _loc_6.addStatus(ControllBarDef.STATUS_SHOW);
                }
                _loc_6.addStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
                if (_loc_5.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_FF))
                {
                    _loc_6.addStatus(ControllBarDef.STATUS_FF_SHOW, false);
                }
                if (_loc_5.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_VOLUME))
                {
                    _loc_6.addStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW, false);
                }
                if (FlashVarConfig.expandState)
                {
                    _loc_6.addStatus(ControllBarDef.STATUS_EXPAND_UNFOLD, false);
                }
                _loc_7 = new ControllBarView(param1, _loc_6.status.clone(), _loc_3);
                _loc_7.volumeControlView.setVolume(Settings.instance.volumn, Settings.instance.mute);
                PanelManager.getInstance().register(_loc_7);
                facade.registerMediator(new ControllBarViewMediator(_loc_7));
                _loc_6.addStatus(ControllBarDef.STATUS_OPEN);
            }
            return;
        }// end function

        public static function getInstance() : ControllBarPlugins
        {
            if (_instance == null)
            {
                _instance = new ControllBarPlugins(new SingletonClass());
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

