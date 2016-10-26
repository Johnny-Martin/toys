package mp4
{
    import __AS3__.vec.*;

    public class TKHDBox extends FullBox
    {
        public var creationTime:Number;
        public var modificationTime:Number;
        public var trackId:uint;
        public var reserved1:uint;
        public var duration:Number;
        public var reserved2:Vector.<uint>;
        public var layer:int;
        public var alternateGroup:int;
        public var volume:Number;
        public var reserved3:uint;
        public var matrix:Vector.<int>;
        public var width:Number;
        public var height:Number;

        public function TKHDBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.reserved2 = new Vector.<uint>(2);
            this.matrix = new Vector.<int>(9);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            super.read(param1);
            if (version == 0)
            {
                this.creationTime = param1.readUnsignedInt();
                this.modificationTime = param1.readUnsignedInt();
            }
            else
            {
                this.creationTime = param1.readUnsignedInt64();
                this.modificationTime = param1.readUnsignedInt64();
            }
            this.trackId = param1.readUnsignedInt();
            this.reserved1 = param1.readUnsignedInt();
            if (version == 0)
            {
                this.duration = param1.readUnsignedInt();
            }
            else
            {
                this.duration = param1.readUnsignedInt64();
            }
            this.reserved2[0] = param1.readUnsignedInt();
            this.reserved2[1] = param1.readUnsignedInt();
            this.layer = param1.readShort();
            this.alternateGroup = param1.readShort();
            this.volume = param1.readShort() / 256;
            this.reserved3 = param1.readUnsignedShort();
            var _loc_2:int = 0;
            while (_loc_2 < 9)
            {
                
                this.matrix.push(param1.readInt());
                _loc_2++;
            }
            this.width = param1.readUnsignedInt() / 65536;
            this.height = param1.readUnsignedInt() / 65536;
            return;
        }// end function

        override public function clear() : void
        {
            this.reserved2 = null;
            this.matrix = null;
            super.clear();
            return;
        }// end function

    }
}
