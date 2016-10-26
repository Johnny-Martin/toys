package com.adobe.images
{
    import com.adobe.crypto.*;
    import com.hurlant.crypto.symmetric.*;
    import flash.utils.*;

    public class BitUi extends Object
    {
        private var xtea:XTeaKey;

        public function BitUi()
        {
            return;
        }// end function

        public function encryptBase64(param1:String, param2:Array) : String
        {
            var _loc_3:String = "";
            if (param1 == "")
            {
                return _loc_3;
            }
            var _loc_4:* = K102553B9BF6692A27B4F72A7BF9DC30394C3AF373516K(param2);
            this.xtea = new XTeaKey(_loc_4);
            var _loc_5:* = new ByteArray();
            new ByteArray().writeUTFBytes(param1);
            _loc_5.position = 0;
            var _loc_6:* = 8 - _loc_5.length % 8;
            var _loc_7:* = new ByteArray();
            new ByteArray().writeByte(_loc_6);
            _loc_5.readBytes(_loc_7, _loc_6);
            _loc_7.position = 0;
            while (_loc_7.bytesAvailable)
            {
                
                this.xtea.encrypt(_loc_7, _loc_7.position);
            }
            _loc_7.position = 0;
            _loc_3 = Base64.encodeByteArray(_loc_7);
            _loc_3 = replaceAll(_loc_3, "+", "-");
            _loc_3 = replaceAll(_loc_3, "/", "_");
            _loc_3 = replaceAll(_loc_3, "=", ".");
            return _loc_3;
        }// end function

        public function decryptBase64(param1:String, param2:Array) : String
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
            var _loc_5:* = Base64.decodeToByteArray(_loc_4);
            var _loc_6:* = K102553B9BF6692A27B4F72A7BF9DC30394C3AF373516K(param2);
            this.xtea = new XTeaKey(_loc_6);
            while (_loc_5.bytesAvailable)
            {
                
                this.xtea.decrypt(_loc_5, _loc_5.position);
            }
            _loc_5.position = 0;
            var _loc_7:* = _loc_5.readByte();
            _loc_5.position = _loc_7;
            _loc_3 = _loc_5.readUTFBytes(_loc_5.bytesAvailable);
            return _loc_3;
        }// end function

        private static function K102553B9BF6692A27B4F72A7BF9DC30394C3AF373516K(param1:Array) : ByteArray
        {
            var _loc_2:* = new ByteArray();
            if (param1.length < 4)
            {
                param1.length = 4;
            }
            var _loc_3:* = param1[0] != "" ? (param1[0]) : (0);
            var _loc_4:* = param1[1] != "" ? (param1[1]) : (0);
            var _loc_5:* = param1[2] != "" ? (param1[2]) : (0);
            var _loc_6:* = param1[3] != "" ? (param1[3]) : (0);
            trace(_loc_3 + "," + _loc_4 + "," + _loc_5 + "," + _loc_6);
            _loc_2.writeInt(_loc_3);
            _loc_2.writeInt(_loc_4);
            _loc_2.writeInt(_loc_5);
            _loc_2.writeInt(_loc_6);
            return _loc_2;
        }// end function

        public static function replaceAll(param1:String, param2:String, param3:String) : String
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
