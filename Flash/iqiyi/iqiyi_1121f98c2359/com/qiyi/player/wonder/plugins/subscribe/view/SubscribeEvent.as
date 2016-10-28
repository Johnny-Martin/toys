package com.qiyi.player.wonder.plugins.subscribe.view
{
    import com.qiyi.player.wonder.common.event.*;

    public class SubscribeEvent extends CommonEvent
    {
        public static const Evt_Open:String = "evtSubscribeOpen";
        public static const Evt_Close:String = "evtSubscribeClose";
        public static const Evt_BtnAndIconClick:String = "evtSubscribeBtnAndIconClick";
        public static const Evt_RemovePromptUI:String = "evtRemovePromptUI";
        public static const Evt_ShowComplete:String = "evtShowComplete";

        public function SubscribeEvent(param1:String, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
