package mp4
{

    public class MP4ParserError extends Error
    {
        public static const NEEDMOREBYTES:int = 2001;

        public function MP4ParserError(param1:String, param2:int)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
