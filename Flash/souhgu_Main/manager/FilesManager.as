package manager
{
    import control.*;
    import flash.utils.*;
    import model.*;

    public class FilesManager extends BaseCtrl
    {
        private var _downloadtype:Number = 0;
        private var _staticO:Object;
        private var _nsChunkDic:Dictionary;
        private var _countidx:int = 10;
        private var _countnum:int = 0;
        private var _fullFileDic:Dictionary;

        public function FilesManager()
        {
            this._staticO = new Object();
            this._nsChunkDic = new Dictionary();
            this._fullFileDic = new Dictionary();
            return;
        }// end function

        public function init() : void
        {
            this._nsChunkDic = new Dictionary();
            this._staticO.p = 0;
            this._staticO.c = 0;
            this._staticO.flashp = 0;
            this._staticO.ifoxp = 0;
            return;
        }// end function

        private function delNsInfo() : void
        {
            this._p2psohu.peer.sendPeer.delAllNs();
            return;
        }// end function

        public function delOldNsInf(param1:int, param2:Boolean = true) : void
        {
            var _loc_3:* = this._nsChunkDic[param1].filename;
            var _loc_4:* = _loc_3 + this._nsChunkDic[param1].dataIdx;
            if (this._p2psohu.trackSocket.socket.connected)
            {
                this._p2psohu.trackSocket.sendMsgMth("delfile", _loc_4);
                if (this._fullFileDic[_loc_3] != undefined)
                {
                    this._p2psohu.trackSocket.sendMsgMth("delfile", _loc_3);
                }
            }
            if (param2)
            {
                this._nsChunkDic[param1] = undefined;
                delete this._nsChunkDic[param1];
                if (this._fullFileDic[_loc_3] != undefined)
                {
                    this._fullFileDic[_loc_3] = undefined;
                    delete this._fullFileDic[_loc_3];
                }
            }
            return;
        }// end function

        public function reloginDelInfo() : void
        {
            var _loc_1:* = undefined;
            for (_loc_1 in this._nsChunkDic)
            {
                
                this.delOldNsInf(_loc_1, false);
            }
            if (this._p2psohu.config.isRtmfpDie)
            {
                this.delNsInfo();
            }
            return;
        }// end function

        public function reviewAddInfo() : void
        {
            var _loc_1:* = undefined;
            var _loc_2:* = undefined;
            var _loc_3:Object = null;
            if (this._p2psohu.config.isRtmfpDie)
            {
                this.addNsInfo();
            }
            for (_loc_1 in this._nsChunkDic)
            {
                
                _loc_3 = this._nsChunkDic[_loc_1];
                this._p2psohu.trackSocket.sendMsgMth("addfile", _loc_3.filename + _loc_3.dataIdx, this._p2psohu.peer.sendPeer.inrpnum, 0, 0);
            }
            for (_loc_2 in this._fullFileDic)
            {
                
                this._p2psohu.trackSocket.sendMsgMth("addfile", _loc_2, this._p2psohu.peer.sendPeer.inrpnum, 0, 0);
            }
            return;
        }// end function

        public function sendAddPeerInfo(param1:Object) : void
        {
            var _loc_2:* = new Object();
            _loc_2.filename = this._p2psohu.chunksMang.getFilename(param1.fileidx);
            _loc_2.dataIdx = param1.dataIdx;
            this._nsChunkDic[param1.chunkidx] = _loc_2;
            this._p2psohu.trackSocket.sendMsgMth("addfile", _loc_2.filename + _loc_2.dataIdx, this._downloadtype, 0, 0);
            if (this.fileLoadedOver(param1.fileidx) && this._fullFileDic[_loc_2.filename] == undefined)
            {
                this._p2psohu.trackSocket.sendMsgMth("addfile", _loc_2.filename, this._downloadtype, 0, 0);
                this._fullFileDic[_loc_2.filename] = _loc_2.filename;
            }
            return;
        }// end function

        public function sendStaticMth(param1:Object) : void
        {
            var _loc_3:Object = null;
            var _loc_2:* = param1.basize;
            if (param1.isfrompeer)
            {
                if (this._p2psohu.config.isCDNSmall && this.p2pSohuLib.chunksMang.npidx != null)
                {
                    _loc_3 = CountIdx.getIdxAsObject(this.p2pSohuLib.chunksMang.npidx);
                    if (this._p2psohu.config.smallFileIdx == _loc_3.fileidx)
                    {
                        return;
                    }
                }
                this._p2psohu.trackSocket.sendMsgMth("addstatic", 0, _loc_2);
            }
            else
            {
                if (this._p2psohu.config.isCDNSmall && this._p2psohu.config.smallFileIdx == this._p2psohu.fileo.fileidx)
                {
                    return;
                }
                this._p2psohu.trackSocket.sendMsgMth("addstatic", _loc_2, 0);
            }
            return;
        }// end function

        private function fileLoadedOver(param1:int) : Boolean
        {
            var _loc_4:int = 0;
            var _loc_2:* = this._p2psohu.fileList.fileoA[param1];
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2.total)
            {
                
                _loc_4 = _loc_2.first_count + _loc_3;
                if (this._p2psohu.chunksMang.checkChunkLoadedOver(_loc_4) == false)
                {
                    return false;
                }
                _loc_3++;
            }
            return true;
        }// end function

        public function sendcdnlog() : void
        {
            return;
        }// end function

        private function addNsInfo() : void
        {
            this._p2psohu.peer.sendPeer.shareNsInit();
            return;
        }// end function

        public function addCdnSize(param1:Number) : void
        {
            if (this._p2psohu.config.isCDNSmall && this._p2psohu.config.smallFileIdx == this._p2psohu.fileo.fileidx)
            {
                return;
            }
            if (this._staticO.c == 0 && this._staticO.p == 0)
            {
                if (this._p2psohu.config.staticO.c == undefined)
                {
                    this._p2psohu.config.staticO.c = 0;
                }
                this._staticO.c = this._staticO.c + (this._p2psohu.config.staticO.c + param1);
            }
            else
            {
                this._staticO.c = this._staticO.c + param1;
            }
            this._p2psohu.config.staticO.c = this._staticO.c;
            this._p2psohu.showTestInfo("upload size cdn:" + this._staticO.c + " peer:" + this._staticO.p);
            return;
        }// end function

        public function addPeerSize(param1:Number) : void
        {
            var _loc_2:Object = null;
            if (this._p2psohu.config.isCDNSmall && this.p2pSohuLib.chunksMang.npidx != null)
            {
                _loc_2 = CountIdx.getIdxAsObject(this.p2pSohuLib.chunksMang.npidx);
                if (this._p2psohu.config.smallFileIdx == _loc_2.fileidx)
                {
                    return;
                }
            }
            if (this._staticO.c == 0 && this._staticO.p == 0)
            {
                if (this._p2psohu.config.staticO.p == undefined)
                {
                    this._p2psohu.config.staticO.p = 0;
                }
                this._staticO.p = this._staticO.p + (this._p2psohu.config.staticO.p + param1);
            }
            else
            {
                this._staticO.p = this._staticO.p + param1;
            }
            this._p2psohu.config.staticO.p = this._staticO.p;
            this._p2psohu.showTestInfo("upload size cdn:" + this._staticO.c + " peer:" + this._staticO.p);
            return;
        }// end function

        public function addTypePeerSize(param1:Number, param2:String) : void
        {
            if (this.staticO[param2 + "p"] == undefined)
            {
                this.staticO[param2 + "p"] = 0;
                if (this._p2psohu.config.staticO[param2 + "p"] == undefined)
                {
                    this._p2psohu.config.staticO[param2 + "p"] = 0;
                }
                this._staticO[param2 + "p"] = this._p2psohu.config.staticO.p + param1;
            }
            else
            {
                this._staticO[param2 + "p"] = this._staticO[param2 + "p"] + param1;
            }
            this._p2psohu.config.staticO[param2 + "p"] = this._staticO[param2 + "p"];
            return;
        }// end function

        public function set downloadtype(param1:Number) : void
        {
            this._downloadtype = param1;
            return;
        }// end function

        public function get staticO() : Object
        {
            return this._staticO;
        }// end function

        public function get nsChunkDic() : Dictionary
        {
            return this._nsChunkDic;
        }// end function

    }
}
