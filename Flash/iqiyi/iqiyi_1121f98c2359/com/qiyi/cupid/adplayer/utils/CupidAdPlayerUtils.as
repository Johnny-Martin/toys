package com.qiyi.cupid.adplayer.utils
{
    import flash.external.*;
    import flash.net.*;

    public class CupidAdPlayerUtils extends Object
    {

        public function CupidAdPlayerUtils()
        {
            return;
        }// end function

        public static function saveBaseCookie(param1:String, param2:String, param3:Object) : void
        {
            var so:SharedObject;
            var file:* = param1;
            var field:* = param2;
            var data:* = param3;
            try
            {
                so = SharedObject.getLocal(file, "/");
                so.data[field] = data;
                so.flush();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public static function getBaseCookie(param1:String, param2:String) : Object
        {
            var so:SharedObject;
            var file:* = param1;
            var field:* = param2;
            var data:Object;
            try
            {
                so = SharedObject.getLocal(file, "/");
                data = so.data[field];
            }
            catch (e:Error)
            {
            }
            return data;
        }// end function

        public static function getDefaultBlackScreenDuration(param1:String) : int
        {
            var _loc_2:int = 15;
            var _loc_3:Array = ["qc_100001_100014", "qc_100001_100015", "qc_100001_100016", "qc_100001_100041", "qc_100001_100042", "qc_100001_100044"];
            var _loc_4:Array = ["qc_100001_100002", "qc_100001_100012", "qc_100001_100018", "qc_100001_100071", "qc_100001_100089"];
            if (_loc_3.indexOf(param1) != -1)
            {
                _loc_2 = 45;
            }
            else if (_loc_4.indexOf(param1) != -1)
            {
                _loc_2 = 30;
            }
            return _loc_2;
        }// end function

        public static function getUserAgent() : String
        {
            var agent:String;
            try
            {
                if (ExternalInterface.available)
                {
                    agent = ExternalInterface.call("function(){return navigator.userAgent.toLocaleLowerCase();}") as String;
                }
            }
            catch (e:Error)
            {
            }
            return agent;
        }// end function

        public static function getLocation() : String
        {
            var location:String;
            try
            {
                if (ExternalInterface.available)
                {
                    location = ExternalInterface.call("function(){" + "if(top.location.href){" + "return top.location.href;" + "}" + "return document.location.href;" + "}") as String;
                }
            }
            catch (e:Error)
            {
            }
            return location ? (location) : ("");
        }// end function

        public static function getReferrer() : String
        {
            var referrer:String;
            try
            {
                if (ExternalInterface.available)
                {
                    referrer = ExternalInterface.call("function(){return document.referrer;}") as String;
                }
            }
            catch (e:Error)
            {
            }
            return referrer ? (referrer) : ("");
        }// end function

    }
}
