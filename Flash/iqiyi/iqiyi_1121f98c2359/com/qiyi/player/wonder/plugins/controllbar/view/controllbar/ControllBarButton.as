package com.qiyi.player.wonder.plugins.controllbar.view.controllbar
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import controllbar.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class ControllBarButton extends Sprite
    {
        private var _normalBtnBg:ControlBarBtnNormal;
        private var _hoverBtnBg:ControlBarBtnHover;
        private var _selectedNormalBtnBg:ControlBarBtnSelectedNormal;
        private var _selectedHoverBtnBg:ControlBarBtnSelectedHover;
        private var _textField:TextField;
        private var _text:String = "";
        private var _isSelected:Boolean = false;

        public function ControllBarButton(param1:String)
        {
            this._text = param1;
            this._normalBtnBg = new ControlBarBtnNormal();
            addChild(this._normalBtnBg);
            this._hoverBtnBg = new ControlBarBtnHover();
            this._hoverBtnBg.visible = false;
            addChild(this._hoverBtnBg);
            this._selectedNormalBtnBg = new ControlBarBtnSelectedNormal();
            this._selectedNormalBtnBg.visible = false;
            addChild(this._selectedNormalBtnBg);
            this._selectedHoverBtnBg = new ControlBarBtnSelectedHover();
            this._selectedHoverBtnBg.visible = false;
            addChild(this._selectedHoverBtnBg);
            var _loc_2:Boolean = false;
            this._hoverBtnBg.mouseEnabled = false;
            var _loc_2:* = _loc_2;
            this._hoverBtnBg.mouseChildren = _loc_2;
            var _loc_2:* = _loc_2;
            this._selectedHoverBtnBg.mouseEnabled = _loc_2;
            var _loc_2:* = _loc_2;
            this._selectedHoverBtnBg.mouseChildren = _loc_2;
            var _loc_2:* = _loc_2;
            this._selectedNormalBtnBg.mouseEnabled = _loc_2;
            var _loc_2:* = _loc_2;
            this._selectedNormalBtnBg.mouseChildren = _loc_2;
            var _loc_2:* = _loc_2;
            this._normalBtnBg.mouseEnabled = _loc_2;
            this._normalBtnBg.mouseChildren = _loc_2;
            var _loc_2:Boolean = true;
            this.buttonMode = true;
            this.useHandCursor = _loc_2;
            this._textField = FastCreator.createLabel(param1, 10066329, 12, TextFieldAutoSize.LEFT);
            this._textField.x = 0;
            addChild(this._textField);
            this._textField.mouseEnabled = false;
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this.updateLayout();
            return;
        }// end function

        public function get text() : String
        {
            return this._text;
        }// end function

        public function get isSelected() : Boolean
        {
            return this._isSelected;
        }// end function

        public function set isSelected(param1:Boolean) : void
        {
            this._isSelected = param1;
            if (this._isSelected)
            {
                this._selectedHoverBtnBg.visible = false;
                this._selectedNormalBtnBg.visible = true;
                this._hoverBtnBg.visible = false;
                this._normalBtnBg.visible = false;
                this._textField.defaultTextFormat = ControllBarDef.SELECTED_FONT_COLOR;
            }
            else
            {
                this._selectedHoverBtnBg.visible = false;
                this._selectedNormalBtnBg.visible = false;
                this._hoverBtnBg.visible = false;
                this._normalBtnBg.visible = true;
                this._textField.defaultTextFormat = ControllBarDef.DEFAULT_FONT_COLOR;
            }
            this._textField.text = this._text;
            return;
        }// end function

        public function updateBtnText(param1:String) : void
        {
            this._text = param1;
            this._textField.text = this._text;
            this.updateLayout();
            return;
        }// end function

        private function updateLayout() : void
        {
            var _loc_1:* = this._textField.textWidth + ControllBarDef.GAP_BG_TEXT * 2;
            this._normalBtnBg.width = this._textField.textWidth + ControllBarDef.GAP_BG_TEXT * 2;
            var _loc_1:* = _loc_1;
            this._hoverBtnBg.width = _loc_1;
            var _loc_1:* = _loc_1;
            this._selectedNormalBtnBg.width = _loc_1;
            this._selectedHoverBtnBg.width = _loc_1;
            var _loc_1:* = (BodyDef.VIDEO_BOTTOM_RESERVE - this._hoverBtnBg.height) / 2;
            this._normalBtnBg.y = (BodyDef.VIDEO_BOTTOM_RESERVE - this._hoverBtnBg.height) / 2;
            var _loc_1:* = _loc_1;
            this._hoverBtnBg.y = _loc_1;
            var _loc_1:* = _loc_1;
            this._selectedNormalBtnBg.y = _loc_1;
            this._selectedHoverBtnBg.y = _loc_1;
            var _loc_1:* = ControllBarDef.GAP_BG_MOUSE;
            this._normalBtnBg.x = ControllBarDef.GAP_BG_MOUSE;
            var _loc_1:* = _loc_1;
            this._hoverBtnBg.x = _loc_1;
            var _loc_1:* = _loc_1;
            this._selectedNormalBtnBg.x = _loc_1;
            this._selectedHoverBtnBg.x = _loc_1;
            this._textField.y = (BodyDef.VIDEO_BOTTOM_RESERVE - this._textField.height) / 2;
            this._textField.x = ControllBarDef.GAP_BG_MOUSE + ControllBarDef.GAP_BG_TEXT - 2;
            this.graphics.clear();
            this.graphics.beginFill(16777215, 0);
            this.graphics.drawRect(0, 0, this._hoverBtnBg.width + ControllBarDef.GAP_BG_MOUSE * 2, BodyDef.VIDEO_BOTTOM_RESERVE);
            this.graphics.endFill();
            return;
        }// end function

        private function onMouseOver(event:MouseEvent) : void
        {
            if (this._isSelected)
            {
                this._selectedHoverBtnBg.visible = true;
                this._selectedNormalBtnBg.visible = false;
                this._hoverBtnBg.visible = false;
                this._normalBtnBg.visible = false;
                this._textField.defaultTextFormat = ControllBarDef.SELECTED_FONT_COLOR;
            }
            else
            {
                this._selectedHoverBtnBg.visible = false;
                this._selectedNormalBtnBg.visible = false;
                this._hoverBtnBg.visible = true;
                this._normalBtnBg.visible = false;
                this._textField.defaultTextFormat = ControllBarDef.HOVER_FONT_COLOR;
            }
            this._textField.text = this._text;
            return;
        }// end function

        private function onMouseOut(event:MouseEvent) : void
        {
            if (this._isSelected)
            {
                this._selectedHoverBtnBg.visible = false;
                this._selectedNormalBtnBg.visible = true;
                this._hoverBtnBg.visible = false;
                this._normalBtnBg.visible = false;
                this._textField.defaultTextFormat = ControllBarDef.SELECTED_FONT_COLOR;
            }
            else
            {
                this._selectedHoverBtnBg.visible = false;
                this._selectedNormalBtnBg.visible = false;
                this._hoverBtnBg.visible = false;
                this._normalBtnBg.visible = true;
                this._textField.defaultTextFormat = ControllBarDef.DEFAULT_FONT_COLOR;
            }
            this._textField.text = this._text;
            return;
        }// end function

    }
}
