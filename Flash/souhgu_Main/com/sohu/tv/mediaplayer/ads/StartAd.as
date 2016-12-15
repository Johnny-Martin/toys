package com.sohu.tv.mediaplayer.ads
{
    import com.adobe.images.*;
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import com.sohu.tv.mediaplayer.ui.*;
    import com.sohu.tv.mediaplayer.video.*;
    import ebing.*;
    import ebing.display.*;
    import ebing.events.*;
    import ebing.external.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.media.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;

    public class StartAd extends EventDispatcher implements IAds
    {
        protected var _adPath:String = "";
        protected var _adStatUrl:String;
        protected var _adClickUrl:String;
        protected var _adList:Array;
        protected var _currentIndex:uint;
        protected var _downloadIndex:uint;
        protected var _width:Number;
        protected var _height:Number;
        protected var _container:Sprite;
        protected var _swfAdLoader:LoaderUtil;
        protected var _state:String = "no";
        protected var _owner:StartAd;
        protected var _adNowTime:uint;
        protected var _adTotTime:uint;
        protected var _adTimeout:uint = 0;
        protected var _adPlayError:uint = 0;
        protected var _adDownloadError:uint = 0;
        protected var _interVarId:Number;
        protected var _temTime:uint;
        protected var _statSender:TvSohuURLLoaderUtil;
        protected var _isShown:Boolean = false;
        protected var _countText:TextField;
        protected var _countDown:Sprite;
        private var _countMc:Sprite;
        private var _isDispatchEvent:Boolean;
        private var _hasAd:Boolean = false;
        private var _volume:Number = 0;
        private var _so:SharedObject;
        private var _soundTransform:SoundTransform;
        private var _adTimeoutId:Number = 0;
        private var _adBeginTime:uint = 0;
        protected var _closeBtnUp:Sprite;
        protected var _closeBtnOver:Sprite;
        protected var _close_btn:Sprite;
        protected var _removeAdMc:Sprite;
        private var _iFoxPanel:Object;
        private var _isMute:Boolean;
        private var _tempTimer1:Number = 0;
        private var _tempTimer2:Number = 0;
        private var _isAutoPlayAd:Boolean;
        private var _isAdSelect:Boolean = false;
        protected var _isVpaidAd:Boolean = false;
        protected var _isPIPAd:Boolean = false;
        protected var _isNoDetailClasss:Boolean = false;
        private var soundIcon:SoundIcon;
        protected var _isAdTip:Boolean = false;
        private var _adTipContainer:Sprite;
        private var _adTipCloseBtn:Sprite;
        private var _adTipTimeout:Number = 0;
        private var _tipBg:Sprite;
        private var _tipTxt:TextField;
        private var _isFinishLoaded:Boolean = false;
        private var _isFFSendPQ:Boolean = false;
        private var _skipAdsTime:Number = 0;
        private var _skipAdsDuration:Number = 0;
        private var _isAdPlay:Boolean = false;
        private var _endTime:uint = 0;
        private var _ebt:String = "";
        private var _btnUi:ButtonUi;
        private var _bitUi:BitUi;
        public var ADS_VM_PATH:String = "";
        private var _isCheckAdPlay:Boolean = false;
        private var _slaveAdPar:Object;
        protected var _DetailClass:Class;
        protected var _recordNowTime:Number;
        private var _skTime:int = 5;
        protected var _skCkUrl:String = "";
        private var _isSkipAd:Boolean = false;
        public static const TO_HAS_SOUND_ICON:String = "to_has_sound_icon";
        public static const TO_NO_SOUND_ICON:String = "to_no_sound_icon";
        public static const CHECK_ADS_TIME:String = "http://v.aty.sohu.com/ct";

        public function StartAd(param1:Object)
        {
            this._owner = this;
            this.hardInit(param1);
            return;
        }// end function

        public function hardInit(param1:Object) : void
        {
            this._width = param1.width;
            this._height = param1.height;
            this.sysInit("start");
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

        protected function initAdList(param1:Object, param2:uint) : void
        {
            var arrr:Array;
            var boo:Boolean;
            var tem:Array;
            var funObj:Object;
            var sa:Array;
            var json:* = param1;
            var i:* = param2;
            this._adList[i] = {adPath:"", duration:"", adClickUrl:"", adStatUrl:"", adClickStatUrl:"", adPlayOverStatUrl:"", func:null, adSfunc:null, adEfunc:null, adArrPB:null, isExcluded:false, callTime:null, adType:"", playState:"no", loadState:"no", ad:null, hitArea:new MovieClip(), detail:new Sprite(), errTip:new Sprite()};
            this._adList[i].adPath = json[i][0];
            if (this._adList[i].adPath != "")
            {
                arrr = this._adList[i].adPath.split("data.vod.itc.cn");
                if (arrr.length > 1)
                {
                    boo = this._adList[i].adPath.split("?").length > 1;
                    this._adList[i].adPath = this._adList[i].adPath + ((boo ? ("&") : ("?")) + "uuid=" + PlayerConfig.uuid);
                }
            }
            this._adList[i].adType = Utils.getType(json[i][0].split("?")[0], ".");
            this._adList[i].duration = json[i][1];
            this._adList[i].hasSound = true;
            this._adList[i].thirdAds = "";
            var _loc_4:int = 0;
            this._adList[i].endLoadTime = 0;
            this._adList[i].startLoadTime = _loc_4;
            var _loc_4:int = 0;
            this._adList[i].endPlayTime = 0;
            this._adList[i].startPlayTime = _loc_4;
            var _loc_4:int = 0;
            this._adList[i].adPlayedTime2 = 0;
            this._adList[i].adStartTime = _loc_4;
            this._adList[i].errtype = "";
            this._adList[i].isLoadErr = false;
            this._adList[i].isConnectTimeOut = false;
            this._adList[i].isSendPQ = false;
            this._adList[i].isSendAdPlayStock = false;
            this._adList[i].isSendAdStopStock = false;
            if (json[i].length >= 3 && json[i][2] != null && json[i][2] != "")
            {
                this._adList[i].adClickUrl = json[i][2];
            }
            if (json[i].length >= 4 && json[i][3] != null && json[i][3] != "")
            {
                this._adList[i].adStatUrl = json[i][3];
            }
            if (json[i].length >= 5 && json[i][4] != null && json[i][4] != "")
            {
                tem = json[i][4].split("|");
                this._adList[i].func = tem[0];
                tem.shift();
                this._adList[i].callTime = tem.length == 0 ? ([0]) : (tem);
            }
            if (json[i].length >= 6 && json[i][5] != null && json[i][5] != "")
            {
                this._adList[i].adPlayOverStatUrl = json[i][5];
            }
            if (json[i].length >= 7 && json[i][6] != null && json[i][6] != "")
            {
                this._adList[i].adClickStatUrl = json[i][6];
            }
            if (json[i].length >= 8 && json[i][7] != null && json[i][7] != "")
            {
                this._adList[i].hasSound = json[i][7] == "0" ? (false) : (true);
            }
            if (json[i].length >= 9 && json[i][8] != null && json[i][8] != "")
            {
                this._adList[i].thirdAds = json[i][8];
            }
            if (json[i].length >= 10 && json[i][9] != null && json[i][9] != "")
            {
                funObj = Object(json[i][9]);
                if (funObj.sfunc != null && funObj.sfunc != "")
                {
                    this._adList[i].adSfunc = funObj.sfunc;
                }
                if (funObj.efunc != null && funObj.efunc != "")
                {
                    this._adList[i].adEfunc = funObj.efunc;
                }
            }
            if (json[i].length >= 11 && json[i][10] != null && json[i][10] != "")
            {
                if (json[i][10] == "1")
                {
                    this._isAdSelect = true;
                }
                else if (json[i][10] == "2")
                {
                    this._isVpaidAd = true;
                }
                else if (json[i][10] == "3")
                {
                    this._isPIPAd = true;
                }
            }
            if (json[i].length >= 12 && json[i][11] != null && json[i][11] != "")
            {
                this._adList[i].adArrPB = json[i][11];
            }
            if (json[i].length >= 13 && json[i][12] != null && json[i][12] != "" && json[i][12] == "1")
            {
                this._adList[i].isExcluded = true;
            }
            this._adTotTime = this._adTotTime + this._adList[i].duration;
            this._adList[i].hitArea.index = i;
            Utils.drawRect(this._adList[i].hitArea, 1, 1, this._width, this._height, 16777215, 0);
            this._adList[i].hitArea.buttonMode = true;
            this._adList[i].hitArea.addEventListener(MouseEvent.CLICK, this.adClickHandler);
            if (this._adList[i].adType == "swf")
            {
                try
                {
                    sa;
                    if (this._slaveAdPar && this._slaveAdPar.length >= 1)
                    {
                        sa = this._slaveAdPar.shift();
                    }
                    this._adList[i].ad = new TvSohuFlashCore({width:this._width, height:this._height, limitTime:this._isVpaidAd ? (15) : (5), isVpaidAd:this._isVpaidAd, index:i, isPIPAd:this._isPIPAd, isThirdAds:this._adList[i].thirdAds, callTime:this._adList[i].callTime, func:this._adList[i].func, adSfunc:this._adList[i].adSfunc, adEfunc:this._adList[i].adEfunc, extraAd:sa, pbUrl:this._adList[i].adStatUrl});
                }
                catch (evt)
                {
                }
            }
            else
            {
                try
                {
                    this._adList[i].ad = new TvSohuSimpleVideoCore({width:this._width, height:this._height, buffer:1, limitTime:5, index:i});
                }
                catch (evt)
                {
                }
            }
            this._adList[i].ad.softInit({url:this._adList[i].adPath, time:this._adList[i].duration * 1000});
            this._adList[i].ad.addEventListener(MediaEvent.LOAD_PROGRESS, this.adLoadProgress);
            this._adList[i].ad.addEventListener(MediaEvent.STOP, this.adStop);
            this._adList[i].ad.addEventListener(MediaEvent.START, this.adStart);
            this._adList[i].ad.addEventListener(MediaEvent.PLAYED, this.adPlayed);
            this._adList[i].ad.addEventListener(MediaEvent.NOTFOUND, this.adLoadError);
            this._adList[i].ad.addEventListener(MediaEvent.CONNECT_TIMEOUT, this.adConnectTimeOut);
            this._adList[i].ad.addEventListener(MediaEvent.PLAY_ABEND, this.adPlayError);
            this._adList[i].ad.visible = false;
            this._adList[i].hitArea.visible = false;
            this._adList[i].detail.visible = false;
            this._adList[i].errTip = new LoadAdErrorTip({url:this._adList[i].adPath, time:this._adList[i].duration, width:this._width, height:this._height, index:i});
            this._adList[i].errTip.addEventListener(MediaEvent.STOP, this.adStop);
            this._adList[i].errTip.addEventListener(MediaEvent.START, this.adStart);
            this._adList[i].errTip.addEventListener(MediaEvent.PLAY_PROGRESS, this.adPlayProgress);
            this._adList[i].errTip.addEventListener(MediaEvent.LOAD_PROGRESS, this.adLoadProgress);
            if (this._adList[i].adType == "swf")
            {
                if (this._isPIPAd)
                {
                    this._adList[i].ad.loadSwf();
                    this._adList[i].ad.visible = true;
                }
                this._adList[i].ad.addEventListener("allowFlash", function (event:Event) : void
            {
                _adList[i].hitArea.visible = false;
                return;
            }// end function
            );
                this._adList[i].ad.addEventListener("ad_click", function (event:Event) : void
            {
                _adList[i].hitArea.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                return;
            }// end function
            );
                this._adList[i].ad.addEventListener("pauseFlash", function (event:Event) : void
            {
                _adList[i].ad.pause();
                stopTimeOut();
                return;
            }// end function
            );
                this._adList[i].ad.addEventListener("resumeFlash", function (event:Event) : void
            {
                _adList[i].ad.swfStart();
                startTimeOut();
                return;
            }// end function
            );
                this._adList[i].ad.addEventListener("closeFlash", function (event:Event) : void
            {
                if (_adList[i].playState != "end")
                {
                    if (_adList[i].adStartTime > 0)
                    {
                        _skipAdsTime = _skipAdsTime + (new Date().getTime() - _adList[i].adStartTime);
                    }
                    _skipAdsDuration = _skipAdsDuration + _adList[i].duration;
                    _adList[i].playState = "end";
                }
                return;
            }// end function
            );
                this._adList[i].ad.addEventListener(TvSohuAdsEvent.SWFAD_ERROR, this.swfad_error);
            }
            this._container.addChild(this._adList[i].ad);
            this._container.addChild(this._adList[i].hitArea);
            this._container.addChild(this._adList[i].errTip);
            this._container.addChild(this._adList[i].detail);
            this._adList[i].detail.visible = false;
            if (this._adList[i].adPath != "")
            {
                AdLog.msg("第 " + i + " 广告地址：" + this._adList[i].adPath + "：：时长：" + this._adList[i].duration + "：：" + (this._adList[i].hasSound ? ("有声广告") : ("无声广告")) + "：：是否排斥控制栏广告 ： " + (this._adList[i].isExcluded ? ("yes") : ("no")) + "  ");
            }
            else
            {
                AdLog.msg("第 " + i + " 空广告" + "：：" + (this._adList[i].hasSound ? ("有声广告") : ("无声广告")) + "：：是否排斥控制栏广告 ： " + (this._adList[i].isExcluded ? ("yes") : ("no")) + "  ");
            }
            return;
        }// end function

        private function swfad_error(param1) : void
        {
            if (param1 != null && param1.obj != null && param1.obj.errType != null && param1.obj.errType != "")
            {
                AdLog.msg("TvSohuFlashCore:SWFAD_ERROR:errType:" + param1.obj.errType);
                this.adPingback(param1.obj.errType);
            }
            return;
        }// end function

        public function set detailClass(param1:Class) : void
        {
            var _loc_3:Sprite = null;
            param1 = DetailBtn as Class;
            if (param1 != null)
            {
                this._DetailClass = param1;
            }
            var _loc_2:uint = 0;
            while (_loc_2 < this._adList.length)
            {
                
                _loc_3 = new this._DetailClass();
                if (this._isNoDetailClasss || this._isVpaidAd || this._isPIPAd)
                {
                    _loc_3.visible = false;
                }
                else
                {
                    _loc_3.visible = true;
                }
                _loc_3["skipAdBtn"].visible = false;
                _loc_3["skipAdBtn"].buttonMode = true;
                _loc_3["detail_mc"].buttonMode = true;
                _loc_3["skipAdBtn"].addEventListener(MouseEvent.MOUSE_DOWN, this.skipBtnHandler);
                _loc_3["skipAdBtn"].addEventListener(MouseEvent.MOUSE_OVER, this.skipOverHandler);
                _loc_3["skipAdBtn"].addEventListener(MouseEvent.MOUSE_OUT, this.skipOutHandler);
                _loc_3["detail_mc"].addEventListener(MouseEvent.CLICK, this.detailClickHandler);
                _loc_3["detail_mc"].addEventListener(MouseEvent.MOUSE_OVER, this.detailOverHandler);
                _loc_3["detail_mc"].addEventListener(MouseEvent.MOUSE_OUT, this.detailOutHandler);
                this._adList[_loc_2].detail.addChild(_loc_3);
                _loc_2 = _loc_2 + 1;
            }
            this.resize(this._width, this._height);
            return;
        }// end function

        protected function detailClickHandler(event:MouseEvent) : void
        {
            this._adList[this._currentIndex].hitArea.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            return;
        }// end function

        protected function detailOverHandler(event:MouseEvent) : void
        {
            if (this._adList[this._currentIndex].detail.numChildren > 0)
            {
                this._adList[this._currentIndex].detail.getChildAt((this._adList[this._currentIndex].detail.numChildren - 1)).detail_mc.gotoAndStop(2);
                ;
            }
            return;
        }// end function

        protected function detailOutHandler(event:MouseEvent) : void
        {
            if (this._adList[this._currentIndex].detail.numChildren > 0)
            {
                this._adList[this._currentIndex].detail.getChildAt((this._adList[this._currentIndex].detail.numChildren - 1)).detail_mc.gotoAndStop(1);
                ;
            }
            return;
        }// end function

        protected function skipOverHandler(event:MouseEvent) : void
        {
            if (this._adList[this._currentIndex].detail.numChildren > 0)
            {
                this._adList[this._currentIndex].detail.getChildAt((this._adList[this._currentIndex].detail.numChildren - 1)).skipAdBtn.gotoAndStop(2);
                ;
            }
            return;
        }// end function

        protected function skipOutHandler(event:MouseEvent) : void
        {
            if (this._adList[this._currentIndex].detail.numChildren > 0)
            {
                this._adList[this._currentIndex].detail.getChildAt((this._adList[this._currentIndex].detail.numChildren - 1)).skipAdBtn.gotoAndStop(1);
                ;
            }
            return;
        }// end function

        public function set isNoDetailClasss(param1:Boolean) : void
        {
            this._isNoDetailClasss = param1;
            return;
        }// end function

        public function set isAdTip(param1:Boolean) : void
        {
            this._isAdTip = param1;
            return;
        }// end function

        private function showAdTip() : void
        {
            var _loc_1:* = new TextFormat();
            _loc_1.size = 14;
            _loc_1.leading = 10;
            _loc_1.font = "宋体";
            _loc_1.align = TextFormatAlign.LEFT;
            this._tipBg = new Sprite();
            Utils.drawRect(this._tipBg, 0, 0, this._width, 30, 0, 0.6);
            this._adTipContainer.addChild(this._tipBg);
            this._tipTxt = new TextField();
            this._tipTxt.height = 20;
            var _loc_4:int = 5;
            this._tipTxt.x = 5;
            this._tipTxt.y = _loc_4;
            this._tipTxt.text = "因版权原因，该剧暂时不能跳过广告，我们正在积极解决。";
            this._tipTxt.setTextFormat(_loc_1);
            this._tipTxt.textColor = 15132390;
            this._adTipContainer.addChild(this._tipTxt);
            this._adTipCloseBtn = new Sprite();
            var _loc_2:* = new Sprite();
            var _loc_3:* = new Sprite();
            _loc_2 = drawSquareCloseBtn(15, 0, 10461087, 0);
            _loc_3 = drawSquareCloseBtn(15, 16711680, 16777215, 1);
            _loc_2.name = "btnUp";
            _loc_3.name = "btnOver";
            this._adTipCloseBtn.addChild(_loc_2);
            this._adTipCloseBtn.addChild(_loc_3);
            this._adTipCloseBtn.addEventListener(MouseEvent.MOUSE_OVER, this.tipCloseBtnOver);
            this._adTipCloseBtn.addEventListener(MouseEvent.MOUSE_OUT, this.tipCloseBtnOut);
            this._adTipCloseBtn.addEventListener(MouseEvent.MOUSE_UP, this.tipCloseBtnUp);
            Utils.setCenter(this._adTipCloseBtn, this._tipBg);
            this._adTipCloseBtn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
            this._adTipCloseBtn.buttonMode = true;
            this._adTipCloseBtn.useHandCursor = true;
            this._adTipCloseBtn.mouseChildren = false;
            this._adTipContainer.addChild(this._adTipCloseBtn);
            this.resizeAdTip();
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            var json:Object;
            var i:uint;
            var obj:* = param1;
            this.initMc();
            if (obj.skTime != null && obj.skTime != undefined)
            {
                this._isSkipAd = true;
                this._skTime = obj.skTime;
            }
            if (obj.skCkUrl != null && obj.skCkUrl != undefined && obj.skCkUrl != "")
            {
                this._skCkUrl = obj.skCkUrl;
            }
            this._tempTimer1 = new Date().getTime();
            var startAdPar:* = obj.adPar;
            if (obj.slaveAdPar)
            {
                this._slaveAdPar = new JSON().parse(String(obj.slaveAdPar).replace(new RegExp("\'", "g"), "\""));
            }
            if (startAdPar == "" && obj.selectedVideo && obj.selectedVideo != null)
            {
                startAdPar;
            }
            if (startAdPar != "")
            {
                try
                {
                    json = new JSON().parse(startAdPar.replace(new RegExp("\'", "g"), "\""));
                    if (obj.selectedVideo && obj.selectedVideo != null)
                    {
                        json.unshift(obj.selectedVideo);
                    }
                    json = json.filter(function (param1, param2:int, param3:Array) : Boolean
            {
                if (param1.length >= 8 && param1[7] != null && param1[7] != "")
                {
                    return !TvSohuAds.getInstance().isFrequencyLimit(param1[7]);
                }
                return true;
            }// end function
            );
                    i;
                    while (i < json.length)
                    {
                        
                        this.initAdList(json, i);
                        i = (i + 1);
                    }
                    this._container.addChild(this._countDown);
                    this._countDown.visible = false;
                    this._container.addChild(this._adTipContainer);
                    this._adTipContainer.visible = false;
                    this.detailClass = null;
                }
                catch (evt)
                {
                    ErrorSenderPQ.getInstance().sendPQStat({error:PlayerConfig.ADINFO_PARSE_ERROR, code:PlayerConfig.REALVV_CODE});
                }
                ;
            }
            return;
        }// end function

        protected function adClickHandler(event:MouseEvent) : void
        {
            var _loc_2:* = this._adList[event.target["index"]].adClickUrl;
            if (_loc_2 != "")
            {
                Utils.openWindow(_loc_2);
            }
            this._statSender.multiSend(this._adList[event.target["index"]].adClickStatUrl);
            return;
        }// end function

        protected function sysInit(param1:String = null) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
                this.drawSkin();
                this.addEvent();
            }
            var _loc_3:int = 0;
            this._endTime = 0;
            var _loc_3:* = _loc_3;
            this._skipAdsDuration = _loc_3;
            var _loc_3:* = _loc_3;
            this._skipAdsTime = _loc_3;
            var _loc_3:* = _loc_3;
            this._adDownloadError = _loc_3;
            var _loc_3:* = _loc_3;
            this._adPlayError = _loc_3;
            var _loc_3:* = _loc_3;
            this._adTimeout = _loc_3;
            var _loc_3:* = _loc_3;
            this._adTotTime = _loc_3;
            this._adNowTime = _loc_3;
            this._state = "no";
            this._hasAd = false;
            var _loc_2:uint = 0;
            while (_loc_2 < this._adList.length)
            {
                
                this._adList[_loc_2].adSfunc = null;
                this._adList[_loc_2].adEfunc = null;
                _loc_2 = _loc_2 + 1;
            }
            var _loc_3:Boolean = false;
            this._isCheckAdPlay = false;
            var _loc_3:* = _loc_3;
            this._isVpaidAd = _loc_3;
            var _loc_3:* = _loc_3;
            this._isPIPAd = _loc_3;
            var _loc_3:* = _loc_3;
            this._isAdPlay = _loc_3;
            var _loc_3:* = _loc_3;
            this._isFFSendPQ = _loc_3;
            this._isAdSelect = _loc_3;
            return;
        }// end function

        protected function drawSkin() : void
        {
            this._countDown = new Sprite();
            this._adTipContainer = new Sprite();
            this._countText = new TextField();
            this._countText.width = 32;
            this._countText.height = 30;
            this._close_btn = new Sprite();
            this._countMc = new CountBg_n();
            this.soundIcon = new SoundIcon();
            this.soundIcon.x = this._countMc.width + 5;
            this._countDown.addChild(this.soundIcon);
            this.soundIcon.addEventListener(MouseEvent.MOUSE_DOWN, this.soundIconClickHandler);
            this._countDown.addChild(this._countMc);
            this.resize(this._width, this._height);
            return;
        }// end function

        private function initMc() : void
        {
            var _loc_1:* = new TextFormat();
            _loc_1.font = PlayerConfig.MICROSOFT_YAHEI;
            _loc_1.color = 15154225;
            _loc_1.size = 14;
            _loc_1.align = TextFormatAlign.CENTER;
            this._countText.defaultTextFormat = _loc_1;
            this._countText.y = 3;
            this._closeBtnUp = drawCloseBtn(15, 0, 16777215);
            this._closeBtnOver = drawCloseBtn(15, 0, 15154225);
            this._close_btn.addChild(this._closeBtnUp);
            this._close_btn.addChild(this._closeBtnOver);
            this._closeBtnOver.visible = false;
            var _loc_2:Boolean = true;
            this._close_btn.useHandCursor = true;
            this._close_btn.buttonMode = _loc_2;
            this._close_btn.mouseChildren = false;
            this._close_btn.visible = true;
            this._close_btn.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this._close_btn.y = (this._countMc.height - this._close_btn.height) / 2 - 0.5;
            this._close_btn.x = this._countMc.width - this._close_btn.width - 12;
            this._countMc.addChild(this._close_btn);
            this._countMc.addChild(this._countText);
            return;
        }// end function

        protected function mouseOverHandler(event:MouseEvent) : void
        {
            this._closeBtnOver.visible = true;
            this._closeBtnUp.visible = false;
            return;
        }// end function

        protected function mouseOutHandler(event:MouseEvent) : void
        {
            this._closeBtnOver.visible = false;
            this._closeBtnUp.visible = true;
            return;
        }// end function

        public function pause() : void
        {
            if (this._adList[this._currentIndex].errTip.errStatusSp.visible && this._adList[this._currentIndex].errTip.tipFlagState == "play")
            {
                this._adList[this._currentIndex].errTip.pause();
            }
            else
            {
                this._adList[this._currentIndex].ad.pause();
            }
            this.stopTimeOut();
            return;
        }// end function

        public function resume() : void
        {
            if (this._adList[this._currentIndex].errTip.errStatusSp.visible && this._adList[this._currentIndex].errTip.tipFlagState == "pause")
            {
                this._adList[this._currentIndex].errTip.reStart();
            }
            else if (this._adList[this._currentIndex].adType == "swf")
            {
                this._adList[this._currentIndex].ad.swfStart();
            }
            else
            {
                this._adList[this._currentIndex].ad.play();
            }
            this.startTimeOut();
            return;
        }// end function

        protected function mouseUpHandler(event:MouseEvent) : void
        {
            var _loc_2:Boolean = false;
            event.target.mouseEnabled = false;
            var _loc_2:* = _loc_2;
            event.target.useHandCursor = _loc_2;
            event.target.buttonMode = _loc_2;
            this._close_btn.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.pause();
            this.showIFoxPanel();
            SendRef.getInstance().sendPQ("PL_S_CloseAD");
            dispatchEvent(new Event("openIFoxPanel"));
            return;
        }// end function

        public function resetPlay() : void
        {
            this.resume();
            var _loc_1:Boolean = true;
            this._close_btn.mouseEnabled = true;
            var _loc_1:* = _loc_1;
            this._close_btn.useHandCursor = _loc_1;
            this._close_btn.buttonMode = _loc_1;
            this._close_btn.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            return;
        }// end function

        public function showIFoxPanel(param1 = null) : void
        {
            var evt:* = param1;
            if (this._iFoxPanel == null)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _iFoxPanel = obj.data.content;
                    _container.addChild(_iFoxPanel);
                    _iFoxPanel.init(P2PExplorer.getInstance().hasP2P);
                    _iFoxPanel.addEventListener("closeIFoxPanel", function (event:Event) : void
                {
                    resetPlay();
                    return;
                }// end function
                );
                    _iFoxPanel.addEventListener("close_startAd", function (event:Event) : void
                {
                    close();
                    dispatch(TvSohuAdsEvent.SCREENFINISH);
                    return;
                }// end function
                );
                    resize(_width, _height);
                    showIFoxPanel();
                }
                else
                {
                    resetPlay();
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/IFoxPanelLogin.swf");
            }
            else if (this._iFoxPanel.isOpen)
            {
                this._iFoxPanel.close();
            }
            else
            {
                this._container.setChildIndex(this._iFoxPanel, (this._container.numChildren - 1));
                this._iFoxPanel.open();
            }
            return;
        }// end function

        protected function adPlayProgress(event:MediaEvent) : void
        {
            var nowTime:Number;
            var b:Number;
            var t:Number;
            var i:uint;
            var arr:Array;
            var k:int;
            var evt:* = event;
            if (evt.obj.nowTime != 0)
            {
                if (!this._isAdPlay)
                {
                    this._isAdPlay = true;
                    this._adList[this._currentIndex].adStartTime = new Date().getTime();
                }
                if (this._adList[this._currentIndex].startPlayTime == 0)
                {
                    this._adList[this._currentIndex].startPlayTime = getTimer();
                }
                this._adList[this._currentIndex].adPlayedTime2 = evt.obj.nowTime;
                nowTime = this._adNowTime + evt.obj.nowTime;
                this._recordNowTime = nowTime;
                if (nowTime >= this._skTime && this._isSkipAd)
                {
                    if (this._adList[this._currentIndex].detail.numChildren > 0)
                    {
                        this._adList[this._currentIndex].detail.getChildAt((this._adList[this._currentIndex].detail.numChildren - 1)).skipAdBtn.visible = true;
                        ;
                    }
                }
                b = Math.ceil(this._adTotTime - nowTime);
                t = b < 0 ? (0) : (b);
                if (!this._isAdSelect && !this._isVpaidAd && !this._isPIPAd)
                {
                    this._countText.selectable = false;
                    this._countText.htmlText = t.toString();
                    this._countDown.visible = true;
                }
                this._adList[this._currentIndex].detail.visible = true;
                if (this._isAdTip || PlayerConfig.is56)
                {
                    this._isAdTip = false;
                    this._close_btn.visible = false;
                    if (TvSohuAds.getInstance().vipUser != "")
                    {
                        this.showAdTip();
                        this._adTipContainer.visible = true;
                        this._container.setChildIndex(this._adTipContainer, (this._container.numChildren - 1));
                        this._adTipTimeout = setTimeout(function () : void
            {
                clearTimeout(_adTipTimeout);
                _adTipContainer.visible = false;
                return;
            }// end function
            , 1000 * 20);
                    }
                    this.resize(this._width, this._height);
                }
                this.dispatch(TvSohuAdsEvent.SCREEN_PLAY_PROGRESS, {isSeek:false, nowTime:nowTime, totTime:this._adTotTime});
                this.adPingback();
                if (ExternalInterface.available && this._adList[this._currentIndex].func != null)
                {
                    i;
                    while (i < this._adList[this._currentIndex].callTime.length)
                    {
                        
                        if (evt.obj.nowTime >= this._adList[this._currentIndex].callTime[i])
                        {
                            ExternalInterface.call(this._adList[this._currentIndex].func, Math.round(evt.obj.nowTime));
                            this._adList[this._currentIndex].callTime.splice(i, 1);
                            break;
                        }
                        i = (i + 1);
                    }
                }
                if (this._adList[this._currentIndex].adArrPB != null)
                {
                    arr = this._adList[this._currentIndex].adArrPB;
                    k;
                    while (k < arr.length)
                    {
                        
                        if (evt.obj.nowTime >= Number(arr[k].t))
                        {
                            AdLog.msg("第 " + this._currentIndex + " 广告：" + arr);
                            AdLog.msg("上报地址：" + arr[k].v);
                            this._statSender.multiSend(arr[k].v);
                            arr.splice(k, 1);
                            break;
                        }
                        k = (k + 1);
                    }
                }
            }
            return;
        }// end function

        protected function adStart(event:MediaEvent) : void
        {
            this._adList[this._downloadIndex].endLoadTime = getTimer() - this._adList[this._downloadIndex].startLoadTime;
            if (!this._isShown)
            {
                this._isShown = true;
                this.dispatch(TvSohuAdsEvent.SCREENSHOWN);
            }
            return;
        }// end function

        protected function adPlayed(event:MediaEvent) : void
        {
            this._tempTimer2 = new Date().getTime();
            if (this._currentIndex == 0)
            {
                if (this._adList[this._currentIndex].adPath != "" && this._tempTimer1 != 0)
                {
                    PlayerConfig.adgetSpend = this._tempTimer2 - this._tempTimer1;
                }
                else
                {
                    PlayerConfig.adgetSpend = -1;
                }
            }
            var _loc_2:int = 0;
            this._tempTimer2 = 0;
            this._tempTimer1 = _loc_2;
            return;
        }// end function

        protected function addEvent() : void
        {
            return;
        }// end function

        protected function adLoadProgress(event:MediaEvent) : void
        {
            if (event.obj.nowSize >= event.obj.totSize)
            {
                if (this._adList[this._downloadIndex].loadState != "end")
                {
                    this.adLoaded();
                }
            }
            return;
        }// end function

        protected function adLoaded() : void
        {
            this._adList[this._downloadIndex].loadState = "end";
            this._adList[this._downloadIndex].ad.removeEventListener(MediaEvent.LOAD_PROGRESS, this.adLoadProgress);
            PlayerConfig.startAdLoadTime = getTimer() - this._adBeginTime;
            if (this._downloadIndex < (this._adList.length - 1))
            {
                AdLog.msg((this._downloadIndex + 1) + " :: downloadAd");
                this.downloadAd((this._downloadIndex + 1));
            }
            else
            {
                AdLog.msg(" :: TvSohuAdsEvent.START_AD_LOADED");
                if (!this._isFinishLoaded)
                {
                    this.dispatch(TvSohuAdsEvent.START_AD_LOADED);
                    this._isFinishLoaded = true;
                }
            }
            return;
        }// end function

        protected function adLoadError(event:MediaEvent) : void
        {
            var _loc_2:* = event.target.id;
            this._adList[_loc_2].isLoadErr = true;
            AdLog.msg(_loc_2 + " :: adLoadError : evt.type : " + event.type + "   ::  playState   ::   " + this._adList[_loc_2].playState);
            event.target.removeEventListener(MediaEvent.STOP, this.adStop);
            event.target.removeEventListener(MediaEvent.CONNECT_TIMEOUT, this.adConnectTimeOut);
            event.target.removeEventListener(MediaEvent.PLAY_ABEND, this.adPlayError);
            this._adList[this._downloadIndex].errtype = event.type;
            this._adList[this._downloadIndex].errTip.loadTip();
            if (this._adList[_loc_2].playState == "playing")
            {
                AdLog.msg(_loc_2 + " :: errTip.play()");
                this.adPingback("p2");
                this._adList[_loc_2].errTip.play();
            }
            this.sendAdPQ(this._downloadIndex);
            return;
        }// end function

        protected function adConnectTimeOut(event:MediaEvent) : void
        {
            var _loc_2:* = event.target.id;
            this._adList[_loc_2].isConnectTimeOut = true;
            AdLog.msg(this._downloadIndex + "：ConnectTimeOut ");
            this._adList[this._downloadIndex].errtype = event.type;
            this._adTimeout = this._adTimeout + this._adList[this._downloadIndex].duration;
            if (this._adList[this._downloadIndex].playState == "playing" || this._adList[this._downloadIndex].playState == "end")
            {
                this.adPingback("p1");
                this.adStop();
            }
            this.sendAdPQ(this._downloadIndex);
            return;
        }// end function

        protected function adPlayError(event:MediaEvent) : void
        {
            AdLog.msg(this._currentIndex + "：PlayError：evt.type：" + event.type);
            this._adList[this._currentIndex].errtype = event.type + "_pt:" + event.obj.playedTime + "-tt:" + event.obj.totTime;
            this._adPlayError = this._adPlayError + this._adList[this._currentIndex].duration;
            if (this._adList[this._currentIndex].playState == "playing")
            {
                this.adStop();
            }
            return;
        }// end function

        protected function adStop(event:MediaEvent = null) : void
        {
            var _loc_2:Array = null;
            var _loc_3:int = 0;
            this._adList[this._currentIndex].errtype = event != null ? (event.type + ":" + event.obj.mask) : (this._adList[this._currentIndex].errtype);
            if (this._adList[this._currentIndex].errtyp != null && this._adList[this._currentIndex].errtype == MediaEvent.STOP && Math.abs(this._adList[this._currentIndex].ad.fileTotTime - this._adList[this._currentIndex].duration) > 3)
            {
                this._adList[this._currentIndex].errtype = "downloadError";
                this._adDownloadError = this._adDownloadError + this._adList[this._currentIndex].duration;
                AdLog.msg(this._currentIndex + "：downloadError : _adDownloadError" + this._adDownloadError);
            }
            this._adNowTime = this._adNowTime + this._adList[this._currentIndex].duration;
            this._adList[this._currentIndex].endPlayTime = getTimer();
            this._adList[this._currentIndex].ad.removeEventListener(MediaEvent.PLAY_PROGRESS, this.adPlayProgress);
            if (this._adList[this._currentIndex].adArrPB != null && this._adList[this._currentIndex].adArrPB.length > 0)
            {
                _loc_2 = this._adList[this._currentIndex].adArrPB;
                _loc_3 = 0;
                while (_loc_3 < _loc_2.length)
                {
                    
                    this._statSender.multiSend(_loc_2[_loc_3].v);
                    _loc_2.splice(_loc_3, 1);
                    _loc_3++;
                }
            }
            this.sendAdPQ(this._currentIndex);
            this._adList[this._currentIndex].ad.visible = false;
            this._adList[this._currentIndex].detail.visible = false;
            this._adList[this._currentIndex].hitArea.visible = false;
            this._adList[this._currentIndex].playState = "end";
            if (this._currentIndex < (this._adList.length - 1))
            {
                this.sendAdStopStock(this._currentIndex);
                if (!this._adList[this._currentIndex].isLoadErr)
                {
                    if (this._adList[this._currentIndex].adPlayOverStatUrl != "" && this._adList[this._currentIndex].adEfunc != null && ExternalInterface.available)
                    {
                        ExternalInterface.call(this._adList[this._currentIndex].adEfunc, this._adList[this._currentIndex].duration, this._adList[this._currentIndex].adPlayOverStatUrl);
                    }
                    else
                    {
                        this._statSender.multiSend(this._adList[this._currentIndex].adPlayOverStatUrl);
                    }
                }
                AdLog.msg((this._currentIndex + 1) + "：：playAd");
                this.playAd((this._currentIndex + 1));
            }
            else
            {
                if (this._currentIndex == (this._adList.length - 1))
                {
                    if (this._adList[this._currentIndex].adPlayOverStatUrl != "" && this._adList[this._currentIndex].adEfunc != null && ExternalInterface.available)
                    {
                        ExternalInterface.call(this._adList[this._currentIndex].adEfunc, this._adList[this._currentIndex].duration, this._adList[this._currentIndex].adPlayOverStatUrl);
                    }
                    else
                    {
                        this._statSender.multiSendAndCallBack(this._adList[this._currentIndex].adPlayOverStatUrl, this.vmCallBack);
                    }
                    this.sendAdStopStock(this._currentIndex);
                }
                AdLog.msg("关闭广告");
                if (!this._isFinishLoaded)
                {
                    AdLog.msg("skip_isFinishLoaded" + this._isFinishLoaded);
                    this.dispatch(TvSohuAdsEvent.START_AD_LOADED);
                    this._isFinishLoaded = true;
                }
                this.close();
                this.dispatch(TvSohuAdsEvent.SCREENFINISH);
                this.checkAdPlayTime("finish", "v.aty");
            }
            return;
        }// end function

        private function sendAdPQ(param1:uint) : void
        {
            return;
            try
            {
                if (this._adList[param1].adPath != "" && !this._adList[param1].isSendPQ)
                {
                    InforSender.getInstance().sendCustomMesg("http://vm.aty.sohu.com/qs?stime=" + this._adList[param1].endLoadTime + "&errtype=" + this._adList[param1].errtype + "&adtype=" + this._adList[param1].adType + "&uuid=" + PlayerConfig.uuid + "&userid=" + PlayerConfig.userId + "&totad=" + this._adList.length + "&currad=" + (param1 + 1) + "&vid=" + PlayerConfig.vid + "&out=" + PlayerConfig.domainProperty + "&type=oad" + "&adurl=" + escape(escape(this._adList[param1].adPath)) + "&pageUrl=" + escape(PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl))));
                    this._adList[param1].isSendPQ = true;
                }
            }
            catch (evt)
            {
            }
            return;
        }// end function

        protected function close() : void
        {
            var i:uint;
            PlayerConfig.startAdPlayTime = getTimer() - this._adBeginTime;
            clearTimeout(this._adTimeoutId);
            clearTimeout(this._adTipTimeout);
            this._adTipContainer.visible = false;
            this._close_btn.visible = true;
            this._state = "end";
            this._container.visible = false;
            PlayerConfig.selectAdMute = false;
            i;
            while (i < this._adList.length)
            {
                
                this._adList[i].ad.removeEventListener(MediaEvent.LOAD_PROGRESS, this.adLoadProgress);
                this._adList[i].ad.removeEventListener(MediaEvent.PLAY_PROGRESS, this.adPlayProgress);
                this._adList[i].ad.removeEventListener(MediaEvent.STOP, this.adStop);
                this._adList[i].ad.removeEventListener(MediaEvent.START, this.adStart);
                this._adList[i].ad.removeEventListener(MediaEvent.PLAYED, this.adPlayed);
                this._adList[i].ad.removeEventListener(MediaEvent.NOTFOUND, this.adLoadError);
                this._adList[i].ad.removeEventListener(MediaEvent.CONNECT_TIMEOUT, this.adConnectTimeOut);
                this._adList[i].ad.removeEventListener(MediaEvent.PLAY_ABEND, this.adPlayError);
                this._adList[i].errTip.removeEventListener(MediaEvent.STOP, this.adStop);
                this._adList[i].errTip.removeEventListener(MediaEvent.START, this.adStart);
                this._adList[i].errTip.removeEventListener(MediaEvent.PLAY_PROGRESS, this.adPlayProgress);
                this._adList[i].errTip.removeEventListener(MediaEvent.LOAD_PROGRESS, this.adLoadProgress);
                if (this._adList[i].adType == "swf")
                {
                    this._adList[i].ad.removeEventListener("allowFlash", function (event:Event) : void
            {
                _adList[i].hitArea.visible = false;
                return;
            }// end function
            );
                    this._adList[i].ad.removeEventListener("ad_click", function (event:Event) : void
            {
                _adList[i].hitArea.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                return;
            }// end function
            );
                    this._adList[i].ad.removeEventListener("pauseFlash", function (event:Event) : void
            {
                _adList[i].ad.pause();
                stopTimeOut();
                return;
            }// end function
            );
                    this._adList[i].ad.removeEventListener("resumeFlash", function (event:Event) : void
            {
                _adList[i].ad.swfStart();
                startTimeOut();
                return;
            }// end function
            );
                    this._adList[i].ad.swfStop();
                }
                else
                {
                    this._adList[i].ad.stop();
                }
                try
                {
                    this._container.removeChild(this._adList[i].ad);
                    this._container.removeChild(this._adList[i].detail);
                    this._container.removeChild(this._adList[i].hitArea);
                    this._container.removeChild(this._adList[i].errTip);
                }
                catch (evt)
                {
                }
                i = (i + 1);
            }
            return;
        }// end function

        public function unshiftList(param1:Array) : void
        {
            this._adList.unshift(new Object());
            this.initAdList([param1], 0);
            return;
        }// end function

        public function play() : void
        {
            if (Eif.available && ExternalInterface.available)
            {
                ExternalInterface.call("showFlashGames", PlayerConfig.vid, PlayerConfig.userId, this._adTotTime);
            }
            var _loc_6:int = 0;
            this._downloadIndex = 0;
            this._currentIndex = _loc_6;
            PlayerConfig.startAdTime = this._adTotTime;
            this.resize(this._width, this._height);
            this._container.visible = true;
            this.startTimeOut();
            var _loc_1:* = Utils.getBrowserCookie("fee_status");
            var _loc_2:* = Utils.getBrowserCookie("fee_ifox");
            var _loc_3:* = _loc_1 != "" || _loc_2 != "" && P2PExplorer.getInstance().hasP2P ? ("&vu=" + (_loc_1 != "" ? (_loc_1) : (_loc_2))) : ("");
            var _loc_4:Boolean = false;
            var _loc_5:int = 0;
            while (_loc_5 < this._adList.length)
            {
                
                if (this._adList[_loc_5].adPath != "")
                {
                    _loc_4 = true;
                    break;
                }
                _loc_5++;
            }
            if (_loc_3 != "" && !_loc_4)
            {
                PlayerConfig.isVipUser = true;
            }
            return;
        }// end function

        private function vmCallBack(param1:String) : void
        {
            AdLog.msg("vmCallBack : " + param1);
            this.ADS_VM_PATH = param1;
            this.checkAdPlayTime("finish", "vm.aty");
            return;
        }// end function

        protected function checkAdPlayTime(param1:String, param2:String) : void
        {
            return;
            var boo:Boolean;
            var loadPath:String;
            var isHasAd:Boolean;
            var flag:* = param1;
            var source:* = param2;
            if (!this._isCheckAdPlay)
            {
                this._isCheckAdPlay = true;
                boo = source == "vm.aty" ? (true) : (false);
                loadPath = boo ? (this.ADS_VM_PATH + "&ran=" + PlayerConfig.userId) : (CHECK_ADS_TIME + "?vid=" + PlayerConfig.vid + "&uid=" + PlayerConfig.userId + "&m=" + new Date().getTime());
                AdLog.msg("验证请求地址 : " + loadPath);
                isHasAd = this._adList[(this._adList.length - 1)] && this._adList[(this._adList.length - 1)].adPath != "" ? (true) : (false);
                new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                var num:uint;
                var allAdTime:Number;
                var k:int;
                var _adUrl:String;
                var _adSerTime:String;
                var _adPlayedTime1:String;
                var _adPlayedTime2:String;
                var i:int;
                var obj:* = param1;
                AdLog.msg("请求接口：" + source + " : : 返回状态 ： " + obj.info + " : : 返回数据：" + obj.data);
                if (obj.info == "success")
                {
                    try
                    {
                        _endTime = boo ? (uint(_bitUi.decryptBase64(obj.data, [PlayerConfig.vid, PlayerConfig.userId.substr(0, 8)]))) : (uint(_btnUi.drawBar(obj.data, PlayerConfig.vid, PlayerConfig.userId.substr(0, 8))));
                    }
                    catch (evt)
                    {
                        if (!boo)
                        {
                            dispatch(TvSohuAdsEvent.START_AD_ILLEGAL);
                        }
                        AdLog.msg("广告返回数据decoderror");
                        InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {num:"2", errType:"decoderror", loadType:source, hasAd:isHasAd});
                    }
                    AdLog.msg("_endTime:" + _endTime + "|_ebt:" + uint(_ebt));
                    num = (_endTime - uint(_ebt)) / 1000 + 3;
                    allAdTime;
                    k;
                    while (k < _adList.length)
                    {
                        
                        allAdTime = allAdTime + _adList[k].duration;
                        k = (k + 1);
                    }
                    AdLog.msg("num:" + num + "|_skipAdsTime:" + _skipAdsTime / 1000);
                    AdLog.msg("allAdTime:" + allAdTime + "|_adTimeout:" + _adTimeout + "|_adPlayError:" + _adPlayError + "|_adDownloadError:" + _adDownloadError + "|_skipAdsDuration:" + _skipAdsDuration);
                    if (num - _skipAdsTime / 1000 >= allAdTime - _adTimeout - _adPlayError - _adDownloadError - _skipAdsDuration)
                    {
                        AdLog.msg(num - _skipAdsTime / 1000 + "|" + (allAdTime - _adTimeout - _adPlayError - _adDownloadError - _skipAdsDuration) + "：合法！！flag : " + flag);
                    }
                    else
                    {
                        AdLog.msg(num - _skipAdsTime / 1000 + "|" + (allAdTime - _adTimeout - _adPlayError - _adDownloadError - _skipAdsDuration) + "：不合法！！flag : " + flag);
                        PlayerConfig.ILLEGALMSG = "2";
                        dispatch(TvSohuAdsEvent.START_AD_ILLEGAL);
                        _adUrl;
                        _adSerTime;
                        _adPlayedTime1;
                        _adPlayedTime2;
                        i;
                        while (i < _adList.length)
                        {
                            
                            if (_adList[i].adPath != "")
                            {
                                _adUrl = _adUrl + (_adList[i].adPath + "|");
                                _adSerTime = _adSerTime + (_adList[i].duration + "|");
                                _adPlayedTime1 = _adPlayedTime1 + ((_adList[i].endPlayTime - _adList[i].startPlayTime) / 1000 + "_" + _adList[i].errtype + "|");
                                _adPlayedTime2 = _adPlayedTime2 + (_adList[_currentIndex].adPlayedTime2 + "|");
                            }
                            else
                            {
                                _adUrl = _adUrl + "|";
                                _adSerTime = _adSerTime + "|";
                                _adPlayedTime1 = _adPlayedTime1 + "|";
                                _adPlayedTime2 = _adPlayedTime2 + "|";
                            }
                            i = (i + 1);
                        }
                        InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {num:"0", errType:"pb2", serTimeNum1:uint(_ebt), serTimeNum2:_endTime, clientTime:allAdTime - _adTimeout - _adPlayError - _adDownloadError - _skipAdsDuration, adUrl:escape(_adUrl), adSerTime:escape(_adSerTime), adPlayedTime1:escape(_adPlayedTime1), adPlayedTime2:escape(_adPlayedTime2), flag:flag, loadType:source, hasAd:isHasAd});
                        ErrorSenderPQ.getInstance().sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"ad", code:PlayerConfig.ADINFO_PB2_ERROR, error:"pb2", debuginfo:AdLog.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
                    }
                }
                else
                {
                    if (!boo)
                    {
                        dispatch(TvSohuAdsEvent.START_AD_ILLEGAL);
                    }
                    AdLog.msg("请求广告数据失败！原因：" + obj.info);
                    InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {num:"2", errType:obj.info, loadType:source, hasAd:isHasAd});
                    ErrorSenderPQ.getInstance().sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"ad", code:PlayerConfig.ADINFO_PB2_ERROR, error:"pb1", debuginfo:AdLog.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
                }
                return;
            }// end function
            , loadPath);
            }
            return;
        }// end function

        private function startTimeOut() : void
        {
            this._adTimeoutId = setTimeout(this.adTimeout, (this._adTotTime + PlayerConfig.startAdTimeOut) * 1000);
            if (this._adList[this._currentIndex] && this._adList[this._currentIndex].playState == "no")
            {
                this._state = "playing";
                this._adBeginTime = getTimer();
                if (!this._isPIPAd)
                {
                    AdLog.msg(this._downloadIndex + " :: downloadAd");
                    this.downloadAd(this._downloadIndex);
                }
                AdLog.msg(this._currentIndex + " :: playAd");
                this.playAd(this._currentIndex);
            }
            return;
        }// end function

        private function stopTimeOut() : void
        {
            clearTimeout(this._adTimeoutId);
            return;
        }// end function

        private function adTimeout() : void
        {
            Utils.debug("广告超时了！！！");
            this.close();
            this.dispatch(TvSohuAdsEvent.SCREEN_LOAD_FAILED);
            this.checkAdPlayTime("timeout", "v.aty");
            return;
        }// end function

        protected function downloadAd(param1:uint) : void
        {
            this._downloadIndex = param1;
            this._adList[this._downloadIndex].startLoadTime = getTimer();
            if (this._adList[param1].adPath != "" && this._adList[param1].playState != "playing" && this._adList[param1].playState != "end")
            {
                this._adList[param1].loadState = "loading";
                this._adList[param1].ad.play();
                this._adList[param1].ad.pause();
            }
            else
            {
                this.adLoaded();
            }
            return;
        }// end function

        protected function playAd(param1:uint) : void
        {
            this._currentIndex = param1;
            this.initVolume();
            this.adStop();
            return;
            if (this._adList[param1].adPath != "")
            {
                this._adList[param1].ad.addEventListener(MediaEvent.PLAY_PROGRESS, this.adPlayProgress);
                this._adList[param1].ad.visible = true;
                if (this._adList[param1].adClickUrl != "")
                {
                    this._adList[param1].hitArea.visible = true;
                }
                else
                {
                    this._adList[param1].hitArea.visible = false;
                }
                this._adList[param1].playState = "playing";
                if (this._adList[param1].isLoadErr)
                {
                    this.adPingback("p2");
                }
                else if (this._adList[param1].isConnectTimeOut)
                {
                    this.adPingback("p1");
                }
                if (this._adList[param1].adType == "swf" && this._adList[param1].isLoadErr)
                {
                    AdLog.msg(param1 + " :: errTip.play()");
                    this._adList[param1].errTip.play();
                }
                else
                {
                    this._adList[param1].ad.play();
                }
            }
            else
            {
                this.adPingback();
                this.adStop();
            }
            return;
        }// end function

        private function adPingback(param1:String = "0") : void
        {
            return;
            var _loc_2:Boolean = false;
            var _loc_3:Array = null;
            var _loc_4:RegExp = null;
            if (this._adList[this._currentIndex].adStatUrl != "")
            {
                _loc_2 = false;
                _loc_3 = this._adList[this._currentIndex].adStatUrl.split("err=[ERRORCODE]");
                if (_loc_3.length > 1)
                {
                    _loc_2 = true;
                    _loc_4 = /\[ERRORCODE]""\[ERRORCODE]/;
                    this._adList[this._currentIndex].adStatUrl = this._adList[this._currentIndex].adStatUrl.replace(_loc_4, param1);
                    AdLog.msg("第" + this._currentIndex + "条广告截取到了err=[ERRORCODE]字符替换后曝光地址为：" + this._adList[this._currentIndex].adStatUrl);
                }
                if (_loc_2 || param1 == "0")
                {
                    if (this._adList[this._currentIndex].adStatUrl != "" && this._adList[this._currentIndex].adSfunc != null && ExternalInterface.available)
                    {
                        ExternalInterface.call(this._adList[this._currentIndex].adSfunc, 0, this._adList[this._currentIndex].adStatUrl);
                    }
                    else if (this._adList[this._currentIndex].adStatUrl != "")
                    {
                        this._statSender.multiSend(this._adList[this._currentIndex].adStatUrl);
                        AdLog.msg("第 " + this._currentIndex + " 广告的" + "曝光地址上报：" + this._adList[this._currentIndex].adStatUrl);
                    }
                    this.sendAdPlayStock(this._currentIndex);
                    this._adList[this._currentIndex].adStatUrl = "";
                    if (this._adList[this._currentIndex].adType == "swf")
                    {
                        this._adList[this._currentIndex].ad.removeEventListener(TvSohuAdsEvent.SWFAD_ERROR, this.swfad_error);
                    }
                }
            }
            return;
        }// end function

        protected function sendAdPlayStock(param1:uint) : void
        {
            return;
            var _loc_2:String = null;
            try
            {
                if (!this._adList[param1].isSendAdPlayStock && this._adList[param1].adStatUrl != "")
                {
                    _loc_2 = this._adList[param1].adStatUrl.split("?").length > 1 ? (this._adList[param1].adStatUrl.split("?")[1]) : ("");
                    this.sendAdStock(param1, "oad", "b", _loc_2);
                    this._adList[param1].isSendAdPlayStock = true;
                }
            }
            catch (evt)
            {
            }
            return;
        }// end function

        protected function sendAdStopStock(param1:uint) : void
        {
            return;
            var _loc_2:String = null;
            try
            {
                if (!this._adList[param1].isSendAdStopStock && this._adList[param1].adPath != "" && this._adList[param1].adPlayOverStatUrl != "" && !this._adList[param1].isLoadErr)
                {
                    _loc_2 = this._adList[param1].adPlayOverStatUrl.split("?").length > 1 ? (this._adList[param1].adPlayOverStatUrl.split("?")[1]) : ("");
                    this.sendAdStock(param1, "oad", "a", _loc_2);
                    this._adList[param1].isSendAdStopStock = true;
                }
            }
            catch (evt)
            {
            }
            return;
        }// end function

        protected function sendAdStock(param1:uint, param2:String, param3:String, param4:String = "") : void
        {
            return;
            var _loc_5:* = param4 != "" ? ("&" + param4) : ("");
            var _loc_6:* = this._adList[param1].adPath != "" ? ("act") : ("na");
            var _loc_7:* = PlayerConfig.domainProperty == "3" ? ("http://ctr.hd.sohu.com/s.gif?prod=56") : ("http://wl.hd.sohu.com/s.gif?prod=flash");
            InforSender.getInstance().sendCustomMesg(_loc_7 + "&systype=" + (PlayerConfig.isHotOrMy ? ("0") : ("1")) + "&cid=" + PlayerConfig.catcode + "&log=" + _loc_6 + "&from=" + PlayerConfig.domainProperty + "&3th=" + (this._adList[param1].thirdAds == "" || this._adList[param1].thirdAds == "0" ? ("0") : ("1")) + "&adTime=" + this._adList[param1].duration + "&adType=" + this._adList[param1].adType + "&dmpt=" + param2 + "&po=" + param3 + "&adUrl=" + (this._adList[param1].adPath != "" ? (escape(this._adList[param1].adPath)) : ("")) + _loc_5);
            return;
        }// end function

        public function destroy() : void
        {
            this.close();
            this.sysInit("start");
            this._container.visible = false;
            this._isShown = false;
            this._isFinishLoaded = false;
            return;
        }// end function

        public function get state() : String
        {
            return this._state;
        }// end function

        public function get isAutoPlayAd() : Boolean
        {
            return this._isAutoPlayAd;
        }// end function

        public function set isAutoPlayAd(param1:Boolean) : void
        {
            this._isAutoPlayAd = param1;
            return;
        }// end function

        public function set ebt(param1:String) : void
        {
            this._ebt = param1;
            return;
        }// end function

        protected function newFunc() : void
        {
            this._adList = new Array();
            this._statSender = new TvSohuURLLoaderUtil();
            this._soundTransform = new SoundTransform();
            this._btnUi = new ButtonUi();
            this._bitUi = new BitUi();
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            this._width = param1 < 0 ? (0) : (param1);
            this._height = param2 < 0 ? (0) : (param2);
            if (this._iFoxPanel != null)
            {
                this._iFoxPanel.resize(this._width, this._height);
                Utils.setCenterByNumber(this._iFoxPanel, this._width, this._height);
            }
            var _loc_3:uint = 0;
            while (_loc_3 < this._adList.length)
            {
                
                this._adList[_loc_3].hitArea.width = this._width;
                this._adList[_loc_3].hitArea.height = this._height;
                this._adList[_loc_3].detail.x = 0;
                if (this._adList[_loc_3].detail.numChildren > 0)
                {
                    this._adList[_loc_3].detail.getChildAt((this._adList[_loc_3].detail.numChildren - 1)).detail_mc.x = this._width - this._adList[_loc_3].detail.getChildAt((this._adList[_loc_3].detail.numChildren - 1)).detail_mc.width - 10;
                    ;
                }
                if (this._adList[_loc_3].detail.numChildren > 0)
                {
                    this._adList[_loc_3].detail.getChildAt((this._adList[_loc_3].detail.numChildren - 1)).skipAdBtn.x = this._adList[_loc_3].detail.getChildAt((this._adList[_loc_3].detail.numChildren - 1)).detail_mc.x - this._adList[_loc_3].detail.getChildAt((this._adList[_loc_3].detail.numChildren - 1)).skipAdBtn.width - 5;
                    ;
                }
                this._adList[_loc_3].detail.y = this._height - this._adList[_loc_3].detail.height - 18 - (this._container.stage.displayState == StageDisplayState.FULL_SCREEN ? (37) : (0));
                this._adList[_loc_3].ad.resize(this._width, this._height);
                this._adList[_loc_3].errTip.resize(this._width, this._height);
                _loc_3 = _loc_3 + 1;
            }
            this._countMc["lineMc"].visible = this._close_btn.visible;
            this._countMc.width = this._close_btn.visible ? (120) : (32);
            this.soundIcon.x = this._close_btn.visible ? (this._countMc.width + 5) : (37);
            this._countDown.x = this._width - this._countDown.width - (this._close_btn.visible ? (10) : (2));
            this._countDown.y = 10;
            this._countText.scaleX = this._close_btn.visible ? (1) : (3.5);
            this._adTipContainer.x = this._width - this._adTipContainer.width;
            this._adTipContainer.y = this._height - this._adTipContainer.height - 8;
            this.resizeAdTip();
            return;
        }// end function

        private function resizeAdTip() : void
        {
            if (this._adTipContainer != null && this._tipBg != null && this._tipTxt != null && this._adTipCloseBtn != null)
            {
                var _loc_1:* = this._width;
                this._tipTxt.width = this._width;
                this._tipBg.width = _loc_1;
                this._adTipCloseBtn.x = Math.round(this._width - this._adTipCloseBtn.width / 2 - 15);
                this._adTipContainer.y = this._height - this._adTipContainer.height;
                this._adTipContainer.x = 0;
            }
            return;
        }// end function

        public function get hasAd() : Boolean
        {
            if (!PlayerConfig.HIDESTARTAD)
            {
                if (this._adList.length > 0 && TvSohuAds.getInstance().hasAds)
                {
                    this._hasAd = true;
                }
                else
                {
                    this._hasAd = false;
                }
            }
            return this._hasAd;
        }// end function

        public function get adPath() : String
        {
            var _loc_2:uint = 0;
            var _loc_1:String = "";
            while (_loc_2 < this._adList.length)
            {
                
                _loc_1 = _loc_1 + (this._adList[_loc_2].adPath + ",");
                _loc_2 = _loc_2 + 1;
            }
            _loc_1 = _loc_1.substr(_loc_1.length - 2, 1);
            return _loc_1;
        }// end function

        public function saveVolume() : void
        {
            PlayerConfig.advolume = this._volume;
            return;
        }// end function

        protected function onStatusShare(event:NetStatusEvent) : void
        {
            if (event.info.code == "SharedObject.Flush.Success")
            {
            }
            else if (event.info.code == "SharedObject.Flush.Failed")
            {
            }
            this._so.removeEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
            return;
        }// end function

        public function initVolume() : void
        {
            var _loc_1:Number = 0;
            if (this._adList[this._currentIndex] != null && this._adList[this._currentIndex].hasSound && !this._isMute)
            {
                if (PlayerConfig.advolume != null)
                {
                    _loc_1 = Number(PlayerConfig.advolume);
                }
                else
                {
                    _loc_1 = 0.5;
                }
            }
            else
            {
                _loc_1 = 0;
            }
            if (PlayerConfig.isMute)
            {
                _loc_1 = 0;
            }
            if (PlayerConfig.selectAdMute)
            {
                _loc_1 = 0;
            }
            this._volume = _loc_1;
            this._adList[this._currentIndex].ad.volume = this._volume;
            this._soundTransform.volume = this._volume;
            if (this._volume == 0)
            {
                this.soundIcon.soundState = false;
            }
            else
            {
                this.soundIcon.soundState = true;
            }
            return;
        }// end function

        public function set isMute(param1:Boolean) : void
        {
            this._isMute = param1;
            return;
        }// end function

        public function set volume(param1:Number) : void
        {
            this._volume = param1;
            this._soundTransform.volume = this._volume;
            var _loc_2:uint = 0;
            while (_loc_2 < this._adList.length)
            {
                
                this._adList[_loc_2].ad.volume = this._volume;
                _loc_2 = _loc_2 + 1;
            }
            this.saveVolume();
            if (this._volume == 0)
            {
                this.soundIcon.soundState = false;
            }
            else
            {
                this.soundIcon.soundState = true;
            }
            return;
        }// end function

        public function get volume() : Number
        {
            return this._volume;
        }// end function

        public function get isExcluded() : Boolean
        {
            var _loc_1:Boolean = false;
            if (this._adList[this._currentIndex].isExcluded)
            {
                _loc_1 = true;
            }
            return _loc_1;
        }// end function

        protected function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new TvSohuAdsEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

        private function soundIconClickHandler(event:MouseEvent) : void
        {
            if (this.soundIcon.soundState)
            {
                new URLLoaderUtil().send("http://click.hd.sohu.com.cn/s.gif?type= PL_S_UnMuteAd&_=" + new Date().time);
                dispatchEvent(new Event(TO_HAS_SOUND_ICON));
            }
            else
            {
                new URLLoaderUtil().send("http://click.hd.sohu.com.cn/s.gif?type= PL_S_MuteAd&_=" + new Date().time);
                dispatchEvent(new Event(TO_NO_SOUND_ICON));
            }
            return;
        }// end function

        protected function skipBtnHandler(event:MouseEvent) : void
        {
            if (this._adList[this._currentIndex].playState != "end")
            {
                if (this._adList[this._currentIndex].adStartTime > 0)
                {
                    this._skipAdsTime = this._skipAdsTime + (new Date().getTime() - this._adList[this._currentIndex].adStartTime);
                }
                this._skipAdsDuration = this._skipAdsDuration + this._adList[this._currentIndex].duration;
                this._adList[this._currentIndex].playState = "end";
            }
            this._adList[this._currentIndex].ad.stop();
            var _loc_2:* = /\[SKIPTIME]""\[SKIPTIME]/;
            this._skCkUrl = this._skCkUrl.replace(_loc_2, this._recordNowTime);
            this._statSender.multiSend(this._skCkUrl);
            return;
        }// end function

        private function tipCloseBtnOver(event:MouseEvent) : void
        {
            this._adTipCloseBtn.getChildByName("btnUp").visible = false;
            this._adTipCloseBtn.getChildByName("btnOver").visible = true;
            return;
        }// end function

        private function tipCloseBtnOut(event:MouseEvent) : void
        {
            this._adTipCloseBtn.getChildByName("btnUp").visible = true;
            this._adTipCloseBtn.getChildByName("btnOver").visible = false;
            return;
        }// end function

        private function tipCloseBtnUp(event:MouseEvent) : void
        {
            var _loc_2:Boolean = false;
            event.target.useHandCursor = false;
            event.target.buttonMode = _loc_2;
            this._adTipCloseBtn.removeEventListener(MouseEvent.MOUSE_UP, this.tipCloseBtnUp);
            clearTimeout(this._adTipTimeout);
            this._adTipContainer.visible = false;
            return;
        }// end function

        public static function drawCloseBtn(param1:Number, param2:uint, param3:uint) : Sprite
        {
            var _loc_4:* = new Sprite();
            var _loc_5:* = new TextField();
            var _loc_6:* = new TextFormat();
            new TextFormat().color = param3;
            _loc_6.size = 14;
            _loc_6.font = PlayerConfig.MICROSOFT_YAHEI;
            _loc_5.autoSize = TextFieldAutoSize.LEFT;
            _loc_5.defaultTextFormat = _loc_6;
            _loc_5.selectable = false;
            _loc_5.text = "付费去广告";
            _loc_5.x = 5;
            _loc_4.addChild(_loc_5);
            return _loc_4;
        }// end function

        private static function drawSquareCloseBtn(param1:Number, param2:uint, param3:uint, param4:int) : Sprite
        {
            var _loc_5:* = int(param1 / 5);
            var _loc_6:* = param1 / 2;
            var _loc_7:* = param1 / 2;
            var _loc_8:* = int(param1 / 5);
            var _loc_9:* = new Sprite();
            var _loc_10:* = new Sprite();
            new Sprite().graphics.beginFill(param2, 0);
            _loc_10.graphics.drawCircle(_loc_7, _loc_7, _loc_6);
            _loc_10.graphics.endFill();
            _loc_10.graphics.lineStyle(_loc_5, param3, 1, false, "normal", CapsStyle.NONE);
            _loc_10.graphics.moveTo(_loc_8, _loc_8);
            _loc_10.graphics.lineTo(param1 - _loc_8, param1 - _loc_8);
            _loc_10.graphics.moveTo(_loc_8, param1 - _loc_8);
            _loc_10.graphics.lineTo(param1 - _loc_8, _loc_8);
            _loc_9.addChild(_loc_10);
            _loc_10.y = (_loc_9.height - _loc_10.height) / 2;
            _loc_9.graphics.beginFill(param2, param4);
            _loc_9.graphics.drawRect(0, 0, _loc_9.width, _loc_9.height);
            _loc_9.graphics.endFill();
            return _loc_9;
        }// end function

    }
}
