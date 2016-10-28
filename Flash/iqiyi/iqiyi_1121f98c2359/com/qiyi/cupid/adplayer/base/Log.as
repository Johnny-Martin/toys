package com.qiyi.cupid.adplayer.base
{
    import com.adobe.serialization.json.*;
    import flash.external.*;

    public class Log extends Object
    {
        private var name:String;
        private var label:String;
        private var color:String;
        private var isEnabled:Boolean = false;
        public static var logs:Array = [];
        private static const INHERIT:String = "color:inherit";
        private static const PREFIX:String = "ad:flash:loader:";
        private static const LS_KEY:String = "addebug";
        private static const MAX_LOG_LEN:int = 3000;
        private static const COLORS:Array = "lightseagreen forestgreen goldenrod dodgerblue darkorchid crimson".split(" ").reverse();
        private static var colorIndex:int = 0;
        private static var names:Array = [];
        private static var skips:Array = [];
        private static var prev:Number;
        private static var curr:Number;
        private static var ms:Number;

        public function Log(param1:String)
        {
            this.name = param1;
            this.isEnabled = shouldEnable(param1);
            if (this.isEnabled)
            {
                this.label = PREFIX + param1;
                this.color = getColor();
            }
            return;
        }// end function

        public function debug(... args) : void
        {
            this.console("debug", args);
            return;
        }// end function

        public function error(... args) : void
        {
            this.console("error", args);
            return;
        }// end function

        public function log(... args) : void
        {
            this.console("log", args);
            return;
        }// end function

        public function info(... args) : void
        {
            this.console("info", args);
            return;
        }// end function

        public function warn(... args) : void
        {
            this.console("warn", args);
            return;
        }// end function

        private function console(param1:String, param2:Array) : void
        {
            var level:* = param1;
            var args:* = param2;
            saveLogs(this.name, args);
            if (!this.isEnabled)
            {
                return;
            }
            curr = new Date().time;
            ms = curr - (prev || curr);
            prev = curr;
            var main:* = "%c" + this.label + "%c";
            var arr:Array;
            var i:int;
            while (i < args.length)
            {
                
                arr.push(args[i]);
                main = main + " %o";
                i = (i + 1);
            }
            arr.push(this.color);
            main = main + ("%c +" + ms + "ms");
            arr[0] = main;
            var jsonp:* = arr.map(function (param1, param2, param3) : String
            {
                var item:* = param1;
                var i:* = param2;
                var arr:* = param3;
                try
                {
                    return JSON.encode(item);
                }
                catch (ignore:Error)
                {
                }
                return "";
            }// end function
            ).join(", ");
            jsonp = "function(){console." + level + "(" + jsonp + ")}";
            safeExec(jsonp);
            return;
        }// end function

        private static function getColor() : String
        {
            return "color:" + COLORS[colorIndex++ % COLORS.length];
        }// end function

        private static function shouldEnable(param1:String) : Boolean
        {
            var _loc_2:int = 0;
            var _loc_3:RegExp = null;
            _loc_2 = 0;
            do
            {
                
                if (_loc_3.test(param1))
                {
                    return false;
                }
                var _loc_4:* = skips[_loc_2++];
                _loc_3 = skips[_loc_2++];
            }while (_loc_4)
            _loc_2 = 0;
            do
            {
                
                if (_loc_3.test(param1))
                {
                    return true;
                }
                var _loc_4:* = names[_loc_2++];
                _loc_3 = names[_loc_2++];
            }while (_loc_4)
            return false;
        }// end function

        private static function getTime() : String
        {
            var _loc_1:* = new Date();
            var _loc_2:* = (_loc_1.month + 1) + "-" + _loc_1.date;
            return _loc_2 + " " + [_loc_1.hours, _loc_1.minutes, _loc_1.seconds, _loc_1.milliseconds].join(":");
        }// end function

        private static function saveLogs(param1:String, param2:Array) : void
        {
            var _loc_3:Array = ["[" + getTime() + " " + param1 + "]"];
            _loc_3.push.apply(_loc_3, param2);
            logs.push(_loc_3);
            if (logs.length > MAX_LOG_LEN)
            {
                logs.shift();
            }
            return;
        }// end function

        private static function init() : void
        {
            var _loc_4:String = null;
            var _loc_1:* = getLocalStorage();
            if (!_loc_1)
            {
                return;
            }
            var _loc_2:* = _loc_1.split(/[\s,]+""[\s,]+/);
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_4 = _loc_2[_loc_3];
                if (!_loc_4)
                {
                }
                else
                {
                    _loc_4 = _loc_4.replace(/\*""\*/g, ".*?");
                    if (_loc_4.charAt(0) == "-")
                    {
                        skips.push(new RegExp("^" + _loc_4.substr(1) + "$"));
                    }
                    else
                    {
                        names.push(new RegExp("^" + _loc_4 + "$"));
                    }
                }
                _loc_3++;
            }
            return;
        }// end function

        private static function getLocalStorage() : String
        {
            var _loc_1:* = "function(arr) {" + "var ls = window.localStorage || {};" + "return ls." + LS_KEY + "}";
            return safeExec(_loc_1) || "";
        }// end function

        private static function safeExec(... args)
        {
            args = new activation;
            var args:* = args;
            try
            {
                if (ExternalInterface.available)
                {
                    return ExternalInterface.call.apply(ExternalInterface, );
                }
            }
            catch (ignore:Error)
            {
            }
            return;
        }// end function

        init();
    }
}
