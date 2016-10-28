package com.qiyi.player.wonder.body.model
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.lso.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.vo.*;
    import flash.external.*;
    import gs.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class JavascriptAPIProxy extends Proxy
    {
        private var _addCallbackTryCount:int = 0;
        private var _userProxy:UserProxy;
        private var _playerProxy:PlayerProxy;
        private var _origin:String = "";
        private var _callJsFollowUpNextLoadFlag:Boolean = false;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.body.model.JavascriptAPIProxy";
        public static var JS_CALLBACK_V1:String = "lib.swf.notice";
        public static var JS_CALLBACK_V2:String = "Q.__callbacks__.iqiyi_player_notice";

        public function JavascriptAPIProxy()
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.body.model.JavascriptAPIProxy");
            super(NAME);
            this.addCallback();
            return;
        }// end function

        private function addCallback() : void
        {
            if (this._addCallbackTryCount > 100)
            {
                return;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._addCallbackTryCount + 1;
            _loc_2._addCallbackTryCount = _loc_3;
            if (ExternalInterface.available)
            {
                try
                {
                    ExternalInterface.addCallback("loadQiyiVideo", this.loadQiyiVideo);
                    ExternalInterface.addCallback("pauseQiyiVideo", this.pauseQiyiVideo);
                    ExternalInterface.addCallback("resumeQiyiVideo", this.resumeQiyiVideo);
                    ExternalInterface.addCallback("initQiyiVideo", this.initQiyiVideo);
                    ExternalInterface.addCallback("seekQiyiVideo", this.seekQiyiVideo);
                    ExternalInterface.addCallback("replayQiyiVideo", this.replayQiyiVideo);
                    ExternalInterface.addCallback("setCyclePlay", this.setCyclePlay);
                    ExternalInterface.addCallback("setNextQiyiVideoInfo", this.setNextQiyiVideoInfo);
                    ExternalInterface.addCallback("setContinuePlayState", this.setContinuePlayState);
                    ExternalInterface.addCallback("switchVideo", this.switchVideo);
                    ExternalInterface.addCallback("switchNextVideo", this.switchNextVideo);
                    ExternalInterface.addCallback("switchPreVideo", this.switchPreVideo);
                    ExternalInterface.addCallback("addVideoList", this.addVideoList);
                    ExternalInterface.addCallback("removeVideoList", this.removeVideoList);
                    ExternalInterface.addCallback("getQiyiPlayerInfo", this.getQiyiPlayerInfo);
                    ExternalInterface.addCallback("getQiyiVideoInfo", this.getQiyiVideoInfo);
                    ExternalInterface.addCallback("getIsInMainVideo", this.getIsInMainVideo);
                    ExternalInterface.addCallback("getQiyuInfo", this.getQiyuInfo);
                    ExternalInterface.addCallback("setQiyiUserLogin", this.setQiyiUserLogin);
                    ExternalInterface.addCallback("setQiyiSubscribe", this.setQiyiSubscribe);
                    ExternalInterface.addCallback("setQiyiVisits", this.setQiyiVisits);
                    ExternalInterface.addCallback("setLight", this.setLight);
                    ExternalInterface.addCallback("forceToSaveCurVideoInfo", this.forceToSaveCurVideoInfo);
                    ExternalInterface.addCallback("expand", this.expand);
                    ExternalInterface.addCallback("setBarrageStatus", this.setBarrageStatus);
                    ExternalInterface.addCallback("setSelfSendBarrageInfo", this.setSelfSendBarrageInfo);
                    ExternalInterface.addCallback("setSmallWindowMode", this.setSmallWindowMode);
                    ExternalInterface.addCallback("setBarrageSetting", this.setBarrageSetting);
                    ExternalInterface.addCallback("getCaptureURL", this.getCaptureURL);
                    ExternalInterface.addCallback("setActivityNoticeInfo", this.setActivityNoticeInfo);
                    ExternalInterface.addCallback("zoomQiyiVideo", this.zoomQiyiVideo);
                    ExternalInterface.addCallback("setTimeListener", this.timeListener);
                    ExternalInterface.addCallback("getHasBarrageConfigInfo", this.getHasBarrageConfigInfo);
                    ExternalInterface.addCallback("setSubscribeInfo", this.setSubscribeInfo);
                    ExternalInterface.addCallback("setSubscribeStateChange", this.setSubscribeStateChange);
                    ExternalInterface.addCallback("getCommentConfigInfo", this.getCommentConfigInfo);
                    ExternalInterface.addCallback("getQiyiPlayerLog", this.getQiyiPlayerLog);
                    TweenLite.delayedCall(2, this.callJsPlayerLoadSuccess);
                }
                catch (error:Error)
                {
                    _log.warn("JavascriptAPIProxy add call back，catch error!");
                    TweenLite.delayedCall(0.3, addCallback);
                }
            }
            else
            {
                this._log.warn("JavascriptAPIProxy add call，available is false!");
                TweenLite.delayedCall(0.3, this.addCallback);
            }
            return;
        }// end function

        public function injectUserProxy(param1:UserProxy) : void
        {
            this._userProxy = param1;
            return;
        }// end function

        public function injectPlayerProxy(param1:PlayerProxy) : void
        {
            this._playerProxy = param1;
            return;
        }// end function

        public function externalInterfaceCall(param1:String, param2:Object) : void
        {
            var $jsFun:* = param1;
            var $param:* = param2;
            try
            {
                if (this._origin == "")
                {
                    if (!ExternalInterface.objectID)
                    {
                        this._origin = FlashVarConfig.origin;
                    }
                    else
                    {
                        this._origin = ExternalInterface.objectID;
                    }
                }
                ExternalInterface.call("document.getElementById(\'" + this._origin + "\').fire", JSON.encode($param));
                ExternalInterface.call($jsFun, JSON.encode($param));
            }
            catch (error:Error)
            {
                _log.debug("call js error : " + $param.type);
            }
            return;
        }// end function

        private function unitTest() : void
        {
            return;
        }// end function

        public function checkClientInstall() : Boolean
        {
            try
            {
                return ExternalInterface.call("lib.swf.checkClientInstall");
            }
            catch (error:Error)
            {
            }
            return false;
        }// end function

        public function callJsPlayNextVideo() : void
        {
            this._log.debug("call js callJsPlayNextVideo");
            var _loc_1:* = new Object();
            _loc_1.type = "playNextVideo";
            var _loc_2:* = new Object();
            _loc_2.origin = FlashVarConfig.origin;
            _loc_1.data = _loc_2;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_1);
            return;
        }// end function

        public function callJsPlayPreVideo() : void
        {
            return;
        }// end function

        public function callJsSetLight(param1:Boolean) : void
        {
            this._log.debug("call js callJsSetLight");
            var _loc_2:* = new Object();
            _loc_2.type = "setLight";
            var _loc_3:* = new Object();
            _loc_3.open = param1.toString();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            sendNotification(BodyDef.NOTIFIC_JS_LIGHT_CHANGED, param1);
            return;
        }// end function

        public function callJsLoadComplete() : void
        {
            this._log.debug("call js callJsLoadComplete");
            var _loc_1:* = new Object();
            _loc_1.type = "loadComplete";
            var _loc_2:* = new Object();
            _loc_2.complete = "true";
            if (this._playerProxy.curActor.movieModel)
            {
                _loc_2.tvid = this._playerProxy.curActor.movieModel.tvid;
            }
            else
            {
                _loc_2.tvid = "";
            }
            _loc_2.origin = FlashVarConfig.origin;
            _loc_1.data = _loc_2;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_1);
            return;
        }// end function

        public function callJsDownload() : void
        {
            this._log.debug("call js callJsDownload");
            var _loc_1:* = this._playerProxy.curActor.movieModel;
            var _loc_2:* = this._playerProxy.curActor.movieInfo;
            var _loc_3:* = new Object();
            _loc_3.type = "download";
            var _loc_4:* = new Object();
            _loc_4.albumId = _loc_1 ? (_loc_1.albumId) : ("");
            _loc_4.videoName = _loc_2 ? (_loc_2.title ? (_loc_2.title.replace(/\\""""\"/g, "\'")) : ("")) : ("");
            _loc_4.isCharge = _loc_1 ? (_loc_1.member.toString()) : ("false");
            _loc_4.tvid = _loc_1 ? (_loc_1.tvid) : ("");
            _loc_4.origin = FlashVarConfig.origin;
            _loc_3.data = _loc_4;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_3);
            return;
        }// end function

        public function callJsPlayerStateChange(param1:String, param2:String = "", param3:String = "") : void
        {
            this._log.info("call js callJsPlayerStateChange(" + param1 + "), tvid: " + param2);
            var _loc_4:* = new Object();
            _loc_4.type = "playerStateChange";
            var _loc_5:* = new Object();
            _loc_5.tvid = param2;
            _loc_5.vid = param3;
            _loc_5.state = param1;
            if (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED) && (this._playerProxy.curActor.errorCode == 708 || this._playerProxy.curActor.errorCode == 709))
            {
                _loc_5.privateVideo = "1";
            }
            else
            {
                _loc_5.privateVideo = "0";
            }
            _loc_5.origin = FlashVarConfig.origin;
            _loc_4.data = _loc_5;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_4);
            return;
        }// end function

        public function callJsExpand(param1:Boolean) : void
        {
            this._log.debug("call js callJsExpand");
            var _loc_2:* = new Object();
            _loc_2.type = "expand";
            var _loc_3:* = new Object();
            _loc_3.value = param1.toString();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            sendNotification(BodyDef.NOTIFIC_JS_EXPAND_CHANGED, param1);
            return;
        }// end function

        public function callJsRecharge(param1:String, param2:String, param3:String, param4:String, param5:int = 0) : void
        {
            this._log.debug("call js callJsRecharge,code:" + param4 + ",from:" + param5 + ",tvid:" + param1 + ",vid:" + param2);
            var _loc_6:* = new Object();
            _loc_6.type = "recharge";
            var _loc_7:* = new Object();
            _loc_7.code = param4;
            _loc_7.tvid = param1;
            _loc_7.vid = param2;
            _loc_7.aid = param3;
            _loc_7.from = param5;
            _loc_7.origin = FlashVarConfig.origin;
            _loc_6.data = _loc_7;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_6);
            return;
        }// end function

        public function callJsAuthenticationResult(param1:String, param2:Boolean) : void
        {
            this._log.debug("call js callJsAuthenticationResult,isTryWatch:" + param2);
            var _loc_3:* = new Object();
            _loc_3.type = "authenticationResult";
            var _loc_4:* = new Object();
            _loc_4.isTryWatch = param2.toString();
            _loc_4.tvid = param1;
            _loc_4.origin = FlashVarConfig.origin;
            _loc_3.data = _loc_4;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_3);
            return;
        }// end function

        public function callJsRequestVideoList(param1:Boolean) : void
        {
            this._log.debug("call js callJsRequestVideoList,isBefore:" + param1);
            var _loc_2:* = new Object();
            _loc_2.type = "requestVideoList";
            var _loc_3:* = new Object();
            _loc_3.around = param1 ? ("0") : ("1");
            _loc_3.origin = FlashVarConfig.origin;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsSwitchFullScreen(param1:Boolean) : void
        {
            this._log.debug("call js callJsSwitchFullScreen " + param1);
            var _loc_2:* = new Object();
            _loc_2.type = "switchFullScreen";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.value = param1.toString();
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsRequestJSSendPB(param1:int) : void
        {
            this._log.debug("call js callJsRequestJSSendPB " + param1);
            var _loc_2:* = new Object();
            _loc_2.type = "requestJSSendPB";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.PBType = param1.toString();
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsShowLoginPanel(param1:String) : void
        {
            this._log.debug("call js callJsShowLoginPanel, source:" + param1);
            var _loc_2:* = new Object();
            _loc_2.type = "showLoginPanel";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.source = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsFocusTips(param1:int) : void
        {
            this._log.debug("call js callJsFocusTips,time:" + param1);
            var _loc_2:* = new Object();
            _loc_2.type = "focusTips";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.time = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V2, _loc_2);
            return;
        }// end function

        public function callJsRefreshPage() : void
        {
            this._log.debug("call js callJsRefreshPage");
            var _loc_1:* = new Object();
            _loc_1.type = "refreshPage";
            var _loc_2:* = new Object();
            _loc_2.origin = FlashVarConfig.origin;
            _loc_1.data = _loc_2;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_1);
            return;
        }// end function

        public function callJsFindGoods(param1:int) : void
        {
            this._log.debug("call js callJsFindGoods,time:" + param1);
            var _loc_2:* = new Object();
            _loc_2.type = "findGoods";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.time = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsBarrageReply(param1:BarrageInfoVO) : void
        {
            this._log.debug("call js callJsBarrageReply,$barrageInfo:" + param1);
            var _loc_2:* = new Object();
            _loc_2.type = "barrageReply";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.uid = param1 && param1.userInfo && param1.userInfo.uid ? (param1.userInfo.uid.toString()) : ("");
            _loc_3.name = param1 && param1.userInfo && param1.userInfo.name ? (param1.userInfo.name.toString()) : ("");
            _loc_3.replyContentId = param1 ? (param1.contentId) : ("");
            _loc_3.replyContent = param1 ? (param1.content) : ("");
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsSetBarrageInteractInfo(param1:Object, param2:Boolean) : void
        {
            this._log.debug("call js callJsSetBarrageInteractInfo isConnected=" + param2);
            var _loc_3:* = new Object();
            _loc_3.type = "setBarrageInteractInfo";
            var _loc_4:* = new Object();
            _loc_4.origin = FlashVarConfig.origin;
            _loc_4.interactInfo = param1;
            _loc_4.isConnected = param2 ? ("1") : ("0");
            _loc_3.data = _loc_4;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_3);
            return;
        }// end function

        public function callJsBarrageReceiveData(param1:Array) : void
        {
            this._log.debug("call js callJsBarrageReceiveData");
            var _loc_2:* = new Object();
            _loc_2.type = "barrageReceiveData";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.barrageData = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsBarrageStateChange(param1:Boolean) : void
        {
            this._log.debug("call js callJsBarrageStateChange");
            var _loc_2:* = new Object();
            _loc_2.type = "barrageStateChange";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.barrageState = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsDoSomething(param1:String) : void
        {
            this._log.debug("call js setJsDoSomething : " + param1);
            var _loc_2:* = new Object();
            _loc_2.type = "setJsDoSomething";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.handleType = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsFollowUpNextLoad() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Object = null;
            if (!this._callJsFollowUpNextLoadFlag)
            {
                this._log.debug("call js FollowUpNextLoad");
                this._callJsFollowUpNextLoadFlag = true;
                _loc_1 = new Object();
                _loc_1.type = "followUpNextLoad";
                _loc_2 = new Object();
                _loc_2.origin = FlashVarConfig.origin;
                _loc_1.data = _loc_2;
                this.externalInterfaceCall(JS_CALLBACK_V1, _loc_1);
            }
            return;
        }// end function

        public function callJsUserClickScore(param1:Number) : void
        {
            this._log.debug("call js userClickScore");
            var _loc_2:* = new Object();
            _loc_2.type = "userClickScore";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.score = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsSetHasBarrageConfigInfo(param1:Object) : void
        {
            this._log.debug("call js setHasBarrageConfigInfo");
            var _loc_2:* = new Object();
            _loc_2.type = "setHasBarrageConfigInfo";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.configInfo = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function callJsPgcFollow(param1:uint) : void
        {
            this._log.debug("call js pgcFollow");
            var _loc_2:* = new Object();
            _loc_2.type = "pgcFollow";
            var _loc_3:* = new Object();
            _loc_3.origin = FlashVarConfig.origin;
            _loc_3.playerSubscribe = param1;
            _loc_2.data = _loc_3;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_2);
            return;
        }// end function

        public function requestLogin() : void
        {
            var dataProvider:Object;
            var dataValue:Object;
            this._log.debug("call js callJsLogin ");
            try
            {
                dataProvider = new Object();
                dataProvider.type = "requestLogin";
                dataValue = new Object();
                dataValue.origin = FlashVarConfig.origin;
                dataProvider.data = dataValue;
                this.externalInterfaceCall(JS_CALLBACK_V1, dataProvider);
            }
            catch (error:Error)
            {
                _log.debug("call js callJsLogin error");
            }
            return;
        }// end function

        public function requestReward() : void
        {
            var dataProvider:Object;
            var dataValue:Object;
            this._log.debug("call js callJsReward ");
            try
            {
                dataProvider = new Object();
                dataProvider.type = "requestReward";
                dataValue = new Object();
                dataValue.origin = FlashVarConfig.origin;
                dataProvider.data = dataValue;
                this.externalInterfaceCall(JS_CALLBACK_V1, dataProvider);
            }
            catch (error:Error)
            {
                _log.debug("call js callJsReward error");
            }
            return;
        }// end function

        public function callJsCommentAllowed(param1:Boolean, param2:String) : void
        {
            this._log.debug("call js commentAllowed");
            var _loc_3:* = new Object();
            _loc_3.type = "commentAllowed";
            var _loc_4:* = new Object();
            _loc_4.origin = FlashVarConfig.origin;
            _loc_4.commentAllowed = param1;
            _loc_4.qitanId = param2;
            _loc_3.data = _loc_4;
            this.externalInterfaceCall(JS_CALLBACK_V1, _loc_3);
            return;
        }// end function

        private function callJsPlayerLoadSuccess() : void
        {
            this._log.debug("call js callJsPlayerLoadSuccess");
            var _loc_1:* = new Object();
            _loc_1.type = "playerLoadSuccess";
            var _loc_2:* = new Object();
            _loc_2.origin = FlashVarConfig.origin;
            _loc_1.data = _loc_2;
            try
            {
                ExternalInterface.call("lib.swf.notice", JSON.encode(_loc_1));
            }
            catch (error:Error)
            {
            }
            this.externalInterfaceCall(JS_CALLBACK_V2, _loc_1);
            this.unitTest();
            return;
        }// end function

        private function loadQiyiVideo(param1:String) : void
        {
            var obj:Object;
            var $callback:* = param1;
            if (this._playerProxy.invalid)
            {
                return;
            }
            try
            {
                this._log.info("js call loadQiyiVideo");
                ProcessesTimeRecord.needRecord = false;
                obj = JSON.decode($callback);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_LOAD_QIYI_VIDEO, obj);
            }
            catch (error:Error)
            {
                _log.info("js call loadQiyiVideo error");
            }
            return;
        }// end function

        private function pauseQiyiVideo() : void
        {
            this._log.debug("js call pauseQiyiVideo!");
            sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
            sendNotification(BodyDef.NOTIFIC_JS_CALL_PAUSE);
            return;
        }// end function

        private function initQiyiVideo() : void
        {
            this._log.debug("js call initQiyiVideo!");
            if (!this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
            {
                sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
            }
            return;
        }// end function

        private function resumeQiyiVideo() : void
        {
            this._log.debug("js call resumeQiyiVideo!");
            if (!FlashVarConfig.autoPlay && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
            {
                sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
            }
            else
            {
                sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_RESUME);
            }
            return;
        }// end function

        private function seekQiyiVideo(param1:String) : void
        {
            this._log.debug("js call seek:" + param1);
            var _loc_2:* = int(param1);
            sendNotification(BodyDef.NOTIFIC_JS_CALL_SEEK, _loc_2 * 1000);
            return;
        }// end function

        private function replayQiyiVideo() : void
        {
            this._log.debug("js call replay");
            sendNotification(BodyDef.NOTIFIC_JS_CALL_REPLAY);
            return;
        }// end function

        private function setCyclePlay(param1:String) : void
        {
            this._log.info("js call setCyclePlay:" + param1);
            var _loc_2:* = param1 == "true";
            sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_CYCLE_PLAY, _loc_2);
            return;
        }// end function

        private function setNextQiyiVideoInfo(param1:String) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Boolean = false;
            var _loc_4:String = null;
            try
            {
                _loc_2 = JSON.decode(param1);
                _loc_3 = _loc_2.continuePlay == "true";
                _loc_4 = _loc_2.nextVideoTitle;
                this._log.debug("js  setNextQiyiVideoInfo:" + _loc_3 + ",nextVideoTitle:" + _loc_4);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO, {continuePlay:_loc_3, nextVideoTitle:_loc_4});
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function setContinuePlayState(param1:String) : void
        {
            var _loc_2:Boolean = false;
            try
            {
                _loc_2 = param1 == "true";
                this._log.debug("js  setContinuePlayState:" + _loc_2);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function switchVideo(param1:String) : void
        {
            var _loc_2:Object = null;
            if (this._playerProxy.invalid)
            {
                return;
            }
            try
            {
                _loc_2 = JSON.decode(param1);
                this._log.debug("js  switchVideo tvid:" + _loc_2.tvid + " vid:" + _loc_2.vid);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SWITCH_VIDEO, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function switchNextVideo() : void
        {
            if (this._playerProxy.invalid)
            {
                return;
            }
            this._log.debug("js switchNextVideo");
            sendNotification(BodyDef.NOTIFIC_JS_CALL_SWITCH_NEXT_VIDEO);
            return;
        }// end function

        private function switchPreVideo() : void
        {
            if (this._playerProxy.invalid)
            {
                return;
            }
            this._log.debug("js switchPreVideo");
            sendNotification(BodyDef.NOTIFIC_JS_CALL_SWITCH_PRE_VIDEO);
            return;
        }// end function

        private function addVideoList(param1:String) : void
        {
            var _loc_2:Object = null;
            try
            {
                _loc_2 = JSON.decode(param1);
                this._log.info("js addVideoList taid = " + _loc_2.taid + " tcid = " + _loc_2.tcid);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_ADD_VIDEO_LIST, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function removeVideoList(param1:String) : void
        {
            var _loc_2:Object = null;
            try
            {
                _loc_2 = JSON.decode(param1);
                this._log.info("js removeVideoList tvid:" + _loc_2.tvid + " vid:" + _loc_2.vid);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_REMOVE_FROM_LIST, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function getQiyiPlayerInfo() : String
        {
            var _loc_2:IMovieModel = null;
            var _loc_3:IMovieInfo = null;
            var _loc_1:* = new Object();
            try
            {
                _loc_2 = this._playerProxy.curActor.movieModel;
                _loc_3 = this._playerProxy.curActor.movieInfo;
                _loc_1.vid = _loc_2.vid;
                _loc_1.tvid = _loc_2.tvid;
                _loc_1.totalDuration = _loc_2.duration;
                _loc_1.currentTime = this._playerProxy.curActor.currentTime;
                _loc_1.currentDefination = _loc_2.curDefinitionInfo.type.id.toString();
                _loc_1.currentTrack = _loc_2.curAudioTrackInfo.com.qiyi.player.core.model:IAudioTrackInfo::type.id.toString();
                _loc_1.uuid = this._playerProxy.curActor.uuid;
                _loc_1.categoryId = _loc_2.channelID.toString();
                _loc_1.loadComplete = this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_LOAD_COMPLETE) ? ("1") : ("0");
                _loc_1.isTryWatch = this._playerProxy.curActor.isTryWatch ? ("1") : ("0");
                _loc_1.width = _loc_2.width;
                _loc_1.height = _loc_2.height;
                this._log.debug("js get getQiyiPlayerInfo time :" + _loc_1.currentTime + "/" + _loc_1.totalDuration + ",loadComplete:" + _loc_1.loadComplete);
            }
            catch (error:Error)
            {
            }
            return JSON.encode(_loc_1);
        }// end function

        private function getQiyiVideoInfo() : String
        {
            this._log.info("js call getQiyiVideoInfo");
            var _loc_1:String = "";
            if (this._playerProxy.curActor.movieInfo)
            {
                return this._playerProxy.curActor.movieInfo.info;
            }
            return "";
        }// end function

        private function getIsInMainVideo() : String
        {
            this._log.info("js call getIsInMainVideo");
            if (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
            {
                return "1";
            }
            return "0";
        }// end function

        private function getQiyuInfo() : String
        {
            this._log.info("js call getQiyuInfo");
            var _loc_1:String = "";
            return JSON.encode(_loc_1);
        }// end function

        private function setQiyiUserLogin(param1:String) : void
        {
            var _loc_2:Object = null;
            var _loc_3:uint = 0;
            this._log.debug("js call setQiyiUserLogin: " + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                if (this._userProxy)
                {
                    this._userProxy.isLogin = _loc_2.login == "true";
                    this._userProxy.passportID = _loc_2.passportId ? (_loc_2.passportId) : ("");
                    this._userProxy.P00001 = _loc_2.P00001 ? (_loc_2.P00001) : ("");
                    this._userProxy.profileID = _loc_2.profileID ? (_loc_2.profileID) : (this._userProxy.passportID);
                    this._userProxy.profileCookie = _loc_2.profileCookie ? (_loc_2.profileCookie) : ("");
                    this._userProxy.loginSource = _loc_2.source ? (_loc_2.source) : ("");
                    if (this._userProxy.isLogin && FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
                    {
                        _loc_3 = LSO.getInstance().takeOutTotalBonus();
                        if (_loc_3 != 0)
                        {
                            this._userProxy.saveTotalBonus(_loc_3, this._playerProxy.curActor.uuid);
                        }
                    }
                    this._log.debug("js call setQiyiUserLogin send notific!");
                    sendNotification(BodyDef.NOTIFIC_CHECK_USER);
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function setQiyiSubscribe(param1:String) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Boolean = false;
            var _loc_4:String = null;
            this._log.debug("js call setQiyiSubscribe");
            try
            {
                _loc_2 = JSON.decode(param1);
                _loc_3 = _loc_2.canSubscribe == "true";
                _loc_4 = _loc_2.tvName;
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SUBSCRIBE, {canSubscribe:_loc_3, tvName:_loc_4});
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function setQiyiVisits(param1:String) : void
        {
            this._log.debug("js call setQiyiVisits:" + param1);
            this._playerProxy.curActor.visits = param1;
            this._playerProxy.preActor.visits = param1;
            PingBack.getInstance().visits = param1;
            return;
        }// end function

        private function setLight(param1:String) : void
        {
            this._log.debug("js call setLight:" + param1);
            var _loc_2:* = param1 == "true";
            sendNotification(BodyDef.NOTIFIC_JS_LIGHT_CHANGED, _loc_2);
            return;
        }// end function

        private function forceToSaveCurVideoInfo(param1:String = "") : void
        {
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            this._log.debug("js call forceToSaveCurVideoInfo");
            var _loc_2:Array = [];
            var _loc_3:* = this._playerProxy.curActor.movieModel;
            if (param1 == "")
            {
                if (_loc_3)
                {
                    _loc_2 = [{tvid:_loc_3.tvid, vid:_loc_3.vid, curtime:this._playerProxy.curActor.currentTime.toString(), albumid:_loc_3.albumId.toString(), definition:_loc_3.curDefinitionInfo.type.id.toString(), member:_loc_3.member.toString()}];
                }
            }
            else
            {
                try
                {
                    _loc_4 = JSON.decode(param1);
                    if (_loc_4 && _loc_4.length)
                    {
                        _loc_5 = 0;
                        while (_loc_5 < _loc_4.length)
                        {
                            
                            _loc_2.push({tvid:_loc_4[_loc_5].tvid, vid:_loc_4[_loc_5].vid, curtime:"0", albumid:_loc_4[_loc_5].albumid, definition:_loc_3 ? (_loc_3.curDefinitionInfo.type.id.toString()) : (""), member:_loc_4[_loc_5].member});
                            _loc_5++;
                        }
                    }
                }
                catch (e:Error)
                {
                }
            }
            LSO.getInstance().setClientFlashInfo(_loc_2);
            return;
        }// end function

        private function expand(param1:String) : void
        {
            this._log.debug("js call expand:" + param1);
            var _loc_2:* = param1 == "true";
            sendNotification(BodyDef.NOTIFIC_JS_EXPAND_CHANGED, _loc_2);
            return;
        }// end function

        private function setBarrageStatus(param1:String) : void
        {
            var _loc_2:Object = null;
            this._log.debug("js call setBarrageStatus:" + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function setSelfSendBarrageInfo(param1:String) : void
        {
            var _loc_2:Object = null;
            this._log.debug("js call setSelfSendBarrageInfo:" + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function setSmallWindowMode(param1:String) : void
        {
            var _loc_2:Boolean = false;
            this._log.debug("js call setSmallWindowMode:" + param1);
            try
            {
                _loc_2 = param1 == "1";
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function setBarrageSetting(param1:String) : void
        {
            var _loc_2:Object = null;
            this._log.debug("js call setBarrageSetting:" + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_SETTING, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function getCaptureURL(param1:String) : String
        {
            var _loc_2:Object = null;
            var _loc_3:Number = NaN;
            var _loc_4:int = 0;
            this._log.debug("js call getCaptureURL:" + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                _loc_3 = -1;
                _loc_4 = 1;
                if (_loc_2.time != undefined)
                {
                    _loc_3 = Number(_loc_2.time);
                }
                if (_loc_2.mode != undefined)
                {
                    _loc_4 = int(_loc_2.mode);
                }
                return this._playerProxy.curActor.getCaptureURL(_loc_3, _loc_4);
            }
            catch (error:Error)
            {
            }
            return "";
        }// end function

        private function setActivityNoticeInfo(param1:String) : void
        {
            var _loc_2:Object = null;
            this._log.debug("js call setActivityNoticeInfo:" + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_ACTIVITY_NOTICE_INFO, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function zoomQiyiVideo(param1:String) : void
        {
            this._log.debug("js call zoomQiyiVideo:" + param1);
            try
            {
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_ZOOM_QIYI_VIDEO, param1);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function timeListener(param1:String) : void
        {
            var _loc_2:Object = null;
            this._log.debug("js call setTimeListener:" + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_TIME_LISTENER, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function getHasBarrageConfigInfo() : void
        {
            this._log.debug("js call getHasBarrageConfigInfo");
            try
            {
                sendNotification(BodyDef.NOTIFIC_JS_CALL_GET_BARRAGE_CONFIG);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function getCommentConfigInfo() : void
        {
            this._log.debug("js call getCommentConfigInfo");
            try
            {
                sendNotification(BodyDef.NOTIFIC_JS_CALL_GET_COMMENT_CONFIG);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function getQiyiPlayerLog() : String
        {
            this._log.debug("js call getCommentConfigInfo");
            try
            {
                return LogManager.getLifeLogs().join("\n");
            }
            catch (error:Error)
            {
            }
            return "";
        }// end function

        private function setSubscribeInfo(param1:String) : void
        {
            var _loc_2:Object = null;
            this._log.debug("js call setSubscribeInfo" + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_SUBSCRIBE_INFO, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function setSubscribeStateChange(param1:String) : void
        {
            var _loc_2:Object = null;
            this._log.debug("js call setSubscribeStateChange" + param1);
            try
            {
                _loc_2 = JSON.decode(param1);
                sendNotification(BodyDef.NOTIFIC_JS_CALL_SET_SUBSCRIBE_STATE_CHANGE, _loc_2);
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

    }
}
