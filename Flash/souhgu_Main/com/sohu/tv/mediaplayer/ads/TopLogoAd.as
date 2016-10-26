package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import ebing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class TopLogoAd extends EventDispatcher
    {
        private var _flogoadSprite:Sprite;
        private var _flogoadSmallLoader:Loader;
        private var _flogoadBigLoader:Loader;
        private var _logoAdReady:Boolean;
        private var _flogoadTimer:Timer;
        private var _flogoTimeout:Number = 0;
        private var _flogoTimeoutID:Number = 0;
        private var _loc_y:Number;
        private var _logoAdPlayed:Boolean;
        private var _flogoDelay:Number = 0;
        private var _logo_ad_first_display_time:Number = 0;
        private var _adPath:String = "";
        private var _adDelay:String = "";
        private var _adPingback:String = "";
        private var _adClick:String = "";
        private var _owner:TopLogoAd;
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _container:Sprite;
        private var _state:String = "no";

        public function TopLogoAd()
        {
            this._flogoadSmallLoader = new Loader();
            this._flogoadBigLoader = new Loader();
            this._owner = this;
            return;
        }// end function

        public function get container() : Sprite
        {
            return this._container;
        }// end function

        public function set container(param1:Sprite) : void
        {
            this._container = param1;
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            this._adPath = param1.adPar;
            this._adDelay = param1.adDelayPar;
            this._adClick = param1.adClick;
            this._adPingback = param1.adPingback != null && param1.adPingback != undefined && param1.adPingback != "undefined" ? (param1.adPingback) : ("");
            return;
        }// end function

        private function flogoadSmallCompleteHandler(event:Event) : void
        {
            var evt:* = event;
            this._flogoadSprite.addChild(this._flogoadSmallLoader);
            this._flogoadSmallLoader.visible = false;
            this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                _flogoadSmallLoader.content["clickUrl"] = _adClick;
                return;
            }// end function
            );
            this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
            if (this._logoAdReady)
            {
                this.playLogoAdd();
            }
            this._logoAdReady = true;
            return;
        }// end function

        private function flogoadSmallErrorHandler(event:IOErrorEvent) : void
        {
            this._flogoadSmallLoader = null;
            return;
        }// end function

        private function flogoadBigCompleteHandler(event:Event) : void
        {
            var evt:* = event;
            this._flogoadSprite.addChild(this._flogoadBigLoader);
            this._flogoadBigLoader.visible = false;
            this._flogoadBigLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                _flogoadBigLoader.content["clickUrl"] = _adClick;
                return;
            }// end function
            );
            this._flogoadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
            if (this._logoAdReady)
            {
                this.playLogoAdd();
            }
            this._logoAdReady = true;
            return;
        }// end function

        private function flogoadBigErrorHandler(event:IOErrorEvent) : void
        {
            this._flogoadBigLoader = null;
            return;
        }// end function

        private function runLogoAd() : void
        {
            if (this._state == "playing")
            {
                this._flogoadTimer.start();
                this.playLogoAd();
            }
            return;
        }// end function

        private function playLogoAd(... args) : void
        {
            if (this._state == "playing")
            {
                if (this._flogoadSprite != null && this._flogoadSprite.numChildren > 0)
                {
                    if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                    {
                        if (this._flogoadBigLoader != null)
                        {
                            this._flogoadBigLoader.visible = true;
                        }
                        if (this._flogoadSmallLoader != null)
                        {
                            this._flogoadSmallLoader.visible = false;
                        }
                        this._flogoadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_sx"));
                    }
                    else
                    {
                        if (this._flogoadSmallLoader != null)
                        {
                            this._flogoadSmallLoader.visible = true;
                        }
                        if (this._flogoadBigLoader != null)
                        {
                            this._flogoadBigLoader.visible = false;
                        }
                        this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_sx"));
                    }
                    this._flogoadSprite.visible = true;
                    this.pingback();
                    if (this._flogoTimeout > 0)
                    {
                        this._flogoTimeoutID = setTimeout(this.hideLogoAd, this._flogoTimeout);
                    }
                }
            }
            return;
        }// end function

        public function changeAd() : Boolean
        {
            var _loc_1:Boolean = false;
            if (this._flogoadSprite != null && this._flogoadSprite.numChildren > 0)
            {
                _loc_1 = false;
                if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                {
                    if (this._flogoadSprite.visible == true)
                    {
                        if (this._flogoadBigLoader != null)
                        {
                            this._flogoadBigLoader.visible = true;
                        }
                        if (this._flogoadSmallLoader != null)
                        {
                            this._flogoadSmallLoader.visible = false;
                        }
                    }
                    _loc_1 = true;
                }
                else
                {
                    if (this._flogoadSprite.visible == true)
                    {
                        if (this._flogoadBigLoader != null)
                        {
                            this._flogoadBigLoader.visible = false;
                        }
                        if (this._flogoadSmallLoader != null)
                        {
                            this._flogoadSmallLoader.visible = true;
                        }
                    }
                    _loc_1 = false;
                }
            }
            return _loc_1;
        }// end function

        private function hideLogoAd() : void
        {
            this._flogoadSprite.visible = false;
            return;
        }// end function

        private function showLogoAd() : void
        {
            if (this._flogoadSprite != null)
            {
                this._flogoadSprite.visible = true;
            }
            return;
        }// end function

        public function play() : void
        {
            var _loc_1:Array = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:Array = null;
            if (!this._logoAdPlayed)
            {
                this._logoAdPlayed = true;
                if (this._state == "no")
                {
                    this._state = "playing";
                    this._flogoadSprite = new Sprite();
                    this._flogoadSprite.visible = false;
                    this._container.addChild(this._flogoadSprite);
                    if (this._adPath != "")
                    {
                        _loc_1 = this._adPath.split("|");
                        _loc_2 = _loc_1[0] || "";
                        _loc_3 = _loc_1[1] || "";
                        _loc_4 = this._adDelay.split(",");
                        if (this._adDelay == "")
                        {
                            this._flogoDelay = 0;
                            this._flogoTimeout = 0;
                        }
                        else if (_loc_4.length == 1)
                        {
                            this._flogoDelay = Number(_loc_4[0]) * 60000 || 15 * 60000;
                            this._flogoTimeout = 8 * 1000;
                        }
                        else if (_loc_4.length == 2)
                        {
                            this._flogoDelay = Number(_loc_4[0]) * 60000 || 15 * 60000;
                            this._flogoTimeout = Number(_loc_4[1]) * 1000 || 8 * 1000;
                        }
                        else if (_loc_4.length == 3)
                        {
                            this._flogoDelay = Number(_loc_4[0]) * 60000 || 15 * 60000;
                            this._flogoTimeout = Number(_loc_4[1]) * 1000 || 8 * 1000;
                            this._logo_ad_first_display_time = Number(_loc_4[2]) * 60000 || 3 * 60000;
                        }
                        if (this.checkUrl(_loc_2, "swf") || this.checkUrl(_loc_2, "jpg") || this.checkUrl(_loc_2, "gif") || this.checkUrl(_loc_2, "jpeg"))
                        {
                            this._flogoadSmallLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.flogoadSmallCompleteHandler);
                            this._flogoadSmallLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.flogoadSmallErrorHandler);
                            this._flogoadSmallLoader.load(new URLRequest(_loc_2));
                        }
                        if (this.checkUrl(_loc_3, "swf") || this.checkUrl(_loc_3, "jpg") || this.checkUrl(_loc_3, "gif") || this.checkUrl(_loc_2, "jpeg"))
                        {
                            this._flogoadBigLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.flogoadBigCompleteHandler);
                            this._flogoadBigLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.flogoadBigErrorHandler);
                            this._flogoadBigLoader.load(new URLRequest(_loc_3));
                        }
                    }
                }
                else
                {
                    this._flogoadSprite.visible = true;
                    this._state = "playing";
                }
            }
            return;
        }// end function

        public function pingback() : void
        {
            var _loc_1:RegExp = null;
            if (this._adPingback != "")
            {
                _loc_1 = /\[_TIME]""\[_TIME]/gi;
                new TvSohuURLLoaderUtil().multiSend(this._adPingback.replace(_loc_1, new Date().getTime()));
            }
            return;
        }// end function

        private function playLogoAdd() : void
        {
            if (this._state == "playing")
            {
                if (this._adPath != "")
                {
                    Utils.debug("_tlogoDelay:" + this._flogoDelay + " _tlogoTimeout:" + " _logo_ad_first_display_time:" + this._logo_ad_first_display_time);
                    if (this._flogoDelay > 0 && this._flogoTimeout > 0)
                    {
                        this._flogoadTimer = new Timer(this._flogoDelay, 0);
                        this._flogoadTimer.addEventListener(TimerEvent.TIMER, this.playLogoAd);
                        setTimeout(this.runLogoAd, this._logo_ad_first_display_time);
                    }
                    else
                    {
                        this.playLogoAd();
                    }
                    Utils.debug("wwwwwwwwwwwwwwwwww:" + this.width + " hhhhhhhhhhhhhhhhhhhhhhh:" + this.height);
                    dispatchEvent(new TvSohuAdsEvent(TvSohuAdsEvent.LOGOSHOWN));
                }
            }
            return;
        }// end function

        public function get hasAd() : Boolean
        {
            if (this._adPath != "")
            {
                return true;
            }
            return false;
        }// end function

        private function checkUrl(param1:String, param2:String) : Boolean
        {
            if (param1 == "")
            {
                return false;
            }
            var _loc_3:* = param1.length;
            var _loc_4:* = param2.length;
            return param1.substring(_loc_3 - _loc_4 - 1) == "." + param2;
        }// end function

        public function close() : void
        {
            this._flogoadSprite.visible = false;
            this._state = "end";
            return;
        }// end function

        public function get width() : Number
        {
            try
            {
                if (this._container.stage != null && (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen))
                {
                    if (this._flogoadBigLoader.contentLoaderInfo != null)
                    {
                        this._width = this._flogoadBigLoader.contentLoaderInfo.width;
                    }
                }
                else if (this._flogoadSmallLoader.contentLoaderInfo != null)
                {
                    this._width = this._flogoadSmallLoader.contentLoaderInfo.width;
                }
            }
            catch (evt)
            {
            }
            return this._width;
        }// end function

        public function get height() : Number
        {
            try
            {
                if (this._container.stage != null && (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen))
                {
                    if (this._flogoadBigLoader.contentLoaderInfo != null)
                    {
                        this._height = this._flogoadBigLoader.contentLoaderInfo.height;
                    }
                }
                else if (this._flogoadSmallLoader.contentLoaderInfo != null)
                {
                    this._height = this._flogoadSmallLoader.contentLoaderInfo.height;
                }
            }
            catch (evt)
            {
            }
            return this._height;
        }// end function

    }
}
