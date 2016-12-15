package 
{
    import com.adobe.images.*;
    import com.greensock.*;
    import com.greensock.easing.*;
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.ads.*;
    import com.sohu.tv.mediaplayer.netstream.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import com.sohu.tv.mediaplayer.ui.*;
    import com.sohu.tv.mediaplayer.video.*;
    import ebing.*;
    import ebing.events.*;
    import ebing.external.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class Main extends Sprite
    {
        private var _tvSohuMpb:Object;
        private var _model:Model;
        private var _qfStat:ErrorSenderPQ;
        private var _cacheFixed_num:Number;
        private var _ads:TvSohuAds;
        private var _pauseAd:Number;
        private var _so:SharedObject;
        private var _isDrag:Boolean = false;
        private var _isAutoPlay:Boolean = true;
        private var _isDelaySeek:Boolean = false;
        private var _breakPoint:Number = 0;
        private var _tvSohuLoading:Object;
        private var _tvSohuLoading_c:Sprite;
        private var _version:String = "";
        private var _autoFix:String = "";
        private var _bandwidth:Number = 0;
        private var _owner:Main;
        private var _isPlayStartAd:Boolean = true;
        private var _isShowPlayedAd:Boolean = false;
        private var _mpbSoftInitSuc:Boolean = false;
        private var _selectorStartAdContainer:Sprite;
        private var _startAdContainer:Sprite;
        private var _endAdContainer:Sprite;
        private var _middleAdContainer:Sprite;
        private var _mpbSoftInitObj:Object;
        private var _tvSohuMpbOk:Number;
        private var _width:Number;
        private var _height:Number;
        private var _tvSohuMpb_c:Sprite;
        private var _cm:ContextMenu;
        private var _bg:Sprite;
        private var _isPwd:Boolean = false;
        private var _errStatusSp:Sprite;
        private var _tvSohuErrorMsg:TvSohuErrorMsg;
        private var _logsPanel:LogsPanel;
        private var _verInfoPanel:VerInfoPanel;
        private var _isLoop:Boolean = false;
        private var _isNewsLogo:Boolean;
        private var _testVerTip:TextField;
        private var _fatText:TextFormat;
        private var _isFirstSend:Boolean = true;
        private var _isDownPreviewPic:Boolean = true;
        private var _isAutoLoop:Boolean = false;
        private var _isJsCallLoadAndPlay:Boolean = false;
        private var _btnUi:ButtonUi;
        private var _adPlayIllegal:AdPlayIllegal;
        private var _payPanel:Object;
        private var _svdUserSo:SharedObject;
        private var _isSeekToNoTip:Boolean = false;
        private var _vidFor56:String = "";
        private var jsCheckLoadTimer:Timer;
        private var _isRollbackFor56cdn:Boolean = false;
        private var _isRollbackWaitAds:Boolean = false;
        private var timer:Timer;
        private var intervalTimeout:Timer;
        private var _isSendRVV:Boolean = true;
        private var _oriMkey:String = "";
        private var _superVipPanel:Object;

        public function Main()
        {
            this.timer = new Timer(500, 15);
            this.intervalTimeout = new Timer(8000, 1);
            this._owner = this;
            if (stage)
            {
                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.align = StageAlign.TOP_LEFT;
            }
            Security.allowDomain("*");
            this._cacheFixed_num = setInterval(function () : void
            {
                if (stage.stageWidth != 0 && stage.stageHeight != 0)
                {
                    clearInterval(_cacheFixed_num);
                    sysInit("start");
                }
                return;
            }// end function
            , 10);
            return;
        }// end function

        public function sysInit(param1:String) : void
        {
            var flv:String;
            var sn:String;
            var str:String;
            var ran:int;
            var obj:Object;
            var myTvVid:String;
            var re:RegExp;
            var re1:RegExp;
            var flag:* = param1;
            if (flag == "start")
            {
                stage.addEventListener(Event.RESIZE, this.resizeHandler);
                PlayerConfig.vid = this.getParams("vid");
                PlayerConfig.tvid = this.getParams("tvid");
                if (this.getParams("sid") != null && this.getParams("sid") != "" && this.getParams("sid") != "null")
                {
                    PlayerConfig.sid = this.getParams("sid");
                }
                else if (Utils.getBrowserCookie("SUV") != null && Utils.getBrowserCookie("SUV") != "" && Utils.getBrowserCookie("SUV") != "null")
                {
                    PlayerConfig.sid = Utils.getBrowserCookie("SUV");
                }
                if (Utils.getBrowserCookie("pagelianbo") != "")
                {
                    PlayerConfig.lb = Utils.getBrowserCookie("pagelianbo");
                    if (Eif.available)
                    {
                        ExternalInterface.call("function(){document.cookie=\"pagelianbo=;path=/;\"}");
                    }
                }
                if (Utils.getBrowserCookie("YYID") != "")
                {
                    PlayerConfig.yyid = Utils.getBrowserCookie("YYID");
                }
                PlayerConfig.pid = this.getParams("pid");
                PlayerConfig.nid = this.getParams("nid");
                PlayerConfig.playListId = this.getParams("playListId");
                flv = unescape(this.getParams("flv"));
                PlayerConfig.isPreview = this.getParams("preview") == "true" ? (true) : (false);
                PlayerConfig.isListPlay = this.getParams("isListPlay") == "0" ? (false) : (true);
                PlayerConfig.isHisRecomm = this.getParams("isHisRecomm") == "0" ? (false) : (true);
                PlayerConfig.openListPlay = this.getParams("openListPlay") == "1" ? (true) : (false);
                PlayerConfig.showPgcModule = this.getParams("showPgcModule") == "0" || this.getParams("hasPgcMode") == "0" ? (false) : (true);
                sn = this.getParams("skinNum");
                PlayerConfig.skinNum = sn != "" && sn != "2" && sn != "5" && sn != "6" && sn != "7" ? (sn) : ("1");
                PlayerConfig.autoPlay = this.getParams("autoplay") == "true" || this.getParams("autoPlay") == "true" ? (true) : (false);
                PlayerConfig.showRecommend = this.getParams("showRecommend") == "0" ? (false) : (true);
                PlayerConfig.recommendPath = this.getParams("recommend");
                PlayerConfig.coverImg = this.getParams("playercover");
                PlayerConfig.showAds = this.getParams("adss") == "0" ? (false) : (true);
                PlayerConfig.hasApi = this.getParams("api") == "1" ? (true) : (false);
                PlayerConfig.outReferer = this.getParams("pageurl");
                PlayerConfig.isHide = this.getParams("showCtrlBar") == "0" ? (true) : (false);
                PlayerConfig.isHideTip = this.getParams("showTipHistory") == "0" ? (true) : (false);
                PlayerConfig.isJump = this.getParams("jump") == "0" ? (false) : (true);
                PlayerConfig.showCommentBtn = this.getParams("highlightBtn") == "1" ? (true) : (false);
                PlayerConfig.apiKey = this.getParams("api_key");
                PlayerConfig.acidFor56 = this.getParams("acid");
                PlayerConfig.midFor56 = this.getParams("mid");
                PlayerConfig.channelFor56 = this.getParams("channel");
                PlayerConfig.SHOW_NEXT_PLAY = this.getParams("show_next_play");
                PlayerConfig.statidFor56 = this.getParams("statid");
                PlayerConfig.liveType = this.getParams("ltype");
                if (PlayerConfig.liveType != "")
                {
                    PlayerConfig.isLive = true;
                }
                PlayerConfig.userAgent = this.getParams("ua");
                PlayerConfig.plid = this.getParams("plid");
                PlayerConfig.pub_catecode = this.getParams("pub_catecode");
                PlayerConfig.ch_key = this.getParams("ch_key");
                PlayerConfig.atype = this.getParams("atype");
                PlayerConfig.showShareBtn = this.getParams("shareBtn") == "1" ? (true) : (false);
                PlayerConfig.showSogouBtn = this.getParams("sogouBtn") == "0" ? (false) : (true);
                PlayerConfig.showWiderBtn = this.getParams("widerBtn") == "1" ? (true) : (false);
                PlayerConfig.showIFoxBar = this.getParams("iFoxBar") == "0" ? (false) : (true);
                PlayerConfig.tvIsFee = this.getParams("tv_is_fee") == "1" ? (true) : (false);
                PlayerConfig.showMiniWinBtn = this.getParams("miniWinBtn") == "1" ? (true) : (false);
                PlayerConfig.showLangSetBtn = this.getParams("langSetBtn") == "1" ? (true) : (false);
                PlayerConfig.showTopBar = this.getParams("topBar") == "1" ? (true) : (false);
                PlayerConfig.topBarNor = this.getParams("topBarNor") == "1" ? (true) : (false);
                PlayerConfig.topBarFull = this.getParams("topBarFull") == "1" ? (true) : (false);
                PlayerConfig.showDownloadBtn = this.getParams("downloadBtn") == "1" ? (true) : (false);
                PlayerConfig.startTime = this.getParams("startTime");
                PlayerConfig.endTime = this.getParams("endTime");
                PlayerConfig.adReview = this.getAdReview();
                PlayerConfig.cooperator = this.getParams("cooperator");
                PlayerConfig.isMute = this.getParams("mute") == "1" ? (true) : (false);
                PlayerConfig.passportUID = this.getPassportUID();
                PlayerConfig.passportMail = this.getPassportMail();
                PlayerConfig.xuid = this.getParams("xuid");
                PlayerConfig.onPlay = this.getParams("onPlay");
                PlayerConfig.onPause = this.getParams("onPause");
                PlayerConfig.onPlayed = this.getParams("onPlayed");
                PlayerConfig.onPlayerReady = this.getParams("onPlayerReady");
                PlayerConfig.onEndAdStop = this.getParams("onEndAdStop");
                PlayerConfig.onBufferEmpty = this.getParams("onBufferEmpty");
                PlayerConfig.onStop = this.getParams("onStop");
                PlayerConfig.onStartAdShown = this.getParams("onStartAdShown");
                PlayerConfig.onStartAdFinish = this.getParams("onStartAdFinish");
                PlayerConfig.onMAdShown = this.getParams("onMAdShown");
                PlayerConfig.onMAdFinish = this.getParams("onMAdFinish");
                PlayerConfig.isSendPID = this.getParams("isSendPID") == "1" ? (true) : (false);
                PlayerConfig.isNoP2P = this.getParams("isNoP2P") == "1" ? (true) : (false);
                PlayerConfig.showUgcAd = this.getParams("showUgcAd") == "0" ? (false) : (true);
                PlayerConfig.currentPageUrl = this.getPageURL();
                PlayerConfig.flashVersion = Capabilities.version;
                PlayerConfig.playerReffer = stage.loaderInfo.url;
                PlayerConfig.isSohuDomain = this.isSohuDomain();
                PlayerConfig.isPartner = this.isPartner();
                PlayerConfig.seekTo = this.getSeekTo();
                PlayerConfig.timestamp = new Date().getTime();
                PlayerConfig.swfHost = this.getSwfHost();
                PlayerConfig.uuid = this.getParams("uuid") != "" ? (this.getParams("uuid")) : (Utils.createUID());
                PlayerConfig.mergeid = this.getMergeid();
                PlayerConfig.txid = Utils.getBrowserCookie("_TXID") != "" ? (Utils.getBrowserCookie("_TXID")) : ("");
                PlayerConfig.lqd = Utils.getBrowserCookie("_LQD") != "" ? (Utils.getBrowserCookie("_LQD")) : ("");
                PlayerConfig.lcode = Utils.getBrowserCookie("_LCODE") != "" ? (Utils.getBrowserCookie("_LCODE")) : ("");
                PlayerConfig.clientWidth = this.getClientWidth();
                PlayerConfig.clientHeight = this.getClientHeight();
                str = PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight + "/" + PlayerConfig.VERSION;
                ran = int(int(Number(PlayerConfig.clientWidth) % 127) * int(Number(PlayerConfig.clientHeight) % 127) % 127) + 100;
                this._btnUi = new ButtonUi();
                PlayerConfig.adMd = this._btnUi.drawBtnAD(str, PlayerConfig.clientWidth, PlayerConfig.clientHeight) + ran;
                PlayerConfig.cdnMd = this._btnUi.drawBtnCDN(str, PlayerConfig.clientWidth, PlayerConfig.clientHeight) + ran;
                PlayerConfig.dmMd = this._btnUi.drawBtnDM(str, PlayerConfig.clientWidth, PlayerConfig.clientHeight) + ran;
                PlayerConfig.qsMd = this._btnUi.drawBtnQS(str, PlayerConfig.clientWidth, PlayerConfig.clientHeight) + ran;
                this._width = stage.stageWidth;
                this._height = stage.stageHeight;
                if (PlayerConfig.isSohuDomain)
                {
                    if (stage.stageWidth < 290 || stage.stageHeight < 245)
                    {
                        PlayerConfig.showRecommend = false;
                    }
                }
                else if (stage.stageWidth < 300 || stage.stageHeight < 230)
                {
                    PlayerConfig.showRecommend = false;
                }
                if (!PlayerConfig.DEBUG)
                {
                    if (Eif.available && ExternalInterface.available)
                    {
                        PlayerConfig.authorId = Utils.getJSVar("_uid");
                    }
                    this._vidFor56 = this.getParams("vid56");
                    if (this._vidFor56 != "")
                    {
                        PlayerConfig.is56 = true;
                        PlayerConfig.vid = this._vidFor56;
                    }
                    else
                    {
                        myTvVid = this.getParams("id");
                        PlayerConfig.isTransition = false;
                        PlayerConfig.isMyTvVideo = false;
                        re = /data\.vod""data\.vod/;
                        if (PlayerConfig.vid == "" && flv != "" && re.test(flv))
                        {
                            re1 = /http:\/\/""http:\/\//g;
                            var _loc_3:* = flv.replace(re1, "");
                            PlayerConfig.vid = flv.replace(re1, "");
                            PlayerConfig.vmsFlv = _loc_3;
                            PlayerConfig.isTransition = true;
                        }
                        else if (PlayerConfig.vid == "" && myTvVid != "")
                        {
                            PlayerConfig.vid = myTvVid;
                            PlayerConfig.isMyTvVideo = true;
                        }
                    }
                }
                else if (PlayerConfig.IS_MYTV_VIDEO)
                {
                    PlayerConfig.isMyTvVideo = true;
                }
                if (PlayerConfig.is56 && !PlayerConfig.DEBUG)
                {
                    this.jsCheckLoadTimer = new Timer(200, 0);
                    this.jsCheckLoadTimer.addEventListener(TimerEvent.TIMER, this.__onInterval);
                    this.jsCheckLoadTimer.start();
                    this.initJSBox();
                }
                PlayerConfig.isJump = PlayerConfig.isSohuDomain ? (false) : (true);
                PlayerConfig.hasApi = true;
                LogManager.msg("vid:" + PlayerConfig.vid + "&sid:" + PlayerConfig.sid + "&pid:" + PlayerConfig.pid + "&nid:" + PlayerConfig.nid + "&prev:" + PlayerConfig.isPreview + "&st:" + String(PlayerConfig.seekTo) + "&sk:" + String(PlayerConfig.skinNum) + "&ap:" + PlayerConfig.autoPlay + "&sr:" + PlayerConfig.showRecommend + "&rp:" + PlayerConfig.recommendPath + "&cover:" + PlayerConfig.coverImg + "&ad:" + PlayerConfig.showAds + "&api:" + PlayerConfig.hasApi + "&pu:" + PlayerConfig.outReferer + "&scb:" + !PlayerConfig.isHide + "&jump:" + PlayerConfig.isJump + "&cb:" + PlayerConfig.showCommentBtn + "&sb:" + PlayerConfig.showShareBtn + "&mwb:" + PlayerConfig.showMiniWinBtn + "&cf:" + PlayerConfig.currentPageUrl + "&fv:" + PlayerConfig.flashVersion + "&pr:" + PlayerConfig.playerReffer + "&issd:" + PlayerConfig.isSohuDomain + "&ts:" + String(PlayerConfig.timestamp) + "&sh:" + PlayerConfig.swfHost + "&uuid:" + PlayerConfig.uuid + "&ver:" + PlayerConfig.VERSION + "&&" + Capabilities.serverString);
                this.wirteCookie();
                obj = Utils.RegExpVersion();
                if (!(obj.majorVersion == 10 && obj.minorVersion == 0))
                {
                    this.setMenu();
                }
                this.newFunc();
                this.drawUi();
                this.addEvent();
                setYaheiFont();
                this._ads.selectorStartAd.container = this._selectorStartAdContainer;
                this._ads.startAd.container = this._startAdContainer;
                this._ads.endAd.container = this._endAdContainer;
                this._ads.middleAd.container = this._middleAdContainer;
                P2PExplorer.getInstance().callP2P(function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    P2PExplorer.getInstance().hasP2P = true;
                    if (param1.data != null && param1.data != "")
                    {
                        PlayerConfig.ifoxInfoObj = {ifoxVer:"", ifoxUid:"", ifoxCh:""};
                        PlayerConfig.ifoxInfoObj.ifoxVer = param1.data.split("|")[0];
                        PlayerConfig.ifoxInfoObj.ifoxUid = param1.data.split("|")[1];
                        PlayerConfig.ifoxInfoObj.ifoxCh = param1.data.split("|")[2];
                    }
                }
                else
                {
                    P2PExplorer.getInstance().hasP2P = false;
                }
                PlayerConfig.passportUID = getPassportUID();
                PlayerConfig.passportMail = getPassportMail();
                start();
                return;
            }// end function
            );
            }
            return;
        }// end function

        private function __onInterval(event:TimerEvent) : void
        {
            if (ExternalInterface.call("function(){try{if(s2j_check()==\'ok\'){return true;}}catch(ex){}}"))
            {
                this.jsCheckLoadTimer.stop();
                this.jsCheckLoadTimer = null;
                ExternalInterface.addCallback("j2s_checkPlayerLoad", this.__onCheckPlayerLoad);
            }
            return;
        }// end function

        private function __onCheckPlayerLoad() : Boolean
        {
            return true;
        }// end function

        private function initJSBox() : void
        {
            this.timer.addEventListener(TimerEvent.TIMER, this.__timerInterval);
            this.timer.start();
            this.intervalTimeout.addEventListener(TimerEvent.TIMER, this.__onTimeOutInterval);
            this.intervalTimeout.start();
            return;
        }// end function

        private function __onTimeOutInterval(event:TimerEvent) : void
        {
            this.timer.removeEventListener(TimerEvent.TIMER, this.__timerInterval);
            this.timer.stop();
            this.timer = null;
            this.intervalTimeout.removeEventListener(TimerEvent.TIMER, this.__onTimeOutInterval);
            this.intervalTimeout.stop();
            this.intervalTimeout = null;
            this.callJs("s2j_onJsCallbackAddError");
            return;
        }// end function

        private function __timerInterval(event:TimerEvent) : void
        {
            var e:* = event;
            if (ExternalInterface.call("function(){try{if(s2j_check()==\'ok\'){return true;}}catch(ex){}}"))
            {
                this.clearTimerInterval();
                try
                {
                    ExternalInterface.addCallback("j2s_setVideoResumeAll", this.playVideo);
                    ExternalInterface.addCallback("j2s_setVideoPauseAll", this.pauseVideo);
                    ExternalInterface.addCallback("j2s_parseFlashVars2Root", this.parseFlashVars2Root);
                    ExternalInterface.addCallback("j2s_getVideoSec", function () : Number
            {
                return _tvSohuMpb.core.filePlayedTime;
            }// end function
            );
                }
                catch (evt:SecurityError)
                {
                }
                this.callJs("s2j_onJsCallbackAddSuccess");
                LogManager.msg("通知js可以s2j_onJsCallbackAddSuccess");
                this.get56Cookie();
            }
            return;
        }// end function

        public function parseFlashVars2Root(param1:Object) : void
        {
            var _loc_2:* = PlayerConfig.jsCalledArr.length;
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2)
            {
                
                switch(PlayerConfig.jsCalledArr[_loc_3].param.length)
                {
                    case 0:
                    {
                        var _loc_4:* = PlayerConfig.jsCalledArr[_loc_3];
                        _loc_4.PlayerConfig.jsCalledArr[_loc_3]["func"]();
                        break;
                    }
                    case 1:
                    {
                        var _loc_4:* = PlayerConfig.jsCalledArr[_loc_3];
                        _loc_4.PlayerConfig.jsCalledArr[_loc_3]["func"](PlayerConfig.jsCalledArr[_loc_3].param[0]);
                        break;
                    }
                    case 2:
                    {
                        var _loc_4:* = PlayerConfig.jsCalledArr[_loc_3];
                        _loc_4.PlayerConfig.jsCalledArr[_loc_3]["func"](PlayerConfig.jsCalledArr[_loc_3].param[0], PlayerConfig.jsCalledArr[_loc_3].param[1]);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_3++;
            }
            PlayerConfig.jsCalledArr = [];
            return;
        }// end function

        private function callJs(param1:String, param2:String = null) : Boolean
        {
            var func_name:* = param1;
            var param:* = param2;
            try
            {
                ExternalInterface.call("function __" + func_name + "(){try{" + func_name + "(\'" + param + "\');}catch(ex){}}");
            }
            catch (evt:SecurityError)
            {
                return false;
            }
            return true;
        }// end function

        private function clearTimerInterval() : void
        {
            this.timer.removeEventListener(TimerEvent.TIMER, this.__timerInterval);
            this.timer.stop();
            this.timer = null;
            this.intervalTimeout.removeEventListener(TimerEvent.TIMER, this.__onTimeOutInterval);
            this.intervalTimeout.stop();
            this.intervalTimeout = null;
            return;
        }// end function

        private function getAdReview() : String
        {
            var _loc_1:String = "";
            if (Eif.available)
            {
                _loc_1 = ExternalInterface.call("eval", "location.hash");
            }
            var _loc_2:* = _loc_1.split("#");
            var _loc_3:* = _loc_2[(_loc_2.length - 1)];
            if (_loc_3 != null && _loc_3 != "")
            {
                return _loc_3;
            }
            return "";
        }// end function

        private function getPassportUID() : String
        {
            var passportUID:String;
            if (Eif.available)
            {
                try
                {
                    passportUID = ExternalInterface.call("eval", "(typeof sohuHD !== \'undefined\' && sohuHD.passport && sohuHD.passport.getUid && sohuHD.passport.getUid()) || (typeof PassportSC !== \'undefined\' && (PassportSC.parsePassportCookie() || PassportSC.cookie.uid || \'\'))");
                }
                catch (evt:Error)
                {
                }
            }
            return passportUID != null && passportUID != "" && passportUID != "false" ? (passportUID) : ("");
        }// end function

        private function getPassportMail() : String
        {
            var passportFor56:String;
            var passportMail:String;
            if (Eif.available)
            {
                try
                {
                    if (PlayerConfig.domainProperty == "3")
                    {
                        passportFor56 = String(Utils.getBrowserCookie("member_id")).split("@")[0].split("%")[0];
                        if (passportFor56 != null)
                        {
                            passportMail = passportFor56;
                        }
                    }
                    else
                    {
                        passportMail = ExternalInterface.call("eval", "(typeof sohuHD !== \'undefined\' && sohuHD.passport && sohuHD.passport.getPassport && sohuHD.passport.getPassport()) || (typeof PassportSC !== \'undefined\' && (PassportSC.parsePassportCookie() || PassportSC.cookieHandle()))");
                    }
                }
                catch (evt:Error)
                {
                }
            }
            PlayerConfig.landingrefer = Utils.getBrowserCookie("landingrefer");
            return passportMail != null && passportMail != "" && passportMail != "false" ? (passportMail) : ("");
        }// end function

        private function getClientWidth() : Number
        {
            var _width:Number;
            if (Eif.available)
            {
                try
                {
                    _width = ExternalInterface.call("eval", "document.documentElement.clientWidth");
                }
                catch (evt:Error)
                {
                }
            }
            return _width;
        }// end function

        private function getClientHeight() : Number
        {
            var _height:Number;
            if (Eif.available)
            {
                try
                {
                    _height = ExternalInterface.call("eval", "document.documentElement.clientHeight");
                }
                catch (evt:Error)
                {
                }
            }
            return _height;
        }// end function

        private function getSeekTo() : uint
        {
            var _loc_2:uint = 0;
            var _loc_3:Array = null;
            var _loc_4:String = null;
            var _loc_5:Array = null;
            var _loc_6:String = null;
            var _loc_1:String = "";
            if (Eif.available && PlayerConfig.isSohuDomain)
            {
                _loc_1 = ExternalInterface.call("eval", "location.hash");
            }
            if (_loc_1 != "" && _loc_1 != null)
            {
                _loc_3 = _loc_1.split("#");
                _loc_4 = _loc_3[(_loc_3.length - 1)];
                _loc_5 = _loc_4.split("_");
                if (_loc_5.length > 1)
                {
                    this._isSeekToNoTip = true;
                    _loc_6 = _loc_5[(_loc_5.length - 1)];
                    if (_loc_6 != null && _loc_6 != "" && Number(_loc_6) > 0)
                    {
                        _loc_2 = uint(_loc_6);
                    }
                }
                else if (_loc_4 != null && _loc_4 != "" && Number(_loc_4) > 0)
                {
                    _loc_2 = uint(_loc_4);
                }
                else
                {
                    _loc_2 = uint(this.getParams("seekTo"));
                }
            }
            else
            {
                _loc_2 = uint(this.getParams("seekTo"));
            }
            PlayerConfig.tempParam = _loc_2 > 0 ? (true) : (false);
            return _loc_2;
        }// end function

        private function getMergeid() : String
        {
            var json:Object;
            var mergeid:String;
            if (Eif.available)
            {
                try
                {
                    json = new JSON().parse(ExternalInterface.call("returnUserIdsList"));
                    if (json != null && json != "" && json.ifox != null && json.ifox != "")
                    {
                        mergeid = json.ifox;
                    }
                }
                catch (evt:Error)
                {
                }
            }
            return mergeid;
        }// end function

        private function setMenu() : void
        {
            this._cm = new ContextMenu();
            var _loc_1:* = PlayerConfig.swfHost.split("/");
            var _loc_2:* = _loc_1[_loc_1.length - 2];
            var _loc_3:* = new ContextMenuItem("画面调节...");
            var _loc_4:* = new ContextMenuItem("色彩调节...");
            var _loc_5:* = new ContextMenuItem("视频信息");
            var _loc_6:* = new ContextMenuItem("复制视频地址");
            var _loc_7:* = new ContextMenuItem("复制当前时间视频地址");
            var _loc_8:* = new ContextMenuItem("意见反馈");
            var _loc_9:* = new ContextMenuItem("查看Log");
            var _loc_10:* = new ContextMenuItem("查看面板信息");
            var _loc_11:* = new ContextMenuItem("noAdsLive" + "SohuTVPlayer:" + PlayerConfig.VERSION);
            var _loc_12:* = new ContextMenuItem("FlashPlayer:" + PlayerConfig.flashVersion);
            var _loc_13:* = new ContextMenuItem("用户ID:" + PlayerConfig.userId);
            _loc_3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.showDSPanel);
            _loc_4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.showCSPanel);
            _loc_5.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.showVideoInfoPanel);
            _loc_6.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.copyVideoPath);
            _loc_7.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.copyVideoHotPath);
            _loc_8.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.gotoTvSohuBlog);
            _loc_9.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.gotoCopyLog);
            _loc_10.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.showPanelVer);
            var _loc_14:Boolean = false;
            _loc_13.enabled = false;
            var _loc_14:* = _loc_14;
            _loc_12.enabled = _loc_14;
            _loc_11.enabled = _loc_14;
            var _loc_14:Boolean = true;
            _loc_11.separatorBefore = true;
            var _loc_14:* = _loc_14;
            _loc_8.separatorBefore = _loc_14;
            _loc_6.separatorBefore = _loc_14;
            this._cm.hideBuiltInItems();
            this._cm.customItems.push(_loc_3);
            this._cm.customItems.push(_loc_4);
            this._cm.customItems.push(_loc_5);
            this._cm.customItems.push(_loc_6);
            this._cm.customItems.push(_loc_7);
            this._cm.customItems.push(_loc_8);
            this._cm.customItems.push(_loc_9);
            this._cm.customItems.push(_loc_10);
            this._cm.customItems.push(_loc_11);
            this._cm.customItems.push(_loc_12);
            this._cm.customItems.push(_loc_13);
            this.contextMenu = this._cm;
            this._cm.addEventListener(ContextMenuEvent.MENU_SELECT, this.menuSelectHandler);
            this.shieldRightMenuItem();
            return;
        }// end function

        private function menuSelectHandler(event:ContextMenuEvent) : void
        {
            return;
        }// end function

        private function showVideoInfoPanel(event:ContextMenuEvent) : void
        {
            if (this._tvSohuMpb != null)
            {
                this._tvSohuMpb.showVideoInfoPanel();
            }
            return;
        }// end function

        private function showDSPanel(event:ContextMenuEvent) : void
        {
            if (this._tvSohuMpb != null)
            {
                this._tvSohuMpb.showSettingPanel("CLICK");
            }
            return;
        }// end function

        private function showCSPanel(event:ContextMenuEvent) : void
        {
            if (this._tvSohuMpb != null)
            {
                this._tvSohuMpb.showSettingPanel("CLICK");
            }
            return;
        }// end function

        private function gotoTvSohuBlog(event:ContextMenuEvent) : void
        {
            this._qfStat.sendFeedback();
            return;
        }// end function

        private function gotoCopyLog(event:ContextMenuEvent = null) : void
        {
            this._logsPanel.resize(stage.stageWidth, stage.stageHeight - 42);
            if (PlayerConfig.isLive && this._tvSohuMpb != null && this._tvSohuMpb.core != null && this._tvSohuMpb.core.peerId != null)
            {
                LogManager.msg("peerId:" + this._tvSohuMpb.core.peerId);
            }
            if (!this._logsPanel.isOpen)
            {
                this._logsPanel.open();
            }
            else
            {
                this._logsPanel.close();
            }
            this.setChildIndex(this._logsPanel, (this.numChildren - 1));
            return;
        }// end function

        private function showPanelVer(event:ContextMenuEvent) : void
        {
            this._verInfoPanel.resize(stage.stageWidth, stage.stageHeight - 42);
            if (!this._verInfoPanel.isOpen && VerLog.getMsg() != "")
            {
                this._verInfoPanel.open();
            }
            else
            {
                this._verInfoPanel.close();
            }
            this.setChildIndex(this._verInfoPanel, (this.numChildren - 1));
            return;
        }// end function

        private function closeStageVideo(event:ContextMenuEvent) : void
        {
            var _loc_2:String = null;
            this._svdUserSo = SharedObject.getLocal("svdUserTip", "/");
            this._svdUserSo.clear();
            this._svdUserSo.data.svdTag = "0";
            try
            {
                _loc_2 = this._svdUserSo.flush();
                if (_loc_2 == SharedObjectFlushStatus.PENDING)
                {
                    this._svdUserSo.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                }
                else if (_loc_2 == SharedObjectFlushStatus.FLUSHED)
                {
                }
            }
            catch (e:Error)
            {
            }
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_CloseSpeedUp&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            if (Eif.available && ExternalInterface.available)
            {
                ExternalInterface.call("swfClose3D");
            }
            return;
        }// end function

        private function gotoStageVideo(event:Event = null) : void
        {
            this._bg.visible = false;
            if (this._tvSohuMpb != null && this._tvSohuMpb.core != null)
            {
                this._tvSohuMpb.core.toggleVideoMode();
            }
            return;
        }// end function

        private function gotoVideo(event:Event = null) : void
        {
            this._bg.visible = true;
            if (this._tvSohuMpb != null && this._tvSohuMpb.core != null)
            {
                this._tvSohuMpb.core.toggleVideoMode();
            }
            return;
        }// end function

        private function copyVideoPath(event:ContextMenuEvent) : void
        {
            System.setClipboard(PlayerConfig.filePrimaryReferer);
            return;
        }// end function

        private function copyVideoHotPath(event:ContextMenuEvent) : void
        {
            System.setClipboard(PlayerConfig.filePrimaryReferer + "#" + PlayerConfig.playedTime);
            return;
        }// end function

        private function getSwfHost() : String
        {
            var _loc_1:* = stage.loaderInfo.url;
            _loc_1 = _loc_1.split("?")[0];
            var _loc_2:* = _loc_1.lastIndexOf("/");
            var _loc_3:* = _loc_1.substr(0, (_loc_2 + 1));
            return _loc_3;
        }// end function

        private function getPageURL() : String
        {
            var _loc_1:String = "";
            if (Eif.available)
            {
                _loc_1 = ExternalInterface.call("eval", "document.URL");
            }
            return _loc_1;
        }// end function

        private function isSohuDomain() : Boolean
        {
            var _loc_1:* = PlayerConfig.currentPageUrl == "" ? (PlayerConfig.outReferer) : (PlayerConfig.currentPageUrl);
            if (_loc_1 == null || _loc_1 == "")
            {
                return false;
            }
            if (_loc_1.split(stage.loaderInfo.url).length >= 2)
            {
                return false;
            }
            var _loc_2:* = /\/([^\/]+)""\/([^\/]+)/;
            var _loc_3:* = PlayerConfig.SOHU_MATRIX;
            var _loc_4:* = _loc_1.match(_loc_2);
            if (_loc_1.match(_loc_2) == null)
            {
                return false;
            }
            var _loc_5:* = String(_loc_4[1]);
            var _loc_6:int = 0;
            while (_loc_6 < _loc_3.length)
            {
                
                if (new RegExp(_loc_3[_loc_6], "i").test(_loc_5))
                {
                    PlayerConfig.domainProperty = "2";
                    if (new RegExp(PlayerConfig.TV_SOHU, "i").test(_loc_5))
                    {
                        PlayerConfig.domainProperty = "0";
                        return true;
                    }
                    if (new RegExp("56\\.com$", "i").test(_loc_5))
                    {
                        PlayerConfig.domainProperty = "3";
                        return true;
                    }
                    if (new RegExp("admin\\.tv\\.sohuno\\.com$", "i").test(_loc_5) || new RegExp("cap\\.tv\\.sohuno\\.com$", "i").test(_loc_5))
                    {
                        PlayerConfig.domainProperty = "4";
                        return true;
                    }
                    return true;
                }
                _loc_6++;
            }
            PlayerConfig.domainProperty = "1";
            return false;
        }// end function

        private function isPartner() : Boolean
        {
            var _loc_1:* = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
            if (_loc_1 == null || _loc_1 == "")
            {
                return false;
            }
            if (_loc_1.split(stage.loaderInfo.url).length >= 2)
            {
                return false;
            }
            var _loc_2:* = /\/([^\/]+)""\/([^\/]+)/;
            var _loc_3:Array = ["taohua\\.com$", "taohua\\.net$", "yunhd\\.unikaixin\\.com$", "baishi\\.baidu\\.com$", "v\\.baidu\\.com$"];
            var _loc_4:* = _loc_1.match(_loc_2);
            if (_loc_1.match(_loc_2) == null)
            {
                return false;
            }
            var _loc_5:* = String(_loc_4[1]);
            var _loc_6:int = 0;
            while (_loc_6 < _loc_3.length)
            {
                
                if (new RegExp(_loc_3[_loc_6], "i").test(_loc_5))
                {
                    return true;
                }
                _loc_6++;
            }
            return false;
        }// end function

        private function specialDomain(param1:String, param2:Array) : Boolean
        {
            var _loc_3:* = param1;
            if (_loc_3 == null || _loc_3 == "")
            {
                return false;
            }
            if (_loc_3.split(stage.loaderInfo.url).length >= 2)
            {
                return false;
            }
            var _loc_4:* = /\/([^\/]+)""\/([^\/]+)/;
            var _loc_5:* = param2;
            var _loc_6:* = _loc_3.match(_loc_4);
            if (_loc_3.match(_loc_4) == null)
            {
                return false;
            }
            var _loc_7:* = String(_loc_6[1]);
            var _loc_8:int = 0;
            while (_loc_8 < _loc_5.length)
            {
                
                if (new RegExp(_loc_5[_loc_8], "i").test(_loc_7))
                {
                    return true;
                }
                _loc_8++;
            }
            return false;
        }// end function

        private function createMpb() : void
        {
            if (this._tvSohuMpb == null)
            {
                if (stage.loaderInfo.parameters["showMode"] == "pr")
                {
                    this._tvSohuMpb = RadioMpb.getInstance();
                }
                else if (stage.loaderInfo.parameters["showMode"] == "360")
                {
                    this._tvSohuMpb = TSZMpb.getInstance();
                }
                else
                {
                    this._tvSohuMpb = TvSohuMediaPlayback.getInstance();
                }
                addChild(this._tvSohuMpb);
                this.swapChildren(this._tvSohuMpb, this._startAdContainer);
                this._tvSohuMpb.hardInit({buffer:3, width:this._width, height:this._height, core:"", isHide:PlayerConfig.isHide, hardInitHandler:this.onMpbHardInit, skinPath:"http://tv.sohu.com/upload/swf/20160505/" + "skins/s" + PlayerConfig.skinNum + ".swf", selectorStartAdContainer:this._selectorStartAdContainer, startAdContainer:this._startAdContainer, endAdContainer:this._endAdContainer, middleAdContainer:this._middleAdContainer, stage:this.stage});
                this._tvSohuMpb.addEventListener("liveCoreVer", function (event:Event) : void
            {
                var _loc_2:* = new ContextMenuItem("PLCore:" + _tvSohuMpb.liveCoreVer);
                _loc_2.enabled = false;
                _cm.customItems.push(_loc_2);
                return;
            }// end function
            );
            }
            else if (!this._mpbSoftInitSuc)
            {
                if (PlayerConfig.isFms && PlayerConfig.currentCore != "TvSohuFMSCore" || !PlayerConfig.isFms && PlayerConfig.currentCore != "TvSohuVideoCore")
                {
                    this._tvSohuMpb.setLoadCore(this.softInitAndContinue);
                }
                else if (PlayerConfig.isLive && this._tvSohuMpb.core != null && this._tvSohuMpb.core.initP2P != null)
                {
                    this._tvSohuMpb.core.initP2P(this.softInitAndContinue);
                }
                else
                {
                    this.softInitAndContinue();
                }
            }
            return;
        }// end function

        private function onMpbHardInit(param1:Object) : void
        {
            if (param1.info == "success")
            {
                this.addMpbEvent();
                if (!this._mpbSoftInitSuc)
                {
                    this.softInitAndContinue();
                }
                ;
            }
            return;
        }// end function

        private function softInitAndContinue() : void
        {
            this.softInitMpb();
            if (this._isAutoPlay)
            {
                if (TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing")
                {
                    if (!PlayerConfig.isFms)
                    {
                        this._tvSohuMpb.core.play();
                        this._tvSohuMpb.core.pause();
                    }
                }
                else
                {
                    this._tvSohuMpb.core.play();
                }
            }
            else if (this._isRollbackWaitAds && !this._isAutoPlay)
            {
                this._tvSohuMpb.core.play();
                this._tvSohuMpb.core.pause();
            }
            else
            {
                this._tvSohuMpb.showCover();
            }
            return;
        }// end function

        private function softInitMpb() : void
        {
            var _loc_1:Object = null;
            var _loc_2:uint = 0;
            this._tvSohuMpb.softInit(this._mpbSoftInitObj);
            if (this._tvSohuMpb != null)
            {
                if (!(PlayerConfig.skinNum == "-1" && stage.loaderInfo.parameters["os"] == "android"))
                {
                    if (this._tvSohuMpb.skin != null && this._isDownPreviewPic)
                    {
                        this._tvSohuMpb.setHighDot();
                    }
                }
                this._tvSohuMpb.isShowNextTitle = false;
            }
            PlayerConfig.videoArr = this._tvSohuMpb.core.videoArr;
            if (Eif.available && ExternalInterface.available)
            {
                _loc_1 = ExternalInterface.call("getVrsPlayerHistory", PlayerConfig.vid, PlayerConfig.pid, 0, 0, PlayerConfig.videoTitle);
            }
            if (PlayerConfig.previewTime == 0 && this._breakPoint <= 0)
            {
                if (PlayerConfig.seekTo > 0 && PlayerConfig.seekTo < PlayerConfig.totalDuration)
                {
                    if (!this._isSeekToNoTip)
                    {
                        PlayerConfig.flashCookieLastTime = PlayerConfig.seekTo;
                    }
                    this._breakPoint = Number(PlayerConfig.seekTo);
                }
                else if (_loc_1 != null && String(_loc_1.success) == "5" && Number(_loc_1.lastTime) <= this._tvSohuMpb.core.fileTotTime - 6 && this._isDrag && !this._isLoop)
                {
                    PlayerConfig.tempLastTime = _loc_1.lastTime;
                    this._breakPoint = Number(PlayerConfig.tempLastTime);
                }
                else
                {
                    this._so = SharedObject.getLocal("playHistory", "/");
                    if (this._so.data.list != undefined)
                    {
                        _loc_2 = 0;
                        while (_loc_2 < this._so.data.list.length)
                        {
                            
                            if (this._so.data.list[_loc_2].vid == PlayerConfig.vid && Number(this._so.data.list[_loc_2].playedTime) >= 6 && Number(this._so.data.list[_loc_2].playedTime) <= this._tvSohuMpb.core.fileTotTime - 6 && this._isDrag)
                            {
                                PlayerConfig.flashCookieLastTime = this._so.data.list[_loc_2].playedTime;
                                this._breakPoint = Number(PlayerConfig.flashCookieLastTime);
                            }
                            if (this._so.data.list[_loc_2].vid == PlayerConfig.superVid || this._so.data.list[_loc_2].vid == PlayerConfig.hdVid || this._so.data.list[_loc_2].vid == PlayerConfig.norVid)
                            {
                                var _loc_3:* = PlayerConfig;
                                var _loc_4:* = PlayerConfig.currentVideoReplayNum + 1;
                                _loc_3.currentVideoReplayNum = _loc_4;
                            }
                            _loc_2 = _loc_2 + 1;
                        }
                    }
                    else if (_loc_1 != null && (String(_loc_1.success) == "3" || String(_loc_1.success) == "1" && Number(_loc_1.lastTime) >= 30) && Number(_loc_1.lastTime) >= 6 && Number(_loc_1.lastTime) <= this._tvSohuMpb.core.fileTotTime - 6 && this._isDrag)
                    {
                        PlayerConfig.tempLastTime = _loc_1.lastTime;
                        this._breakPoint = Number(PlayerConfig.tempLastTime);
                    }
                    this._so = SharedObject.getLocal("so", "/");
                    if (this._so.data.isJEC != undefined)
                    {
                        this._tvSohuMpb.isJumpEndCaption = Boolean(this._so.data.isJEC);
                    }
                    else
                    {
                        this._tvSohuMpb.isJumpEndCaption = true;
                    }
                    if (this._so.data.isJSC != undefined)
                    {
                        this._tvSohuMpb.isJumpStartCaption = Boolean(this._so.data.isJSC);
                    }
                    else
                    {
                        this._tvSohuMpb.isJumpStartCaption = true;
                    }
                    if (this._so.data.isViewTimer != undefined)
                    {
                        this._tvSohuMpb.isViewTimer = Boolean(this._so.data.isViewTimer);
                    }
                    else
                    {
                        this._tvSohuMpb.isViewTimer = true;
                    }
                }
            }
            if (this._breakPoint <= 0 && PlayerConfig.stTime >= 6 && PlayerConfig.stTime <= this._tvSohuMpb.core.fileTotTime - 6 && this._isDrag && this._tvSohuMpb.isJumpStartCaption)
            {
                var _loc_3:* = PlayerConfig.stTime;
                this._breakPoint = PlayerConfig.stTime;
                PlayerConfig.preludeTime = _loc_3;
            }
            if (this._breakPoint >= 6 && this._breakPoint <= this._tvSohuMpb.core.fileTotTime - 6 && this._isDrag)
            {
                if (PlayerConfig.isWebP2p && !PlayerConfig.autoPlay)
                {
                    this._isDelaySeek = true;
                }
                else
                {
                    this._tvSohuMpb.core.seek(this._breakPoint);
                }
            }
            this._mpbSoftInitSuc = true;
            return;
        }// end function

        private function start() : void
        {
            var _loc_2:SharedObject = null;
            var _loc_3:String = null;
            var _loc_4:Boolean = false;
            var _loc_1:String = "";
            this._so = SharedObject.getLocal("vmsPlayer", "/");
            if (this._so.data.ver != undefined && this._so.data.ver != "" && String(this._so.data.ver) != "0")
            {
                var _loc_5:* = this._so.data.ver;
                this._version = this._so.data.ver;
                PlayerConfig.definition = _loc_5;
            }
            if (this._so.data.bw != undefined && this._so.data.bw != "" && String(this._so.data.bw) != "0")
            {
                this._bandwidth = this._so.data.bw;
            }
            if (this._so.data.af != undefined && this._so.data.af != "" && String(this._so.data.af) != "0")
            {
                var _loc_5:* = this._so.data.af;
                this._autoFix = this._so.data.af;
                PlayerConfig.autoFix = _loc_5;
            }
            else if (this._so.data.ver == undefined || this._so.data.ver == "" || String(this._so.data.ver) == "0")
            {
                var _loc_5:String = "1";
                this._autoFix = "1";
                PlayerConfig.autoFix = _loc_5;
                try
                {
                    _loc_2.data.af = this._autoFix;
                    _loc_3 = _loc_2.flush();
                    if (_loc_3 == SharedObjectFlushStatus.PENDING)
                    {
                        _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                    }
                    else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                    {
                    }
                }
                catch (e:Error)
                {
                }
            }
            if (PlayerConfig.DEBUG)
            {
                _loc_1 = PlayerConfig.DEBUG_VID;
                PlayerConfig.pid = PlayerConfig.DEBUG_PID;
            }
            else
            {
                _loc_1 = PlayerConfig.vid;
            }
            if (!PlayerConfig.tvIsFee && (this._version == "31" || this._version == "51"))
            {
                _loc_4 = this._version == "31" ? (true) : (false);
                this.checkOriMkey(false, _loc_4);
                return;
            }
            if (PlayerConfig.autoPlay)
            {
                this.loadAndPlay(_loc_1);
            }
            else
            {
                this.loadAndPause(_loc_1);
            }
            return;
        }// end function

        public function resizeHandler(param1 = null) : void
        {
            this._width = stage.stageWidth;
            this._height = stage.stageHeight;
            if (this._tvSohuMpb != null && this._tvSohuMpb.core != null)
            {
                this._tvSohuMpb.resize(this._width, this._height);
            }
            else
            {
                if (this._ads.startAd.hasAd)
                {
                    this._ads.startAd.resize(this._width, this._height);
                }
                if (this._ads.selectorStartAd.hasAd)
                {
                    this._ads.selectorStartAd.resize(this._width, this._height);
                }
            }
            this.resize();
            return;
        }// end function

        private function getParams(param1:String) : String
        {
            var _loc_2:String = "";
            if (stage.loaderInfo.parameters[param1] != null)
            {
                _loc_2 = String(stage.loaderInfo.parameters[param1]);
                _loc_2 = _loc_2.replace(new RegExp("\\^", "g"), "&");
            }
            return _loc_2;
        }// end function

        private function newFunc() : void
        {
            this._ads = TvSohuAds.getInstance(this.stage);
            this._qfStat = ErrorSenderPQ.getInstance();
            var _loc_1:* = this.getParams("ltype");
            this._qfStat.qfltype = this.getParams("ltype");
            InforSender.getInstance().ifltype = _loc_1;
            this._model = Model.getInstance();
            return;
        }// end function

        private function drawUi() : void
        {
            this._tvSohuLoading_c = new Sprite();
            this._selectorStartAdContainer = new Sprite();
            this._startAdContainer = new Sprite();
            this._endAdContainer = new Sprite();
            this._middleAdContainer = new Sprite();
            this._errStatusSp = new Sprite();
            this._logsPanel = new LogsPanel(stage.stageWidth, stage.stageHeight - 42);
            this._logsPanel.close(0);
            this._verInfoPanel = new VerInfoPanel(stage.stageWidth, stage.stageHeight - 42);
            this._verInfoPanel.close(0);
            this._bg = new Sprite();
            Utils.drawRect(this._bg, 0, 0, stage.stageWidth, stage.stageHeight, 0, 1);
            addChild(this._bg);
            addChild(this._selectorStartAdContainer);
            addChild(this._startAdContainer);
            addChild(this._tvSohuLoading_c);
            addChild(this._errStatusSp);
            addChild(this._logsPanel);
            addChild(this._verInfoPanel);
            this.resize();
            return;
        }// end function

        private function addEvent() : void
        {
            this._model.addEventListener(Model.VINFO_LOAD_SUCCESS, this.vinfoLoadSuccess);
            this._model.addEventListener(Model.VINFO_LOAD_TIMEOUT, this.vinfoLoadTimeout);
            this._model.addEventListener(Model.VINFO_LOAD_IOERROR, this.vinfoLoadIoError);
            this._model.addEventListener(Model.VINFO_DATA_EMPTY, this.vinfoDataEmpty);
            this._model.addEventListener(Model.VINFO_VID_INVALID, this.vinfoVidInvalid);
            this._model.addEventListener(Model.QUICK_MODE, this.showQuickPanel);
            this._ads.selectorStartAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN, this.startAdShown);
            this._ads.startAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN, this.startAdShown);
            this._ads.startAd.addEventListener(TvSohuAdsEvent.START_AD_LOADED, this.startAdLoaded);
            this._ads.startAd.addEventListener(TvSohuAdsEvent.SCREEN_LOAD_FAILED, this.startAdLoadFailed);
            this._ads.startAd.addEventListener(TvSohuAdsEvent.SCREENFINISH, this.screenAdFinish);
            this._ads.startAd.addEventListener(TvSohuAdsEvent.START_AD_ILLEGAL, this.adPlayIllegal);
            this._ads.startAd.addEventListener("to_has_sound_icon", this.adsVolume);
            this._ads.startAd.addEventListener("to_no_sound_icon", this.adsMute);
            this._ads.endAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN, this.endAdShown);
            this._ads.endAd.addEventListener(TvSohuAdsEvent.ENDFINISH, this.endAdFinish);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.keyboardUpHandler);
            stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, this.stageVideoAvailabilityHandler);
            stage.addEventListener("throttle", this.onThrottle);
            loaderInfo.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, this.uncaughtErrorHandler);
            return;
        }// end function

        private function sendLogs(event:MouseEvent) : void
        {
            this._qfStat.sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"player", code:PlayerConfig.BUFFER_CODE, error:"", debuginfo:"主播放器日志：" + LogManager.getMsg() + "|p2p日志：" + P2pLog.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
            return;
        }// end function

        private function showQuickPanel(event:Event) : void
        {
            var evt:* = event;
            new LoaderUtil().load(20, function (param1:Object) : void
            {
                var content:*;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    content = obj.data.content;
                    addChild(content);
                    content.close(0);
                    content.init(stage.stageWidth, stage.stageHeight);
                    content.open();
                    content.addEventListener("startPlay", function (event:Event) : void
                {
                    if (PlayerConfig.isLive && PlayerConfig.hasP2PLive)
                    {
                        toP2PLive();
                    }
                    removeChild(content);
                    return;
                }// end function
                );
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/QuickLivePanel.swf");
            return;
        }// end function

        private function loadLoading(param1:String) : void
        {
            var url:* = param1;
            new LoaderUtil().load(3, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    _tvSohuLoading = param1.data.content;
                    _tvSohuLoading.hardInit({width:stage.stageWidth, height:stage.stageHeight});
                    _tvSohuLoading_c.addChild(_tvSohuLoading);
                    dispatchEvent(new Event("hideShellLoading"));
                }
                return;
            }// end function
            , null, url);
            return;
        }// end function

        private function addMpbEvent() : void
        {
            this._tvSohuMpb.core.addEventListener(MediaEvent.PAUSE, this.onPause);
            this._tvSohuMpb.core.addEventListener(MediaEvent.PLAY, this.onPlay);
            this._tvSohuMpb.core.addEventListener(MediaEvent.PLAYED, this.onPlayed);
            this._tvSohuMpb.core.addEventListener(MediaEvent.STOP, this.onStop);
            this._tvSohuMpb.core.addEventListener(MediaEvent.CONNECTING, this.onMediaConnecting);
            this._tvSohuMpb.core.addEventListener("live_overload", this.toP2PLive);
            this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.SUPER_BUTTON_MOUSEUP, this.changeSuperVideo);
            this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.COMMON_BUTTON_MOUSEUP, this.changeCommonVideo);
            this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.HD_BUTTON_MOUSEUP, this.changeHdVideo);
            this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.ORI_BUTTON_MOUSEUP, this.changeYYYVideo);
            this._tvSohuMpb.addEventListener(TvSohuMediaPlayback.EXTREME_BUTTON_MOUSEUP, this.changeExtremeVideo);
            this._tvSohuMpb.addEventListener("retryPanel_shown", this.retryPanelShown);
            this._tvSohuMpb.addEventListener("playListVideo", this.playListVideo);
            this._tvSohuMpb.addEventListener("videoDestroy", this.videoDestroy);
            this._tvSohuMpb.addEventListener("ChangeAutoPlay", function (event:Event) : void
            {
                _isAutoPlay = true;
                return;
            }// end function
            );
            this._tvSohuMpb.addEventListener("skinLoadSuccess", function (event:Event) : void
            {
                dispatchEvent(new Event("hideShellLoading"));
                startPlayListLoop();
                return;
            }// end function
            );
            this._tvSohuMpb.addEventListener("gotoStageVideo", this.gotoStageVideo);
            this._tvSohuMpb.addEventListener("gotoVideo", this.gotoVideo);
            this._tvSohuMpb.core.addEventListener("PFVNetStreamError", this.rollbackFor56);
            if (PlayerConfig.hasApi && Eif.available)
            {
                try
                {
                    ExternalInterface.addCallback("playVideo", this.playVideo);
                    ExternalInterface.addCallback("pauseVideo", this.pauseVideo);
                    ExternalInterface.addCallback("stopVideo", this._tvSohuMpb.core.stop);
                    ExternalInterface.addCallback("webUnload", this.webUnload);
                    ExternalInterface.addCallback("getUUID", function () : String
            {
                return PlayerConfig.uuid;
            }// end function
            );
                    ExternalInterface.addCallback("destroyVideo", function () : void
            {
                _tvSohuMpb.core.destroy();
                return;
            }// end function
            );
                    ExternalInterface.addCallback("playerState", function () : String
            {
                return _tvSohuMpb.core.streamState;
            }// end function
            );
                    ExternalInterface.addCallback("seekTo", this._tvSohuMpb.seekTo);
                    ExternalInterface.addCallback("playedTime", function () : Number
            {
                return _tvSohuMpb.core.filePlayedTime;
            }// end function
            );
                    ExternalInterface.addCallback("videoTotTime", function () : Number
            {
                if (_tvSohuMpb.core != null)
                {
                    return Math.floor(_tvSohuMpb.core.fileTotTime);
                }
                return 0;
            }// end function
            );
                    ExternalInterface.addCallback("videoWidth", function () : Number
            {
                if (_tvSohuMpb.core != null)
                {
                    return Math.floor(_tvSohuMpb.core.metaWidth);
                }
                return 0;
            }// end function
            );
                    ExternalInterface.addCallback("videoHeight", function () : Number
            {
                if (_tvSohuMpb.core != null)
                {
                    return Math.floor(_tvSohuMpb.core.metaHeight);
                }
                return 0;
            }// end function
            );
                    ExternalInterface.addCallback("setVolume", function (param1:Number) : void
            {
                if (_tvSohuMpb.core != null)
                {
                    _tvSohuMpb.core.volume = param1;
                }
                return;
            }// end function
            );
                    ExternalInterface.addCallback("getCount", function () : String
            {
                return ErrorSenderPQ.getInstance().getPlayCount();
            }// end function
            );
                    ExternalInterface.addCallback("commonMode", this._tvSohuMpb.toCommonMode);
                    ExternalInterface.addCallback("getDebugInfo", function () : Object
            {
                var _loc_1:Object = {debugInfo:"-1", volume:-1, averageSpeed:"-1", rate:"-1", os:"-1", currentNewFile:""};
                _loc_1.debugInfo = LogManager.getMsg();
                if (_tvSohuMpb != null)
                {
                    _loc_1.volume = _tvSohuMpb.core.volume;
                    _loc_1.rate = _tvSohuMpb.core.vrate;
                    _loc_1.os = Capabilities.os;
                    if (PlayerConfig.synUrl != null && PlayerConfig.synUrl[_tvSohuMpb.core.downloadIndex] != null)
                    {
                        _loc_1.currentNewFile = PlayerConfig.synUrl[_tvSohuMpb.core.downloadIndex];
                    }
                    if (_tvSohuMpb.videoInfoPanel != null)
                    {
                        _loc_1.averageSpeed = _tvSohuMpb.videoInfoPanel.averageSpeed;
                    }
                }
                return _loc_1;
            }// end function
            );
                    if (PlayerConfig.isTransition)
                    {
                        ExternalInterface.addCallback("externalPlay", this._tvSohuMpb.core.play);
                        ExternalInterface.addCallback("externalPause", this._tvSohuMpb.core.pause);
                        ExternalInterface.addCallback("externalStop", this._tvSohuMpb.core.stop);
                        ExternalInterface.addCallback("getCurrentTime", function () : Number
            {
                return Math.floor(_tvSohuMpb.core.filePlayedTime);
            }// end function
            );
                        ExternalInterface.call("playerLoaded");
                    }
                    if (PlayerConfig.onPlayerReady != "")
                    {
                        ExternalInterface.call(PlayerConfig.onPlayerReady);
                    }
                    if (PlayerConfig.showWiderBtn)
                    {
                        ExternalInterface.addCallback("externalCinema", this._tvSohuMpb.toCinemaMode);
                    }
                    ExternalInterface.addCallback("ctrlBarVisible", this.setCtrlBarVisible);
                    ExternalInterface.addCallback("startCutImgToBoundPage", this._tvSohuMpb.startCutImgToBoundPage);
                    ExternalInterface.addCallback("updateUserLoginInfo", this.updateUserLoginInfo);
                    if (stage.loaderInfo.parameters["showMode"] == "radio")
                    {
                        ExternalInterface.addCallback("setNextVideo", this._tvSohuMpb.setNextVideo);
                        ExternalInterface.addCallback("loadAndPlay", this.loadAndPlay);
                        ExternalInterface.addCallback("setBtnState", this._tvSohuMpb.setBtnState);
                    }
                    if (PlayerConfig.voteRegion != "" && PlayerConfig.voteRegion == "1" && PlayerConfig.voteId != "")
                    {
                        if (Eif.available && ExternalInterface.available)
                        {
                            ExternalInterface.call("initPageVote", PlayerConfig.voteId);
                        }
                    }
                }
                catch (evt:SecurityError)
                {
                }
            }
            return;
        }// end function

        private function toP2PLive(event:Event = null) : void
        {
            PlayerConfig.needP2PLive = true;
            this.loadAndPlay(PlayerConfig.vid);
            return;
        }// end function

        private function rollbackFor56(event:Event = null) : void
        {
            LogManager.msg("PFVNetStreamError" + " : : PFVNetStreamErrorType : " + this._tvSohuMpb.core.PFVNetStreamErrorType);
            if (this._tvSohuMpb.core.PFVNetStreamErrorType == "0")
            {
                LogManager.msg((PlayerConfig.isWSP2p ? ("wsp2p") : ("56cdn")) + "当前播放" + PlayerConfig.rfilesType + "出现异常！");
                if (PlayerConfig.rfilesType == "clear")
                {
                    if (PlayerConfig.definitionArrFor56.indexOf("super") == -1)
                    {
                        if (PlayerConfig.definitionArrFor56.indexOf("normal") == -1)
                        {
                            LogManager.msg("启动回滚逻辑保持" + (PlayerConfig.isWSP2p ? ("56cdn") : ("wsp2p")) + "模式尝试标清视频播放");
                            if (PlayerConfig.isWSP2p)
                            {
                                this._isRollbackFor56cdn = true;
                            }
                            else
                            {
                                this._isRollbackFor56cdn = false;
                            }
                            this.changeHdVideo();
                        }
                        else
                        {
                            LogManager.msg("启动回滚逻辑保持wsp2p模式切换到标清尝试播放");
                            this.changeCommonVideo();
                        }
                    }
                    else
                    {
                        LogManager.msg("启动回滚逻辑保持wsp2p模式切换到超清尝试播放");
                        this.changeSuperVideo();
                    }
                }
                else if (PlayerConfig.rfilesType == "normal")
                {
                    if (PlayerConfig.definitionArrFor56.indexOf("super") == -1)
                    {
                        if (PlayerConfig.definitionArrFor56.indexOf("clear") == -1)
                        {
                            LogManager.msg("启动回滚逻辑保持" + (PlayerConfig.isWSP2p ? ("56cdn") : ("wsp2p")) + "模式尝试标清视频播放");
                            if (PlayerConfig.isWSP2p)
                            {
                                this._isRollbackFor56cdn = true;
                            }
                            else
                            {
                                this._isRollbackFor56cdn = false;
                            }
                            this.changeCommonVideo();
                        }
                        else
                        {
                            LogManager.msg("启动回滚逻辑保持" + (PlayerConfig.isWSP2p ? ("wsp2p") : ("56cdn")) + "模式切换到高清尝试播放");
                            this.changeHdVideo();
                        }
                    }
                    else
                    {
                        LogManager.msg("启动回滚逻辑保持" + (PlayerConfig.isWSP2p ? ("wsp2p") : ("56cdn")) + "模式切换到超清尝试播放");
                        this.changeSuperVideo();
                    }
                }
                else if (PlayerConfig.rfilesType == "super")
                {
                    if (PlayerConfig.definitionArrFor56.indexOf("clear") == -1)
                    {
                        if (PlayerConfig.definitionArrFor56.indexOf("normal") == -1)
                        {
                            LogManager.msg("启动回滚逻辑保持" + (PlayerConfig.isWSP2p ? ("56cdn") : ("wsp2p")) + "模式尝试标清视频播放");
                            if (PlayerConfig.isWSP2p)
                            {
                                this._isRollbackFor56cdn = true;
                            }
                            else
                            {
                                this._isRollbackFor56cdn = false;
                            }
                            this.changeSuperVideo();
                        }
                        else
                        {
                            LogManager.msg("启动回滚逻辑保持" + (PlayerConfig.isWSP2p ? ("wsp2p") : ("56cdn")) + "模式切换到标清尝试播放");
                            this.changeCommonVideo();
                        }
                    }
                    else
                    {
                        LogManager.msg("启动回滚逻辑保持" + (PlayerConfig.isWSP2p ? ("wsp2p") : ("56cdn")) + "模式切换到高清尝试播放");
                        this.changeHdVideo();
                    }
                }
            }
            else if (this._tvSohuMpb.core.PFVNetStreamErrorType == "2" || this._tvSohuMpb.core.PFVNetStreamErrorType == "3")
            {
                LogManager.msg("启动回滚逻辑切换56cdn模式 , " + PlayerConfig.rfilesType + "视频尝试播放");
                this._isRollbackFor56cdn = true;
                if (PlayerConfig.rfilesType == "clear")
                {
                    this.changeHdVideo();
                }
                else if (PlayerConfig.rfilesType == "super")
                {
                    this.changeSuperVideo();
                }
                else if (PlayerConfig.rfilesType == "normal")
                {
                    this.changeCommonVideo();
                }
            }
            return;
        }// end function

        private function startAdLoadFailed(param1 = null) : void
        {
            this.startAdLoaded();
            this.screenAdFinish();
            return;
        }// end function

        private function adPlayIllegal(param1 = null) : void
        {
            if (this._tvSohuMpb != null && this._tvSohuMpb.core != null)
            {
                this._tvSohuMpb.core.pause();
            }
            var _loc_2:* = /CODE""CODE/;
            this._adPlayIllegal = new AdPlayIllegal(stage.stageWidth, stage.stageHeight, PlayerConfig.ADS_PLAY_ILLEGAL.replace(_loc_2, " 500" + PlayerConfig.ILLEGALMSG + " "));
            addChild(this._adPlayIllegal);
            var _loc_3:* = "500" + PlayerConfig.ILLEGALMSG;
            if (Eif.available && ExternalInterface.available)
            {
                ExternalInterface.call("function(){document.cookie=\'pbb1=" + _loc_3 + ";path=/\';}");
            }
            return;
        }// end function

        private function illegalAdsTip() : void
        {
            this.hideTvSohuLoading();
            this.statusError(PlayerConfig.ADS_DATA_ERROR, false);
            return;
        }// end function

        private function showmore(event:Event = null) : void
        {
            if (PlayerConfig.showRecommend)
            {
                this._tvSohuMpb.loadMore();
            }
            else
            {
                this._tvSohuMpb.showCover();
            }
            return;
        }// end function

        private function onMediaConnecting(event:MediaEvent) : void
        {
            this.hideTvSohuLoading();
            return;
        }// end function

        private function onPlayed(event:MediaEvent) : void
        {
            var _loc_3:SharedObject = null;
            var _loc_4:uint = 0;
            var _loc_5:String = null;
            var _loc_6:Object = null;
            var _loc_7:String = null;
            var _loc_2:* = new Date().getTime();
            try
            {
                if (this._tvSohuMpb.core.coreTempTime)
                {
                    PlayerConfig.cdngetSpend = _loc_2 - this._tvSohuMpb.core.coreTempTime - PlayerConfig.allotSpend;
                }
            }
            catch (evt)
            {
            }
            if (Eif.available && this._ads.endAd.state != "playing" && this._ads.startAd.state != "playing")
            {
                if (PlayerConfig.onPlayed != "")
                {
                    _loc_3 = SharedObject.getLocal("ac", "/");
                    _loc_4 = 0;
                    if (_loc_3.data.nov != undefined)
                    {
                        _loc_4 = _loc_3.data.nov;
                    }
                    ExternalInterface.call(PlayerConfig.onPlayed, PlayerConfig.userId, Model.getInstance().videoInfo.vt, PlayerConfig.currentVideoReplayNum, _loc_4);
                    PlayerConfig.onPlayed = "";
                }
                else if (PlayerConfig.isTransition)
                {
                    _loc_5 = this.getParams("clipPlayCallback");
                    if (_loc_5 != "")
                    {
                        ExternalInterface.call(_loc_5);
                    }
                }
            }
            if (PlayerConfig.otherInforSender == "")
            {
                try
                {
                    _loc_6 = {mode:PlayerConfig.availableStvd && PlayerConfig.stvdInUse ? (1) : (0), curColor:this._tvSohuMpb.core.videoArr[this._tvSohuMpb.core.curIndex].video.info.getCurColor(), colorSpace:this._tvSohuMpb.core.videoArr[this._tvSohuMpb.core.curIndex].video.info.getColorSpace(), svdLen:this._tvSohuMpb.core.videoArr[this._tvSohuMpb.core.curIndex].video.info.getSvdLen()};
                }
                catch (err:Error)
                {
                }
                if (this._isSendRVV)
                {
                    this._isSendRVV = false;
                    InforSender.getInstance().sendMesg(InforSender.START2, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, _loc_6);
                }
                else
                {
                    InforSender.getInstance().sendMesg(InforSender.ROLLBACKPLAY, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif");
                }
            }
            else if (PlayerConfig.otherInforSender != "")
            {
                InforSender.getInstance().sendMesg(PlayerConfig.otherInforSender, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif");
                this.vmsPlayerCookie();
            }
            if (this._isFirstSend)
            {
                if (Eif.available)
                {
                    _loc_7 = Utils.getJSVar("__playerTest");
                    if (_loc_7 != null && _loc_7 != "" && _loc_7 != "undefined")
                    {
                        PlayerConfig.jsgetSpend = _loc_7.split(",")[0];
                        PlayerConfig.playerSpend = _loc_7.split(",")[1];
                    }
                }
                SendRef.getInstance().sendPlayerTest("loadtime");
                this._isFirstSend = false;
            }
            if (PlayerConfig.pvpic != null && PlayerConfig.isPreviewPic && this._tvSohuMpb != null && this._isDownPreviewPic)
            {
                this._tvSohuMpb.isTsp = true;
                this._isDownPreviewPic = false;
            }
            return;
        }// end function

        private function startPlayListLoop() : void
        {
            if (!(PlayerConfig.skinNum == "-1" && stage.loaderInfo.parameters["os"] == "android" && stage.loaderInfo.parameters["showMode"] == "radio"))
            {
                if (PlayerConfig.vrsPlayListId)
                {
                    if (PlayerConfig.openListPlay || PlayerConfig.domainProperty == "0" && !PlayerConfig.isMyTvVideo && PlayerConfig.isListPlay)
                    {
                        if (this._tvSohuMpb.panel == null)
                        {
                            setTimeout(function () : void
            {
                _tvSohuMpb.showPlayListPanel();
                _isLoop = true;
                _isNewsLogo = PlayerConfig.isNewsLogo;
                return;
            }// end function
            , 1000);
                        }
                    }
                }
            }
            return;
        }// end function

        private function startAdShown(event:TvSohuAdsEvent) : void
        {
            if (this._tvSohuLoading_c.numChildren >= 0)
            {
                this.hideTvSohuLoading();
            }
            this.resizeHandler();
            if (Eif.available && PlayerConfig.onStartAdShown != "")
            {
                ExternalInterface.call(PlayerConfig.onStartAdShown);
            }
            return;
        }// end function

        private function hideTvSohuLoading() : void
        {
            TweenLite.to(this._tvSohuLoading_c, 0.2, {alpha:0, ease:Quad.easeOut, onComplete:function () : void
            {
                var _loc_1:* = undefined;
                _tvSohuLoading_c.visible = false;
                if (_tvSohuLoading != null)
                {
                    _loc_1 = 0;
                    while (_loc_1 < _tvSohuLoading_c.numChildren)
                    {
                        
                        _tvSohuLoading_c.removeChildAt(_loc_1);
                        _loc_1 = _loc_1 + 1;
                    }
                    _tvSohuLoading = null;
                }
                return;
            }// end function
            });
            dispatchEvent(new Event("hideShellLoading"));
            return;
        }// end function

        private function changeSuperVideo(event:Event = null) : void
        {
            if (this._superVipPanel != null)
            {
                this._superVipPanel.dispatchEvent(new Event("RESUME"));
            }
            this._isPlayStartAd = false;
            this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
            PlayerConfig.otherInforSender = "change";
            if (PlayerConfig.is56)
            {
                PlayerConfig.rfilesType = PlayerConfig.isSohuFor56 ? ("wvga") : ("super");
            }
            if (this._ads.endAd.state != "playing" && this._ads.startAd.state != "playing")
            {
                this._isRollbackWaitAds = false;
                this.loadAndPlay(PlayerConfig.superVid);
            }
            else
            {
                this._isRollbackWaitAds = true;
                this.loadAndPause(PlayerConfig.superVid);
            }
            PlayerConfig.definition = "21";
            return;
        }// end function

        private function changeCommonVideo(event:Event = null) : void
        {
            if (this._superVipPanel != null)
            {
                this._superVipPanel.dispatchEvent(new Event("RESUME"));
            }
            this._isPlayStartAd = false;
            this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
            PlayerConfig.otherInforSender = "change";
            if (PlayerConfig.is56)
            {
                PlayerConfig.rfilesType = PlayerConfig.isSohuFor56 ? ("qvga") : ("normal");
            }
            if (this._ads.endAd.state != "playing" && this._ads.startAd.state != "playing")
            {
                this._isRollbackWaitAds = false;
                this.loadAndPlay(PlayerConfig.norVid);
            }
            else
            {
                this._isRollbackWaitAds = true;
                this.loadAndPause(PlayerConfig.norVid);
            }
            PlayerConfig.definition = "2";
            return;
        }// end function

        private function changeHdVideo(event:Event = null) : void
        {
            if (this._superVipPanel != null)
            {
                this._superVipPanel.dispatchEvent(new Event("RESUME"));
            }
            this._isPlayStartAd = false;
            this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
            PlayerConfig.otherInforSender = "change";
            if (PlayerConfig.is56)
            {
                PlayerConfig.rfilesType = PlayerConfig.isSohuFor56 ? ("vga") : ("clear");
            }
            if (this._ads.endAd.state != "playing" && this._ads.startAd.state != "playing")
            {
                this._isRollbackWaitAds = false;
                this.loadAndPlay(PlayerConfig.hdVid);
            }
            else
            {
                this._isRollbackWaitAds = true;
                this.loadAndPause(PlayerConfig.hdVid);
            }
            PlayerConfig.definition = "1";
            return;
        }// end function

        private function changeYYYVideo(event:Event) : void
        {
            if (this._superVipPanel != null)
            {
                this._superVipPanel.dispatchEvent(new Event("RESUME"));
            }
            if (!PlayerConfig.tvIsFee && PlayerConfig.tvOriFee)
            {
                this.checkOriMkey(true, true, PlayerConfig.oriVid);
                return;
            }
            this.changeOriVideo(true);
            return;
        }// end function

        private function changeExtremeVideo(event:Event) : void
        {
            if (this._superVipPanel != null)
            {
                this._superVipPanel.dispatchEvent(new Event("RESUME"));
            }
            if (!PlayerConfig.tvIsFee && PlayerConfig.tvOriFee)
            {
                this.checkOriMkey(true, false, PlayerConfig.h2644kVid);
                return;
            }
            this.changeOriVideo(false);
            return;
        }// end function

        private function changeOriVideo(param1:Boolean) : void
        {
            this._isPlayStartAd = false;
            this._breakPoint = this._tvSohuMpb.core.filePlayedTime;
            PlayerConfig.otherInforSender = "change";
            if (param1)
            {
                this.loadAndPlay(PlayerConfig.oriVid);
                PlayerConfig.definition = "31";
            }
            else
            {
                this.loadAndPlay(PlayerConfig.h2644kVid);
                PlayerConfig.definition = "51";
            }
            return;
        }// end function

        private function checkOriMkey(param1:Boolean, param2:Boolean, param3:String = "") : void
        {
            var _key:String;
            var boo:* = param1;
            var isOri:* = param2;
            var checkVid:* = param3;
            _key;
            var _url:* = "https://api.store.sohu.com/video/pc/checkpermission?aid=" + (PlayerConfig.vrsPlayListId != "" ? (PlayerConfig.vrsPlayListId) : (PlayerConfig.plid)) + "&vid=" + (checkVid != "" ? (checkVid) : (PlayerConfig.vid)) + "&tvid=" + PlayerConfig.tvid + "&t=" + new Date().getTime();
            LogManager.msg("获取mkey接口地址：" + _url);
            new URLLoaderUtil().load(5, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                if (param1.info == "success")
                {
                    _loc_2 = new JSON().parse(param1.data);
                    LogManager.msg("接口返回状态：" + param1.info + " | 返回数据：" + param1.data);
                    if (_loc_2 != null && _loc_2.data != null && _loc_2.data.mkey != null && _loc_2.data.mkey != "")
                    {
                        _key = _loc_2.data.mkey;
                    }
                    else
                    {
                        _key = "";
                    }
                }
                else
                {
                    _key = "";
                }
                checkOriFinsh(boo, _key, isOri);
                return;
            }// end function
            , _url);
            return;
        }// end function

        private function checkOriFinsh(param1:Boolean, param2:String, param3:Boolean) : void
        {
            this._oriMkey = param2;
            if (!param1)
            {
                if (PlayerConfig.autoPlay)
                {
                    this.loadAndPlay(PlayerConfig.vid);
                }
                else
                {
                    this.loadAndPause(PlayerConfig.vid);
                }
                return;
            }
            if (this._oriMkey != "")
            {
                this.changeOriVideo(param3);
            }
            else
            {
                this._tvSohuMpb.core.pause();
                this.showSuperVipPanel(true);
            }
            return;
        }// end function

        private function showSuperVipPanel(param1:Boolean) : void
        {
            var boo:* = param1;
            if (this._superVipPanel == null)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _superVipPanel = obj.data.content;
                    _superVipPanel.addEventListener("RESUME", function (event:Event) : void
                {
                    closeSuperVipPanel();
                    tvSohuMpb.core.play();
                    return;
                }// end function
                );
                    _superVipPanel.addEventListener("common", function (event:Event) : void
                {
                    closeSuperVipPanel();
                    PlayerConfig.definition = "2";
                    vmsPlayerCookie();
                    loadAndPlay(PlayerConfig.norVid);
                    return;
                }// end function
                );
                    _superVipPanel.addEventListener("hd", function (event:Event) : void
                {
                    closeSuperVipPanel();
                    PlayerConfig.definition = "1";
                    vmsPlayerCookie();
                    loadAndPlay(PlayerConfig.hdVid);
                    return;
                }// end function
                );
                    _superVipPanel.addEventListener("super", function (event:Event) : void
                {
                    closeSuperVipPanel();
                    PlayerConfig.definition = "21";
                    vmsPlayerCookie();
                    loadAndPlay(PlayerConfig.superVid);
                    return;
                }// end function
                );
                    addChild(_superVipPanel);
                    obj = new Object();
                    obj.isSkin = boo;
                    obj.data = {norVid:PlayerConfig.norVid, highVid:PlayerConfig.hdVid, superVid:PlayerConfig.superVid};
                    obj.url = PlayerConfig.coverImg;
                    obj.w = stage.stageWidth;
                    obj.h = stage.stageHeight;
                    _superVipPanel.init(obj);
                    _superVipPanel.resize(stage.stageWidth, stage.stageHeight);
                    Utils.setCenterByNumber(_superVipPanel, stage.stageWidth, boo ? (stage.stageHeight - 32) : (stage.stageHeight));
                    _superVipPanel.open();
                    if (boo)
                    {
                        SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=PL_C_GoldVipShow&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                    }
                    else
                    {
                        SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=PL_C_ChooseClarityShow&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                    }
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/SuperVipPanel.swf");
            }
            return;
        }// end function

        private function vmsPlayerCookie() : void
        {
            var _loc_2:String = null;
            var _loc_1:* = SharedObject.getLocal("vmsPlayer", "/");
            _loc_1.data.ver = PlayerConfig.definition;
            var _loc_3:String = "";
            _loc_1.data.af = "";
            PlayerConfig.autoFix = _loc_3;
            try
            {
                _loc_2 = _loc_1.flush();
                if (_loc_2 == SharedObjectFlushStatus.PENDING)
                {
                    _loc_1.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                }
                else if (_loc_2 == SharedObjectFlushStatus.FLUSHED)
                {
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function closeSuperVipPanel() : void
        {
            if (this._superVipPanel != null)
            {
                this._superVipPanel.removeEventListener("RESUME", function (event:Event) : void
            {
                closeSuperVipPanel();
                tvSohuMpb.core.play();
                return;
            }// end function
            );
                this._superVipPanel.removeEventListener("common", function (event:Event) : void
            {
                closeSuperVipPanel();
                PlayerConfig.definition = "2";
                vmsPlayerCookie();
                loadAndPlay(PlayerConfig.norVid);
                return;
            }// end function
            );
                this._superVipPanel.removeEventListener("hd", function (event:Event) : void
            {
                closeSuperVipPanel();
                PlayerConfig.definition = "1";
                vmsPlayerCookie();
                loadAndPlay(PlayerConfig.hdVid);
                return;
            }// end function
            );
                this._superVipPanel.removeEventListener("super", function (event:Event) : void
            {
                closeSuperVipPanel();
                PlayerConfig.definition = "21";
                vmsPlayerCookie();
                loadAndPlay(PlayerConfig.superVid);
                return;
            }// end function
            );
                removeChild(this._superVipPanel);
                this._superVipPanel = null;
            }
            return;
        }// end function

        public function loadAndPlay(param1:String, param2 = null, param3:String = "") : void
        {
            if (param2 != null)
            {
                PlayerConfig.isMyTvVideo = param2;
                this._isJsCallLoadAndPlay = true;
                this.loopSoft();
            }
            if (param3 != "")
            {
                PlayerConfig.plid = param3;
            }
            this._isJsCallLoadAndPlay = false;
            PlayerConfig.vid = param1;
            this._isAutoPlay = true;
            this.fetchVideoInfo(PlayerConfig.vid);
            return;
        }// end function

        private function loopSoft() : void
        {
            if (this._ads.hasAds)
            {
                this._ads.destroy();
            }
            if (!this._isAutoLoop)
            {
                this._isAutoLoop = true;
                this._tvSohuMpb.core.stop();
            }
            this._isAutoLoop = false;
            try
            {
                this._tvSohuMpb.setFlatWall3D();
                this._tvSohuMpb.loopInitParams();
            }
            catch (evt:SecurityError)
            {
            }
            this.setVideoVer();
            PlayerConfig.uuid = Utils.createUID();
            this._qfStat.isSentDefPause = false;
            var _loc_2:* = this.getParams("ltype");
            this._qfStat.qfltype = this.getParams("ltype");
            InforSender.getInstance().ifltype = _loc_2;
            var _loc_2:Boolean = true;
            this._isSendRVV = true;
            var _loc_2:* = _loc_2;
            this._isFirstSend = _loc_2;
            this._isDownPreviewPic = _loc_2;
            if (!PlayerConfig.autoPlay)
            {
                PlayerConfig.autoPlay = true;
            }
            PlayerConfig.xuid = "";
            PlayerConfig.seekTo = 0;
            this._isSeekToNoTip = false;
            this._breakPoint = 0;
            PlayerConfig.isVipUser = false;
            PlayerConfig.isShowTanmu = false;
            PlayerConfig.isRollback = false;
            PlayerConfig.initP2PFailed = false;
            PlayerConfig.useWebP2p = true;
            this._isDelaySeek = false;
            PlayerConfig.isSogouAd = false;
            return;
        }// end function

        public function loadAndPause(param1:String) : void
        {
            PlayerConfig.vid = param1;
            this._isAutoPlay = false;
            this.fetchVideoInfo(PlayerConfig.vid);
            return;
        }// end function

        private function onPause(event:MediaEvent) : void
        {
            var evt:* = event;
            if (evt.obj.isHard)
            {
                if ((this._tvSohuMpb.preLoadPanel == null || (!this._tvSohuMpb.preLoadPanel.visible || this._tvSohuMpb.preLoadPanel.isBackgroundRun)) && (this._tvSohuMpb.sharePanel2 == null || !this._tvSohuMpb.sharePanel2.isOpen) && this._tvSohuMpb.isShownPauseAd && !PlayerConfig.isSogouAd)
                {
                    this._pauseAd = setTimeout(function () : void
            {
                if (_ads.pauseAd.hasAd && _tvSohuMpb.core.streamState == "pause")
                {
                    AdLog.msg("==========请求暂停广告数据==========");
                    _ads.pauseAd.play();
                }
                else if (!_ads.pauseAd.hasAd)
                {
                    _ads.pauseAd.pingback();
                }
                return;
            }// end function
            , 500);
                }
            }
            if (Eif.available && PlayerConfig.onPause != "")
            {
                ExternalInterface.call(PlayerConfig.onPause);
            }
            return;
        }// end function

        private function onPlay(event:MediaEvent) : void
        {
            var _loc_2:uint = 0;
            if (this._ads.pauseAd.hasAd && (this._ads.pauseAd.state == "playing" || this._ads.pauseAd.state == "loading" || this._ads.pauseAd.state == "end"))
            {
                clearTimeout(this._pauseAd);
                this._ads.pauseAd.close();
            }
            if (this._tvSohuMpb.more != null)
            {
                this._tvSohuMpb.more.visible = false;
            }
            if (this._tvSohuMpb != null && this._tvSohuMpb.likePanel != null)
            {
                this._tvSohuMpb.likePanel.visible = false;
            }
            if (this._tvSohuMpb != null && this._tvSohuMpb.flatWall3D != null && this._tvSohuMpb.flatWall3D.isOpen)
            {
                this._tvSohuMpb.flatWall3D.close();
            }
            if (this._payPanel != null)
            {
                this._payPanel.visible = false;
            }
            if (this._ads.endAd.state != "playing" && this._ads.startAd.state != "playing")
            {
                this.activateRightMenuItem();
            }
            if (!PlayerConfig.sendRealVV && TvSohuAds.getInstance().startAd.state != "playing")
            {
                _loc_2 = 0;
                if (PlayerConfig.startAdTime == 0)
                {
                    _loc_2 = 0;
                }
                else if (PlayerConfig.startAdPlayTime >= PlayerConfig.startAdTime * 1000 - 3000 && PlayerConfig.startAdPlayTime < PlayerConfig.startAdTime * 1000 + 3000)
                {
                    _loc_2 = 1;
                }
                else if (PlayerConfig.startAdPlayTime >= PlayerConfig.startAdTime * 1000 + 3000 && PlayerConfig.startAdPlayTime <= PlayerConfig.startAdTime * 1000 + PlayerConfig.startAdTimeOut * 1000 - 1000)
                {
                    _loc_2 = 2;
                }
                else if (PlayerConfig.startAdPlayTime > PlayerConfig.startAdTime * 1000 + PlayerConfig.startAdTimeOut * 1000 - 1000 && PlayerConfig.startAdPlayTime <= PlayerConfig.startAdTime * 1000 + PlayerConfig.startAdTimeOut * 1000 + 1000)
                {
                    _loc_2 = 3;
                }
                else if (PlayerConfig.startAdPlayTime <= PlayerConfig.startAdTime * 1000 - 3000)
                {
                    _loc_2 = 4;
                }
                this._qfStat.sendPQStat({code:PlayerConfig.REALVV_CODE, adt:PlayerConfig.startAdTime, alt:PlayerConfig.startAdLoadTime, apt:PlayerConfig.startAdPlayTime, slt:PlayerConfig.skinLoadTime > 150000 ? (0) : (PlayerConfig.skinLoadTime), rpt:PlayerConfig.videoDownloadTime > 0 ? (getTimer() - PlayerConfig.videoDownloadTime) : (0), aps:_loc_2});
                PlayerConfig.sendRealVV = true;
            }
            if (Eif.available && PlayerConfig.onPlay != "")
            {
                ExternalInterface.call(PlayerConfig.onPlay);
            }
            return;
        }// end function

        private function onStop(event:MediaEvent = null) : void
        {
            if (event != null)
            {
                if (this._ads.endAd.hasAd && this._ads.endAd.state == "no")
                {
                    this._ads.endAd.play();
                }
                else
                {
                    this.endAdFinish();
                }
                if (this._ads.bottomAd.hasAd)
                {
                    this._ads.bottomAd.close();
                }
                if (this._ads.topAd.hasAd)
                {
                    this._ads.topAd.close();
                }
                if (this._ads.logoAd.hasAd)
                {
                    this._ads.logoAd.close();
                }
                if (this._ads.topLogoAd.hasAd)
                {
                    this._ads.topLogoAd.close();
                }
            }
            if (PlayerConfig.startTime != "" && PlayerConfig.endTime != "")
            {
                this._tvSohuMpb.core.seek(uint(PlayerConfig.startTime));
            }
            if (Eif.available && PlayerConfig.onStop != "" && !this._isJsCallLoadAndPlay)
            {
                ExternalInterface.call(PlayerConfig.onStop);
            }
            return;
        }// end function

        private function videoDestroy(event:Event) : void
        {
            this.loopSoft();
            return;
        }// end function

        private function playListVideo(event:Event) : void
        {
            var _loc_3:Boolean = false;
            this.loopSoft();
            PlayerConfig.lb = "1";
            PlayerConfig.lastReferer = PlayerConfig.filePrimaryReferer;
            var _loc_2:* = this._tvSohuMpb.panel.getVideoInfo();
            if (_loc_2.isMyorVrs)
            {
                PlayerConfig.isMyTvVideo = true;
            }
            else
            {
                PlayerConfig.isMyTvVideo = false;
            }
            if (_loc_2.tvIsEarly != null && _loc_2.tvIsEarly == "1")
            {
                PlayerConfig.tvIsFee = true;
            }
            else
            {
                PlayerConfig.tvIsFee = false;
            }
            if (!PlayerConfig.tvIsFee && (this._version == "31" || this._version == "51"))
            {
                _loc_3 = this._version == "31" ? (true) : (false);
                PlayerConfig.vid = _loc_2.vid;
                this.checkOriMkey(false, _loc_3);
                return;
            }
            this.loadAndPlay(_loc_2.vid);
            this._tvSohuMpb.isSwitchVideos = false;
            return;
        }// end function

        private function setVideoVer() : void
        {
            this._so = SharedObject.getLocal("vmsPlayer", "/");
            if (this._so.data.ver != undefined && this._so.data.ver != "" && String(this._so.data.ver) != "0")
            {
                var _loc_1:* = this._so.data.ver;
                this._version = this._so.data.ver;
                PlayerConfig.definition = _loc_1;
            }
            return;
        }// end function

        private function startAdLoaded(event:TvSohuAdsEvent = null) : void
        {
            this.createMpb();
            if (this._tvSohuMpb != null)
            {
                this._tvSohuMpb.gotoShowTanmu();
            }
            return;
        }// end function

        private function endAdShown(event:TvSohuAdsEvent) : void
        {
            this.shieldRightMenuItem();
            return;
        }// end function

        private function adsVolume(event:Event) : void
        {
            event.target.volume = 0.5;
            return;
        }// end function

        private function adsMute(event:Event) : void
        {
            event.target.volume = 0;
            return;
        }// end function

        private function screenAdFinish(param1 = null) : void
        {
            var item13:ContextMenuItem;
            var evt:* = param1;
            Utils.debug("1111");
            clearInterval(this._tvSohuMpbOk);
            this._tvSohuMpbOk = setInterval(function () : void
            {
                var _loc_1:* = undefined;
                var _loc_2:* = undefined;
                if (_tvSohuMpb != null && _tvSohuMpb.ncConnectError)
                {
                    clearInterval(_tvSohuMpbOk);
                    statusError(PlayerConfig.NC_RETRY_FAILED_TEXT, false);
                    writeErrorMark();
                }
                else if (_tvSohuMpb != null && _mpbSoftInitSuc)
                {
                    clearInterval(_tvSohuMpbOk);
                    if (_isAutoPlay)
                    {
                        if (_isDelaySeek)
                        {
                            _tvSohuMpb.core.seek(_breakPoint);
                        }
                        _tvSohuMpb.core.play();
                        playPlayedAds();
                    }
                    else if (_isRollbackWaitAds && !_isAutoPlay && evt != null)
                    {
                        _tvSohuMpb.core.play();
                        playPlayedAds();
                    }
                    if (PlayerConfig.onPlayed != "")
                    {
                        _loc_1 = SharedObject.getLocal("ac", "/");
                        _loc_2 = 0;
                        if (_loc_1.data.nov != undefined)
                        {
                            _loc_2 = _loc_1.data.nov;
                        }
                        ExternalInterface.call(PlayerConfig.onPlayed, PlayerConfig.userId, Model.getInstance().videoInfo.vt, PlayerConfig.currentVideoReplayNum, _loc_2);
                        PlayerConfig.onPlayed = "";
                    }
                    activateRightMenuItem();
                }
                return;
            }// end function
            , 10);
            if (PlayerConfig.availableStvd && PlayerConfig.stvdInUse)
            {
                item13 = new ContextMenuItem("关闭硬件加速");
                item13.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.closeStageVideo);
                item13.enabled = true;
                item13.separatorBefore = true;
                this._cm.customItems.push(item13);
            }
            if (Eif.available && PlayerConfig.onStartAdFinish != "")
            {
                ExternalInterface.call(PlayerConfig.onStartAdFinish);
            }
            return;
        }// end function

        private function shieldRightMenuItem() : void
        {
            var _loc_1:uint = 0;
            while (_loc_1 < 3)
            {
                
                this._cm.customItems[_loc_1].enabled = false;
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        private function activateRightMenuItem() : void
        {
            var _loc_1:uint = 0;
            while (_loc_1 < 3)
            {
                
                this._cm.customItems[_loc_1].enabled = true;
                _loc_1 = _loc_1 + 1;
            }
            return;
        }// end function

        private function playPlayedAds() : void
        {
            if (!this._isShowPlayedAd)
            {
                this._isShowPlayedAd = true;
                if (this._ads.logoAd.hasAd)
                {
                    this._ads.logoAd.play();
                }
                else
                {
                    this._ads.logoAd.pingback();
                }
                if (this._ads.topLogoAd.hasAd)
                {
                    this._ads.topLogoAd.play();
                }
                else
                {
                    this._ads.topLogoAd.pingback();
                }
                if (this._ads.topAd.hasAd)
                {
                    this._ads.topAd.play();
                }
                else
                {
                    this._ads.topAd.pingback();
                }
                if (this._ads.bottomAd.hasAd)
                {
                    this._ads.bottomAd.play();
                }
                else
                {
                    this._ads.bottomAd.pingback();
                }
            }
            return;
        }// end function

        private function endAdFinish(param1 = null) : void
        {
            var so:SharedObject;
            var item:Object;
            var flushResult:String;
            var evt:* = param1;
            if (stage.loaderInfo.parameters["showMode"] == "pr")
            {
                return;
            }
            PlayerConfig.advolume = null;
            if (this._isAutoLoop)
            {
                return;
            }
            if (PlayerConfig.isUgcPreview)
            {
                if (PlayerConfig.domainProperty == "0" && Eif.available && ExternalInterface.available)
                {
                    this._tvSohuMpb.toCommonMode();
                    ExternalInterface.call("window.tryPlayOver", "1");
                }
                else if (PlayerConfig.showRecommend)
                {
                    this._tvSohuMpb.loadMore();
                }
                else
                {
                    this._tvSohuMpb.showCover();
                }
                return;
            }
            var sgnp:Object;
            if (this._tvSohuMpb.panel != null && this._tvSohuMpb.panel.hasNext() && (!PlayerConfig.isSohuDomain || PlayerConfig.openListPlay))
            {
                this._isAutoLoop = true;
                this._tvSohuMpb.panel.nextPlay();
                SendRef.getInstance().sendPQVPCU("PL_S _LIST");
            }
            else if (this._tvSohuMpb.panel != null && this._tvSohuMpb.panel.hasNext() && PlayerConfig.isSohuDomain && this._tvSohuMpb.stage.displayState == "fullScreen")
            {
                this._isAutoLoop = true;
                this._tvSohuMpb.panel.nextPlay();
                SendRef.getInstance().sendPQVPCU("PL_S _LIST");
            }
            else if (this._tvSohuMpb.hisRecommObj != null && this._tvSohuMpb.hisRecommObj.videoUrl != null && this._tvSohuMpb.hisRecommObj.videoUrl != "")
            {
                so = SharedObject.getLocal("hisRecommMark", "/");
                item;
                so.data.item = item;
                try
                {
                    flushResult = so.flush();
                    if (flushResult == SharedObjectFlushStatus.PENDING)
                    {
                        so.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                    }
                    else if (flushResult == SharedObjectFlushStatus.FLUSHED)
                    {
                    }
                }
                catch (e:Error)
                {
                }
                SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_haoli202921_bfqznlbvv&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                SendRef.getInstance().sendPQDrog("http://ctr.hd.sohu.com/ctr.gif?fuid=" + PlayerConfig.userId + "&yyid=" + PlayerConfig.yyid + "&passport=" + PlayerConfig.passportMail + "&sid=" + PlayerConfig.sid + "&vid=" + this._tvSohuMpb.hisRecommObj.vid + "&pid=" + this._tvSohuMpb.hisRecommObj.pid + "&cid=" + this._tvSohuMpb.hisRecommObj.cid + "&refvid=" + PlayerConfig.vid + "&refpid=" + PlayerConfig.vrsPlayListId + "&refcid=" + PlayerConfig.caid + "&msg=click" + "&alg=" + this._tvSohuMpb.hisRecommObj.r + "&ab=0&formwork=33&type=100" + "&uuid=" + PlayerConfig.uuid + "&url=" + escape(this._tvSohuMpb.hisRecommObj.videoUrl) + "&refer=" + (PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl))));
                this._tvSohuMpb.toCommonMode();
                Utils.openWindow(this._tvSohuMpb.hisRecommObj.videoUrl, "_self");
            }
            else
            {
                PlayerConfig.otherInforSender = "restart";
                this._tvSohuMpb.readyReplay();
                if (Eif.available && PlayerConfig.hasApi && !PlayerConfig.is56)
                {
                    try
                    {
                        if (PlayerConfig.onEndAdStop != "")
                        {
                            ExternalInterface.call(PlayerConfig.onEndAdStop);
                        }
                        else
                        {
                            ExternalInterface.call("vrsPlayerCallEndAd");
                            sgnp = ExternalInterface.call("swfGotoNewPage", "", PlayerConfig.isTransition ? ("vms1") : (!PlayerConfig.isLongVideo ? ("vms2") : (PlayerConfig.isMyTvVideo ? ("my") : ("vrs"))));
                        }
                    }
                    catch (evt:SecurityError)
                    {
                    }
                }
                else if (Eif.available && PlayerConfig.is56)
                {
                    ExternalInterface.call("s2j_onPlayOver", "page");
                    ExternalInterface.call("s2j_playNextStat");
                    if (PlayerConfig.acidFor56 != "" || PlayerConfig.midFor56 != "" || PlayerConfig.SHOW_NEXT_PLAY == "on")
                    {
                        sgnp = ExternalInterface.call("s2j_playNext", "page");
                    }
                    else
                    {
                        sgnp = ExternalInterface.call("s2j_onOverPanelPlayNext", "page");
                    }
                }
                if (sgnp == null)
                {
                    if (PlayerConfig.previewTime > 0 && PlayerConfig.cooperator == "imovie")
                    {
                        this._tvSohuMpb.toCommonMode();
                    }
                    if (PlayerConfig.previewTime > 0)
                    {
                        if (PlayerConfig.isPartner || PlayerConfig.cooperator == "imovie")
                        {
                            if (Eif.available && ExternalInterface.available)
                            {
                                ExternalInterface.call("playerIsBuy");
                            }
                        }
                        else
                        {
                            this.loadPayPanel();
                        }
                    }
                    else if (PlayerConfig.showRecommend)
                    {
                        this._tvSohuMpb.loadMore();
                    }
                    else
                    {
                        this._tvSohuMpb.showCover();
                    }
                }
                else
                {
                    this._tvSohuMpb.toCommonMode();
                }
            }
            return;
        }// end function

        private function adsHandler() : void
        {
            if (this._ads.hasAds)
            {
                this.getErrorMarkCookie();
                if (this._ads.selectorStartAd.hasAd && this._isPlayStartAd && this._isAutoPlay)
                {
                    this._ads.selectorStartAd.play();
                }
                else if (this._ads.startAd.hasAd && this._isPlayStartAd && this._isAutoPlay)
                {
                    this._ads.startAd.play();
                }
                else if (this._ads.startAd.hasAd && this._ads.startAd.isAutoPlayAd && !this._isAutoPlay && this._isPlayStartAd)
                {
                    this._ads.startAd.play();
                }
                else if (this._ads.illegal)
                {
                    this.illegalAdsTip();
                }
                else
                {
                    this.startAdLoadFailed();
                }
            }
            else
            {
                this.startAdLoadFailed();
            }
            return;
        }// end function

        private function retryPanelShown(event:Event) : void
        {
            if (PlayerConfig.isFirst)
            {
                PlayerConfig.isFirst = false;
                this.writeErrorMark();
            }
            return;
        }// end function

        private function fetchVideoInfo(param1:String) : void
        {
            var infoPath:String;
            var id:String;
            var co:String;
            var ver:String;
            var af:String;
            var fkey:String;
            var apikey:String;
            var livetype:String;
            var needP2pLive:String;
            var referer:String;
            var plid:String;
            var bw:String;
            var passwd:String;
            var hasIfox:String;
            var uid:String;
            var cooperator:String;
            var authorId:String;
            var tt:Array;
            var tt1:String;
            var i:uint;
            var t:Array;
            var t2:String;
            var _url:String;
            var vid:* = param1;
            infoPath = PlayerConfig.isPreview ? (PlayerConfig.FETCH_VINFO_PATH_PREVIEW) : (PlayerConfig.isTransition ? (PlayerConfig.FETCH_VINFO_PATH_TRANSITION) : (PlayerConfig.isMyTvVideo ? (PlayerConfig.FETCH_VINFO_PATH_MYTV) : (PlayerConfig.liveType != "" ? (PlayerConfig.FETCH_LIVE_PATH) : (PlayerConfig.FETCH_VINFO_PATH))));
            id = vid;
            if (PlayerConfig.isTransition)
            {
                tt = vid.split("|");
                tt1;
                i;
                while (i < tt.length)
                {
                    
                    t = tt[i].split("/");
                    t2 = t[(t.length - 1)];
                    tt1 = tt1 + (t2 + (i == (tt.length - 1) ? ("") : ("|")));
                    i = (i + 1);
                }
                if (tt1 != "" && tt1 != null)
                {
                    id = tt1;
                }
            }
            if (this._tvSohuMpb != null)
            {
                this._tvSohuMpb.core.stop("noevent");
            }
            if (this._ads != null && this._isPlayStartAd)
            {
                this._ads.destroy();
                this._isShowPlayedAd = false;
            }
            PlayerConfig.vid = vid;
            this._mpbSoftInitSuc = false;
            co;
            if (this._isPlayStartAd)
            {
                co = this.getParams("co") != "" ? ("&co=" + this.getParams("co")) : ("");
            }
            ver = this._version != "" ? ("&ver=" + this._version) : ("");
            af = this._autoFix == "1" ? ("&af=1") : ("");
            var fk:* = this.getParams("fkey");
            fkey = fk != "" ? ("&fkey=" + fk) : ("");
            apikey = PlayerConfig.apiKey != "" ? ("&api_key=" + PlayerConfig.apiKey) : ("");
            livetype = PlayerConfig.liveType != "" ? ("&type=" + PlayerConfig.liveType) : ("");
            needP2pLive = PlayerConfig.needP2PLive ? ("&quick=1") : ("");
            referer = "&referer=" + (PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl)));
            plid = PlayerConfig.plid != "" ? ("&plid=" + PlayerConfig.plid) : ("");
            PlayerConfig.needP2PLive = false;
            bw = this._bandwidth != 0 ? ("&bw=" + this._bandwidth) : ("");
            passwd = this._isPwd ? ("&passwd=" + (this._tvSohuErrorMsg != null ? (this._tvSohuErrorMsg.pwdStr) : (""))) : ("");
            hasIfox = P2PExplorer.getInstance().hasP2P ? ("&hasIfox=1") : ("");
            uid = PlayerConfig.userId != "" ? ("&uid=" + PlayerConfig.userId) : ("");
            cooperator = PlayerConfig.cooperator != "" ? ("&cooperator=" + PlayerConfig.cooperator) : ("");
            authorId = PlayerConfig.authorId != "" && PlayerConfig.authorId != null ? ("&authorId=" + PlayerConfig.authorId) : ("");
            if (PlayerConfig.tvIsFee && !PlayerConfig.is56)
            {
                _url = "https://api.store.sohu.com/film/pc/checkpermission?aid=" + PlayerConfig.plid + "&vid=" + PlayerConfig.vid + "&passport=" + PlayerConfig.passportMail + "&t=" + new Date().getTime();
                LogManager.msg("获取mkey接口地址：" + _url);
                if (PlayerConfig.passportMail != "")
                {
                    new URLLoaderUtil().load(5, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                if (param1.info == "success")
                {
                    _loc_2 = new JSON().parse(param1.data);
                    LogManager.msg("接口返回状态：" + param1.info + " | 返回数据：" + param1.data);
                    if (_loc_2 != null && _loc_2.data != null && _loc_2.data.mkey != null && _loc_2.data.mkey != "")
                    {
                        LogManager.msg("mkey：" + _loc_2.data.mkey + " : state : " + _loc_2.data.state);
                        _model.fetchVideoInfo(infoPath + id + ver + af + bw + co + fkey + apikey + hasIfox + livetype + needP2pLive + plid + uid + authorId + cooperator + "&mkey=" + _loc_2.data.mkey + "&out=" + PlayerConfig.domainProperty + passwd + "&g=" + Math.abs(new Date().getTimezoneOffset() / 60) + referer);
                    }
                    else
                    {
                        LogManager.msg("mkey不存在" + " : state : " + _loc_2.data.state);
                        if (PlayerConfig.isSohuDomain)
                        {
                            if (Eif.available)
                            {
                                if (_tvSohuMpb != null)
                                {
                                    _tvSohuMpb.exitFullScreen();
                                }
                                ExternalInterface.call("openVipWin");
                            }
                            return;
                        }
                        else
                        {
                            _model.fetchVideoInfo(infoPath + id + ver + af + bw + co + fkey + apikey + hasIfox + livetype + needP2pLive + plid + uid + authorId + cooperator + "&out=" + PlayerConfig.domainProperty + passwd + "&g=" + Math.abs(new Date().getTimezoneOffset() / 60) + referer);
                        }
                    }
                }
                else
                {
                    LogManager.msg("接口返回状态：" + param1.info);
                    if (PlayerConfig.isSohuDomain)
                    {
                        if (Eif.available)
                        {
                            if (_tvSohuMpb != null)
                            {
                                _tvSohuMpb.exitFullScreen();
                            }
                            ExternalInterface.call("openVipWin");
                        }
                        return;
                    }
                    else
                    {
                        _model.fetchVideoInfo(infoPath + id + ver + af + bw + co + fkey + apikey + hasIfox + livetype + needP2pLive + plid + uid + authorId + cooperator + "&out=" + PlayerConfig.domainProperty + passwd + "&g=" + Math.abs(new Date().getTimezoneOffset() / 60) + referer);
                    }
                }
                return;
            }// end function
            , _url);
                }
                else
                {
                    LogManager.msg("用户未登陆");
                    if (PlayerConfig.isSohuDomain)
                    {
                        if (Eif.available)
                        {
                            if (this._tvSohuMpb != null)
                            {
                                this._tvSohuMpb.exitFullScreen();
                            }
                            ExternalInterface.call("openVipWin");
                        }
                        return;
                    }
                    else
                    {
                        this._model.fetchVideoInfo(infoPath + id + ver + af + bw + co + fkey + apikey + hasIfox + livetype + needP2pLive + plid + uid + authorId + cooperator + "&out=" + PlayerConfig.domainProperty + passwd + "&g=" + Math.abs(new Date().getTimezoneOffset() / 60) + referer);
                    }
                }
            }
            else if (!PlayerConfig.is56)
            {
                this._model.fetchVideoInfo(infoPath + id + ver + af + bw + co + fkey + apikey + hasIfox + livetype + needP2pLive + plid + uid + authorId + cooperator + (this._oriMkey != "" ? ("&mkey=" + this._oriMkey) : ("")) + "&out=" + PlayerConfig.domainProperty + passwd + "&g=" + Math.abs(new Date().getTimezoneOffset() / 60) + referer);
            }
            else
            {
                this._model.fetchVideoInfo(PlayerConfig.FETCH_VINFO_PATH_56 + this._vidFor56 + "/?src=site&ref=www.56.com" + passwd + apikey);
            }
            var _loc_3:String = "";
            this._oriMkey = "";
            var _loc_3:* = _loc_3;
            this._version = _loc_3;
            this._autoFix = _loc_3;
            return;
        }// end function

        private function vinfoLoadTimeout(event:Event) : void
        {
            var _loc_2:RegExp = null;
            if (stage.stageWidth != 0 && stage.stageHeight != 0)
            {
                _loc_2 = /CODE""CODE/;
                this.statusError(PlayerConfig.VINFO_ERROR_TEXT.replace(_loc_2, PlayerConfig.VINFO_ERROR_TIMEOUT), false);
            }
            this.writeErrorMark();
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            this._qfStat.sendFeedback();
            return;
        }// end function

        private function writeErrorMark() : void
        {
            var _loc_3:String = null;
            var _loc_1:* = SharedObject.getLocal("errorMark", "/");
            var _loc_2:Object = {vid:PlayerConfig.vid, time:new Date().getTime()};
            _loc_1.data.item = _loc_2;
            try
            {
                _loc_3 = _loc_1.flush();
                if (_loc_3 == SharedObjectFlushStatus.PENDING)
                {
                    _loc_1.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                }
                else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                {
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function getErrorMarkCookie() : void
        {
            var _loc_1:* = SharedObject.getLocal("errorMark", "/");
            if (_loc_1.data.item != undefined && _loc_1.data.item.vid != undefined && _loc_1.data.item.vid != "")
            {
                if (_loc_1.data.item.vid == PlayerConfig.vid && new Date().getTime() - _loc_1.data.item.time <= 300000)
                {
                    this._isPlayStartAd = false;
                }
                _loc_1.clear();
            }
            return;
        }// end function

        private function vinfoLoadIoError(event:Event) : void
        {
            var _loc_2:RegExp = null;
            if (stage.stageWidth != 0 && stage.stageHeight != 0)
            {
                _loc_2 = /CODE""CODE/;
                this.statusError(PlayerConfig.VINFO_ERROR_TEXT.replace(_loc_2, PlayerConfig.VINFO_ERROR_OTHER), false);
            }
            this.writeErrorMark();
            return;
        }// end function

        private function vinfoDataEmpty(event:Event) : void
        {
            var _loc_2:RegExp = null;
            if (stage.stageWidth != 0 && stage.stageHeight != 0)
            {
                _loc_2 = /CODE""CODE/;
                this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_2, PlayerConfig.VINFO_ERROR_2), false);
            }
            return;
        }// end function

        private function vinfoVidInvalid(event:Event) : void
        {
            var _loc_2:RegExp = null;
            if (stage.stageWidth != 0 && stage.stageHeight != 0)
            {
                _loc_2 = /CODE""CODE/;
                this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_2, PlayerConfig.VINFO_ERROR_1), false);
            }
            return;
        }// end function

        private function wirteCookie() : void
        {
            var _loc_3:String = null;
            var _loc_1:* = new Date().getTime();
            var _loc_2:* = this.makeRandom(_loc_1);
            this._so = SharedObject.getLocal("vmsuser", "/");
            if (this._so.data.id == undefined || this._so.data.id == "" || this._so.data.id.length != 20)
            {
                _loc_3 = "";
                if (Utils.getBrowserCookie("fuid") != "")
                {
                    this._so.clear();
                    this._so.data.id = Utils.getBrowserCookie("fuid");
                    this._so.data.ts = _loc_1;
                    PlayerConfig.userId = Utils.getBrowserCookie("fuid");
                    try
                    {
                        _loc_3 = this._so.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            this._so.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                }
                else
                {
                    this._so.clear();
                    this._so.data.id = _loc_2;
                    this._so.data.ts = _loc_1;
                    PlayerConfig.userId = _loc_2;
                    if (Eif.available && ExternalInterface.available)
                    {
                        ExternalInterface.call("function(){var d = new Date();d.setTime(d.getTime()+(100*24*60*60*1000));var expires=\'expires=\'+d.toGMTString();document.cookie=\'fuid=" + _loc_2 + ";path=/;domain=tv.sohu.com;\'+expires;}");
                    }
                    try
                    {
                        _loc_3 = this._so.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            this._so.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                }
            }
            else
            {
                PlayerConfig.userId = this._so.data.id;
            }
            return;
        }// end function

        private function get56Cookie() : void
        {
            var _loc_1:* = undefined;
            if (PlayerConfig.domainProperty == "3" && Eif.available)
            {
                _loc_1 = ExternalInterface.call("s2j_getCookie", "fuid");
                LogManager.msg("通过56提供的js方法s2j_getCookie读取fuid=" + _loc_1);
                if (_loc_1 == "" || _loc_1 == null || _loc_1 == "undefined" || _loc_1 == undefined)
                {
                    ExternalInterface.call("s2j_setCookie", "fuid", PlayerConfig.userId, {path:"/", domain:".56.com", expires:100 * 24 * 60 * 60 * 1000});
                    LogManager.msg("s2j_setCookie , fuid = " + ExternalInterface.call("s2j_getCookie", "fuid"));
                }
                else
                {
                    PlayerConfig.userId = _loc_1;
                }
            }
            return;
        }// end function

        private function onStatusShare(event:NetStatusEvent) : void
        {
            if (event.info.code == "SharedObject.Flush.Success")
            {
            }
            else if (event.info.code == "SharedObject.Flush.Failed")
            {
            }
            event.target.removeEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
            return;
        }// end function

        private function makeRandom(param1:Number) : String
        {
            var _loc_2:Number = 1000;
            var _loc_3:* = _loc_2;
            var _loc_4:* = _loc_2 + Math.pow(10, 7);
            var _loc_5:* = Math.random();
            _loc_5 = Math.random() < 0.1 ? (_loc_5 + 0.1) : (_loc_5);
            var _loc_6:* = Math.floor(_loc_3 + _loc_5 * _loc_4);
            var _loc_7:* = String(param1) + "" + String(_loc_6);
            return String(param1) + "" + String(_loc_6);
        }// end function

        private function parseVInfo(param1:Object) : void
        {
            var coverImg:String;
            var uvrObj:Object;
            var arr:Array;
            var pageUrl:String;
            var isSendTa:Boolean;
            var i:uint;
            var re1:RegExp;
            var re2:RegExp;
            var flvPath:String;
            var j:int;
            var et2:uint;
            var st2:Number;
            var k:uint;
            var l:uint;
            var len:Number;
            var minute_str:String;
            var adpoArr:Array;
            var n:uint;
            var p:int;
            var numType:Number;
            var _so56:SharedObject;
            var file:String;
            var arr2:Array;
            var str:String;
            var id:String;
            var vid:String;
            var uid:String;
            var ta:String;
            var tvid:String;
            var oth:String;
            var ch:String;
            var cd:String;
            var sz:String;
            var md:String;
            var prod:String;
            var pt:String;
            var uuid:String;
            var url:String;
            var msg:Function;
            var ugu:String;
            var ugcode:String;
            var cdnparamstr:String;
            var item12:ContextMenuItem;
            var info:* = param1;
            while (this._errStatusSp.numChildren)
            {
                
                this._errStatusSp.removeChildAt(0);
            }
            if (PlayerConfig.coverImg != "")
            {
                arr;
                pageUrl = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
                if (this.specialDomain(pageUrl, arr) && this.specialDomain(PlayerConfig.coverImg, PlayerConfig.SOHU_MATRIX) || !this.specialDomain(pageUrl, arr))
                {
                    coverImg = PlayerConfig.coverImg;
                }
            }
            else
            {
                var _loc_3:* = PlayerConfig.is56 ? (info.info.bimg) : (info.data.coverImg);
                coverImg = PlayerConfig.is56 ? (info.info.bimg) : (info.data.coverImg);
                PlayerConfig.coverImg = _loc_3;
            }
            var filePath:String;
            var fileSize:String;
            var fileTime:String;
            var streamarr:* = new Array();
            var sizearr:* = new Array();
            var timearr:* = new Array();
            var is200:Boolean;
            var st:uint;
            var et:uint;
            var ep:* = new Array();
            var uvr:* = new Array();
            var midAdAdPo:* = new Array();
            var totTime:Number;
            var epInfo:* = new Array();
            var cupTipArr:* = new Array();
            if (!PlayerConfig.is56)
            {
                var _loc_3:* = info.data.clipsURL;
                PlayerConfig.clipsUrl = info.data.clipsURL;
                streamarr = _loc_3;
                sizearr = info.data.clipsBytes;
                timearr = info.data.clipsDuration;
                if (info.prot != null && info.prot == "2")
                {
                    is200;
                }
                var _loc_3:* = info.data.sT != null ? (uint(info.data.sT)) : (0);
                PlayerConfig.stTime = info.data.sT != null ? (uint(info.data.sT)) : (0);
                st = _loc_3;
                var _loc_3:* = info.data.eT != null ? (uint(info.data.eT)) : (0);
                PlayerConfig.etTime = info.data.eT != null ? (uint(info.data.eT)) : (0);
                et = _loc_3;
                ep = info.data.eP != null ? (info.data.eP) : ([]);
                uvr = info.uvr != null ? (info.uvr) : ([]);
                PlayerConfig.fileSize = sizearr;
                if (info.p2pflag != null)
                {
                    PlayerConfig.p2pflag = info.p2pflag;
                }
                if (info.bs != null)
                {
                    PlayerConfig.availableTime = Number(info.bs);
                }
                if (info.ibn != null && info.ibn == 1)
                {
                    PlayerConfig.isPlayDownSameClip = true;
                }
                else
                {
                    PlayerConfig.isPlayDownSameClip = false;
                }
                if (info.data.su != null && info.data.su is Array)
                {
                    PlayerConfig.synUrl = info.data.su;
                }
                if (info.ct != null)
                {
                    PlayerConfig.area = info.ct;
                }
                if (info.nt != null)
                {
                    PlayerConfig.isp = info.nt;
                }
                if (info.hcap != null)
                {
                    PlayerConfig.hcap = String(info.hcap);
                }
                if (info.data.logoUrl != null && info.data.logoUrl != "")
                {
                    PlayerConfig.watermarkPath = info.data.logoUrl;
                }
                if (info.scap != null && PlayerConfig.hcap != "-1")
                {
                    PlayerConfig.cap = info.scap;
                }
                if (info.fee != null)
                {
                    PlayerConfig.isFee = info.fee == 1 ? (true) : (false);
                }
                if (info.cmscat != null && info.cmscat != "")
                {
                    PlayerConfig.cmscat = info.cmscat;
                }
                if (this.getParams("cmscat") != "")
                {
                    PlayerConfig.cmscat = this.getParams("cmscat");
                }
                if (this.getParams("playListId") != "")
                {
                    PlayerConfig.playListId = this.getParams("playListId");
                }
                if (info.data.hc != null && info.data.hc != "")
                {
                    PlayerConfig.hashId = info.data.hc;
                }
                if (info.data.ck != null && info.data.ck != "")
                {
                    PlayerConfig.key = info.data.ck;
                }
                if (info.data.bfd != null && info.data.bfd != "")
                {
                    PlayerConfig.bfd = info.data.bfd;
                }
                if (info.sp != null && info.sp != "")
                {
                    PlayerConfig.p2pSP = info.sp;
                }
                if (info.url != null)
                {
                    PlayerConfig.filePrimaryReferer = info.url;
                }
                if (info.data.version != null)
                {
                    PlayerConfig.isHd = String(info.data.version) == "1" || String(info.data.version) == "21" || String(info.data.version) == "2" || String(info.data.version) == "31" ? (true) : (false);
                }
                if (info.data.photoUrls != null && info.data.photoUrls != "")
                {
                    PlayerConfig.photoUrlsArr = info.data.photoUrls;
                }
                try
                {
                    if (info.data.tvName != null)
                    {
                        PlayerConfig.videoTitle = unescape(info.data.tvName);
                    }
                }
                catch (evt)
                {
                    LogManager.msg("Main::解析tvName:" + evt);
                }
                if (info.isSelf == 1)
                {
                    PlayerConfig.isMyselfUgcVideo = true;
                }
                else
                {
                    PlayerConfig.isMyselfUgcVideo = false;
                }
                if (info.allot != null)
                {
                    PlayerConfig.gslbIp = info.allot;
                }
                if (info.reserveIp != null)
                {
                    PlayerConfig.backupGSLBIP = info.reserveIp.split(";");
                }
                if (info.tn != null && info.data.tn != "")
                {
                    PlayerConfig.p2pTNum = uint(info.tn);
                }
                if (info.id != null && String(info.id) != "0")
                {
                    PlayerConfig.currentVid = String(info.id);
                }
                isSendTa = PlayerConfig.ch_key.split("aureole").length > 1;
                PlayerConfig.ta_jm = PlayerConfig.ch_key != "" && isSendTa ? (this._btnUi.drawBtn(PlayerConfig.ch_key, PlayerConfig.currentVid, PlayerConfig.userId.substr(0, 8))) : ("");
                if (info.data.relativeId != null && String(info.data.relativeId) != "0")
                {
                    PlayerConfig.relativeId = info.data.relativeId;
                }
                if (info.data.superVid != null && String(info.data.superVid) != "0")
                {
                    PlayerConfig.superVid = String(info.data.superVid);
                }
                else
                {
                    PlayerConfig.superVid = "";
                }
                if (info.data.highVid != null && String(info.data.highVid) != "0")
                {
                    PlayerConfig.hdVid = info.data.highVid;
                }
                else
                {
                    PlayerConfig.hdVid = "";
                }
                if (info.data.norVid != null && String(info.data.norVid) != "0")
                {
                    PlayerConfig.norVid = info.data.norVid;
                }
                else
                {
                    PlayerConfig.norVid = "";
                }
                if (info.data.oriVid != null && String(info.data.oriVid) != "0")
                {
                    PlayerConfig.oriVid = info.data.oriVid;
                }
                else
                {
                    PlayerConfig.oriVid = "";
                }
                if (info.data.h2644kVid != null && String(info.data.h2644kVid) != "0")
                {
                    PlayerConfig.h2644kVid = info.data.h2644kVid;
                }
                else
                {
                    PlayerConfig.h2644kVid = "";
                }
                if (info.data.orifee != null && info.data.orifee == 1)
                {
                    PlayerConfig.tvOriFee = true;
                }
                else
                {
                    PlayerConfig.tvOriFee = false;
                }
                if (info.data.logoPos != null && info.data.logoPos != "")
                {
                    PlayerConfig.watermarkPos = info.data.logoPos;
                }
                if (Eif.available && ExternalInterface.available)
                {
                    PlayerConfig.danmuDefaultStatus = Utils.getJSVar("sohuHD.baseInfo.dm");
                    LogManager.msg("从页面获取的参数，参数值是：" + PlayerConfig.danmuDefaultStatus);
                }
                else if (info.dm != null)
                {
                    PlayerConfig.danmuDefaultStatus = String(info.dm);
                    LogManager.msg("从热点获取的参数，参数值是：" + PlayerConfig.danmuDefaultStatus);
                }
                if (PlayerConfig.danmuDefaultStatus == "1" || PlayerConfig.danmuDefaultStatus == "2")
                {
                    PlayerConfig.isShowTanmu = true;
                }
                else
                {
                    PlayerConfig.isShowTanmu = false;
                }
                if (info.isdl != null && info.isdl != "")
                {
                    PlayerConfig.idDownload = info.isdl == 1 ? (true) : (false);
                }
                if (this._isLoop)
                {
                    PlayerConfig.isNewsLogo = this._isNewsLogo;
                }
                i;
                while (i < timearr.length)
                {
                    
                    flvPath = PlayerConfig.isFms && !PlayerConfig.isLive ? (Utils.getType(streamarr[i], ".") + ":" + streamarr[i].substring(streamarr[i].lastIndexOf("stream/") + 7, streamarr[i].length)) : (streamarr[i]);
                    if (i == 0)
                    {
                        fileTime = String(timearr[i]);
                        fileSize = sizearr[i];
                        filePath = flvPath;
                    }
                    else
                    {
                        fileTime = fileTime + ("," + String(timearr[i]));
                        fileSize = fileSize + ("," + sizearr[i]);
                        filePath = filePath + ("," + flvPath);
                    }
                    totTime = totTime + timearr[i];
                    i = (i + 1);
                }
                if (info.ispv != null && info.ispv == 1 && (PlayerConfig.isFee || PlayerConfig.cooperator == "imovie"))
                {
                    j;
                    if (streamarr.length < timearr.length)
                    {
                        if (PlayerConfig.cooperator == "imovie")
                        {
                            j;
                            while (j < 2)
                            {
                                
                                PlayerConfig.previewTime = PlayerConfig.previewTime + timearr[j];
                                j = (j + 1);
                            }
                        }
                        else
                        {
                            j;
                            while (j < streamarr.length)
                            {
                                
                                PlayerConfig.previewTime = PlayerConfig.previewTime + timearr[j];
                                j = (j + 1);
                            }
                        }
                    }
                    else if (totTime > 3600 || PlayerConfig.cooperator == "imovie")
                    {
                        PlayerConfig.previewTime = 600;
                    }
                    else
                    {
                        PlayerConfig.previewTime = 300;
                    }
                }
                re1 = /http:\/\/tv\.sohu\.com""http:\/\/tv\.sohu\.com/;
                re2 = /http:\/\/store\.tv\.sohu\.com""http:\/\/store\.tv\.sohu\.com/;
                PlayerConfig.isTvAndOutSite = !PlayerConfig.isSohuDomain && (re1.test(PlayerConfig.filePrimaryReferer) || re2.test(PlayerConfig.filePrimaryReferer));
                if (PlayerConfig.startTime != "" && PlayerConfig.endTime == "")
                {
                    et2 = uint(PlayerConfig.startTime) + PlayerConfig.SHARE_TIME_LIMIT;
                    if (et2 < totTime)
                    {
                        PlayerConfig.endTime = String(et2);
                    }
                    else
                    {
                        PlayerConfig.endTime = String(totTime);
                    }
                }
                else if (PlayerConfig.startTime == "" && PlayerConfig.endTime != "")
                {
                    st2 = uint(PlayerConfig.endTime) - PlayerConfig.SHARE_TIME_LIMIT;
                    if (st2 < 0)
                    {
                        PlayerConfig.startTime = "0";
                    }
                    else
                    {
                        PlayerConfig.startTime = String(st2);
                    }
                }
                else if (PlayerConfig.startTime != "" && PlayerConfig.endTime != "")
                {
                    if (uint(PlayerConfig.endTime) < uint(PlayerConfig.startTime))
                    {
                        var _loc_3:String = "";
                        PlayerConfig.endTime = "";
                        PlayerConfig.startTime = _loc_3;
                    }
                    else if (uint(PlayerConfig.endTime) - uint(PlayerConfig.startTime) > PlayerConfig.SHARE_TIME_LIMIT)
                    {
                        PlayerConfig.endTime = String(uint(PlayerConfig.startTime) + PlayerConfig.SHARE_TIME_LIMIT);
                    }
                }
                if (PlayerConfig.startTime != "" && PlayerConfig.endTime != "")
                {
                    if (this._breakPoint <= 0)
                    {
                        this._breakPoint = PlayerConfig.startTime == "0" ? (1) : (uint(PlayerConfig.startTime));
                    }
                }
                if (st > 0 && st / totTime >= 0 && st / totTime <= 1)
                {
                    epInfo[0] = {rate:st / totTime, time:st, type:"", title:"正片开始位置", isai:"0"};
                }
                if (ep != null)
                {
                    k;
                    while (k < ep.length)
                    {
                        
                        if (ep[k].pt != null && ep[k].pt == 3)
                        {
                            cupTipArr.push({k:ep[k].k, v:ep[k].v, url:ep[k].url});
                        }
                        else if (ep[k].k / totTime >= 0 && ep[k].k / totTime <= 1)
                        {
                            epInfo.push({rate:ep[k].k / totTime, time:ep[k].k, type:"", title:ep[k].v, isai:"0"});
                        }
                        k = (k + 1);
                    }
                }
                if (et > 0)
                {
                    if (et / totTime >= 0 && et / totTime <= 1)
                    {
                        epInfo.push({rate:et / totTime, time:et, type:"", title:"正片结束位置", isai:"0"});
                    }
                }
                if (uvr != null)
                {
                    l;
                    while (l < uvr.length)
                    {
                        
                        if (uvr[l].t != null && uvr[l].t == 1)
                        {
                            len = PlayerConfig.totalDuration - uvr[l].length;
                            minute_str = String(Math.floor(len / 60));
                            if (minute_str.length == 1)
                            {
                                minute_str = "0" + minute_str;
                            }
                            uvrObj;
                        }
                        l = (l + 1);
                    }
                }
                PlayerConfig.epInfo = PlayerConfig.startTime == "" && PlayerConfig.endTime == "" ? (epInfo) : (null);
                PlayerConfig.cueTipEpInfo = cupTipArr != null ? (cupTipArr) : (null);
                PlayerConfig.uvrInfo = uvrObj != null ? (uvrObj) : (null);
                if (info.data.adpo != null)
                {
                    adpoArr = info.data.adpo;
                    n;
                    while (n < adpoArr.length)
                    {
                        
                        midAdAdPo.push(adpoArr[n].s);
                        n = (n + 1);
                    }
                }
                else
                {
                    midAdAdPo.push(PlayerConfig.MIDDLEAD_SHOWTIME);
                }
                PlayerConfig.midAdTimeArr = midAdAdPo;
                PlayerConfig.stype = PlayerConfig.isMyTvVideo ? (PlayerConfig.wm_user == "20" ? ("211") : ("210")) : (PlayerConfig.catcode);
                this._mpbSoftInitObj = {filePath:filePath, fileTime:fileTime, fileSize:fileSize, isDrag:this._isDrag, cover:coverImg, is200:is200};
            }
            else
            {
                var _loc_3:* = info.info.vid;
                PlayerConfig.hdVid = info.info.vid;
                var _loc_3:* = _loc_3;
                PlayerConfig.norVid = _loc_3;
                var _loc_3:* = _loc_3;
                PlayerConfig.superVid = _loc_3;
                PlayerConfig.vid = _loc_3;
                PlayerConfig.isSohuFor56 = info.info.sohu_cdn == "1" ? (true) : (false);
                PlayerConfig.rfilesArr = info.info.rfiles;
                PlayerConfig.cidFor56 = info.info.cid;
                PlayerConfig.wm_filing = info.info.record != null && info.info.record != "" ? (info.info.record) : ("");
                PlayerConfig.opera_id = info.info.opera_id;
                PlayerConfig.definitionArrFor56 = new Array();
                PlayerConfig.videoTitle = unescape(info.info.Subject);
                midAdAdPo.push(PlayerConfig.MIDDLEAD_SHOWTIME);
                PlayerConfig.midAdTimeArr = midAdAdPo;
                p;
                while (p < PlayerConfig.rfilesArr.length)
                {
                    
                    PlayerConfig.definitionArrFor56.push(PlayerConfig.rfilesArr[p].type);
                    p = (p + 1);
                }
                numType;
                if (PlayerConfig.rfilesType == "")
                {
                    _so56 = SharedObject.getLocal("vmsPlayer56", "/");
                    if (_so56.data.ver != undefined && _so56.data.ver != "")
                    {
                        numType = this.matchFilesType(_so56.data.ver);
                    }
                    else if (PlayerConfig.isSohuFor56)
                    {
                        if (PlayerConfig.definitionArrFor56.length > 1)
                        {
                            numType;
                        }
                        else
                        {
                            numType;
                        }
                    }
                    else
                    {
                        numType;
                    }
                    PlayerConfig.rfilesType = PlayerConfig.rfilesArr[numType].type;
                }
                else if (PlayerConfig.definitionArrFor56.indexOf(PlayerConfig.rfilesType) == -1)
                {
                    if (PlayerConfig.isSohuFor56)
                    {
                        if (PlayerConfig.definitionArrFor56.length > 1)
                        {
                            numType;
                        }
                        else
                        {
                            numType;
                        }
                    }
                    else
                    {
                        numType;
                    }
                }
                else
                {
                    numType = PlayerConfig.definitionArrFor56.indexOf(PlayerConfig.rfilesType);
                }
                PlayerConfig.currentPlayUrl = PlayerConfig.rfilesArr[numType].url + "&prod=56&pt=1&pg=1";
                PlayerConfig.totalDuration = Number(PlayerConfig.rfilesArr[numType].totaltime) / 1000;
                LogManager.msg("播放视频地址:" + PlayerConfig.currentPlayUrl + "| 清晰度是：" + PlayerConfig.rfilesType);
                if (Eif.available && ExternalInterface.available)
                {
                    file = encodeURI(PlayerConfig.currentPlayUrl);
                    this.callJs("s2j_sendData", file);
                }
                this._mpbSoftInitObj = {filePath:PlayerConfig.rfilesArr[numType].url, fileTime:Number(PlayerConfig.rfilesArr[numType].totaltime) / 1000, fileSize:PlayerConfig.rfilesArr[numType].fileSize, isDrag:this._isDrag, cover:coverImg, is200:is200};
            }
            if (PlayerConfig.DEBUG)
            {
                info.holiday = 0;
            }
            if (info.holiday != null && PlayerConfig.autoPlay && stage.loaderInfo.parameters["showMode"] != "360")
            {
                if (info.holiday != 0)
                {
                    this.loadLoading("http://tv.sohu.com/upload/swf/holiday/" + String(info.holiday) + ".swf");
                }
                else
                {
                    this.loadLoading(PlayerConfig.swfHost + "TvSohuLoading.swf");
                }
            }
            if (!PlayerConfig.is56)
            {
                if (!(P2PExplorer.getInstance().hasP2P || PlayerConfig.isLive || PlayerConfig.isFms) && !PlayerConfig.isUgcFeeVideo && !PlayerConfig.isNoP2P)
                {
                    P2pSohuLib.getInstance().cleanMth();
                    arr2 = new Array();
                    arr2.push(PlayerConfig.gslbIp);
                    var _loc_3:int = 0;
                    var _loc_4:* = PlayerConfig.gslbIpList;
                    while (_loc_4 in _loc_3)
                    {
                        
                        str = _loc_4[_loc_3];
                        arr2.push(str);
                    }
                    id = String(info.pid);
                    vid = PlayerConfig.currentVid;
                    uid = PlayerConfig.userId;
                    ta = escape(PlayerConfig.ta_jm);
                    tvid = PlayerConfig.tvid;
                    oth = PlayerConfig.lqd != "" ? (PlayerConfig.lqd) : ("");
                    ch = PlayerConfig.channel != "" ? (PlayerConfig.channel) : ("");
                    cd = PlayerConfig.lcode != "" != "" ? (PlayerConfig.lcode) : ("");
                    sz = PlayerConfig.clientWidth + "_" + PlayerConfig.clientHeight;
                    md = PlayerConfig.cdnMd;
                    prod;
                    pt;
                    uuid = PlayerConfig.uuid;
                    url = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
                    msg = P2pLog.msg;
                    ugu = PlayerConfig.ugu;
                    ugcode = PlayerConfig.ugcode;
                    cdnparamstr = (tvid == "" ? ("") : ("&tvid=" + tvid)) + (ch == "" ? ("") : ("&ch=" + ch)) + (oth == "" ? ("") : ("&oth=" + oth)) + (cd == "" ? ("") : ("&cd=" + cd)) + (sz == "" ? ("") : ("&sz=" + sz)) + (md == "" ? ("") : ("&md=" + md)) + (prod == "" ? ("") : ("&prod=" + prod)) + (pt == "" ? ("") : ("&pt=" + pt)) + (uuid == "" ? ("") : ("&uuid=" + uuid)) + (ugu == "" ? ("") : ("&ugu=" + ugu)) + (ugcode == "" ? ("") : ("&ugcode=" + ugcode));
                    P2pSohuLib.getInstance().init(msg, PlayerConfig.videoVersion, id, arr2, vid, uid, ta, cdnparamstr);
                    PlayerConfig.isWebP2p = true;
                    item12 = new ContextMenuItem("coreversion:" + P2pSohuLib.getInstance().config.version);
                    item12.enabled = false;
                    while (this._cm.customItems.length > 10)
                    {
                        
                        this._cm.customItems.pop();
                    }
                    this._cm.customItems.push(item12);
                    if (PlayerConfig.autoPlay)
                    {
                        Model.getInstance().sendVV();
                    }
                    this.checkLoadAds();
                }
                else
                {
                    if (PlayerConfig.autoPlay)
                    {
                        Model.getInstance().sendVV();
                    }
                    PlayerConfig.isWebP2p = false;
                    PlayerConfig.useWebP2p = false;
                    if (PlayerConfig.autoPlay)
                    {
                        Model.getInstance().sendVV();
                    }
                    this.checkLoadAds();
                }
            }
            else
            {
                totTime = Number(info.info.duration) / 1000;
                if (totTime > 120 && !this._isRollbackFor56cdn && !PlayerConfig.isSohuFor56)
                {
                    if (!PlayerConfig.isWSP2p)
                    {
                        LogManager.msg("wsp2p初始化开始");
                        PFVFSNetStream.initService(function () : void
            {
                if (PFVFSNetStream.available)
                {
                    PlayerConfig.isWSP2p = true;
                }
                else
                {
                    PlayerConfig.isWSP2p = false;
                }
                LogManager.msg("wsp2p初始化完成，结果：" + PFVFSNetStream.available);
                LogManager.msg("PlayerConfig.isWSP2p：" + PlayerConfig.isWSP2p);
                if (PlayerConfig.autoPlay)
                {
                    Model.getInstance().sendVV();
                }
                checkLoadAds();
                return;
            }// end function
            );
                    }
                    else
                    {
                        if (PlayerConfig.autoPlay)
                        {
                            Model.getInstance().sendVV();
                        }
                        this.checkLoadAds();
                    }
                }
                else
                {
                    LogManager.msg("56的cdn , 是否是搜狐的mp4 ： " + PlayerConfig.isSohuFor56);
                    PlayerConfig.isWSP2p = false;
                    this._isRollbackFor56cdn = false;
                    if (PlayerConfig.autoPlay)
                    {
                        Model.getInstance().sendVV();
                    }
                    this.checkLoadAds();
                }
            }
            return;
        }// end function

        private function checkLoadAds() : void
        {
            PlayerConfig.isSogouAd = true;
            LogManager.msg("搜狗浏览器用户去广告");
            startAdLoadFailed();
            _isPlayStartAd = true;
            return;
            var sogouSid:String;
            var url:* = PlayerConfig.currentPageUrl == "" ? (PlayerConfig.outReferer) : (PlayerConfig.currentPageUrl);
            var re1:* = /\?sid=""\?sid=/;
            var re2:* = /\&sid=""\&sid=/;
            if (re1.test(url) || re2.test(url))
            {
                sogouSid = url.split("sid=")[1].split("&")[0];
            }
            if (sogouSid != "")
            {
                LogManager.msg("地址栏里参数sid:" + sogouSid);
                new URLLoaderUtil().load(5, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                if (param1.info == "success")
                {
                    LogManager.msg("obj.data:" + param1.data);
                    _loc_2 = new JSON().parse(param1.data);
                    if (_loc_2.status == 1)
                    {
                        PlayerConfig.isSogouAd = true;
                        LogManager.msg("搜狗浏览器用户去广告");
                        startAdLoadFailed();
                        _isPlayStartAd = true;
                    }
                    else
                    {
                        LogManager.msg("非搜狗浏览器用户不能去广告");
                        loadAdsInfo();
                    }
                }
                else
                {
                    LogManager.msg("obj.info:" + param1.info);
                    loadAdsInfo();
                }
                return;
            }// end function
            , "http://seo.hd.sohu.com/copyright/sogou/validate.do?sid=" + sogouSid);
            }
            else
            {
                LogManager.msg("地址栏里无sid参数");
                this.loadAdsInfo();
            }
            return;
        }// end function

        private function loadAdsInfo() : void
        {
            this.startAdLoadFailed();
            this._isPlayStartAd = true;
            return;
            var _loc_2:Number = NaN;
            var _loc_3:String = null;
            var _loc_1:Boolean = false;
            try
            {
                if (Eif.available && ExternalInterface.available)
                {
                    _loc_2 = PlayerConfig.totalDuration > 180 ? (30) : (10);
                    _loc_3 = InforSender.getInstance().heartBeat(_loc_2, "http://pb.hd.sohu.com.cn/hdpb.gif?msg=realPlayTime") + "&time=" + PlayerConfig.viewTime;
                    ExternalInterface.call("messagebus.publish", "player.update_time", {time:PlayerConfig.viewTime, pingback:_loc_3});
                }
                this._svdUserSo = SharedObject.getLocal("svdUserTip", "/");
                if (this._svdUserSo.data.svdTag != undefined && this._svdUserSo.data.svdTag != "" && (this._svdUserSo.data.svdTag == "0" || this._svdUserSo.data.svdTag == "1"))
                {
                    _loc_1 = true;
                    if (this._svdUserSo.data.svdTag == "0" && this._tvSohuMpb != null)
                    {
                        this._tvSohuMpb.isSvdUserTip = true;
                    }
                    this._svdUserSo.clear();
                }
            }
            catch (e:Error)
            {
            }
            if (PlayerConfig.DEBUG_MAIL.indexOf(PlayerConfig.passportMail) == -1 && this._isPlayStartAd && !_loc_1)
            {
                this._ads.loadAdInfo(this.adsHandler);
            }
            else
            {
                this.startAdLoadFailed();
                this._isPlayStartAd = true;
            }
            return;
        }// end function

        public function vinfoLoadSuccess(param1 = null) : void
        {
            var _loc_4:String = null;
            var _loc_5:RegExp = null;
            var _loc_2:* = param1 == null && PlayerConfig.videoInfo != null ? (PlayerConfig.videoInfo) : (param1.target.videoInfo);
            PlayerConfig.videoInfo = null;
            var _loc_3:* = /CODE""CODE/;
            if (PlayerConfig.is56)
            {
                if (_loc_2.status == 1)
                {
                    this._isDrag = true;
                    this.parseVInfo(_loc_2);
                }
                else if (_loc_2.status == -1)
                {
                    this.statusError(PlayerConfig.VIDEO_DELETED_56_1, true);
                }
                else if (_loc_2.status == -2)
                {
                    this.statusError(PlayerConfig.VIDEO_DELETED_56_2, true);
                }
                else if (_loc_2.status == -3)
                {
                    this.statusError(PlayerConfig.COPYRIGHT_FALLIN.replace(_loc_3, PlayerConfig.VINFO_ERROR_6), true);
                }
                else if (_loc_2.status == -4)
                {
                    this.statusError(PlayerConfig.VIDEO_DELETED_56_2, true);
                }
                else if (_loc_2.status == -5)
                {
                    this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_3, "56_5"), false);
                }
                else if (_loc_2.status == -6)
                {
                    this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_3, "56_6"), false);
                }
                else if (_loc_2.status == -400)
                {
                    this.statusError(PlayerConfig.NC_RETRY_FAILED_TEXT, false);
                }
                else if (_loc_2.status == -401)
                {
                    this._isPwd = true;
                    this.statusError("密码为空或者错误", true);
                }
                else if (_loc_2.status == -403)
                {
                    this._isPwd = true;
                    this.statusError("密码为空或者错误", true);
                }
                else if (_loc_2.status == -404)
                {
                    this.statusError(PlayerConfig.NC_RETRY_FAILED_TEXT, false);
                }
                else if (_loc_2.status == -408)
                {
                    this.statusError(PlayerConfig.NC_RETRY_FAILED_TEXT, false);
                }
                else if (_loc_2.status == -500)
                {
                    this.statusError(PlayerConfig.VINFO_ERROR_TEXT.replace(_loc_3, "56_500"), false);
                }
                else if (_loc_2.status == -501)
                {
                    this.statusError(PlayerConfig.NC_RETRY_FAILED_TEXT, false);
                }
            }
            else if (_loc_2.play == 1)
            {
                if (_loc_2.status == 1)
                {
                    if (PlayerConfig.isTransition || PlayerConfig.isLive)
                    {
                        this._isDrag = false;
                    }
                    else
                    {
                        this._isDrag = true;
                    }
                    this.parseVInfo(_loc_2);
                }
                else if (_loc_2.status == 2)
                {
                    this._isDrag = false;
                    this.parseVInfo(_loc_2);
                }
                else if (_loc_2.status == 3)
                {
                    this.statusError(PlayerConfig.COPYRIGHT_FALLIN.replace(_loc_3, PlayerConfig.VINFO_ERROR_3), true);
                }
                else if (_loc_2.status == 4)
                {
                    this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_3, PlayerConfig.VINFO_ERROR_1), true);
                }
                else if (_loc_2.status == 5)
                {
                    _loc_4 = _loc_2.mytvmsg + "(515)||向我们<u><a href=\"event:\"><font color=\"#ff0000\">留言反馈</font></a></u>";
                    this.statusError(_loc_4, true);
                }
                else if (_loc_2.status == 6)
                {
                    this.statusError(PlayerConfig.COPYRIGHT_FALLIN.replace(_loc_3, PlayerConfig.VINFO_ERROR_6), true);
                }
                else if (_loc_2.status == 7)
                {
                    this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_3, PlayerConfig.VINFO_ERROR_7), true);
                }
                else if (_loc_2.status == 8)
                {
                    this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_3, PlayerConfig.VINFO_ERROR_8), true);
                }
                else if (_loc_2.status == 9)
                {
                    this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_3, PlayerConfig.VINFO_ERROR_9), true);
                }
                else if (_loc_2.status == 10)
                {
                    this.statusError(PlayerConfig.COPYRIGHT_STORE.replace(_loc_3, PlayerConfig.VINFO_ERROR_10), true);
                }
                else if (_loc_2.status == 11)
                {
                    this._isPwd = true;
                    this.statusError(_loc_2.mytvmsg, true);
                }
                else if (_loc_2.status != null && _loc_2.status == 12)
                {
                    this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_3, PlayerConfig.VINFO_ERROR_12), false);
                }
                else if (_loc_2.status != null && _loc_2.status == 13)
                {
                    _loc_5 = /URL""URL/;
                    this.statusError(PlayerConfig.VINFO_FEE_ERROR.replace(_loc_5, _loc_2.url), false);
                }
                else if (_loc_2.status != null && _loc_2.status == 14)
                {
                    PlayerConfig.coverImg = _loc_2.coverImg;
                    if (_loc_2.superVid != null && String(_loc_2.superVid) != "0")
                    {
                        PlayerConfig.superVid = String(_loc_2.superVid);
                    }
                    else
                    {
                        PlayerConfig.superVid = "";
                    }
                    if (_loc_2.highVid != null && String(_loc_2.highVid) != "0")
                    {
                        PlayerConfig.hdVid = _loc_2.highVid;
                    }
                    else
                    {
                        PlayerConfig.hdVid = "";
                    }
                    if (_loc_2.norVid != null && String(_loc_2.norVid) != "0")
                    {
                        PlayerConfig.norVid = _loc_2.norVid;
                    }
                    else
                    {
                        PlayerConfig.norVid = "";
                    }
                    if (this._tvSohuLoading_c.numChildren >= 0)
                    {
                        this.hideTvSohuLoading();
                    }
                    this.showSuperVipPanel(false);
                }
            }
            else if (_loc_2.play == 0)
            {
                this.statusError(PlayerConfig.LIMIT_TEXT, false);
            }
            else
            {
                this.statusError(PlayerConfig.VINFO_DATA_ERROR.replace(_loc_3, PlayerConfig.VINFO_ERROR_14), false);
            }
            return;
        }// end function

        private function statusError(param1:String, param2:Boolean = false) : void
        {
            var _time:Number;
            var strTxt:* = param1;
            var isShowErrRecomm:* = param2;
            this.hideTvSohuLoading();
            if (this._tvSohuMpb != null)
            {
                this.tvSohuMpb.clearTipText();
            }
            var hasSkin:Boolean;
            if (this._tvSohuMpb != null && this._tvSohuMpb.skin != null)
            {
                hasSkin;
            }
            else
            {
                hasSkin;
            }
            if (this._tvSohuErrorMsg == null)
            {
                this._tvSohuErrorMsg = new TvSohuErrorMsg(stage.stageWidth, stage.stageHeight, strTxt, hasSkin, this._isPwd, isShowErrRecomm);
                this._tvSohuErrorMsg.addEventListener("loadAndPlay", function (event:Event) : void
            {
                loadAndPlay(PlayerConfig.vid);
                return;
            }// end function
            );
                this._tvSohuErrorMsg.addEventListener("resizeErrorRecomm", function (event:Event) : void
            {
                resize();
                return;
            }// end function
            );
                this._errStatusSp.addChild(this._tvSohuErrorMsg);
            }
            else
            {
                this._tvSohuErrorMsg.updateInfo(strTxt);
            }
            _time = setInterval(function () : void
            {
                onStop();
                clearInterval(_time);
                return;
            }// end function
            , 5000);
            return;
        }// end function

        private function resize() : void
        {
            if (this._tvSohuLoading != null)
            {
                this._tvSohuLoading.resize(stage.stageWidth, stage.stageHeight);
            }
            if (this._logsPanel != null)
            {
                if (this._tvSohuMpb != null && this._tvSohuMpb.core)
                {
                    this._logsPanel.resize(this._tvSohuMpb.core.width, this._tvSohuMpb.core.height - 5);
                }
                else
                {
                    this._logsPanel.resize(stage.stageWidth, stage.stageHeight - 42);
                }
            }
            if (this._verInfoPanel != null)
            {
                if (this._tvSohuMpb != null && this._tvSohuMpb.core)
                {
                    this._verInfoPanel.resize(this._tvSohuMpb.core.width, this._tvSohuMpb.core.height - 5);
                }
                else
                {
                    this._verInfoPanel.resize(stage.stageWidth, stage.stageHeight - 42);
                }
            }
            if (this._bg != null)
            {
                this._bg.width = stage.stageWidth;
                this._bg.height = stage.stageHeight;
            }
            if (this._tvSohuErrorMsg != null)
            {
                this._tvSohuErrorMsg.resize(stage.stageWidth, stage.stageHeight);
            }
            if (this._adPlayIllegal != null)
            {
                this._adPlayIllegal.resize(stage.stageWidth, stage.stageHeight);
            }
            if (this._payPanel != null)
            {
                this._payPanel.resize(stage.stageWidth, stage.stageHeight);
            }
            if (this._superVipPanel != null)
            {
                this._superVipPanel.resize(stage.stageWidth, stage.stageHeight);
                Utils.setCenterByNumber(this._superVipPanel, stage.stageWidth, stage.stageHeight);
            }
            return;
        }// end function

        private function keyboardUpHandler(event:KeyboardEvent) : void
        {
            switch(event.keyCode)
            {
                case 68:
                {
                    if (event.ctrlKey && (event.shiftKey && !PlayerConfig.isCounterfeitFms || event.altKey))
                    {
                        this.gotoCopyLog();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function stageVideoAvailabilityHandler(event:StageVideoAvailabilityEvent) : void
        {
            if (event.availability == StageVideoAvailability.AVAILABLE && stage.loaderInfo.parameters["stageVideo"] == "1")
            {
                PlayerConfig.availableStvd = true;
                this._bg.visible = false;
                if (PlayerConfig.availableStvd && PlayerConfig.recordSvdMode != 0)
                {
                    PlayerConfig.stvdInUse = true;
                }
                LogManager.msg("已开启硬件加速功能");
            }
            else
            {
                LogManager.msg("未开启硬件加速功能");
                PlayerConfig.availableStvd = false;
                this._bg.visible = true;
                PlayerConfig.stvdInUse = false;
            }
            return;
        }// end function

        public function webUnload() : void
        {
            return;
        }// end function

        public function playVideo() : void
        {
            if (TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing")
            {
                if (!PlayerConfig.is56)
                {
                    TvSohuAds.getInstance().startAd.resume();
                }
                else
                {
                    this._isAutoPlay = true;
                }
            }
            else
            {
                this._tvSohuMpb.core.play();
            }
            return;
        }// end function

        public function pauseVideo() : void
        {
            LogManager.msg("j2s_setVideoPauseAll  : : j2s_setVideoPause");
            if (TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing")
            {
                if (!PlayerConfig.is56)
                {
                    TvSohuAds.getInstance().startAd.pause();
                }
                else
                {
                    this._isAutoPlay = false;
                }
            }
            else
            {
                this._tvSohuMpb.core.pause();
            }
            return;
        }// end function

        public function updateUserLoginInfo(param1:String) : void
        {
            switch(param1)
            {
                case "login":
                {
                    break;
                }
                case "login.userinfo":
                {
                    PlayerConfig.passportMail = this.getPassportMail();
                    if (PlayerConfig.domainProperty == "3")
                    {
                        PlayerConfig.visitorId = PlayerConfig.passportMail.split("@")[0];
                    }
                    else if (Eif.available)
                    {
                        PlayerConfig.visitorId = ExternalInterface.call("sohuHD.user.uid");
                    }
                    if (this._tvSohuMpb != null)
                    {
                        this._tvSohuMpb.updateUserLoginInfo();
                    }
                    break;
                }
                case "logout":
                {
                    if (Eif.available)
                    {
                        PlayerConfig.visitorId = ExternalInterface.call("sohuHD.user.uid");
                    }
                    PlayerConfig.passportMail = this.getPassportMail();
                    if (this._tvSohuMpb != null)
                    {
                        this._tvSohuMpb.updateUserLoginInfo();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function setCtrlBarVisible(param1 = null) : void
        {
            this._tvSohuMpb.ctrlBarVisible(this.getParams("showCtrlBar") == "0" ? (true) : (false), param1);
            return;
        }// end function

        private function loadPayPanel() : void
        {
            if (this._payPanel == null)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _payPanel = obj.data.content;
                    _payPanel.init(PlayerConfig.vrsPlayListId, PlayerConfig.vid);
                    _payPanel.addEventListener("replay_preview_video", function (event:Event) : void
                {
                    _tvSohuMpb.replay();
                    return;
                }// end function
                );
                    addChild(_payPanel);
                    _payPanel.resize(stage.stageWidth, stage.stageHeight);
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/PayPanel.swf");
            }
            else
            {
                this._payPanel.visible = true;
            }
            return;
        }// end function

        private function onThrottle(event:Event) : void
        {
            if (event["state"] == "throttle")
            {
                PlayerConfig.isThrottle = true;
            }
            else if (event["state"] == "resume")
            {
                PlayerConfig.isThrottle = false;
            }
            return;
        }// end function

        private function uncaughtErrorHandler(event:UncaughtErrorEvent) : void
        {
            LogManager.msg("uncaughtErrorHandler : event.error : " + event.error);
            if (this._tvSohuMpb != null)
            {
                this._tvSohuMpb.isUncaught = true;
                this._tvSohuMpb.uncaughtError = event.error;
            }
            event.preventDefault();
            return;
        }// end function

        private function matchFilesType(param1:String) : Number
        {
            var _loc_2:Number = 0;
            var _loc_3:* = new Array();
            var _loc_4:* = new Array();
            var _loc_5:* = new Array();
            var _loc_6:* = new Array();
            var _loc_7:int = 0;
            while (_loc_7 < PlayerConfig.rfilesArr.length)
            {
                
                _loc_3.push(PlayerConfig.rfilesArr[_loc_7].filesize);
                _loc_4.push(PlayerConfig.rfilesArr[_loc_7].totaltime);
                _loc_5.push(PlayerConfig.rfilesArr[_loc_7].url);
                _loc_6.push(PlayerConfig.rfilesArr[_loc_7].type);
                _loc_7++;
            }
            if (_loc_6.indexOf(param1) == -1)
            {
                _loc_2 = 0;
            }
            else
            {
                _loc_2 = _loc_6.indexOf(param1);
            }
            return _loc_2;
        }// end function

        public function get tvSohuMpb()
        {
            return this._tvSohuMpb;
        }// end function

        public static function setYaheiFont() : void
        {
            var _loc_1:* = new TextField();
            _loc_1.defaultTextFormat = new TextFormat("Microsoft YaHei", 12, 16777215);
            _loc_1.text = "雅黑";
            var _loc_2:* = new TextField();
            _loc_2.defaultTextFormat = new TextFormat("宋体", 12, 16777215);
            _loc_2.text = "雅黑";
            if (_loc_1.textHeight == _loc_2.textHeight)
            {
                PlayerConfig.MICROSOFT_YAHEI = "微软雅黑";
            }
            return;
        }// end function

    }
}
