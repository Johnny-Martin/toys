package com.sohu.tv.mediaplayer
{
    import ebing.utils.*;
    import flash.utils.*;

    public class XModel extends Object
    {
        private static const XXT_VIDEO_KEY:String = "SOHU@HoT^~123";

        public function XModel()
        {
            return;
        }// end function

        public function encryptBase64(param1:String, param2:String) : String
        {
            var _loc_3:String = "";
            if (param1 == "")
            {
                return _loc_3;
            }
            var _loc_4:* = ToUtf8(param2);
            _loc_3 = this.NetEncrypt(param1, _loc_4);
            _loc_3 = replaceAll(_loc_3, "+", "-");
            _loc_3 = replaceAll(_loc_3, "/", "_");
            _loc_3 = replaceAll(_loc_3, "=", ".");
            return _loc_3;
        }// end function

        public function decryptBase64(param1:String, param2:String) : String
        {
            var _loc_3:String = "";
            var _loc_4:* = param1;
            if (param1 == "")
            {
                return _loc_3;
            }
            _loc_4 = replaceAll(_loc_4, "-", "+");
            _loc_4 = replaceAll(_loc_4, "_", "/");
            _loc_4 = replaceAll(_loc_4, ".", "=");
            var _loc_5:* = ToUtf8(XXT_VIDEO_KEY + Base64.decode(param2));
            _loc_3 = this.NetDecrypt(_loc_4, _loc_5);
            return _loc_3;
        }// end function

        private function NetEncrypt(param1:String, param2:ByteArray) : String
        {
            var _loc_3:* = ToUtf8(param1);
            if (_loc_3.length == 0)
            {
                return param1;
            }
            return Utf8toString(ToByteArray(Encrypt(ToUInt32Array(_loc_3, true), ToUInt32Array(param2, false)), false));
        }// end function

        private function NetDecrypt(param1:String, param2:ByteArray) : String
        {
            var _loc_3:* = Base64.decode(param1);
            if (_loc_3.length == 0)
            {
                return param1;
            }
            var _loc_4:* = ToByteArray(Decrypt(ToUInt32Array(_loc_3, false), ToUInt32Array(param2, false)), true);
            var _loc_5:* = new ByteArray();
            var _loc_6:uint = 0;
            while (_loc_6 < _loc_4.length)
            {
                
                _loc_5[_loc_6] = _loc_4[_loc_6];
                _loc_6 = _loc_6 + 1;
            }
            return _loc_5.toString();
        }// end function

        private static function ToUInt32Array(param1:ByteArray, param2:Boolean) : Array
        {
            var _loc_6:uint = 0;
            var _loc_3:* = new Array();
            var _loc_4:* = param1.length;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3[_loc_5 >>> 2] = uint(_loc_3[_loc_5 >>> 2] | uint(param1[_loc_5]) << ((_loc_5 & 3) << 3));
                _loc_5++;
            }
            if (param2)
            {
                _loc_3.push(_loc_4);
                _loc_6 = param1.length - 1;
                _loc_3[_loc_6 >>> 2] = uint(_loc_3[_loc_6 >>> 2] | uint(param1[_loc_6]) << ((_loc_6 & 3) << 3));
            }
            return _loc_3;
        }// end function

        private static function Encrypt(param1:Array, param2:Array) : Array
        {
            var _loc_12:Array = null;
            var _loc_3:* = param1.length - 1;
            if (_loc_3 < 1)
            {
                return param1;
            }
            if (param2.length < 4)
            {
                _loc_12 = new Array();
                _loc_12 = param2.slice();
                param2 = _loc_12;
            }
            while (param2.length < 4)
            {
                
                param2.push(0);
            }
            var _loc_4:* = param1[_loc_3];
            var _loc_5:* = param1[0];
            var _loc_6:uint = 2654435769;
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_9:int = 0;
            var _loc_10:* = 6 + 52 / (_loc_3 + 1);
            while (_loc_10-- > 0)
            {
                
                _loc_7 = uint(_loc_7 + _loc_6);
                _loc_8 = _loc_7 >>> 2 & 3;
                _loc_9 = 0;
                while (_loc_9 < _loc_3)
                {
                    
                    _loc_5 = param1[(_loc_9 + 1)];
                    var _loc_13:* = param1[_loc_9] + ((_loc_4 >>> 5 ^ _loc_5 << 2) + (_loc_5 >>> 3 ^ _loc_4 << 4) ^ (_loc_7 ^ _loc_5) + (param2[_loc_9 & 3 ^ _loc_8] ^ _loc_4));
                    param1[_loc_9] = param1[_loc_9] + ((_loc_4 >>> 5 ^ _loc_5 << 2) + (_loc_5 >>> 3 ^ _loc_4 << 4) ^ (_loc_7 ^ _loc_5) + (param2[_loc_9 & 3 ^ _loc_8] ^ _loc_4));
                    _loc_4 = uint(_loc_13);
                    _loc_9++;
                }
                _loc_5 = param1[0];
                var _loc_13:* = param1[_loc_3] + ((_loc_4 >>> 5 ^ _loc_5 << 2) + (_loc_5 >>> 3 ^ _loc_4 << 4) ^ (_loc_7 ^ _loc_5) + (param2[_loc_9 & 3 ^ _loc_8] ^ _loc_4));
                param1[_loc_3] = param1[_loc_3] + ((_loc_4 >>> 5 ^ _loc_5 << 2) + (_loc_5 >>> 3 ^ _loc_4 << 4) ^ (_loc_7 ^ _loc_5) + (param2[_loc_9 & 3 ^ _loc_8] ^ _loc_4));
                _loc_4 = uint(_loc_13);
            }
            var _loc_11:uint = 0;
            while (_loc_11 < param1.length)
            {
                
                param1[_loc_11] = uint(param1[_loc_11]);
                _loc_11 = _loc_11 + 1;
            }
            return param1;
        }// end function

        private static function Decrypt(param1:Array, param2:Array) : Array
        {
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_9:int = 0;
            var _loc_11:Array = null;
            var _loc_3:* = param1.length - 1;
            if (_loc_3 < 1)
            {
                return param1;
            }
            if (param2.length < 4)
            {
                _loc_11 = new Array();
                _loc_11 = param2.slice();
                param2 = _loc_11;
            }
            while (param2.length < 4)
            {
                
                param2.push(0);
            }
            var _loc_4:* = param1[_loc_3];
            var _loc_5:* = param1[0];
            var _loc_6:uint = 2654435769;
            var _loc_10:* = 6 + 52 / (_loc_3 + 1);
            _loc_7 = uint(uint(_loc_10) * _loc_6);
            while (_loc_7 != 0)
            {
                
                _loc_8 = _loc_7 >>> 2 & 3;
                _loc_9 = _loc_3;
                while (_loc_9 > 0)
                {
                    
                    _loc_4 = param1[(_loc_9 - 1)];
                    var _loc_12:* = param1[_loc_9] - ((_loc_4 >>> 5 ^ _loc_5 << 2) + (_loc_5 >>> 3 ^ _loc_4 << 4) ^ (_loc_7 ^ _loc_5) + (param2[_loc_9 & 3 ^ _loc_8] ^ _loc_4));
                    param1[_loc_9] = param1[_loc_9] - ((_loc_4 >>> 5 ^ _loc_5 << 2) + (_loc_5 >>> 3 ^ _loc_4 << 4) ^ (_loc_7 ^ _loc_5) + (param2[_loc_9 & 3 ^ _loc_8] ^ _loc_4));
                    _loc_5 = uint(_loc_12);
                    _loc_9 = _loc_9 - 1;
                }
                _loc_4 = param1[_loc_3];
                var _loc_12:* = param1[0] - ((_loc_4 >>> 5 ^ _loc_5 << 2) + (_loc_5 >>> 3 ^ _loc_4 << 4) ^ (_loc_7 ^ _loc_5) + (param2[_loc_9 & 3 ^ _loc_8] ^ _loc_4));
                param1[0] = param1[0] - ((_loc_4 >>> 5 ^ _loc_5 << 2) + (_loc_5 >>> 3 ^ _loc_4 << 4) ^ (_loc_7 ^ _loc_5) + (param2[_loc_9 & 3 ^ _loc_8] ^ _loc_4));
                _loc_5 = uint(_loc_12);
                _loc_7 = uint(_loc_7 - _loc_6);
            }
            return param1;
        }// end function

        private static function ToByteArray(param1:Array, param2:Boolean) : Array
        {
            var _loc_3:int = 0;
            var _loc_6:uint = 0;
            if (param2)
            {
                _loc_3 = int(param1[(param1.length - 1)]);
            }
            else
            {
                _loc_3 = param1.length << 2;
            }
            var _loc_4:* = new Array();
            var _loc_5:uint = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_6 = param1[_loc_5 >>> 2] >>> ((_loc_5 & 3) << 3) & uint(255);
                _loc_4.push(_loc_6);
                _loc_5 = _loc_5 + 1;
            }
            return _loc_4;
        }// end function

        private static function ToUtf8(param1:String) : ByteArray
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeUTFBytes(param1);
            _loc_2.position = 0;
            return _loc_2;
        }// end function

        private static function Utf8toString(param1:Array) : String
        {
            var _loc_2:* = new ByteArray();
            var _loc_3:uint = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2.writeByte(param1[_loc_3]);
                _loc_3 = _loc_3 + 1;
            }
            _loc_2.position = 0;
            if (_loc_2.bytesAvailable > 0)
            {
                return Base64.encode(_loc_2);
            }
            return "";
        }// end function

        private static function replaceAll(param1:String, param2:String, param3:String) : String
        {
            var _loc_8:String = null;
            var _loc_4:String = "";
            var _loc_5:* = param1.split(param2);
            var _loc_6:* = param1.split(param2).length;
            var _loc_7:int = 0;
            for each (_loc_8 in _loc_5)
            {
                
                if (_loc_7 < (_loc_6 - 1))
                {
                    _loc_4 = _loc_4 + (_loc_8 + param3);
                }
                else
                {
                    _loc_4 = _loc_4 + _loc_8;
                }
                _loc_7++;
            }
            return _loc_4;
        }// end function

    }
}
