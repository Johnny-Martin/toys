package mp4
{
    import __AS3__.vec.*;

    public class STSSBox extends FullBox
    {
        public var syncCount:uint;
        public var syncTable:Vector.<uint>;

        public function STSSBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            this.syncCount = 0;
            this.syncTable = new Vector.<uint>;
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            super.read(param1);
            this.syncCount = param1.readUnsignedInt();
            var _loc_2:int = 0;
            while (_loc_2 < this.syncCount)
            {
                
                this.syncTable.push(param1.readUnsignedInt());
                _loc_2++;
            }
            return;
        }// end function

        override public function clear() : void
        {
            this.syncTable = null;
            super.clear();
            return;
        }// end function

    }
}
