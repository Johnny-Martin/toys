package com.iqiyi.components.panelSystem
{
    import com.iqiyi.components.panelSystem.interfaces.*;
    import flash.display.*;
    import flash.utils.*;

    public class PanelManager extends Object
    {
        private var _panels:Dictionary;
        private static var _instance:PanelManager;

        public function PanelManager(param1:SingletonClass)
        {
            if (param1 == null)
            {
                throw new Error("PanelManager is Singleton Class!");
            }
            this._panels = new Dictionary();
            return;
        }// end function

        public function register(param1:IPanel) : void
        {
            if (this._panels[param1.name] == null)
            {
                this._panels[param1.name] = param1;
            }
            return;
        }// end function

        public function unregister(param1:String) : void
        {
            var _loc_2:* = this._panels[param1];
            if (_loc_2)
            {
                _loc_2.destroy();
                delete this._panels[param1];
            }
            return;
        }// end function

        public function getPanel(param1:String) : IPanel
        {
            return this._panels[param1];
        }// end function

        public function open(param1:String, param2:DisplayObjectContainer = null) : IPanel
        {
            var _loc_3:* = this._panels[param1];
            if (_loc_3)
            {
                _loc_3.open(param2);
            }
            return _loc_3;
        }// end function

        public function close(param1:String) : IPanel
        {
            var _loc_2:* = this._panels[param1];
            if (_loc_2)
            {
                _loc_2.close();
            }
            return _loc_2;
        }// end function

        public function closeAll() : void
        {
            var _loc_1:IPanel = null;
            for each (_loc_1 in this._panels)
            {
                
                if (_loc_1.isOpen)
                {
                    _loc_1.close();
                }
            }
            return;
        }// end function

        public function closeByType(param1:int) : void
        {
            var _loc_2:IPanel = null;
            for each (_loc_2 in this._panels)
            {
                
                if (_loc_2.isOpen && _loc_2.type == param1)
                {
                    _loc_2.close();
                }
            }
            return;
        }// end function

        public static function getInstance() : PanelManager
        {
            if (_instance == null)
            {
                _instance = new PanelManager(new SingletonClass());
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

