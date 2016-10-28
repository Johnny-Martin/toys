package com.qiyi.player.wonder.plugins.feedback.view.parts.drmcopyright
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import feedback.*;
    import flash.display.*;
    import flash.text.*;

    public class DRMCopyrightLimited extends Sprite implements IDestroy
    {
        private var _titleTF:TextField;
        private var _qrcode:Bitmap;
        private var _downLoadTF:TextField;
        private var _linkTF:TextField;
        private var _englistTF:TextField;
        private var _height:Number = 0;
        private var _errorcode:String = "";
        private var _errocodeTF:TextField;
        private static const TEXT_DEFAULT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.DRM_COPYRIGHT_LIMITED);
        private static const TEXT_DOWNLOAD_BTN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.DRM_COPYRIGHT_LIMITED1);
        private static const TEXT_LINK:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES5);
        private static const TEXT_ENGLISH_PLATFORM_LIMIT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES7);
        private static const STR_ERROR_CODE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.ERROR_CODE_DEFAULT_DES);

        public function DRMCopyrightLimited(param1:String)
        {
            this._errorcode = param1;
            this._titleTF = FastCreator.createLabel(TEXT_DEFAULT, 16777215, 18);
            addChild(this._titleTF);
            this._height = this._height + (this._titleTF.height + 20);
            this._qrcode = new Bitmap(new QRCode() as BitmapData);
            addChild(this._qrcode);
            this._height = this._height + (this._qrcode.height + 20);
            this._downLoadTF = FastCreator.createLabel(TEXT_DOWNLOAD_BTN, 16777215, 16);
            var _loc_2:Boolean = false;
            this._downLoadTF.mouseEnabled = false;
            this._downLoadTF.selectable = _loc_2;
            addChild(this._downLoadTF);
            this._height = this._height + (this._downLoadTF.height + 5);
            this._linkTF = FastCreator.createLabel(TEXT_LINK, 10066329);
            addChild(this._linkTF);
            this._height = this._height + (this._linkTF.height + 5);
            this._englistTF = FastCreator.createLabel(TEXT_ENGLISH_PLATFORM_LIMIT, 10066329);
            addChild(this._englistTF);
            this._height = this._height + this._englistTF.height;
            this._errocodeTF = FastCreator.createLabel(STR_ERROR_CODE + this._errorcode, 16777215, 14);
            addChild(this._errocodeTF);
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function get linkTextField() : TextField
        {
            return this._linkTF;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            this._errocodeTF.x = param1 - this._errocodeTF.width - 55;
            this._errocodeTF.y = param2 - 45;
            this._titleTF.x = (param1 - this._titleTF.width) * 0.5;
            this._qrcode.x = (param1 - this._qrcode.width) * 0.5;
            this._downLoadTF.x = (param1 - this._downLoadTF.width) * 0.5;
            this._linkTF.x = (param1 - this._linkTF.width) * 0.5;
            this._englistTF.x = this._linkTF.x;
            this._titleTF.y = (param2 - this._height) * 0.5 + 5;
            this._qrcode.y = this._titleTF.y + this._titleTF.height + 20;
            this._downLoadTF.y = this._qrcode.y + this._qrcode.height + 5;
            this._linkTF.y = this._downLoadTF.y + this._downLoadTF.height + 20;
            this._englistTF.y = this._linkTF.y + this._linkTF.height + 5;
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:DisplayObject = null;
            while (numChildren > 0)
            {
                
                _loc_1 = getChildAt(0);
                if (_loc_1.parent)
                {
                    removeChild(_loc_1);
                }
                _loc_1 = null;
            }
            return;
        }// end function

    }
}
