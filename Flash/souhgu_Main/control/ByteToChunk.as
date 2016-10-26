package control
{
    import flash.utils.*;
    import model.*;
    import test.*;

    public class ByteToChunk extends BaseCtrl
    {

        public function ByteToChunk()
        {
            return;
        }// end function

        private function showCRC(param1:ByteArray) : String
        {
            var _loc_2:* = new crc32();
            _loc_2.update(param1);
            this._p2psohu.showTestInfo("crc   c:" + _loc_2.toString());
            return _loc_2.toString();
        }// end function

        public static function setRangeToCharks(param1:Object) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:* = Math.ceil(param1.num / ByteSize.PICESIZE);
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                _loc_2.push({lowidx:_loc_4, type:0, fileidx:param1.fileidx, lowtotal:_loc_3, dataIdx:param1.dataIdx, ba:new ByteArray(), basize:0, chunkidx:param1.chunkidx, isfrompeer:true, datawrong:0});
                _loc_4++;
            }
            return _loc_2;
        }// end function

        public static function setByteAToCharks(param1:Array, param2:ByteArray) : Array
        {
            var _loc_5:crc32 = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_3:* = Math.ceil(param2.length / ByteSize.PICESIZE);
            param2.position = 0;
            if (param1 == null)
            {
                param1 = new Array();
            }
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (param1[_loc_4] == null)
                {
                    param1[_loc_4] = new Object();
                }
                param1[_loc_4].ba = new ByteArray();
                if (_loc_4 == (_loc_3 - 1))
                {
                    param2.readBytes(param1[_loc_4].ba, 0, param2.bytesAvailable);
                }
                else
                {
                    param2.readBytes(param1[_loc_4].ba, 0, ByteSize.PICESIZE);
                }
                if (P2pSohuLib.getInstance().config.isCrc)
                {
                    _loc_5 = new crc32();
                    _loc_5.update(param1[_loc_4].ba);
                    _loc_6 = _loc_5.toString();
                    _loc_7 = "";
                    _loc_8 = _loc_6.length;
                    if (_loc_8 < 8)
                    {
                        _loc_9 = _loc_8;
                        while (_loc_9 < 8)
                        {
                            
                            _loc_7 = _loc_7 + "0";
                            _loc_9++;
                        }
                    }
                    param1[_loc_4].crc = _loc_7 + _loc_6;
                }
                param1[_loc_4].type = 2;
                _loc_4++;
            }
            param2.clear();
            return param1;
        }// end function

        public static function setCharksToByte(param1:Array) : ByteArray
        {
            var _loc_3:Object = null;
            var _loc_2:* = new ByteArray();
            for each (_loc_3 in param1)
            {
                
                if (_loc_3.ba == null)
                {
                    break;
                }
                _loc_2.writeBytes(_loc_3.ba);
            }
            return _loc_2;
        }// end function

    }
}
