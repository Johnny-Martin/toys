package com.qiyi.player.wonder.plugins.tips
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.tips.model.*;
    import com.qiyi.player.wonder.plugins.tips.view.*;
    import com.qiyi.player.wonder.plugins.tips.view.parts.*;
    import flash.display.*;

    public class TipsPlugins extends AbstractPlugins
    {
        private static var _instance:TipsPlugins;

        public function TipsPlugins(param1:SingletonClass)
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
                        case TipsProxy.NAME:
                        {
                            if (!facade.hasProxy(TipsProxy.NAME))
                            {
                                facade.registerProxy(new TipsProxy());
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
            else if (!facade.hasProxy(TipsProxy.NAME))
            {
                facade.registerProxy(new TipsProxy());
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
                        case TipsViewMediator.NAME:
                        {
                            this.createTipsViewMediator(param1);
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
                this.createTipsViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            return;
        }// end function

        private function createTipsViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:UserProxy = null;
            var _loc_3:UserInfoVO = null;
            var _loc_4:ControllBarProxy = null;
            var _loc_5:TipsProxy = null;
            var _loc_6:TipsView = null;
            if (!facade.hasMediator(TipsViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                TipManager.setADState(false);
                TipManager.setIsMember(_loc_2.userLevel != UserDef.USER_LEVEL_NORMAL);
                TipManager.setIsLogin(_loc_2.isLogin);
                TipManager.setPassportId(_loc_2.passportID);
                _loc_3 = new UserInfoVO();
                _loc_3.isLogin = _loc_2.isLogin;
                _loc_3.passportID = _loc_2.passportID;
                _loc_3.userID = _loc_2.userID;
                _loc_3.userName = _loc_2.userName;
                _loc_3.userLevel = _loc_2.userLevel;
                _loc_3.userType = _loc_2.userType;
                _loc_4 = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
                _loc_5 = facade.retrieveProxy(TipsProxy.NAME) as TipsProxy;
                _loc_6 = new TipsView(param1, _loc_5.status.clone(), _loc_3);
                if (_loc_4.hasStatus(ControllBarDef.STATUS_SHOW))
                {
                    if (_loc_4.hasStatus(ControllBarDef.STATUS_SEEK_BAR_THICK))
                    {
                        _loc_6.setGap(TipsDef.STAGE_GAP_1);
                    }
                    else
                    {
                        _loc_6.setGap(TipsDef.STAGE_GAP_2);
                    }
                }
                else
                {
                    _loc_6.setGap(TipsDef.STAGE_GAP_3);
                }
                PanelManager.getInstance().register(_loc_6);
                facade.registerMediator(new TipsViewMediator(_loc_6));
            }
            return;
        }// end function

        public static function getInstance() : TipsPlugins
        {
            if (_instance == null)
            {
                _instance = new TipsPlugins(new SingletonClass());
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

