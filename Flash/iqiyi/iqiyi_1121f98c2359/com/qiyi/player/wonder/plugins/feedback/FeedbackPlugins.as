package com.qiyi.player.wonder.plugins.feedback
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.feedback.controller.*;
    import com.qiyi.player.wonder.plugins.feedback.model.*;
    import com.qiyi.player.wonder.plugins.feedback.view.*;
    import flash.display.*;

    public class FeedbackPlugins extends AbstractPlugins
    {
        private static var _instance:FeedbackPlugins;

        public function FeedbackPlugins(param1:SingletonClass)
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
                        case FeedbackProxy.NAME:
                        {
                            if (!facade.hasProxy(FeedbackProxy.NAME))
                            {
                                facade.registerProxy(new FeedbackProxy());
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
            else if (!facade.hasProxy(FeedbackProxy.NAME))
            {
                facade.registerProxy(new FeedbackProxy());
            }
            return;
        }// end function

        override public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void
        {
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            super.initView(param1, param2);
            var _loc_3:UserProxy = null;
            var _loc_4:UserInfoVO = null;
            var _loc_5:FeedbackProxy = null;
            var _loc_6:FeedbackView = null;
            if (param2)
            {
                _loc_7 = param2.length;
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    switch(param2[_loc_8])
                    {
                        case FeedbackViewMediator.NAME:
                        {
                            this.createFeedbackViewMediator(param1);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_8++;
                }
            }
            else
            {
                this.createFeedbackViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            facade.registerCommand(FeedbackDef.NOTIFIC_OPEN_CLOSE, FeebackOpenCloseCommand);
            return;
        }// end function

        private function createFeedbackViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:UserProxy = null;
            var _loc_3:UserInfoVO = null;
            var _loc_4:FeedbackProxy = null;
            var _loc_5:FeedbackView = null;
            if (!facade.hasMediator(FeedbackViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                _loc_3 = new UserInfoVO();
                _loc_3.isLogin = _loc_2.isLogin;
                _loc_3.passportID = _loc_2.passportID;
                _loc_3.userID = _loc_2.userID;
                _loc_3.userName = _loc_2.userName;
                _loc_3.userLevel = _loc_2.userLevel;
                _loc_3.userType = _loc_2.userType;
                _loc_4 = facade.retrieveProxy(FeedbackProxy.NAME) as FeedbackProxy;
                _loc_5 = new FeedbackView(param1, _loc_4.status.clone(), _loc_3);
                PanelManager.getInstance().register(_loc_5);
                facade.registerMediator(new FeedbackViewMediator(_loc_5));
            }
            return;
        }// end function

        public static function getInstance() : FeedbackPlugins
        {
            if (_instance == null)
            {
                _instance = new FeedbackPlugins(new SingletonClass());
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

