package control
{
    import manager.*;
    import model.*;
    import server.*;

    public class CdnLoader extends BaseCtrl
    {
        public var cdnldmang:CdnLoaderManager;
        private var _isStopCdnLoader:Boolean = false;
        private var _isHeader:Boolean = false;
        private var _badidx:int = 0;
        private var _badcdn:String = "";
        private var _isLastChunk:Boolean = false;
        private var cdnConA:Array;
        private var cdnDataA:Array;
        private var _cdnConIdx:int = 0;
        private var _cdnDataIdx:int = 0;
        private var _maxConA:int = 8;
        private var _failIdx:int = 0;
        private var _failType:String;
        private var _isloadSeekData:Boolean = false;
        private var _cdn301idx:int = 0;

        public function CdnLoader()
        {
            this.cdnConA = new Array();
            this.cdnDataA = new Array();
            return;
        }// end function

        public function init() : void
        {
            this.cdnldmang = new CdnLoaderManager();
            this.cdnldmang.cdnloader = this;
            return;
        }// end function

        public function loadHeaderFile() : void
        {
            this.loadFileMth();
            return;
        }// end function

        public function loadFileMth() : void
        {
            this._isStopCdnLoader = false;
            this.loadFromCDN();
            return;
        }// end function

        private function loadFromCDN() : void
        {
            var _loc_2:LoadFromCDN = null;
            var _loc_3:LoadFromCDN = null;
            var _loc_4:Object = null;
            if (this._isStopCdnLoader && this.p2pSohuLib.config.isRP)
            {
                return;
            }
            this._isLastChunk = false;
            var _loc_1:int = 0;
            while (_loc_1 < this.cdnldmang.cdnloadNum)
            {
                
                if (this.cdnldmang.cdnloaderA[_loc_1].ld == null)
                {
                    _loc_3 = this.newLoadCDN();
                    this.cdnldmang.cdnloaderA[_loc_1].ld = _loc_3;
                }
                if (this._isLastChunk)
                {
                    break;
                }
                _loc_2 = this.cdnldmang.cdnloaderA[_loc_1].ld;
                if (!_loc_2.isRun)
                {
                    if (_loc_2.cdnInfo != null)
                    {
                        if (_loc_2.cdnInfo.dataInfo != undefined)
                        {
                            if (_loc_2.isCDNLoading)
                            {
                            }
                            else if (_loc_2.cdnInfo.fileidx != this._p2psohu.chunksMang.fileDLIdx)
                            {
                                _loc_2.gc();
                                break;
                            }
                            else
                            {
                                this._isLastChunk = this.lcConSuc(_loc_2);
                            }
                        }
                        else if (_loc_2.socketType && _loc_2.isCDNLoading == false)
                        {
                            if (_loc_2.cdnInfo.fileidx != this._p2psohu.chunksMang.fileDLIdx)
                            {
                                _loc_2.gc();
                                break;
                            }
                            else
                            {
                                this._isLastChunk = this.lcConSuc(_loc_2);
                            }
                        }
                    }
                    else
                    {
                        _loc_4 = this.getCdnLd();
                        if (_loc_4 != null)
                        {
                            if (this._p2psohu.chunksMang.seekOffset != -1 && this._p2psohu.chunksMang.isSeekData && !this._isloadSeekData)
                            {
                                this._isloadSeekData = true;
                            }
                            _loc_2.loadCDNMth(_loc_4);
                            this.cdnldmang.addConectMth(_loc_2);
                        }
                    }
                }
                else if (_loc_2.socketType && _loc_2.isCDNLoading == false)
                {
                    if (_loc_2.cdnInfo.fileidx != this._p2psohu.chunksMang.fileDLIdx)
                    {
                        _loc_2.gc();
                        break;
                    }
                    else
                    {
                        this._isLastChunk = this.lcConSuc(_loc_2);
                    }
                }
                _loc_1++;
            }
            return;
        }// end function

        public function referCdnList(param1:Boolean) : void
        {
            this.p2pSohuLib.schedulingServer.loadURL(this.p2pSohuLib.fileList.fileoA[this.p2pSohuLib.fileo.fileidx].cdnfilename, param1);
            return;
        }// end function

        public function referDataList(param1:Object) : void
        {
            this.p2pSohuLib.chunksMang.referChunkData(param1);
            return;
        }// end function

        public function checkLCFile() : void
        {
            var _loc_2:LoadFromCDN = null;
            var _loc_1:int = 0;
            while (_loc_1 < this.cdnldmang.cdnloadNum)
            {
                
                if (this.cdnldmang.cdnloaderA[_loc_1].ld != null)
                {
                    _loc_2 = this.cdnldmang.cdnloaderA[_loc_1].ld;
                    if (_loc_2.cdnInfo != null && !_loc_2.isCDNLoading && _loc_2.cdnInfo.fileidx != this._p2psohu.chunksMang.fileDLIdx)
                    {
                        this.p2pSohuLib.showTestInfo("checkLCFile  i:" + _loc_1 + "" + _loc_2.cdnInfo + " fileidx:" + this.p2pSohuLib.fileo.fileidx + " ld.cdnInfo.fileidx:" + _loc_2.cdnInfo.fileidx);
                        _loc_2.gc();
                    }
                }
                _loc_1++;
            }
            return;
        }// end function

        public function saveCdnNum(param1:Boolean, param2:Number = 0) : void
        {
            if (this._cdnConIdx == this._maxConA)
            {
                this._cdnConIdx = 0;
            }
            this.cdnConA[this._cdnConIdx] = {dur:param1 ? (param2) : (this.p2pSohuLib.config.avg_cdnConnectDelayNum * 2)};
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < this.cdnConA.length)
            {
                
                _loc_3 = _loc_3 + this.cdnConA[_loc_4].dur;
                _loc_4++;
            }
            this._p2psohu.config.avg_cdnConnectDelayNum = Math.max(Math.min(2000, _loc_3 / this.cdnConA.length), 1800);
            return;
        }// end function

        public function saveCdnDataNum(param1:Boolean, param2:Number, param3:Number) : void
        {
            if (this._cdnDataIdx == this._maxConA)
            {
                this._cdnDataIdx = 0;
            }
            this.cdnDataA[this._cdnDataIdx] = {dur:param2, size:param3};
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            while (_loc_6 < this.cdnDataA.length)
            {
                
                _loc_4 = _loc_4 + this.cdnDataA[_loc_6].dur;
                _loc_5 = _loc_5 + this.cdnDataA[_loc_6].size;
                _loc_6++;
            }
            this.p2pSohuLib.config.avg_cdnDatatime = Math.min(this.p2pSohuLib.config.f2 / (60 * 1024) * 1000, Math.max(_loc_5 / (this.cdnDataA.length * 60 * 1024) * 1000, 5000));
            this.p2pSohuLib.config.avg_cdnDataV = Math.max(10 * 1024, Math.min(500 * 1024, _loc_5 / (_loc_4 * 0.001)));
            return;
        }// end function

        public function loadEmptyChunk(param1:LoadFromCDN) : void
        {
            this._isLastChunk = this.lcConSuc(param1);
            return;
        }// end function

        public function lcConSuc(param1:LoadFromCDN) : Boolean
        {
            this.p2pSohuLib.showTestInfo("lcConSuc-------1---+ lc idx:" + this.cdnldmang.getLDIdx(param1));
            var _loc_2:* = this.p2pSohuLib.chunksMang.getDataRange();
            if (_loc_2 == null)
            {
                this.p2pSohuLib.showTestInfo("lcConSuc---3-没有任务了------+ lc idx:" + this.cdnldmang.getLDIdx(param1));
                return false;
            }
            param1.beginDownLoadData(_loc_2);
            var _loc_3:* = this.p2pSohuLib.fileList.fileoA[_loc_2.fileidx].end_count;
            if (_loc_2.chunkidx == _loc_3 && _loc_2.arridx[(_loc_2.arridx.length - 1)].piceidx == (this._p2psohu.chunksMang.getChunkInfo(_loc_3).pice_total - 1))
            {
                return true;
            }
            return false;
        }// end function

        private function newLoadCDN() : LoadFromCDN
        {
            var _loc_1:* = new LoadFromCDN();
            _loc_1.p2pSohuLib = this.p2pSohuLib;
            _loc_1.init();
            return _loc_1;
        }// end function

        public function fileLoadedOver(param1:Object, param2:LoadFromCDN) : void
        {
            this.cdnldmang.saveFileMth(param1, param2);
            return;
        }// end function

        public function callNextCDN(param1:Boolean, param2:LoadFromCDN) : void
        {
            this.p2pSohuLib.showTestInfo("call next cdn      isdie:" + param1 + " isStopCdnLoader:" + this.isStopCdnLoader + " isrp:" + this.p2pSohuLib.config.isRP + " isfirst:" + this.p2pSohuLib.isfirst);
            if (this.isStopCdnLoader && this.p2pSohuLib.config.isRP)
            {
                return;
            }
            if (this.p2pSohuLib.isfirst)
            {
                return;
            }
            if (param1)
            {
                this.cdnldmang.delItemMth(param2);
                if (this.p2pSohuLib.config.is301)
                {
                    var _loc_3:String = this;
                    var _loc_4:* = this._cdn301idx + 1;
                    _loc_3._cdn301idx = _loc_4;
                    if (this._cdn301idx == 5)
                    {
                        this.p2pSohuLib.showFailInfoMth("cdnconfail");
                    }
                    this.loadFileMth();
                }
                else
                {
                    this.referCdnList(true);
                }
            }
            return;
        }// end function

        public function get isCdnLoading() : Boolean
        {
            var _loc_2:LoadFromCDN = null;
            var _loc_1:int = 0;
            while (_loc_1 < this.cdnldmang.cdnloadNum)
            {
                
                _loc_2 = this.cdnldmang.cdnloaderA[_loc_1].ld;
                if (_loc_2 == null)
                {
                    return false;
                }
                return _loc_2.isCDNLoading;
                _loc_1++;
            }
            return true;
        }// end function

        public function getCdnLd() : Object
        {
            return this.p2pSohuLib.loaderMang.cdnlist.getCdnLd();
        }// end function

        public function errorType302(param1:String) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this._failIdx + 1;
            _loc_2._failIdx = _loc_3;
            if (this._failIdx > ByteSize.ROLLBACKIDX && this._p2psohu.getNsType("isNsTimeLowest"))
            {
                this._failIdx = 0;
                if (this._p2psohu.config.is301)
                {
                    this.p2pSohuLib.showFailInfoMth("404", "301", param1);
                }
                else
                {
                    this.p2pSohuLib.showFailInfoMth("404", "302");
                }
            }
            return;
        }// end function

        public function referFileClearBadCdn() : void
        {
            this._badidx = 0;
            this._badcdn = "";
            this.p2pSohuLib.schedulingServer.badCdn = this._badcdn;
            return;
        }// end function

        public function badCdnMth() : void
        {
            var _loc_1:String = null;
            var _loc_2:String = this;
            var _loc_3:* = this._badidx + 1;
            _loc_2._badidx = _loc_3;
            if (this._badidx >= 3)
            {
                this.cleanbadcdn();
                return;
            }
            if (this.p2pSohuLib.loaderMang.cdnlist.getCdnLd() == null)
            {
                return;
            }
            if (this._badcdn == "")
            {
                this._badcdn = this.p2pSohuLib.loaderMang.cdnlist.getCdnLd().nid;
            }
            else
            {
                _loc_1 = this.p2pSohuLib.loaderMang.cdnlist.getCdnLd().nid;
                if (!this.hasBadCdn(_loc_1))
                {
                    this._badcdn = this._badcdn + ("," + this.p2pSohuLib.loaderMang.cdnlist.getCdnLd().nid);
                }
            }
            this.p2pSohuLib.schedulingServer.badCdn = this._badcdn;
            if (this._badidx == 0)
            {
                this._badcdn = "";
            }
            return;
        }// end function

        public function cleanbadcdn() : void
        {
            this._badcdn = "";
            this._badidx = 0;
            this.p2pSohuLib.schedulingServer.badCdn = this._badcdn;
            if (this.p2pSohuLib.config.is301)
            {
                this._cdn301idx = 0;
            }
            return;
        }// end function

        public function hasBadCdn(param1:String) : Boolean
        {
            var _loc_4:String = null;
            var _loc_2:* = this._badcdn.split(",");
            var _loc_3:Boolean = false;
            for each (_loc_4 in _loc_2)
            {
                
                if (_loc_4 == param1)
                {
                    _loc_3 = true;
                    break;
                }
            }
            return _loc_3;
        }// end function

        public function clearMth(param1:Boolean = true) : void
        {
            this._isStopCdnLoader = true;
            this._isLastChunk = false;
            this.cdnldmang.clearMth(param1);
            this.cleanbadcdn();
            return;
        }// end function

        public function get isCDNLoading() : Boolean
        {
            return this.cdnldmang.isCDNLoading;
        }// end function

        public function get isCDNRunning() : Boolean
        {
            return this.cdnldmang.isCDNRunning;
        }// end function

        public function get isCDNFileidx() : int
        {
            return this.cdnldmang.isCDNFileidx;
        }// end function

        public function get isStopCdnLoader() : Boolean
        {
            return this._isStopCdnLoader;
        }// end function

        public function set isloadSeekData(param1:Boolean) : void
        {
            this._isloadSeekData = param1;
            return;
        }// end function

        public function seekInit() : void
        {
            this._failIdx = 0;
            this.cdnldmang.seekInit();
            return;
        }// end function

        public function cdn302ConOK() : void
        {
            this._failIdx = 0;
            return;
        }// end function

    }
}
