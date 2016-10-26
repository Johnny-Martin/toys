package test
{
    import __AS3__.vec.*;
    import flash.utils.*;

    final public class crc32 extends Object
    {
        private var _crc:uint;
        private var _length:uint;
        private var _endian:String;
        private static var lookup:Vector.<uint> = make_crc_table();
        private static var _poly:uint = 3.98829e+009;
        private static var _init:uint = 4.29497e+009;

        public function crc32()
        {
            this._length = 4294967295;
            this._endian = Endian.LITTLE_ENDIAN;
            this.reset();
            return;
        }// end function

        public function get endian() : String
        {
            return this._endian;
        }// end function

        public function get length() : uint
        {
            return this._length;
        }// end function

        public function update(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
        {
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            if (param3 == 0)
            {
                param3 = param1.length;
            }
            param1.position = param2;
            var _loc_6:* = this._length & this._crc;
            _loc_4 = param2;
            while (_loc_4 < param3)
            {
                
                _loc_5 = uint(param1[_loc_4]);
                _loc_6 = _loc_6 >>> 8 ^ lookup[(_loc_6 ^ _loc_5) & 255];
                _loc_4 = _loc_4 + 1;
            }
            this._crc = ~_loc_6;
            return;
        }// end function

        public function reset() : void
        {
            this._crc = _init;
            return;
        }// end function

        public function valueOf() : uint
        {
            return this._crc;
        }// end function

        public function toString(param1:Number = 16) : String
        {
            return this._crc.toString(param1);
        }// end function

        private static function make_crc_table() : Vector.<uint>
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_1:* = new Vector.<uint>;
            _loc_3 = 0;
            while (_loc_3 < 256)
            {
                
                _loc_2 = _loc_3;
                _loc_4 = 0;
                while (_loc_4 < 8)
                {
                    
                    if ((_loc_2 & 1) != 0)
                    {
                        _loc_2 = _loc_2 >>> 1 ^ _poly;
                    }
                    else
                    {
                        _loc_2 = _loc_2 >>> 1;
                    }
                    _loc_4 = _loc_4 + 1;
                }
                _loc_1[_loc_3] = _loc_2;
                _loc_3 = _loc_3 + 1;
            }
            return _loc_1;
        }// end function

    }
}
