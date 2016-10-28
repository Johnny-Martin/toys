package com.qiyi.player.wonder.plugins.recommend
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.recommend.controller.*;
    import com.qiyi.player.wonder.plugins.recommend.model.*;
    import com.qiyi.player.wonder.plugins.recommend.view.*;
    import flash.display.*;

    public class RecommendPlugins extends AbstractPlugins
    {
        private static var _instance:RecommendPlugins;

        public function RecommendPlugins(param1:SingletonClass)
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
                        case RecommendProxy.NAME:
                        {
                            if (!facade.hasProxy(RecommendProxy.NAME))
                            {
                                facade.registerProxy(new RecommendProxy());
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
            else if (!facade.hasProxy(RecommendProxy.NAME))
            {
                facade.registerProxy(new RecommendProxy());
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
                        case RecommendViewMediator.NAME:
                        {
                            this.createRecommendViewMediator(param1);
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
                this.createRecommendViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            facade.registerCommand(RecommendDef.NOTIFIC_FINISH_RECOMMEND_OPEN_CLOSE, RecommendOpenCloseCommand);
            return;
        }// end function

        private function createRecommendViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:RecommendProxy = null;
            var _loc_3:RecommendView = null;
            if (!facade.hasMediator(RecommendViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(RecommendProxy.NAME) as RecommendProxy;
                _loc_3 = new RecommendView(param1, _loc_2.status.clone(), this.createUserInfoVO());
                PanelManager.getInstance().register(_loc_3);
                facade.registerMediator(new RecommendViewMediator(_loc_3));
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

        public static function getInstance() : RecommendPlugins
        {
            if (_instance == null)
            {
                _instance = new RecommendPlugins(new SingletonClass());
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

