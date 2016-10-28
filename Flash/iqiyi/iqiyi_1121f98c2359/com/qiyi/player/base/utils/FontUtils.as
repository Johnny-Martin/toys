package com.qiyi.player.base.utils
{
    import flash.text.*;

    public class FontUtils extends Object
    {

        public function FontUtils()
        {
            return;
        }// end function

        public static function hasFont(param1:String) : Boolean
        {
            var _loc_2:* = Font.enumerateFonts(true);
            var _loc_3:* = _loc_2.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (_loc_2[_loc_4].fontName == param1)
                {
                    return true;
                }
                _loc_4++;
            }
            return false;
        }// end function

    }
}
