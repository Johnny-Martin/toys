package test
{
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import model.*;

    public class CrcCtrl extends BaseCtrl
    {
        private var i:int = 0;
        public var crcA:Array;
        private var httpstatus:int = 1;

        public function CrcCtrl()
        {
            this.crcA = new Array();
            return;
        }// end function

        public function beginDownloadCrc() : void
        {
            if (this._p2psohu.config.isCrc)
            {
                this.downloadCrc();
            }
            return;
        }// end function

        public function downloadCrc() : void
        {
            var _loc_1:* = this.p2pSohuLib.fileList.fileoA[this.i].cdnfilename;
            var _loc_2:* = _loc_1.split("/");
            var _loc_3:* = (_loc_2[(_loc_2.length - 1)] as String).slice(0, -4);
            var _loc_4:* = new URLRequest();
            new URLRequest().url = "http://61.135.176.223:8080/test/crcrs0/" + String(ByteSize.PICESIZE) + "/" + _loc_3 + ".crc";
            var _loc_5:* = new URLLoader();
            new URLLoader().addEventListener(Event.COMPLETE, this.completeHandler);
            _loc_5.addEventListener(IOErrorEvent.IO_ERROR, this.ioHandler);
            _loc_5.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityHandler);
            _loc_5.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpstatusEvt);
            _loc_5.load(_loc_4);
            return;
        }// end function

        private function httpstatusEvt(event:HTTPStatusEvent) : void
        {
            this.httpstatus = event.status;
            if (this.httpstatus != 200 && this.httpstatus != 0)
            {
                this.serverGC();
            }
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            if (event.target == null)
            {
                this._p2psohu.config.isCrc = false;
                return;
            }
            var _loc_2:* = URLLoader(event.target);
            var _loc_3:* = _loc_2.data as String;
            this._p2psohu.showTestInfo("downloadCrc     loader.data:  i:" + this.i + " str.length:" + _loc_3.length + " httpstatus:" + this.httpstatus);
            var _loc_4:String = this;
            var _loc_5:* = this.i + 1;
            _loc_4.i = _loc_5;
            this.parseCrcStr(_loc_3);
            if (this.i < this.p2pSohuLib.fileList.fileoA.length)
            {
                this.downloadCrc();
            }
            else
            {
                this._p2psohu.config.isCrc = true;
            }
            return;
        }// end function

        private function parseCrcStr(param1:String) : void
        {
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_2:* = param1.split("\n");
            _loc_2.pop();
            var _loc_3:* = new Array();
            for each (_loc_4 in _loc_2)
            {
                
                _loc_5 = _loc_4.slice(5);
                if (_loc_5 == "")
                {
                    var _loc_8:String = this;
                    var _loc_9:* = this.i - 1;
                    _loc_8.i = _loc_9;
                    return;
                }
                _loc_3.push(_loc_4.slice(5));
            }
            this.crcA.push(_loc_3);
            return;
        }// end function

        private function ioHandler(event:IOErrorEvent) : void
        {
            this._p2psohu.showTestInfo("cr_ctrl ioerror:" + event.errorID + " httpstatus:" + this.httpstatus);
            this.serverGC();
            return;
        }// end function

        private function securityHandler(event:SecurityErrorEvent) : void
        {
            this._p2psohu.showTestInfo("cr_ctrl securityerror" + " httpstatus:" + this.httpstatus);
            this.serverGC();
            return;
        }// end function

        public function serverGC() : void
        {
            this.i = 0;
            this.crcA.splice(0);
            this._p2psohu.config.isCrc = false;
            this.httpstatus = 1;
            this._p2psohu.showTestInfo("nocrc check");
            return;
        }// end function

    }
}
