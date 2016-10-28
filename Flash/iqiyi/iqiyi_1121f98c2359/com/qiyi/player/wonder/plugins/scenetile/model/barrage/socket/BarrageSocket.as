package com.qiyi.player.wonder.plugins.scenetile.model.barrage.socket
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.common.event.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class BarrageSocket extends EventDispatcher
    {
        private const DOMAIN:String = "buffalo.sns.iqiyi.com";
        private const PORT_SOCKET:int = 9527;
        private const PORT_CROSSDOMAIN:int = 9528;
        private const HEAD_BYTE_SIZE:int = 8;
        private const TVL_TYPE_BYTE_SIZE:int = 1;
        private const TVL_CONTENTSIZE_BYTE_SIZE:int = 4;
        private const HEART_BEAT_TIME:int = 5000;
        private var _socket:Socket;
        private var _socketData:ByteArray;
        private var _cacheData:ByteArray;
        private var _timer:Timer;
        private var _tvid:String = "";
        private var _isConnecting:Boolean = false;
        private var _log:ILogger;
        public static const Evt_BarrageSocketConnected:String = "evtBarrageSocketConnected";
        public static const Evt_BarrageSocketIOError:String = "evtBarrageSocketIOError";
        public static const Evt_BarrageSocketSecurityError:String = "evtBarrageSocketSecurityError";
        public static const Evt_BarrageSocketClose:String = "evtBarrageSocketClose";
        public static const Evt_BarrageSocketReceiveData:String = "evtBarrageSocketReceiveData";
        public static const TVL_TYPE_LOGIN:int = 1;
        public static const TVL_TYPE_LOGOUT:int = 2;
        public static const TVL_TYPE_PRIVATE:int = 3;
        public static const TVL_TYPE_MULTICAST:int = 4;
        public static const TVL_TYPE_HEART_BEAT:int = 5;
        public static const TVL_TYPE_SEND_MESSAGE:int = 6;
        public static const APPID:int = 21;

        public function BarrageSocket()
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.plugins.scenetile.model.barrage.socket.BarrageSocket");
            this._socket = new Socket();
            this._socket.endian = Endian.BIG_ENDIAN;
            this._socket.addEventListener(Event.CONNECT, this.onConnectHandler);
            this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler);
            this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityErrorHandler);
            this._socket.addEventListener(Event.CLOSE, this.onCloseHandler);
            this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketDataHandler);
            this._socketData = new ByteArray();
            this._socketData.endian = Endian.BIG_ENDIAN;
            this._cacheData = new ByteArray();
            this._cacheData.endian = Endian.BIG_ENDIAN;
            this._timer = new Timer(this.HEART_BEAT_TIME);
            this._timer.addEventListener(TimerEvent.TIMER, this.onHeartBeat);
            return;
        }// end function

        public function get connected() : Boolean
        {
            return this._socket.connected;
        }// end function

        public function get isConnecting() : Boolean
        {
            return this._isConnecting;
        }// end function

        public function open(param1:String) : void
        {
            this._tvid = param1;
            if (!this._socket.connected && !this._isConnecting)
            {
                this._log.info("BarrageSocket start connect!");
                this._isConnecting = true;
                Security.loadPolicyFile("xmlsocket://" + this.DOMAIN + ":" + this.PORT_CROSSDOMAIN);
                this._socket.connect(this.DOMAIN, this.PORT_SOCKET);
            }
            return;
        }// end function

        public function close() : void
        {
            this._isConnecting = false;
            this._timer.stop();
            this.sendLogout();
            try
            {
                this._socket.close();
                this._log.info("BarrageSocket closed!");
            }
            catch (error:Error)
            {
            }
            this.clearBytes();
            return;
        }// end function

        private function clearBytes() : void
        {
            this._socketData.length = 0;
            this._socketData.position = 0;
            this._cacheData.length = 0;
            this._cacheData.position = 0;
            return;
        }// end function

        private function onConnectHandler(event:Event) : void
        {
            this._log.info("BarrageSocket connect successful!");
            this._isConnecting = false;
            this.clearBytes();
            this.sendLogin();
            this._timer.start();
            dispatchEvent(new CommonEvent(Evt_BarrageSocketConnected));
            return;
        }// end function

        private function onIOErrorHandler(event:IOErrorEvent) : void
        {
            this._log.info("BarrageSocket IO error!");
            this._isConnecting = false;
            this._timer.stop();
            this.clearBytes();
            dispatchEvent(new CommonEvent(Evt_BarrageSocketIOError));
            return;
        }// end function

        private function onSecurityErrorHandler(event:Event) : void
        {
            this._log.info("BarrageSocket security error!");
            this._isConnecting = false;
            this._timer.stop();
            this.clearBytes();
            dispatchEvent(new CommonEvent(Evt_BarrageSocketSecurityError));
            return;
        }// end function

        private function onCloseHandler(event:Event) : void
        {
            this._log.info("BarrageSocket server close!");
            this._isConnecting = false;
            this._timer.stop();
            this.clearBytes();
            dispatchEvent(new CommonEvent(Evt_BarrageSocketClose));
            return;
        }// end function

        private function onSocketDataHandler(event:ProgressEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            this._socket.readBytes(this._socketData, this._socketData.length);
            while (true)
            {
                
                if (this._socketData.length >= this.HEAD_BYTE_SIZE)
                {
                    this._socketData.position = 0;
                    _loc_2 = this._socketData.readUnsignedShort();
                    _loc_3 = this._socketData.readUnsignedShort();
                    _loc_4 = this._socketData.readUnsignedInt();
                    _loc_5 = this._socketData.length - this.HEAD_BYTE_SIZE - _loc_4;
                    if (_loc_5 >= 0)
                    {
                        this.parse(_loc_3);
                        if (_loc_5 > 0)
                        {
                            this._cacheData.writeBytes(this._socketData, this.HEAD_BYTE_SIZE + _loc_4);
                            this._socketData.position = 0;
                            this._socketData.length = 0;
                            this._socketData.writeBytes(this._cacheData);
                            this._cacheData.length = 0;
                            this._cacheData.position = 0;
                        }
                        else
                        {
                            this._socketData.length = 0;
                        }
                        this._socketData.position = 0;
                    }
                    else
                    {
                        break;
                    }
                    continue;
                }
                break;
            }
            return;
        }// end function

        private function parse(param1:int) : void
        {
            var _loc_2:Array = null;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:String = null;
            var _loc_7:Object = null;
            if (param1 > 0)
            {
                _loc_2 = [];
                this._socketData.position = this.HEAD_BYTE_SIZE;
                _loc_3 = 0;
                while (_loc_3 < param1)
                {
                    
                    _loc_4 = this._socketData.readUnsignedByte();
                    _loc_5 = this._socketData.readUnsignedInt();
                    _loc_6 = this._socketData.readMultiByte(_loc_5, "utf-8");
                    _loc_7 = new Object();
                    _loc_7.TVLType = _loc_4;
                    _loc_7.TVLContent = _loc_6;
                    _loc_2.push(_loc_7);
                    _loc_3++;
                }
                dispatchEvent(new CommonEvent(Evt_BarrageSocketReceiveData, _loc_2));
            }
            return;
        }// end function

        private function onHeartBeat(event:Event) : void
        {
            this.sendHeartBeat();
            return;
        }// end function

        public function send(param1:int, param2:String) : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:ByteArray = null;
            if (this._socket.connected)
            {
                _loc_3 = 1;
                _loc_4 = 1;
                _loc_5 = new ByteArray();
                _loc_5.endian = Endian.BIG_ENDIAN;
                _loc_5.writeMultiByte(param2, "utf-8");
                this._socket.writeShort(_loc_3);
                this._socket.writeShort(_loc_4);
                this._socket.writeInt(this.TVL_TYPE_BYTE_SIZE + this.TVL_CONTENTSIZE_BYTE_SIZE + _loc_5.length);
                this._socket.writeByte(param1);
                this._socket.writeInt(_loc_5.length);
                this._socket.writeBytes(_loc_5);
                this._socket.flush();
            }
            return;
        }// end function

        public function sendLogin(param1:Boolean = true) : void
        {
            this.send(TVL_TYPE_LOGIN, this.createSendContent(TVL_TYPE_LOGIN, param1));
            return;
        }// end function

        private function sendLogout() : void
        {
            this.send(TVL_TYPE_LOGOUT, this.createSendContent(TVL_TYPE_LOGOUT));
            return;
        }// end function

        private function sendHeartBeat() : void
        {
            this.send(TVL_TYPE_HEART_BEAT, this.createSendContent(TVL_TYPE_HEART_BEAT));
            return;
        }// end function

        private function createSendContent(param1:int, param2:Boolean = true) : String
        {
            var _loc_3:String = "";
            if (UserManager.getInstance().user)
            {
                _loc_3 = UserManager.getInstance().user.P00001;
            }
            var _loc_4:* = new Object();
            _loc_4.msgType = param1;
            var _loc_5:* = new Object();
            _loc_5.tvid = Number(this._tvid);
            _loc_5.addTime = new Date().getTime();
            _loc_5.authcookie = _loc_3;
            _loc_5.udid = UUIDManager.instance.uuid;
            _loc_5.appid = APPID;
            _loc_5.history = param2 ? (1) : (0);
            _loc_4.data = [_loc_5];
            return JSON.encode(_loc_4);
        }// end function

    }
}
