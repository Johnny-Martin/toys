package loader.vod
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class P2PFileLoader extends EventDispatcher
    {
        private var _loader:URLLoader;
        private var _loadErr:Boolean = false;
        private var _loadDone:Boolean = false;
        private var _isLoading:Boolean = false;
        private var _retryCount:int = 0;
        private var _retryTimeout:uint;
        private var _url:String = "http://dispatcher.video.qiyi.com/dispn/flashppdp.swf";
        private var _instanceClass:Class = null;
        private var _domain:ApplicationDomain = null;
        private var _startTime:uint = 0;
        private var _fileIndex:uint = 0;
        private var _dict:Dictionary;
        public static const LoadCorePingBack:String = "http://msg.video.qiyi.com/vodpb.gif?url=";
        public static const retryMaxCount:int = 3;
        public static const Evt_LoadDone:String = "Evt_LoadDone";
        public static const Evt_LoadError:String = "Evt_LoadError";
        private static var _instance:P2PFileLoader;

        public function P2PFileLoader(param1:SingletonClass)
        {
            this._dict = new Dictionary();
            return;
        }// end function

        public function loadCore(param1:String = "") : void
        {
            var done:Function;
            var $url:* = param1;
            done = function () : void
            {
                _isLoading = false;
                _loadDone = true;
                dispatchEvent(new Event(Evt_LoadDone));
                return;
            }// end function
            ;
            if (this._domain != null)
            {
                try
                {
                    this._instanceClass = this._domain.getDefinition("com.iqiyi.file.File") as Class;
                    if (this._instanceClass != null)
                    {
                        this._isLoading = true;
                        setTimeout(done, 10);
                        return;
                    }
                }
                catch ($err)
                {
                    _instanceClass = null;
                }
                try
                {
                }
                this._instanceClass = ApplicationDomain.currentDomain.getDefinition("com.iqiyi.file.File") as Class;
                if (this._instanceClass != null)
                {
                    this._isLoading = true;
                    setTimeout(done, 10);
                    return;
                }
            }
            catch ($err)
            {
                _instanceClass = null;
            }
            if ($url != "")
            {
                this._url = $url;
            }
            Security.allowDomain("*");
            this._loader = new URLLoader();
            this._loader.dataFormat = URLLoaderDataFormat.BINARY;
            this._loader.addEventListener(Event.COMPLETE, this.onCoreComplete);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            this._loader.load(new URLRequest(this._url));
            this._isLoading = true;
            this._startTime = getTimer();
            return;
        }// end function

        private function onCoreComplete(event:Event) : void
        {
            var swfLoader:Loader;
            var done:Function;
            var $event:* = event;
            done = function (event:Event) : void
            {
                sendToURL(new URLRequest(LoadCorePingBack + _url + "&tag=done&curl=" + _url + "&useTime=" + (getTimer() - _startTime) + "&dur=" + getTimer()));
                _isLoading = false;
                swfLoader.removeEventListener(Event.COMPLETE, done);
                _instanceClass = _domain.getDefinition("com.iqiyi.file.File") as Class;
                _loadDone = true;
                dispatchEvent(new Event(Evt_LoadDone));
                return;
            }// end function
            ;
            this._loader.removeEventListener(Event.COMPLETE, this.onCoreComplete);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            swfLoader = new Loader();
            swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, done);
            this._domain = new ApplicationDomain();
            var context:* = new LoaderContext(false, this._domain);
            swfLoader.loadBytes(this._loader.data as ByteArray, context);
            return;
        }// end function

        private function onError(param1) : void
        {
            this._loader.removeEventListener(Event.COMPLETE, this.onCoreComplete);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            clearTimeout(this._retryTimeout);
            this._retryTimeout = setTimeout(this.retry, 1000);
            return;
        }// end function

        private function retry() : void
        {
            clearTimeout(this._retryTimeout);
            var _loc_1:String = this;
            var _loc_2:* = this._retryCount + 1;
            _loc_1._retryCount = _loc_2;
            if (this._retryCount > retryMaxCount)
            {
                sendToURL(new URLRequest(LoadCorePingBack + this._url + "&tag=lost&curl=" + this._url + "&useTime=" + (getTimer() - this._startTime) + "&dur=" + getTimer()));
                this._loadErr = true;
                this._isLoading = false;
                this._loadDone = false;
                dispatchEvent(new Event(Evt_LoadError));
                return;
            }
            this._loader.load(new URLRequest(this._url + "?rn=" + getTimer()));
            return;
        }// end function

        public function getFile() : File
        {
            if (this._instanceClass == null)
            {
                return null;
            }
            this._dict[this._fileIndex.toString()] = new this._instanceClass();
            var _loc_1:* = new File(this._fileIndex.toString());
            var _loc_2:String = this;
            var _loc_3:* = this._fileIndex + 1;
            _loc_2._fileIndex = _loc_3;
            return _loc_1;
        }// end function

        public function get(param1:String) : Object
        {
            return this._dict[param1];
        }// end function

        public function deleteFile(param1:String) : void
        {
            var _loc_2:* = undefined;
            if (param1 in this._dict)
            {
                _loc_2 = this._dict[param1];
                var _loc_3:* = _loc_2;
                _loc_3._loc_2["clear"]();
                delete this._dict[param1];
            }
            return;
        }// end function

        public function get loadDone() : Boolean
        {
            return this._loadDone;
        }// end function

        public function get loadErr() : Boolean
        {
            return this._loadErr;
        }// end function

        public function get isLoading() : Boolean
        {
            return this._isLoading;
        }// end function

        public function get version() : String
        {
            if (this._instanceClass == null)
            {
                return "";
            }
            return this._instanceClass["version"];
        }// end function

        public static function get instance() : P2PFileLoader
        {
            if (_instance == null)
            {
                _instance = new P2PFileLoader(new SingletonClass());
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

