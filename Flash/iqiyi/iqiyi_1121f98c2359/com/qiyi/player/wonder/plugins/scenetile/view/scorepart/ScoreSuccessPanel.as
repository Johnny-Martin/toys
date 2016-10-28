package com.qiyi.player.wonder.plugins.scenetile.view.scorepart
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import scenetile.*;

    public class ScoreSuccessPanel extends Sprite
    {
        private var _bg:CommonBg;
        private var _closeBtn:ScoreCloseBtn;
        private var _scoreSuccessIcon:ScoreSuccessIcon;
        private var _tfPanelDescribe:TextField;
        private var _isLogin:Boolean = false;
        private static const STR_PANEL_DES_LOGIN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_SUCCESS_PANEL_DES1);

        public function ScoreSuccessPanel(param1:Boolean)
        {
            this._isLogin = param1;
            this.initPanel();
            return;
        }// end function

        private function initPanel() : void
        {
            this._bg = new CommonBg();
            this._bg.width = 380;
            this._bg.height = 160;
            addChild(this._bg);
            this._scoreSuccessIcon = new ScoreSuccessIcon();
            this._scoreSuccessIcon.x = 126;
            this._scoreSuccessIcon.y = (this._bg.height - this._scoreSuccessIcon.height) * 0.5;
            addChild(this._scoreSuccessIcon);
            this._tfPanelDescribe = FastCreator.createLabel(STR_PANEL_DES_LOGIN, 16777215, 16, TextFieldAutoSize.LEFT);
            this._tfPanelDescribe.x = 159;
            this._tfPanelDescribe.y = (this._bg.height - this._scoreSuccessIcon.height) * 0.5;
            addChild(this._tfPanelDescribe);
            this._closeBtn = new ScoreCloseBtn();
            this._closeBtn.x = this._bg.width - this._closeBtn.width / 2 - 5;
            this._closeBtn.y = (-this._closeBtn.height) / 2 + 5;
            addChild(this._closeBtn);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            return;
        }// end function

        private function onCloseBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreClose));
            return;
        }// end function

        public function destory() : void
        {
            var _loc_1:DisplayObject = null;
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            while (numChildren > 0)
            {
                
                _loc_1 = getChildAt(0);
                if (_loc_1.parent)
                {
                    _loc_1.parent.removeChild(_loc_1);
                }
                _loc_1 = null;
            }
            return;
        }// end function

    }
}
