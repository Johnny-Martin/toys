package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.prng.*;
    import com.hurlant.util.*;
    import flash.utils.*;

    public class XTeaKey extends Object implements ISymmetricKey
    {
        public const NUM_ROUNDS:uint = 32;
        private var K10255269C23FDCE8B24503A67C29619F006FF3373515K:Array;

        public function XTeaKey(param1:ByteArray)
        {
            param1.position = 0;
            this.K10255269C23FDCE8B24503A67C29619F006FF3373515K = [param1.readUnsignedInt(), param1.readUnsignedInt(), param1.readUnsignedInt(), param1.readUnsignedInt()];
            return;
        }// end function

        public function getBlockSize() : uint
        {
            return 8;
        }// end function

        public function encrypt(param1:ByteArray, param2:uint = 0) : void
        {
            var _loc_5:uint = 0;
            param1.position = param2;
            var _loc_3:* = param1.readUnsignedInt();
            var _loc_4:* = param1.readUnsignedInt();
            var _loc_6:uint = 0;
            var _loc_7:uint = 2654435769;
            _loc_5 = 0;
            while (_loc_5 < this.NUM_ROUNDS)
            {
                
                _loc_6 = _loc_6 + _loc_7;
                _loc_3 = _loc_3 + ((_loc_4 << 4) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[0] ^ _loc_4 + _loc_6 ^ (_loc_4 >> 5) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[1]);
                _loc_4 = _loc_4 + ((_loc_3 << 4) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[2] ^ _loc_3 + _loc_6 ^ (_loc_3 >> 5) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[3]);
                _loc_5 = _loc_5 + 1;
            }
            param1.position = param1.position - 8;
            param1.writeUnsignedInt(_loc_3);
            param1.writeUnsignedInt(_loc_4);
            return;
        }// end function

        public function decrypt(param1:ByteArray, param2:uint = 0) : void
        {
            var _loc_5:uint = 0;
            param1.position = param2;
            var _loc_3:* = param1.readUnsignedInt();
            var _loc_4:* = param1.readUnsignedInt();
            var _loc_6:uint = 2654435769;
            var _loc_7:* = 2654435769 * this.NUM_ROUNDS;
            if (this.NUM_ROUNDS == 32)
            {
                _loc_7 = 3337565984;
            }
            else if (this.NUM_ROUNDS == 16)
            {
                _loc_7 = 3816266640;
            }
            _loc_5 = 0;
            while (_loc_5 < this.NUM_ROUNDS)
            {
                
                _loc_4 = _loc_4 - ((_loc_3 << 4) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[2] ^ _loc_3 + _loc_7 ^ (_loc_3 >> 5) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[3]);
                _loc_3 = _loc_3 - ((_loc_4 << 4) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[0] ^ _loc_4 + _loc_7 ^ (_loc_4 >> 5) + this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[1]);
                _loc_7 = _loc_7 - _loc_6;
                _loc_5 = _loc_5 + 1;
            }
            param1.position = param1.position - 8;
            param1.writeUnsignedInt(_loc_3);
            param1.writeUnsignedInt(_loc_4);
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_1:* = new Random();
            var _loc_2:uint = 0;
            while (_loc_2 < this.K10255269C23FDCE8B24503A67C29619F006FF3373515K.length)
            {
                
                this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[_loc_2] = _loc_1.nextByte();
                delete this.K10255269C23FDCE8B24503A67C29619F006FF3373515K[_loc_2];
                _loc_2 = _loc_2 + 1;
            }
            this.K10255269C23FDCE8B24503A67C29619F006FF3373515K = null;
            Memory.gc();
            return;
        }// end function

        public function toString() : String
        {
            return "xtea";
        }// end function

        public static function parseKey(param1:String) : XTeaKey
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeUnsignedInt(parseInt(param1.substr(0, 8), 16));
            _loc_2.writeUnsignedInt(parseInt(param1.substr(8, 8), 16));
            _loc_2.writeUnsignedInt(parseInt(param1.substr(16, 8), 16));
            _loc_2.writeUnsignedInt(parseInt(param1.substr(24, 8), 16));
            _loc_2.position = 0;
            return new XTeaKey(_loc_2);
        }// end function

    }
}
