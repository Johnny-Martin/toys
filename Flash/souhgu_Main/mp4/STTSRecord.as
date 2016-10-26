package mp4
{

    public class STTSRecord extends Object
    {
        public var sampleCount:uint;
        public var sampleDelta:uint;

        public function STTSRecord()
        {
            this.sampleCount = 0;
            this.sampleDelta = 0;
            return;
        }// end function

        public function read(param1:MP4Stream) : void
        {
            this.sampleCount = param1.readUnsignedInt();
            this.sampleDelta = param1.readUnsignedInt();
            return;
        }// end function

        public function clear() : void
        {
            return;
        }// end function

    }
}
