package ebing.utils
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class Base64 extends Object
    {
        public static const PADDING:int = 61;
        private static const _encodeChars:Vector.<int> = InitEncodeChar();
        private static const _encodeShort:Vector.<int> = InitEncodeShort();
        private static const _decodeChars:Vector.<int> = InitDecodeChar();

        public function Base64()
        {
            return;
        }// end function

        public static function encode(param1:ByteArray) : String
        {
            var _loc_6:int = 0;
            var _loc_2:* = new ByteArray();
            _loc_2.length = (2 + param1.length - (param1.length + 2) % 3) * 4 / 3;
            var _loc_3:int = 0;
            var _loc_4:* = param1.length % 3;
            var _loc_5:* = param1.length - _loc_4;
            while (_loc_3 < _loc_5)
            {
                
                _loc_6 = param1[_loc_3++] << 16 | param1[_loc_3++] << 8 | param1[_loc_3++];
                _loc_2.writeInt(_encodeShort[_loc_6 >>> 12] << 16 | _encodeShort[_loc_6 & 4095]);
            }
            if (_loc_4 == 1)
            {
                _loc_6 = param1[_loc_3];
                _loc_6 = _encodeShort[_loc_6 << 4] << 16 | PADDING << 8 | PADDING;
                _loc_2.writeInt(_loc_6);
            }
            else if (_loc_4 == 2)
            {
                _loc_6 = param1[_loc_3++] << 8 | param1[_loc_3];
                _loc_6 = _encodeShort[_loc_6 >>> 4] << 16 | _encodeChars[(_loc_6 & 15) << 2] << 8 | PADDING;
                _loc_2.writeInt(_loc_6);
            }
            _loc_2.position = 0;
            return _loc_2.readUTFBytes(_loc_2.length);
        }// end function

        public static function decode(param1:String) : ByteArray
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:ByteArray = null;
            _loc_6 = 0;
            _loc_7 = new ByteArray();
            _loc_7.length = 3 * int((param1.length + 3) / 4);
            var _loc_8:* = new ByteArray();
            new ByteArray().length = param1.length + 4;
            _loc_8.writeUTFBytes(param1);
            _loc_8.writeInt(PADDING << 24 | PADDING << 16 | PADDING << 8 | PADDING);
            while (true)
            {
                
                do
                {
                    
                    _loc_2 = _decodeChars[_loc_8[_loc_6++]];
                }while (_loc_2 == -1)
                _loc_3 = _decodeChars[_loc_8[_loc_6++]];
                _loc_4 = _decodeChars[_loc_8[_loc_6++]];
                _loc_5 = _decodeChars[_loc_8[_loc_6++]];
                if (_loc_5 >= 0)
                {
                    _loc_7.writeByte(_loc_2 << 2 | _loc_3 >>> 4);
                    _loc_7.writeShort(_loc_3 << 12 | _loc_4 << 6 | _loc_5);
                    continue;
                }
                if (_loc_3 >= 0)
                {
                    _loc_7.writeByte(_loc_2 << 2 | _loc_3 >>> 4);
                    if (_loc_4 >= 0)
                    {
                        _loc_7.writeByte(_loc_3 << 4 | _loc_4 >>> 2);
                    }
                }
                break;
            }
            _loc_7.length = _loc_7.position;
            _loc_7.position = 0;
            return _loc_7;
        }// end function

        public static function InitEncodeChar() : Vector.<int>
        {
            var _loc_1:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            var _loc_2:* = new Vector.<int>;
            var _loc_3:int = 0;
            while (_loc_3 < 64)
            {
                
                _loc_2.push(_loc_1.charCodeAt(_loc_3));
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public static function InitEncodeShort() : Vector.<int>
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_1:* = new Vector.<int>;
            var _loc_2:int = 0;
            while (_loc_2 < 64)
            {
                
                _loc_3 = _encodeChars[_loc_2];
                _loc_4 = 0;
                while (_loc_4 < 64)
                {
                    
                    _loc_1.push(_loc_3 << 8 | _encodeChars[_loc_4]);
                    _loc_4++;
                }
                _loc_2++;
            }
            return _loc_1;
        }// end function

        public static function InitDecodeChar() : Vector.<int>
        {
            var _loc_1:* = new Vector.<int>;
            _loc_1.push(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
            _loc_1[PADDING] = -2;
            return _loc_1;
        }// end function

    }
}
