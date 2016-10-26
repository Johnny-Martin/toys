package mp4
{
    import __AS3__.vec.*;

    public class STSZBox extends FullBox
    {
        public var constantSize:uint;
        public var sizeCount:uint;
        public var sizeTable:Vector.<uint>;

        public function STSZBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.constantSize = 0;
            this.sizeCount = 0;
            this.sizeTable = new Vector.<uint>;
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_2:int = 0;
            super.read(param1);
            this.constantSize = param1.readUnsignedInt();
            this.sizeCount = param1.readUnsignedInt();
            if (this.constantSize == 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this.sizeCount)
                {
                    
                    this.sizeTable.push(param1.readUnsignedInt());
                    _loc_2++;
                }
            }
            return;
        }// end function

        override public function clear() : void
        {
            this.sizeTable = null;
            super.clear();
            return;
        }// end function

    }
}
