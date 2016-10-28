package CPlayer
{
    import CPlayer.CNetStream.Cipher.*;
    import flash.net.*;
    import flash.utils.*;

    public class CNetStream extends NetStream
    {
        private var instanceId:int = 0;
        private var ttext:String = "CNetStreamID";
        private static var instanceCount:int = 0;
        private static var instanceCountMax:int = 1024;

        public function CNetStream(param1:NetConnection)
        {
            super(param1);
            this.instanceId = instanceCount + 1;
            return;
        }// end function

        public function testSet(param1:uint) : int
        {
            if (this.instanceId >= instanceCountMax)
            {
                return 0;
            }
            crossbridge_test_set(param1);
            return 1;
        }// end function

        public function testGet() : String
        {
            if (this.instanceId >= instanceCountMax)
            {
                return "";
            }
            return String(crossbridge_test_get());
        }// end function

        public function setLicense(param1:String) : int
        {
            if (this.instanceId >= instanceCountMax)
            {
                return 0;
            }
            return crossbridge_set_license(param1, this.instanceId);
        }// end function

        public function appendBytesEncrypted(param1:ByteArray) : int
        {
            if (this.instanceId >= instanceCountMax)
            {
                return 0;
            }
            var _loc_2:* = param1.length;
            var _loc_3:* = CModule.malloc(_loc_2);
            var _loc_4:* = CModule.malloc(_loc_2);
            param1.position = 0;
            CModule.writeBytes(_loc_3, _loc_2, param1);
            var _loc_5:* = crossbridge_decrypt_flv_tags(_loc_3, _loc_2, _loc_4, _loc_2, this.instanceId);
            param1.clear();
            CModule.readBytes(_loc_4, _loc_5, param1);
            CModule.free(_loc_3);
            CModule.free(_loc_4);
            super.appendBytes(param1);
            return _loc_5;
        }// end function

        public function appendBytes2(param1:ByteArray, param2:Boolean) : int
        {
            if (this.instanceId >= instanceCountMax)
            {
                return 0;
            }
            if (param2)
            {
                this.appendBytesEncrypted(param1);
            }
            else
            {
                super.appendBytes(param1);
            }
            return 1;
        }// end function

    }
}
