package com.qiyi.player.base.uuid
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class UUIDManager extends EventDispatcher
    {
        private const COOKIE:String = "qiyi_statistics";
        private const UUID_URL:String = "http://data.video.qiyi.com/uid";
        private const MAX_RETRY:int = 3;
        private var _inited:Boolean = false;
        private var _uuid:String = "";
        private var _webEventId:String = "";
        private var _videoEventID:String = "";
        private var _isNewUser:Boolean = false;
        private var _loader:URLLoader;
        private var _curRetryCount:int = 0;
        private var _timeout:uint = 0;
        public static const READY:String = "ready";
        private static var _instance:UUIDManager = null;

        public function UUIDManager(param1:SingletonClass)
        {
            this.load();
            return;
        }// end function

        public function load() : void
        {
            if (!this._inited)
            {
                this.loadFromLocal();
                if (this._uuid == null || this._uuid.length != 32)
                {
                    this.loadFromServer();
                }
                this._inited = true;
            }
            return;
        }// end function

        public function get uuid() : String
        {
            if (this._uuid)
            {
                return this._uuid;
            }
            return "";
        }// end function

        public function get isNewUser() : Boolean
        {
            return this._isNewUser;
        }// end function

        public function set isNewUser(param1:Boolean) : void
        {
            this._isNewUser = param1;
            return;
        }// end function

        public function buildVideoEventID() : void
        {
            this._videoEventID = MD5.calculate(this._uuid + getTimer() + Math.random());
            return;
        }// end function

        public function getVideoEventID() : String
        {
            return this._videoEventID;
        }// end function

        public function setWebEventID(param1:String) : void
        {
            this._webEventId = param1;
            return;
        }// end function

        public function getWebEventID() : String
        {
            return this._webEventId;
        }// end function

        private function loadFromLocal() : void
        {
            var so:SharedObject;
            try
            {
                so = SharedObject.getLocal(this.COOKIE, "/");
                this._uuid = so.data.uuid;
                if (this._uuid == null || this._uuid.length != 32 || IDFilter.inList(this._uuid))
                {
                    this._uuid = "";
                    so.data.uuid = this._uuid;
                    so.flush();
                }
            }
            catch (e:Error)
            {
                _uuid = "";
            }
            return;
        }// end function

        private function loadFromServer() : void
        {
            this._isNewUser = true;
            if (this._loader)
            {
                this._loader.removeEventListener(Event.COMPLETE, this.onCompleteHandler);
                this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onErrorHander);
                this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHander);
            }
            this._loader = new URLLoader();
            this._loader.addEventListener(Event.COMPLETE, this.onCompleteHandler);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.onErrorHander);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHander);
            clearTimeout(this._timeout);
            this._timeout = setTimeout(this.onErrorHander, 2000);
            this._loader.load(new URLRequest(this.UUID_URL + "?tn=" + Math.random()));
            return;
        }// end function

        private function retry() : void
        {
            if (this._curRetryCount < this.MAX_RETRY)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._curRetryCount + 1;
                _loc_1._curRetryCount = _loc_2;
                this.loadFromServer();
            }
            else
            {
                this.onCompleteHandler();
            }
            return;
        }// end function

        private function onErrorHander(event:Event = null) : void
        {
            clearTimeout(this._timeout);
            this.retry();
            return;
        }// end function

        private function onCompleteHandler(event:Event = null) : void
        {
            var strContent:String;
            var indexLift:int;
            var indexRight:int;
            var obj:Object;
            var so:SharedObject;
            var event:* = event;
            clearTimeout(this._timeout);
            this.loadFromLocal();
            if (this._uuid)
            {
                dispatchEvent(new Event(READY));
            }
            else
            {
                try
                {
                    if (event)
                    {
                        strContent = this._loader.data;
                        indexLift = strContent.indexOf("{");
                        indexRight = strContent.indexOf("}", -1);
                        strContent = strContent.slice(indexLift, (indexRight + 1));
                        obj = JSON.decode(strContent);
                        this._uuid = obj.uid;
                    }
                    else
                    {
                        this._uuid = "";
                    }
                }
                catch (e:Error)
                {
                    _uuid = "";
                }
                if (this._uuid == null || this._uuid == "")
                {
                    this._uuid = UUID.createUUID();
                }
                try
                {
                    so = SharedObject.getLocal(this.COOKIE, "/");
                    so.data.uuid = this._uuid;
                    so.flush();
                }
                catch (e:Error)
                {
                }
                dispatchEvent(new Event(READY));
            }
            return;
        }// end function

        public static function get instance() : UUIDManager
        {
            if (_instance == null)
            {
                _instance = new UUIDManager(new SingletonClass());
            }
            return _instance;
        }// end function

    }
}

class SingletonClass extends Object
{

    function SingletonClass()
    {
        return;
    }// end function

}

