package com.ws.event
{
    import flash.events.*;

    public class PFVEvent extends Event
    {
        public var info:Object = null;
        public static const SVC_STATUS:String = "service_status";

        public function PFVEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null)
        {
            super(param1, param2, param3);
            this.info = param4;
            return;
        }// end function

    }
}
