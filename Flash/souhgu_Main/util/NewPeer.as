package util
{
    import flash.events.*;
    import flash.net.*;
    import model.*;
    import server.*;

    public class NewPeer extends BasePeer
    {
        public var sendPeer:SendPeer;
        public var receivePeer:ReceivePeer;
        private var _cdErrRpA:Array;
        private var _cdErrSpA:Array;

        public function NewPeer()
        {
            this.sendPeer = new SendPeer();
            this.receivePeer = new ReceivePeer();
            this._cdErrRpA = new Array();
            this._cdErrSpA = new Array();
            this.receivePeer.Peer = this;
            this.sendPeer.Peer = this;
            return;
        }// end function

        override protected function shareNsInit() : void
        {
            this.sendPeer.shareNsInit();
            this.p2pSohuLib.oldDataMang.shareData();
            return;
        }// end function

        override public function clearDiePeerMth(param1:NetStream) : void
        {
            this.sendPeer.clearDiePeer(param1.farID);
            this.receivePeer.clearDiePeer(param1.farID);
            return;
        }// end function

        override protected function closeNCMth(param1:NetConnection) : void
        {
            if (this._p2psohu.isAllDie || this._p2psohu.ns.isClose)
            {
                return;
            }
            this.rtmfpFailMth("rtmfp die closeNC");
            return;
        }// end function

        override protected function nsConnectFailMth(param1:NetConnection) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this._failidx + 1;
            _loc_2._failidx = _loc_3;
            param1.removeEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
            param1.close();
            if (this._failidx > ByteSize.ROLLBACKIDX && this._p2psohu.getNsType("isNsTimeLowest"))
            {
                this._p2psohu.initFailMth();
                _failidx = 0;
                this._p2psohu.showFailInfoMth("rtmfpfail");
            }
            else
            {
                this.rtmfpFailMth("rtmfp die nsConnectFail");
            }
            return;
        }// end function

        override protected function registFailMth(event:TimerEvent) : void
        {
            this._p2psohu.showTestInfo("rtmfp server 注册超时  ismain:" + this.registRtmfpT.o.ismain + "  rtmfpurl:" + this.registRtmfpT.o.url, true);
            this._p2psohu.initFailInfo = "3;" + _rtmfpurl;
            this._p2psohu.config.initErrorType = "03";
            this.rtmfpFailMth("rtmfp die registFail");
            return;
        }// end function

        private function rtmfpFailMth(param1:String) : void
        {
            this._p2psohu.config.isRtmfpDie = true;
            super._isRegistering = false;
            this.registRtmfpT.o.nc.removeEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
            this.registRtmfpT.o.nc.close();
            this.registRtmfpT.stop();
            this.receivePeer.clearMth(true);
            this._p2psohu.serverDieMth(param1);
            return;
        }// end function

        public function getTransCDO(param1:int, param2:int) : Object
        {
            var _loc_8:Object = null;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_3:* = new Object();
            var _loc_4:* = new Array();
            var _loc_5:* = new Array();
            this._p2psohu.config.cdidx = this._p2psohu.config.cdidx + ByteSize.CDDIF;
            if (this._p2psohu.config.cdidx >= this.p2pSohuLib.chunksMang.chunkTotal)
            {
                this._p2psohu.config.cdidx = 0;
            }
            if (this._p2psohu.config.cdidx < 0)
            {
                this._p2psohu.config.cdidx = 0;
            }
            var _loc_6:int = 0;
            var _loc_7:* = this._p2psohu.config.cdidx == 0 ? (0) : ((this._p2psohu.config.cdidx - 1));
            while (_loc_6 < ByteSize.CDDIF)
            {
                
                _loc_10 = _loc_7 - _loc_6;
                if (_loc_10 < 0)
                {
                    break;
                }
                _loc_8 = this._p2psohu.chunksMang.getChunkInfo(_loc_10);
                if (_loc_8.datawrong != 1)
                {
                    if (_loc_8.cd != undefined)
                    {
                        _loc_5.push({cd:_loc_8.cd, chunkidx:_loc_10, fileidx:_loc_8.fileidx});
                    }
                    else
                    {
                        _loc_5.push({cd:null, chunkidx:_loc_10, fileidx:_loc_8.fileidx});
                    }
                }
                _loc_6++;
            }
            _loc_3.chunkcd = _loc_5;
            var _loc_9:* = this._p2psohu.chunksMang.getChunkInfo(param1);
            if (param2 != 0)
            {
                _loc_11 = 0;
                while (_loc_11 <= param2)
                {
                    
                    if (_loc_9.pices[_loc_11].datawrong != 1)
                    {
                        if (_loc_9.pices[_loc_11].cd != undefined && _loc_9.datawrong != 1)
                        {
                            _loc_4.push({cd:_loc_9.pices[_loc_11].cd, piceidx:_loc_11, chunkidx:param1, fileidx:_loc_9.fileidx});
                        }
                        else
                        {
                            _loc_4.push({cd:null, piceidx:_loc_11, chunkidx:param1, fileidx:_loc_9.fileidx});
                        }
                    }
                    _loc_11++;
                }
            }
            else if (_loc_9.pices[param2].cd != undefined && _loc_9.pices[param2].datawrong != 1 && _loc_9.datawrong != 1)
            {
                _loc_4.push({cd:_loc_9.pices[param2].cd, piceidx:param2, chunkidx:param1, fileidx:_loc_9.fileidx});
            }
            else
            {
                _loc_4.push({cd:null, piceidx:param2, chunkidx:param1, fileidx:_loc_9.fileidx});
            }
            _loc_3.picecd = _loc_4;
            return _loc_3;
        }// end function

        public function checkCDMth(param1:Object) : Object
        {
            var _loc_11:Object = null;
            var _loc_12:int = 0;
            var _loc_13:Object = null;
            var _loc_14:int = 0;
            var _loc_2:* = param1.chunkcd.length;
            var _loc_3:* = new Object();
            var _loc_4:* = new Array();
            var _loc_5:* = new Array();
            var _loc_6:int = 0;
            while (_loc_6 < _loc_2)
            {
                
                _loc_11 = this._p2psohu.chunksMang.getChunkInfo(param1.chunkcd[_loc_6].chunkidx);
                if (_loc_11.cd != undefined && _loc_11.datawrong != 1 && param1.chunkcd[_loc_6].cd != null && _loc_11.cd != param1.chunkcd[_loc_6].cd)
                {
                    _loc_12 = 0;
                    while (_loc_12 < _loc_11.total)
                    {
                        
                        _loc_11.pices[_loc_12].datawrong = 1;
                        _loc_12++;
                    }
                    this._p2psohu.showTestInfo("@@@@@ wrongcd isrp:" + param1.isrp + " farid:" + param1.farid + " fileidx:" + param1.chunkcd[_loc_6].fileidx + " chunkidx:" + param1.chunkcd[_loc_6].chunkidx + " my_cd:" + _loc_11.cd + " o.chunkcd[i].cd:" + param1.chunkcd[_loc_6].cd);
                    _loc_11.datawrong = 1;
                    this._p2psohu.showTestInfo("chunk验证错误 删除共享 chunkidx:" + param1.chunkcd[_loc_6].chunkidx + " isrp:" + param1.isrp);
                    this._p2psohu.chunksMang.delChunkInfo(_loc_11.chunkidx);
                    _loc_5.push({cd:_loc_11.cd, chunkidx:_loc_11.chunkidx, fileidx:_loc_11.fileidx});
                }
                _loc_6++;
            }
            var _loc_7:* = param1.picecd.length;
            var _loc_8:Boolean = false;
            var _loc_9:* = this._p2psohu.chunksMang.getChunkInfo(param1.picecd[0].chunkidx);
            var _loc_10:int = 0;
            while (_loc_10 < _loc_7)
            {
                
                _loc_13 = this._p2psohu.chunksMang.getPiceInfo(param1.picecd[_loc_10].chunkidx, param1.picecd[_loc_10].piceidx);
                if (_loc_9.datawrong != 1 && _loc_13.cd != undefined && _loc_13.datawrong != 1 && param1.picecd[_loc_10].cd != null && _loc_13.cd != param1.picecd[_loc_10].cd)
                {
                    this._p2psohu.showTestInfo("pice验证错误  删除共享 chunkidx:" + param1.picecd[0].chunkidx);
                    this._p2psohu.chunksMang.delChunkInfo(param1.picecd[0].chunkidx);
                    _loc_4.push({cd:_loc_13.cd, piceidx:param1.picecd[_loc_10].piceidx, chunkidx:param1.picecd[_loc_10].chunkidx, fileidx:_loc_13.fileidx});
                    _loc_13.datawrong = 1;
                    _loc_8 = true;
                    this._p2psohu.showTestInfo("@@@@@ wrongcd isrp:" + param1.isrp + " farid:" + param1.farid + " fileidx:" + param1.picecd[_loc_10].fileidx + " chunkidx:" + param1.picecd[_loc_10].chunkidx + " piceidx:" + param1.picecd[_loc_10].piceidx + " my_cd:" + _loc_13.cd + " o.picecd[j].cd:" + param1.picecd[_loc_10].cd);
                }
                _loc_10++;
            }
            if (_loc_8)
            {
                _loc_9.datawrong = 1;
                _loc_14 = 0;
                while (_loc_14 < _loc_9.total)
                {
                    
                    _loc_9.pices[_loc_14].datawrong = 1;
                    _loc_14++;
                }
            }
            if (_loc_4.length == 0 && _loc_5.length == 0)
            {
                return null;
            }
            _loc_3.chunkcd = _loc_5;
            _loc_3.picecd = _loc_4;
            return _loc_3;
        }// end function

        public function checkRPRevCD(param1:uint, param2:Array, param3:int, param4:int) : Boolean
        {
            var _loc_5:* = param2.length;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_5)
            {
                
                if (param2[_loc_6].chunkidx == param3 && param2[_loc_6].piceidx == param4)
                {
                    this._p2psohu.showTestInfo("checkRPRevCD my_cd:" + param1 + " other_cd:" + param2[_loc_6].cd);
                    if (param2[_loc_6].cd == param1)
                    {
                        return true;
                    }
                    return false;
                }
                _loc_6++;
            }
            return false;
        }// end function

        public function clearMth() : void
        {
            this._isRegistering = false;
            registRtmfpT.stop();
            _failidx = 0;
            return;
        }// end function

        public function closePeer() : void
        {
            if (_mainNC == null)
            {
                return;
            }
            this.isfirst = true;
            this._mainNC.close();
            this._mainNC.removeEventListener(NetStatusEvent.NET_STATUS, netConnectionHandler);
            this.receivePeer.clearMth();
            this.sendPeer.clearMth();
            this.clearMth();
            return;
        }// end function

        public function seekInit() : void
        {
            this._p2psohu.isGetwayInitFail = false;
            _failidx = 0;
            return;
        }// end function

        public function cleanPreMth() : void
        {
            if (this.registRtmfpT.running)
            {
                this.registRtmfpT.reset();
            }
            return;
        }// end function

    }
}
