package ebing.controls
{
    import ebing.*;
    import ebing.controls.s1.*;
    import ebing.events.*;
    import flash.events.*;
    import flash.utils.*;

    public class SliderSpeed extends SliderUtil
    {
        protected var _forward_btn:ButtonUtil;
        protected var _back_btn:ButtonUtil;
        protected var _exeId:Number;
        protected var _seekNum:Number = -1;
        private var _width:Number = 0;
        private var _height:Number = 0;
        protected var _mouseDownId:Number = 0;
        protected var _ttt:Boolean = false;
        private var K102603F25C07E72E7B457A86E55A433967646C373566K:Number = 0;

        public function SliderSpeed(param1:Object)
        {
            super(param1);
            return;
        }// end function

        override public function init(param1:Object) : void
        {
            this._forward_btn = param1.skin.forwardBtn;
            this._back_btn = param1.skin.backBtn;
            super.init(param1);
            return;
        }// end function

        override protected function drawSkin() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            super.drawSkin();
            if (this._forward_btn != null)
            {
                _loc_1 = Utils.getMaxWidth([this._back_btn, this._forward_btn, _container]);
                _loc_2 = Utils.getMaxHeight([this._back_btn, this._forward_btn, _container]);
                addChild(this._forward_btn);
                addChild(this._back_btn);
                Utils.setCenterByNumber(this._back_btn, _loc_1, _loc_2);
                Utils.setCenterByNumber(this._forward_btn, _loc_1, _loc_2);
                Utils.setCenterByNumber(_container, _loc_1, _loc_2);
                this._back_btn.x = 0;
                _container.x = this._back_btn.width;
                this._forward_btn.x = _container.x + _container.width;
                this._width = this._forward_btn.x + this._forward_btn.width - this._back_btn.x;
                this._height = _loc_2;
            }
            return;
        }// end function

        override public function resize(param1:Number) : void
        {
            this._width = param1;
            super.resize(param1 - (this._forward_btn.width + this._back_btn.width));
            this._forward_btn.x = _container.x + _container.width;
            return;
        }// end function

        override protected function addEvent() : void
        {
            super.addEvent();
            if (this._forward_btn != null)
            {
                this._forward_btn.addEventListener(MouseEventUtil.MOUSE_DOWN, this.downHandler);
                this._forward_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.upHandler);
                this._forward_btn.addEventListener(MouseEventUtil.RELEASE_OUTSIDE, this.upHandler);
                this._back_btn.addEventListener(MouseEventUtil.MOUSE_DOWN, this.downHandler);
                this._back_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.upHandler);
                this._back_btn.addEventListener(MouseEventUtil.RELEASE_OUTSIDE, this.upHandler);
            }
            return;
        }// end function

        private function onAddStage(event:Event) : void
        {
            return;
        }// end function

        public function backward() : void
        {
            this._back_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_DOWN));
            return;
        }// end function

        public function forward() : void
        {
            this._forward_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_DOWN));
            return;
        }// end function

        public function stopForward() : void
        {
            this._forward_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
            return;
        }// end function

        public function stopBackward() : void
        {
            this._back_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
            return;
        }// end function

        override protected function downHandler(param1:MouseEventUtil) : void
        {
            var evt:* = param1;
            super.downHandler(evt);
            switch(evt.target)
            {
                case this._forward_btn:
                {
                    clearTimeout(this._mouseDownId);
                    this._mouseDownId = setTimeout(function () : void
            {
                _ttt = true;
                dispatch(SliderEventUtil.SLIDE_START);
                clearInterval(_exeId);
                _exeId = setInterval(speedForward, 20);
                return;
            }// end function
            , 300);
                    break;
                }
                case this._back_btn:
                {
                    clearTimeout(this._mouseDownId);
                    this._mouseDownId = setTimeout(function () : void
            {
                _ttt = true;
                dispatch(SliderEventUtil.SLIDE_START);
                clearInterval(_exeId);
                _exeId = setInterval(speedBack, 20);
                return;
            }// end function
            , 300);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function upHandler(param1:MouseEventUtil) : void
        {
            super.upHandler(param1);
            switch(param1.target)
            {
                case this._forward_btn:
                {
                    clearTimeout(this._mouseDownId);
                    clearInterval(this._exeId);
                    this._seekNum = -1;
                    if (!this._ttt)
                    {
                        this.speedForward(true);
                    }
                    else
                    {
                        this._ttt = false;
                    }
                    dispatch(SliderEventUtil.SLIDE_END, {sign:0, rate:_topRate_num});
                    break;
                }
                case this._back_btn:
                {
                    clearTimeout(this._mouseDownId);
                    clearInterval(this._exeId);
                    this._seekNum = -1;
                    if (!this._ttt)
                    {
                        this.speedBack(true);
                    }
                    else
                    {
                        this._ttt = false;
                    }
                    dispatch(SliderEventUtil.SLIDE_END, {sign:0, rate:_topRate_num});
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function speedForward(param1:Boolean = false) : void
        {
            trace("speedForward");
            if (this._seekNum == -1)
            {
                this._seekNum = _dollop_btn.x + _dollop_btn.width / 2;
            }
            this._seekNum = param1 ? (this._seekNum + 3) : ((this._seekNum + 1));
            doSlide(this._seekNum, 0);
            return;
        }// end function

        protected function speedBack(param1:Boolean = false) : void
        {
            trace("speedBack");
            if (this._seekNum == -1)
            {
                this._seekNum = _dollop_btn.x + _dollop_btn.width / 2;
            }
            this._seekNum = param1 ? (this._seekNum - 3) : ((this._seekNum - 1));
            doSlide(this._seekNum, 0);
            return;
        }// end function

        override public function get width() : Number
        {
            return this._width;
        }// end function

        override public function get height() : Number
        {
            trace("SliderSpeed height");
            return this._height;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            var _loc_2:* = param1;
            this._back_btn.enabled = param1;
            var _loc_2:* = _loc_2;
            this._forward_btn.enabled = _loc_2;
            super.enabled = _loc_2;
            return;
        }// end function

    }
}
