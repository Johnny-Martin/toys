﻿package com.qiyi.player.wonder.plugins.dock.view
{
    import com.qiyi.player.wonder.common.event.*;

    public class DockEvent extends CommonEvent
    {
        public static const Evt_Open:String = "evtDockOpen";
        public static const Evt_Close:String = "evtDockClose";

        public function DockEvent(param1:String, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
