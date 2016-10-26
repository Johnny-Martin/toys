package mp4
{
    import __AS3__.vec.*;

    public class HDLRBox extends FullBox
    {
        public var predefined:uint;
        public var handlerType:String;
        public var reserved:Vector.<uint>;
        public var name:String;
        public static const VIDE:String = "vide";
        public static const SOUN:String = "soun";

        public function HDLRBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.reserved = new Vector.<uint>(3);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_2:* = param1.position;
            super.read(param1);
            this.predefined = param1.readUnsignedInt();
            this.handlerType = param1.readFourCC();
            this.reserved[0] = param1.readUnsignedInt();
            this.reserved[1] = param1.readUnsignedInt();
            this.reserved[2] = param1.readUnsignedInt();
            this.name = param1.readString();
            param1.position = _loc_2 + this.payloadSize;
            return;
        }// end function

        override public function clear() : void
        {
            this.handlerType = null;
            this.reserved = null;
            this.name = null;
            super.clear();
            return;
        }// end function

    }
}
