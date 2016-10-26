package server
{
    import com.*;
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class BasePeer extends BaseCtrl
    {
        private var _mainRtmfpUrl:String;
        private var _mainPeer:String;
        private var _isfirst:Boolean = true;
        private var _ismySelf:Boolean = false;
        protected var iscall:Boolean = false;
        protected var _mainNC:NetConnection;
        private var _successNsDic:Dictionary;
        protected var _mainPeerInfo:Object;
        private var curCallpeerinfo:Object;
        protected var registRtmfpT:TimerSohu;
        protected var registerFailType:int = 0;
        protected var _isRegistering:Boolean = false;
        protected var _rtmfpurl:String;
        protected var _failidx:int = 0;
        private var _ipTIdx:int = 0;
        private var _registbt:int;
        private var isCheckNat:Boolean = true;
        private var _checknat:Boolean = false;
        private var _ncNat:NetConnection;
        private var _rtmfpA:Array;
        private var _rtmfpidx:int = 0;

        public function BasePeer()
        {
            this._successNsDic = new Dictionary();
            this._mainPeerInfo = new Object();
            this.curCallpeerinfo = new Object();
            this._rtmfpA = new Array();
            return;
        }// end function

        public function peerMth() : void
        {
            this.registRtmfpT = new TimerSohu(this._p2psohu.config.errorConTimeNumRtmfp);
            this.registRtmfpT.addEventListener(TimerEvent.TIMER, this.registFailMth);
            if (this._rtmfpA.length == 0 && this.p2pSohuLib.config.isRtmfpTest)
            {
                switch(GetWayMsg._instance.sp)
                {
                    case 2:
                    {
                        this._rtmfpA.push("rtmfp://123.125.122.178:8080");
                        this._rtmfpA.push("rtmfp://220.181.2.37:8080");
                        this._rtmfpA.push("rtmfp://112.29.145.12:8080");
                        break;
                    }
                    default:
                    {
                        this._rtmfpA.push("rtmfp://220.181.2.37:8080");
                        this._rtmfpA.push("rtmfp://123.125.122.178:8080");
                        this._rtmfpA.push("rtmfp://112.29.145.12:8080");
                        break;
                        break;
                    }
                }
            }
            return;
        }// end function

        public function registerRtmfpMth(param1:String, param2:Object = null) : void
        {
            if (this._isRegistering)
            {
                return;
            }
            if (this._p2psohu.config.nat == 0)
            {
                this.isCheckNat = true;
            }
            var _loc_3:* = new NetConnection();
            _loc_3.maxPeerConnections = 8;
            _loc_3.addEventListener(NetStatusEvent.NET_STATUS, this.netConnectionHandler);
            this.curCallpeerinfo = param2;
            this._mainNC = _loc_3;
            this._mainRtmfpUrl = param1;
            this.registRtmfpT.o = {nc:_loc_3, url:param1};
            this.registRtmfpT.start();
            this.registerFailType = 0;
            if (this.p2pSohuLib.config.isRtmfpTest)
            {
                if (!this.p2pSohuLib.config.isYDRtmfp)
                {
                    this._rtmfpurl = this._rtmfpA[this._rtmfpidx];
                }
                else
                {
                    this._rtmfpurl = param1;
                }
                if (GetWayMsg._instance.sp == 8 || GetWayMsg._instance.sp == 3)
                {
                    this._rtmfpurl = "rtmfp://112.29.145.12:8080";
                }
            }
            else
            {
                this._rtmfpurl = param1;
            }
            this._p2psohu.showTestInfo("::registerRtmfpMth:" + this._rtmfpurl, true);
            _loc_3.connect(this._rtmfpurl + "/" + this._p2psohu.config.developerKey);
            if (this.p2pSohuLib.config.isRtmfpTest)
            {
                var _loc_4:String = this;
                var _loc_5:* = this._rtmfpidx + 1;
                _loc_4._rtmfpidx = _loc_5;
                if (this._rtmfpidx == 3)
                {
                    this._rtmfpidx = 0;
                }
            }
            this._isRegistering = true;
            this._registbt = getTimer();
            return;
        }// end function

        protected function registFailMth(event:TimerEvent) : void
        {
            throw new Error("must be override");
        }// end function

        public function netConnectionHandler(event:NetStatusEvent) : void
        {
            var _loc_2:* = event.currentTarget as NetConnection;
            this._p2psohu.showTestInfo("netConnectionHandler------------------------:" + event.info.code);
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this._isRegistering = false;
                    this.registRtmfpT.stop();
                    this._failidx = 0;
                    this._p2psohu.config.rtmfpConT = getTimer() - this._registbt;
                    this._p2psohu.showTestInfo("rtmfp success 你的PeerId是:" + _loc_2.nearID + " dur:" + this._p2psohu.config.rtmfpConT, true, true);
                    this._mainPeer = _loc_2.nearID;
                    this._p2psohu.config.peerID = this._mainPeer;
                    this.initSendStream(_loc_2);
                    this.initUserType(this._mainPeer);
                    break;
                }
                case "NetConnection.Connect.Closed":
                {
                    this.closeNCMth(_loc_2);
                    break;
                }
                case "NetStream.Connect.Success":
                {
                    this._p2psohu.showTestInfo("ok farid:" + event.info.stream.farID.slice(0, 8));
                    break;
                }
                case "NetConnection.Connect.Failed":
                {
                    this._p2psohu.showTestInfo("NetConnection.Connect.Failed错误");
                    this.nsConnectFailMth(_loc_2);
                    break;
                }
                case "NetStream.Connect.Closed":
                {
                    this._p2psohu.showTestInfo("die farid:" + event.info.stream.farID.slice(0, 8));
                    this.clearDiePeerMth(event.info.stream);
                    break;
                }
                case "NetStream.Play.Failed":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function initUserType(param1:String) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2 = _loc_2 * 1313 + param1.charCodeAt(_loc_3);
                _loc_3 = _loc_3 + 1;
            }
            this._p2psohu.showTestInfo("打印 rtmfp注册地址 registerRtmfpMth:" + this._rtmfpurl + " getwaycont:" + this._p2psohu.config.getwayConT + " rtmfpcont:" + this._p2psohu.config.rtmfpConT);
            this._p2psohu.showTestInfo("version:" + this._p2psohu.config.version + " playerversion:" + Capabilities.version + " comversion:" + this._p2psohu.config.COMVERSION + " os:" + Capabilities.os, true);
            if (this._p2psohu.config.hasnatCheckAtPeer)
            {
                this.checkNatMth();
            }
            this._p2psohu.showTestInfo("has nat:" + this._p2psohu.config.nat + " isCheckNat:" + this.isCheckNat + " ischecking:" + CheckIP.getInstance().ischecking + " _checknat:" + this._checknat, true);
            this._p2psohu.trackUrlOKMth();
            return;
        }// end function

        public function checkNatMth() : void
        {
            if (!this._p2psohu.config.istownc)
            {
                this.getNatMth();
            }
            else
            {
                this._ncNat = new NetConnection();
                this._ncNat.addEventListener(NetStatusEvent.NET_STATUS, this.ncNatConnection);
                this._ncNat.connect(CheckIP.getInstance().rtmfpurl);
            }
            return;
        }// end function

        private function ncNatConnection(event:NetStatusEvent) : void
        {
            P2pSohuLib.getInstance().showTestInfo("ncNatConnection!!!---------checknat---------------:" + event.info.code);
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.getNatMth();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function getNatMth() : void
        {
            if (this._p2psohu.config.isTestP2P)
            {
                if (this.isCheckNat && CheckIP.getInstance().ischecking == false && this._checknat == false)
                {
                    this._p2psohu.showTestInfo("CheckIP.getInstance().init  CheckIP.getInstance().ischeckover:" + CheckIP.getInstance().ischeckover);
                    if (CheckIP.getInstance().ischeckover)
                    {
                        this._p2psohu.showTestInfo("CheckIP.getInstance().init nat:" + this._p2psohu.config.nat);
                    }
                    else
                    {
                        CheckIP.getInstance().init(this.getClientNat, this._ncNat);
                    }
                    this._checknat = true;
                }
            }
            return;
        }// end function

        public function getClientNat(param1:int, param2:String = null, param3:Boolean = false) : void
        {
            if (param3)
            {
                this._p2psohu.config.hasnat = true;
                if (this._p2psohu.trackSocket.socket.connected && param1 != this._p2psohu.config.nat)
                {
                    this._p2psohu.trackSocket.sendMsgMth("addnat", param1);
                }
                this.isCheckNat = false;
            }
            this._p2psohu.config.nat = param1;
            this._p2psohu.showTestInfo("reset nat:" + param1 + "  str:" + param2 + " hasnat:" + param3, true, true);
            CheckIP.getInstance().ischecking = false;
            if (this._ncNat != null)
            {
                this._ncNat.removeEventListener(NetStatusEvent.NET_STATUS, this.ncNatConnection);
                this._ncNat.close();
            }
            return;
        }// end function

        private function initSendStream(param1:NetConnection) : void
        {
            var _loc_2:* = param1.uri.indexOf("/", 12);
            var _loc_3:* = param1.uri.substring(0, _loc_2);
            this._mainPeerInfo = {nc:param1, peerid:param1.nearID, rtmfp:_loc_3};
            this.shareNsInit();
            return;
        }// end function

        protected function shareNsInit() : void
        {
            throw new Error("must be override!");
        }// end function

        protected function closeNCMth(param1:NetConnection) : void
        {
            throw new Error("must be override!");
        }// end function

        protected function nsConnectFailMth(param1:NetConnection) : void
        {
            throw new Error("must be override!");
        }// end function

        public function clearDiePeerMth(param1:NetStream) : void
        {
            throw new Error("must be override!");
        }// end function

        public function get mainRtmfpUrl() : String
        {
            return this._mainRtmfpUrl;
        }// end function

        public function get mainPeer() : String
        {
            return this._mainPeer;
        }// end function

        public function set mainPeer(param1:String) : void
        {
            this._mainPeer = param1;
            return;
        }// end function

        public function get mainNC() : NetConnection
        {
            return this._mainNC;
        }// end function

        public function get isfirst() : Boolean
        {
            return this._isfirst;
        }// end function

        public function set isfirst(param1:Boolean) : void
        {
            this._isfirst = param1;
            return;
        }// end function

        public function get ismySelf() : Boolean
        {
            return this._ismySelf;
        }// end function

    }
}
