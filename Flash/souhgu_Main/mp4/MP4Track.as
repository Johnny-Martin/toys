package mp4
{
    import __AS3__.vec.*;

    public class MP4Track extends Object
    {
        public var timeScale:uint;
        public var duration:Number;
        public var samples:Vector.<MP4Sample>;
        public var codecs:Vector.<int>;
        public var handlerType:String;
        public var frameCount:uint;

        public function MP4Track()
        {
            this.timeScale = NaN;
            this.duration = 0;
            this.samples = new Vector.<MP4Sample>;
            this.codecs = new Vector.<int>;
            this.frameCount = 0;
            return;
        }// end function

        public function clear() : void
        {
            this.samples = null;
            this.codecs = null;
            this.handlerType = null;
            return;
        }// end function

    }
}
