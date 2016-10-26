package mp4
{

    public class MP4Sample extends Object
    {
        public var decodingTime:uint;
        public var sampleDelta:uint;
        public var compositionTimeOffset:uint;
        public var offsetInFile:Number;
        public var offsetPlayFromNow:Number;
        public var size:uint;
        public var codecId:uint;
        public var seekable:Boolean;
        public var handlerType:String;

        public function MP4Sample()
        {
            this.decodingTime = 0;
            this.compositionTimeOffset = 0;
            this.seekable = false;
            this.offsetInFile = NaN;
            this.size = 0;
            return;
        }// end function

    }
}
