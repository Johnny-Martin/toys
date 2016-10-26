package com.sohu.tv.mediaplayer.netstream
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.video.*;
    import ebing.*;
    import ebing.utils.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class PeerNS extends TvSohuNetStream
    {
        private var _fileo:Object;
        private var _isClearData:Boolean = false;
        private var _seekOffset:Number = 0;
        private var _ClearedMemory:Boolean = false;
        public var startT:Number;
        private var _nc:NetConnection;
        private var _netstream:NetStream;
        private var _video:Video = null;
        private var _eventLisnterArray:Array;
        private var _isClose:Boolean = true;
        private var _isPause:Boolean = false;
        private var _cdnUrl:String;
        private var _byteloaded:uint = 0;
        private var _isfirst:Boolean = true;
        private var _isSeek:Boolean = false;
        private var _timeidx:int = 0;
        private var _nowtime:Number;
        private var _seekType:Boolean;
        private var _isfirstSeek:Boolean = true;
        private var _isseekb:Boolean = false;
        private var _seekWaitForUser:Boolean = false;
        private var _hasAD:Boolean = false;
        private var _isfirstPause:Boolean = false;
        private var _isfirstDoplay:Boolean = false;

        public function PeerNS(param1:NetConnection, param2:Boolean = false, param3:Boolean = false, param4:uint = 0)
        {
            this._eventLisnterArray = new Array();
            this._nc = param1;
            super(this._nc, param2, param3);
            _clipNo = param4;
            _is200 = param2;
            return;
        }// end function

        public function init(param1:Object) : void
        {
            this._fileo = param1;
            this._netstream = new NetStream(this._nc);
            this._netstream.checkPolicyFile = true;
            sysInit("start");
            this.bufferTime = 0;
            this._isClose = false;
            return;
        }// end function

        private function onSocketFail() : void
        {
            this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"NetStream.Play.StreamNotFound"}));
            return;
        }// end function

        public function pause1() : void
        {
            this._isPause = true;
            if (!this._isseekb)
            {
                this._netstream.pause();
            }
            return;
        }// end function

        public function resume1() : void
        {
            this._isPause = false;
            if (!this._isseekb)
            {
                this._netstream.resume();
            }
            return;
        }// end function

        public function close1() : void
        {
            this._isClose = true;
            this._isfirst = true;
            this._isSeek = false;
            this._seekWaitForUser = false;
            this._netstream.close();
            P2pSohuLib.getInstance().cleanNS(this._fileo.filename, this._ClearedMemory);
            this._ClearedMemory = false;
            this._isseekb = true;
            this._byteloaded = 0;
            return;
        }// end function

        public function play1(... args) : void
        {
            P2pSohuLib.getInstance().showTestInfo("$$play1");
            this._isPause = false;
            this._isClose = false;
            this._netstream.play(null);
            this._netstream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
            P2pSohuLib.getInstance().downLoadFile();
            return;
        }// end function

        override public function play(... args) : void
        {
            _gslbUrl = args[0];
            if (PlayerConfig.isWebP2p)
            {
                Utils.debug("TvSohuNetStream arguments:" + args[0] + " is200:" + _is200);
                _isPlay = true;
                _gslbUrl = args[0];
                this.doPlay(_gslbUrl);
            }
            else
            {
                super.play(_gslbUrl);
            }
            return;
        }// end function

        override protected function doPlay(param1:String) : void
        {
            P2pSohuLib.getInstance().showTestInfo("$$doplay  url:" + param1 + "  _isseekb:" + this._isseekb);
            if (!this._isfirst)
            {
                _isPlay = true;
                this._isPause = false;
                this._isClose = false;
                return;
            }
            if (this._isfirst)
            {
                this._isfirst = false;
            }
            _isPlay = true;
            _isnp = true;
            _cdnuse = getTimer();
            gotMetaData = false;
            this._cdnUrl = param1;
            var _loc_2:* = /\?start=""\?start=/;
            _isDrag = _loc_2.test(param1) ? (true) : (false);
            if (_isPlay)
            {
                this.play1();
            }
            else
            {
                this.play1();
                this.pause();
            }
            bufferNum = 0;
            if (_isWriteLog)
            {
                LogManager.msg("段号：" + _clipNo + " 最终播放地址：" + this._cdnUrl);
            }
            clearCdnTimeout(false);
            var _loc_3:int = 0;
            if (_hasP2P)
            {
                _loc_3 = _p2pTimeLimit;
            }
            else if (_is200)
            {
                _loc_3 = _cdn200TimeLimit;
            }
            else
            {
                _loc_3 = _cdn301TimeLimit;
            }
            return;
        }// end function

        public function popNoFileInfo() : void
        {
            this.close();
            this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"CDNTimeout"}));
            return;
        }// end function

        override public function pause() : void
        {
            P2pSohuLib.getInstance().showTestInfo("$$pause");
            _isPlay = false;
            this.pause1();
            return;
        }// end function

        override public function resume() : void
        {
            P2pSohuLib.getInstance().showTestInfo("$$resume  _isseekb:" + this._isseekb);
            _isPlay = true;
            this.resume1();
            return;
        }// end function

        override public function close() : void
        {
            if (this._isClose)
            {
                return;
            }
            this.close1();
            super.close();
            return;
        }// end function

        public function changeClarityBegin(param1:Object, param2:Number) : void
        {
            P2pSohuLib.getInstance().showTestInfo("$$changeClarityBegin  offset:" + param2);
            this._fileo = param1;
            return;
        }// end function

        public function changeClarityEnd() : void
        {
            P2pSohuLib.getInstance().showTestInfo("$$changeClarityEnd  ");
            return;
        }// end function

        override public function seek(param1:Number) : void
        {
            if (this._isClose)
            {
                return;
            }
            P2pSohuLib.getInstance().showTestInfo("seek $$$$$$$$$$$   offset:" + param1 + " _isseekb:" + this._isseekb + " _isPlay:" + _isPlay, true);
            this._isseekb = true;
            this._isSeek = true;
            if (!this._isClearData && param1 == 0)
            {
                return;
            }
            this._netstream.pause();
            if (this._isfirst)
            {
                this._isfirst = false;
                this._netstream.play(null);
                this._netstream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
                P2pSohuLib.getInstance().seekMth(param1);
                return;
            }
            P2pSohuLib.getInstance().seekMth(param1);
            return;
        }// end function

        public function seekClearData() : void
        {
            P2pSohuLib.getInstance().showTestInfo("$$seekClearData   _isPlay:" + _isPlay);
            this._netstream.seek(0);
            this._netstream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
            this._netstream.play(null);
            this._isSeek = false;
            this.bufferTime = 10;
            this._netstream.pause();
            return;
        }// end function

        public function seekStartMth() : void
        {
            this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"NoData.Drag.Start"}));
            return;
        }// end function

        public function seekResumeMth() : void
        {
            this._isseekb = false;
            P2pSohuLib.getInstance().showTestInfo("$$seekResumeMth _isseekb:" + this._isseekb + " _isPlay:" + _isPlay);
            if (this._isPlay)
            {
                this._netstream.resume();
            }
            this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"NoData.Drag.End"}));
            this.bufferTime = 3;
            return;
        }// end function

        private function seekend(event:TimerEvent) : void
        {
            this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"NoData.Drag.End"}));
            return;
        }// end function

        private function smallSuppliers() : void
        {
            this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback", reason:"smallSuppliers"}));
            return;
        }// end function

        public function cdnDieMth() : void
        {
            return;
        }// end function

        public function attachVideoToStream(param1:Video) : void
        {
            this._video = param1;
            if (TvSohuVideo.predictMode == TvSohuVideo.STG_VIDEO_MODE)
            {
                var _loc_2:* = param1;
                _loc_2.param1["attachSvdCurStream"](this._netstream);
            }
            else
            {
                param1.attachNetStream(this._netstream);
            }
            return;
        }// end function

        override public function get bytesLoaded() : uint
        {
            var _loc_1:* = P2pSohuLib.getInstance().chunksMang.loadingShowSize;
            return _loc_1;
        }// end function

        public function initPCoreFailMth(param1:String) : void
        {
            this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback.InitFail", reason:param1}));
            return;
        }// end function

        public function initPCoreSucMth() : void
        {
            LogManager.msg("initPCoreSucMth");
            this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"P2pcore.Init.Success"}));
            return;
        }// end function

        public function errorStaticAndRollBack(param1:String, param2:String = null, param3:String = null) : void
        {
            switch(param1)
            {
                case "404":
                {
                    if (param2 == "302")
                    {
                        this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback", reason:"302Error"}));
                    }
                    else if (param2 == "301")
                    {
                        this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback", reason:"301cdnConError", cdnip:param3}));
                    }
                    else
                    {
                        this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"NetStream.Play.StreamNotFound"}));
                    }
                    break;
                }
                case "cdnconfail":
                {
                    this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback", reason:"cdnConError"}));
                    break;
                }
                case "schedulfail":
                {
                    if (param2 == "timeout")
                    {
                        this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"timeout"}));
                    }
                    else if (param2 == "ioerror")
                    {
                        this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"ioerror"}));
                    }
                    else if (param2 == "dataerror")
                    {
                        this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"returnError"}));
                    }
                    else
                    {
                        this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"302Error10Times"}));
                    }
                    break;
                }
                case "schedulsuccess":
                {
                    this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Success"}));
                    break;
                }
                case "rtmfpfail":
                {
                    this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback", reason:"rtmfpError"}));
                    break;
                }
                case "blackscreen":
                {
                    this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback", reason:"blackscreen"}));
                    break;
                }
                case "smallSuppliers":
                {
                    this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback", reason:"smallSuppliers"}));
                    break;
                }
                case "trackfail":
                {
                    this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"Webp2p.Rollback", reason:"trackError"}));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function hasDataMth() : void
        {
            this._netstream.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"NetStream.Play.Start"}));
            return;
        }// end function

        public function fileStatMth(param1:Object) : void
        {
            PlayerConfig.cdnId = param1.cdnid;
            PlayerConfig.cdnIp = param1.cdnip;
            this._netstream.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"NetStream.PQStat.Upload", index:param1.fileidx, cdnip:param1.cdnip, cdnid:param1.cdnid}));
            return;
        }// end function

        override public function get bytesTotal() : uint
        {
            return P2pSohuLib.getInstance().fileList.bytestotal;
        }// end function

        public function get fileo() : Object
        {
            return this._fileo;
        }// end function

        public function get peerNs() : NetStream
        {
            return this._netstream;
        }// end function

        override public function set client(param1:Object) : void
        {
            this._netstream.client = param1;
            return;
        }// end function

        override public function get time() : Number
        {
            if (this._timeidx == 0)
            {
                this._nowtime = P2pSohuLib.getInstance().nsTime();
            }
            else if (this._timeidx % 5 == 0)
            {
                this._timeidx = -1;
            }
            var _loc_1:String = this;
            var _loc_2:* = this._timeidx + 1;
            _loc_1._timeidx = _loc_2;
            return this._nowtime;
        }// end function

        public function get isClose() : Boolean
        {
            return this._isClose;
        }// end function

        public function clearDataMth() : void
        {
            this._ClearedMemory = true;
            return;
        }// end function

        override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            var _loc_6:* = new Object();
            new Object().action = "add";
            _loc_6.type = param1;
            _loc_6.func = param2;
            this._eventLisnterArray.push(_loc_6);
            this._netstream.addEventListener(param1, param2);
            return;
        }// end function

        override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            var _loc_4:* = new Object();
            new Object().action = "remove";
            _loc_4.type = param1;
            _loc_4.func = param2;
            this._eventLisnterArray.push(_loc_4);
            this._netstream.removeEventListener(param1, param2);
            return;
        }// end function

        override public function dispatchEvent(event:Event) : Boolean
        {
            return this._netstream.dispatchEvent(event);
        }// end function

        override public function willTrigger(param1:String) : Boolean
        {
            return this._netstream.willTrigger(param1);
        }// end function

        override public function hasEventListener(param1:String) : Boolean
        {
            return this._netstream.hasEventListener(param1);
        }// end function

        override public function get bufferLength() : Number
        {
            if (this._isSeek)
            {
                return 0;
            }
            return this._netstream.bufferLength;
        }// end function

        override public function get bufferTime() : Number
        {
            return this._netstream.bufferTime;
        }// end function

        override public function set bufferTime(param1:Number) : void
        {
            this._netstream.bufferTime = param1;
            return;
        }// end function

        override public function get soundTransform() : SoundTransform
        {
            return this._netstream.soundTransform;
        }// end function

        override public function set soundTransform(param1:SoundTransform) : void
        {
            this._netstream.soundTransform = param1;
            return;
        }// end function

        public function get duration() : Number
        {
            return P2pSohuLib.getInstance().fileList.timestotal;
        }// end function

        public function getVideo() : Video
        {
            return this._video;
        }// end function

    }
}
