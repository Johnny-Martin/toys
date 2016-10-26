package manager
{
    import configbag.*;
    import control.*;
    import flash.utils.*;

    public class OldDataManager extends BaseCtrl
    {
        private var _vidDic:Dictionary;
        private var _dicIdx:int = 0;

        public function OldDataManager()
        {
            this._vidDic = new Dictionary();
            return;
        }// end function

        public function saveData() : void
        {
            var _loc_1:Dictionary = null;
            if (!this._p2psohu.config.isShareOld)
            {
                return;
            }
            if (Config.getInstance().vid != "" && this.p2pSohuLib.chunksMang.chunkTotal != 0)
            {
                _loc_1 = this.duplicateArray(this.p2pSohuLib.filesManager.nsChunkDic);
                if (this.hasLength(_loc_1))
                {
                    this._vidDic[Config.getInstance().vid] = {chunks:this.duplicateArray(this.p2pSohuLib.chunksMang.oldData), idx:this._dicIdx, shareChunkDic:_loc_1};
                    var _loc_2:String = this;
                    var _loc_3:* = this._dicIdx + 1;
                    _loc_2._dicIdx = _loc_3;
                }
            }
            return;
        }// end function

        public function shareData() : void
        {
            var _loc_1:Object = null;
            var _loc_2:* = undefined;
            var _loc_3:Object = null;
            if (!this._p2psohu.config.isShareOld)
            {
                return;
            }
            for each (_loc_1 in this._vidDic)
            {
                
                for (_loc_2 in _loc_1.shareChunkDic)
                {
                    
                    _loc_3 = _loc_1.shareChunkDic[_loc_2];
                    this._p2psohu.trackSocket.sendMsgMth("addfile", _loc_3.filename + _loc_3.dataIdx, this._p2psohu.peer.sendPeer.inrpnum, 0, 0);
                }
            }
            return;
        }// end function

        private function hasLength(param1:Dictionary) : Boolean
        {
            var _loc_3:Object = null;
            var _loc_2:Boolean = false;
            for each (_loc_3 in param1)
            {
                
                _loc_2 = true;
                break;
            }
            return _loc_2;
        }// end function

        private function duplicateArray(param1:Object)
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeObject(param1);
            _loc_2.position = 0;
            return _loc_2.readObject();
        }// end function

    }
}
