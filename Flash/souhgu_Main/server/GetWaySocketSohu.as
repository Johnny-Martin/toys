package server
{
    import com.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;

    public class GetWaySocketSohu extends BaseSocketSohu
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

        public function GetWaySocketSohu()
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
                switch(param1 % 3)
                {
                    case 0:
                    {
                        this.suc_socketip = this._p2psohu.config.getWayHost;
                        break;
                    }
                    case 1:
                    {
                        this.suc_socketip = this._p2psohu.config.getWayHostIP;
                        break;
                    }
                    case 2:
                    {
                        this.suc_socketip = this._p2psohu.config.getWayHostIp2;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if ((Capabilities.os as String).indexOf("Mac") != -1)
                {
                    this.suc_socketport = 988;
                }
                else
                {
                    this.suc_socketport = param2 % 2 == 0 ? (this._p2psohu.config.getWayPort) : (988);
                }
            }
            this._p2psohu.showTestInfo("Getway  socketInit:" + this.suc_socketip + ":" + this.suc_socketport + " count:" + param1 + " portcount:" + param2, true);
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
            this._p2psohu.showTestInfo("Getway  confail", true);
            this._p2psohu.initFailInfo = "0;" + this.suc_socketip + ":" + this.suc_socketport;
            this._p2psohu.config.initErrorType = "00";
            this.socketGC();
            this._issuc = false;
            var _loc_2:String = this;
            var _loc_3:* = this.con_port_count + 1;
            _loc_2.con_port_count = _loc_3;
            if (this.con_port_count % 2 == 0)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.con_count + 1;
                _loc_2.con_count = _loc_3;
                if (this.con_count > 2 && this._p2psohu.isfirst)
                {
                    this._p2psohu.showTestInfo("getway connect fail", true);
                    this._p2psohu.initFailMth();
                    this._p2psohu.cleanMth();
                }
                this.socketInit(this.con_count, this.con_port_count);
                return;
            }
            this.socketInit(this.con_count, this.con_port_count);
            return;
        }// end function

        private function changeSocket() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this.con_port_count + 1;
            _loc_1.con_port_count = _loc_2;
            if (this.con_port_count % 2 == 0)
            {
                var _loc_1:String = this;
                var _loc_2:* = this.con_count + 1;
                _loc_1.con_count = _loc_2;
                if (this.con_count > 2 && this._p2psohu.isfirst)
                {
                    this._p2psohu.showTestInfo("getway connect fail", true);
                    this._p2psohu.initFailMth();
                    this._p2psohu.cleanMth();
                }
            }
            return;
        }// end function

        private function closeHandler(event:Event) : void
        {
            this._p2psohu.showTestInfo("getway socket断开链接  close");
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
            this._p2psohu.showTestInfo("getway connect success  dur:" + this._p2psohu.config.getwayConT, true);
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
            if (super.backMsgLenMth(this.msg))
            {
                this.socketMsgBackMth();
            }
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
            this._p2psohu.showTestInfo("GetWayMsg  back  sp:" + GetWayMsg._instance.sp + " province:" + GetWayMsg._instance.province + " city:" + GetWayMsg._instance.city, true);
            if (GetWayMsg._instance.sp == 1 || GetWayMsg._instance.sp == 2 || GetWayMsg._instance.sp == 8)
            {
                this._p2psohu.rtmfpServerOKMth();
            }
            else if (!this._p2psohu.config.isplayinit)
            {
                this._p2psohu.isGetwayInitFail = true;
            }
            else
            {
                this._p2psohu.showFailInfoMth("smallSuppliers");
            }
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this._p2psohu.showTestInfo("getway socket ioerror");
            this._p2psohu.initFailInfo = "1;" + this.suc_socketip + ":" + this.suc_socketport;
            if (this._p2psohu.peer.mainNC == null || this._p2psohu.trackSocket == null || this._p2psohu.trackSocket.socket == null || this._p2psohu.trackSocket != null && this._p2psohu.trackSocket.socket != null && !this._p2psohu.trackSocket.socket.connected || this._p2psohu.peer.mainNC != null && !this._p2psohu.peer.mainNC.connected)
            {
                this.restartGetWay();
            }
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this._p2psohu.showTestInfo("getway socket securityError");
            this._p2psohu.initFailInfo = "2;" + this.suc_socketip + ":" + this.suc_socketport;
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

        public function restartGetWay(param1:String = null) : void
        {
            if (param1 != null)
            {
                if (this.waitStopFileT.running)
                {
                    return;
                }
            }
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

        public function getwayConType() : Boolean
        {
            return this.conT.running;
        }// end function

        public function cleanPreMth() : void
        {
            this.socketGC(true);
            return;
        }// end function

    }
}
