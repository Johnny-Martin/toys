package manager
{
    import configbag.*;
    import control.*;
    import flash.utils.*;
    import model.*;

    public class LoaderManager extends BaseCtrl
    {
        private var loadDic:Dictionary;
        private var _loadA:Array;
        private var _loadIdx:int = 0;
        public var cdnlist:CdnList;
        public var peerlist:PeerList;
        private var _iswait:Boolean = false;
        private var _waitidx:int = 0;

        public function LoaderManager()
        {
            this.loadDic = new Dictionary();
            this._loadA = new Array();
            return;
        }// end function

        public function init() : void
        {
            this.cdnlist = new CdnList();
            this.cdnlist.loadermang = this;
            this.peerlist = new PeerList();
            this.peerlist.loadermang = this;
            return;
        }// end function

        public function schedulingServerBack(param1:Array, param2:Boolean) : void
        {
            if (Config.getInstance().isP2pLive)
            {
            }
            else
            {
                if (this._p2psohu.isAllDie)
                {
                    return;
                }
                if (_p2psohu.fileo != null)
                {
                    this._p2psohu.showTestInfo("schedulingServerBack header:" + (_p2psohu.fileo.header != undefined ? (true) : (null)) + " isrefer:" + param2 + " isSeek:" + this._p2psohu.isSeek + " isloading:" + this._p2psohu.chunksMang.isloading);
                }
                this.cdnlist.addCdnList(param1, _p2psohu.fileo);
                if (this._p2psohu.streamMang.isFirstInsertPhoto)
                {
                    this._p2psohu.streamMang.getPhotoPolicyFile(param1[0].url);
                }
                if (this._p2psohu.isSeek)
                {
                    if (this._p2psohu.chunksMang.headLoaded())
                    {
                        _p2psohu.continueSeek();
                    }
                    else
                    {
                        this._p2psohu.cdnloader.loadFileMth();
                    }
                }
                else if (param2)
                {
                    if (!this._p2psohu.chunksMang.isloading)
                    {
                        return;
                    }
                    this._p2psohu.cdnloader.loadFileMth();
                }
                else
                {
                    this._p2psohu.cdnloader.loadFileMth();
                }
            }
            return;
        }// end function

        public function peerlistMth(param1:Object) : void
        {
            if (this._p2psohu.config.ispurecdn)
            {
                return;
            }
            if (this._p2psohu.isAllLoadedOver)
            {
                return;
            }
            this.loadFileMth(param1);
            return;
        }// end function

        private function loadFileMth(param1:Object) : void
        {
            this.peerlist.addPeerList(param1.peerlist, param1);
            if (param1.peernum == 0)
            {
                this._p2psohu.showTestInfo("peer个数是0");
                this._p2psohu.peer.receivePeer.waitReferPeerList();
            }
            else
            {
                this._p2psohu.peer.receivePeer.referPeerA();
                this._p2psohu.peer.receivePeer.beginP2PMth();
            }
            param1 = null;
            return;
        }// end function

        public function cleanMth() : void
        {
            this._waitidx = 0;
            this._iswait = false;
            return;
        }// end function

    }
}
