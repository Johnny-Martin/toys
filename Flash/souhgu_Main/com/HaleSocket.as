package com
{
    import flash.events.*;
    import flash.net.*;

    public class HaleSocket extends Socket
    {

        public function HaleSocket(param1:String = null, param2:int = 0)
        {
            addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, this.uncaughtErrorEventHandler);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            super(param1, param2);
            return;
        }// end function

        override public function close() : void
        {
            removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, this.uncaughtErrorEventHandler);
            removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            super.close();
            return;
        }// end function

        private function uncaughtErrorEventHandler(event:UncaughtErrorEvent) : void
        {
            trace("Socket未知异常: " + event.errorID);
            return;
        }// end function

        private function ioErrorHandler(param1) : void
        {
            trace("Socket IO异常: " + param1.errorID);
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            trace("Socket安全沙箱: " + event.errorID);
            return;
        }// end function

    }
}
