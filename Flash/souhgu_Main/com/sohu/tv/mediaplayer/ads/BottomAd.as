package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import ebing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class BottomAd extends EventDispatcher
    {
        private var _adPath:String = "";
        private var _adDelay:String = "";
        private var _adPingback:String = "";
        private var _adClick:String = "";
        private var _fbottomadIsUp:Boolean;
        private var _loc_bottom_array:Array;
        private var _fbottomDelay:Number = 0;
        private var _fbottomTimeout:Number = 0;
        private var _bottom_ad_first_display_time:Number = 0;
        private var _fbottomadSmallLoader:Loader;
        private var _fbottomadBigLoader:Loader;
        private var _fbottomadSprite:Sprite;
        private var _fbottomadTimer:Timer;
        private var _fbottomadTimeoutID:Number = 0;
        private var _fbottomadWidth:Number = 0;
        private var _smallAdCloseBtnX:uint = 0;
        private var _smallAdCloseBtnY:uint = 0;
        private var _bigAdCloseBtnX:uint = 0;
        private var _bigAdCloseBtnY:uint = 0;
        private var _smallGoogleAdHeight:uint = 0;
        private var _fbottomCloseBtn:DisplayObject;
        private var _sogou:Object;
        private var _container:Sprite;
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _bg:Sprite;
        protected var _state:String = "no";
        private var _closeBtnUp:Sprite;
        private var _closeBtnOver:Sprite;
        private var _close_btn:Sprite;
        private var _bigLoaderContainer:Sprite;
        private var _smallLoaderContainer:Sprite;
        private var _isPlaying:Boolean = false;
        private var _isFButtomAd:Boolean = false;

        public function BottomAd()
        {
            this._close_btn = new Sprite();
            this._closeBtnUp = PlayerConfig.drawCloseBtn(15, 0, 16777215);
            this._closeBtnOver = PlayerConfig.drawCloseBtn(15, 0, 16711680);
            this._close_btn.addChild(this._closeBtnUp);
            this._close_btn.addChild(this._closeBtnOver);
            this._closeBtnOver.visible = false;
            var _loc_1:Boolean = true;
            this._close_btn.useHandCursor = true;
            this._close_btn.buttonMode = _loc_1;
            this._close_btn.mouseChildren = false;
            this._close_btn.visible = false;
            this._close_btn.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this._bg = new Sprite();
            Utils.drawRect(this._bg, 0, 0, 1, 1, 0, 1);
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

        private function mouseOverHandler(event:MouseEvent) : void
        {
            this._closeBtnOver.visible = true;
            this._closeBtnUp.visible = false;
            return;
        }// end function

        private function mouseOutHandler(event:MouseEvent) : void
        {
            this._closeBtnOver.visible = false;
            this._closeBtnUp.visible = true;
            return;
        }// end function

        private function mouseUpHandler(event:MouseEvent) : void
        {
            this.hideBottomAd();
            return;
        }// end function

        public function play() : void
        {
            var _loc_1:Array = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:Array = null;
            if (this._adPath != "")
            {
                if (this._state == "no")
                {
                    this._container.visible = true;
                    this._fbottomadSprite = new Sprite();
                    this._bigLoaderContainer = new Sprite();
                    this._smallLoaderContainer = new Sprite();
                    this._fbottomadIsUp = false;
                    _loc_1 = this._adPath.split("|");
                    _loc_2 = _loc_1[0] || "";
                    _loc_3 = _loc_1[1] || "";
                    _loc_4 = this._adDelay.split(",");
                    if (_loc_4.length == 0)
                    {
                        this._fbottomDelay = 15 * 60 * 1000;
                        this._fbottomTimeout = 8 * 1000;
                    }
                    else if (_loc_4.length == 1)
                    {
                        this._fbottomDelay = Number(_loc_4[0]) * 1000 || 15 * 60 * 1000;
                        this._fbottomTimeout = 8 * 1000;
                    }
                    else if (_loc_4.length == 2)
                    {
                        this._fbottomDelay = Number(_loc_4[0]) * 1000 || 15 * 60 * 1000;
                        this._fbottomTimeout = Number(_loc_4[1]) * 1000 || 8 * 1000;
                    }
                    else if (_loc_4.length == 3)
                    {
                        this._fbottomDelay = Number(_loc_4[0]) * 1000 || 15 * 60 * 1000;
                        this._fbottomTimeout = Number(_loc_4[1]) * 1000 || 8 * 1000;
                        this._bottom_ad_first_display_time = Number(_loc_4[2]) * 1000 || 3 * 60 * 1000;
                    }
                    if (this.checkUrl(_loc_2, "swf") || this.checkUrl(_loc_2, "jpg") || this.checkUrl(_loc_2, "gif") || this.checkUrl(_loc_2, "jpeg"))
                    {
                        this._fbottomadSmallLoader = new Loader();
                        this._fbottomadSmallLoader.visible = false;
                        this._fbottomadSmallLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.fbottomadSmallCompleteHandler);
                        this._fbottomadSmallLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.fbottomadSmallErrorHandler);
                        this._fbottomadSmallLoader.load(new URLRequest(_loc_2));
                    }
                    if (this.checkUrl(_loc_3, "swf") || this.checkUrl(_loc_3, "jpg") || this.checkUrl(_loc_3, "gif") || this.checkUrl(_loc_3, "jpeg"))
                    {
                        this._fbottomadBigLoader = new Loader();
                        this._fbottomadBigLoader.visible = false;
                        this._fbottomadBigLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.fbottomadBigCompleteHandler);
                        this._fbottomadBigLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.fbottomadBigErrorHandler);
                        this._fbottomadBigLoader.load(new URLRequest(_loc_3));
                    }
                    this._fbottomadSprite.addChild(this._bg);
                    this._fbottomadSprite.addChild(this._bigLoaderContainer);
                    this._fbottomadSprite.addChild(this._smallLoaderContainer);
                    this._fbottomadSprite.addChild(this._close_btn);
                    this._container.addChild(this._fbottomadSprite);
                    this._fbottomadTimer = new Timer(this._fbottomDelay, 0);
                    this._fbottomadTimer.addEventListener(TimerEvent.TIMER, this.playBottomAd);
                    setTimeout(this.runBottomAd, this._bottom_ad_first_display_time);
                    this._state = "loading";
                }
                else
                {
                    this._container.visible = true;
                }
            }
            return;
        }// end function

        public function pingback() : void
        {
            return;
            if (this._adPingback != "")
            {
                new TvSohuURLLoaderUtil().multiSend(this._adPingback);
            }
            return;
        }// end function

        public function close() : void
        {
            this._container.visible = false;
            this._state = "no";
            if (this._fbottomadTimeoutID != 0)
            {
                clearTimeout(this._fbottomadTimeoutID);
            }
            if (this._fbottomadTimer != null)
            {
                this._fbottomadTimer.stop();
            }
            this.hideBottomAd();
            return;
        }// end function

        public function hide() : void
        {
            this._container.visible = false;
            return;
        }// end function

        public function show() : void
        {
            this._container.visible = true;
            return;
        }// end function

        private function resizeBottomAd() : void
        {
            var _loc_1:Number = NaN;
            try
            {
                _loc_1 = 0;
                if (this._fbottomadSprite != null && this._fbottomadSprite.numChildren > 1)
                {
                    this._container.setChildIndex(this._fbottomadSprite, (this._container.numChildren - 1));
                    if (this._isFButtomAd)
                    {
                        if (this._fbottomadSmallLoader != null)
                        {
                            if (this._isPlaying)
                            {
                                this._fbottomadSmallLoader.visible = true;
                                _loc_1 = this._fbottomadSmallLoader.content["height"];
                                if (this._smallAdCloseBtnX > 0)
                                {
                                    this._close_btn.x = this._smallAdCloseBtnX;
                                }
                                else
                                {
                                    this._close_btn.x = this._fbottomadSmallLoader.x + this._fbottomadSmallLoader.content["width"] - this._close_btn.width - 2;
                                }
                                if (this._smallAdCloseBtnY > 0)
                                {
                                    this._close_btn.y = this._smallAdCloseBtnY;
                                }
                                else
                                {
                                    this._close_btn.y = 2;
                                }
                            }
                        }
                    }
                    else if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                    {
                        if (this._fbottomadBigLoader != null)
                        {
                            if (this._isPlaying)
                            {
                                this._fbottomadBigLoader.visible = true;
                                _loc_1 = this._fbottomadBigLoader.contentLoaderInfo.height;
                                if (this._bigAdCloseBtnX > 0)
                                {
                                    this._close_btn.x = this._bigAdCloseBtnX;
                                }
                                else
                                {
                                    this._close_btn.x = this._fbottomadBigLoader.x + this._fbottomadBigLoader.contentLoaderInfo.width - this._close_btn.width - 2;
                                }
                                if (this._smallAdCloseBtnY > 0)
                                {
                                    this._close_btn.y = this._bigAdCloseBtnY;
                                }
                                else
                                {
                                    this._close_btn.y = 2;
                                }
                            }
                        }
                        if (this._fbottomadSmallLoader != null)
                        {
                            this._fbottomadSmallLoader.visible = false;
                        }
                    }
                    else
                    {
                        if (this._fbottomadSmallLoader != null)
                        {
                            if (this._isPlaying)
                            {
                                this._fbottomadSmallLoader.visible = true;
                                _loc_1 = this._fbottomadSmallLoader.contentLoaderInfo.height;
                                if (this._smallAdCloseBtnX > 0)
                                {
                                    this._close_btn.x = this._smallAdCloseBtnX;
                                }
                                else
                                {
                                    this._close_btn.x = this._fbottomadSmallLoader.x + this._fbottomadSmallLoader.contentLoaderInfo.width - this._close_btn.width - 2;
                                }
                                if (this._smallAdCloseBtnY > 0)
                                {
                                    this._close_btn.y = this._smallAdCloseBtnY;
                                }
                                else
                                {
                                    this._close_btn.y = 2;
                                }
                            }
                        }
                        if (this._fbottomadBigLoader != null)
                        {
                            this._fbottomadBigLoader.visible = false;
                        }
                    }
                }
            }
            catch (evt:Error)
            {
            }
            return;
        }// end function

        private function runBottomAd() : void
        {
            this._fbottomadTimer.start();
            this.playBottomAd();
            return;
        }// end function

        private function playBottomAd(... args) : void
        {
            args = new activation;
            var _loc_loader:Loader;
            var mh:Number;
            var args:* = args;
            this.resizeBottomAd();
            if (this._fbottomadSprite != null && this._fbottomadSprite.numChildren > 1)
            {
                this._fbottomadSprite.visible = true;
                this._fbottomadIsUp = true;
                mh;
                if (this._fbottomadTimeoutID != 0)
                {
                    clearTimeout(this._fbottomadTimeoutID);
                }
                if (this._isFButtomAd)
                {
                    if (this._fbottomadSmallLoader != null)
                    {
                        this._fbottomadSmallLoader.visible = true;
                        try
                        {
                            this._fbottomadWidth = this._fbottomadSmallLoader.content["width"];
                        }
                        catch (evt)
                        {
                        }
                        _loc_loader = this._fbottomadSmallLoader;
                        this._fbottomadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_xt"));
                        this._close_btn.visible = true;
                        if (this._smallAdCloseBtnX > 0)
                        {
                            this._close_btn.x = this._smallAdCloseBtnX;
                        }
                        else
                        {
                            this._close_btn.x = this._fbottomadSmallLoader.x + this._fbottomadWidth - this._close_btn.width - 2;
                        }
                        if (this._smallAdCloseBtnY > 0)
                        {
                            this._close_btn.y = this._smallAdCloseBtnY;
                        }
                        else
                        {
                            this._close_btn.y = 2;
                        }
                    }
                }
                else if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                {
                    if (this._fbottomadBigLoader != null)
                    {
                        this._fbottomadBigLoader.visible = true;
                        try
                        {
                            this._fbottomadWidth = this._fbottomadBigLoader.contentLoaderInfo.width;
                        }
                        catch (evt)
                        {
                        }
                        _loc_loader = this._fbottomadBigLoader;
                        this._fbottomadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_xt"));
                        this._close_btn.visible = true;
                        if (this._bigAdCloseBtnX > 0)
                        {
                            this._close_btn.x = this._bigAdCloseBtnX;
                        }
                        else
                        {
                            this._close_btn.x = this._fbottomadBigLoader.x + this._fbottomadWidth - this._close_btn.width - 2;
                        }
                        if (this._smallAdCloseBtnY > 0)
                        {
                            this._close_btn.y = this._bigAdCloseBtnY;
                        }
                        else
                        {
                            this._close_btn.y = 2;
                        }
                    }
                    if (this._fbottomadSmallLoader != null)
                    {
                        this._fbottomadSmallLoader.visible = false;
                    }
                }
                else
                {
                    if (this._fbottomadSmallLoader != null)
                    {
                        this._fbottomadSmallLoader.visible = true;
                        try
                        {
                            this._fbottomadWidth = this._fbottomadSmallLoader.contentLoaderInfo.width;
                        }
                        catch (evt)
                        {
                        }
                        _loc_loader = this._fbottomadSmallLoader;
                        this._fbottomadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_xt"));
                        this._close_btn.visible = true;
                        if (this._smallAdCloseBtnX > 0)
                        {
                            this._close_btn.x = this._smallAdCloseBtnX;
                        }
                        else
                        {
                            this._close_btn.x = this._fbottomadSmallLoader.x + this._fbottomadWidth - this._close_btn.width - 2;
                        }
                        if (this._smallAdCloseBtnY > 0)
                        {
                            this._close_btn.y = this._smallAdCloseBtnY;
                        }
                        else
                        {
                            this._close_btn.y = 2;
                        }
                    }
                    if (this._fbottomadBigLoader != null)
                    {
                        this._fbottomadBigLoader.visible = false;
                    }
                }
                if (this._fbottomTimeout > 0)
                {
                    this._fbottomadTimeoutID = setTimeout(this.hideBottomAd, this._fbottomTimeout);
                }
                if ( != null)
                {
                    contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
                }
                dispatchEvent(new TvSohuAdsEvent(TvSohuAdsEvent.BOTTOMSHOWN));
                this._isPlaying = true;
                this.pingback();
            }
            return;
        }// end function

        private function hideBottomAd() : void
        {
            if (this._fbottomadSprite != null)
            {
                this._fbottomadSprite.visible = false;
            }
            this._fbottomadIsUp = false;
            this._close_btn.visible = false;
            dispatchEvent(new TvSohuAdsEvent(TvSohuAdsEvent.BOTTOMHIDE));
            this._isPlaying = false;
            this._isFButtomAd = false;
            return;
        }// end function

        private function fbottomCloseHandler(event:MouseEvent) : void
        {
            if (this._fbottomadTimeoutID != 0)
            {
                clearTimeout(this._fbottomadTimeoutID);
            }
            this.hideBottomAd();
            return;
        }// end function

        private function fbottomadSmallCompleteHandler(event:Event) : void
        {
            var evt:* = event;
            this._smallLoaderContainer.addChild(this._fbottomadSmallLoader);
            this._fbottomadSmallLoader.visible = false;
            this._fbottomadSmallLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                _fbottomadSmallLoader.content["clickUrl"] = _adClick;
                return;
            }// end function
            );
            this._fbottomadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
            this._fbottomadSmallLoader.contentLoaderInfo.sharedEvents.addEventListener("resize", this.smallResize);
            this.resize(this._width, this._height);
            return;
        }// end function

        private function fbottomadSmallErrorHandler(event:IOErrorEvent) : void
        {
            this._fbottomadSmallLoader = null;
            return;
        }// end function

        private function fbottomadBigCompleteHandler(event:Event) : void
        {
            var evt:* = event;
            this._bigLoaderContainer.addChild(this._fbottomadBigLoader);
            this._fbottomadBigLoader.visible = false;
            this._fbottomadBigLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                _fbottomadBigLoader.content["clickUrl"] = _adClick;
                return;
            }// end function
            );
            this._fbottomadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
            this._fbottomadBigLoader.contentLoaderInfo.sharedEvents.addEventListener("resize", this.bigadResize);
            this.resize(this._width, this._height);
            return;
        }// end function

        private function fbottomadBigErrorHandler(event:IOErrorEvent) : void
        {
            this._fbottomadBigLoader = null;
            return;
        }// end function

        private function smallResize(event:Event) : void
        {
            var _loc_2:* = this._fbottomadSmallLoader.content["width"];
            var _loc_6:* = this._fbottomadSmallLoader.content["height"];
            this._smallGoogleAdHeight = this._fbottomadSmallLoader.content["height"];
            var _loc_3:* = _loc_6;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            if (this.isFButtomAd)
            {
                _loc_4 = this._fbottomadSmallLoader.content["width"];
                _loc_5 = this._fbottomadSmallLoader.content["height"];
            }
            else
            {
                _loc_4 = this._fbottomadSmallLoader.contentLoaderInfo.width;
                _loc_5 = this._fbottomadSmallLoader.contentLoaderInfo.height;
            }
            this._smallAdCloseBtnX = this._fbottomadSmallLoader.x + (_loc_4 / 2 + _loc_2 / 2 - this._close_btn.width) - 2;
            this._smallAdCloseBtnY = _loc_5 - _loc_3 + 2;
            this.resize(this._width, this._height);
            return;
        }// end function

        private function bigadResize(event:Event) : void
        {
            var _loc_2:* = this._fbottomadBigLoader.content["width"];
            var _loc_3:* = this._fbottomadBigLoader.content["height"];
            var _loc_4:* = this._fbottomadBigLoader.contentLoaderInfo.width;
            var _loc_5:* = this._fbottomadBigLoader.contentLoaderInfo.height;
            this._bigAdCloseBtnX = this._fbottomadBigLoader.x + (_loc_4 / 2 + _loc_2 / 2 - this._close_btn.width) - 2;
            this._bigAdCloseBtnY = _loc_5 - _loc_3 + 2;
            this.resize(this._width, this._height);
            return;
        }// end function

        public function get hasAd() : Boolean
        {
            return this._adPath == "" ? (false) : (true);
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
                if (this._fbottomadSmallLoader != null && this._fbottomadBigLoader != null)
                {
                    this._fbottomadSmallLoader.x = Math.round(w - this._fbottomadSmallLoader.contentLoaderInfo.width) / 2;
                    this._fbottomadSmallLoader.y = 0;
                    this._fbottomadBigLoader.x = Math.round(w - this._fbottomadBigLoader.contentLoaderInfo.width) / 2;
                    this._fbottomadBigLoader.y = 0;
                    if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                    {
                        this._smallLoaderContainer.visible = false;
                        this._bigLoaderContainer.visible = true;
                    }
                    else
                    {
                        this._smallLoaderContainer.visible = true;
                        this._bigLoaderContainer.visible = false;
                    }
                }
                else if (this._fbottomadSmallLoader != null && this._isFButtomAd)
                {
                    this._fbottomadSmallLoader.x = Math.round(w - this._fbottomadSmallLoader.content["width"]) / 2;
                    this._fbottomadSmallLoader.y = 0;
                    this._smallLoaderContainer.visible = true;
                }
            }
            catch (evt)
            {
                Utils.debug("55555");
            }
            this.resizeBottomAd();
            return;
        }// end function

        public function get height() : Number
        {
            var h:int;
            if (this.isShow)
            {
                try
                {
                    if (this._fbottomadSmallLoader != null && this._fbottomadBigLoader != null)
                    {
                        if (this._container.stage.displayState != StageDisplayState.FULL_SCREEN && !PlayerConfig.isBrowserFullScreen)
                        {
                            h = this._fbottomadSmallLoader.contentLoaderInfo.height;
                        }
                        else
                        {
                            h = this._fbottomadBigLoader.contentLoaderInfo.height;
                        }
                    }
                    else if (this._fbottomadSmallLoader != null && this._isFButtomAd)
                    {
                        h = this._fbottomadSmallLoader.content["height"];
                    }
                }
                catch (evt)
                {
                }
            }
            return h;
        }// end function

        public function get isShow() : Boolean
        {
            if (this._fbottomadSmallLoader != null && this._fbottomadSmallLoader.contentLoaderInfo != null && this._fbottomadBigLoader != null && this._fbottomadBigLoader.contentLoaderInfo != null && (this._fbottomadSmallLoader.visible || this._fbottomadBigLoader.visible) && this._container.visible && this._fbottomadSprite.visible)
            {
                return true;
            }
            if (this._isFButtomAd && this._fbottomadSmallLoader != null && this._fbottomadSmallLoader.contentLoaderInfo != null && this._fbottomadSmallLoader.visible && this._container.visible && this._fbottomadSprite.visible)
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
            return Utils.getType(param1, ".") == param2;
        }// end function

        public function set isFButtomAd(param1:Boolean) : void
        {
            this._isFButtomAd = param1;
            return;
        }// end function

        public function get isFButtomAd() : Boolean
        {
            return this._isFButtomAd;
        }// end function

    }
}
