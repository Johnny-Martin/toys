package com.qiyi.player.core.model.def
{
    import com.qiyi.player.base.pub.*;

    public class PlatformEnum extends Object
    {
        public static const ITEMS:Array = [];
        public static const PC:EnumItem = new EnumItem(11, "11", ITEMS);
        public static const CN_PF:EnumItem = new EnumItem(0, "01010021010000000000", ITEMS);
        public static const TW_PF:EnumItem = new EnumItem(1, "01010021010010000000", ITEMS);

        public function PlatformEnum()
        {
            return;
        }// end function

    }
}
