package model
{
    import flash.utils.*;

    public class CountIdx extends Object
    {

        public function CountIdx()
        {
            return;
        }// end function

        public static function saveIdxAsByte(param1:int, param2:int, param3:int) : ByteArray
        {
            var _loc_4:* = new ByteArray();
            new ByteArray().writeInt(param3);
            _loc_4.writeInt(param2);
            _loc_4.writeInt(param1);
            _loc_4.position = 0;
            return _loc_4;
        }// end function

        public static function getIdxAsObject(param1:ByteArray) : Object
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeBytes(param1);
            _loc_2.position = 0;
            param1.position = 0;
            var _loc_3:* = new Object();
            _loc_3.piceidx = _loc_2.readInt();
            _loc_3.chunkidx = _loc_2.readInt();
            _loc_3.fileidx = _loc_2.readInt();
            _loc_2.clear();
            return _loc_3;
        }// end function

        public static function addPiceIdx(param1:ByteArray, param2:int, param3:int, param4:int, param5:int, param6:int) : ByteArray
        {
            var _loc_7:* = new ByteArray();
            new ByteArray().writeBytes(param1);
            var _loc_8:* = getIdxAsObject(_loc_7);
            var _loc_9:int = 0;
            while (_loc_9 < param6)
            {
                
                var _loc_10:* = _loc_8;
                var _loc_11:* = _loc_8.piceidx + 1;
                _loc_10.piceidx = _loc_11;
                if (_loc_8.piceidx >= param3)
                {
                    var _loc_10:* = _loc_8;
                    var _loc_11:* = _loc_8.chunkidx + 1;
                    _loc_10.chunkidx = _loc_11;
                    _loc_8.piceidx = 0;
                    if (_loc_8.chunkidx - param2 >= param4)
                    {
                        var _loc_10:* = _loc_8;
                        var _loc_11:* = _loc_8.fileidx + 1;
                        _loc_10.fileidx = _loc_11;
                        _loc_8.piceidx = 0;
                        if (_loc_8.fileidx >= param5)
                        {
                            return null;
                        }
                        break;
                    }
                    else
                    {
                        break;
                    }
                }
                _loc_9++;
            }
            _loc_7.clear();
            param1.clear();
            return saveIdxAsByte(_loc_8.fileidx, _loc_8.chunkidx, _loc_8.piceidx);
        }// end function

        public static function getLowestIdx(param1:ByteArray, param2:ByteArray) : ByteArray
        {
            var _loc_3:* = getIdxAsObject(param1);
            var _loc_4:* = getIdxAsObject(param2);
            if (_loc_3.fileidx > _loc_4.fileidx)
            {
                return param2;
            }
            if (_loc_3.fileidx < _loc_4.fileidx)
            {
                return param1;
            }
            if (_loc_3.chunkidx > _loc_4.chunkidx)
            {
                return param2;
            }
            if (_loc_3.chunkidx < _loc_4.chunkidx)
            {
                return param1;
            }
            if (_loc_3.piceidx > _loc_4.piceidx)
            {
                return param2;
            }
            if (_loc_3.piceidx < _loc_4.piceidx)
            {
                return param1;
            }
            return param1;
        }// end function

        public static function compareIdxIsBig(param1:ByteArray, param2:ByteArray) : Boolean
        {
            var _loc_4:Object = null;
            var _loc_3:* = getIdxAsObject(param1);
            if (param2 != null)
            {
                _loc_4 = getIdxAsObject(param2);
            }
            else
            {
                return false;
            }
            if (_loc_3.fileidx > _loc_4.fileidx)
            {
                return true;
            }
            if (_loc_3.fileidx < _loc_4.fileidx)
            {
                return false;
            }
            if (_loc_3.chunkidx > _loc_4.chunkidx)
            {
                return true;
            }
            if (_loc_3.chunkidx < _loc_4.chunkidx)
            {
                return false;
            }
            if (_loc_3.piceidx > _loc_4.piceidx)
            {
                return true;
            }
            if (_loc_3.piceidx < _loc_4.piceidx)
            {
                return false;
            }
            return false;
        }// end function

    }
}
