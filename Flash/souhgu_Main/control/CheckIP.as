package control
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class CheckIP extends Object
    {
        private var nc:NetConnection;
        private var first_public_ip:String;
        private var symmetric_peerid:String;
        private var actTimer:Timer;
        private var check_full_or_symmetric_timer:Timer;
        private var check_firewall_timer:Timer;
        private var check_all_time:Timer;
        private var _cbf:Function;
        private var publish_check_full_cone_nat_ns:NetStream;
        private var publish_check_restricted_cone_nat_ns:NetStream;
        private var publish_check_firwall_ns:NetStream;
        public var nat:int = 0;
        private var str:String = "";
        private var resultstr:String = "";
        private var timeF:Function;
        private var hasNat:Boolean = false;
        private var is_public:Boolean = false;
        public var ischecking:Boolean = false;
        public var ischeckover:Boolean = false;
        private var _activity:int = 0;
        private var _rtmfpurl:String = "rtmfp://flash.nat.tv.sohu.com:8080";
        private var isoutnc:Boolean = false;
        private static var _instance:CheckIP;

        public function CheckIP()
        {
            this.actTimer = new Timer(200);
            this.check_full_or_symmetric_timer = new Timer(5000);
            this.check_firewall_timer = new Timer(5000);
            this.check_all_time = new Timer(15000);
            return;
        }// end function

        public function init(param1:Function, param2:NetConnection = null) : void
        {
            P2pSohuLib.getInstance().showTestInfo("checkip  init!!!" + "  ischecking:" + this.ischecking + " ischeckover:" + this.ischeckover);
            this.str = this.str + (" checkip  init" + "  ischecking:" + this.ischecking + " ischeckover:" + this.ischeckover + "  :" + getTimer());
            if (this.ischeckover)
            {
                return;
            }
            this.cleanAllTime();
            this._cbf = param1;
            if (param2 != null)
            {
                this.nc = param2;
                this.isoutnc = true;
                this.checkInit();
            }
            else
            {
                this.nc = new NetConnection();
                this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.netConnectionHandler);
                this.nc.connect(this._rtmfpurl);
            }
            return;
        }// end function

        private function netConnectionHandler(event:NetStatusEvent) : void
        {
            P2pSohuLib.getInstance().showTestInfo("netConnectionHandler!!!---------checknat---------------:" + event.info.code);
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.checkInit();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function checkInit() : void
        {
            this.ischecking = true;
            this._activity = 0;
            this.check_all_time.addEventListener(TimerEvent.TIMER, this.timeOverMth);
            this.check_all_time.start();
            this.actTimer.addEventListener(TimerEvent.TIMER, this.onActivityTimer);
            this.actTimer.start();
            this.publishNs();
            return;
        }// end function

        private function publishNs() : void
        {
            this.publish_check_full_cone_nat_ns = new NetStream(this.nc, NetStream.DIRECT_CONNECTIONS);
            this.publish_check_full_cone_nat_ns.publish("NatCheckFullConeStreamName");
            this.publish_check_full_cone_nat_ns.addEventListener(NetStatusEvent.NET_STATUS, this.showstate);
            var fso:* = new Object();
            fso.onPeerConnect = function (param1:NetStream) : Boolean
            {
                str = str + (" |" + "NatCheckFullConeStreamName");
                P2pSohuLib.getInstance().showTestInfo("natCheckMth pname!!!:" + "NatCheckFullConeStreamName");
                check_full_or_symmetric_timer.stop();
                check_full_or_symmetric_timer.removeEventListener(TimerEvent.TIMER, onCheckFullOrSymmetricTimer);
                publish_check_full_cone_nat_ns.close();
                publish_check_full_cone_nat_ns.removeEventListener(NetStatusEvent.NET_STATUS, showstate);
                cleanAllTime();
                sendNat(3);
                return true;
            }// end function
            ;
            this.publish_check_full_cone_nat_ns.client = fso;
            this.publish_check_restricted_cone_nat_ns = new NetStream(this.nc, NetStream.DIRECT_CONNECTIONS);
            this.publish_check_restricted_cone_nat_ns.publish("NatCheckRestrictedConeStreamName");
            this.publish_check_restricted_cone_nat_ns.addEventListener(NetStatusEvent.NET_STATUS, this.showstate);
            var fo:* = new Object();
            fo.onPeerConnect = function (param1:NetStream) : Boolean
            {
                str = str + (" |" + "NatCheckRestrictedConeStreamName");
                P2pSohuLib.getInstance().showTestInfo("natCheckMth pname!!!:" + "NatCheckRestrictedConeStreamName");
                check_full_or_symmetric_timer.stop();
                check_full_or_symmetric_timer.removeEventListener(TimerEvent.TIMER, onCheckPortConeTimer);
                publish_check_restricted_cone_nat_ns.close();
                publish_check_restricted_cone_nat_ns.removeEventListener(NetStatusEvent.NET_STATUS, showstate);
                cleanAllTime();
                sendNat(5);
                return true;
            }// end function
            ;
            this.publish_check_restricted_cone_nat_ns.client = fo;
            return;
        }// end function

        private function timeOverMth(event:TimerEvent = null) : void
        {
            this.str = this.str + " |alltimeover";
            P2pSohuLib.getInstance().showTestInfo("alltimeover!!!");
            this.cleanAllTime();
            this.sendNat(2);
            return;
        }// end function

        private function cleanAllTime() : void
        {
            this.str = this.str + ("  cleanAllTime   ischecking:" + this.ischecking + " hasNat:" + this.hasNat);
            P2pSohuLib.getInstance().showTestInfo("cleanAllTime   ischecking!!!:" + this.ischecking + " hasNat:" + this.hasNat);
            this.check_full_or_symmetric_timer.stop();
            this.check_full_or_symmetric_timer.reset();
            if (this.timeF != null)
            {
                this.check_full_or_symmetric_timer.removeEventListener(TimerEvent.TIMER, this.timeF);
            }
            this.check_firewall_timer.stop();
            this.check_firewall_timer.reset();
            this.check_firewall_timer.removeEventListener(TimerEvent.TIMER, this.onCheckFireWallTimer);
            this.actTimer.stop();
            this.actTimer.reset();
            this.actTimer.removeEventListener(TimerEvent.TIMER, this.onActivityTimer);
            if (this.publish_check_firwall_ns != null)
            {
                this.publish_check_firwall_ns.close();
            }
            if (this.publish_check_full_cone_nat_ns != null)
            {
                this.publish_check_full_cone_nat_ns.close();
                this.publish_check_full_cone_nat_ns.removeEventListener(NetStatusEvent.NET_STATUS, this.showstate);
            }
            this.check_all_time.removeEventListener(TimerEvent.TIMER, this.timeOverMth);
            this.check_all_time.stop();
            this.check_all_time.reset();
            if (this.nc != null && !this.isoutnc)
            {
                this.nc.removeEventListener(NetStatusEvent.NET_STATUS, this.netConnectionHandler);
            }
            return;
        }// end function

        private function sendNat(param1:int) : void
        {
            if (this.nat == 0)
            {
                this.nat = param1;
                this.hasNat = true;
            }
            else
            {
                this.hasNat = false;
            }
            this.str = this.str + ("  sendNat _nat:" + param1);
            P2pSohuLib.getInstance().showTestInfo("sendNat _nat!!!:" + param1);
            this._cbf(this.nat, this.str + this.resultstr, this.hasNat);
            this.str = this.str + "  sendNat over";
            this.ischeckover = true;
            this._activity = 0;
            return;
        }// end function

        private function onActivityTimer(event:TimerEvent) : void
        {
            var e:* = event;
            var _loc_3:String = this;
            var _loc_4:* = this._activity + 1;
            _loc_3._activity = _loc_4;
            P2pSohuLib.getInstance().showTestInfo("checkip  onActivityTimer actTimer.currentCount!!!:" + this.actTimer.currentCount + " _activity:" + this._activity);
            if (this.actTimer.currentCount == 10 || this._activity == 10)
            {
                this.timeOverMth();
            }
            this.actTimer.stop();
            this.actTimer.removeEventListener(TimerEvent.TIMER, this.onActivityTimer);
            this.str = this.str + (" |NatCheckPublic" + " :" + getTimer());
            try
            {
                this.nc.call("NatCheckPublic", new Responder(this.onCheckPublicIPResult, this.onCheckPublicStatus));
            }
            catch (e:Error)
            {
                P2pSohuLib.getInstance().showTestInfo("checkip  onActivityTimer e!!!:" + e.errorID);
            }
            return;
        }// end function

        public function onCheckPublicStatus(param1:Object) : void
        {
            P2pSohuLib.getInstance().showTestInfo("checkip  onCheckPublicStatus  actTimer.currentCount!!!:" + this.actTimer.currentCount + " _activity:" + this._activity);
            this.str = this.str + "checkip  onCheckPublicStatus";
            this.actTimer.addEventListener(TimerEvent.TIMER, this.onActivityTimer);
            this.actTimer.start();
            return;
        }// end function

        public function onCheckPublicIPResult(param1:Object) : void
        {
            var response:* = param1;
            this.actTimer.stop();
            this.actTimer.removeEventListener(TimerEvent.TIMER, this.onActivityTimer);
            var i:int;
            this.symmetric_peerid = response.symmetric_peerid;
            var firewall_peerid:* = response.firewall_peerid;
            this.first_public_ip = response.public_ip;
            var len:* = response.private_ip.length;
            i;
            while (i < len)
            {
                
                if (response.public_ip == response.private_ip[i])
                {
                    this.is_public = true;
                    break;
                }
                i = (i + 1);
            }
            this.resultstr = " public_ip:" + this.first_public_ip + " is_public:" + this.is_public;
            if (this.is_public == false)
            {
                this.str = this.str + " |NatCheckFullConeStreamName NatCheckFullCone";
                P2pSohuLib.getInstance().showTestInfo("onCheckPublicIPResult NatCheckFullConeStreamName NatCheckFullCone");
                try
                {
                    this.check_full_or_symmetric_timer.addEventListener(TimerEvent.TIMER, this.onCheckFullOrSymmetricTimer);
                    this.check_full_or_symmetric_timer.start();
                }
                catch (e:Error)
                {
                    P2pSohuLib.getInstance().showTestInfo("NatCheckFullConeStreamName NatCheckFullCone e!!!:" + e.errorID);
                }
            }
            else
            {
                this.cleanAllTime();
                this.sendNat(2);
                return;
            }
            return;
        }// end function

        private function showstate(event:NetStatusEvent) : void
        {
            this.str = this.str + (" |showstate:" + event.info.code);
            return;
        }// end function

        private function firewallCheckMth(param1:String, param2:String) : void
        {
            var peerid:* = param1;
            var funcname:* = param2;
            this.publish_check_firwall_ns = new NetStream(this.nc, peerid);
            this.publish_check_firwall_ns.play(this.nc.nearID);
            var obj:* = new Object();
            switch(funcname)
            {
                case "checkFireWall":
                {
                    obj[funcname] = function (param1:String, param2:int) : void
            {
                check_firewall_timer.stop();
                check_firewall_timer.removeEventListener(TimerEvent.TIMER, onCheckFireWallTimer);
                publish_check_firwall_ns.close();
                var _loc_3:* = param1 + ":" + param2;
                this.resultstr = this.resultstr + (" checkFireWall  public_ip:" + _loc_3);
                str = str + " |checkFireWall";
                P2pSohuLib.getInstance().showTestInfo("checkFireWall!!!");
                cleanAllTime();
                sendNat(2);
                return;
            }// end function
            ;
                    break;
                }
                case "getPublicIP":
                {
                    obj[funcname] = function (param1:Object) : void
            {
                check_firewall_timer.stop();
                check_firewall_timer.removeEventListener(TimerEvent.TIMER, onCheckFireWallTimer);
                publish_check_firwall_ns.close();
                var _loc_2:* = param1.public_ip + ":" + param1.public_port;
                this.resultstr = this.resultstr + (" getPublicIP  public_ip:" + _loc_2);
                str = str + " |getPublicIP";
                P2pSohuLib.getInstance().showTestInfo("getPublicIP!!!");
                if (first_public_ip != _loc_2)
                {
                    cleanAllTime();
                    sendNat(7);
                }
                else
                {
                    str = str + " |NatCheckRestrictedConeStreamName  NatCheckRestrictedCone";
                    P2pSohuLib.getInstance().showTestInfo("NatCheckRestrictedConeStreamName  NatCheckRestrictedCone!!!");
                    check_full_or_symmetric_timer.addEventListener(TimerEvent.TIMER, onCheckPortConeTimer);
                    check_full_or_symmetric_timer.start();
                }
                return;
            }// end function
            ;
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.publish_check_firwall_ns.client = obj;
            return;
        }// end function

        private function onCheckFireWallTimer(event:TimerEvent) : void
        {
            this.check_firewall_timer.stop();
            this.check_firewall_timer.removeEventListener(TimerEvent.TIMER, this.onCheckFireWallTimer);
            this.str = this.str + " |onCheckFireWallTimer";
            P2pSohuLib.getInstance().showTestInfo("onCheckFireWallTimer !!!");
            if (!this.is_public)
            {
                this.cleanAllTime();
                this.sendNat(4);
            }
            else
            {
                this.cleanAllTime();
                this.sendNat(6);
            }
            return;
        }// end function

        public function onCheckFullConeResult(param1:Object = null) : void
        {
            return;
        }// end function

        public function onCheckStatus(param1:Object = null) : void
        {
            return;
        }// end function

        private function onCheckFullOrSymmetricTimer(event:TimerEvent) : void
        {
            this.str = this.str + " |onCheckFullOrSymmetricTimer";
            P2pSohuLib.getInstance().showTestInfo("onCheckFullOrSymmetricTimer !!!");
            this.check_full_or_symmetric_timer.stop();
            this.check_full_or_symmetric_timer.removeEventListener(TimerEvent.TIMER, this.onCheckFullOrSymmetricTimer);
            this.publish_check_full_cone_nat_ns.close();
            this.publish_check_full_cone_nat_ns.removeEventListener(NetStatusEvent.NET_STATUS, this.showstate);
            this.check_firewall_timer.addEventListener(TimerEvent.TIMER, this.onCheckFireWallTimer);
            this.check_firewall_timer.start();
            this.firewallCheckMth(this.symmetric_peerid, "getPublicIP");
            return;
        }// end function

        private function onCheckPortConeTimer(event:TimerEvent) : void
        {
            this.str = this.str + " |onCheckPortConeTimer";
            P2pSohuLib.getInstance().showTestInfo("onCheckPortConeTimer !!!");
            this.check_full_or_symmetric_timer.stop();
            this.check_full_or_symmetric_timer.removeEventListener(TimerEvent.TIMER, this.onCheckPortConeTimer);
            this.publish_check_restricted_cone_nat_ns.close();
            this.publish_check_restricted_cone_nat_ns.removeEventListener(NetStatusEvent.NET_STATUS, this.showstate);
            this.cleanAllTime();
            this.sendNat(4);
            return;
        }// end function

        public function get rtmfpurl() : String
        {
            return this._rtmfpurl;
        }// end function

        public static function getInstance() : CheckIP
        {
            if (CheckIP._instance == null)
            {
                CheckIP._instance = new CheckIP;
            }
            return CheckIP._instance;
        }// end function

    }
}
