package util
{
    import manager.*;
    import model.*;
    import server.*;

    public class ReceivePeer extends BaseSRPeer
    {
        public var peerldmang:PeerLoaderManager;
        private var fileDelayNum:Number = 500;
        private var _isSpingToCdn:Boolean = false;
        private var _ispicedatanull:Number = -1;
        private var _delayLPA:Array;
        private var _isConnecting:Boolean = false;
        private var peerConA:Array;
        private var peerDataA:Array;
        private var _peerConIdx:int = 0;
        private var _peerDataIdx:int = 0;
        private var _maxConA:int = 8;
        private var _iswait:Boolean = false;
        private var _waitidx:int = 0;

        public function ReceivePeer()
        {
            this._delayLPA = new Array();
            this.peerConA = new Array();
            this.peerDataA = new Array();
            this.init();
            return;
        }// end function

        private function init() : void
        {
            this.peerldmang = new PeerLoaderManager();
            this.peerldmang.rp = this;
            return;
        }// end function

        public function callNextPeer(param1:LoadFromPeer = null) : void
        {
            if (param1 != null)
            {
                this.peerldmang.delItemMth(param1);
            }
            this._newpeer.p2pSohuLib.showTestInfo("callNextPeer ");
            this.loadFromPeer();
            return;
        }// end function

        public function beginP2PMth() : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            this._isSpingToCdn = false;
            this._ispicedatanull = -1;
            var _loc_1:Boolean = true;
            for each (_loc_2 in this._newpeer.p2pSohuLib.loaderMang.peerlist.getList())
            {
                
                if (_loc_2.peerid == this._newpeer.mainPeer)
                {
                    continue;
                }
                if (!this.peerldmang.isInBlackDic(_loc_2.peerid))
                {
                    _loc_1 = false;
                    break;
                }
            }
            if (_loc_1 && this.peerldmang.spnum == 0)
            {
                this._newpeer.p2pSohuLib.showTestInfo("没有可用peer  pn:" + this._newpeer.p2pSohuLib.loaderMang.peerlist.getListLen() + " blacknum:" + this.peerldmang.blacknum);
                _loc_3 = this._newpeer.p2pSohuLib.fileo.filename + this._newpeer.p2pSohuLib.chunksMang.dataIdx;
                if (this._newpeer.p2pSohuLib.trackSocket.isSendMsgSuc(_loc_3))
                {
                    this.referPeerList();
                }
                else
                {
                    this.waitReferPeerList();
                }
            }
            else
            {
                this.loadFromPeer();
            }
            return;
        }// end function

        public function referPeerA() : void
        {
            var _loc_3:int = 0;
            var _loc_1:* = this._newpeer.p2pSohuLib.loaderMang.peerlist.getListLen();
            if (_loc_1 < this.peerldmang.peerloadMaxNum)
            {
                this.peerldmang.peerloadNum = _loc_1;
            }
            else
            {
                this.peerldmang.peerloadNum = this.peerldmang.peerloadMaxNum;
            }
            var _loc_2:* = this.peerldmang.peerloaderA.length;
            if (_loc_1 > _loc_2)
            {
                _loc_3 = _loc_2;
                while (_loc_3 < this.peerldmang.peerloadNum)
                {
                    
                    this.peerldmang.peerloaderA.push({ld:null});
                    _loc_3++;
                }
            }
            return;
        }// end function

        public function loadFromPeer() : void
        {
            var _loc_2:int = 0;
            var _loc_3:LoadFromPeer = null;
            var _loc_4:LoadFromPeer = null;
            var _loc_5:LoadFromPeer = null;
            var _loc_6:Object = null;
            var _loc_7:String = null;
            if (this._newpeer.p2pSohuLib.isAllLoadedOver)
            {
                return;
            }
            if (this.peerldmang.peerloaderA.length == 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this.peerldmang.peerloadNum)
                {
                    
                    _loc_3 = new LoadFromPeer();
                    _loc_3.p2pSohuLib = this._newpeer.p2pSohuLib;
                    _loc_3.conSucF = this.lcConSuc;
                    this.peerldmang.peerloaderA[_loc_2] = {ld:_loc_3};
                    _loc_2++;
                }
            }
            this._ispicedatanull = -1;
            var _loc_1:int = 0;
            while (_loc_1 < this.peerldmang.peerloadNum)
            {
                
                if (this._ispicedatanull == 0)
                {
                    this.waitReferPeerList();
                    break;
                }
                if (this.peerldmang.peerloaderA[_loc_1].ld == null)
                {
                    _loc_5 = new LoadFromPeer();
                    _loc_5.p2pSohuLib = this._newpeer.p2pSohuLib;
                    _loc_5.conSucF = this.lcConSuc;
                    this.peerldmang.peerloaderA[_loc_1].ld = _loc_5;
                }
                _loc_4 = this.peerldmang.peerloaderA[_loc_1].ld;
                if (_loc_4.peerConnectT == null)
                {
                    _loc_6 = this.getPeerLd();
                    if (_loc_6 != null)
                    {
                        _loc_4.loadPeerMth(_loc_6);
                        this.peerldmang.addConectMth(_loc_4);
                    }
                    else
                    {
                        _loc_7 = this._newpeer.p2pSohuLib.fileo.filename + this._newpeer.p2pSohuLib.chunksMang.dataIdx;
                        if (this._newpeer.p2pSohuLib.trackSocket.isSendMsgSuc(_loc_7))
                        {
                            this.referPeerList();
                            break;
                        }
                        else
                        {
                            this.waitReferPeerList();
                            break;
                        }
                    }
                }
                else if (_loc_4.peerinfo != null && _loc_4.peerinfo.dataInfo != undefined)
                {
                    if (!_loc_4.isloading)
                    {
                        this._ispicedatanull = this.lcConSuc(_loc_4);
                    }
                }
                else if (this.peerldmang.spDic[_loc_4] != undefined)
                {
                    this._ispicedatanull = this.lcConSuc(_loc_4);
                }
                else if (this.peerldmang.connectingDic[_loc_4] != undefined)
                {
                }
                _loc_1++;
            }
            return;
        }// end function

        public function waitReferPeerList() : void
        {
            this._newpeer.p2pSohuLib.showTestInfo("waitReferPeerList");
            this._iswait = true;
            this._waitidx = 0;
            return;
        }// end function

        private function referPeerList() : void
        {
            this._newpeer.p2pSohuLib.getPeerListMth();
            return;
        }// end function

        public function referDataList(param1:Object) : void
        {
            this._newpeer.p2pSohuLib.chunksMang.referPiceData(param1);
            return;
        }// end function

        public function loadOldData(param1:LoadFromPeer) : void
        {
            this._newpeer.p2pSohuLib.showTestInfo("loadolddata~~");
            this._ispicedatanull = this.lcConSuc(param1);
            return;
        }// end function

        private function lcConSuc(param1:LoadFromPeer) : Number
        {
            var _loc_2:* = this._newpeer.p2pSohuLib.chunksMang.getPiceDataMth();
            if (_loc_2 == null)
            {
                return 0;
            }
            param1.begindownloadData(_loc_2);
            return -1;
        }// end function

        private function getPeerLd() : Object
        {
            var _loc_1:* = this._newpeer.p2pSohuLib.loaderMang.peerlist.getPeerLd();
            if (_loc_1 == null)
            {
                return _loc_1;
            }
            if (_loc_1.peerid == this._newpeer.mainPeer)
            {
                return null;
            }
            if (this.peerldmang.isInBlackDic(_loc_1.peerid))
            {
                return this.getPeerLd();
            }
            if (this.peerldmang.isInPeerLoaderA(_loc_1.peerid))
            {
                return this.getPeerLd();
            }
            return _loc_1;
        }// end function

        public function byteLoadedOver(param1:Object, param2:LoadFromPeer) : void
        {
            this.peerldmang.saveByteMth(param1, param2);
            return;
        }// end function

        public function clearDiePeer(param1:String) : void
        {
            this.peerldmang.clearDiePeer(param1);
            return;
        }// end function

        public function clearMth(param1:Boolean = true) : void
        {
            this.waitReferPeerList();
            this._newpeer.p2pSohuLib.loaderMang.cleanMth();
            this._ispicedatanull = -1;
            this.peerldmang.clearMth(param1);
            return;
        }// end function

        public function seekStopLoadMth() : void
        {
            this.clearMth(false);
            this.peerldmang.seekStopLoadMth();
            return;
        }// end function

        public function savePeerNum(param1:Boolean, param2:Number = 0) : void
        {
            if (this._peerConIdx == this._maxConA)
            {
                this._peerConIdx = 0;
            }
            this.peerConA[this._peerConIdx] = {dur:param1 ? (param2) : (this._newpeer.p2pSohuLib.config.avg_peerConnectDelayNum * 2)};
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < this.peerConA.length)
            {
                
                _loc_3 = _loc_3 + this.peerConA[_loc_4].dur;
                _loc_4++;
            }
            this._newpeer.p2pSohuLib.config.avg_peerConnectDelayNum = Math.max(Math.min(4000, _loc_3 / this.peerConA.length), 3000);
            return;
        }// end function

        public function savePeerDataNum(param1:Boolean, param2:Number, param3:Number) : void
        {
            if (this._peerDataIdx == this._maxConA)
            {
                this._peerDataIdx = 0;
            }
            this.peerDataA[this._peerDataIdx] = {dur:param2, size:param3};
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            while (_loc_6 < this.peerDataA.length)
            {
                
                _loc_4 = _loc_4 + this.peerDataA[_loc_6].dur;
                _loc_5 = _loc_5 + this.peerDataA[_loc_6].size;
                _loc_6++;
            }
            this._newpeer.p2pSohuLib.config.avg_peerDatatime = Math.max(Math.min(10000, _loc_4 / this.peerDataA.length), 5000);
            this._newpeer.p2pSohuLib.config.avg_peerDataV = Math.min(500 * 1024, Math.max(ByteSize.PICESIZE / (this._newpeer.p2pSohuLib.config.avg_peerDatatime * 0.001), _loc_5 / (_loc_4 * 0.001)));
            return;
        }// end function

        public function waitForGetPeerlist() : void
        {
            if (this._iswait)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._waitidx + 1;
                _loc_1._waitidx = _loc_2;
                if (this._waitidx == this._newpeer.p2pSohuLib.config.visitTrack)
                {
                    this._newpeer.p2pSohuLib.trackSocket.clearGetPeerListMsgDic();
                    this._iswait = false;
                    this._waitidx = 0;
                    this.referPeerList();
                }
            }
            return;
        }// end function

        public function get isSpingToCdn() : Boolean
        {
            return this._isSpingToCdn;
        }// end function

        public function set ispicedatanull(param1:Number) : void
        {
            this._ispicedatanull = param1;
            return;
        }// end function

        public function get iswait() : Boolean
        {
            return this._iswait;
        }// end function

        public function set iswait(param1:Boolean) : void
        {
            this._iswait = param1;
            return;
        }// end function

    }
}
