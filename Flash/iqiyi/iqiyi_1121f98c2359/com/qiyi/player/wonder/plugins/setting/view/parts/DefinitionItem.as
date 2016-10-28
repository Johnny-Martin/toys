package com.qiyi.player.wonder.plugins.setting.view.parts
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import setting.*;

    public class DefinitionItem extends Sprite
    {
        private var _data:EnumItem;
        private var _textField:TextField;
        private var _mouseArea:Shape;
        private var _isSelected:Boolean = false;
        private var _isVid:Boolean = false;
        private var _streamLimitIcon:StreamLimitIcon;
        private var _streamSelected:StreamSelected;
        private var _hasSLIcon:Boolean = false;
        private static const FONT_SIZE:uint = 12;

        public function DefinitionItem(param1:EnumItem, param2:Boolean)
        {
            this._data = param1;
            this._hasSLIcon = param2;
            if (!this._streamSelected)
            {
                this._streamSelected = new StreamSelected();
                var _loc_3:Boolean = false;
                this._streamSelected.mouseEnabled = false;
                this._streamSelected.mouseChildren = _loc_3;
                this._streamSelected.visible = false;
                addChild(this._streamSelected);
            }
            this._textField = FastCreator.createLabel("", 13421772, FONT_SIZE, TextFieldAutoSize.LEFT);
            this._textField.htmlText = this.getTextByEnumItem();
            var _loc_3:Boolean = false;
            this._textField.selectable = false;
            this._textField.mouseEnabled = _loc_3;
            addChild(this._textField);
            if (!this._streamLimitIcon && param2)
            {
                this._streamLimitIcon = new StreamLimitIcon();
                var _loc_3:Boolean = false;
                this._streamLimitIcon.mouseEnabled = false;
                this._streamLimitIcon.mouseChildren = _loc_3;
                addChild(this._streamLimitIcon);
            }
            this._mouseArea = new Shape();
            this._mouseArea.graphics.beginFill(0);
            this._mouseArea.graphics.drawRect(0, 0, SettingDef.DEFINITION_PANEL_WIDTH, SettingDef.DEFINITION_PANEL_ITEM_HEIGHT);
            this._mouseArea.graphics.endFill();
            this._mouseArea.alpha = 0;
            addChild(this._mouseArea);
            if (this._streamLimitIcon)
            {
                this._textField.x = (SettingDef.DEFINITION_PANEL_WIDTH - this._streamLimitIcon.width - this._textField.width) * 0.5 - 2;
                this._textField.y = (this.height - this._textField.height) * 0.5;
                this._streamLimitIcon.x = this._textField.x + this._textField.width + 4;
                this._streamLimitIcon.y = (this.height - this._streamLimitIcon.height) * 0.5;
            }
            else
            {
                this._textField.x = (this.width - this._textField.width) * 0.5;
                this._textField.y = (this.height - this._textField.height) * 0.5;
            }
            addEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver);
            addEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut);
            return;
        }// end function

        public function get isVid() : Boolean
        {
            return this._isVid;
        }// end function

        public function set isVid(param1:Boolean) : void
        {
            this._isVid = param1;
            if (param1)
            {
                this._textField.defaultTextFormat = FastCreator.createTextFormat(FastCreator.FONT_MSYH, FONT_SIZE, this._isSelected ? (16777215) : (SettingDef.DEFINITION_COLOR));
                this._textField.htmlText = this.getTextByEnumItem();
            }
            else
            {
                this._textField.defaultTextFormat = FastCreator.createTextFormat(FastCreator.FONT_MSYH, FONT_SIZE, 13421772);
                this._textField.htmlText = this.getTextByEnumItem();
            }
            return;
        }// end function

        public function get isSelected() : Boolean
        {
            return this._isSelected;
        }// end function

        public function set isSelected(param1:Boolean) : void
        {
            this._isSelected = param1;
            if (param1)
            {
                if (this._streamLimitIcon)
                {
                    this._streamLimitIcon.gotoAndStop("_select");
                }
                this._textField.defaultTextFormat = FastCreator.createTextFormat(FastCreator.FONT_MSYH, FONT_SIZE, 16777215);
                this._textField.htmlText = this.getTextByEnumItem();
                this._streamSelected.visible = false;
                graphics.clear();
                if (this._hasSLIcon)
                {
                    this._streamSelected.visible = param1;
                }
                else
                {
                    graphics.beginFill(SettingDef.DEFINITION_COLOR);
                    graphics.drawRoundRect(0, 0, SettingDef.DEFINITION_PANEL_WIDTH, SettingDef.DEFINITION_PANEL_ITEM_HEIGHT, SettingDef.DEFINITION_PANEL_RADIUS);
                    graphics.endFill();
                }
            }
            else
            {
                if (this._streamLimitIcon)
                {
                    this._streamLimitIcon.gotoAndStop("_unselect");
                }
                this._textField.defaultTextFormat = FastCreator.createTextFormat(FastCreator.FONT_MSYH, FONT_SIZE, 13421772);
                this._textField.htmlText = this.getTextByEnumItem();
                graphics.endFill();
            }
            return;
        }// end function

        public function get data() : EnumItem
        {
            return this._data;
        }// end function

        private function onItemRollOver(event:MouseEvent) : void
        {
            if (!this._isSelected)
            {
                graphics.clear();
                graphics.lineStyle(1, this._hasSLIcon ? (9860164) : (5865493), 0.3);
                graphics.drawRoundRect(1, 0, SettingDef.DEFINITION_PANEL_WIDTH - 2, SettingDef.DEFINITION_PANEL_ITEM_HEIGHT, SettingDef.DEFINITION_PANEL_RADIUS);
                graphics.endFill();
            }
            return;
        }// end function

        private function onItemRollOut(event:MouseEvent) : void
        {
            if (!this._isSelected)
            {
                graphics.clear();
            }
            return;
        }// end function

        private function getTextByEnumItem() : String
        {
            var _loc_1:* = ChineseNameOfLangAudioDef.getDefinitionName(this._data);
            if (this._data == DefinitionEnum.FULL_HD)
            {
                _loc_1 = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_VIEW_DES6) + _loc_1;
            }
            return _loc_1 == "" ? (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_DEFINITION_ITEM_DES1)) : (_loc_1);
        }// end function

        public function destroy() : void
        {
            if (this._streamLimitIcon && this._streamLimitIcon.parent)
            {
                removeChild(this._streamLimitIcon);
                this._streamLimitIcon = null;
            }
            this.graphics.clear();
            removeEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver);
            removeEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut);
            removeChild(this._textField);
            this._textField = null;
            return;
        }// end function

    }
}
