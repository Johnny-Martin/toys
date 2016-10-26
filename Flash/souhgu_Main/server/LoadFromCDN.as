package server
{
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import httpSocket.*;
    import model.*;
    import test.*;

    public class LoadFromCDN extends BaseCtrl
    {
        protected var _cdnInfo:Object;
        protected var _httpsocket:HttpSocket;
        private var _delayDataT:Number = 7500;
        public var connectTimer:TimerSohu;
        protected var _isCDNLoading:Boolean = false;
        private var url:String;
        protected var beginT:Number;
        private var _hasDataT:Boolean = true;
        protected var _proba:ByteArray;
        protected var _isDataDie:Boolean = false;
        private var _beginIdx:int;
        private var _failIdx:int = 0;
        private var _failType:String;
        private var _is302:Boolean = false;
        private var _302ChangeIdx:int = 0;
        private var _failRangeIdx:int = 0;
        private var _piceStartT:Number;
        private var _cont:Number;
        private var _staticST:String;
        private var _cdnStr:String = "";

        public function LoadFromCDN()
        {
            return;
        }// end function

        public function init() : void
        {
            this._httpsocket = new HttpSocket();
            if (this.p2pSohuLib.config.isP2pLive)
            {
                this._httpsocket.plversion = "sohupl:" + String(this.p2pSohuLib.config.version);
            }
            else
            {
                this._httpsocket.plversion = "sohuce:" + String(this.p2pSohuLib.config.version);
            }
            this._httpsocket.testMsgF = this.p2pSohuLib.showTestInfo;
            this._httpsocket.addEventListener(HttpSocketEvent.CONNECT, this.connectMth);
            this._httpsocket.addEventListener(HttpSocketEvent.COMPLETE, this.completeMth);
            this._httpsocket.addEventListener(HttpSocketEvent.CLOSE, this.closeMth);
            this._httpsocket.addEventListener(HttpSocketEvent.ERROR, this.errorSocketMth);
            this._httpsocket.addEventListener(HttpSocketEvent.FILE_LENGTH, this.fileLengthMth);
            this.connectTimer = new TimerSohu(this.p2pSohuLib.config.avg_cdnConnectDelayNum);
            this.connectTimer.msg = "connect_error";
            this.connectTimer.addEventListener(TimerEvent.TIMER, this.diePeerMth);
            return;
        }// end function

        public function loadCDNMth(param1:Object) : void
        {
            var _loc_2:* = param1.cdnurl;
            this._cdnInfo = param1;
            this._cdnInfo.recdnurl = _loc_2;
            this.socketLoad();
            return;
        }// end function

        private function socketLoad() : void
        {
            var _loc_3:int = 0;
            var _loc_4:URLRequest = null;
            this.p2pSohuLib.config.isCdnNoFile = false;
            this.beginT = getTimer();
            if (this._httpsocket == null)
            {
                this.init();
            }
            this.connectTimer.reset();
            var _loc_1:* = this._cdnInfo.recdnurl;
            var _loc_2:* = _loc_1.split("http");
            if (_loc_2.length > 2)
            {
                this._cdnInfo.recdnurl = "";
                _loc_3 = 0;
                while (_loc_3 < _loc_2.length)
                {
                    
                    if (_loc_2[_loc_3].length > 5)
                    {
                        this._cdnInfo.recdnurl = this._cdnInfo.recdnurl + ("http" + _loc_2[_loc_3]);
                    }
                    _loc_3++;
                }
            }
            else
            {
                this._cdnInfo.recdnurl = "http" + _loc_2[(_loc_2.length - 1)];
            }
            this._cdnInfo.recdnurl = encodeURI(this._cdnInfo.recdnurl);
            this.p2pSohuLib.showTestInfo("loadCDN----------cdn:" + this._cdnInfo.recdnurl, true);
            this.p2pSohuLib.showTestInfo("loadCDNMth----------cdn:" + this._cdnInfo.ip + " fileidx:" + this._cdnInfo.fileidx + " sockettype:" + this._httpsocket.socketType + " _hasDataT:" + this._hasDataT + " connectTimer running:" + this.connectTimer.running + " recdnurl:" + this._cdnInfo.recdnurl);
            this._cdnStr = this._cdnStr + (this._cdnInfo.recdnurl + ";");
            if (!this._httpsocket.socketType)
            {
                _loc_4 = new URLRequest(this._cdnInfo.recdnurl);
                _loc_4.method = URLRequestMethod.GET;
                this._httpsocket.isP2pLive = this.p2pSohuLib.config.isP2pLive;
                this._httpsocket.load(_loc_4);
                this.connectTimer.delay = this.p2pSohuLib.config.avg_cdnConnectDelayNum * 2;
                this.connectTimer.msg = "connect_error";
                this.connectTimer.start();
                this._staticST = this._p2psohu.curT;
            }
            else
            {
                this.connectTimer.delay = this.p2pSohuLib.config.cdnDataT;
                this.connectTimer.msg = "data_error";
                this._p2psohu.cdnloader.lcConSuc(this);
            }
            return;
        }// end function

        private function connectMth(event:HttpSocketEvent) : void
        {
            this._failIdx = 0;
            this._failRangeIdx = 0;
            this._failType = null;
            if (!this._is302)
            {
                this._p2psohu.cdnloader.cleanbadcdn();
            }
            this._p2psohu.cdnloader.cdn302ConOK();
            this._is302 = false;
            this._cont = getTimer() - this.beginT;
            this.p2pSohuLib.showTestInfo("connectMth---------+ lc idx:" + this.p2pSohuLib.cdnloader.cdnldmang.getLDIdx(this) + " cdn:" + this._cdnInfo.ip + " sockettype:" + this._httpsocket.socketType + " _hasDataT:" + this._hasDataT + " connectTimer running:" + this.connectTimer.running + " cont:" + this._cont);
            this.connectTimer.reset();
            this.connectTimer.delay = this.p2pSohuLib.config.cdnDataT;
            this.connectTimer.msg = "data_error";
            this.beginT = getTimer();
            this._p2psohu.cdnloader.lcConSuc(this);
            return;
        }// end function

        public function beginDownLoadData(param1:Object) : void
        {
            this._isCDNLoading = true;
            this._cdnInfo.dataInfo = param1;
            param1.isfrompeer = false;
            this._proba = new ByteArray();
            this._isDataDie = false;
            this._beginIdx = 0;
            this.p2pSohuLib.showTestInfo("beginDownLoadData-----+ lc idx:" + this.p2pSohuLib.cdnloader.cdnldmang.getLDIdx(this) + "-----cdn:" + this._cdnInfo.ip + " o.fileidx:" + param1.fileidx + " _cdnInfo.fileidx:" + this._cdnInfo.fileidx + " fileDLIdx:" + this.p2pSohuLib.chunksMang.fileDLIdx + " arrlen:" + param1.arridx.length + " connum:" + this._p2psohu.cdnloader.cdnldmang.connum + " dataIdx:" + param1.dataIdx + " total:" + param1.total + " chunkidx:" + param1.chunkidx + " b:" + param1.begin + " e:" + param1.end + " _isCDNLoading:" + this._isCDNLoading);
            if (param1.fileidx != this._cdnInfo.fileidx)
            {
                this.gc();
                if (this._p2psohu.cdnloader.cdnldmang.cdnloadNum > 1 && this._p2psohu.cdnloader.cdnldmang.connum == 1 || this._p2psohu.cdnloader.cdnldmang.cdnloadNum == 1)
                {
                    this.p2pSohuLib.referFileInfo(this.p2pSohuLib.fileList.fileoA[param1.fileidx], true);
                }
                return;
            }
            this._piceStartT = getTimer();
            this.connectTimer.start();
            this._httpsocket.addEventListener(HttpSocketEvent.PROGRESS, this.progressData, false, 0, true);
            this._httpsocket.setRangeHeaders(param1.begin, param1.end, param1.isend);
            this._httpsocket.getDataMth();
            return;
        }// end function

        private function wrongCDN(param1:String) : void
        {
            if (this.isSameCdn())
            {
                this.p2pSohuLib.cdnloader.badCdnMth();
            }
            this.errorMth(param1);
            return;
        }// end function

        private function fileLengthMth(event:HttpSocketEvent) : void
        {
            this._httpsocket.removeEventListener(HttpSocketEvent.FILE_LENGTH, this.fileLengthMth);
            var _loc_2:* = this.p2pSohuLib.fileList.resizeFileNum(this._cdnInfo.fileidx, this._cdnInfo.dataInfo.arridx[0].chunkidx, this._cdnInfo.dataInfo.arridx[0].piceidx, Number(event.data));
            if (_loc_2 == "0")
            {
                this.p2pSohuLib.showTestInfo("loadCDNMth--@@@@@cdnfile_wrong:  cdnfilelen:" + Number(event.data) + " filelen:" + this._p2psohu.fileList.fileoA[this._cdnInfo.fileidx].size + " hotlen:" + this._p2psohu.fileList.fileoA[this._cdnInfo.fileidx].oldsize, false, true);
                this.wrongCDN("cdnfile_wrong");
            }
            return;
        }// end function

        private function progressData(event:HttpSocketEvent) : void
        {
            var _loc_7:ByteArray = null;
            if (this._proba == null)
            {
                return;
            }
            var _loc_2:* = new ByteArray();
            _loc_2.writeBytes(event.data as ByteArray);
            (event.data as ByteArray).clear();
            var _loc_3:* = _loc_2.length;
            if (_loc_3 == 0)
            {
                return;
            }
            this._proba.writeBytes(_loc_2);
            _loc_2.clear();
            _loc_2 = null;
            event = null;
            var _loc_4:* = new ByteArray();
            new ByteArray().writeBytes(this._proba);
            var _loc_5:* = Math.floor(_loc_4.length / ByteSize.PICESIZE);
            _loc_4.position = this._beginIdx * ByteSize.PICESIZE;
            var _loc_6:* = this._beginIdx;
            while (_loc_6 < _loc_5)
            {
                
                _loc_7 = new ByteArray();
                _loc_4.readBytes(_loc_7, 0, ByteSize.PICESIZE);
                this.piceDataLoadOver(_loc_7, _loc_6);
                _loc_6++;
            }
            _loc_4.clear();
            _loc_4 = null;
            this._p2psohu.filesManager.addCdnSize(_loc_3);
            return;
        }// end function

        protected function completeMth(event:HttpSocketEvent) : void
        {
            var _loc_2:ByteArray = null;
            var _loc_3:int = 0;
            var _loc_4:ByteArray = null;
            var _loc_5:int = 0;
            var _loc_6:ByteArray = null;
            this.p2pSohuLib.showTestInfo("cdn  completeMth--------------" + " _beginIdx:" + this._beginIdx + " len:" + this._cdnInfo.dataInfo.arridx.length);
            this._httpsocket.removeEventListener(HttpSocketEvent.PROGRESS, this.progressData, true);
            this._proba.clear();
            this.connectTimer.reset();
            if (this._beginIdx != this._cdnInfo.dataInfo.arridx.length && !this._p2psohu.isAllLoadedOver)
            {
                _loc_2 = new ByteArray();
                _loc_2.writeBytes(event.data as ByteArray);
                (event.data as ByteArray).clear();
                event = null;
                _loc_3 = Math.floor(_loc_2.length / ByteSize.PICESIZE);
                _loc_2.position = this._beginIdx * ByteSize.PICESIZE;
                if (this._beginIdx == (this.cdnInfo.dataInfo.arridx.length - 1))
                {
                    _loc_4 = new ByteArray();
                    _loc_2.readBytes(_loc_4, 0, _loc_2.bytesAvailable);
                    this.piceDataLoadOver(_loc_4, this._beginIdx);
                }
                else
                {
                    _loc_5 = this._beginIdx;
                    while (_loc_5 < _loc_3)
                    {
                        
                        _loc_6 = new ByteArray();
                        _loc_2.readBytes(_loc_6, 0, ByteSize.PICESIZE);
                        this.piceDataLoadOver(_loc_6, _loc_5);
                        _loc_5++;
                    }
                }
                _loc_2.clear();
            }
            else
            {
                (event.data as ByteArray).clear();
            }
            this.completeLoadMth();
            return;
        }// end function

        private function dataLoadOver(param1:ByteArray) : void
        {
            var _loc_2:* = this._cdnInfo.dataInfo.arridx.length;
            var _loc_3:* = new Object();
            param1.position = 0;
            _loc_3.ba = param1;
            _loc_3.size = param1.length;
            _loc_3.isfrompeer = false;
            _loc_3.benginT = this.beginT;
            _loc_3.dur = getTimer() - this.beginT;
            _loc_3.dataIdx = this._cdnInfo.dataInfo.dataIdx;
            _loc_3.fileidx = this._cdnInfo.fileidx;
            _loc_3.total = this._cdnInfo.dataInfo.total;
            _loc_3.arridx = this._cdnInfo.dataInfo.arridx;
            _loc_3.cdnurl = this._cdnInfo.recdnurl;
            _loc_3.begin = this._cdnInfo.dataInfo.begin;
            _loc_3.end = this._cdnInfo.dataInfo.end;
            _loc_3.cont = this._cont;
            _loc_3.isover = true;
            this._isCDNLoading = false;
            var _loc_4:* = ByteSize.PICESIZE * (_loc_2 - 1) + _loc_3.size;
            this.p2pSohuLib.cdnloader.saveCdnDataNum(true, _loc_3.dur, _loc_4);
            this.p2pSohuLib.chunksMang.saveChunkData(_loc_3);
            this.p2pSohuLib.chunksMang.cdnDataLoadedOver(this._cdnInfo.dataInfo.arridx);
            return;
        }// end function

        private function piceDataLoadOver(param1:ByteArray, param2:int) : void
        {
            var _loc_4:Number = NaN;
            if (this._302ChangeIdx != 0)
            {
                this._302ChangeIdx = 0;
            }
            this._cdnStr = "";
            this._piceStartT = getTimer();
            var _loc_3:* = new Object();
            param1.position = 0;
            _loc_3.ba = param1;
            _loc_3.size = _loc_3.ba.length;
            _loc_3.isfrompeer = false;
            _loc_3.benginT = this.beginT;
            _loc_3.dur = getTimer() - this.beginT;
            _loc_3.dataIdx = this._cdnInfo.dataInfo.dataIdx;
            _loc_3.fileidx = this._cdnInfo.fileidx;
            _loc_3.chunkidx = this._cdnInfo.dataInfo.arridx[param2].chunkidx;
            _loc_3.total = this._cdnInfo.dataInfo.total;
            _loc_3.arridx = this._cdnInfo.dataInfo.arridx;
            _loc_3.lowidx = this._cdnInfo.dataInfo.arridx[param2].piceidx;
            _loc_3.cdnurl = this._cdnInfo.recdnurl;
            _loc_3.begin = this._cdnInfo.dataInfo.begin;
            _loc_3.end = this._cdnInfo.dataInfo.end;
            _loc_3.cont = this._cont;
            var _loc_5:String = this;
            var _loc_6:* = this._beginIdx + 1;
            _loc_5._beginIdx = _loc_6;
            if (this._beginIdx == this._cdnInfo.dataInfo.arridx.length)
            {
                _loc_3.isover = true;
                this._isCDNLoading = false;
                _loc_4 = ByteSize.PICESIZE * (this._beginIdx - 1) + _loc_3.size;
                this.p2pSohuLib.cdnloader.saveCdnDataNum(true, _loc_3.dur, _loc_4);
            }
            this.p2pSohuLib.chunksMang.saveChunkData(_loc_3);
            if (this._beginIdx == this._cdnInfo.dataInfo.arridx.length)
            {
                this.p2pSohuLib.chunksMang.cdnDataLoadedOver(this._cdnInfo.dataInfo.arridx);
            }
            return;
        }// end function

        private function completeLoadMth() : void
        {
            this._beginIdx = 0;
            this._piceStartT = getTimer();
            if (this._p2psohu.isAllLoadedOver || this._cdnInfo == null)
            {
                return;
            }
            this.p2pSohuLib.showTestInfo("cdn  completeMth--------------  lc idx:" + this.p2pSohuLib.cdnloader.cdnldmang.getLDIdx(this) + " cdn:" + this._cdnInfo.ip + " fileidx:" + this._cdnInfo.fileidx + " b:" + this._cdnInfo.dataInfo.begin + " e:" + this._cdnInfo.dataInfo.end + " arridx.length:" + this._cdnInfo.dataInfo.arridx.length + " isrp:" + this.p2pSohuLib.config.isRP);
            this._p2psohu.cdnloader.cleanbadcdn();
            this._cdnInfo.dataInfo = null;
            this._cdnInfo.dataInfo = undefined;
            return;
        }// end function

        private function byteLoadedOver(param1:Object) : void
        {
            this.p2pSohuLib.cdnloader.fileLoadedOver(param1, this);
            return;
        }// end function

        protected function closeMth(event:HttpSocketEvent) : void
        {
            this.p2pSohuLib.showTestInfo("cdn  close :---lc idx:" + this.p2pSohuLib.cdnloader.cdnldmang.getLDIdx(this) + " ip:" + this._cdnInfo.ip + " fileidx:" + this._cdnInfo.fileidx + " dataIdx:" + (this._cdnInfo.dataInfo == null ? (null) : (this._cdnInfo.dataInfo.dataIdx)) + " chunkidx:" + (this._cdnInfo.dataInfo == null ? (null) : (this._cdnInfo.dataInfo.chunkIdx)) + " piceidx:" + (this._cdnInfo.dataInfo == null ? (null) : (this._cdnInfo.dataInfo.arridx[0].piceidx)) + " _isCDNLoading:" + this._isCDNLoading + " isStopCdnLoader:" + this.p2pSohuLib.cdnloader.isStopCdnLoader + " isrp:" + this.p2pSohuLib.config.isRP + " isloading:" + this.p2pSohuLib.chunksMang.isloading);
            if (this.p2pSohuLib.chunksMang.isloading == false || this.p2pSohuLib.isAllLoadedOver)
            {
                this.gc();
                return;
            }
            if (!this.p2pSohuLib.cdnloader.cdnldmang.getIsInLoadA(this))
            {
                this.gc();
                return;
            }
            if (this.p2pSohuLib.nsPlayTimerMinMth() && this.p2pSohuLib.cdnloader.isStopCdnLoader)
            {
                this.gc();
                return;
            }
            if (this._isCDNLoading || this.connectTimer.running)
            {
                this.errorMth("close");
            }
            else
            {
                this.gc();
            }
            return;
        }// end function

        private function errorSocketMth(event:HttpSocketEvent) : void
        {
            var _loc_3:String = null;
            if (this._p2psohu.isAllDie)
            {
                return;
            }
            if (this._isCDNLoading == false)
            {
                this.gc();
                return;
            }
            var _loc_2:* = event.msg as String;
            this.p2pSohuLib.showTestInfo("cdn  errorMth evt:" + _loc_2 + "--ip:" + this._cdnInfo.ip + " fileidx:" + this._cdnInfo.fileidx + " chunkidx:" + (this._cdnInfo.dataInfo != undefined ? (this._cdnInfo.dataInfo.chunkidx) : (null)));
            if (_loc_2.indexOf("302=") != -1 || _loc_2.indexOf("301=") != -1)
            {
                this._is302 = true;
                var _loc_4:String = this;
                var _loc_5:* = this._302ChangeIdx + 1;
                _loc_4._302ChangeIdx = _loc_5;
                if (this._302ChangeIdx > ByteSize.ROLLBACKIDX302 && !this.p2pSohuLib.config.is301)
                {
                    this.p2pSohuLib.cleanMth(true);
                    this.p2pSohuLib.showTestInfo("cdn 302 error:" + this._cdnStr, true);
                    this.p2pSohuLib.showFailInfoMth("schedulfail");
                    return;
                }
                this.p2pSohuLib.showTestInfo("cdn msg:" + _loc_2, true);
                this.gc(true);
                _loc_3 = (event.msg as String).slice(4);
                this._cdnInfo.recdnurl = _loc_3;
                this.socketLoad();
                return;
            }
            else if (_loc_2.indexOf("no_range") != -1)
            {
                this.failRangeMth();
            }
            else if (_loc_2.indexOf("404") != -1)
            {
                this.failStaticMth("404");
            }
            if (this.isSameCdn())
            {
                this.p2pSohuLib.cdnloader.badCdnMth();
            }
            this.gc();
            this.p2pSohuLib.cdnloader.callNextCDN(true, this);
            return;
        }// end function

        private function errorMth(param1:String) : void
        {
            if (this._p2psohu.isAllDie)
            {
                return;
            }
            if (this._cdnInfo != null)
            {
                this.p2pSohuLib.showTestInfo("cdn  errorMth str:" + param1 + " ip:" + this._cdnInfo.ip + " fileidx:" + this._cdnInfo.fileidx + " chunkidx:" + (this._cdnInfo.dataInfo != undefined ? (this._cdnInfo.dataInfo.chunkidx) : (null)));
            }
            this.p2pSohuLib.showTestInfo("cdn error:" + param1, true);
            this.gc();
            this.p2pSohuLib.cdnloader.callNextCDN(true, this);
            return;
        }// end function

        private function failStaticCDNMth() : void
        {
            if (this._failType != null)
            {
                this._failType = null;
                this._failIdx = 0;
            }
            var _loc_1:String = this;
            var _loc_2:* = this._failIdx + 1;
            _loc_1._failIdx = _loc_2;
            if (this._failIdx > ByteSize.ROLLBACKIDX + 2 && this._p2psohu.getNsType("isNsTimeLowest"))
            {
                this._failType = null;
                this._failIdx = 0;
                this._p2psohu.showFailInfoMth("cdnconfail");
            }
            return;
        }// end function

        private function failRangeMth() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this._failRangeIdx + 1;
            _loc_1._failRangeIdx = _loc_2;
            if (this._failRangeIdx > ByteSize.ROLLBACKIDX && this._p2psohu.getNsType("isNsTimeLowest"))
            {
                this._failRangeIdx = 0;
                this._p2psohu.showTestInfo("failRangeMth");
                this._p2psohu.showFailInfoMth("blackscreen");
            }
            return;
        }// end function

        private function failStaticMth(param1:String) : void
        {
            if (this._failType == null)
            {
                this._failType = param1;
                this._failIdx = 0;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._failIdx + 1;
            _loc_2._failIdx = _loc_3;
            if (this._failIdx > ByteSize.ROLLBACKIDX && this._failType == "404" && this._p2psohu.getNsType("isNsTimeLowest"))
            {
                this._failIdx = 0;
                this._p2psohu.showFailInfoMth("404");
            }
            return;
        }// end function

        private function diePeerMth(event:TimerEvent = null) : void
        {
            var _loc_2:Number = NaN;
            if (this.p2pSohuLib.isAllDie)
            {
                this.gc();
                return;
            }
            if (this.connectTimer.msg == "connect_error")
            {
                this.p2pSohuLib.showTestInfo("diecdn   t.ms g:" + this.connectTimer.msg + "  cdnurl:" + this._cdnInfo.ip + " fileidx:" + this._cdnInfo.fileidx + " chunkidx:" + (this._cdnInfo.dataInfo != undefined ? (this._cdnInfo.dataInfo.chunkidx) : (null)) + " delay:" + this.connectTimer.delay);
                this.connectTimer.reset();
                this.connectTimer.removeEventListener(TimerEvent.TIMER, this.diePeerMth);
                if (this._is302 || this.p2pSohuLib.config.is301)
                {
                    this.p2pSohuLib.cdnloader.errorType302(this._cdnInfo.ip);
                    return;
                }
                this.failStaticCDNMth();
                if (this._p2psohu.isAllDie)
                {
                    return;
                }
            }
            else
            {
                _loc_2 = getTimer() - this._piceStartT;
                if (_loc_2 < this.p2pSohuLib.config.cdnPiceDataT)
                {
                    return;
                }
                this._isDataDie = true;
                this.p2pSohuLib.cdnloader.saveCdnDataNum(false, this.connectTimer.delay, this._proba.length);
                this.connectTimer.reset();
                this.connectTimer.removeEventListener(TimerEvent.TIMER, this.diePeerMth);
            }
            if (this.isSameCdn())
            {
                this.p2pSohuLib.cdnloader.badCdnMth();
            }
            this.errorMth(this.connectTimer.msg);
            return;
        }// end function

        private function isSameCdn() : Boolean
        {
            var _loc_1:* = this.p2pSohuLib.cdnloader.getCdnLd();
            var _loc_2:* = this._cdnInfo.recdnurl;
            var _loc_3:* = _loc_2.split("/");
            var _loc_4:* = _loc_3[2].split(":")[0];
            return _loc_3[2].split(":")[0] == _loc_1.ip ? (true) : (this._cdnInfo.ip == _loc_1.ip ? (true) : (false));
        }// end function

        public function gc(param1:Boolean = false) : void
        {
            this.p2pSohuLib.showTestInfo("loadfromcdn gc  cdninfo:" + (this._cdnInfo == null ? (null) : (this._cdnInfo.dataInfo)));
            if (this._cdnInfo != null && this._cdnInfo.dataInfo != undefined)
            {
                this.p2pSohuLib.cdnloader.referDataList(this._cdnInfo.dataInfo);
                this._cdnInfo.dataInfo = undefined;
            }
            this._beginIdx = 0;
            this._cont = 0;
            this._cdnStr = "";
            this.connectTimer.stop();
            this.connectTimer.removeEventListener(TimerEvent.TIMER, this.diePeerMth);
            this._isCDNLoading = false;
            if (this._proba != null)
            {
                this._proba.clear();
                this._proba = null;
            }
            this._isDataDie = false;
            this._piceStartT = getTimer();
            if (!param1)
            {
                this._cdnInfo = null;
            }
            if (this._httpsocket == null)
            {
                return;
            }
            this._httpsocket.close();
            this._httpsocket.removeEventListener(HttpSocketEvent.CONNECT, this.connectMth);
            this._httpsocket.removeEventListener(HttpSocketEvent.COMPLETE, this.completeMth);
            this._httpsocket.removeEventListener(HttpSocketEvent.CLOSE, this.closeMth);
            this._httpsocket.removeEventListener(HttpSocketEvent.ERROR, this.errorSocketMth);
            this._httpsocket.removeEventListener(HttpSocketEvent.FILE_LENGTH, this.fileLengthMth);
            this._httpsocket.removeEventListener(HttpSocketEvent.PROGRESS, this.progressData, true);
            this._httpsocket = null;
            return;
        }// end function

        private function testCdn(param1:String, param2:String) : void
        {
            var _loc_3:* = new CdnHeaderTest();
            _loc_3.type = param2;
            _loc_3.p2pSohuLib = this.p2pSohuLib;
            _loc_3.downloadHeader(param1);
            return;
        }// end function

        public function get socketType() : Boolean
        {
            if (this._httpsocket == null)
            {
                return false;
            }
            return this._httpsocket.socketType;
        }// end function

        public function get isCDNLoading() : Boolean
        {
            return this._isCDNLoading;
        }// end function

        public function get cdnInfo() : Object
        {
            return this._cdnInfo;
        }// end function

        public function get isRun() : Boolean
        {
            if (this.connectTimer.running || this._isCDNLoading)
            {
                return true;
            }
            return false;
        }// end function

        public function seekInit() : void
        {
            this._failType = null;
            this._failIdx = 0;
            this._failRangeIdx = 0;
            return;
        }// end function

    }
}
