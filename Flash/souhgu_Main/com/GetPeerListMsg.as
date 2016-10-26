package com
{
    import flash.utils.*;
    import test.*;

    public class GetPeerListMsg extends BaseMsg
    {
        private var peerInfoO:Object;
        public static var _instance:GetPeerListMsg = new GetPeerListMsg;

        public function GetPeerListMsg()
        {
            this.peerInfoO = new Object();
            return;
        }// end function

        public static function sendMsg(param1:Array) : ByteArray
        {
            var _loc_2:* = GetPeerListMsg._instance.P2P_PROC_PACKAGE(0, P2PMsg.P2P_END_FLASH, P2PMsg.P2P_END_PROXY, P2PMsg.P2P_PROXY_AND_CLIENT_VOD_PEERS);
            var _loc_3:* = GetPeerListMsg._instance.getBody(param1);
            var _loc_4:* = GetPeerListMsg._instance.getHeader(_loc_3.length, _loc_2);
            var _loc_5:* = new ByteArray();
            new ByteArray().writeBytes(_loc_4);
            _loc_5.writeBytes(_loc_3);
            _loc_4.clear();
            _loc_3.clear();
            return _loc_5;
        }// end function

        public static function parseMsg(param1:ByteArray) : Object
        {
            var filenamelen:uint;
            var str:String;
            var peerIDlen:uint;
            var peerID:String;
            var urlLen:uint;
            var url:String;
            var p2pID:uint;
            var proxyIP:uint;
            var msg:* = param1;
            GetPeerListMsg._instance.peerInfoO = new Object();
            try
            {
                filenamelen = msg.readUnsignedShort();
                GetPeerListMsg._instance.peerInfoO.filename = msg.readMultiByte(filenamelen, "us-ascii");
            }
            catch (e:Error)
            {
                str = "pl getpeerlist errormsg filename:" + HexDump.dump(msg);
                P2pSohuLib.getInstance().sendToError(str);
            }
            var peernum:* = msg.readUnsignedInt();
            var peerlista:* = new Array();
            var i:int;
            while (i < peernum)
            {
                
                peerIDlen = msg.readUnsignedShort();
                peerID = msg.readMultiByte(peerIDlen, "us-ascii");
                urlLen = msg.readUnsignedShort();
                url = msg.readMultiByte(urlLen, "us-ascii");
                p2pID = msg.readUnsignedInt();
                proxyIP = msg.readUnsignedInt();
                peerlista.push({peerid:peerID, rtmfpurl:url, p2pid:p2pID, proxyip:proxyIP});
                i = (i + 1);
            }
            GetPeerListMsg._instance.peerInfoO.peernum = peernum;
            GetPeerListMsg._instance.peerInfoO.peerlist = peerlista;
            msg.clear();
            return GetPeerListMsg._instance.peerInfoO;
        }// end function

    }
}
