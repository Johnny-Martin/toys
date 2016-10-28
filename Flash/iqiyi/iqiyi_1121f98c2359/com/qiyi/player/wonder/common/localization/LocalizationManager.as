package com.qiyi.player.wonder.common.localization
{
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.common.localization.lang.*;

    public class LocalizationManager extends Object
    {
        private var _langType:String = "CH";
        private var _baseLang:BaseLocalization;
        private var _isInited:Boolean = false;
        private static var _instance:LocalizationManager;

        public function LocalizationManager()
        {
            return;
        }// end function

        public function init(param1:String) : void
        {
            if (this._isInited)
            {
                return;
            }
            this._isInited = true;
            this.langType = param1;
            return;
        }// end function

        public function get langType() : String
        {
            return this._langType;
        }// end function

        public function set langType(param1:String) : void
        {
            this._langType = param1;
            switch(param1)
            {
                case LocalizaEnum.LOCALIZE_CN_S.name:
                case LocalizaEnum.LOCALIZE_TW_S.name:
                {
                    this._baseLang = new LOCALIZATION_CH();
                    break;
                }
                case "EN":
                {
                    break;
                }
                case LocalizaEnum.LOCALIZE_TW_T.name:
                case LocalizaEnum.LOCALIZE_CN_T.name:
                {
                    this._baseLang = new LOCALIZATION_TW();
                    break;
                }
                default:
                {
                    this._baseLang = new LOCALIZATION_CH();
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function getLanguageStringByName(param1:String) : String
        {
            if (this._baseLang)
            {
                this._langType = this._langType;
            }
            return this._baseLang.LANG_DIC[param1];
        }// end function

        public static function get instance() : LocalizationManager
        {
            var _loc_1:* = _instance || new LocalizationManager;
            _instance = _instance || new LocalizationManager;
            return _loc_1;
        }// end function

    }
}
