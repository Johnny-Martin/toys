package com.qiyi.player.core.video.events
{
    import flash.events.*;

    public class DispatcherEvent extends Event
    {
        private var _data:Object;
        public static const Evt_Success:String = "success";
        public static const Evt_Failed:String = "failed";

        public function DispatcherEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
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
