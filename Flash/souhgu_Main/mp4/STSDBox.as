package mp4
{
    import __AS3__.vec.*;

    public class STSDBox extends FullBox
    {
        public var count:uint;
        public var descriptions:Vector.<Box>;

        public function STSDBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.descriptions = new Vector.<Box>;
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_3:BoxHeader = null;
            var _loc_4:Box = null;
            super.read(param1);
            this.count = param1.readUnsignedInt();
            var _loc_2:int = 0;
            while (_loc_2 < this.count)
            {
                
                _loc_3 = new BoxHeader();
                _loc_3.read(param1);
                _loc_4 = BoxFactory.newBox(_loc_3, this);
                _loc_4.read(param1);
                this.descriptions.push(_loc_4);
                _loc_2++;
            }
            return;
        }// end function

        override public function clear() : void
        {
            var _loc_1:int = 0;
            while (_loc_1 < this.count)
            {
                
                this.descriptions[_loc_1].clear();
                this.descriptions[_loc_1] = null;
                _loc_1++;
            }
            this.descriptions = null;
            super.clear();
            return;
        }// end function

    }
}
