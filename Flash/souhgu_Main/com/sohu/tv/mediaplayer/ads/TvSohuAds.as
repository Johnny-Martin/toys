package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.net.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.external.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class TvSohuAds extends EventDispatcher
    {
        private var _adsInfo_arr:Array;
        private var _hasAds:Boolean;
        private var _selectorStartAd:SelectorStartAd;
        private var _backgroudAd:BackgroundAd;
        private var _startAd:StartAd;
        private var _topLogoAd:TopLogoAd;
        private var _logoAd:LogoAd;
        private var _pauseAd:Object;
        private var _endAd:EndAd;
        private var _middleAd:MiddleAd;
        private var _sogouAd:SogouAd;
        private var _topAd:TopAd;
        private var _bottomAd:BottomAd;
        private var _ctrlBarAd:CtrlBarAd;
        private var _func:Function;
        private var _stage:Stage;
        private var _adSo:SharedObject;
        private var _fetchAdsUrl:String = "";
        private var _vipUser:String = "";
        private var _illegal:Boolean = false;
        private var encNum:int = 0;
        private var _playAdTimeout:Number = 0;
        private var _startLoadAds:Number = 0;
        private var _spendTime:Number = 0;
        protected var _urlloader:TvSohuURLLoaderUtil;
        private var _xxtea:XXTEA;
        private var _recordData:String = "";
        private static var singleton:TvSohuAds;

        public function TvSohuAds(param1:Stage = null)
        {
            this._xxtea = new XXTEA();
            if (param1 != null)
            {
                this._stage = param1;
            }
            this.hardInit();
            return;
        }// end function

        private function hardInit() : void
        {
            this.sysInit("start");
            return;
        }// end function

        private function sysInit(param1:String = null) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
                this.drawUi();
                this.addEvent();
            }
            this._vipUser = "";
            return;
        }// end function

        private function addEvent() : void
        {
            return;
        }// end function

        private function newFunc() : void
        {
            this._selectorStartAd = new SelectorStartAd({width:this._stage.stageWidth, height:this._stage.stageHeight});
            this._selectorStartAd.addEventListener(TvSohuAdsEvent.SELECTORFINISH, this.selectorAdFinish);
            this._startAd = new StartAd({width:this._stage.stageWidth, height:this._stage.stageHeight});
            this._topLogoAd = new TopLogoAd();
            this._logoAd = new LogoAd();
            this._pauseAd = new PauseAd2();
            this._endAd = new EndAd({width:this._stage.stageWidth, height:this._stage.stageHeight});
            this._middleAd = new MiddleAd({width:this._stage.stageWidth, height:this._stage.stageHeight});
            this._topAd = new TopAd();
            this._bottomAd = new BottomAd();
            this._ctrlBarAd = new CtrlBarAd();
            this._sogouAd = new SogouAd();
            this._backgroudAd = new BackgroundAd();
            try
            {
                this._adSo = SharedObject.getLocal("AD", "/");
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function loadAdInfo(param1:Function) : void
        {
            var func:* = param1;
            this._func = func;
            var vipUser:* = Utils.getBrowserCookie("fee_status");
            var ifoxVipUser:* = Utils.getBrowserCookie("fee_ifox");
            var vu:* = vipUser != "" || ifoxVipUser != "" && P2PExplorer.getInstance().hasP2P ? ("&vu=" + (vipUser != "" ? (vipUser) : (ifoxVipUser))) : ("");
            this._vipUser = vu;
            var type:* = PlayerConfig.isTransition ? ("vms1") : (!PlayerConfig.isLongVideo ? ("vms2") : (PlayerConfig.isMyTvVideo ? (PlayerConfig.wm_user == "20" ? ("pgc") : ("my")) : ("vrs")));
            var pub_catecode:* = PlayerConfig.pub_catecode != "" ? ("&pub_catecode=" + PlayerConfig.pub_catecode) : ("");
            var qd:* = PlayerConfig.ch_key != "" ? ("&qd=" + PlayerConfig.ch_key) : ("");
            var _isIf:String;
            var refer:String;
            if (Eif.available && ExternalInterface.available)
            {
                if (ExternalInterface.call("eval", "window.top.location != window.self.location"))
                {
                    _isIf;
                }
                else
                {
                    _isIf;
                }
                refer = ExternalInterface.call("eval", "document.referrer");
            }
            var newInfoStr:* = (PlayerConfig.lqd != "" ? ("&oth=" + PlayerConfig.lqd) : ("")) + (PlayerConfig.lcode != "" ? ("&cd=" + PlayerConfig.lcode) : ("")) + "&sz=" + (PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight) + "&md=" + PlayerConfig.adMd + (PlayerConfig.ugu != "" ? ("&ugu=" + PlayerConfig.ugu) : ("")) + (PlayerConfig.ugcode != "" ? ("&ugcode=" + PlayerConfig.ugcode) : (""));
            if (InforSender.getInstance().paramStr == "")
            {
                InforSender.getInstance().callbackFun();
            }
            var arr:* = InforSender.getInstance().paramStr.split("_");
            this.encNum = arr[1];
            var enc:* = "&ran=" + encodeURIComponent(arr[0]) + "_" + this.encNum;
            if (!PlayerConfig.is56)
            {
                this._fetchAdsUrl = PlayerConfig.FETCH_ADS_PATCH + "?cat=" + PlayerConfig.cmscat + "&pver=" + Capabilities.version + "&type=" + type + "&al=" + (PlayerConfig.isMyTvVideo && PlayerConfig.wm_user == "20" ? (Number(PlayerConfig.plid)) : (Number(PlayerConfig.vrsPlayListId))) + "&vid=" + PlayerConfig.vid + "&tvid=" + PlayerConfig.tvid + "&uuid=" + PlayerConfig.uuid + "&c=" + PlayerConfig.channel + "&vc=" + PlayerConfig.catcode + "&act=" + PlayerConfig.act + "&st=" + PlayerConfig.mainActorId + "&ar=" + PlayerConfig.areaId + "&ye=" + PlayerConfig.year + "&fee=" + (PlayerConfig.isFee ? ("1") : ("0")) + "&isIf=" + _isIf + "&du=" + PlayerConfig.totalDuration + (PlayerConfig.xuid != "" ? ("&pgy=" + PlayerConfig.xuid) : ("")) + "&out=" + PlayerConfig.domainProperty + "&uid=" + PlayerConfig.userId + pub_catecode + qd + (PlayerConfig.adReview != "" ? ("&review=" + PlayerConfig.adReview) : ("")) + (PlayerConfig.apiKey != "" ? ("&ak=" + PlayerConfig.apiKey) : ("")) + (PlayerConfig.liveType != "" ? ("&lid=" + PlayerConfig.vid) : ("")) + "&autoPlay=" + (PlayerConfig.autoPlay ? ("1") : ("0")) + (PlayerConfig.txid != "" ? ("&txid=" + PlayerConfig.txid) : ("")) + "&crid=" + PlayerConfig.crid + vu + enc + newInfoStr + (PlayerConfig.myTvUserId != "" ? ("&myTvUid=" + PlayerConfig.myTvUserId) : ("")) + (PlayerConfig.tag != "" ? ("&tag=" + encodeURIComponent(PlayerConfig.tag)) : ("")) + "&pageUrl=" + escape(PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl))) + "&lrd=" + escape(PlayerConfig.landingrefer) + "&pagerefer=" + escape(escape(refer)) + "&ag=" + escape(PlayerConfig.age) + "&ti=" + encodeURIComponent(PlayerConfig.videoTitle) + "&w=" + this._stage.stageWidth + "&h=" + this._stage.stageHeight + "&ooab=" + (PlayerConfig.isInFiveMinPlayed ? ("1") : ("0"));
            }
            else
            {
                this._fetchAdsUrl = "http://v.aty.sohu.com/v" + "?" + "c=56com" + "&cat=" + PlayerConfig.cidFor56 + "&vc=" + PlayerConfig.cidFor56 + "&review=" + "" + "&pver=" + PlayerConfig.flashVersion + "&type=56flash" + "&al=" + PlayerConfig.acidFor56 + "&act=" + "&st=" + "&ar=" + "&ye=" + "&du=" + PlayerConfig.totalDuration + "&vid=" + PlayerConfig.vid + "&out=" + 0 + "&tuv=" + PlayerConfig.userId + "&uid=" + PlayerConfig.userId + "&uuid=" + PlayerConfig.uuid + "&autoPlay=" + 1 + "&ag=" + "&fee=" + "&lid=" + "&ak=" + PlayerConfig.apiKey + "&vu=" + "&isIf=" + _isIf + "&qd=" + PlayerConfig.ch_key + "&mal=" + PlayerConfig.opera_id + "&Inx=" + "&tot=" + "&adtime=" + 60 + "&pageUrl=" + escape(PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl))) + "&ti=" + encodeURIComponent(PlayerConfig.videoTitle) + "&ptime=" + "&ooab=" + (PlayerConfig.isInFiveMinPlayed ? ("1") : ("0"));
            }
            if (!this._selectorStartAd.hasAd)
            {
                this._urlloader = new TvSohuURLLoaderUtil();
                AdLog.msg("请求广告接口：" + this._fetchAdsUrl);
                this._urlloader.load(15, this.adsInfoHandler, this._fetchAdsUrl + "&m=" + new Date().getTime());
                this._startLoadAds = new Date().getTime();
                this._playAdTimeout = setTimeout(function () : void
            {
                clearTimeout(_playAdTimeout);
                adsInfoHandler({info:"timeout2", target:this});
                return;
            }// end function
            , 1000 * 5);
            }
            return;
        }// end function

        private function adsInfoHandler(param1:Object, param2:Boolean = true) : void
        {
            var errInfo:Object;
            var _decNum:String;
            var str:String;
            var json:Object;
            var startAdPar:String;
            var oadSlaveAdPar:String;
            var endAdPar:String;
            var logoAdPar:String;
            var logoAdDelayPar:String;
            var logoAdIntervalPar:String;
            var logoAdClickPar:String;
            var logoAdClickStat:String;
            var logoHardAdFlag:String;
            var clicklayerflogo:String;
            var logoAdFirsttimePar:String;
            var topLogoAdPar:String;
            var topLogoAdDelayPar:String;
            var topLogoAdClickPar:String;
            var pauseAdPar:String;
            var topAdPar:String;
            var topAdDelayPar:String;
            var topAdClickPar:String;
            var bottomAdPar:String;
            var bottomAdDelayPar:String;
            var bottomAdClickPar:String;
            var ctrlBarAdPar:String;
            var sogouAdPar:String;
            var logoAdPingback:String;
            var topLogoAdPingback:String;
            var pauseAdPingback:String;
            var topAdPingback:String;
            var bottomAdPingback:String;
            var ctrlBarAdPingback:String;
            var ctrlBarAdClickPar:String;
            var clicklayerfbar:String;
            var ctrlBarAdClickStat:String;
            var ctrlHardAdFlag:String;
            var _oadvol:String;
            var dataStr:String;
            var skAdPar:String;
            var skStartAdPar:String;
            var skStartAdTime:int;
            var skStartAdClickStat:String;
            var selectorStartAdPar:Array;
            var j:Object;
            var i:uint;
            var obj:* = param1;
            var firstCall:* = param2;
            if (firstCall)
            {
                this._spendTime = (new Date().getTime() - this._startLoadAds) / 1000;
                AdLog.msg("广告接口返回：" + obj.info + "：： : " + (obj.info == "ioError" ? ("status : " + obj.status) : (" ")) + ": : : spend：" + this._spendTime);
                clearTimeout(this._playAdTimeout);
            }
            if (obj.info == "timeout2")
            {
                errInfo;
                InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, errInfo);
            }
            else if (this._spendTime > 5 && this._spendTime < 15)
            {
                this._urlloader.close();
                _decNum;
                try
                {
                    if (!PlayerConfig.is56)
                    {
                        str = this._xxtea.NetDecrypt(obj.data, this.encNum);
                        _decNum = str != "" ? ("1") : ("0");
                    }
                }
                catch (evt)
                {
                    _decNum;
                }
                errInfo;
                InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, errInfo);
                return;
            }
            else if (this._spendTime >= 15)
            {
                this._urlloader.close();
                errInfo;
                InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, errInfo);
                return;
            }
            if (obj.info == "success")
            {
                if (firstCall)
                {
                    PlayerConfig.adinfoSpend = obj.target.spend;
                }
                try
                {
                    if (!PlayerConfig.is56)
                    {
                        dataStr = this._xxtea.NetDecrypt(obj.data, this.encNum);
                        AdLog.msg("==========广告信息(json)开始==========");
                        AdLog.msg(dataStr);
                        AdLog.msg("==========广告信息(json)结束==========");
                        json = new JSON().parse(dataStr);
                    }
                    else
                    {
                        AdLog.msg("==========广告信息(json)开始==========");
                        AdLog.msg(obj.data);
                        AdLog.msg("==========广告信息(json)结束==========");
                        json = new JSON().parse(obj.data);
                    }
                }
                catch (evt)
                {
                    AdLog.msg("广告返回数据播放器解密失败 decoderror");
                    InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {num:"1", errType:"decoderror"});
                    if (_vipUser == "")
                    {
                        _illegal = true;
                    }
                }
                if (firstCall)
                {
                    this._recordData = obj.data;
                    skAdPar;
                    skStartAdPar;
                    skStartAdClickStat;
                    if (json != null && json.data != null && json.data.skoad != null && json.data.skoad != "")
                    {
                        skAdPar = this.getPar(json.data.skoad);
                    }
                    if (json != null && json.data != null && this.getPar(json.data.vuflag) != null && this.getPar(json.data.vuflag) != "" && this.getPar(json.data.vuflag) == "1")
                    {
                        this._selectorStartAd.isAdTip = true;
                    }
                    if (json != null && json.data != null && json.data.soad != "" && json.data.soad != null)
                    {
                        AdLog.msg("==========展示四选一广告==========");
                        selectorStartAdPar = json.data.soad;
                        this.selectorAdIni(selectorStartAdPar);
                        this.hasAds = true;
                        this._func();
                        return;
                    }
                    if (skAdPar != "")
                    {
                        skStartAdPar = json.data.skoad[0].ad;
                        skStartAdTime = json.data.skoad[0].sktime;
                        skStartAdClickStat = json.data.skoad[0].ckurl;
                        AdLog.msg("==========可跳过广告展示==========可跳过时间为" + skStartAdTime + "秒");
                    }
                }
                startAdPar;
                oadSlaveAdPar;
                endAdPar;
                logoAdPar;
                logoAdDelayPar;
                logoAdIntervalPar;
                logoAdClickPar;
                logoAdClickStat;
                logoHardAdFlag;
                clicklayerflogo;
                logoAdFirsttimePar;
                topLogoAdPar;
                topLogoAdDelayPar;
                topLogoAdClickPar;
                pauseAdPar;
                topAdPar;
                topAdDelayPar;
                topAdClickPar;
                bottomAdPar;
                bottomAdDelayPar;
                bottomAdClickPar;
                ctrlBarAdPar;
                sogouAdPar;
                logoAdPingback;
                topLogoAdPingback;
                pauseAdPingback;
                topAdPingback;
                bottomAdPingback;
                ctrlBarAdPingback;
                ctrlBarAdClickPar;
                clicklayerfbar;
                ctrlBarAdClickStat;
                ctrlHardAdFlag;
                _oadvol;
                if (json != null && json.status == 1)
                {
                    AdLog.msg("==========广告status正常==========");
                    if (skAdPar != "" && skAdPar != null)
                    {
                        startAdPar = skStartAdPar;
                    }
                    else
                    {
                        startAdPar = this.getPar(json.data.oad);
                    }
                    oadSlaveAdPar = this.getPar(json.data.oad_slave);
                    if (this.getPar(json.data.oadvol) != "")
                    {
                        if (this.getPar(json.data.oadvol) == "0")
                        {
                            this.startAd.isMute = true;
                        }
                        else if (this.getPar(json.data.oadvol) == "1")
                        {
                            this.startAd.isMute = false;
                        }
                    }
                    if (this.getPar(json.data.oadplaymode) != "")
                    {
                        if (this.getPar(json.data.oadplaymode) == "0")
                        {
                            this.startAd.isAutoPlayAd = false;
                        }
                        else if (this.getPar(json.data.oadplaymode) == "1")
                        {
                            this.startAd.isAutoPlayAd = true;
                        }
                    }
                    if (this.getPar(json.data.ebt) != null && this.getPar(json.data.ebt) != "")
                    {
                        this.startAd.ebt = this.getPar(json.data.ebt);
                    }
                    endAdPar = this.getPar(json.data.ead);
                    logoAdPar = this.getPar(json.data.flogoad);
                    logoAdDelayPar = this.getPar(json.data.flogodelay);
                    logoAdIntervalPar = this.getPar(json.data.flogointerval);
                    logoAdPingback = this.getPar(json.data.flogopingback);
                    logoAdClickPar = this.getPar(json.data.flogoclickurl);
                    logoAdClickStat = this.getPar(json.data.flogoclickmonitor);
                    logoHardAdFlag = this.getPar(json.data.flogohardflag);
                    clicklayerflogo = this.getPar(json.data.clicklayerflogo);
                    logoAdFirsttimePar = this.getPar(json.data.flogofirsttime);
                    topLogoAdPar = this.getPar(json.data.tlogoad);
                    topLogoAdDelayPar = this.getPar(json.data.tlogodelay);
                    topLogoAdPingback = this.getPar(json.data.tlogopingback);
                    topLogoAdClickPar = this.getPar(json.data.tlogoclickurl);
                    pauseAdPar;
                    pauseAdPingback = this.getPar(json.data.padpingback);
                    topAdPar = this.getPar(json.data.ftitlead);
                    topAdDelayPar = this.getPar(json.data.ftitledelay);
                    topAdPingback = this.getPar(json.data.ftitlepingback);
                    topAdClickPar = this.getPar(json.data.ftitleclickurl);
                    bottomAdPar = this.getPar(json.data.fbottomad);
                    bottomAdDelayPar = this.getPar(json.data.fbottomdelay);
                    bottomAdPingback = this.getPar(json.data.fbottompingback);
                    bottomAdClickPar = this.getPar(json.data.fbottomclickurl);
                    if (this.getPar(json.data.fbottomtype) != "")
                    {
                        if (this.getPar(json.data.fbottomtype) == "1")
                        {
                            this._bottomAd.isFButtomAd = true;
                        }
                        else if (this.getPar(json.data.fbottomtype) == "0")
                        {
                            this._bottomAd.isFButtomAd = false;
                        }
                    }
                    ctrlBarAdPar = this.getPar(json.data.fbarad);
                    ctrlBarAdPingback = this.getPar(json.data.fbarpingback);
                    ctrlBarAdClickPar = this.getPar(json.data.fbarclickurl);
                    clicklayerfbar = this.getPar(json.data.clicklayerfbar);
                    ctrlBarAdClickStat = this.getPar(json.data.fbaradclickmonitor);
                    ctrlHardAdFlag = this.getPar(json.data.fbarhardflag);
                    PlayerConfig.firstReqTanmuTime = this.getPar(json.data.firstreqbarragetime);
                }
                else
                {
                    startAdPar = this.getParams("oad");
                    endAdPar = this.getParams("ead");
                    logoAdPar = this.getParams("flogoad");
                    logoAdDelayPar = this.getParams("flogodelay");
                    logoAdIntervalPar = this.getParams("flogointerval");
                    logoAdFirsttimePar = this.getParams("flogofirsttime");
                    topLogoAdPar = this.getParams("tlogoad");
                    topLogoAdDelayPar = this.getParams("tlogodelay");
                    pauseAdPar = this.getParams("pad");
                    topAdPar = this.getParams("ftitlead");
                    topAdDelayPar = this.getParams("ftitledelay");
                    bottomAdPar = this.getParams("fbottomad");
                    bottomAdDelayPar = this.getParams("fbottomdelay");
                    ctrlBarAdPar = this.getParams("fbarad");
                    if (startAdPar != "" || endAdPar != "" || logoAdPar != "" || logoAdFirsttimePar != "" || logoAdDelayPar != "" || logoAdIntervalPar != "" || topLogoAdPar != "" || topLogoAdDelayPar != "" || pauseAdPar != "" || topAdPar != "" || topAdDelayPar != "" || bottomAdPar != "" || bottomAdDelayPar != "" || ctrlBarAdPar != "")
                    {
                        SendRef.getInstance().sendPQVPC("pl_oldad_show");
                    }
                    if (json != null && json.status == 3 && json.data != null && json.data.oad != null && json.data.oad != "")
                    {
                        j = new JSON().parse(json.data.oad.replace(new RegExp("\'", "g"), "\""));
                        i;
                        while (i < j.length)
                        {
                            
                            if (j[i][3] != null)
                            {
                                new URLLoaderUtil().multiSend(j[i][3]);
                            }
                            i = (i + 1);
                        }
                        if (json.data.flogopingback != null && json.data.flogopingback != "")
                        {
                            new URLLoaderUtil().send(json.data.flogopingback);
                        }
                        if (json.data.fbaradpingback != null && json.data.fbaradpingback != "")
                        {
                            new URLLoaderUtil().send(json.data.fbaradpingback);
                        }
                        if (json.data.padpingback != null && json.data.padpingback != "")
                        {
                            new URLLoaderUtil().send(json.data.padpingback);
                        }
                    }
                    ErrorSenderPQ.getInstance().sendPQStat({error:PlayerConfig.ADINFO_ERROR_OTHER, code:PlayerConfig.REALVV_CODE});
                    if (json != null && json.status != null && (json.status == -101 || json.status == -102))
                    {
                        InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {num:"1", errType:json.status == -101 ? ("tampercipher") : ("tamperparams")});
                        if (this._vipUser == "")
                        {
                            startAdPar = "[[\'http://images.sohu.com/ytv/SH/Unilever/8/44/" + Utils.createUID() + ".mp4\',60,\'\',\'\',\'\',\'\',\'\',\'0\']]";
                        }
                    }
                }
                if (json != null && json.data != null && this.getPar(json.data.vuflag) != null && this.getPar(json.data.vuflag) != "" && this.getPar(json.data.vuflag) == "1")
                {
                    var _loc_4:Boolean = true;
                    this._endAd.isAdTip = true;
                    this._startAd.isAdTip = _loc_4;
                }
                if (obj.selectedVideo && obj.selectedVideo != null)
                {
                    AdLog.msg("==========前贴广告部分开始==========");
                    this._startAd.softInit({adPar:obj.selectedVideo, slaveAdPar:oadSlaveAdPar});
                    AdLog.msg("==========前贴广告部分结束==========");
                }
                else if (this._vipUser == "" && (json == null || json.status == null))
                {
                    SendRef.getInstance().sendPQVPC("3");
                    this._illegal = true;
                }
                else
                {
                    AdLog.msg("==========前贴广告部分开始==========");
                    if (skAdPar != "" && skAdPar != null)
                    {
                        this._startAd.softInit({adPar:startAdPar, slaveAdPar:oadSlaveAdPar, skTime:skStartAdTime, skCkUrl:skStartAdClickStat});
                    }
                    else
                    {
                        this._startAd.softInit({adPar:startAdPar, slaveAdPar:oadSlaveAdPar});
                    }
                    AdLog.msg("==========前贴广告部分结束==========");
                }
                this._logoAd.softInit({adPar:logoAdPar, adClick:logoAdClickPar, adClickStat:logoAdClickStat, adDelayPar:logoAdDelayPar, adIntervalPar:logoAdIntervalPar, adPingback:logoAdPingback, adClicklayerflogo:clicklayerflogo, adFirsttimePar:logoAdFirsttimePar, hardFlag:logoHardAdFlag, flogodspsource:json.data.flogodspsource});
                this._topLogoAd.softInit({adPar:topLogoAdPar, adClick:topLogoAdClickPar, adDelayPar:topLogoAdDelayPar, adPingback:topLogoAdPingback});
                this._pauseAd.softInit({adPar:pauseAdPar, adPingback:pauseAdPingback});
                AdLog.msg("==========后贴广告部分开始==========");
                this._endAd.softInit({adPar:endAdPar});
                AdLog.msg("==========后贴广告部分结束==========");
                this._topAd.softInit({adPar:topAdPar, adClick:topAdClickPar, adDelayPar:topAdDelayPar, adPingback:topAdPingback});
                this._bottomAd.softInit({adPar:bottomAdPar, adClick:bottomAdClickPar, adDelayPar:bottomAdDelayPar, adPingback:bottomAdPingback});
                this._sogouAd.softInit({adPar:sogouAdPar});
                this._ctrlBarAd.softInit({adPar:ctrlBarAdPar, adClick:ctrlBarAdClickPar, adClickStat:ctrlBarAdClickStat, adPingback:ctrlBarAdPingback, adClicklayerfbar:clicklayerfbar, hardFlag:ctrlHardAdFlag, fbardspsource:json.data.fbardspsource});
                this.hasAds = true;
            }
            else
            {
                startAdPar = this.getParams("oad");
                endAdPar = this.getParams("ead");
                logoAdPar = this.getParams("flogoad");
                logoAdFirsttimePar = this.getParams("flogofirsttime");
                logoAdDelayPar = this.getParams("flogodelay");
                logoAdIntervalPar = this.getParams("flogointerval");
                topLogoAdPar = this.getParams("tlogoad");
                topLogoAdDelayPar = this.getParams("tlogodelay");
                pauseAdPar = this.getParams("pad");
                topAdPar = this.getParams("ftitlead");
                topAdDelayPar = this.getParams("ftitledelay");
                bottomAdPar = this.getParams("fbottomad");
                bottomAdDelayPar = this.getParams("fbottomdelay");
                ctrlBarAdPar = this.getParams("fbarad");
                if (startAdPar != "" || endAdPar != "" || logoAdPar != "" || logoAdFirsttimePar != "" || logoAdDelayPar != "" || logoAdIntervalPar != "" || topLogoAdPar != "" || topLogoAdDelayPar != "" || pauseAdPar != "" || topAdPar != "" || topAdDelayPar != "" || bottomAdPar != "" || bottomAdDelayPar != "" || ctrlBarAdPar != "")
                {
                    SendRef.getInstance().sendPQVPC("pl_oldad_show");
                }
                if (obj.info == "timeout")
                {
                    ErrorSenderPQ.getInstance().sendPQStat({error:PlayerConfig.ADINFO_ERROR_TIMEOUT, code:PlayerConfig.REALVV_CODE, utime:obj.target.spend});
                }
                else if (obj.info == "securityError" || obj.info == "ioError")
                {
                    InforSender.getInstance().sendMesg(InforSender.FF, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {num:"1", errType:obj.info});
                    if (this._vipUser == "")
                    {
                        startAdPar = "[[\'http://images.sohu.com/ytv/SH/Unilever/8/44/" + Utils.createUID() + ".mp4\',60,\'\',\'\',\'\',\'\',\'\',\'0\']]";
                    }
                }
                else
                {
                    ErrorSenderPQ.getInstance().sendPQStat({error:PlayerConfig.ADINFO_ERROR_FAILED, code:PlayerConfig.REALVV_CODE});
                }
                if (obj.selectedVideo && obj.selectedVideo != null)
                {
                    AdLog.msg("==========前贴广告部分开始==========");
                    this._startAd.softInit({adPar:obj.selectedVideo});
                    AdLog.msg("==========前贴广告部分结束==========");
                }
                else
                {
                    AdLog.msg("==========前贴广告部分开始==========");
                    this._startAd.softInit({adPar:startAdPar});
                    AdLog.msg("==========前贴广告部分结束==========");
                }
                this._logoAd.softInit({adPar:logoAdPar, adDelayPar:logoAdDelayPar, adIntervalPar:logoAdIntervalPar, adFirsttimePar:logoAdFirsttimePar});
                this._topLogoAd.softInit({adPar:topLogoAdPar, adDelayPar:topLogoAdDelayPar});
                this._pauseAd.softInit({adPar:pauseAdPar});
                AdLog.msg("==========后贴广告部分开始==========");
                this._endAd.softInit({adPar:endAdPar});
                AdLog.msg("==========后贴广告部分结束==========");
                this._topAd.softInit({adPar:topAdPar, adDelayPar:topAdDelayPar});
                this._bottomAd.softInit({adPar:bottomAdPar, adDelayPar:bottomAdDelayPar});
                this._sogouAd.softInit({adPar:sogouAdPar});
                this._ctrlBarAd.softInit({adPar:ctrlBarAdPar});
                this.hasAds = true;
            }
            this._func();
            return;
        }// end function

        private function getPar(param1) : String
        {
            var _loc_2:String = "";
            if (param1 != undefined && param1 != null)
            {
                _loc_2 = String(param1);
            }
            return _loc_2;
        }// end function

        private function getTestData(param1:Number) : String
        {
            var _loc_2:String = "";
            var _loc_3:* = PlayerConfig.swfHost + "panel/ErrorAds.swf";
            var _loc_4:Number = 0;
            if (Math.round(param1) > 300)
            {
                _loc_4 = 60;
                _loc_2 = "[[\'" + _loc_3 + "\'," + _loc_4 + ",\'\',\'\',\'\',\'\',\'\',\'1\',\'0\',{},\'0\']]";
            }
            else if (Math.round(param1) > 60 && Math.round(param1) <= 300)
            {
                _loc_4 = 40;
                _loc_2 = "[[\'" + _loc_3 + "\'," + _loc_4 + ",\'\',\'\',\'\',\'\',\'\',\'1\',\'0\',{},\'0\']]";
            }
            else
            {
                return _loc_2;
            }
            return _loc_2;
        }// end function

        private function selectorAdIni(param1:Array) : void
        {
            this._selectorStartAd.softInit({adPar:param1});
            if (this._selectorStartAd.hasAd && PlayerConfig.autoPlay)
            {
                this._selectorStartAd.play();
                SendRef.getInstance().sendPQVPC("pl_oldad_show");
            }
            return;
        }// end function

        private function selectorAdFinish(event:TvSohuAdsEvent) : void
        {
            if (this._selectorStartAd.video && this._selectorStartAd.video != "" && this._selectorStartAd.video != null)
            {
                this.adsInfoHandler({info:"success", data:this._recordData, selectedVideo:this._selectorStartAd.video}, false);
            }
            else
            {
                this.adsInfoHandler({info:"success", data:this._recordData}, false);
            }
            return;
        }// end function

        private function drawUi() : void
        {
            return;
        }// end function

        private function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new TvSohuAdsEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

        public function destroy() : void
        {
            if (this.selectorStartAd != null && this.selectorStartAd.hasAd)
            {
                this.selectorStartAd.destroy();
            }
            if (this.startAd != null && this.startAd.hasAd && (this.startAd.state == "playing" || this.startAd.state == "end"))
            {
                this.startAd.destroy();
            }
            if (this.endAd != null && this.endAd.hasAd)
            {
                this.endAd.destroy();
            }
            if (this.ctrlBarAd != null && this.ctrlBarAd.hasAd)
            {
                this.ctrlBarAd.destroy();
            }
            if (this.middleAd != null && this.middleAd.hasAd)
            {
                this.middleAd.destroy();
            }
            if (this.backgroudAd != null)
            {
                this.backgroudAd.destroy();
            }
            return;
        }// end function

        public function get illegal() : Boolean
        {
            return this._illegal;
        }// end function

        public function get hasAds() : Boolean
        {
            return this._hasAds;
        }// end function

        public function set hasAds(param1:Boolean) : void
        {
            this._hasAds = param1;
            return;
        }// end function

        public function screen()
        {
            return "";
        }// end function

        public function get selectorStartAd() : SelectorStartAd
        {
            return this._selectorStartAd;
        }// end function

        public function get startAd() : StartAd
        {
            return this._startAd;
        }// end function

        public function get pauseAd()
        {
            return this._pauseAd;
        }// end function

        public function get ctrlBarAd() : CtrlBarAd
        {
            return this._ctrlBarAd;
        }// end function

        public function get logoAd() : LogoAd
        {
            return this._logoAd;
        }// end function

        public function get topLogoAd() : TopLogoAd
        {
            return this._topLogoAd;
        }// end function

        public function get sogouAd() : SogouAd
        {
            return this._sogouAd;
        }// end function

        public function get topAd() : TopAd
        {
            return this._topAd;
        }// end function

        public function get bottomAd() : BottomAd
        {
            return this._bottomAd;
        }// end function

        public function get endAd() : EndAd
        {
            return this._endAd;
        }// end function

        public function get middleAd() : MiddleAd
        {
            return this._middleAd;
        }// end function

        public function get backgroudAd() : BackgroundAd
        {
            return this._backgroudAd;
        }// end function

        public function set stage(param1:Stage) : void
        {
            this._stage = param1;
            return;
        }// end function

        public function isFrequencyLimit(param1:String) : Boolean
        {
            var _loc_5:uint = 0;
            var _loc_2:* = param1.split("|");
            if (_loc_2.length < 2 || this._adSo == null)
            {
                return false;
            }
            var _loc_3:* = new Date();
            var _loc_4:* = this.doubleDigitFormat((_loc_3.month + 1)) + this.doubleDigitFormat(_loc_3.date);
            if (this._adSo.data.adLimit != undefined && this._adSo.data.adLimit != null)
            {
                _loc_5 = 0;
                while (_loc_5 < this._adSo.data.adLimit.length)
                {
                    
                    if (this._adSo.data.adLimit[_loc_5].id == _loc_2[0])
                    {
                        if (uint(this._adSo.data.adLimit[_loc_5].frequency) == 0 && this._adSo.data.adLimit[_loc_5].date == _loc_4)
                        {
                            return true;
                        }
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            return false;
        }// end function

        public function doubleDigitFormat(param1:uint) : String
        {
            if (param1 < 10)
            {
                return "0" + param1.toString();
            }
            return param1.toString();
        }// end function

        public function get fetchAdsUrl() : String
        {
            return this._fetchAdsUrl;
        }// end function

        public function get vipUser() : String
        {
            return this._vipUser;
        }// end function

        private function getParams(param1:String) : String
        {
            var _loc_2:String = "";
            if (this._stage.loaderInfo.parameters[param1] != null)
            {
                _loc_2 = String(this._stage.loaderInfo.parameters[param1]);
                _loc_2 = _loc_2.replace(new RegExp("\\^", "g"), "&");
                _loc_2 = _loc_2.replace(new RegExp("#{3}", "g"), "^");
            }
            return _loc_2;
        }// end function

        public static function getInstance(param1:Stage = null) : TvSohuAds
        {
            if (singleton == null)
            {
                singleton = new TvSohuAds(param1);
            }
            return singleton;
        }// end function

    }
}
