package manager
{
    import control.*;
    import flash.display.*;
    import flash.utils.*;
    import server.*;

    public class CdnLoaderManager extends Sprite
    {
        private var _cdnloader:CdnLoader;
        private var _cdnloaderA:Array;
        public var cdnloadNum:int = 2;
        private var loadingDic:Dictionary;
        private var connectingDic:Dictionary;
        private var _connum:int = 0;
        private var _maxDataIdx:int = 0;

        public function CdnLoaderManager()
        {
            this._cdnloaderA = new Array();
            this.loadingDic = new Dictionary();
            this.connectingDic = new Dictionary();
            this._cdnloaderA = new Array();
            var _loc_1:int = 0;
            while (_loc_1 < this.cdnloadNum)
            {
                
                this.cdnloaderA.push({ld:null, fileo:null, dura:new Array(), sizea:new Array()});
                _loc_1++;
            }
            return;
        }// end function

        public function addConectMth(param1:LoadFromCDN) : void
        {
            this.connectingDic[param1] = param1;
            var _loc_2:String = this;
            var _loc_3:* = this._connum + 1;
            _loc_2._connum = _loc_3;
            return;
        }// end function

        public function delItemMth(param1:LoadFromCDN) : void
        {
            var _loc_3:Object = null;
            var _loc_2:int = 0;
            while (_loc_2 < this.cdnloaderA.length)
            {
                
                _loc_3 = this.cdnloaderA[_loc_2];
                if (_loc_3.ld != null && _loc_3.ld == param1)
                {
                    if (this.connectingDic[param1] != undefined)
                    {
                        this.connectingDic[param1] = undefined;
                        if (this._connum > 0)
                        {
                            var _loc_4:String = this;
                            var _loc_5:* = this._connum - 1;
                            _loc_4._connum = _loc_5;
                        }
                    }
                    (_loc_3.dura as Array).splice(0);
                    (_loc_3.sizea as Array).splice(0);
                    this.delLoadingDic(_loc_3.ld);
                    break;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function delLoadingDic(param1:LoadFromCDN) : void
        {
            var _loc_2:String = null;
            for (_loc_2 in this.loadingDic)
            {
                
                if (this.loadingDic[_loc_2] == param1)
                {
                    trace("delLoadingDic:" + _loc_2);
                    this.loadingDic[_loc_2] = null;
                    delete this.loadingDic[_loc_2];
                    break;
                }
            }
            return;
        }// end function

        public function saveFileMth(param1:Object, param2:LoadFromCDN) : void
        {
            return;
        }// end function

        private function sendFileMth(param1:LoadFromCDN) : void
        {
            return;
        }// end function

        private function clearLdAMth() : void
        {
            var _loc_1:Object = null;
            for each (_loc_1 in this.cdnloaderA)
            {
                
                if (_loc_1.ld != null && _loc_1.ld.cdnInfo != null)
                {
                    _loc_1.ld.gc();
                }
                if (_loc_1.dura != null)
                {
                    (_loc_1.dura as Array).splice(0);
                }
                if (_loc_1.sizea != null)
                {
                    (_loc_1.sizea as Array).splice(0);
                }
            }
            return;
        }// end function

        public function clearMth(param1:Boolean = true) : void
        {
            var _loc_2:String = null;
            if (param1)
            {
                this.clearLdAMth();
            }
            else
            {
                this.referDataBack();
            }
            this._cdnloader.p2pSohuLib.config.cdnDatatime = 3000;
            this._maxDataIdx = 0;
            for (_loc_2 in this.loadingDic)
            {
                
                this.loadingDic[_loc_2] = null;
                delete this.loadingDic[_loc_2];
            }
            this.loadingDic = new Dictionary();
            this.connectingDic = new Dictionary();
            this._connum = 0;
            return;
        }// end function

        public function referDataBack() : void
        {
            var _loc_1:Object = null;
            for each (_loc_1 in this.cdnloaderA)
            {
                
                if (_loc_1.ld != null && _loc_1.ld.cdnInfo != null)
                {
                    if (_loc_1.ld.cdnInfo.dataInfo != null)
                    {
                        this._cdnloader.referDataList(_loc_1.ld.cdnInfo.dataInfo);
                    }
                }
            }
            return;
        }// end function

        public function getIsInLoadA(param1:LoadFromCDN) : Boolean
        {
            var _loc_2:Object = null;
            for each (_loc_2 in this._cdnloaderA)
            {
                
                if (_loc_2.ld == param1)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function get isCDNLoading() : Boolean
        {
            var _loc_2:Object = null;
            var _loc_1:Boolean = false;
            for each (_loc_2 in this.cdnloaderA)
            {
                
                if (_loc_2.ld != null && _loc_2.ld.isCDNLoading)
                {
                    _loc_1 = true;
                    break;
                }
            }
            return _loc_1;
        }// end function

        public function get isCDNRunning() : Boolean
        {
            var _loc_2:Object = null;
            var _loc_1:Boolean = false;
            for each (_loc_2 in this.cdnloaderA)
            {
                
                if (_loc_2.ld != null && _loc_2.ld.isRun)
                {
                    _loc_1 = true;
                    break;
                }
            }
            return _loc_1;
        }// end function

        public function get isCDNFileidx() : int
        {
            var _loc_2:Object = null;
            var _loc_1:int = 0;
            for each (_loc_2 in this.cdnloaderA)
            {
                
                if (_loc_2.ld != null && _loc_2.ld.isRun)
                {
                    _loc_1 = _loc_2.ld.cdnInfo.fileidx;
                    break;
                }
            }
            return _loc_1;
        }// end function

        private function get isFileFull() : Boolean
        {
            var _loc_1:Object = null;
            for each (_loc_1 in this.cdnloaderA)
            {
                
                if (_loc_1.fileo == null)
                {
                    return false;
                }
            }
            return true;
        }// end function

        public function getLDIdx(param1:LoadFromCDN) : int
        {
            var _loc_2:int = 0;
            while (_loc_2 < this.cdnloadNum)
            {
                
                if (this.cdnloaderA[_loc_2].ld == param1)
                {
                    return _loc_2;
                }
                _loc_2++;
            }
            return -1;
        }// end function

        public function set cdnloader(param1:CdnLoader) : void
        {
            this._cdnloader = param1;
            return;
        }// end function

        public function get cdnloader() : CdnLoader
        {
            return this._cdnloader;
        }// end function

        public function get isArrFull() : Boolean
        {
            var _loc_1:Object = null;
            for each (_loc_1 in this.cdnloaderA)
            {
                
                if (_loc_1.ld == null)
                {
                    return false;
                }
            }
            return true;
        }// end function

        public function seekInit() : void
        {
            var _loc_1:Object = null;
            for each (_loc_1 in this.cdnloaderA)
            {
                
                if (_loc_1.ld != null)
                {
                    _loc_1.ld.seekInit();
                }
            }
            return;
        }// end function

        public function get cdnloaderA() : Array
        {
            return this._cdnloaderA;
        }// end function

        public function set cdnloaderA(param1:Array) : void
        {
            this._cdnloaderA = param1;
            return;
        }// end function

        public function set maxDataIdx(param1:int) : void
        {
            this._maxDataIdx = param1;
            return;
        }// end function

        public function get connum() : int
        {
            return this._connum;
        }// end function

    }
}
