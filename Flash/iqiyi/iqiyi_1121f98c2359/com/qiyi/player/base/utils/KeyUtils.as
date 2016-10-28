package com.qiyi.player.base.utils
{

    public class KeyUtils extends Object
    {

        public function KeyUtils()
        {
            return;
        }// end function

        public static function getDispatchKey(param1:uint, param2:String) : String
        {
            var _loc_3:String = ")(*&^flash@#$%a";
            var _loc_4:* = Math.floor(param1 / (10 * 60));
            return MD5.calculate(_loc_4 + _loc_3 + param2);
        }// end function

        public static function getPassportKey(param1:uint) : String
        {
            var _loc_2:* = param1;
            var _loc_3:uint = 2391461978;
            var _loc_4:* = _loc_3 % 17;
            _loc_2 = rotateRight(_loc_2, _loc_4);
            var _loc_5:* = _loc_2 ^ _loc_3;
            return _loc_5.toString();
        }// end function

        private static function rotateRight(param1:uint, param2:uint) : uint
        {
            var _loc_3:uint = 0;
            var _loc_4:* = param1;
            var _loc_5:int = 0;
            while (_loc_5 < param2)
            {
                
                _loc_3 = _loc_4 & 1;
                _loc_4 = _loc_4 >>> 1;
                _loc_3 = _loc_3 << 31;
                _loc_4 = _loc_4 + _loc_3;
                _loc_5++;
            }
            return _loc_4;
        }// end function

        public static function getVrsEncodeCode(param1:String) : String
        {
            var _loc_6:uint = 0;
            var _loc_2:String = "";
            var _loc_3:* = param1.split("-");
            var _loc_4:* = _loc_3.length;
            var _loc_5:* = _loc_4 - 1;
            while (_loc_5 >= 0)
            {
                
                _loc_6 = getVRSXORCode(parseInt(_loc_3[_loc_4 - _loc_5 - 1], 16), _loc_5);
                _loc_2 = String.fromCharCode(_loc_6) + _loc_2;
                _loc_5 = _loc_5 - 1;
            }
            return _loc_2;
        }// end function

        private static function getVRSXORCode(param1:uint, param2:uint) : uint
        {
            var _loc_3:* = param2 % 3;
            if (_loc_3 == 1)
            {
                return param1 ^ 121;
            }
            if (_loc_3 == 2)
            {
                return param1 ^ 72;
            }
            return param1 ^ 103;
        }// end function

    }
}
