package ebing.controls.s1
{
    import ebing.*;
    import ebing.controls.*;
    import ebing.events.*;
    import flash.display.*;
    import flash.events.*;

    public class SliderUtil extends Sprite
    {
        protected var _skin_spr:Object;
        protected var _dollop_btn:ButtonUtil;
        protected var _top_mc:Object;
        protected var _middle_mc:Object;
        protected var _bottom_mc:Object;
        protected var _mouseTip_obj:Object;
        protected var _btn_mt:MouseTipUtil;
        protected var _btnMt_str:String;
        protected var _topRate_num:Number = 0;
        protected var _middleRate_num:Number = 0;
        protected var _isSliderEnd:Boolean = false;
        protected var _hit_spr:Sprite;
        protected var _container:Sprite;
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _enabled_boo:Boolean = true;
        protected var _isDrag:Boolean = true;

        public function SliderUtil(param1:Object)
        {
            this.init(param1);
            return;
        }// end function

        public function init(param1:Object) : void
        {
            this._dollop_btn = param1.skin.dollop;
            this._top_mc = param1.skin.top;
            this._middle_mc = param1.skin.middle;
            this._bottom_mc = param1.skin.bottom;
            this._isDrag = param1.isDrag;
            this.sysInit("start");
            return;
        }// end function

        public function set isDrag(param1:Boolean) : void
        {
            this._isDrag = param1;
            return;
        }// end function

        public function resize(param1:Number) : void
        {
            var _loc_2:* = param1;
            this._bottom_mc.width = param1;
            this._width = _loc_2;
            this.topRate = this.topRate;
            this.middleRate = this.middleRate;
            return;
        }// end function

        protected function sysInit(param1:String) : void
        {
            if (param1 == "start")
            {
                this._hit_spr = new Sprite();
                Utils.drawRect(this._hit_spr, 0, 0, 1, this._middle_mc.height, 16777215, 0);
                this.newFunc();
                this.drawSkin();
                this.addEvent();
                this._hit_spr.buttonMode = true;
            }
            return;
        }// end function

        protected function drawSkin() : void
        {
            this._container = new Sprite();
            var _loc_1:* = Utils.getMaxWidth([this._top_mc, this._middle_mc, this._bottom_mc, this._dollop_btn, this._hit_spr]);
            var _loc_2:* = Utils.getMaxHeight([this._top_mc, this._middle_mc, this._bottom_mc, this._dollop_btn, this._hit_spr]);
            this._width = this._bottom_mc.width;
            this._height = _loc_2;
            this._container.addChild(this._bottom_mc);
            this._container.addChild(this._middle_mc);
            this._container.addChild(this._top_mc);
            this._container.addChild(this._hit_spr);
            this._container.addChild(this._dollop_btn);
            Utils.setCenterByNumber(this._bottom_mc, _loc_1, _loc_2);
            Utils.setCenterByNumber(this._middle_mc, _loc_1, _loc_2);
            Utils.setCenterByNumber(this._dollop_btn, _loc_1, _loc_2);
            Utils.setCenterByNumber(this._top_mc, _loc_1, _loc_2);
            Utils.setCenterByNumber(this._hit_spr, _loc_1, _loc_2);
            var _loc_3:int = 0;
            this._hit_spr.x = 0;
            var _loc_3:* = _loc_3;
            this._dollop_btn.x = _loc_3;
            var _loc_3:* = _loc_3;
            this._top_mc.x = _loc_3;
            var _loc_3:* = _loc_3;
            this._middle_mc.x = _loc_3;
            this._bottom_mc.x = _loc_3;
            var _loc_3:int = 0;
            this._middle_mc.width = 0;
            this._top_mc.width = _loc_3;
            addChild(this._container);
            var _loc_3:int = 0;
            this._container.y = 0;
            this._container.x = _loc_3;
            return;
        }// end function

        protected function newFunc() : void
        {
            return;
        }// end function

        protected function addEvent() : void
        {
            ButtonUtil.register(this._hit_spr);
            this._dollop_btn.addEventListener(MouseEventUtil.MOUSE_DOWN, this.downHandler);
            this._dollop_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.upHandler);
            this._dollop_btn.addEventListener(MouseEventUtil.RELEASE_OUTSIDE, this.upHandler);
            this._hit_spr.addEventListener(MouseEventUtil.MOUSE_DOWN, this.downHandler);
            return;
        }// end function

        protected function enabledHandler(param1:MouseEventUtil) : void
        {
            trace("stop1");
            if (!this._enabled_boo)
            {
                trace("stop");
                param1.stopImmediatePropagation();
            }
            return;
        }// end function

        protected function moveHandler(event:MouseEvent) : void
        {
            trace("evt.buttonDown:" + event.buttonDown);
            if (event.buttonDown)
            {
                this.doSlide(this._container.mouseX, 0);
            }
            return;
        }// end function

        protected function doSlide(param1:Number, param2:Number) : void
        {
            this._topRate_num = this.getTopRate(param1);
            this._dollop_btn.x = this._topRate_num * (this._bottom_mc.width - this._dollop_btn.width);
            this._top_mc.width = this._dollop_btn.x + this._dollop_btn.width / 2;
            if (this._topRate_num == 0)
            {
                this._top_mc.visible = false;
            }
            else
            {
                this._top_mc.visible = true;
            }
            this.dispatch(SliderEventUtil.SLIDER_RATE, {rate:this._topRate_num, sign:param2});
            return;
        }// end function

        protected function getTopRate(param1:Number) : Number
        {
            var _loc_2:* = param1;
            var _loc_3:* = this._dollop_btn.width / 2;
            var _loc_4:* = this._isDrag ? (this._bottom_mc) : (this._middle_mc);
            if (_loc_2 <= _loc_3)
            {
                _loc_2 = _loc_3;
            }
            else if (_loc_2 >= _loc_4.width - _loc_3)
            {
                _loc_2 = _loc_4.width - _loc_3;
            }
            return (_loc_2 - _loc_3) / (this._bottom_mc.width - this._dollop_btn.width);
        }// end function

        protected function downHandler(param1:MouseEventUtil) : void
        {
            var _loc_2:MouseEvent = null;
            switch(param1.target)
            {
                case this._dollop_btn:
                {
                    this.dispatch(SliderEventUtil.SLIDE_START);
                    this._isSliderEnd = false;
                    trace("-------------stage:" + stage, "MOUSE_MOVE:" + MouseEvent.MOUSE_MOVE, "moveHandler:" + this.moveHandler);
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);
                    _loc_2 = new MouseEvent(MouseEvent.MOUSE_MOVE);
                    _loc_2.buttonDown = true;
                    this.moveHandler(_loc_2);
                    break;
                }
                case this._hit_spr:
                {
                    this.doSlide(this._container.mouseX, 1);
                    this.dispatch(SliderEventUtil.SLIDE_END, {sign:1});
                    this._isSliderEnd = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function upHandler(param1:MouseEventUtil) : void
        {
            trace("--------:" + param1.target);
            switch(param1.target)
            {
                case this._dollop_btn:
                {
                    if (!this._isSliderEnd)
                    {
                        this.dispatch(SliderEventUtil.SLIDE_END, {sign:0, rate:this._topRate_num});
                    }
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);
                    break;
                }
                default:
                {
                    break;
                }
            }
            param1.target.stopDrag();
            return;
        }// end function

        public function get topRate() : Number
        {
            return this._topRate_num;
        }// end function

        public function get middleRate() : Number
        {
            return this._middleRate_num;
        }// end function

        public function set topRate(param1:Number) : void
        {
            if (param1 >= 0 && param1 <= 1)
            {
                this._topRate_num = param1;
                this._top_mc.width = this._topRate_num * (this._bottom_mc.width - this._dollop_btn.width) + this._dollop_btn.width / 2;
                this._dollop_btn.x = Math.floor(this._top_mc.width - this._dollop_btn.width / 2);
                if (this._topRate_num == 0)
                {
                    this._top_mc.visible = false;
                }
                else
                {
                    this._top_mc.visible = true;
                }
            }
            return;
        }// end function

        public function set enabled(param1:Boolean) : void
        {
            if (this._enabled_boo != param1)
            {
                this._enabled_boo = param1;
                this._dollop_btn.enabled = param1;
                if (param1)
                {
                    this._hit_spr.buttonMode = true;
                    if (!this._hit_spr.hasEventListener(MouseEventUtil.MOUSE_DOWN))
                    {
                        this._hit_spr.addEventListener(MouseEventUtil.MOUSE_DOWN, this.downHandler);
                    }
                    if (!this._dollop_btn.hasEventListener(MouseEventUtil.MOUSE_DOWN) && !this._dollop_btn.hasEventListener(MouseEventUtil.MOUSE_UP) && !this._dollop_btn.hasEventListener(MouseEventUtil.RELEASE_OUTSIDE))
                    {
                        this._dollop_btn.addEventListener(MouseEventUtil.MOUSE_DOWN, this.downHandler);
                        this._dollop_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.upHandler);
                        this._dollop_btn.addEventListener(MouseEventUtil.RELEASE_OUTSIDE, this.upHandler);
                    }
                }
                else
                {
                    this._hit_spr.buttonMode = false;
                    this._hit_spr.removeEventListener(MouseEventUtil.MOUSE_DOWN, this.downHandler);
                    this._dollop_btn.removeEventListener(MouseEventUtil.MOUSE_DOWN, this.downHandler);
                    this._dollop_btn.removeEventListener(MouseEventUtil.MOUSE_UP, this.upHandler);
                    this._dollop_btn.removeEventListener(MouseEventUtil.RELEASE_OUTSIDE, this.upHandler);
                }
            }
            return;
        }// end function

        public function get enabled() : Boolean
        {
            return this._enabled_boo;
        }// end function

        override public function get width() : Number
        {
            trace("SliderUtil width");
            return this._width;
        }// end function

        override public function get height() : Number
        {
            trace("SliderUtil height");
            return this._height;
        }// end function

        public function set middleRate(param1:Number) : void
        {
            if (param1 >= 0 && param1 <= 1)
            {
                this._middleRate_num = param1;
                if (this._isDrag)
                {
                    this._hit_spr.width = this._bottom_mc.width;
                }
                else
                {
                    var _loc_2:* = this._bottom_mc.width * this._middleRate_num;
                    this._middle_mc.width = this._bottom_mc.width * this._middleRate_num;
                    this._hit_spr.width = _loc_2;
                }
                this._middle_mc.width = this._bottom_mc.width * this._middleRate_num;
            }
            return;
        }// end function

        public function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new SliderEventUtil(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

    }
}
