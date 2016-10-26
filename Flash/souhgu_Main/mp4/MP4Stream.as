package mp4
{
    import flash.utils.*;

    public class MP4Stream extends ByteArray
    {

        public function MP4Stream()
        {
            return;
        }// end function

        public function readUnsignedInt64() : Number
        {
            return readUnsignedInt() * 4294967296 + readUnsignedInt();
        }// end function

        public function readFourCC() : String
        {
            var _loc_1:* = readUnsignedInt();
            return String.fromCharCode(_loc_1 >>> 24, _loc_1 >>> 16 & 255, _loc_1 >>> 8 & 255, _loc_1 & 255);
        }// end function

        public function readString() : String
        {
            var _loc_1:* = length;
            var _loc_2:* = position;
            while (_loc_2 < _loc_1)
            {
                
                if (this[_loc_2] == 0)
                {
                    break;
                }
                _loc_2 = _loc_2 + 1;
            }
            var _loc_3:* = readUTFBytes(_loc_2 - position);
            var _loc_5:* = position + 1;
            position = _loc_5;
            return _loc_3;
        }// end function

        public function readStringWithLength(param1:uint) : String
        {
            var _loc_2:* = readByte();
            var _loc_3:* = readUTFBytes(_loc_2 > (param1 - 1) ? ((param1 - 1)) : (_loc_2));
            return _loc_3;
        }// end function

    }
}
