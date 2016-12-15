package server
{
    import com.*;
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import model.*;

    public class PeerForLoad extends BaseCtrl
    {
        private var _incomingStream:HoldNetStream;
        private var _outgoingStream:HoldNetStream;
        public var rpeerid:String;
        public var conSucF:Function;
        public var fileinfo:Object;
        private var _delayT:TimerSohu;
        private var _delayNum:Number = 50;
        private var sendDataA:Array;
        private var _wrongo:Object;

        public function PeerForLoad()
        {
            this.fileinfo = new Object();
            this.sendDataA = new Array();
            return;
        }// end function

        public function init(param1:Object) : void
        {
            var fileo:* = param1;
            this.fileinfo = fileo;
            var filensname:* = this.p2pSohuLib.peer.mainPeer.slice(0, 8) + fileo.filename + fileo.dataIdx;
            this._outgoingStream = new HoldNetStream(this._p2psohu.peer.mainNC, NetStream.DIRECT_CONNECTIONS);
            this._outgoingStream.addEventListener(NetStatusEvent.NET_STATUS, this.outFileNSHandler);
            this._outgoingStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorMth);
            this._outgoingStream.publish(fileo.filename + fileo.dataIdx);
            var o:* = new Object();
            o.onPeerConnect = function (param1:NetStream) : Boolean
            {
                _p2psohu.showTestInfo("rp 连入 rpid:" + param1.farID.slice(0, 8) + " nslen:" + _outgoingStream.peerStreams.length + " nsname:" + fileinfo.dataIdx);
                if (_outgoingStream.peerStreams.length > 0)
                {
                    _p2psohu.showTestInfo("流被占" + " rpid:" + param1.farID.slice(0, 8) + " nslen:" + _outgoingStream.peerStreams.length + " nsname:" + fileinfo.dataIdx);
                    return false;
                }
                if (fileinfo == null)
                {
                    _p2psohu.showTestInfo("pl 流已死:" + " nsname:" + fileinfo.dataIdx);
                    this.gc();
                    return false;
                }
                var _loc_2:* = _p2psohu.peer.sendPeer.isLimitMth(param1);
                if (_loc_2)
                {
                    rpConnectSucMth(param1.farID);
                }
                return _loc_2;
            }// end function
            ;
            this._outgoingStream.client = o;
            this._delayT = new TimerSohu(this._delayNum);
            this._delayT.addEventListener(TimerEvent.TIMER, this.delaySendData);
            return;
        }// end function

        private function rpConnectSucMth(param1:String) : void
        {
            var rp:* = param1;
            this.rpeerid = rp;
            this._incomingStream = new HoldNetStream(this._p2psohu.peer.mainNC, rp);
            this._incomingStream.addEventListener(NetStatusEvent.NET_STATUS, this.inFileNSHandler);
            this._incomingStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorMth);
            var inname:* = rp + this.fileinfo.filename + this.fileinfo.dataIdx;
            this._incomingStream.play(inname);
            var o:* = new Object();
            o.onSP = function (param1:int, param2:int, param3:int, param4:Object) : void
            {
                dataForRP(param1, param2, param3, param4);
                return;
            }// end function
            ;
            this._incomingStream.client = o;
            if (!this._delayT.running)
            {
                this._delayT.start();
            }
            return;
        }// end function

        private function asyncErrorMth(event:AsyncErrorEvent) : void
        {
            trace(event);
            return;
        }// end function

        private function outFileNSHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
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

        private function inFileNSHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetStream.Play.Start":
                {
                    this._p2psohu.showTestInfo("sp-rp 链接成功===rp:" + this.rpeerid.slice(0, 8) + " nsname:" + this.fileinfo.dataIdx);
                    this.conSucF(this);
                    break;
                }
                case "NetStream.Play.Stop":
                case "NetStream.Play.Failed":
                {
                    this.clearNs();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function delaySendData(event:TimerEvent) : void
        {
            if (this.sendDataA.length == 0)
            {
                return;
            }
            this.sendDataToRp(this.sendDataA.shift());
            return;
        }// end function

        private function sendDataToRp(param1:Object) : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            if (this._p2psohu.config.hasCd && param1.o.chunkcd != undefined)
            {
                _loc_2 = new Object();
                if (this._wrongo != null)
                {
                    _loc_2.chunkcd = this._wrongo.chunkcd;
                    _loc_2.picecd = this._wrongo.picecd;
                }
                else
                {
                    _loc_2 = this._p2psohu.peer.getTransCDO(param1.chunkidx, param1.lowidx);
                }
                for (_loc_3 in _loc_2)
                {
                    
                    param1.o[_loc_3] = _loc_2[_loc_3];
                }
            }
            this.outgoingStream.send("onRP", param1.ba, param1.fileidx, param1.chunkidx, param1.lowidx, param1.o);
            this._p2psohu.filesManager.addTypePeerSize(param1.o.size, param1.o.peertype);
            this._p2psohu.showTestInfo("供体sendDataToRp: len:fileidx:chunkidx:lowidx: " + param1.ba.length + ":" + param1.fileidx + ":" + param1.chunkidx + ":" + param1.lowidx);
            (param1.ba as ByteArray).clear();
            param1 = null;
            return;
        }// end function

        private function dataForRP(param1:int, param2:int, param3:int, param4:Object) : void
        {
            var _loc_12:Object = null;
            var _loc_13:int = 0;
            if (param4.peertype != undefined && param4.peertype != "flash")
            {
                param1 = this._p2psohu.fileList.getFileidx(param4.hashid);
                _loc_12 = this._p2psohu.fileList.fileoA[param1];
                _loc_13 = _loc_12.first_count + param4.chunkidx;
                if (_loc_13 > _loc_12.end_count)
                {
                    param2 = _loc_12.end_count;
                    param3 = param4.lowidx + ByteSize._CHUNKSIZE / ByteSize.PICESIZE * (_loc_13 - param2);
                }
                else
                {
                    param2 = _loc_13;
                    param3 = param4.lowidx;
                }
            }
            var _loc_5:Boolean = false;
            var _loc_6:* = this._p2psohu.chunksMang.getChunkInfo(param2);
            var _loc_7:* = this._p2psohu.chunksMang.getPiceInfo(param2, param3);
            var _loc_8:* = new ByteArray();
            if (_loc_6.datawrong != 1 && _loc_7 != null && _loc_7.datawrong != 1)
            {
                _loc_8 = _loc_7.ba;
            }
            else
            {
                _loc_5 = true;
            }
            var _loc_9:* = new Object();
            new Object().playtime = this._p2psohu.streamMang.nsTime;
            _loc_9.dfidx = this._p2psohu.chunksMang.fileDLIdx;
            _loc_9.dcidx = this._p2psohu.chunksMang.chunkDLIdx;
            _loc_9.dpidx = this._p2psohu.chunksMang.peerDLIdx;
            _loc_9.iserror = _loc_5;
            _loc_9.filelen = this._p2psohu.fileList.fileoA[param1].size;
            if (this._p2psohu.config.hasCd && param4.chunkcd != undefined)
            {
                this._wrongo = this._p2psohu.peer.checkCDMth(param4);
            }
            _loc_9.farid = this._p2psohu.config.peerID.slice(0, 8);
            _loc_9.isrp = false;
            _loc_9.hashid = param4.hashid;
            _loc_9.peertype = "flash";
            _loc_9.vid = param4.vid;
            _loc_9.chunkidx = param4.chunkidx;
            _loc_9.lowidx = param4.lowidx;
            _loc_9.otstart = param4.otstart;
            var _loc_10:* = new ByteArray();
            if (param4.peertype != undefined && param4.peertype != "flash")
            {
                _loc_10 = this.duplicateByte(_loc_8, param4.otstart, param4.otlen);
                _loc_9.peertype = param4.peertype;
            }
            else
            {
                _loc_10 = this.duplicateByte(_loc_8, 0, _loc_8.length);
            }
            _loc_9.size = _loc_10.length;
            var _loc_11:Object = {ba:_loc_10, fileidx:param1, chunkidx:param2, lowidx:param3, o:_loc_9};
            if (param4.peertype != undefined && param4.peertype != "flash")
            {
                this.sendDataToRp(_loc_11);
            }
            else
            {
                this.sendDataA.push(_loc_11);
            }
            this._p2psohu.showTestInfo("供体 fileidx:" + param1 + " lowidx:" + param3 + " chunkidx:" + param2 + " rpid:" + this.rpeerid.slice(0, 8) + " o.filelen:" + _loc_9.filelen + " databa:" + _loc_8.length);
            return;
        }// end function

        private function duplicateByte(param1:ByteArray, param2:int, param3:int) : ByteArray
        {
            var _loc_4:* = new ByteArray();
            if (param2 + param3 >= param1.length)
            {
                param3 = param1.length - param2;
            }
            _loc_4.writeBytes(param1, param2, param3);
            _loc_4.position = 0;
            return _loc_4;
        }// end function

        public function gc() : void
        {
            if (this._outgoingStream != null)
            {
                this._outgoingStream.removeEventListener(NetStatusEvent.NET_STATUS, this.outFileNSHandler);
                this._outgoingStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorMth);
                this._outgoingStream.close();
                this._outgoingStream = null;
                this._p2psohu.peer.sendPeer.delPeerForLoad(this);
                this.fileinfo = null;
                if (this._delayT.running)
                {
                    this._delayT.stop();
                }
                this._delayT.removeEventListener(TimerEvent.TIMER, this.delaySendData);
            }
            this.clearNs();
            return;
        }// end function

        public function clearNs() : void
        {
            this._p2psohu.peer.sendPeer.delPeerForLoad(this);
            this.rpeerid = null;
            if (this._delayT.running)
            {
                this._delayT.stop();
            }
            if (this._incomingStream == null)
            {
                return;
            }
            this._incomingStream.removeEventListener(NetStatusEvent.NET_STATUS, this.inFileNSHandler);
            this._incomingStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, this.asyncErrorMth);
            this._incomingStream.close();
            this._incomingStream = null;
            return;
        }// end function

        public function get outgoingStream() : HoldNetStream
        {
            return this._outgoingStream;
        }// end function

    }
}
