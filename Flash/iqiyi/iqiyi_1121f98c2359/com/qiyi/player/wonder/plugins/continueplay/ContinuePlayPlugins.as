package com.qiyi.player.wonder.plugins.continueplay
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.continueplay.controller.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.continueplay.view.*;
    import flash.display.*;

    public class ContinuePlayPlugins extends AbstractPlugins
    {
        private static var _instance:ContinuePlayPlugins;

        public function ContinuePlayPlugins(param1:SingletonClass)
        {
            return;
        }// end function

        override public function initModel(param1:Vector.<String> = null) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            super.initModel(param1);
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:ContinuePlayProxy = null;
            if (param1)
            {
                _loc_4 = param1.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    switch(param1[_loc_5])
                    {
                        case ContinuePlayProxy.NAME:
                        {
                            if (!facade.hasProxy(ContinuePlayProxy.NAME))
                            {
                                _loc_3 = new ContinuePlayProxy();
                                _loc_3.injectPlayerProxy(_loc_2);
                                facade.registerProxy(_loc_3);
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_5++;
                }
            }
            else if (!facade.hasProxy(ContinuePlayProxy.NAME))
            {
                _loc_3 = new ContinuePlayProxy();
                _loc_3.injectPlayerProxy(_loc_2);
                facade.registerProxy(_loc_3);
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
                        case ContinuePlayViewMediator.NAME:
                        {
                            this.createContinuePlayViewMediator(param1);
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
                this.createContinuePlayViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            facade.registerCommand(ContinuePlayDef.NOTIFIC_OPEN_CLOSE, ContinuePlayOpenCloseCommand);
            facade.registerCommand(BodyDef.NOTIFIC_JS_CALL_ADD_VIDEO_LIST, AddVideoListCommand);
            facade.registerCommand(BodyDef.NOTIFIC_JS_CALL_REMOVE_FROM_LIST, RemoveVideoListCommand);
            return;
        }// end function

        private function createContinuePlayViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:UserProxy = null;
            var _loc_3:UserInfoVO = null;
            var _loc_4:ContinuePlayProxy = null;
            var _loc_5:ContinuePlayView = null;
            if (!facade.hasMediator(ContinuePlayViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                _loc_3 = new UserInfoVO();
                _loc_3.isLogin = _loc_2.isLogin;
                _loc_3.passportID = _loc_2.passportID;
                _loc_3.userID = _loc_2.userID;
                _loc_3.userName = _loc_2.userName;
                _loc_3.userLevel = _loc_2.userLevel;
                _loc_3.userType = _loc_2.userType;
                _loc_4 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
                _loc_5 = new ContinuePlayView(param1, _loc_4.status.clone(), _loc_3);
                PanelManager.getInstance().register(_loc_5);
                facade.registerMediator(new ContinuePlayViewMediator(_loc_5));
            }
            return;
        }// end function

        public static function getInstance() : ContinuePlayPlugins
        {
            if (_instance == null)
            {
                _instance = new ContinuePlayPlugins(new SingletonClass());
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

