package com.qiyi.player.wonder.plugins.recommend.view.part
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import flash.geom.*;

    public class PlayFinishRecommendUtils extends Object
    {
        public static const MAX_COL:uint = 6;
        public static const MAX_ROW:uint = 5;
        public static const GAP_BORDER_LEFT:uint = 20;
        public static const GAP_BORDER_UP:uint = 40;

        public function PlayFinishRecommendUtils()
        {
            return;
        }// end function

        public static function getRecommendItemRectangle(param1:uint) : Rectangle
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 1;
            var _loc_5:uint = 1;
            if (param1 <= MAX_COL - 2)
            {
                if (param1 == 0)
                {
                    _loc_2 = 0;
                    _loc_5 = 1;
                }
                else
                {
                    _loc_2 = RecommendDef.PLAY_FINISH_BIG_ITEM_WIDTH + (param1 - 1) * RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + param1 * RecommendDef.PLAY_FINISH_ITEM_GAP;
                    _loc_5 = param1 + 2;
                }
                _loc_3 = 0;
                _loc_4 = 1;
            }
            else if (param1 <= MAX_COL * 2 - 4)
            {
                _loc_2 = RecommendDef.PLAY_FINISH_BIG_ITEM_WIDTH + (param1 - MAX_COL + 1) * RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + (param1 - MAX_COL + 2) * RecommendDef.PLAY_FINISH_ITEM_GAP;
                _loc_3 = RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP;
                _loc_5 = param1 - (MAX_COL - 4);
                _loc_4 = 2;
            }
            else
            {
                _loc_4 = Math.ceil((param1 + 4) / MAX_COL);
                _loc_2 = (param1 - (MAX_COL * (_loc_4 - 1) - 4) - 1) * (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + RecommendDef.PLAY_FINISH_ITEM_GAP);
                _loc_3 = (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP) * (_loc_4 - 1);
                _loc_5 = param1 - (MAX_COL * (_loc_4 - 1) - 4);
            }
            return new Rectangle(_loc_2, _loc_3, _loc_4, _loc_5);
        }// end function

        public static function getShowPoint(param1:Number, param2:Number) : Point
        {
            var _loc_3:* = Math.floor((param1 - GAP_BORDER_LEFT * 2) / (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + RecommendDef.PLAY_FINISH_ITEM_GAP));
            var _loc_4:* = Math.floor((param2 - GAP_BORDER_UP * 2) / (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP));
            if (_loc_3 < 3 || _loc_4 < 2)
            {
                var _loc_5:int = 0;
                _loc_4 = 0;
                _loc_3 = _loc_5;
            }
            _loc_3 = _loc_3 > MAX_COL ? (MAX_COL) : (_loc_3);
            _loc_4 = _loc_4 > MAX_ROW ? (MAX_ROW) : (_loc_4);
            return new Point(_loc_4, _loc_3);
        }// end function

        public static function getUpdate(param1:String, param2:Number, param3:Number, param4:Number) : String
        {
            switch(param1)
            {
                case "1":
                {
                    return updateDisPlayTime(param2 * 1000);
                }
                case "2":
                {
                    return getUpdateSets(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES1), param2, param3, param4);
                }
                case "3":
                {
                    return getUpdateSets(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES2), param2, param3, param4);
                }
                case "4":
                {
                    return getUpdateSets(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES1), param2, param3, param4);
                }
                case "5":
                {
                    return updateDisPlayTime(param2 * 1000);
                }
                case "6":
                {
                    return updateDisPlayTime(param2 * 1000);
                }
                case "7":
                {
                    return updateDisPlayTime(param2 * 1000);
                }
                case "9":
                {
                    return getUpdateSets(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES2), param2, param3, param4);
                }
                case "10":
                {
                    return updateDisPlayTime(param2 * 1000);
                }
                default:
                {
                    return updateDisPlayTime(param2 * 1000);
                    break;
                }
            }
            return "";
        }// end function

        private static function getUpdateSets(param1:String, param2:Number, param3:Number, param4:Number) : String
        {
            if (param4 == 1)
            {
                return updateDisPlayTime(param2 * 1000);
            }
            if (param3 == 1)
            {
                return param4 + param1 + LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES3);
            }
            return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES4) + param4 + param1;
        }// end function

        private static function updateDisPlayTime(param1:Number) : String
        {
            if (param1 >= 3600000)
            {
                return digits(param1);
            }
            return digits2(param1);
        }// end function

        private static function digits(param1:Number) : String
        {
            var _loc_2:String = "";
            var _loc_3:String = "";
            var _loc_4:* = param1 / 1000;
            if (Math.floor(_loc_4 / 60) < 10)
            {
                _loc_2 = "00:0" + Math.floor(_loc_4 / 60);
            }
            else if (Math.floor(_loc_4 / 60) >= 60)
            {
                _loc_3 = String(Math.floor(_loc_4 / 3600) < 10 ? ("0" + Math.floor(_loc_4 / 3600)) : (Math.floor(_loc_4 / 3600)));
                _loc_2 = _loc_3 + ":" + String(_loc_4 / 60 % 60 < 10 ? ("0" + Math.floor(_loc_4 / 60 % 60)) : (Math.floor(_loc_4 / 60 % 60)));
            }
            else
            {
                _loc_2 = "00:" + Math.floor(_loc_4 / 60);
            }
            var _loc_5:* = String(_loc_4 % 60 < 10 ? ("0" + Math.floor(_loc_4 % 60)) : (Math.floor(_loc_4 % 60)));
            return _loc_2 + ":" + _loc_5;
        }// end function

        private static function digits2(param1:uint) : String
        {
            param1 = param1 / 1000;
            var _loc_2:* = String(Math.floor(param1 / 60) < 10 ? ("0" + Math.floor(param1 / 60)) : (Math.floor(param1 / 60)));
            var _loc_3:* = String(param1 % 60 < 10 ? ("0" + Math.floor(param1 % 60)) : (Math.floor(param1 % 60)));
            return _loc_2 + ":" + _loc_3;
        }// end function

        public static function getChannelChineseName(param1:String) : String
        {
            switch(param1)
            {
                case "1":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES5);
                }
                case "2":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES6);
                }
                case "3":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES7);
                }
                case "4":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES8);
                }
                case "5":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES9);
                }
                case "6":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES10);
                }
                case "7":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES11);
                }
                case "8":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES12);
                }
                case "9":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES13);
                }
                case "10":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES14);
                }
                case "11":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES15);
                }
                case "12":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES16);
                }
                case "13":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES17);
                }
                case "14":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES18);
                }
                case "15":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES19);
                }
                case "16":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES20);
                }
                case "17":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES21);
                }
                case "18":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES22);
                }
                case "20":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES23);
                }
                case "21":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES24);
                }
                case "22":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES25);
                }
                case "23":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES26);
                }
                case "24":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES27);
                }
                case "25":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES28);
                }
                case "26":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES29);
                }
                case "27":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES30);
                }
                case "32":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES31);
                }
                case "33":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES32);
                }
                case "91":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES33);
                }
                case "95":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES34);
                }
                case "97":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES35);
                }
                case "99":
                {
                    return LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_UTILS_DES36);
                }
                default:
                {
                    return "";
                    break;
                }
            }
        }// end function

    }
}
