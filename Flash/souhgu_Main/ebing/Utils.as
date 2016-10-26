package ebing
{
    import ebing.external.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class Utils extends Object
    {

        public function Utils() : void
        {
            trace("ok");
            return;
        }// end function

        public static function fomatTime(param1:Number) : String
        {
            var _loc_2:* = param1 / 60;
            var _loc_3:* = String(Math.floor(_loc_2));
            var _loc_4:* = String(Math.floor(param1 % 60));
            if (_loc_3.length == 1)
            {
                _loc_3 = "0" + _loc_3;
            }
            if (_loc_4.length == 1)
            {
                _loc_4 = "0" + _loc_4;
            }
            return _loc_3 + ":" + _loc_4;
        }// end function

        public static function fomatSpeed(param1:Number, param2:Boolean = true)
        {
            var _loc_5:Object = null;
            param1 = isNaN(param1) ? (0) : (param1);
            var _loc_3:Number = 0;
            var _loc_4:String = "";
            if (param1 >= Math.pow(1024, 3))
            {
                _loc_3 = param1 / Math.pow(1024, 3);
                _loc_4 = "GBPS";
            }
            else if (param1 >= Math.pow(1024, 2))
            {
                _loc_3 = param1 / Math.pow(1024, 2);
                _loc_4 = "MBPS";
            }
            else if (param1 >= 1024)
            {
                _loc_3 = param1 / 1024;
                _loc_4 = "KBPS";
            }
            else
            {
                _loc_3 = param1;
                _loc_4 = "BPS";
            }
            _loc_3 = numberFormat(_loc_3, 2);
            if (param2)
            {
                return _loc_3 + _loc_4;
            }
            _loc_5 = {speed:_loc_3, units:_loc_4};
            return _loc_5;
        }// end function

        public static function clone(param1:Object)
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeObject(param1);
            _loc_2.position = 0;
            return _loc_2.readObject();
        }// end function

        public static function debug(param1:String) : void
        {
            return;
        }// end function

        public static function alert(param1:String) : void
        {
            if (Eif.available)
            {
                ExternalInterface.call("alert", param1);
            }
            return;
        }// end function

        public static function drawRect(param1, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
        {
            param1.graphics.beginFill(param6, param7);
            param1.graphics.drawRect(param2, param3, param4, param5);
            param1.graphics.endFill();
            return;
        }// end function

        public static function drawRoundRect(param1, param2:Number, param3:Number, param4:Number, param5:Number, param6, param7:Number, param8:Number) : void
        {
            param1.graphics.beginFill(param7, param8);
            param1.graphics.drawRoundRect(param2, param3, param4, param5, param6);
            param1.graphics.endFill();
            return;
        }// end function

        public static function drawCircle(param1, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
        {
            param1.graphics.beginFill(param5, param6);
            param1.graphics.drawCircle(param2, param3, param4);
            param1.graphics.endFill();
            return;
        }// end function

        public static function numberFormat(param1:Number, param2:uint) : Number
        {
            var _loc_4:uint = 0;
            var _loc_3:String = "1";
            var _loc_5:uint = 0;
            while (_loc_5 < param2)
            {
                
                _loc_3 = _loc_3 + "0";
                _loc_5 = _loc_5 + 1;
            }
            _loc_4 = uint(_loc_3);
            return Math.round(param1 * _loc_4) / _loc_4;
        }// end function

        public static function prorata(param1:Object, param2:Number, param3:Number) : void
        {
            if (param1.width / param1.height > param2 / param3)
            {
                param1.height = param2 / param1.width * param1.height;
                param1.width = param2;
            }
            else if (param1.width / param1.height < param2 / param3)
            {
                param1.width = param3 / param1.height * param1.width;
                param1.height = param3;
            }
            else
            {
                param1.width = param2;
                param1.height = param3;
            }
            return;
        }// end function

        public static function setCenterByNumber(param1:Object, param2:Number, param3:Number) : void
        {
            param1.x = Math.round((param2 - param1.width) / 2);
            param1.y = Math.round((param3 - param1.height) / 2);
            return;
        }// end function

        public static function setCenter(param1:Object, param2:Object) : void
        {
            param1.x = Math.round(param2.x + (param2.width - param1.width) / 2);
            param1.y = Math.round(param2.y + (param2.height - param1.height) / 2);
            return;
        }// end function

        public static function getMaxWidth(param1:Array) : Number
        {
            var K10260369E26E3832DE47FC97D12D2F3AE5C517373566K:Number;
            var ele:* = param1;
            K10260369E26E3832DE47FC97D12D2F3AE5C517373566K;
            if (ele.length > 0)
            {
                K10260369E26E3832DE47FC97D12D2F3AE5C517373566K = ele[0].width;
                ele.forEach(function (param1, param2:int, param3:Array) : void
            {
                var _loc_4:* = param1.width;
                if (param1.width > K10260369E26E3832DE47FC97D12D2F3AE5C517373566K)
                {
                    K10260369E26E3832DE47FC97D12D2F3AE5C517373566K = _loc_4;
                }
                return;
            }// end function
            );
            }
            return K10260369E26E3832DE47FC97D12D2F3AE5C517373566K;
        }// end function

        public static function getMaxHeight(param1:Array) : Number
        {
            var K102603EAD02531CD994919907D63F217355FFB373566K:Number;
            var ele:* = param1;
            K102603EAD02531CD994919907D63F217355FFB373566K;
            if (ele.length > 0)
            {
                K102603EAD02531CD994919907D63F217355FFB373566K = ele[0].height;
                ele.forEach(function (param1, param2:int, param3:Array) : void
            {
                var _loc_4:* = param1.height;
                if (param1.height > K102603EAD02531CD994919907D63F217355FFB373566K)
                {
                    K102603EAD02531CD994919907D63F217355FFB373566K = _loc_4;
                }
                return;
            }// end function
            );
            }
            return K102603EAD02531CD994919907D63F217355FFB373566K;
        }// end function

        public static function showHorizontalList(param1:uint, param2:Class, param3:String, param4, param5:uint, param6:uint, param7:uint, param8:uint, param9:Number = -1, param10:Number = 1, param11:Boolean = true) : Array
        {
            var _loc_15:* = undefined;
            var _loc_16:* = undefined;
            var _loc_12:* = param9 != -1 ? (param9) : (param7);
            var _loc_13:* = new Array();
            var _loc_14:uint = 0;
            while (_loc_14 < param1)
            {
                
                _loc_15 = new (param2 as Class)();
                var _loc_17:* = param10;
                _loc_15.scaleY = param10;
                new (param2 as Class)().scaleX = _loc_17;
                _loc_15["index"] = _loc_14;
                _loc_13[_loc_14] = _loc_15;
                _loc_15.visible = param11;
                param4.addChild(_loc_15);
                _loc_16 = _loc_15;
                if (_loc_14 == 0)
                {
                    _loc_16.x = param5;
                    _loc_16.y = param6;
                }
                else if (_loc_14 % param8 != 0)
                {
                    _loc_16.x = _loc_13[(_loc_14 - 1)].x + _loc_13[(_loc_14 - 1)].width + param7;
                    _loc_16.y = _loc_13[(_loc_14 - 1)].y;
                }
                else
                {
                    _loc_16.x = _loc_13[0].x;
                    _loc_16.y = _loc_13[(_loc_14 - 1)].y + _loc_13[(_loc_14 - 1)].height + _loc_12;
                }
                _loc_14 = _loc_14 + 1;
            }
            return _loc_13;
        }// end function

        public static function createUID() : String
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_1:String = "";
            var _loc_2:String = "0123456789abcdef";
            _loc_3 = 0;
            while (_loc_3 < 8)
            {
                
                _loc_1 = _loc_1 + _loc_2.charAt(Math.round(Math.random() * 15));
                _loc_3++;
            }
            _loc_3 = 0;
            while (_loc_3 < 3)
            {
                
                _loc_1 = _loc_1 + "-";
                _loc_4 = 0;
                while (_loc_4 < 4)
                {
                    
                    _loc_1 = _loc_1 + _loc_2.charAt(Math.round(Math.random() * 15));
                    _loc_4++;
                }
                _loc_3++;
            }
            _loc_1 = _loc_1 + "-";
            var _loc_5:* = new Date().getTime();
            _loc_1 = _loc_1 + ("000000000" + _loc_5.toString(16)).substr(-8);
            _loc_3 = 0;
            while (_loc_3 < 4)
            {
                
                _loc_1 = _loc_1 + _loc_2.charAt(Math.round(Math.random() * 15));
                _loc_3++;
            }
            return _loc_1;
        }// end function

        public static function getType(param1:String, param2:String) : String
        {
            var _loc_3:* = param1.split(param2);
            var _loc_4:* = _loc_3[(_loc_3.length - 1)].split("&");
            var _loc_5:* = _loc_3[(_loc_3.length - 1)].split("&")[0].split("?");
            return _loc_3[(_loc_3.length - 1)].split("&")[0].split("?")[0];
        }// end function

        public static function openWindow(param1:String, param2:String = "_blank", param3:String = "") : Boolean
        {
            var url:* = param1;
            var window:* = param2;
            var features:* = param3;
            var K1026034FAE6215F1184E7C820792AAB29CE5E7373566K:* = new URLRequest(url);
            window = window;
            var boo:Boolean;
            if (!Eif.available)
            {
                if (ExternalInterface.available)
                {
                    try
                    {
                        navigateToURL(K1026034FAE6215F1184E7C820792AAB29CE5E7373566K, window);
                        boo;
                    }
                    catch (evt:Error)
                    {
                        boo;
                    }
                }
                else
                {
                    boo;
                }
            }
            else
            {
                try
                {
                    ExternalInterface.call("function(){window.open(\'" + url + "\',\'" + window + "\');}");
                    boo;
                }
                catch (e:Error)
                {
                    boo;
                }
            }
            return boo;
        }// end function

        public static function trim(param1:String) : String
        {
            return param1.replace(/(^\s*)|(\s*$)""(^\s*)|(\s*$)/g, "");
        }// end function

        public static function maxCharsLimit(param1:String, param2:uint, param3:Boolean = false) : String
        {
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_4:* = /[^\;
            if (param1.replace(_loc_4, "mm").length > param2)
            {
                _loc_5 = Math.floor(param2 / 2);
                _loc_6 = _loc_5;
                while (_loc_6 < param1.length)
                {
                    
                    if (param1.substr(0, _loc_6).replace(_loc_4, "mm").length >= param2)
                    {
                        return param1.substr(0, _loc_6) + (param3 ? ("...") : (""));
                    }
                    _loc_6 = _loc_6 + 1;
                }
            }
            return param1;
        }// end function

        public static function getBrowserCookie(param1:String) : String
        {
            var _loc_3:String = null;
            var _loc_4:Array = null;
            var _loc_5:uint = 0;
            var _loc_6:Array = null;
            var _loc_2:String = "";
            if (Eif.available)
            {
                _loc_3 = ExternalInterface.call("function(){return document.cookie;}");
                if (_loc_3 != null && _loc_3 != "undefined" && _loc_3 != "")
                {
                    _loc_4 = _loc_3.split(";");
                    _loc_5 = 0;
                    while (_loc_5 < _loc_4.length)
                    {
                        
                        _loc_6 = _loc_4[_loc_5].split("=");
                        if (_loc_6.length > 0)
                        {
                            if (trim(_loc_6[0]) == param1)
                            {
                                _loc_2 = _loc_6[1];
                            }
                        }
                        _loc_5 = _loc_5 + 1;
                    }
                }
            }
            return _loc_2;
        }// end function

        public static function RegExpVersion() : Object
        {
            var _loc_1:* = new Object();
            var _loc_2:* = /^(?P<platform>(\w+)) (?P<majorVersion>(\d+)),(?P<minorVersion>(\d+)),(?P<buildNumber>(\d+)),(?P<internalBuildNumber>(\d+))$""^(?P<platform>(\w+)) (?P<majorVersion>(\d+)),(?P<minorVersion>(\d+)),(?P<buildNumber>(\d+)),(?P<internalBuildNumber>(\d+))$/i;
            _loc_1 = _loc_2.exec(Capabilities.version);
            return _loc_1;
        }// end function

        public static function getJSVar(param1:String) : String
        {
            return ExternalInterface.call("function(){return " + param1 + ";}", null);
        }// end function

        public static function cleanVar(param1:String) : String
        {
            var _loc_2:* = new String();
            var _loc_3:int = 0;
            while (_loc_3 < param1.length)
            {
                
                if (param1.charAt(_loc_3) != "\n" && param1.charAt(_loc_3) != "\r")
                {
                    _loc_2 = _loc_2 + param1.charAt(_loc_3);
                }
                _loc_3++;
            }
            while (_loc_2.charAt((_loc_2.length - 1)) == " ")
            {
                
                _loc_2 = _loc_2.slice(0, -1);
            }
            while (_loc_2.charAt(0) == " ")
            {
                
                _loc_2 = _loc_2.slice(1);
            }
            return _loc_2;
        }// end function

        public static function cleanTrim(param1:String) : String
        {
            return param1.replace(/\s""\s/g, "");
        }// end function

        public static function cleanUnderline(param1:String) : String
        {
            var _loc_2:* = param1.split("_")[0];
            return _loc_2;
        }// end function

    }
}
