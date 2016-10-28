package com.qiyi.player.wonder.plugins.controllbar.view.preview.image
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class PreviewImageLoader extends EventDispatcher
    {
        private var _imgDic:Dictionary;
        private var _waitLoadVec:Vector.<String>;
        private var _loader:Loader;
        private var _defaultImage:Bitmap;
        private var _isInit:Boolean = false;
        private var _loading:Boolean = false;
        private static var _instance:PreviewImageLoader;
        public static const COMPLETE:String = "COMPLETE";

        public function PreviewImageLoader()
        {
            return;
        }// end function

        public function init() : void
        {
            this._isInit = true;
            this._imgDic = new Dictionary();
            this._waitLoadVec = new Vector.<String>;
            this.imgLoader(SystemConfig.DEFAULT_IMAGE_URL);
            return;
        }// end function

        public function getImageByIndex(param1:int) : BitmapData
        {
            if (!this._isInit)
            {
                this.init();
            }
            var _loc_2:* = this._imgDic[param1];
            if (_loc_2)
            {
                return _loc_2;
            }
            return null;
        }// end function

        public function getDefaultImage() : BitmapData
        {
            if (!this._isInit)
            {
                this.init();
            }
            if (this._defaultImage)
            {
                return this._defaultImage.bitmapData;
            }
            return null;
        }// end function

        public function imgLoader(param1:String) : void
        {
            var _loc_2:uint = 0;
            if (!this._loading)
            {
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
                }
                this._loader = new Loader();
                this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
                this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onErrorHandler);
                this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHandler);
                this._loading = true;
                this._loader.load(new URLRequest(param1), new LoaderContext(true));
            }
            else
            {
                _loc_2 = 0;
                while (_loc_2 < this._waitLoadVec.length)
                {
                    
                    if (this._waitLoadVec[_loc_2] == param1)
                    {
                        return;
                    }
                    _loc_2 = _loc_2 + 1;
                }
                this._waitLoadVec.push(param1);
            }
            return;
        }// end function

        private function onLoadComplete(event:Event) : void
        {
            var _loc_2:Bitmap = null;
            var _loc_3:int = 0;
            var _loc_4:Array = null;
            var _loc_5:Array = null;
            var _loc_6:BitmapData = null;
            var _loc_7:Rectangle = null;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            this._loading = false;
            try
            {
                _loc_2 = new Bitmap((this._loader.content as Bitmap).bitmapData);
                _loc_3 = 0;
                if (event.target.url == SystemConfig.DEFAULT_IMAGE_URL)
                {
                    if (!this._defaultImage)
                    {
                        this._defaultImage = new Bitmap();
                        this._defaultImage.bitmapData = _loc_2.bitmapData;
                    }
                }
                else
                {
                    _loc_4 = event.target.url.split(".jpg");
                    if (_loc_4.length > 0)
                    {
                        _loc_5 = _loc_4[0].split("_");
                        if (_loc_5.length > 0)
                        {
                            _loc_3 = int(_loc_5[(_loc_5.length - 1)]);
                        }
                    }
                    if (_loc_3 > 0)
                    {
                        _loc_8 = 0;
                        while (_loc_8 < ControllBarDef.IMAGE_PRE_BIG_ROW)
                        {
                            
                            _loc_9 = 0;
                            while (_loc_9 < ControllBarDef.IMAGE_PRE_BIG_COL)
                            {
                                
                                _loc_7 = new Rectangle();
                                _loc_7.x = _loc_9 * ControllBarDef.IMAGE_PRE_SMALL_SIZE.x;
                                _loc_7.y = _loc_8 * ControllBarDef.IMAGE_PRE_SMALL_SIZE.y;
                                _loc_7.width = ControllBarDef.IMAGE_PRE_SMALL_SIZE.x;
                                _loc_7.height = ControllBarDef.IMAGE_PRE_SMALL_SIZE.y;
                                _loc_6 = new BitmapData(ControllBarDef.IMAGE_PRE_SMALL_SIZE.x, ControllBarDef.IMAGE_PRE_SMALL_SIZE.y, true, 0);
                                _loc_6.copyPixels(_loc_2.bitmapData, _loc_7, new Point(0, 0));
                                this._imgDic[(_loc_3 - 1) * 100 + _loc_8 * ControllBarDef.IMAGE_PRE_BIG_ROW + _loc_9] = _loc_6;
                                _loc_9++;
                            }
                            _loc_8++;
                        }
                    }
                    dispatchEvent(new Event(COMPLETE));
                }
            }
            catch (error:Error)
            {
            }
            if (this._waitLoadVec.length > 0)
            {
                this.imgLoader(this._waitLoadVec.pop());
            }
            return;
        }// end function

        public function clearImageData() : void
        {
            var _loc_1:Object = null;
            var _loc_2:BitmapData = null;
            for (_loc_1 in this._imgDic)
            {
                
                _loc_2 = this._imgDic[_loc_1];
                delete this._imgDic[_loc_1];
                _loc_2 = null;
                _loc_1 = null;
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
            return;
        }// end function

        public static function get instance() : PreviewImageLoader
        {
            var _loc_1:* = _instance || new PreviewImageLoader;
            _instance = _instance || new PreviewImageLoader;
            return _loc_1;
        }// end function

    }
}
