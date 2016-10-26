package mp4
{

    public class Box extends Object
    {
        public var header:BoxHeader;
        public var container:Box;

        public function Box(param1:BoxHeader, param2:Box)
        {
            this.header = param1;
            this.container = param2;
            return;
        }// end function

        public function get headerSize() : uint
        {
            return this.header.headerSize;
        }// end function

        public function get payloadSize() : Number
        {
            return this.header.payloadSize;
        }// end function

        public function get boxType() : String
        {
            return this.header.boxType;
        }// end function

        public function get boxSize() : Number
        {
            return this.header.boxSize;
        }// end function

        public function read(param1:MP4Stream) : void
        {
            return;
        }// end function

        public function clear() : void
        {
            this.container = null;
            this.header.clear();
            this.header = null;
            return;
        }// end function

    }
}
