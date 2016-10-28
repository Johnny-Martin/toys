package com.qiyi.player.wonder.plugins.dock.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.dock.*;
    import com.qiyi.player.wonder.plugins.dock.model.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.model.*;
    import com.qiyi.player.wonder.plugins.share.*;
    import com.qiyi.player.wonder.plugins.share.model.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class DockViewMediator extends Mediator implements ISwitch
    {
        private var _dockProxy:DockProxy;
        private var _dockView:DockView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.dock.view.DockViewMediator";

        public function DockViewMediator(param1:DockView)
        {
            super(NAME, param1);
            this._dockView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            SwitchManager.getInstance().register(this);
            this._dockProxy = facade.retrieveProxy(DockProxy.NAME) as DockProxy;
            this._dockView.addEventListener(DockEvent.Evt_Open, this.onDockViewOpen);
            this._dockView.addEventListener(DockEvent.Evt_Close, this.onDockViewClose);
            this._dockView.shareBtn.addEventListener(MouseEvent.CLICK, this.onShareBtnClick);
            this._dockView.openLightBtn.addEventListener(MouseEvent.CLICK, this.onOpenLightBtnClick);
            this._dockView.closeLightBtn.addEventListener(MouseEvent.CLICK, this.onCloseLightBtnClick);
            this._dockView.offlineWatchBtn.addEventListener(MouseEvent.CLICK, this.onOfflineWatchBtnClick);
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [DockDef.NOTIFIC_ADD_STATUS, DockDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_LEAVE_STAGE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_JS_LIGHT_CHANGED, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, ADDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:PlayerProxy = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case DockDef.NOTIFIC_ADD_STATUS:
                {
                    this._dockView.onAddStatus(int(_loc_2));
                    break;
                }
                case DockDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._dockView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._dockView.onResize(_loc_2.w, _loc_2.h);
                    break;
                }
                case BodyDef.NOTIFIC_FULL_SCREEN:
                {
                    if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK_LIGHT) && !Boolean(_loc_2))
                    {
                        this._dockProxy.addStatus(DockDef.STATUS_LIGHT_SHOW);
                    }
                    else
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_LIGHT_SHOW);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_LEAVE_STAGE:
                {
                    this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
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
                case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
                {
                    if (Boolean(_loc_2))
                    {
                        this._dockProxy.addStatus(DockDef.STATUS_LIGHT_ON);
                    }
                    else
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_LIGHT_ON);
                    }
                    _loc_5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    PingBack.getInstance().userActionPing(PingBackDef.LIGHT, _loc_5.curActor.currentTime);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
                {
                    if (Boolean(_loc_2))
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_OPEN);
                    }
                    else if (!LocalizaEnum.isTWLocalize(FlashVarConfig.localize))
                    {
                        this._dockProxy.addStatus(DockDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this.onPlayerSwitchPreActor();
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

        public function getSwitchID() : Vector.<int>
        {
            return this.Vector.<int>([SwitchDef.ID_SHOW_DOCK, SwitchDef.ID_SHOW_DOCK_SHARE, SwitchDef.ID_SHOW_DOCK_LIGHT, SwitchDef.ID_SHOW_TWO_DIMENSION_CODE_BTN, SwitchDef.ID_SHOW_DOCK_DETAILS, SwitchDef.ID_SHOW_DOCK_OFFLINE_WATCH]);
        }// end function

        public function onSwitchStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case SwitchDef.ID_SHOW_DOCK:
                {
                    if (!this.checkShowStatus())
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_DOCK_SHARE:
                {
                    if (param2)
                    {
                        this._dockProxy.addStatus(DockDef.STATUS_SHARE_SHOW);
                    }
                    else
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_SHARE_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_DOCK_LIGHT:
                {
                    if (param2 && !GlobalStage.isFullScreen())
                    {
                        this._dockProxy.addStatus(DockDef.STATUS_LIGHT_SHOW);
                    }
                    else
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_LIGHT_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_DOCK_OFFLINE_WATCH:
                {
                    if (param2)
                    {
                        if (this.checkOfflineWatchShowStatus())
                        {
                            this._dockProxy.addStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
                        }
                    }
                    else
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
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

        private function checkShowStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && !_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc_2.hasStatus(ADDef.STATUS_LOADING) && !_loc_2.hasStatus(ADDef.STATUS_PLAYING) && !_loc_2.hasStatus(ADDef.STATUS_PAUSED) && _loc_1.curActor.movieModel && _loc_1.curActor.movieModel.screenType != ScreenEnum.THREE_D && !_loc_1.curActor.smallWindowMode)
            {
                return true;
            }
            return false;
        }// end function

        private function checkOfflineWatchShowStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK_OFFLINE_WATCH) && _loc_1.curActor.movieModel)
            {
                if (!_loc_1.curActor.movieModel.member)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function checkShareBtnShowStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_DOCK_SHARE))
            {
                return true;
            }
            return false;
        }// end function

        private function onDockViewOpen(event:DockEvent) : void
        {
            if (!this._dockProxy.hasStatus(DockDef.STATUS_OPEN))
            {
                if (!LocalizaEnum.isTWLocalize(FlashVarConfig.localize))
                {
                    this._dockProxy.addStatus(DockDef.STATUS_OPEN);
                }
            }
            return;
        }// end function

        private function onDockViewClose(event:DockEvent) : void
        {
            if (this._dockProxy.hasStatus(DockDef.STATUS_OPEN))
            {
                this._dockProxy.removeStatus(DockDef.STATUS_OPEN);
            }
            return;
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
            this._dockView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            var _loc_4:PlayerProxy = null;
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                {
                    if (param2)
                    {
                        if (this.checkOfflineWatchShowStatus())
                        {
                            this._dockProxy.addStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
                        }
                        else
                        {
                            this._dockProxy.removeStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
                        }
                        if (!this.checkShowStatus())
                        {
                            this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    if (param2)
                    {
                        _loc_4 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                        if (_loc_4.curActor.movieInfo && _loc_4.curActor.movieInfo.allowDownload)
                        {
                            this._dockProxy.addStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE);
                        }
                        else
                        {
                            this._dockProxy.removeStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPPING:
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2 && !this.checkShowStatus())
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
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

        private function onPlayerSwitchPreActor() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                if (this.checkOfflineWatchShowStatus())
                {
                    this._dockProxy.addStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
                }
                else
                {
                    this._dockProxy.removeStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW);
                }
                if (!this.checkShowStatus())
                {
                    this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
                }
            }
            return;
        }// end function

        private function onADStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ADDef.STATUS_LOADING:
                case ADDef.STATUS_PLAYING:
                case ADDef.STATUS_PAUSED:
                {
                    if (param2 && !this.checkShowStatus())
                    {
                        this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
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

        private function onShareBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(ShareProxy.NAME) as ShareProxy;
            if (_loc_2.hasStatus(ShareDef.STATUS_OPEN))
            {
                sendNotification(ShareDef.NOTIFIC_OPEN_CLOSE, false);
            }
            else
            {
                sendNotification(ShareDef.NOTIFIC_OPEN_CLOSE, true);
            }
            return;
        }// end function

        private function onOpenLightBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_3.callJsSetLight(true);
            return;
        }// end function

        private function onCloseLightBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_3.callJsSetLight(false);
            return;
        }// end function

        private function onOfflineWatchBtnClick(event:MouseEvent) : void
        {
            var _loc_3:OfflineWatchProxy = null;
            var _loc_4:String = null;
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT || FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE && _loc_2.checkClientInstall())
            {
                _loc_2.callJsDownload();
            }
            else
            {
                _loc_3 = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
                if (_loc_3.hasStatus(OfflineWatchDef.STATUS_OPEN))
                {
                    sendNotification(OfflineWatchDef.NOTIFIC_OPEN_CLOSE, false);
                }
                else
                {
                    GlobalStage.setNormalScreen();
                    sendNotification(OfflineWatchDef.NOTIFIC_OPEN_CLOSE, true);
                    PingBack.getInstance().userActionPing(PingBackDef.DOWNLOAD_CLIENT);
                    _loc_4 = "";
                    if (Capabilities.version.indexOf("WIN") == 0)
                    {
                        _loc_4 = SystemConfig.CLIENT_DOWNLOAD_URL + "?id=&pubplatform=" + 1 + "&pubarea=pcltdown_dock" + "&srcchannel=&qipuid=&useragent=&u=&pu=" + "&rn=" + Math.random();
                        navigateToURL(new URLRequest(_loc_4), "_blank");
                    }
                    else
                    {
                        _loc_4 = SystemConfig.CLIENT_DOWNLOAD_URL + "?id=&pubplatform=" + 6 + "&pubarea=pcltdown_dock" + "&srcchannel=&qipuid=&useragent=&u=&pu=" + "&rn=" + Math.random();
                        navigateToURL(new URLRequest(_loc_4), "_blank");
                    }
                }
            }
            PingBack.getInstance().userActionPing(PingBackDef.CLICK_DOWNLOAD);
            return;
        }// end function

        private function onMouseMove(event:MouseEvent) : void
        {
            if (this.checkShowStatus())
            {
                this._dockProxy.addStatus(DockDef.STATUS_SHOW);
                TweenLite.killTweensOf(this.delayedHideDock);
                TweenLite.delayedCall(DockDef.DOCK_HIND_DELAY / 1000, this.delayedHideDock);
            }
            return;
        }// end function

        private function delayedHideDock() : void
        {
            this._dockProxy.removeStatus(DockDef.STATUS_SHOW);
            return;
        }// end function

    }
}
