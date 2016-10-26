package server
{
    import com.*;
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import model.*;

    public class LoadFromPeer extends BaseCtrl
    {
        private var incomingStream:HoldNetStream;
        private var outgoingStream:HoldNetStream;
        public var farpeerid:String;
        private var _peerConnectT:TimerSohu;
        private var _conSucF:Function;
        public var peerinfo:Object;
        private var beginT:Number;
        private var _spDataIdx:int = 0;
        private var _hasDataIdx:int = 0;
        private var _cont:Number;
        private var _wrongo:Object;
        private var _isloading:Boolean = false;
        private var _rpinterval:int = 50;
        private var t:TimerSohu;

        public function LoadFromPeer()
        {
            this.peerinfo = new Object();
            return;
        }// end function

        public function loadPeerMth(param1:Object) : void
        {
            if (param1.peerid == this._p2psohu.peer.mainPeer)
            {
                this.callNextPeer();
                return;
            }
            this.peerinfo = param1;
            this.init(param1.peerid, param1.filename, param1.dataIdx);
            return;
        }// end function

        private function init(param1:String, param2:String, param3:int) : void
        {
            var nsIdx:int;
            var outstrname:String;
            var o:Object;
            var speer:* = param1;
            var filename:* = param2;
            var dataIdx:* = param3;
            this.farpeerid = speer;
            try
            {
                this._peerConnectT = new TimerSohu(this._p2psohu.config.avg_peerConnectDelayNum * 2);
                this._peerConnectT.addEventListener(TimerEvent.TIMER, this.peerConnectFailMth);
                this._peerConnectT.msg = "connect";
                nsIdx = Math.round(Math.random() * (ByteSize.NSLEN - 1));
                this.outgoingStream = new HoldNetStream(this._p2psohu.peer.mainNC, NetStream.DIRECT_CONNECTIONS);
                this.outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, this.outFileNSHandler);
                this.outgoingStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorMth);
                outstrname = this._p2psohu.peer.mainPeer + speer + nsIdx;
                this.outgoingStream.publish(outstrname);
                this.incomingStream = new HoldNetStream(this._p2psohu.peer.mainNC, speer);
                this.incomingStream.addEventListener(NetStatusEvent.NET_STATUS, this.inFileNSHandler);
                this.incomingStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorMth);
                this.incomingStream.play(speer + nsIdx);
                o = new Object();
                o.onRP = function (param1:ByteArray, param2:int, param3:int, param4:int, param5:Object) : void
            {
                if (_p2psohu.chunksMang.getChunkInfo(param3).type == 2)
                {
                    return;
                }
                dataFromSP(param1, param2, param3, param4, param5);
                return;
            }// end function
            ;
                this.incomingStream.client = o;
                this._peerConnectT.start();
                this.beginT = getTimer();
                this._p2psohu.showTestInfo("loadfrompeer  speer:" + speer.slice(0, 8) + " nsIdx:" + nsIdx + "  _peerConnectT.running:" + this._peerConnectT.running + " _peerConnectT.delay:" + this._peerConnectT.delay);
                this.t = new TimerSohu(this._rpinterval);
                this.t.addEventListener(TimerEvent.TIMER, this.delayForGetData);
            }
            catch (e:Error)
            {
                this._p2psohu.showTestInfo(e.getStackTrace());
            }
            return;
        }// end function

        private function asyncErrorMth(event:AsyncErrorEvent) : void
        {
            trace(event);
            return;
        }// end function

        private function inFileNSHandler(event:NetStatusEvent) : void
        {
            var _loc_2:* = event.currentTarget as HoldNetStream;
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    break;
                }
                case "NetStream.Play.Stop":
                case "NetStream.Play.Failed":
                {
                    this.closeFailNs();
                    _loc_2.removeEventListener(NetStatusEvent.NET_STATUS, this.inFileNSHandler);
                    break;
                }
                case "NetStream.Play.UnpublishNotify":
                {
                    this._p2psohu.showTestInfo("关闭流通知rp close sp......speerid:" + this.farpeerid.slice(0, 8));
                    _loc_2.removeEventListener(NetStatusEvent.NET_STATUS, this.inFileNSHandler);
                    this.clearDiePeer();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function outFileNSHandler(event:NetStatusEvent) : void
        {
            var _loc_2:* = event.currentTarget as HoldNetStream;
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    if (this._peerConnectT.msg == "data" && this._peerConnectT.running)
                    {
                        return;
                    }
                    this._peerConnectT.reset();
                    this._peerConnectT.removeEventListener(TimerEvent.TIMER, this.peerConnectFailMth);
                    this.peerinfo.conT = getTimer() - this.beginT;
                    this._p2psohu.peer.receivePeer.savePeerNum(true, this.peerinfo.conT);
                    this._p2psohu.showTestInfo("rp-sp 链接成功，接收数据===spid:" + this.farpeerid.slice(0, 8) + "  peercont:" + this.peerinfo.conT);
                    this._p2psohu.peer.receivePeer.peerldmang.addItemMth(this);
                    this._conSucF(this);
                    break;
                }
                case "NetStream.Play.Stop":
                case "NetStream.Play.Failed":
                {
                    this.closeFailNs();
                    _loc_2.removeEventListener(NetStatusEvent.NET_STATUS, this.outFileNSHandler);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function closeFailNs() : void
        {
            var _loc_1:* = getTimer() - this.beginT;
            this._p2psohu.showTestInfo("呼叫失败......" + this.farpeerid.slice(0, 8) + " peerfaildur:" + _loc_1);
            this._p2psohu.peer.receivePeer.peerldmang.addBlackList(this.farpeerid, ByteSize.BLACKP1);
            this.callNextPeer();
            return;
        }// end function

        public function gc() : void
        {
            this._p2psohu.showTestInfo("lp gc farid:" + this.farpeerid);
            this._hasDataIdx = 0;
            this._spDataIdx = 0;
            if (this.peerinfo != null && this.peerinfo.dataInfo != undefined)
            {
                this._p2psohu.peer.receivePeer.referDataList(this.peerinfo.dataInfo);
            }
            if (this._peerConnectT != null)
            {
                this._peerConnectT.stop();
                if (this._peerConnectT.msg == "connect")
                {
                    this._peerConnectT.removeEventListener(TimerEvent.TIMER, this.peerConnectFailMth);
                }
                else
                {
                    this._peerConnectT.removeEventListener(TimerEvent.TIMER, this.dataLoadFailMth);
                }
                this._peerConnectT = null;
            }
            this.clearNs();
            return;
        }// end function

        public function clearDiePeer() : void
        {
            this._p2psohu.showTestInfo("diepeer***************---" + this.farpeerid.slice(0, 8) + "  _peerConnectT.running:" + this._peerConnectT.running);
            this._p2psohu.peer.receivePeer.peerldmang.delBlackList(this.farpeerid);
            this.callNextPeer();
            return;
        }// end function

        public function begindownloadData(param1:Object) : void
        {
            var _loc_5:Object = null;
            var _loc_6:String = null;
            var _loc_7:int = 0;
            this._peerConnectT.reset();
            this._peerConnectT.delay = this._p2psohu.config.avg_peerDatatime * 2;
            this._peerConnectT.msg = "data";
            this._peerConnectT.addEventListener(TimerEvent.TIMER, this.dataLoadFailMth);
            this._isloading = true;
            this.peerinfo.dataInfo = param1;
            this.peerinfo.fileidx = param1.fileidx;
            this.peerinfo.startT = getTimer();
            this._p2psohu.peer.receivePeer.peerldmang.saveLoadingByteMth(this.peerinfo, this);
            var _loc_2:* = new Object();
            _loc_2.farid = this._p2psohu.config.peerID.slice(0, 8);
            _loc_2.isrp = true;
            if (this._p2psohu.config.hasCd)
            {
                if (this._wrongo != null)
                {
                    _loc_2.chunkcd = this._wrongo.chunkcd;
                    _loc_2.picecd = this._wrongo.picecd;
                }
                else
                {
                    _loc_5 = this._p2psohu.peer.getTransCDO(this.peerinfo.dataInfo.chunkidx, this.peerinfo.dataInfo.lowidx);
                    for (_loc_6 in _loc_5)
                    {
                        
                        _loc_2[_loc_6] = _loc_5[_loc_6];
                    }
                }
            }
            _loc_2.vid = this._p2psohu.config.vid;
            _loc_2.hashid = this._p2psohu.fileList.fileoA[this.peerinfo.fileidx].filename;
            _loc_2.peertype = "flash";
            var _loc_3:* = this.peerinfo.dataInfo.lowidx;
            var _loc_4:* = ByteSize._CHUNKSIZE / ByteSize.PICESIZE;
            _loc_2.lowidx = _loc_3;
            _loc_2.chunkidx = this._p2psohu.chunksMang.getChunkInfo(this.peerinfo.dataInfo.chunkidx).dataIdx;
            if (_loc_3 >= _loc_4)
            {
                _loc_7 = Math.floor(_loc_3 / _loc_4);
                _loc_2.lowidx = _loc_3 - _loc_4 * _loc_7;
                _loc_2.chunkidx = _loc_2.chunkidx + _loc_7;
            }
            this.outgoingStream.send("onSP", this.peerinfo.fileidx, this.peerinfo.dataInfo.chunkidx, _loc_3, _loc_2);
            return;
        }// end function

        private function delayForGetData(event:TimerEvent) : void
        {
            if (this.outgoingStream != null && this.t.o != null)
            {
                this.outgoingStream.send("onSP", this.t.o.fileidx, this.t.o.chunkidx, this.t.o.lowidx, this.t.o.rpo);
                this.peerinfo.startT = getTimer();
                this._peerConnectT.start();
            }
            this.t.o = null;
            return;
        }// end function

        private function dataFromSP(param1:ByteArray, param2:int, param3:int, param4:int, param5:Object) : void
        {
            var _loc_11:Object = null;
            var _loc_12:int = 0;
            var _loc_13:uint = 0;
            var _loc_14:Boolean = false;
            var _loc_15:Object = null;
            var _loc_16:Object = null;
            this._isloading = false;
            if (_p2psohu.isAllDie)
            {
                return;
            }
            if (param5.peertype != undefined && param5.peertype != "flash")
            {
                param2 = this._p2psohu.fileList.getFileidx(param5.hashid);
            }
            var _loc_6:* = getTimer() - this.peerinfo.startT;
            if (this._p2psohu.chunksMang.innpidx == null)
            {
                this._p2psohu.chunksMang.innpidx = CountIdx.saveIdxAsByte(this._p2psohu.chunksMang.fileDLIdx, _p2psohu.chunksMang.chunkDLIdx, _p2psohu.chunksMang.peerInsertIdx);
            }
            var _loc_7:* = CountIdx.getIdxAsObject(this._p2psohu.chunksMang.innpidx);
            this._p2psohu.showTestInfo("rp接收数据--dataFromSP  fileidx:" + param2 + " chunkidx:" + param3 + " piceidx:" + param4 + " farid:" + this.farpeerid.slice(0, 8) + " spo.filelen:" + param5.filelen + " ba:" + param1.length + " peerdatadur:" + _loc_6 + " sp-playtime:" + param5.playtime + " sp-dfidx:" + param5.dfidx + " sp-dcidx:" + param5.dcidx + " sp-dpidx:" + param5.dpidx + " isseek:" + this._p2psohu.isSeek + " loadv peer compelet:" + param1.length / _loc_6 * 0.001);
            this._peerConnectT.reset();
            this._peerConnectT.removeEventListener(TimerEvent.TIMER, this.dataLoadFailMth);
            this._p2psohu.peer.receivePeer.peerldmang.delLoadingByteMth(this.peerinfo);
            if (param5.peertype != undefined && param5.peertype != "flash")
            {
                _loc_11 = this._p2psohu.fileList.fileoA[param2];
                _loc_12 = _loc_11.first_count + param5.chunkidx;
                if (_loc_12 > _loc_11.end_count)
                {
                    param3 = _loc_11.end_count;
                    param4 = param5.lowidx + ByteSize._CHUNKSIZE / ByteSize.PICESIZE * (_loc_12 - param3);
                }
                else
                {
                    param3 = _loc_12;
                    param4 = param5.lowidx;
                }
            }
            var _loc_8:* = this._p2psohu.fileList.resizeFileNum(param2, param3, param4, param5.filelen, true);
            if (this._p2psohu.fileList.resizeFileNum(param2, param3, param4, param5.filelen, true) == "0")
            {
                this.p2pSohuLib.showTestInfo("loadCDNMth--@@@@@peerfile_wrong:  peerfilelen:" + param5.filelen + " filelen:" + this._p2psohu.fileList.fileoA[param2].size + " hotlen:" + this._p2psohu.fileList.fileoA[param2].oldsize, false, true);
                param1.clear();
                this.callNextPeer();
                return;
            }
            var _loc_9:* = new Object();
            new Object().fileidx = param2;
            _loc_9.chunkidx = param3;
            _loc_9.lowidx = param4;
            var _loc_10:* = new ByteArray();
            new ByteArray().writeBytes(param1);
            param1.clear();
            if (this._p2psohu.config.hasCd && param5.picecd != undefined)
            {
                this._wrongo = this._p2psohu.peer.checkCDMth(param5);
            }
            if (_loc_10.length != 0 && this._p2psohu.config.hasCd && param5.picecd != undefined)
            {
                _loc_13 = this._p2psohu.chunksMang.getCompressData(_loc_10);
                _loc_14 = this._p2psohu.peer.checkRPRevCD(_loc_13, param5.picecd, param3, param4);
                if (!_loc_14)
                {
                    this._p2psohu.chunksMang.referPiceData(_loc_9);
                    this._conSucF(this);
                    return;
                }
                _loc_15 = this._p2psohu.chunksMang.getPiceInfo(param3, param4);
                _loc_15.cd = _loc_13;
            }
            if (_loc_10.length == 0)
            {
                if (param5.iserror)
                {
                    this._p2psohu.showTestInfo("重新领任务 spo.iserror");
                    this._p2psohu.chunksMang.referPiceData(_loc_9);
                }
                this._p2psohu.showTestInfo("sp 没有要分享的数据了  _hasDataIdx:" + this._hasDataIdx + " farid:" + this.farpeerid.slice(0, 8));
                this.callNextPeer();
            }
            else
            {
                this._hasDataIdx = 0;
                this._spDataIdx = 0;
                _loc_16 = this._p2psohu.chunksMang.getChunkInfo(param3);
                if (_loc_16.pices[param4].type == 2)
                {
                    this._p2psohu.showTestInfo("重新领任务");
                    this._conSucF(this);
                    return;
                }
                this._p2psohu.filesManager.addPeerSize(_loc_10.length);
                _loc_9.ba = _loc_10;
                _loc_9.size = _loc_10.length;
                _loc_9.isfrompeer = true;
                _loc_9.filename = this._p2psohu.chunksMang.getFilename(param2);
                _loc_9.dataIdx = _loc_16.dataIdx;
                _loc_9.delayfilet = _loc_6;
                _loc_9.farid = this.farpeerid.slice(0, 8);
                _loc_9.cont = this.peerinfo.conT;
                this._p2psohu.peer.receivePeer.savePeerDataNum(true, _loc_9.delayfilet, _loc_9.size);
                this._p2psohu.peer.receivePeer.byteLoadedOver(_loc_9, this);
            }
            return;
        }// end function

        private function peerConnectFailMth(event:TimerEvent) : void
        {
            this._peerConnectT.reset();
            this._peerConnectT.removeEventListener(TimerEvent.TIMER, this.peerConnectFailMth);
            this._p2psohu.peer.receivePeer.savePeerNum(false);
            this._p2psohu.showTestInfo("rp connect time out!***************" + this.farpeerid.slice(0, 8) + " _peerConnectT.delay:" + this._peerConnectT.delay);
            this._p2psohu.peer.receivePeer.peerldmang.addBlackList(this.farpeerid, ByteSize.BLACKP2);
            this.callNextPeer();
            return;
        }// end function

        private function dataLoadFailMth(event:TimerEvent) : void
        {
            this._peerConnectT.reset();
            this._peerConnectT.removeEventListener(TimerEvent.TIMER, this.dataLoadFailMth);
            this._p2psohu.showTestInfo("sp load outtime!---------------------" + this.farpeerid.slice(0, 8) + " _spDataIdx:" + this._spDataIdx + " _peerConnectT.delay:" + this._peerConnectT.delay);
            this._p2psohu.peer.receivePeer.savePeerDataNum(false, this._peerConnectT.delay, 0);
            var _loc_2:String = this;
            var _loc_3:* = this._spDataIdx + 1;
            _loc_2._spDataIdx = _loc_3;
            if (this._spDataIdx >= 1)
            {
                this._p2psohu.peer.receivePeer.peerldmang.addBlackList(this.farpeerid, ByteSize.BLACKP1);
                this.callNextPeer();
            }
            else
            {
                this.begindownloadData(this.peerinfo.dataInfo);
            }
            return;
        }// end function

        private function callNextPeer() : void
        {
            this._p2psohu.peer.receivePeer.callNextPeer(this);
            return;
        }// end function

        private function clearNs() : void
        {
            this._p2psohu.showTestInfo("lp  clearNs farid:" + (this.farpeerid == null ? (null) : (this.farpeerid.slice(0, 8))) + " peerinfo.dataInfo:" + (this.peerinfo == null ? (null) : (this.peerinfo.dataInfo)) + " outns:" + (this.outgoingStream == null ? (null) : (false)) + " b-t:" + getTimer() + " isAllDie:" + this._p2psohu.isAllDie + " _peerConnectT:" + this._peerConnectT);
            if (this._peerConnectT != null && this._peerConnectT.running)
            {
                this._peerConnectT.reset();
                if (this._peerConnectT.msg == "connect")
                {
                    this._peerConnectT.removeEventListener(TimerEvent.TIMER, this.peerConnectFailMth);
                }
                else
                {
                    this._peerConnectT.removeEventListener(TimerEvent.TIMER, this.dataLoadFailMth);
                }
            }
            this.farpeerid = null;
            this.peerinfo = null;
            this._wrongo = null;
            this._isloading = false;
            if (this.outgoingStream == null)
            {
                return;
            }
            this.outgoingStream.removeEventListener(NetStatusEvent.NET_STATUS, this.outFileNSHandler);
            this.incomingStream.removeEventListener(NetStatusEvent.NET_STATUS, this.inFileNSHandler);
            this.outgoingStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorMth);
            this.incomingStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorMth);
            this.outgoingStream.close();
            this.incomingStream.close();
            this.outgoingStream = null;
            this.incomingStream = null;
            this.t.stop();
            this.t.removeEventListener(TimerEvent.TIMER, this.delayForGetData);
            this.t.o = null;
            this.t = null;
            return;
        }// end function

        public function set conSucF(param1:Function) : void
        {
            this._conSucF = param1;
            return;
        }// end function

        public function get peerConnectT() : TimerSohu
        {
            return this._peerConnectT;
        }// end function

        public function get isloading() : Boolean
        {
            return this._isloading;
        }// end function

    }
}
