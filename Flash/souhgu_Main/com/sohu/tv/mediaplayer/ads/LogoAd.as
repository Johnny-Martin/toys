package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class LogoAd extends EventDispatcher
    {
        private var _flogoadSprite:Sprite;
        private var _flogoadSmallLoader:Loader;
        private var _flogoadBigLoader:Loader;
        private var _logoAdReady:Boolean;
        private var _flogoTimeout:Number = 0;
        private var _flogoTimeoutID:Number = 0;
        private var _loc_y:Number;
        private var _logoAdPlayed:Boolean;
        private var _adPath:String = "";
        private var _adDelay:String = "";
        private var _adInternal:String = "";
        private var _adPingback:String = "";
        private var _adClick:String = "";
        private var _owner:LogoAd;
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _container:Sprite;
        private var _state:String = "no";
        private var _flogoInternal:Number = 0;
        private var _adClicklayerflogo:Boolean = false;
        private var _hitAreSmall:Sprite;
        private var _hitAreBig:Sprite;
        private var _isSendAdPlayStock:Boolean = false;
        private var _adFirsttime:String = "";
        private var _adClickStat:String = "";
        private var _adIcon:Sprite;
        private var _adIcon1:Sprite;
        private var _adHardFlag:String = "0";
        private var _coreVideoW:Number;
        private var _smallW:Number;
        private var _smallH:Number;
        private var _bigW:Number;
        private var _bigH:Number;

        public function LogoAd()
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

        public function setCoreValue(param1:Number) : void
        {
            this._coreVideoW = param1;
            if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
            {
                this._adIcon1.visible = true;
                this._adIcon.visible = false;
                this.setIconState(this._adIcon1["littleIcon"], this._bigW, this._bigH, this._adIcon1);
            }
            else
            {
                this._adIcon1.visible = false;
                this._adIcon.visible = true;
                this.setIconState(this._adIcon["littleIcon"], this._smallW, this._smallH, this._adIcon);
            }
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            this._adPath = param1.adPar;
            this._adDelay = param1.adDelayPar;
            this._adInternal = param1.adIntervalPar != null && param1.adIntervalPar != undefined && param1.adIntervalPar != "undefined" ? (param1.adIntervalPar) : ("0");
            this._adClick = param1.adClick;
            this._adClickStat = param1.adClickStat != null && param1.adClickStat != undefined && param1.adClickStat != "undefined" ? (param1.adClickStat) : ("");
            this._adPingback = param1.adPingback != null && param1.adPingback != undefined && param1.adPingback != "undefined" ? (param1.adPingback) : ("");
            this._adClicklayerflogo = param1.adClicklayerflogo != null && param1.adClicklayerflogo != undefined && param1.adClicklayerflogo != "undefined" && param1.adClicklayerflogo != "" && (param1.adClicklayerflogo == "true" || param1.adClicklayerflogo == true) ? (true) : (false);
            this._adFirsttime = param1.adFirsttimePar != null && param1.adFirsttimePar != undefined && param1.adFirsttimePar != "undefined" ? (param1.adFirsttimePar) : ("0");
            this._adHardFlag = param1.hardFlag != null && param1.hardFlag != undefined && param1.hardFlag != "undefined" && param1.hardFlag != "" ? (param1.hardFlag) : ("0");
            return;
        }// end function

        private function flogoadSmallCompleteHandler(event:Event) : void
        {
            var evt:* = event;
            this._flogoadSprite.addChild(this._flogoadSmallLoader);
            this._smallW = this._flogoadSmallLoader.contentLoaderInfo.width;
            this._smallH = this._flogoadSmallLoader.contentLoaderInfo.height;
            this._flogoadSmallLoader.visible = false;
            this._hitAreSmall = new Sprite();
            Utils.drawRect(this._hitAreSmall, 0, 0, this._flogoadSmallLoader.contentLoaderInfo.width, this._flogoadSmallLoader.contentLoaderInfo.height, 16711680, 0);
            this._flogoadSprite.addChild(this._adIcon);
            this._adIcon["littleIcon"].visible = true;
            this._adIcon["bigIcon"].visible = false;
            this.setIconState(this._adIcon["littleIcon"], this._flogoadSmallLoader.contentLoaderInfo.width, this._flogoadSmallLoader.contentLoaderInfo.height, this._adIcon);
            this._flogoadSprite.addChild(this._hitAreSmall);
            this._hitAreSmall.buttonMode = true;
            this._hitAreSmall.addEventListener(MouseEvent.CLICK, this.adClickHandler);
            this._hitAreSmall.visible = false;
            if (!this._adClicklayerflogo)
            {
                this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                try
                {
                    _flogoadSmallLoader.content["clickUrl"] = _adClick;
                    _flogoadSmallLoader.content["clickStatUrl"] = _adClickStat;
                }
                catch (error:Error)
                {
                }
                return;
            }// end function
            );
                this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
            }
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
            this._bigW = this._flogoadBigLoader.contentLoaderInfo.width;
            this._bigH = this._flogoadBigLoader.contentLoaderInfo.height;
            this._flogoadBigLoader.visible = false;
            this._hitAreBig = new Sprite();
            Utils.drawRect(this._hitAreBig, 0, 0, this._flogoadBigLoader.contentLoaderInfo.width, this._flogoadBigLoader.contentLoaderInfo.height, 255, 0);
            this._flogoadSprite.addChild(this._adIcon1);
            this._adIcon1["littleIcon"].visible = true;
            this._adIcon1["bigIcon"].visible = false;
            this.setIconState(this._adIcon1["littleIcon"], this._flogoadBigLoader.contentLoaderInfo.width, this._flogoadBigLoader.contentLoaderInfo.height, this._adIcon1);
            this._flogoadSprite.addChild(this._hitAreBig);
            this._hitAreBig.buttonMode = true;
            this._hitAreBig.addEventListener(MouseEvent.CLICK, this.adClickHandler);
            this._hitAreBig.visible = false;
            if (!this._adClicklayerflogo)
            {
                this._flogoadBigLoader.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                try
                {
                    _flogoadBigLoader.content["clickUrl"] = _adClick;
                    _flogoadSmallLoader.content["clickStatUrl"] = _adClickStat;
                }
                catch (error:Error)
                {
                }
                return;
            }// end function
            );
                this._flogoadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
            }
            if (this._logoAdReady)
            {
                this.playLogoAdd();
            }
            this._logoAdReady = true;
            return;
        }// end function

        private function setIconState(param1:Sprite, param2:Number, param3:Number, param4:Sprite = null) : void
        {
            switch(this._adHardFlag)
            {
                case "0":
                {
                    param4.visible = false;
                    break;
                }
                case "1":
                {
                    var _loc_5:int = 2;
                    param4.y = 2;
                    param4.x = _loc_5;
                    break;
                }
                case "2":
                {
                    param4.x = 2;
                    param4.y = param3 - param1.height - 2;
                    break;
                }
                case "3":
                {
                    param4.x = param2 - param1.width - 2;
                    param4.y = 2;
                    break;
                }
                case "4":
                {
                    param4.x = param2 - param1.width - 2;
                    param4.y = param3 - param1.height - 2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function adClickHandler(event:MouseEvent) : void
        {
            if (this._adClick != "")
            {
                Utils.openWindow(this._adClick);
                if (this._adClickStat != "")
                {
                    new TvSohuURLLoaderUtil().multiSend(this._adClickStat);
                }
            }
            return;
        }// end function

        private function flogoadBigErrorHandler(event:IOErrorEvent) : void
        {
            this._flogoadBigLoader = null;
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
                        this._hitAreBig.visible = this._adClicklayerflogo;
                        if (this._flogoadSmallLoader != null)
                        {
                            args = false;
                            this._hitAreSmall.visible = args;
                            this._flogoadSmallLoader.visible = args;
                        }
                        this._flogoadBigLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_jb"));
                    }
                    else
                    {
                        if (this._flogoadSmallLoader != null)
                        {
                            this._flogoadSmallLoader.visible = true;
                        }
                        this._hitAreSmall.visible = this._adClicklayerflogo;
                        if (this._flogoadBigLoader != null)
                        {
                            var _loc_2:Boolean = false;
                            this._hitAreBig.visible = false;
                            this._flogoadBigLoader.visible = _loc_2;
                        }
                        this._flogoadSmallLoader.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_jb"));
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
                if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                {
                    if (this._flogoadSprite.visible == true)
                    {
                        if (this._flogoadBigLoader != null)
                        {
                            this._flogoadBigLoader.visible = true;
                        }
                        this._hitAreBig.visible = this._adClicklayerflogo;
                        if (this._flogoadSmallLoader != null)
                        {
                            var _loc_2:Boolean = false;
                            this._hitAreSmall.visible = false;
                            this._flogoadSmallLoader.visible = _loc_2;
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
                            var _loc_2:Boolean = false;
                            this._hitAreBig.visible = false;
                            this._flogoadBigLoader.visible = _loc_2;
                        }
                        if (this._flogoadSmallLoader != null)
                        {
                            this._flogoadSmallLoader.visible = true;
                        }
                        this._hitAreSmall.visible = this._adClicklayerflogo;
                    }
                    _loc_1 = false;
                }
            }
            return _loc_1;
        }// end function

        private function hideLogoAd() : void
        {
            this._flogoadSprite.visible = false;
            if (this._flogoTimeout > 0)
            {
                clearTimeout(this._flogoTimeoutID);
            }
            if (this._adInternal != "" && this._adInternal != "0")
            {
                this._flogoInternal = setTimeout(this.loadAndPlayAd, Number(this._adInternal) * 1000);
            }
            else
            {
                this._flogoInternal = setTimeout(this.loadAndPlayAd, PlayerConfig.LOGOAD_DELAY * 1000);
            }
            dispatchEvent(new TvSohuAdsEvent(TvSohuAdsEvent.LOGOFINISH));
            this.destroy();
            return;
        }// end function

        private function loadAndPlayAd() : void
        {
            var ptCode:* = /&pageUrl=""&pageUrl=/;
            var url:* = TvSohuAds.getInstance().fetchAdsUrl;
            url = url.replace(ptCode, "&pt=flogo&pageUrl=");
            new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                var _loc_3:Object = null;
                clearTimeout(_flogoInternal);
                if (param1.info == "success")
                {
                    _loc_2 = new JSON().parse(param1.data);
                    if (_loc_2.status == 1)
                    {
                        _loc_3 = {adPar:_loc_2.data.flogoad, adClick:_loc_2.data.flogoclickurl, adClickStat:_loc_2.data.flogoclickmonitor, adDelayPar:_loc_2.data.flogodelay, adIntervalPar:_loc_2.data.flogointerval, adPingback:_loc_2.data.flogopingback, adClicklayerflogo:_loc_2.data.clicklayerflogo, hardFlag:_loc_2.data.flogohardflag};
                        softInit(_loc_3);
                        play();
                    }
                    else
                    {
                        hideLogoAd();
                    }
                }
                else
                {
                    hideLogoAd();
                }
                return;
            }// end function
            , url + "&m=" + new Date().getTime());
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
                        if (this._adDelay != "")
                        {
                            this._flogoTimeout = Number(this._adDelay) * 1000;
                        }
                        else
                        {
                            this._flogoTimeout = 10 * 1000;
                        }
                        if (this.checkUrl(_loc_2, "swf") || this.checkUrl(_loc_2, "jpg") || this.checkUrl(_loc_2, "gif") || this.checkUrl(_loc_2, "jpeg") || this.checkUrl(_loc_2, "SWF") || this.checkUrl(_loc_2, "JPG") || this.checkUrl(_loc_2, "GIF") || this.checkUrl(_loc_2, "JPEG"))
                        {
                            this._flogoadSmallLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.flogoadSmallCompleteHandler);
                            this._flogoadSmallLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.flogoadSmallErrorHandler);
                            this._flogoadSmallLoader.load(new URLRequest(_loc_2));
                        }
                        if (this.checkUrl(_loc_3, "swf") || this.checkUrl(_loc_3, "jpg") || this.checkUrl(_loc_3, "gif") || this.checkUrl(_loc_2, "jpeg") || this.checkUrl(_loc_3, "SWF") || this.checkUrl(_loc_3, "JPG") || this.checkUrl(_loc_3, "GIF") || this.checkUrl(_loc_2, "JPEG"))
                        {
                            this._flogoadBigLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.flogoadBigCompleteHandler);
                            this._flogoadBigLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.flogoadBigErrorHandler);
                            this._flogoadBigLoader.load(new URLRequest(_loc_3));
                        }
                    }
                    else
                    {
                        this.hideLogoAd();
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
            return;
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            if (!this._isSendAdPlayStock && this._adPingback != "")
            {
                this._isSendAdPlayStock = true;
                _loc_1 = this._adPingback.split("?").length > 1 ? ("&" + this._adPingback.split("?")[1]) : ("");
                _loc_2 = "";
                if (this._adPath.split("|")[0] != "")
                {
                    _loc_2 = Utils.getType(this._adPath.split("|")[0], ".");
                }
                _loc_3 = this._adPath != "" ? ("act") : ("na");
                _loc_4 = PlayerConfig.domainProperty == "3" ? ("http://ctr.hd.sohu.com/s.gif?prod=56") : ("http://wl.hd.sohu.com/s.gif?prod=flash");
                InforSender.getInstance().sendCustomMesg(_loc_4 + "&systype=" + (PlayerConfig.isHotOrMy ? ("0") : ("1")) + "&cid=" + PlayerConfig.catcode + "&log=" + _loc_3 + "&from=" + PlayerConfig.domainProperty + "&3th=0&adTime=0&adType=" + _loc_2 + "&dmpt=lad&po=b" + "&adUrl=" + (this._adPath != "" ? (escape(this._adPath)) : ("")) + _loc_1);
            }
            if (this._adPingback != "")
            {
                new TvSohuURLLoaderUtil().multiSend(this._adPingback);
            }
            return;
        }// end function

        private function playLogoAdd() : void
        {
            if (this._state == "playing")
            {
                if (this._adPath != "")
                {
                    if (this._adFirsttime != "" && this._adFirsttime != "0")
                    {
                        setTimeout(this.playLogoAd, Number(this._adFirsttime) * 1000);
                    }
                    else
                    {
                        this.playLogoAd();
                    }
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
            if (this._flogoadSprite != null)
            {
                this._flogoadSprite.visible = false;
            }
            clearTimeout(this._flogoInternal);
            if (this._flogoTimeout > 0)
            {
                clearTimeout(this._flogoTimeoutID);
            }
            this.destroy();
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

        private function destroy() : void
        {
            var _loc_1:uint = 0;
            var _loc_2:uint = 0;
            var _loc_3:String = "";
            this._adClick = "";
            var _loc_3:* = _loc_3;
            this._adPingback = _loc_3;
            var _loc_3:* = _loc_3;
            this._adInternal = _loc_3;
            var _loc_3:* = _loc_3;
            this._adDelay = _loc_3;
            var _loc_3:* = _loc_3;
            this._adFirsttime = _loc_3;
            this._adPath = _loc_3;
            this._state = "no";
            var _loc_3:Boolean = false;
            this._logoAdPlayed = false;
            this._logoAdReady = _loc_3;
            this._isSendAdPlayStock = false;
            if (this._flogoadSprite != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this._flogoadSprite.numChildren)
                {
                    
                    this._flogoadSprite.removeChildAt(0);
                    _loc_1 = _loc_1 + 1;
                }
            }
            if (this._container != null)
            {
                _loc_2 = 0;
                while (_loc_2 < this._container.numChildren)
                {
                    
                    this._container.removeChildAt(0);
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        public function set adIconClass(param1:Class) : void
        {
            this._adIcon = new param1;
            this._adIcon1 = new param1;
            return;
        }// end function

    }
}
