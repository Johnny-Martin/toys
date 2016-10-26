﻿package com
{
    import flash.utils.*;

    public class HeartMsg extends BaseMsg
    {
        public static var _instance:HeartMsg = new HeartMsg;

        public function HeartMsg()
        {
            return;
        }// end function

        public static function sendMsg(... args) : ByteArray
        {
            args = _instance.P2P_PROC_PACKAGE(0, P2PMsg.P2P_END_FLASH, P2PMsg.P2P_END_PROXY, P2PMsg.P2P_HEART);
            var _loc_3:* = new ByteArray();
            _loc_3.writeByte(1);
            _loc_3.writeUnsignedInt(args[0]);
            var _loc_4:* = _instance.getHeader(_loc_3.length, args);
            var _loc_5:* = new ByteArray();
            new ByteArray().writeBytes(_loc_4);
            _loc_5.writeBytes(_loc_3);
            _loc_4.clear();
            _loc_3.clear();
            return _loc_5;
        }// end function

    }
}
