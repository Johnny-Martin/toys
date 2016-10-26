package mp4
{
    import flash.utils.*;

    public class AVCCBox extends Box
    {
        public var configRecord:ByteArray;

        public function AVCCBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.configRecord = new ByteArray();
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            param1.readBytes(this.configRecord, 0, this.payloadSize);
            return;
        }// end function

        override public function clear() : void
        {
            this.configRecord = null;
            super.clear();
            return;
        }// end function

    }
}
