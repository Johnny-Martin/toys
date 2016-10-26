package mp4
{

    public class STSCRecord extends Object
    {
        public var firstChunk:uint;
        public var samplesPerChunk:uint;
        public var sampleDescIndex:uint;

        public function STSCRecord()
        {
            this.firstChunk = 1;
            this.sampleDescIndex = 1;
            this.samplesPerChunk = 0;
            return;
        }// end function

        public function read(param1:MP4Stream) : void
        {
            this.firstChunk = param1.readUnsignedInt();
            this.samplesPerChunk = param1.readUnsignedInt();
            this.sampleDescIndex = param1.readUnsignedInt();
            return;
        }// end function

        public function clear() : void
        {
            return;
        }// end function

    }
}
