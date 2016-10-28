package com.qiyi.player.wonder.plugins.hint
{

    public class HintDef extends Object
    {
        private static var statusBegin:int = 0;
        public static const STATUS_BEGIN:int = statusBegin;
        public static const STATUS_VIEW_INIT:int = statusBegin;
        public static const STATUS_OPEN:int = statusBegin + 1;
        public static const STATUS_PLAYING:int = statusBegin + 1;
        public static const STATUS_PAUSED:int = statusBegin + 1;
        public static const STATUS_END:int = statusBegin + 1;
        public static const STATUS_COUNT:int = STATUS_END - STATUS_BEGIN;
        public static const NOTIFIC_ADD_STATUS:String = "HintAddStatus";
        public static const NOTIFIC_REMOVE_STATUS:String = "HintRemoveStatus";
        public static const NOTIFIC_HINT_CHECK:String = "HintCheck";
        public static const NOTIFIC_HINT_OPEN_CLOSE:String = "HintOpenClose";
        public static const NOTIFIC_HINT_PAUSE:String = "HintPause";
        public static const NOTIFIC_HINT_RESUME:String = "HintResume";

        public function HintDef()
        {
            return;
        }// end function

    }
}
