package com.hurlant.crypto.prng
{
    import com.hurlant.util.*;
    import flash.utils.*;

    public class ARC4 extends Object implements IPRNG, IStreamCipher
    {
        private var i:int = 0;
        private var K102552C96791B855C8453B8619B51EA0AB7E40373515K:int = 0;
        private var K1026025EF84ACC028743C8B9086BDC07057FCF373565K:ByteArray;
        private const psize:uint = 256;

        public function ARC4(param1:ByteArray = null)
        {
            this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K = new ByteArray();
            if (param1)
            {
                this.init(param1);
            }
            return;
        }// end function

        public function getPoolSize() : uint
        {
            return this.psize;
        }// end function

        public function init(param1:ByteArray) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            _loc_2 = 0;
            while (_loc_2 < 256)
            {
                
                this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc_2] = _loc_2;
                _loc_2++;
            }
            _loc_3 = 0;
            _loc_2 = 0;
            while (_loc_2 < 256)
            {
                
                _loc_3 = _loc_3 + this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc_2] + param1[_loc_2 % param1.length] & 255;
                _loc_4 = this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc_2];
                this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc_2] = this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc_3];
                this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc_3] = _loc_4;
                _loc_2++;
            }
            this.i = 0;
            this.K102552C96791B855C8453B8619B51EA0AB7E40373515K = 0;
            return;
        }// end function

        public function next() : uint
        {
            var _loc_1:int = 0;
            this.i = (this.i + 1) & 255;
            this.K102552C96791B855C8453B8619B51EA0AB7E40373515K = this.K102552C96791B855C8453B8619B51EA0AB7E40373515K + this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.i] & 255;
            _loc_1 = this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.i];
            this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.i] = this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.K102552C96791B855C8453B8619B51EA0AB7E40373515K];
            this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.K102552C96791B855C8453B8619B51EA0AB7E40373515K] = _loc_1;
            return this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc_1 + this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[this.i] & 255];
        }// end function

        public function getBlockSize() : uint
        {
            return 1;
        }// end function

        public function encrypt(param1:ByteArray) : void
        {
            var _loc_2:uint = 0;
            while (_loc_2 < param1.length)
            {
                
                var _loc_3:* = _loc_2 + 1;
                param1[_loc_3] = param1[_loc_3] ^ this.next();
            }
            return;
        }// end function

        public function decrypt(param1:ByteArray) : void
        {
            this.encrypt(param1);
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_1:uint = 0;
            if (this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K.length)
                {
                    
                    this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K[_loc_1] = Math.random() * 256;
                    _loc_1 = _loc_1 + 1;
                }
                this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K.length = 0;
                this.K1026025EF84ACC028743C8B9086BDC07057FCF373565K = null;
            }
            this.i = 0;
            this.K102552C96791B855C8453B8619B51EA0AB7E40373515K = 0;
            Memory.gc();
            return;
        }// end function

        public function toString() : String
        {
            return "rc4";
        }// end function

    }
}
