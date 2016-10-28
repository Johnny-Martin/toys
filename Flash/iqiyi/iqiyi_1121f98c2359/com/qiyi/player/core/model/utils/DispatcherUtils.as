package com.qiyi.player.core.model.utils
{
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.player.coreplayer.*;

    public class DispatcherUtils extends Object
    {

        public function DispatcherUtils()
        {
            return;
        }// end function

        public static function isNeedDispatch(param1:ICorePlayer) : Boolean
        {
            var _loc_2:Object = null;
            if (param1 && param1.movie && param1.movie.streamType == StreamEnum.HTTP)
            {
                _loc_2 = Utility.getFlashVersion();
                return !(_loc_2.ver1 > 10 || _loc_2.ver2 >= 1);
            }
            return true;
        }// end function

    }
}
