package com.hurlant.crypto.prng
{
    import com.hurlant.util.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class Random extends Object
    {
        private var state:IPRNG;
        private var K10260294EA6D5D9CCC4E4D82B72EB00DFF07DF373565K:Boolean = false;
        private var K102602703AE35BC410456981F392E33C28DE34373565K:ByteArray;
        private var K10260281A4035357FB48ADA03038D171A278CD373565K:int;
        private var K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K:int;
        private var K102602DB472586B87642DB9D3B4C36D690E9D3373565K:Boolean = false;

        public function Random(param1:Class = null)
        {
            var _loc_2:uint = 0;
            if (param1 == null)
            {
                param1 = ARC4;
            }
            this.state = new param1 as IPRNG;
            this.K10260281A4035357FB48ADA03038D171A278CD373565K = this.state.getPoolSize();
            this.K102602703AE35BC410456981F392E33C28DE34373565K = new ByteArray();
            this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = 0;
            while (this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K < this.K10260281A4035357FB48ADA03038D171A278CD373565K)
            {
                
                _loc_2 = 65536 * Math.random();
                var _loc_4:String = this;
                _loc_4.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
                var _loc_3:* = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
                this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc_3] = _loc_2 >>> 8;
                var _loc_5:String = this;
                _loc_5.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
                this.K102602703AE35BC410456981F392E33C28DE34373565K[++this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K] = _loc_2 & 255;
            }
            this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = 0;
            this.seed();
            return;
        }// end function

        public function seed(param1:int = 0) : void
        {
            if (param1 == 0)
            {
                param1 = new Date().getTime();
            }
            var _loc_3:String = this;
            _loc_3.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
            var _loc_2:* = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
            this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc_2] = this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc_2] ^ param1 & 255;
            var _loc_4:String = this;
            _loc_4.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
            var _loc_3:* = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
            this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc_3] = this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc_3] ^ param1 >> 8 & 255;
            var _loc_5:String = this;
            _loc_5.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
            this.K102602703AE35BC410456981F392E33C28DE34373565K[++this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K] = this.K102602703AE35BC410456981F392E33C28DE34373565K[++this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K] ^ param1 >> 16 & 255;
            var _loc_6:String = this;
            _loc_6.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K + 1;
            this.K102602703AE35BC410456981F392E33C28DE34373565K[++this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K] = this.K102602703AE35BC410456981F392E33C28DE34373565K[++this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K] ^ param1 >> 24 & 255;
            this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K % this.K10260281A4035357FB48ADA03038D171A278CD373565K;
            this.K102602DB472586B87642DB9D3B4C36D690E9D3373565K = true;
            return;
        }// end function

        public function autoSeed() : void
        {
            var _loc_3:Font = null;
            var _loc_1:* = new ByteArray();
            _loc_1.writeUnsignedInt(System.totalMemory);
            _loc_1.writeUTF(Capabilities.serverString);
            _loc_1.writeUnsignedInt(getTimer());
            _loc_1.writeUnsignedInt(new Date().getTime());
            var _loc_2:* = Font.enumerateFonts(true);
            for each (_loc_3 in _loc_2)
            {
                
                _loc_1.writeUTF(_loc_3.fontName);
                _loc_1.writeUTF(_loc_3.fontStyle);
                _loc_1.writeUTF(_loc_3.fontType);
            }
            _loc_1.position = 0;
            while (_loc_1.bytesAvailable >= 4)
            {
                
                this.seed(_loc_1.readUnsignedInt());
            }
            return;
        }// end function

        public function nextBytes(param1:ByteArray, param2:int) : void
        {
            while (param2--)
            {
                
                param1.writeByte(this.nextByte());
            }
            return;
        }// end function

        public function nextByte() : int
        {
            if (!this.K10260294EA6D5D9CCC4E4D82B72EB00DFF07DF373565K)
            {
                if (!this.K102602DB472586B87642DB9D3B4C36D690E9D3373565K)
                {
                    this.autoSeed();
                }
                this.state.init(this.K102602703AE35BC410456981F392E33C28DE34373565K);
                this.K102602703AE35BC410456981F392E33C28DE34373565K.length = 0;
                this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = 0;
                this.K10260294EA6D5D9CCC4E4D82B72EB00DFF07DF373565K = true;
            }
            return this.state.next();
        }// end function

        public function dispose() : void
        {
            var _loc_1:uint = 0;
            while (_loc_1 < this.K102602703AE35BC410456981F392E33C28DE34373565K.length)
            {
                
                this.K102602703AE35BC410456981F392E33C28DE34373565K[_loc_1] = Math.random() * 256;
                _loc_1 = _loc_1 + 1;
            }
            this.K102602703AE35BC410456981F392E33C28DE34373565K.length = 0;
            this.K102602703AE35BC410456981F392E33C28DE34373565K = null;
            this.state.dispose();
            this.state = null;
            this.K10260281A4035357FB48ADA03038D171A278CD373565K = 0;
            this.K102602FA1394ACDA43422B97FFA1C7A7F85A51373565K = 0;
            Memory.gc();
            return;
        }// end function

        public function toString() : String
        {
            return "random-" + this.state.toString();
        }// end function

    }
}
