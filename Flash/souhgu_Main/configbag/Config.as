package configbag
{

    public class Config extends Object
    {
        public var version:Number = 1512071747;
        public var COMVERSION:int = 4;
        public var isLog:Boolean = false;
        public var isRtmfpTest:Boolean = false;
        public var isYDRtmfp:Boolean = false;
        public var fname:String = "L";
        public var testpid:String = "9008319";
        public var isplayinit:Boolean = true;
        public var isfirstlog:Boolean = true;
        public var logname:String = "";
        public var hasnatCheck:Boolean = false;
        public var hasnatCheckAtPeer:Boolean = false;
        public var istownc:Boolean = false;
        public var hasIELog:Boolean = false;
        public var isversiontest:Boolean = false;
        public var issohutest:Boolean = false;
        public var islow:Boolean = false;
        public var isShareOld:Boolean = false;
        public var hasCd:Boolean = true;
        public var hasparselog:Boolean = false;
        public var isP2pLive:Boolean = false;
        public var isSingleCdn:Boolean = true;
        public var isAutoSeek:Boolean = false;
        public var f1:Number = 1000000;
        public var f2:Number = 1500000;
        public var insertNumT:Number = 90;
        public var isTestP2P:Boolean = true;
        public var isPureCdn:Boolean = false;
        public var hasnat:Boolean = false;
        public var isChangeClarity:Boolean = false;
        public var is988:Boolean = false;
        public var isCDNSmall:Boolean = false;
        public var smallFileIdx:int = 0;
        public var isSmall:Boolean = false;
        public var isFileChanged:Boolean = false;
        public var isCrc:Boolean = false;
        public var transLimitNum:int = 6;
        public var ispurecdn:Boolean = false;
        public var isPureRp:Boolean = false;
        public var clarity:String;
        public var isPastTenSNoData:Boolean = false;
        private var _getWayHost:String = "p2p.vod.tv.sohu.com";
        public var getWayHostIP:String = "220.181.2.37";
        public var getWayHostIp2:String = "123.125.122.178";
        public var schedulIP:String = "data.vod.itc.cn";
        public var schedulIPList:Array;
        public var schedulIdx:int = 0;
        private var _getWayPort:Number = 80;
        private var _trackHost:String;
        private var _trackPort:Number;
        private var _cdnUrl:String = "http://10.10.82.155:7180";
        private var _rtmfpUrl:String = "rtmfp://p2p.rtmfp.net/";
        private var _filelistUrl:String = "http://10.10.82.155:7180/filelist.txt";
        private var _peerID:String = "";
        private var _p2pID:int = -1;
        private var _cid:String = "1";
        public var vid:String = "";
        public var pid:String = "";
        public var uid:String = "";
        public var ta:String = "";
        public var cdnparam:String = "";
        private var _nextfilename:String = "";
        private var _curfilename:String = "1.flv";
        public var stopFilename:String = "";
        public var endfilename:Number = 173;
        public var filenum:int = 30;
        public var isDownAndPlay:Boolean = false;
        public var isAdobeRtmfp:Boolean = false;
        public var isRP:Boolean = false;
        public var chunknum:Number = 1;
        public var spnum:int = 2;
        public var rpnum:int = 3;
        public var spnum_percon:int = 1;
        public var isWeb:Boolean = true;
        public var nowLoadingFilename:String;
        public var indexFilename:String;
        public var isWait:Boolean = false;
        public var randomNum:Number;
        public var nsbytemin:Number = 20000;
        public var nsbytemid:Number = 100000;
        public var nsbytemax:Number = 450000;
        public var usertypenum:Number = 15;
        public var usertype:Boolean = false;
        public var isIOError:Boolean = false;
        public var bufv:Number = 50000;
        public var min_bufv:Number = 76800;
        public var bufsize:Number = 0;
        public var buftime:Number = 3000;
        public var filetime:Number = 1000;
        public var superSecend:int = 5;
        public var superMidSecend:int = 10;
        public var superUserSecend:int = 6;
        public var filesizeA:Array;
        public var filesizeAnum:int = 10;
        public var fileMaxSize:int = 10;
        public var fileCdnTA:Array;
        public var filePeerTA:Array;
        public var peertime:Number = 1500;
        public var peerSucA:Array;
        public var peerSuc:Number = 0.5;
        public var codeNum:int = 5;
        public var errorConTimeNumGet:Number = 4000;
        public var errorConTimeNumTrack:Number = 6000;
        public var errorConTimeNumRtmfp:Number = 6000;
        public var waitCountTotal:int = 3;
        public var peerConnectDelayNum:int = 10000;
        public var avg_peerConnectDelayNum:int = 3000;
        public var peerConDelNum:Number = 1.5;
        public var peerDelNum:Number = 1.1;
        public var peerDatatime:Number = 6000;
        public var avg_peerDatatime:int = 5000;
        public var avg_peerDataV:int = 10240;
        public var cdnConnectDelayNum:int = 6000;
        public var avg_cdnConnectDelayNum:int = 2000;
        public var cdnDatatime:Number = 6000;
        public var avg_cdnDatatime:int = 15000;
        public var avg_cdnDataV:int = 10240;
        public var cdnDataT:int = 1000;
        public var cdnPiceDataT:int = 6000;
        public var avg_schConNum:int = 1500;
        public var avg_schDataNum:int = 3000;
        public var peerlistTInteral:int = 7000;
        public var loginTInteral:int = 3000;
        public var trackActA:Array;
        public var trackActTNum:int = 3000;
        public var max_peer_time:Number = 3000;
        public var min_peer_time:Number = 1500;
        public var lastMsgCMD:String;
        public var isChangeCdn:Boolean = false;
        public var isChangeCdnPeer:Boolean = false;
        public var isCdnNoFile:Boolean = false;
        public var initErrorType:String = "-1";
        public var initNum:int = 10;
        public var nat:int = 3;
        public var nsMaxTime:Number = 300;
        public var chunkGap:Number = 3;
        public var piceGap:Number = 2;
        public var isRtmfpDie:Boolean = false;
        public var curBuf:Number;
        public var dniBuf:Number;
        public var nsVBuf:Number;
        public var nsABuf:Number;
        public var cdidx:int = 0;
        public var getwayConT:Number;
        public var rtmfpConT:Number;
        public var initT:Number;
        public var visitTrack:int = 3;
        public var is301:Boolean = false;
        public var staticO:Object;
        private static var _instance:Config;

        public function Config()
        {
            this.schedulIPList = new Array();
            this.filesizeA = new Array();
            this.fileCdnTA = new Array();
            this.filePeerTA = new Array();
            this.peerSucA = new Array();
            this.trackActA = new Array();
            this.staticO = new Object();
            return;
        }// end function

        public function clearMth() : void
        {
            this.trackActA.splice(0);
            this.filesizeA.splice(0);
            this.fileCdnTA.splice(0);
            this.filePeerTA.splice(0);
            this.peerSucA.splice(0);
            this.isfirstlog = true;
            this.logname = "";
            return;
        }// end function

        public function get cdnUrl() : String
        {
            return this._cdnUrl;
        }// end function

        public function set cdnUrl(param1:String) : void
        {
            this._cdnUrl = param1;
            return;
        }// end function

        public function get rtmfpUrl() : String
        {
            return this._rtmfpUrl;
        }// end function

        public function set rtmfpUrl(param1:String) : void
        {
            this._rtmfpUrl = param1;
            return;
        }// end function

        public function get developerKey() : String
        {
            return "1710124cbf69e3f25b780c13-d6cbf2cb35a1";
        }// end function

        public function get getWayHost() : String
        {
            return this._getWayHost;
        }// end function

        public function set getWayHost(param1:String) : void
        {
            this._getWayHost = param1;
            return;
        }// end function

        public function get getWayPort() : Number
        {
            return this._getWayPort;
        }// end function

        public function set getWayPort(param1:Number) : void
        {
            this._getWayPort = param1;
            return;
        }// end function

        public function get trackPort() : Number
        {
            return this._trackPort;
        }// end function

        public function set trackPort(param1:Number) : void
        {
            this._trackPort = param1;
            return;
        }// end function

        public function get filelistUrl() : String
        {
            return this._filelistUrl;
        }// end function

        public function set filelistUrl(param1:String) : void
        {
            this._filelistUrl = param1;
            return;
        }// end function

        public function get trackHost() : String
        {
            return this._trackHost;
        }// end function

        public function set trackHost(param1:String) : void
        {
            this._trackHost = param1;
            return;
        }// end function

        public function get peerID() : String
        {
            return this._peerID;
        }// end function

        public function set peerID(param1:String) : void
        {
            this._peerID = param1;
            return;
        }// end function

        public function get p2pID() : int
        {
            return this._p2pID;
        }// end function

        public function set p2pID(param1:int) : void
        {
            this._p2pID = param1;
            return;
        }// end function

        public function get cid() : String
        {
            return this._cid;
        }// end function

        public function set cid(param1:String) : void
        {
            this._cid = param1;
            return;
        }// end function

        public function get nextfilename() : String
        {
            return this._nextfilename;
        }// end function

        public function set nextfilename(param1:String) : void
        {
            this._nextfilename = param1;
            return;
        }// end function

        public function get curfilename() : String
        {
            return this._curfilename;
        }// end function

        public function set curfilename(param1:String) : void
        {
            this._curfilename = param1;
            return;
        }// end function

        public static function getInstance() : Config
        {
            if (_instance == null)
            {
                _instance = new Config;
            }
            return _instance;
        }// end function

    }
}
