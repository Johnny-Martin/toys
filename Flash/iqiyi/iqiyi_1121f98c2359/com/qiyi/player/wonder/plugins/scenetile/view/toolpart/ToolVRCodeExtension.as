package com.qiyi.player.wonder.plugins.scenetile.view.toolpart
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.ui.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;
    import scenetile.*;

    public class ToolVRCodeExtension extends Sprite implements IDestroy
    {
        private var _vrcodeExtension:VRcodeExtension;
        private var _textfield:TextField;
        private var _isShowVRCode:Boolean = false;
        private static const STR:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCENETILE_STREAMLIMIT_VIEW_DES5);

        public function ToolVRCodeExtension()
        {
            this._vrcodeExtension = new VRcodeExtension();
            addChild(this._vrcodeExtension);
            this._textfield = FastCreator.createLabel(STR, 16777215, 16);
            this._textfield.x = 100;
            this._textfield.y = (this._vrcodeExtension.height - this._textfield.height) * 0.5;
            this._vrcodeExtension._panel.addChild(this._textfield);
            this._vrcodeExtension._panel.visible = false;
            this._textfield.mouseEnabled = false;
            this._vrcodeExtension._btn.addEventListener(MouseEvent.MOUSE_OVER, this.onBtnMouseOver);
            this._vrcodeExtension._btn.addEventListener(MouseEvent.MOUSE_OUT, this.onBtnMouseOut);
            return;
        }// end function

        public function showVRCode() : void
        {
            if (!this._isShowVRCode)
            {
                this._isShowVRCode = true;
                this.onPanelMouseOver();
                TweenLite.delayedCall(5, this.onBtnMouseOut);
            }
            return;
        }// end function

        private function onBtnMouseOver(event:MouseEvent) : void
        {
            this._vrcodeExtension._panel.addEventListener(MouseEvent.MOUSE_OVER, this.onPanelMouseOver);
            this._vrcodeExtension._panel.addEventListener(MouseEvent.MOUSE_OUT, this.onPanelMouseOut);
            if (!this._vrcodeExtension._panel.visible)
            {
                PingBack.getInstance().showActionPing_4_0(PingBackDef.VR_CODE_SHOW);
            }
            this._vrcodeExtension._panel.visible = true;
            TweenLite.killDelayedCallsTo(this.onBtnMouseOut);
            return;
        }// end function

        private function onBtnMouseOut(event:MouseEvent = null) : void
        {
            this._vrcodeExtension._panel.visible = false;
            return;
        }// end function

        private function onPanelMouseOver(event:MouseEvent = null) : void
        {
            this._vrcodeExtension._panel.visible = true;
            return;
        }// end function

        private function onPanelMouseOut(event:MouseEvent) : void
        {
            this._vrcodeExtension._panel.removeEventListener(MouseEvent.MOUSE_OVER, this.onPanelMouseOver);
            this._vrcodeExtension._panel.removeEventListener(MouseEvent.MOUSE_OUT, this.onPanelMouseOut);
            this._vrcodeExtension._panel.visible = false;
            return;
        }// end function

        private function onClosebtnClick(event:MouseEvent) : void
        {
            this._isShowVRCode = true;
            this._vrcodeExtension._panel.visible = false;
            return;
        }// end function

        public function destroy() : void
        {
            this._vrcodeExtension._btn.removeEventListener(MouseEvent.MOUSE_OVER, this.onBtnMouseOver);
            this._vrcodeExtension._btn.removeEventListener(MouseEvent.MOUSE_OUT, this.onBtnMouseOut);
            this._vrcodeExtension._panel.removeEventListener(MouseEvent.MOUSE_OVER, this.onPanelMouseOver);
            this._vrcodeExtension._panel.removeEventListener(MouseEvent.MOUSE_OUT, this.onPanelMouseOut);
            this._textfield = null;
            this._vrcodeExtension = null;
            return;
        }// end function

    }
}
