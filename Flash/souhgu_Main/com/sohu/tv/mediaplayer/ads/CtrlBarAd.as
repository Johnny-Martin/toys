package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class CtrlBarAd extends EventDispatcher
    {
        private var _adPath:String = "";
        private var _adContent:DisplayObject;
        private var _state:String = "no";
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _showPause:Boolean;
        private var _container:Sprite;
        private var _normalAdMask:Sprite;
        private var _fullAdMask:Sprite;
        private var _normalAdPath:String = "";
        private var _fullAdPath:String = "";
        private var _adPingback:String = "";
        private var _adClick:String = "";
        private var _normalAd_c:Sprite;
        private var _fullAd_c:Sprite;
        private var _isReady:Boolean = false;
        private var _adClicklayerfbar:Boolean = false;
        private var _fullAdHitAre:Sprite;
        private var _normalAdHitAre:Sprite;
        private var _isSendAdPlayStock:Boolean = false;
        private var _adClickStat:String = "";
        private var _adIcon:Sprite;
        private var _adIcon1:Sprite;
        private var _adHardFlag:String = "0";
        private var _adDspSource:String = "";
        private var _adIconTxt:TextField;
        private var _adIconTxt1:TextField;

        public function CtrlBarAd()
        {
            this._adIconTxt = new TextField();
            this._adIconTxt1 = new TextField();
            this._normalAdMask = new Sprite();
            this._normalAd_c = new Sprite();
            this._fullAd_c = new Sprite();
            this._fullAdMask = new Sprite();
            Utils.drawRect(this._normalAdMask, 0, 0, 280, 20, 0, 1);
            Utils.drawRect(this._fullAdMask, 0, 0, 420, 20, 0, 1);
            this._adIcon = new Sprite();
            this._adIcon1 = new Sprite();
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
            var _loc_2:* = this._adPath.split("|");
            this._normalAdPath = _loc_2[0];
            this._fullAdPath = _loc_2.length > 1 ? (_loc_2[1]) : ("");
            this._adClick = param1.adClick;
            this._adClickStat = param1.adClickStat != null && param1.adClickStat != undefined && param1.adClickStat != "undefined" ? (param1.adClickStat) : ("");
            this._adPingback = param1.adPingback != null && param1.adPingback != undefined && param1.adPingback != "undefined" ? (param1.adPingback) : ("");
            this._adClicklayerfbar = param1.adClicklayerfbar != null && param1.adClicklayerfbar != undefined && param1.adClicklayerfbar != "undefined" && param1.adClicklayerfbar != "" && (param1.adClicklayerfbar == true || param1.adClicklayerfbar == "true") ? (true) : (false);
            this._adHardFlag = param1.hardFlag != null && param1.hardFlag != undefined && param1.hardFlag != "undefined" && param1.hardFlag != "" ? (param1.hardFlag) : ("0");
            this._adDspSource = param1.fbardspsource != null && param1.fbardspsource != undefined && param1.fbardspsource != "undefined" && param1.fbardspsource != "" ? (param1.fbardspsource + " ") : ("");
            var _loc_3:* = new TextFormat();
            _loc_3.color = 16777215;
            _loc_3.leading = -2;
            _loc_3.size = 9;
            _loc_3.font = PlayerConfig.MICROSOFT_YAHEI;
            this._adIconTxt.autoSize = TextFieldAutoSize.LEFT;
            this._adIconTxt.selectable = false;
            this._adIconTxt.text = this._adDspSource + "广告";
            this._adIconTxt.setTextFormat(_loc_3);
            Utils.drawRect(this._adIcon, 0, 0, this._adIconTxt.width, this._adIconTxt.height, 0, 0.6);
            this._adIconTxt1.autoSize = TextFieldAutoSize.LEFT;
            this._adIconTxt1.selectable = false;
            this._adIconTxt1.text = this._adDspSource + "广告";
            this._adIconTxt1.setTextFormat(_loc_3);
            Utils.drawRect(this._adIcon1, 0, 0, this._adIconTxt1.width, this._adIconTxt1.height, 0, 0.6);
            this._adIconTxt.x = (this._adIcon.width - this._adIconTxt.textWidth) / 2 - 1.7;
            this._adIconTxt.y = (this._adIcon.height - this._adIconTxt.height) / 2 - 1;
            this._adIconTxt1.x = (this._adIcon1.width - this._adIconTxt1.textWidth) / 2 - 1.7;
            this._adIconTxt1.y = (this._adIcon1.height - this._adIconTxt1.height) / 2 - 1;
            return;
        }// end function

        public function play() : void
        {
            if (this._adContent == null && this._adPath != "")
            {
                if (this._state == "no")
                {
                    this.loadNormalAd();
                    this.loadFullAd();
                    this._state = "loading";
                    this.pingback();
                }
            }
            return;
        }// end function

        public function pingback() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:RegExp = null;
            if (!this._isSendAdPlayStock && this._adPingback != "")
            {
                this._isSendAdPlayStock = true;
                _loc_1 = this._adPingback.split("?").length > 1 ? ("&" + this._adPingback.split("?")[1]) : ("");
                _loc_2 = "";
                if (this._normalAdPath != "")
                {
                    _loc_2 = Utils.getType(this._normalAdPath, ".");
                }
                _loc_3 = this._adPath != "" ? ("act") : ("na");
                _loc_4 = PlayerConfig.domainProperty == "3" ? ("http://ctr.hd.sohu.com/s.gif?prod=56") : ("http://wl.hd.sohu.com/s.gif?prod=flash");
                InforSender.getInstance().sendCustomMesg(_loc_4 + "&systype=" + (PlayerConfig.isHotOrMy ? ("0") : ("1")) + "&cid=" + PlayerConfig.catcode + "&log=" + _loc_3 + "&from=" + PlayerConfig.domainProperty + "&3th=0&adTime=0&adType=" + _loc_2 + "&dmpt=cad&po=b" + "&adUrl=" + (this._adPath != "" ? (escape(this._adPath)) : ("")) + _loc_1);
            }
            if (this._adPingback != "")
            {
                _loc_5 = /\[_TIME]""\[_TIME]/gi;
                new TvSohuURLLoaderUtil().multiSend(this._adPingback.replace(_loc_5, new Date().getTime()));
                this._adPingback = "";
            }
            return;
        }// end function

        private function loadNormalAd() : void
        {
            if (this._normalAdPath != "")
            {
                new LoaderUtil().load(20, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    obj.data.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
                {
                    try
                    {
                        obj.data.content["clickUrl"] = _adClick;
                        obj.data.content["clickStatUrl"] = _adClickStat;
                    }
                    catch (error:Error)
                    {
                    }
                    return;
                }// end function
                );
                    obj.data.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
                    _normalAd_c.addChild(obj.data);
                    if (_container.stage.displayState != "fullScreen" && !PlayerConfig.isBrowserFullScreen || _fullAdPath == "")
                    {
                        _width = obj.data.contentLoaderInfo.width;
                        _height = obj.data.contentLoaderInfo.height;
                    }
                    _adIcon.addChild(_adIconTxt);
                    _normalAd_c.addChild(_adIcon);
                    setIconState(_adIcon, obj.data.contentLoaderInfo.width, obj.data.contentLoaderInfo.height);
                    _normalAdHitAre = new Sprite();
                    var _loc_3:* = obj.data.contentLoaderInfo.height;
                    _height = obj.data.contentLoaderInfo.height;
                    Utils.drawRect(_normalAdHitAre, 0, 0, obj.data.contentLoaderInfo.width, _loc_3, 65280, 0);
                    _normalAdHitAre.buttonMode = true;
                    _normalAdHitAre.addEventListener(MouseEvent.CLICK, adClickHandler);
                    _normalAdHitAre.visible = false;
                    _normalAd_c.addChild(_normalAdHitAre);
                    _normalAd_c.visible = true;
                    _container.addChild(_normalAd_c);
                    _container.addChild(_normalAdMask);
                    _normalAd_c.mask = _normalAdMask;
                    _state = "playing";
                    if (_isReady)
                    {
                        dispatch(TvSohuAdsEvent.CTRLBARSHOWN);
                        dispatchSharedEvent();
                    }
                    else
                    {
                        _isReady = true;
                    }
                }
                return;
            }// end function
            , null, this._normalAdPath);
            }
            return;
        }// end function

        private function loadFullAd() : void
        {
            if (this._fullAdPath != "")
            {
                new LoaderUtil().load(20, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    obj.data.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
                {
                    try
                    {
                        obj.data.content["clickUrl"] = _adClick;
                        obj.data.content["clickStatUrl"] = _adClickStat;
                    }
                    catch (error:Error)
                    {
                    }
                    return;
                }// end function
                );
                    obj.data.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
                    _fullAd_c.addChild(obj.data);
                    if (_container.stage.displayState == "fullScreen" || PlayerConfig.isBrowserFullScreen || _normalAdPath == "")
                    {
                        _width = obj.data.contentLoaderInfo.width;
                        _height = obj.data.contentLoaderInfo.height;
                    }
                    _adIcon1.addChild(_adIconTxt1);
                    _fullAd_c.addChild(_adIcon1);
                    setIconState(_adIcon1, obj.data.contentLoaderInfo.width, obj.data.contentLoaderInfo.height);
                    _fullAdHitAre = new Sprite();
                    Utils.drawRect(_fullAdHitAre, 0, 0, obj.data.contentLoaderInfo.width, obj.data.contentLoaderInfo.height, 15790320, 0);
                    _fullAdHitAre.buttonMode = true;
                    _fullAdHitAre.addEventListener(MouseEvent.CLICK, adClickHandler);
                    _fullAdHitAre.visible = false;
                    _fullAd_c.addChild(_fullAdHitAre);
                    _fullAd_c.visible = true;
                    _container.addChild(_fullAd_c);
                    _container.addChild(_fullAdMask);
                    _fullAd_c.mask = _fullAdMask;
                    _state = "playing";
                    if (_isReady)
                    {
                        dispatch(TvSohuAdsEvent.CTRLBARSHOWN);
                        dispatchSharedEvent();
                    }
                    else
                    {
                        _isReady = true;
                    }
                }
                return;
            }// end function
            , null, this._fullAdPath);
            }
            return;
        }// end function

        private function setIconState(param1:Sprite, param2:Number, param3:Number) : void
        {
            var _loc_4:int = 0;
            switch(this._adHardFlag)
            {
                case "0":
                {
                    param1.visible = false;
                    break;
                }
                case "1":
                {
                    param1.x = _loc_4;
                    param1.y = _loc_4;
                    break;
                }
                case "2":
                {
                    param1.x = _loc_4;
                    param1.y = param3 - param1.height - _loc_4;
                    break;
                }
                case "3":
                {
                    param1.x = param2 - param1.width - _loc_4;
                    param1.y = _loc_4;
                    break;
                }
                case "4":
                {
                    param1.x = param2 - param1.width - _loc_4;
                    param1.y = param3 - param1.height - _loc_4;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get hasAd() : Boolean
        {
            return this._adPath == "" ? (false) : (true);
        }// end function

        public function changeAd() : void
        {
            if (this.hasAd)
            {
                if ((this._container.stage.displayState == "fullScreen" || PlayerConfig.isBrowserFullScreen) && this._fullAdPath != "")
                {
                    this._fullAd_c.visible = true;
                    if (this._fullAdHitAre != null)
                    {
                        this._fullAdHitAre.visible = this._adClicklayerfbar;
                    }
                    this._normalAd_c.visible = false;
                    if (this._normalAdHitAre != null)
                    {
                        this._normalAdHitAre.visible = false;
                    }
                }
                else
                {
                    this._fullAd_c.visible = false;
                    if (this._fullAdHitAre != null)
                    {
                        this._fullAdHitAre.visible = false;
                    }
                    this._normalAd_c.visible = true;
                    if (this._normalAdHitAre != null)
                    {
                        this._normalAdHitAre.visible = this._adClicklayerfbar;
                    }
                }
            }
            return;
        }// end function

        private function adClickHandler(event:MouseEvent) : void
        {
            var _loc_2:RegExp = null;
            if (this._adClick != "")
            {
                Utils.openWindow(this._adClick);
                if (this._adClickStat != "")
                {
                    _loc_2 = /\[_TIME]""\[_TIME]/gi;
                    new TvSohuURLLoaderUtil().multiSend(this._adClickStat.replace(_loc_2, new Date().getTime()));
                }
            }
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:String = "";
            this._fullAdPath = "";
            var _loc_1:* = _loc_1;
            this._normalAdPath = _loc_1;
            this._adPath = _loc_1;
            var _loc_1:Boolean = false;
            this._normalAd_c.visible = false;
            this._fullAd_c.visible = _loc_1;
            if (this._fullAdHitAre != null)
            {
                this._fullAdHitAre.visible = false;
            }
            if (this._normalAdHitAre != null)
            {
                this._normalAdHitAre.visible = false;
            }
            this._state = "no";
            this._isSendAdPlayStock = false;
            return;
        }// end function

        public function dispatchSharedEvent() : void
        {
            var _loc_1:Loader = null;
            if (this._fullAd_c.visible && this._fullAd_c.numChildren >= 1)
            {
                _loc_1 = this._fullAd_c.getChildAt((this._fullAd_c.numChildren - 1)) as Loader;
            }
            else if (this._normalAd_c.visible && this._normalAd_c.numChildren >= 1)
            {
                _loc_1 = this._normalAd_c.getChildAt((this._normalAd_c.numChildren - 1)) as Loader;
            }
            if (_loc_1 != null)
            {
                if (this._container.stage.displayState == "fullScreen" || PlayerConfig.isHide)
                {
                    _loc_1.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_fs"));
                }
                else
                {
                    _loc_1.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show_fs_cx"));
                }
            }
            return;
        }// end function

        public function get width() : Number
        {
            if (this.hasAd)
            {
                return this._fullAd_c.visible && this._fullAdPath != "" ? (this._fullAdMask.width) : (this._normalAdMask.width);
            }
            else
            {
                return 0;
            }
        }// end function

        public function get height() : Number
        {
            if (this.hasAd)
            {
                return this._fullAd_c.visible && this._fullAdPath != "" ? (this._fullAdMask.height) : (this._normalAdMask.height);
            }
            else
            {
                return 0;
            }
        }// end function

        public function get metaWidth() : Number
        {
            return this._fullAd_c.visible ? (420) : (280);
        }// end function

        public function set width(param1:Number) : void
        {
            var _loc_2:Sprite = null;
            if (this._fullAd_c.visible && this._fullAdPath != "")
            {
                _loc_2 = this._fullAdMask;
            }
            else
            {
                _loc_2 = this._normalAdMask;
            }
            _loc_2.width = param1;
            return;
        }// end function

        public function set height(param1:Number) : void
        {
            var _loc_2:Sprite = null;
            if (this._fullAd_c.visible && this._fullAdPath != "")
            {
                _loc_2 = this._fullAdMask;
            }
            else
            {
                _loc_2 = this._normalAdMask;
            }
            _loc_2.height = param1;
            return;
        }// end function

        public function get normalAd_c() : Sprite
        {
            return this._normalAd_c;
        }// end function

        public function get state() : String
        {
            return this._state;
        }// end function

        private function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new TvSohuAdsEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
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
