package com
{
    import flash.utils.*;

    public class AddStaticMsg extends BaseMsg
    {
        public static var _instance:AddStaticMsg = new AddStaticMsg;

        public function AddStaticMsg()
        {
            return;
        }// end function

        public static function sendMsg(param1:Array) : ByteArray
        {
            var _loc_2:* = _instance.P2P_PROC_PACKAGE(0, P2PMsg.P2P_END_FLASH, P2PMsg.P2P_END_PROXY, P2PMsg.P2P_PROXY_AND_CLIENT_STAT);
            var _loc_3:* = _instance.getBody(param1);
            var _loc_4:* = _instance.getHeader(_loc_3.length, _loc_2);
            var _loc_5:* = new ByteArray();
            new ByteArray().writeBytes(_loc_4);
            _loc_5.writeBytes(_loc_3);
            _loc_4.clear();
            _loc_3.clear();
            return _loc_5;
        }// end function

    }
}
