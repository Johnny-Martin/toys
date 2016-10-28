package com.qiyi.player.core.history.events
{
    import flash.events.*;

    public class HistoryEvent extends Event
    {
        private var _data:Object;
        public static const Evt_Ready:String = "ready";

        public function HistoryEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this._data = param2;
            return;
        }// end function

        public function get data() : Object
        {
            return this._data;
        }// end function

    }
}
