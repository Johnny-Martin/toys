package com.sohu.tv.mediaplayer.ui
{
    import com.greensock.*;
    import ebing.*;
    import ebing.controls.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class TvSohuButton extends ButtonUtil
    {
        private var _cartoon:MovieClip;
        private var _tween:TweenLite;
        private var _num:int = 0;
        private var _str:String;
        private var _time:Number;
        private var _verObj:Object;

        public function TvSohuButton(param1:Object)
        {
            this._verObj = new Object();
            super(param1);
            return;
        }// end function

        override protected function sysInit() : void
        {
            super.sysInit();
            this._verObj = Utils.RegExpVersion();
            return;
        }// end function

        public function set hasLable(param1:String) : void
        {
            if (_skin_mc.txt != null)
            {
                _skin_mc.txt.text = param1;
            }
            this._str = param1;
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            if (_enabled_boo != param1)
            {
                _enabled_boo = param1;
                if (param1)
                {
                    _target.buttonMode = true;
                    _target.useHandCursor = true;
                    this.addEvent();
                }
                else
                {
                    _target.buttonMode = false;
                    _target.useHandCursor = false;
                    if (_skin_mc != null)
                    {
                        _skin_mc.gotoAndStop(4);
                    }
                    this.removeEvent();
                }
            }
            if (_skin_mc.txt != null)
            {
                _skin_mc.txt.text = this._str;
            }
            return;
        }// end function

        override protected function clickHandler(event:MouseEvent) : void
        {
            super.clickHandler(event);
            this.setTimeFun();
            return;
        }// end function

        override protected function overHandler(event:MouseEvent) : void
        {
            super.overHandler(event);
            if (_skin_mc.txt != null)
            {
                _skin_mc.txt.text = this._str;
            }
            return;
        }// end function

        override protected function downHandler(event:MouseEvent) : void
        {
            super.downHandler(event);
            this.setTimeFun();
            return;
        }// end function

        override protected function upHandler(event:MouseEvent) : void
        {
            super.upHandler(event);
            if (_skin_mc.txt != null)
            {
                _skin_mc.txt.text = this._str;
            }
            return;
        }// end function

        override protected function onStageMouseUp(event:MouseEvent) : void
        {
            super.onStageMouseUp(event);
            if (_skin_mc.txt != null)
            {
                _skin_mc.txt.text = this._str;
            }
            return;
        }// end function

        override protected function outHandler(event:MouseEvent) : void
        {
            super.outHandler(event);
            this.setTimeFun();
            return;
        }// end function

        override protected function moveHandler(event:MouseEvent) : void
        {
            super.moveHandler(event);
            if (_skin_mc.txt != null)
            {
                _skin_mc.txt.text = this._str;
            }
            return;
        }// end function

        override protected function doubleHandler(event:MouseEvent) : void
        {
            super.doubleHandler(event);
            if (_skin_mc.txt != null)
            {
                _skin_mc.txt.text = this._str;
            }
            return;
        }// end function

        override protected function addEvent() : void
        {
            _target.addEventListener(MouseEvent.MOUSE_DOWN, this.downHandler);
            _target.addEventListener(MouseEvent.MOUSE_UP, this.upHandler);
            _target.addEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);
            _target.addEventListener(MouseEvent.DOUBLE_CLICK, this.doubleHandler);
            _target.addEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }// end function

        override protected function removeEvent() : void
        {
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, this.downHandler);
            _target.removeEventListener(MouseEvent.MOUSE_UP, this.upHandler);
            _target.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);
            _target.removeEventListener(MouseEvent.DOUBLE_CLICK, this.doubleHandler);
            _target.removeEventListener(MouseEvent.CLICK, this.clickHandler);
            return;
        }// end function

        public function set clicked(param1:Boolean) : void
        {
            if (param1)
            {
                if (_skin_mc != null)
                {
                    _skin_mc.gotoAndStop(3);
                }
            }
            else if (_skin_mc != null)
            {
                _skin_mc.gotoAndStop(1);
            }
            return;
        }// end function

        private function setTimeFun() : void
        {
            if (this._verObj.majorVersion == 9)
            {
                this._time = setInterval(function () : void
            {
                if (_skin_mc.txt.text != null)
                {
                    _skin_mc.txt.text = _str;
                    clearInterval(_time);
                }
                return;
            }// end function
            , 50);
            }
            else if (_skin_mc.txt != null)
            {
                _skin_mc.txt.text = this._str;
            }
            return;
        }// end function

    }
}
