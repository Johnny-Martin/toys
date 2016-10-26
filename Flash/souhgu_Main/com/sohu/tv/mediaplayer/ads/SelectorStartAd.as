package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import com.sohu.tv.mediaplayer.ui.*;
    import ebing.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class SelectorStartAd extends EventDispatcher implements IAds
    {
        protected var _width:Number;
        protected var _height:Number;
        protected var _container:Sprite;
        protected var _state:String = "no";
        protected var _owner:SelectorStartAd;
        protected var _adNowTime:uint;
        protected var _adTotTime:uint;
        protected var _statSender:URLLoaderUtil;
        protected var _isShown:Boolean = false;
        protected var _countText:TextField;
        protected var _countMc:Sprite;
        protected var _wtimer:Timer;
        protected var _hasAd:Boolean = false;
        private var _adSelectorJson:Object;
        private var _selectedVideo:String;
        protected var _closeBtnUp:Sprite;
        protected var _closeBtnOver:Sprite;
        protected var _close_btn:Sprite;
        private var _picContainer:Sprite;
        private var _textMc:Sprite;
        private var selectorStartAdPar:Array;
        private var adArr:Array;
        private var _area:Sprite;
        protected var _isAdTip:Boolean = false;
        private var lc:LoaderContext;
        private var isfirst:Boolean = true;
        private var _localSound:Sound;
        private var _soundChannel:SoundChannel;
        private var soundIcon:SoundIcon;
        protected var _countDown:Sprite;
        private var _volume:Number = 0.5;
        private var _iFoxPanel:Object;
        public static const TO_HAS_SOUND_ICON:String = "to_has_sound_icon";
        public static const TO_NO_SOUND_ICON:String = "to_no_sound_icon";

        public function SelectorStartAd(param1:Object)
        {
            this.adArr = new Array();
            this._area = new Sprite();
            this.lc = new LoaderContext(true);
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

        protected function sysInit(param1:String = null) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
                this.drawSkin();
                this.addEvent();
            }
            var _loc_2:int = 0;
            this._adTotTime = 0;
            this._adNowTime = _loc_2;
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

        protected function drawSkin() : void
        {
            this._textMc = new Sprite();
            this._picContainer = new Sprite();
            this._countDown = new Sprite();
            this.soundIcon = new SoundIcon();
            this.resize(this._width, this._height);
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            this.selectorStartAdPar = param1.adPar;
            if (this.selectorStartAdPar != null && this.selectorStartAdPar.length == 4)
            {
                this.initAd(this.selectorStartAdPar);
            }
            else
            {
                Utils.debug("选择器数据为空!");
                this.close();
            }
            return;
        }// end function

        protected function initAd(param1:Array) : void
        {
            var _loc_4:TextLike = null;
            var _loc_5:SelectItem = null;
            this._container.visible = false;
            this._area = new Sprite();
            this._picContainer = new Sprite();
            this._countMc = new CountBg_n();
            Utils.drawRect(this._area, 0, 0, this._width, this._height, 1973790, 1);
            Utils.drawRect(this._picContainer, 0, 0, 570, 451, 16777215, 0);
            this._container.addChild(this._area);
            this._container.addChild(this._picContainer);
            this._container.addChild(this._textMc);
            this._container.addChild(this._countDown);
            this._countDown.addChild(this._countMc);
            this._picContainer.x = (this._width - this._picContainer.width) / 2;
            this._picContainer.y = (this._height - this._picContainer.height) / 2;
            if (param1[0].bgmurl != null && param1[0].bgmurl != undefined && param1[0].bgmurl != "")
            {
                if (this._localSound == null)
                {
                    this._localSound = new Sound(new URLRequest(param1[0].bgmurl));
                }
            }
            if (param1[0].bgpurl != null && param1[0].bgpurl != undefined && param1[0].bgpurl != "")
            {
                new LoaderUtil().load(8, this.picLoadHandler, null, param1[0].bgpurl, this.lc);
            }
            else
            {
                _loc_4 = new TextLike();
                this._textMc.addChild(_loc_4);
                this._textMc.x = Math.floor((this._width - this._textMc.width) / 2);
                this._textMc.y = this._picContainer.y + 30;
            }
            this._adTotTime = uint(param1[0].cdtime);
            this._adTotTime = this._adTotTime > 10 || this._adTotTime <= 0 ? (10) : (this._adTotTime);
            this._countText = new TextField();
            this._countText.selectable = false;
            this._countText.width = 32;
            this._countText.height = 30;
            var _loc_2:* = new TextFormat();
            _loc_2.font = PlayerConfig.MICROSOFT_YAHEI;
            _loc_2.align = TextFormatAlign.CENTER;
            _loc_2.color = 15154225;
            _loc_2.size = 14;
            this._countText.defaultTextFormat = _loc_2;
            this._countMc.addChild(this._countText);
            this._countText.y = 3;
            this._close_btn = new Sprite();
            this._closeBtnUp = drawCloseBtn(15, 0, 16777215);
            this._closeBtnOver = drawCloseBtn(15, 0, 16711680);
            this._close_btn.addChild(this._closeBtnUp);
            this._close_btn.addChild(this._closeBtnOver);
            this._countMc.addChild(this._close_btn);
            this.soundIcon.x = this._countMc.width + 5;
            this._countDown.addChild(this.soundIcon);
            this.soundIcon.addEventListener(MouseEvent.MOUSE_DOWN, this.soundIconClickHandler);
            this._close_btn.x = this._countMc.width - this._close_btn.width - 12;
            this._close_btn.y = (this._countMc.height - this._close_btn.height) / 2 - 2.5;
            this._closeBtnOver.visible = false;
            var _loc_6:Boolean = true;
            this._close_btn.useHandCursor = true;
            this._close_btn.buttonMode = _loc_6;
            this._close_btn.mouseChildren = false;
            this._close_btn.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
            this._wtimer = new Timer(1000, this._adTotTime);
            this._wtimer.addEventListener(TimerEvent.TIMER, this.adPlayProgress);
            this._wtimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.adPlayComplete);
            var _loc_3:int = 0;
            while (_loc_3 < 4)
            {
                
                _loc_5 = new SelectItem(param1[_loc_3]);
                _loc_5.buttonMode = true;
                _loc_5.aname = _loc_3.toString();
                _loc_5.addEventListener(MouseEvent.CLICK, this.adClickHandler);
                this._picContainer.addChild(_loc_5);
                if (_loc_3 == 0)
                {
                    _loc_5.x = 30;
                    _loc_5.y = (this._textMc.height == 0 ? (21) : (this._textMc.height)) + 60;
                }
                else if (_loc_3 == 1)
                {
                    _loc_5.x = this._picContainer.width - _loc_5.width - 30;
                    _loc_5.y = (this._textMc.height == 0 ? (21) : (this._textMc.height)) + 60;
                }
                else if (_loc_3 == 2)
                {
                    _loc_5.x = 30;
                    _loc_5.y = this._picContainer.height - _loc_5.height - 30;
                }
                else if (_loc_3 == 3)
                {
                    _loc_5.x = this._picContainer.width - _loc_5.width - 30;
                    _loc_5.y = this._picContainer.height - _loc_5.height - 30;
                }
                param1.push(_loc_5);
                this.initVolume();
                _loc_3++;
            }
            if (this._isAdTip || PlayerConfig.is56)
            {
                this._isAdTip = false;
                this._close_btn.visible = false;
                this.resize(this._width, this._height);
            }
            else
            {
                this._close_btn.visible = true;
            }
            this._hasAd = true;
            if (!this._isShown)
            {
                this._isShown = true;
                this.dispatch(TvSohuAdsEvent.SCREENSHOWN);
            }
            return;
        }// end function

        private function picLoadHandler(param1:Object) : void
        {
            var _loc_2:Loader = null;
            var _loc_3:TextLike = null;
            if (param1.info == "success")
            {
                param1.data.content.smoothing = true;
                _loc_2 = param1.data;
                _loc_2.width = param1.data.width > 270 ? (270) : (param1.data.width);
                _loc_2.height = 21;
                this._textMc.addChild(_loc_2);
            }
            else
            {
                _loc_3 = new TextLike();
                this._textMc.addChild(_loc_3);
            }
            this._textMc.x = Math.floor((this._width - this._textMc.width) / 2);
            this._textMc.y = this._picContainer.y + 30;
            return;
        }// end function

        protected function adPlayProgress(event:TimerEvent) : void
        {
            if (this.isfirst)
            {
                if (this._localSound != null)
                {
                    this._soundChannel = this._localSound.play(0);
                }
                if (this._soundChannel != null)
                {
                    if (this._volume == 0)
                    {
                        this._soundChannel.soundTransform = new SoundTransform(0);
                    }
                    else
                    {
                        this._soundChannel.soundTransform = new SoundTransform(1);
                    }
                    this.isfirst = false;
                }
            }
            var _loc_2:* = Math.ceil(this._adTotTime - this._wtimer.currentCount);
            var _loc_3:* = _loc_2 < 0 ? (0) : (_loc_2);
            this._countText.htmlText = _loc_3.toString();
            this._adNowTime = this._wtimer.currentCount;
            this.dispatch(TvSohuAdsEvent.SELECTOR_PLAY_PROGRESS);
            return;
        }// end function

        protected function addEvent() : void
        {
            return;
        }// end function

        protected function adPlayComplete(event:TimerEvent) : void
        {
            this._adNowTime = this._adTotTime;
            this.close();
            return;
        }// end function

        protected function close() : void
        {
            if (this._soundChannel != null)
            {
                this._soundChannel.stop();
            }
            this._hasAd = false;
            this._state = "end";
            if (this._wtimer != null && this._wtimer.running)
            {
                this._wtimer.stop();
            }
            this.dispatch(TvSohuAdsEvent.SELECTORFINISH);
            this._container.visible = false;
            this._isShown = false;
            this.isfirst = true;
            try
            {
                this._container.removeChild(this._area);
                this._container.removeChild(this._picContainer);
                this._container.removeChild(this._countDown);
                this._container.removeChild(this._textMc);
                this._countDown.removeChild(this._countMc);
                this._countMc.removeChild(this._countText);
                this._countMc.removeChild(this._close_btn);
                if (this._textMc.numChildren > 0)
                {
                    this._textMc.removeChildAt(0);
                }
                while (this._picContainer.numChildren > 0)
                {
                    
                    this._picContainer.removeChildAt(0);
                }
            }
            catch (evt)
            {
            }
            return;
        }// end function

        public function play() : void
        {
            this._container.visible = true;
            this._state = "playing";
            this.showSelector();
            this.dispatch(TvSohuAdsEvent.SCREENSHOWN);
            return;
        }// end function

        public function destroy() : void
        {
            this.close();
            return;
        }// end function

        public function get state() : String
        {
            return this._state;
        }// end function

        protected function newFunc() : void
        {
            this._statSender = new URLLoaderUtil();
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            this._width = param1 < 0 ? (0) : (param1);
            this._height = param2 < 0 ? (0) : (param2);
            if (this._width < 480)
            {
                this._textMc.x = Math.floor((this._width - this._textMc.width) / 2);
                var _loc_3:* = this._width / 480;
                this._textMc.scaleY = this._width / 480;
                this._textMc.scaleX = _loc_3;
            }
            else
            {
                this._textMc.x = Math.floor((this._width - this._textMc.width) / 2);
                var _loc_3:int = 1;
                this._textMc.scaleY = 1;
                this._textMc.scaleX = _loc_3;
            }
            if (this._width < 583 || this._height < 460)
            {
                var _loc_3:* = Math.min(this._width / 570, this._height / 451);
                this._picContainer.scaleY = Math.min(this._width / 570, this._height / 451);
                this._picContainer.scaleX = _loc_3;
                this._picContainer.x = (this._width - this._picContainer.width) / 2;
                this._picContainer.y = (this._height - this._picContainer.height) / 2 + 20;
                this._textMc.y = this._picContainer.y + 30 * Math.min(this._width / 570, this._height / 451);
            }
            else
            {
                var _loc_3:int = 1;
                this._picContainer.scaleY = 1;
                this._picContainer.scaleX = _loc_3;
                this._picContainer.x = (this._width - 570) / 2;
                this._picContainer.y = (this._height - 451) / 2;
                this._textMc.y = this._picContainer.y + 30;
            }
            this._area.width = this._width;
            this._area.height = this._height;
            if (this._countDown != null && this._close_btn != null && this._countMc != null)
            {
                this._countMc["lineMc"].visible = this._close_btn.visible;
                this._countMc.width = this._close_btn.visible ? (120) : (32);
                this.soundIcon.x = this._close_btn.visible ? (this._countMc.width + 5) : (37);
                this._countDown.x = this._width - this._countDown.width - (this._close_btn.visible ? (10) : (2));
                this._countDown.y = 10;
                this._countText.scaleX = this._close_btn.visible ? (1) : (3.5);
            }
            if (this._iFoxPanel != null)
            {
                this._iFoxPanel.resize(this._width, this._height);
                Utils.setCenterByNumber(this._iFoxPanel, this._width, this._height);
            }
            return;
        }// end function

        public function get hasAd() : Boolean
        {
            return this._hasAd;
        }// end function

        public function get adPath() : String
        {
            return "";
        }// end function

        public function get video() : String
        {
            return this._selectedVideo;
        }// end function

        protected function showSelector() : void
        {
            this._wtimer.start();
            this._countMc.visible = true;
            this._countText.htmlText = this._adTotTime.toString();
            return;
        }// end function

        protected function adClickHandler(event:MouseEvent) : void
        {
            var _loc_3:RegExp = null;
            var _loc_2:int = -1;
            switch(event.currentTarget.aname)
            {
                case "0":
                {
                    _loc_2 = 0;
                    break;
                }
                case "1":
                {
                    _loc_2 = 1;
                    break;
                }
                case "2":
                {
                    _loc_2 = 2;
                    break;
                }
                case "3":
                {
                    _loc_2 = 3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.selectorStartAdPar[_loc_2].ckurl != "" && this.selectorStartAdPar[_loc_2].ckurl != null)
            {
                _loc_3 = /\[SKIPTIME]""\[SKIPTIME]/;
                this._statSender.multiSend(this.selectorStartAdPar[_loc_2].ckurl.replace(_loc_3, this._wtimer.currentCount.toString()));
            }
            this.selectedVideo(_loc_2);
            this.close();
            return;
        }// end function

        protected function selectedVideo(param1:int) : void
        {
            if (this.selectorStartAdPar[param1].ad && this.selectorStartAdPar[param1].ad != null)
            {
                this._selectedVideo = this.selectorStartAdPar[param1].ad;
            }
            return;
        }// end function

        protected function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new TvSohuAdsEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
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

        protected function mouseUpHandler(event:MouseEvent) : void
        {
            this.pause();
            var _loc_2:Boolean = false;
            event.target.mouseEnabled = false;
            var _loc_2:* = _loc_2;
            event.target.useHandCursor = _loc_2;
            event.target.buttonMode = _loc_2;
            this._close_btn.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.showIFoxPanel();
            SendRef.getInstance().sendPQ("PL_S_CloseAD");
            dispatchEvent(new Event("openIFoxPanel"));
            return;
        }// end function

        private function pause() : void
        {
            this._wtimer.stop();
            return;
        }// end function

        private function resetPlay() : void
        {
            this._wtimer.start();
            var _loc_1:Boolean = true;
            this._close_btn.mouseEnabled = true;
            var _loc_1:* = _loc_1;
            this._close_btn.useHandCursor = _loc_1;
            this._close_btn.buttonMode = _loc_1;
            this._close_btn.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            return;
        }// end function

        public function set isAdTip(param1:Boolean) : void
        {
            this._isAdTip = param1;
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

        private function soundIconClickHandler(event:MouseEvent) : void
        {
            if (this.soundIcon.soundState)
            {
                PlayerConfig.selectAdMute = false;
                if (this._soundChannel != null)
                {
                    this._soundChannel.soundTransform = new SoundTransform(1);
                }
                new URLLoaderUtil().send("http://click.hd.sohu.com.cn/s.gif?type= PL_S_UnMuteAd&_=" + new Date().time);
                dispatchEvent(new Event(TO_HAS_SOUND_ICON));
            }
            else
            {
                PlayerConfig.selectAdMute = true;
                if (this._soundChannel != null)
                {
                    this._soundChannel.soundTransform = new SoundTransform(0);
                }
                new URLLoaderUtil().send("http://click.hd.sohu.com.cn/s.gif?type= PL_S_MuteAd&_=" + new Date().time);
                dispatchEvent(new Event(TO_NO_SOUND_ICON));
            }
            return;
        }// end function

        public function initVolume() : void
        {
            var _loc_1:Number = 0;
            if (PlayerConfig.isMute)
            {
                _loc_1 = 0;
            }
            else
            {
                _loc_1 = 0.5;
            }
            this._volume = _loc_1;
            if (this._volume == 0)
            {
                this.soundIcon.soundState = false;
                PlayerConfig.selectAdMute = true;
            }
            else
            {
                this.soundIcon.soundState = true;
                PlayerConfig.selectAdMute = false;
            }
            return;
        }// end function

        public function set volume(param1:Number) : void
        {
            this._volume = param1;
            if (this._volume == 0)
            {
                PlayerConfig.selectAdMute = true;
                this.soundIcon.soundState = false;
                if (this._soundChannel != null)
                {
                    this._soundChannel.soundTransform = new SoundTransform(0);
                }
            }
            else
            {
                PlayerConfig.selectAdMute = false;
                this.soundIcon.soundState = true;
                if (this._soundChannel != null)
                {
                    this._soundChannel.soundTransform = new SoundTransform(1);
                }
            }
            return;
        }// end function

        public function get volume() : Number
        {
            return this._volume;
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
            _loc_5.selectable = false;
            _loc_5.text = "付费去广告";
            _loc_5.x = 5;
            _loc_5.setTextFormat(_loc_6);
            _loc_4.addChild(_loc_5);
            return _loc_4;
        }// end function

    }
}
