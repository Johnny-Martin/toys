package com.qiyi.player.wonder.plugins.scenetile
{
    import com.qiyi.player.wonder.common.localization.*;

    public class SceneTileDef extends Object
    {
        private static var statusBegin:int = 0;
        public static const STATUS_BEGIN:int = statusBegin;
        public static const STATUS_TOOL_VIEW_INIT:int = statusBegin;
        public static const STATUS_BARRAGE_VIEW_INIT:int = statusBegin + 1;
        public static const STATUS_SCORE_VIEW_INIT:int = statusBegin + 1;
        public static const STATUS_TOOL_OPEN:int = statusBegin + 1;
        public static const STATUS_BARRAGE_OPEN:int = statusBegin + 1;
        public static const STATUS_SCORE_OPEN:int = statusBegin + 1;
        public static const STATUS_SCORE_SUCCESS_OPEN:int = statusBegin + 1;
        public static const STATUS_PLAY_BTN_SHOW:int = statusBegin + 1;
        public static const STATUS_PANORAMIC_TOOL_SHOW:int = statusBegin + 1;
        public static const STATUS_BARRAGE_STAR_HEAD_SHOW:int = statusBegin + 1;
        public static const STATUS_END:int = statusBegin + 1;
        public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
        public static const NOTIFIC_ADD_STATUS:String = "sceneTileAddStatus";
        public static const NOTIFIC_REMOVE_STATUS:String = "sceneTileRemoveStatus";
        public static const NOTIFIC_OPEN_CLOSE_SCORE:String = "sceneTileOpenCloseScore";
        public static const NOTIFIC_RECEIVE_BARRAGE_INFO:String = "sceneTileReceiveBarrageInfo";
        public static const NOTIFIC_STAR_HEAD_SHOW:String = "sceneTileStarHeadShow";
        public static const NOTIFIC_REQUEST_BARRAGE_CONFIG:String = "sceneTileRequestBarrageConfig";
        public static const SCORE_PLAYING_DURATION:Number = 0.1;
        public static const SCORE_PLAYING_POINT:Number = 0.9;
        public static const SCORE_MAX_LEVEL:uint = 5;
        public static const SCORE_LEVEL_DESCRIBE:Array = [LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_PANEL_DES4), LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_PANEL_DES5), LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_PANEL_DES6), LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_PANEL_DES7), LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_PANEL_DES8)];
        public static const SCORE_SHOW_TIME:uint = 30;
        public static const BARRAGE_BUFFER_BARRAGEINFO_NUM:uint = 100;
        public static const BARRAGE_REQUEST_INTERVAL_TIME:int = 300000;
        public static const BARRAGE_MAX_SHOW_ROW_NUM:uint = 6;
        public static const BARRAGE_STAR_ROW_NUM:uint = 2;
        public static const BARRAGE_MIN_SHOW_ROW_NUM:uint = 3;
        public static const BARRAGE_POSITION_ROW:Array = [[1, 1, 1], [1, 2, 1], [2, 1, 2], [2, 2, 2]];
        public static const BARRAGE_ROW_SPEED:Array = [3, 3, 3, 3, 3, 3];
        public static const BARRAGE_IN_FLY_SPEED:uint = 100;
        public static const BARRAGE_OUT_FLY_SPEED:uint = 30;
        public static const BARRAGE_ITEM_GAP:uint = 100;
        public static const BARRAGE_DELETE_PERCENT:uint = 30;
        public static const BARRAGE_DEFAULT_FONT_SIZE:uint = 30;
        public static const BARRAGE_DEFAULT_FONT_COLOR:String = "ffffff";
        public static const BARRAGE_DEFAULT_ALPHA:uint = 90;
        public static const BARRAGE_FONT_SIZE_ARRAY:Array = [18, 21, 24];
        public static const BARRAGE_FONT_SIZE_SIGN_ARRAY:Array = [10, 20, 30];
        public static const BARRAGE_POSITION_NONE:uint = 0;
        public static const BARRAGE_POSITION_UP:uint = 1;
        public static const BARRAGE_POSITION_CENTRE:uint = 2;
        public static const BARRAGE_POSITION_DOWN:uint = 3;
        public static const BARRAGE_CONTENT_TYPE_NONE:uint = 0;
        public static const BARRAGE_CONTENT_TYPE_PERSON:uint = 1;
        public static const BARRAGE_CONTENT_TYPE_STAR:uint = 2;
        public static const BARRAGE_CONTENT_TYPE_RESTAR:uint = 3;
        public static const BARRAGE_BG_TYPE_NONE:uint = 100;
        public static const BARRAGE_BG_0:uint = 0;
        public static const BARRAGE_BG_1:uint = 1;
        public static const BARRAGE_BG_2:uint = 2;
        public static const BARRAGE_BG_3:uint = 3;
        public static const BARRAGE_BG_4:uint = 4;
        public static const BARRAGE_BG_5:uint = 5;
        public static const BARRAGE_SOURCE_JS:String = "barrageSourceJS";
        public static const BARRAGE_SOURCE_SCOKET:String = "barrageSourceSCOKET";
        public static const BARRAGE_SOURCE_HTTP:String = "barrageSourceHTTP";

        public function SceneTileDef()
        {
            return;
        }// end function

    }
}
