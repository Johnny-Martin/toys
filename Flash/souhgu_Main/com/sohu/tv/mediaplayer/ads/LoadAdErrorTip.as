package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;

    public class LoadAdErrorTip extends Sprite
    {
        private var _tipMc:Sprite;
        private var _tipTimer:Timer;
        private var _tipTimeLimit:Number = 0;
        protected var _fileTotTime:Number = 0;
        protected var _filePlayedTime:Number = 0;
        protected var _errStatusSp:Sprite;
        protected var limit:TextField;
        protected var _width:Number = 0;
        protected var _height:Number = 0;
        protected var tf:TextFormat;
        protected var _tipFlagState:String = "";
        protected var _isErrTipShown:Boolean = false;
        protected var _bg:Sprite;
        private var _textSp:Sprite;
        private var _errIco:MovieClip;
        private var _QRCode:MovieClip;
        private var _qrSp:Sprite;
        private var _mcSp:Sprite;
        private var _isChange:Boolean = false;

        public function LoadAdErrorTip(param1:Object)
        {
            this._tipTimeLimit = param1.time;
            this._width = param1.width;
            this._height = param1.height;
            this._tipTimer = new Timer(1000, 0);
            this._tipTimer.addEventListener(TimerEvent.TIMER, this.tipTimerHandler);
            this._tipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.stop);
            this.newFunc();
            this.drawSkin();
            this.addEvent();
            return;
        }// end function

        public function loadTip() : void
        {
            this.dispatch(MediaEvent.LOAD_PROGRESS, {nowSize:1, totSize:1});
            return;
        }// end function

        public function play() : void
        {
            if (!this._isErrTipShown)
            {
                this._tipTimer.start();
                this._errStatusSp.visible = true;
                this._tipFlagState = "play";
                this.dispatch(MediaEvent.START);
                this._isErrTipShown = true;
            }
            this.stop();
            return;
        }// end function

        protected function tipTimerHandler(event:TimerEvent) : void
        {
            this._filePlayedTime = this._filePlayedTime + event.target.delay / 1000;
            this.dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:this._filePlayedTime, totTime:this._tipTimeLimit * 1000});
            return;
        }// end function

        public function pause(param1 = null) : void
        {
            this._tipTimer.stop();
            this._tipFlagState = "pause";
            return;
        }// end function

        public function reStart(param1 = null) : void
        {
            this._tipTimer.start();
            this._tipFlagState = "play";
            return;
        }// end function

        public function stop(param1 = null) : void
        {
            this._tipTimer.stop();
            this._errStatusSp.visible = false;
            this._tipFlagState = "stop";
            this.dispatch(MediaEvent.STOP, {finish:true});
            this._isErrTipShown = false;
            return;
        }// end function

        private function newFunc() : void
        {
            return;
        }// end function

        private function drawSkin() : void
        {
            this._errStatusSp = new Sprite();
            this._textSp = new Sprite();
            this._qrSp = new Sprite();
            this._textSp.visible = false;
            this._bg = new Sprite();
            this._mcSp = new Sprite();
            Utils.drawRect(this._bg, 0, 0, this._width, this._height, 0, 1);
            this._errStatusSp.addChild(this._bg);
            var _loc_1:* = new errMark();
            this._errIco = _loc_1.errIco;
            this._QRCode = _loc_1.QRCode;
            this._textSp.addChild(this._errIco);
            this._qrSp.addChild(this._QRCode);
            var _loc_2:* = PlayerConfig.ILLEGAL_INTERCEPT_DATA.split("|");
            var _loc_3:* = this.setFont(_loc_2[0], 24, 16777215, 500, 35, TextFormatAlign.CENTER);
            var _loc_4:* = this.setFont(_loc_2[1], 14, 16777215, 500, 25, TextFormatAlign.CENTER);
            var _loc_5:* = this.setFont(_loc_2[2], 14, 13421772, 500, 25, TextFormatAlign.CENTER);
            _loc_4.addEventListener(TextEvent.LINK, this.linkHandler);
            this._textSp.addChild(_loc_3);
            this._textSp.addChild(_loc_4);
            this._qrSp.addChild(_loc_5);
            _loc_3.x = this._errIco.width;
            var _loc_6:int = 0;
            _loc_5.x = 0;
            _loc_4.x = _loc_6;
            _loc_4.y = _loc_3.y + _loc_3.textHeight + 15;
            this._errIco.x = _loc_3.x + (_loc_3.width - _loc_3.textWidth) / 2 - this._errIco.width - 12;
            this._errIco.y = _loc_3.y;
            this._mcSp.addChild(this._textSp);
            this._qrSp.name = "qrSp";
            this._mcSp.addChild(this._qrSp);
            Utils.setCenter(this._QRCode, _loc_5);
            this._QRCode.y = _loc_5.y + _loc_5.textHeight + 10;
            var _loc_6:Boolean = false;
            this._qrSp.visible = false;
            this._textSp.visible = _loc_6;
            this._qrSp.x = this._textSp.x;
            this._qrSp.y = this._textSp.y + this._textSp.height;
            this._errStatusSp.addChild(this._mcSp);
            addChild(this._errStatusSp);
            this._errStatusSp.visible = false;
            this.resize(this._width, this._height);
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            ErrorSenderPQ.getInstance().sendFeedback();
            return;
        }// end function

        private function setFont(param1:String, param2:Number = 14, param3:uint = 16777215, param4:Number = 0, param5:Number = 0, param6:String = "center") : TextField
        {
            var _loc_7:* = new TextField();
            var _loc_8:* = new TextFormat();
            new TextFormat().size = param2;
            _loc_8.leading = 10;
            _loc_7.wordWrap = true;
            _loc_8.font = PlayerConfig.MICROSOFT_YAHEI;
            _loc_8.align = param6;
            _loc_7.textColor = param3;
            _loc_7.htmlText = param1;
            _loc_7.width = param4;
            _loc_7.height = param5;
            _loc_7.setTextFormat(_loc_8);
            return _loc_7;
        }// end function

        private function addEvent() : void
        {
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            this._width = param1 < 0 ? (0) : (param1);
            this._height = param2 < 0 ? (0) : (param2);
            this._bg.width = this._width;
            this._bg.height = this._height;
            if (this._mcSp.height + 20 > this._height && this._mcSp.getChildByName("qrSp") != null)
            {
                this._qrSp.visible = false;
                this._mcSp.removeChild(this._qrSp);
            }
            else
            {
                this._mcSp.addChild(this._qrSp);
                this._qrSp.visible = true;
            }
            Utils.setCenter(this._mcSp, this._bg);
            this._textSp.visible = true;
            return;
        }// end function

        public function get errStatusSp() : Sprite
        {
            return this._errStatusSp;
        }// end function

        public function get tipFlagState() : String
        {
            return this._tipFlagState;
        }// end function

        protected function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new MediaEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

    }
}
