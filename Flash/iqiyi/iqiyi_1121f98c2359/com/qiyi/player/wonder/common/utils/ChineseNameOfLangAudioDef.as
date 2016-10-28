package com.qiyi.player.wonder.common.utils
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.common.localization.*;

    public class ChineseNameOfLangAudioDef extends Object
    {

        public function ChineseNameOfLangAudioDef()
        {
            return;
        }// end function

        public static function getLanguageName(param1:EnumItem) : String
        {
            switch(param1)
            {
                case LanguageEnum.CHINESE:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_CHINESE);
                }
                case LanguageEnum.TRADITIONAL:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_TRADITIONAL);
                }
                case LanguageEnum.ENGLISH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_ENGLISH);
                }
                case LanguageEnum.KOREAN:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_KOREAN);
                }
                case LanguageEnum.JAPANESE:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_JAPANESE);
                }
                case LanguageEnum.FRENCH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_FRENCH);
                }
                case LanguageEnum.RUSSIAN:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_RUSSIAN);
                }
                case LanguageEnum.NOTHING:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_NOTHING);
                }
                case LanguageEnum.CHINESE_AND_ENGLISH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_CH_AND_EN);
                }
                case LanguageEnum.CHINESE_AND_JAPANESE:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_CH_AND_JA);
                }
                case LanguageEnum.CHINESE_AND_FRENCH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_CH_AND_FR);
                }
                case LanguageEnum.CHINESE_AND_RUSSIAN:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_CH_AND_RU);
                }
                case LanguageEnum.CHINESE_AND_KOREAN:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_CH_AND_KO);
                }
                case LanguageEnum.TW_AND_ENGLISH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_TW_AND_EN);
                }
                case LanguageEnum.TW_AND_KOREAN:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_TW_AND_KO);
                }
                case LanguageEnum.TW_AND_JAPANESE:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_TW_AND_JA);
                }
                case LanguageEnum.TW_AND_FRENCH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_TW_AND_FR);
                }
                case LanguageEnum.TW_AND_RUSSIAN:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.LANGUAGE_NAME_TW_AND_RU);
                }
                default:
                {
                    break;
                }
            }
            return "";
        }// end function

        public static function getAudioName(param1:EnumItem) : String
        {
            switch(param1)
            {
                case AudioTrackEnum.CHINESE:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.AUDIO_NAME_CHINESE);
                }
                case AudioTrackEnum.CANTONESE:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.AUDIO_NAME_CANTONESE);
                }
                case AudioTrackEnum.ENGLISH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.AUDIO_NAME_ENGLISH);
                }
                case AudioTrackEnum.FRENCH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.AUDIO_NAME_FRENCH);
                }
                case AudioTrackEnum.JAPANESE:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.AUDIO_NAME_JAPANESE);
                }
                case AudioTrackEnum.KOREAN:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.AUDIO_NAME_KOREAN);
                }
                case AudioTrackEnum.RUSSIAN:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.AUDIO_NAME_RUSSIAN);
                }
                case AudioTrackEnum.NONE:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.AUDIO_NAME_NONE);
                }
                default:
                {
                    break;
                }
            }
            return "";
        }// end function

        public static function getDefinitionName(param1:EnumItem) : String
        {
            switch(param1)
            {
                case DefinitionEnum.NONE:
                {
                    break;
                }
                case DefinitionEnum.LIMIT:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.DEFINITION_NAME_LIMIT);
                }
                case DefinitionEnum.STANDARD:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.DEFINITION_NAME_STANDARD);
                }
                case DefinitionEnum.HIGH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.DEFINITION_NAME_HIGH);
                }
                case DefinitionEnum.SUPER:
                case DefinitionEnum.SUPER_HIGH:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.DEFINITION_NAME_SUPER_HIGH);
                }
                case DefinitionEnum.FULL_HD:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.DEFINITION_NAME_FULL_HD);
                }
                case DefinitionEnum.FOUR_K:
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.DEFINITION_NAME_FOUR_K);
                }
                default:
                {
                    break;
                }
            }
            return "";
        }// end function

    }
}
