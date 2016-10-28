package com.qiyi.player.wonder.plugins.hint.view
{
    import com.qiyi.player.wonder.common.event.*;

    public class HintEvent extends CommonEvent
    {
        public static const Evt_Open:String = "evtHintOpen";
        public static const Evt_Close:String = "evtHintClose";
        public static const Evt_Status_Playing:String = "Playing";
        public static const Evt_Status_Paused:String = "Paused";
        public static const Evt_Status_Stop:String = "Stop";

        public function HintEvent(param1:String, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
