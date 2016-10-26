package httpSocket.utils
{

    public class StringUtil extends Object
    {
        private static var CHINESE_MAX:Number = 40959;
        private static var CHINESE_MIN:Number = 19968;
        private static var LOWER_MAX:Number = 122;
        private static var LOWER_MIN:Number = 97;
        private static var NUMBER_MAX:Number = 57;
        private static var NUMBER_MIN:Number = 48;
        private static var UPPER_MAX:Number = 90;
        private static var UPPER_MIN:Number = 65;
        private static var NEW_LINE_REPLACER:String = String.fromCharCode(6);
        private static const ChineseNumberTable:Array = [38646, 19968, 20108, 19977, 22235, 20116, 20845, 19971, 20843, 20061, 21313];
        public static const LV1_Split:String = ",";
        public static const LV2_Split:String = ":";

        public function StringUtil()
        {
            throw new Error("StringUtil class is static container only");
        }// end function

        public static function equalsIgnoreCase(param1:String, param2:String) : Boolean
        {
            return param1.toLowerCase() == param2.toLowerCase();
        }// end function

        public static function equals(param1:String, param2:String) : Boolean
        {
            return param1 == param2;
        }// end function

        public static function isEmail(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = trim(param1);
            var _loc_2:* = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+""(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
            var _loc_3:* = _loc_2.exec(param1);
            if (_loc_3 == null)
            {
                return false;
            }
            return true;
        }// end function

        public static function isNumber(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            return !isNaN(parseInt(param1));
        }// end function

        public static function isDouble(param1:String) : Boolean
        {
            param1 = trim(param1);
            var _loc_2:* = /^[-\+]?\d+(\.\d+)?$""^[-\+]?\d+(\.\d+)?$/;
            var _loc_3:* = _loc_2.exec(param1);
            if (_loc_3 == null)
            {
                return false;
            }
            return true;
        }// end function

        public static function isInteger(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = trim(param1);
            var _loc_2:* = /^[-\+]?\d+$""^[-\+]?\d+$/;
            var _loc_3:* = _loc_2.exec(param1);
            if (_loc_3 == null)
            {
                return false;
            }
            return true;
        }// end function

        public static function isEnglish(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = trim(param1);
            var _loc_2:* = /^[A-Za-z]+$""^[A-Za-z]+$/;
            var _loc_3:* = _loc_2.exec(param1);
            if (_loc_3 == null)
            {
                return false;
            }
            return true;
        }// end function

        public static function isChinese(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = trim(param1);
            var _loc_2:* = /^[Α-￥]+$""^[Α-￥]+$/;
            var _loc_3:* = _loc_2.exec(param1);
            if (_loc_3 == null)
            {
                return false;
            }
            return true;
        }// end function

        public static function isDoubleChar(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = trim(param1);
            var _loc_2:* = /^[^\;
            var _loc_3:* = _loc_2.exec(param1);
            if (_loc_3 == null)
            {
                return false;
            }
            return true;
        }// end function

        public static function hasChineseChar(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = trim(param1);
            var _loc_2:* = /[^\;
            var _loc_3:* = _loc_2.exec(param1);
            if (_loc_3 == null)
            {
                return false;
            }
            return true;
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
            param1 = trim(param1);
            var _loc_3:* = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + param2 + "}$", "");
            var _loc_4:* = _loc_3.exec(param1);
            if (_loc_3.exec(param1) == null)
            {
                return false;
            }
            return true;
        }// end function

        public static function isURL(param1:String) : Boolean
        {
            if (param1 == null)
            {
                return false;
            }
            param1 = trim(param1).toLowerCase();
            var _loc_2:* = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\\'':+!]*([^<>\\""\\""])*$""^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
            var _loc_3:* = _loc_2.exec(param1);
            if (_loc_3 == null)
            {
                return false;
            }
            return true;
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
            var _loc_8:int = 0;
            var _loc_2:* = new Array();
            var _loc_3:* = param1.length;
            var _loc_4:uint = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_5 = param1.charCodeAt(_loc_4++);
                switch(_loc_5 >> 4)
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
                        _loc_6 = param1.charCodeAt(_loc_4++);
                        _loc_2[_loc_2.length] = String.fromCharCode((_loc_5 & 31) << 6 | _loc_6 & 63);
                        break;
                    }
                    case 14:
                    {
                        _loc_7 = param1.charCodeAt(_loc_4++);
                        _loc_8 = param1.charCodeAt(_loc_4++);
                        _loc_2[_loc_2.length] = String.fromCharCode((_loc_5 & 15) << 12 | (_loc_7 & 63) << 6 | (_loc_8 & 63) << 0);
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

        public static function autoReturn(param1:String, param2:int) : String
        {
            var _loc_3:* = param1.length;
            if (_loc_3 < 0)
            {
                return "";
            }
            var _loc_4:* = param2;
            var _loc_5:* = param1.substr(0, _loc_4);
            while (_loc_4 <= _loc_3)
            {
                
                _loc_5 = _loc_5 + "\n";
                _loc_5 = _loc_5 + param1.substr(_loc_4, param2);
                _loc_4 = _loc_4 + param2;
            }
            return _loc_5;
        }// end function

        public static function limitStringLengthByByteCount(param1:String, param2:int, param3:String = "...") : String
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:String = null;
            var _loc_7:int = 0;
            var _loc_8:uint = 0;
            if (param1 == null || param1 == "")
            {
                return param1;
            }
            _loc_4 = param1.length;
            _loc_5 = 0;
            _loc_6 = "";
            _loc_7 = 0;
            while (_loc_7 < _loc_4)
            {
                
                _loc_8 = param1.charCodeAt(_loc_7);
                if (_loc_8 > 16777215)
                {
                    _loc_5 = _loc_5 + 4;
                }
                else if (_loc_8 > 65535)
                {
                    _loc_5 = _loc_5 + 3;
                }
                else if (_loc_8 > 255)
                {
                    _loc_5 = _loc_5 + 2;
                }
                else
                {
                    _loc_5++;
                }
                if (_loc_5 < param2)
                {
                    _loc_6 = _loc_6 + param1.charAt(_loc_7);
                }
                else if (_loc_5 == param2)
                {
                    _loc_6 = _loc_6 + param1.charAt(_loc_7);
                    _loc_6 = _loc_6 + param3;
                    break;
                }
                else
                {
                    _loc_6 = _loc_6 + param3;
                    break;
                }
                _loc_7++;
            }
            return _loc_6;
        }// end function

        public static function getCharsArray(param1:String, param2:Boolean) : Array
        {
            var _loc_3:* = param1;
            if (param2 == false)
            {
                _loc_3 = trim(param1);
            }
            return _loc_3.split("");
        }// end function

        public static function getStringBytes(param1:String) : int
        {
            return getStrActualLen(param1);
        }// end function

        public static function substrByByteLen(param1:String, param2:int) : String
        {
            var _loc_6:String = null;
            if (param1 == "" || param1 == null)
            {
                return param1;
            }
            var _loc_3:int = 0;
            var _loc_4:* = param1.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = param1.charAt(_loc_5);
                _loc_3 = _loc_3 + getStrActualLen(_loc_6);
                if (_loc_3 > param2)
                {
                    param1 = param1.substr(0, (_loc_5 - 1));
                    break;
                }
                _loc_5++;
            }
            return param1;
        }// end function

        public static function getStrActualLen(param1:String) : int
        {
            if (param1 == "" || param1 == null)
            {
                return 0;
            }
            return param1.replace(/[^\;
        }// end function

        public static function isEmptyString(param1:String) : Boolean
        {
            return param1 == null || param1 == "";
        }// end function

        public static function isNewlineOrEnter(param1:uint) : Boolean
        {
            return param1 == 13 || param1 == 10;
        }// end function

        public static function removeNewlineOrEnter(param1:String) : String
        {
            param1 = replace(param1, "\n", "");
            return replace(param1, "\r", "");
        }// end function

        public static function escapeNewline(param1:String) : String
        {
            return replace(param1, "\n", NEW_LINE_REPLACER);
        }// end function

        public static function unescapeNewline(param1:String) : String
        {
            return replace(param1, NEW_LINE_REPLACER, "\n");
        }// end function

        public static function judge(param1:String) : String
        {
            var _loc_2:String = "";
            var _loc_3:Boolean = false;
            var _loc_4:Number = 0;
            while (_loc_4 < param1.length)
            {
                
                if (escape(param1.substring(_loc_4, (_loc_4 + 1))).length > 3)
                {
                    _loc_2 = _loc_2 + ("\'" + param1.substring(_loc_4, (_loc_4 + 1)) + "\' ");
                    _loc_3 = true;
                }
                _loc_4 = _loc_4 + 1;
            }
            if (_loc_3)
            {
            }
            return _loc_2;
        }// end function

        public static function changeToBj(param1:String) : String
        {
            var _loc_4:String = null;
            var _loc_5:Number = NaN;
            var _loc_6:String = null;
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:String = "";
            var _loc_3:Number = 0;
            while (_loc_3 < param1.length)
            {
                
                if (escape(param1.substring(_loc_3, (_loc_3 + 1))).length > 3)
                {
                    _loc_4 = param1.substring(_loc_3, (_loc_3 + 1));
                    if (_loc_4.charCodeAt(0) > 60000)
                    {
                        _loc_5 = _loc_4.charCodeAt(0) - 65248;
                        _loc_6 = String.fromCharCode(_loc_5);
                        _loc_2 = _loc_2 + _loc_6;
                    }
                    else if (_loc_4.charCodeAt(0) == 12288)
                    {
                        _loc_2 = _loc_2 + " ";
                    }
                    else
                    {
                        _loc_2 = _loc_2 + param1.substring(_loc_3, (_loc_3 + 1));
                    }
                }
                else
                {
                    _loc_2 = _loc_2 + param1.substring(_loc_3, (_loc_3 + 1));
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        public static function changeToQj(param1:String) : String
        {
            var _loc_4:String = null;
            var _loc_5:Number = NaN;
            var _loc_6:String = null;
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:String = "";
            var _loc_3:Number = 0;
            while (_loc_3 < param1.length)
            {
                
                if (escape(param1.substring(_loc_3, (_loc_3 + 1))).length > 3)
                {
                    _loc_4 = param1.substring(_loc_3, (_loc_3 + 1));
                    if (_loc_4.charCodeAt(0) > 60000)
                    {
                        _loc_5 = _loc_4.charCodeAt(0) + 65248;
                        _loc_6 = String.fromCharCode(_loc_5);
                        _loc_2 = _loc_2 + _loc_6;
                    }
                    else
                    {
                        _loc_2 = _loc_2 + param1.substring(_loc_3, (_loc_3 + 1));
                    }
                }
                else
                {
                    _loc_2 = _loc_2 + param1.substring(_loc_3, (_loc_3 + 1));
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        public static function renewZero(param1:String, param2:int) : String
        {
            var _loc_5:int = 0;
            var _loc_3:String = "";
            var _loc_4:* = param1.length;
            if (param1.length < param2)
            {
                _loc_5 = 0;
                while (_loc_5 < param2 - _loc_4)
                {
                    
                    _loc_3 = _loc_3 + "0";
                    _loc_5++;
                }
                return _loc_3 + param1;
            }
            else
            {
                return param1;
            }
        }// end function

        public static function isUpToRegExp(param1:String, param2:RegExp) : Boolean
        {
            if (param1 != null && param2 != null)
            {
                return param1.match(param2) != null;
            }
            return false;
        }// end function

        public static function isErrorFormatString(param1:String, param2:int = 0) : Boolean
        {
            if (param1 == null || param2 != 0 && param1.length > param2)
            {
                return true;
            }
            return param1.indexOf(String.fromCharCode(0)) != -1;
        }// end function

        public static function getFormatMoney(param1:Number) : String
        {
            var _loc_2:* = param1.toString();
            var _loc_3:* = new Array();
            var _loc_4:Number = -1;
            while (_loc_2.charAt(_loc_2.length + _loc_4) != "")
            {
                
                if (Math.abs(_loc_4 - 2) >= _loc_2.length)
                {
                    _loc_3.push(_loc_2.substr(0, _loc_2.length + _loc_4 + 1));
                }
                else
                {
                    _loc_3.push(_loc_2.substr(_loc_4 - 2, 3));
                }
                _loc_4 = _loc_4 - 3;
            }
            _loc_3.reverse();
            return _loc_3.join(",");
        }// end function

        public static function uintToChineseNumber(param1:uint) : String
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            if (param1 <= 10)
            {
                return String.fromCharCode(ChineseNumberTable[param1]);
            }
            if (param1 < 20)
            {
                return String.fromCharCode(ChineseNumberTable[10], ChineseNumberTable[param1 - 10]);
            }
            if (param1 < 100)
            {
                _loc_2 = Math.floor(param1 / 10);
                _loc_3 = param1 % 10;
                if (_loc_3 > 0)
                {
                    return String.fromCharCode(ChineseNumberTable[_loc_2], ChineseNumberTable[10], ChineseNumberTable[_loc_3]);
                }
                return String.fromCharCode(ChineseNumberTable[_loc_2], ChineseNumberTable[10]);
            }
            else
            {
                return "";
            }
        }// end function

        public static function format(param1:String, ... args) : String
        {
            args = new activation;
            var args:Array;
            var strFormat:* = param1;
            var additionalArgs:* = args;
            args = ;
            var reg:* = /\{(\d+)\}""\{(\d+)\}/g;
            return replace(, function (param1:String, param2:String, param3:int, param4:String) : String
            {
                return args[param2];
            }// end function
            );
        }// end function

        public static function lv1ParseString(param1:String, param2:Function) : Boolean
        {
            var _loc_4:String = null;
            if (param1 == null || param1 == "")
            {
                return false;
            }
            var _loc_3:Boolean = false;
            for each (_loc_4 in param1.split(LV1_Split))
            {
                
                StringUtil.param2(_loc_4);
                _loc_3 = true;
            }
            return _loc_3;
        }// end function

        public static function lv2ParseString(param1:String, param2:Function) : Boolean
        {
            var _loc_4:String = null;
            var _loc_5:Array = null;
            if (param1 == null || param1 == "")
            {
                return false;
            }
            var _loc_3:Boolean = false;
            for each (_loc_4 in param1.split(LV2_Split))
            {
                
                if (_loc_4 != null && _loc_4 == "")
                {
                    _loc_5 = param1.split(LV1_Split);
                    if (_loc_5.length > 1)
                    {
                        StringUtil.param2(_loc_5);
                        _loc_3 = true;
                    }
                }
            }
            return _loc_3;
        }// end function

        public static function getLv1SplitString(param1:Array, param2:Function) : String
        {
            if (param1 == null || param1.length == 0)
            {
                return "";
            }
            var _loc_3:* = param1.length;
            var _loc_4:* = StringUtil.param2(param1[0]);
            var _loc_5:int = 1;
            while (_loc_5 < _loc_3)
            {
                
                _loc_4 = _loc_4 + LV1_Split;
                _loc_4 = _loc_4 + StringUtil.param2(param1[_loc_5]);
                _loc_5++;
            }
            return _loc_4;
        }// end function

        public static function getLv2SplitString(param1:Array, param2:Function) : String
        {
            if (param1 == null || param1.length == 0)
            {
                return "";
            }
            var _loc_3:* = param1.length;
            var _loc_4:* = StringUtil.param2(param1[0], LV2_Split);
            var _loc_5:int = 1;
            while (_loc_5 < _loc_3)
            {
                
                _loc_4 = _loc_4 + LV1_Split;
                _loc_4 = _loc_4 + StringUtil.param2(param1[_loc_5], LV2_Split);
                _loc_5++;
            }
            return _loc_4;
        }// end function

    }
}
