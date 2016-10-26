package com.sohu.tv.mediaplayer.ui
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import ebing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class VerInfoPanel extends Sprite
    {
        private var _panelVersion:TextField;
        private var _bg:Sprite;
        protected var _owner:Object;
        protected var _isOpen:Boolean = false;
        private var _closeBtnUp:Sprite;
        private var _closeBtnOver:Sprite;
        private var _close_btn:Sprite;
        private var _width:Number = 0;
        private var _height:Number = 0;

        public function VerInfoPanel(param1:Number, param2:Number)
        {
            this._panelVersion = new TextField();
            this._bg = new Sprite();
            this._close_btn = new Sprite();
            this._owner = this;
            VerLog.logsText = this._panelVersion;
            this._width = param1 >= 250 ? (250) : (param1);
            this._height = param2 >= 200 ? (200) : (param2);
            this.drawSkin(this._width, this._height);
            this.addEvent();
            return;
        }// end function

        private function drawSkin(param1:Number, param2:Number) : void
        {
            Utils.drawRect(this._bg, 0, 0, param1, param2, 0, 0.8);
            addChild(this._bg);
            this._closeBtnUp = drawCloseBtn(15, 0, 16777215);
            this._closeBtnOver = drawCloseBtn(15, 0, 16711680);
            this._close_btn.addChild(this._closeBtnUp);
            this._close_btn.addChild(this._closeBtnOver);
            this._closeBtnOver.visible = false;
            var _loc_3:Boolean = true;
            this._close_btn.useHandCursor = true;
            this._close_btn.buttonMode = _loc_3;
            this._close_btn.mouseChildren = false;
            setTextFormat(this._panelVersion, 16777215);
            addChild(this._panelVersion);
            this._close_btn.x = param1 - this._close_btn.width - 5;
            this._close_btn.y = 5;
            addChild(this._close_btn);
            this._panelVersion.x = 10;
            this._panelVersion.width = param1 - 10;
            this._panelVersion.visible = false;
            this.resize(param1, param2);
            return;
        }// end function

        private function addEvent() : void
        {
            this._close_btn.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_UP, this.close);
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            this._width = param1 >= 250 ? (250) : (param1);
            this._height = param2 >= 200 ? (200) : (param2);
            if (this._bg != null && this._close_btn != null)
            {
                _loc_3 = this._width - this._bg.width;
                _loc_4 = this._height - this._bg.height;
                this._close_btn.x = this._close_btn.x + _loc_3;
                this._bg.width = this._width;
                this._panelVersion.width = this._panelVersion.width + _loc_3;
                this._bg.height = this._panelVersion.textHeight + 10;
            }
            setTextFormat(this._panelVersion, 16777215);
            return;
        }// end function

        public function close(param1 = null) : void
        {
            var evt:* = param1;
            if (evt != 0 && this._isOpen)
            {
                this._isOpen = false;
                this._owner.visible = true;
                TweenLite.to(this._owner, 0.3, {alpha:0, ease:Quad.easeOut, onComplete:function () : void
            {
                _owner.visible = false;
                return;
            }// end function
            });
            }
            else
            {
                this._owner.visible = false;
                this._owner.alpha = 0;
            }
            return;
        }// end function

        public function open(param1 = null) : void
        {
            this._panelVersion.visible = true;
            this._isOpen = true;
            this._owner.visible = true;
            TweenLite.to(this._owner, 0.3, {alpha:1, ease:Quad.easeOut});
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

        public function get isOpen() : Boolean
        {
            return this._isOpen;
        }// end function

        override public function get width() : Number
        {
            return this._bg.width;
        }// end function

        override public function get height() : Number
        {
            return this._bg.height;
        }// end function

        public static function setTextFormat(param1:TextField, param2:Number) : void
        {
            var _loc_3:* = new TextFormat();
            _loc_3.size = 12;
            _loc_3.leading = 10;
            _loc_3.font = "微软雅黑";
            _loc_3.align = TextFormatAlign.LEFT;
            param1.wordWrap = true;
            param1.textColor = param2;
            param1.setTextFormat(_loc_3);
            return;
        }// end function

        public static function drawCloseBtn(param1:Number, param2:uint, param3:uint) : Sprite
        {
            var _loc_4:* = int(param1 / 5);
            var _loc_5:* = param1 / 2;
            var _loc_6:* = param1 / 2;
            var _loc_7:* = int(param1 / 5);
            var _loc_8:* = new Sprite();
            var _loc_9:* = new Sprite();
            new Sprite().graphics.beginFill(param2, 0.8);
            _loc_9.graphics.drawCircle(_loc_6, _loc_6, _loc_5);
            _loc_9.graphics.endFill();
            _loc_9.graphics.lineStyle(_loc_4, param3, 1, false, "normal", CapsStyle.NONE);
            _loc_9.graphics.moveTo(_loc_7, _loc_7);
            _loc_9.graphics.lineTo(param1 - _loc_7, param1 - _loc_7);
            _loc_9.graphics.moveTo(_loc_7, param1 - _loc_7);
            _loc_9.graphics.lineTo(param1 - _loc_7, _loc_7);
            _loc_8.addChild(_loc_9);
            _loc_9.x = 1;
            _loc_9.y = (_loc_8.height - _loc_9.height) / 2;
            _loc_8.graphics.beginFill(4473924, 0);
            _loc_8.graphics.drawRect(0, 0, _loc_8.width, _loc_8.height);
            _loc_8.graphics.endFill();
            return _loc_8;
        }// end function

    }
}
