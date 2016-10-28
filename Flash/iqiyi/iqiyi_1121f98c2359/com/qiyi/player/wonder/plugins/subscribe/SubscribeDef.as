package com.qiyi.player.wonder.plugins.subscribe
{

    public class SubscribeDef extends Object
    {
        private static var statusBegin:int = 0;
        public static const STATUS_BEGIN:int = statusBegin;
        public static const STATUS_VIEW_INIT:int = statusBegin;
        public static const STATUS_OPEN:int = statusBegin + 1;
        public static const STATUS_SHOW_PROMPT:int = statusBegin + 1;
        public static const STATUS_END:int = statusBegin + 1;
        public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
        public static const NOTIFIC_ADD_STATUS:String = "SubscribeAddStatus";
        public static const NOTIFIC_REMOVE_STATUS:String = "SubscribeRemoveStatus";
        public static const PROMPT_PLAYING_DURATION:Number = 0.2;
        public static const PROMPT_PLAYING_POINT:Number = 0.8;
        public static const PROMPT_SHOW_TIME:uint = 6;
        public static const PANEL_TYPE_SUBSCRIBE:uint = 0;
        public static const PANEL_TYPE_REWARD:uint = 1;

        public function SubscribeDef()
        {
            return;
        }// end function

    }
}
