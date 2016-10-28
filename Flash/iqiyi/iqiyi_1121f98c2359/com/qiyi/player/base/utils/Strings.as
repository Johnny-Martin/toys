package com.qiyi.player.base.utils
{

    public class Strings extends Object
    {

        public function Strings()
        {
            return;
        }// end function

        public static function parseTime(param1:String) : Number
        {
            var _loc_4:int = 0;
            var _loc_2:Number = 0;
            var _loc_3:* = param1.split(":");
            if (_loc_3.length > 1)
            {
                _loc_2 = _loc_3[0] * 3600;
                _loc_2 = _loc_2 + _loc_3[1] * 60;
                _loc_2 = _loc_2 + Number(_loc_3[2]);
            }
            else
            {
                _loc_4 = 0;
                switch(param1.charAt((param1.length - 1)))
                {
                    case "h":
                    {
                        _loc_4 = 3600;
                        break;
                    }
                    case "m":
                    {
                        _loc_4 = 60;
                        break;
                    }
                    case "s":
                    {
                        _loc_4 = 1;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (_loc_4)
                {
                    _loc_2 = Number(param1.substr(0, (param1.length - 1))) * _loc_4;
                }
                else
                {
                    _loc_2 = Number(param1);
                }
            }
            return _loc_2;
        }// end function

        public static function formatAsTimeCode(param1:Number, param2:Boolean = true) : String
        {
            var _loc_3:* = Math.floor(param1 / 3600);
            _loc_3 = isNaN(_loc_3) ? (0) : (_loc_3);
            var _loc_4:* = Math.floor(param1 % 3600 / 60);
            _loc_4 = isNaN(_loc_4) ? (0) : (_loc_4);
            var _loc_5:* = Math.floor(param1 % 3600 % 60);
            _loc_5 = isNaN(_loc_5) ? (0) : (_loc_5);
            return (_loc_3 == 0 ? (param2 ? ("00:") : ("")) : (_loc_3 < 10 ? ("0" + _loc_3.toString() + ":") : (_loc_3.toString() + ":"))) + (_loc_4 < 10 ? ("0" + _loc_4.toString()) : (_loc_4.toString())) + ":" + (_loc_5 < 10 ? ("0" + _loc_5.toString()) : (_loc_5.toString()));
        }// end function

        public static function trim(param1:String) : String
        {
            var _loc_4:int = 0;
            var _loc_2:* = param1;
            var _loc_3:int = 0;
            while (_loc_3 != param1.length)
            {
                
                _loc_4 = param1.charCodeAt(_loc_3);
                if (_loc_4 > 32)
                {
                    break;
                }
                _loc_3++;
            }
            _loc_2 = param1.substr(_loc_3);
            _loc_3 = _loc_2.length;
            while (_loc_3 >= 0)
            {
                
                _loc_4 = param1.charCodeAt(_loc_3);
                if (_loc_4 > 32)
                {
                    break;
                }
                _loc_3 = _loc_3 - 1;
            }
            _loc_2 = _loc_2.substr(0, _loc_3);
            return _loc_2;
        }// end function

        public static function getFileExtension(param1:String) : String
        {
            var _loc_2:* = param1.lastIndexOf(".");
            if (_loc_2 == -1)
            {
                return "";
            }
            return param1.substr((_loc_2 + 1));
        }// end function

        public static function getFileName(param1:String) : String
        {
            var _loc_2:* = param1.lastIndexOf("/");
            if (_loc_2 == -1)
            {
                _loc_2 = param1.lastIndexOf("\\");
                if (_loc_2 == -1)
                {
                    return param1;
                }
            }
            return param1.substr((_loc_2 + 1));
        }// end function

    }
}
