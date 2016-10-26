package mp4
{
    import flash.utils.*;

    public class FLVHeader extends Object
    {
        private var _hasVideoTags:Boolean = true;
        private var _hasAudioTags:Boolean = true;
        private var offset:uint;
        public static const MIN_FILE_HEADER_BYTE_COUNT:int = 9;

        public function FLVHeader(param1:ByteArray = null)
        {
            if (param1 != null)
            {
                this.readHeader(param1);
                this.readRest(param1);
            }
            return;
        }// end function

        public function get hasAudioTags() : Boolean
        {
            return this._hasAudioTags;
        }// end function

        public function set hasAudioTags(param1:Boolean) : void
        {
            this._hasAudioTags = param1;
            return;
        }// end function

        public function get hasVideoTags() : Boolean
        {
            return this._hasVideoTags;
        }// end function

        public function set hasVideoTags(param1:Boolean) : void
        {
            this._hasVideoTags = param1;
            return;
        }// end function

        public function write(param1:ByteArray) : void
        {
            param1.writeByte(70);
            param1.writeByte(76);
            param1.writeByte(86);
            param1.writeByte(1);
            var _loc_2:uint = 0;
            if (this._hasAudioTags)
            {
                _loc_2 = _loc_2 | 4;
            }
            if (this._hasVideoTags)
            {
                _loc_2 = _loc_2 | 1;
            }
            param1.writeByte(_loc_2);
            var _loc_3:* = MIN_FILE_HEADER_BYTE_COUNT;
            param1.writeUnsignedInt(_loc_3);
            var _loc_4:uint = 0;
            param1.writeUnsignedInt(_loc_4);
            return;
        }// end function

        function readHeader(param1:ByteArray) : void
        {
            if (param1.bytesAvailable < MIN_FILE_HEADER_BYTE_COUNT)
            {
                throw new Error("FLVHeader() input too short");
            }
            if (param1.readByte() != 70)
            {
                throw new Error("FLVHeader readHeader() Signature[0] not \'F\'");
            }
            if (param1.readByte() != 76)
            {
                throw new Error("FLVHeader readHeader() Signature[1] not \'L\'");
            }
            if (param1.readByte() != 86)
            {
                throw new Error("FLVHeader readHeader() Signature[2] not \'V\'");
            }
            if (param1.readByte() != 1)
            {
                throw new Error("FLVHeader readHeader() Version not 0x01");
            }
            var _loc_2:* = param1.readByte();
            this._hasAudioTags = _loc_2 & 4 ? (true) : (false);
            this._hasVideoTags = _loc_2 & 1 ? (true) : (false);
            this.offset = param1.readUnsignedInt();
            if (this.offset < MIN_FILE_HEADER_BYTE_COUNT)
            {
                throw new Error("FLVHeader() offset smaller than minimum");
            }
            return;
        }// end function

        function readRest(param1:ByteArray) : void
        {
            var _loc_2:ByteArray = null;
            if (this.offset > MIN_FILE_HEADER_BYTE_COUNT)
            {
                if (this.offset - MIN_FILE_HEADER_BYTE_COUNT < param1.bytesAvailable - FLVTag.PREV_TAG_BYTE_COUNT)
                {
                    throw new Error("FLVHeader() input too short for nonstandard offset");
                }
                _loc_2 = new ByteArray();
                param1.readBytes(_loc_2, 0, this.offset - MIN_FILE_HEADER_BYTE_COUNT);
            }
            if (param1.bytesAvailable < FLVTag.PREV_TAG_BYTE_COUNT)
            {
                throw new Error("FLVHeader() input too short for previousTagSize0");
            }
            param1.readUnsignedInt();
            return;
        }// end function

        function get restBytesNeeded() : int
        {
            return FLVTag.PREV_TAG_BYTE_COUNT + (this.offset - MIN_FILE_HEADER_BYTE_COUNT);
        }// end function

    }
}
