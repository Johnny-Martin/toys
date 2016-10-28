package com.qiyi.player.wonder.body.view
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.common.config.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;

    public class AppView extends Sprite
    {
        private var _curVideoLayer:Sprite;
        private var _preVideoLayer:Sprite;
        private var _hintVideoLayer:Sprite;
        private var _mouseClickLayer:Sprite;
        private var _filterLayer:Sprite;
        private var _barrageLayer:Sprite;
        private var _ADLayer:Sprite;
        private var _fixLayer:Sprite;
        private var _fixSub1Layer:Sprite;
        private var _sceneTileToolLayer:Sprite;
        private var _popupLayer:Sprite;
        private var _rewardLayer:Sprite;

        public function AppView()
        {
            this.initLayer();
            GlobalStage.stage.addEventListener(Event.RESIZE, this.onStageResize);
            GlobalStage.stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.onFullScreen);
            GlobalStage.stage.addEventListener(Event.MOUSE_LEAVE, this.onMouseLeaveStage);
            return;
        }// end function

        public function get curVideoLayer() : Sprite
        {
            return this._curVideoLayer;
        }// end function

        public function get preVideoLayer() : Sprite
        {
            return this._preVideoLayer;
        }// end function

        public function get hintVideoLayer() : Sprite
        {
            return this._hintVideoLayer;
        }// end function

        public function get filterLayer() : Sprite
        {
            return this._filterLayer;
        }// end function

        public function get barrageLayer() : Sprite
        {
            return this._barrageLayer;
        }// end function

        public function get ADLayer() : Sprite
        {
            return this._ADLayer;
        }// end function

        public function get fixLayer() : Sprite
        {
            return this._fixLayer;
        }// end function

        public function get fixSub1Layer() : Sprite
        {
            return this._fixSub1Layer;
        }// end function

        public function get sceneTileToolLayer() : Sprite
        {
            return this._sceneTileToolLayer;
        }// end function

        public function get popupLayer() : Sprite
        {
            return this._popupLayer;
        }// end function

        public function get rewardLayer() : Sprite
        {
            return this._rewardLayer;
        }// end function

        public function switchPreLayer() : void
        {
            removeChild(this._curVideoLayer);
            addChildAt(this._preVideoLayer, 0);
            var _loc_1:* = this._curVideoLayer;
            this._curVideoLayer = this._preVideoLayer;
            this._preVideoLayer = _loc_1;
            return;
        }// end function

        private function initLayer() : void
        {
            this._curVideoLayer = new Sprite();
            addChildAt(this._curVideoLayer, 0);
            this._preVideoLayer = new Sprite();
            this._hintVideoLayer = new Sprite();
            addChild(this._hintVideoLayer);
            this._mouseClickLayer = new Sprite();
            this._mouseClickLayer.graphics.beginFill(0, 0);
            this._mouseClickLayer.graphics.drawRect(0, 0, 1, 1);
            this._mouseClickLayer.graphics.endFill();
            this._mouseClickLayer.width = GlobalStage.stage.stageWidth;
            this._mouseClickLayer.height = GlobalStage.stage.stageHeight;
            this._mouseClickLayer.doubleClickEnabled = true;
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                GlobalStage.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseLayerClick);
            }
            else
            {
                this._mouseClickLayer.addEventListener(MouseEvent.CLICK, this.onMouseLayerClick);
            }
            this._mouseClickLayer.addEventListener(MouseEvent.DOUBLE_CLICK, this.onMouseLayerDoubleClick);
            addChild(this._mouseClickLayer);
            this._filterLayer = new Sprite();
            var _loc_1:Boolean = false;
            this._filterLayer.mouseChildren = false;
            this._filterLayer.mouseEnabled = _loc_1;
            addChild(this._filterLayer);
            this._barrageLayer = new Sprite();
            addChild(this._barrageLayer);
            this._rewardLayer = new Sprite();
            addChild(this._rewardLayer);
            this._ADLayer = new Sprite();
            addChild(this._ADLayer);
            this._fixLayer = new Sprite();
            addChild(this._fixLayer);
            this._fixSub1Layer = new Sprite();
            this._fixLayer.addChild(this._fixSub1Layer);
            this._sceneTileToolLayer = new Sprite();
            addChild(this._sceneTileToolLayer);
            this._popupLayer = new Sprite();
            addChild(this._popupLayer);
            return;
        }// end function

        private function onMouseLayerClick(event:MouseEvent) : void
        {
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                if (event.target == GlobalStage.stage && event.delta == 1)
                {
                    TweenLite.killTweensOf(this.onMouseLayerClickHandler);
                    TweenLite.delayedCall(0.35, this.onMouseLayerClickHandler);
                }
            }
            else
            {
                TweenLite.killTweensOf(this.onMouseLayerClickHandler);
                TweenLite.delayedCall(0.35, this.onMouseLayerClickHandler);
            }
            return;
        }// end function

        private function onMouseLayerClickHandler() : void
        {
            dispatchEvent(new BodyEvent(BodyEvent.Evt_MouseLayerClick));
            return;
        }// end function

        private function onMouseLayerDoubleClick(event:MouseEvent) : void
        {
            TweenLite.killTweensOf(this.onMouseLayerClickHandler);
            dispatchEvent(new BodyEvent(BodyEvent.Evt_MouseLayerDoubleClick));
            return;
        }// end function

        private function onStageResize(event:Event) : void
        {
            this._mouseClickLayer.width = GlobalStage.stage.stageWidth;
            this._mouseClickLayer.height = GlobalStage.stage.stageHeight;
            dispatchEvent(new BodyEvent(BodyEvent.Evt_StageResize));
            return;
        }// end function

        private function onFullScreen(event:FullScreenEvent) : void
        {
            dispatchEvent(new BodyEvent(BodyEvent.Evt_FullScreen, event.fullScreen));
            return;
        }// end function

        private function onMouseLeaveStage(event:Event) : void
        {
            dispatchEvent(new BodyEvent(BodyEvent.Evt_LeaveStage));
            return;
        }// end function

    }
}
