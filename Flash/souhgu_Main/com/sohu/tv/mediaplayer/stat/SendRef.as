package com.sohu.tv.mediaplayer.stat
{
    import com.sohu.tv.mediaplayer.*;
    import flash.events.*;
    import flash.net.*;

    public class SendRef extends EventDispatcher
    {
        public static var singleton:SendRef;

        public function SendRef() : void
        {
            return;
        }// end function

        public function sendPQ(param1:String, param2:Number = 0) : void
        {
            return;
            var _loc_3:String = "http://click.hd.sohu.com.cn/s.gif?";
            var _loc_4:* = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
            var _loc_5:* = new URLVariables();
            new URLVariables().type = param1;
            _loc_5.s = PlayerConfig.stype;
            _loc_5.ref = _loc_4;
            if (param2 != 0)
            {
                _loc_5.code = param2;
            }
            _loc_5.timestamp = new Date().getTime();
            var _loc_6:* = new URLRequest(_loc_3);
            new URLRequest(_loc_3).method = URLRequestMethod.GET;
            _loc_6.data = _loc_5;
            sendToURL(_loc_6);
            return;
        }// end function

        public function sendPQVPC(param1:String) : void
        {
            return;
            var _loc_2:String = "http://click.hd.sohu.com.cn/s.gif?";
            var _loc_3:* = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
            var _loc_4:* = new URLVariables();
            new URLVariables().type = param1;
            _loc_4.ref = _loc_3;
            _loc_4.vid = PlayerConfig.vid;
            _loc_4.tvid = PlayerConfig.tvid;
            _loc_4.pid = PlayerConfig.vrsPlayListId;
            _loc_4.cid = PlayerConfig.caid;
            _loc_4.s = PlayerConfig.stype;
            _loc_4.timestamp = new Date().getTime();
            var _loc_5:* = new URLRequest(_loc_2);
            new URLRequest(_loc_2).method = URLRequestMethod.GET;
            _loc_5.data = _loc_4;
            sendToURL(_loc_5);
            return;
        }// end function

        public function sendPQVPCU(param1:String) : void
        {
            return;
            var _loc_2:String = "http://click.hd.sohu.com.cn/s.gif?";
            var _loc_3:* = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
            var _loc_4:* = new URLVariables();
            new URLVariables().type = param1;
            _loc_4.ref = _loc_3;
            _loc_4.vid = PlayerConfig.vid;
            _loc_4.tvid = PlayerConfig.tvid;
            _loc_4.pid = PlayerConfig.vrsPlayListId;
            _loc_4.cid = PlayerConfig.caid;
            _loc_4.uuid = PlayerConfig.uuid;
            _loc_4.s = PlayerConfig.stype;
            _loc_4.timestamp = new Date().getTime();
            var _loc_5:* = new URLRequest(_loc_2);
            new URLRequest(_loc_2).method = URLRequestMethod.GET;
            _loc_5.data = _loc_4;
            sendToURL(_loc_5);
            return;
        }// end function

        public function sendPQDrog(param1:String) : void
        {
            return;
            var _loc_2:* = new URLRequest(param1);
            _loc_2.method = URLRequestMethod.GET;
            sendToURL(_loc_2);
            return;
        }// end function

        public function sendPlayerTest(param1:String) : void
        {
            return;
            var _loc_2:String = "http://click2.hd.sohu.com/x.gif?";
            var _loc_3:* = new URLVariables();
            _loc_3.type = param1;
            _loc_3.plat = "flash";
            _loc_3.uid = PlayerConfig.userId;
            _loc_3.hotvrs = PlayerConfig.hotVrsSpend;
            _loc_3.adinfo = PlayerConfig.adinfoSpend;
            _loc_3.adget = PlayerConfig.adgetSpend;
            _loc_3.allot = PlayerConfig.allotSpend;
            _loc_3.cdnget = PlayerConfig.cdngetSpend;
            _loc_3.version = PlayerConfig.VERSION;
            _loc_3.allotip = PlayerConfig.allotip;
            _loc_3.cdnip = PlayerConfig.cdnIp;
            _loc_3.cdnid = PlayerConfig.cdnId;
            _loc_3.clientip = PlayerConfig.clientIp;
            if (PlayerConfig.jsgetSpend != 0)
            {
                _loc_3.jsget = PlayerConfig.jsgetSpend;
            }
            if (PlayerConfig.playerSpend != 0)
            {
                _loc_3.playerget = PlayerConfig.playerSpend;
            }
            _loc_3.url = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
            _loc_3.timestamp = new Date().getTime();
            var _loc_4:* = new URLRequest(_loc_2);
            new URLRequest(_loc_2).method = URLRequestMethod.GET;
            _loc_4.data = _loc_3;
            sendToURL(_loc_4);
            return;
        }// end function

        public static function getInstance() : SendRef
        {
            if (singleton == null)
            {
                singleton = new SendRef;
            }
            return singleton;
        }// end function

    }
}
