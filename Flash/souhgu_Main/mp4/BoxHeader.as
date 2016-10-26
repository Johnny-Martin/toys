package mp4
{

    public class BoxHeader extends Object
    {
        public var totalSize:uint;
        public var boxType:String;
        public var extendedSize:Number;

        public function BoxHeader()
        {
            this.totalSize = NaN;
            this.boxType = null;
            this.extendedSize = NaN;
            return;
        }// end function

        public function get boxSize() : Number
        {
            if (this.totalSize == 1)
            {
                return this.extendedSize;
            }
            return this.totalSize;
        }// end function

        public function get headerSize() : uint
        {
            if (this.totalSize == 1)
            {
                return 16;
            }
            return 8;
        }// end function

        public function get payloadSize() : Number
        {
            return this.boxSize - this.headerSize;
        }// end function

        public function read(param1:MP4Stream) : void
        {
            var _loc_2:* = param1.position;
            if (param1.bytesAvailable < 8)
            {
                throw new MP4ParserError("No Enough Bytes Available", MP4ParserError.NEEDMOREBYTES);
            }
            var _loc_3:* = param1.readUnsignedInt();
            var _loc_4:* = param1.readFourCC();
            var _loc_5:* = NaN;
            if (_loc_3 == 1)
            {
                if (param1.bytesAvailable < 8)
                {
                    param1.position = _loc_2;
                    throw new MP4ParserError("No Enough Bytes Available", MP4ParserError.NEEDMOREBYTES);
                }
                _loc_5 = param1.readUnsignedInt64();
            }
            this.totalSize = _loc_3;
            this.boxType = _loc_4;
            this.extendedSize = _loc_5;
            return;
        }// end function

        public function clear() : void
        {
            this.totalSize = NaN;
            this.boxType = null;
            this.extendedSize = NaN;
            return;
        }// end function

    }
}
