package com.qiyi.player.wonder.plugins.setting.view.parts
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class SoundTrackLanguage extends Sprite
    {
        private var _label:TextField;
        private var _subtitlesTypeVector:Vector.<SelectTextField>;
        private var _soundTrackLangVector:Vector.<IAudioTrackInfo>;
        private var _currSoundTrackLang:EnumItem;

        public function SoundTrackLanguage()
        {
            this.mouseEnabled = false;
            this._soundTrackLangVector = new Vector.<IAudioTrackInfo>;
            this._subtitlesTypeVector = new Vector.<SelectTextField>;
            this._label = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_SOUND_DES1) + " ", 13421772, 14);
            addChild(this._label);
            return;
        }// end function

        public function get soundTrackLangVector() : Vector.<IAudioTrackInfo>
        {
            return this._soundTrackLangVector;
        }// end function

        public function setSoundTrackLang(param1:IAudioTrackInfo, param2:Vector.<IAudioTrackInfo>) : void
        {
            var _loc_4:SelectTextField = null;
            var _loc_7:SelectTextField = null;
            this._soundTrackLangVector = param2;
            if (!this._soundTrackLangVector)
            {
                return;
            }
            while (this._subtitlesTypeVector.length > 0)
            {
                
                _loc_7 = this._subtitlesTypeVector.shift();
                removeChild(_loc_7);
                _loc_7.removeEventListener(MouseEvent.CLICK, this.onItemClick);
                _loc_7.destroy();
                _loc_7 = null;
            }
            var _loc_3:* = this._label.width + this._label.x + 10;
            var _loc_5:Boolean = false;
            var _loc_6:uint = 0;
            while (_loc_6 < this._soundTrackLangVector.length)
            {
                
                _loc_4 = new SelectTextField(ChineseNameOfLangAudioDef.getAudioName(this._soundTrackLangVector[_loc_6].type), 14);
                _loc_4.x = _loc_3;
                _loc_4.y = this._label.y - _loc_4.height + 24;
                _loc_3 = _loc_3 + _loc_4.width + 10;
                _loc_4.data = this._soundTrackLangVector[_loc_6].type;
                this._subtitlesTypeVector.push(_loc_4);
                addChild(_loc_4);
                if (param1.type == this._soundTrackLangVector[_loc_6].type)
                {
                    var _loc_8:Boolean = true;
                    _loc_4.isSelected = true;
                    _loc_5 = _loc_8;
                    this._currSoundTrackLang = this._soundTrackLangVector[_loc_6].type;
                }
                _loc_4.addEventListener(MouseEvent.CLICK, this.onItemClick);
                _loc_6 = _loc_6 + 1;
            }
            if (!_loc_5 && this._subtitlesTypeVector.length > 0)
            {
                this._subtitlesTypeVector[0].isSelected = true;
                this._currSoundTrackLang = this._subtitlesTypeVector[0].data as EnumItem;
            }
            return;
        }// end function

        private function onItemClick(event:MouseEvent) : void
        {
            var _loc_3:SelectTextField = null;
            var _loc_2:* = event.currentTarget as SelectTextField;
            for each (_loc_3 in this._subtitlesTypeVector)
            {
                
                _loc_3.isSelected = false;
                if (_loc_3 == _loc_2)
                {
                    _loc_3.isSelected = true;
                }
            }
            dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged, _loc_2.data));
            return;
        }// end function

        public function close() : void
        {
            dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged, this._currSoundTrackLang));
            return;
        }// end function

        public function resetClick() : void
        {
            var _loc_1:uint = 0;
            while (_loc_1 < this._subtitlesTypeVector.length)
            {
                
                this._subtitlesTypeVector[_loc_1].isSelected = false;
                if (_loc_1 == SettingDef.DEFAULT_SOUND_TRACK_INDEX)
                {
                    this._subtitlesTypeVector[_loc_1].isSelected = true;
                    dispatchEvent(new SettingEvent(SettingEvent.Evt_AudioTrackChanged, this._subtitlesTypeVector[_loc_1].data));
                }
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

    }
}
