package com.sohu.tv.mediaplayer.ui
{
    import ebing.*;
    import ebing.utils.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.text.*;

    public class CaptionBar extends Sprite
    {
        private var _bg:Sprite;
        private var _sText:TextField;
        private var _nText:TextField;
        private var _eText:TextField;
        private var _isSCaption:Boolean = false;
        private var _isNCaption:Boolean = false;
        private var _isECaption:Boolean = false;
        private var _isCECaption:Boolean = false;
        private var _sCaptionPath:String = "";
        private var _nCaptionPath:String = "";
        private var _eCaptionPath:String = "";
        private var _ceCaptionPath:String = "";
        private var _sSrt:Srt;
        private var _nSrt:Srt;
        private var _eSrt:Srt;
        private var _ceSrt:Srt;
        private var _width:Number = 1;
        private var _height:Number = 30;
        private var _captionSizeRate:Number = 0.7;
        private var _captionAlpha:Number = 1;
        private var _pt:Number = 0;
        private var _captionColor:Number = 0;
        private var _captionVer:String = "0";
        private var _dragTip_txt:TextField;
        private var _py:Number = 0.85;
        private var _isDragState:Boolean = false;

        public function CaptionBar(param1:String, param2:String, param3:String, param4:String)
        {
            this._sCaptionPath = param1;
            this._nCaptionPath = param2;
            this._eCaptionPath = param3;
            this._ceCaptionPath = param4;
            this.newFunc();
            this.drawSkin();
            this.addEvent();
            var _loc_6:* = TextFieldAutoSize.LEFT;
            this._eText.autoSize = TextFieldAutoSize.LEFT;
            var _loc_6:* = _loc_6;
            this._nText.autoSize = _loc_6;
            this._sText.autoSize = _loc_6;
            var _loc_6:Boolean = true;
            this._eText.multiline = true;
            var _loc_6:* = _loc_6;
            this._nText.multiline = _loc_6;
            this._sText.multiline = _loc_6;
            this._sText.antiAliasType = AntiAliasType.ADVANCED;
            var _loc_6:Boolean = false;
            this._eText.selectable = false;
            var _loc_6:* = _loc_6;
            this._nText.selectable = _loc_6;
            this._sText.selectable = _loc_6;
            this._sText.wordWrap = true;
            this._bg.alpha = 0;
            var _loc_5:* = new GlowFilter(0, 1, 3, 3, 2, 1, false, false);
            this._sText.filters = [_loc_5];
            this._dragTip_txt.filters = [_loc_5];
            _loc_5.color = 10066329;
            var _loc_6:int = 8;
            _loc_5.blurY = 8;
            _loc_5.blurX = _loc_6;
            this._bg.filters = [_loc_5];
            this.captionColor = 16777215;
            this._dragTip_txt.textColor = 16777215;
            this._dragTip_txt.autoSize = TextFieldAutoSize.LEFT;
            this._dragTip_txt.visible = false;
            return;
        }// end function

        private function newFunc() : void
        {
            this._sText = new TextField();
            this._nText = new TextField();
            this._eText = new TextField();
            this._sSrt = new Srt();
            this._nSrt = new Srt();
            this._eSrt = new Srt();
            this._ceSrt = new Srt();
            this._dragTip_txt = new TextField();
            return;
        }// end function

        private function drawSkin() : void
        {
            this._bg = new Sprite();
            Utils.drawRect(this._bg, 0, 0, this._width, this._height, 0, 1);
            addChild(this._bg);
            this._dragTip_txt.text = "按住左键以调整字幕位置";
            addChild(this._dragTip_txt);
            addChild(this._sText);
            addChild(this._nText);
            addChild(this._eText);
            return;
        }// end function

        private function addEvent() : void
        {
            return;
        }// end function

        public function set py(param1:Number) : void
        {
            this._py = param1;
            return;
        }// end function

        public function get py() : Number
        {
            return this._py;
        }// end function

        public function playProgress(param1 = null) : void
        {
            if (param1 != null)
            {
                this._pt = param1.obj.nowTime * 1000;
            }
            var _loc_2:String = "";
            if (this._isSCaption)
            {
                _loc_2 = this._sSrt.getText(this._pt);
                _loc_2 = _loc_2 == "" ? (" ") : (_loc_2);
            }
            if (this._isNCaption)
            {
                _loc_2 = this._nSrt.getText(this._pt);
                _loc_2 = _loc_2 == "" ? (" ") : (_loc_2);
            }
            if (this._isECaption)
            {
                _loc_2 = this._eSrt.getText(this._pt);
                _loc_2 = _loc_2 == "" ? (" ") : (_loc_2);
            }
            if (this._isCECaption)
            {
                _loc_2 = this._ceSrt.getText(this._pt);
                _loc_2 = _loc_2 == "" ? (" ") : (_loc_2);
            }
            var _loc_3:* = /\r""\r/;
            _loc_2 = _loc_2.replace(_loc_3, "");
            this._sText.text = _loc_2;
            var _loc_4:* = new TextFormat();
            new TextFormat().size = parent["core"].videoContainer.height * this._captionSizeRate / 10 - 2;
            _loc_4.font = "_sans";
            _loc_4.bold = true;
            _loc_4.align = TextFormatAlign.CENTER;
            this._sText.setTextFormat(_loc_4);
            this._height = this._sText.textHeight + 3;
            this._bg.height = this._height;
            if (_loc_2 == " " && this._bg.alpha == 0 || this._captionVer == "0")
            {
                this.visible = false;
            }
            else
            {
                this.visible = true;
            }
            return;
        }// end function

        public function get sText() : TextField
        {
            return this._sText;
        }// end function

        public function get captionVer() : String
        {
            return this._captionVer;
        }// end function

        public function set captionVer(param1:String) : void
        {
            this._captionVer = param1;
            if (param1 == "1")
            {
                this._isSCaption = true;
                var _loc_2:Boolean = false;
                this._isECaption = false;
                var _loc_2:* = _loc_2;
                this._isNCaption = _loc_2;
                this._isCECaption = _loc_2;
                if (!this._sSrt.hasData)
                {
                    this._sSrt.loadSrtFile(this._sCaptionPath);
                }
            }
            else if (param1 == "2")
            {
                this._isNCaption = true;
                var _loc_2:Boolean = false;
                this._isECaption = false;
                var _loc_2:* = _loc_2;
                this._isSCaption = _loc_2;
                this._isCECaption = _loc_2;
                if (!this._nSrt.hasData)
                {
                    this._nSrt.loadSrtFile(this._nCaptionPath);
                }
            }
            else if (param1 == "3")
            {
                this._isECaption = true;
                var _loc_2:Boolean = false;
                this._isNCaption = false;
                var _loc_2:* = _loc_2;
                this._isSCaption = _loc_2;
                this._isCECaption = _loc_2;
                if (!this._eSrt.hasData)
                {
                    this._eSrt.loadSrtFile(this._eCaptionPath);
                }
            }
            else if (param1 == "4")
            {
                this._isCECaption = true;
                var _loc_2:Boolean = false;
                this._isECaption = false;
                var _loc_2:* = _loc_2;
                this._isNCaption = _loc_2;
                this._isSCaption = _loc_2;
                if (!this._ceSrt.hasData)
                {
                    this._ceSrt.loadSrtFile(this._ceCaptionPath);
                }
            }
            else if (param1 == "0")
            {
                var _loc_2:Boolean = false;
                this._isECaption = false;
                var _loc_2:* = _loc_2;
                this._isNCaption = _loc_2;
                this._isSCaption = _loc_2;
            }
            return;
        }// end function

        public function set captionColor(param1:Number) : void
        {
            var _loc_2:* = param1;
            this._eText.textColor = param1;
            var _loc_2:* = _loc_2;
            this._nText.textColor = _loc_2;
            var _loc_2:* = _loc_2;
            this._sText.textColor = _loc_2;
            this._captionColor = _loc_2;
            return;
        }// end function

        public function get captionColor() : Number
        {
            return this._captionColor;
        }// end function

        public function set captionAlpha(param1:Number) : void
        {
            this._captionAlpha = param1;
            var _loc_2:* = this._captionAlpha;
            this._eText.alpha = this._captionAlpha;
            var _loc_2:* = _loc_2;
            this._nText.alpha = _loc_2;
            this._sText.alpha = _loc_2;
            return;
        }// end function

        public function set captionSizeRate(param1:Number) : void
        {
            this._captionSizeRate = param1;
            this.playProgress();
            return;
        }// end function

        public function resize(param1:Number) : void
        {
            this._width = param1;
            this._bg.width = this._width;
            var _loc_2:* = this._width;
            this._eText.width = this._width;
            var _loc_2:* = _loc_2;
            this._nText.width = _loc_2;
            this._sText.width = _loc_2;
            Utils.setCenter(this._dragTip_txt, this._bg);
            this._dragTip_txt.y = -this._dragTip_txt.height;
            return;
        }// end function

        public function showDragBg() : void
        {
            this._dragTip_txt.visible = true;
            this._bg.alpha = 0.4;
            return;
        }// end function

        public function hideDragBg() : void
        {
            this._dragTip_txt.visible = false;
            this._bg.alpha = 0;
            return;
        }// end function

        public function get isDragState() : Boolean
        {
            return this._isDragState;
        }// end function

        public function set isDragState(param1:Boolean) : void
        {
            this._isDragState = param1;
            return;
        }// end function

        public function get bg() : Sprite
        {
            return this._bg;
        }// end function

        override public function get height() : Number
        {
            return this._bg.height;
        }// end function

        public function get captionAlpha() : Number
        {
            return this._captionAlpha;
        }// end function

        public function get captionSizeRate() : Number
        {
            return this._captionSizeRate;
        }// end function

    }
}
