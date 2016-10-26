package manager
{
    import configbag.*;
    import control.*;
    import flash.events.*;
    import flash.utils.*;
    import model.*;

    public class ChunksManager extends BaseCtrl
    {
        public var streamInIdx:int = 0;
        public var peerInsertIdx:int = 0;
        public var fileDLIdx:int = 0;
        public var chunkDLIdx:int = 0;
        public var peerDLIdx:int = 0;
        private var _dlChunkA:Array;
        private var _chunksMamory:ChunksMemory;
        private var _isloading:Boolean = true;
        private var _isinsertNsData:Boolean = false;
        private var _seekOffset:Number = -1;
        private var _isStopSeek:Boolean = false;
        private var _isSeek:Boolean = false;
        private var _doSeek:Boolean = false;
        private var _seekIdx:int = 0;
        private var _peerDLBeginIdx:int;
        public var npidx:ByteArray;
        public var innpidx:ByteArray;
        private var _waitPiceRange:Boolean = false;
        private var _seekidx:ByteArray;
        private var _isSeekData:Boolean = false;
        private var _idx:int = 0;
        private var _idxMax:int = 0;
        private var npidxo:Object;
        private var _downloadedDataT:Timer;
        private var _seekHeaderData:Boolean = false;

        public function ChunksManager()
        {
            this._dlChunkA = new Array();
            this._chunksMamory = new ChunksMemory();
            this._downloadedDataT = new Timer(50);
            return;
        }// end function

        public function get fileo() : Object
        {
            return this._p2psohu.fileList.fileoA[this.fileDLIdx];
        }// end function

        public function bulidChunks(param1:Array) : void
        {
            this._chunksMamory.bulidChunks(param1);
            return;
        }// end function

        private function checkFileMth(param1:Object) : void
        {
            this.chunkDLIdx = param1.chunkidx;
            this.peerDLIdx = param1.piceidx;
            if (param1.fileidx == this.fileDLIdx)
            {
                return;
            }
            this._p2psohu.showTestInfo("checkFileMth 修改file   oldfile:" + this.fileDLIdx + " new o.file:" + param1.fileidx + " chunkDLIdx:" + param1.chunkidx + " peerDLIdx:" + param1.piceidx);
            if (this.fileDLIdx != param1.fileidx)
            {
                this.fileDLIdx = param1.fileidx;
            }
            if (this.isFileLoaded(param1.fileidx))
            {
                this._p2psohu.showTestInfo("checkFileMth 更新cdnlist    fileDLIdx:" + this.fileDLIdx + "  chunkDLIdx:" + param1.chunkidx + " peerDLIdx:" + param1.piceidx);
                this._p2psohu.referFileInfo(this._p2psohu.fileList.fileoA[this.fileDLIdx], false);
            }
            return;
        }// end function

        private function checkFileIdx(param1:int, param2:Boolean) : void
        {
            if (this.fileDLIdx > param1)
            {
                return;
            }
            var _loc_3:* = this._p2psohu.fileList.fileoA[param1].end_count;
            if (this.chunkDLIdx < _loc_3)
            {
                return;
            }
            if (this.fileDLIdx == param1 && this.chunkDLIdx == _loc_3 && this.peerDLIdx < (this._chunksMamory.chunks[_loc_3].pice_total - 1))
            {
                return;
            }
            this.fileDLIdx = param1 + 1;
            if (this.fileDLIdx == this._p2psohu.fileList.fileoA.length)
            {
                return;
            }
            this._p2psohu.showTestInfo("checkFileIdx  fileDLIdx:" + this.fileDLIdx + " isfrompeer:" + param2);
            var _loc_4:* = param2 ? (this.isFileLoaded(this.fileDLIdx)) : (true);
            if (param2 ? (this.isFileLoaded(this.fileDLIdx)) : (true))
            {
                this._p2psohu.referFileInfo(this._p2psohu.fileList.fileoA[this.fileDLIdx], false);
                this._p2psohu.cdnloader.checkLCFile();
            }
            return;
        }// end function

        private function referChunkIdx() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this.chunkDLIdx + 1;
            _loc_1.chunkDLIdx = _loc_2;
            this.peerDLIdx = 0;
            return;
        }// end function

        private function seekInit() : void
        {
            this.isloading = true;
            this._isinsertNsData = false;
            this._isSeekData = true;
            this.peerDLIdx = 0;
            this._isStopSeek = true;
            return;
        }// end function

        public function getNpRange(param1:Boolean) : Object
        {
            var _loc_2:Boolean = false;
            var _loc_3:Object = null;
            if (this.npidx == null)
            {
                if (param1)
                {
                    return null;
                }
                if (!(this._p2psohu.isSeek || this._isSeekData))
                {
                    return null;
                }
            }
            if (!param1)
            {
                if (!this.isloadingContinue(param1))
                {
                    this._isloading = false;
                    this._p2psohu.showTestInfo("暂停下载  chunkDLIdx:" + this.chunkDLIdx + " streamInIdx:" + this.streamInIdx + " _peerDLBeginIdx:" + this._peerDLBeginIdx);
                    return null;
                }
                return this.getCdnRange();
            }
            else
            {
                _loc_2 = this.getNearDataMth(true);
                if (this.npidx == null)
                {
                    return null;
                }
                _loc_3 = CountIdx.getIdxAsObject(this.npidx);
                if (_loc_3.fileidx == 0 && _loc_3.chunkidx == 0 && _loc_3.piceidx == 0)
                {
                    this._waitPiceRange = true;
                    return null;
                }
                if (this._waitPiceRange)
                {
                    return null;
                }
                return this.getPiceRange();
            }
        }// end function

        private function getPiceRange() : Object
        {
            var _loc_4:Boolean = false;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            var _loc_1:* = this.foundChunkIdx(this.npidx);
            if (_loc_1 == null)
            {
                return null;
            }
            var _loc_2:* = this._chunksMamory.chunks[_loc_1.chunkidx];
            var _loc_3:* = this._chunksMamory.chunks[_loc_1.chunkidx].pices[_loc_1.piceidx];
            if (_loc_3 == null)
            {
                if (_loc_1.fileidx == (this._p2psohu.fileList.fileoA.length - 1) && _loc_1.chunkidx == this._p2psohu.fileList.fileoA[_loc_1.fileidx].end_count)
                {
                    this._p2psohu.showTestInfo("所有任务都领走了。");
                    return null;
                }
                this.npidx = CountIdx.addPiceIdx(this.npidx, this._p2psohu.fileList.fileoA[_loc_1.fileidx].first_count, _loc_2.pice_total, _loc_2.total, this._p2psohu.fileList.fileoA.length, 1);
                if (this.npidx == null)
                {
                    this._p2psohu.showTestInfo("picenull没有新增任务了。");
                    return null;
                }
                this.checkFileMth(CountIdx.getIdxAsObject(this.npidx));
                return this.getPiceRange();
            }
            this.npidx = CountIdx.addPiceIdx(this.npidx, this._p2psohu.fileList.fileoA[_loc_1.fileidx].first_count, _loc_2.pice_total, _loc_2.total, this._p2psohu.fileList.fileoA.length, 1);
            if (_loc_3.type != 2 && _loc_3.type != -1 && _loc_3.type != 1)
            {
                _loc_3.type = 1;
                if (this.npidx == null)
                {
                    _loc_4 = this.getNearDataMth();
                    if (_loc_4)
                    {
                        _loc_5 = CountIdx.getIdxAsObject(this.npidx);
                        if (_loc_5.chunkidx == (this._chunksMamory.chunks.length - 1) && _loc_5.piceidx == (this._chunksMamory.chunks[_loc_5.chunkidx].pice_total - 1))
                        {
                            this._p2psohu.showTestInfo("没有新增任务了。");
                        }
                    }
                    else
                    {
                        this._p2psohu.showTestInfo("没有新增任务了。");
                    }
                }
                else
                {
                    this.checkFileMth(CountIdx.getIdxAsObject(this.npidx));
                }
                this._p2psohu.showTestInfo("pice领任务 fileidx:" + _loc_3.fileidx + " chunkidx:" + _loc_3.chunkidx + " piceidx:" + _loc_3.lowidx);
                return _loc_3;
            }
            else
            {
                if (this.npidx == null)
                {
                    this._p2psohu.showTestInfo("所有任务都领走了。");
                    return null;
                }
                _loc_6 = CountIdx.getIdxAsObject(this.npidx);
                this.chunkDLIdx = _loc_6.chunkidx;
                this.peerDLIdx = _loc_6.piceidx;
                return this.getPiceRange();
            }
        }// end function

        public function searchNpidx() : void
        {
            this.getNearDataMth(false);
            return;
        }// end function

        private function getCdnRange() : Object
        {
            var _loc_1:Boolean = false;
            var _loc_2:Boolean = false;
            var _loc_10:String = null;
            var _loc_15:Object = null;
            var _loc_16:Object = null;
            var _loc_17:Object = null;
            var _loc_18:String = null;
            var _loc_19:Object = null;
            var _loc_20:Object = null;
            var _loc_21:Object = null;
            var _loc_22:String = null;
            var _loc_23:Object = null;
            var _loc_24:Object = null;
            var _loc_25:Object = null;
            var _loc_26:Object = null;
            if (this._p2psohu.isSeek)
            {
                _loc_1 = true;
                _loc_2 = true;
            }
            else if (this._seekOffset == -1)
            {
                _loc_1 = !this._p2psohu.nsPlayTimerMinMth();
            }
            else
            {
                _loc_1 = true;
            }
            if (!_loc_1)
            {
                return null;
            }
            var _loc_3:Boolean = false;
            var _loc_4:* = new Array();
            var _loc_5:Boolean = false;
            var _loc_6:* = this._p2psohu.config.piceGap;
            if (this._p2psohu.isSeek)
            {
                this.npidx = CountIdx.saveIdxAsByte(this.fileDLIdx, this._p2psohu.fileList.fileoA[this.fileDLIdx].first_count, 0);
                _loc_15 = CountIdx.getIdxAsObject(this.npidx);
                _loc_16 = this._chunksMamory.chunks[_loc_15.chunkidx];
                _loc_17 = new Object();
                for (_loc_18 in _loc_16)
                {
                    
                    _loc_17[_loc_18] = _loc_16[_loc_18];
                }
                return this.getSeekData(_loc_17, 4);
            }
            else if (this._isSeekData)
            {
                _loc_19 = CountIdx.getIdxAsObject(this.innpidx);
                this._p2psohu.showTestInfo("getSeekData fileidx:" + _loc_19.fileidx + " chunkidx:" + _loc_19.chunkidx + " piceidx:" + _loc_19.piceidx);
                this.npidx = CountIdx.saveIdxAsByte(_loc_19.fileidx, _loc_19.chunkidx, _loc_19.piceidx);
                _loc_6 = Math.ceil(this._p2psohu.nowF2 / ByteSize.PICESIZE);
                _loc_20 = this._chunksMamory.chunks[CountIdx.getIdxAsObject(this.npidx).chunkidx];
                _loc_21 = new Object();
                for (_loc_22 in _loc_20)
                {
                    
                    _loc_21[_loc_22] = _loc_20[_loc_22];
                }
                if (this._p2psohu.config.isCDNSmall)
                {
                    return this.getCDNSmallDataRange(_loc_21);
                }
                return this.getSeekData(_loc_21, _loc_6);
            }
            _loc_2 = this.getNearDataMth(false);
            if (!_loc_2)
            {
                return null;
            }
            var _loc_7:* = CountIdx.getIdxAsObject(this.npidx);
            var _loc_8:* = this._chunksMamory.chunks[_loc_7.chunkidx];
            var _loc_9:* = new Object();
            for (_loc_10 in _loc_8)
            {
                
                _loc_9[_loc_10] = _loc_8[_loc_10];
            }
            if (this._p2psohu.config.isCDNSmall)
            {
                return this.getCDNSmallDataRange(_loc_9);
            }
            if (_loc_1)
            {
                if (this._p2psohu.config.clarity == "31")
                {
                    _loc_6 = Math.ceil(this._p2psohu.nowF2 / ByteSize.PICESIZE);
                }
                else
                {
                    _loc_6 = Math.ceil((this._p2psohu.nowF2 - this._p2psohu.getNsType()) / ByteSize.PICESIZE);
                }
                if (_loc_6 <= 0)
                {
                    _loc_6 = 1;
                }
            }
            var _loc_11:int = 0;
            while (_loc_11 < _loc_6)
            {
                
                _loc_23 = CountIdx.getIdxAsObject(this.npidx);
                _loc_24 = this._chunksMamory.chunks[_loc_23.chunkidx];
                _loc_25 = this._chunksMamory.chunks[_loc_23.chunkidx].pices[_loc_23.piceidx];
                if (_loc_25.type != 2 && _loc_25.type != -1)
                {
                    _loc_25.type = 1;
                    _loc_4.push(_loc_23);
                    this.npidx = CountIdx.addPiceIdx(this.npidx, this._p2psohu.fileList.fileoA[_loc_23.fileidx].first_count, _loc_24.pice_total, _loc_24.total, this._p2psohu.fileList.fileoA.length, 1);
                    if (this.npidx == null)
                    {
                        this._p2psohu.showTestInfo("所有任务都领走了。");
                        break;
                    }
                    _loc_26 = CountIdx.getIdxAsObject(this.npidx);
                    this.chunkDLIdx = _loc_26.chunkidx;
                    this.peerDLIdx = _loc_26.piceidx;
                    if (_loc_23.fileidx != _loc_26.fileidx)
                    {
                        _loc_5 = true;
                        break;
                    }
                }
                else
                {
                    break;
                }
                _loc_11++;
            }
            if (_loc_4.length == 0)
            {
                return null;
            }
            var _loc_12:* = this.getPiceDLRange(_loc_4[0].chunkidx, _loc_4[0].piceidx);
            _loc_9.begin = _loc_12.begin;
            var _loc_13:* = _loc_4[(_loc_4.length - 1)];
            var _loc_14:* = this.getPiceDLRange(_loc_13.chunkidx, _loc_13.piceidx);
            _loc_9.end = _loc_14.end;
            _loc_9.arridx = _loc_4;
            if (_loc_13.chunkidx == this._p2psohu.fileList.fileoA[_loc_13.fileidx].end_count && _loc_13.piceidx == (this._chunksMamory.chunks[_loc_13.chunkidx].pice_total - 1))
            {
                _loc_5 = true;
            }
            _loc_9.isend = _loc_5;
            this._p2psohu.showTestInfo("cdn领任务 fileidx:" + _loc_9.fileidx + " chunkidx:" + _loc_9.chunkidx + " begin:" + _loc_9.begin + " end:" + _loc_9.end + " isend:" + _loc_5 + " piceidx:" + _loc_4[0].piceidx + " arr.length:" + _loc_4.length + " f1:" + this._p2psohu.config.f1 + " f2:" + this._p2psohu.config.f2 + " nowbyte:" + this._p2psohu.getNsType() + " isseek:" + this._p2psohu.isSeek);
            return _loc_9;
        }// end function

        private function getSeekData(param1:Object, param2:Number) : Object
        {
            var _loc_9:Object = null;
            var _loc_10:Object = null;
            var _loc_11:Object = null;
            var _loc_12:Object = null;
            var _loc_3:Boolean = false;
            var _loc_4:* = new Array();
            var _loc_5:int = 0;
            while (_loc_5 < param2)
            {
                
                _loc_9 = CountIdx.getIdxAsObject(this.npidx);
                _loc_10 = this._chunksMamory.chunks[_loc_9.chunkidx];
                _loc_11 = this._chunksMamory.chunks[_loc_9.chunkidx].pices[_loc_9.piceidx];
                if (_loc_5 != 0 && _loc_9.fileidx != param1.fileidx)
                {
                    _loc_5 = _loc_5 - 1;
                    _loc_3 = true;
                    break;
                }
                if (_loc_11.type != 2)
                {
                    _loc_11.type = 1;
                }
                _loc_4.push(_loc_9);
                this.npidx = CountIdx.addPiceIdx(this.npidx, this._p2psohu.fileList.fileoA[_loc_9.fileidx].first_count, _loc_10.pice_total, _loc_10.total, this._p2psohu.fileList.fileoA.length, 1);
                if (this.npidx == null)
                {
                    this._p2psohu.showTestInfo("所有任务都领走了。");
                    break;
                }
                _loc_12 = CountIdx.getIdxAsObject(this.npidx);
                this.chunkDLIdx = _loc_12.chunkidx;
                this.peerDLIdx = _loc_12.piceidx;
                if (_loc_9.fileidx != _loc_12.fileidx)
                {
                    _loc_3 = true;
                    break;
                }
                _loc_5++;
            }
            var _loc_6:* = this.getPiceDLRange(_loc_4[0].chunkidx, _loc_4[0].piceidx);
            param1.begin = _loc_6.begin;
            var _loc_7:* = _loc_4[(_loc_4.length - 1)];
            var _loc_8:* = this.getPiceDLRange(_loc_7.chunkidx, _loc_7.piceidx);
            param1.end = _loc_8.end;
            param1.arridx = _loc_4;
            if (_loc_7.chunkidx == this._p2psohu.fileList.fileoA[_loc_7.fileidx].end_count && _loc_7.piceidx == (this._chunksMamory.chunks[_loc_7.chunkidx].pice_total - 1))
            {
                _loc_3 = true;
            }
            param1.isend = _loc_3;
            this._p2psohu.showTestInfo("cdn领任务 getSeekData fileidx:" + param1.fileidx + " chunkidx:" + param1.chunkidx + " begin:" + param1.begin + " end:" + param1.end + " isend:" + _loc_3 + " piceidx:" + _loc_4[0].piceidx + " arr.length:" + _loc_4.length + " f1:" + this._p2psohu.config.f1 + " f2:" + this._p2psohu.config.f2 + " nowbyte:" + this._p2psohu.getNsType() + " isseek:" + this._p2psohu.isSeek);
            return param1;
        }// end function

        private function getCDNSmallDataRange(param1:Object) : Object
        {
            var _loc_9:Object = null;
            var _loc_10:Object = null;
            var _loc_2:* = new Array();
            var _loc_3:* = this.fileDLIdx;
            var _loc_4:* = CountIdx.getIdxAsObject(this.npidx);
            var _loc_5:* = CountIdx.getIdxAsObject(this.npidx);
            this._p2psohu.showTestInfo("getCDNSmallDataRange npidx fileidx:" + _loc_5.fileidx + " chunkidx:" + _loc_5.chunkidx + " piceidx:" + _loc_5.piceidx + " nowfileidx:" + _loc_3 + " nowfileidx:" + _loc_4.fileidx);
            while (_loc_3 == _loc_4.fileidx)
            {
                
                _loc_4 = null;
                _loc_5 = CountIdx.getIdxAsObject(this.npidx);
                _loc_9 = this._chunksMamory.chunks[_loc_5.chunkidx];
                _loc_10 = this._chunksMamory.chunks[_loc_5.chunkidx].pices[_loc_5.piceidx];
                if (_loc_10.type == -1)
                {
                    _loc_5 = null;
                    break;
                }
                _loc_10.type = 1;
                _loc_2.push(_loc_5);
                this.npidx = CountIdx.addPiceIdx(this.npidx, this._p2psohu.fileList.fileoA[_loc_5.fileidx].first_count, _loc_9.pice_total, _loc_9.total, this._p2psohu.fileList.fileoA.length, 1);
                if (this.npidx == null)
                {
                    this._p2psohu.showTestInfo("所有任务都领走了。");
                    break;
                }
                _loc_4 = CountIdx.getIdxAsObject(this.npidx);
                this.chunkDLIdx = _loc_4.chunkidx;
                this.peerDLIdx = _loc_4.piceidx;
                _loc_5 = null;
            }
            if (_loc_2.length == 0)
            {
                return null;
            }
            var _loc_6:* = this.getPiceDLRange(_loc_2[0].chunkidx, _loc_2[0].piceidx);
            param1.begin = _loc_6.begin;
            var _loc_7:* = _loc_2[(_loc_2.length - 1)];
            var _loc_8:* = this.getPiceDLRange(_loc_7.chunkidx, _loc_7.piceidx);
            param1.end = _loc_8.end;
            param1.arridx = _loc_2;
            param1.isend = true;
            _loc_6 = null;
            _loc_8 = null;
            this._p2psohu.showTestInfo("getCDNSmallDataRange cdn领任务 fileidx:" + param1.fileidx + " chunkidx:" + param1.chunkidx + " begin:" + param1.begin + " end:" + param1.end + " piceidx:" + _loc_2[0].piceidx + " arr.length:" + _loc_2.length + " f1:" + this._p2psohu.config.f1 + " f2:" + this._p2psohu.config.f2 + " nowbyte:" + this._p2psohu.getNsType() + " isseek:" + this._p2psohu.isSeek);
            return param1;
        }// end function

        private function getNearDataMth(param1:Boolean = true) : Boolean
        {
            var _loc_3:Object = null;
            var _loc_7:Object = null;
            var _loc_8:Object = null;
            var _loc_9:Boolean = false;
            var _loc_10:Object = null;
            var _loc_11:Object = null;
            var _loc_12:Object = null;
            var _loc_13:Boolean = false;
            if (this.innpidx == null || this.npidx == null)
            {
                return false;
            }
            var _loc_2:* = CountIdx.getIdxAsObject(this.npidx);
            var _loc_4:Boolean = false;
            var _loc_5:* = new ByteArray();
            new ByteArray().writeBytes(this.innpidx);
            var _loc_6:* = this.foundChunkIdx(_loc_5);
            if (this.foundChunkIdx(_loc_5) == null)
            {
                return false;
            }
            _loc_3 = CountIdx.getIdxAsObject(_loc_5);
            this._p2psohu.showTestInfo("getNearDataMth npidx bf:" + _loc_2.fileidx + " bc:" + _loc_2.chunkidx + " bp:" + _loc_2.piceidx + " innpidx_temp ef:" + _loc_3.fileidx + " ec:" + _loc_3.chunkidx + "  ep:" + _loc_3.piceidx);
            while (!CountIdx.compareIdxIsBig(_loc_5, this.npidx))
            {
                
                _loc_6 = CountIdx.getIdxAsObject(_loc_5);
                _loc_7 = this._chunksMamory.chunks[_loc_6.chunkidx];
                _loc_8 = this._chunksMamory.chunks[_loc_6.chunkidx].pices[_loc_6.piceidx];
                _loc_9 = param1 ? (_loc_8.type != 2) : (true);
                if (_loc_8.type != 2 && _loc_8.type != -1 && _loc_9)
                {
                    this.npidx = _loc_5;
                    return true;
                }
                _loc_5 = CountIdx.addPiceIdx(_loc_5, this._p2psohu.fileList.fileoA[_loc_6.fileidx].first_count, _loc_7.pice_total, _loc_7.total, this._p2psohu.fileList.fileoA.length, 1);
                if (_loc_5 == null)
                {
                    return false;
                }
            }
            _loc_2 = CountIdx.getIdxAsObject(_loc_5);
            this._p2psohu.showTestInfo("getNearDataMth innpidx_temp bf:" + _loc_2.fileidx + " bc:" + _loc_2.chunkidx + " bp:" + _loc_2.piceidx);
            while (_loc_5 != null)
            {
                
                _loc_10 = CountIdx.getIdxAsObject(_loc_5);
                _loc_11 = this._chunksMamory.chunks[_loc_10.chunkidx];
                _loc_12 = this._chunksMamory.chunks[_loc_10.chunkidx].pices[_loc_10.piceidx];
                this._p2psohu.showTestInfo("getNearDataMth 2 bf:" + _loc_10.fileidx + " bc:" + _loc_10.chunkidx + " bp:" + _loc_10.piceidx);
                _loc_13 = param1 ? (_loc_12.type != 1) : (true);
                if (_loc_12.type != 2 && _loc_12.type != -1 && _loc_13)
                {
                    this.npidx = _loc_5;
                    return true;
                }
                _loc_5 = CountIdx.addPiceIdx(_loc_5, this._p2psohu.fileList.fileoA[_loc_10.fileidx].first_count, _loc_11.pice_total, _loc_11.total, this._p2psohu.fileList.fileoA.length, 1);
            }
            this.npidx = _loc_5;
            return false;
        }// end function

        private function foundChunkIdx(param1:ByteArray) : Object
        {
            var _loc_2:* = CountIdx.getIdxAsObject(param1);
            var _loc_3:* = this._chunksMamory.chunks[_loc_2.chunkidx];
            var _loc_4:* = _loc_2.chunkidx;
            while (_loc_3.type == 2 || _loc_3.type == -1)
            {
                
                _loc_4++;
                _loc_2.piceidx = 0;
                _loc_3 = this._chunksMamory.chunks[_loc_4];
                if (_loc_3 == null)
                {
                    return null;
                }
            }
            _loc_2.chunkidx = _loc_4;
            _loc_2.fileidx = _loc_3.fileidx;
            param1 = CountIdx.saveIdxAsByte(_loc_2.fileidx, _loc_2.chunkidx, _loc_2.piceidx);
            return _loc_2;
        }// end function

        public function getDataRange() : Object
        {
            return this.getNpRange(false);
        }// end function

        public function getPiceDataMth() : Object
        {
            return this.getNpRange(true);
        }// end function

        public function insertLastData() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Object = null;
            while (this.innpidx != null)
            {
                
                _loc_1 = CountIdx.getIdxAsObject(this.innpidx);
                this.streamInIdx = _loc_1.chunkidx;
                _loc_2 = this._chunksMamory.chunks[_loc_1.chunkidx].pices[_loc_1.piceidx];
                if (_loc_2.type == 2 && _loc_2.type != -1)
                {
                    this._p2psohu.streamMang.nsAppendBytes(_loc_2);
                    this.referStreamIdx();
                    continue;
                }
                break;
            }
            return;
        }// end function

        public function insertLoadedData(event:TimerEvent = null) : void
        {
            this.insertDataToNs();
            return;
        }// end function

        public function referChunkData(param1:Object) : void
        {
            var _loc_6:Object = null;
            var _loc_7:ByteArray = null;
            if (this._p2psohu.isAllDie || this._p2psohu.isAllLoadedOver)
            {
                return;
            }
            if (param1.clarity != this._p2psohu.config.clarity || this._seekOffset != -1)
            {
                return;
            }
            this._p2psohu.showTestInfo("referChunkData fileidx:" + param1.fileidx + " dataIdx:" + param1.dataIdx + " chunkidx:" + param1.chunkidx + " chunk type:" + this._chunksMamory.chunks[param1.chunkidx].type + " piceidx:" + param1.arridx[0].piceidx);
            var _loc_2:Boolean = true;
            var _loc_3:* = param1.arridx.length - 1;
            while (_loc_3 > -1)
            {
                
                _loc_6 = this._chunksMamory.chunks[param1.arridx[_loc_3].chunkidx].pices[param1.arridx[_loc_3].piceidx];
                if (_loc_6.type != 2 && _loc_6.type != -1)
                {
                    this._chunksMamory.chunks[param1.arridx[_loc_3].chunkidx].pices[param1.arridx[_loc_3].piceidx].type = 0;
                    _loc_2 = false;
                }
                _loc_3 = _loc_3 - 1;
            }
            if (_loc_2)
            {
                return;
            }
            var _loc_4:* = CountIdx.saveIdxAsByte(param1.arridx[0].fileidx, param1.arridx[0].chunkidx, param1.arridx[0].piceidx);
            if (this.npidx == null)
            {
                this.npidx = _loc_4;
            }
            else
            {
                _loc_7 = this.referNpidx(_loc_4);
                if (_loc_7 != null)
                {
                    this.npidx = _loc_7;
                }
            }
            var _loc_5:* = CountIdx.getIdxAsObject(this.npidx);
            this._p2psohu.showTestInfo("referChunkData  referdatalist:===new chunkidx:" + _loc_5.chunkidx + " piceidx:" + _loc_5.piceidx + " streamInIdx:" + this.streamInIdx + " old chunkDLIdx:" + this.chunkDLIdx + " old peerdlidx:" + this.peerDLIdx + " back fileidx:" + param1.arridx[0].fileidx + " back chunkidx:" + param1.arridx[0].chunkidx + " back piceidx:" + param1.arridx[0].piceidx);
            this.checkFileMth(_loc_5);
            return;
        }// end function

        public function referPiceData(param1:Object) : void
        {
            var _loc_4:ByteArray = null;
            if (this._p2psohu.isAllDie || this._p2psohu.isAllLoadedOver)
            {
                return;
            }
            if (this._chunksMamory.chunks[param1.chunkidx].pices[param1.lowidx].type == 2)
            {
                return;
            }
            var _loc_2:* = CountIdx.saveIdxAsByte(param1.fileidx, param1.chunkidx, param1.lowidx);
            if (this.npidx == null)
            {
                this.npidx = _loc_2;
            }
            else
            {
                _loc_4 = this.referNpidx(_loc_2);
                if (_loc_4 != null)
                {
                    this.npidx = _loc_4;
                }
            }
            if (this.npidx == null)
            {
                return;
            }
            var _loc_3:* = CountIdx.getIdxAsObject(this.npidx);
            this._p2psohu.showTestInfo("referPiceData:=== old peerDLIdx:" + this.peerDLIdx + " chunkDLIdx:" + this.chunkDLIdx + " new chunkidx:" + _loc_3.chunkidx + " new lowidx:" + _loc_3.piceidx);
            this._chunksMamory.chunks[param1.chunkidx].pices[param1.lowidx].type = 0;
            return;
        }// end function

        private function referNpidx(param1:ByteArray) : ByteArray
        {
            var _loc_2:* = CountIdx.getIdxAsObject(param1);
            if (this.innpidx == null)
            {
                this.innpidx = CountIdx.saveIdxAsByte(this.fileDLIdx, this.chunkDLIdx, this.peerInsertIdx);
            }
            var _loc_3:* = CountIdx.getIdxAsObject(this.innpidx);
            if (_loc_2.fileidx > _loc_3.fileidx)
            {
                return CountIdx.getLowestIdx(this.npidx, param1);
            }
            if (_loc_2.fileidx == _loc_3.fileidx)
            {
                if (_loc_2.chunkidx > _loc_3.chunkidx)
                {
                    return CountIdx.getLowestIdx(this.npidx, param1);
                }
                if (_loc_2.chunkidx == _loc_3.chunkidx && _loc_2.piceidx > _loc_3.piceidx)
                {
                    return CountIdx.getLowestIdx(this.npidx, param1);
                }
            }
            return null;
        }// end function

        public function cdnDataLoadedOver(param1:Array) : void
        {
            var _loc_5:Object = null;
            var _loc_2:* = param1[0].chunkidx;
            var _loc_3:* = param1.length;
            if (this._dlChunkA.indexOf(_loc_2) != -1 && this._dlChunkA.indexOf(param1[(_loc_3 - 1)].chunkidx) != -1)
            {
                return;
            }
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (this._p2psohu.isAllLoadedOver)
                {
                    break;
                }
                _loc_5 = this._chunksMamory.chunks[param1[_loc_4].chunkidx].pices[param1[_loc_4].piceidx];
                this.piceLoadedOver(_loc_5);
                _loc_4++;
            }
            this.getNearDataMth(false);
            if (this.npidx != null)
            {
                this.checkFileMth(CountIdx.getIdxAsObject(this.npidx));
            }
            return;
        }// end function

        private function piceLoadedOver(param1:Object) : void
        {
            var _loc_2:* = this._chunksMamory.chunks[param1.chunkidx];
            var _loc_3:Boolean = false;
            _loc_3 = _loc_2.dlnum == _loc_2.pice_total ? (true) : (false);
            var _loc_4:* = this._p2psohu.fileList.fileoA[param1.fileidx].end_count;
            var _loc_5:* = param1.chunkidx == _loc_4 ? (true) : (false);
            if ((param1.chunkidx == _loc_4 ? (true) : (false)) && param1.lowidx == (this._chunksMamory.chunks[_loc_4].pice_total - 1))
            {
                this.checkFileIdx(param1.fileidx, param1.isfrompeer);
            }
            var _loc_6:Boolean = false;
            if (_loc_3 && this._dlChunkA.indexOf(param1.chunkidx) == -1)
            {
                this.saveChunkCD(_loc_2);
                _loc_2.type = 2;
                _loc_6 = true;
                this._dlChunkA.push(param1.chunkidx);
                if (param1.chunkidx == (this._chunksMamory.chunks.length - 1) && this.dataLoadedOver())
                {
                    this.p2pSohuLib.allFileoLoadedOver();
                }
                this._p2psohu.filesManager.sendAddPeerInfo(param1);
            }
            this._p2psohu.filesManager.sendStaticMth(param1);
            return;
        }// end function

        private function dataLoadedOver() : Boolean
        {
            var _loc_1:* = new ByteArray();
            _loc_1.writeBytes(this.innpidx);
            var _loc_2:* = CountIdx.getIdxAsObject(_loc_1);
            var _loc_3:Boolean = true;
            var _loc_4:* = this._chunksMamory.chunks[_loc_2.chunkidx];
            var _loc_5:* = this._chunksMamory.chunks[_loc_2.chunkidx].pices[_loc_2.piceidx].type;
            if (this._chunksMamory.chunks[_loc_2.chunkidx].pices[_loc_2.piceidx].type != 2 && _loc_5 != -1)
            {
                _loc_3 = false;
            }
            else
            {
                while (_loc_5 == 2)
                {
                    
                    _loc_1 = CountIdx.addPiceIdx(_loc_1, this._p2psohu.fileList.fileoA[_loc_2.fileidx].first_count, _loc_4.pice_total, _loc_4.total, this._p2psohu.fileList.fileoA.length, 1);
                    if (_loc_1 == null)
                    {
                        break;
                    }
                    _loc_2 = CountIdx.getIdxAsObject(_loc_1);
                    _loc_4 = this._chunksMamory.chunks[_loc_2.chunkidx];
                    _loc_5 = _loc_4.pices[_loc_2.piceidx].type;
                    if (_loc_5 != 2 && _loc_5 != -1)
                    {
                        this._p2psohu.showTestInfo("dataLoadedOver fileidx:chunkidx:piceidx:" + _loc_2.fileidx + ":" + _loc_2.chunkidx + ":" + _loc_2.piceidx);
                        _loc_3 = false;
                        break;
                    }
                }
            }
            return _loc_3;
        }// end function

        public function checkMemoryAndIdx(param1:Boolean) : void
        {
            if (this._chunksMamory.realDLSize >= ByteSize.SHAREMEMORY)
            {
                this.delOldChunk(this.findOldChunk());
            }
            if (this.isloadingContinue(param1))
            {
                this.continueLoadData(param1);
            }
            else
            {
                this._isloading = false;
            }
            return;
        }// end function

        public function isloadingContinue(param1:Boolean) : Boolean
        {
            if (this._p2psohu.isSeek)
            {
                return true;
            }
            if (!param1)
            {
                return this._p2psohu.getNsType("isLoadingContinue");
            }
            return true;
        }// end function

        private function findOldChunk() : int
        {
            var _loc_3:int = 0;
            return this._dlChunkA[0];
            if (this.streamInIdx > _loc_1)
            {
                return _loc_1;
            }
            if (this.streamInIdx <= _loc_1)
            {
                this._p2psohu.showlog("内存已满，且instream不在内存空间内，删除最大的chunk max_chunkidx:" + _loc_2);
                return _loc_2;
            }
            return _loc_1;
        }// end function

        private function continueLoadData(param1:Boolean) : void
        {
            this._isloading = true;
            var _loc_2:* = this._chunksMamory.chunks[this.chunkDLIdx];
            if (_loc_2 == null)
            {
                return;
            }
            if (param1)
            {
                this._p2psohu.peer.receivePeer.beginP2PMth();
            }
            else
            {
                return;
            }
            return;
        }// end function

        public function resumeDowloadMth() : void
        {
            this._p2psohu.showTestInfo("恢复下载   chunkDLIdx:" + this.chunkDLIdx + " streamInIdx:" + this.streamInIdx);
            if (this.chunkDLIdx >= this._chunksMamory.chunks.length)
            {
                return;
            }
            this._peerDLBeginIdx = this.chunkDLIdx;
            this.continueLoadData(this._p2psohu.config.isRP);
            return;
        }// end function

        public function changeToCdn() : void
        {
            this._p2psohu.showTestInfo("changeToCdn");
            this._p2psohu.config.isRP = false;
            this._p2psohu.setCdnAndCdnGap(1, 2);
            this._p2psohu.cdnloader.loadFileMth();
            return;
        }// end function

        private function changeToPeer() : void
        {
            this._p2psohu.showTestInfo("changeToPeer");
            this._p2psohu.config.isRP = true;
            this._peerDLBeginIdx = this.chunkDLIdx;
            this._p2psohu.setCdnAndCdnGap(1, 0);
            this._p2psohu.filesManager.sendcdnlog();
            return;
        }// end function

        public function saveChunkData(param1:Object) : void
        {
            var _loc_3:Boolean = false;
            var _loc_4:Object = null;
            var _loc_5:Boolean = false;
            if (this._isSeekData)
            {
                this._isSeekData = false;
            }
            if (param1.chunkidx == 32)
            {
                trace();
            }
            this._chunksMamory.savePiceData(param1);
            var _loc_2:* = this._chunksMamory.chunks[param1.chunkidx].pices[param1.lowidx];
            _loc_2.isfrompeer = false;
            if (this._p2psohu.config.isCrc)
            {
                _loc_3 = this.checkCrc(_loc_2, false);
                if (_loc_3)
                {
                    this._chunksMamory.chunks[param1.chunkidx].pices[param1.lowidx].type = 0;
                    this.referPiceData(this._chunksMamory.chunks[param1.chunkidx].pices[param1.lowidx]);
                    return;
                }
            }
            if (this._p2psohu.isSeek)
            {
                _loc_4 = this.getChunkInfo(this._p2psohu.fileList.fileoA[this.fileDLIdx].first_count);
                _loc_5 = true;
                if (this._seekHeaderData == false && _loc_5)
                {
                    this._seekHeaderData = this._p2psohu.chunksMang.headLoaded();
                }
                if (this._seekHeaderData == false)
                {
                    this.checkMemoryAndIdx(false);
                }
                else if (this._p2psohu.cdnloader.isCdnLoading == false)
                {
                    this._p2psohu.continueSeek();
                }
            }
            else
            {
                if (this._waitPiceRange)
                {
                    this._waitPiceRange = false;
                    this._p2psohu.peer.receivePeer.beginP2PMth();
                }
                this.checkMemoryAndIdx(false);
            }
            (param1.ba as ByteArray).clear();
            param1.ba = undefined;
            param1 = null;
            return;
        }// end function

        public function savePiceData(param1:Object) : void
        {
            var _loc_4:Boolean = false;
            this._chunksMamory.savePiceData(param1);
            var _loc_2:* = this._chunksMamory.chunks[param1.chunkidx];
            var _loc_3:* = _loc_2.pices[param1.lowidx];
            if (this._p2psohu.config.isCrc)
            {
                _loc_4 = this.checkCrc(_loc_3, true);
                if (_loc_4)
                {
                    this._chunksMamory.chunks[param1.chunkidx].pices[param1.lowidx].type = 0;
                    this.referPiceData(this._chunksMamory.chunks[param1.chunkidx].pices[param1.lowidx]);
                    return;
                }
            }
            _loc_3.isfrompeer = true;
            this.piceLoadedOver(_loc_3);
            this.checkMemoryAndIdx(true);
            (param1.ba as ByteArray).clear();
            param1.ba = undefined;
            param1 = null;
            return;
        }// end function

        public function checkChunkLoadedOver(param1:int) : Boolean
        {
            var _loc_4:Object = null;
            var _loc_2:* = this._chunksMamory.chunks[param1];
            if (_loc_2.type == 2 || _loc_2.type == -1)
            {
                return true;
            }
            return false;
            return true;
        }// end function

        private function checkAllPiceLoaded(param1:Object, param2:int) : Boolean
        {
            var _loc_3:Object = null;
            if (param2 == (param1.pice_total - 1))
            {
                for each (_loc_3 in param1.pices)
                {
                    
                    if (_loc_3.type != 2 && _loc_3.type != -1 || _loc_3.datawrong == 1)
                    {
                        return false;
                    }
                }
                return true;
            }
            return false;
        }// end function

        private function saveChunkCD(param1:Object) : void
        {
            var _loc_3:Object = null;
            var _loc_4:uint = 0;
            if (this._chunksMamory.chunks[param1.chunkidx].cd != undefined)
            {
                return;
            }
            var _loc_2:* = new ByteArray();
            for each (_loc_3 in param1.pices)
            {
                
                _loc_2.writeUnsignedInt(_loc_3.cd);
            }
            if (this._p2psohu.config.hasCd)
            {
                _loc_4 = this.getCompressData(_loc_2);
                this._chunksMamory.chunks[param1.chunkidx].cd = _loc_4;
            }
            _loc_2.clear();
            return;
        }// end function

        private function checkCrc(param1:Object, param2:Boolean) : Boolean
        {
            var _loc_5:int = 0;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:int = 0;
            var _loc_3:Boolean = false;
            var _loc_4:* = param1.dataIdx * (ByteSize.CHUNKSIZE / ByteSize.PICESIZE) + param1.lowidx;
            if (this._p2psohu.crcCtrl.crcA.length == 0)
            {
                return false;
            }
            if (this._p2psohu.crcCtrl.crcA[param1.fileidx] == undefined || this._p2psohu.crcCtrl.crcA[param1.fileidx][_loc_4] == undefined)
            {
                return false;
            }
            if (this._p2psohu.crcCtrl.crcA[param1.fileidx][_loc_4] == "")
            {
                this._p2psohu.showTestInfo("@@@@@ wrongcrc crc idx:" + _loc_4 + " fileidx:" + param1.fileidx + " chunkidx:" + param1.chunkidx + " piceidx:" + param1.lowidx + " piceo.crc:" + param1.crc + " crc:" + this._p2psohu.crcCtrl.crcA[param1.fileidx][_loc_4] + " cdnfilename:" + this._p2psohu.fileList.fileoA[param1.fileidx].cdnfilename + " isfrompeer:" + param2);
                return false;
            }
            if (param1.crc != this._p2psohu.crcCtrl.crcA[param1.fileidx][_loc_4])
            {
                _loc_5 = param1.crc.length;
                _loc_6 = param1.crc;
                _loc_7 = "";
                if (_loc_5 < 8)
                {
                    _loc_8 = _loc_5;
                    while (_loc_8 < 8)
                    {
                        
                        _loc_7 = _loc_7 + "0";
                        _loc_8++;
                    }
                }
                param1.crc = _loc_7 + _loc_6;
                if (param1.crc != this._p2psohu.crcCtrl.crcA[param1.fileidx][_loc_4])
                {
                    _loc_3 = true;
                    this._p2psohu.showTestInfo("@@@@@ wrongcrc crc idx:" + _loc_4 + " fileidx:" + param1.fileidx + " chunkidx:" + param1.chunkidx + " piceidx:" + param1.lowidx + " piceo.crc:" + param1.crc + " crc:" + this._p2psohu.crcCtrl.crcA[param1.fileidx][_loc_4] + " cdnfilename:" + this._p2psohu.fileList.fileoA[param1.fileidx].cdnfilename + " isfrompeer:" + param2);
                }
            }
            return false;
        }// end function

        private function sendDataToNs(param1:Boolean, param2:Boolean = false) : void
        {
            var _loc_3:Object = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            if (this._isinsertNsData)
            {
                if (this._doSeek)
                {
                    this._doSeek = false;
                    var _loc_7:String = this;
                    var _loc_8:* = this._seekIdx + 1;
                    _loc_7._seekIdx = _loc_8;
                    this._p2psohu.ns.seekClearData();
                }
                if (param1)
                {
                    _loc_3 = CountIdx.getIdxAsObject(this.innpidx);
                    this.peerInsertIdx = _loc_3.piceidx;
                    _loc_4 = this._chunksMamory.chunks[_loc_3.chunkidx].pices[this.peerInsertIdx];
                    if (_loc_4.type == 2)
                    {
                        this._p2psohu.showTestInfo("sendDataToNs 塞----peer数据 peerInsertIdx:" + this.peerInsertIdx + " total:" + this._chunksMamory.chunks[_loc_3.chunkidx].total + " lowtotal:" + _loc_4.lowtotal + " type:" + _loc_4.type);
                        this._p2psohu.streamMang.nsAppendBytes(_loc_4);
                        this.referStreamIdx();
                        if (this._seekIdx != 0)
                        {
                            if (_loc_3.chunkidx >= this._chunksMamory.chunks.length - 2 || this._chunksMamory.chunks.length < 30 && this._p2psohu.fileList.fileoA.length < 4)
                            {
                                this._seekIdx = 0;
                                this._p2psohu.ns.seekResumeMth();
                            }
                            else if (this._seekIdx * ByteSize.PICESIZE > ByteSize.SEEKSECOND * Config.getInstance().bufv || this._chunksMamory.chunks.length < 30 && this._p2psohu.fileList.fileoA.length < 4)
                            {
                                trace("_seekIdx:" + this._seekIdx);
                                this._seekIdx = 0;
                                this._p2psohu.ns.seekResumeMth();
                            }
                            else
                            {
                                var _loc_7:String = this;
                                var _loc_8:* = this._seekIdx + 1;
                                _loc_7._seekIdx = _loc_8;
                            }
                        }
                        this._p2psohu.streamMang.checkNsMemory();
                        if (this._isinsertNsData)
                        {
                            this.insertDataToNs();
                            return;
                        }
                        if (this._downloadedDataT.running)
                        {
                            this._downloadedDataT.removeEventListener(TimerEvent.TIMER, this.insertLoadedData);
                            this._downloadedDataT.stop();
                        }
                    }
                }
                else
                {
                    _loc_5 = CountIdx.getIdxAsObject(this.innpidx);
                    _loc_6 = this._chunksMamory.chunks[_loc_5.chunkidx];
                    if (_loc_6.type == 2)
                    {
                        this._p2psohu.streamMang.nsAppendBytes(_loc_6);
                    }
                }
            }
            return;
        }// end function

        private function referStreamIdx(param1:int = 1) : void
        {
            var _loc_2:Object = null;
            if (this.innpidx == null)
            {
                _loc_2.fileidx = 0;
                _loc_2.chunkidx = 0;
                _loc_2.piceidx = 0;
            }
            else
            {
                _loc_2 = CountIdx.getIdxAsObject(this.innpidx);
            }
            this._p2psohu.showTestInfo("referStreamIdx  b--fileidx:" + _loc_2.fileidx + " chunkidx:" + _loc_2.chunkidx + " piceidx:" + _loc_2.piceidx);
            var _loc_3:* = this._chunksMamory.chunks[_loc_2.chunkidx];
            this.innpidx = CountIdx.addPiceIdx(this.innpidx, this._p2psohu.fileList.fileoA[_loc_2.fileidx].first_count, _loc_3.pice_total, _loc_3.total, this._p2psohu.fileList.fileoA.length, param1);
            if (this.innpidx == null)
            {
                return;
            }
            var _loc_4:* = CountIdx.getIdxAsObject(this.innpidx);
            this.streamInIdx = _loc_4.chunkidx;
            this.peerInsertIdx = _loc_4.piceidx;
            this._p2psohu.showTestInfo("referStreamIdx  innpidx:" + (this.innpidx == null ? (null) : ("not null")) + " new--fileidx:" + _loc_2.fileidx + " streamInIdx:" + _loc_2.chunkidx + " peerInsertIdx:" + _loc_2.piceidx);
            return;
        }// end function

        public function insertDataToNs() : void
        {
            var _loc_4:Boolean = false;
            if (this.innpidx == null)
            {
                return;
            }
            var _loc_1:* = CountIdx.getIdxAsObject(this.innpidx);
            this.streamInIdx = _loc_1.chunkidx;
            this.peerInsertIdx = _loc_1.piceidx;
            var _loc_2:* = this._chunksMamory.chunks[_loc_1.chunkidx];
            var _loc_3:* = _loc_2.pices[_loc_1.piceidx];
            if (_loc_3.type == 2)
            {
                this._p2psohu.showTestInfo("重新启动塞入数据 type:" + _loc_3.type + " fileidx:" + _loc_1.fileidx + " streamInIdx:" + _loc_1.chunkidx + " piceidx:" + _loc_1.piceidx + " begin:" + _loc_2.begin + " end:" + _loc_2.end + " _isloading:" + this._isloading + " seekoffset:" + this.seekOffset + " isinsertNsData:" + this.isinsertNsData + " _downloadedDataT.run:" + this._downloadedDataT.running);
            }
            if (_loc_3.type == -1)
            {
                this._p2psohu.showTestInfo("重新启动塞入数据 type:" + _loc_3.type);
                this.referStreamIdx();
                if (this._seekOffset != -1)
                {
                    this.chunkDLIdx = this.streamInIdx;
                }
                this.insertDataToNs();
                return;
            }
            if (_loc_3.type == 2)
            {
                this._isinsertNsData = true;
                _loc_4 = false;
                this.insertLoadedDataToNs(_loc_4);
            }
            else
            {
                this._isinsertNsData = false;
                if (this._downloadedDataT.running)
                {
                    this._downloadedDataT.removeEventListener(TimerEvent.TIMER, this.insertLoadedData);
                    this._downloadedDataT.stop();
                }
            }
            return;
        }// end function

        private function insertLoadedDataToNs(param1:Boolean) : void
        {
            this.sendDataToNs(true, param1);
            this._isinsertNsData = false;
            return;
        }// end function

        private function getCurFileDLSize(param1:int, param2:int = -1) : Number
        {
            var _loc_5:int = 0;
            if (this._p2psohu.fileList.fileoA == null || this._p2psohu.fileList.fileoA.length == 0)
            {
                param1 = 0;
                return 0;
            }
            if (param1 >= this._p2psohu.fileList.fileoA.length)
            {
                param1 = this._p2psohu.fileList.fileoA.length - 1;
            }
            if (param2 >= this._chunksMamory.chunks.length)
            {
                param2 = this._chunksMamory.chunks.length - 1;
            }
            var _loc_3:Number = 0;
            var _loc_4:int = 0;
            while (_loc_4 < param1)
            {
                
                _loc_3 = _loc_3 + this._p2psohu.fileList.fileoA[_loc_4].size;
                _loc_4++;
            }
            if (param2 != -1)
            {
                _loc_5 = this._p2psohu.fileList.fileoA[param1].first_count;
                while (_loc_5 <= param2)
                {
                    
                    _loc_3 = _loc_3 + this._chunksMamory.chunks[_loc_5].dlsize;
                    _loc_5++;
                }
            }
            return _loc_3;
        }// end function

        public function checkDLChunkA() : void
        {
            if (this._dlChunkA.length > ByteSize.SHAREMEMORY / ByteSize.CHUNKSIZE)
            {
                this.delOldChunk(this.findOldChunk());
            }
            return;
        }// end function

        private function delOldChunk(param1:int) : void
        {
            var _loc_2:* = this._dlChunkA.indexOf(param1);
            this._dlChunkA.splice(_loc_2, 1);
            this._p2psohu.showTestInfo("delOldChunk  idx:" + param1 + " _dlChunkA.length:" + this._dlChunkA.length);
            this._chunksMamory.delOldChunk(param1);
            this.delChunkInfo(param1);
            return;
        }// end function

        public function delChunkInfo(param1:int) : void
        {
            if (this._p2psohu.filesManager.nsChunkDic[param1] == undefined)
            {
                return;
            }
            var _loc_2:* = this._chunksMamory.chunks[param1];
            var _loc_3:* = this._p2psohu.fileList.fileoA[_loc_2.fileidx].filename + _loc_2.dataIdx;
            this._p2psohu.showTestInfo("delfile  fileidx:" + _loc_2.fileidx + " chunkidx:" + param1 + " dataIdx:" + _loc_2.dataIdx + " filename:" + _loc_3);
            this._p2psohu.trackSocket.sendMsgMth("delfile", _loc_3);
            this._p2psohu.filesManager.delOldNsInf(param1);
            return;
        }// end function

        public function seekMth(param1:Number, param2:int) : void
        {
            if (this._isStopSeek)
            {
                return;
            }
            this._isSeek = true;
            this._doSeek = true;
            this.seekInit();
            this.seekOffset = param1;
            var _loc_3:* = this.getSeekLoc(param2);
            this.streamInIdx = _loc_3.streamidx;
            this.peerInsertIdx = _loc_3.peerinsertidx;
            var _loc_4:Boolean = false;
            if (this.chunkDLIdx != this.streamInIdx)
            {
                _loc_4 = true;
            }
            this.chunkDLIdx = this.streamInIdx;
            this.peerDLIdx = this.peerInsertIdx;
            this.npidx = CountIdx.saveIdxAsByte(this.fileDLIdx, this.chunkDLIdx, this.peerInsertIdx);
            this.innpidx = CountIdx.saveIdxAsByte(this.fileDLIdx, this.chunkDLIdx, this.peerInsertIdx);
            this._seekidx = CountIdx.saveIdxAsByte(this.fileDLIdx, this.chunkDLIdx, this.peerInsertIdx);
            var _loc_5:* = this.hasMoreData();
            this._p2psohu.showTestInfo("seekMth streamInIdx:" + this.streamInIdx + " peerInsertIdx:" + this.peerInsertIdx + " chunkDLIdx:" + this.chunkDLIdx + " fileDLIdx:" + this.fileDLIdx + " seekfileidx:" + param2 + " seekOffset:" + this.seekOffset + " isdif:" + _loc_4 + " cdn connum:" + this._p2psohu.cdnloader.cdnldmang.connum + " hasmoredata:" + _loc_5 + " file size:" + this._p2psohu.fileList.fileoA[param2].size);
            this._p2psohu.streamMang.resumeTimer();
            if (_loc_5)
            {
                this._isSeekData = false;
                this._waitPiceRange = false;
            }
            else
            {
                this._p2psohu.ns.seekStartMth();
                this._p2psohu.cdnloader.loadFileMth();
            }
            this._p2psohu.peer.receivePeer.beginP2PMth();
            return;
        }// end function

        private function hasMoreData() : Boolean
        {
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            var _loc_1:* = Math.ceil(this._p2psohu.config.f2 / ByteSize.PICESIZE);
            var _loc_2:Boolean = true;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_1)
            {
                
                _loc_4 = CountIdx.getIdxAsObject(this._seekidx);
                _loc_5 = this._chunksMamory.chunks[_loc_4.chunkidx];
                _loc_6 = this._chunksMamory.chunks[_loc_4.chunkidx].pices[_loc_4.piceidx];
                if (_loc_6.type != 2 && _loc_6.type != -1)
                {
                    _loc_2 = false;
                    break;
                }
                this._seekidx = CountIdx.addPiceIdx(this._seekidx, this._p2psohu.fileList.fileoA[_loc_4.fileidx].first_count, _loc_5.pice_total, _loc_5.total, this._p2psohu.fileList.fileoA.length, 1);
                if (this._seekidx == null)
                {
                    this._p2psohu.showTestInfo("所有任务都领走了。");
                    _loc_2 = true;
                    break;
                }
                _loc_3++;
            }
            if (this._seekidx != null)
            {
                this._seekidx.clear();
            }
            return _loc_2;
        }// end function

        public function headLoaded() : Boolean
        {
            var _loc_1:* = this.getChunkInfo(this._p2psohu.fileList.fileoA[this.fileDLIdx].first_count);
            this._p2psohu.streamMang.insertFileidx = this.fileo.fileidx;
            var _loc_2:* = new ByteArray();
            var _loc_3:Boolean = false;
            this._p2psohu.mp4convert.closeMth();
            this._p2psohu.mp4convert.openMth();
            var _loc_4:int = 0;
            while (_loc_4 < _loc_1.pice_total)
            {
                
                if (_loc_1.pices[_loc_4].ba.length != 0)
                {
                    trace("----------i:" + _loc_4);
                    _loc_3 = this._p2psohu.mp4convert.transferHeader(_loc_1.pices[_loc_4].ba);
                    this._p2psohu.showTestInfo("headLoaded b:" + _loc_3 + " ba.length:" + _loc_1.pices[_loc_4].ba.length + " i:" + _loc_4 + " chunko.pice_total:" + _loc_1.pice_total + " _seekHeaderData:" + this._seekHeaderData);
                    if (_loc_3)
                    {
                        break;
                    }
                    else
                    {
                    }
                }
                else
                {
                    break;
                }
                _loc_4++;
            }
            this._p2psohu.showTestInfo("headLoaded b:" + _loc_3);
            return _loc_3;
        }// end function

        private function getSeekLoc(param1:int) : Object
        {
            var _loc_5:Object = null;
            var _loc_2:* = this._p2psohu.fileList.fileoA[param1];
            var _loc_3:* = new Object();
            var _loc_4:* = _loc_2.first_count;
            while (_loc_4 <= _loc_2.end_count)
            {
                
                _loc_5 = this._chunksMamory.chunks[_loc_4];
                if (this.seekOffset >= _loc_5.begin && this.seekOffset <= _loc_5.end)
                {
                    _loc_3.streamidx = _loc_4;
                    _loc_3.peerinsertidx = Math.floor((this.seekOffset - _loc_5.begin) / ByteSize.PICESIZE);
                    return _loc_3;
                }
                _loc_4++;
            }
            return null;
        }// end function

        private function getSeekLoadedDataLoc() : int
        {
            var _loc_4:Object = null;
            var _loc_1:* = new Object();
            var _loc_2:* = this._chunksMamory.chunks.length;
            var _loc_3:* = this.streamInIdx;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._chunksMamory.chunks[_loc_3];
                if (this.streamInIdx == _loc_3 && (_loc_4.type == 0 || _loc_4.type == 1))
                {
                    return -1;
                }
                if (_loc_4.type != 2)
                {
                    return (_loc_3 - 1);
                }
                _loc_3++;
            }
            return (_loc_3 - 1);
        }// end function

        public function getCurInsertFileIdx() : int
        {
            if (this.streamInIdx >= this._p2psohu.fileList.fileoA.length)
            {
                return (this._p2psohu.fileList.fileoA.length - 1);
            }
            return this._chunksMamory.chunks[this.streamInIdx].fileidx;
        }// end function

        public function resizeChunk(param1:int, param2:Number) : void
        {
            this._chunksMamory.resizeChunk(param1, param2);
            return;
        }// end function

        public function setUnUseChunk(param1:int, param2:int, param3:int, param4:Number) : void
        {
            this._chunksMamory.setUnUseChunk(param1, param2, param3, param4);
            return;
        }// end function

        public function cleanPreMth() : void
        {
            if (this._downloadedDataT.running)
            {
                this._downloadedDataT.removeEventListener(TimerEvent.TIMER, this.insertLoadedData);
                this._downloadedDataT.stop();
            }
            this._isinsertNsData = true;
            this._seekHeaderData = false;
            this._waitPiceRange = true;
            return;
        }// end function

        public function cleanMth() : void
        {
            this.streamInIdx = 0;
            this.peerInsertIdx = 0;
            this._waitPiceRange = false;
            this._seekHeaderData = false;
            this.fileDLIdx = 0;
            this.chunkDLIdx = 0;
            this.peerDLIdx = 0;
            this._isSeekData = false;
            this.npidx = CountIdx.saveIdxAsByte(0, 0, 0);
            this.innpidx = CountIdx.saveIdxAsByte(0, 0, 0);
            this._dlChunkA.splice(0);
            this._dlChunkA = new Array();
            this._isloading = true;
            this._isinsertNsData = false;
            this._seekOffset = -1;
            this._isStopSeek = false;
            this._isSeek = false;
            this._doSeek = false;
            this._downloadedDataT.stop();
            this._downloadedDataT.removeEventListener(TimerEvent.TIMER, this.insertLoadedData);
            return;
        }// end function

        public function get dataIdx() : int
        {
            if (this._chunksMamory.chunks[this.chunkDLIdx] == null)
            {
                return this._chunksMamory.chunks[(this._chunksMamory.chunks.length - 1)].dataIdx;
            }
            return this._chunksMamory.chunks[this.chunkDLIdx].dataIdx;
        }// end function

        public function get insertFileidx() : int
        {
            return this._chunksMamory.chunks[this.streamInIdx].fileidx;
        }// end function

        public function getFilename(param1:int) : String
        {
            return this._p2psohu.fileList.fileoA[param1].filename;
        }// end function

        public function getCurPiceIdx(param1:int, param2:int = 0, param3:int = 0) : String
        {
            var _loc_4:* = this._p2psohu.fileList.fileoA[param1].first_count + param2 + "|" + param3;
            return this._p2psohu.fileList.fileoA[param1].first_count + param2 + "|" + param3;
        }// end function

        public function getChunkInfo(param1:int = -1) : Object
        {
            if (param1 == -1)
            {
                param1 = this.chunkDLIdx;
            }
            return this._chunksMamory.chunks[param1];
        }// end function

        private function getPiceDLRange(param1:int, param2:int) : Object
        {
            var _loc_3:* = new Object();
            if (param2 == 0)
            {
                _loc_3.begin = this._chunksMamory.chunks[param1].begin;
            }
            else
            {
                _loc_3.begin = this._chunksMamory.chunks[param1].begin + param2 * ByteSize.PICESIZE;
            }
            if (param2 == (this._chunksMamory.chunks[param1].pice_total - 1))
            {
                _loc_3.end = this._chunksMamory.chunks[param1].end;
            }
            else
            {
                _loc_3.end = _loc_3.begin + ByteSize.PICESIZE - 1;
            }
            return _loc_3;
        }// end function

        public function getPiceInfo(param1:int, param2:int) : Object
        {
            return this._chunksMamory.chunks[param1].pices[param2];
        }// end function

        public function getCurPicetotalByChunkidx(param1:int) : int
        {
            return this._chunksMamory.chunks[param1].pice_total;
        }// end function

        public function getCurChunkIdx(param1:String, param2:int) : int
        {
            return this._p2psohu.fileList.fileoA[this._p2psohu.fileList.getFileidx(param1)].first_count + param2;
        }// end function

        public function getLoadedChunkByte() : Number
        {
            var _loc_4:int = 0;
            var _loc_5:Boolean = false;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_1:Number = 0;
            if (this.innpidx == null)
            {
                return 0;
            }
            var _loc_2:* = CountIdx.getIdxAsObject(this.innpidx);
            var _loc_3:* = this._chunksMamory.chunks[_loc_2.chunkidx].pices[_loc_2.piceidx];
            if (_loc_2.chunkidx == this.chunkDLIdx)
            {
                _loc_4 = _loc_2.piceidx;
                while (_loc_4 < this._chunksMamory.chunks[_loc_2.chunkidx].pice_total)
                {
                    
                    if (this._chunksMamory.chunks[_loc_2.chunkidx].pices[_loc_4].type == 2)
                    {
                        _loc_1 = _loc_1 + this._chunksMamory.chunks[_loc_2.chunkidx].pices[_loc_4].ba.length;
                    }
                    else
                    {
                        break;
                    }
                    _loc_4++;
                }
            }
            else
            {
                _loc_5 = false;
                _loc_6 = _loc_2.chunkidx;
                while (_loc_6 < this.chunkDLIdx)
                {
                    
                    _loc_7 = _loc_6 == _loc_2.chunkidx ? (_loc_2.piceidx) : (0);
                    while (_loc_7 < this._chunksMamory.chunks[_loc_6].pice_total)
                    {
                        
                        if (this._chunksMamory.chunks[_loc_6].pices[_loc_7].type == 2)
                        {
                            _loc_1 = _loc_1 + this._chunksMamory.chunks[_loc_6].pices[_loc_7].ba.length;
                        }
                        else
                        {
                            _loc_5 = true;
                            break;
                        }
                        _loc_7++;
                    }
                    if (_loc_5)
                    {
                        break;
                    }
                    _loc_6++;
                }
            }
            return _loc_1;
        }// end function

        public function get loadingShowSize() : Number
        {
            var _loc_1:Number = NaN;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            if (this._isSeek)
            {
                _loc_1 = 0;
                _loc_2 = 0;
                while (_loc_2 < this.streamInIdx)
                {
                    
                    _loc_1 = _loc_1 + this._chunksMamory.chunks[_loc_2].size;
                    _loc_2++;
                }
                _loc_3 = this._chunksMamory.chunks.length;
                _loc_4 = this.streamInIdx;
                while (_loc_4 < _loc_3)
                {
                    
                    if (this._chunksMamory.chunks[_loc_4].type == 2)
                    {
                        _loc_1 = _loc_1 + this._chunksMamory.chunks[_loc_4].dlsize;
                    }
                    else
                    {
                        break;
                    }
                    _loc_4++;
                }
                return _loc_1;
            }
            else
            {
                return this.getCurFileDLSize(this.fileDLIdx, this.chunkDLIdx);
            }
        }// end function

        public function getNoDataChunkidx(param1:int) : int
        {
            var _loc_2:* = this._chunksMamory.chunks.length;
            var _loc_3:* = param1;
            while (_loc_3 < _loc_2)
            {
                
                if (this._chunksMamory.chunks[_loc_3].type == 0)
                {
                    return _loc_3;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function get chunkTotal() : int
        {
            return this._chunksMamory.chunks.length;
        }// end function

        public function get isloading() : Boolean
        {
            return this._isloading;
        }// end function

        public function set isloading(param1:Boolean) : void
        {
            this._isloading = param1;
            return;
        }// end function

        public function set isinsertNsData(param1:Boolean) : void
        {
            this._isinsertNsData = param1;
            return;
        }// end function

        public function get isinsertNsData() : Boolean
        {
            return this._isinsertNsData;
        }// end function

        public function set isStopSeek(param1:Boolean) : void
        {
            this._isStopSeek = param1;
            return;
        }// end function

        public function get seekOffset() : Number
        {
            return this._seekOffset;
        }// end function

        public function set seekOffset(param1:Number) : void
        {
            this._seekOffset = param1;
            return;
        }// end function

        public function get waitPiceRange() : Boolean
        {
            return this._waitPiceRange;
        }// end function

        public function get isSeekData() : Boolean
        {
            return this._isSeekData;
        }// end function

        public function get doSeek() : Boolean
        {
            return this._doSeek;
        }// end function

        public function getCompressData(param1:ByteArray) : uint
        {
            return this._chunksMamory.compressPiece(param1);
        }// end function

        public function isFileLoaded(param1:int) : Boolean
        {
            var _loc_2:Boolean = false;
            var _loc_3:Object = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_8:ByteArray = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            if (this.innpidx == null)
            {
                _loc_3.fileidx = 0;
                _loc_3.chunkidx = 0;
                _loc_3.piceidx = 0;
            }
            else
            {
                _loc_8 = new ByteArray();
                _loc_8.writeBytes(this.innpidx);
                _loc_3 = CountIdx.getIdxAsObject(_loc_8);
            }
            if (param1 == _loc_3.fileidx)
            {
                _loc_4 = _loc_3.chunkidx;
                _loc_5 = this._p2psohu.fileList.fileoA[param1].end_count;
                _loc_6 = _loc_3.piceidx;
            }
            else
            {
                if (param1 < _loc_3.fileidx)
                {
                    return true;
                }
                _loc_4 = this._p2psohu.fileList.fileoA[param1].first_count;
                _loc_5 = this._p2psohu.fileList.fileoA[param1].end_count;
                _loc_6 = 0;
            }
            if (param1 == _loc_3.fileidx)
            {
                _loc_2 = true;
            }
            else if (param1 > _loc_3.fileidx)
            {
                _loc_2 = false;
            }
            var _loc_7:* = _loc_4;
            while (_loc_7 < _loc_5)
            {
                
                _loc_9 = this._chunksMamory.chunks[_loc_7].pice_total;
                _loc_10 = 0;
                if (_loc_7 == _loc_4)
                {
                    _loc_10 = _loc_6;
                }
                while (_loc_10 < _loc_9)
                {
                    
                    if (this._chunksMamory.chunks[_loc_7].pices[_loc_10].type != 2 && this._chunksMamory.chunks[_loc_7].pices[_loc_10].type != -1)
                    {
                        if (param1 == _loc_3.fileidx)
                        {
                            _loc_2 = false;
                        }
                        else if (param1 > _loc_3.fileidx)
                        {
                            _loc_2 = true;
                        }
                        break;
                    }
                    _loc_10++;
                }
                _loc_7++;
            }
            _loc_8.clear();
            return _loc_2;
        }// end function

        public function get oldData() : Array
        {
            return this._chunksMamory.chunks;
        }// end function

    }
}
