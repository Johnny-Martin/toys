package loader.vod
{
    import flash.utils.*;

    public class VideoData extends Object
    {
        public var data:Object;

        public function VideoData()
        {
            return;
        }// end function

        public function get headers() : ByteArray
        {
            return this.data["headers"];
        }// end function

        public function get time() : Number
        {
            return this.data["time"];
        }// end function

        public function get bytes() : ByteArray
        {
            return this.data["bytes"];
        }// end function

        public function get duration() : Number
        {
            return this.data["duration"];
        }// end function

        public function get jumpFragment() : Boolean
        {
            return this.data["jumpFragment"];
        }// end function

        public function get encode() : Boolean
        {
            return this.data["encode"];
        }// end function

    }
}
