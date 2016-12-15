package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;

    public class PauseAd2 extends EventDispatcher implements IAds
    {
        protected var _adPath:String;
        private var _adPingback:String = "";
        private var _adClick:String = "";
        private var _adClickStat:String = "";
        protected var _showPause:Boolean;
        protected var _normalAdContent:Loader;
        protected var _fullAdContent:Loader;
        protected var _owner:PauseAd;
        protected var _state:String = "no";
        protected var _normalAdCloseBtn:Sprite;
        protected var _fullAdCloseBtn:Sprite;
        protected var _container:Sprite;
        private var _adLoader:URLLoaderUtil;
        private var _padSfunc:String = "";
        private var _adAlign:String = "";
        private var _normalAdW:Number = 0;
        private var _normalAdH:Number = 0;
        private var _fullAdW:Number = 0;
        private var _fullAdH:Number = 0;
        private var _thirdAds:Boolean = false;
        private var _stageW:Number = 0;
        private var _stageH:Number = 0;
        private var _adClickLayer:Boolean = false;
        private var _normalAdPath:String = "";
        private var _fullAdPath:String = "";
        private var _normalAd_c:Sprite;
        private var _fullAd_c:Sprite;
        private var _normalAdMask:Sprite;
        private var _fullAdMask:Sprite;
        private var _fullAdHitAre:Sprite;
        private var _normalAdHitAre:Sprite;
        private var _isSendAdPlayStock:Boolean = false;
        private var _adIcon:Sprite;
        private var _adIcon1:Sprite;
        private var _adHardFlag:String = "0";

        public function PauseAd2()
        {
            this._normalAdCloseBtn = new Sprite();
            this._fullAdCloseBtn = new Sprite();
            this._normalAd_c = new Sprite();
            this._fullAd_c = new Sprite();
            this._adLoader = new URLLoaderUtil();
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
            var _loc_2:String = null;
            var _loc_3:Array = null;
            if (param1.adPar != null && param1.adPar != "")
            {
                _loc_2 = param1.adPar;
                this._adPath = _loc_2;
                _loc_3 = this._adPath.split("|");
                this._normalAdPath = _loc_3[0];
                this._fullAdPath = _loc_3.length > 1 ? (_loc_3[1]) : ("");
            }
            this._adClick = param1.adClick;
            this._adClickStat = param1.adClickStat != null && param1.adClickStat != undefined && param1.adClickStat != "undefined" ? (param1.adClickStat) : ("");
            this._adPingback = param1.adPingback != null && param1.adPingback != undefined && param1.adPingback != "undefined" ? (param1.adPingback) : ("");
            this._padSfunc = param1.padsfunc != null && param1.padsfunc != undefined && param1.padsfunc != "undefined" && param1.padsfunc != "" ? (param1.padsfunc) : ("");
            this._adAlign = param1.adAlign != null && param1.adAlign != undefined && param1.adAlign != "undefined" && param1.adAlign != "" ? (param1.adAlign) : ("");
            this._adClickLayer = param1.adClickLayer != null && param1.adClickLayer != undefined && param1.adClickLayer != "undefined" && param1.adClickLayer != "" && (param1.adClickLayer == "true" || param1.adClickLayer == true) ? (true) : (false);
            this._adHardFlag = param1.hardFlag != null && param1.hardFlag != undefined && param1.hardFlag != "undefined" && param1.hardFlag != "" ? (param1.hardFlag) : ("0");
            return;
        }// end function

        public function play() : void
        {
            var vipUser:* = Utils.getBrowserCookie("fee_status");
            var vu:* = PlayerConfig.passportMail != "" && vipUser != "" && PlayerConfig.passportMail == vipUser ? ("&vu=" + vipUser) : (vipUser);
            var ptCode:* = /&pageUrl=""&pageUrl=/;
            var url:* = TvSohuAds.getInstance().fetchAdsUrl;
            url = url.replace(ptCode, "&pt=pad&pageUrl=");
            this._adLoader.load(10, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                if (param1.info == "success")
                {
                    AdLog.msg("==========暂停广告信息(json)开始==========");
                    AdLog.msg(param1.data);
                    AdLog.msg("==========暂停广告信息(json)结束==========");
                    _loc_2 = new JSON().parse(param1.data);
                    if (_loc_2.status == 1)
                    {
                        destroy();
                        softInit({adPar:_loc_2.data.pad, adClick:_loc_2.data.padclickurl, adPingback:_loc_2.data.padpingback, adClickStat:_loc_2.data.clickmonitor, padsfunc:_loc_2.data.padsfunc, adAlign:_loc_2.data.align, adClickLayer:_loc_2.data.clicklayer, hardFlag:_loc_2.data.padhardflag});
                        if (_normalAdPath != "" || _fullAdPath != "")
                        {
                            AdLog.msg("暂停广告地址 : :" + _normalAdPath + "|" + _fullAdPath);
                            _showPause = true;
                            if (_normalAdContent == null && _fullAdContent == null)
                            {
                                if (_state == "no")
                                {
                                    new LoaderUtil().load(20, loadNormalAd, null, _normalAdPath);
                                    new LoaderUtil().load(20, loadFullAd, null, _fullAdPath);
                                    _state = "loading";
                                    pingback();
                                    AdLog.msg("分别loader普屏和全屏暂停广告");
                                }
                            }
                            else if (_showPause)
                            {
                                AdLog.msg("有暂停广告直接展示");
                                if ((_container.stage.displayState == "fullScreen" || PlayerConfig.isBrowserFullScreen) && _fullAdPath != "")
                                {
                                    _fullAd_c.visible = true;
                                    _normalAd_c.visible = false;
                                    _fullAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
                                }
                                else
                                {
                                    _normalAd_c.visible = true;
                                    _fullAd_c.visible = false;
                                    _normalAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
                                }
                                _container.visible = true;
                                _state = "playing";
                            }
                            else
                            {
                                AdLog.msg("关闭现有的暂停广告");
                                close();
                            }
                        }
                        else
                        {
                            AdLog.msg("无暂停广告");
                            pingback();
                        }
                    }
                }
                return;
            }// end function
            , url + "&m=" + new Date().getTime());
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
                _loc_1 = "";
                _loc_2 = this._adPingback.split("?").length > 1 ? ("&" + this._adPingback.split("?")[1]) : ("");
                if (this._normalAdPath != "")
                {
                    _loc_1 = Utils.getType(this._normalAdPath, ".");
                }
                _loc_3 = this._adPath != "" ? ("act") : ("na");
                _loc_4 = PlayerConfig.domainProperty == "3" ? ("http://ctr.hd.sohu.com/s.gif?prod=56") : ("http://wl.hd.sohu.com/s.gif?prod=flash");
                InforSender.getInstance().sendCustomMesg(_loc_4 + "&systype=" + (PlayerConfig.isHotOrMy ? ("0") : ("1")) + "&cid=" + PlayerConfig.catcode + "&log=" + _loc_3 + "&from=" + PlayerConfig.domainProperty + "&3th=0&adTime=0&adType=" + _loc_1 + "&dmpt=pad&po=b" + "&adUrl=" + (this._adPath != "" ? (escape(this._adPath)) : ("")) + _loc_2);
            }
            if (this._adPingback != "")
            {
                if (this._padSfunc != "" && ExternalInterface.available)
                {
                    ExternalInterface.call(this._padSfunc, 0, this._adPingback);
                }
                else
                {
                    new TvSohuURLLoaderUtil().multiSend(this._adPingback);
                }
            }
            return;
        }// end function

        protected function loadNormalAd(param1:Object) : void
        {
            var obj:* = param1;
            if (obj.info == "success")
            {
                this._normalAdContent = obj.data;
                this._normalAdW = obj.data.contentLoaderInfo.width;
                this._normalAdH = obj.data.contentLoaderInfo.height;
                this._normalAdCloseBtn = this.closeBtnSp(this._normalAdCloseBtn);
                this._normalAdCloseBtn.x = Math.round(this._normalAdW - this._normalAdCloseBtn.width / 2 + 10);
                this._normalAdMask = new Sprite();
                Utils.drawRect(this._normalAdMask, 0, 0, this._normalAdW, this._normalAdH, 0, 0);
                this._normalAdMask.visible = false;
                this._normalAd_c.addChild(this._normalAdMask);
                if (this._adClickLayer)
                {
                    this._normalAdMask.visible = true;
                    this._normalAdContent.mask = this._normalAdMask;
                }
                this._normalAd_c.addChild(this._normalAdContent);
                this._normalAd_c.addChild(this._adIcon);
                this._adIcon["littleIcon"].visible = false;
                this._adIcon["bigIcon"].visible = true;
                this.setIconState(this._adIcon, this._normalAdW, this._normalAdH);
                this._normalAdHitAre = new Sprite();
                Utils.drawRect(this._normalAdHitAre, 0, 0, this._normalAdW, this._normalAdH, 16711680, 0);
                this._normalAd_c.addChild(this._normalAdHitAre);
                this._normalAdHitAre.buttonMode = true;
                this._normalAdHitAre.addEventListener(MouseEvent.CLICK, this.adClickHandler);
                this._normalAd_c.addChild(this._normalAdCloseBtn);
                this._container.addChild(this._normalAd_c);
                this._normalAd_c.visible = false;
                var _loc_3:* = this._adClickLayer;
                this._normalAdCloseBtn.visible = this._adClickLayer;
                this._normalAdHitAre.visible = _loc_3;
                this._normalAdContent.contentLoaderInfo.sharedEvents.addEventListener("resize", this.resize);
                this._normalAdContent.contentLoaderInfo.sharedEvents.addEventListener("noPad", this.noPadHandler);
                this._normalAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
                this._normalAdContent.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                if (_showPause)
                {
                    _normalAdCloseBtn.visible = true;
                    try
                    {
                        _normalAdContent.content["clickUrl"] = _adClick;
                        _normalAdContent.content["clickStatUrl"] = _adClickStat;
                    }
                    catch (error:Error)
                    {
                    }
                }
                return;
            }// end function
            );
                this._normalAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
                this.showFullOrNor();
            }
            return;
        }// end function

        private function setIconState(param1:Sprite, param2:Number, param3:Number) : void
        {
            switch(this._adHardFlag)
            {
                case "0":
                {
                    param1.visible = false;
                    break;
                }
                case "1":
                {
                    param1.x = 2;
                    param1.y = 2;
                    break;
                }
                case "2":
                {
                    param1.x = 2;
                    param1.y = param3 - param1.height - 2;
                    break;
                }
                case "3":
                {
                    param1.x = param2 - param1.width - 2;
                    param1.y = 2;
                    break;
                }
                case "4":
                {
                    param1.x = param2 - param1.width - 2;
                    param1.y = param3 - param1.height - 2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function loadFullAd(param1:Object) : void
        {
            var obj:* = param1;
            if (obj.info == "success")
            {
                this._fullAdContent = obj.data;
                this._fullAdW = obj.data.contentLoaderInfo.width;
                this._fullAdH = obj.data.contentLoaderInfo.height;
                this._fullAdCloseBtn = this.closeBtnSp(this._fullAdCloseBtn);
                this._fullAdCloseBtn.x = Math.round(this._fullAdW - this._fullAdCloseBtn.width / 2 + 10);
                this._fullAdMask = new Sprite();
                Utils.drawRect(this._fullAdMask, 0, 0, this._fullAdW, this._fullAdH, 0, 1);
                this._fullAdMask.visible = false;
                this._fullAd_c.addChild(this._fullAdMask);
                if (this._adClickLayer)
                {
                    this._fullAdMask.visible = true;
                    this._fullAdContent.mask = this._fullAdMask;
                }
                this._fullAd_c.addChild(this._fullAdContent);
                this._fullAd_c.addChild(this._adIcon1);
                this._adIcon1["littleIcon"].visible = false;
                this._adIcon1["bigIcon"].visible = true;
                this.setIconState(this._adIcon1, this._fullAdW, this._fullAdH);
                this._fullAdHitAre = new Sprite();
                Utils.drawRect(this._fullAdHitAre, 0, 0, this._fullAdW, this._fullAdH, 16711680, 0);
                this._fullAd_c.addChild(this._fullAdHitAre);
                this._fullAdHitAre.buttonMode = true;
                this._fullAdHitAre.addEventListener(MouseEvent.CLICK, this.adClickHandler);
                this._fullAd_c.addChild(this._fullAdCloseBtn);
                this._container.addChild(this._fullAd_c);
                this._fullAd_c.visible = false;
                var _loc_3:* = this._adClickLayer;
                this._fullAdCloseBtn.visible = this._adClickLayer;
                this._fullAdHitAre.visible = _loc_3;
                this._fullAdContent.contentLoaderInfo.sharedEvents.addEventListener("resize", this.resize);
                this._fullAdContent.contentLoaderInfo.sharedEvents.addEventListener("noPad", this.noPadHandler);
                this._fullAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_show"));
                this._fullAdContent.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
            {
                if (_showPause)
                {
                    _fullAdCloseBtn.visible = true;
                    try
                    {
                        _fullAdContent.content["clickUrl"] = _adClick;
                        _fullAdContent.content["clickStatUrl"] = _adClickStat;
                    }
                    catch (error:Error)
                    {
                    }
                }
                return;
            }// end function
            );
                this._fullAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_click"));
                this.showFullOrNor();
            }
            return;
        }// end function

        private function showFullOrNor() : void
        {
            if (this._showPause)
            {
                if ((this._container.stage.displayState == "fullScreen" || PlayerConfig.isBrowserFullScreen) && this._fullAdPath != "")
                {
                    this._fullAd_c.visible = true;
                    this._normalAd_c.visible = false;
                    AdLog.msg("展示全屏暂停广告");
                }
                else
                {
                    this._normalAd_c.visible = true;
                    this._fullAd_c.visible = false;
                    AdLog.msg("展示普屏暂停广告");
                }
                this._container.visible = true;
                this._state = "playing";
                this.dispatch(TvSohuAdsEvent.PAUSESHOWN);
            }
            else
            {
                this.close();
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

        private function resize(event:Event) : void
        {
            this._thirdAds = true;
            this.changeSize(this._stageW, this._stageH);
            return;
        }// end function

        public function changeSize(param1:Number, param2:Number) : void
        {
            var w:* = param1;
            var h:* = param2;
            this._stageW = w;
            this._stageH = h;
            try
            {
                this.changeNormalAdSize(w, h);
                this.changeFullAdSize(w, h);
            }
            catch (evt)
            {
            }
            if ((this._container.stage.displayState == "fullScreen" || PlayerConfig.isBrowserFullScreen) && this._fullAdPath != "")
            {
                if (this._fullAd_c != null)
                {
                    this._fullAd_c.visible = true;
                }
                if (this._fullAdHitAre != null)
                {
                    this._fullAdHitAre.visible = this._adClickLayer;
                }
                if (this._normalAd_c != null)
                {
                    this._normalAd_c.visible = false;
                }
                if (this._normalAdHitAre != null)
                {
                    this._normalAdHitAre.visible = false;
                }
            }
            else
            {
                if (this._fullAd_c != null)
                {
                    this._fullAd_c.visible = false;
                }
                if (this._fullAdHitAre != null)
                {
                    this._fullAdHitAre.visible = false;
                }
                if (this._normalAd_c != null)
                {
                    this._normalAd_c.visible = true;
                }
                if (this._normalAdHitAre != null)
                {
                    this._normalAdHitAre.visible = this._adClickLayer;
                }
            }
            return;
        }// end function

        private function changeNormalAdSize(param1:Number, param2:Number) : void
        {
            var _loc_5:Number = NaN;
            var _loc_3:* = this._normalAdW;
            var _loc_4:* = this._normalAdH;
            if (this._normalAdContent != null)
            {
                if (param1 > this._normalAdW + 26 && param2 > this._normalAdH + 26)
                {
                    var _loc_6:int = 1;
                    this._normalAdContent.scaleY = 1;
                    this._normalAdContent.scaleX = _loc_6;
                    this._normalAdW = this._normalAdContent.contentLoaderInfo.width;
                    this._normalAdH = this._normalAdContent.contentLoaderInfo.height;
                }
                else
                {
                    _loc_5 = Math.min(param1 / (_loc_3 + 26), param2 / (_loc_4 + 26));
                    this._normalAdContent.scaleX = _loc_5 * this._normalAdContent.scaleX;
                    this._normalAdContent.scaleY = _loc_5 * this._normalAdContent.scaleY;
                    this._normalAdW = _loc_5 * _loc_3;
                    this._normalAdH = _loc_5 * _loc_4;
                }
                if (this._thirdAds)
                {
                    this._normalAdCloseBtn.x = Math.round(this._normalAdW / 2 + this._normalAdContent.content["width"] * this._normalAdContent.scaleX / 2 - this._normalAdCloseBtn.width / 2 + 10);
                    this._normalAdCloseBtn.y = Math.round(this._normalAdH / 2 - this._normalAdContent.content["height"] * this._normalAdContent.scaleY / 2);
                    this._normalAdCloseBtn.visible = true;
                }
                else
                {
                    this._normalAdCloseBtn.x = Math.round(this._normalAdW - this._normalAdCloseBtn.width / 2 + 10);
                }
                this.setIconState(this._adIcon, this._normalAdW, this._normalAdH);
            }
            if (this._adClickLayer && this._normalAdHitAre != null)
            {
                this._normalAdHitAre.width = this._normalAdW;
                this._normalAdHitAre.height = this._normalAdW;
            }
            if (this._adClickLayer && this._normalAdMask != null)
            {
                this._normalAdMask.width = this._normalAdW;
                this._normalAdMask.height = this._normalAdH;
                this._normalAdContent.mask = this._normalAdMask;
            }
            return;
        }// end function

        private function changeFullAdSize(param1:Number, param2:Number) : void
        {
            var _loc_5:Number = NaN;
            var _loc_3:* = this._fullAdW;
            var _loc_4:* = this._fullAdH;
            if (this._fullAdContent != null)
            {
                if (param1 > this._fullAdW + 26 && param2 > this._fullAdH + 26)
                {
                    var _loc_6:int = 1;
                    this._fullAdContent.scaleY = 1;
                    this._fullAdContent.scaleX = _loc_6;
                    this._fullAdW = this._fullAdContent.contentLoaderInfo.width;
                    this._fullAdH = this._fullAdContent.contentLoaderInfo.height;
                }
                else
                {
                    _loc_5 = Math.min(param1 / (_loc_3 + 26), param2 / (_loc_4 + 26));
                    this._fullAdContent.scaleX = _loc_5 * this._fullAdContent.scaleX;
                    this._fullAdContent.scaleY = _loc_5 * this._fullAdContent.scaleY;
                    this._fullAdW = _loc_5 * _loc_3;
                    this._fullAdH = _loc_5 * _loc_4;
                }
                if (this._thirdAds)
                {
                    this._fullAdCloseBtn.x = Math.round(this._fullAdW / 2 + this._fullAdContent.content["width"] * this._fullAdContent.scaleX / 2 - this._fullAdCloseBtn.width / 2 + 10);
                    this._fullAdCloseBtn.y = Math.round(this._fullAdH / 2 - this._fullAdContent.content["height"] * this._fullAdContent.scaleY / 2);
                    this._fullAdCloseBtn.visible = true;
                }
                else
                {
                    this._fullAdCloseBtn.x = Math.round(this._fullAdW - this._fullAdCloseBtn.width / 2 + 10);
                }
                this.setIconState(this._adIcon1, this._fullAdW, this._fullAdH);
            }
            if (this._adClickLayer && this._fullAdHitAre != null)
            {
                this._fullAdHitAre.width = this._fullAdW;
                this._fullAdHitAre.height = this._fullAdH;
            }
            if (this._adClickLayer && this._fullAdMask != null)
            {
                this._fullAdMask.width = this._fullAdW;
                this._fullAdMask.height = this._fullAdH;
                this._fullAdContent.mask = this._fullAdMask;
            }
            return;
        }// end function

        protected function mouseUpHandler(event:MouseEvent) : void
        {
            this.close();
            return;
        }// end function

        protected function noPadHandler(event:Event) : void
        {
            this.close();
            return;
        }// end function

        public function get hasAd() : Boolean
        {
            return false;
        }// end function

        public function get adAlign() : String
        {
            return this._adAlign;
        }// end function

        public function close(param1 = null) : void
        {
            var evt:* = param1;
            this._showPause = false;
            this._container.visible = false;
            this._thirdAds = false;
            this._adClickLayer = false;
            this._isSendAdPlayStock = false;
            if (this._normalAdHitAre != null && this._normalAdMask != null)
            {
                this._normalAdHitAre.removeEventListener(MouseEvent.CLICK, this.adClickHandler);
                var _loc_3:Boolean = false;
                this._normalAdHitAre.visible = false;
                this._normalAdMask.visible = _loc_3;
            }
            if (this._fullAdHitAre != null && this._fullAdMask != null)
            {
                this._fullAdHitAre.removeEventListener(MouseEvent.CLICK, this.adClickHandler);
                var _loc_3:Boolean = false;
                this._fullAdHitAre.visible = false;
                this._fullAdMask.visible = _loc_3;
            }
            this._adLoader.close();
            try
            {
                if (this._normalAdContent != null)
                {
                    this._normalAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_hide"));
                }
                if (this._fullAdContent != null)
                {
                    this._fullAdContent.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_hide"));
                }
            }
            catch (evt)
            {
            }
            this._state = "end";
            this.dispatch(TvSohuAdsEvent.PAUSECLOSED);
            AdLog.msg("关闭暂停广告");
            return;
        }// end function

        public function destroy() : void
        {
            this._adPath = "";
            this._state = "no";
            if (this._normalAdContent != null)
            {
                this._normalAdContent.contentLoaderInfo.sharedEvents.removeEventListener("noPad", this.noPadHandler);
                try
                {
                    this._normalAd_c.removeChild(this._normalAdContent);
                    this._normalAd_c.removeChild(this._normalAdCloseBtn);
                    this._container.removeChild(this._normalAd_c);
                }
                catch (evt)
                {
                }
                this._normalAdContent = null;
            }
            if (this._fullAdContent != null)
            {
                this._fullAdContent.contentLoaderInfo.sharedEvents.removeEventListener("noPad", this.noPadHandler);
                try
                {
                    this._fullAd_c.removeChild(this._fullAdContent);
                    this._fullAd_c.removeChild(this._fullAdCloseBtn);
                    this._container.removeChild(this._fullAd_c);
                }
                catch (evt)
                {
                }
                this._fullAdContent = null;
            }
            AdLog.msg("销毁暂停广告");
            return;
        }// end function

        public function get state() : String
        {
            return this._state;
        }// end function

        public function get width() : Number
        {
            if (this._fullAd_c != null && this._fullAd_c.visible && this._fullAdPath != "" && this._fullAdContent != null)
            {
                return this._fullAdW;
            }
            if (this._normalAd_c != null && this._normalAd_c.visible && this._normalAdPath != "" && this._normalAdContent != null)
            {
                return this._normalAdW;
            }
            return 0;
        }// end function

        public function get height() : Number
        {
            if (this._fullAd_c != null && this._fullAd_c.visible && this._fullAdPath != "" && this._fullAdContent != null)
            {
                return this._fullAdH;
            }
            if (this._normalAd_c != null && this._normalAd_c.visible && this._normalAdPath != "" && this._normalAdContent != null)
            {
                return this._normalAdH;
            }
            return 0;
        }// end function

        public function get adPath() : String
        {
            return this._adPath;
        }// end function

        protected function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new TvSohuAdsEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

        private function closeBtnSp(param1:Sprite) : Sprite
        {
            var _closeBtnUp:Sprite;
            var _closeBtnOver:Sprite;
            var sp:* = param1;
            sp = new Sprite();
            _closeBtnUp = this.drawCircleCloseBtn(11, 0, 16777215);
            _closeBtnOver = this.drawCircleCloseBtn(12, 16711680, 16777215);
            sp.addChild(_closeBtnUp);
            sp.addChild(_closeBtnOver);
            sp.addEventListener(MouseEvent.MOUSE_OVER, function (event:Event) : void
            {
                _closeBtnOver.visible = true;
                _closeBtnUp.visible = false;
                return;
            }// end function
            );
            sp.addEventListener(MouseEvent.MOUSE_OUT, function (event:Event) : void
            {
                _closeBtnOver.visible = false;
                _closeBtnUp.visible = true;
                return;
            }// end function
            );
            sp.addEventListener(MouseEvent.MOUSE_UP, function (event:Event) : void
            {
                close();
                return;
            }// end function
            );
            sp.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
            sp.buttonMode = true;
            sp.useHandCursor = true;
            sp.mouseChildren = false;
            return sp;
        }// end function

        private function drawCircleCloseBtn(param1:Number, param2:uint, param3:uint) : Sprite
        {
            var _loc_4:* = new Sprite();
            var _loc_5:Number = 2;
            var _loc_6:Number = 8.5;
            _loc_4.graphics.lineStyle(_loc_5, param3, 0.5);
            _loc_4.graphics.beginFill(param2, 0.6);
            _loc_4.graphics.drawCircle(_loc_5, _loc_5, param1);
            _loc_4.graphics.endFill();
            var _loc_7:* = new Sprite();
            new Sprite().graphics.lineStyle(2, 16777215, 1);
            _loc_7.graphics.lineTo(_loc_6, _loc_6);
            _loc_7.graphics.moveTo(_loc_6, 0);
            _loc_7.graphics.lineTo(0, _loc_6);
            _loc_4.addChild(_loc_7);
            _loc_7.x = -_loc_5;
            _loc_7.y = -_loc_5;
            return _loc_4;
        }// end function

        public function set adIconClass(param1:Class) : void
        {
            this._adIcon = new param1;
            this._adIcon1 = new param1;
            return;
        }// end function

    }
}
