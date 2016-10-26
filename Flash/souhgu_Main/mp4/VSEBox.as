package mp4
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class VSEBox extends ContainerBox
    {
        public var reserved1:ByteArray;
        public var dataReferenceIndex:uint;
        public var predefined1:uint;
        public var reserved2:uint;
        public var predefined2:Vector.<uint>;
        public var width:uint;
        public var height:uint;
        public var horizResolution:Number;
        public var vertResolution:Number;
        public var reserved3:uint;
        public var frameCount:uint;
        public var compressorName:String;
        public var depth:uint;
        public var predefined3:int;

        public function VSEBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.reserved1 = new ByteArray();
            this.predefined2 = new Vector.<uint>(3);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_2:* = param1.position;
            param1.readBytes(this.reserved1, 0, 6);
            this.dataReferenceIndex = param1.readUnsignedShort();
            this.predefined1 = param1.readUnsignedShort();
            this.reserved2 = param1.readUnsignedShort();
            this.predefined2[0] = param1.readUnsignedInt();
            this.predefined2[1] = param1.readUnsignedInt();
            this.predefined2[2] = param1.readUnsignedInt();
            this.width = param1.readUnsignedShort();
            this.height = param1.readUnsignedShort();
            this.horizResolution = param1.readUnsignedInt() / 65536;
            this.vertResolution = param1.readUnsignedInt() / 65536;
            this.reserved3 = param1.readUnsignedInt();
            this.frameCount = param1.readUnsignedShort();
            var _loc_3:* = param1.position;
            this.compressorName = param1.readStringWithLength(32);
            param1.position = _loc_3 + 32;
            this.depth = param1.readUnsignedShort();
            this.predefined3 = param1.readShort();
            var _loc_4:* = this.payloadSize - (param1.position - _loc_2);
            readBoxes(param1, _loc_4);
            return;
        }// end function

        override public function clear() : void
        {
            this.reserved1 = null;
            this.predefined2 = null;
            super.clear();
            return;
        }// end function

    }
}
