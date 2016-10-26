package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import ebing.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.utils.*;

    public class BackgroundAd extends EventDispatcher
    {
        private var _container:Sprite;
        private var _bgAdSp:Sprite;
        private var _state:String = "no";
        private var _adPath:String = "";
        private var _adTime:String = "";
        private var _adPingback:String = "";
        private var _adThirdPingback:String = "";
        private var _adClick:String = "";
        private var _startPingback:String = "";
        private var _endPingback:String = "";
        private var _adArrPB:Object;
        private var _jsSfun:String;
        private var _jsEfun:String;
        private var _baseColor:String = "";
        private var _picLoader:Loader;
        private var _prepareState:Boolean;
        private var _startPrepare:Boolean = false;
        private var _width:Number;
        private var _height:Number;
        private var _videoW:Number;
        private var _videoH:Number;
        private var _adTimer:Timer;
        private var _timeNum:int = 0;
        private var pattern:RegExp;
        private var _adHardFlag:String = "0";
        private var _adIcon:Sprite;
        private var _drawSp:Sprite;
        private var _drawBlack:Sprite;
        private var _hitArea:Sprite;

        public function BackgroundAd()
        {
            this._bgAdSp = new Sprite();
            this._adTimer = new Timer(1000);
            this.pattern = /\[_TIME]""\[_TIME]/gi;
            this._drawSp = new Sprite();
            this._drawBlack = new Sprite();
            this._hitArea = new Sprite();
            this._picLoader = new Loader();
            return;
        }// end function

        public function beginPrepare() : void
        {
            if (!this._startPrepare)
            {
                this.loadAndPlayAd();
                this._startPrepare = true;
            }
            return;
        }// end function

        private function loadAndPlayAd() : void
        {
            var ptCode:* = /&pageUrl=""&pageUrl=/;
            var url:* = TvSohuAds.getInstance().fetchAdsUrl;
            url = url.replace(ptCode, "&pt=wrapframe&pageUrl=");
            AdLog.msg("请求背景广告接口：" + url);
            new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                var json:Object;
                var bgAd:Object;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    try
                    {
                        AdLog.msg("背景广告接口返回：" + obj.info + "：：： " + (obj.info == "ioError" ? ("status : " + obj.status) : (" ")) + "content：：" + obj.data);
                        AdLog.msg("背景广告数据结束");
                        json = new JSON().parse(obj.data);
                        if (json != null && json.status == 1 && json.data != null && json.data.wrapFrameAd != null && json.data.wrapFrameAd != undefined)
                        {
                            bgAd = json.data.wrapFrameAd[0];
                            if (int(bgAd.duration) <= 30)
                            {
                                if (bgAd.materialUrl != "" && bgAd.materialUrl != null && bgAd.materialUrl != undefined)
                                {
                                    _prepareState = true;
                                    softInit(bgAd);
                                    Utils.drawRect(_drawBlack, 0, 0, 1, 1, 0, 1);
                                    Utils.drawRect(_drawSp, 0, 0, 1, 1, Number(_baseColor), 1);
                                    Utils.drawRect(_hitArea, 0, 0, 1, 1, 16711680, 0);
                                    _adTimer.addEventListener(TimerEvent.TIMER, timerHandler);
                                    playPrepare();
                                }
                                else
                                {
                                    _prepareState = false;
                                    _startPingback = bgAd.sohuStartMonitor;
                                    AdLog.msg("背景广告空广告上报，上报地址为=" + _startPingback);
                                    _jsSfun = bgAd.jsMonitor.sfunc;
                                    if (_startPingback != "")
                                    {
                                        if (_jsSfun != null && _jsSfun != "" && ExternalInterface.available)
                                        {
                                            ExternalInterface.call(_jsSfun, 0, _startPingback.replace(pattern, new Date().getTime()));
                                        }
                                        else
                                        {
                                            new TvSohuURLLoaderUtil().multiSend(_startPingback.replace(pattern, new Date().getTime()));
                                        }
                                    }
                                }
                            }
                            else
                            {
                                _prepareState = false;
                            }
                        }
                        else
                        {
                            AdLog.msg("背景广告数据有问题");
                            _prepareState = false;
                        }
                    }
                    catch (error:Error)
                    {
                        _prepareState = false;
                    }
                }
                else
                {
                    _prepareState = false;
                }
                return;
            }// end function
            , url + "&m=" + new Date().getTime());
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            this._adPath = param1.materialUrl;
            this._adTime = param1.duration;
            this._adPingback = param1.sohuClickMonitor;
            this._adThirdPingback = param1.thirdPartyClickMonitor;
            this._adClick = param1.landingUrl;
            this._startPingback = param1.sohuStartMonitor;
            this._endPingback = param1.sohuEndMonitor;
            this._adArrPB = param1.timerMonitor;
            this._jsSfun = param1.jsMonitor.sfunc;
            this._jsEfun = param1.jsMonitor.efunc;
            this._baseColor = "0x" + param1.baseColor.substring(1, 10);
            this._adHardFlag = param1.hardflag != null && param1.hardflag != undefined && param1.hardflag != "undefined" && param1.hardflag != "" ? (param1.hardflag) : ("0");
            return;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            var _loc_2:int = 0;
            if (this._adArrPB != null)
            {
                _loc_2 = 0;
                while (_loc_2 < this._adArrPB.length)
                {
                    
                    if (this._timeNum >= Number(this._adArrPB[_loc_2].t))
                    {
                        if (this._jsSfun != null && this._jsSfun != "" && ExternalInterface.available)
                        {
                            ExternalInterface.call(this._jsSfun, 0, this._adArrPB[_loc_2].v.replace(this.pattern, new Date().getTime()));
                        }
                        else
                        {
                            new TvSohuURLLoaderUtil().multiSend(this._adArrPB[_loc_2].v.replace(this.pattern, new Date().getTime()));
                        }
                        this._adArrPB.splice(_loc_2, 1);
                        break;
                    }
                    _loc_2++;
                }
            }
            var _loc_3:String = this;
            var _loc_4:* = this._timeNum + 1;
            _loc_3._timeNum = _loc_4;
            return;
        }// end function

        private function playPrepare() : void
        {
            if (this._state == "no")
            {
                this._bgAdSp.visible = false;
                this._container.addChild(this._drawBlack);
                this._container.addChild(this._drawSp);
                this._container.addChild(this._bgAdSp);
                this._container.addChild(this._hitArea);
                this._hitArea.buttonMode = true;
                this._container.addChild(this._adIcon);
                this._hitArea.addEventListener(MouseEvent.CLICK, this.adClickHandler);
                if (this._adPath != "")
                {
                    this._picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.adPicCompleteHandler);
                    this._picLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.adPicErrorHandler);
                    this._picLoader.load(new URLRequest(this._adPath));
                }
            }
            else
            {
                this._bgAdSp.visible = true;
                this._hitArea.visible = true;
                this._drawSp.visible = true;
                this._state = "playing";
            }
            return;
        }// end function

        private function adClickHandler(event:MouseEvent) : void
        {
            if (this._adClick != "")
            {
                Utils.openWindow(this._adClick);
            }
            if (this._adPingback != "")
            {
                new TvSohuURLLoaderUtil().multiSend(this._adPingback.replace(this.pattern, new Date().getTime()));
            }
            if (this._adThirdPingback != "")
            {
                new TvSohuURLLoaderUtil().multiSend(this._adThirdPingback.replace(this.pattern, new Date().getTime()));
            }
            return;
        }// end function

        private function adPicErrorHandler(event:IOErrorEvent) : void
        {
            this._startPrepare = false;
            this._prepareState = false;
            this._picLoader = null;
            return;
        }// end function

        private function adPicCompleteHandler(event:Event) : void
        {
            this._bgAdSp.addChild(this._picLoader);
            this._adIcon["littleIcon"].visible = false;
            this._adIcon["bigIcon"].visible = true;
            this._picLoader.visible = false;
            this._drawSp.visible = false;
            this._hitArea.visible = false;
            this._prepareState = true;
            return;
        }// end function

        private function setIconState(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number) : void
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
                    param1.x = 2 + param4;
                    param1.y = 2 + param5;
                    break;
                }
                case "2":
                {
                    param1.x = 2 + param4;
                    param1.y = param3 - param1.height - 2 - param5;
                    break;
                }
                case "3":
                {
                    param1.x = param2 - param1.width - 2 - param4;
                    param1.y = 2 + param5;
                    break;
                }
                case "4":
                {
                    param1.x = param2 - param1.width - 2 - param4;
                    param1.y = param3 - param1.height - 2 - param5;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function play() : void
        {
            if (this._prepareState)
            {
                this._bgAdSp.visible = true;
                this._picLoader.visible = true;
                this._drawSp.visible = true;
                this._hitArea.visible = true;
                this._adTimer.reset();
                this._adTimer.start();
                if (this._startPingback != "")
                {
                    if (this._jsSfun != null && this._jsSfun != "" && ExternalInterface.available)
                    {
                        ExternalInterface.call(this._jsSfun, 0, this._startPingback.replace(this.pattern, new Date().getTime()));
                    }
                    else
                    {
                        new TvSohuURLLoaderUtil().multiSend(this._startPingback.replace(this.pattern, new Date().getTime()));
                    }
                }
            }
            return;
        }// end function

        public function hideAd() : void
        {
            this._bgAdSp.visible = false;
            this._picLoader.visible = false;
            this._hitArea.visible = false;
            this._drawSp.visible = false;
            this._adTimer.stop();
            this._adTimer.reset();
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:uint = 0;
            var _loc_2:uint = 0;
            if (this._endPingback != "")
            {
                if (this._jsEfun != null && this._jsEfun != "" && ExternalInterface.available)
                {
                    ExternalInterface.call(this._jsEfun, 0, this._endPingback.replace(this.pattern, new Date().getTime()));
                }
                else
                {
                    new TvSohuURLLoaderUtil().multiSend(this._endPingback.replace(this.pattern, new Date().getTime()));
                }
            }
            this._adTimer.stop();
            this._adTimer.removeEventListener(TimerEvent.TIMER, this.timerHandler);
            this._state = "no";
            this._prepareState = false;
            this._startPrepare = false;
            if (this._bgAdSp != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this._bgAdSp.numChildren)
                {
                    
                    this._bgAdSp.removeChildAt(0);
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

        public function resize(param1:Number, param2:Number, param3:Number, param4:Number) : void
        {
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            this._width = param1;
            this._height = param2;
            this._videoW = 2 * param3;
            this._videoH = 2 * param4;
            var _loc_5:* = (this._width - this._videoW) / 2;
            var _loc_6:* = (this._height - this._videoH) / 2;
            try
            {
                _loc_7 = this._picLoader.contentLoaderInfo.width;
                _loc_8 = this._picLoader.contentLoaderInfo.height;
                _loc_9 = this._videoW / _loc_7;
                _loc_10 = this._videoH / _loc_8;
                if (_loc_7 > this._videoW || _loc_8 > this._videoH)
                {
                    _loc_11 = _loc_9 < _loc_10 ? (_loc_9) : (_loc_10);
                    var _loc_12:* = _loc_11;
                    this._picLoader.scaleY = _loc_11;
                    this._picLoader.scaleX = _loc_12;
                }
                else
                {
                    var _loc_12:int = 1;
                    this._picLoader.scaleY = 1;
                    this._picLoader.scaleX = _loc_12;
                }
                this._drawBlack.width = this._width;
                this._drawBlack.height = this._height;
                var _loc_12:* = this._videoW;
                this._hitArea.width = this._videoW;
                this._drawSp.width = _loc_12;
                var _loc_12:* = this._videoH;
                this._hitArea.height = this._videoH;
                this._drawSp.height = _loc_12;
                Utils.setCenterByNumber(this._bgAdSp, this._width, this._height);
                Utils.setCenterByNumber(this._drawSp, this._width, this._height);
                Utils.setCenterByNumber(this._hitArea, this._width, this._height);
                if (this._container.stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
                {
                    this.setIconState(this._adIcon, this._width, this._height, _loc_5, _loc_6 + 30);
                }
                else
                {
                    this.setIconState(this._adIcon, this._width, this._height, _loc_5, _loc_6);
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        public function get prepared() : Boolean
        {
            return this._prepareState;
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

        public function set adIconClass(param1:Class) : void
        {
            this._adIcon = new param1;
            return;
        }// end function

        public function get bgAdTime() : int
        {
            return int(this._adTime);
        }// end function

    }
}
