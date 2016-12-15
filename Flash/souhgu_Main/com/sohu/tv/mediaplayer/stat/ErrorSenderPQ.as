package com.sohu.tv.mediaplayer.stat
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.ads.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.ui.*;
    import ebing.*;
    import ebing.external.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;

    public class ErrorSenderPQ extends EventDispatcher
    {
        private var _isSentDefPause:Boolean = false;
        private var _playCount:String = "";
        private var _intervalBufferNum:uint = 0;
        private var _qfltype:String = "";
        private var _loader:URLLoader;
        private var _is56HD:String = "0";
        public static var singleton:ErrorSenderPQ;
        public static var STAT_IP_ID:int = Math.round(Math.random() * 10) % PlayerConfig.STAT_IP.length;
        public static var STAT_IP_QFCLIPS_ID:int = Math.round(Math.random() * 10) % PlayerConfig.STAT_IP_QFCLIPS.length;
        public static const FEEDBACK_PATH:String = "http://feedback.vrs.sohu.com/feedback.html?type=q4";

        public function ErrorSenderPQ() : void
        {
            return;
        }// end function

        public function sendPQStat(param1:Object = null) : void
        {
            return;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:URLVariables = null;
            var _loc_7:Array = null;
            var _loc_8:URLRequest = null;
            var _loc_9:Array = null;
            var _loc_10:int = 0;
            var _loc_11:Array = null;
            var _loc_12:String = null;
            var _loc_13:uint = 0;
            var _loc_14:URLRequest = null;
            var _loc_15:String = null;
            var _loc_16:String = null;
            var _loc_17:String = null;
            var _loc_18:String = null;
            var _loc_19:String = null;
            var _loc_20:String = null;
            var _loc_21:String = null;
            var _loc_22:String = null;
            var _loc_23:URLRequest = null;
            if (PlayerConfig.isPreview)
            {
                return;
            }
            if (PlayerConfig.is56)
            {
                this.update56Ver();
            }
            if (param1 != null)
            {
                _loc_2 = PlayerConfig.STAT_IP[STAT_IP_ID];
                _loc_3 = "http://" + _loc_2 + "/dov.do";
                _loc_4 = PlayerConfig.STAT_IP_QFCLIPS[STAT_IP_QFCLIPS_ID];
                _loc_5 = "http://" + _loc_4 + "/dov.do";
                _loc_6 = new URLVariables();
                _loc_6.method = "stat";
                _loc_6.t = new Date().getTime();
                _loc_6.uid = PlayerConfig.userId;
                _loc_6.vid = PlayerConfig.vid;
                _loc_6.tvid = PlayerConfig.tvid;
                _loc_6.nid = PlayerConfig.nid;
                _loc_6.pid = PlayerConfig.pid;
                _loc_6.sid = PlayerConfig.sid != null && PlayerConfig.sid != "" && PlayerConfig.sid != "null" ? (PlayerConfig.sid) : ("0");
                _loc_6.uuid = PlayerConfig.uuid;
                _loc_6.cid = PlayerConfig.cid;
                _loc_6.type = PlayerConfig.isTransition ? ("vms1") : (!PlayerConfig.isLongVideo ? ("vms2") : (PlayerConfig.isMyTvVideo ? ("my") : ("vrs")));
                _loc_6.isHD = PlayerConfig.is56 ? (this._is56HD) : (PlayerConfig.isHd ? (PlayerConfig.videoVersion) : ("0"));
                _loc_6.vt = PlayerConfig.viewTime;
                _loc_6.totTime = PlayerConfig.totalDuration;
                _loc_6.out = PlayerConfig.domainProperty;
                _loc_6.stvMode = PlayerConfig.availableStvd && PlayerConfig.stvdInUse ? ("1") : ("0");
                if (PlayerConfig.gslbWay != "")
                {
                    _loc_9 = PlayerConfig.gslbWay.split("&");
                    _loc_10 = 0;
                    while (_loc_10 < _loc_9.length)
                    {
                        
                        if (_loc_9[_loc_10] != "")
                        {
                            _loc_11 = _loc_9[_loc_10].split("=");
                            if (_loc_11.length > 1)
                            {
                                _loc_6[_loc_11[0]] = _loc_11[1];
                            }
                        }
                        _loc_10++;
                    }
                }
                if (param1.error != null && param1.error == PlayerConfig.VINFO_ERROR_12)
                {
                    _loc_6.vinfoErr = 2;
                }
                if (PlayerConfig.pub_catecode != null && PlayerConfig.pub_catecode != "")
                {
                    _loc_6.pub_catecode = PlayerConfig.pub_catecode;
                }
                if (PlayerConfig.ch_key != null && PlayerConfig.ch_key != "")
                {
                    _loc_6.ch_key = PlayerConfig.ch_key;
                }
                if (PlayerConfig.cdnId != "")
                {
                    _loc_6.cdnid = PlayerConfig.cdnId;
                }
                if (PlayerConfig.cdnIp != "")
                {
                    _loc_6.cdnip = PlayerConfig.cdnIp;
                }
                if (PlayerConfig.clientIp != "")
                {
                    _loc_6.clientIp = PlayerConfig.clientIp;
                }
                if (PlayerConfig.vrsPlayListId != "")
                {
                    _loc_6.playerListId = PlayerConfig.vrsPlayListId;
                }
                if (PlayerConfig.isForbidP2P != "")
                {
                    _loc_6.FP2P = PlayerConfig.isForbidP2P;
                }
                if (PlayerConfig.gslbErrorIp != "")
                {
                    _loc_6.gslbErrIp = PlayerConfig.gslbErrorIp;
                }
                if (PlayerConfig.caid != "")
                {
                    _loc_6.caid = PlayerConfig.caid;
                }
                if (PlayerConfig.userAgent == "sh")
                {
                    if (PlayerConfig.SOHUTEST)
                    {
                        _loc_6.ua = "sohutest";
                    }
                    else
                    {
                        _loc_6.ua = "sh";
                    }
                }
                if (PlayerConfig.ifoxInfoObj != null && PlayerConfig.ifoxInfoObj != "")
                {
                    if (PlayerConfig.ifoxInfoObj.ifoxVer != "")
                    {
                        _loc_6.v = PlayerConfig.ifoxInfoObj.ifoxVer;
                    }
                    if (PlayerConfig.ifoxInfoObj.ifoxUid != "")
                    {
                        _loc_6.iuid = PlayerConfig.ifoxInfoObj.ifoxUid;
                    }
                    if (PlayerConfig.ifoxInfoObj.ifoxCh != "")
                    {
                        _loc_6.ChannelID = PlayerConfig.ifoxInfoObj.ifoxCh;
                    }
                }
                _loc_6.ref = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
                _loc_6.pver = escape(PlayerConfig.flashVersion);
                _loc_6.fver = PlayerConfig.VERSION;
                _loc_7 = PlayerConfig.swfHost.split("/");
                _loc_6.pdir = _loc_7[_loc_7.length - 2];
                _loc_6.code = param1.code;
                if (PlayerConfig.lqd != "")
                {
                    _loc_6.oth = PlayerConfig.lqd;
                }
                if (PlayerConfig.lcode != "")
                {
                    _loc_6.cd = PlayerConfig.lcode;
                }
                _loc_6.sz = PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight;
                _loc_6.md = PlayerConfig.qsMd;
                if (PlayerConfig.ugu != "")
                {
                    _loc_6.ugu = PlayerConfig.ugu;
                }
                if (PlayerConfig.ugcode != "")
                {
                    _loc_6.ugcode = PlayerConfig.ugcode;
                }
                if (param1.all700no != null)
                {
                    _loc_6.all700no = param1.all700no;
                }
                if (param1.allno != null)
                {
                    _loc_6.allno = param1.allno;
                }
                if (param1.errno != null)
                {
                    _loc_6.errno = param1.errno;
                }
                if (param1.bufno != null)
                {
                    _loc_6.bufno = param1.bufno;
                }
                if (param1.allbufno != null)
                {
                    _loc_6.allbufno = param1.allbufno;
                }
                if (param1.dom != null)
                {
                    _loc_6.dom = escape(param1.dom);
                }
                if (param1.split != null)
                {
                    _loc_6.split = param1.split;
                }
                if (param1.drag != null && Number(param1.drag) > 0)
                {
                    _loc_6.drag = param1.drag;
                }
                else
                {
                    _loc_6.drag = "-1";
                }
                if (param1.error != null)
                {
                    _loc_6.error = param1.error;
                }
                if (param1.adt != null)
                {
                    _loc_6.adt = param1.adt;
                }
                if (param1.alt != null)
                {
                    _loc_6.alt = param1.alt;
                }
                if (param1.apt != null)
                {
                    _loc_6.apt = param1.apt;
                }
                if (param1.slt != null)
                {
                    _loc_6.slt = param1.slt;
                }
                if (param1.rpt != null)
                {
                    _loc_6.rpt = param1.rpt;
                }
                if (param1.aps != null)
                {
                    _loc_6.aps = param1.aps;
                }
                if (param1.isp2p != null)
                {
                    _loc_6.isp2p = param1.isp2p;
                }
                if (param1.bd != null)
                {
                    _loc_6.bd = param1.bd;
                }
                if (param1.isped)
                {
                    _loc_6.isped = param1.isped;
                }
                if (param1.fbt)
                {
                    _loc_6.fbt = param1.fbt;
                }
                if (param1.utime != null)
                {
                    _loc_6.utime = param1.utime;
                }
                if (param1.ontime != null)
                {
                    _loc_6.ontime = param1.ontime;
                }
                if (PlayerConfig.isLive)
                {
                    _loc_6.pt = "5";
                }
                else if (PlayerConfig.isFms)
                {
                    _loc_6.pt = "2";
                }
                else if (PlayerConfig.isAlbumVideo)
                {
                    _loc_6.pt = "22";
                }
                else
                {
                    _loc_6.pt = "1";
                }
                if (PlayerConfig.isWebP2p && !PlayerConfig.isLive)
                {
                    if (PlayerConfig.SOHUTEST)
                    {
                        _loc_6.pt = "99";
                    }
                    else
                    {
                        _loc_6.pt = "16";
                    }
                }
                if (PlayerConfig.is56)
                {
                    _loc_6.is56 = "1";
                    _loc_6.pt = "560";
                    _loc_6.split = "1";
                }
                _loc_6.fms = PlayerConfig.isFms ? ("1") : ("0");
                if (param1.mycode != null)
                {
                    _loc_6.mycode = param1.mycode;
                }
                if (param1.vvmark != null)
                {
                    _loc_6.vvmark = param1.vvmark;
                    if (param1.isClipsVV != null && param1.isClipsVV == true)
                    {
                    }
                    else
                    {
                        if (param1.code == PlayerConfig.VINFO_CODE && param1.error != 0)
                        {
                            if (PlayerConfig.otherInforSender == "")
                            {
                                InforSender.getInstance().sendMesg(InforSender.START, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", param1.error);
                                InforSender.getInstance().sendIRS();
                            }
                        }
                        else if (PlayerConfig.otherInforSender == "")
                        {
                            InforSender.getInstance().sendMesg(InforSender.START, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif");
                            InforSender.getInstance().sendIRS();
                        }
                        if (PlayerConfig.isMyTvVideo)
                        {
                            _loc_12 = "";
                            if (Model.getInstance().videoInfo != null && Model.getInstance().videoInfo.status != null && Model.getInstance().videoInfo.status != "" && Model.getInstance().videoInfo.status == 12)
                            {
                                _loc_12 = "&status=" + Model.getInstance().videoInfo.status;
                            }
                            new URLLoaderUtil().send("http://vstat.v.blog.sohu.com/dostat.do?method=setVideoPlayCount&v=" + PlayerConfig.vid + _loc_12 + "&playlistId=" + PlayerConfig.vrsPlayListId + "&c=" + PlayerConfig.cid + "&vc=" + encodeURIComponent(PlayerConfig.catcode) + "&uid=" + PlayerConfig.userId + "&plat=" + (PlayerConfig.domainProperty == "3" ? ("flash_56") : ("flash")) + "&os=" + Utils.cleanTrim(Capabilities.os) + "&online=0" + "&type=" + _loc_6.type + "&o=" + PlayerConfig.myTvUserId + "&r=" + (PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl))) + "&time=" + new Date().getTime());
                        }
                    }
                    if (PlayerConfig.playOrder != "")
                    {
                        new URLLoaderUtil().send("http://secure-cn.imrworldwide.com/cgi-bin/m?ci=cn-sohu&cg=0&cc=1&si=sohu2011/" + PlayerConfig.vrsPlayListId + "/" + PlayerConfig.playOrder + "/imp");
                    }
                }
                if (param1.datarate != null)
                {
                    _loc_6.datarate = param1.datarate;
                }
                if (param1.isdl != null)
                {
                    _loc_6.isdl = param1.isdl;
                }
                if (param1.code == PlayerConfig.BUFFER_CODE)
                {
                    var _loc_24:String = this;
                    var _loc_25:* = this._intervalBufferNum + 1;
                    _loc_24._intervalBufferNum = _loc_25;
                }
                switch(param1.code)
                {
                    case PlayerConfig.VINFO_CODE:
                    {
                        _loc_13 = 0;
                        if (PlayerConfig.tempParam)
                        {
                            _loc_13 = 0;
                            PlayerConfig.tempParam = false;
                        }
                        else
                        {
                            _loc_13 = PlayerConfig.seekTo;
                        }
                        _loc_6.seekto = _loc_13;
                        _loc_6.def = PlayerConfig.definition;
                        _loc_6.isp2p = P2PExplorer.getInstance().hasP2P ? (PlayerConfig.gslbErrorIp != "" ? (0) : (1)) : (0);
                        _loc_6.os = escape(Capabilities.os);
                        if (!this._isSentDefPause)
                        {
                            this._isSentDefPause = true;
                            _loc_6.autoPlay = PlayerConfig.autoPlay ? ("1") : ("0");
                            if (Model.getInstance().videoInfo != null && Model.getInstance().videoInfo.status != null && Model.getInstance().videoInfo.status != "" && Model.getInstance().videoInfo.status != 3)
                            {
                                this.sendAndLoadPlayCount();
                            }
                        }
                        break;
                    }
                    case PlayerConfig.BUFFER_CODE:
                    {
                        if (param1.allbufno == 15)
                        {
                            this.sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"player", code:PlayerConfig.BUFFER_CODE, error:param1.error, debuginfo:"主播放器日志：" + LogManager.getMsg() + "|p2p日志：" + P2pLog.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
                        }
                        break;
                    }
                    case PlayerConfig.CDN_CODE:
                    {
                        if (param1.error != 0)
                        {
                            this.sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"player", code:PlayerConfig.CDN_CODE, error:param1.error, debuginfo:"主播放器日志：" + LogManager.getMsg() + "|p2p日志：" + P2pLog.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
                        }
                        break;
                    }
                    case PlayerConfig.GSLB_CODE:
                    {
                        if (param1.error != 0)
                        {
                            this.sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"player", code:PlayerConfig.GSLB_CODE, error:param1.error, debuginfo:"主播放器日志：" + LogManager.getMsg() + "|p2p日志：" + P2pLog.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (param1.isClipsVV != null && param1.isClipsVV == true && !PlayerConfig.isLive)
                {
                    _loc_3 = _loc_5;
                }
                else if (!PlayerConfig.isFms && !PlayerConfig.isLive && (param1.code == PlayerConfig.CDN_CODE || param1.code == PlayerConfig.GSLB_CODE || param1.code == PlayerConfig.BUFFER_CODE))
                {
                    _loc_14 = new URLRequest(_loc_5);
                    _loc_14.method = URLRequestMethod.GET;
                    _loc_14.data = _loc_6;
                    if (param1.code == PlayerConfig.BUFFER_CODE && param1.bufno != null && param1.bufno != 1 && param1.bufno != 4)
                    {
                    }
                    else if (!PlayerConfig.ISTEST || PlayerConfig.ISTEST && (PlayerConfig.currentVid == "717990" || PlayerConfig.currentVid == "1782553" || PlayerConfig.currentVid == "1710392"))
                    {
                        sendToURL(_loc_14);
                    }
                }
                _loc_8 = new URLRequest(_loc_3);
                if (param1.code == PlayerConfig.VINFO_CODE && param1.error == PlayerConfig.VINFO_ERROR_1)
                {
                    _loc_8.method = URLRequestMethod.POST;
                    if (param1.vrsdata != null)
                    {
                        _loc_6.vrsdata = param1.vrsdata;
                    }
                    if (param1.pagehtml != null)
                    {
                        _loc_6.pagehtml = param1.pagehtml;
                    }
                    if (param1.vid != null)
                    {
                        _loc_6.vid = param1.vid;
                    }
                }
                else
                {
                    _loc_8.method = URLRequestMethod.GET;
                }
                _loc_8.data = _loc_6;
                if (param1.code == PlayerConfig.BUFFER_CODE && param1.allbufno != null && param1.allbufno != 1 && param1.allbufno != 4)
                {
                }
                else if (!PlayerConfig.ISTEST || PlayerConfig.ISTEST && (PlayerConfig.currentVid == "717990" || PlayerConfig.currentVid == "1782553" || PlayerConfig.currentVid == "1710392"))
                {
                    sendToURL(_loc_8);
                }
                if (param1.code == PlayerConfig.VINFO_CODE)
                {
                    _loc_15 = "1";
                    _loc_16 = "7395122";
                    _loc_17 = "";
                    _loc_18 = "";
                    _loc_19 = "";
                    _loc_20 = PlayerConfig.isLive ? ("live_show") : ("");
                    _loc_21 = PlayerConfig.userId;
                    _loc_22 = new Array("c1=", _loc_15, "&c2=", _loc_16, "&c3=", _loc_17, "&c4=", _loc_18, "&c5=", _loc_19, "&c6=", _loc_20, "&c11=", _loc_21).join("");
                    _loc_23 = new URLRequest("http://b.scorecardresearch.com/b?" + _loc_22);
                    sendToURL(_loc_23);
                }
            }
            return;
        }// end function

        public function sendDebugInfo(param1:Object) : void
        {
            return;
            var _loc_2:Object = {type:param1.type, code:param1.code, error:param1.error, debuginfo:param1.debuginfo, uid:param1.uid, sid:param1.sid, time:param1.time};
            new URLLoaderUtil().send(param1.url, {method:"POST", dataType:"u", data:_loc_2});
            return;
        }// end function

        public function sendFeedback() : void
        {
            return;
            var _loc_1:String = "http://feedback.vrs.sohu.com/uploadLog.html";
            var _loc_2:* = new URLRequest(_loc_1);
            this._loader = new URLLoader();
            _loc_2.method = URLRequestMethod.POST;
            var _loc_3:* = new URLVariables();
            _loc_3.log = encodeURIComponent("主播放器日志：" + LogManager.getMsg() + "广告日志：" + AdLog.getMsg());
            _loc_2.data = _loc_3;
            this._loader.addEventListener(Event.COMPLETE, this.loaderComplete);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.loaderIoError);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderSecurityError);
            this._loader.load(_loc_2);
            return;
        }// end function

        private function loaderComplete(event:Event) : void
        {
            var _loc_2:* = new JSON().parse(event.target.data);
            if (_loc_2.status == 1 && _loc_2.logId != null && _loc_2.logId != "")
            {
                this.openWindow(FEEDBACK_PATH + "&logId=" + _loc_2.logId);
            }
            else
            {
                this.openWindow(FEEDBACK_PATH);
            }
            return;
        }// end function

        private function loaderIoError(event:Event) : void
        {
            this.openWindow(FEEDBACK_PATH);
            return;
        }// end function

        private function loaderSecurityError(event:Event) : void
        {
            this.openWindow(FEEDBACK_PATH);
            return;
        }// end function

        private function openWindow(param1:String) : void
        {
            return;
            var _loc_2:URLRequest = null;
            if (!Eif.available)
            {
                Utils.openWindow(param1, "_blank");
            }
            else
            {
                _loc_2 = new URLRequest(param1);
                navigateToURL(_loc_2, "_blank");
            }
            return;
        }// end function

        private function sendAndLoadPlayCount() : void
        {
            return;
            var enc:String;
            var isHdVid:Boolean;
            var tArr:Array;
            var _xxtea:XXTEA;
            var currTime:Number;
            if (!PlayerConfig.isTransition && !PlayerConfig.isMyTvVideo && !PlayerConfig.isLive && !PlayerConfig.is56)
            {
                enc;
                if (PlayerConfig.isLpc && PlayerConfig.hotVrSyst != "")
                {
                    tArr = PlayerConfig.hotVrSyst.split("&m=");
                    if (!PlayerConfig.autoPlay)
                    {
                        currTime = new Date().getTime();
                        tArr[0] = String(Number(tArr[0]) + Math.abs(currTime - Number(tArr[1])));
                    }
                    _xxtea = new XXTEA();
                    enc = "&enc=" + encodeURIComponent(_xxtea.NetEncrypt("syst=" + tArr[0], int(Number(PlayerConfig.tvid) % 127)));
                }
                isHdVid = this._qfltype != "" && !PlayerConfig.isLive && PlayerConfig.hdVid != "" ? (true) : (false);
                new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    _playCount = param1.data;
                }
                return;
            }// end function
            , "http://count.vrs.sohu.com/count/stat.do?videoId=" + (isHdVid ? (PlayerConfig.hdVid) : (PlayerConfig.vid)) + "&tvid=" + PlayerConfig.tvid + (Model.getInstance().videoInfo.status == 12 ? ("&status=12") : ("")) + "&playlistId=" + PlayerConfig.vrsPlayListId + "&categoryId=" + PlayerConfig.caid + "&catecode=" + encodeURIComponent(PlayerConfig.catcode) + "&uid=" + PlayerConfig.userId + "&plat=flash" + "&os=" + Utils.cleanTrim(Capabilities.os) + "&online=0" + "&type=" + (PlayerConfig.isMyTvVideo ? ("my") : (PlayerConfig.isTransition || !PlayerConfig.isLongVideo ? ("vms") : ("vrs"))) + "&r=" + (PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl))) + "&t=" + (new Date().getTime() + Math.random()) + enc);
            }
            return;
        }// end function

        public function liveHeart(param1:String, param2:uint, param3:uint) : void
        {
            var _loc_8:String = null;
            var _loc_9:String = null;
            var _loc_4:String = "";
            if (PlayerConfig.isP2PLive)
            {
                _loc_8 = Eif.available && ExternalInterface.call("sohuHD.ifox.getVersion") != undefined ? ("&v=" + ExternalInterface.call("sohuHD.ifox.getVersion")) : ("");
                _loc_9 = Eif.available && ExternalInterface.call("sohuHD.ifox.getChannelNum") != undefined ? ("&channel=" + ExternalInterface.call("sohuHD.ifox.getChannelNum")) : ("");
                _loc_4 = "&xx=" + param2 + "&tvFileId=" + param1 + "&qmbn=" + param3 + _loc_8 + _loc_9;
            }
            var _loc_5:* = PlayerConfig.STAT_IP[STAT_IP_ID];
            var _loc_6:* = "http://" + _loc_5 + "/heart.do";
            var _loc_7:String = "http://114.80.179.90:8080/heart.do";
            new URLLoaderUtil().send(_loc_6 + "?code=1&uid=" + PlayerConfig.userId + "&lid=" + PlayerConfig.vid + "&buf=" + this._intervalBufferNum + _loc_4 + "&t=" + (new Date().getTime() + Math.random()));
            new URLLoaderUtil().send(_loc_7 + "?code=1&uid=" + PlayerConfig.userId + "&lid=" + PlayerConfig.vid + "&buf=" + this._intervalBufferNum + _loc_4 + "&t=" + (new Date().getTime() + Math.random()));
            this._intervalBufferNum = 0;
            return;
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

        public function getPlayCount() : String
        {
            return this._playCount;
        }// end function

        public function set isSentDefPause(param1:Boolean) : void
        {
            this._isSentDefPause = param1;
            return;
        }// end function

        public function set qfltype(param1:String) : void
        {
            this._qfltype = param1;
            return;
        }// end function

        public function get qfltype() : String
        {
            return this._qfltype;
        }// end function

        public static function getInstance() : ErrorSenderPQ
        {
            if (ErrorSenderPQ.singleton == null)
            {
                ErrorSenderPQ.singleton = new ErrorSenderPQ;
            }
            return ErrorSenderPQ.singleton;
        }// end function

    }
}
