package test
{
    import flash.utils.*;

    public class HexDump extends Object
    {

        public function HexDump()
        {
            return;
        }// end function

        public static function dump(param1:ByteArray) : String
        {
            var _loc_7:int = 0;
            var _loc_8:String = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_2:* = fillUp("Offset", 8, " ") + "  00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F\n";
            var _loc_3:int = 0;
            var _loc_4:* = param1.length;
            var _loc_5:String = "";
            param1.position = 0;
            var _loc_6:int = 0;
            while (_loc_6 < _loc_4)
            {
                
                _loc_5 = _loc_5 + (fillUp(_loc_3.toString(16).toUpperCase(), 8, "0") + "  ");
                _loc_7 = Math.min(16, param1.length - param1.position);
                _loc_8 = "";
                _loc_9 = 0;
                while (_loc_9 < 16)
                {
                    
                    if (_loc_9 < _loc_7)
                    {
                        _loc_10 = param1.readUnsignedByte();
                        _loc_8 = _loc_8 + (_loc_10 >= 32 ? (String.fromCharCode(_loc_10)) : ("."));
                        _loc_5 = _loc_5 + (fillUp(_loc_10.toString(16).toUpperCase(), 2, "0") + " ");
                        _loc_3++;
                    }
                    else
                    {
                        _loc_5 = _loc_5 + "   ";
                        _loc_8 = _loc_8 + " ";
                    }
                    _loc_9++;
                }
                _loc_5 = _loc_5 + (" " + _loc_8 + "\n");
                _loc_6 = _loc_6 + 15;
            }
            _loc_2 = _loc_2 + _loc_5;
            return _loc_2;
        }// end function

        private static function fillUp(param1:String, param2:int, param3:String) : String
        {
            var _loc_4:* = param2 - param1.length;
            var _loc_5:String = "";
            while (--_loc_4 > -1)
            {
                
                _loc_5 = _loc_5 + param3;
            }
            return _loc_5 + param1;
        }// end function

    }
}
