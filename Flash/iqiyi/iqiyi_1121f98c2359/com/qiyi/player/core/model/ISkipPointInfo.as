package com.qiyi.player.core.model
{
    import com.qiyi.player.base.pub.*;

    public interface ISkipPointInfo
    {

        public function ISkipPointInfo();

        function get startTime() : int;

        function get endTime() : int;

        function get skipPointType() : EnumItem;

    }
}
