package com.sohu.tv.mediaplayer
{
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.external.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.events.*;
    import flash.external.*;
    import flash.utils.*;

    public class Model extends EventDispatcher
    {
        public var _dispatcher:EventDispatcher;
        private var _videoInfo_obj:Object;
        private var _qfStat:ErrorSenderPQ;
        private var _vInfoUrl:String = "";
        private var _backUrl:String = "";
        private var _tryNum:Number = 4;
        private var _tryCount:Number = 4;
        private var _vvObj:Object;
        private var _callJsTimer:Number;
        private var _videoInfoTimeout:Number = 0;
        public static const VINFO_LOAD_SUCCESS:String = "vinfo_load_success";
        public static const VINFO_LOAD_IOERROR:String = "vinfo_load_ioerror";
        public static const VINFO_LOAD_TIMEOUT:String = "vinfo_load_timeout";
        public static const VINFO_DATA_EMPTY:String = "vinfo_data_empty";
        public static const VINFO_VID_INVALID:String = "vinfo_vid_invalid";
        public static const QUICK_MODE:String = "quick_mode";
        private static var singleton:Model;

        public function Model()
        {
            this.sysInit("start");
            return;
        }// end function

        private function sysInit(param1:String) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
                this.addEvent();
            }
            return;
        }// end function

        private function newFunc() : void
        {
            this._qfStat = ErrorSenderPQ.getInstance();
            return;
        }// end function

        private function addEvent() : void
        {
            return;
        }// end function

        public function fetchVideoInfo(param1:String) : void
        {
            var url:* = param1;
            this._vInfoUrl = url;
            var _loc_3:String = this;
            var _loc_4:* = this._tryNum - 1;
            _loc_3._tryNum = _loc_4;
            var _vid:String;
            var _html:String;
            if (PlayerConfig.vid != "")
            {
                if (this._tryCount - this._tryNum - 1 == 0)
                {
                    new URLLoaderUtil().load(10, this.videoInfoHandler, this._vInfoUrl + "&t=" + Math.random());
                    this._videoInfoTimeout = setTimeout(function () : void
            {
                clearTimeout(_videoInfoTimeout);
                videoInfoHandler({info:"timeout2", target:this});
                return;
            }// end function
            , 1000 * 5);
                }
                else
                {
                    new URLLoaderUtil().load(10, this.videoInfoHandler, this._vInfoUrl + "&r=" + (this._tryCount - this._tryNum - 1) + "&t=" + Math.random());
                }
            }
            else
            {
                try
                {
                    if (ExternalInterface.available)
                    {
                        _vid = "*" + ExternalInterface.call("eval", "vid");
                        _html = ExternalInterface.call("eval", "document.documentElement.innerHTML");
                    }
                }
                catch (evt)
                {
                    _vid;
                    _html;
                }
                if (_html)
                {
                    _html = _html.replace(/\
n""\n/g, "").substr(0, 5000);
                }
                var _loc_3:* = PlayerConfig;
                _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                this._qfStat.sendPQStat({vid:_vid, error:PlayerConfig.VINFO_ERROR_1, code:PlayerConfig.VINFO_CODE, utime:0, allno:++PlayerConfig.allErrNo, dom:this._vInfoUrl, vvmark:0, pagehtml:_html});
                this.dispatch(VINFO_VID_INVALID);
                return;
            }
            return;
        }// end function

        private function videoInfoHandler(param1:Object) : void
        {
            var errInfo:Object;
            var m:Boolean;
            var i:uint;
            var mm:Boolean;
            var j:uint;
            var obj:* = param1;
            PlayerConfig.viewTime = 0;
            PlayerConfig.isHd = false;
            clearTimeout(this._videoInfoTimeout);
            if (obj.info == "timeout2")
            {
                errInfo;
                InforSender.getInstance().sendMesg(InforSender.VINFOTIMEOUT, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, errInfo);
                return;
            }
            if (obj.info == "success")
            {
                PlayerConfig.hotVrsSpend = obj.target.spend;
                LogManager.msg("==========视频信息(json)开始==========");
                LogManager.msg(obj.data);
                LogManager.msg("==========视频信息(json)结束==========");
                try
                {
                    this._videoInfo_obj = new JSON().parse(obj.data);
                }
                catch (evt)
                {
                }
                if (this._videoInfo_obj == null || typeof(this._videoInfo_obj) != "object")
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_1, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0, vrsdata:String(obj.data).replace(/\
n""\n/g, "").substr(0, 5000)});
                    if (this._tryNum > 0)
                    {
                        if (this._tryNum == (this._tryCount - 1))
                        {
                            LogManager.msg("接口返回success，但数据异常，重试请求视频信息地址：" + this._vInfoUrl);
                            this.fetchVideoInfo(this._vInfoUrl);
                        }
                        else if (!PlayerConfig.is56)
                        {
                            if (this._tryNum == this._tryCount - 2)
                            {
                                this._backUrl = this._vInfoUrl;
                                this.fetchVideoInfo(this._vInfoUrl.replace("hot.vrs.sohu.com", PlayerConfig.FETCH_VINFO_SUB_IP[Math.round(Math.random() * 10) % PlayerConfig.FETCH_VINFO_SUB_IP.length]));
                            }
                            else
                            {
                                this.fetchVideoInfo(this._backUrl.replace("hot.vrs.sohu.com", "um.hd.sohu.com"));
                            }
                            LogManager.msg("接口返回success，但数据异常，启用备用地址请求视频信息：" + this._vInfoUrl);
                        }
                    }
                    else
                    {
                        this.dispatch(VINFO_VID_INVALID);
                    }
                    return;
                }
                var _loc_3:int = 4;
                this._tryNum = 4;
                this._tryCount = _loc_3;
                if (!PlayerConfig.is56)
                {
                    if (this._videoInfo_obj.data != null && this._videoInfo_obj.data.totalDuration != null)
                    {
                        try
                        {
                            PlayerConfig.totalDuration = this._videoInfo_obj.data.totalDuration;
                        }
                        catch (evt)
                        {
                        }
                    }
                    if (this._videoInfo_obj.isp2p != null && this._videoInfo_obj.isp2p != "")
                    {
                        PlayerConfig.isForbidP2P = String(this._videoInfo_obj.isp2p);
                    }
                    if (this._videoInfo_obj.isai != null)
                    {
                        PlayerConfig.isai = this._videoInfo_obj.isai;
                    }
                    else
                    {
                        PlayerConfig.isai = "";
                    }
                    if (this._videoInfo_obj.data != null && this._videoInfo_obj.data.tvFileIds != null)
                    {
                        PlayerConfig.tvFileIds = this._videoInfo_obj.data.tvFileIds;
                    }
                    if (this._videoInfo_obj.tvid != null && this._videoInfo_obj.tvid != "")
                    {
                        PlayerConfig.tvid = this._videoInfo_obj.tvid;
                    }
                    if (this._videoInfo_obj.wm_data != null)
                    {
                        PlayerConfig.wmDataInfo = this._videoInfo_obj.wm_data;
                        if (this._videoInfo_obj.wm_data.ugu != null && this._videoInfo_obj.wm_data.ugu != "")
                        {
                            PlayerConfig.ugu = this._videoInfo_obj.wm_data.ugu;
                        }
                        if (this._videoInfo_obj.wm_data.ugcode != null && this._videoInfo_obj.wm_data.ugcode != "")
                        {
                            PlayerConfig.ugcode = this._videoInfo_obj.wm_data.ugcode;
                        }
                        if (this._videoInfo_obj.wm_data.wm_video != null && this._videoInfo_obj.wm_data.wm_video == 1)
                        {
                            PlayerConfig.isWmVideo = true;
                        }
                        else
                        {
                            PlayerConfig.isWmVideo = false;
                        }
                        if (this._videoInfo_obj.wm_data.wm_user != null)
                        {
                            PlayerConfig.wm_user = this._videoInfo_obj.wm_data.wm_user;
                        }
                        if (this._videoInfo_obj.wm_data.fc_user != null)
                        {
                            PlayerConfig.fc_user = this._videoInfo_obj.wm_data.fc_user;
                        }
                        if (this._videoInfo_obj.wm_data.wm_filing != null && this._videoInfo_obj.wm_data.wm_filing != "")
                        {
                            PlayerConfig.wm_filing = this._videoInfo_obj.wm_data.wm_filing;
                        }
                    }
                    else
                    {
                        PlayerConfig.wmDataInfo = null;
                        PlayerConfig.isWmVideo = false;
                        var _loc_3:String = "";
                        PlayerConfig.wm_filing = "";
                        var _loc_3:* = _loc_3;
                        PlayerConfig.fc_user = _loc_3;
                        var _loc_3:* = _loc_3;
                        PlayerConfig.wm_user = _loc_3;
                        var _loc_3:* = _loc_3;
                        PlayerConfig.ugcode = _loc_3;
                        PlayerConfig.ugu = _loc_3;
                    }
                    if (this._videoInfo_obj.ad_data != null && this._videoInfo_obj.ad_data.adPic != null && this._videoInfo_obj.ad_data.adPic != "" && this._videoInfo_obj.ad_data.adTime != null)
                    {
                        PlayerConfig.ugcAdData = this._videoInfo_obj.ad_data;
                    }
                    else
                    {
                        PlayerConfig.ugcAdData = null;
                    }
                    if (this._videoInfo_obj.status == 1)
                    {
                        if (this._videoInfo_obj.fms != null)
                        {
                            PlayerConfig.isFms = false;
                            if (this._videoInfo_obj.fms == 1)
                            {
                                PlayerConfig.isFms = true;
                            }
                            else if (this._videoInfo_obj.fms == 2)
                            {
                                PlayerConfig.isCounterfeitFms = true;
                            }
                        }
                        else
                        {
                            PlayerConfig.isFms = false;
                        }
                        if (this._videoInfo_obj.vt != null && this._videoInfo_obj.vt != 1)
                        {
                            PlayerConfig.isLongVideo = false;
                        }
                        if (this._videoInfo_obj.caid != null && this._videoInfo_obj.caid != "")
                        {
                            PlayerConfig.caid = this._videoInfo_obj.caid;
                        }
                        if (this._videoInfo_obj.plcatid != null && this._videoInfo_obj.plcatid != "")
                        {
                            PlayerConfig.plcatid = this._videoInfo_obj.plcatid;
                        }
                        if (this._videoInfo_obj.isNewsLogo != null && this._videoInfo_obj.isNewsLogo == 1)
                        {
                            PlayerConfig.isNewsLogo = true;
                        }
                        if (this._videoInfo_obj.systype != null && this._videoInfo_obj.systype == 1)
                        {
                            PlayerConfig.isHotOrMy = false;
                        }
                        if (this._videoInfo_obj.catcode != null && this._videoInfo_obj.catcode != "")
                        {
                            PlayerConfig.catcode = this._videoInfo_obj.catcode;
                        }
                        if (this._videoInfo_obj.mainActorId != null && this._videoInfo_obj.mainActorId != "")
                        {
                            PlayerConfig.mainActorId = this._videoInfo_obj.mainActorId;
                        }
                        if (this._videoInfo_obj.act != null && this._videoInfo_obj.act != "")
                        {
                            PlayerConfig.act = this._videoInfo_obj.act;
                        }
                        if (this._videoInfo_obj.age != null && this._videoInfo_obj.age != "")
                        {
                            PlayerConfig.age = this._videoInfo_obj.age;
                        }
                        if (this._videoInfo_obj.areaId != null && this._videoInfo_obj.areaId != "")
                        {
                            PlayerConfig.areaId = this._videoInfo_obj.areaId;
                        }
                        else
                        {
                            PlayerConfig.areaId = 0;
                        }
                        if (this._videoInfo_obj.year != null && this._videoInfo_obj.year != "")
                        {
                            PlayerConfig.year = this._videoInfo_obj.year;
                        }
                        if (this._videoInfo_obj.onlyusep2p != null)
                        {
                            PlayerConfig.onlyusep2p = this._videoInfo_obj.onlyusep2p;
                        }
                        else
                        {
                            PlayerConfig.onlyusep2p = -1;
                        }
                        if (this._videoInfo_obj.pvpic != null && this._videoInfo_obj.pvpic != "")
                        {
                            PlayerConfig.pvpic = this._videoInfo_obj.pvpic;
                            if (PlayerConfig.pvpic.big != null && PlayerConfig.pvpic.big != "" && PlayerConfig.pvpic.small != null && PlayerConfig.pvpic.small != "")
                            {
                                PlayerConfig.isPreviewPic = true;
                            }
                            else
                            {
                                PlayerConfig.isPreviewPic = false;
                            }
                        }
                        else
                        {
                            PlayerConfig.isPreviewPic = false;
                        }
                        if (this._videoInfo_obj.syst != null && this._videoInfo_obj.syst != "")
                        {
                            PlayerConfig.hotVrSyst = this._videoInfo_obj.syst + "&m=" + new Date().getTime();
                        }
                        if (this._videoInfo_obj.islpc != null && this._videoInfo_obj.islpc == 1)
                        {
                            PlayerConfig.isLpc = true;
                        }
                        else
                        {
                            PlayerConfig.isLpc = false;
                        }
                        if (this._videoInfo_obj.islive != null && this._videoInfo_obj.islive == 1)
                        {
                            PlayerConfig.isLive = true;
                        }
                        else
                        {
                            PlayerConfig.isLive = false;
                            PlayerConfig.liveType = "";
                        }
                        if (this._videoInfo_obj.quick != null && this._videoInfo_obj.quick == 1)
                        {
                            PlayerConfig.isP2PLive = true;
                        }
                        else
                        {
                            PlayerConfig.isP2PLive = false;
                        }
                        if (this._videoInfo_obj.hasquick != null && this._videoInfo_obj.hasquick == 1)
                        {
                            PlayerConfig.hasP2PLive = true;
                        }
                        else
                        {
                            PlayerConfig.hasP2PLive = false;
                        }
                        if (PlayerConfig.hasP2PLive && PlayerConfig.isP2PLive)
                        {
                            PlayerConfig.isP2PLive = true;
                        }
                        else
                        {
                            PlayerConfig.isP2PLive = false;
                        }
                        if (this._videoInfo_obj.needIfox != null && this._videoInfo_obj.needIfox == 1)
                        {
                            if (PlayerConfig.isLive && PlayerConfig.isP2PLive && !P2PExplorer.getInstance().hasP2P)
                            {
                                this.dispatch(QUICK_MODE);
                                return;
                            }
                        }
                        if (this._videoInfo_obj.rotate != null && this._videoInfo_obj.rotate != "")
                        {
                            PlayerConfig.myTvRotate = Math.floor(this._videoInfo_obj.rotate / 90) >= 3 ? (3) : (Math.floor(this._videoInfo_obj.rotate / 90));
                        }
                        else
                        {
                            PlayerConfig.myTvRotate = 0;
                        }
                        if (this._videoInfo_obj.definition != null && this._videoInfo_obj.definition != "")
                        {
                            PlayerConfig.myTvDefinition = this._videoInfo_obj.definition;
                        }
                        else
                        {
                            PlayerConfig.myTvDefinition = "";
                        }
                        if (this._videoInfo_obj.voteRegion != null)
                        {
                            PlayerConfig.voteRegion = this._videoInfo_obj.voteRegion;
                        }
                        if (this._videoInfo_obj.voteId != null)
                        {
                            PlayerConfig.voteId = this._videoInfo_obj.voteId;
                        }
                        if (this._videoInfo_obj.crid != null)
                        {
                            PlayerConfig.crid = this._videoInfo_obj.crid;
                        }
                        if (this._videoInfo_obj.ifplu != null && this._videoInfo_obj.ifplu != "")
                        {
                            PlayerConfig.ifplu = this._videoInfo_obj.ifplu;
                        }
                        if (this._videoInfo_obj.early != null && this._videoInfo_obj.early == 1)
                        {
                            PlayerConfig.early = true;
                        }
                        else
                        {
                            PlayerConfig.early = false;
                        }
                        if (this._videoInfo_obj.tvfee != null && this._videoInfo_obj.tvfee == 1)
                        {
                            PlayerConfig.tvfee = true;
                        }
                        else
                        {
                            PlayerConfig.tvfee = false;
                        }
                        if (this._videoInfo_obj.pay_data != null)
                        {
                            if (this._videoInfo_obj.pay_data.isPayVideo == 1)
                            {
                                PlayerConfig.isUgcFeeVideo = true;
                                if (this._videoInfo_obj.pay_data.isPay == 0)
                                {
                                    PlayerConfig.isUgcPreview = true;
                                    if (Number(this._videoInfo_obj.pay_data.trailerTime) > 0)
                                    {
                                        PlayerConfig.previewTime = Number(this._videoInfo_obj.pay_data.trailerTime);
                                    }
                                    else
                                    {
                                        if (Eif.available && ExternalInterface.available)
                                        {
                                            this._callJsTimer = setInterval(function () : void
            {
                var _loc_1:* = ExternalInterface.call("window.tryPlayOver", "2");
                if (Number(_loc_1) == 1)
                {
                    clearInterval(_callJsTimer);
                }
                return;
            }// end function
            , 20);
                                        }
                                        return;
                                    }
                                }
                            }
                            else
                            {
                                PlayerConfig.isUgcFeeVideo = false;
                                PlayerConfig.isUgcPreview = false;
                            }
                        }
                        else
                        {
                            PlayerConfig.isUgcFeeVideo = false;
                            PlayerConfig.isUgcPreview = false;
                        }
                        if (this._videoInfo_obj.data != null)
                        {
                            if (this._videoInfo_obj.data.cid != null && this._videoInfo_obj.data.cid != "")
                            {
                                PlayerConfig.cid = String(this._videoInfo_obj.data.cid);
                            }
                            if (this._videoInfo_obj.data.myTvUid != null && this._videoInfo_obj.data.myTvUid != "")
                            {
                                PlayerConfig.myTvUserId = String(this._videoInfo_obj.data.myTvUid);
                            }
                            if (this._videoInfo_obj.keyword != null && this._videoInfo_obj.keyword != "")
                            {
                                PlayerConfig.keyWord = String(this._videoInfo_obj.keyword);
                            }
                            if (this._videoInfo_obj.data.keyword != null && this._videoInfo_obj.data.keyword != "")
                            {
                                PlayerConfig.keyWord = String(this._videoInfo_obj.data.keyword);
                            }
                            if (this._videoInfo_obj.data.tag != null && this._videoInfo_obj.data.tag != "")
                            {
                                PlayerConfig.tag = String(this._videoInfo_obj.data.tag);
                            }
                            if (this._videoInfo_obj.data.ch != null && this._videoInfo_obj.data.ch != "")
                            {
                                PlayerConfig.channel = this._videoInfo_obj.data.ch;
                            }
                            if (this._videoInfo_obj.data.videoType != null && this._videoInfo_obj.data.videoType == 20)
                            {
                                PlayerConfig.isAlbumVideo = true;
                            }
                            else
                            {
                                PlayerConfig.isAlbumVideo = false;
                            }
                            if (this._videoInfo_obj.pid != null && this._videoInfo_obj.pid != "")
                            {
                                PlayerConfig.vrsPlayListId = this._videoInfo_obj.pid;
                            }
                            if (this._videoInfo_obj.playOrder != null && this._videoInfo_obj.playOrder != "")
                            {
                                PlayerConfig.playOrder = this._videoInfo_obj.playOrder;
                            }
                            if (this._videoInfo_obj.allot != null && this._videoInfo_obj.allot != "")
                            {
                                m;
                                i;
                                while (i < PlayerConfig.gslbIpList.length)
                                {
                                    
                                    if (this._videoInfo_obj.allot == PlayerConfig.gslbIpList[i])
                                    {
                                        m;
                                    }
                                    i = (i + 1);
                                }
                                if (!m)
                                {
                                    PlayerConfig.gslbErrorIp = this._videoInfo_obj.allot;
                                }
                            }
                        }
                        if (PlayerConfig.isTransition)
                        {
                            try
                            {
                                PlayerConfig.vid = String(this._videoInfo_obj.id);
                            }
                            catch (evt:Error)
                            {
                            }
                        }
                        if (this._videoInfo_obj.play == 0)
                        {
                            var _loc_3:* = PlayerConfig;
                            _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                            this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_FORBID, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                        }
                        else
                        {
                            if (this._videoInfo_obj.data == null)
                            {
                                var _loc_3:* = PlayerConfig;
                                _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                                this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_2, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0, vrsdata:obj.data});
                                this.dispatch(VINFO_DATA_EMPTY);
                                return;
                            }
                            if (this._videoInfo_obj.data.clipsURL == null || this._videoInfo_obj.data.clipsURL.length <= 0)
                            {
                                var _loc_3:* = PlayerConfig;
                                _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                                this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_2, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0, vrsdata:obj.data});
                                this.dispatch(VINFO_DATA_EMPTY);
                                return;
                            }
                            if (this._videoInfo_obj.data.version != null)
                            {
                                PlayerConfig.videoVersion = String(this._videoInfo_obj.data.version);
                                PlayerConfig.isHd = String(this._videoInfo_obj.data.version) == "1" || String(this._videoInfo_obj.data.version) == "21" || String(this._videoInfo_obj.data.version) == "31" || String(this._videoInfo_obj.data.version) == "2" ? (true) : (false);
                            }
                            this._vvObj = {error:0, allno:0, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, dom:obj.target.url, vvmark:1};
                        }
                    }
                    else if (this._videoInfo_obj.status == 2)
                    {
                        if (this._videoInfo_obj.allot != null && this._videoInfo_obj.allot != "")
                        {
                            mm;
                            j;
                            while (j < PlayerConfig.gslbIpList.length)
                            {
                                
                                if (this._videoInfo_obj.allot == PlayerConfig.gslbIpList[j])
                                {
                                    mm;
                                }
                                j = (j + 1);
                            }
                            if (!mm)
                            {
                                PlayerConfig.gslbErrorIp = this._videoInfo_obj.allot;
                            }
                        }
                        if (this._videoInfo_obj.play == 0)
                        {
                            var _loc_3:* = PlayerConfig;
                            _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                            this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_FORBID, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                        }
                        else
                        {
                            if (this._videoInfo_obj.data == null)
                            {
                                var _loc_3:* = PlayerConfig;
                                _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                                this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_2, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                                this.dispatch(VINFO_DATA_EMPTY);
                                return;
                            }
                            if (this._videoInfo_obj.data.clipsURL == null || this._videoInfo_obj.data.clipsURL.length <= 0)
                            {
                                var _loc_3:* = PlayerConfig;
                                _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                                this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_2, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                                this.dispatch(VINFO_DATA_EMPTY);
                                return;
                            }
                            if (this._videoInfo_obj.data.version != null)
                            {
                                PlayerConfig.videoVersion = String(this._videoInfo_obj.data.version);
                                PlayerConfig.isHd = String(this._videoInfo_obj.data.version) == "1" || String(this._videoInfo_obj.data.version) == "21" || String(this._videoInfo_obj.data.version) == "31" || String(this._videoInfo_obj.data.version) == "2" ? (true) : (false);
                            }
                            this._vvObj = {error:0, allno:0, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, dom:obj.target.url, vvmark:1};
                        }
                    }
                    else if (this._videoInfo_obj.status == 3)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_3, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                    else if (this._videoInfo_obj.status == 4)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_1, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0, vrsdata:obj.data});
                    }
                    else if (this._videoInfo_obj.status == 5)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_3, code:PlayerConfig.VINFO_CODE, mycode:this._videoInfo_obj.code, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                    else if (this._videoInfo_obj.status == 6)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_6, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                    else if (this._videoInfo_obj.status == 7)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_7, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                    else if (this._videoInfo_obj.status == 8)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_8, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                    else if (this._videoInfo_obj.status == 9)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_9, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                    else if (this._videoInfo_obj.status == 10)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_10, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                    else if (this._videoInfo_obj.status == 12)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_12, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                }
                else if (this._videoInfo_obj.status == 1)
                {
                    if (this._videoInfo_obj.st != null && this._videoInfo_obj.st != "")
                    {
                        PlayerConfig.hotVrSyst = this._videoInfo_obj.st + "&m=" + new Date().getTime();
                    }
                    if (this._videoInfo_obj.info.cid != null && this._videoInfo_obj.info.cid != "")
                    {
                        PlayerConfig.catcode = this._videoInfo_obj.info.cid;
                    }
                    if (this._videoInfo_obj.info.user_id != null && this._videoInfo_obj.info.user_id != "")
                    {
                        PlayerConfig.myTvUid = this._videoInfo_obj.info.user_id;
                    }
                    this._vvObj = {error:0, allno:0, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, dom:obj.target.url, vvmark:1};
                }
                else if (this._videoInfo_obj.status == -1)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -2)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_11, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -3)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -4)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_FORBID, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -5)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -400)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -401)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -403)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -404)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -408)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -500)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                else if (this._videoInfo_obj.status == -501)
                {
                    var _loc_3:* = PlayerConfig;
                    _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                    this._qfStat.sendPQStat({error:this._videoInfo_obj.status, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                }
                this.dispatch(VINFO_LOAD_SUCCESS);
            }
            else if (obj.info == "timeout")
            {
                if (this._tryNum == 3 && PlayerConfig.is56)
                {
                    InforSender.getInstance().sendMesg(InforSender.VVERROR, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {vxmlErr:obj.info});
                }
                if (this._tryNum > 0)
                {
                    if (this._tryNum == (this._tryCount - 1))
                    {
                        LogManager.msg("接口timeout，重试请求视频信息地址：" + this._vInfoUrl);
                        this.fetchVideoInfo(this._vInfoUrl);
                    }
                    else if (!PlayerConfig.is56)
                    {
                        if (this._tryNum == this._tryCount - 2)
                        {
                            this._backUrl = this._vInfoUrl;
                            this.fetchVideoInfo(this._vInfoUrl.replace("hot.vrs.sohu.com", PlayerConfig.FETCH_VINFO_SUB_IP[Math.round(Math.random() * 10) % PlayerConfig.FETCH_VINFO_SUB_IP.length]));
                        }
                        else
                        {
                            this.fetchVideoInfo(this._backUrl.replace("hot.vrs.sohu.com", "um.hd.sohu.com"));
                        }
                        LogManager.msg("接口timeout，启用备用地址请求视频信息：" + this._vInfoUrl);
                    }
                    else
                    {
                        LogManager.msg("接口timeout，重试请求视频信息地址：" + this._vInfoUrl);
                        this.fetchVideoInfo(this._vInfoUrl);
                    }
                }
                else
                {
                    LogManager.msg("备用ip或备用地址接口timeout");
                    if (!PlayerConfig.is56)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_TIMEOUT, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, dom:obj.target.url, allno:++PlayerConfig.allErrNo, vvmark:0});
                    }
                    this.dispatch(VINFO_LOAD_TIMEOUT);
                    this._qfStat.sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"player", code:PlayerConfig.VINFO_CODE, error:PlayerConfig.VINFO_ERROR_TIMEOUT, debuginfo:LogManager.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
                }
            }
            else
            {
                if (this._tryNum == 3 && PlayerConfig.is56)
                {
                    InforSender.getInstance().sendMesg(InforSender.VVERROR, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {vxmlErr:obj.info});
                }
                if (this._tryNum > 0)
                {
                    if (this._tryNum == (this._tryCount - 1))
                    {
                        LogManager.msg("接口" + obj.info + ",重试请求视频信息地址：" + this._vInfoUrl);
                        this.fetchVideoInfo(this._vInfoUrl);
                    }
                    else if (!PlayerConfig.is56)
                    {
                        if (this._tryNum == this._tryCount - 2)
                        {
                            this._backUrl = this._vInfoUrl;
                            this.fetchVideoInfo(this._vInfoUrl.replace("hot.vrs.sohu.com", PlayerConfig.FETCH_VINFO_SUB_IP[Math.round(Math.random() * 10) % PlayerConfig.FETCH_VINFO_SUB_IP.length]));
                        }
                        else
                        {
                            this.fetchVideoInfo(this._backUrl.replace("hot.vrs.sohu.com", "um.hd.sohu.com"));
                        }
                        LogManager.msg("接口" + obj.info + "，启用备用地址请求视频信息：" + this._vInfoUrl);
                    }
                    else
                    {
                        LogManager.msg("接口" + obj.info + ",重试请求视频信息地址：" + this._vInfoUrl);
                        this.fetchVideoInfo(this._vInfoUrl);
                    }
                }
                else
                {
                    LogManager.msg("备用ip或备用地址接口" + obj.info);
                    if (!PlayerConfig.is56)
                    {
                        var _loc_3:* = PlayerConfig;
                        _loc_3.allErrNo = PlayerConfig.allErrNo + 1;
                        this._qfStat.sendPQStat({error:PlayerConfig.VINFO_ERROR_OTHER, code:PlayerConfig.VINFO_CODE, utime:obj.target.spend, allno:++PlayerConfig.allErrNo, dom:obj.target.url, vvmark:0});
                    }
                    this.dispatch(VINFO_LOAD_IOERROR);
                    this._qfStat.sendDebugInfo({url:"http://um.hd.sohu.com/u.gif", type:"player", code:PlayerConfig.VINFO_CODE, error:PlayerConfig.VINFO_ERROR_OTHER, debuginfo:LogManager.getMsg(), sid:PlayerConfig.sid, uid:PlayerConfig.userId, time:new Date().getTime()});
                }
            }
            return;
        }// end function

        public function get videoInfo() : Object
        {
            return this._videoInfo_obj;
        }// end function

        public function sendVV() : void
        {
            if (this._vvObj != null)
            {
                this._qfStat.sendPQStat(this._vvObj);
                this._vvObj = null;
            }
            return;
        }// end function

        private function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new Event(param1);
            dispatchEvent(_loc_3);
            return;
        }// end function

        private function doDecrypt(param1:String, param2:int) : String
        {
            var _loc_3:String = "";
            var _loc_4:* = new XXTEA();
            _loc_3 = new XXTEA().NetDecrypt(param1, param2);
            return _loc_3;
        }// end function

        public static function getInstance() : Model
        {
            if (singleton == null)
            {
                singleton = new Model;
            }
            return singleton;
        }// end function

    }
}
