package mp4
{

    public class CTTSRecord extends Object
    {
        public var sampleCount:uint;
        public var sampleOffset:uint;

        public function CTTSRecord()
        {
            this.sampleCount = 0;
            this.sampleOffset = 0;
            return;
        }// end function

        public function read(param1:MP4Stream) : void
        {
            this.sampleCount = param1.readUnsignedInt();
            this.sampleOffset = param1.readUnsignedInt();
            return;
        }// end function

        public function clear() : void
        {
            return;
        }// end function

    }
}
