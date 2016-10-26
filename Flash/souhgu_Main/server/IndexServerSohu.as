package server
{
    import com.*;
    import configbag.*;
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class IndexServerSohu extends BaseCtrl
    {
        private var _urll:URLLoader;
        private var _urlr:URLRequest;
        private var isqs1:Boolean = true;
        private var oldstopfilename:String;
        private var waitStopFileT:Timer;
        private var waitInterval:Number = 1000;
        private var conT:Timer;
        private var nofile_num:int = 0;

        public function IndexServerSohu()
        {
            return;
        }// end function

        public function init() : void
        {
            this._urll = new URLLoader();
            this._urlr = new URLRequest();
            this._urlr.method = URLRequestMethod.GET;
            this.waitStopFileT = new Timer(this.waitInterval);
            this.waitStopFileT.addEventListener(TimerEvent.TIMER, this.waitForCallIndex);
            this.conT = new Timer(this._p2psohu.config.errorConTimeNumGet);
            this.conT.addEventListener(TimerEvent.TIMER, this.connectFailMth);
            return;
        }// end function

        public function loadURL() : void
        {
            this.callIndex();
            return;
        }// end function

        private function waitForCallIndex(event:TimerEvent) : void
        {
            this.waitStopFileT.reset();
            if (this.waitInterval == 8000)
            {
                this.callIndex();
                return;
            }
            this.waitInterval = this.waitInterval * 2;
            this.waitStopFileT.delay = this.waitInterval;
            this.callIndex();
            return;
        }// end function

        private function callIndex() : void
        {
            if (this._p2psohu.isAllDie)
            {
                return;
            }
            this._p2psohu.config.nowLoadingFilename = "";
            this._p2psohu.config.randomNum = this.randRange(30, 65);
            this._urlr.url = this.getBaseQsUrl() + "cid=" + Config.getInstance().cid + "&usr=" + this._p2psohu.config.peerID + "&v=" + this._p2psohu.config.version;
            this._urll.addEventListener(Event.COMPLETE, this.completeHandler);
            this._urll.addEventListener(Event.OPEN, this.openMth);
            this._urll.addEventListener(IOErrorEvent.IO_ERROR, this.ioHandler);
            this._urll.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityHandler);
            this._urll.load(this._urlr);
            this.conT.reset();
            this.conT.start();
            return;
        }// end function

        private function connectFailMth(event:TimerEvent) : void
        {
            this.conT.reset();
            this.conT.removeEventListener(TimerEvent.TIMER, this.connectFailMth);
            this._p2psohu.showTestInfo("index connectFailMth");
            this.waitStopFileT.start();
            return;
        }// end function

        public function randRange(param1:Number, param2:Number) : int
        {
            var _loc_3:* = Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
            return _loc_3;
        }// end function

        private function getBaseQsUrl() : String
        {
            return "http://gslb.tv.sohu.com/streamIndex?";
        }// end function

        private function openMth(event:Event) : void
        {
            this.conT.stop();
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var _loc_2:* = URLLoader(event.target);
            this.waitStopFileT.reset();
            var _loc_3:* = _loc_2.data as String;
            this._p2psohu.showTestInfo("indexServerBack     loader.data:" + _loc_3 + " nofile_num:" + this.nofile_num);
            var _loc_4:* = Json.decode(_loc_3);
            if (Json.decode(_loc_3).code == "000000" && _loc_4.segment == "")
            {
                var _loc_5:String = this;
                var _loc_6:* = this.nofile_num + 1;
                _loc_5.nofile_num = _loc_6;
                if (this.nofile_num > 2)
                {
                    this._p2psohu.errorMth();
                }
                else
                {
                    this.waitStopFileT.start();
                }
                return;
            }
            this.nofile_num = 0;
            if (_loc_4.code == "000001")
            {
                this._p2psohu.cleanMth();
                return;
            }
            this._p2psohu.indexServerBack(String(_loc_4.segment));
            return;
        }// end function

        private function ioHandler(event:IOErrorEvent) : void
        {
            this._p2psohu.showTestInfo("index ioerror");
            this.waitStopFileT.start();
            return;
        }// end function

        private function securityHandler(event:SecurityErrorEvent) : void
        {
            this._p2psohu.showTestInfo("index securityerror");
            return;
        }// end function

    }
}
