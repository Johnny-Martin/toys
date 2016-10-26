package mp4
{

    public class MDATBox extends Box
    {
        public var bytesReaded:uint;

        public function MDATBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_2:* = this.payloadSize - this.bytesReaded;
            param1.position = param1.position + (param1.bytesAvailable > _loc_2 ? (_loc_2) : (param1.bytesAvailable));
            return;
        }// end function

        override public function clear() : void
        {
            super.clear();
            return;
        }// end function

    }
}
