package com.qiyi.player.wonder.plugins.feedback.view.parts.privatevideo
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.feedback.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import offinewatch.*;

    public class PrivateVideo extends Sprite implements IDestroy
    {
        private var _sprPWContainer:Sprite;
        private var _sprCDContainer:Sprite;
        private var _tfTitle:TextField;
        private var _tfPassWord:TextField;
        private var _shapePassWordBg:Shape;
        private var _inputPassWord:TextField;
        private var _tfPassWordError:TextField;
        private var _confirmBtn:OffineDownloadlBtn;
        private var _contirmTF:TextField;
        private var _tfCountdown:TextField;
        private var _timeCountdown:Timer;
        private var _errorCode:uint = 0;
        private var _hasNestVideo:Boolean = false;
        private var _isOpenedPrivateVideo:Boolean = false;
        private var _countdownTime:uint = 15;
        private var _errocodeTF:TextField;
        private static const STR_TITLE_PRIVATE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES1);
        private static const STR_TITLE_PASSWORD:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES2);
        private static const STR_TITLE_PW_EXITFULL:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES3);
        private static const STR_TITLE_PASSWORD_ERROR:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES4);
        private static const STR_COUNTDOWN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES5);
        private static const STR_CONFIRM:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES6);
        private static const STR_ERROR_CODE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.ERROR_CODE_DEFAULT_DES);

        public function PrivateVideo(param1:uint, param2:Boolean, param3:Boolean)
        {
            this._errorCode = param1;
            this._hasNestVideo = param2;
            this._isOpenedPrivateVideo = param3;
            this.init();
            return;
        }// end function

        private function init() : void
        {
            this._tfTitle = FastCreator.createLabel(this._errorCode == 708 ? (STR_TITLE_PRIVATE) : (GlobalStage.isFullScreen() ? (STR_TITLE_PW_EXITFULL) : (STR_TITLE_PASSWORD)), 16777215, 16);
            addChild(this._tfTitle);
            this.createPassWordPart();
            this.creatNestVideoPart();
            this._errocodeTF = FastCreator.createLabel(STR_ERROR_CODE + this._errorCode, 16777215, 14);
            addChild(this._errocodeTF);
            return;
        }// end function

        private function createPassWordPart() : void
        {
            if (this._errorCode == 709)
            {
                this._sprPWContainer = new Sprite();
                this._sprPWContainer.graphics.beginFill(16711680, 0);
                this._sprPWContainer.graphics.drawRect(0, 0, 300, 80);
                this._sprPWContainer.graphics.endFill();
                addChild(this._sprPWContainer);
                this._tfPassWord = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES7), 16777215, 16, TextFieldAutoSize.LEFT);
                this._tfPassWord.x = (280 - this._tfPassWord.width - 200) * 0.5;
                this._sprPWContainer.addChild(this._tfPassWord);
                this._shapePassWordBg = new Shape();
                this._shapePassWordBg.graphics.beginFill(16777215);
                this._shapePassWordBg.graphics.drawRoundRect(0, 0, 200, 32, 10);
                this._shapePassWordBg.graphics.endFill();
                this._shapePassWordBg.x = this._tfPassWord.x + this._tfPassWord.width + 10;
                this._sprPWContainer.addChild(this._shapePassWordBg);
                this._inputPassWord = FastCreator.createInput("123", 0, 16);
                this._inputPassWord.height = 32;
                this._inputPassWord.width = 190;
                this._inputPassWord.x = this._shapePassWordBg.x;
                this._inputPassWord.y = this._shapePassWordBg.y + 2;
                this._inputPassWord.text = "";
                this._inputPassWord.displayAsPassword = true;
                this._sprPWContainer.addChild(this._inputPassWord);
                if (this._isOpenedPrivateVideo)
                {
                    this._tfPassWordError = FastCreator.createLabel(STR_TITLE_PASSWORD_ERROR, 16716340, 12);
                    this._tfPassWordError.y = this._tfPassWord.y + this._tfPassWord.height + 15;
                    this._tfPassWordError.x = this._shapePassWordBg.x;
                    this._sprPWContainer.addChild(this._tfPassWordError);
                }
                this._confirmBtn = new OffineDownloadlBtn();
                this._confirmBtn.x = (this._sprPWContainer.width - this._confirmBtn.width) * 0.5;
                this._confirmBtn.y = this._shapePassWordBg.y + this._shapePassWordBg.height + 5 + (this._tfPassWordError ? (this._tfPassWordError.height + 5) : (0));
                this._sprPWContainer.addChild(this._confirmBtn);
                this._contirmTF = FastCreator.createLabel(STR_CONFIRM, 16777215, 14);
                this._contirmTF.x = this._confirmBtn.x + (this._confirmBtn.width - this._contirmTF.width) * 0.5;
                this._contirmTF.y = this._confirmBtn.y + (this._confirmBtn.height - this._contirmTF.height) * 0.5;
                this._contirmTF.mouseEnabled = false;
                this._sprPWContainer.addChild(this._contirmTF);
                this._inputPassWord.addEventListener(FocusEvent.FOCUS_IN, this.onInputPassWord);
                this._confirmBtn.addEventListener(MouseEvent.CLICK, this.onConfirmBtnClick);
            }
            return;
        }// end function

        private function creatNestVideoPart() : void
        {
            if (this._hasNestVideo)
            {
                this._sprCDContainer = new Sprite();
                this._sprCDContainer.graphics.beginFill(65280, 0);
                this._sprCDContainer.graphics.drawRect(0, 0, 300, 80);
                this._sprCDContainer.graphics.endFill();
                addChild(this._sprCDContainer);
                this._tfCountdown = FastCreator.createLabel(FeedbackDef.FEEDBACK_PRIVATEVIDEO_COUNTDOWN + LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES8) + STR_COUNTDOWN, 16777215, 16, TextFieldAutoSize.CENTER);
                this._tfCountdown.x = (this._sprCDContainer.width - this._tfCountdown.width) * 0.5;
                this._sprCDContainer.addChild(this._tfCountdown);
                this._tfCountdown.addEventListener(TextEvent.LINK, this.onNestVideoLink);
                this._timeCountdown = new Timer(1000, FeedbackDef.FEEDBACK_PRIVATEVIDEO_COUNTDOWN);
                this._timeCountdown.addEventListener(TimerEvent.TIMER, this.onCountdownTime);
                this._timeCountdown.addEventListener(TimerEvent.TIMER_COMPLETE, this.onCountdownComplete);
                this._timeCountdown.start();
            }
            return;
        }// end function

        private function onCountdownTime(event:TimerEvent) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this._countdownTime - 1;
            _loc_2._countdownTime = _loc_3;
            this._tfCountdown.htmlText = this._countdownTime + LocalizationManager.instance.getLanguageStringByName(LocalizationDef.PRIVATE_VIDEO_DES8) + STR_COUNTDOWN;
            return;
        }// end function

        private function onCountdownComplete(event:TimerEvent) : void
        {
            this._timeCountdown.stop();
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_PrivateNestVideo));
            return;
        }// end function

        private function onNestVideoLink(event:TextEvent) : void
        {
            this._tfCountdown.removeEventListener(TextEvent.LINK, this.onNestVideoLink);
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_PrivateNestVideo));
            return;
        }// end function

        private function onConfirmBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_PrivateConfirmBtnClick, this._inputPassWord.text));
            return;
        }// end function

        private function onInputPassWord(event:FocusEvent) : void
        {
            if (this._sprCDContainer && this._tfCountdown)
            {
                this._tfCountdown.htmlText = STR_COUNTDOWN;
            }
            if (this._timeCountdown)
            {
                this._timeCountdown.stop();
                this._timeCountdown.removeEventListener(TimerEvent.TIMER, this.onCountdownTime);
                this._timeCountdown.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onCountdownComplete);
            }
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0, 0, param1, param2);
            graphics.endFill();
            this._tfTitle.text = this._errorCode == 708 ? (STR_TITLE_PRIVATE) : (GlobalStage.isFullScreen() ? (STR_TITLE_PW_EXITFULL) : (STR_TITLE_PASSWORD));
            this._tfTitle.x = (param1 - this._tfTitle.width) * 0.5;
            this._tfTitle.y = (param2 - this._tfTitle.height - (this._sprPWContainer ? (this._sprPWContainer.height) : (0)) - (this._sprCDContainer ? (this._sprCDContainer.height) : (0))) * 0.5;
            if (this._sprPWContainer)
            {
                this._sprPWContainer.x = (param1 - this._sprPWContainer.width) * 0.5;
                this._sprPWContainer.y = this._tfTitle.y + this._tfTitle.height + 15;
            }
            if (this._sprCDContainer)
            {
                this._sprCDContainer.x = (param1 - this._sprCDContainer.width) * 0.5;
                this._sprCDContainer.y = this._tfTitle.y + this._tfTitle.height + 5 + (this._sprPWContainer ? (this._sprPWContainer.height + 15) : (0));
            }
            this._errocodeTF.x = param1 - this._errocodeTF.width - 45;
            this._errocodeTF.y = param2 - 45;
            return;
        }// end function

        public function destroy() : void
        {
            if (this._tfCountdown)
            {
                this._tfCountdown.removeEventListener(TextEvent.LINK, this.onNestVideoLink);
            }
            if (this._confirmBtn)
            {
                this._confirmBtn.removeEventListener(MouseEvent.CLICK, this.onConfirmBtnClick);
            }
            if (this._inputPassWord)
            {
                this._inputPassWord.removeEventListener(FocusEvent.FOCUS_IN, this.onInputPassWord);
            }
            var _loc_1:Object = null;
            if (this._sprPWContainer)
            {
                while (this._sprPWContainer.numChildren > 0)
                {
                    
                    _loc_1 = this._sprPWContainer.removeChildAt(0);
                    _loc_1 = null;
                }
                if (this._sprPWContainer.parent)
                {
                    this._sprPWContainer.parent.removeChild(this._sprPWContainer);
                }
            }
            if (this._sprCDContainer)
            {
                while (this._sprCDContainer.numChildren > 0)
                {
                    
                    _loc_1 = this._sprCDContainer.removeChildAt(0);
                    _loc_1 = null;
                }
                if (this._sprCDContainer.parent)
                {
                    this._sprCDContainer.parent.removeChild(this._sprCDContainer);
                }
            }
            if (this._tfTitle && this._tfTitle.parent)
            {
                this._tfTitle.parent.removeChild(this._tfTitle);
                this._tfTitle = null;
            }
            if (this._timeCountdown)
            {
                this._timeCountdown.stop();
                this._timeCountdown.removeEventListener(TimerEvent.TIMER, this.onCountdownTime);
                this._timeCountdown.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onCountdownComplete);
                this._timeCountdown = null;
            }
            return;
        }// end function

    }
}
