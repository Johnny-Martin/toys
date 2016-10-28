package com.qiyi.player.wonder.plugins.scenetile.view.barragepart
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.logging.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class BarrageStarHeadImage extends EventDispatcher
    {
        private var _imgDic:Dictionary;
        private var _waitLoadVec:Vector.<String>;
        private var _loader:Loader;
        private var _isInit:Boolean = false;
        private var _loading:Boolean = false;
        private var _log:ILogger;
        private static var _instance:BarrageStarHeadImage;
        public static const COMPLETE:String = "COMPLETE";

        public function BarrageStarHeadImage()
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.plugins.scenetile.view.barragepart.BarrageStarHeadImage");
            return;
        }// end function

        public function init() : void
        {
            this._isInit = true;
            this._imgDic = new Dictionary();
            this._waitLoadVec = new Vector.<String>;
            return;
        }// end function

        public function getHeadImageByUrl(param1:String) : BitmapData
        {
            if (!this._isInit)
            {
                this.init();
            }
            var _loc_2:* = this._imgDic[param1];
            if (_loc_2)
            {
                return this._imgDic[param1].bitmapData;
            }
            this.imgLoader(param1);
            return null;
        }// end function

        private function imgLoader(param1:String) : void
        {
            var i:uint;
            var $imgUrl:* = param1;
            if (!this._loading)
            {
                this._log.debug("BarrageStarHeadImage request star head image imgUrl : " + $imgUrl);
                try
                {
                    if (this._loader)
                    {
                        this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoadComplete);
                        this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onErrorHandler);
                        this._loader.close();
                        this._loader = null;
                    }
                }
                catch (error:Error)
                {
                    _log.debug("BarrageStarHeadImage request star head image Error" + error);
                }
                this._loader = new Loader();
                this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
                this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onErrorHandler);
                this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHandler);
                this._loading = true;
                this._loader.load(new URLRequest($imgUrl), new LoaderContext(true));
            }
            else
            {
                i;
                while (i < this._waitLoadVec.length)
                {
                    
                    if (this._waitLoadVec[i] == $imgUrl)
                    {
                        return;
                    }
                    i = (i + 1);
                }
                this._waitLoadVec.push($imgUrl);
            }
            return;
        }// end function

        private function onLoadComplete(event:Event) : void
        {
            var bitmap:Bitmap;
            var $event:* = event;
            this._loading = false;
            try
            {
                bitmap = new Bitmap((this._loader.content as Bitmap).bitmapData);
                this._imgDic[$event.target.url] = bitmap;
                dispatchEvent(new Event(COMPLETE));
                this._log.debug("BarrageStarHeadImage request star head image Complete");
            }
            catch (error:Error)
            {
                _log.debug("BarrageStarHeadImage star head image Complete Error:" + error);
            }
            if (this._waitLoadVec.length > 0)
            {
                this.imgLoader(this._waitLoadVec.pop());
            }
            return;
        }// end function

        private function onErrorHandler(event:Event) : void
        {
            this._loading = false;
            if (this._waitLoadVec.length > 0)
            {
                this.imgLoader(this._waitLoadVec.shift());
            }
            this._log.debug("BarrageStarHeadImage request star head image Error");
            return;
        }// end function

        public static function get instance() : BarrageStarHeadImage
        {
            var _loc_1:* = _instance || new BarrageStarHeadImage;
            _instance = _instance || new BarrageStarHeadImage;
            return _loc_1;
        }// end function

    }
}
