package model
{
    import configbag.*;
    import control.*;
    import flash.utils.*;
    import test.*;

    public class ChunksMemory extends Object
    {
        public var chunks:Array;
        private var _realDLSize:Number = 0;

        public function ChunksMemory()
        {
            this.chunks = new Array();
            return;
        }// end function

        public function bulidChunks(param1:Array) : void
        {
            var _loc_5:Object = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_8:Boolean = false;
            var _loc_9:int = 0;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Object = null;
            var _loc_13:Array = null;
            this.cleanMth();
            var _loc_2:* = param1.length;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_5 = param1[_loc_4];
                if (Number(_loc_5.size) <= 0 || Number(_loc_5.size) > 1000000000)
                {
                    P2pSohuLib.getInstance().errorMth();
                    break;
                }
                _loc_6 = Math.ceil(Number(_loc_5.size) / ByteSize.CHUNKSIZE);
                _loc_7 = Number(_loc_5.size);
                _loc_8 = false;
                if (_loc_4 == 0)
                {
                    _loc_3 = _loc_6;
                }
                else
                {
                    _loc_3 = _loc_3 + _loc_6;
                }
                _loc_9 = 0;
                while (_loc_9 < _loc_6)
                {
                    
                    _loc_10 = _loc_9 * ByteSize.CHUNKSIZE;
                    if (_loc_9 == (_loc_6 - 1))
                    {
                        _loc_11 = _loc_7 - 1;
                    }
                    else
                    {
                        _loc_11 = _loc_10 + ByteSize.CHUNKSIZE - 1;
                    }
                    _loc_12 = new Object();
                    _loc_12.filename = _loc_5.filename;
                    _loc_12.dataIdx = _loc_9;
                    _loc_12.num = _loc_11 - _loc_10 + 1;
                    _loc_12.fileidx = _loc_4;
                    _loc_12.chunkidx = _loc_4 != 0 ? (_loc_9 + _loc_3 - _loc_6) : (_loc_9);
                    _loc_13 = ByteToChunk.setRangeToCharks(_loc_12);
                    this.chunks.push({clarity:Config.getInstance().clarity, begin:_loc_10, end:_loc_11, type:0, dataIdx:_loc_9, chunkidx:_loc_12.chunkidx, total:_loc_6, pices:_loc_13, pice_total:_loc_13.length, fileidx:_loc_4, size:_loc_12.num, dlsize:0, dlnum:0, isfrompeer:false, datawrong:0});
                    _loc_9++;
                }
                _loc_4++;
            }
            return;
        }// end function

        public function resizeChunk(param1:int, param2:Number) : void
        {
            var _loc_3:* = this.chunks[param1];
            _loc_3.size = param2 - _loc_3.begin;
            _loc_3.end = param2 - 1;
            var _loc_4:* = new Object();
            new Object().filename = _loc_3.filename;
            _loc_4.dataIdx = _loc_3.dataIdx;
            _loc_4.num = _loc_3.size + 1;
            _loc_4.fileidx = _loc_3.fileidx;
            _loc_4.chunkidx = _loc_3.chunkidx;
            var _loc_5:* = ByteToChunk.setRangeToCharks(_loc_4);
            _loc_3.pices = _loc_5;
            _loc_3.pice_total = _loc_5.length;
            return;
        }// end function

        public function setUnUseChunk(param1:int, param2:int, param3:int, param4:Number) : void
        {
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_5:* = Math.ceil(Number(param4) / ByteSize.CHUNKSIZE);
            var _loc_6:* = param3;
            if (_loc_5 != param1)
            {
                _loc_9 = _loc_5 + param2;
                while (_loc_9 <= param3)
                {
                    
                    this.chunks[_loc_9].type = -1;
                    _loc_10 = 0;
                    while (_loc_10 < this.chunks[_loc_9].pice_total)
                    {
                        
                        this.chunks[_loc_9].pices[_loc_10].type = -1;
                        _loc_10++;
                    }
                    _loc_9++;
                }
                _loc_6 = _loc_5 + param2 - 1;
            }
            var _loc_7:* = this.chunks[_loc_6];
            this.chunks[_loc_6].size = param4 - _loc_7.begin;
            _loc_7.end = param4 - 1;
            _loc_7.num = _loc_7.end - _loc_7.begin + 1;
            var _loc_8:* = ByteToChunk.setRangeToCharks(_loc_7);
            _loc_7.pices = _loc_8;
            _loc_7.pice_total = _loc_8.length;
            P2pSohuLib.getInstance().fileList.fileoA[this.chunks[_loc_6].fileidx].end_count = _loc_6;
            return;
        }// end function

        public function savePiceData(param1:Object) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:crc32 = null;
            if (this.chunks[param1.chunkidx].pices[param1.lowidx].type != 2)
            {
                (this.chunks[param1.chunkidx].dlnum + 1);
            }
            this.chunks[param1.chunkidx].dlsize = this.chunks[param1.chunkidx].dlsize + param1.size;
            var _loc_2:* = new ByteArray();
            _loc_2.writeBytes(param1.ba);
            (param1.ba as ByteArray).clear();
            this.chunks[param1.chunkidx].pices[param1.lowidx].ba = _loc_2;
            this.chunks[param1.chunkidx].pices[param1.lowidx].type = 2;
            this.chunks[param1.chunkidx].pices[param1.lowidx].basize = param1.size;
            if (Config.getInstance().hasCd)
            {
                if (this.chunks[param1.chunkidx].pices[param1.lowidx].cd == undefined)
                {
                    _loc_3 = this.compressPiece(_loc_2);
                    this.chunks[param1.chunkidx].pices[param1.lowidx].cd = _loc_3;
                }
                else
                {
                    _loc_3 = this.chunks[param1.chunkidx].pices[param1.lowidx].cd;
                }
            }
            if (Config.getInstance().isCrc)
            {
                _loc_4 = new crc32();
                _loc_4.update(param1.ba);
                this.chunks[param1.chunkidx].pices[param1.lowidx].crc = _loc_4.toString();
            }
            this._realDLSize = this._realDLSize + param1.size;
            return;
        }// end function

        public function compressPiece(param1:ByteArray) : uint
        {
            param1.position = 0;
            var _loc_2:* = new ByteArray();
            _loc_2.writeBytes(param1);
            _loc_2.compress();
            if (_loc_2.length < 4)
            {
                _loc_2.position = 0;
            }
            else
            {
                _loc_2.position = _loc_2.length - 4;
            }
            var _loc_3:* = new ByteArray();
            _loc_2.readBytes(_loc_3);
            _loc_3.position = 0;
            var _loc_4:* = _loc_3.readUnsignedInt();
            _loc_2.clear();
            _loc_3.clear();
            return _loc_4;
        }// end function

        public function delOldChunk(param1:int) : void
        {
            var _loc_3:int = 0;
            var _loc_2:* = this.chunks[param1];
            if (_loc_2 != null)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2.pice_total)
                {
                    
                    if (_loc_2.pices[_loc_3].ba != null)
                    {
                        (_loc_2.pices[_loc_3].ba as ByteArray).clear();
                    }
                    _loc_2.pices[_loc_3].type = 0;
                    _loc_3++;
                }
                this._realDLSize = this._realDLSize - _loc_2.dlsize;
                _loc_2.type = 0;
                _loc_2.dlnum = 0;
                _loc_2.dlsize = 0;
            }
            return;
        }// end function

        public function get realDLSize() : Number
        {
            return this._realDLSize;
        }// end function

        private function cleanMth() : void
        {
            this._realDLSize = 0;
            var _loc_1:* = this.chunks.length;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this.delOldChunk(_loc_2);
                _loc_2++;
            }
            this.chunks.splice(0);
            return;
        }// end function

    }
}
