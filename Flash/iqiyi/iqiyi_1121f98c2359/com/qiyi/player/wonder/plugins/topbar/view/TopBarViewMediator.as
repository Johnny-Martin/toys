package com.qiyi.player.wonder.plugins.topbar.view
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import com.qiyi.player.wonder.plugins.topbar.model.*;
    import flash.events.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class TopBarViewMediator extends Mediator
    {
        private var _topBarProxy:TopBarProxy;
        private var _topBarView:TopBarView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.topbar.view.TopBarViewMediator";

        public function TopBarViewMediator(param1:TopBarView)
        {
            super(NAME, param1);
            this._topBarView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._topBarProxy = facade.retrieveProxy(TopBarProxy.NAME) as TopBarProxy;
            this._topBarView.addEventListener(TopBarEvent.Evt_Open, this.onTopBarViewOpen);
            this._topBarView.addEventListener(TopBarEvent.Evt_Close, this.onTopBarViewClose);
            this._topBarView.addEventListener(TopBarEvent.Evt_ScaleClick, this.onScaleClick);
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onStageMouseWheel);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [TopBarDef.NOTIFIC_ADD_STATUS, TopBarDef.NOTIFIC_REMOVE_STATUS, TopBarDef.NOTIFIC_REQUEST_SCALE, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED, SettingDef.NOTIFIC_NORMAL_VIDEO_RATE_CHANGE, ADDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case TopBarDef.NOTIFIC_ADD_STATUS:
                {
                    this._topBarView.onAddStatus(int(_loc_2));
                    break;
                }
                case TopBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._topBarView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case TopBarDef.NOTIFIC_REQUEST_SCALE:
                {
                    if (GlobalStage.isFullScreen() && int(_loc_2) != this._topBarProxy.scaleValue && this.checkCanScaleChange())
                    {
                        this.changeScaleValue(int(_loc_2));
                        this._topBarView.updateScaleBtn(int(_loc_2));
                    }
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._topBarView.onResize(_loc_2.w, _loc_2.h);
                    break;
                }
                case BodyDef.NOTIFIC_FULL_SCREEN:
                {
                    this.onFullScreenChanged(Boolean(_loc_2));
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
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this.onPlayerSwitchPreActor();
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.onPlayerDefinitionSwitched(int(_loc_2));
                    }
                    break;
                }
                case SettingDef.NOTIFIC_NORMAL_VIDEO_RATE_CHANGE:
                {
                    if (this.checkCanScaleChange())
                    {
                        if (int(_loc_2) == SettingDef.VIDEO_PAGE_ASPECT_FILL)
                        {
                            this.changeScaleValue(TopBarDef.SCALE_VALUE_FULL);
                            this._topBarView.updateScaleBtn(TopBarDef.SCALE_VALUE_FULL);
                        }
                        else if (this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_FULL)
                        {
                            this.changeScaleValue(TopBarDef.SCALE_VALUE_100);
                            this._topBarView.updateScaleBtn(TopBarDef.SCALE_VALUE_100);
                        }
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

        private function onTopBarViewOpen(event:TopBarEvent) : void
        {
            if (!this._topBarProxy.hasStatus(TopBarDef.STATUS_OPEN))
            {
                this._topBarProxy.addStatus(TopBarDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onTopBarViewClose(event:TopBarEvent) : void
        {
            if (this._topBarProxy.hasStatus(TopBarDef.STATUS_OPEN))
            {
                this._topBarProxy.removeStatus(TopBarDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onScaleClick(event:TopBarEvent) : void
        {
            this.changeScaleValue(int(event.data));
            return;
        }// end function

        private function changeScaleValue(param1:int) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (this._topBarProxy.scaleValue == param1 && _loc_2.curActor.movieModel && _loc_2.curActor.movieModel.multiAngle)
            {
                return;
            }
            this._topBarProxy.scaleValue = param1;
            if (this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_FULL)
            {
                _loc_2.curActor.setPuman(true);
                _loc_2.curActor.setZoom(TopBarDef.SCALE_VALUE_100);
                _loc_2.preActor.setPuman(true);
                _loc_2.preActor.setZoom(TopBarDef.SCALE_VALUE_100);
            }
            else
            {
                _loc_2.curActor.setPuman(false);
                _loc_2.curActor.setZoom(this._topBarProxy.scaleValue);
                _loc_2.preActor.setPuman(false);
                _loc_2.preActor.setZoom(this._topBarProxy.scaleValue);
            }
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2)
                    {
                        TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    this._topBarView.setTitle(_loc_4.curActor.movieInfo.title);
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                {
                    if (param2)
                    {
                        if (_loc_4.curActor.movieModel && !_loc_4.curActor.movieModel.multiAngle)
                        {
                            this._topBarProxy.addStatus(TopBarDef.STATUS_SCALE_BAR_SHOW);
                        }
                        else
                        {
                            this._topBarProxy.removeStatus(TopBarDef.STATUS_SCALE_BAR_SHOW);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    this._topBarProxy.addStatus(TopBarDef.STATUS_ALLOW_TELL_TIME);
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPPING:
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2)
                    {
                        TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                        if (!this.checkShowStatus())
                        {
                            this._topBarProxy.removeStatus(TopBarDef.STATUS_SHOW);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
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
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                this._topBarView.setTitle(_loc_1.curActor.movieInfo.title);
            }
            if (_loc_1.curActor.movieModel && !_loc_1.curActor.movieModel.multiAngle)
            {
                this._topBarProxy.addStatus(TopBarDef.STATUS_SCALE_BAR_SHOW);
            }
            else
            {
                this._topBarProxy.removeStatus(TopBarDef.STATUS_SCALE_BAR_SHOW);
            }
            TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
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
                    if (param2)
                    {
                        this._topBarProxy.removeStatus(TopBarDef.STATUS_ALLOW_TELL_TIME);
                        if (!this.checkShowStatus())
                        {
                            this._topBarProxy.removeStatus(TopBarDef.STATUS_SHOW);
                        }
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
            this._topBarView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function onFullScreenChanged(param1:Boolean) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (param1)
            {
                this._topBarView.hasTween = true;
                GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
                if (this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_FULL)
                {
                    _loc_2.curActor.setPuman(true);
                    _loc_2.curActor.setZoom(TopBarDef.SCALE_VALUE_100);
                    _loc_2.preActor.setPuman(true);
                    _loc_2.preActor.setZoom(TopBarDef.SCALE_VALUE_100);
                }
                else
                {
                    _loc_2.curActor.setPuman(false);
                    _loc_2.curActor.setZoom(this._topBarProxy.scaleValue);
                    _loc_2.preActor.setPuman(false);
                    _loc_2.preActor.setZoom(this._topBarProxy.scaleValue);
                }
            }
            else
            {
                this._topBarView.hasTween = false;
                GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
                this._topBarProxy.removeStatus(TopBarDef.STATUS_SHOW);
                if (this._topBarProxy.scaleValue != TopBarDef.SCALE_VALUE_FULL)
                {
                    _loc_2.curActor.setPuman(false);
                    _loc_2.curActor.setZoom(TopBarDef.SCALE_VALUE_100);
                    _loc_2.preActor.setPuman(false);
                    _loc_2.preActor.setZoom(TopBarDef.SCALE_VALUE_100);
                }
            }
            this._topBarView.onFullScreenChanged(param1);
            return;
        }// end function

        private function checkShowStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (GlobalStage.isFullScreen() && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && !_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc_2.hasStatus(ADDef.STATUS_LOADING) && !_loc_2.hasStatus(ADDef.STATUS_PLAYING) && !_loc_2.hasStatus(ADDef.STATUS_PAUSED))
            {
                return true;
            }
            return false;
        }// end function

        private function onPlayerDefinitionSwitched(param1:int) : void
        {
            if (!Settings.instance.autoMatchRate)
            {
                TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                TweenLite.delayedCall(param1 / 1000, this.onPlayerDefinitionSwitchComplete);
            }
            return;
        }// end function

        private function onPlayerDefinitionSwitchComplete() : void
        {
            var _loc_2:EnumItem = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.movieModel)
            {
                _loc_2 = _loc_1.curActor.movieModel.curDefinitionInfo.type;
                if (_loc_2 == DefinitionEnum.LIMIT)
                {
                    if (GlobalStage.isFullScreen() && this._topBarProxy.scaleValue != TopBarDef.SCALE_VALUE_75)
                    {
                        if (this.checkCanScaleChange())
                        {
                            this.changeScaleValue(TopBarDef.SCALE_VALUE_75);
                            this._topBarView.updateScaleBtn(TopBarDef.SCALE_VALUE_75);
                        }
                    }
                }
            }
            return;
        }// end function

        private function onMouseMove(event:MouseEvent) : void
        {
            if (this.checkShowStatus())
            {
                this._topBarProxy.addStatus(TopBarDef.STATUS_SHOW);
                TweenLite.killTweensOf(this.delayedHideTopBar);
                TweenLite.delayedCall(TopBarDef.TOP_BAR_HIND_DELAY / 1000, this.delayedHideTopBar);
            }
            return;
        }// end function

        private function delayedHideTopBar() : void
        {
            this._topBarProxy.removeStatus(TopBarDef.STATUS_SHOW);
            return;
        }// end function

        private function onStageMouseWheel(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            if (!GlobalStage.isFullScreen())
            {
                this._topBarProxy.upWardWheelCount = 0;
                this._topBarProxy.downWardWheelCount = 0;
                return;
            }
            var _loc_3:* = this._topBarProxy.scaleValue;
            if (event.delta > 0)
            {
                var _loc_4:* = this._topBarProxy;
                var _loc_5:* = this._topBarProxy.upWardWheelCount + 1;
                _loc_4.upWardWheelCount = _loc_5;
                if (this._topBarProxy.upWardWheelCount == 3)
                {
                    this._topBarProxy.upWardWheelCount = 0;
                    if (this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_FULL)
                    {
                        return;
                    }
                    _loc_3 = this._topBarProxy.scaleValue + 25;
                    if (_loc_3 > TopBarDef.SCALE_VALUE_100)
                    {
                        _loc_3 = TopBarDef.SCALE_VALUE_FULL;
                    }
                    if (this.checkCanScaleChange())
                    {
                        this.changeScaleValue(_loc_3);
                        this._topBarView.updateScaleBtn(this._topBarProxy.scaleValue);
                        PingBack.getInstance().scaleActionPing(this._topBarProxy.scaleValue);
                    }
                }
            }
            else
            {
                var _loc_4:* = this._topBarProxy;
                var _loc_5:* = this._topBarProxy.downWardWheelCount + 1;
                _loc_4.downWardWheelCount = _loc_5;
                if (this._topBarProxy.downWardWheelCount == 3)
                {
                    this._topBarProxy.downWardWheelCount = 0;
                    if (this._topBarProxy.scaleValue == TopBarDef.SCALE_VALUE_50)
                    {
                        return;
                    }
                    _loc_3 = this._topBarProxy.scaleValue - 25;
                    if (_loc_3 < 0)
                    {
                        _loc_3 = TopBarDef.SCALE_VALUE_100;
                    }
                    if (this.checkCanScaleChange())
                    {
                        this.changeScaleValue(_loc_3);
                        this._topBarView.updateScaleBtn(this._topBarProxy.scaleValue);
                        PingBack.getInstance().scaleActionPing(this._topBarProxy.scaleValue);
                    }
                }
            }
            return;
        }// end function

        private function checkCanScaleChange() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.movieModel && _loc_1.curActor.movieModel.multiAngle)
            {
                return false;
            }
            return true;
        }// end function

    }
}
