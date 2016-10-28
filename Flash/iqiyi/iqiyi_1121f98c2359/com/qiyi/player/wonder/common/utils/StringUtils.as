package com.qiyi.player.wonder.common.utils
{
    import flash.utils.*;

    public class StringUtils extends Object
    {

        public function StringUtils()
        {
            return;
        }// end function

        public static function encodeGBK(param1:String) : String
        {
            var _loc_4:int = 0;
            var _loc_2:String = "";
            var _loc_3:* = new ByteArray();
            _loc_3.writeMultiByte(param1, "gbk");
            while (_loc_4 < _loc_3.length)
            {
                
                _loc_2 = _loc_2 + escape(String.fromCharCode(_loc_3[_loc_4]));
                _loc_4++;
            }
            return _loc_2;
        }// end function

        public static function remainWord(param1:String, param2:uint, param3:String = "...") : String
        {
            var _loc_4:String = "";
            if (param1.length > param2)
            {
                _loc_4 = param1.substr(0, param2) + param3;
            }
            else
            {
                _loc_4 = param1;
            }
            return _loc_4;
        }// end function

        public static function substitute(param1:String, ... args) : String
        {
            if (param1 == null)
            {
                return "";
            }
            args = args.length;
            var _loc_4:Array = null;
            if (args == 1 && args[0] is Array)
            {
                _loc_4 = args[0] as Array;
                args = _loc_4.length;
            }
            else
            {
                _loc_4 = args;
            }
            var _loc_5:int = 0;
            while (_loc_5 < args)
            {
                
                param1 = param1.replace(new RegExp("\\{" + _loc_5 + "\\}", "g"), _loc_4[_loc_5]);
                _loc_5++;
            }
            return param1;
        }// end function

    }
}
