package model
{
    import configbag.*;
    import control.*;

    public class CdnList extends BaseList
    {
        private var _cdnlist:Object;

        public function CdnList()
        {
            return;
        }// end function

        public function addCdnList(param1:Array, param2:Object) : void
        {
            var _loc_3:String = null;
            if (this._loadermang.p2pSohuLib.config.isSingleCdn)
            {
                this._cdnlist = new Object();
                _loc_3 = (Config.getInstance().ta == "" ? ("") : ("&ta=" + Config.getInstance().ta)) + Config.getInstance().cdnparam;
                this._cdnlist.cdnurl = param1[0].url + (this._loadermang.p2pSohuLib.config.is301 ? ("") : ("&pid=" + this._loadermang.p2pSohuLib.config.pid + _loc_3));
                this._cdnlist.fileidx = param2.fileidx;
                this._cdnlist.cdnfilename = param2.cdnfilename;
                this._cdnlist.ip = param1[0].ip;
                this._cdnlist.port = param1[0].port;
                this._cdnlist.total = param2.total;
                this._cdnlist.filename = param2.filename;
                this._cdnlist.nid = param1[0].nid;
            }
            else
            {
                super.addList(param1, true, param2);
            }
            return;
        }// end function

        public function referCdnList(param1:Object) : void
        {
            var _loc_2:Object = null;
            for each (_loc_2 in _listInfoA)
            {
                
                _loc_2.fileidx = param1.fileidx;
                _loc_2.cdnfilename = param1.cdnfilename;
                _loc_2.filename = param1.filename;
            }
            return;
        }// end function

        public function delCdn(param1:String) : void
        {
            if (this._loadermang.p2pSohuLib.config.isSingleCdn)
            {
                this._cdnlist = null;
            }
            else
            {
                super.delItem(param1, true);
            }
            return;
        }// end function

        public function getCdnLd() : Object
        {
            var _loc_1:Object = null;
            var _loc_2:String = null;
            if (this._loadermang.p2pSohuLib.config.isSingleCdn)
            {
                if (this._cdnlist == null)
                {
                    return null;
                }
                _loc_1 = new Object();
                for (_loc_2 in this._cdnlist)
                {
                    
                    _loc_1[_loc_2] = this._cdnlist[_loc_2];
                }
                return _loc_1;
            }
            else
            {
                return super.getLd(true);
            }
        }// end function

    }
}
