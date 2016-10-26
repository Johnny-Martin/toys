package com.ws.net
{
    import com.ws.stat.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class VodClassFactory extends EventDispatcher
    {
        private var _libraryURL:String = "";
        private var _loader:VodClassLoader = null;
        private var _startTime:Number = 0;
        private var _timer:Timer = null;
        private var _logStat:Statistics = null;
        private var _callback:Function = null;
        public var isSuccess:Boolean = false;

        public function VodClassFactory(param1:String, param2:Function, param3:Statistics = null)
        {
            this._libraryURL = param1;
            this._callback = param2;
            this._logStat = param3;
            return;
        }// end function

        public function load(param1:int = 6000, param2:Boolean = true) : void
        {
            this._startTime = getTimer();
            this._loader = new VodClassLoader();
            this._loader.addEventListener(VodClassLoader.LOAD_IO_ERROR, this.loaderError_Hander);
            this._loader.addEventListener(VodClassLoader.LOAD_SECURITY_RROR, this.loaderError_Hander);
            this._loader.addEventListener(VodClassLoader.DOWNLOAD_IO_ERROR, this.loaderError_Hander);
            this._loader.addEventListener(VodClassLoader.DOWNLOAD_SECURITY_ERROR, this.loaderError_Hander);
            this._loader.addEventListener(VodClassLoader.CLASS_LOADED, this.loader_classLoadedHander);
            this._loader.load(this._libraryURL, param2);
            if (param1 > 0)
            {
                this._timer = new Timer(param1, 1);
                this._timer.addEventListener(TimerEvent.TIMER, this.timer_Hander);
                this._timer.start();
            }
            return;
        }// end function

        protected function loaderError_Hander(event:Event) : void
        {
            var _loc_2:Object = null;
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.timer_Hander);
            }
            if (this._loader != null)
            {
                this._loader.removeEventListener(VodClassLoader.LOAD_IO_ERROR, this.loaderError_Hander);
                this._loader.removeEventListener(VodClassLoader.LOAD_SECURITY_RROR, this.loaderError_Hander);
                this._loader.removeEventListener(VodClassLoader.DOWNLOAD_IO_ERROR, this.loaderError_Hander);
                this._loader.removeEventListener(VodClassLoader.DOWNLOAD_SECURITY_ERROR, this.loaderError_Hander);
                this._loader.removeEventListener(VodClassLoader.CLASS_LOADED, this.loader_classLoadedHander);
                this._loader = null;
            }
            this.isSuccess = false;
            if (this._logStat)
            {
                _loc_2 = new Object();
                _loc_2.type = "LoadFail";
                _loc_2.time = int(new Date().getTime() / 1000);
                this._logStat.reportStatInfo(Statistics.LIB_LOAD, _loc_2);
            }
            this._callback();
            return;
        }// end function

        protected function timer_Hander(event:Event) : void
        {
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.timer_Hander);
            }
            this.loaderError_Hander(null);
            return;
        }// end function

        protected function loader_classLoadedHander(event:Event) : void
        {
            var _loc_2:Object = null;
            if (this._timer != null)
            {
                this._timer.stop();
                this._timer.removeEventListener(TimerEvent.TIMER, this.timer_Hander);
            }
            this.isSuccess = true;
            if (this._logStat)
            {
                _loc_2 = new Object();
                _loc_2.type = "LoadSuccess";
                _loc_2.time = int(new Date().getTime() / 1000);
                this._logStat.reportStatInfo(Statistics.LIB_LOAD, _loc_2);
            }
            this._callback();
            return;
        }// end function

        public function createNetStream(param1:Boolean) : NetStream
        {
            var _loc_2:* = undefined;
            if (this._loader != null)
            {
                _loc_2 = null;
                _loc_2 = this._loader.createStream(param1);
                return new _loc_2 as NetStream;
            }
            return null;
        }// end function

        public function getClass(param1:String) : Class
        {
            if (this._loader != null)
            {
                return this._loader.getClass(param1);
            }
            return null;
        }// end function

        public function get bytes() : Number
        {
            return this._loader.bytesTotal;
        }// end function

        public static function checkCompatibility() : Boolean
        {
            var _loc_3:Array = null;
            var _loc_1:* = Capabilities.version;
            var _loc_2:* = _loc_1.search(/\d""\d/);
            if (_loc_2 != -1)
            {
                _loc_1 = _loc_1.substr(_loc_2);
                _loc_3 = _loc_1.split(",");
                if (_loc_3.length == 4)
                {
                    if (_loc_3[0] > 10)
                    {
                        return true;
                    }
                    if (_loc_3[0] == 10 && _loc_3[1] >= 1)
                    {
                        return true;
                    }
                }
            }
            return false;
        }// end function

    }
}
