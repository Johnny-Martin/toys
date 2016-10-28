package com.qiyi.player.wonder.plugins.hint
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.plugins.*;
    import com.qiyi.player.wonder.plugins.hint.controller.*;
    import com.qiyi.player.wonder.plugins.hint.model.*;
    import com.qiyi.player.wonder.plugins.hint.view.*;
    import flash.display.*;

    public class HintPlugins extends AbstractPlugins
    {
        private static var _instance:HintPlugins;

        public function HintPlugins(param1:SingletonClass)
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
                        case HintProxy.NAME:
                        {
                            if (!facade.hasProxy(HintProxy.NAME))
                            {
                                facade.registerProxy(new HintProxy());
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
            else if (!facade.hasProxy(HintProxy.NAME))
            {
                facade.registerProxy(new HintProxy());
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
                        case HintViewMediator.NAME:
                        {
                            this.createHintViewMediator(param1);
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
                this.createHintViewMediator(param1);
            }
            return;
        }// end function

        override public function initController() : void
        {
            super.initController();
            facade.registerCommand(HintDef.NOTIFIC_HINT_OPEN_CLOSE, HintOpenCloseCommand);
            facade.registerCommand(HintDef.NOTIFIC_HINT_CHECK, HintCheckCommand);
            return;
        }// end function

        private function createHintViewMediator(param1:DisplayObjectContainer) : void
        {
            var _loc_2:HintProxy = null;
            var _loc_3:HintView = null;
            if (!facade.hasMediator(HintViewMediator.NAME))
            {
                _loc_2 = facade.retrieveProxy(HintProxy.NAME) as HintProxy;
                _loc_3 = new HintView(param1);
                PanelManager.getInstance().register(_loc_3);
                facade.registerMediator(new HintViewMediator(_loc_3));
            }
            return;
        }// end function

        public static function getInstance() : HintPlugins
        {
            if (_instance == null)
            {
                _instance = new HintPlugins(new SingletonClass());
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

