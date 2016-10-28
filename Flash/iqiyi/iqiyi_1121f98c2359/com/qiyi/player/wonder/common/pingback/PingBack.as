package com.qiyi.player.wonder.common.pingback
{
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import org.puremvc.as3.patterns.facade.*;

    public class PingBack extends Object
    {
        private var _facade:Facade;
        private var _visits:String = "";
        private var _send140707ADInitFlag:Boolean = false;
        private var _send140708FStartFlag:Boolean = false;
        private var _sendFirstVideoFlag:Boolean = false;
        private static const PING_BACK_URL:String = "http://msg.71.am/vpb.gif";
        private static const PING_BACK_TMPSTATS:String = "http://msg.71.am/tmpstats.gif";
        private static const PING_BACK_BARRAGE:String = "http://msg.71.am/b";
        private static const PING_BACK_MIRROR:String = "http://msg.71.am/v5/";
        private static const PlATFORM_TYPE:String = "11";
        private static var _instance:PingBack;

        public function PingBack(param1:SingletonClass)
        {
            return;
        }// end function

        public function set visits(param1:String) : void
        {
            this._visits = param1;
            return;
        }// end function

        public function init(param1:Facade) : void
        {
            this._facade = param1;
            return;
        }// end function

        private function pingRequestServer(param1:String, param2:Boolean = true) : void
        {
            var _loc_3:* = new URLRequest();
            if (param2)
            {
                _loc_3.url = param1 + "&tn=" + Math.random();
            }
            else
            {
                _loc_3.url = param1;
            }
            sendToURL(_loc_3);
            return;
        }// end function

        private function publicURL() : String
        {
            var _loc_1:* = UUIDManager.instance.isNewUser ? ("1") : ("0");
            var _loc_2:String = "";
            var _loc_3:String = "";
            var _loc_4:String = "";
            var _loc_5:String = "";
            var _loc_6:String = "";
            var _loc_7:String = "";
            var _loc_8:String = "";
            var _loc_9:String = "";
            var _loc_10:String = "";
            var _loc_11:* = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_12:* = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_13:* = _loc_11.curActor.movieModel;
            var _loc_14:* = _loc_11.curActor.movieInfo;
            if (_loc_13 && _loc_14)
            {
                _loc_2 = _loc_13.vid;
                _loc_3 = _loc_13.tvid;
                _loc_4 = _loc_13.albumId;
                _loc_5 = _loc_13.channelID.toString();
                _loc_6 = _loc_14.pageUrl;
                _loc_7 = _loc_13.curDefinitionInfo.type.id.toString();
                _loc_8 = _loc_13.ctgId.toString();
                _loc_10 = _loc_11.curActor.movieModel.uploaderID;
            }
            else
            {
                _loc_2 = "";
            }
            if (_loc_2 != "")
            {
                _loc_9 = _loc_11.curActor.videoEventID;
            }
            var _loc_15:* = UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("");
            var _loc_16:* = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
            var _loc_17:* = _loc_11.curActor.uuid;
            var _loc_18:* = UUIDManager.instance.getWebEventID();
            var _loc_19:String = "";
            _loc_19 = "&newusr=" + _loc_1 + "&vid=" + _loc_2 + "&aid=" + _loc_4 + "&tvid=" + _loc_3 + "&cid=" + _loc_5 + "&purl=" + encodeURIComponent(_loc_6) + "&lev=" + _loc_7 + "&puid=" + _loc_15 + "&pru=" + _loc_16 + "&suid=" + _loc_17 + "&visits=" + this._visits + "&pla=" + PlATFORM_TYPE + "&weid=" + _loc_18 + "&veid=" + _loc_9 + "&coop=" + FlashVarConfig.coop + "&ctgid=" + _loc_8 + "&plid=" + FlashVarConfig.playListID + "&vvfrom=" + FlashVarConfig.videoFrom + "&mod=" + FlashVarConfig.localize + "&tn=" + String(Math.random());
            _loc_19 = _loc_19 + (_loc_10 && _loc_10 != "0" ? ("&upderid=" + _loc_10) : (""));
            return _loc_19;
        }// end function

        public function playStartPing() : void
        {
            this.environmentInfoPing();
            return;
        }// end function

        public function recommendationPanelPing() : void
        {
            var _loc_1:String = "";
            _loc_1 = PING_BACK_URL + "?flag=" + PingBackDef.PLAYER_ACTION + "&plyract=" + PingBackDef.SHOW_RECOMMEND + this.publicURL();
            this.pingRequestServer(_loc_1, false);
            return;
        }// end function

        public function continuityPlayPing() : void
        {
            var _loc_1:String = "";
            _loc_1 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&plyract=" + PingBackDef.CONTINUITY_PLAY + this.publicURL();
            this.pingRequestServer(_loc_1, false);
            return;
        }// end function

        public function cyclePlayPing(param1:String, param2:String) : void
        {
            var _loc_3:String = "";
            _loc_3 = PING_BACK_URL + "?flag=" + param1 + "&" + param2 + "=" + PingBackDef.CYCLE_PLAY + this.publicURL();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function userActionPing(param1:String, param2:int = -1) : void
        {
            var _loc_3:String = "";
            if (param2 >= 0)
            {
                _loc_3 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + "&prgr=" + int(param2 / 1000).toString() + this.publicURL();
            }
            else
            {
                _loc_3 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + this.publicURL();
            }
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function playerActionPing(param1:String, param2:String = "") : void
        {
            var _loc_3:String = "";
            _loc_3 = PING_BACK_URL + "?flag=" + PingBackDef.PLAYER_ACTION + "&plyract=" + param1 + this.publicURL();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function switchDefinition(param1:int, param2:int) : void
        {
            var _loc_3:* = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.SWITCH_DEFINATION + "&from=" + param1 + "&to=" + param2 + this.publicURL();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function previewActionPing(param1:int) : void
        {
            var _loc_2:* = param1 / 1000;
            var _loc_3:String = "";
            _loc_3 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.PREVIEW_VIDEO + "&prvwt=" + _loc_2 + this.publicURL();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function dragActionPing(param1:int, param2:int, param3:uint) : void
        {
            var _loc_4:* = param1 / 1000;
            var _loc_5:* = param2 / 1000;
            var _loc_6:String = "";
            _loc_6 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.DRAG + "&from=" + _loc_4 + "&isgrn=" + param3 + "&to=" + _loc_5 + this.publicURL();
            this.pingRequestServer(_loc_6, false);
            return;
        }// end function

        public function scaleActionPing(param1:int) : void
        {
            var _loc_2:String = "";
            _loc_2 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.SCALE + "&scale=" + (param1 == 0 ? ("coverd") : (param1)) + this.publicURL();
            this.pingRequestServer(_loc_2, false);
            return;
        }// end function

        public function recommendSelectionPing(param1:String, param2:String) : void
        {
            var _loc_3:String = "";
            _loc_3 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.RECOMMENDATION_SELECTED + "&recselurl=" + param1 + "&recslctpos=" + param2 + this.publicURL();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function recommendClick4QiyuPing(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String) : void
        {
            var _loc_8:* = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_9:* = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_10:* = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_11:String = "";
            if (_loc_9.taid != "")
            {
                _loc_11 = _loc_9.taid;
            }
            else
            {
                _loc_11 = _loc_8.curActor.movieModel != null ? (_loc_8.curActor.movieModel.albumId) : ("");
            }
            var _loc_12:String = "";
            if (_loc_9.taid != "")
            {
                _loc_12 = _loc_9.tcid;
            }
            else
            {
                _loc_12 = _loc_8.curActor.movieModel != null ? (_loc_8.curActor.movieModel.channelID.toString()) : ("");
            }
            var _loc_13:* = UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("");
            var _loc_14:* = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
            var _loc_15:String = "";
            _loc_15 = PING_BACK_TMPSTATS + "?type=recctplay20121226" + "&usract=userclick" + "&ppuid=" + _loc_13 + "&pru=" + _loc_14 + "&uid=" + _loc_8.curActor.uuid + "&aid=" + _loc_11 + "&event_id=" + param2 + "&cid=" + _loc_12 + "&bkt=" + param3 + "&area=" + param4 + "&rank=" + param5 + "&url=" + param6 + "&taid=" + param1 + "&tcid=" + param7 + "&platform=" + PlATFORM_TYPE + "&plid=" + FlashVarConfig.playListID + "&vvfrom=" + FlashVarConfig.videoFrom + "&mod=" + FlashVarConfig.localize + "&t=" + String(Math.random());
            var _loc_16:* = _loc_8.curActor.movieModel != null ? (_loc_8.curActor.movieModel.uploaderID) : ("");
            _loc_15 = _loc_15 + (_loc_16 && _loc_16 != "0" ? ("&upderid=" + _loc_16) : (""));
            this.pingRequestServer(_loc_15, false);
            return;
        }// end function

        public function recommendLoadDoneSend(param1:String, param2:String, param3:String, param4:String) : void
        {
            var _loc_5:* = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_6:* = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_7:* = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_8:String = "";
            if (_loc_6.taid != "")
            {
                _loc_8 = _loc_6.taid;
            }
            else
            {
                _loc_8 = _loc_5.curActor.movieModel != null ? (_loc_5.curActor.movieModel.albumId) : ("");
            }
            var _loc_9:String = "";
            if (_loc_6.taid != "")
            {
                _loc_9 = _loc_6.tcid;
            }
            else
            {
                _loc_9 = _loc_5.curActor.movieModel != null ? (_loc_5.curActor.movieModel.channelID.toString()) : ("");
            }
            var _loc_10:* = UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("");
            var _loc_11:* = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
            var _loc_12:String = "";
            _loc_12 = PING_BACK_TMPSTATS + "?type=recctplay20121226" + "&usract=show&ppuid=" + _loc_10 + "&uid=" + _loc_5.curActor.uuid + "&pru=" + _loc_11 + "&aid=" + _loc_8 + "&event_id=" + param2 + "&cid=" + _loc_9 + "&bkt=" + param3 + "&area=" + param4 + "&platform=" + PlATFORM_TYPE + "&albumlist=" + param1 + "&mod=" + FlashVarConfig.localize + "&t=" + String(Math.random());
            this.pingRequestServer(_loc_12, false);
            return;
        }// end function

        public function skipAD(param1:String, param2:String, param3:String, param4:String) : void
        {
            var _loc_5:* = PING_BACK_TMPSTATS + "?type=skipad131210&pf=1&p=10&ppuid=" + param1 + "&flshuid=" + param2 + "&tvid=" + param3 + "&aid=" + param4 + "&mod=" + FlashVarConfig.localize + "&tn=" + Math.random();
            this.pingRequestServer(_loc_5, false);
            return;
        }// end function

        public function floatPlayerPing() : void
        {
            var _loc_1:String = "";
            _loc_1 = PING_BACK_TMPSTATS + "?type=bodanvvtest" + "&isfloatplayer=" + FlashVarConfig.isFloatPlayer + this.publicURL();
            this.pingRequestServer(_loc_1, false);
            return;
        }// end function

        public function headmapPing() : void
        {
            var _loc_1:String = "";
            _loc_1 = PING_BACK_TMPSTATS + "?type=bodanvvtest" + "&isheadmap=" + FlashVarConfig.isheadmap + this.publicURL();
            this.pingRequestServer(_loc_1, false);
            return;
        }// end function

        public function videoSharePing(param1:String, param2:Number, param3:Number) : void
        {
            var _loc_4:String = "";
            _loc_4 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_SHARE + "&shrtg=" + param1 + "&shrst=" + param2 + "&shret=" + param3 + this.publicURL();
            this.pingRequestServer(_loc_4, false);
            return;
        }// end function

        public function filterPing(param1:String) : void
        {
            var _loc_2:String = "";
            _loc_2 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + param1 + this.publicURL();
            this.pingRequestServer(_loc_2, false);
            return;
        }// end function

        public function nextPing() : void
        {
            var _loc_1:String = "";
            _loc_1 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.NEXT + this.publicURL();
            this.pingRequestServer(_loc_1, false);
            return;
        }// end function

        public function videoLinkShowPing() : void
        {
            var _loc_1:String = "";
            _loc_1 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_LINK_SHOW + this.publicURL();
            this.pingRequestServer(_loc_1, false);
            return;
        }// end function

        public function videoLinkUserClickPing() : void
        {
            var _loc_1:String = "";
            _loc_1 = PING_BACK_URL + "?flag=" + PingBackDef.USER_ACTION + "&usract=" + PingBackDef.VIDEO_LINK_CLICK + this.publicURL();
            this.pingRequestServer(_loc_1, false);
            return;
        }// end function

        public function environmentInfoPing() : void
        {
            var _loc_1:String = "";
            var _loc_2:* = this.getBrowserMatch();
            if (_loc_2)
            {
                _loc_1 = _loc_2.browser;
            }
            var _loc_3:String = "";
            _loc_3 = PING_BACK_URL + "?flag=" + PingBackDef.STU_ENV + "&plyrver=" + Version.VERSION + "&pla=" + PlATFORM_TYPE + "&os=" + Capabilities.os + "&browser=" + _loc_1 + "&dpi=" + Capabilities.screenResolutionX + "X" + Capabilities.screenResolutionY + "&flashver=" + Capabilities.version + this.publicURL();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function startVisitsPing() : void
        {
            var _loc_1:String = "";
            _loc_1 = PING_BACK_URL + "?flag=" + PingBackDef.START_VISITS + this.publicURL();
            this.pingRequestServer(_loc_1, false);
            return;
        }// end function

        public function sendPlayerLoadSuccess(param1:String) : void
        {
            var _loc_2:* = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=jingyitest1" + "&url=" + this.getPageLocationHref() + "&ver=" + encodeURIComponent(Capabilities.version) + "&yhls=" + param1 + "&pla=" + PlATFORM_TYPE + "&mod=" + FlashVarConfig.localize + "&tn=" + Math.random();
            this.pingRequestServer(_loc_2, false);
            return;
        }// end function

        public function sendBeforeADInit() : void
        {
            var _loc_1:String = null;
            if (!this._send140707ADInitFlag)
            {
                this._send140707ADInitFlag = true;
                _loc_1 = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=140707adinit" + "&pla=" + PlATFORM_TYPE + "&mod=" + FlashVarConfig.localize + "&tn=" + Math.random();
                this.pingRequestServer(_loc_1, false);
            }
            return;
        }// end function

        public function sendVideoStart() : void
        {
            var _loc_1:String = null;
            if (!this._send140708FStartFlag)
            {
                this._send140708FStartFlag = true;
                _loc_1 = PING_BACK_TMPSTATS + "?type=yhls20130924&usract=140708fstart" + "&pla=" + PlATFORM_TYPE + "&mod=" + FlashVarConfig.localize + "&tn=" + Math.random();
                this.pingRequestServer(_loc_1, false);
            }
            return;
        }// end function

        public function sendFirstVideo() : void
        {
            var _loc_1:String = null;
            if (!this._sendFirstVideoFlag)
            {
                this._sendFirstVideoFlag = true;
                _loc_1 = PING_BACK_URL + "?flag=plyract&plyract=508101_tst&tn=" + "&mod=" + FlashVarConfig.localize + Math.random();
                this.pingRequestServer(_loc_1, false);
            }
            return;
        }// end function

        public function sendFilmScore(param1:uint) : void
        {
            var _loc_2:* = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = this._facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_4:* = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_5:String = "";
            if (_loc_3.taid != "")
            {
                _loc_5 = _loc_3.tcid;
            }
            else
            {
                _loc_5 = _loc_2.curActor.movieModel != null ? (_loc_2.curActor.movieModel.channelID.toString()) : ("");
            }
            var _loc_6:String = "";
            if (_loc_2.curActor.movieModel.channelID == ChannelEnum.FILM.id)
            {
                _loc_6 = _loc_2.curActor.movieModel.tvid;
            }
            else
            {
                _loc_6 = _loc_2.curActor.movieModel.albumId;
            }
            var _loc_7:* = UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("");
            var _loc_8:* = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
            var _loc_9:* = PING_BACK_TMPSTATS + "?usract=3" + "&type=user_rating_20141014" + "&ppuid=" + _loc_7 + "&pru=" + _loc_8 + "&uid=" + _loc_2.curActor.uuid + "&platform=11" + "&taid=" + _loc_6 + "&rate=" + param1 + "&src_code=1" + "&channel_id=" + _loc_5 + "&mod=" + FlashVarConfig.localize + "&rn=" + Math.random();
            this.pingRequestServer(_loc_9, false);
            return;
        }// end function

        public function sendFilmScoreRecommend(param1:uint) : void
        {
            var _loc_8:Number = NaN;
            var _loc_2:* = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_4:* = UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("");
            var _loc_5:* = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
            var _loc_6:String = "";
            if (UserManager.getInstance().user)
            {
                _loc_6 = UserManager.getInstance().user.P00001;
            }
            var _loc_7:String = "";
            if (_loc_2.curActor.movieModel.channelID == ChannelEnum.FILM.id)
            {
                _loc_7 = _loc_2.curActor.movieModel.tvid;
                _loc_8 = 2;
            }
            else
            {
                _loc_7 = _loc_2.curActor.movieModel.albumId;
                _loc_8 = 1;
            }
            var _loc_9:* = SystemConfig.MOVIE_SCORE_URL + "add_movie_score?qipu_id=" + _loc_7 + "&uid=" + _loc_4 + "&pauthcookie=" + (UserManager.getInstance().user ? (UserManager.getInstance().user.profileCookie) : ("")) + "&authcookie=" + _loc_6 + "&appid=21" + "&type=" + _loc_8 + "&pru=" + _loc_5 + "&mod=" + FlashVarConfig.localize + "&score=" + param1 + "&rn=" + Math.random();
            this.pingRequestServer(_loc_9, false);
            return;
        }// end function

        public function barrageDeleteInfo(param1:uint, param2:int) : void
        {
            var _loc_3:* = PING_BACK_BARRAGE + "?block=tucao" + "&t=21" + "&vtime=" + param2 + "&rseat=140903_clr" + "&clrcnt=" + param1 + this.publicUrl_4_0() + "&rn=" + Math.random();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function userActionPing_4_0(param1:String) : void
        {
            var _loc_2:* = PING_BACK_BARRAGE + "?rseat=" + param1 + "&t=20" + this.publicUrl_4_0() + "&rn=" + Math.random();
            this.pingRequestServer(_loc_2, false);
            return;
        }// end function

        public function showActionPing_4_0(param1:String) : void
        {
            var _loc_2:* = PING_BACK_BARRAGE + "?block=" + param1 + "&t=21" + this.publicUrl_4_0() + "&rn=" + Math.random();
            this.pingRequestServer(_loc_2, false);
            return;
        }// end function

        public function noticeUserActionPing_4_0(param1:String, param2:String) : void
        {
            var _loc_3:* = PING_BACK_BARRAGE + "?rseat=" + param1 + "&noticeid=" + param2 + "&t=20" + this.publicUrl_4_0() + "&rn=" + Math.random();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function noticeShowActionPing_4_0(param1:String, param2:String) : void
        {
            var _loc_3:* = PING_BACK_BARRAGE + "?block=" + param1 + "&noticeid=" + param2 + "&t=21" + this.publicUrl_4_0() + "&rn=" + Math.random();
            this.pingRequestServer(_loc_3, false);
            return;
        }// end function

        public function mirrorCheckUser(param1:String, param2:String, param3:String) : void
        {
            var _loc_4:* = PING_BACK_MIRROR + "yhy/checkvip_timeout?p1=1_10_101&u=" + param1 + "&pu=" + param2 + "&fv=" + WonderVersion.VERSION_WONDER + "&mod=" + FlashVarConfig.localize + "&at=" + param3;
            this.pingRequestServer(_loc_4);
            return;
        }// end function

        private function publicUrl_4_0() : String
        {
            var _loc_1:* = this._facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = this._facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_3:* = _loc_1.curActor.movieModel;
            var _loc_4:* = _loc_1.curActor.movieInfo;
            var _loc_5:String = "";
            var _loc_6:Number = 0;
            var _loc_7:String = "";
            var _loc_8:* = UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("");
            var _loc_9:* = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
            if (_loc_3 && _loc_4)
            {
                _loc_5 = _loc_3.tvid;
                _loc_6 = _loc_3.duration;
                _loc_7 = _loc_3.channelID.toString();
            }
            var _loc_10:* = "&pf=1" + "&bstp=0" + "&p=10" + "&p1=101" + "&u=" + _loc_1.curActor.uuid + "&pu=" + _loc_8 + "&pru=" + _loc_9 + "&qpid=" + _loc_5 + "&c1=" + _loc_7 + "&mod=" + FlashVarConfig.localize + "&tm=" + _loc_6;
            return _loc_10;
        }// end function

        private function getPageLocationHref() : String
        {
            var location:String;
            try
            {
                location = ExternalInterface.call("function(){return window.location.href;}");
                if (location)
                {
                    location = encodeURIComponent(location);
                }
            }
            catch (e:Error)
            {
                location;
            }
            return location;
        }// end function

        private function getBrowserMatch() : Object
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:RegExp = null;
            var _loc_4:RegExp = null;
            var _loc_5:RegExp = null;
            var _loc_6:Object = null;
            try
            {
                _loc_1 = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
                _loc_2 = _loc_1 ? (_loc_1) : ("");
                _loc_3 = new RegExp("(opera)(?:.*version)?[ \\/]([\\w.]+)", "i");
                _loc_4 = new RegExp("(msie) ([\\w.]+)", "i");
                _loc_5 = new RegExp("(mozilla)(?:.*? rv:([\\w.]+))?", "i");
                _loc_6 = new RegExp("(webkit)[ \\/]([\\w.]+)", "i").exec(_loc_2) || _loc_3.exec(_loc_2) || _loc_4.exec(_loc_2) || _loc_2.indexOf("compatible") < 0 && _loc_5.exec(_loc_2) || [];
                return {browser:_loc_6[1] || "", version:_loc_6[2] || "0"};
            }
            catch (error:Error)
            {
            }
            return null;
        }// end function

        public static function getInstance() : PingBack
        {
            if (_instance == null)
            {
                _instance = new PingBack(new SingletonClass());
            }
            return _instance;
        }// end function

    }
}

class SingletonClass extends Object
{

    function SingletonClass()
    {
        return;
    }// end function

}

