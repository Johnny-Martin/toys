package ebing.controls
{
    import ebing.*;
    import ebing.controls.s1.*;
    import ebing.events.*;
    import flash.display.*;

    public class VolumeBar extends Sprite
    {
        protected var _muteVol_btn:ButtonUtil;
        protected var _comebackVol_btn:ButtonUtil;
        protected var _volume_num:Number = 0;
        protected var _slider:SliderUtil;
        protected var _par:Object;
        private var _width:Number = 0;
        private var _height:Number = 0;

        public function VolumeBar(param1:Object)
        {
            this.init(param1);
            return;
        }// end function

        public function init(param1:Object) : void
        {
            this._muteVol_btn = param1.skin.muteBtn;
            this._comebackVol_btn = param1.skin.comebackBtn;
            this._par = param1;
            this.sysInit("start");
            return;
        }// end function

        protected function sysInit(param1:String) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
                this.drawSkin();
                this.addEvent();
            }
            return;
        }// end function

        protected function newFunc() : void
        {
            this._slider = new SliderUtil(this._par);
            return;
        }// end function

        protected function drawSkin() : void
        {
            var _loc_1:* = Utils.getMaxWidth([this._comebackVol_btn, this._muteVol_btn, this._slider]);
            var _loc_2:* = Utils.getMaxHeight([this._comebackVol_btn, this._muteVol_btn, this._slider]);
            addChild(this._comebackVol_btn);
            addChild(this._muteVol_btn);
            addChild(this._slider);
            Utils.setCenterByNumber(this._comebackVol_btn, _loc_1, _loc_2);
            Utils.setCenterByNumber(this._muteVol_btn, _loc_1, _loc_2);
            Utils.setCenterByNumber(this._slider, _loc_1, _loc_2);
            var _loc_3:int = 0;
            this._muteVol_btn.y = 0;
            var _loc_3:* = _loc_3;
            this._muteVol_btn.x = _loc_3;
            var _loc_3:* = _loc_3;
            this._comebackVol_btn.y = _loc_3;
            this._comebackVol_btn.x = _loc_3;
            this._slider.x = this._comebackVol_btn.width;
            this._width = this._slider.x + this._slider.width - this._comebackVol_btn.x;
            this._height = _loc_2;
            this._slider.middleRate = 1;
            return;
        }// end function

        protected function addEvent() : void
        {
            this._muteVol_btn.addEventListener(MouseEventUtil.CLICK, this.muteVolume);
            this._comebackVol_btn.addEventListener(MouseEventUtil.CLICK, this.comebackVolume);
            this._slider.addEventListener(SliderEventUtil.SLIDER_RATE, this.checkRate);
            return;
        }// end function

        protected function muteVolume(param1:MouseEventUtil) : void
        {
            this._volume_num = this._slider.topRate;
            this._slider.topRate = 0;
            this._slider.dispatch(SliderEventUtil.SLIDER_RATE, {rate:this._slider.topRate});
            this._slider.dispatch(SliderEventUtil.SLIDE_END, {sign:1});
            param1.target.visible = false;
            this._comebackVol_btn.visible = true;
            return;
        }// end function

        protected function comebackVolume(param1:MouseEventUtil) : void
        {
            this._volume_num = this._volume_num > 0 ? (this._volume_num) : (0.8);
            this._slider.topRate = this._volume_num;
            this._slider.dispatch(SliderEventUtil.SLIDER_RATE, {rate:this._slider.topRate});
            this._slider.dispatch(SliderEventUtil.SLIDE_END, {sign:1});
            param1.target.visible = false;
            this._muteVol_btn.visible = true;
            return;
        }// end function

        protected function checkRate(param1:SliderEventUtil = null) : void
        {
            if (this._slider.topRate <= 0)
            {
                this._comebackVol_btn.visible = true;
                this._muteVol_btn.visible = false;
            }
            else if (this._slider.topRate > 0 && this._slider.topRate <= 1)
            {
                this._comebackVol_btn.visible = false;
                this._muteVol_btn.visible = true;
            }
            return;
        }// end function

        override public function get width() : Number
        {
            return this._width;
        }// end function

        override public function get height() : Number
        {
            return this._height;
        }// end function

        public function set enabled(param1:Boolean) : void
        {
            var _loc_2:* = param1;
            this._comebackVol_btn.enabled = param1;
            var _loc_2:* = _loc_2;
            this._muteVol_btn.enabled = _loc_2;
            this._slider.enabled = _loc_2;
            return;
        }// end function

        public function get slider() : SliderUtil
        {
            return this._slider;
        }// end function

        public function set rate(param1:Number) : void
        {
            this._slider.topRate = param1;
            this.checkRate();
            return;
        }// end function

    }
}
