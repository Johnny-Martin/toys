package test
{
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class CdnHeaderTest extends BaseCtrl
    {
        private var _urlr:URLRequest;
        private var _type:String;
        private var _start_t:Number;

        public function CdnHeaderTest()
        {
            this._urlr = new URLRequest();
            return;
        }// end function

        public function downloadHeader(param1:String) : void
        {
            this._urlr.url = param1 + "&headeronly";
            this._p2psohu.showTestInfo("cht downloadHeader _urlr.url:" + this._urlr.url);
            this._start_t = getTimer();
            var _loc_2:* = new URLLoader();
            _loc_2.addEventListener(Event.COMPLETE, this.completeHandler);
            _loc_2.addEventListener(IOErrorEvent.IO_ERROR, this.ioHandler);
            _loc_2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityHandler);
            _loc_2.load(this._urlr);
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var _loc_2:* = getTimer() - this._start_t;
            this._p2psohu.showTestInfo("downloadCdnheader + type:" + this._type + " use time:" + _loc_2 + " _urlr.url:" + this._urlr.url);
            return;
        }// end function

        private function ioHandler(event:IOErrorEvent) : void
        {
            this._p2psohu.showTestInfo("cdnheader io  type:" + this._type + " errorid:" + event.errorID + " _urlr.url:" + this._urlr.url);
            return;
        }// end function

        private function securityHandler(event:SecurityErrorEvent) : void
        {
            this._p2psohu.showTestInfo("cdnheader security  type:" + this._type + " _urlr.url:" + this._urlr.url);
            return;
        }// end function

        public function set type(param1:String) : void
        {
            this._type = param1;
            return;
        }// end function

    }
}
