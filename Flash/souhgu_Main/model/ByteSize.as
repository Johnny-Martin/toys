package model
{

    public class ByteSize extends Object
    {
        public static var _CHUNKSIZE:int = 2097152;
        public static var CNDDLSIZE1:int = 1048576;
        public static var CNDDLSIZE2:int = 2097152;
        public static var PICESIZE:int = 65536;
        public static var SHAREMEMORY:int = 419430400;
        public static var BLACKP1:int = 1;
        public static var BLACKP2:int = 2;
        public static var BLACKP3:int = 3;
        public static var NSLEN:int = 50;
        public static var NSINSERTNUM:int = 40;
        public static var CHUNKTNUM:int = 90;
        public static var LOADSTOPTNUM:int = 300;
        public static var LOWSECOND:int = 5;
        public static var SEEKSECOND:int = 15;
        public static var F1_low:int = 15;
        public static var F1_high:int = 40;
        public static var F2_low:int = 25;
        public static var F2_high:int = 50;
        public static var FSec:int = 10;
        public static var ROLLBACKIDX:int = 4;
        public static var ROLLBACKIDX302:int = 9;
        public static var FILElENGTHDIF:int = 512000;
        public static var CDDIF:int = 5;
        public static var BLACKTIME:int = 25000;

        public function ByteSize()
        {
            return;
        }// end function

        public static function setISSOHUTEST(param1:Boolean, param2:Boolean) : void
        {
            if (param1)
            {
                if (param2)
                {
                    F1_low = 15;
                    F2_low = 25;
                }
                else
                {
                    F1_high = 40;
                    F2_high = 50;
                }
            }
            else if (param2)
            {
                F1_low = 12;
                F2_low = 22;
            }
            else
            {
                F1_high = 30;
                F2_high = 40;
            }
            return;
        }// end function

        public static function setLineNum(param1:String) : void
        {
            switch(param1)
            {
                case "31":
                {
                    F1_low = 20;
                    F2_low = 30;
                    F1_high = 40;
                    F2_high = 50;
                    _CHUNKSIZE = 2097152;
                    PICESIZE = 262144;
                    break;
                }
                default:
                {
                    F1_low = 20;
                    F2_low = 30;
                    F1_high = 40;
                    F2_high = 50;
                    _CHUNKSIZE = 2097152;
                    PICESIZE = 65536;
                    break;
                    break;
                }
            }
            return;
        }// end function

        public static function get CHUNKSIZE() : int
        {
            return _CHUNKSIZE;
        }// end function

        public static function set CHUNKSIZE(param1:int) : void
        {
            _CHUNKSIZE = param1;
            return;
        }// end function

    }
}
