package httpSocket
{
    import flash.errors.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import httpSocket.parse.*;
    import httpSocket.utils.*;

    public class HttpSocket extends EventDispatcher
    {
        private var _host:String;
        private var _port:int = 80;
        private var _src:String;
        private var _method:String = "GET";
        private var _file:ByteArray;
        private var _wait:Boolean = true;
        private var _len:int = 0;
        private var _isOver:Boolean;
        private var _postData:Object;
        private var _httpHeaders:Object;
        private var _socket:Socket;
        private var requestHeaderStr:String;
        private var requestStr:String;
        private var currentPosition:Number = 0;
        private var rangeNum:Number = 0;
        private var isfirst:Boolean = true;
        private var rangeba:ByteArray;
        private var _testMsgF:Function;
        private var _isHeaderLoad:Boolean = false;
        private var _isStartCdnLoad:Boolean = false;
        private var isContentLength_Head:Boolean = true;
        private var _filelen:int = 0;
        private var _backHead:ByteArray;
        private var _isCDNLoader:Boolean = false;
        private var _isP2pLive:Boolean = false;
        private var httptype:String = "1.0";
        private var heada:Array;
        public var plversion:String;
        private var _endNum:Number;
        private var _isend:Boolean = false;

        public function HttpSocket()
        {
            this._file = new ByteArray();
            this.rangeba = new ByteArray();
            this._backHead = new ByteArray();
            this.heada = new Array();
            this.rangeba = new ByteArray();
            this._httpHeaders = new Object();
            this.gc();
            return;
        }// end function

        public function load(param1:URLRequest) : void
        {
            var arg1:* = param1;
            var request:* = arg1;
            this.gc();
            this.rangeba.clear();
            if (request == null)
            {
                this.sendError("Invalid URLRequest");
                return;
            }
            var url:* = request.url;
            if (!this.analyseUrl(url) || request == null)
            {
                this.sendError("Error Url");
                return;
            }
            this._postData = request.data;
            var method:* = request.method;
            if (method == URLRequestMethod.POST || method == HttpSocketMethod.POST)
            {
                this._method = HttpSocketMethod.POST;
            }
            else
            {
                this._method = HttpSocketMethod.GET;
            }
            try
            {
                this._socket = new Socket();
                this._socket.addEventListener(Event.CLOSE, this.onClose);
                this._socket.addEventListener(Event.CONNECT, this.onConnect);
                this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
                this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
                this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
                this._socket.connect(this._host, this._port);
            }
            catch (e:IOError)
            {
                onError(new IOErrorEvent(IOErrorEvent.IO_ERROR));
                ;
            }
            catch (e:SecurityError)
            {
                onError(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
                ;
            }
            catch (e:Error)
            {
                onError();
            }
            return;
        }// end function

        private function analyseUrl(param1:String) : Boolean
        {
            var arr:Array;
            var hostValue:String;
            var portValue:int;
            var i:int;
            var hostArr:Array;
            var arg1:* = param1;
            var url:* = arg1;
            try
            {
                if (url == null)
                {
                    return false;
                }
                if (url.indexOf("http://") == -1)
                {
                    return false;
                }
                arr = url.split("/");
                if (arr == null || arr.length <= 2)
                {
                    return false;
                }
                hostValue = arr[2];
                if (hostValue == null || hostValue == "")
                {
                    return false;
                }
                portValue = this._port;
                if (hostValue.indexOf(":") != -1)
                {
                    hostArr = hostValue.split(":");
                    if (hostArr == null)
                    {
                        return false;
                    }
                    hostValue = hostArr[0];
                    if (hostValue == null || hostValue == "")
                    {
                        return false;
                    }
                    portValue = hostArr[1];
                }
                this._host = hostValue;
                this._port = portValue;
                i;
                if (arr[arr.length - 2] != "flashp2p")
                {
                    this._src = arr[3];
                    i;
                    while (i < arr.length)
                    {
                        
                        this._src = this._src + ("/" + arr[i]);
                        i = (i + 1);
                    }
                }
                else
                {
                    this._src = "flashp2p/" + arr[(arr.length - 1)];
                }
            }
            catch (e:Error)
            {
                return false;
            }
            return true;
        }// end function

        private function getFile(param1:ByteArray) : void
        {
            var _loc_2:HttpSocketEvent = null;
            this._filelen = this._filelen + param1.length;
            if (!this._isCDNLoader || !this._isP2pLive)
            {
                this._file.writeBytes(param1);
            }
            this.sendData(param1);
            if (this._len > 0 && this._filelen >= this._len && !this._isOver)
            {
                _loc_2 = new HttpSocketEvent(HttpSocketEvent.COMPLETE);
                _loc_2.data = this._file;
                dispatchEvent(_loc_2);
                this.isfirst = true;
                this._len = 0;
            }
            return;
        }// end function

        private function onClose(event:Event) : void
        {
            if (this._testMsgF != null)
            {
                if (this._socket != null && this._socket.connected)
                {
                    this._testMsgF("onClose:" + this._socket.bytesAvailable);
                }
            }
            this.rangeba.clear();
            dispatchEvent(new HttpSocketEvent(HttpSocketEvent.CLOSE));
            return;
        }// end function

        public function p2pliveMth(param1:String) : void
        {
            var _loc_2:String = null;
            this._file.clear();
            this.rangeba.clear();
            this._backHead.clear();
            this._filelen = 0;
            this.requestStr = "";
            this._len = 0;
            this._wait = true;
            this._isOver = false;
            this._filelen = 0;
            this.isfirst = true;
            this.isContentLength_Head = true;
            this.requestHeaderStr = "";
            this._src = "";
            this.heada[0] = this._method + " /" + param1 + " HTTP/" + this.httptype + "\r\n";
            for each (_loc_2 in this.heada)
            {
                
                this.requestStr = this.requestStr + _loc_2;
            }
            this.requestStr = this.requestStr + "\r\n";
            if (this._testMsgF != null)
            {
                this._testMsgF("p2pliveMth: " + this.requestStr);
            }
            this._socket.writeUTFBytes(this.requestStr);
            this._socket.flush();
            return;
        }// end function

        public function getDataMth() : void
        {
            var _loc_1:String = null;
            this._file.clear();
            this._filelen = 0;
            this.isfirst = true;
            this.rangeba.clear();
            this.requestStr = this.requestHeaderStr;
            for (_loc_1 in this._httpHeaders)
            {
                
                this.requestStr = this.requestStr + (_loc_1 + ":" + this._httpHeaders[_loc_1] + "\r\n");
            }
            this.requestStr = this.requestStr + "\r\n";
            if (this._testMsgF != null)
            {
                this._testMsgF("getDataMth: " + this.requestStr);
            }
            this._socket.writeUTFBytes(this.requestStr);
            this._socket.flush();
            return;
        }// end function

        private function onConnect(event:Event) : void
        {
            var _loc_2:* = undefined;
            if (this._socket == null || !this._socket.connected || this._src == "")
            {
                return;
            }
            this._socket.removeEventListener(Event.CONNECT, this.onConnect);
            this.heada.splice(0);
            this.heada.push(this._method + " /" + this._src + " HTTP/" + this.httptype + "\r\n");
            this.requestHeaderStr = this._method + " /" + this._src + " HTTP/" + this.httptype + "\r\n";
            this.heada.push("Host:" + this._host + ":" + this._port + "\r\n");
            this.requestHeaderStr = this.requestHeaderStr + ("Host:" + this._host + ":" + this._port + "\r\n");
            this.heada.push("Connection:" + "keep-alive" + "\r\n");
            this.requestHeaderStr = this.requestHeaderStr + ("Connection:" + "keep-alive" + "\r\n");
            if (!this._isP2pLive)
            {
                this.heada.push("Cache-Control: no-cache, must-revalidate" + "\r\n");
                this.requestHeaderStr = this.requestHeaderStr + ("Cache-Control: no-cache, must-revalidate" + "\r\n");
                this.heada.push("User-Agent:" + this.plversion + "\r\n");
                this.requestHeaderStr = this.requestHeaderStr + ("User-Agent:" + this.plversion + "\r\n");
                this.sendConnect(this.requestStr);
                this.requestStr = this.requestHeaderStr;
                this.requestStr = this.requestStr + "\r\n";
            }
            else
            {
                this.heada.push("User-Agent:" + this.plversion + "\r\n");
                this.requestHeaderStr = this.requestHeaderStr + ("User-Agent:" + this.plversion + "\r\n");
                this.sendConnect(this.requestStr);
                this.requestStr = this.requestHeaderStr;
                for (_loc_2 in this._httpHeaders)
                {
                    
                    this.requestStr = this.requestStr + (_loc_2 + ":" + this._httpHeaders[_loc_2] + "\r\n");
                }
                if (this._method != HttpSocketMethod.POST)
                {
                    this.requestStr = this.requestStr + "\r\n";
                    this._socket.writeUTFBytes(this.requestStr);
                }
                this._socket.flush();
            }
            return;
        }// end function

        private function onSocketData(event:ProgressEvent) : void
        {
            var _loc_3:Array = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:Array = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:Boolean = false;
            var _loc_10:String = null;
            var _loc_11:String = null;
            var _loc_12:Array = null;
            var _loc_13:String = null;
            var _loc_14:RegExp = null;
            var _loc_15:String = null;
            var _loc_16:String = null;
            var _loc_17:int = 0;
            var _loc_18:HttpSocketEvent = null;
            var _loc_19:String = null;
            var _loc_20:Number = NaN;
            var _loc_21:HttpSocketEvent = null;
            var _loc_2:* = new ByteArray();
            this._socket.readBytes(_loc_2);
            if (this.isfirst)
            {
                this.rangeba.writeBytes(_loc_2);
                _loc_3 = ByteParse.parseHead(this.rangeba);
                if (_loc_3 == null)
                {
                    return;
                }
                this.isfirst = false;
                this._backHead = _loc_3[0];
                this._backHead.position = 0;
                _loc_4 = this._backHead.toString();
                if (this._testMsgF != null)
                {
                    this._testMsgF(this.host + "|" + this.port + "|" + _loc_4);
                }
                _loc_5 = StringUtil.replace(_loc_4, "\r\n\r\n", "");
                _loc_6 = _loc_5.split("\r\n");
                _loc_7 = "";
                _loc_8 = "";
                if (this._testMsgF != null)
                {
                }
                _loc_9 = false;
                _loc_10 = "";
                for each (_loc_11 in _loc_6)
                {
                    
                    _loc_12 = _loc_11.split(":");
                    if (_loc_12.length == 1)
                    {
                        _loc_13 = StringUtil.replace(_loc_12[0], "HTTP/" + "1.1", "");
                        _loc_14 = /^ +""^ +/;
                        _loc_7 = _loc_13.replace(_loc_14, "");
                        _loc_15 = StringUtil.replace(_loc_7, "HTTP/" + "1.0", "");
                        _loc_7 = _loc_15.replace(_loc_14, "");
                        continue;
                    }
                    if (!this._isP2pLive && (_loc_7.indexOf("302") != -1 || _loc_7.indexOf("301") != -1))
                    {
                        if (_loc_12[0] == "Location")
                        {
                            _loc_9 = true;
                            if (_loc_12.length != 2)
                            {
                                _loc_16 = _loc_12[1];
                                _loc_17 = 2;
                                while (_loc_17 < _loc_12.length)
                                {
                                    
                                    _loc_16 = _loc_16 + (":" + _loc_12[_loc_17]);
                                    _loc_17++;
                                }
                                _loc_10 = _loc_16;
                            }
                            else
                            {
                                _loc_10 = _loc_12[1];
                            }
                            break;
                        }
                        else
                        {
                            continue;
                        }
                    }
                    if (_loc_7.indexOf("404") != -1)
                    {
                        this.sendError(_loc_7, _loc_8);
                        break;
                    }
                    if (!this._isP2pLive && (_loc_7.indexOf("200") != -1 || _loc_7.indexOf("206") != -1))
                    {
                        if (_loc_4.search("Content-Range") == -1)
                        {
                            this.sendError("no_range");
                            return;
                        }
                    }
                    if (_loc_12[0] == "Date")
                    {
                        _loc_8 = _loc_12[1];
                        continue;
                    }
                    if (_loc_12[0] == "Content-Length")
                    {
                        this.isContentLength_Head = true;
                        if (_loc_7.indexOf("200") == -1 && _loc_7.indexOf("206") == -1)
                        {
                            this.sendError(_loc_7, _loc_8);
                        }
                        else
                        {
                            this._len = int(StringUtil.replace(String(_loc_12[1]), " ", ""));
                            if (this.rangeNum != 0 && this._len != this.rangeNum && this._isend == false)
                            {
                                this.sendError("wrongdata _len:" + this._len + " :rangeNum:" + this.rangeNum + " _filelen:" + this._filelen);
                                this._backHead.clear();
                                this.rangeba.clear();
                                _loc_2.clear();
                                this.isfirst = true;
                                break;
                            }
                        }
                        continue;
                    }
                    if (this._isP2pLive && _loc_12[0] == "Parameter")
                    {
                        _loc_18 = new HttpSocketEvent(HttpSocketEvent.NEXTFILENAME);
                        _loc_19 = StringUtil.replace(_loc_12[1], " ", "");
                        _loc_18.data = _loc_19;
                        dispatchEvent(_loc_18);
                        continue;
                    }
                    if (!this._isP2pLive && _loc_12[0] == "Content-Range")
                    {
                        _loc_8 = _loc_12[1];
                        _loc_20 = Number(_loc_8.substring((_loc_8.indexOf("/") + 1), _loc_8.length));
                        _loc_21 = new HttpSocketEvent(HttpSocketEvent.FILE_LENGTH);
                        _loc_21.data = _loc_20;
                        dispatchEvent(_loc_21);
                        continue;
                    }
                    if (_loc_12[0] == "Transfer-Encoding")
                    {
                        continue;
                    }
                }
                if (_loc_7.indexOf("302") != -1 || _loc_7.indexOf("301") != -1)
                {
                    this.gc();
                    if (_loc_9 == false)
                    {
                        this.sendError("302-wrongurl");
                    }
                    else
                    {
                        this.sendError("302=" + _loc_10);
                    }
                    return;
                }
                if (_loc_7.indexOf("200") != -1 || _loc_7.indexOf("206") != -1)
                {
                    this.getFile(_loc_3[1]);
                }
                else
                {
                    this.sendError(_loc_7, _loc_8);
                }
                this._backHead.clear();
                this.rangeba.clear();
                _loc_2.clear();
            }
            else if (this.isContentLength_Head)
            {
                this.getFile(_loc_2);
            }
            return;
        }// end function

        private function onError(param1 = null) : void
        {
            this.rangeba.clear();
            if (param1 && param1.type)
            {
                this.sendError(param1.type);
            }
            else
            {
                this.sendError("Unknow Error");
            }
            return;
        }// end function

        private function sendConnect(param1:Object) : void
        {
            var value:Object;
            var e:HttpSocketEvent;
            var loc1:*;
            var arg1:* = param1;
            e;
            value = arg1;
            try
            {
                if (!this._isOver)
                {
                    e = new HttpSocketEvent(HttpSocketEvent.CONNECT);
                    e.data = value;
                    dispatchEvent(e);
                }
            }
            catch (ee:Error)
            {
                trace("--x sendOpen", ee.message);
            }
            return;
        }// end function

        private function sendOpen(param1:Object) : void
        {
            var value:Object;
            var e:HttpSocketEvent;
            var loc1:*;
            var arg1:* = param1;
            e;
            value = arg1;
            try
            {
                if (!this._isOver)
                {
                    e = new HttpSocketEvent(HttpSocketEvent.OPEN);
                    e.data = value;
                    dispatchEvent(e);
                }
            }
            catch (ee:Error)
            {
                trace("--x sendOpen", ee.message);
            }
            return;
        }// end function

        private function sendData(param1:Object) : void
        {
            var e:HttpSocketEvent;
            var arg1:* = param1;
            var value:* = arg1;
            try
            {
                e = new HttpSocketEvent(HttpSocketEvent.PROGRESS);
                e.data = value;
                dispatchEvent(e);
            }
            catch (ee:Error)
            {
                trace("--x sendData", ee.message);
            }
            return;
        }// end function

        private function sendError(param1:String, param2:String = "") : void
        {
            var e:HttpSocketEvent;
            var o:Object;
            var arg1:* = param1;
            var datestr:* = param2;
            try
            {
                e = new HttpSocketEvent(HttpSocketEvent.ERROR);
                e.msg = arg1;
                if (datestr != "")
                {
                    o = new Object();
                    o.datestr = datestr;
                    e.data = o;
                }
                dispatchEvent(e);
            }
            catch (ee:Error)
            {
                trace("--x sendError", ee.message);
            }
            return;
        }// end function

        public function get host() : String
        {
            return this._host;
        }// end function

        public function get port() : int
        {
            return this._port;
        }// end function

        public function get bytesTotal() : Number
        {
            return this._len;
        }// end function

        public function get bytesLoaded() : Number
        {
            return this._filelen;
        }// end function

        public function close() : void
        {
            this.gc();
            return;
        }// end function

        private function gc() : void
        {
            this._len = 0;
            this._wait = true;
            this._isOver = false;
            this._filelen = 0;
            if (this._file)
            {
                this._file.clear();
            }
            this.heada.splice(0);
            this._file = null;
            this._file = new ByteArray();
            if (this._backHead)
            {
                this._backHead.clear();
            }
            this._backHead = null;
            this._backHead = new ByteArray();
            if (this._socket != null)
            {
                if (this._socket.connected)
                {
                    this._socket.close();
                    this._socket.removeEventListener(Event.CONNECT, this.onConnect);
                    this._socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
                    this._socket.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
                    this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
                    this._socket.removeEventListener(Event.CLOSE, this.onClose);
                }
            }
            this._src = "";
            this.isfirst = true;
            this.isContentLength_Head = true;
            this.requestHeaderStr = "";
            this._socket = null;
            this.rangeNum = 0;
            return;
        }// end function

        public function set testMsgF(param1:Function) : void
        {
            this._testMsgF = param1;
            return;
        }// end function

        public function set isHeaderLoad(param1:Boolean) : void
        {
            this._isHeaderLoad = param1;
            return;
        }// end function

        public function setRangeHeaders(param1:Number, param2:Number = -1, param3:Boolean = false) : void
        {
            if (param2 == -1)
            {
                this._httpHeaders.Range = "Bytes=" + param1 + "-";
            }
            else
            {
                this._httpHeaders.Range = "Bytes=" + param1 + "-" + param2;
            }
            this.rangeNum = param2 - param1 + 1;
            this._endNum = param2;
            this._isend = param3;
            trace("rangeNum:" + this.rangeNum + " end:" + param2 + " begin:" + param1);
            return;
        }// end function

        public function addHeadItem(param1:String, param2:String) : Boolean
        {
            if (HttpSocketUtil.checkAddItem(param1, param2))
            {
                this._httpHeaders[param1] = param2;
                return true;
            }
            return false;
        }// end function

        public function set isCDNLoader(param1:Boolean) : void
        {
            this._isCDNLoader = param1;
            return;
        }// end function

        public function set isP2pLive(param1:Boolean) : void
        {
            this._isP2pLive = param1;
            this.httptype = "1.1";
            return;
        }// end function

        public function get socketType() : Boolean
        {
            return this._socket == null ? (false) : (this._socket.connected);
        }// end function

        public function set isStartCdnLoad(param1:Boolean) : void
        {
            this._isStartCdnLoad = param1;
            return;
        }// end function

    }
}
