package mp4
{
    import __AS3__.vec.*;

    public class ContainerBox extends Box
    {
        public var boxes:Vector.<Box>;

        public function ContainerBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.boxes = new Vector.<Box>;
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            this.readBoxes(param1, boxSize - headerSize);
            return;
        }// end function

        protected function readBoxes(param1:MP4Stream, param2:Number) : void
        {
            var _loc_3:BoxHeader = null;
            var _loc_4:Box = null;
            while (param2 > 0)
            {
                
                _loc_3 = new BoxHeader();
                _loc_3.read(param1);
                _loc_4 = BoxFactory.newBox(_loc_3, this);
                _loc_4.read(param1);
                this.boxes.push(_loc_4);
                param2 = param2 - _loc_4.boxSize;
            }
            return;
        }// end function

        public function getBoxes(param1:String) : Vector.<Box>
        {
            var _loc_2:* = new Vector.<Box>;
            var _loc_3:int = 0;
            while (_loc_3 < this.boxes.length)
            {
                
                if (this.boxes[_loc_3].boxType == param1)
                {
                    _loc_2.push(this.boxes[_loc_3]);
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function getBox(param1:String) : Box
        {
            var _loc_2:* = this.getBoxes(param1);
            if (_loc_2 != null && _loc_2.length >= 1)
            {
                return _loc_2[0];
            }
            return null;
        }// end function

        override public function clear() : void
        {
            var _loc_1:int = 0;
            while (_loc_1 < this.boxes.length)
            {
                
                this.boxes[_loc_1].clear();
                this.boxes[_loc_1] = null;
                _loc_1++;
            }
            this.boxes = null;
            super.clear();
            return;
        }// end function

    }
}
