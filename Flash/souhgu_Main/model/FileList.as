package model
{
    import control.*;
    import flash.utils.*;

    public class FileList extends BaseCtrl
    {
        public var fileoA:Array;
        private var fileoDic:Dictionary;
        private var _bytestotal:Number;
        private var _timestotal:Number;

        public function FileList()
        {
            this.fileoDic = new Dictionary();
            return;
        }// end function

        public function saveFileDataMth(param1:Array) : void
        {
            var _loc_7:Object = null;
            var _loc_8:int = 0;
            this.cleanMth();
            this.fileoA = new Array();
            var _loc_2:* = param1.length;
            var _loc_3:Number = 0;
            var _loc_4:Number = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_2)
            {
                
                _loc_7 = param1[_loc_6];
                _loc_3 = _loc_3 + _loc_7.size;
                _loc_4 = _loc_4 + _loc_7.duration;
                if (_loc_7.cdnfilename == undefined)
                {
                }
                else
                {
                    this.fileoA.push(param1[_loc_6]);
                    _loc_8 = Number(_loc_7.size);
                    _loc_7.dataidx = 0;
                    this.fileoA[_loc_6].oldsize = _loc_7.size;
                    this.fileoA[_loc_6].hasstat = false;
                    _loc_7.rebyte = _loc_3;
                    _loc_7.retime = _loc_4;
                    _loc_7.first_count = _loc_5;
                    _loc_5 = _loc_5 + Math.ceil(Number(_loc_7.size) / ByteSize.CHUNKSIZE);
                    _loc_7.end_count = _loc_5 - 1;
                    this.fileoDic[_loc_7.filename] = _loc_7.fileidx;
                    _loc_7.total = Math.ceil(Number(_loc_7.size) / ByteSize.CHUNKSIZE);
                }
                _loc_6++;
            }
            this._timestotal = _loc_4;
            this._bytestotal = _loc_3;
            this._p2psohu.chunksMang.bulidChunks(this.fileoA);
            return;
        }// end function

        public function resizeFileNum(param1:int, param2:int, param3:int, param4:Number, param5:Boolean = false) : String
        {
            if (this.fileoA[param1].realsize == undefined)
            {
                if (this.fileoA[param1].first_count == param2 && param3 == 0)
                {
                    this.fileoA[param1].realsize = param4;
                    if (param4 != this.fileoA[param1].oldsize)
                    {
                        this.resizeRealFileLen(param4, param1, param5);
                    }
                }
            }
            else if (param4 != this.fileoA[param1].realsize)
            {
                return "0";
            }
            return null;
        }// end function

        private function resizeRealFileLen(param1:int, param2:int, param3:Boolean) : void
        {
            this._p2psohu.showTestInfo("矫正size  fileidx:" + param2 + " old:" + this.fileoA[param2].size + " new:" + param1 + " isfrompeer:" + param3);
            if (this.fileoA[param2].size < param1)
            {
                this._p2psohu.chunksMang.resizeChunk(this.fileoA[param2].end_count, param1);
            }
            else
            {
                this._p2psohu.chunksMang.setUnUseChunk(this.fileoA[param2].total, this.fileoA[param2].first_count, this.fileoA[param2].end_count, param1);
            }
            return;
        }// end function

        public function getFileidx(param1:String) : int
        {
            return this.fileoDic[param1];
        }// end function

        public function getChunkTotal(param1:String) : int
        {
            var _loc_2:* = this.fileoA[this.getFileidx(param1)];
            return _loc_2.end_count - _loc_2.first_count + 1;
        }// end function

        public function getSeekFile(param1:Number) : Object
        {
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            if (param1 == 0)
            {
                _loc_4 = this.fileoA[0];
                _loc_4.seektime = 0;
                return _loc_4;
            }
            var _loc_2:* = this.fileoA.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_5 = this.fileoA[_loc_3];
                if (param1 < _loc_5.retime)
                {
                    _loc_5.seektime = _loc_5.duration - (this.fileoA[_loc_3].retime - param1);
                    return _loc_5;
                }
                _loc_3++;
            }
            if (param1 == this.fileoA[(_loc_2 - 1)].retime)
            {
                this.fileoA[(_loc_2 - 1)].seektime = param1 - (_loc_2 > 1 ? (this.fileoA[_loc_2 - 2].retime) : (0));
            }
            else
            {
                this.fileoA[(_loc_2 - 1)].seektime = param1 - this.fileoA[(_loc_2 - 1)].retime;
            }
            return this.fileoA[(_loc_2 - 1)];
        }// end function

        public function cleanMth() : void
        {
            var _loc_1:String = null;
            if (this.fileoA != null)
            {
                this.fileoA.splice(0);
            }
            for (_loc_1 in this.fileoDic)
            {
                
                this.fileoDic[_loc_1] = null;
                delete this.fileoDic[_loc_1];
            }
            this.fileoDic = new Dictionary();
            return;
        }// end function

        public function setFileStat(param1:int) : void
        {
            this.fileoA[param1].hasstat = true;
            return;
        }// end function

        public function getFileStat(param1:int) : Boolean
        {
            return this.fileoA[param1].hasstat;
        }// end function

        public function get timestotal() : Number
        {
            return this._timestotal;
        }// end function

        public function get bytestotal() : Number
        {
            return this._bytestotal;
        }// end function

    }
}
