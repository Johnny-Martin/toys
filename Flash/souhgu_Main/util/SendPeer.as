package util
{
    import flash.net.*;
    import flash.utils.*;
    import model.*;
    import server.*;

    public class SendPeer extends BaseSRPeer
    {
        private var inRpDic:Dictionary;
        private var _inrpnum:Number = 0;
        private var fileOutNsDic:Dictionary;

        public function SendPeer()
        {
            this.inRpDic = new Dictionary();
            this.fileOutNsDic = new Dictionary();
            return;
        }// end function

        public function shareNsInit() : void
        {
            var _loc_2:PeerForLoad = null;
            var _loc_3:Object = null;
            var _loc_1:int = 0;
            while (_loc_1 < ByteSize.NSLEN)
            {
                
                _loc_2 = new PeerForLoad();
                _loc_2.p2pSohuLib = this._newpeer.p2pSohuLib;
                _loc_2.conSucF = this.rpConSuc;
                _loc_3 = new Object();
                _loc_3.filename = this._newpeer.p2pSohuLib.config.peerID;
                _loc_3.dataIdx = _loc_1;
                _loc_2.init(_loc_3);
                this.fileOutNsDic[_loc_3.filename + _loc_3.dataIdx] = {pl:_loc_2, idx:_loc_1, rp:null};
                _loc_1++;
            }
            return;
        }// end function

        private function rpConSuc(param1:PeerForLoad) : void
        {
            if (this.inRpDic[param1.rpeerid] != undefined)
            {
                return;
            }
            this.fileOutNsDic[param1.fileinfo.filename + param1.fileinfo.dataIdx].rp = param1.rpeerid;
            this.inRpDic[param1.rpeerid] = param1;
            var _loc_2:String = this;
            var _loc_3:* = this.inrpnum + 1;
            _loc_2.inrpnum = _loc_3;
            this._newpeer.p2pSohuLib.showTestInfo("rpConSuc  inrpnum:" + this.inrpnum);
            return;
        }// end function

        public function isLimitMth(param1:NetStream) : Boolean
        {
            if (_newpeer.receivePeer.peerldmang.spDic[param1.farID] != undefined)
            {
                return false;
            }
            if (this.inrpnum > _newpeer.p2pSohuLib.config.rpnum)
            {
                return false;
            }
            return true;
        }// end function

        public function showRP() : void
        {
            var _loc_1:String = null;
            for (_loc_1 in this.inRpDic)
            {
                
                this._newpeer.p2pSohuLib.showTestInfo("rp名称 rppid:" + _loc_1.slice(0, 8));
            }
            return;
        }// end function

        public function delAllNs() : void
        {
            var _loc_1:String = null;
            var _loc_2:PeerForLoad = null;
            var _loc_3:String = null;
            this._newpeer.p2pSohuLib.showTestInfo("delAllNs  :");
            for (_loc_1 in this.fileOutNsDic)
            {
                
                _loc_2 = this.fileOutNsDic[_loc_1].pl;
                _loc_2.gc();
                _loc_3 = this.fileOutNsDic[_loc_1].rp;
                if (_loc_3 != null)
                {
                    this.inRpDic[_loc_3] = null;
                    delete this.inRpDic[_loc_3];
                }
                this.fileOutNsDic[_loc_1] = null;
                delete this.fileOutNsDic[_loc_1];
            }
            this.fileOutNsDic = new Dictionary();
            this.inRpDic = new Dictionary();
            this.inrpnum = 0;
            return;
        }// end function

        public function delPeerForLoad(param1:PeerForLoad) : void
        {
            if (param1.rpeerid != null && this.inRpDic[param1.rpeerid] != undefined)
            {
                if (param1.fileinfo != null)
                {
                    this.fileOutNsDic[param1.fileinfo.filename + param1.fileinfo.dataIdx].rp = null;
                }
                this.inRpDic[param1.rpeerid] = null;
                delete this.inRpDic[param1.rpeerid];
                var _loc_2:String = this;
                var _loc_3:* = this.inrpnum - 1;
                _loc_2.inrpnum = _loc_3;
                this._newpeer.p2pSohuLib.showTestInfo("delPeerForLoad  inrpnum:" + this.inrpnum);
            }
            return;
        }// end function

        public function clearDiePeer(param1:String) : void
        {
            var _loc_2:PeerForLoad = null;
            if (this.inRpDic[param1] != undefined)
            {
                _loc_2 = this.inRpDic[param1];
                this._newpeer.p2pSohuLib.showTestInfo("sp  clearDiePeer rp  dieid:" + param1.slice(0, 8));
                _loc_2.clearNs();
            }
            return;
        }// end function

        public function clearMth() : void
        {
            this.delAllNs();
            return;
        }// end function

        public function get inrpnum() : Number
        {
            return this._inrpnum;
        }// end function

        public function set inrpnum(param1:Number) : void
        {
            this._inrpnum = param1;
            return;
        }// end function

    }
}
