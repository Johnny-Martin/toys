package com
{
    import flash.events.*;
    import flash.net.*;

    public class HoldNetStream extends NetStream
    {

        public function HoldNetStream(param1:NetConnection, param2:String = "connectToFMS")
        {
            addEventListener(IOErrorEvent.IO_ERROR, this.ioError, false, 0, false);
            addEventListener(NetStatusEvent.NET_STATUS, this.netStatus, false, 0, false);
            addEventListener(StatusEvent.STATUS, this.statusError, false, 0, false);
            super(param1, param2);
            return;
        }// end function

        private function ioError(event:IOErrorEvent) : void
        {
            trace(event.errorID);
            return;
        }// end function

        private function netStatus(event:NetStatusEvent) : void
        {
            return;
        }// end function

        private function statusError(event:StatusEvent) : void
        {
            if (event.level == "error")
            {
                trace("报错哈");
            }
            return;
        }// end function

    }
}
