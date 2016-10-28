package com.iqiyi.components.tooltip
{
    import flash.display.*;
    import flash.text.*;

    public class DefaultToolTip extends Sprite implements IDefaultToolTip
    {
        private const GAP:int = 3;
        private var _bg:DefaultBg;
        private var _textField:TextField;

        public function DefaultToolTip()
        {
            this._bg = new DefaultBg();
            addChild(this._bg);
            this._textField = new TextField();
            this._textField.x = this.GAP;
            this._textField.y = this.GAP;
            this._textField.type = TextFieldType.DYNAMIC;
            this._textField.multiline = true;
            this._textField.wordWrap = false;
            this._textField.selectable = false;
            this._textField.autoSize = TextFieldAutoSize.LEFT;
            this._textField.mouseEnabled = false;
            var _loc_1:* = new TextFormat();
            _loc_1.size = 12;
            _loc_1.color = 16777215;
            _loc_1.align = TextFormatAlign.LEFT;
            _loc_1.leading = 0;
            _loc_1.font = "微软雅黑";
            this._textField.defaultTextFormat = _loc_1;
            addChild(this._textField);
            return;
        }// end function

        public function set text(param1:String) : void
        {
            this._textField.text = param1;
            this.update();
            return;
        }// end function

        public function set htmlText(param1:String) : void
        {
            this._textField.htmlText = param1;
            this.update();
            return;
        }// end function

        private function update() : void
        {
            this._bg.width = this._textField.width + 2 * this.GAP;
            this._bg.height = this._textField.height + 2 * this.GAP;
            return;
        }// end function

    }
}
