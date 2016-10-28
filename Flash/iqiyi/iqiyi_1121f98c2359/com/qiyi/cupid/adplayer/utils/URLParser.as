package com.qiyi.cupid.adplayer.utils
{
    import flash.utils.*;

    public class URLParser extends Object
    {
        private var _url:String;
        private var _host:String = "";
        private var _port:String = "";
        private var _protocol:String = "";
        private var _path:String = "";
        private var _parameters:Dictionary;
        private var _parameterArray:Array;

        public function URLParser(param1:String)
        {
            this._url = param1;
            this.parse();
            return;
        }// end function

        public function getHost() : String
        {
            return this._host;
        }// end function

        public function getPort() : String
        {
            return this._port;
        }// end function

        public function getProtocol() : String
        {
            return this._protocol;
        }// end function

        public function getPath() : String
        {
            return this._path;
        }// end function

        public function getParameters() : Dictionary
        {
            return this._parameters;
        }// end function

        public function getParameterArray() : Array
        {
            return this._parameterArray;
        }// end function

        private function parse() : void
        {
            var _loc_4:Array = null;
            var _loc_5:String = null;
            var _loc_6:Array = null;
            var _loc_7:Dictionary = null;
            var _loc_1:* = /((?P<protocol>[a-zA-Z]+) : \/\/)?  (?P<host>[^:\/]*) (:(?P<port>\d+))?  ((?P<path>[^?]*))? ((?P<parameters>.*))? ""((?P<protocol>[a-zA-Z]+) : \/\/)?  (?P<host>[^:\/]*) (:(?P<port>\d+))?  ((?P<path>[^?]*))? ((?P<parameters>.*))? /x;
            var _loc_2:* = _loc_1.exec(this._url);
            this._protocol = _loc_2.protocol;
            this._host = _loc_2.host;
            this._port = _loc_2.port;
            this._path = _loc_2.path;
            var _loc_3:* = _loc_2.parameters;
            if (_loc_3 != "")
            {
                if (_loc_3.charAt(0) == "?")
                {
                    _loc_3 = _loc_3.substring(1);
                }
                this._parameters = new Dictionary();
                this._parameterArray = new Array();
                _loc_4 = _loc_3.split("&");
                for each (_loc_5 in _loc_4)
                {
                    
                    _loc_6 = _loc_5.split("=");
                    this._parameters[_loc_6[0]] = _loc_6[1];
                    _loc_7 = new Dictionary();
                    _loc_7["key"] = _loc_6[0];
                    _loc_7["value"] = _loc_6[1];
                    this._parameterArray.push(_loc_7);
                }
            }
            return;
        }// end function

    }
}
