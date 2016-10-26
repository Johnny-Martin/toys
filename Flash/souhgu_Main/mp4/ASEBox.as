package mp4
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class ASEBox extends ContainerBox
    {
        public var reserved1:ByteArray;
        public var dataReferenceIndex:uint;
        public var reserved2:Vector.<uint>;
        public var channelCount:uint;
        public var sampleSize:uint;
        public var predefined1:uint;
        public var reserved3:uint;
        public var sampleRate:Number;

        public function ASEBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.reserved1 = new ByteArray();
            this.reserved2 = new Vector.<uint>(2);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_2:* = param1.position;
            param1.readBytes(this.reserved1, 0, 6);
            this.dataReferenceIndex = param1.readUnsignedShort();
            this.reserved2[0] = param1.readUnsignedInt();
            this.reserved2[1] = param1.readUnsignedInt();
            this.channelCount = param1.readUnsignedShort();
            this.sampleSize = param1.readUnsignedShort();
            this.predefined1 = param1.readUnsignedShort();
            this.reserved3 = param1.readUnsignedShort();
            this.sampleRate = param1.readUnsignedInt() / 65536;
            var _loc_3:* = this.payloadSize - (param1.position - _loc_2);
            readBoxes(param1, _loc_3);
            return;
        }// end function

        override public function clear() : void
        {
            this.reserved2 = null;
            this.reserved1 = null;
            super.clear();
            return;
        }// end function

    }
}
