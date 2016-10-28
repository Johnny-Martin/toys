package com.qiyi.player.wonder.plugins.setting.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.view.parts.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;

    public class SettingView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _subtitlesLangTypeVector:Vector.<Language>;
        private var _soundTrackLangVector:Vector.<IAudioTrackInfo>;
        private var _bg:CommonBg;
        private var _closeBtn:CommonCloseBtn;
        private var _settingTF:TextField;
        private var _subtitles:Subtitles;
        private var _soundTrackLanguage:SoundTrackLanguage;
        private var _setDefaultTF:SelectTextField;
        private var _confirmTF:TextField;
        private var _confirmBtn:CommonGreenBtn;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.SettingView";
        public static const SETTING_STR:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_VIEW_DES1);

        public function SettingView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            type = BodyDef.VIEW_TYPE_POPUP;
            this._status = param2;
            this._userInfoVO = param3;
            this.initUI();
            return;
        }// end function

        public function get soundTrackLanguage() : SoundTrackLanguage
        {
            return this._soundTrackLanguage;
        }// end function

        public function get subtitles() : Subtitles
        {
            return this._subtitles;
        }// end function

        private function initUI() : void
        {
            this._bg = new CommonBg();
            this._bg.width = 400;
            addChild(this._bg);
            this._closeBtn = new CommonCloseBtn();
            this._closeBtn.x = this._bg.width - this._closeBtn.width - 5;
            this._closeBtn.y = 1;
            addChild(this._closeBtn);
            this._settingTF = FastCreator.createLabel(SETTING_STR, 13421772, 14);
            this._settingTF.x = 20;
            this._settingTF.y = 12;
            addChild(this._settingTF);
            this._subtitles = new Subtitles();
            this._subtitles.x = 45;
            addChild(this._subtitles);
            this._soundTrackLanguage = new SoundTrackLanguage();
            this._soundTrackLanguage.x = 45;
            addChild(this._soundTrackLanguage);
            this._setDefaultTF = new SelectTextField(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_VIEW_DES2));
            this._setDefaultTF.x = 170;
            addChild(this._setDefaultTF);
            this._confirmBtn = new CommonGreenBtn();
            this._confirmBtn.x = 260;
            addChild(this._confirmBtn);
            this._confirmTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_VIEW_DES3), 16777215, 14);
            this._confirmTF.x = this._confirmBtn.x + (this._confirmBtn.width - this._confirmTF.textWidth) / 2;
            var _loc_1:Boolean = false;
            this._confirmTF.mouseEnabled = false;
            this._confirmTF.selectable = _loc_1;
            addChild(this._confirmTF);
            this._setDefaultTF.addEventListener(MouseEvent.CLICK, this.onSetDefaultTFClick);
            this._confirmBtn.addEventListener(MouseEvent.CLICK, this.onConfirmBtnClick);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            return;
        }// end function

        public function setSubtitlesLangType(param1:EnumItem, param2:Vector.<Language>) : void
        {
            this._subtitlesLangTypeVector = param2;
            if (this._subtitles && this._subtitlesLangTypeVector)
            {
                this._subtitles.visible = true;
                this._subtitles.initSubtitles(param1, param2);
            }
            else
            {
                this._subtitles.visible = false;
            }
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function setSoundTrackLang(param1:IAudioTrackInfo, param2:Vector.<IAudioTrackInfo>) : void
        {
            this._soundTrackLangVector = param2;
            if (this._soundTrackLangVector && this._soundTrackLanguage)
            {
                this._soundTrackLanguage.visible = true;
                this._soundTrackLanguage.setSoundTrackLang(param1, this._soundTrackLangVector);
            }
            else
            {
                this._soundTrackLanguage.visible = false;
            }
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            this._status.addStatus(param1);
            switch(param1)
            {
                case SettingDef.STATUS_OPEN:
                {
                    this.open();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onRemoveStatus(param1:int) : void
        {
            this._status.removeStatus(param1);
            switch(param1)
            {
                case SettingDef.STATUS_OPEN:
                {
                    this.close();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            this.x = (param1 - this._bg.width) / 2;
            this.y = (param2 - height) / 2;
            this._subtitles.y = 50;
            this._soundTrackLanguage.y = this._subtitles.y + this._subtitles.height * int(this._subtitles.visible);
            if (this._subtitles.visible)
            {
                if (this._soundTrackLanguage.visible)
                {
                    this._bg.height = 260;
                    var _loc_3:* = this._soundTrackLanguage.y + 36;
                    this._confirmBtn.y = this._soundTrackLanguage.y + 36;
                    this._setDefaultTF.y = _loc_3;
                }
                else
                {
                    this._bg.height = 215;
                    var _loc_3:* = this._subtitles.y + this._subtitles.height + 10;
                    this._confirmBtn.y = this._subtitles.y + this._subtitles.height + 10;
                    this._setDefaultTF.y = _loc_3;
                }
            }
            else if (this._soundTrackLanguage.visible)
            {
                this._bg.height = 135;
                var _loc_3:* = this._soundTrackLanguage.y + 36;
                this._confirmBtn.y = this._soundTrackLanguage.y + 36;
                this._setDefaultTF.y = _loc_3;
            }
            this._confirmTF.y = this._confirmBtn.y + 2;
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new SettingEvent(SettingEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new SettingEvent(SettingEvent.Evt_Close));
            }
            return;
        }// end function

        override protected function onAddToStage() : void
        {
            super.onAddToStage();
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            alpha = 0;
            TweenLite.to(this, BodyDef.POPUP_TWEEN_TIME / 1000, {alpha:1});
            return;
        }// end function

        override protected function onRemoveFromStage() : void
        {
            super.onRemoveFromStage();
            TweenLite.killTweensOf(this);
            return;
        }// end function

        private function onSetDefaultTFClick(event:MouseEvent) : void
        {
            if (this._soundTrackLanguage.visible)
            {
                this._soundTrackLanguage.resetClick();
            }
            if (this._subtitles.visible)
            {
                this._subtitles.resetClick();
            }
            return;
        }// end function

        private function onConfirmBtnClick(event:MouseEvent) : void
        {
            this.close();
            return;
        }// end function

        private function onCloseBtnClick(event:MouseEvent) : void
        {
            if (this._soundTrackLanguage.visible)
            {
                this._soundTrackLanguage.close();
            }
            if (this._subtitles.visible)
            {
                this._subtitles.close();
            }
            this.close();
            return;
        }// end function

    }
}
