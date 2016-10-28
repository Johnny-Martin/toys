package com.qiyi.player.core.model.def
{
    import com.qiyi.player.base.pub.*;

    public class LocalizaEnum extends Object
    {
        public static const ITEMS:Array = [];
        public static const NONE:EnumItem = new EnumItem(0, "none", ITEMS);
        public static const LOCALIZE_TW_T:EnumItem = new EnumItem(1, "tw_t", ITEMS);
        public static const LOCALIZE_TW_S:EnumItem = new EnumItem(2, "tw_s", ITEMS);
        public static const LOCALIZE_CN_T:EnumItem = new EnumItem(3, "cn_t", ITEMS);
        public static const LOCALIZE_CN_S:EnumItem = new EnumItem(4, "cn_s", ITEMS);

        public function LocalizaEnum()
        {
            return;
        }// end function

        public static function isTWLocalize(param1:String) : Boolean
        {
            if (param1 == LocalizaEnum.LOCALIZE_TW_T.name || param1 == LocalizaEnum.LOCALIZE_TW_S.name)
            {
                return true;
            }
            return false;
        }// end function

        public static function isComplexFontLocalize(param1:String) : Boolean
        {
            if (param1 == LocalizaEnum.LOCALIZE_TW_T.name || param1 == LocalizaEnum.LOCALIZE_CN_T.name)
            {
                return true;
            }
            return false;
        }// end function

    }
}
