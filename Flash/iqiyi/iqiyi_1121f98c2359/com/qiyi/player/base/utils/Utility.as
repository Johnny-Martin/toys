package com.qiyi.player.base.utils
{
    import com.qiyi.player.base.pub.*;
    import flash.system.*;

    public class Utility extends Object
    {

        public function Utility()
        {
            return;
        }// end function

        public static function getFlashVersion() : Object
        {
            var _loc_1:Object = {};
            var _loc_2:* = Capabilities.version;
            var _loc_3:* = _loc_2.indexOf(" ");
            _loc_1.platform = _loc_2.substr(0, _loc_3);
            _loc_2 = _loc_2.substr((_loc_3 + 1));
            var _loc_4:* = _loc_2.split(",");
            _loc_1.ver1 = int(_loc_4[0]);
            _loc_1.ver2 = int(_loc_4[1]);
            _loc_1.ver3 = int(_loc_4[2]);
            _loc_1.ver4 = int(_loc_4[3]);
            return _loc_1;
        }// end function

        public static function runtimeSupportsStageVideo() : Boolean
        {
            var _loc_1:* = Capabilities.version;
            if (_loc_1 == null)
            {
                return false;
            }
            var _loc_2:* = _loc_1.split(" ");
            if (_loc_2.length < 2)
            {
                return false;
            }
            var _loc_3:* = _loc_2[0];
            var _loc_4:* = _loc_2[1].split(",");
            if (_loc_4.length < 2)
            {
                return false;
            }
            var _loc_5:* = parseInt(_loc_4[0]);
            var _loc_6:* = parseInt(_loc_4[1]);
            return _loc_5 > 10 || _loc_5 == 10 && _loc_6 >= 2;
        }// end function

        public static function runtimeSupportsDataMode() : Boolean
        {
            var _loc_1:* = Capabilities.version;
            if (_loc_1 == null)
            {
                return false;
            }
            var _loc_2:* = _loc_1.split(" ");
            if (_loc_2.length < 2)
            {
                return false;
            }
            var _loc_3:* = _loc_2[0];
            var _loc_4:* = _loc_2[1].split(",");
            if (_loc_4.length < 2)
            {
                return false;
            }
            var _loc_5:* = parseInt(_loc_4[0]);
            var _loc_6:* = parseInt(_loc_4[1]);
            return _loc_5 > 10 || _loc_5 == 10 && _loc_6 >= 1;
        }// end function

        public static function getUrl(param1:String, param2:String) : String
        {
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            while (_loc_5 < param1.length)
            {
                
                if (param1.substr(_loc_5, 1) == "/")
                {
                    _loc_4++;
                }
                if (_loc_4 == 3)
                {
                    break;
                }
                _loc_5++;
            }
            _loc_3 = param1.substr(0, (_loc_5 + 1)) + param2 + param1.substr(_loc_5);
            return _loc_3;
        }// end function

        public static function getItemById(param1:Array, param2:int) : EnumItem
        {
            var _loc_3:* = undefined;
            for each (_loc_3 in param1)
            {
                
                if (_loc_3.id == param2)
                {
                    return _loc_3;
                }
            }
            return null;
        }// end function

        public static function getItemByName(param1:Array, param2:String) : EnumItem
        {
            var _loc_3:* = undefined;
            for each (_loc_3 in param1)
            {
                
                if (_loc_3.name == param2)
                {
                    return _loc_3;
                }
            }
            return null;
        }// end function

    }
}
