package model
{
    import control.*;

    public class PeerList extends BaseList
    {
        private var _peerInfoA:Array;
        private var _peerIdx:int = -1;
        private var peerFileInfo:Object;

        public function PeerList()
        {
            this._peerInfoA = new Array();
            return;
        }// end function

        public function addPeerList(param1:Array, param2:Object) : void
        {
            var _loc_3:int = -1;
            var _loc_4:int = 0;
            while (_loc_4 < param1.length)
            {
                
                if (param1[_loc_4].peerid == this._loadermang.p2pSohuLib.config.peerID)
                {
                    _loc_3 = _loc_4;
                    break;
                }
                _loc_4++;
            }
            if (_loc_3 != -1)
            {
                param1.splice(_loc_3, 1);
            }
            super.addList(param1, false, param2);
            return;
        }// end function

        public function delPeer(param1:String) : void
        {
            super.delItem(param1, false);
            return;
        }// end function

        public function getPeerLd() : Object
        {
            return super.getLd(false);
        }// end function

    }
}
