package com.qiyi.player.wonder.plugins.feedback.view.parts.concurrencylimit
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.feedback.view.*;
    import common.*;
    import feedback.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class ConcurrencyLimit extends Sprite implements IDestroy
    {
        private var _limitImg:ConcurrencyLimitImg;
        private var _limitExplain:TextField;
        private var _warnSuggestionHandle:TextField;
        private var _cutoffRule:ConcurrencyLimitCutoffRule;
        private var _changePasswordBtn:CommonGreenBtn;
        private var _changePasswordTF:TextField;
        private var _skipMemberAuthBtn:CommonGreenBtn;
        private var _skipMemberAuthTF:TextField;
        private var _viewDetailsTF:TextField;
        private var _isMemberVideo:Boolean = false;
        private var _errorcode:String = "";
        private var _errocodeTF:TextField;
        private static const STR_LIMIT_EXPLAIN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONCURRENCY_LIMIT_DES1);
        private static const STR_SUGGESTION_HANDLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONCURRENCY_LIMIT_DES2);
        private static const STR_CHANGE_PW_BTN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONCURRENCY_LIMIT_DES3);
        private static const STR_SKIP_MEMBER_BTN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONCURRENCY_LIMIT_DES4);
        private static const STR_CLICK_VIEW_DETAILS:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONCURRENCY_LIMIT_DES5);
        private static const STR_ERROR_CODE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.ERROR_CODE_DEFAULT_DES);

        public function ConcurrencyLimit(param1:Boolean, param2:String)
        {
            this._isMemberVideo = param1;
            this._errorcode = param2;
            this.initPanel();
            return;
        }// end function

        private function initPanel() : void
        {
            this._limitImg = new ConcurrencyLimitImg();
            addChild(this._limitImg);
            this._limitExplain = FastCreator.createLabel(STR_LIMIT_EXPLAIN, 16777215, 14);
            addChild(this._limitExplain);
            this._warnSuggestionHandle = FastCreator.createLabel(STR_SUGGESTION_HANDLE, 16777215, 14);
            addChild(this._warnSuggestionHandle);
            this._cutoffRule = new ConcurrencyLimitCutoffRule();
            addChild(this._cutoffRule);
            this._changePasswordBtn = new CommonGreenBtn();
            this._changePasswordBtn.width = 110;
            this._changePasswordBtn.height = 36;
            addChild(this._changePasswordBtn);
            this._changePasswordTF = FastCreator.createLabel(STR_CHANGE_PW_BTN, 16777215, 16);
            var _loc_1:Boolean = false;
            this._changePasswordTF.mouseEnabled = false;
            this._changePasswordTF.selectable = _loc_1;
            addChild(this._changePasswordTF);
            this._skipMemberAuthBtn = new CommonGreenBtn();
            this._skipMemberAuthBtn.width = 160;
            this._skipMemberAuthBtn.height = 36;
            addChild(this._skipMemberAuthBtn);
            this._skipMemberAuthTF = FastCreator.createLabel(STR_SKIP_MEMBER_BTN, 16777215, 16);
            var _loc_1:Boolean = false;
            this._skipMemberAuthTF.mouseEnabled = false;
            this._skipMemberAuthTF.selectable = _loc_1;
            addChild(this._skipMemberAuthTF);
            if (this._isMemberVideo)
            {
                var _loc_1:Boolean = false;
                this._skipMemberAuthTF.visible = false;
                this._skipMemberAuthBtn.visible = _loc_1;
            }
            this._viewDetailsTF = FastCreator.createLabel(STR_CLICK_VIEW_DETAILS, 6921984, 16, TextFieldAutoSize.LEFT);
            addChild(this._viewDetailsTF);
            this._errocodeTF = FastCreator.createLabel(STR_ERROR_CODE + this._errorcode, 16777215, 14, TextFieldAutoSize.LEFT);
            addChild(this._errocodeTF);
            this._changePasswordBtn.addEventListener(MouseEvent.CLICK, this.onChangePasswordBtnClick);
            this._skipMemberAuthBtn.addEventListener(MouseEvent.CLICK, this.onSkipMemberAuthBtnClick);
            this._viewDetailsTF.addEventListener(TextEvent.LINK, this.onViewDetailsTFClick);
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
            this._limitImg.x = (param1 - this._limitImg.width - this._limitExplain.width) * 0.5;
            this._limitImg.y = param2 * 0.5 - 130;
            this._limitExplain.x = this._limitImg.x + this._limitImg.width + 10;
            this._limitExplain.y = this._limitImg.y + (this._limitImg.height - this._limitExplain.height) * 0.5;
            this._cutoffRule.x = (param1 - this._cutoffRule.width) * 0.5;
            this._cutoffRule.y = this._limitExplain.y + this._limitExplain.height + 25;
            this._warnSuggestionHandle.x = (param1 - this._warnSuggestionHandle.width) * 0.5;
            this._warnSuggestionHandle.y = this._cutoffRule.y + this._cutoffRule.height + 25;
            this._viewDetailsTF.x = 20;
            this._viewDetailsTF.y = param2 - this._viewDetailsTF.height - 15;
            if (this._isMemberVideo)
            {
                this._changePasswordBtn.x = (param1 - this._changePasswordBtn.width) * 0.5;
                this._changePasswordBtn.y = this._warnSuggestionHandle.y + this._warnSuggestionHandle.height + 25;
                this._changePasswordTF.x = this._changePasswordBtn.x + (this._changePasswordBtn.width - this._changePasswordTF.width) * 0.5;
                this._changePasswordTF.y = this._changePasswordBtn.y + (this._changePasswordBtn.height - this._changePasswordTF.height) * 0.5;
            }
            else
            {
                var _loc_3:Boolean = true;
                this._skipMemberAuthTF.visible = true;
                this._skipMemberAuthBtn.visible = _loc_3;
                this._changePasswordBtn.x = (param1 - this._changePasswordBtn.width - this._skipMemberAuthBtn.width - 50) * 0.5;
                this._changePasswordBtn.y = this._warnSuggestionHandle.y + this._warnSuggestionHandle.height + 25;
                this._changePasswordTF.x = this._changePasswordBtn.x + (this._changePasswordBtn.width - this._changePasswordTF.width) * 0.5;
                this._changePasswordTF.y = this._changePasswordBtn.y + (this._changePasswordBtn.height - this._changePasswordTF.height) * 0.5;
                this._skipMemberAuthBtn.x = this._changePasswordBtn.x + this._changePasswordBtn.width + 50;
                this._skipMemberAuthBtn.y = this._changePasswordBtn.y;
                this._skipMemberAuthTF.x = this._skipMemberAuthBtn.x + (this._skipMemberAuthBtn.width - this._skipMemberAuthTF.width) * 0.5;
                this._skipMemberAuthTF.y = this._skipMemberAuthBtn.y + (this._skipMemberAuthBtn.height - this._skipMemberAuthTF.height) * 0.5;
            }
            return;
        }// end function

        private function onChangePasswordBtnClick(event:MouseEvent) : void
        {
            if (this._isMemberVideo)
            {
                PingBack.getInstance().userActionPing_4_0(PingBackDef.CONCUR_LIMIT_VIP_PW_CLICK);
            }
            else
            {
                PingBack.getInstance().userActionPing_4_0(PingBackDef.CONCUR_LIMIT_PASSWORD_CLICK);
            }
            navigateToURL(new URLRequest("http://www.iqiyi.com/u/password"), "_blank");
            return;
        }// end function

        private function onSkipMemberAuthBtnClick(event:MouseEvent) : void
        {
            PingBack.getInstance().userActionPing_4_0(PingBackDef.CONCUR_LIMIT_INITPLAY_CLICK);
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_SkipMemberAuthBtnClick));
            return;
        }// end function

        private function onViewDetailsTFClick(event:TextEvent) : void
        {
            navigateToURL(new URLRequest("http://passport.iqiyi.com/pages/static/vip_banned.action"), "_blank");
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
