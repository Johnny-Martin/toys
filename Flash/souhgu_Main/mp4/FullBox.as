package mp4
{

    public class FullBox extends Box
    {
        public var version:uint;
        public var flags:uint;

        public function FullBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_2:* = param1.readUnsignedInt();
            this.version = _loc_2 >>> 24;
            this.flags = _loc_2 & 16777215;
            return;
        }// end function

        override public function clear() : void
        {
            super.clear();
            return;
        }// end function

    }
}
