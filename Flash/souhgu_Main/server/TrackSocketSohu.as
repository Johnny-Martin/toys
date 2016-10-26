package server
{
    import com.*;
    import control.*;
    import flash.events.*;
    import flash.utils.*;

    public class TrackSocketSohu extends BaseSocketSohu
    {
        private var intervalT:Number = 1000;
        private var _peers:Number = 0;
        private var timer:Timer;
        private var _reconnect:Boolean = false;
        private var trackT:TimerSohu;
        private var getPeerlistT:Timer;
        private var getPeerlistStartT:Number = 0;
        private var getPeerlistMsgDic:Dictionary;
        private var trackip:String;
        private var trackport:int;
        private var con_count:int = 0;
        private var max_conNum:int = 0;
        private var iscleanpre:Boolean = false;
        private var t:TimerSohu;
        private var _getPeerlistFailIdx:int = 0;
        private var _startt:Number;

        public function TrackSocketSohu()
        {
            this.getPeerlistMsgDic = new Dictionary();
            return;
        }// end function

        public function socketInit(param1:String, param2:int) : void
        {
            if (this._p2psohu.isAllDie)
            {
                return;
            }
            this.trackip = param1;
            this.trackport = param2;
            this.trackT = new TimerSohu(this._p2psohu.config.errorConTimeNumTrack);
            this.trackT.addEventListener(TimerEvent.TIMER, this.errorConnectMth);
            this.trackT.start();
            this.timer = new Timer(this.intervalT);
            this.timer.addEventListener(TimerEvent.TIMER, this.sendHeartMth);
            this.t = new TimerSohu(300);
            this.t.addEventListener(TimerEvent.TIMER, this.delayDelMsg);
            this._p2psohu.showTestInfo(param1 + "  :track:  " + param2, true, true);
            socket = new HaleSocket();
            socket.addEventListener(Event.CLOSE, this.closeHandler);
            socket.addEventListener(Event.CONNECT, this.connectHandler);
            socket.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            socket.addEventListener(ProgressEvent.SOCKET_DATA, this.socketDataHandler);
            socket.connect(param1, param2);
            this._startt = getTimer();
            return;
        }// end function

        private function errorConnectMth(event:TimerEvent) : void
        {
            this._p2psohu.showTestInfo("track   链接超时  socket.connect:" + this.socket.connected, true);
            this._p2psohu.initFailInfo = "4;" + this.trackip + ":" + this.trackport;
            this._p2psohu.config.initErrorType = "04";
            this.trackT.removeEventListener(TimerEvent.TIMER, this.errorConnectMth);
            this.trackT.reset();
            this.testOtherPort();
            return;
        }// end function

        private function testOtherPort() : void
        {
            this.socketGC();
            var _loc_1:String = this;
            var _loc_2:* = this.con_count + 1;
            _loc_1.con_count = _loc_2;
            if (this.con_count > 1 && this.con_count % 2 == 0)
            {
                this.con_count = 0;
                this._p2psohu.getwaySocket.restartGetWay();
            }
            else
            {
                this.socketInit(this.trackip, 988);
            }
            return;
        }// end function

        private function sendHeartMth(event:TimerEvent) : void
        {
            var _loc_3:String = null;
            if (this.timer.currentCount % 120 == 0)
            {
                this.peers = 0;
                this.sendHeartRequest();
            }
            if (!this._p2psohu.chunksMang.isloading)
            {
                this.clearGetPeerListMsgDic();
                return;
            }
            var _loc_2:* = getTimer();
            for (_loc_3 in this.getPeerlistMsgDic)
            {
                
                if (_loc_2 - this.getPeerlistMsgDic[_loc_3] > this._p2psohu.config.peerlistTInteral)
                {
                    if (!this.t.running && this.t.o != null && this.t.o.filename != _loc_3)
                    {
                        this.getPeerlistFail(_loc_3);
                    }
                    break;
                }
            }
            return;
        }// end function

        public function clearGetPeerListMsgDic() : void
        {
            var _loc_1:String = null;
            for (_loc_1 in this.getPeerlistMsgDic)
            {
                
                this.getPeerlistMsgDic[_loc_1] = null;
                delete this.getPeerlistMsgDic[_loc_1];
            }
            this.getPeerlistMsgDic = new Dictionary();
            if (this.t != null && this.t.running)
            {
                this.t.reset();
                this.t.o = null;
            }
            return;
        }// end function

        public function sendHeartRequest() : void
        {
            var _loc_1:ByteArray = null;
            if (socket && socket.connected)
            {
                _loc_1 = HeartMsg.sendMsg(this.peers);
                socket.writeBytes(_loc_1);
                socket.flush();
            }
            return;
        }// end function

        public function sendMsgMth(... args) : void
        {
            args = null;
            this.iscleanpre = false;
            if (!socket.connected)
            {
                if (this._reconnect == false)
                {
                    this._p2psohu.config.lastMsgCMD = args[0];
                    this._reconnect = true;
                    this._p2psohu.serverDieMth("tracker die disconnect");
                }
                this._p2psohu.showTestInfo("tracker die disconnect _reconnect:" + this._reconnect);
                return;
            }
            switch(args[0])
            {
                case "login":
                {
                    this._p2psohu.showTestInfo("track  sendMsgMth  login 登陆", true);
                    args = LoginMsg.sendMsg();
                    socket.writeBytes(args);
                    this.trackT.reset();
                    this.trackT.delay = this._p2psohu.config.loginTInteral;
                    this.trackT.addEventListener(TimerEvent.TIMER, this.loginFailMth);
                    socket.flush();
                    this.trackT.start();
                    break;
                }
                case "addstatic":
                {
                    args = AddStaticMsg.sendMsg(args);
                    socket.writeBytes(args);
                    socket.flush();
                    break;
                }
                case "addnat":
                {
                    args = SendNatMsg.sendMsg(args);
                    socket.writeBytes(args);
                    socket.flush();
                    break;
                }
                case "addfile":
                {
                    args = AddFileMsg.sendMsg(args);
                    socket.writeBytes(args);
                    socket.flush();
                    break;
                }
                case "delfile":
                {
                    args = DelFileMsg.sendMsg(args);
                    socket.writeBytes(args);
                    socket.flush();
                    break;
                }
                case "getpeerlist":
                {
                    if (this.getPeerlistMsgDic[args[1]] != undefined)
                    {
                        return;
                    }
                    this.clearGetPeerListMsgDic();
                    this.getPeerlistMsgDic[args[1]] = getTimer();
                    if (this._p2psohu.config.isTestP2P)
                    {
                        args = GetMixPeerListMsg.sendMsg(args);
                    }
                    else
                    {
                        args = GetPeerListMsg.sendMsg(args);
                    }
                    socket.writeBytes(args);
                    socket.flush();
                    this.getPeerlistStartT = getTimer();
                    break;
                }
                default:
                {
                    break;
                }
            }
            args.clear();
            return;
        }// end function

        private function readResponse() : void
        {
            if (!socket.connected)
            {
                return;
            }
            if (this.iscleanpre)
            {
                return;
            }
            var _loc_1:* = new ByteArray();
            socket.readBytes(_loc_1, 0, socket.bytesAvailable);
            if (super.backMsgLenMth(_loc_1))
            {
                this.socketMsgBackMth();
            }
            return;
        }// end function

        private function socketMsgBackMth() : void
        {
            var _loc_1:* = _baA.shift();
            var _loc_2:* = _loc_1.readUnsignedShort();
            var _loc_3:* = _loc_1.readUnsignedInt();
            switch(GetWayMsg._instance.P2P_PROC_SERIAL(_loc_1.readUnsignedInt()))
            {
                case P2PMsg.P2P_PROXY_AND_CLIENT_LOGIN:
                {
                    break;
                }
                case P2PMsg.P2P_PROXY_AND_CLIENT_VOD_PEERS:
                case P2PMsg.P2P_PROXY_AND_CLIENT_MIX_PEERS:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            if (_baA.length != 0)
            {
                this.socketMsgBackMth();
            }
            return;
        }// end function

        private function loginMsgMth(param1:ByteArray) : void
        {
            this.trackT.reset();
            this.trackT.removeEventListener(TimerEvent.TIMER, this.loginFailMth);
            LoginMsg.parseMsg(param1);
            this._p2psohu.showTestInfo("LoginMsg clientip:" + LoginMsg._instance.ip + " timer.running:" + this.timer.running);
            if (!this.timer.running)
            {
                this.timer.start();
            }
            this._p2psohu.loginOKMth(LoginMsg._instance.p2pid);
            return;
        }// end function

        private function peerlistMsgMth(param1:ByteArray) : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            this.saveTrackActMth();
            if (this._p2psohu.config.isTestP2P)
            {
                _loc_2 = GetMixPeerListMsg.parseMsg(param1);
            }
            else
            {
                _loc_2 = GetPeerListMsg.parseMsg(param1);
            }
            if (this.getPeerlistMsgDic[_loc_2.filename] != undefined)
            {
                if (this.t.running)
                {
                    this.getPeerlistMsgDic[this.t.o.filename] = null;
                    delete this.getPeerlistMsgDic[this.t.o.filename];
                    this.t.reset();
                    if (this.t.o.filename != _loc_2.filename)
                    {
                        this.t.o = null;
                        this.t.o = new Object();
                        this.t.o.filename = _loc_2.filename;
                        this.t.start();
                    }
                    else
                    {
                        this.t.o = null;
                    }
                }
                else
                {
                    if (this.t.o == null)
                    {
                        this.t.o = new Object();
                        this.t.o.filename = _loc_2.filename;
                    }
                    this.t.start();
                }
            }
            else
            {
                if (this.t.running && this.t.o.filename == _loc_2.filename)
                {
                    this.t.reset();
                    this.t.o = null;
                }
                for (_loc_3 in this.getPeerlistMsgDic)
                {
                    
                    this.getPeerlistMsgDic[_loc_3] = null;
                    delete this.getPeerlistMsgDic[_loc_3];
                }
            }
            this._p2psohu.loaderMang.peerlistMth(_loc_2);
            return;
        }// end function

        private function delayDelMsg(event:TimerEvent) : void
        {
            this.t.stop();
            this.getPeerlistMsgDic[this.t.o.filename] = null;
            delete this.getPeerlistMsgDic[this.t.o.filename];
            this.t.o = null;
            return;
        }// end function

        private function saveTrackActMth() : void
        {
            var _loc_1:* = getTimer() - this.getPeerlistStartT;
            this._p2psohu.config.trackActTNum = (this._p2psohu.config.trackActTNum * 5 + _loc_1 * 3) / 8;
            return;
        }// end function

        private function loginFailMth(event:TimerEvent) : void
        {
            this.trackT.removeEventListener(TimerEvent.TIMER, this.loginFailMth);
            this.trackT.reset();
            this._p2psohu.showTestInfo("loginFailMth:", true);
            this._p2psohu.initFailInfo = "7;" + this.trackip + ":" + this.trackport;
            this._p2psohu.config.initErrorType = "05";
            this._p2psohu.config.lastMsgCMD = "login";
            this.testOtherPort();
            return;
        }// end function

        private function getPeerlistFail(param1:String) : void
        {
            this._p2psohu.showTestInfo("getPeerlistFail getTimer():" + getTimer() + " _getPeerlistFailIdx:" + this._getPeerlistFailIdx);
            this.clearGetPeerListMsgDic();
            if (this._getPeerlistFailIdx < 1)
            {
                this.sendMsgMth("getpeerlist", param1);
            }
            else
            {
                var _loc_2:String = this;
                var _loc_3:* = this._getPeerlistFailIdx + 1;
                _loc_2._getPeerlistFailIdx = _loc_3;
                if (this._getPeerlistFailIdx == 2)
                {
                    this._getPeerlistFailIdx = 0;
                    this._p2psohu.serverDieMth("tracker die getPeerlistFail");
                }
            }
            return;
        }// end function

        public function closeHandler(event:Event = null) : void
        {
            this._p2psohu.showTestInfo("tracker socket close:" + event);
            if (this._p2psohu.isAllLoadedOver)
            {
                return;
            }
            this.testOtherPort();
            return;
        }// end function

        private function connectHandler(event:Event) : void
        {
            event.target.removeEventListener(Event.CONNECT, this.connectHandler);
            socket.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.trackT.reset();
            this.trackT.removeEventListener(TimerEvent.TIMER, this.errorConnectMth);
            this.con_count = 0;
            this._reconnect = false;
            this._p2psohu.showTestInfo("track connect success dur:" + (getTimer() - this._startt), true);
            if (this._p2psohu.peer.mainNC.connected)
            {
                this._p2psohu.loginPeerMth();
            }
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._p2psohu.showTestInfo("tracker socket ioerror:" + event.errorID, true);
            this._p2psohu.initFailInfo = "5;" + this.trackip + ":" + this.trackport;
            this._p2psohu.serverDieMth("tracker die io");
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._p2psohu.showTestInfo("tracker socket securityerror:" + event.errorID, true);
            this._p2psohu.initFailInfo = "6;" + this.trackip + ":" + this.trackport;
            if (this._p2psohu.ns.bufferLength == 0)
            {
                _p2psohu.showFailInfoMth("blackscreen");
            }
            else
            {
                this._p2psohu.serverDieMth("tracker die security");
            }
            return;
        }// end function

        private function socketDataHandler(event:ProgressEvent) : void
        {
            this.readResponse();
            return;
        }// end function

        public function socketGC(param1:Boolean = false) : void
        {
            this.getPeerlistStartT = 0;
            this._getPeerlistFailIdx = 0;
            if (this.trackT != null)
            {
                this.trackT.stop();
                if (this.trackT.hasEventListener(TimerEvent.TIMER))
                {
                    if (this.trackT.delay == this._p2psohu.config.errorConTimeNumTrack)
                    {
                        this.trackT.removeEventListener(TimerEvent.TIMER, this.errorConnectMth);
                    }
                    else if (this.trackT.delay == 1000)
                    {
                        this.trackT.removeEventListener(TimerEvent.TIMER, this.loginFailMth);
                    }
                }
            }
            this._p2psohu.showTestInfo("socketGC  iscleanpre:" + this.iscleanpre + " socket.connected:" + (socket == null ? (null) : (socket.connected)));
            this.clearGetPeerListMsgDic();
            if (this.t.running)
            {
                this.t.reset();
            }
            this.t.o = null;
            if (param1)
            {
                this.timer.stop();
                this.timer.removeEventListener(TimerEvent.TIMER, this.sendHeartMth);
                this.iscleanpre = false;
            }
            if (this.iscleanpre)
            {
                return;
            }
            if (socket == null && !socket.connected)
            {
                return;
            }
            socket.removeEventListener(Event.CONNECT, this.connectHandler);
            socket.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.socketDataHandler);
            socket.removeEventListener(Event.CLOSE, this.closeHandler);
            if (socket.connected)
            {
                this.socket.close();
            }
            return;
        }// end function

        public function cleanPreMth() : void
        {
            this._p2psohu.showTestInfo("track socket cleanPreMth");
            this.iscleanpre = true;
            this.socketGC();
            return;
        }// end function

        public function isSendMsgSuc(param1:String) : Boolean
        {
            if (this.getPeerlistMsgDic[param1] == undefined)
            {
                return true;
            }
            return false;
        }// end function

        public function set peers(param1:Number) : void
        {
            this._peers = param1;
            return;
        }// end function

        public function get peers() : Number
        {
            return this._peers;
        }// end function

        public function get clientIp() : String
        {
            return LoginMsg._instance.ip;
        }// end function

    }
}
