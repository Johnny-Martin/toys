package com.ws.net
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class VodClassLoader extends EventDispatcher
    {
        private var _urlstream:URLStream;
        private var _isAnalysis:Boolean;
        private var _bytesLoaded:uint;
        private var _bytesTotal:uint;
        private var _loader:Loader = null;
        private var _url:String;
        private var _bytes:ByteArray;
        private var _doLib:Object = null;
        public static const CLASS_LOADED:String = "classLoaded";
        public static const DOWNLOAD_IO_ERROR:String = "downloadError";
        public static const DOWNLOAD_SECURITY_ERROR:String = "downloadError";
        public static const LOAD_IO_ERROR:String = "loadIOError";
        public static const LOAD_SECURITY_RROR:String = "loadSecurityError";

        public function VodClassLoader()
        {
            this._urlstream = new URLStream();
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loader_completeHander);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loader_ioErrorHander);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loader_securityHander);
            return;
        }// end function

        public function getClass(param1:String) : Class
        {
            return this._loader.contentLoaderInfo.applicationDomain.getDefinition(param1) as Class;
        }// end function

        public function createStream(param1:Boolean = false) : Class
        {
            if (!param1)
            {
                return this._doLib.streamClass;
            }
            return this._doLib.liveStreamClass;
        }// end function

        protected function loader_completeHander(event:Event) : void
        {
            var _loc_3:ByteArray = null;
            var _loc_2:* = this._loader.contentLoaderInfo.applicationDomain.getDefinition("PFVDoLib") as Class;
            if (_loc_2 != null)
            {
                this._doLib = new _loc_2;
                this._doLib.addEventListener("lib_loaded", this.onLibLoaderHandler);
                this._doLib.addEventListener("lib_error", this.onLibErrorHandler);
                _loc_3 = new ByteArray();
                this._bytes.readBytes(_loc_3);
                this._doLib.libBytes = _loc_3;
            }
            return;
        }// end function

        private function onLibLoaderHandler(event:Event) : void
        {
            dispatchEvent(new Event(VodClassLoader.CLASS_LOADED));
            return;
        }// end function

        private function onLibErrorHandler(event:Event) : void
        {
            dispatchEvent(new Event(VodClassLoader.LOAD_IO_ERROR));
            return;
        }// end function

        protected function loader_ioErrorHander(event:Event) : void
        {
            dispatchEvent(new Event(VodClassLoader.LOAD_IO_ERROR));
            return;
        }// end function

        protected function loader_securityHander(event:Event) : void
        {
            dispatchEvent(new Event(VodClassLoader.LOAD_SECURITY_RROR));
            return;
        }// end function

        protected function us_completeHander(event:Event) : void
        {
            var _loc_2:int = 0;
            var _loc_3:ByteArray = null;
            if (this._urlstream.bytesAvailable > 0)
            {
                this._bytesLoaded = this._urlstream.bytesAvailable;
                this._bytesTotal = this._urlstream.bytesAvailable;
                this._urlstream.readBytes(this._bytes, 0, this._urlstream.bytesAvailable);
                _loc_2 = this._bytes.readInt();
                _loc_3 = new ByteArray();
                if (this._bytes.length < _loc_2)
                {
                    dispatchEvent(new Event(VodClassLoader.DOWNLOAD_IO_ERROR));
                }
                else
                {
                    this._bytes.readBytes(_loc_3, 0, _loc_2);
                    this._loader.loadBytes(_loc_3);
                }
            }
            return;
        }// end function

        protected function us_ioErrorHander(event:Event) : void
        {
            dispatchEvent(new Event(VodClassLoader.DOWNLOAD_IO_ERROR));
            return;
        }// end function

        protected function us_securityHander(event:Event) : void
        {
            dispatchEvent(new Event(VodClassLoader.DOWNLOAD_SECURITY_ERROR));
            return;
        }// end function

        protected function us_progressHander(event:ProgressEvent) : void
        {
            this._bytesLoaded = event.bytesLoaded;
            this._bytesTotal = event.bytesTotal;
            return;
        }// end function

        public function load(param1:String, param2:Boolean = true) : void
        {
            this._bytesLoaded = 0;
            this._bytesTotal = 0;
            this._url = param1;
            var _loc_3:* = new URLRequest(this._url);
            this._urlstream.addEventListener(Event.COMPLETE, this.us_completeHander);
            this._urlstream.addEventListener(IOErrorEvent.IO_ERROR, this.us_ioErrorHander);
            this._urlstream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.us_securityHander);
            this._urlstream.addEventListener(ProgressEvent.PROGRESS, this.us_progressHander);
            if (this._bytes == null)
            {
                this._bytes = new ByteArray();
            }
            this._urlstream.load(_loc_3);
            return;
        }// end function

        public function get bytesLoaded() : uint
        {
            return this._bytesLoaded;
        }// end function

        public function get bytesTotal() : uint
        {
            return this._bytesTotal;
        }// end function

    }
}
