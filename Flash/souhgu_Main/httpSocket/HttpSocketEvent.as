package httpSocket
{
    import flash.events.*;

    public class HttpSocketEvent extends Event
    {
        public var data:Object;
        public var msg:Object;
        public static const CONNECT:String = "connect";
        public static const OPEN:String = "open";
        public static const CLOSE:String = "close";
        public static const PROGRESS:String = "progress";
        public static const COMPLETE:String = "complete";
        public static const ERROR:String = "error";
        public static const CONTENT_LENGTH:String = "content_length";
        public static const NEXTFILENAME:String = "nextfilename";
        public static const FILE_LENGTH:String = "file_length";

        public function HttpSocketEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
        {
            super(param1, param2, param3);
            return;
        }// end function

    }
}
