package mp4
{
    import flash.utils.*;

    public class ESDSBox extends FullBox
    {
        public var decoderSpecificInfo:ByteArray;
        private static const ES:uint = 3;
        private static const DECODER_CONFIG:uint = 4;
        private static const DECODER_SPECIFIC_INFO:uint = 5;

        public function ESDSBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.decoderSpecificInfo = new ByteArray();
            return;
        }// end function

        private function readDescriptorLength(param1:MP4Stream) : uint
        {
            var _loc_4:uint = 0;
            var _loc_2:uint = 0;
            var _loc_3:int = 0;
            while (_loc_3 < 4)
            {
                
                _loc_4 = param1.readUnsignedByte();
                _loc_2 = _loc_2 << 7 | _loc_4 & 127;
                if (!(_loc_4 & 128))
                {
                    break;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_4:uint = 0;
            var _loc_2:* = param1.position;
            super.read(param1);
            var _loc_3:* = param1.readUnsignedByte();
            if (_loc_3 == ES)
            {
                this.readDescriptorLength(param1);
                param1.position = param1.position + 3;
            }
            _loc_3 = param1.readUnsignedByte();
            if (_loc_3 == DECODER_CONFIG)
            {
                this.readDescriptorLength(param1);
                param1.position = param1.position + 13;
            }
            _loc_3 = param1.readUnsignedByte();
            if (_loc_3 == DECODER_SPECIFIC_INFO)
            {
                _loc_4 = this.readDescriptorLength(param1);
                param1.readBytes(this.decoderSpecificInfo, 0, _loc_4);
            }
            param1.position = _loc_2 + this.payloadSize;
            return;
        }// end function

        override public function clear() : void
        {
            this.decoderSpecificInfo = null;
            super.clear();
            return;
        }// end function

    }
}
