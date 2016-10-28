package com.qiyi.player.wonder.plugins.continueplay.view.parts
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import common.*;
    import continueplay.*;
    import flash.text.*;

    public class ContinueLoading extends LoadingTip
    {
        private var _loadingTF:TextField;
        private var _loadingMC:CommonLoadingMC;
        private static const TEXT_LOADING:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_LOADING_DES);

        public function ContinueLoading()
        {
            this._loadingMC = new CommonLoadingMC();
            this._loadingMC.x = 6;
            this._loadingMC.y = 6;
            var _loc_1:int = 15;
            this._loadingMC.height = 15;
            this._loadingMC.width = _loc_1;
            addChild(this._loadingMC);
            this._loadingTF = FastCreator.createLabel(TEXT_LOADING, 16777215);
            this._loadingTF.x = 24;
            this._loadingTF.y = 2;
            addChild(this._loadingTF);
            return;
        }// end function

    }
}
