package com.qiyi.player.wonder.common.loader
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.common.event.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;

    public class CommonLoader extends EventDispatcher
    {
        private var _loader:Loader;
        private var _urlLoader:URLLoader;
        private var _loaderVO:LoaderVO;
        private var _log:ILogger;
        public static const EVENT_COMPLETE:String = "EVENT_COMPLETE";
        public static const EVENT_ERROR:String = "EVENT_ERROR";

        public function CommonLoader()
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.common.loader.CommonLoader");
            return;
        }// end function

        public function startLoad(param1:LoaderVO) : void
        {
            if (this._loaderVO)
            {
                this._loaderVO.destroy();
                this._loaderVO = null;
            }
            this._loaderVO = param1;
            switch(this._loaderVO.type)
            {
                case LoaderManager.TYPE_LOADER:
                {
                    this.loader();
                    break;
                }
                case LoaderManager.TYPE_URLlOADER:
                {
                    this.urlLoader();
                    break;
                }
                default:
                {
                    this.urlLoader();
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function loader() : void
        {
            this.destroyLoader();
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaderComplete);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onErrorHandler);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHandler);
            this._loader.load(new URLRequest(this._loaderVO.url), new LoaderContext(true));
            return;
        }// end function

        private function urlLoader() : void
        {
            this.destroyUrlLoader();
            this._urlLoader = new URLLoader();
            this._urlLoader.addEventListener(Event.COMPLETE, this.onUrlLoaderComplete);
            this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onErrorHandler);
            this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHandler);
            this._urlLoader.load(new URLRequest(this._loaderVO.url));
            return;
        }// end function

        private function onLoaderComplete(event:Event) : void
        {
            if (this._loaderVO.sucFun != null)
            {
                this._loaderVO.sucFun.call(null, this._loader.content);
            }
            dispatchEvent(new CommonEvent(EVENT_COMPLETE));
            return;
        }// end function

        private function onUrlLoaderComplete(event:Event) : void
        {
            if (this._loaderVO.sucFun != null)
            {
                this._loaderVO.sucFun.call(null, this._urlLoader.data);
            }
            dispatchEvent(new CommonEvent(EVENT_COMPLETE));
            return;
        }// end function

        private function onErrorHandler(event:Event) : void
        {
            this.destroyLoader();
            this.destroyUrlLoader();
            (this._loaderVO.alreadyTry + 1);
            if (this._loaderVO.alreadyTry >= this._loaderVO.retry)
            {
                if (this._loaderVO.errorFun != null)
                {
                    this._loaderVO.errorFun.call(null);
                }
                this._log.info("CommonLoader loader error : " + event.type + ",    url : " + this._loaderVO.url);
                dispatchEvent(new CommonEvent(EVENT_ERROR));
            }
            else
            {
                switch(this._loaderVO.type)
                {
                    case LoaderManager.TYPE_LOADER:
                    {
                        this.loader();
                        break;
                    }
                    case LoaderManager.TYPE_URLlOADER:
                    {
                        this.urlLoader();
                        break;
                    }
                    default:
                    {
                        this.urlLoader();
                        break;
                        break;
                    }
                }
            }
            return;
        }// end function

        private function destroyLoader() : void
        {
            try
            {
                if (this._loader)
                {
                    this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoaderComplete);
                    this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onErrorHandler);
                    this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHandler);
                    this._loader.close();
                    this._loader = null;
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function destroyUrlLoader() : void
        {
            try
            {
                if (this._urlLoader)
                {
                    this._urlLoader.removeEventListener(Event.COMPLETE, this.onUrlLoaderComplete);
                    this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onErrorHandler);
                    this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHandler);
                    this._urlLoader.close();
                    this._urlLoader = null;
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

    }
}
