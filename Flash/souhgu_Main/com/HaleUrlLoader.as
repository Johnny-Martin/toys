package com
{
    import flash.events.*;
    import flash.net.*;

    public class HaleUrlLoader extends URLLoader
    {

        public function HaleUrlLoader(param1:URLRequest = null)
        {
            addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, this.uncaughtErrorEventHandler);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            super(param1);
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
            trace("urlloader 未知异常: " + event.errorID);
            return;
        }// end function

        private function ioErrorHandler(param1) : void
        {
            trace("urlloader IO异常: " + param1.errorID);
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            trace("urlloader 安全沙箱: " + event.errorID);
            return;
        }// end function

    }
}
