package com
{
    import configbag.*;
    import flash.utils.*;

    public class LoginMsg extends BaseMsg
    {
        public var p2pid:int;
        public var ip:String = null;
        public static var _instance:LoginMsg = new LoginMsg;

        public function LoginMsg()
        {
            return;
        }// end function

        public static function sendMsg() : ByteArray
        {
            var _loc_2:ByteArray = null;
            var _loc_1:* = _instance.P2P_PROC_PACKAGE(0, P2PMsg.P2P_END_FLASH, P2PMsg.P2P_END_PROXY, P2PMsg.P2P_PROXY_AND_CLIENT_LOGIN);
            if (Config.getInstance().isP2pLive)
            {
                _loc_2 = _instance.getBody(["login", Config.getInstance().peerID, Config.getInstance().rtmfpUrl, "vod:" + Config.getInstance().cid, Config.getInstance().version, 0, 0, GetWayMsg._instance.sp, GetWayMsg._instance.province, GetWayMsg._instance.city]);
            }
            else
            {
                _loc_2 = _instance.getBody(["login", Config.getInstance().peerID, Config.getInstance().rtmfpUrl, "vod:" + Config.getInstance().pid, Config.getInstance().version, Config.getInstance().COMVERSION, Config.getInstance().nat, GetWayMsg._instance.sp, GetWayMsg._instance.province, GetWayMsg._instance.city]);
            }
            var _loc_3:* = _instance.getHeader(_loc_2.length, _loc_1);
            var _loc_4:* = new ByteArray();
            new ByteArray().writeBytes(_loc_3);
            _loc_4.writeBytes(_loc_2);
            _loc_3.clear();
            _loc_2.clear();
            return _loc_4;
        }// end function

        public static function parseMsg(param1:ByteArray) : void
        {
            _instance.p2pid = param1.readUnsignedInt();
            var _loc_2:* = param1.readUnsignedShort();
            _instance.ip = param1.readMultiByte(_loc_2, "us-ascii");
            param1.clear();
            return;
        }// end function

    }
}
