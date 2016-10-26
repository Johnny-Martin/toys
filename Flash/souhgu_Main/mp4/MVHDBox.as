package mp4
{
    import __AS3__.vec.*;

    public class MVHDBox extends FullBox
    {
        public var creationTime:Number;
        public var modificationTime:Number;
        public var timeScale:uint;
        public var duration:Number;
        public var rate:Number;
        public var volume:Number;
        public var reserved1:uint;
        public var reserved2:Vector.<uint>;
        public var matrix:Vector.<int>;
        public var reserved3:Vector.<uint>;
        public var nextTrackId:uint;

        public function MVHDBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.reserved2 = new Vector.<uint>(2);
            this.matrix = new Vector.<int>(9);
            this.reserved3 = new Vector.<uint>(6);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            super.read(param1);
            if (this.version != 0)
            {
                this.creationTime = param1.readUnsignedInt64();
                this.modificationTime = param1.readUnsignedInt64();
                this.timeScale = param1.readUnsignedInt();
                this.duration = param1.readUnsignedInt64();
            }
            else
            {
                this.creationTime = param1.readUnsignedInt();
                this.modificationTime = param1.readUnsignedInt();
                this.timeScale = param1.readUnsignedInt();
                this.duration = param1.readUnsignedInt();
            }
            this.rate = param1.readInt() / 65536;
            this.volume = param1.readShort() / 256;
            this.reserved1 = param1.readUnsignedShort();
            this.reserved2[0] = param1.readUnsignedInt();
            this.reserved2[1] = param1.readUnsignedInt();
            var _loc_2:int = 0;
            while (_loc_2 < 9)
            {
                
                this.matrix.push(param1.readInt());
                _loc_2++;
            }
            var _loc_3:int = 0;
            while (_loc_3 < 6)
            {
                
                this.reserved3.push(param1.readUnsignedInt());
                _loc_3++;
            }
            this.nextTrackId = param1.readUnsignedInt();
            return;
        }// end function

        override public function clear() : void
        {
            this.reserved2 = null;
            this.matrix = null;
            this.reserved3 = null;
            super.clear();
            return;
        }// end function

    }
}
