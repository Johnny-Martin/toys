package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.common.ui.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class OpenVideoItem extends Sprite
    {
        private var _videoUrl:String;
        public var _picUrl:String = "";
        private var _label:String;
        private var _horizontal:Boolean;
        private var _labelText:TextField;

        public function OpenVideoItem(param1:String, param2:String, param3:String, param4:Boolean = false)
        {
            buttonMode = true;
            this._videoUrl = param1;
            this._picUrl = param2;
            this._label = param3;
            if (param3.length > 26)
            {
                this._label = param3.slice(0, 26) + "..";
            }
            this._horizontal = param4;
            this.initUI();
            addEventListener(MouseEvent.CLICK, this.onItemClick);
            addEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver);
            addEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut);
            return;
        }// end function

        private function initUI() : void
        {
            var _loc_1:OpenVideoPicFrame = null;
            this._labelText = FastCreator.createLabel(this._label, 10066329);
            this._labelText.wordWrap = true;
            this._labelText.height = 54;
            if (this._horizontal)
            {
                _loc_1 = new OpenVideoPicFrame(117, 79, this._picUrl, 16777215, 10066329, 2);
                _loc_1.x = 9.5;
                _loc_1.y = 20;
                this._labelText.x = _loc_1.x;
                this._labelText.y = 110;
                this._labelText.width = 117;
            }
            else
            {
                _loc_1 = new OpenVideoPicFrame(95, 122, this._picUrl, 16777215, 10066329, 2);
                _loc_1.x = 20.5;
                _loc_1.y = 8;
                this._labelText.x = _loc_1.x;
                this._labelText.y = 138;
                this._labelText.width = 95;
            }
            addChild(_loc_1);
            addChild(this._labelText);
            return;
        }// end function

        private function onItemClick(event:MouseEvent) : void
        {
            if (GlobalStage.isFullScreen())
            {
                GlobalStage.setNormalScreen();
            }
            navigateToURL(new URLRequest(this._videoUrl), "_self");
            return;
        }// end function

        private function onItemRollOver(event:MouseEvent) : void
        {
            this._labelText.defaultTextFormat.underline = true;
            this._labelText.textColor = 8562957;
            return;
        }// end function

        private function onItemRollOut(event:MouseEvent) : void
        {
            this._labelText.defaultTextFormat.underline = false;
            this._labelText.textColor = 10066329;
            return;
        }// end function

    }
}
