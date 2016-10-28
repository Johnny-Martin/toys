package com.qiyi.player.wonder.plugins.continueplay.view.parts
{
    import com.qiyi.player.wonder.common.config.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class ContinueItemImage extends Loader
    {
        private var _url:String = "";
        private var _curRetryCount:int = 0;
        private static const IMAGE_CACHE:Dictionary = new Dictionary();
        private static const MAX_RETRY_COUNT:int = 2;

        public function ContinueItemImage()
        {
            contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            return;
        }// end function

        override public function load(param1:URLRequest, param2:LoaderContext = null) : void
        {
            this._url = param1.url;
            super.load(param1, param2);
            return;
        }// end function

        private function onIOError(event:IOErrorEvent) : void
        {
            if (this._curRetryCount < MAX_RETRY_COUNT)
            {
                var _loc_2:String = this;
                var _loc_3:* = this._curRetryCount + 1;
                _loc_2._curRetryCount = _loc_3;
                this.load(new URLRequest(this._url), new LoaderContext(true));
            }
            return;
        }// end function

        public static function getImage(param1:String) : ContinueItemImage
        {
            var _loc_3:Array = null;
            var _loc_4:int = 0;
            var _loc_5:String = null;
            if (param1 == null || param1 == "")
            {
                param1 = SystemConfig.DEFAULT_IMAGE_URL;
            }
            else
            {
                _loc_3 = param1.match(/_\d+_\d+\.""_\d+_\d+\./);
                if (_loc_3 && _loc_3.length > 0)
                {
                    param1 = param1.replace(/_\d+_\d+\.""_\d+_\d+\./, "_116_65.");
                }
                else
                {
                    _loc_4 = param1.lastIndexOf(".");
                    _loc_5 = param1.substr(0, _loc_4);
                    _loc_5 = _loc_5 + "_116_65";
                    _loc_5 = _loc_5 + param1.substr(_loc_4);
                    param1 = _loc_5;
                }
            }
            var _loc_2:ContinueItemImage = null;
            if (IMAGE_CACHE[param1] == null || param1 == SystemConfig.DEFAULT_IMAGE_URL)
            {
                _loc_2 = new ContinueItemImage;
                _loc_2.load(new URLRequest(param1), new LoaderContext(true));
                IMAGE_CACHE[param1] = _loc_2;
            }
            else
            {
                _loc_2 = IMAGE_CACHE[param1] as ContinueItemImage;
            }
            return _loc_2;
        }// end function

    }
}
