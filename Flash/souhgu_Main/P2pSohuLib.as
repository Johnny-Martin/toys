package 
{
    import com.*;
    import configbag.*;
    import control.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.globalization.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import manager.*;
    import model.*;
    import mp4.*;
    import server.*;
    import test.*;
    import util.*;

    public class P2pSohuLib extends Sprite
    {
        public var getwaySocketVOD:GetWaySocketSohuVOD;
        public var getwaySocket:GetWaySocketSohu;
        public var trackSocket:TrackSocketSohu;
        public var idxServer:IndexServerSohu;
        public var schedulingServer:SchedulingServer;
        public var peer:NewPeer;
        public var cdnloader:CdnLoader;
        public var loaderMang:LoaderManager;
        public var filesManager:FilesManager;
        public var codeManager:CodeManager;
        public var mp4convert:ConvertByte;
        public var config:Config;
        public var fileo:Object;
        private var _isfirst:Boolean = true;
        private var istest:Boolean = false;
        private var logObj:UploadLog;
        private var logstr:String = "";
        private var loginitstr:String = "";
        public var isAllDie:Boolean = false;
        public var liblogA:Array;
        public var oldBuffer:Number = 0;
        private var isfirstseek:Boolean = true;
        private var _isGetwayInitFail:Boolean = false;
        private var _isSetStart:Boolean = false;
        private var _isReLogin:Boolean = true;
        public var ns:Object;
        public var peerNs:NetStream;
        public var fileList:FileList;
        public var chunksMang:ChunksManager;
        public var streamMang:StreamManager;
        public var oldDataMang:OldDataManager;
        public var isAllLoadedOver:Boolean = false;
        public var isrefercdnNoDL:Boolean = false;
        private var _isSeek:Boolean = false;
        private var _seekoffset:Number = 0;
        public var realseek:Number = 0;
        public var isSeekInsertByte:Boolean = false;
        public var seekFileIdx:int = -1;
        public var seekinoffset:Number = 0;
        public var seekoutoffset:Number = 0;
        private var hasnodata:Boolean = false;
        private var hasnodata_startt:Number;
        private var num:int = 0;
        public var crcCtrl:CrcCtrl;
        private var _dieType:String;
        private var _seektime:Number = 0;
        private var _lognum:int = -1;
        private var initT:Timer;
        private var _initB:int;
        private var logCB:Function;
        private var _initFailInfo:String;
        private var oldtime:Number = 0;
        private static var _instance:P2pSohuLib;

        public function P2pSohuLib()
        {
            this.fileo = new Object();
            this.logObj = new UploadLog();
            this.liblogA = new Array();
            this.initT = new Timer(25000);
            return;
        }// end function

        public function init(param1:Function, param2:String, param3:String, param4:Array, param5:String, param6:String, param7:String, param8:String) : void
        {
            var _loc_9:Array = null;
            Config.getInstance().initT = getTimer();
            this.logCB = param1;
            if (Config.getInstance().isLog)
            {
                this.showTestInfo("日志打开", true);
            }
            else
            {
                this.showTestInfo("日志关闭", false);
            }
            this.showTestInfo("lib init version:" + Config.getInstance().version + " comversion:" + Config.getInstance().COMVERSION);
            if (this.oldDataMang != null)
            {
                this.oldDataMang.saveData();
            }
            else
            {
                this.oldDataMang = new OldDataManager();
                this.oldDataMang.p2pSohuLib = this;
            }
            this.isAllDie = false;
            this._isfirst = true;
            this.oldtime = 0;
            this._dieType = null;
            Config.getInstance().isRtmfpDie = false;
            Security.allowDomain("*");
            this.config = Config.getInstance();
            this.peer = new NewPeer();
            this.peer.p2pSohuLib = this;
            this.peer.peerMth();
            this.cdnloader = new CdnLoader();
            this.cdnloader.p2pSohuLib = this;
            this.cdnloader.init();
            this.filesManager = new FilesManager();
            this.filesManager.p2pSohuLib = this;
            this.filesManager.init();
            this.codeManager = new CodeManager();
            this.codeManager.p2pSohuLib = this;
            this.idxServer = new IndexServerSohu();
            this.idxServer.p2pSohuLib = this;
            this.idxServer.init();
            this.schedulingServer = new SchedulingServer();
            this.schedulingServer.p2pSohuLib = this;
            this.schedulingServer.init();
            this.fileList = new FileList();
            this.fileList.p2pSohuLib = this;
            this.chunksMang = new ChunksManager();
            this.chunksMang.p2pSohuLib = this;
            this.streamMang = new StreamManager();
            this.streamMang.p2pSohuLib = this;
            Config.getInstance().clarity = param2;
            ByteSize.setLineNum(param2);
            if (Config.getInstance().isP2pLive)
            {
            }
            else
            {
                Config.getInstance().vid = param5;
                Config.getInstance().pid = param3;
                Config.getInstance().uid = param6;
                Config.getInstance().ta = param7;
                Config.getInstance().cdnparam = param8;
                if (param4 != null)
                {
                    _loc_9 = ["220.181.61.229", "123.125.123.80", "220.181.61.212", "123.125.123.81", "220.181.61.213", "123.125.123.82"];
                    _loc_9.splice(0, 0, param4[0]);
                    Config.getInstance().schedulIPList = _loc_9;
                    if (param4[0] == "")
                    {
                        Config.getInstance().is301 = true;
                    }
                    else
                    {
                        Config.getInstance().is301 = false;
                    }
                }
            }
            if (Config.getInstance().isversiontest)
            {
                ByteSize.setISSOHUTEST(Config.getInstance().issohutest, Config.getInstance().islow);
            }
            this.mp4convert = new ConvertByte();
            this.mp4convert.metadataF = this.onHeaderMth;
            this.crcCtrl = new CrcCtrl();
            this.crcCtrl.p2pSohuLib = this;
            this.loaderMang = new LoaderManager();
            this.loaderMang.p2pSohuLib = this;
            this.loaderMang.init();
            this.initT = new Timer(ByteSize.BLACKTIME, 1);
            this.initT.addEventListener(TimerEvent.TIMER, this.initMth);
            if (!Config.getInstance().isplayinit)
            {
                this.initCoreMth();
            }
            return;
        }// end function

        public function initCoreMth() : void
        {
            this._initB = getTimer();
            this.initT.start();
            this.getwayInit();
            return;
        }// end function

        public function getwayInit() : void
        {
            this.getwaySocket = new GetWaySocketSohu();
            this.getwaySocket.p2pSohuLib = this;
            this.getwaySocket.init();
            this.getwaySocket.socketInit();
            return;
        }// end function

        public function delayInitT(param1:Number) : void
        {
            this.initT.delay = this.initT.delay + param1;
            return;
        }// end function

        private function initMth(event:TimerEvent = null) : void
        {
            this.initFailMth();
            this.cleanMth();
            return;
        }// end function

        public function initFailMth() : void
        {
            this.showTestInfo("lib init fail  dur:" + (getTimer() - this._initB), true);
            if (this.initT.running)
            {
                this.initT.stop();
                this.initT.removeEventListener(TimerEvent.TIMER, this.initMth);
            }
            this._isGetwayInitFail = true;
            if (Config.getInstance().isplayinit)
            {
                this.ns.initPCoreFailMth(this._initFailInfo);
            }
            this.showFailLog();
            return;
        }// end function

        private function showFailLog() : void
        {
            var _loc_2:String = null;
            var _loc_1:* = new Array();
            if (this._initFailInfo == null)
            {
                _loc_1[0] = "8";
            }
            else
            {
                _loc_1 = this._initFailInfo.split(";");
            }
            switch(_loc_1[0])
            {
                case "0":
                {
                    _loc_2 = "gcf";
                    break;
                }
                case "1":
                {
                    _loc_2 = "gio";
                    break;
                }
                case "2":
                {
                    _loc_2 = "gse";
                    break;
                }
                case "3":
                {
                    _loc_2 = "rfr";
                    break;
                }
                case "4":
                {
                    _loc_2 = "tcf";
                    break;
                }
                case "5":
                {
                    _loc_2 = "tio";
                    break;
                }
                case "6":
                {
                    _loc_2 = "tse";
                    break;
                }
                case "7":
                {
                    _loc_2 = "tlf";
                    break;
                }
                default:
                {
                    _loc_2 = "inf";
                    break;
                    break;
                }
            }
            if (Config.getInstance().isLog && Config.getInstance().pid == Config.getInstance().testpid)
            {
                if (Config.getInstance().isfirstlog)
                {
                    Config.getInstance().logname = Config.getInstance().fname + "OSF" + _loc_2 + (DebugServer.createUID() as String).slice(0, 7) + "_" + this.filesManager.staticO.c + "_" + this.filesManager.staticO.p;
                    Config.getInstance().isfirstlog = false;
                    this.loginitstr = this.loginitstr + (" uid:" + Config.getInstance().uid);
                }
                this.logObj.pushLogString(Config.getInstance().logname + ".txt", this.loginitstr + "\n" + _loc_1[1]);
            }
            this.loginitstr = "";
            return;
        }// end function

        public function trackUrlOKMth() : void
        {
            if (this.trackSocket != null && this.trackSocket.socket != null && this.trackSocket.socket.connected)
            {
                this.showTestInfo("trackUrlOKMth  trackSocket.socket.connected:" + this.trackSocket.socket.connected);
                this.loginPeerMth();
                return;
            }
            var _loc_1:* = GetWayMsg._instance.proxykey;
            var _loc_2:* = _loc_1.indexOf(":");
            var _loc_3:* = _loc_1.substring(0, _loc_2);
            var _loc_4:* = Number(_loc_1.substring((_loc_2 + 1), _loc_1.length));
            if (this.trackSocket == null)
            {
                this.trackSocket = new TrackSocketSohu();
                this.trackSocket.p2pSohuLib = this;
            }
            this.trackSocket.socketInit(_loc_3, _loc_4);
            return;
        }// end function

        public function rtmfpServerOKMth() : void
        {
            if (this.peer.mainRtmfpUrl == null || !this.peer.mainNC.connected)
            {
                this.peer.isfirst = true;
                this.registPeerMth();
            }
            else if (this.peer.mainNC.connected)
            {
                if (this.trackSocket != null && this.trackSocket.socket != null && this.trackSocket.socket.connected)
                {
                    this.showTestInfo("rtmfpServerOKMth  trackSocket.socket.connected:" + this.trackSocket.socket.connected);
                    this.loginPeerMth();
                }
                else
                {
                    this.trackUrlOKMth();
                }
            }
            return;
        }// end function

        public function registPeerMth() : void
        {
            var _loc_1:int = 0;
            if (!Config.getInstance().isAdobeRtmfp)
            {
                Config.getInstance().rtmfpUrl = GetWayMsg._instance.rtmfpUrl;
            }
            if (this.istest)
            {
                _loc_1 = this.idxServer.randRange(0, 2);
                switch(_loc_1)
                {
                    case 0:
                    {
                        Config.getInstance().rtmfpUrl = "rtmfp://61.135.176.223:80";
                        break;
                    }
                    case 1:
                    {
                        Config.getInstance().rtmfpUrl = "rtmfp://61.135.176.225:80";
                        break;
                    }
                    case 2:
                    {
                        Config.getInstance().rtmfpUrl = "rtmfp://61.135.176.219:80";
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            this.peer.registerRtmfpMth(Config.getInstance().rtmfpUrl);
            return;
        }// end function

        public function loginPeerMth() : void
        {
            Config.getInstance().peerID = this.peer.mainPeer;
            this.trackSocket.sendMsgMth("login");
            return;
        }// end function

        public function loginOKMth(param1:uint) : void
        {
            Config.getInstance().p2pID = param1;
            this.showTestInfo("p2pid:" + param1, true);
            if (this.initT.running)
            {
                this.initT.stop();
                this.initT.removeEventListener(TimerEvent.TIMER, this.initMth);
                this.loginitstr = "";
            }
            var _loc_2:* = getTimer() - Config.getInstance().initT;
            this.showTestInfo("loginOKMth: _isfirst:" + this._isfirst + " isRtmfpDie:" + Config.getInstance().isRtmfpDie + " vid:" + Config.getInstance().vid + " _dieType:" + this._dieType + " dur:" + _loc_2, true);
            this.showTestInfo("GetWayMsg  back  sp:" + GetWayMsg._instance.sp + " province:" + GetWayMsg._instance.province + " city:" + GetWayMsg._instance.city);
            this.initFailInfo = "";
            DebugServer.sendMsg("LOGIN", this._isfirst ? ("1") : ("0"));
            if (this._isfirst == false)
            {
                if (this._dieType == null)
                {
                    return;
                }
                if (this._dieType.search("tracker") != -1 || this._dieType.search("rtmfp") != -1)
                {
                    this.filesManager.reviewAddInfo();
                }
                this._isReLogin = true;
                Config.getInstance().isRtmfpDie = false;
                if (this.peer.receivePeer.peerldmang.spnum == 0 && this.peer.receivePeer.peerldmang.connum == 0)
                {
                    this.getPeerListMth();
                }
                else
                {
                    this.peer.receivePeer.loadFromPeer();
                }
            }
            else if (Config.getInstance().isplayinit)
            {
                this.ns.initPCoreSucMth();
                if (this._seekoffset != 0)
                {
                    this.seekMth(this._seekoffset);
                }
                else
                {
                    this.loadDataToNs();
                }
            }
            return;
        }// end function

        public function trackConnectMth() : Boolean
        {
            if (Config.getInstance().p2pID == -1)
            {
                return false;
            }
            return true;
        }// end function

        public function showTestInfo(param1:String, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_7:String = null;
            var _loc_4:String = "MM-dd HH:mm:ss";
            var _loc_5:* = new DateTimeFormatter("en-US");
            new DateTimeFormatter("en-US").setDateTimePattern(_loc_4);
            var _loc_6:* = _loc_5.format(new Date());
            if (this.peer != null && this.peer.mainPeer != null)
            {
                _loc_7 = _loc_6 + "--" + this.peer.mainPeer.slice(0, 8) + ":" + param1;
            }
            else
            {
                _loc_7 = _loc_6 + "--" + param1;
            }
            trace(_loc_7);
            if (Config.getInstance().isLog && Config.getInstance().hasIELog)
            {
                ExternalInterface.call("console.log", _loc_7);
            }
            if (this.peer != null && this.peer.mainPeer != null)
            {
                this.logstr = this.logstr + (_loc_6 + "--" + this.peer.mainPeer.slice(0, 8) + ":" + param1 + "\n");
                trace(Config.getInstance().vid + ":" + Config.getInstance().pid);
                if (Config.getInstance().isLog && Config.getInstance().pid == Config.getInstance().testpid)
                {
                    if (Config.getInstance().isfirstlog)
                    {
                        Config.getInstance().logname = Config.getInstance().fname + "OSSUC" + this.peer.mainPeer.slice(0, 8) + "_" + this.filesManager.staticO.c + "_" + this.filesManager.staticO.p;
                        Config.getInstance().isfirstlog = false;
                        this.logstr = this.logstr + (_loc_6 + "--" + this.peer.mainPeer.slice(0, 8) + ":" + " vid:" + Config.getInstance().vid + " uid:" + Config.getInstance().uid + "\n");
                    }
                    this.logObj.pushLogString(Config.getInstance().logname + ".txt", this.logstr);
                }
                if (this._lognum != 0)
                {
                    this.logstr = "";
                }
            }
            else
            {
                this.loginitstr = this.loginitstr + (_loc_6 + "--:" + param1 + "\n");
            }
            if (param2 && this.logCB != null)
            {
                this.logCB(param1);
            }
            return;
        }// end function

        public function sendSeekLog() : void
        {
            if (this._lognum == 0)
            {
                this.logObj.pushLogString(this.peer.mainPeer + ".txt", this.logstr);
            }
            this._lognum = 1;
            this.logstr = "";
            return;
        }// end function

        public function sendToError(param1:String) : void
        {
            if (param1 == null)
            {
                this.logObj.pushLogString(this.peer.mainPeer.slice(0, 8) + ".txt", this.logstr);
            }
            else
            {
                this.logObj.pushLogString(this.peer.mainPeer.slice(0, 8) + ".txt", param1);
            }
            return;
        }// end function

        public function referFileInfo(param1:Object, param2:Boolean) : void
        {
            var _loc_3:Array = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            if (this.isAllDie)
            {
                return;
            }
            this.cdnloader.referFileClearBadCdn();
            this.fileo = param1;
            Config.getInstance().bufv = param1.byteRate;
            Config.getInstance().f1 = Math.max(ByteSize.F1_low, Math.min(ByteSize.F1_high, ByteSize.F1_low + (getTimer() - this._seektime) / (1000 * ByteSize.FSec))) * Config.getInstance().bufv;
            Config.getInstance().f2 = Math.max(ByteSize.F2_low, Math.min(ByteSize.F2_high, ByteSize.F2_low + (getTimer() - this._seektime) / (1000 * ByteSize.FSec))) * Config.getInstance().bufv;
            this.chunksMang.fileDLIdx = this.fileo.fileidx;
            Config.getInstance().chunkGap = Math.max(3, Math.ceil(60 * Config.getInstance().bufv / ByteSize.CHUNKSIZE)) * 2;
            if (param2)
            {
                if (Config.getInstance().is301)
                {
                    _loc_3 = new Array();
                    _loc_4 = new Object();
                    _loc_4.url = "http://" + this.fileo.clipsurl;
                    _loc_5 = this.parseIpAndPort(this.fileo.clipsurl);
                    _loc_4.ip = _loc_5.ip;
                    _loc_4.port = _loc_5.port;
                    _loc_4.nid = "";
                    _loc_3.push(_loc_4);
                    this.loaderMang.schedulingServerBack(_loc_3, false);
                    _loc_6 = new Object();
                    _loc_6.fileidx = this.fileo.fileidx;
                    _loc_6.cdnid = _loc_4.nid;
                    _loc_6.cdnip = _loc_4.ip;
                    this.fileStatMth(_loc_6);
                }
                else
                {
                    this.schedulingServer.loadURL(param1.cdnfilename, false);
                }
            }
            return;
        }// end function

        private function parseIpAndPort(param1:String) : Object
        {
            var _loc_5:Array = null;
            var _loc_2:* = param1.split("/");
            var _loc_3:* = new Object();
            var _loc_4:* = _loc_2[0];
            if (_loc_2[0].indexOf(":") != -1)
            {
                _loc_5 = _loc_4.split(":");
                _loc_3.ip = _loc_5[0];
                _loc_3.port = _loc_5[1];
            }
            else
            {
                _loc_3.ip = _loc_4;
                _loc_3.port = "80";
            }
            return _loc_3;
        }// end function

        public function seekMth(param1:Number, param2:Boolean = false) : void
        {
            var _loc_5:Object = null;
            if (this._isfirst && Config.getInstance().isplayinit && Config.getInstance().p2pID == -1)
            {
                this._seekoffset = param1;
                this.initCoreMth();
                return;
            }
            this.firstLibDo();
            if (!param2)
            {
                this._seektime = getTimer();
                this._isSeek = true;
                this.cleanPreMth(true);
                this.setCdnAndCdnGap(1, 0);
                this._seekoffset = param1;
                _loc_5 = this.fileList.getSeekFile(param1);
                if (this.fileo != null)
                {
                    this.showTestInfo("seekMth    nfile.header:" + (_loc_5.header == undefined ? (null) : (true)) + " old_fileidx:" + this.fileo.fileidx + " new_fileidx:" + _loc_5.fileidx + " isAllDie:" + this.isAllDie + " offset:" + param1 + " seektime:" + _loc_5.seektime);
                }
                this.nsPlayTimerMinMth();
                this.seekFileIdx = _loc_5.fileidx;
                this.chunksMang.isStopSeek = true;
                this.chunksMang.chunkDLIdx = this.fileList.fileoA[_loc_5.fileidx].first_count;
                this.chunksMang.peerDLIdx = 0;
                this.chunksMang.streamInIdx = this.chunksMang.chunkDLIdx;
                this.chunksMang.peerInsertIdx = 0;
                this.chunksMang.npidx = CountIdx.saveIdxAsByte(_loc_5.fileidx, this.chunksMang.chunkDLIdx, 0);
                this.chunksMang.innpidx = CountIdx.saveIdxAsByte(_loc_5.fileidx, this.chunksMang.streamInIdx, 0);
                this.referFileInfo(_loc_5, true);
                return;
            }
            this.chunksMang.isStopSeek = false;
            this.showTestInfo("seek filename:" + this.fileo.filename + " fileidx:" + this.fileo.fileidx + " offset:" + param1 + " seektime:" + this.fileo.seektime + " header:" + (this.fileo.header != undefined ? (this.fileo.header.length) : (null)));
            var _loc_3:* = this.mp4convert.seekMth(this.fileo.seektime * 1000);
            if (_loc_3 == null)
            {
                _loc_3 = new Object();
                _loc_3.time = 0;
                _loc_3.fileoffset = 0;
            }
            this.realseek = _loc_3.time / 1000;
            this.seekinoffset = this.fileo.duration - this.realseek;
            var _loc_4:int = 0;
            while (_loc_4 < this.seekFileIdx)
            {
                
                this.seekoutoffset = this.seekoutoffset + this.fileList.fileoA[_loc_4].duration;
                _loc_4++;
            }
            this.seekoutoffset = this.seekoutoffset + (this.realseek + 1);
            this.showTestInfo("seek操作  fileoffset:" + _loc_3.fileoffset + " realseek:" + this.realseek + " _seekoffset:" + this._seekoffset + " fileo.duration :" + this.fileo.duration + " seekoutoffset:" + this.seekoutoffset + " seekinoffset:" + this.seekinoffset + " seekfileidx:" + this.seekFileIdx);
            this.nsPlayTimerMinMth();
            this.setCdnAndCdnGap(1, 1);
            this.chunksMang.seekMth(_loc_3.fileoffset, this.fileo.fileidx);
            return;
        }// end function

        public function downLoadFile() : void
        {
            if (!Config.getInstance().isplayinit)
            {
                this.loadDataToNs();
            }
            else if (this._isfirst)
            {
                this.initCoreMth();
            }
            return;
        }// end function

        private function loadDataToNs() : void
        {
            this.firstLibDo();
            this.downloadNewFileMth();
            return;
        }// end function

        private function firstLibDo() : void
        {
            if (this._isfirst)
            {
                this._isfirst = false;
                this.mp4convert.closeMth();
                this.mp4convert.openMth();
                if (!this.streamMang.isTimeRunning)
                {
                    this.streamMang.resumeTimer();
                }
                this.isAllLoadedOver = false;
                this.showTestInfo("firstLibDo  send play begin**********");
                this.streamMang.sendStartBeginMsg();
                if (Config.getInstance().hasnatCheck)
                {
                    this.peer.checkNatMth();
                }
            }
            return;
        }// end function

        public function onHeaderMth(param1:ByteArray, param2:Number) : void
        {
            if (this.fileList.fileoA[this.streamMang.insertFileidx].header != undefined)
            {
                return;
            }
            var _loc_3:* = new ByteArray();
            _loc_3.writeBytes(param1);
            this.fileList.fileoA[this.streamMang.insertFileidx].header = _loc_3;
            this.fileList.fileoA[this.streamMang.insertFileidx].duration = param2;
            this.showTestInfo("onHeaderMth:  insertfileidx:" + this.streamMang.insertFileidx + " dlfileidx:" + this.fileo.fileidx + " dur:" + param2 + " nba:" + _loc_3.length);
            return;
        }// end function

        private function downloadNewFileMth() : void
        {
            this._seektime = getTimer();
            this.setCdnAndCdnGap(1, 2);
            Config.getInstance().isRP = false;
            this.chunksMang.npidx = CountIdx.saveIdxAsByte(0, 0, 0);
            this.chunksMang.innpidx = CountIdx.saveIdxAsByte(0, 0, 0);
            this.referFileInfo(this.fileList.fileoA[0], true);
            this.getPeerListMth();
            return;
        }// end function

        public function fileStatMth(param1:Object) : void
        {
            if (this.fileList.getFileStat(param1.fileidx) == false)
            {
                this.fileList.setFileStat(param1.fileidx);
                this.ns.fileStatMth(param1);
            }
            return;
        }// end function

        public function setCdnAndCdnGap(param1:int, param2:int) : void
        {
            this.cdnloader.cdnldmang.cdnloadNum = 1;
            if (param2 == 1)
            {
                Config.getInstance().piceGap = int(ByteSize.CNDDLSIZE1 / ByteSize.PICESIZE);
            }
            else if (param2 == 2)
            {
                Config.getInstance().piceGap = int(ByteSize.CNDDLSIZE2 / ByteSize.PICESIZE);
            }
            else
            {
                Config.getInstance().piceGap = 2;
            }
            return;
        }// end function

        private function getStart(param1:String) : String
        {
            var _loc_2:* = param1.search("start");
            return param1.slice(_loc_2 + 6);
        }// end function

        public function continueSeek() : void
        {
            if (this._isSeek)
            {
                this._isSeek = false;
                this.seekMth(this._seekoffset, true);
            }
            return;
        }// end function

        public function getPeerListMth() : void
        {
            if (this.isAllDie)
            {
                return;
            }
            this.trackSocket.sendMsgMth("getpeerlist", this.fileo.filename + this.chunksMang.dataIdx);
            return;
        }// end function

        public function nsPlayTimerMinMth(param1:Boolean = false) : Boolean
        {
            if (Config.getInstance().ispurecdn)
            {
                Config.getInstance().isRP = false;
                return false;
            }
            if (Config.getInstance().isPureRp)
            {
                Config.getInstance().isRP = true;
                return true;
            }
            var _loc_2:* = this.peerNs.info;
            var _loc_3:* = this.chunksMang.getLoadedChunkByte();
            var _loc_4:* = this.getNsByte(_loc_3);
            Config.getInstance().f1 = Math.max(ByteSize.F1_low, Math.min(ByteSize.F1_high, ByteSize.F1_low + (getTimer() - this._seektime) / (ByteSize.FSec * 1000))) * Config.getInstance().bufv;
            Config.getInstance().f2 = Math.max(ByteSize.F2_low, Math.min(ByteSize.F2_high, ByteSize.F2_low + (getTimer() - this._seektime) / (1000 * ByteSize.FSec))) * Config.getInstance().bufv;
            Config.getInstance().curBuf = _loc_4;
            Config.getInstance().dniBuf = _loc_3;
            _loc_2 = null;
            var _loc_5:* = _loc_4 > Config.getInstance().f1 ? (true) : (false);
            if (!(_loc_4 > Config.getInstance().f1 ? (true) : (false)) && _loc_3 != 0)
            {
            }
            return _loc_5;
        }// end function

        public function nsPlayTimerMaxMth() : Boolean
        {
            if (Config.getInstance().ispurecdn)
            {
                Config.getInstance().isRP = false;
                return false;
            }
            if (Config.getInstance().isPureRp)
            {
                Config.getInstance().isRP = true;
                return true;
            }
            var _loc_1:* = this.peerNs.info;
            var _loc_2:* = this.chunksMang.getLoadedChunkByte();
            var _loc_3:* = this.getNsByte(_loc_2);
            Config.getInstance().f1 = Math.max(ByteSize.F1_low, Math.min(ByteSize.F1_high, ByteSize.F1_low + (getTimer() - this._seektime) / (1000 * ByteSize.FSec))) * Config.getInstance().bufv;
            Config.getInstance().f2 = Math.max(ByteSize.F2_low, Math.min(ByteSize.F2_high, ByteSize.F2_low + (getTimer() - this._seektime) / (1000 * ByteSize.FSec))) * Config.getInstance().bufv;
            Config.getInstance().curBuf = _loc_3;
            Config.getInstance().dniBuf = _loc_2;
            this.showTestInfo("nsPlayTimerMaxMth:  nowt:" + _loc_3 + " f1:" + Config.getInstance().f1 + " f2:" + Config.getInstance().f2 + "  bufv:" + Config.getInstance().bufv + " filetime:" + Config.getInstance().filetime + " chunkGap:" + Config.getInstance().chunkGap + " avg_cdnConnectDelayNum:" + Config.getInstance().avg_cdnConnectDelayNum + " avg_cdnDatatime:" + Config.getInstance().avg_cdnDatatime + " avg_cdnDataV:" + Config.getInstance().avg_cdnDataV + " avg_schConNum:" + Config.getInstance().avg_schConNum + " avg_schDataNum:" + Config.getInstance().avg_schDataNum + " insertNumT:" + Config.getInstance().insertNumT + " ispurecdn:" + Config.getInstance().ispurecdn + " avg_peerConnectDelayNum:" + Config.getInstance().avg_peerConnectDelayNum + " avg_peerDatatime:" + Config.getInstance().avg_peerDatatime + " avg_peerDataV:" + Config.getInstance().avg_peerDataV + ":" + this.config.avg_peerDataV + " piceGap:" + Config.getInstance().piceGap + " download_not_in:" + _loc_2 + " streamidx:" + this.chunksMang.streamInIdx + " chunkdlidx:" + this.chunksMang.chunkDLIdx + " peerinsertidx:" + this.chunksMang.peerInsertIdx + " peerdlidx:" + this.chunksMang.peerDLIdx + " clarity:" + Config.getInstance().clarity + " staticO.p:" + this.filesManager.staticO.p + " staticO.c:" + this.filesManager.staticO.c + " audioBufferByteLength:" + _loc_1.audioBufferByteLength + " videoBufferByteLength:" + _loc_1.videoBufferByteLength);
            _loc_1 = null;
            return _loc_3 > Config.getInstance().f2 ? (true) : (false);
        }// end function

        public function reviewIndex() : void
        {
            Config.getInstance().stopFilename = "";
            return;
        }// end function

        public function indexServerBack(param1:String) : void
        {
            return;
        }// end function

        public function addFileData(param1:Array) : void
        {
            this.showTestInfo("addFileData");
            Config.getInstance().bufv = param1[0].byteRate;
            this.peer.receivePeer.peerldmang.initMax();
            this.fileList.saveFileDataMth(param1);
            if (Config.getInstance().isCrc)
            {
                this.crcCtrl.beginDownloadCrc();
            }
            return;
        }// end function

        public function referPeerNs(param1) : void
        {
            this.showTestInfo("referPeerNs");
            this.ns = null;
            this.peerNs = null;
            this.ns = param1;
            this.peerNs = param1.peerNs;
            this.streamMang.initNetStream(param1);
            return;
        }// end function

        public function allFileoLoadedOver() : void
        {
            this.isAllLoadedOver = true;
            this.showTestInfo("下载完毕，不用下载了", true);
            this.cdnloader.clearMth();
            this.peer.receivePeer.clearMth();
            return;
        }// end function

        public function cleanNS(param1:String, param2:Boolean = false, param3:Object = null) : void
        {
            this.showTestInfo("cleanNS:");
            this.isAllLoadedOver = true;
            this._isfirst = true;
            this.cleanPreMth(true);
            this.isAllLoadedOver = true;
            this.streamMang.cleanMth();
            this._isSeek = false;
            this.chunksMang.cleanMth();
            return;
        }// end function

        public function fileLoadedOver(param1:Boolean) : void
        {
            return;
        }// end function

        public function p2pLoadFile() : void
        {
            return;
        }// end function

        public function serverDieMth(param1:String) : void
        {
            this.showTestInfo("all server die所有server都死啦！  重启getway:" + param1 + " isAllDie:" + this.isAllDie, true);
            if (this.isAllDie)
            {
                return;
            }
            this._dieType = param1;
            this.libInit(true);
            this.getwaySocket.restartGetWay(param1);
            return;
        }// end function

        private function cleanPreMth(param1:Boolean) : void
        {
            if (this.trackSocket == null)
            {
                return;
            }
            this.showTestInfo("cleanPreMth  iscleardataidx:" + param1);
            this.schedulingServer.cleanPreMth();
            this.trackSocket.cleanPreMth();
            if (param1)
            {
                this.cdnloader.clearMth();
                this.isAllLoadedOver = false;
                this.chunksMang.cleanPreMth();
                if (this._isSeek)
                {
                    this.peer.receivePeer.seekStopLoadMth();
                }
                else
                {
                    this.peer.receivePeer.clearMth();
                }
                this._seekoffset = 0;
                this.realseek = 0;
                this.seekinoffset = 0;
                this.seekoutoffset = 0;
                this.isSeekInsertByte = false;
                this.seekFileIdx = -1;
                this.streamMang.pauseTimer();
                Config.getInstance().isRP = false;
                this.isrefercdnNoDL = false;
                this.mp4convert.closeMth();
                this.mp4convert.openMth();
                this.popInit();
                this.cdnloader.seekInit();
                this.schedulingServer.seekInit();
                this.peer.seekInit();
            }
            this._isSetStart = false;
            return;
        }// end function

        public function get nowF2() : Number
        {
            Config.getInstance().f2 = Math.max(ByteSize.F2_low, Math.min(ByteSize.F2_high, ByteSize.F2_low + (getTimer() - this._seektime) / (1000 * ByteSize.FSec))) * Config.getInstance().bufv;
            return Config.getInstance().f2;
        }// end function

        public function get dlFileidx() : int
        {
            return this.chunksMang.fileDLIdx;
        }// end function

        public function get insertFileidx() : int
        {
            return this.chunksMang.insertFileidx;
        }// end function

        public function cleanMth(param1:Boolean = true) : void
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            if (this.initT.running)
            {
                this.initT.stop();
                this.initT.removeEventListener(TimerEvent.TIMER, this.initMth);
            }
            this.showTestInfo("clean lib");
            this.isAllDie = true;
            this._dieType = null;
            this.libInit(false);
            this.fileo = null;
            if (param1 == false)
            {
                _loc_2 = Guid.create();
                _loc_3 = _loc_2.substring(0, 38) + Config.getInstance().initErrorType;
                this.logObj.pushLogString(_loc_3 + ".txt", this.logstr);
            }
            else
            {
                Config.getInstance().p2pID = -1;
            }
            return;
        }// end function

        public function showlog(param1:String) : void
        {
            return;
        }// end function

        public function get curT() : String
        {
            var _loc_1:String = "HH:mm:ss";
            var _loc_2:* = new DateTimeFormatter("en-US");
            _loc_2.setDateTimePattern(_loc_1);
            var _loc_3:* = _loc_2.format(new Date());
            return _loc_3;
        }// end function

        public function gc() : void
        {
            return;
        }// end function

        private function libInit(param1:Boolean) : void
        {
            if (this.streamMang == null || this.getwaySocket == null)
            {
                return;
            }
            this.showTestInfo("libInit  isRestartTrack:" + param1 + " _dieType:" + this._dieType);
            if (!param1)
            {
                if (this.peer != null)
                {
                    this.peer.closePeer();
                    this.peer.clearMth();
                }
                Config.getInstance().isRtmfpDie = false;
                this.streamMang.cleanMth();
                this.chunksMang.cleanMth();
                this.fileList.cleanMth();
                this.cdnloader.clearMth();
                this.schedulingServer.serverGC();
                this.getwaySocket.socketGC(true);
            }
            if (!this.getwaySocket.getwayConType())
            {
                this.getwaySocket.socketGC();
            }
            if (this._dieType == null || this._dieType.search("tracker") != -1 || this._dieType.search("rtmfp") != -1)
            {
                this.filesManager.reloginDelInfo();
            }
            Config.getInstance().clearMth();
            if (this.trackSocket != null)
            {
                this.trackSocket.socketGC(true);
            }
            this._isReLogin = false;
            return;
        }// end function

        public function errorMth() : void
        {
            this.showTestInfo("errormth  回滚不了啦");
            this.ns.onSocketFail();
            return;
        }// end function

        public function dieDataInfo() : int
        {
            var _loc_1:int = 0;
            if (Config.getInstance().isRP)
            {
                _loc_1 = 1;
            }
            else
            {
                _loc_1 = 2;
            }
            return _loc_1;
        }// end function

        public function sendBufEmpStat() : void
        {
            if (this.trackSocket == null || this.isAllLoadedOver)
            {
                return;
            }
            this.showTestInfo("@@@@@ bufempty ");
            this.nsPlayTimerMinMth();
            this.trackSocket.peers = this.dieDataInfo();
            this.trackSocket.sendHeartRequest();
            return;
        }// end function

        public function nsTime() : Number
        {
            var _loc_1:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_2:* = this.streamMang.nsTime;
            var _loc_3:* = "nsTime  isseek:" + this._isSeek + " oldtime:" + this.oldtime + " seekoutoffset:" + this.seekoutoffset + " seekinoffset:" + this.seekinoffset + " isSeekInsertByte:" + this.isSeekInsertByte + " time:" + _loc_2 + " realseek:" + this.realseek + " _seekoffset:" + this._seekoffset + " fileretime:" + (this.fileo != null ? (this.fileo.retime) : (0));
            trace(_loc_3);
            this.checkNsDataMth();
            if (this._isSeek)
            {
                _loc_1 = this._seekoffset;
            }
            else if (this._seekoffset == 0)
            {
                _loc_1 = _loc_2;
            }
            else if (this.isSeekInsertByte)
            {
                _loc_4 = _loc_2 + this.seekoutoffset;
                _loc_1 = _loc_4 > this._seekoffset ? (_loc_4) : (this._seekoffset);
                if (_loc_1 > this.fileList.timestotal)
                {
                    _loc_1 = this.oldtime;
                }
            }
            else
            {
                _loc_1 = this._seekoffset;
            }
            this.oldtime = _loc_1;
            return _loc_1;
        }// end function

        public function popInit() : void
        {
            this.hasnodata = false;
            this.hasnodata_startt = getTimer();
            return;
        }// end function

        private function checkNsDataMth() : void
        {
            var _loc_1:int = 0;
            if (this.fileo == null)
            {
                return;
            }
            if (Config.getInstance().isAutoSeek)
            {
                var _loc_2:String = this;
                var _loc_3:* = this.num + 1;
                _loc_2.num = _loc_3;
                if (this.num % 300 == 0)
                {
                    if (this.num > 5850)
                    {
                        this.num = 0;
                    }
                    _loc_1 = Math.floor(Math.random() * 5850);
                    if (this.ns != null)
                    {
                        this.ns.seek(_loc_1);
                    }
                }
            }
            if (this.ns.bufferLength < 0.1 && this.ns.isPlay && !this.isAllLoadedOver)
            {
                if (!this.hasnodata)
                {
                    this.hasnodata = true;
                    this.hasnodata_startt = getTimer();
                    this._initB = getTimer();
                }
                if (this.hasnodata)
                {
                    if (getTimer() - this.hasnodata_startt > ByteSize.BLACKTIME)
                    {
                        this.showPopInfo();
                    }
                }
            }
            else
            {
                this.popInit();
            }
            return;
        }// end function

        public function showPopInfo() : void
        {
            this.showTestInfo("blackScreen @@@@@  dur:" + (getTimer() - this._initB));
            this.showFailInfoMth("blackscreen");
            return;
        }// end function

        public function showFailInfoMth(param1:String, param2:String = null, param3:String = null) : void
        {
            if (param1 != "schedulsuccess")
            {
                this.showTestInfo("rollback  type：" + param1 + " param:" + param2 + " init_dur:" + (getTimer() - this._initB), true);
                if (param1 == "schedulfail" || param1 == "404" && param2 == null)
                {
                }
                else
                {
                    this.cleanMth();
                }
            }
            else
            {
                this.showTestInfo("统计  type：" + param1 + " param:" + param2);
            }
            this.ns.errorStaticAndRollBack(param1, param2, param3);
            return;
        }// end function

        public function get libLog() : String
        {
            var _loc_2:String = null;
            var _loc_1:String = "";
            for each (_loc_2 in this.liblogA)
            {
                
                _loc_1 = _loc_1 + (_loc_2 + "\n");
            }
            this.liblogA.splice(0);
            return _loc_1;
        }// end function

        public function get isfirst() : Boolean
        {
            return this._isfirst;
        }// end function

        public function get isGetwayInitFail() : Boolean
        {
            return this._isGetwayInitFail;
        }// end function

        public function set isGetwayInitFail(param1:Boolean) : void
        {
            this._isGetwayInitFail = param1;
            return;
        }// end function

        public function get isSetStart() : Boolean
        {
            return this._isSetStart;
        }// end function

        public function get allFile() : Array
        {
            return this.fileList.fileoA;
        }// end function

        public function get isSeek() : Boolean
        {
            return this._isSeek;
        }// end function

        public function set isSeek(param1:Boolean) : void
        {
            this._isSeek = param1;
            return;
        }// end function

        public function setSckedulIdx() : void
        {
            var _loc_1:int = 1;
            var _loc_2:* = Math.round(Math.random() * (6 - 1));
            var _loc_3:* = _loc_2 + _loc_1;
            Config.getInstance().schedulIdx = _loc_3;
            return;
        }// end function

        public function get schdulSuc() : String
        {
            if (Config.getInstance().schedulIPList.length == 0)
            {
                return Config.getInstance().schedulIP;
            }
            return Config.getInstance().schedulIPList[Config.getInstance().schedulIdx];
        }// end function

        public function get schdulString() : String
        {
            if (Config.getInstance().schedulIPList.length == 0)
            {
                return Config.getInstance().schedulIP;
            }
            if (Config.getInstance().schedulIdx != 0)
            {
                var _loc_2:* = Config.getInstance();
                var _loc_3:* = Config.getInstance().schedulIdx + 1;
                _loc_2.schedulIdx = _loc_3;
                if (Config.getInstance().schedulIdx >= Config.getInstance().schedulIPList.length)
                {
                    Config.getInstance().schedulIdx = 1;
                }
            }
            var _loc_1:* = Config.getInstance().schedulIPList[Config.getInstance().schedulIdx];
            return _loc_1;
        }// end function

        public function getNsType(param1:String = null)
        {
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            var _loc_2:* = this.chunksMang.getLoadedChunkByte();
            var _loc_3:* = this.getNsByte(_loc_2);
            Config.getInstance().f1 = Math.max(ByteSize.F1_low, Math.min(ByteSize.F1_high, ByteSize.F1_low + (getTimer() - this._seektime) / (1000 * ByteSize.FSec))) * Config.getInstance().bufv;
            Config.getInstance().f2 = Math.max(ByteSize.F2_low, Math.min(ByteSize.F2_high, ByteSize.F2_low + (getTimer() - this._seektime) / (1000 * ByteSize.FSec))) * Config.getInstance().bufv;
            Config.getInstance().curBuf = _loc_3;
            Config.getInstance().dniBuf = _loc_2;
            switch(param1)
            {
                case "isLoadingContinue":
                {
                    _loc_4 = ByteSize.LOADSTOPTNUM * Config.getInstance().bufv;
                    return _loc_3 > _loc_4 ? (false) : (true);
                }
                case "isNsTimeLowest":
                {
                    _loc_5 = ByteSize.LOWSECOND * Config.getInstance().bufv;
                    return _loc_3 > _loc_5 ? (false) : (true);
                }
                default:
                {
                    return _loc_3;
                    break;
                }
            }
        }// end function

        public function getNsByte(param1:Number) : Number
        {
            var _loc_2:* = this.peerNs.info;
            Config.getInstance().nsVBuf = _loc_2.videoBufferByteLength;
            Config.getInstance().nsABuf = _loc_2.audioBufferByteLength;
            return ((_loc_2.audioBufferByteLength == 0 || _loc_2.videoBufferByteLength == 0) && this.peerNs.bufferLength < ByteSize.LOWSECOND ? (0) : (_loc_2.audioBufferByteLength + _loc_2.videoBufferByteLength)) + param1;
        }// end function

        public function get clientIp() : String
        {
            return this.trackSocket.clientIp;
        }// end function

        public function get initFailInfo() : String
        {
            return this._initFailInfo;
        }// end function

        public function set initFailInfo(param1:String) : void
        {
            this._initFailInfo = param1;
            return;
        }// end function

        public static function getInstance() : P2pSohuLib
        {
            if (P2pSohuLib._instance == null)
            {
                P2pSohuLib._instance = new P2pSohuLib;
            }
            return P2pSohuLib._instance;
        }// end function

    }
}
