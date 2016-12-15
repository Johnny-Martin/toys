package com.qiyi.player.wonder.plugins.scenetile.view
{
    import __AS3__.vec.*;
    import com.adobe.serialization.json.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.socket.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.vo.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.*;
    import flash.events.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class SceneTileBarrageViewMediator extends Mediator
    {
        private var _sceneTileProxy:SceneTileProxy;
        private var _playerProxy:PlayerProxy;
        private var _sceneTileView:SceneTileBarrageView;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileBarrageViewMediator";

        public function SceneTileBarrageViewMediator(param1:SceneTileBarrageView)
        {
            this._log = Log.getLogger(NAME);
            super(NAME, param1);
            this._sceneTileView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            this._playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            this._sceneTileView.addEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
            this._sceneTileView.addEventListener(SceneTileEvent.Evt_BarrageDeleteInfo, this.onBarrageDeleteInfo);
            this._sceneTileView.addEventListener(SceneTileEvent.Evt_BarrageItemClick, this.onBarrageItemClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [SceneTileDef.NOTIFIC_ADD_STATUS, SceneTileDef.NOTIFIC_REMOVE_STATUS, SceneTileDef.NOTIFIC_RECEIVE_BARRAGE_INFO, SceneTileDef.NOTIFIC_STAR_HEAD_SHOW, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_REPLAY, BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS, BodyDef.NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_SETTING, BodyDef.NOTIFIC_PLAYER_RUNNING, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, BodyDef.NOTIFIC_JS_CALL_GET_BARRAGE_CONFIG, ADDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_2:Object = null;
            var _loc_5:Vector.<BarrageInfoVO> = null;
            var _loc_6:JavascriptAPIProxy = null;
            var _loc_7:BarrageInfoVO = null;
            var _loc_8:Object = null;
            var _loc_9:JavascriptAPIProxy = null;
            var _loc_10:JavascriptAPIProxy = null;
            super.handleNotification(param1);
            _loc_2 = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case SceneTileDef.NOTIFIC_ADD_STATUS:
                {
                    this._sceneTileView.onAddStatus(int(_loc_2));
                    break;
                }
                case SceneTileDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._sceneTileView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case SceneTileDef.NOTIFIC_RECEIVE_BARRAGE_INFO:
                {
                    _loc_5 = _loc_2 as Vector.<BarrageInfoVO>;
                    if (_loc_5 && this._sceneTileProxy.barrageProxy.checkShowBarrage())
                    {
                        this._sceneTileView.updateBufferBarrageInfo(_loc_5, true);
                    }
                    break;
                }
                case SceneTileDef.NOTIFIC_STAR_HEAD_SHOW:
                {
                    if (this.checkShowStarHead())
                    {
                        this._sceneTileProxy.addStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
                    }
                    else
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._sceneTileView.onResize(_loc_2.w, _loc_2.h);
                    break;
                }
                case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
                {
                    this.onCheckUserComplete();
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
                {
                    this.onPlayerStatusChanged(int(_loc_2), true, _loc_4);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS:
                {
                    this.onPlayerStatusChanged(int(_loc_2), false, _loc_4);
                    break;
                }
                case BodyDef.NOTIFIC_FULL_SCREEN:
                {
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REPLAY:
                {
                    var _loc_11:int = 0;
                    this._sceneTileProxy.barrageProxy.preLoadDataParagraph = 0;
                    this._sceneTileProxy.barrageProxy.curDataParagraph = _loc_11;
                    this._sceneTileProxy.barrageProxy.isRequestBarrageConfig = false;
                    this._sceneTileProxy.barrageProxy.barrageConfigObj = null;
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this._sceneTileView.clearAllBarrageItem();
                    var _loc_11:int = 0;
                    this._sceneTileProxy.barrageProxy.preLoadDataParagraph = 0;
                    this._sceneTileProxy.barrageProxy.curDataParagraph = _loc_11;
                    this._sceneTileProxy.barrageProxy.isRequestBarrageConfig = false;
                    this._sceneTileProxy.barrageProxy.barrageConfigObj = null;
                    this._sceneTileView.removeEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
                    this._sceneTileProxy.barrageProxy.barrageSocket.close();
                    _loc_6 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    _loc_6.callJsSetBarrageInteractInfo(this._sceneTileProxy.barrageProxy.starInteractInfo.starInteractObj, this._sceneTileProxy.barrageProxy.barrageSocket.connected);
                    var _loc_11:* = this._sceneTileProxy.barrageProxy.barrageSocket.connected;
                    this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageProxy.barrageSocket.connected;
                    this._playerProxy.curActor.isStarBarrage = _loc_11;
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS:
                {
                    var _loc_11:* = _loc_2.isOpen;
                    this._playerProxy.preActor.openBarrage = _loc_2.isOpen;
                    this._playerProxy.curActor.openBarrage = _loc_11;
                    this._sceneTileProxy.barrageProxy.isBarrageOpen = _loc_2.isOpen;
                    if (!this._sceneTileProxy.barrageProxy.isBarrageOpen)
                    {
                        this._sceneTileProxy.barrageProxy.barrageSocket.close();
                        _loc_9 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                        _loc_9.callJsSetBarrageInteractInfo(this._sceneTileProxy.barrageProxy.starInteractInfo.starInteractObj, this._sceneTileProxy.barrageProxy.barrageSocket.connected);
                        var _loc_11:* = this._sceneTileProxy.barrageProxy.barrageSocket.connected;
                        this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageProxy.barrageSocket.connected;
                        this._playerProxy.curActor.isStarBarrage = _loc_11;
                    }
                    this._sceneTileView.hideAllBarrageItem(this.checkShowBarrage());
                    if (this.checkShowBarrage() && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING))
                    {
                        this._sceneTileView.addEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SELF_SEND_BARRAGE_INFO:
                {
                    _loc_7 = new BarrageInfoVO();
                    _loc_8 = new Object();
                    _loc_8.msgType = BarrageSocket.TVL_TYPE_SEND_MESSAGE;
                    _loc_8.data = [_loc_2];
                    if (this._sceneTileProxy.barrageProxy.barrageSocket.connected)
                    {
                        this._sceneTileProxy.barrageProxy.barrageSocket.send(BarrageSocket.TVL_TYPE_SEND_MESSAGE, JSON.encode(_loc_8));
                    }
                    _loc_7.update(_loc_2, SceneTileDef.BARRAGE_SOURCE_JS);
                    if (this._sceneTileProxy.barrageProxy.barrageSocket.connected && _loc_2.contentType && _loc_2.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
                    {
                        return;
                    }
                    if (this._playerProxy.curActor.movieModel && this._playerProxy.curActor.movieModel.albumId == "202445101" || this._playerProxy.curActor.movieInfo.infoJSON && this._playerProxy.curActor.movieInfo.infoJSON.sid == "202445101" || !this._sceneTileProxy.barrageProxy.checkCanBarrageFakeWrite())
                    {
                        return;
                    }
                    this._sceneTileView.updateSelfBarrageInfo(_loc_7);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
                {
                    this._sceneTileView.hideAllBarrageItem(this.checkShowBarrage());
                    if (this.checkShowBarrage() && !this._sceneTileView.hasEventListener(Event.ENTER_FRAME) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING))
                    {
                        this._sceneTileView.addEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
                    }
                    if (this.checkShowStarHead())
                    {
                        this._sceneTileProxy.addStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
                    }
                    else
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_SETTING:
                {
                    this._sceneTileProxy.barrageProxy.barrageAlpha = _loc_2.alpha == undefined ? (this._sceneTileProxy.barrageProxy.barrageAlpha) : (_loc_2.alpha);
                    if (_loc_2.isFilterImage != undefined)
                    {
                        this._sceneTileProxy.barrageProxy.barrageIsFilterImage = _loc_2.isFilterImage == "1" ? (true) : (false);
                    }
                    this._sceneTileView.updateAllBarrageItemAlpha(this._sceneTileProxy.barrageProxy.barrageAlpha);
                    this._sceneTileView.isFilterImage = this._sceneTileProxy.barrageProxy.barrageIsFilterImage;
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    this.onPlayerRunning(_loc_2.currentTime, _loc_2.bufferTime, _loc_2.duration, _loc_2.playingDuration);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_GET_BARRAGE_CONFIG:
                {
                    if (this._sceneTileProxy.barrageProxy.barrageConfigObj && this._sceneTileProxy.barrageProxy.barrageConfigObj.code == "A00000" && this._sceneTileProxy.barrageProxy.barrageConfigObj.data)
                    {
                        _loc_10 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                        _loc_10.callJsSetHasBarrageConfigInfo(this._sceneTileProxy.barrageProxy.barrageConfigObj.data);
                    }
                    break;
                }
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    this.onADStatusChanged(int(_loc_2), true);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            var _loc_4:JavascriptAPIProxy = null;
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2)
                    {
                        this._sceneTileView.clearAllBarrageItem();
                        var _loc_5:int = 0;
                        this._sceneTileProxy.barrageProxy.preLoadDataParagraph = 0;
                        this._sceneTileProxy.barrageProxy.curDataParagraph = _loc_5;
                        this._sceneTileProxy.barrageProxy.isRequestBarrageConfig = false;
                        this._sceneTileProxy.barrageProxy.barrageConfigObj = null;
                        this._sceneTileView.removeEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
                        this._sceneTileProxy.barrageProxy.barrageSocket.close();
                        _loc_4 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                        _loc_4.callJsSetBarrageInteractInfo(this._sceneTileProxy.barrageProxy.starInteractInfo.starInteractObj, this._sceneTileProxy.barrageProxy.barrageSocket.connected);
                        var _loc_5:* = this._sceneTileProxy.barrageProxy.barrageSocket.connected;
                        this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageProxy.barrageSocket.connected;
                        this._playerProxy.curActor.isStarBarrage = _loc_5;
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PAUSED:
                {
                    if (param2)
                    {
                        this._sceneTileView.removeEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    if (param2 && this.checkShowBarrage())
                    {
                        this._sceneTileView.addEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
                    }
                    if (this._playerProxy.curActor.movieInfo.putBarrage)
                    {
                        this._sceneTileProxy.barrageProxy.requestBarrageConfig(this._playerProxy.curActor.movieModel.tvid, this._playerProxy.curActor.movieModel.albumId, this._playerProxy.curActor.movieModel.channelID);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_FAILED:
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2)
                    {
                        this._sceneTileView.clearAllBarrageItem();
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                        this._sceneTileView.removeEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
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

        private function onADStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ADDef.STATUS_LOADING:
                case ADDef.STATUS_PAUSED:
                {
                    this._sceneTileView.removeEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
                    this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
                    break;
                }
                case ADDef.STATUS_PLAYING:
                {
                    this._sceneTileView.removeEventListener(Event.ENTER_FRAME, this.onSceneTileViewEnterFrame);
                    this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW);
                    if (this._playerProxy.curActor.movieInfo.putBarrage)
                    {
                        this._sceneTileProxy.barrageProxy.requestBarrageConfig(this._playerProxy.curActor.movieModel.tvid, this._playerProxy.curActor.movieModel.albumId, this._playerProxy.curActor.movieModel.channelID);
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

        private function onSceneTileViewEnterFrame(event:Event) : void
        {
            var _loc_2:Vector.<BarrageInfoVO> = null;
            var _loc_3:int = 0;
            if (this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && this._playerProxy.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                if (this._sceneTileProxy.barrageProxy.checkShowBarrage() && this._playerProxy.curActor.currentTime >= SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME * this._sceneTileProxy.barrageProxy.curDataParagraph || this._playerProxy.curActor.currentTime < SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME * (this._sceneTileProxy.barrageProxy.curDataParagraph - 1))
                {
                    _loc_3 = Math.ceil(this._playerProxy.curActor.currentTime / SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME);
                    this._sceneTileProxy.barrageProxy.requestBarrageData(_loc_3 == 0 ? (1) : (_loc_3), this._playerProxy.curActor.movieModel.tvid, this._playerProxy.curActor.movieModel.albumId, this._playerProxy.curActor.movieModel.channelID);
                    this._sceneTileView.isFilterImage = this._sceneTileProxy.barrageProxy.barrageIsFilterImage;
                }
                if (!this._sceneTileProxy.barrageProxy.starInteractInfo.isReady && !this._sceneTileProxy.barrageProxy.starInteractInfo.isLoading)
                {
                    this._sceneTileProxy.barrageProxy.starInteractInfo.startLoad();
                }
                _loc_2 = this._sceneTileProxy.barrageProxy.getBarrageData(Math.ceil(this._playerProxy.curActor.currentTime / 1000));
                if (_loc_2 != null && this._sceneTileProxy.barrageProxy.checkShowBarrage())
                {
                    this._sceneTileView.updateBufferBarrageInfo(_loc_2);
                }
                this._sceneTileView.updateBarrageItemCoordinate(this._sceneTileProxy.barrageProxy.barrageSocket.connected);
                this._sceneTileView.checkAddBarrageItem(this.checkShowBarrage(), this._sceneTileProxy.barrageProxy.barrageAlpha, this._sceneTileProxy.barrageProxy.barrageSocket.connected);
                this._sceneTileView.checkRemoveBarrageItem();
            }
            return;
        }// end function

        private function checkShowBarrage() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (this._sceneTileProxy.barrageProxy.isBarrageOpen && this._sceneTileProxy.barrageProxy.checkShowBarrage() && (!_loc_1.hasStatus(ADDef.STATUS_PLAYING) && !_loc_1.hasStatus(ADDef.STATUS_PAUSED) && !_loc_1.hasStatus(ADDef.STATUS_LOADING)) && !this._playerProxy.curActor.smallWindowMode)
            {
                return true;
            }
            return false;
        }// end function

        private function onBarrageDeleteInfo(event:SceneTileEvent) : void
        {
            PingBack.getInstance().barrageDeleteInfo(int(event.data), this._playerProxy.curActor.currentTime);
            return;
        }// end function

        private function onBarrageItemClick(event:SceneTileEvent) : void
        {
            GlobalStage.setNormalScreen();
            var _loc_2:* = event.data as BarrageItem;
            var _loc_3:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            if (_loc_2 && _loc_2.barrageInfo)
            {
                _loc_3.callJsBarrageReply(_loc_2.barrageInfo);
            }
            return;
        }// end function

        private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:Object = null;
            var _loc_6:Number = NaN;
            var _loc_7:JavascriptAPIProxy = null;
            if (this._sceneTileProxy.barrageProxy.starInteractInfo.isReady && this._playerProxy.curActor.movieModel)
            {
                _loc_5 = this._sceneTileProxy.barrageProxy.starInteractInfo.getStarInteractByTvid(this._playerProxy.curActor.movieModel.tvid);
                _loc_6 = new Date().valueOf();
                if (_loc_5 && (_loc_6 >= Number(_loc_5.begin_time) * 1000 && _loc_6 < Number(_loc_5.end_time) * 1000))
                {
                    if (!this._sceneTileProxy.barrageProxy.barrageSocket.connected && !this._sceneTileProxy.barrageProxy.barrageSocket.isConnecting && this._sceneTileProxy.barrageProxy.isBarrageOpen)
                    {
                        this._sceneTileProxy.barrageProxy.barrageSocket.open(this._playerProxy.curActor.movieModel.tvid);
                    }
                }
                else if (this._sceneTileProxy.barrageProxy.barrageSocket.connected)
                {
                    this._sceneTileProxy.barrageProxy.barrageSocket.close();
                    _loc_7 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    _loc_7.callJsSetBarrageInteractInfo(this._sceneTileProxy.barrageProxy.starInteractInfo.starInteractObj, this._sceneTileProxy.barrageProxy.barrageSocket.connected);
                    var _loc_8:* = this._sceneTileProxy.barrageProxy.barrageSocket.connected;
                    this._playerProxy.preActor.isStarBarrage = this._sceneTileProxy.barrageProxy.barrageSocket.connected;
                    this._playerProxy.curActor.isStarBarrage = _loc_8;
                    sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
                }
            }
            return;
        }// end function

        private function checkShowStarHead() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (this._sceneTileProxy.barrageProxy.barrageSocket.connected && !this._playerProxy.curActor.smallWindowMode && this._sceneTileProxy.barrageProxy.isBarrageOpen && this._sceneTileProxy.barrageProxy.checkShowBarrage() && (!_loc_1.hasStatus(ADDef.STATUS_PLAYING) && !_loc_1.hasStatus(ADDef.STATUS_PAUSED) && !_loc_1.hasStatus(ADDef.STATUS_LOADING)))
            {
                return true;
            }
            return false;
        }// end function

        private function onCheckUserComplete() : void
        {
            var _loc_1:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_2:* = new UserInfoVO();
            _loc_2.isLogin = _loc_1.isLogin;
            _loc_2.passportID = _loc_1.passportID;
            _loc_2.userID = _loc_1.userID;
            _loc_2.userName = _loc_1.userName;
            _loc_2.userLevel = _loc_1.userLevel;
            _loc_2.userType = _loc_1.userType;
            if (this._sceneTileProxy.barrageProxy.barrageSocket.connected)
            {
                this._sceneTileProxy.barrageProxy.barrageSocket.sendLogin(false);
            }
            this._sceneTileView.onUserInfoChanged(_loc_2);
            return;
        }// end function

    }
}
