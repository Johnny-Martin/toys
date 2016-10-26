package test
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class UploadLog extends EventDispatcher
    {
        private var urlLoader:URLLoader;
        public var sendToUrl:String = "http://220.181.118.178/flashlog3.php";
        private var logBuffer:Array;
        public static const LOGSERVERURL:String = "http://220.181.118.178/flashlog3.php";

        public function UploadLog()
        {
            this.logBuffer = new Array();
            return;
        }// end function

        public function UpLoadLog() : void
        {
            return;
        }// end function

        private function setup() : void
        {
            if (this.urlLoader == null)
            {
                this.urlLoader = new URLLoader();
            }
            if (this.urlLoader != null)
            {
                this.urlLoader.addEventListener(Event.COMPLETE, this.sendComplete);
                this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.sendIOError);
                this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.sendSecurityError);
            }
            return;
        }// end function

        private function cleanup() : void
        {
            if (this.urlLoader != null)
            {
                this.urlLoader.removeEventListener(Event.COMPLETE, this.sendComplete);
                this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.sendIOError);
                this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.sendSecurityError);
                this.urlLoader.close();
                this.urlLoader = null;
            }
            return;
        }// end function

        public function pushLogString(param1:String, param2:String, param3:Boolean = false, param4:String = "http://220.181.118.178/flashlog3.php") : void
        {
            var _loc_5:* = param2;
            this._pushLog(param1, _loc_5, param3, param4, "String");
            return;
        }// end function

        public function pushLogByteArray(param1:String, param2:ByteArray, param3:Boolean = false, param4:String = "http://220.181.118.178/flashlog3.php") : void
        {
            var _loc_5:uint = 0;
            if (param2 != null)
            {
                _loc_5 = param2.position;
                this._pushLog(param1, Base64.encodeByteArray(param2), param3, param4, "ByteArray");
                param2.position = _loc_5;
            }
            return;
        }// end function

        private function _pushLog(param1:String, param2:String, param3:Boolean, param4:String, param5:String) : void
        {
            var _loc_7:Object = null;
            var _loc_6:* = this.logBuffer.length;
            if (this.logBuffer.length > 0 && "filename" in this.logBuffer[(_loc_6 - 1)] && this.logBuffer[(_loc_6 - 1)]["filename"] == param1 && "overrideOld" in this.logBuffer[(_loc_6 - 1)] && this.logBuffer[(_loc_6 - 1)]["overrideOld"] == false && param3 == false && "url" in this.logBuffer[(_loc_6 - 1)] && this.logBuffer[(_loc_6 - 1)]["url"] == param4 && "type" in this.logBuffer[(_loc_6 - 1)] && this.logBuffer[(_loc_6 - 1)]["type"] == "String" && param5 == "String")
            {
                if ("data" in this.logBuffer[(_loc_6 - 1)])
                {
                    this.logBuffer[(_loc_6 - 1)]["data"] = this.logBuffer[(_loc_6 - 1)]["data"] + "\n" + param2;
                }
                else
                {
                    this.logBuffer[(_loc_6 - 1)]["data"] = param2;
                }
            }
            else
            {
                _loc_7 = new Object();
                _loc_7["filename"] = param1;
                _loc_7["data"] = param2;
                _loc_7["overrideOld"] = param3;
                _loc_7["url"] = param4;
                _loc_7["type"] = param5;
                this.logBuffer.push(_loc_7);
            }
            if (this.urlLoader == null)
            {
                this.setup();
                _loc_7 = this.logBuffer.shift();
                this._sendBufferedLog(_loc_7);
            }
            return;
        }// end function

        private function sendComplete(event:Event) : void
        {
            var _loc_2:Object = null;
            if (this.logBuffer.length > 0)
            {
                _loc_2 = this.logBuffer.shift();
                this._sendBufferedLog(_loc_2);
            }
            else
            {
                this.cleanup();
            }
            return;
        }// end function

        private function sendIOError(event:IOErrorEvent) : void
        {
            var _loc_2:Object = null;
            trace(event);
            if (this.urlLoader != null)
            {
                this.cleanup();
            }
            if (this.logBuffer.length > 0)
            {
                this.setup();
                _loc_2 = this.logBuffer.shift();
                this._sendBufferedLog(_loc_2);
            }
            return;
        }// end function

        private function sendSecurityError(event:SecurityErrorEvent) : void
        {
            var _loc_2:Object = null;
            trace(event);
            if (this.urlLoader != null)
            {
                this.cleanup();
            }
            if (this.logBuffer.length > 0)
            {
                this.setup();
                _loc_2 = this.logBuffer.shift();
                this._sendBufferedLog(_loc_2);
            }
            return;
        }// end function

        private function _sendBufferedLog(param1:Object) : void
        {
            var _loc_2:* = new URLVariables();
            _loc_2["filename"] = param1["filename"];
            _loc_2["data"] = param1["data"];
            _loc_2["type"] = param1["type"];
            if (param1["overrideOld"])
            {
                _loc_2["mode"] = "override";
            }
            else
            {
                _loc_2["mode"] = "append";
            }
            var _loc_3:* = new URLRequest(param1["url"]);
            _loc_3.data = _loc_2;
            _loc_3.method = URLRequestMethod.POST;
            this.urlLoader.load(_loc_3);
            _loc_2 = null;
            return;
        }// end function

        private static function _sendNoBuffer(param1:String, param2:String, param3:Boolean, param4:String, param5:String) : void
        {
            var _loc_6:* = new URLVariables();
            new URLVariables()["filename"] = param1;
            _loc_6["data"] = param2;
            _loc_6["type"] = param5;
            if (param3)
            {
                _loc_6["mode"] = "override";
            }
            else
            {
                _loc_6["mode"] = "append";
            }
            var _loc_7:* = new URLRequest(param4);
            new URLRequest(param4).data = _loc_6;
            _loc_7.method = URLRequestMethod.POST;
            try
            {
                sendToURL(_loc_7);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public static function sendStringNoBuffer(param1:String, param2:String, param3:Boolean = false, param4:String = "http://220.181.118.178/flashlog3.php") : void
        {
            _sendNoBuffer(param1, param2, param3, param4, "String");
            return;
        }// end function

        public static function sendByteArrayNoBuffer(param1:String, param2:ByteArray, param3:Boolean = false, param4:String = "http://220.181.118.178/flashlog3.php") : void
        {
            var _loc_5:uint = 0;
            if (param2 != null)
            {
                _loc_5 = param2.position;
                _sendNoBuffer(param1, Base64.encodeByteArray(param2), param3, param4, "ByteArray");
                param2.position = _loc_5;
            }
            return;
        }// end function

    }
}
