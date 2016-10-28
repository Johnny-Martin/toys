package com.qiyi.player.core.player.def
{

    public class StatusEnum extends Object
    {
        private static var begin:int = 0;
        public static const BEGIN:int = begin;
        public static const IDLE:int = begin;
        public static const ALREADY_LOAD_MOVIE:int = begin + 1;
        public static const ALREADY_READY:int = begin + 1;
        public static const ALREADY_START_LOAD:int = begin + 1;
        public static const ALREADY_PLAY:int = begin + 1;
        public static const PLAYING:int = begin + 1;
        public static const PAUSED:int = begin + 1;
        public static const SEEKING:int = begin + 1;
        public static const WAITING:int = begin + 1;
        public static const STOPPING:int = begin + 1;
        public static const STOPED:int = begin + 1;
        public static const FAILED:int = begin + 1;
        public static const WAITING_START_LOAD:int = begin + 1;
        public static const WAITING_PLAY:int = begin + 1;
        public static const META_START_LOAD_CALLED:int = begin + 1;
        public static const HISTORY_START_LOAD_CALLED:int = begin + 1;
        public static const P2P_CORE_START_LOAD_CALLED:int = begin + 1;
        public static const END:int = begin + 1;
        public static const COUNT:int = END - BEGIN;

        public function StatusEnum()
        {
            return;
        }// end function

    }
}
