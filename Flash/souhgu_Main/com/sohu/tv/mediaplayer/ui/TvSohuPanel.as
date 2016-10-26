package com.sohu.tv.mediaplayer.ui
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;

    public class TvSohuPanel extends Sprite
    {
        protected var _owner:Object;
        protected var _skin:MovieClip;
        protected var _isOpen:Boolean = false;
        protected var _close_btn:SimpleButton;

        public function TvSohuPanel(param1:MovieClip, param2:Boolean = true)
        {
            this._owner = this;
            if (param2)
            {
                this.BaseHardInit(param1);
            }
            return;
        }// end function

        public function BaseHardInit(param1:MovieClip) : void
        {
            this._skin = param1;
            var _loc_2:int = 0;
            this._skin.y = 0;
            this._skin.x = _loc_2;
            addChild(this._skin);
            this._close_btn = this._skin.close_btn;
            this._close_btn.addEventListener(MouseEvent.MOUSE_UP, this.close);
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
            this._isOpen = true;
            this._owner.visible = true;
            TweenLite.to(this._owner, 0.3, {alpha:1, ease:Quad.easeOut});
            return;
        }// end function

        public function resizeHandler(event:Event = null) : void
        {
            this.changeSize(this._owner["parent"].core.width, this._owner["parent"].core.height);
            return;
        }// end function

        public function changeSize(param1:Number, param2:Number) : void
        {
            var _loc_3:Number = NaN;
            if (param1 <= this._skin.width || param2 <= this._skin.height)
            {
                _loc_3 = Math.min(param1 / this._skin.width, param2 / this._skin.height);
                this._skin.scaleX = _loc_3 * this._skin.scaleX;
                this._skin.scaleY = _loc_3 * this._skin.scaleY;
            }
            else
            {
                var _loc_4:int = 1;
                this._skin.scaleY = 1;
                this._skin.scaleX = _loc_4;
            }
            return;
        }// end function

        public function get isOpen() : Boolean
        {
            return this._isOpen;
        }// end function

        override public function get width() : Number
        {
            this.resizeHandler();
            return this._skin.width;
        }// end function

        override public function get height() : Number
        {
            this.resizeHandler();
            return this._skin.height;
        }// end function

    }
}
