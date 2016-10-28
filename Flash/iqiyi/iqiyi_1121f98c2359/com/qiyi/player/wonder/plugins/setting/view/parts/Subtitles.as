package com.qiyi.player.wonder.plugins.setting.view.parts
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.impls.subtitle.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class Subtitles extends Sprite
    {
        private var _subtitlesColor:TextField;
        private var _subtitlesColorItem:Vector.<SelectTextField>;
        private var _subtitlesFontSize:TextField;
        private var _subtitlesFontSizeItem:Vector.<SelectTextField>;
        private var _subtitlesLanguage:TextField;
        private var _subtitlesLanguageItem:Vector.<SelectTextField>;
        private var _currColor:uint;
        private var _currFontSize:uint;
        private var _currLanguage:EnumItem;
        private var _subtitlesLanguageData:Vector.<Language>;

        public function Subtitles()
        {
            this.mouseEnabled = false;
            this._subtitlesLanguageItem = new Vector.<SelectTextField>;
            this._subtitlesLanguage = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_SUBTITLES_DES1) + " ", 13421772, 14);
            addChild(this._subtitlesLanguage);
            this._subtitlesColorItem = new Vector.<SelectTextField>;
            this._subtitlesColor = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_SUBTITLES_DES2) + " ", 13421772, 14);
            this._subtitlesColor.y = this._subtitlesLanguage.y + 36;
            addChild(this._subtitlesColor);
            this._subtitlesFontSizeItem = new Vector.<SelectTextField>;
            this._subtitlesFontSize = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_SUBTITLES_DES3) + " ", 13421772, 14);
            this._subtitlesFontSize.y = this._subtitlesColor.y + 36;
            addChild(this._subtitlesFontSize);
            return;
        }// end function

        public function initSubtitles(param1:EnumItem, param2:Vector.<Language>) : void
        {
            this._subtitlesLanguageData = param2;
            if (!this._subtitlesLanguageData)
            {
                return;
            }
            var _loc_3:* = new Language();
            _loc_3.isDefault = false;
            _loc_3.lang = LanguageEnum.NOTHING;
            _loc_3.url = "";
            this._subtitlesLanguageData.push(_loc_3);
            this.initSubtitlesLanguage(param1);
            this.initSubtitlesColor();
            this.initSubtitlesFontSize();
            return;
        }// end function

        private function initSubtitlesColor() : void
        {
            var _loc_2:SelectTextField = null;
            var _loc_5:SelectTextField = null;
            while (this._subtitlesColorItem.length > 0)
            {
                
                _loc_5 = this._subtitlesColorItem.shift();
                removeChild(_loc_5);
                _loc_5.removeEventListener(MouseEvent.CLICK, this.onLanguageItemClick);
                _loc_5.destroy();
                _loc_5 = null;
            }
            var _loc_1:* = this._subtitlesColor.width + this._subtitlesColor.x + 10;
            var _loc_3:Boolean = false;
            var _loc_4:uint = 0;
            while (_loc_4 < SettingDef.FONT_COLOR_LIST.length)
            {
                
                _loc_2 = new SelectTextField(SettingDef.FONT_COLOR_SHOW_LIST[_loc_4], 14);
                _loc_2.x = _loc_1;
                _loc_2.y = this._subtitlesColor.y - _loc_2.height + 24;
                _loc_1 = _loc_1 + _loc_2.width + 10;
                _loc_2.data = SettingDef.FONT_COLOR_LIST[_loc_4];
                this._subtitlesColorItem.push(_loc_2);
                addChild(_loc_2);
                if (Settings.instance.subtitleColor == SettingDef.FONT_COLOR_LIST[_loc_4])
                {
                    var _loc_6:Boolean = true;
                    _loc_2.isSelected = true;
                    _loc_3 = _loc_6;
                    this._currColor = SettingDef.FONT_COLOR_LIST[_loc_4];
                }
                _loc_2.addEventListener(MouseEvent.CLICK, this.onSubtitlesColorClick);
                _loc_4 = _loc_4 + 1;
            }
            if (!_loc_3 && this._subtitlesColorItem.length > 0)
            {
                this._subtitlesColorItem[0].isSelected = true;
                this._currColor = uint(this._subtitlesColorItem[0].data);
            }
            return;
        }// end function

        private function initSubtitlesFontSize() : void
        {
            var _loc_2:SelectTextField = null;
            var _loc_5:SelectTextField = null;
            while (this._subtitlesFontSizeItem.length > 0)
            {
                
                _loc_5 = this._subtitlesFontSizeItem.shift();
                removeChild(_loc_5);
                _loc_5.removeEventListener(MouseEvent.CLICK, this.onLanguageItemClick);
                _loc_5.destroy();
                _loc_5 = null;
            }
            var _loc_1:* = this._subtitlesFontSize.width + this._subtitlesFontSize.x + 10;
            var _loc_3:Boolean = false;
            var _loc_4:int = 0;
            while (_loc_4 < SettingDef.FONT_SIZE_LIST.length)
            {
                
                _loc_2 = new SelectTextField("Aa", SettingDef.FONT_SIZE_LIST[_loc_4]);
                _loc_2.x = _loc_1;
                _loc_2.y = this._subtitlesFontSize.y - (_loc_2.height - 24) + _loc_4 * 2;
                _loc_1 = _loc_1 + _loc_2.width + 10;
                _loc_2.data = SettingDef.FONT_SIZE_LIST[_loc_4];
                this._subtitlesFontSizeItem.push(_loc_2);
                addChild(_loc_2);
                if (Settings.instance.subtitleSize == SettingDef.FONT_SIZE_LIST[_loc_4])
                {
                    var _loc_6:Boolean = true;
                    _loc_2.isSelected = true;
                    _loc_3 = _loc_6;
                    this._currFontSize = SettingDef.FONT_SIZE_LIST[_loc_4];
                }
                _loc_2.addEventListener(MouseEvent.CLICK, this.onFontSizeItemClick);
                _loc_4++;
            }
            if (!_loc_3 && this._subtitlesFontSizeItem.length > 0)
            {
                this._subtitlesFontSizeItem[SettingDef.DEFAULT_SUBTITLE_SIZE_INDEX].isSelected = true;
                this._currFontSize = uint(this._subtitlesFontSizeItem[SettingDef.DEFAULT_SUBTITLE_SIZE_INDEX].data);
            }
            return;
        }// end function

        private function initSubtitlesLanguage(param1:EnumItem) : void
        {
            var _loc_3:SelectTextField = null;
            var _loc_6:SelectTextField = null;
            while (this._subtitlesLanguageItem.length > 0)
            {
                
                _loc_6 = this._subtitlesLanguageItem.shift();
                removeChild(_loc_6);
                _loc_6.removeEventListener(MouseEvent.CLICK, this.onLanguageItemClick);
                _loc_6.destroy();
                _loc_6 = null;
            }
            var _loc_2:* = this._subtitlesLanguage.width + this._subtitlesLanguage.x + 10;
            var _loc_4:Boolean = false;
            var _loc_5:uint = 0;
            while (_loc_5 < this._subtitlesLanguageData.length)
            {
                
                _loc_3 = new SelectTextField(ChineseNameOfLangAudioDef.getLanguageName(this._subtitlesLanguageData[_loc_5].lang), 14);
                _loc_3.x = _loc_2;
                _loc_3.y = this._subtitlesLanguage.y - _loc_3.height + 24;
                _loc_2 = _loc_2 + _loc_3.width + 10;
                _loc_3.data = this._subtitlesLanguageData[_loc_5].lang;
                this._subtitlesLanguageItem.push(_loc_3);
                addChild(_loc_3);
                if (!_loc_4 && this._subtitlesLanguageData[_loc_5].lang == param1)
                {
                    var _loc_7:Boolean = true;
                    _loc_3.isSelected = true;
                    _loc_4 = _loc_7;
                    this._currLanguage = this._subtitlesLanguageData[_loc_5].lang;
                }
                _loc_3.addEventListener(MouseEvent.CLICK, this.onLanguageItemClick);
                _loc_5 = _loc_5 + 1;
            }
            if (!_loc_4 && this._subtitlesLanguageItem.length > 0)
            {
                this._subtitlesLanguageItem[0].isSelected = true;
                this._currLanguage = this._subtitlesLanguageItem[0].data as EnumItem;
            }
            return;
        }// end function

        private function onLanguageItemClick(event:MouseEvent) : void
        {
            var _loc_3:SelectTextField = null;
            var _loc_2:* = event.currentTarget as SelectTextField;
            for each (_loc_3 in this._subtitlesLanguageItem)
            {
                
                _loc_3.isSelected = false;
                if (_loc_3 == _loc_2)
                {
                    _loc_3.isSelected = true;
                }
            }
            dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged, _loc_2.data));
            return;
        }// end function

        private function onSubtitlesColorClick(event:MouseEvent) : void
        {
            var _loc_3:SelectTextField = null;
            var _loc_2:* = event.currentTarget as SelectTextField;
            for each (_loc_3 in this._subtitlesColorItem)
            {
                
                _loc_3.isSelected = false;
                if (_loc_3 == _loc_2)
                {
                    _loc_3.isSelected = true;
                }
            }
            dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged, _loc_2.data));
            return;
        }// end function

        private function onFontSizeItemClick(event:MouseEvent) : void
        {
            var _loc_3:SelectTextField = null;
            var _loc_2:* = event.currentTarget as SelectTextField;
            for each (_loc_3 in this._subtitlesFontSizeItem)
            {
                
                _loc_3.isSelected = false;
                if (_loc_3 == _loc_2)
                {
                    _loc_3.isSelected = true;
                }
            }
            dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged, _loc_2.data));
            return;
        }// end function

        public function close() : void
        {
            dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged, this._currFontSize));
            dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged, this._currColor));
            dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged, this._currLanguage));
            return;
        }// end function

        public function resetClick() : void
        {
            var _loc_1:uint = 0;
            _loc_1 = 0;
            while (_loc_1 < this._subtitlesFontSizeItem.length)
            {
                
                this._subtitlesFontSizeItem[_loc_1].isSelected = false;
                if (_loc_1 == SettingDef.DEFAULT_SUBTITLE_SIZE_INDEX)
                {
                    this._subtitlesFontSizeItem[_loc_1].isSelected = true;
                    dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontSizeChanged, SettingDef.FONT_SIZE_LIST[_loc_1]));
                }
                _loc_1 = _loc_1 + 1;
            }
            _loc_1 = 0;
            while (_loc_1 < this._subtitlesColorItem.length)
            {
                
                this._subtitlesColorItem[_loc_1].isSelected = false;
                if (_loc_1 == SettingDef.DEFAULT_SUBTITLE_COLOR_INDEX)
                {
                    this._subtitlesColorItem[_loc_1].isSelected = true;
                    dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleFontColorChanged, this._subtitlesColorItem[_loc_1].data));
                }
                _loc_1 = _loc_1 + 1;
            }
            _loc_1 = 0;
            while (_loc_1 < this._subtitlesLanguageItem.length)
            {
                
                this._subtitlesLanguageItem[_loc_1].isSelected = false;
                if (_loc_1 == SettingDef.DEFAULT_SUBTITLE_LANG_INDEX)
                {
                    this._subtitlesLanguageItem[_loc_1].isSelected = true;
                    dispatchEvent(new SettingEvent(SettingEvent.Evt_TitleLanguageChanged, this._subtitlesLanguageItem[_loc_1].data));
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

    }
}
