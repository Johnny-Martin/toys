package mp4
{
    import __AS3__.vec.*;

    public class FTYPBox extends Box
    {
        private var majorBrand:String;
        private var minorVersion:uint;
        private var compatibleBrands:Vector.<String>;

        public function FTYPBox(param1:BoxHeader, param2:Box)
        {
            super(param1, param2);
            return;
        }// end function

        override public function read(param1:MP4Stream) : void
        {
            this.majorBrand = param1.readFourCC();
            this.minorVersion = param1.readUnsignedInt();
            this.compatibleBrands = new Vector.<String>;
            var _loc_2:* = payloadSize - 8;
            while (_loc_2 >= 4)
            {
                
                this.compatibleBrands.push(param1.readFourCC());
                _loc_2 = _loc_2 - 4;
            }
            return;
        }// end function

        override public function clear() : void
        {
            this.majorBrand = null;
            this.compatibleBrands = null;
            return;
        }// end function

    }
}
