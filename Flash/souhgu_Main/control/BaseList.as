package control
{
    import configbag.*;

    public class BaseList extends BaseLoader
    {
        protected var _listInfoA:Array;
        protected var _listIdx:int = -1;

        public function BaseList()
        {
            this._listInfoA = new Array();
            return;
        }// end function

        protected function addList(param1:Array, param2:Boolean, param3:Object) : void
        {
            var _loc_4:Object = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:String = null;
            this._listInfoA.splice(0);
            this._listIdx = -1;
            if (!param2)
            {
                _loc_5 = (param3.filename as String).length;
                _loc_6 = String(this._loadermang.p2pSohuLib.chunksMang.dataIdx).length;
                _loc_7 = (param3.filename as String).substr(0, _loc_5 - _loc_6);
            }
            for each (_loc_4 in param1)
            {
                
                if (param2)
                {
                    this._listInfoA.push({cdnurl:_loc_4.url, fileidx:param3.fileidx, cdnfilename:param3.cdnfilename, ip:_loc_4.ip, port:_loc_4.port, total:param3.total, filename:param3.filename});
                    continue;
                }
                if (Config.getInstance().isTestP2P)
                {
                    this._listInfoA.push({peerid:_loc_4.peerid, p2pid:_loc_4.p2pid, proxyip:_loc_4.proxyip, peertype:_loc_4.peertype, rtmfpurl:_loc_4.rtmfpurl, filename:_loc_7, dataIdx:this._loadermang.p2pSohuLib.chunksMang.dataIdx, fileidx:this._loadermang.p2pSohuLib.chunksMang.fileDLIdx});
                    continue;
                }
                this._listInfoA.push({peerid:_loc_4.peerid, p2pid:_loc_4.p2pid, proxyip:_loc_4.proxyip, rtmfpurl:_loc_4.rtmfpurl, filename:_loc_7, dataIdx:this._loadermang.p2pSohuLib.chunksMang.dataIdx, fileidx:this._loadermang.p2pSohuLib.chunksMang.fileDLIdx});
            }
            param1 = null;
            return;
        }// end function

        protected function delItem(param1:String, param2:Boolean) : void
        {
            var _loc_3:* = this._listInfoA.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (param2 && this._listInfoA[_loc_4].ip == param1)
                {
                    break;
                }
                else if (!param2 && this._listInfoA[_loc_4].peerid == param1)
                {
                    break;
                }
                _loc_4++;
            }
            this._listInfoA.splice(_loc_4, 1);
            return;
        }// end function

        protected function getLd(param1:Boolean) : Object
        {
            if (this._listInfoA.length == 0)
            {
                return null;
            }
            var _loc_3:String = this;
            var _loc_4:* = this._listIdx + 1;
            _loc_3._listIdx = _loc_4;
            if (this._listIdx >= this._listInfoA.length)
            {
                if (param1)
                {
                    this._listIdx = 0;
                }
                else
                {
                    return null;
                }
            }
            var _loc_2:* = new Object();
            if (param1)
            {
                _loc_2.cdnurl = this._listInfoA[this._listIdx].cdnurl;
                _loc_2.fileidx = this._listInfoA[this._listIdx].fileidx;
                _loc_2.cdnfilename = this._listInfoA[this._listIdx].cdnfilename;
                _loc_2.ip = this._listInfoA[this._listIdx].ip;
                _loc_2.port = this._listInfoA[this._listIdx].port;
                _loc_2.total = this._listInfoA[this._listIdx].total;
                _loc_2.filename = this._listInfoA[this._listIdx].filename;
            }
            else
            {
                _loc_2.peerid = this._listInfoA[this._listIdx].peerid;
                _loc_2.p2pid = this._listInfoA[this._listIdx].p2pid;
                _loc_2.proxyip = this._listInfoA[this._listIdx].proxyip;
                if (Config.getInstance().isTestP2P)
                {
                    _loc_2.peertype = this._listInfoA[this._listIdx].peertype;
                }
                _loc_2.rtmfpurl = this._listInfoA[this._listIdx].rtmfpurl;
                _loc_2.filename = this._listInfoA[this._listIdx].filename;
                _loc_2.dataIdx = this._listInfoA[this._listIdx].dataIdx;
            }
            return _loc_2;
        }// end function

        public function getListLen() : Number
        {
            return this._listInfoA.length;
        }// end function

        public function get listIdx() : int
        {
            return this._listIdx;
        }// end function

        public function getList() : Array
        {
            return this._listInfoA;
        }// end function

    }
}
