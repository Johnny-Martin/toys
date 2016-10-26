package mp4
{

    public class MDHDBox extends FullBox
    {
        public var creationTime:Number;
        public var modificationTime:Number;
        public var timeScale:uint;
        public var duration:Number;
        public var pad:uint;
        public var language:String;
        public var reserved:uint;

        public function MDHDBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.timeScale = NaN;
            this.duration = 0;
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            super.read(param1);
            if (version != 0)
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
            var _loc_2:* = param1.readUnsignedShort();
            this.pad = _loc_2 >>> 15;
            this.language = String.fromCharCode(96 + (_loc_2 >>> 10 & 31), 96 + (_loc_2 >>> 5 & 31), 96 + (_loc_2 & 31));
            this.reserved = param1.readUnsignedShort();
            return;
        }// end function

        override public function clear() : void
        {
            this.language = null;
            super.clear();
            return;
        }// end function

    }
}
