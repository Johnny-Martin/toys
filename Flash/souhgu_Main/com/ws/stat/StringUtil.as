package com.ws.stat
{

    public class StringUtil extends Object
    {

        public function StringUtil()
        {
            return;
        }// end function

        public static function equals(param1:String, param2:String) : Boolean
        {
            return param1 == param2;
        }// end function

        public static function equalsIgnoreCase(param1:String, param2:String) : Boolean
        {
            return param1.toLowerCase() == param2.toLowerCase();
        }// end function

        public static function isNumber(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            return !isNaN(Number(param1));
        }// end function

        public static function isIP(param1:String) : Boolean
        {
            var _loc_2:* = /^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$""^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/;
            return checkChar(param1, _loc_2);
        }// end function

        public static function isEmail(param1:String) : Boolean
        {
            var _loc_2:* = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+""(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
            return checkChar(param1, _loc_2);
        }// end function

        public static function isDouble(param1:String) : Boolean
        {
            var _loc_2:* = /^[+\-]?\d+(\.\d+)?$""^[+\-]?\d+(\.\d+)?$/;
            return checkChar(param1, _loc_2);
        }// end function

        public static function isInteger(param1:String) : Boolean
        {
            var _loc_2:* = /^[-\+]?\d+$""^[-\+]?\d+$/;
            return checkChar(param1, _loc_2);
        }// end function

        public static function isEnglish(param1:String) : Boolean
        {
            var _loc_2:* = /^[A-Za-z]+$""^[A-Za-z]+$/;
            return checkChar(param1, _loc_2);
        }// end function

        public static function isChinese(param1:String) : Boolean
        {
            var _loc_2:* = /^[Α-￥]+$""^[Α-￥]+$/;
            return checkChar(param1, _loc_2);
        }// end function

        public static function isDoubleChar(param1:String) : Boolean
        {
            var _loc_2:* = /^[^\;
            return checkChar(param1, _loc_2);
        }// end function

        public static function hasChineseChar(param1:String) : Boolean
        {
            var _loc_2:* = /[^\;
            return checkChar(param1, _loc_2);
        }// end function

        public static function hasAccountChar(param1:String, param2:uint = 15) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            if (param2 < 10)
            {
                param2 = 15;
            }
            var _loc_3:* = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + param2 + "}$", "");
            return checkChar(param1, _loc_3);
        }// end function

        public static function isURL(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = param1.toLowerCase();
            var _loc_2:* = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\\'':+!]*([^<>\\""\\""])*$""^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
            return checkChar(param1, _loc_2);
        }// end function

        public static function isWhitespace(param1:String) : Boolean
        {
            switch(param1)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                {
                    return true;
                }
                default:
                {
                    return false;
                    break;
                }
            }
        }// end function

        public static function checkChar(param1:String, param2:RegExp) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = trim(param1);
            return param2.test(param1);
        }// end function

        public static function trim(param1:String) : String
        {
            if (param1 == null)
            {
                return null;
            }
            return rtrim(ltrim(param1));
        }// end function

        public static function ltrim(param1:String) : String
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = /^\s*""^\s*/;
            return param1.replace(_loc_2, "");
        }// end function

        public static function rtrim(param1:String) : String
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = /\s*$""\s*$/;
            return param1.replace(_loc_2, "");
        }// end function

        public static function beginsWith(param1:String, param2:String) : Boolean
        {
            return param2 == param1.substring(0, param2.length);
        }// end function

        public static function endsWith(param1:String, param2:String) : Boolean
        {
            return param2 == param1.substring(param1.length - param2.length);
        }// end function

        public static function remove(param1:String, param2:String) : String
        {
            return replace(param1, param2, "");
        }// end function

        public static function replace(param1:String, param2:String, param3:String) : String
        {
            return param1.split(param2).join(param3);
        }// end function

        public static function utf16to8(param1:String) : String
        {
            var _loc_5:int = 0;
            var _loc_2:* = new Array();
            var _loc_3:* = param1.length;
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = param1.charCodeAt(_loc_4);
                if (_loc_5 >= 1 && _loc_5 <= 127)
                {
                    _loc_2[_loc_4] = param1.charAt(_loc_4);
                }
                else if (_loc_5 > 2047)
                {
                    _loc_2[_loc_4] = String.fromCharCode(224 | _loc_5 >> 12 & 15, 128 | _loc_5 >> 6 & 63, 128 | _loc_5 >> 0 & 63);
                }
                else
                {
                    _loc_2[_loc_4] = String.fromCharCode(192 | _loc_5 >> 6 & 31, 128 | _loc_5 >> 0 & 63);
                }
                _loc_4 = _loc_4 + 1;
            }
            return _loc_2.join("");
        }// end function

        public static function utf8to16(param1:String) : String
        {
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_2:* = new Array();
            var _loc_3:* = param1.length;
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_7 = param1.charCodeAt(_loc_4++);
                switch(_loc_7 >> 4)
                {
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                    case 7:
                    {
                        _loc_2[_loc_2.length] = param1.charAt((_loc_4 - 1));
                        break;
                    }
                    case 12:
                    case 13:
                    {
                        _loc_5 = param1.charCodeAt(_loc_4++);
                        _loc_2[_loc_2.length] = String.fromCharCode((_loc_7 & 31) << 6 | _loc_5 & 63);
                        break;
                    }
                    case 14:
                    {
                        _loc_5 = param1.charCodeAt(_loc_4++);
                        _loc_6 = param1.charCodeAt(_loc_4++);
                        _loc_2[_loc_2.length] = String.fromCharCode((_loc_7 & 15) << 12 | (_loc_5 & 63) << 6 | (_loc_6 & 63) << 0);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return _loc_2.join("");
        }// end function

        public static function trimBias(param1:String) : String
        {
            return ltrimBias(rtrimBias(param1));
        }// end function

        public static function ltrimBias(param1:String) : String
        {
            var _loc_2:* = param1.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                if (param1.charCodeAt(_loc_3) != 47)
                {
                    return param1.substring(_loc_3);
                }
                _loc_3++;
            }
            return "";
        }// end function

        public static function rtrimBias(param1:String) : String
        {
            var _loc_2:* = param1.length;
            var _loc_3:* = _loc_2;
            while (_loc_3 > 0)
            {
                
                if (param1.charCodeAt((_loc_3 - 1)) != 47)
                {
                    return param1.substring(0, _loc_3);
                }
                _loc_3 = _loc_3 - 1;
            }
            return "";
        }// end function

    }
}
