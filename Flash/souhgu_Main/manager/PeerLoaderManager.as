package manager
{
    import flash.display.*;
    import flash.utils.*;
    import model.*;
    import server.*;
    import util.*;

    public class PeerLoaderManager extends Sprite
    {
        public var peerloadNum:int = 2;
        public var peerloadMaxNum:int = 2;
        public var maxloc:int;
        private var _rp:ReceivePeer;
        public var peerloaderA:Array;
        public var spDic:Dictionary;
        private var loadingDic:Dictionary;
        public var connectingDic:Dictionary;
        private var _spnum:int = 0;
        private var _connum:int = 0;
        private var _minDataIdx:String = "";
        private var blackListDic:Dictionary;
        private var _blacknum:int = 0;
        private var whiteListDic:Dictionary;
        private var _whitenum:int = 0;
        private var isnewloading:Boolean = false;
        private var _oldminix:String = "";
        private var _reidx:int = 0;

        public function PeerLoaderManager()
        {
            this.peerloaderA = new Array();
            this.spDic = new Dictionary();
            this.loadingDic = new Dictionary();
            this.connectingDic = new Dictionary();
            this.blackListDic = new Dictionary();
            this.whiteListDic = new Dictionary();
            return;
        }// end function

        public function initMax() : void
        {
            this.maxloc = (this.peerloadNum != 1 ? (this.peerloadNum * 2 - 1) : (1)) * (ByteSize.CHUNKSIZE / ByteSize.PICESIZE);
            return;
        }// end function

        public function saveLoadingByteMth(param1:Object, param2:LoadFromPeer) : void
        {
            var _loc_3:* = param1.dataInfo.chunkidx + "|" + param1.dataInfo.lowidx;
            this.loadingDic[_loc_3] = param2;
            return;
        }// end function

        public function delLoadingByteMth(param1:Object) : void
        {
            var _loc_2:* = param1.dataInfo.chunkidx + "|" + param1.dataInfo.lowidx;
            this.loadingDic[_loc_2] = null;
            delete this.loadingDic[_loc_2];
            this.minDataIdx();
            return;
        }// end function

        private function minDataIdx() : void
        {
            var _loc_2:String = null;
            var _loc_1:int = -1;
            for (_loc_2 in this.loadingDic)
            {
                
                if (_loc_1 == -1)
                {
                    this._minDataIdx = _loc_2;
                }
                else if (this.isMinDataIdx(this._minDataIdx, _loc_2) < 0)
                {
                    this._minDataIdx = _loc_2;
                }
                _loc_1++;
            }
            if (_loc_1 == -1)
            {
                this._minDataIdx = "";
            }
            return;
        }// end function

        private function isMinDataIdx(param1:String, param2:String) : Number
        {
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:int = 0;
            var _loc_3:* = param1.split("|");
            var _loc_4:* = param2.split("|");
            var _loc_5:* = Number(_loc_3[0]);
            var _loc_6:* = Number(_loc_4[0]);
            var _loc_7:* = Number(_loc_3[1]);
            var _loc_8:* = Number(_loc_4[1]);
            var _loc_9:* = _loc_6 - _loc_5;
            var _loc_10:Number = 0;
            if (_loc_9 != 0)
            {
                _loc_11 = _loc_9 > 0 ? (_loc_6) : (_loc_5);
                _loc_12 = _loc_9 > 0 ? (_loc_5) : (_loc_6);
                _loc_13 = _loc_12;
                while (_loc_13 <= _loc_11)
                {
                    
                    if (_loc_13 == _loc_12)
                    {
                        _loc_10 = _loc_10 + (this._rp._newpeer.p2pSohuLib.chunksMang.getCurPicetotalByChunkidx(_loc_13) - (_loc_9 > 0 ? (_loc_7) : (_loc_8)) + 1);
                    }
                    else if (_loc_13 == _loc_11)
                    {
                        _loc_10 = _loc_10 + ((_loc_9 > 0 ? (_loc_8) : (_loc_7)) + 1);
                    }
                    else
                    {
                        _loc_10 = _loc_10 + this._rp._newpeer.p2pSohuLib.chunksMang.getCurPicetotalByChunkidx(_loc_13);
                    }
                    _loc_13++;
                }
            }
            else
            {
                _loc_10 = _loc_10 + (_loc_8 - _loc_7);
            }
            return _loc_9 < 0 ? (-1 * _loc_10) : (_loc_10);
        }// end function

        public function saveByteMth(param1:Object, param2:LoadFromPeer) : void
        {
            var _loc_4:LoadFromPeer = null;
            var _loc_3:* = param1.chunkidx + "|" + param1.lowidx;
            this.loadingDic[_loc_3] = null;
            delete this.loadingDic[_loc_3];
            this.minDataIdx();
            if (this._minDataIdx != "" && this.isMinDataIdx(this._minDataIdx, _loc_3) >= this.maxloc)
            {
                if (this.isnewloading == false)
                {
                    this.isnewloading = true;
                    this._oldminix = this._minDataIdx;
                    this._reidx = 0;
                }
                else if (this._oldminix == this._minDataIdx)
                {
                    var _loc_5:String = this;
                    var _loc_6:* = this._reidx + 1;
                    _loc_5._reidx = _loc_6;
                    if (this._reidx < this.maxloc)
                    {
                        this._rp._newpeer.p2pSohuLib.chunksMang.savePiceData(param1);
                        return;
                    }
                    this.isnewloading = true;
                    this._oldminix = this._minDataIdx;
                    this._reidx = 0;
                }
                else
                {
                    this.isnewloading = false;
                }
                this._rp._newpeer.p2pSohuLib.showTestInfo("已提前下载  minDataIdx:" + this._minDataIdx + "---nowdl_pice_idx:" + _loc_3 + " offset:" + this.isMinDataIdx(this._minDataIdx, _loc_3));
                _loc_4 = this.loadingDic[this._minDataIdx];
                if (_loc_4 == null)
                {
                    this._rp._newpeer.p2pSohuLib.showTestInfo("人工干预  ---new ip:" + param2.peerinfo.dataInfo.lowidx);
                    this._rp.loadOldData(param2);
                }
                else if (param2 != _loc_4)
                {
                    this._rp._newpeer.p2pSohuLib.showTestInfo("人工干预 del old dataInfo:" + (_loc_4.peerinfo == null ? (null) : (_loc_4.peerinfo.dataInfo)) + "---new ip:" + param2.peerinfo.dataInfo.lowidx);
                    this.delItemMth(_loc_4);
                    this._rp.loadOldData(param2);
                }
                this._rp._newpeer.p2pSohuLib.chunksMang.savePiceData(param1);
            }
            else
            {
                this._rp._newpeer.p2pSohuLib.chunksMang.savePiceData(param1);
            }
            return;
        }// end function

        public function addItemMth(param1:LoadFromPeer) : void
        {
            this.spDic[param1] = param1;
            var _loc_2:String = this;
            var _loc_3:* = this._spnum + 1;
            _loc_2._spnum = _loc_3;
            if (this.connectingDic[param1] != undefined)
            {
                this.connectingDic[param1] = undefined;
                delete this.connectingDic[param1];
                if (this._connum > 0)
                {
                    var _loc_2:String = this;
                    var _loc_3:* = this._connum - 1;
                    _loc_2._connum = _loc_3;
                }
            }
            this._rp._newpeer.p2pSohuLib.showTestInfo("addItemMth  spnum:" + this._spnum + " _connum:" + this._connum);
            return;
        }// end function

        public function addConectMth(param1:LoadFromPeer) : void
        {
            this.connectingDic[param1] = param1;
            var _loc_2:String = this;
            var _loc_3:* = this._connum + 1;
            _loc_2._connum = _loc_3;
            return;
        }// end function

        public function delItemMth(param1:LoadFromPeer) : void
        {
            var _loc_2:Object = null;
            this._rp._newpeer.p2pSohuLib.showTestInfo("delItemMth  farid:" + (param1.farpeerid != null ? (param1.farpeerid.slice(0, 8)) : (null)) + " spnum:" + this._spnum + " _connum:" + this._connum);
            for each (_loc_2 in this.peerloaderA)
            {
                
                if (_loc_2.ld == param1)
                {
                    this.delLDMth(param1);
                    break;
                }
            }
            if (this.spDic[param1] != undefined)
            {
                this.spDic[param1] = null;
                delete this.spDic[param1];
                if (this._spnum > 0)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this._spnum - 1;
                    _loc_3._spnum = _loc_4;
                }
            }
            if (this._connum == 0)
            {
                this._rp.loadFromPeer();
            }
            param1 = null;
            return;
        }// end function

        public function isInPeerLoaderA(param1:String) : Boolean
        {
            var _loc_2:Object = null;
            for each (_loc_2 in this.peerloaderA)
            {
                
                if (_loc_2.ld != null && _loc_2.ld.farpeerid == param1)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function addBlackList(param1:String, param2:int) : void
        {
            if (this.blackListDic[param1] == undefined)
            {
                this._rp._newpeer.p2pSohuLib.showTestInfo("加入黑名单：  peerid:" + param1.slice(0, 8));
                this.blackListDic[param1] = {peeridx:this._rp._newpeer.p2pSohuLib.chunksMang.peerDLIdx, chunkidx:this._rp._newpeer.p2pSohuLib.chunksMang.chunkDLIdx, plus:param2, count:0};
                var _loc_3:String = this;
                var _loc_4:* = this._blacknum + 1;
                _loc_3._blacknum = _loc_4;
            }
            return;
        }// end function

        public function delBlackList(param1:String) : void
        {
            if (this.blackListDic[param1] != undefined)
            {
                this.blackListDic[param1] = null;
                delete this.blackListDic[param1];
                var _loc_2:String = this;
                var _loc_3:* = this._blacknum - 1;
                _loc_2._blacknum = _loc_3;
            }
            return;
        }// end function

        public function isInBlackDic(param1:String) : Boolean
        {
            var _loc_2:int = 0;
            if (this.blackListDic[param1] == undefined)
            {
                return false;
            }
            _loc_2 = ByteSize.CHUNKSIZE / ByteSize.PICESIZE;
            if (this.blackListDic[param1].count > _loc_2 * this.blackListDic[param1].plus)
            {
                this.delBlackList(param1);
                return false;
            }
            var _loc_3:* = this.blackListDic[param1];
            var _loc_4:* = this.blackListDic[param1].count + 1;
            _loc_3.count = _loc_4;
            return true;
        }// end function

        public function seekStopLoadMth() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:Object = null;
            for (_loc_1 in this.blackListDic)
            {
                
                this.blackListDic[_loc_1] = null;
                delete this.blackListDic[_loc_1];
            }
            this._blacknum = 0;
            this.blackListDic = new Dictionary();
            for (_loc_2 in this.connectingDic)
            {
                
                for each (_loc_3 in this.peerloaderA)
                {
                    
                    if (_loc_3.ld != null && _loc_3.ld == this.connectingDic[_loc_2])
                    {
                        this.delLDMth(this.connectingDic[_loc_2]);
                        _loc_3.ld = null;
                    }
                }
            }
            this.connectingDic = new Dictionary();
            this._connum = 0;
            return;
        }// end function

        public function addWhiteList(param1:String) : void
        {
            if (this.whiteListDic[param1] == undefined)
            {
                this.whiteListDic[param1] = {peeridx:this._rp._newpeer.p2pSohuLib.chunksMang.peerDLIdx, chunkidx:this._rp._newpeer.p2pSohuLib.chunksMang.chunkDLIdx};
                var _loc_2:String = this;
                var _loc_3:* = this._whitenum + 1;
                _loc_2._whitenum = _loc_3;
            }
            return;
        }// end function

        private function delLDMth(param1:LoadFromPeer) : void
        {
            var _loc_2:String = null;
            if (this.connectingDic[param1] != undefined)
            {
                this.connectingDic[param1] = undefined;
                delete this.connectingDic[param1];
                if (this._connum > 0)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this._connum - 1;
                    _loc_3._connum = _loc_4;
                }
            }
            this._rp._newpeer.p2pSohuLib.showTestInfo("delLDMth  connum:" + this._connum);
            if (param1.peerinfo != null && param1.peerinfo.dataInfo != undefined)
            {
                _loc_2 = param1.peerinfo.dataInfo.chunkidx + "|" + param1.peerinfo.dataInfo.lowidx;
                this._rp._newpeer.p2pSohuLib.showTestInfo("delLDMth   lowidx:" + param1.peerinfo.dataInfo.lowidx + " chunkidx:" + param1.peerinfo.dataInfo.chunkidx + " nowdl_pice_idx:" + _loc_2);
                this.loadingDic[_loc_2] = null;
                delete this.loadingDic[_loc_2];
                this.minDataIdx();
            }
            param1.gc();
            return;
        }// end function

        public function referMinDataIdx(param1:int) : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            for (_loc_2 in this.loadingDic)
            {
                
                _loc_3 = _loc_2.split("|")[0];
                if (_loc_3 == String(param1))
                {
                    this.loadingDic[_loc_2] = null;
                    delete this.loadingDic[_loc_2];
                    this.minDataIdx();
                }
            }
            return;
        }// end function

        public function getLDIdx(param1:LoadFromPeer) : int
        {
            var _loc_2:int = 0;
            while (_loc_2 < this.peerloadNum)
            {
                
                if (this.peerloaderA[_loc_2].ld == param1)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }// end function

        public function lpGC(param1:String) : void
        {
            var _loc_2:Object = null;
            for each (_loc_2 in this.peerloaderA)
            {
                
                if (_loc_2.ld != null && _loc_2.ld.farpeerid != null && _loc_2.ld.farpeerid == param1)
                {
                    this.delLDMth(_loc_2.ld);
                    _loc_2.ld = null;
                    break;
                }
            }
            return;
        }// end function

        public function clearDiePeer(param1:String) : void
        {
            var _loc_2:Object = null;
            for each (_loc_2 in this.peerloaderA)
            {
                
                if (_loc_2.ld != null && _loc_2.ld.farpeerid != null && _loc_2.ld.farpeerid == param1)
                {
                    this.delLDMth(_loc_2.ld);
                    if (this.spDic[_loc_2.ld] != undefined)
                    {
                        this.spDic[_loc_2.ld] = null;
                        delete this.spDic[_loc_2.ld];
                        if (this._spnum > 0)
                        {
                            var _loc_5:String = this;
                            var _loc_6:* = this._spnum - 1;
                            _loc_5._spnum = _loc_6;
                        }
                    }
                    this._rp._newpeer.p2pSohuLib.showTestInfo("clearDiePeer  dieid:" + param1.slice(0, 8) + " spnum:" + this._spnum + " _connum:" + this._connum);
                    if (this._spnum + this._connum < this._rp._newpeer.p2pSohuLib.config.spnum)
                    {
                        this._rp.loadFromPeer();
                    }
                    _loc_2.ld = null;
                    break;
                }
            }
            return;
        }// end function

        private function clearLdAMth() : void
        {
            var _loc_1:Object = null;
            for each (_loc_1 in this.peerloaderA)
            {
                
                if (_loc_1.ld != null)
                {
                    this.delLDMth(_loc_1.ld);
                    this.spDic[_loc_1.ld] = null;
                    delete this.spDic[_loc_1.ld];
                }
                _loc_1.ld = null;
            }
            this.spDic = new Dictionary();
            this._spnum = 0;
            this.connectingDic = new Dictionary();
            this._connum = 0;
            return;
        }// end function

        public function clearMth(param1:Boolean = true) : void
        {
            var _loc_2:String = null;
            if (!param1)
            {
                this.referDataBack();
            }
            else
            {
                this.clearLdAMth();
            }
            this._minDataIdx = "";
            this.isnewloading = false;
            this._oldminix = "";
            this._reidx = 0;
            for (_loc_2 in this.loadingDic)
            {
                
                this.loadingDic[_loc_2] = null;
                delete this.loadingDic[_loc_2];
            }
            this.loadingDic = new Dictionary();
            return;
        }// end function

        public function referDataBack() : void
        {
            var _loc_1:Object = null;
            return;
            this._minDataIdx = "";
            this.isnewloading = false;
            this._oldminix = "";
            this._reidx = 0;
            return;
        }// end function

        public function set rp(param1:ReceivePeer) : void
        {
            this._rp = param1;
            return;
        }// end function

        public function get spnum() : int
        {
            return this._spnum;
        }// end function

        public function get blacknum() : int
        {
            return this._blacknum;
        }// end function

        public function get connum() : int
        {
            return this._connum;
        }// end function

    }
}
