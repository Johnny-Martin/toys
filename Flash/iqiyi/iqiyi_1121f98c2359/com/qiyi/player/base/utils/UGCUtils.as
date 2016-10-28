package com.qiyi.player.base.utils
{

    public class UGCUtils extends Object
    {

        public function UGCUtils()
        {
            return;
        }// end function

        public static function isUGC(param1:String) : Boolean
        {
            var _loc_2:Number = NaN;
            if (param1 && param1.length > 2 && param1.charAt((param1.length - 1)) == "9" && param1.charAt(param1.length - 2) == "0")
            {
                _loc_2 = Number(param1);
                if (_loc_2 > 0 && _loc_2 > 90000000)
                {
                    return true;
                }
            }
            return false;
        }// end function

    }
}
