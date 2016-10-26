package com
{
    import configbag.*;
    import flash.utils.*;

    public class GetWayMsg extends BaseMsg
    {
        public var proxykey:String;
        public var rtmfpUrl:String;
        public var sp:int;
        public var province:int;
        public var city:int;
        public static var _instance:GetWayMsg = new GetWayMsg;

        public function GetWayMsg()
        {
            return;
        }// end function

        public static function sendMsg() : ByteArray
        {
            var _loc_2:ByteArray = null;
            var _loc_1:* = GetWayMsg._instance.P2P_PROC_PACKAGE(0, P2PMsg.P2P_END_FLASH, P2PMsg.P2P_END_GETWAY, P2PMsg.P2P_GETWAY_AND_CLIENT_SOURCE);
            if (Config.getInstance().isP2pLive)
            {
                _loc_2 = GetWayMsg._instance.getBody(["getway", "live:" + Config.getInstance().cid]);
            }
            else
            {
                _loc_2 = GetWayMsg._instance.getBody(["getway", "vod:" + Config.getInstance().vid]);
            }
            var _loc_3:* = GetWayMsg._instance.getHeader(_loc_2.length, _loc_1);
            var _loc_4:* = new ByteArray();
            new ByteArray().writeBytes(_loc_3);
            _loc_4.writeBytes(_loc_2);
            _loc_3.clear();
            _loc_2.clear();
            return _loc_4;
        }// end function

        public static function parseMsg(param1:ByteArray) : void
        {
            var _loc_2:* = param1.readUnsignedShort();
            GetWayMsg._instance.proxykey = param1.readMultiByte(_loc_2, "us-ascii");
            var _loc_3:* = param1.readUnsignedShort();
            GetWayMsg._instance.rtmfpUrl = param1.readMultiByte(_loc_3, "us-ascii");
            GetWayMsg._instance.sp = param1.readShort();
            GetWayMsg._instance.province = param1.readShort();
            GetWayMsg._instance.city = param1.readShort();
            param1.clear();
            return;
        }// end function

    }
}
