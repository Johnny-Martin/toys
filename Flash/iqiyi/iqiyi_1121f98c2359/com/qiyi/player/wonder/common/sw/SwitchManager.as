package com.qiyi.player.wonder.common.sw
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.common.vo.*;
    import flash.utils.*;

    public class SwitchManager extends Object
    {
        private var _switchMap:Dictionary;
        private var _statusMap:Dictionary;
        private static var _instance:SwitchManager;

        public function SwitchManager(param1:SingletonClass)
        {
            this._switchMap = new Dictionary();
            this._statusMap = new Dictionary();
            return;
        }// end function

        public function setStatus(param1:int, param2:Boolean) : void
        {
            var _loc_3:ISwitch = null;
            if (param1 >= SwitchDef.ID_BEGIN && param1 < SwitchDef.ID_END)
            {
                this._statusMap[param1] = param2;
                _loc_3 = this._switchMap[param1];
                if (_loc_3)
                {
                    _loc_3.onSwitchStatusChanged(param1, param2);
                }
            }
            return;
        }// end function

        public function getStatus(param1:int) : Boolean
        {
            if (param1 >= SwitchDef.ID_BEGIN && param1 < SwitchDef.ID_END)
            {
                return this._statusMap[param1];
            }
            return false;
        }// end function

        public function register(param1:ISwitch) : void
        {
            var _loc_2:* = param1.getSwitchID();
            var _loc_3:int = 0;
            var _loc_4:* = _loc_2.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = _loc_2[_loc_5];
                this._switchMap[_loc_3] = param1;
                _loc_5++;
            }
            return;
        }// end function

        public function unregister(param1:ISwitch) : void
        {
            var _loc_2:* = param1.getSwitchID();
            var _loc_3:int = 0;
            var _loc_4:* = _loc_2.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3 = _loc_2[_loc_5];
                if (this._switchMap[_loc_3])
                {
                    this._switchMap[_loc_3] = null;
                    delete this._switchMap[_loc_3];
                }
                _loc_5++;
            }
            return;
        }// end function

        public function initByFlashVar(param1:String) : void
        {
            var _loc_2:int = 0;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            if (param1)
            {
                _loc_2 = 0;
                _loc_3 = "";
                _loc_2 = 0;
                while (_loc_2 < param1.length)
                {
                    
                    _loc_4 = param1.substr(_loc_2, 1);
                    _loc_4 = "0x" + _loc_4;
                    _loc_5 = Number(_loc_4).toString(2);
                    _loc_6 = _loc_5.length;
                    _loc_7 = 0;
                    while (_loc_7 < 4 - _loc_6)
                    {
                        
                        _loc_5 = "0" + _loc_5;
                        _loc_7++;
                    }
                    _loc_3 = _loc_3 + _loc_5;
                    _loc_2++;
                }
                _loc_2 = SwitchDef.ID_BEGIN;
                while (_loc_2 < SwitchDef.ID_END)
                {
                    
                    if (_loc_2 < _loc_3.length)
                    {
                        this._statusMap[_loc_2] = _loc_3.charAt(_loc_2) == "1";
                    }
                    else
                    {
                        this._statusMap[_loc_2] = false;
                    }
                    _loc_2++;
                }
            }
            return;
        }// end function

        public function initByUserInfo(param1:UserInfoVO) : void
        {
            if (param1)
            {
            }
            return;
        }// end function

        public static function getInstance() : SwitchManager
        {
            if (_instance == null)
            {
                _instance = new SwitchManager(new SingletonClass());
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

