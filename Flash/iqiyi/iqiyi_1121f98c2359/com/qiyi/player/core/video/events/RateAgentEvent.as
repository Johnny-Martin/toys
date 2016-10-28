package com.qiyi.player.core.video.events
{
    import flash.events.*;

    public class RateAgentEvent extends Event
    {
        private var _data:Object;
        public static const Evt_DefinitionChanged:String = "dc";
        public static const Evt_AudioTrackChanged:String = "atc";
        public static const Evt_AutoAdjustRate:String = "autoAdjustRate";

        public function RateAgentEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
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
