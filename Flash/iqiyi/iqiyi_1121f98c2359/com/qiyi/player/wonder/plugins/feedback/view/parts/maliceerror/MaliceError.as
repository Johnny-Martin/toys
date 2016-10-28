package com.qiyi.player.wonder.plugins.feedback.view.parts.maliceerror
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import flash.display.*;
    import flash.text.*;

    public class MaliceError extends Sprite implements IDestroy
    {
        private var _errorText:TextField;
        private var _errorcode:String = "";
        private var _errocodeTF:TextField;
        private static const TF_ERROR_TEXT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.MALICE_ERROR_DES1);
        private static const STR_ERROR_CODE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.ERROR_CODE_DEFAULT_DES);

        public function MaliceError(param1:String)
        {
            this._errorcode = param1;
            this._errorText = FastCreator.createLabel(TF_ERROR_TEXT, 16777215, 16);
            addChild(this._errorText);
            this._errocodeTF = FastCreator.createLabel(STR_ERROR_CODE + this._errorcode, 16777215, 14);
            addChild(this._errocodeTF);
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0, 0, param1, param2);
            graphics.endFill();
            this._errocodeTF.x = param1 - this._errocodeTF.width - 45;
            this._errocodeTF.y = param2 - 45;
            this._errorText.x = (param1 - this._errorText.width) / 2;
            this._errorText.y = (param2 - this._errorText.height) / 2;
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
