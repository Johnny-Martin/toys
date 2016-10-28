package com.qiyi.player.wonder.common.sw
{
    import __AS3__.vec.*;

    public interface ISwitch
    {

        public function ISwitch();

        function getSwitchID() : Vector.<int>;

        function onSwitchStatusChanged(param1:int, param2:Boolean) : void;

    }
}
