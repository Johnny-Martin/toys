package com.ws.stat
{

    public class MathUtil extends Object
    {

        public function MathUtil()
        {
            return;
        }// end function

        public static function random(param1:uint, param2:uint) : uint
        {
            var _loc_3:* = Math.floor((param2 - param1) * Math.random() + param1);
            return _loc_3;
        }// end function

        public static function constrain(param1:Number, param2:Number = 0, param3:Number = 1) : Number
        {
            param1 = Math.max(param1, param2);
            param1 = Math.min(param1, param3);
            return param1;
        }// end function

        public static function forceParseFloat(param1:String) : Number
        {
            var _loc_2:* = parseFloat(param1);
            return isNaN(_loc_2) ? (0) : (_loc_2);
        }// end function

        public static function forceParseInt(param1:String, param2:uint = 0) : Number
        {
            var _loc_3:* = parseInt(param1, param2);
            return isNaN(_loc_3) ? (0) : (_loc_3);
        }// end function

        public static function zeroFill(param1:Number, param2:uint) : String
        {
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_3:* = param1.toFixed(0).match(/\d""\d/g).length;
            var _loc_4:String = "";
            if (_loc_3 < param2)
            {
                _loc_5 = param2 - _loc_3;
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_4 = _loc_4 + "0";
                    _loc_6 = _loc_6 + 1;
                }
            }
            return _loc_4 + String(param1);
        }// end function

    }
}
