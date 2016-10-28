package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class OpenVideoPicFrame extends Sprite
    {
        private var _picW:int;
        private var _picH:int;
        private var _picUrl:String;
        private var _bgColor:uint;
        private var _lineColor:int;
        private var _margin:int;
        private var _loader:Loader;

        public function OpenVideoPicFrame(param1:int, param2:int, param3:String, param4:uint, param5:uint, param6:int)
        {
            this._picW = param1;
            this._picH = param2;
            this._picUrl = param3;
            this._bgColor = param4;
            this._lineColor = param5;
            this._margin = param6;
            graphics.lineStyle(1, this._lineColor);
            graphics.beginFill(this._bgColor, 1);
            graphics.drawRect(0, 0, this._picW + this._margin * 2, this._picH + this._margin * 2);
            graphics.endFill();
            addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
            addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
            this.loadPicture();
            return;
        }// end function

        private function onRollOver(event:MouseEvent) : void
        {
            graphics.clear();
            graphics.lineStyle(2, 8562957);
            graphics.beginFill(this._bgColor, 1);
            graphics.drawRect(0, 0, this._picW + this._margin * 2, this._picH + this._margin * 2);
            graphics.endFill();
            return;
        }// end function

        private function onRollOut(event:MouseEvent) : void
        {
            graphics.clear();
            graphics.lineStyle(1, this._lineColor);
            graphics.beginFill(this._bgColor, 1);
            graphics.drawRect(0, 0, this._picW + this._margin * 2, this._picH + this._margin * 2);
            graphics.endFill();
            return;
        }// end function

        private function loadPicture() : void
        {
            var _loc_1:* = new URLRequest(this._picUrl);
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadComplete);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler);
            this._loader.load(_loc_1);
            return;
        }// end function

        private function onLoadComplete(event:Event) : void
        {
            this._loader.width = this._picW;
            this._loader.height = this._picH;
            addChild(this._loader);
            var _loc_2:* = this._margin;
            this._loader.y = this._margin;
            this._loader.x = _loc_2;
            return;
        }// end function

        private function onIOErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

    }
}
