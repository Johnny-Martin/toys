package com.qiyi.player.base.utils
{

    public class MD5 extends Object
    {

        public function MD5()
        {
            return;
        }// end function

        public static function calculate(param1:String) : String
        {
            return hex_md5(param1);
        }// end function

        private static function hex_md5(param1:String) : String
        {
            return binl2hex(core_md5(str2binl(param1), param1.length * 8));
        }// end function

        private static function core_md5(param1:Array, param2:Number) : Array
        {
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << param2 % 32;
            param1[(param2 + 64 >>> 9 << 4) + 14] = param2;
            var _loc_3:Number = 1732584193;
            var _loc_4:Number = -271733879;
            var _loc_5:Number = -1732584194;
            var _loc_6:Number = 271733878;
            var _loc_7:Number = 0;
            while (_loc_7 < param1.length)
            {
                
                _loc_8 = _loc_3;
                _loc_9 = _loc_4;
                _loc_10 = _loc_5;
                _loc_11 = _loc_6;
                _loc_3 = md5_ff(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 0], 7, -680876936);
                _loc_6 = md5_ff(_loc_6, _loc_3, _loc_4, _loc_5, param1[(_loc_7 + 1)], 12, -389564586);
                _loc_5 = md5_ff(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 2], 17, 606105819);
                _loc_4 = md5_ff(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 3], 22, -1044525330);
                _loc_3 = md5_ff(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 4], 7, -176418897);
                _loc_6 = md5_ff(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 5], 12, 1200080426);
                _loc_5 = md5_ff(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 6], 17, -1473231341);
                _loc_4 = md5_ff(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 7], 22, -45705983);
                _loc_3 = md5_ff(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 8], 7, 1770035416);
                _loc_6 = md5_ff(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 9], 12, -1958414417);
                _loc_5 = md5_ff(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 10], 17, -42063);
                _loc_4 = md5_ff(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 11], 22, -1990404162);
                _loc_3 = md5_ff(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 12], 7, 1804603682);
                _loc_6 = md5_ff(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 13], 12, -40341101);
                _loc_5 = md5_ff(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 14], 17, -1502002290);
                _loc_4 = md5_ff(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 15], 22, 1236535329);
                _loc_3 = md5_gg(_loc_3, _loc_4, _loc_5, _loc_6, param1[(_loc_7 + 1)], 5, -165796510);
                _loc_6 = md5_gg(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 6], 9, -1069501632);
                _loc_5 = md5_gg(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 11], 14, 643717713);
                _loc_4 = md5_gg(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 0], 20, -373897302);
                _loc_3 = md5_gg(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 5], 5, -701558691);
                _loc_6 = md5_gg(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 10], 9, 38016083);
                _loc_5 = md5_gg(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 15], 14, -660478335);
                _loc_4 = md5_gg(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 4], 20, -405537848);
                _loc_3 = md5_gg(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 9], 5, 568446438);
                _loc_6 = md5_gg(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 14], 9, -1019803690);
                _loc_5 = md5_gg(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 3], 14, -187363961);
                _loc_4 = md5_gg(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 8], 20, 1163531501);
                _loc_3 = md5_gg(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 13], 5, -1444681467);
                _loc_6 = md5_gg(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 2], 9, -51403784);
                _loc_5 = md5_gg(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 7], 14, 1735328473);
                _loc_4 = md5_gg(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 12], 20, -1926607734);
                _loc_3 = md5_hh(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 5], 4, -378558);
                _loc_6 = md5_hh(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 8], 11, -2022574463);
                _loc_5 = md5_hh(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 11], 16, 1839030562);
                _loc_4 = md5_hh(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 14], 23, -35309556);
                _loc_3 = md5_hh(_loc_3, _loc_4, _loc_5, _loc_6, param1[(_loc_7 + 1)], 4, -1530992060);
                _loc_6 = md5_hh(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 4], 11, 1272893353);
                _loc_5 = md5_hh(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 7], 16, -155497632);
                _loc_4 = md5_hh(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 10], 23, -1094730640);
                _loc_3 = md5_hh(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 13], 4, 681279174);
                _loc_6 = md5_hh(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 0], 11, -358537222);
                _loc_5 = md5_hh(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 3], 16, -722521979);
                _loc_4 = md5_hh(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 6], 23, 76029189);
                _loc_3 = md5_hh(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 9], 4, -640364487);
                _loc_6 = md5_hh(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 12], 11, -421815835);
                _loc_5 = md5_hh(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 15], 16, 530742520);
                _loc_4 = md5_hh(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 2], 23, -995338651);
                _loc_3 = md5_ii(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 0], 6, -198630844);
                _loc_6 = md5_ii(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 7], 10, 1126891415);
                _loc_5 = md5_ii(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 14], 15, -1416354905);
                _loc_4 = md5_ii(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 5], 21, -57434055);
                _loc_3 = md5_ii(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 12], 6, 1700485571);
                _loc_6 = md5_ii(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 3], 10, -1894986606);
                _loc_5 = md5_ii(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 10], 15, -1051523);
                _loc_4 = md5_ii(_loc_4, _loc_5, _loc_6, _loc_3, param1[(_loc_7 + 1)], 21, -2054922799);
                _loc_3 = md5_ii(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 8], 6, 1873313359);
                _loc_6 = md5_ii(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 15], 10, -30611744);
                _loc_5 = md5_ii(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 6], 15, -1560198380);
                _loc_4 = md5_ii(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 13], 21, 1309151649);
                _loc_3 = md5_ii(_loc_3, _loc_4, _loc_5, _loc_6, param1[_loc_7 + 4], 6, -145523070);
                _loc_6 = md5_ii(_loc_6, _loc_3, _loc_4, _loc_5, param1[_loc_7 + 11], 10, -1120210379);
                _loc_5 = md5_ii(_loc_5, _loc_6, _loc_3, _loc_4, param1[_loc_7 + 2], 15, 718787259);
                _loc_4 = md5_ii(_loc_4, _loc_5, _loc_6, _loc_3, param1[_loc_7 + 9], 21, -343485551);
                _loc_3 = safe_add(_loc_3, _loc_8);
                _loc_4 = safe_add(_loc_4, _loc_9);
                _loc_5 = safe_add(_loc_5, _loc_10);
                _loc_6 = safe_add(_loc_6, _loc_11);
                _loc_7 = _loc_7 + 16;
            }
            return new Array(_loc_3, _loc_4, _loc_5, _loc_6);
        }// end function

        private static function md5_cmn(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
        {
            return safe_add(bit_rol(safe_add(safe_add(param2, param1), safe_add(param4, param6)), param5), param3);
        }// end function

        private static function md5_ff(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
        {
            return md5_cmn(param2 & param3 | ~param2 & param4, param1, param2, param5, param6, param7);
        }// end function

        private static function md5_gg(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
        {
            return md5_cmn(param2 & param4 | param3 & ~param4, param1, param2, param5, param6, param7);
        }// end function

        private static function md5_hh(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
        {
            return md5_cmn(param2 ^ param3 ^ param4, param1, param2, param5, param6, param7);
        }// end function

        private static function md5_ii(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
        {
            return md5_cmn(param3 ^ (param2 | ~param4), param1, param2, param5, param6, param7);
        }// end function

        private static function bit_rol(param1:Number, param2:Number) : Number
        {
            return param1 << param2 | param1 >>> 32 - param2;
        }// end function

        private static function safe_add(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = (param1 & 65535) + (param2 & 65535);
            var _loc_4:* = (param1 >> 16) + (param2 >> 16) + (_loc_3 >> 16);
            return _loc_4 << 16 | _loc_3 & 65535;
        }// end function

        private static function str2binl(param1:String) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:* = (1 << 8) - 1;
            var _loc_4:Number = 0;
            while (_loc_4 < param1.length * 8)
            {
                
                _loc_2[_loc_4 >> 5] = _loc_2[_loc_4 >> 5] | (param1.charCodeAt(_loc_4 / 8) & _loc_3) << _loc_4 % 32;
                _loc_4 = _loc_4 + 8;
            }
            return _loc_2;
        }// end function

        private static function binl2hex(param1:Array) : String
        {
            var _loc_2:* = new String("");
            var _loc_3:* = new String("0123456789abcdef");
            var _loc_4:Number = 0;
            while (_loc_4 < param1.length * 4)
            {
                
                _loc_2 = _loc_2 + (_loc_3.charAt(param1[_loc_4 >> 2] >> _loc_4 % 4 * 8 + 4 & 15) + _loc_3.charAt(param1[_loc_4 >> 2] >> _loc_4 % 4 * 8 & 15));
                _loc_4 = _loc_4 + 1;
            }
            return _loc_2;
        }// end function

    }
}
