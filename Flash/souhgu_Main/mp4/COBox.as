package mp4
{
    import __AS3__.vec.*;

    public class COBox extends FullBox
    {
        public var offsetCount:uint;
        public var offsets:Vector.<Number>;

        public function COBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            super.read(param1);
            this.offsetCount = param1.readUnsignedInt();
            this.offsets = new Vector.<Number>(this.offsetCount);
            var _loc_2:int = 0;
            while (_loc_2 < this.offsetCount)
            {
                
                if (this.boxType == "stco")
                {
                    this.offsets[_loc_2] = param1.readUnsignedInt();
                }
                else
                {
                    this.offsets[_loc_2] = param1.readUnsignedInt64();
                }
                _loc_2++;
            }
            return;
        }// end function

        override public function clear() : void
        {
            this.offsets = null;
            this.offsetCount = NaN;
            super.clear();
            return;
        }// end function

    }
}
