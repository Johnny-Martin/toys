package com.greensock.easing
{
    import com.greensock.*;

    public class FastEase extends Object
    {

        public function FastEase()
        {
            return;
        }// end function

        public static function activateEase(param1:Function, param2:int, param3:uint) : void
        {
            TweenLite.fastEaseLookup[param1] = [param2, param3];
            return;
        }// end function

        public static function activate(param1:Array) : void
        {
            var _loc_3:Object = null;
            var _loc_2:* = param1.length;
            while (_loc_2--)
            {
                
                _loc_3 = param1[_loc_2];
                if (_loc_3.hasOwnProperty("power"))
                {
                    activateEase(_loc_3.easeIn, 1, _loc_3.power);
                    activateEase(_loc_3.easeOut, 2, _loc_3.power);
                    activateEase(_loc_3.easeInOut, 3, _loc_3.power);
                    if (_loc_3.hasOwnProperty("easeNone"))
                    {
                        activateEase(_loc_3.easeNone, 1, 0);
                    }
                }
            }
            return;
        }// end function

    }
}
