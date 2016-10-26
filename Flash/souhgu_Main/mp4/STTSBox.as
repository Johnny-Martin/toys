﻿package mp4
{
    import __AS3__.vec.*;

    public class STTSBox extends FullBox
    {
        public var count:uint;
        public var entries:Vector.<STTSRecord>;

        public function STTSBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            var _loc_3:STTSRecord = null;
            super.read(param1);
            this.count = param1.readUnsignedInt();
            this.entries = new Vector.<STTSRecord>(this.count);
            var _loc_2:int = 0;
            while (_loc_2 < this.count)
            {
                
                _loc_3 = new STTSRecord();
                _loc_3.read(param1);
                this.entries[_loc_2] = _loc_3;
                _loc_2++;
            }
            return;
        }// end function

        override public function clear() : void
        {
            var _loc_1:int = 0;
            while (_loc_1 < this.count)
            {
                
                this.entries[_loc_1].clear();
                this.entries[_loc_1] = null;
                _loc_1++;
            }
            this.entries = null;
            super.clear();
            return;
        }// end function

    }
}
