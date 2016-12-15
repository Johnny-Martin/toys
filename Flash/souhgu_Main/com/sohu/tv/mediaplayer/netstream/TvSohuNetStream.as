package com.sohu.tv.mediaplayer.netstream
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.external.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class TvSohuNetStream extends NetStreamUtil
    {
        protected var _cdn301TimeLimit:int = 15;
        protected var _cdn200TimeLimit:int = 10;
        protected var _p2pTimeLimit:int = 20;
        protected var _cdnTimeoutId:Number = 0;
        protected var _cdnIP:String = "";
        protected var _cdnID:String = "";
        protected var _errCdnIds:Array;
        protected var _hasP2P:Boolean = false;
        protected var _urlloader:URLLoaderUtil;
        protected var _isnp:Boolean = false;
        protected var _isWriteLog:Boolean = false;
        protected var _smallSuppliers:Boolean = false;
        protected var _changeGSLBIP:Boolean = false;
        protected var _ipTime:int = 0;
        protected var _cdnNt:String = "";
        protected var _cdnArea:String = "";

        public function TvSohuNetStream(param1:NetConnection, param2:Boolean = false, param3:Boolean = false)
        {
            var connection:* = param1;
            var is200:* = param2;
            var isWriteLog:* = param3;
            this._errCdnIds = new Array();
            this._urlloader = new URLLoaderUtil();
            this._isWriteLog = isWriteLog;
            if (Eif.available)
            {
                ExternalInterface.addCallback("playUrlForXL", function (param1:String) : void
            {
                doPlay(param1);
                return;
            }// end function
            );
            }
            super(connection, is200);
            return;
        }// end function

        override public function play(... args) : void
        {
            args = new activation;
            var p:URLVariables;
            var arguments:* = args;
            _isPlay = true;
            _gslbUrl = [0];
            try
            {
                p = new URLVariables(_gslbUrl.split("?")[1]);
                _dragTime = start != undefined ? (Number(start)) : (_dragTime);
            }
            catch (evt:Error)
            {
                _dragTime = 0;
            }
            this.checkP2P();
            return;
        }// end function

        private function ttt() : void
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:String = null;
            var _loc_9:String = null;
            var _loc_10:uint = 0;
            var _loc_11:String = null;
            var _loc_12:String = null;
            var _loc_13:uint = 0;
            var _loc_14:Array = null;
            var _loc_15:Array = null;
            var _loc_16:Boolean = false;
            var _loc_1:* = _gslbUrl.split("?").length > 1;
            var _loc_2:* = (PlayerConfig.lqd != "" ? ("&oth=" + PlayerConfig.lqd) : ("")) + (PlayerConfig.lcode != "" ? ("&cd=" + PlayerConfig.lcode) : ("")) + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.cdnMd + (PlayerConfig.ugu != "" ? ("&ugu=" + PlayerConfig.ugu) : ("")) + (PlayerConfig.ugcode != "" ? ("&ugcode=" + PlayerConfig.ugcode) : (""));
            if (this._hasP2P)
            {
                _loc_3 = PlayerConfig.synUrl != null && PlayerConfig.synUrl[_clipNo] != null && PlayerConfig.synUrl[_clipNo] != "" ? ("&new=" + PlayerConfig.synUrl[_clipNo]) : ("");
                _loc_4 = PlayerConfig.p2pTNum > 0 ? ("&cdn=" + String(PlayerConfig.p2pTNum)) : ("");
                _loc_5 = PlayerConfig.p2pSP > 0 ? ("&sp=" + PlayerConfig.p2pSP) : ("");
                _loc_6 = PlayerConfig.area != "" ? ("&area=" + PlayerConfig.area) : ("");
                _loc_7 = PlayerConfig.isp != "" ? ("&isp=" + PlayerConfig.isp) : ("");
                _loc_8 = PlayerConfig.userId != "" ? ("&uid=" + PlayerConfig.userId) : ("");
                _loc_9 = PlayerConfig.ta_jm != "" ? ("&ta=" + escape(PlayerConfig.ta_jm)) : ("");
                if (PlayerConfig.videoArr != null && PlayerConfig.videoArr.length > _clipNo)
                {
                    _loc_13 = 0;
                    while (_loc_13 < _clipNo)
                    {
                        
                        _loc_10 = _loc_10 + PlayerConfig.videoArr[_loc_13].time;
                        _loc_13 = _loc_13 + 1;
                    }
                }
                _loc_11 = "";
                if (PlayerConfig.isMyTvVideo)
                {
                    _loc_14 = _gslbUrl.split("/");
                    if (_loc_14.length > 1)
                    {
                        _loc_11 = PlayerConfig.gslbIp + _gslbUrl.substr(_gslbUrl.indexOf("/"), _gslbUrl.length);
                    }
                    else
                    {
                        _loc_11 = PlayerConfig.gslbIp + _gslbUrl;
                    }
                }
                else
                {
                    _loc_11 = _gslbUrl.replace("http://data.vod.itc.cn", PlayerConfig.gslbIp);
                }
                _loc_12 = PlayerConfig.CHECKP2PPATH + _loc_11 + (_loc_1 ? ("&") : ("?")) + "vid=" + PlayerConfig.currentVid + "&tvid=" + PlayerConfig.tvid + "&uuid=" + PlayerConfig.uuid + "&hashid=" + PlayerConfig.hashId[_clipNo] + "&key=" + PlayerConfig.key[_clipNo] + "&num=" + (_clipNo + 1) + "&pnum=" + String(PlayerConfig.playingSplit) + "&dnum=" + String(_clipNo) + "&ptime=" + (_dragTime == 0 ? (PlayerConfig.playedTime) : (_loc_10)) + "&dtime=" + _loc_10 + "&p2pflag=" + String(PlayerConfig.p2pflag) + "&size=" + PlayerConfig.fileSize[_clipNo] + _loc_4 + _loc_3 + _loc_5 + _loc_6 + _loc_7 + _loc_8 + _loc_9 + _loc_2 + (PlayerConfig.bfd != null && PlayerConfig.bfd[_clipNo] != "" ? ("&bfd=" + PlayerConfig.bfd[_clipNo]) : ("")) + (PlayerConfig.isLive && PlayerConfig.isP2PLive ? ("&liveid=" + PlayerConfig.vid) : ("")) + "&fname=" + PlayerConfig.videoTitle + "&r=" + (new Date().getTime() + Math.random());
                PlayerConfig.allotip = PlayerConfig.gslbIp;
                _gslbUrl = _loc_12;
                this.doPlay(_gslbUrl);
            }
            else if (_is200)
            {
                this.loadLocationAndPlay();
            }
            else
            {
                _loc_15 = _gslbUrl.split("data.vod.itc.cn");
                if (PlayerConfig.synUrl != null && PlayerConfig.synUrl.length > _clipNo && PlayerConfig.synUrl[_clipNo] != "")
                {
                    _gslbUrl = _gslbUrl + (_loc_1 ? ("&") : ("?"));
                    _gslbUrl = _gslbUrl + ("new=" + PlayerConfig.synUrl[_clipNo]);
                }
                if (_loc_15.length <= 1)
                {
                    _gslbUrl = "http://" + (PlayerConfig.gslbIp != "" ? (PlayerConfig.gslbIp + "/") : ("")) + _gslbUrl;
                }
                else if (PlayerConfig.gslbIp != "")
                {
                    _gslbUrl = _gslbUrl.replace("data.vod.itc.cn", PlayerConfig.gslbIp);
                }
                _loc_16 = _gslbUrl.split("?").length > 1;
                _gslbUrl = _gslbUrl + ((_loc_16 ? ("&") : ("?")) + (PlayerConfig.currentVid != "" ? ("vid=" + PlayerConfig.currentVid) : ("")) + "&tvid=" + PlayerConfig.tvid + (PlayerConfig.userId != "" ? ("&uid=" + PlayerConfig.userId) : ("")) + (PlayerConfig.ta_jm != "" ? ("&ta=" + escape(PlayerConfig.ta_jm)) : ("")) + _loc_2 + (PlayerConfig.bfd != null && PlayerConfig.bfd[_clipNo] != "" ? ("&bfd=" + PlayerConfig.bfd[_clipNo]) : ("")));
                PlayerConfig.allotip = PlayerConfig.gslbIp;
                if (this._isWriteLog)
                {
                    LogManager.msg("段号：" + _clipNo + " 调度地址：" + _gslbUrl + " 方式：301");
                }
                this.doPlay(_gslbUrl);
            }
            return;
        }// end function

        private function checkP2P() : void
        {
            if (PlayerConfig.gslbErrorIp == "")
            {
                if (PlayerConfig.isForbidP2P != "1")
                {
                    if (P2PExplorer.getInstance().hasP2P)
                    {
                        if (PlayerConfig.hashId != null && PlayerConfig.hashId[_clipNo] != "" && PlayerConfig.synUrl != null && PlayerConfig.synUrl[_clipNo] != "")
                        {
                            if (!PlayerConfig.isUgcFeeVideo)
                            {
                                try
                                {
                                    new URLLoaderUtil().load(1, this.handshakeReport, PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
                                }
                                catch (evt:ErrorEvent)
                                {
                                    _hasP2P = false;
                                }
                            }
                            else
                            {
                                this.handshakeReport({info:"isUgcFeeVideo"});
                            }
                        }
                        else
                        {
                            this.handshakeReport({info:"hashIdOrNewPathError"});
                        }
                    }
                    else
                    {
                        this.handshakeReport({info:"nop2p"});
                    }
                }
                else
                {
                    this.handshakeReport({info:"forbidP2P"});
                }
            }
            else
            {
                this.handshakeReport({info:"gslbIpError"});
            }
            return;
        }// end function

        private function handshakeReport(param1:Object) : void
        {
            if (param1.info == "success")
            {
                this._hasP2P = true;
                if (this._isWriteLog)
                {
                    LogManager.msg("段号：" + _clipNo + " P2P握手成功！握手地址：" + param1.target.url);
                }
            }
            else
            {
                this._hasP2P = false;
                if (this._isWriteLog)
                {
                    LogManager.msg("段号：" + _clipNo + " P2P握手失败！失败原因：" + param1.info + (param1.info != "hashIdOrNewPathError" && param1.info != "forbidP2P" && param1.info != "gslbIpError" && param1.info != "nop2p" && param1.info != "liveMode" && param1.info != "isUgcFeeVideo" ? (" 握手地址：" + param1.target.url) : ("")));
                }
            }
            this.ttt();
            return;
        }// end function

        override protected function doPlay(param1:String) : void
        {
            var url:* = param1;
            super.checkPolicyFile = true;
            this._isnp = true;
            var boo:* = url.split("?").length > 1;
            var vid:* = PlayerConfig.currentVid != "" ? ("&vid=" + PlayerConfig.currentVid) : ("");
            var uid:* = PlayerConfig.userId != "" ? ("&uid=" + PlayerConfig.userId) : ("");
            var ta:* = PlayerConfig.ta_jm != "" ? ("&ta=" + escape(PlayerConfig.ta_jm)) : ("");
            var plat:String;
            var otherParameters:String;
            var newInfoStr:* = (PlayerConfig.lqd != "" ? ("&oth=" + PlayerConfig.lqd) : ("")) + (PlayerConfig.lcode != "" ? ("&cd=" + PlayerConfig.lcode) : ("")) + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.cdnMd + (PlayerConfig.ugu != "" ? ("&ugu=" + PlayerConfig.ugu) : ("")) + (PlayerConfig.ugcode != "" ? ("&ugcode=" + PlayerConfig.ugcode) : (""));
            if (this._hasP2P || !_is200)
            {
                plat = "&plat=" + escape(Utils.cleanTrim("flash_" + Capabilities.os + "_ifox"));
            }
            else
            {
                plat = "&plat=" + escape(Utils.cleanTrim("flash_" + Capabilities.os));
                otherParameters = vid + "&tvid=" + PlayerConfig.tvid + uid + ta + newInfoStr;
            }
            var tempid:String;
            var cc:* = String(PlayerConfig.catcode).substr(0, 3);
            if (cc == "115" || cc == "106" || cc == "100")
            {
                tempid = "&tempid=" + cc;
            }
            if (boo)
            {
                url = url + "&ua=" + PlayerConfig.userAgent + (PlayerConfig.channel != "" ? ("&ch=" + PlayerConfig.channel) : ("")) + (PlayerConfig.catcode != "" ? ("&catcode=" + PlayerConfig.catcode) : ("")) + (PlayerConfig.vrsPlayListId != "" && PlayerConfig.isSendPID ? ("&pid=" + PlayerConfig.vrsPlayListId) : ("")) + tempid + (PlayerConfig.isUgcFeeVideo ? ("&pg=4") : ("")) + "&prod=flash&pt=1" + plat + (this._cdnNt != "" ? ("&n=" + this._cdnNt) : ("")) + (this._cdnArea != "" ? ("&a=" + this._cdnArea) : ("")) + (PlayerConfig.clientIp != "" ? ("&cip=" + PlayerConfig.clientIp) : ("")) + otherParameters + "&uuid=" + PlayerConfig.uuid + "&url=" + (PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl)));
            }
            else
            {
                url = url + "?ua=" + PlayerConfig.userAgent + (PlayerConfig.channel != "" ? ("&ch=" + PlayerConfig.channel) : ("")) + (PlayerConfig.catcode != "" ? ("&catcode=" + PlayerConfig.catcode) : ("")) + (PlayerConfig.vrsPlayListId != "" && PlayerConfig.isSendPID ? ("&pid=" + PlayerConfig.vrsPlayListId) : ("")) + tempid + (PlayerConfig.isUgcFeeVideo ? ("&pg=4") : ("")) + "&prod=flash&pt=1" + plat + (this._cdnNt != "" ? ("&n=" + this._cdnNt) : ("")) + (this._cdnArea != "" ? ("&a=" + this._cdnArea) : ("")) + (PlayerConfig.clientIp != "" ? ("&cip=" + PlayerConfig.clientIp) : ("")) + otherParameters + "&uuid=" + PlayerConfig.uuid + "&url=" + (PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl)));
            }
            super.doPlay(url);
            if (this._isWriteLog)
            {
                LogManager.msg("段号：" + _clipNo + " 最终播放地址：" + url);
            }
            this.clearCdnTimeout(false);
            var limit:int;
            if (this._hasP2P)
            {
                limit = this._p2pTimeLimit;
            }
            else if (_is200)
            {
                limit = this._cdn200TimeLimit;
            }
            else
            {
                limit = this._cdn301TimeLimit;
            }
            this._cdnTimeoutId = setTimeout(function () : void
            {
                close();
                dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"CDNTimeout"}));
                return;
            }// end function
            , limit * 1000);
            return;
        }// end function

        public function clearCdnTimeout(param1:Boolean = true) : void
        {
            clearTimeout(this._cdnTimeoutId);
            if (param1)
            {
                this._p2pTimeLimit = 20;
            }
            return;
        }// end function

        public function setP2PTimeLimit() : void
        {
            if (this._hasP2P && this._p2pTimeLimit < 60)
            {
                this._p2pTimeLimit = this._p2pTimeLimit + 20;
            }
            else if (!this._hasP2P)
            {
                this._p2pTimeLimit = 20;
            }
            return;
        }// end function

        public function initP2PTimeLimit() : void
        {
            if (this._hasP2P && this._p2pTimeLimit < 60)
            {
                this._p2pTimeLimit = this._p2pTimeLimit + 20;
            }
            else if (!this._hasP2P)
            {
                this._p2pTimeLimit = 20;
            }
            return;
        }// end function

        private function getUrlFilename(param1:String) : String
        {
            if (!param1 || param1 == null || param1 == "")
            {
                return "";
            }
            var _loc_2:* = param1.split("/");
            return _loc_2[(_loc_2.length - 1)].split("?")[0];
        }// end function

        protected function getUrlPath(param1:String) : String
        {
            if (!param1 || param1 == null || param1 == "")
            {
                return "";
            }
            param1 = param1.replace("http://data.vod.itc.cn", "");
            return param1.split("?")[0];
        }// end function

        override protected function loadLocationAndPlay() : void
        {
            var re:* = /\?start=""\?start=/;
            var reData:* = /http\:\/\/(.+?)\/\|([0-9]{1,4})\|(.+?)\|([^|]*)\|?([01]?)\|?([01]?)\|([0-9]{1,6})\|([0-9]{1,6})\|([0-9]{1,6})""http\:\/\/(.+?)\/\|([0-9]{1,4})\|(.+?)\|([^|]*)\|?([01]?)\|?([01]?)\|([0-9]{1,6})\|([0-9]{1,6})\|([0-9]{1,6})/;
            var boo:* = re.test(_gslbUrl);
            var ips:String;
            var synUrl:String;
            if (this._errCdnIds.length > 0)
            {
                ips = "&idc=" + this._errCdnIds.join(",");
            }
            if (PlayerConfig.synUrl != null && PlayerConfig.synUrl.length > _clipNo)
            {
                synUrl = "&new=" + PlayerConfig.synUrl[_clipNo];
            }
            var backupIP:String;
            if (this._changeGSLBIP && PlayerConfig.backupGSLBIP != null && this._ipTime < PlayerConfig.backupGSLBIP.length)
            {
                backupIP = PlayerConfig.backupGSLBIP[this._ipTime];
                var _loc_2:String = this;
                var _loc_3:* = this._ipTime + 1;
                _loc_2._ipTime = _loc_3;
                if (this._ipTime == PlayerConfig.backupGSLBIP.length)
                {
                    this._ipTime = 0;
                }
                this.changeGSLBIP = false;
            }
            var url:String;
            var key:* = PlayerConfig.key != null && PlayerConfig.key[_clipNo] != null && PlayerConfig.key[_clipNo] != "" ? ("&key=" + PlayerConfig.key[_clipNo]) : ("");
            var vid:* = PlayerConfig.currentVid != "" ? ("&vid=" + PlayerConfig.currentVid) : ("");
            var uid:* = PlayerConfig.userId != "" ? ("&uid=" + PlayerConfig.userId) : ("");
            var ta:* = PlayerConfig.ta_jm != "" ? ("&ta=" + escape(PlayerConfig.ta_jm)) : ("");
            var newInfoStr:* = (PlayerConfig.lqd != "" ? ("&oth=" + PlayerConfig.lqd) : ("")) + (PlayerConfig.lcode != "" ? ("&cd=" + PlayerConfig.lcode) : ("")) + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.cdnMd + (PlayerConfig.ugu != "" ? ("&ugu=" + PlayerConfig.ugu) : ("")) + (PlayerConfig.ugcode != "" ? ("&ugcode=" + PlayerConfig.ugcode) : (""));
            url = "http://" + (backupIP != "" ? (backupIP) : (PlayerConfig.gslbIp)) + "/" + (PlayerConfig.isUgcFeeVideo ? ("pvmp4?prot=9&pg=4&ch=" + PlayerConfig.channel) : ("fmp4?prot=9")) + "&prod=flash&pt=1&file=" + this.getUrlPath(_gslbUrl) + synUrl + ips + key + vid + "&tvid=" + PlayerConfig.tvid + uid + ta + newInfoStr + (PlayerConfig.bfd != null && PlayerConfig.bfd[_clipNo] != "" ? ("&bfd=" + PlayerConfig.bfd[_clipNo]) : ("")) + (!PlayerConfig.isWebP2p && boo ? ("&" + _gslbUrl.split("?")[1]) : ("")) + "&iswebp2p=" + (PlayerConfig.isWebP2p ? ("1") : ("0")) + (PlayerConfig.useWebP2p ? (PlayerConfig.isRollback ? ("&rb=" + (PlayerConfig.initP2PFailed ? ("0") : ("1"))) : ("")) : ("&rb=2")) + "&t=" + Math.random();
            PlayerConfig.allotip = backupIP != "" ? (backupIP) : (PlayerConfig.gslbIp);
            if (PlayerConfig.isLive && !PlayerConfig.isP2PLive)
            {
                url = "http://" + _gslbUrl + "&prot=9&prod=flash&pt=1&hasquick=" + (PlayerConfig.hasP2PLive ? ("1") : ("0")) + key;
            }
            if (this._isWriteLog)
            {
                LogManager.msg("段号：" + _clipNo + " 调度地址：" + url + " 方式：200");
            }
            _gslbLoader = new URLLoaderUtil();
            _gslbLoader.load(10, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                var _loc_3:Object = null;
                var _loc_4:Array = null;
                var _loc_5:Array = null;
                var _loc_6:* = param1.target.spend;
                PlayerConfig.allotSpend = param1.target.spend;
                _spend_num = _loc_6;
                if (param1.info == "success")
                {
                    if (_isWriteLog)
                    {
                        LogManager.msg("段号：" + _clipNo + " CDN信息：" + param1.data);
                    }
                    if (param1.data == "quick")
                    {
                        dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"overload"}));
                        return;
                    }
                    _loc_2 = new JSON().parse(param1.data);
                    _url = _loc_2.url;
                    if (_loc_2 != null)
                    {
                        var _loc_6:* = _loc_2.ip;
                        _cdnIP = _loc_2.ip;
                        PlayerConfig.cdnIp = _loc_6;
                        var _loc_6:* = _loc_2.nid;
                        _cdnID = _loc_2.nid;
                        PlayerConfig.cdnId = _loc_6;
                        PlayerConfig.clientIp = _loc_2.cip;
                    }
                    else
                    {
                        var _loc_6:String = "";
                        _url = "";
                        PlayerConfig.cdnIp = _loc_6;
                        PlayerConfig.cdnId = "";
                        PlayerConfig.clientIp = "";
                        var _loc_6:String = "";
                        _cdnArea = "";
                        _cdnNt = _loc_6;
                    }
                    if (_loc_2.isSmallSup != null && _loc_2.isSmallSup == "1" && PlayerConfig.isWebP2p)
                    {
                        LogManager.msg("smallSuppliers");
                        _smallSuppliers = true;
                    }
                    if (_loc_2.n != null)
                    {
                        _cdnNt = _loc_2.n;
                    }
                    if (_loc_2.a != null)
                    {
                        _cdnArea = _loc_2.a;
                    }
                    if (_loc_2.qs != null)
                    {
                        PlayerConfig.gslbWay = _loc_2.qs;
                    }
                    if (!(_loc_2.allotType && _loc_2.allotType == "1"))
                    {
                        if (PlayerConfig.isMyTvVideo)
                        {
                            _url = "http://" + _gslbUrl;
                            _loc_3 = {allotType:_loc_2.allotType, errType:"ugc"};
                            InforSender.getInstance().sendMesg(InforSender.HISTORYPROBLEMS, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, _loc_3);
                        }
                        else if (PlayerConfig.isLive && !PlayerConfig.isP2PLive)
                        {
                            _loc_3 = {allotType:_loc_2.allotType, errType:"livenop2plive"};
                            InforSender.getInstance().sendMesg(InforSender.HISTORYPROBLEMS, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, _loc_3);
                        }
                        else
                        {
                            _loc_4 = _gslbUrl.split("data.vod.itc.cn");
                            if (_loc_4.length > 1 && _url != "")
                            {
                                _url = _gslbUrl.replace("http://data.vod.itc.cn", _url);
                                _loc_3 = {allotType:_loc_2.allotType, errType:"data.vod.itc.cn"};
                                InforSender.getInstance().sendMesg(InforSender.HISTORYPROBLEMS, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, _loc_3);
                            }
                        }
                    }
                    if (_gslbUrl.split("?").length > 1)
                    {
                        _loc_5 = _url.split("?");
                        _url = _loc_5.length > 1 ? (_loc_5[0] + "?" + _gslbUrl.split("?")[1] + "&" + _loc_5[1]) : (_loc_5[0] + "?" + _gslbUrl.split("?")[1]);
                    }
                    doPlay(_url);
                    dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Success"}));
                }
                else if (param1.info == "timeout")
                {
                    dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"timeout"}));
                }
                else
                {
                    dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"ioerror"}));
                }
                return;
            }// end function
            , url, null);
            return;
        }// end function

        override public function close() : void
        {
            super.close();
            return;
        }// end function

        public function sendCloseEvent() : void
        {
            var _loc_1:String = null;
            if (this._hasP2P)
            {
                _loc_1 = "http://127.0.0.1:8810/close" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&num=" + (_clipNo + 1) + "&r=" + (new Date().getTime() + Math.random());
                this._urlloader.send(_loc_1);
            }
            return;
        }// end function

        public function get cdnIP() : String
        {
            return this._cdnIP;
        }// end function

        public function get cdnID() : String
        {
            return this._cdnID;
        }// end function

        public function get hasP2P() : Boolean
        {
            return this._hasP2P;
        }// end function

        public function addErrIp() : void
        {
            if (this._errCdnIds.indexOf(this._cdnID) == -1)
            {
                this._errCdnIds.unshift(this._cdnID);
            }
            if (this._errCdnIds.length > 3)
            {
                this._errCdnIds = this._errCdnIds.slice(0, 2);
            }
            return;
        }// end function

        public function set changeGSLBIP(param1:Boolean) : void
        {
            this._changeGSLBIP = param1;
            return;
        }// end function

        public function get isnp() : Boolean
        {
            return this._isnp;
        }// end function

        public function set isnp(param1:Boolean) : void
        {
            this._isnp = param1;
            return;
        }// end function

    }
}
