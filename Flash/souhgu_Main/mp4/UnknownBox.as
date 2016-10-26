package mp4
{
    import flash.utils.*;

    public class UnknownBox extends Box
    {
        public var payload:ByteArray;

        public function UnknownBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.payload = new ByteArray();
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            param1.readBytes(this.payload, 0, this.payloadSize);
            return;
        }// end function

        override public function clear() : void
        {
            this.payload = null;
            super.clear();
            return;
        }// end function

    }
}
