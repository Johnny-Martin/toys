package com.qiyi.player.wonder.plugins.scenetile
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.scenetile.controller.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.*;
    import flash.display.*;

    public class SceneTilePlugins extends AbstractPlugins
    {
        private static var _instance:SceneTilePlugins;

        public function SceneTilePlugins(param1:SingletonClass)
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
                        case SceneTileProxy.NAME:
                        {
                            if (!facade.hasProxy(SceneTileProxy.NAME))
                            {
                                facade.registerProxy(new SceneTileProxy());
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
            else if (!facade.hasProxy(SceneTileProxy.NAME))
            {
                facade.registerProxy(new SceneTileProxy());
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
                        case SceneTileToolViewMediator.NAME:
                        {
                            this.createSceneTileToolViewMediator(param1);
                            break;
                        }
                        case SceneTileBarrageViewMediator.NAME:
                        {
                            this.createSceneTileBarrageViewMediator(param1);
                            break;
                        }
                        case SceneTileScoreViewMediator.NAME:
                        {
                            this.createSceneTileScoreViewMediator(param1);
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
                this.createSceneTileToolViewMediator(param1);
                this.createSceneTileBarrageViewMediator(param1);
                this.createSceneTileScoreViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            facade.registerCommand(SceneTileDef.NOTIFIC_OPEN_CLOSE_SCORE, SceneTileScoreOpenCloseCommand);
            return;
        }// end function

        private function createSceneTileToolViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:SceneTileProxy = null;
            var _loc_3:SceneTileToolView = null;
            if (!facade.hasMediator(SceneTileToolViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
                if (!FlashVarConfig.autoPlay)
                {
                    _loc_2.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW, false);
                }
                _loc_3 = new SceneTileToolView(param1, _loc_2.status.clone(), this.createUserInfoVO());
                PanelManager.getInstance().register(_loc_3);
                facade.registerMediator(new SceneTileToolViewMediator(_loc_3));
                _loc_2.addStatus(SceneTileDef.STATUS_TOOL_OPEN);
            }
            return;
        }// end function

        private function createSceneTileBarrageViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:SceneTileProxy = null;
            var _loc_3:SceneTileBarrageView = null;
            if (!facade.hasMediator(SceneTileBarrageViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
                _loc_3 = new SceneTileBarrageView(param1, _loc_2.status.clone(), this.createUserInfoVO());
                PanelManager.getInstance().register(_loc_3);
                facade.registerMediator(new SceneTileBarrageViewMediator(_loc_3));
                if (!LocalizaEnum.isTWLocalize(FlashVarConfig.localize))
                {
                    _loc_2.addStatus(SceneTileDef.STATUS_BARRAGE_OPEN);
                }
            }
            return;
        }// end function

        private function createSceneTileScoreViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:SceneTileProxy = null;
            var _loc_3:SceneTileScoreView = null;
            if (!facade.hasMediator(SceneTileScoreViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
                _loc_3 = new SceneTileScoreView(param1, _loc_2.status.clone(), this.createUserInfoVO());
                PanelManager.getInstance().register(_loc_3);
                facade.registerMediator(new SceneTileScoreViewMediator(_loc_3));
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

        public static function getInstance() : SceneTilePlugins
        {
            if (_instance == null)
            {
                _instance = new SceneTilePlugins(new SingletonClass());
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

