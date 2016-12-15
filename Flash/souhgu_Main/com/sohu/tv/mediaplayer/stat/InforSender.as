package com.sohu.tv.mediaplayer.stat
{
    import com.adobe.crypto.*;
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.ads.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.ui.*;
    import ebing.*;
    import ebing.external.*;
    import ebing.utils.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.utils.*;

    public class InforSender extends EventDispatcher
    {
        private var _timeoutID:uint = 0;
        private var _ifltype:String = "";
        private var FCK:FlashCookie;
        private var _is56HD:String = "0";
        private var _xxtea:XXTEA;
        private var _paramStr:String = "";
        public static const START:String = "playCount";
        public static const START2:String = "videoStart";
        public static const START3:String = "out";
        public static const END:String = "videoEnds";
        public static const BUFFER_FULL:String = "bufferFull";
        public static const BUFFER_EMPTY:String = "bufferEmpty";
        public static const STOP:String = "stopTrigger";
        public static const PAUSE:String = "pauseTrigger";
        public static const CLIP_OVER:String = "clipOver";
        public static const ADCLIP_OVER:String = "adclipOver";
        public static const FULLSCREEN:String = "fullScreen";
        public static const SCALESCREEN:String = "scaleScreen";
        public static const DOWNLOAD_TIME:String = "downloadtime";
        public static const OPENING_AD:String = "openingad";
        public static const ENDING_AD:String = "endingad";
        public static const NEW_USER:String = "newuser";
        public static const DROPFRAMES:String = "dropFrames";
        public static const DFFORSO:String = "dfForSo";
        public static const FF:String = "ff";
        public static const HISTORYPROBLEMS:String = "historyproblems";
        public static const VVERROR:String = "vverror";
        public static const VINFOTIMEOUT:String = "vinfotimeout";
        public static const ROLLBACKPLAY:String = "rollbackplay";
        public static var singleton:InforSender;

        public function InforSender() : void
        {
            this.FCK = new FlashCookie();
            this._xxtea = new XXTEA();
            return;
        }// end function

        public function sendMesg(param1:String, param2:Number, param3:String = "", param4:String = "", param5:String = "http://data.vrs.sohu.com/player.gif", param6:uint = 0, param7:Object = null) : void
        {
            return;
            var _loc_21:String = null;
            var _loc_22:String = null;
            var _loc_23:Array = null;
            var _loc_24:Number = NaN;
            if (PlayerConfig.isPreview)
            {
                return;
            }
            if (PlayerConfig.is56)
            {
                this.update56Ver();
            }
            var _loc_8:* = SharedObject.getLocal("hisRecommMark", "/");
            if (SharedObject.getLocal("hisRecommMark", "/").data.item != undefined && _loc_8.data.item.vid != undefined && _loc_8.data.item.vid != "")
            {
                if (_loc_8.data.item.vid == PlayerConfig.vid || _loc_8.data.item.vid == PlayerConfig.hdVid || _loc_8.data.item.vid == PlayerConfig.superVid || _loc_8.data.item.vid == PlayerConfig.norVid || _loc_8.data.item.vid == PlayerConfig.oriVid)
                {
                    PlayerConfig.lb = "3";
                    _loc_8.clear();
                }
            }
            var _loc_9:* = PlayerConfig.userId;
            var _loc_10:* = this._ifltype != "" && !PlayerConfig.isLive && PlayerConfig.hdVid != "" ? (true) : (false);
            var _loc_11:* = this._ifltype != "" && !PlayerConfig.isLive && PlayerConfig.hdVid != "" ? (true) : (false) ? (Number(Utils.cleanUnderline(PlayerConfig.hdVid))) : (Number(Utils.cleanUnderline(PlayerConfig.vid)));
            var _loc_12:* = PlayerConfig.isFms ? (-1) : (Number(PlayerConfig.nid));
            var _loc_13:* = Number(PlayerConfig.pid);
            var _loc_14:* = Number(PlayerConfig.sid);
            var _loc_15:* = String(PlayerConfig.clientIp);
            var _loc_16:* = PlayerConfig.timestamp;
            var _loc_17:* = new URLVariables();
            if (param3 != "" && param4 != "")
            {
                _loc_17[param3] = param4;
            }
            _loc_17.clientIp = _loc_15;
            if (Model.getInstance().videoInfo != null && Model.getInstance().videoInfo.status != null && Model.getInstance().videoInfo.status != "" && Model.getInstance().videoInfo.status == 3)
            {
                _loc_17.msg = START3;
            }
            else
            {
                _loc_17.msg = param1;
            }
            if (param1 == START && !PlayerConfig.is56 && PlayerConfig.autoPlay)
            {
                this.callbackFun();
            }
            if (param1 == START2)
            {
                _loc_17.hasStartAd = TvSohuAds.getInstance().startAd.hasAd ? ("1") : ("0");
                if (param7 != null)
                {
                    if (param7.mode != null)
                    {
                        _loc_17.stvMode = param7.mode;
                    }
                    if (param7.curColor != null)
                    {
                        _loc_17.curColor = param7.curColor;
                    }
                    if (param7.colorSpace != null)
                    {
                        _loc_17.colorSpace = param7.colorSpace;
                    }
                    if (param7.svdLen != null)
                    {
                        _loc_17.svdLen = param7.svdLen;
                    }
                }
            }
            if (param1 == DROPFRAMES)
            {
                if (param7 != null)
                {
                    if (param7.mode != null)
                    {
                        _loc_17.stvMode = param7.mode;
                    }
                    if (param7.curColor != null)
                    {
                        _loc_17.curColor = param7.curColor;
                    }
                    if (param7.colorSpace != null)
                    {
                        _loc_17.colorSpace = param7.colorSpace;
                    }
                    if (param7.svdLen != null)
                    {
                        _loc_17.svdLen = param7.svdLen;
                    }
                    if (param7.videoFps != null)
                    {
                        _loc_17.videoFps = param7.videoFps;
                    }
                    if (param7.totalMemory != null)
                    {
                        _loc_17.totalMemory = param7.totalMemory;
                    }
                    if (param7.freeMemory != null)
                    {
                        _loc_17.freeMemory = param7.freeMemory;
                    }
                }
            }
            if (param1 == FF)
            {
                if (param7 != null)
                {
                    if (param7.num != null)
                    {
                        _loc_17.num = param7.num;
                    }
                    if (param7.errType != null)
                    {
                        _loc_17.errType = param7.errType;
                    }
                    if (param7.outTime != null)
                    {
                        _loc_17.outTime = param7.outTime;
                    }
                    if (param7.spendTime != null)
                    {
                        _loc_17.spendTime = param7.spendTime;
                    }
                    if (param7.decNum != null)
                    {
                        _loc_17.decNum = param7.decNum;
                    }
                    if (param7.serTimeNum1 != null)
                    {
                        _loc_17.serTimeNum1 = param7.serTimeNum1;
                    }
                    if (param7.serTimeNum2 != null)
                    {
                        _loc_17.serTimeNum2 = param7.serTimeNum2;
                    }
                    if (param7.clientTime != null)
                    {
                        _loc_17.clientTime = param7.clientTime;
                    }
                    if (param7.adUrl != null)
                    {
                        _loc_17.adUrl = param7.adUrl;
                    }
                    if (param7.adSerTime != null)
                    {
                        _loc_17.adSerTime = param7.adSerTime;
                    }
                    if (param7.adPlayedTime1 != null)
                    {
                        _loc_17.adPlayedTime1 = param7.adPlayedTime1;
                    }
                    if (param7.adPlayedTime2 != null)
                    {
                        _loc_17.adPlayedTime2 = param7.adPlayedTime2;
                    }
                    if (param7.flag != null)
                    {
                        _loc_17.flag = param7.flag;
                    }
                    if (param7.loadType != null)
                    {
                        _loc_17.loadType = param7.loadType;
                    }
                    if (param7.hasAd != null)
                    {
                        _loc_17.hasAd = param7.hasAd;
                    }
                }
            }
            if (param1 == END)
            {
                if (param7 != null)
                {
                    if (param7.totalRAM != null)
                    {
                        _loc_17.totalRAM = param7.totalRAM;
                    }
                    if (param7.idleRAMPer != null)
                    {
                        _loc_17.idleRAMPer = param7.idleRAMPer;
                    }
                    if (param7.playerRAMPer != null)
                    {
                        _loc_17.playerRAMPer = param7.playerRAMPer;
                    }
                }
            }
            if (param1 == DFFORSO)
            {
                if (param7 != null)
                {
                    if (param7.totalViewTime != null)
                    {
                        _loc_17.totalViewTime = param7.totalViewTime;
                    }
                    if (param7.totalDropFrames != null)
                    {
                        _loc_17.totalDropFrames = param7.totalDropFrames;
                    }
                    if (param7.stvdInUse != null)
                    {
                        _loc_17.stvdInUse = param7.stvdInUse;
                    }
                }
            }
            if (param1 == HISTORYPROBLEMS)
            {
                if (param7 != null)
                {
                    if (param7.allotType != null)
                    {
                        _loc_17.allotType = param7.allotType;
                    }
                    if (param7.errType != null)
                    {
                        _loc_17.errType = param7.errType;
                    }
                }
            }
            if (param1 == VVERROR)
            {
                if (param7 != null)
                {
                    if (param7.vxmlErr != null)
                    {
                        _loc_17.vxmlErr = param7.vxmlErr;
                    }
                }
            }
            if (param1 == VINFOTIMEOUT)
            {
                if (param7 != null)
                {
                    if (param7.outTime != null)
                    {
                        _loc_17.outTime = param7.outTime;
                    }
                }
            }
            if (param1 == START && param6 != 0)
            {
                _loc_17.err = 1;
            }
            _loc_17.time = Math.floor(param2);
            _loc_17.uid = _loc_9;
            _loc_17.vid = _loc_11;
            _loc_17.tvid = PlayerConfig.tvid;
            _loc_17.nid = _loc_12;
            _loc_17.pid = _loc_13;
            _loc_17.sid = _loc_14;
            if (PlayerConfig.isLive)
            {
                _loc_17.ltype = PlayerConfig.liveType;
            }
            if (PlayerConfig.isFee && param1 == START)
            {
                _loc_17.isfee = 1;
                ErrorSenderPQ.getInstance().sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"player", code:PlayerConfig.VINFO_CODE, error:PlayerConfig.VINFO_ERROR_13, debuginfo:"主播放器日志：" + LogManager.getMsg() + "|p2p日志：" + P2pLog.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
            }
            _loc_17.playListId = PlayerConfig.isMyTvVideo ? (PlayerConfig.wm_user == "20" ? (PlayerConfig.vrsPlayListId) : (PlayerConfig.isSohuDomain && PlayerConfig.plid != "" ? (PlayerConfig.plid) : ("0"))) : (PlayerConfig.vrsPlayListId);
            _loc_17.isHD = PlayerConfig.is56 ? (this._is56HD) : (PlayerConfig.isHd ? (PlayerConfig.videoVersion) : ("0"));
            _loc_17.td = Math.round(PlayerConfig.totalDuration);
            if (PlayerConfig.caid != "")
            {
                _loc_17.cateid = PlayerConfig.caid;
            }
            if (PlayerConfig.apiKey != "")
            {
                _loc_17.apikey = PlayerConfig.apiKey;
            }
            if (PlayerConfig.yyid != "")
            {
                _loc_17.yyid = PlayerConfig.yyid;
            }
            if (PlayerConfig.atype != "")
            {
                _loc_17.atype = PlayerConfig.atype;
            }
            if (PlayerConfig.mergeid != "")
            {
                _loc_17.mergeid = PlayerConfig.mergeid;
            }
            if (PlayerConfig.isWebP2p)
            {
                _loc_17.ua = "pp";
            }
            else if (PlayerConfig.SOHUTEST)
            {
                _loc_17.ua = "sohutest";
            }
            else
            {
                _loc_17.ua = "sh";
            }
            _loc_17.isp2p = P2PExplorer.getInstance().hasP2P ? (PlayerConfig.gslbErrorIp != "" ? (0) : (1)) : (0);
            if (PlayerConfig.isMyTvVideo)
            {
                _loc_17.cateid = PlayerConfig.cid;
                _loc_17.userid = PlayerConfig.myTvUserId;
            }
            if (Model.getInstance().videoInfo != null && Model.getInstance().videoInfo.company != null && Model.getInstance().videoInfo.company != "")
            {
                _loc_17.company = Model.getInstance().videoInfo.company;
            }
            _loc_17.timestamp = _loc_16;
            if (Eif.available && ExternalInterface.available)
            {
                try
                {
                    _loc_21 = ExternalInterface.call("eval", "window.top.location.href");
                    _loc_22 = ExternalInterface.call("eval", "window.self.location.href");
                    if (_loc_21 != _loc_22)
                    {
                        _loc_17.isIframe = "1";
                    }
                    else
                    {
                        _loc_17.isIframe = "0";
                    }
                }
                catch (e:Error)
                {
                }
            }
            _loc_17.areaid = PlayerConfig.area;
            _loc_17.vrschannelid = PlayerConfig.channel;
            if (PlayerConfig.isHotOrMy)
            {
                _loc_17.systype = "0";
            }
            else
            {
                _loc_17.systype = "1";
                if (PlayerConfig.isAlbumVideo)
                {
                    _loc_17.album = "1";
                }
                else
                {
                    _loc_17.album = "0";
                }
            }
            _loc_17.uuid = PlayerConfig.uuid;
            var _loc_18:* = PlayerConfig.catcode;
            if (PlayerConfig.is56 && PlayerConfig.acidFor56 != "")
            {
                _loc_17.catcode = Number(PlayerConfig.channelFor56) > 1000 && Number(PlayerConfig.channelFor56) < 10000 ? (String(Number(PlayerConfig.channelFor56) - 1000)) : (PlayerConfig.channelFor56);
            }
            else
            {
                _loc_17.catcode = _loc_18;
            }
            _loc_17.act = PlayerConfig.act;
            _loc_17.st = PlayerConfig.mainActorId;
            _loc_17.ar = PlayerConfig.areaId;
            _loc_17.ye = PlayerConfig.year;
            _loc_17.ag = PlayerConfig.age;
            _loc_17.lf = escape(PlayerConfig.landingrefer);
            _loc_17.autoplay = PlayerConfig.autoPlay ? (1) : (0);
            if (PlayerConfig.lb != null && PlayerConfig.lb != "" && PlayerConfig.lb == "1")
            {
                _loc_17.refer = escape(PlayerConfig.lastReferer);
                _loc_17.url = escape(PlayerConfig.filePrimaryReferer);
            }
            else
            {
                if (Eif.available && ExternalInterface.available)
                {
                    try
                    {
                        _loc_17.refer = escape(ExternalInterface.call("eval", "document.referrer"));
                    }
                    catch (e:Error)
                    {
                    }
                }
                _loc_17.url = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
            }
            if (PlayerConfig.totalDuration > 180)
            {
                _loc_17.heart = 30;
            }
            else
            {
                _loc_17.heart = 10;
            }
            _loc_17.xuid = PlayerConfig.xuid;
            _loc_17.out = PlayerConfig.domainProperty;
            if (PlayerConfig.lb != null && PlayerConfig.lb != "")
            {
                _loc_17.lb = PlayerConfig.lb;
            }
            if (PlayerConfig.pub_catecode != null && PlayerConfig.pub_catecode != "")
            {
                _loc_17.pub_catecode = PlayerConfig.pub_catecode;
            }
            if (PlayerConfig.ch_key != null && PlayerConfig.ch_key != "")
            {
                _loc_17.ch_key = PlayerConfig.ch_key;
            }
            if (PlayerConfig.ifoxInfoObj != null && PlayerConfig.ifoxInfoObj != "")
            {
                if (PlayerConfig.ifoxInfoObj.ifoxVer != "")
                {
                    _loc_17.v = PlayerConfig.ifoxInfoObj.ifoxVer;
                }
                if (PlayerConfig.ifoxInfoObj.ifoxUid != "")
                {
                    _loc_17.iuid = PlayerConfig.ifoxInfoObj.ifoxUid;
                }
                if (PlayerConfig.ifoxInfoObj.ifoxCh != "")
                {
                    _loc_17.ChannelID = PlayerConfig.ifoxInfoObj.ifoxCh;
                }
            }
            _loc_17.passport = PlayerConfig.passportMail;
            try
            {
                if (Eif.available && (ExternalInterface.call("sohuHD.cookie", "promote_position") != null && ExternalInterface.call("sohuHD.cookie", "promote_position") != "" && ExternalInterface.call("sohuHD.cookie", "promote_position") != "undefined"))
                {
                    _loc_17.pepn = ExternalInterface.call("sohuHD.cookie", "promote_position");
                    ExternalInterface.call("sohuHD.cookie", "promote_position", null, {path:"/", domain:"tv.sohu.com"});
                }
            }
            catch (e:Error)
            {
            }
            _loc_17.fver = PlayerConfig.VERSION;
            if (PlayerConfig.lqd != "")
            {
                _loc_17.oth = PlayerConfig.lqd;
            }
            if (PlayerConfig.lcode != "")
            {
                _loc_17.cd = PlayerConfig.lcode;
            }
            _loc_17.sz = PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight;
            _loc_17.md = PlayerConfig.dmMd;
            var _loc_19:* = PlayerConfig.swfHost.split("/");
            _loc_17.pdir = _loc_19[_loc_19.length - 2];
            if (PlayerConfig.ugu != "")
            {
                _loc_17.ugu = PlayerConfig.ugu;
            }
            if (PlayerConfig.ugcode != "")
            {
                _loc_17.ugcode = PlayerConfig.ugcode;
            }
            if (PlayerConfig.wm_user != "")
            {
                _loc_17.wm_user = PlayerConfig.wm_user;
            }
            if (PlayerConfig.fc_user != "")
            {
                _loc_17.fc_user = PlayerConfig.fc_user;
            }
            if (Model.getInstance().videoInfo != null && Model.getInstance().videoInfo.status != null && Model.getInstance().videoInfo.status != "" && Model.getInstance().videoInfo.status == 12)
            {
                _loc_17.status = Model.getInstance().videoInfo.status;
            }
            if (PlayerConfig.is56)
            {
                _loc_17.atype = "56";
                _loc_17.statid = PlayerConfig.statidFor56;
                _loc_17.lb = "2";
            }
            else
            {
                _loc_17.type = PlayerConfig.isMyTvVideo ? ("my") : (PlayerConfig.isTransition || !PlayerConfig.isLongVideo ? ("vms") : ("vrs"));
            }
            if (PlayerConfig.hotVrSyst != "" && (param1 == START || param1 == START2))
            {
                _loc_23 = PlayerConfig.hotVrSyst.split("&m=");
                _loc_24 = new Date().getTime();
                _loc_23[0] = Number(_loc_23[0]) + Math.abs(_loc_24 - Number(_loc_23[1]));
                _loc_17.t = Number(_loc_23[0]);
                _loc_17.syst = new Date().getTime();
                _loc_17.ts = MD5.hash(String(Number(PlayerConfig.vid) % 164) + PlayerConfig.userId + PlayerConfig.uuid + String(Number(_loc_23[0]) % 145));
            }
            if (this._paramStr != "")
            {
                _loc_17.ran = escape(this._paramStr);
            }
            _loc_17.feevv = PlayerConfig.tvIsFee ? (1) : (0);
            var _loc_20:* = new URLRequest(param5);
            new URLRequest(param5).method = URLRequestMethod.GET;
            _loc_20.data = _loc_17;
            if (!PlayerConfig.ISTEST || PlayerConfig.ISTEST && (PlayerConfig.currentVid == "717990" || PlayerConfig.currentVid == "1782553" || PlayerConfig.currentVid == "1710392"))
            {
                sendToURL(_loc_20);
            }
            return;
        }// end function

        public function heartBeat(param1:Number, param2:String) : String
        {
            var _loc_15:String = null;
            var _loc_16:String = null;
            var _loc_17:String = null;
            var _loc_3:String = "";
            var _loc_4:String = "";
            var _loc_5:String = "";
            if (PlayerConfig.lb != null && PlayerConfig.lb != "" && PlayerConfig.lb == "1")
            {
                _loc_5 = escape(PlayerConfig.lastReferer);
                _loc_4 = escape(PlayerConfig.filePrimaryReferer);
            }
            else
            {
                if (Eif.available && ExternalInterface.available)
                {
                    try
                    {
                        _loc_5 = escape(ExternalInterface.call("eval", "document.referrer"));
                    }
                    catch (e:Error)
                    {
                    }
                }
                _loc_4 = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
            }
            var _loc_6:String = "";
            if (PlayerConfig.ifoxInfoObj != null && PlayerConfig.ifoxInfoObj != "")
            {
                _loc_15 = PlayerConfig.ifoxInfoObj.ifoxVer != "" ? ("&v=" + PlayerConfig.ifoxInfoObj.ifoxVer) : ("");
                _loc_16 = PlayerConfig.ifoxInfoObj.ifoxUid != "" ? ("&iuid=" + PlayerConfig.ifoxInfoObj.ifoxUid) : ("");
                _loc_17 = PlayerConfig.ifoxInfoObj.ifoxCh != "" ? ("&ChannelID=" + PlayerConfig.ifoxInfoObj.ifoxCh) : ("");
                _loc_6 = _loc_15 + _loc_16 + _loc_17;
            }
            var _loc_7:Number = 0;
            var _loc_8:* = SharedObject.getLocal("vmsPlayer", "/");
            if (SharedObject.getLocal("vmsPlayer", "/").data.bw != undefined && _loc_8.data.bw != "" && String(_loc_8.data.bw) != "0")
            {
                _loc_7 = _loc_8.data.bw;
            }
            var _loc_9:* = InforSender.getInstance().ifltype != "" && !PlayerConfig.isLive && PlayerConfig.hdVid != "" ? (true) : (false);
            var _loc_10:String = "";
            var _loc_11:* = PlayerConfig.swfHost.split("/");
            _loc_10 = "&pdir=" + _loc_11[_loc_11.length - 2];
            var _loc_12:* = (PlayerConfig.lqd != "" ? ("&oth=" + PlayerConfig.lqd) : ("")) + (PlayerConfig.lcode != "" ? ("&cd=" + PlayerConfig.lcode) : ("")) + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.dmMd + (PlayerConfig.ugu != "" ? ("&ugu=" + PlayerConfig.ugu) : ("")) + (PlayerConfig.ugcode != "" ? ("&ugcode=" + PlayerConfig.ugcode) : ("")) + (PlayerConfig.wm_user != "" ? ("&wm_user=" + PlayerConfig.wm_user) : ("")) + (PlayerConfig.fc_user != "" ? ("&fc_user=" + PlayerConfig.fc_user) : (""));
            var _loc_13:String = "";
            if (PlayerConfig.is56)
            {
                _loc_13 = "&atype=56" + "&statid=" + PlayerConfig.statidFor56 + "&lb=2";
            }
            var _loc_14:* = PlayerConfig.catcode;
            if (PlayerConfig.is56 && PlayerConfig.acidFor56 != "")
            {
                _loc_14 = Number(PlayerConfig.channelFor56) > 1000 && Number(PlayerConfig.channelFor56) < 10000 ? (String(Number(PlayerConfig.channelFor56) - 1000)) : (PlayerConfig.channelFor56);
            }
            _loc_3 = param2 + "&vid=" + (_loc_9 ? (Utils.cleanUnderline(PlayerConfig.hdVid)) : (Utils.cleanUnderline(PlayerConfig.vid))) + "&tvid=" + PlayerConfig.tvid + "&ua=" + (PlayerConfig.isWebP2p ? ("pp") : ("sh")) + "&isHD=" + (PlayerConfig.is56 ? (this._is56HD) : (PlayerConfig.isHd ? (PlayerConfig.videoVersion) : ("0"))) + "&pid=" + PlayerConfig.pid + "&uid=" + PlayerConfig.userId + "&out=" + PlayerConfig.domainProperty + "&playListId=" + (PlayerConfig.isMyTvVideo ? (PlayerConfig.wm_user == "20" ? (PlayerConfig.vrsPlayListId) : (PlayerConfig.isSohuDomain && PlayerConfig.plid != "" ? (PlayerConfig.plid) : ("0"))) : (PlayerConfig.vrsPlayListId)) + "&nid=" + (PlayerConfig.isFms ? (-1) : (Number(PlayerConfig.nid))) + "&tc=" + PlayerConfig.viewTime + (PlayerConfig.is56 ? ("") : ("&type=" + (PlayerConfig.isMyTvVideo ? ("my") : (PlayerConfig.isTransition || !PlayerConfig.isLongVideo ? ("vms") : ("vrs"))))) + "&cateid=" + PlayerConfig.cid + "&userid=" + PlayerConfig.myTvUserId + "&uuid=" + encodeURIComponent(PlayerConfig.uuid) + (PlayerConfig.isLive ? ("&ltype=" + PlayerConfig.liveType) : ("")) + (PlayerConfig.isFee ? ("&isfee=1") : ("")) + (PlayerConfig.pub_catecode != "" ? ("&pub_catecode=" + PlayerConfig.pub_catecode) : ("")) + (PlayerConfig.atype != "" ? ("&atype=" + PlayerConfig.atype) : ("")) + (PlayerConfig.ch_key != "" ? ("&ch_key=" + PlayerConfig.ch_key) : ("")) + (PlayerConfig.mergeid != "" ? ("&mergeid=" + PlayerConfig.mergeid) : ("")) + "&feevv=" + (PlayerConfig.tvIsFee ? (1) : (0)) + "&isp2p=" + (P2PExplorer.getInstance().hasP2P ? (PlayerConfig.gslbErrorIp != "" ? (0) : (1)) : (0)) + (PlayerConfig.userAgent != "" ? ("&ua=" + PlayerConfig.userAgent) : ("")) + "&catcode=" + encodeURIComponent(_loc_14) + "&systype=" + (PlayerConfig.isHotOrMy ? ("0") : ("1")) + "&act=" + PlayerConfig.act + "&st=" + encodeURIComponent(PlayerConfig.mainActorId) + "&ar=" + PlayerConfig.areaId + "&ye=" + PlayerConfig.year + "&ag=" + escape(PlayerConfig.age) + "&clientIp=" + PlayerConfig.clientIp + "&lb=" + PlayerConfig.lb + (PlayerConfig.yyid != "" ? ("&yyid=" + PlayerConfig.yyid) : ("")) + _loc_6 + "&xuid=" + PlayerConfig.xuid + "&passport=" + encodeURIComponent(PlayerConfig.passportMail) + "&showqd=" + Math.round(PlayerConfig.playedTime) + "&heart=" + param1 + "&td=" + Math.round(PlayerConfig.totalDuration) + "&fver=" + PlayerConfig.VERSION + _loc_10 + _loc_12 + _loc_13 + "&url=" + _loc_4 + "&lf=" + escape(PlayerConfig.landingrefer) + "&autoplay=" + (PlayerConfig.autoPlay ? (1) : (0)) + "&cdnIp=" + PlayerConfig.cdnIp + "&cdnSpeed=" + _loc_7 + "&refer=" + _loc_5 + "&t=" + Math.random();
            return _loc_3;
        }// end function

        public function sendIRS(param1:String = "") : void
        {
            var _loc_2:* = PlayerConfig.currentVid.split("_")[0];
            this.FCK._IWT_Debug = false;
            this.FCK._IWT_UAID = PlayerConfig.is56 ? (PlayerConfig.isSohuDomain ? ("UA-56-100009") : ("UA-56-100008")) : (PlayerConfig.isLive ? ("UA-sohu-100007") : (PlayerConfig.isSohuDomain ? ("UA-sohu-100009") : ("UA-sohu-100008")));
            var _loc_3:* = PlayerConfig.isLive ? (_loc_2) : (PlayerConfig.tvid);
            var _loc_4:* = int(PlayerConfig.totalDuration);
            var _loc_5:Boolean = true;
            var _loc_6:* = PlayerConfig.isLive ? (_loc_2) : (PlayerConfig.vid);
            var _loc_7:* = escape(PlayerConfig.currentPageUrl);
            var _loc_8:* = !PlayerConfig.isMyTvVideo ? (escape(PlayerConfig.sid + "|" + PlayerConfig.userId)) : ("");
            var _loc_9:* = PlayerConfig.is56 ? ("1") : (PlayerConfig.isMyTvVideo ? ("1") : ("0"));
            switch(param1)
            {
                case "":
                {
                    this.FCK.IRS_NewPlay(_loc_3, _loc_4, _loc_5, _loc_6, _loc_7, _loc_8, _loc_9);
                    break;
                }
                case "play":
                {
                    this.FCK.IRS_UserACT("play");
                    break;
                }
                case "pause":
                {
                    this.FCK.IRS_UserACT("pause");
                    break;
                }
                case "end":
                {
                    this.FCK.IRS_UserACT("end");
                    this.FCK.IRS_FlashClear();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function sendBufferMesg(param1:String, param2:Number) : void
        {
            if (PlayerConfig.isPreview)
            {
                return;
            }
            if (this._timeoutID != 0)
            {
                clearTimeout(this._timeoutID);
            }
            this._timeoutID = setTimeout(this.sendMesg, 2000, param1, param2);
            return;
        }// end function

        public function sendCustomMesg(param1:String) : void
        {
            return;
            var _loc_2:URLRequest = null;
            if (PlayerConfig.isPreview)
            {
                return;
            }
            if (param1 != null && param1 != "")
            {
                _loc_2 = new URLRequest(param1);
                _loc_2.method = URLRequestMethod.GET;
                sendToURL(_loc_2);
            }
            return;
        }// end function

        public function callbackFun() : void
        {
            var _loc_1:* = Utils.getBrowserCookie("fee_status");
            var _loc_2:* = Utils.getBrowserCookie("fee_ifox");
            var _loc_3:* = _loc_1 != "" || _loc_2 != "" && P2PExplorer.getInstance().hasP2P ? ("&vu=" + (_loc_1 != "" ? (_loc_1) : (_loc_2))) : ("");
            var _loc_4:* = this.randRange(0, 127);
            var _loc_5:* = "&vid=" + PlayerConfig.vid + "&uid=" + PlayerConfig.userId + "&fee=" + (PlayerConfig.isFee ? ("1") : ("0")) + _loc_3 + "&pageUrl=" + escape(PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl)));
            this._paramStr = this._xxtea.NetEncrypt(_loc_5, _loc_4) + "_" + _loc_4;
            return;
        }// end function

        private function randRange(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
            return _loc_3;
        }// end function

        private function update56Ver() : void
        {
            switch(PlayerConfig.rfilesType)
            {
                case "super":
                {
                    this._is56HD = "21";
                    break;
                }
                case "clear":
                {
                    this._is56HD = "1";
                    break;
                }
                case "normal":
                {
                    this._is56HD = "2";
                    break;
                }
                case "wvga":
                {
                    this._is56HD = "21";
                    break;
                }
                case "vga":
                {
                    this._is56HD = "1";
                    break;
                }
                case "qvga":
                {
                    this._is56HD = "2";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function set ifltype(param1:String) : void
        {
            this._ifltype = param1;
            return;
        }// end function

        public function get ifltype() : String
        {
            return this._ifltype;
        }// end function

        public function get paramStr() : String
        {
            return this._paramStr;
        }// end function

        public static function getInstance() : InforSender
        {
            if (InforSender.singleton == null)
            {
                InforSender.singleton = new InforSender;
            }
            return InforSender.singleton;
        }// end function

    }
}
