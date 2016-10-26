package ebing.controls
{
    import ebing.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class SliderPreview extends SliderSpeed
    {
        protected var _previewTip_mc:Object;
        private var _enabled_boo:Boolean = false;
        private var K1026033AA2253713C54411AA0DDBFDB90B7389373566K:Number = 0;

        public function SliderPreview(param1:Object)
        {
            super(param1);
            return;
        }// end function

        override public function init(param1:Object) : void
        {
            this._previewTip_mc = param1.skin.previewTip;
            super.init(param1);
            return;
        }// end function

        override protected function drawSkin() : void
        {
            super.drawSkin();
            if (this._previewTip_mc != null)
            {
                addChild(this._previewTip_mc);
                this._previewTip_mc.visible = false;
                var _loc_1:int = 0;
                this._previewTip_mc.y = 0;
                this._previewTip_mc.x = _loc_1;
            }
            return;
        }// end function

        override protected function addEvent() : void
        {
            super.addEvent();
            _container.addEventListener(MouseEvent.MOUSE_OVER, this.sliderOverHandler);
            return;
        }// end function

        protected function sliderOverHandler(event:MouseEvent) : void
        {
            var evt:* = event;
            this.K1026033AA2253713C54411AA0DDBFDB90B7389373566K = setTimeout(function () : void
            {
                if (_previewTip_mc != null && _enabled_boo && _isDrag)
                {
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMoveHandler);
                    stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
                }
                return;
            }// end function
            , 100);
            return;
        }// end function

        protected function sliderMoveHandler(event:MouseEvent) : void
        {
            var _loc_2:* = _container.mouseX;
            this._previewTip_mc.x = this.mouseX;
            this._previewTip_mc.y = _hit_spr.y;
            if (_container.hitTestPoint(stage.mouseX, stage.mouseY))
            {
                this._previewTip_mc.visible = true;
            }
            else
            {
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.sliderMoveHandler);
                this._previewTip_mc.visible = false;
            }
            dispatch(SliderEventUtil.SLIDER_PREVIEW_RATE, {rate:getTopRate(_loc_2)});
            return;
        }// end function

        public function set previewTip(param1:String) : void
        {
            if (this._previewTip_mc != null)
            {
                this._previewTip_mc.time_txt.text = param1;
            }
            return;
        }// end function

        public function get previewSlip() : MovieClip
        {
            return this._previewTip_mc;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            var _loc_2:* = param1;
            this._enabled_boo = param1;
            super.enabled = _loc_2;
            if (_forward_btn != null)
            {
                var _loc_2:* = param1;
                _back_btn.enabled = param1;
                _forward_btn.enabled = _loc_2;
            }
            return;
        }// end function

    }
}
