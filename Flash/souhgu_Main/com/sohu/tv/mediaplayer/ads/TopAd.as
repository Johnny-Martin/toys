package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import ebing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class TopAd extends EventDispatcher
    {
        private var _ftitleadLoader:Loader;
        private var _ftitleTimeout:Number = 0;
        private var _ftitleTimeoutID:Number = 0;
        private var _ftitleDelay:Number = 0;
        private var _adPath:String = "";
        private var _adDelay:String = "";
        private var _adPingback:String = "";
        private var _adClick:String = "";
        private var _title_ad_first_display_time:Number = 0;
        private var _ftitleadTimer:Timer;
        private var _container:Sprite;
        protected var _state:String = "no";
        private var _bg:Sprite;
        private var _width:Number = 0;
        private var _height:Number = 0;

        public function TopAd()
        {
            this._bg = new Sprite();
            Utils.drawRect(this._bg, 0, 0, 1, 1, 0, 1);
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            this._adPath = param1.adPar;
            this._adDelay = param1.adDelayPar;
            this._adClick = param1.adClick;
            this._adPingback = (param1.adPingback != null && param1.adPingback != undefined && param1.adPingback != "undefined") != null ? (param1.adPingback) : ("");
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

        private function playTitleAd(... args) : void
        {
            if (this._state == "playing")
            {
                this.resizeTitleAd();
                if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                {
                    if (this._ftitleadLoader != null)
                    {
                        this._ftitleadLoader.visible = true;
                        this._ftitleadLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_st"));
                        if (this._ftitleTimeout > 0)
                        {
                            this._ftitleTimeoutID = setTimeout(this.hideTitleAd, this._ftitleTimeout);
                        }
                        this.pingback();
                    }
                }
                else if (this._ftitleadLoader != null)
                {
                    this._ftitleadLoader.visible = false;
                }
                dispatchEvent(new TvSohuAdsEvent(TvSohuAdsEvent.TOPSHOWN));
            }
            return;
        }// end function

        private function hideTitleAd() : void
        {
            if (this._ftitleadLoader != null)
            {
                this._ftitleadLoader.visible = false;
            }
            return;
        }// end function

        private function resizeTitleAd() : void
        {
            if (this._ftitleadLoader != null)
            {
                if (this._ftitleTimeoutID != 0)
                {
                    clearTimeout(this._ftitleTimeoutID);
                }
                if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                {
                    if (this._ftitleDelay == 0 && this._ftitleTimeout == 0)
                    {
                        this._ftitleadLoader.visible = true;
                    }
                }
                else
                {
                    this._ftitleadLoader.visible = false;
                }
                if (this._container.contains(this._ftitleadLoader))
                {
                    this._container.setChildIndex(this._ftitleadLoader, (this._container.numChildren - 1));
                }
            }
            return;
        }// end function

        private function ftitleCompleteHandler(event:Event) : void
        {
            var evt:* = event;
            this._container.addChild(this._bg);
            this._container.addChild(this._ftitleadLoader);
            this._ftitleadLoader.visible = false;
            this._ftitleadLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                _ftitleadLoader.content["clickUrl"] = _adClick;
                return;
            }// end function
            );
            this._ftitleadLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
            this.beginAd();
            return;
        }// end function

        private function ftitleErrorHandler(event:IOErrorEvent) : void
        {
            this._ftitleadLoader = null;
            return;
        }// end function

        public function play() : void
        {
            var _loc_1:Array = null;
            if (this._adPath != "")
            {
                if (this._state == "no")
                {
                    this._state = "playing";
                    _loc_1 = this._adDelay.split(",");
                    if (this._adDelay == "")
                    {
                        this._ftitleDelay = 0;
                        this._ftitleTimeout = 0;
                    }
                    else if (_loc_1.length == 1)
                    {
                        this._ftitleDelay = Number(_loc_1[0]) * 60000 || 15 * 60000;
                        this._ftitleTimeout = 8 * 1000;
                    }
                    else if (_loc_1.length == 2)
                    {
                        this._ftitleDelay = Number(_loc_1[0]) * 60000 || 15 * 60000;
                        this._ftitleTimeout = Number(_loc_1[1]) * 1000 || 8 * 1000;
                    }
                    else if (_loc_1.length == 3)
                    {
                        this._ftitleDelay = Number(_loc_1[0]) * 60000 || 15 * 60000;
                        this._ftitleTimeout = Number(_loc_1[1]) * 1000 || 8 * 1000;
                        this._title_ad_first_display_time = Number(_loc_1[2]) * 60000 || 3 * 60000;
                    }
                    if (this.checkUrl(this._adPath, "swf") || this.checkUrl(this._adPath, "jpg") || this.checkUrl(this._adPath, "gif") || this.checkUrl(this._adPath, "jpeg"))
                    {
                        this._ftitleadLoader = new Loader();
                        this._ftitleadLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.ftitleCompleteHandler);
                        this._ftitleadLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ftitleErrorHandler);
                        this._ftitleadLoader.load(new URLRequest(this._adPath));
                    }
                }
                else
                {
                    this._container.visible = true;
                    this._state = "playing";
                }
            }
            return;
        }// end function

        public function pingback() : void
        {
            var _loc_1:RegExp = null;
            if (this._adPingback != "" && this._adPingback != null)
            {
                _loc_1 = /\[_TIME]""\[_TIME]/gi;
                new TvSohuURLLoaderUtil().multiSend(this._adPingback.replace(_loc_1, new Date().getTime()));
            }
            return;
        }// end function

        public function close() : void
        {
            this._container.visible = false;
            this._state = "end";
            return;
        }// end function

        public function get state() : String
        {
            return this._state;
        }// end function

        private function beginAd() : void
        {
            if (this._adPath != "")
            {
                if (this._ftitleDelay > 0 && this._ftitleTimeout > 0)
                {
                    this._ftitleadTimer = new Timer(this._ftitleDelay, 0);
                    this._ftitleadTimer.addEventListener(TimerEvent.TIMER, this.playTitleAd);
                    setTimeout(this.runTitleAd, this._title_ad_first_display_time);
                }
                else
                {
                    this.playTitleAd();
                }
            }
            return;
        }// end function

        private function runTitleAd() : void
        {
            if (this._state == "playing")
            {
                this._ftitleadTimer.start();
                this.playTitleAd();
            }
            return;
        }// end function

        public function get hasAd() : Boolean
        {
            return this._adPath == "" ? (false) : (true);
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            var w:* = param1;
            var h:* = param2;
            var _loc_4:* = w < 0 ? (0) : (w);
            this._bg.width = w < 0 ? (0) : (w);
            this._width = _loc_4;
            var _loc_4:* = h < 0 ? (0) : (h);
            this._bg.height = h < 0 ? (0) : (h);
            this._height = _loc_4;
            try
            {
                if (this._ftitleadLoader != null)
                {
                    this._ftitleadLoader.x = Math.round(w - this._ftitleadLoader.contentLoaderInfo.width) / 2;
                    this._ftitleadLoader.y = 0;
                }
                if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                {
                    this._container.visible = true;
                }
                else
                {
                    this._container.visible = false;
                }
            }
            catch (evt)
            {
            }
            return;
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

    }
}
