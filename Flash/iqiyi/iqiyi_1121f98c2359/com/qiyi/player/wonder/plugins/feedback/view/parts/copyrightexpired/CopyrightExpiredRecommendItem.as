package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired
{
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.recommend.model.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class CopyrightExpiredRecommendItem extends Sprite
    {
        private var _data:RecommendVO;
        private var _imageLine:Shape;
        private var _loader:Loader;
        private var _tfVideoName:TextField;
        public static const ITEM_WIDTH:uint = 118;

        public function CopyrightExpiredRecommendItem(param1:RecommendVO)
        {
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:String = null;
            this._data = param1;
            this._imageLine = new Shape();
            this._imageLine.graphics.beginFill(6645093);
            this._imageLine.graphics.drawRect(0, 0, ITEM_WIDTH, 68);
            this._imageLine.graphics.endFill();
            this._imageLine.visible = false;
            addChild(this._imageLine);
            var _loc_7:Boolean = true;
            this.buttonMode = true;
            this.useHandCursor = _loc_7;
            var _loc_2:* = this._data.picUrl;
            if (_loc_2 == null || _loc_2 == "")
            {
                _loc_2 = SystemConfig.DEFAULT_IMAGE_URL;
            }
            else
            {
                _loc_4 = _loc_2.match(/_\d+_\d+\.""_\d+_\d+\./);
                if (_loc_4 && _loc_4.length > 0)
                {
                    _loc_2 = _loc_2.replace(/_\d+_\d+\.""_\d+_\d+\./, "_116_65.");
                }
                else
                {
                    _loc_5 = _loc_2.lastIndexOf(".");
                    _loc_6 = _loc_2.substr(0, _loc_5);
                    _loc_6 = _loc_6 + "_116_65";
                    _loc_6 = _loc_6 + _loc_2.substr(_loc_5);
                    _loc_2 = _loc_6;
                }
            }
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError);
            this._loader.load(new URLRequest(_loc_2));
            var _loc_7:Boolean = false;
            this._loader.mouseEnabled = false;
            this._loader.mouseChildren = _loc_7;
            addChild(this._loader);
            var _loc_3:* = this._data.videoName.length > 17 ? (this._data.videoName.slice(0, 17) + "...") : (this._data.videoName);
            this._tfVideoName = FastCreator.createLabel("", 16777215, 12);
            this._tfVideoName.y = 67;
            this._tfVideoName.x = 0;
            this._tfVideoName.width = ITEM_WIDTH;
            addChild(this._tfVideoName);
            this._tfVideoName.wordWrap = true;
            this._tfVideoName.defaultTextFormat = new TextFormat(FastCreator.FONT_MSYH, 12, 16777215, false, null, null, null, null, "center");
            this._tfVideoName.text = _loc_3;
            var _loc_7:Boolean = false;
            this._tfVideoName.mouseEnabled = false;
            this._tfVideoName.selectable = _loc_7;
            addEventListener(MouseEvent.MOUSE_OVER, this.onRollOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onRollOut);
            return;
        }// end function

        public function get data() : RecommendVO
        {
            return this._data;
        }// end function

        private function onComplete(event:Event) : void
        {
            var _loc_2:int = 1;
            this._loader.y = 1;
            this._loader.x = _loc_2;
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError);
            return;
        }// end function

        private function onIOError(event:Event) : void
        {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError);
            return;
        }// end function

        private function onRollOver(event:MouseEvent) : void
        {
            this._imageLine.graphics.clear();
            this._imageLine.graphics.beginFill(16777215);
            this._imageLine.graphics.drawRect(0, 0, ITEM_WIDTH, 68);
            this._imageLine.graphics.endFill();
            this._imageLine.visible = true;
            return;
        }// end function

        private function onRollOut(event:MouseEvent) : void
        {
            this._imageLine.graphics.clear();
            this._imageLine.visible = false;
            return;
        }// end function

        public function destroy() : void
        {
            this._imageLine.graphics.clear();
            if (this._imageLine.parent)
            {
                removeChild(this._imageLine);
            }
            this._data = null;
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError);
            if (this._loader.parent)
            {
                removeChild(this._loader);
            }
            this._loader = null;
            return;
        }// end function

    }
}
