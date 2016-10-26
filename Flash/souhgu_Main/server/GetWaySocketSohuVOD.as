package server
{
    import com.*;
    import flash.events.*;
    import flash.utils.*;

    public class GetWaySocketSohuVOD extends BaseSocketSohu
    {
        private var msg:ByteArray;
        private var waitStopFileT:Timer;
        private var waitInterval:Number = 1000;
        private var conT:Timer;
        private var con_count:int = 0;
        private var suc_socketip:String;
        private var suc_socketport:Number;
        private var _issuc:Boolean = false;
        private var con_port_count:int = 0;
        private var _startt:Number;

        public function GetWaySocketSohuVOD()
        {
            this.msg = new ByteArray();
            return;
        }// end function

        public function init() : void
        {
            this.waitStopFileT = new Timer(this.waitInterval, 1);
            this.waitStopFileT.addEventListener(TimerEvent.TIMER, this.waitForCallInit);
            this.conT = new Timer(this._p2psohu.config.errorConTimeNumGet);
            return;
        }// end function

        private function waitForCallInit(event:TimerEvent) : void
        {
            this.waitStopFileT.reset();
            if (this.waitInterval == 8000)
            {
                this.socketInit(this.con_count, this.con_port_count);
                return;
            }
            this.waitInterval = this.waitInterval + (this.con_port_count % 2 == 0 ? (1000) : (0));
            this.waitStopFileT.delay = this.waitInterval;
            this.socketInit(this.con_count, this.con_port_count);
            return;
        }// end function

        public function socketInit(param1:int = 0, param2:int = 0) : void
        {
            if (this._p2psohu.isAllDie)
            {
                return;
            }
            if (this._issuc)
            {
                this.con_count = 0;
                this.con_port_count = 0;
                this.socketGC();
            }
            this.conT.reset();
            this.conT.addEventListener(TimerEvent.TIMER, this.connectFailMth);
            this.conT.start();
            socket = new HaleSocket();
            if (!this._issuc)
            {
                if (this.con_count >= 3)
                {
                    this._p2psohu.showTestInfo("getway vod init fail", true);
                    this.cleanPreMth();
                    this.p2pSohuLib.getwayInit();
                    return;
                }
                this.suc_socketip = "p2p.vod.tv.sohu.com";
                this.suc_socketport = 8000;
            }
            this._p2psohu.showTestInfo("Getway vod socketInit:" + this.suc_socketip + ":" + this.suc_socketport + " count:" + param1 + " portcount:" + param2, true);
            socket.connect(this.suc_socketip, this.suc_socketport);
            socket.addEventListener(Event.CLOSE, this.closeHandler);
            socket.addEventListener(Event.CONNECT, this.connectHandler);
            socket.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            socket.addEventListener(ProgressEvent.SOCKET_DATA, this.socketDataHandler);
            this._startt = getTimer();
            return;
        }// end function

        private function connectFailMth(event:TimerEvent) : void
        {
            this._p2psohu.showTestInfo("Getway vod confail", true);
            this._p2psohu.config.initErrorType = "00";
            this.socketGC();
            this._issuc = false;
            var _loc_2:String = this;
            var _loc_3:* = this.con_count + 1;
            _loc_2.con_count = _loc_3;
            this.socketInit(this.con_count, this.con_port_count);
            return;
        }// end function

        private function changeSocket() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this.con_count + 1;
            _loc_1.con_count = _loc_2;
            return;
        }// end function

        private function closeHandler(event:Event) : void
        {
            this._p2psohu.showTestInfo("getway vod socket断开链接  close");
            this._p2psohu.config.initErrorType = "02";
            this.restartGetWay();
            return;
        }// end function

        private function connectHandler(event:Event) : void
        {
            event.target.removeEventListener(Event.CONNECT, this.connectHandler);
            socket.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._p2psohu.config.getwayConT = getTimer() - this._startt;
            this._p2psohu.showTestInfo("getway vod connect success  dur:" + this._p2psohu.config.getwayConT, true);
            this.sendGetwayMsg();
            return;
        }// end function

        private function sendGetwayMsg() : void
        {
            if (!socket.connected)
            {
                return;
            }
            this.conT.reset();
            this.conT.removeEventListener(TimerEvent.TIMER, this.connectFailMth);
            var _loc_1:* = GetWayMsg.sendMsg();
            socket.writeBytes(_loc_1);
            socket.flush();
            return;
        }// end function

        private function readResponse() : void
        {
            if (this.waitStopFileT.running)
            {
                this.waitStopFileT.stop();
            }
            this._issuc = true;
            socket.readBytes(this.msg, 0, socket.bytesAvailable);
            if (String.fromCharCode(this.msg.readByte()) == "1")
            {
                this._p2psohu.config.getWayHost = "p2p.vod.tv.sohu.com";
            }
            else
            {
                this._p2psohu.config.getWayHost = "p2p.live.tv.sohu.com";
            }
            this._p2psohu.showTestInfo("getway vod  success  getWayHost:" + this._p2psohu.config.getWayHost, true);
            this._p2psohu.getwayInit();
            this.socketGC();
            return;
        }// end function

        private function socketMsgBackMth() : void
        {
            var _loc_1:* = _baA.shift();
            var _loc_2:* = _loc_1.readUnsignedShort();
            if (_loc_1.readUnsignedInt() == GetWayMsg._instance.MARK)
            {
                switch(GetWayMsg._instance.P2P_PROC_SERIAL(_loc_1.readUnsignedInt()))
                {
                    case P2PMsg.P2P_GETWAY_AND_CLIENT_SOURCE:
                    {
                        _loc_1.readUnsignedInt();
                        this.getWayMsgMth(_loc_1);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            this.socketGC();
            if (_baA.length != 0)
            {
                this.socketMsgBackMth();
            }
            return;
        }// end function

        private function getWayMsgMth(param1:ByteArray) : void
        {
            GetWayMsg.parseMsg(param1);
            this._p2psohu.showTestInfo("GetWayMsg vod back  dur:" + (getTimer() - this._startt));
            this._p2psohu.rtmfpServerOKMth();
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._p2psohu.showTestInfo("getway vod socket ioerror");
            if (this._p2psohu.peer.mainNC == null || this._p2psohu.trackSocket == null || this._p2psohu.trackSocket.socket == null || this._p2psohu.trackSocket != null && this._p2psohu.trackSocket.socket != null && !this._p2psohu.trackSocket.socket.connected || this._p2psohu.peer.mainNC != null && !this._p2psohu.peer.mainNC.connected)
            {
                this.restartGetWay();
            }
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._p2psohu.showTestInfo("getway vod socket securityError");
            this._p2psohu.config.initErrorType = "01";
            if (this._p2psohu.peer.mainNC == null || this._p2psohu.trackSocket == null || this._p2psohu.trackSocket.socket == null || this._p2psohu.trackSocket != null && this._p2psohu.trackSocket.socket != null && !this._p2psohu.trackSocket.socket.connected || this._p2psohu.peer.mainNC != null && !this._p2psohu.peer.mainNC.connected)
            {
                this.restartGetWay();
            }
            return;
        }// end function

        private function socketDataHandler(event:ProgressEvent) : void
        {
            this.readResponse();
            return;
        }// end function

        public function restartGetWay() : void
        {
            this.changeSocket();
            if (this.waitStopFileT.running)
            {
                this.waitStopFileT.stop();
                this.waitInterval = 1000;
                this.waitStopFileT.delay = this.waitInterval;
                this.socketGC();
            }
            this.waitStopFileT.reset();
            this.waitStopFileT.start();
            return;
        }// end function

        public function socketGC(param1:Boolean = false) : void
        {
            if (param1)
            {
                this.con_count = 0;
                this.con_port_count = 0;
            }
            if (this.waitStopFileT.running)
            {
                this.waitStopFileT.reset();
            }
            if (this.conT.running)
            {
                this.conT.reset();
                this.conT.removeEventListener(TimerEvent.TIMER, this.connectFailMth);
            }
            if (socket == null)
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
                socket.close();
            }
            return;
        }// end function

        public function cleanPreMth() : void
        {
            this.socketGC(true);
            return;
        }// end function

    }
}
