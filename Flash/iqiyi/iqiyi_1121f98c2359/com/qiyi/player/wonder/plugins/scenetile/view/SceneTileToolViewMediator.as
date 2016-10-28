package com.qiyi.player.wonder.plugins.scenetile.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.lso.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.dock.*;
    import com.qiyi.player.wonder.plugins.dock.model.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import com.qiyi.player.wonder.plugins.videolink.*;
    import com.qiyi.player.wonder.plugins.videolink.model.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class SceneTileToolViewMediator extends Mediator implements ISwitch
    {
        private var _controlProxy:ControllBarProxy;
        private var _sceneTileProxy:SceneTileProxy;
        private var _sceneTileView:SceneTileToolView;
        private var _sceneTileTipShown:Boolean;
        private var _isFirstPlay:Boolean = true;
        private var _isMouseMoving:Boolean = false;
        private var _moveMousePoint:Point;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileToolViewMediator";

        public function SceneTileToolViewMediator(param1:SceneTileToolView)
        {
            this._moveMousePoint = new Point(0, 0);
            super(NAME, param1);
            this._sceneTileView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            SwitchManager.getInstance().register(this);
            this._controlProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            this._sceneTileView.addEventListener(SceneTileEvent.Evt_ToolOpen, this.onSceneTileToolViewOpen);
            this._sceneTileView.addEventListener(SceneTileEvent.Evt_ToolClose, this.onSceneTileToolViewClose);
            this._sceneTileView.playBtn.addEventListener(MouseEvent.CLICK, this.onPlayBtnClick);
            this._sceneTileView.addEventListener(SceneTileEvent.Evt_PanoramicToolClick, this.onPanoramicToolClick);
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onStageMouseMove);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [SceneTileDef.NOTIFIC_ADD_STATUS, SceneTileDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_JS_LIGHT_CHANGED, BodyDef.NOTIFIC_PLAYER_REPLAYED, BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, BodyDef.NOTIFIC_JS_CALL_SET_ZOOM_QIYI_VIDEO, BodyDef.NOTIFIC_LEAVE_STAGE, ControllBarDef.NOTIFIC_ADD_STATUS, ControllBarDef.NOTIFIC_REMOVE_STATUS, ADDef.NOTIFIC_ADD_STATUS, TopBarDef.NOTIFIC_ADD_STATUS, TopBarDef.NOTIFIC_REMOVE_STATUS, ContinuePlayDef.NOTIFIC_ADD_STATUS, ContinuePlayDef.NOTIFIC_REMOVE_STATUS, SettingDef.NOTIFIC_ADD_STATUS, SettingDef.NOTIFIC_REMOVE_STATUS, VideoLinkDef.NOTIFIC_ADD_STATUS, VideoLinkDef.NOTIFIC_REMOVE_STATUS, HintDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            var _loc_5:ControllBarProxy = null;
            var _loc_6:PlayerProxy = null;
            switch(_loc_3)
            {
                case SceneTileDef.NOTIFIC_ADD_STATUS:
                {
                    _loc_6 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (int(_loc_2) == SceneTileDef.STATUS_SCORE_OPEN)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    if (int(_loc_2) == SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW && _loc_6.curActor.movieModel)
                    {
                        this._sceneTileView.updateStarHeadImage(this._sceneTileProxy.barrageProxy.starInteractInfo.getStarInteractByTvid(_loc_6.curActor.movieModel.tvid));
                    }
                    this._sceneTileView.onAddStatus(int(_loc_2));
                    break;
                }
                case SceneTileDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == SceneTileDef.STATUS_SCORE_OPEN && this.checkPlayBtnShowStatus())
                    {
                        this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    this._sceneTileView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._sceneTileView.onResize(_loc_2.w, _loc_2.h);
                    this.updateBorderShowState();
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
                    if (GlobalStage.isFullScreen())
                    {
                        GlobalStage.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onStageMouseWheel);
                    }
                    else
                    {
                        GlobalStage.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onStageMouseWheel);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW);
                    this._isFirstPlay = true;
                    break;
                }
                case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
                {
                    this.onLightChanged(Boolean(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REPLAYED:
                {
                    _loc_6 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (_loc_6.curActor.movieModel && _loc_6.curActor.movieModel.curDefinitionInfo.type == DefinitionEnum.FULL_HD)
                    {
                        this._sceneTileTipShown = true;
                    }
                    else
                    {
                        this._sceneTileTipShown = false;
                    }
                    this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW);
                    this._isFirstPlay = true;
                    break;
                }
                case BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE:
                {
                    this._sceneTileView.requestUnAutoPlayImage();
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
                {
                    if (Boolean(_loc_2))
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_ZOOM_QIYI_VIDEO:
                {
                    if (this.checkIsMultiAngle())
                    {
                        _loc_6 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                        _loc_6.curActor.zoomVideo(Number(_loc_2) / 3);
                        _loc_6.preActor.zoomVideo(Number(_loc_2) / 3);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_LEAVE_STAGE:
                {
                    if (this.checkIsMultiAngle())
                    {
                        this.onMouseUp();
                    }
                    break;
                }
                case ControllBarDef.NOTIFIC_ADD_STATUS:
                {
                    this.onControllBarStatusChanged(int(_loc_2), true);
                    break;
                }
                case ControllBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onControllBarStatusChanged(int(_loc_2), false);
                    break;
                }
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    this.onADStatusChanged(int(_loc_2), true);
                    break;
                }
                case TopBarDef.NOTIFIC_ADD_STATUS:
                {
                    this.onTopBarStatusChanged(int(_loc_2), true);
                    break;
                }
                case TopBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onTopBarStatusChanged(int(_loc_2), false);
                    break;
                }
                case ContinuePlayDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ContinuePlayDef.STATUS_OPEN)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == ContinuePlayDef.STATUS_OPEN && this.checkPlayBtnShowStatus())
                    {
                        this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case VideoLinkDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == VideoLinkDef.STATUS_OPEN)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case VideoLinkDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == VideoLinkDef.STATUS_OPEN && this.checkPlayBtnShowStatus())
                    {
                        this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case SettingDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == SettingDef.STATUS_FILTER_SHOW_BMD)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case SettingDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == SettingDef.STATUS_FILTER_SHOW_BMD && this.checkPlayBtnShowStatus())
                    {
                        this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case HintDef.NOTIFIC_ADD_STATUS:
                {
                    this.onHintStatusChanged(int(_loc_2), true);
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
            return this.Vector.<int>([SwitchDef.ID_SHOW_MAX_MIN_BTN, SwitchDef.ID_SHOW_LOGO]);
        }// end function

        public function onSwitchStatusChanged(param1:int, param2:Boolean) : void
        {
            var _loc_3:PlayerProxy = null;
            switch(param1)
            {
                case SwitchDef.ID_SHOW_MAX_MIN_BTN:
                {
                    break;
                }
                case SwitchDef.ID_SHOW_LOGO:
                {
                    _loc_3 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (param2)
                    {
                        if (this.checkLogoShowStatus())
                        {
                            _loc_3.curActor.floatLayer.showLogo = true;
                            _loc_3.preActor.floatLayer.showLogo = true;
                        }
                    }
                    else
                    {
                        _loc_3.curActor.floatLayer.showLogo = false;
                        _loc_3.preActor.floatLayer.showLogo = false;
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

        private function updateBorderShowState() : void
        {
            var _loc_1:* = facade.retrieveProxy(DockProxy.NAME) as DockProxy;
            var _loc_2:* = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            if (!_loc_1.hasStatus(DockDef.STATUS_LIGHT_ON) && _loc_2.hasStatus(ControllBarDef.STATUS_SHOW) && !GlobalStage.isFullScreen())
            {
                this._sceneTileView.drawBorder();
            }
            else
            {
                this._sceneTileView.clearBorder();
            }
            return;
        }// end function

        private function onSceneTileToolViewOpen(event:SceneTileEvent) : void
        {
            if (!this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_TOOL_OPEN))
            {
                this._sceneTileProxy.addStatus(SceneTileDef.STATUS_TOOL_OPEN);
            }
            return;
        }// end function

        private function onSceneTileToolViewClose(event:SceneTileEvent) : void
        {
            if (this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_TOOL_OPEN))
            {
                this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_TOOL_OPEN);
            }
            return;
        }// end function

        private function onPanoramicToolClick(event:SceneTileEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_2.curActor.tiltVideo(event.data.y);
            _loc_2.curActor.panVideo(event.data.x);
            _loc_2.preActor.tiltVideo(event.data.y);
            _loc_2.preActor.panVideo(event.data.x);
            this._sceneTileView.showVRCode();
            return;
        }// end function

        private function onPlayBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (!FlashVarConfig.autoPlay && !_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE))
            {
                sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
            }
            else
            {
                sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
                sendNotification(ADDef.NOTIFIC_RESUME);
                GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
            }
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2)
                    {
                        this._sceneTileTipShown = false;
                        this._isFirstPlay = true;
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW);
                        this._sceneTileView.destroyImageLoader();
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PAUSED:
                {
                    if (param2)
                    {
                        if (this.checkPlayBtnShowStatus())
                        {
                            this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                        }
                    }
                    else
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    if (param2)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                        if (this._isFirstPlay)
                        {
                            this._isFirstPlay = false;
                            if (this.checkPanoramicToolState())
                            {
                                this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW);
                            }
                            else
                            {
                                this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW);
                            }
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_FAILED:
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW);
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

        private function onLightChanged(param1:Boolean) : void
        {
            this.updateBorderShowState();
            return;
        }// end function

        private function onControllBarStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ControllBarDef.STATUS_SHOW:
                {
                    this.updateBorderShowState();
                    break;
                }
                case ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW:
                {
                    if (param2)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    else if (this.checkPlayBtnShowStatus())
                    {
                        this._sceneTileProxy.addStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
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
                case ADDef.STATUS_PLAYING:
                {
                    if (param2)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case ADDef.STATUS_PLAY_END:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onHintStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case HintDef.STATUS_OPEN:
                {
                    if (param2)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW);
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

        private function onTopBarStatusChanged(param1:int, param2:Boolean) : void
        {
            var _loc_3:PlayerProxy = null;
            switch(param1)
            {
                case TopBarDef.STATUS_SHOW:
                {
                    _loc_3 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (param2)
                    {
                        if (_loc_3.curActor.floatLayer)
                        {
                            _loc_3.curActor.floatLayer.showLogo = false;
                        }
                        if (_loc_3.preActor.floatLayer)
                        {
                            _loc_3.preActor.floatLayer.showLogo = false;
                        }
                    }
                    else if (this.checkLogoShowStatus())
                    {
                        if (_loc_3.curActor.floatLayer)
                        {
                            _loc_3.curActor.floatLayer.showLogo = true;
                        }
                        if (_loc_3.preActor.floatLayer)
                        {
                            _loc_3.preActor.floatLayer.showLogo = true;
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
            this._sceneTileView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function checkPlayBtnShowStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_4:* = facade.retrieveProxy(VideoLinkProxy.NAME) as VideoLinkProxy;
            var _loc_5:* = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            var _loc_6:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) && !_loc_1.hasStatus(ADDef.STATUS_PLAYING) && !_loc_1.hasStatus(ADDef.STATUS_PAUSED) && !_loc_3.hasStatus(ContinuePlayDef.STATUS_OPEN) && !_loc_5.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW) && !_loc_4.hasStatus(VideoLinkDef.STATUS_OPEN) && !this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_OPEN) && !_loc_6.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
            {
                if (FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && FlashVarConfig.os != FlashVarConfig.OS_XP)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function checkLogoShowStatus() : Boolean
        {
            if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_LOGO))
            {
                if (FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && FlashVarConfig.os != FlashVarConfig.OS_XP)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function delayedComplete() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (!_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
            {
                Mouse.hide();
            }
            return;
        }// end function

        private function checkFullHdTipShowEnable() : Boolean
        {
            var _loc_3:SettingProxy = null;
            var _loc_4:Date = null;
            var _loc_5:Date = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            if (!this._sceneTileTipShown && !_loc_2.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW) && !_loc_1.curActor.smallWindowMode)
            {
                _loc_3 = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
                if (!_loc_3.hasStatus(SettingDef.STATUS_DEFINITION_OPEN))
                {
                    _loc_4 = new Date();
                    _loc_5 = LSO.getInstance().sttDate;
                    if (LSO.getInstance().sttShowCountOneDay < 2 || (_loc_4.date != _loc_5.date || _loc_4.month != _loc_5.month || _loc_4.fullYear != _loc_5.fullYear))
                    {
                        if (LSO.getInstance().sttMaxCount < 7)
                        {
                            return true;
                        }
                        return false;
                    }
                }
            }
            return false;
        }// end function

        private function checkPanoramicToolState() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.movieModel && _loc_2.curActor.movieModel.multiAngle && !_loc_1.hasStatus(ADDef.STATUS_PLAYING) && !_loc_1.hasStatus(ADDef.STATUS_PAUSED) && !_loc_1.hasStatus(ADDef.STATUS_LOADING))
            {
                return true;
            }
            return false;
        }// end function

        private function checkIsMultiAngle() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.movieModel && _loc_1.curActor.movieModel.multiAngle)
            {
                return true;
            }
            return false;
        }// end function

        private function onStageMouseMove(event:MouseEvent) : void
        {
            Mouse.show();
            return;
        }// end function

        private function onStageMouseWheel(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_2.curActor.zoomVideo(event.delta / 3);
            _loc_2.preActor.zoomVideo(event.delta / 3);
            return;
        }// end function

        private function onMouseDown(event:MouseEvent) : void
        {
            if (!this._controlProxy.controlbarRect)
            {
                return;
            }
            this._controlProxy.controlbarRect.height = BodyDef.VIDEO_BOTTOM_RESERVE;
            this._controlProxy.controlbarRect.width = GlobalStage.stage.width;
            if (this.checkIsMultiAngle() && !this._controlProxy.controlbarRect.contains(GlobalStage.stage.mouseX, GlobalStage.stage.mouseY))
            {
                this._moveMousePoint.x = GlobalStage.stage.mouseX;
                this._moveMousePoint.y = GlobalStage.stage.mouseY;
                GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
                GlobalStage.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            }
            return;
        }// end function

        private function onMouseMove(event:MouseEvent) : void
        {
            this._isMouseMoving = true;
            return;
        }// end function

        private function onEnterFrame(event:Event) : void
        {
            var _loc_2:PlayerProxy = null;
            if (this._isMouseMoving && this.checkIsMultiAngle())
            {
                _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                _loc_2.curActor.tiltVideo((-(this._moveMousePoint.y - GlobalStage.stage.mouseY)) / 4);
                _loc_2.curActor.panVideo((-(this._moveMousePoint.x - GlobalStage.stage.mouseX)) / 4);
                _loc_2.preActor.tiltVideo((-(this._moveMousePoint.y - GlobalStage.stage.mouseY)) / 4);
                _loc_2.preActor.panVideo((-(this._moveMousePoint.x - GlobalStage.stage.mouseX)) / 4);
                this._moveMousePoint.x = GlobalStage.stage.mouseX;
                this._moveMousePoint.y = GlobalStage.stage.mouseY;
                this._sceneTileView.showVRCode();
            }
            return;
        }// end function

        private function onMouseUp(event:MouseEvent = null) : void
        {
            if (this._isMouseMoving)
            {
                PingBack.getInstance().userActionPing_4_0(PingBackDef.VR_DRAG_COMPLETE);
            }
            this._isMouseMoving = false;
            GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            GlobalStage.stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            return;
        }// end function

    }
}
