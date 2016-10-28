package com.qiyi.cupid.adplayer.utils
{

    public class StringUtils extends Object
    {

        public function StringUtils()
        {
            return;
        }// end function

        public static function trim(param1:String) : String
        {
            var _loc_2:String = "";
            var _loc_3:int = 0;
            while (_loc_3 < param1.length)
            {
                
                if (param1.charAt(_loc_3) != " ")
                {
                    _loc_2 = _loc_2 + param1.charAt(_loc_3);
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public static function isEmpty(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return true;
            }
            return StringUtils.trim(param1).length == 0;
        }// end function

        public static function removeControlChars(param1:String) : String
        {
            var _loc_2:String = null;
            var _loc_3:Array = null;
            if (param1 != null)
            {
                _loc_2 = param1;
                _loc_2 = _loc_2.split("\t").join(" ");
                _loc_2 = _loc_2.split("\r").join(" ");
                _loc_2 = _loc_2.split("\n").join(" ");
                return _loc_2;
            }
            return param1;
        }// end function

        public static function compressWhitespace(param1:String) : String
        {
            var _loc_3:Array = null;
            var _loc_2:* = param1;
            _loc_3 = _loc_2.split(" ");
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                if (_loc_3[_loc_4] == "")
                {
                    _loc_3.splice(_loc_4, 1);
                    _loc_4 = _loc_4 - 1;
                }
                _loc_4 = _loc_4 + 1;
            }
            _loc_2 = _loc_3.join(" ");
            return _loc_2;
        }// end function

        public static function concatEnsuringSeparator(param1:String, param2:String, param3:String) : String
        {
            if (StringUtils.endsWith(param1, param3) || StringUtils.beginsWith(param2, param3))
            {
                return param1 + param2;
            }
            return param1 + param3 + param2;
        }// end function

        public static function beginsWith(param1:String, param2:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            return StringUtils.trim(param1).indexOf(param2) == 0;
        }// end function

        public static function endsWith(param1:String, param2:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            return param1.lastIndexOf(param2) == param1.length - param2.length;
        }// end function

        public static function revertSingleQuotes(param1:String, param2:String) : String
        {
            var _loc_3:* = /{quote}""{quote}/g;
            return param1.replace(_loc_3, param2);
        }// end function

        public static function replaceSingleWithDoubleQuotes(param1:String) : String
        {
            var _loc_2:* = /''""'/g;
            return param1.replace(_loc_2, "\"");
        }// end function

        public static function escapeString(param1:String) : String
        {
            var _loc_2:* = /([''\\""\\\])""(['\"\\])/g;
            return param1.replace(_loc_2, "\\$1");
        }// end function

        public static function getQuery(param1:String, param2:String) : String
        {
            var _loc_3:* = new RegExp("(^|&|\\?|#)" + param2 + "=([^&]*)(&|$)");
            var _loc_4:* = param1.match(_loc_3);
            if (_loc_4)
            {
                return _loc_4[2];
            }
            return "";
        }// end function

    }
}
