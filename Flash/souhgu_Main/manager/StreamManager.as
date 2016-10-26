package manager
{
    import control.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import model.*;

    public class StreamManager extends BaseCtrl
    {
        private var _ns:Object;
        private var _peerNs:NetStream;
        private var timer:Timer;
        private var _interval:Number = 1000;
        private var _isfirst:Boolean = true;
        private var _insertFileidx:int = 0;
        private var _isFirstInsertPhoto:Boolean = true;
        private var _profileurl:String;

        public function StreamManager()
        {
            return;
        }// end function

        public function initNetStream(param1) : void
        {
            this._ns = null;
            this._peerNs = null;
            if (this.timer != null)
            {
                this.timer.stop();
                this.timer.removeEventListener(TimerEvent.TIMER, this.checkNsLength);
                this.timer = null;
            }
            this._ns = param1;
            this._peerNs = param1.peerNs;
            this.timer = new Timer(this._interval);
            this.timer.addEventListener(TimerEvent.TIMER, this.checkNsLength);
            return;
        }// end function

        public function getPhotoPolicyFile(param1:String) : void
        {
            this._profileurl = "http://" + (param1.split("/") as Array)[2] + "/crossdomain.xml";
            Security.loadPolicyFile(this._profileurl);
            trace(this._ns);
            trace(this._ns.getVideo());
            return;
        }// end function

        public function pauseTimer() : void
        {
            if (this.timer != null)
            {
                this.timer.stop();
            }
            return;
        }// end function

        public function resumeTimer() : void
        {
            if (this.timer == null)
            {
                return;
            }
            this.timer.start();
            return;
        }// end function

        public function sendStartBeginMsg() : void
        {
            if (this._ns != null && this._isfirst)
            {
                this._isfirst = false;
                this._ns.hasDataMth();
            }
            return;
        }// end function

        public function checkNsLength(event:TimerEvent = null) : void
        {
            this._p2psohu.chunksMang.checkDLChunkA();
            if (event != null)
            {
                if (this._isfirst)
                {
                    this._isfirst = false;
                    if (this._ns != null)
                    {
                        this._ns.hasDataMth();
                    }
                }
            }
            if (this._p2psohu.chunksMang.doSeek)
            {
                this._p2psohu.chunksMang.isinsertNsData = false;
                this._p2psohu.chunksMang.insertDataToNs();
            }
            else if (this.nsUpMemeory)
            {
                this._p2psohu.chunksMang.isinsertNsData = false;
            }
            else
            {
                if (this.nsMemeoryLow)
                {
                    this._p2psohu.chunksMang.isinsertNsData = false;
                }
                if (this._p2psohu.chunksMang.isinsertNsData == false)
                {
                    this._p2psohu.chunksMang.insertDataToNs();
                }
            }
            if (!this._p2psohu.isAllLoadedOver && this._p2psohu.chunksMang.isloading == false && this._p2psohu.getNsType("isLoadingContinue"))
            {
                this._p2psohu.chunksMang.resumeDowloadMth();
            }
            if (!this._p2psohu.isAllLoadedOver)
            {
                this._p2psohu.peer.receivePeer.waitForGetPeerlist();
                this.checkDangerArea();
            }
            return;
        }// end function

        private function checkDangerArea() : void
        {
            if (!this.p2pSohuLib.nsPlayTimerMinMth() && this.isDanger)
            {
                this.p2pSohuLib.showTestInfo("到危险区");
                this.p2pSohuLib.chunksMang.changeToCdn();
            }
            return;
        }// end function

        private function get isDanger() : Boolean
        {
            var _loc_1:Boolean = false;
            if (!this._p2psohu.cdnloader.isCDNRunning)
            {
                _loc_1 = true;
            }
            return _loc_1;
        }// end function

        public function checkNsMemory() : void
        {
            if (this.nsUpMemeory)
            {
                this._p2psohu.chunksMang.isinsertNsData = false;
            }
            return;
        }// end function

        private function get nsUpMemeory() : Boolean
        {
            var _loc_1:* = this._p2psohu.getNsByte(0);
            var _loc_2:* = ByteSize.F1_high * this._p2psohu.config.bufv;
            return _loc_1 > _loc_2 ? (true) : (false);
        }// end function

        private function get nsMemeoryLow() : Boolean
        {
            var _loc_1:* = this._p2psohu.getNsByte(0);
            var _loc_2:* = ByteSize.F1_high * this._p2psohu.config.bufv;
            return _loc_1 - this._p2psohu.chunksMang.getLoadedChunkByte() < _loc_2 ? (true) : (false);
        }// end function

        public function nsAppendBytes(param1:Object) : void
        {
            var _loc_3:Boolean = false;
            var _loc_7:ByteArray = null;
            var _loc_9:ByteArray = null;
            var _loc_10:Object = null;
            var _loc_11:int = 0;
            var _loc_12:ByteArray = null;
            var _loc_13:Object = null;
            var _loc_14:int = 0;
            var _loc_2:* = param1.pice_total != undefined ? (false) : (true);
            var _loc_4:Boolean = false;
            this._insertFileidx = param1.fileidx;
            if (param1.fileidx == 0)
            {
                _loc_3 = _loc_2 ? (param1.dataIdx == 0 && param1.lowidx == 0 ? (true) : (false)) : (param1.dataIdx == 0 ? (true) : (false));
            }
            var _loc_5:* = _loc_2 ? (param1.dataIdx == 0 && param1.lowidx == 0 ? (true) : (false)) : (param1.dataIdx == 0 ? (true) : (false));
            var _loc_6:* = new ByteArray();
            if (!_loc_2)
            {
                if (this._p2psohu.chunksMang.seekOffset != -1)
                {
                    _loc_4 = true;
                    _loc_9 = param1.ba;
                    _loc_10 = this._p2psohu.chunksMang.getChunkInfo(param1.chunkidx);
                    _loc_9.position = this._p2psohu.chunksMang.seekOffset - _loc_10.begin;
                    _loc_9.readBytes(_loc_6, 0, _loc_9.bytesAvailable);
                    _loc_6.position = 0;
                    this._p2psohu.chunksMang.seekOffset = -1;
                    _loc_3 = true;
                    this._p2psohu.setCdnAndCdnGap(2, 1);
                }
                else
                {
                    _loc_11 = 0;
                    while (_loc_11 < param1.pice_total)
                    {
                        
                        _loc_6.writeBytes(param1.pices[_loc_11].ba);
                        _loc_11++;
                    }
                }
            }
            else if (this._p2psohu.chunksMang.seekOffset != -1)
            {
                _loc_4 = true;
                _loc_12 = new ByteArray();
                _loc_12.writeBytes(param1.ba);
                _loc_13 = this._p2psohu.chunksMang.getChunkInfo(param1.chunkidx);
                _loc_12.position = this._p2psohu.chunksMang.seekOffset - _loc_13.begin - ByteSize.PICESIZE * param1.lowidx;
                _loc_12.readBytes(_loc_6, 0, _loc_12.bytesAvailable);
                _loc_6.position = 0;
                this._p2psohu.chunksMang.seekOffset = -1;
                _loc_3 = true;
                this._p2psohu.setCdnAndCdnGap(2, 1);
                this._p2psohu.cdnloader.isloadSeekData = false;
            }
            else
            {
                _loc_6.writeBytes(param1.ba);
            }
            var _loc_8:Number = 0;
            if (param1.fileidx > this._p2psohu.seekFileIdx)
            {
                _loc_8 = _loc_8 - this._p2psohu.seekinoffset;
                _loc_14 = _p2psohu.seekFileIdx + 1;
                while (_loc_14 < param1.fileidx)
                {
                    
                    _loc_8 = _loc_8 - this._p2psohu.fileList.fileoA[_loc_14].duration;
                    _loc_14++;
                }
            }
            else if (param1.fileidx == _p2psohu.seekFileIdx)
            {
                _loc_8 = this._p2psohu.realseek;
            }
            _loc_6.position = 0;
            if (!_loc_4 && (_loc_3 || _loc_5))
            {
                this._p2psohu.mp4convert.closeMth();
                this._p2psohu.mp4convert.openMth();
                if (this._p2psohu.fileList.fileoA[param1.fileidx].header != undefined)
                {
                    this._p2psohu.mp4convert.transferHeader(this._p2psohu.fileList.fileoA[param1.fileidx].header);
                }
            }
            _loc_7 = this._p2psohu.mp4convert.transferData(_loc_6, false, _loc_3, _loc_8 * 1000);
            if (_loc_7.length != 0)
            {
                this._peerNs.appendBytes(_loc_7);
            }
            _loc_7.clear();
            _loc_6.clear();
            this._p2psohu.popInit();
            if (_loc_4)
            {
                this._p2psohu.isSeekInsertByte = true;
            }
            if (param1.chunkidx == (this._p2psohu.chunksMang.chunkTotal - 1))
            {
                if (param1.lowidx == (param1.lowtotal - 1))
                {
                    this.allByteInsertNs();
                }
            }
            return;
        }// end function

        private function allByteInsertNs() : void
        {
            this._p2psohu.showTestInfo("塞入完毕", true);
            this._peerNs.appendBytesAction(NetStreamAppendBytesAction.END_SEQUENCE);
            this.pauseTimer();
            return;
        }// end function

        public function get nsTime() : Number
        {
            if (this._peerNs == null)
            {
                return 0;
            }
            return this._peerNs.time;
        }// end function

        public function get isTimeRunning() : Boolean
        {
            if (this.timer == null)
            {
                return false;
            }
            return this.timer.running;
        }// end function

        public function get peerNs() : NetStream
        {
            return this._peerNs;
        }// end function

        public function cleanMth() : void
        {
            if (this.timer != null)
            {
                this.timer.reset();
            }
            this._isfirst = true;
            this._isFirstInsertPhoto = true;
            return;
        }// end function

        public function get insertFileidx() : int
        {
            return this._insertFileidx;
        }// end function

        public function set insertFileidx(param1:int) : void
        {
            this._insertFileidx = param1;
            return;
        }// end function

        public function get isFirstInsertPhoto() : Boolean
        {
            return this._isFirstInsertPhoto;
        }// end function

    }
}
