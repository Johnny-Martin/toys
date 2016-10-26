package server
{
    import com.*;
    import configbag.*;
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import model.*;

    public class SchedulingServer extends BaseCtrl
    {
        private var _urll:HaleUrlLoader;
        private var _urlr:URLRequest;
        private var isqs1:Boolean = true;
        private var oldstopfilename:String;
        private var waitStopFileT:Timer;
        private var waitInterval:Number = 1000;
        private var conT:Timer;
        private var nofile_num:int = 0;
        private var _nowFilename:String;
        private var isRefer:Boolean = false;
        private var _badCdn:String = "";
        private var _startT:Number;
        private var _conAIdx:int = 0;
        private var _conA:Array;
        private var _dataAIdx:int = 0;
        private var _dataA:Array;
        private var _maxT:int = 8;
        private var _failIdx:int = 0;
        private var _failType:String;
        private var _failDataIdx:int = 0;
        private var _isSchedulFailRoll:Boolean = false;
        private var ipnum:int = 0;
        private var iptimes:int = 3;
        private var httpstatus:int = 1;
        private var _isfailidx:int = 0;
        private var _staticST:String;
        private var _schurl:String;
        private var _badHttpIDNum:int = 0;

        public function SchedulingServer()
        {
            this._conA = new Array();
            this._dataA = new Array();
            return;
        }// end function

        public function init() : void
        {
            if (this._urll)
            {
                this.serverGC();
                this._urll = null;
            }
            this._urll = new HaleUrlLoader();
            this._urlr = new URLRequest();
            this._urlr.method = URLRequestMethod.GET;
            this.waitStopFileT = new Timer(this.waitInterval);
            this.waitStopFileT.addEventListener(TimerEvent.TIMER, this.waitForCallIndex);
            this.conT = new Timer(this._p2psohu.config.avg_schConNum * 2);
            this.conT.addEventListener(TimerEvent.TIMER, this.connectFailMth);
            return;
        }// end function

        public function loadURL(param1:String, param2:Boolean = false) : void
        {
            this.isRefer = param2;
            this._nowFilename = param1;
            this.callIndex(false);
            return;
        }// end function

        private function waitForCallIndex(event:TimerEvent) : void
        {
            this.waitStopFileT.reset();
            this.waitStopFileT.delay = this.waitInterval;
            var _loc_2:String = this;
            var _loc_3:* = this.ipnum + 1;
            _loc_2.ipnum = _loc_3;
            if (this.ipnum <= this.iptimes)
            {
                this.callIndex(false);
            }
            else
            {
                this.ipnum = 0;
                this.callIndex();
            }
            return;
        }// end function

        private function callIndex(param1:Boolean = true) : void
        {
            if (this._p2psohu.isAllDie)
            {
                return;
            }
            if (param1 || this._nowFilename == null)
            {
                this.serverGC();
            }
            Security.loadPolicyFile("http://" + Config.getInstance().schedulIP + ":8080/crossdomain.xml");
            this.waitStopFileT.reset();
            this._p2psohu.config.randomNum = this.randRange(30, 65);
            Config.getInstance().schedulIP = param1 ? (this._p2psohu.schdulString) : (this._p2psohu.schdulSuc);
            if (Config.getInstance().isPureCdn)
            {
                Config.getInstance().schedulIP = "220.181.61.211";
            }
            var _loc_2:* = (Config.getInstance().vid == "" ? ("") : ("&vid=" + Config.getInstance().vid)) + (Config.getInstance().uid == "" ? ("") : ("&uid=" + Config.getInstance().uid)) + (Config.getInstance().ta == "" ? ("") : ("&ta=" + Config.getInstance().ta)) + Config.getInstance().cdnparam;
            var _loc_3:String = "cdnList";
            this._urlr.url = "http://" + Config.getInstance().schedulIP + ":80/" + _loc_3 + "?new=" + this._nowFilename + _loc_2 + (this._badCdn == "" ? ("") : ("&idc=" + this._badCdn));
            this._urll.addEventListener(Event.COMPLETE, this.completeHandler);
            this._urll.addEventListener(Event.OPEN, this.openMth);
            this._urll.addEventListener(IOErrorEvent.IO_ERROR, this.ioHandler);
            this._urll.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityHandler);
            this._urll.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpstatusEvt);
            this._urll.load(this._urlr);
            this.conT.reset();
            this.conT.delay = this._p2psohu.config.avg_schConNum * 2;
            this.conT.start();
            this._startT = getTimer();
            this._staticST = this._p2psohu.curT;
            this._schurl = this._urlr.url;
            this._p2psohu.showTestInfo("schedul server callIndex _urlr.url:" + this._urlr.url + " conT.running:" + this.conT.running + " conT.delay:" + this.conT.delay);
            return;
        }// end function

        private function connectFailMth(event:TimerEvent = null) : void
        {
            this.serverGC();
            this.saveConNum(false, getTimer() - this._startT);
            this._p2psohu.showTestInfo("schedul getdataFailMth   isAllDie:" + this._p2psohu.isAllDie + " httpstatus:" + this.httpstatus + " schedulurl:" + this._urlr.url, true);
            this.failStaticMth("timeout");
            if (this._p2psohu.isAllDie)
            {
                return;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._isfailidx + 1;
            _loc_2._isfailidx = _loc_3;
            if (this._isfailidx >= 2)
            {
                this._isfailidx = 0;
                if (this._p2psohu.config.schedulIdx == 0)
                {
                    this._p2psohu.setSckedulIdx();
                }
            }
            this.waitStopFileT.start();
            return;
        }// end function

        private function failStaticMth(param1:String) : void
        {
            if (this._failType == null)
            {
                this._failType = param1;
                this._failIdx = 0;
            }
            else if (this._failType != param1)
            {
                this._failType = param1;
                this._failIdx = 0;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._failIdx + 1;
            _loc_2._failIdx = _loc_3;
            if (this._failIdx > ByteSize.ROLLBACKIDX && this._p2psohu.getNsType("isNsTimeLowest") && this._isSchedulFailRoll == false)
            {
                this._isSchedulFailRoll = true;
                this._failIdx = 0;
                this._p2psohu.showFailInfoMth("schedulfail", this._failType);
            }
            return;
        }// end function

        private function saveConNum(param1:Boolean, param2:int) : void
        {
            if (this._conAIdx == this._maxT)
            {
                this._conAIdx = 0;
            }
            if (!param1)
            {
                param2 = param2 * 1.2;
            }
            this._conA[this._conAIdx] = {dur:param2};
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < this._conA.length)
            {
                
                _loc_3 = _loc_3 + this._conA[_loc_4].dur;
                _loc_4++;
            }
            return;
        }// end function

        private function saveDataNum(param1:Boolean, param2:int) : void
        {
            if (this._dataAIdx == this._maxT)
            {
                this._dataAIdx = 0;
            }
            this._dataA[this._dataAIdx] = {dur:param2};
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < this._dataA.length)
            {
                
                _loc_3 = _loc_3 + this._dataA[_loc_4].dur;
                _loc_4++;
            }
            this._p2psohu.config.avg_schDataNum = Math.min(Math.max(3000, _loc_3 / this._dataA.length), 5000);
            return;
        }// end function

        public function randRange(param1:Number, param2:Number) : int
        {
            var _loc_3:* = Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
            return _loc_3;
        }// end function

        private function openMth(event:Event) : void
        {
            return;
        }// end function

        private function completeHandler(event:Event) : void
        {
            var _loc_3:String = null;
            this.ipnum = 0;
            this._badHttpIDNum = 0;
            this.serverGC();
            this._isfailidx = 0;
            this._p2psohu.showTestInfo("schedulingServerBack     loader.data:" + _loc_3 + " _nowFilename:" + this._nowFilename + "  filename:" + this._p2psohu.fileList.fileoA[this._p2psohu.fileo.fileidx].cdnfilename);
            if (this._nowFilename != this._p2psohu.fileList.fileoA[this._p2psohu.fileo.fileidx].cdnfilename)
            {
                return;
            }
            var _loc_2:* = URLLoader(event.target);
            _loc_3 = _loc_2.data as String;
            if (_loc_3 == "")
            {
                this._p2psohu.showTestInfo("schedulfail dataerror:" + _loc_3, true);
                this.failDataMth();
                this.saveConNum(false, getTimer() - this._startT);
                this.waitStopFileT.start();
                return;
            }
            this._p2psohu.showTestInfo("schedulingServerBack     loader.data:" + _loc_3 + " nofile_num:" + this.nofile_num);
            var _loc_4:* = Json.decode(_loc_3);
            if (Json.decode(_loc_3) == null)
            {
                this._p2psohu.showTestInfo("schedulfail dataerror:" + _loc_3, true);
                this.failDataMth();
                this.saveConNum(false, getTimer() - this._startT);
                this.waitStopFileT.start();
                return;
            }
            this.nofile_num = 0;
            var _loc_5:* = new Array();
            if (_loc_4.cdnlista != undefined)
            {
                this._p2psohu.config.isSingleCdn = false;
                _loc_5 = _loc_4.cdnlista;
            }
            else
            {
                this._p2psohu.config.isSingleCdn = true;
                _loc_5[0] = _loc_4;
                if (_loc_4.url == undefined)
                {
                    this._p2psohu.showTestInfo("schedulfail dataerror:" + _loc_3, true);
                    this.failDataMth();
                    this.saveConNum(false, getTimer() - this._startT);
                    this.waitStopFileT.start();
                    return;
                }
                if (_loc_4.csmall != undefined)
                {
                    if (_loc_4.csmall == "1" && !this._p2psohu.config.isRtmfpTest)
                    {
                        this.saveConNum(false, getTimer() - this._startT);
                        this._p2psohu.showFailInfoMth("smallSuppliers");
                        return;
                    }
                }
            }
            this.saveDataNum(true, getTimer() - this._startT);
            this._failIdx = 0;
            this._failDataIdx = 0;
            this._isSchedulFailRoll = false;
            this._failType = null;
            this._p2psohu.showFailInfoMth("schedulsuccess");
            this._p2psohu.loaderMang.schedulingServerBack(_loc_5, this.isRefer);
            var _loc_6:* = new Object();
            new Object().fileidx = this._p2psohu.fileo.fileidx;
            _loc_6.cdnid = _loc_4.nid;
            _loc_6.cdnip = _loc_4.ip;
            this._p2psohu.fileStatMth(_loc_6);
            return;
        }// end function

        private function failDataMth() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this._failDataIdx + 1;
            _loc_1._failDataIdx = _loc_2;
            if (this._failDataIdx > ByteSize.ROLLBACKIDX && this._p2psohu.getNsType("isNsTimeLowest"))
            {
                this._failDataIdx = 0;
                this._p2psohu.showFailInfoMth("schedulfail", "dataerror");
            }
            return;
        }// end function

        private function httpstatusEvt(event:HTTPStatusEvent) : void
        {
            var _loc_2:String = null;
            if (event.status != 0 || event.status != 200)
            {
                this._p2psohu.showTestInfo("schedul httpstatusEvt:" + event.status, true);
            }
            this.httpstatus = event.status;
            if (this.httpstatus == 200)
            {
                this._badHttpIDNum = 0;
                this.conT.reset();
            }
            else
            {
                _loc_2 = String(this.httpstatus);
                if (_loc_2.slice(0, 1) == "4" || this.httpstatus == 500 || this.httpstatus == 601 || this._badHttpIDNum == 5)
                {
                    this.saveConNum(false, getTimer() - this._startT);
                    this._p2psohu.showFailInfoMth("404");
                    this._p2psohu.cleanMth(true);
                }
                else if (this.httpstatus != 0)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this._badHttpIDNum + 1;
                    _loc_3._badHttpIDNum = _loc_4;
                    this.connectFailMth();
                }
            }
            return;
        }// end function

        private function ioHandler(event:IOErrorEvent) : void
        {
            this._p2psohu.showTestInfo("schedul ioerror:" + event.errorID + " text:" + event.text + " httpstatus:" + this.httpstatus + " schedulurl:" + this._urlr.url, true);
            if (event.errorID == 2032)
            {
                if (this._p2psohu.config.schedulIdx == 0)
                {
                    this._p2psohu.setSckedulIdx();
                }
            }
            this._isfailidx = 0;
            this.serverGC();
            this.failStaticMth("ioerror");
            this.waitStopFileT.start();
            return;
        }// end function

        private function securityHandler(event:SecurityErrorEvent) : void
        {
            this._p2psohu.showTestInfo("schedul securityerror" + " httpstatus:" + this.httpstatus + " schedulurl:" + this._urlr.url, true);
            if (this._p2psohu.config.schedulIdx == 0)
            {
                this._p2psohu.setSckedulIdx();
            }
            this._isfailidx = 0;
            this.serverGC();
            this.failStaticMth("timeout");
            this.waitStopFileT.start();
            return;
        }// end function

        public function seekInit() : void
        {
            this._failDataIdx = 0;
            this._failIdx = 0;
            this._failType = null;
            this._isSchedulFailRoll = false;
            return;
        }// end function

        public function serverGC() : void
        {
            this.cleanPreMth();
            return;
        }// end function

        public function cleanPreMth() : void
        {
            if (this.waitStopFileT.running)
            {
                this.waitStopFileT.reset();
            }
            this.conT.reset();
            this.httpstatus = 1;
            this._urll.removeEventListener(Event.COMPLETE, this.completeHandler);
            this._urll.removeEventListener(Event.OPEN, this.openMth);
            this._urll.removeEventListener(IOErrorEvent.IO_ERROR, this.ioHandler);
            this._urll.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityHandler);
            this._urll.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpstatusEvt);
            return;
        }// end function

        public function get badCdn() : String
        {
            return this._badCdn;
        }// end function

        public function set badCdn(param1:String) : void
        {
            this._badCdn = param1;
            return;
        }// end function

    }
}
