package com.qiyi.player.wonder.plugins.controllbar.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.preview.image.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.loading.*;
    import com.qiyi.player.wonder.plugins.loading.model.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import com.qiyi.player.wonder.plugins.tips.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import flash.utils.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class ControllBarViewMediator extends Mediator implements ISwitch
    {
        private var _controllBarProxy:ControllBarProxy;
        private var _controllBarView:ControllBarView;
        private var _frameCount:uint;
        private var _filterTimer:Timer;
        private var _isTimerRunning:Boolean = false;
        private var _bmdNullTimes:int = 0;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.controllbar.view.ControllBarViewMediator";

        public function ControllBarViewMediator(param1:ControllBarView)
        {
            super(NAME, param1);
            this._controllBarView = param1;
            this._filterTimer = new Timer(800);
            this._filterTimer.addEventListener(TimerEvent.TIMER, this.onFilterTimer);
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            SwitchManager.getInstance().register(this);
            this._controllBarProxy = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            this._controllBarView.addEventListener(ControllBarEvent.Evt_Open, this.onControllBarViewOpen);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_Close, this.onControllBarViewClose);
            this._controllBarView.seekBarView.addEventListener(ControllBarEvent.Evt_Seek, this.onControllBarViewSeek);
            this._controllBarView.seekBarView.addEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick, this.onImagePreViewGoodsClick);
            this._controllBarView.seekBarView.addEventListener(ControllBarEvent.Evt_ImagePreviewVedioShow, this.onImagePreviewVedioShow);
            this._controllBarView.volumeControlView.addEventListener(ControllBarEvent.Evt_VolumeChanged, this.onVolumeChanged);
            this._controllBarView.volumeControlView.addEventListener(ControllBarEvent.Evt_VolumeMuteChanged, this.onVolumeMuteChanged);
            this._controllBarView.loadingBtn.addEventListener(MouseEvent.CLICK, this.onLoadingBtnClick);
            this._controllBarView.playBtn.addEventListener(MouseEvent.CLICK, this.onPlayBtnClick);
            this._controllBarView.pauseBtn.addEventListener(MouseEvent.CLICK, this.onPauseBtnClick);
            this._controllBarView.replayBtn.addEventListener(MouseEvent.CLICK, this.onReplayBtnClick);
            this._controllBarView.unFoldBtn.addEventListener(MouseEvent.CLICK, this.onUnFoldBtnClick);
            this._controllBarView.foldBtn.addEventListener(MouseEvent.CLICK, this.onFoldBtnClick);
            this._controllBarView.barrageBtn.addEventListener(MouseEvent.CLICK, this.onBarrageBtnClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_D3BtnClick, this.onD3BtnClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_FilterOpenClick, this.onFilterBtnClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_FilterCloseClick, this.onFilterSeletedBtnClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_CaptionOrTrackBtnClick, this.onCaptionOrTrackClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_RepeatBtnClicked, this.onRepeatBtnClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_NextVideoBtnClicked, this.onNextVideoBtnClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_TvListBtnClicked, this.onTvListBtnClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_DefinitionBtnClicked, this.onDefinitionBtnClick);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_DefinitionBtnLocationChange, this.onDefinitionBtnLocationChange);
            this._controllBarView.addEventListener(ControllBarEvent.Evt_ControlBarLocationChange, this.controllbarChange);
            this._controllBarView.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onStageMouseMove);
            GlobalStage.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            GlobalStage.stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            this.onStageMouseMove();
            this._controllBarProxy.isFullScreen = GlobalStage.isFullScreen();
            var _loc_1:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            this._controllBarView.repeatSubBtnVisible = _loc_1.isCyclePlay;
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [ControllBarDef.NOTIFIC_ADD_STATUS, ControllBarDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS, BodyDef.NOTIFIC_PLAYER_REPLAYED, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_JS_LIGHT_CHANGED, BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO, BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE, BodyDef.NOTIFIC_JS_EXPAND_CHANGED, BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED, BodyDef.NOTIFIC_JS_CALL_SEEK, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS, BodyDef.NOTIFIC_PLAYER_OUT_SKIP_POINT, BodyDef.NOTIFIC_PLAYER_ENTER_SKIP_POINT, BodyDef.NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT, BodyDef.NOTIFIC_PLAYER_ENJOY_TYPE_INITED, BodyDef.NOTIFIC_LEAVE_STAGE, BodyDef.NOTIFIC_MOUSE_LAYER_CLICK, BodyDef.NOTIFIC_PLAYER_RUNNING, ContinuePlayDef.NOTIFIC_ADD_STATUS, ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED, ContinuePlayDef.NOTIFIC_CYCLE_PLAY_CHANGED, ADDef.NOTIFIC_ADD_STATUS, ADDef.NOTIFIC_REMOVE_STATUS, ADDef.NOTIFIC_AD_RECEIVE_VIEW_POINTS, LoadingDef.NOTIFIC_ADD_STATUS, LoadingDef.NOTIFIC_REMOVE_STATUS, HintDef.NOTIFIC_ADD_STATUS, HintDef.NOTIFIC_REMOVE_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_7:ADProxy = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            var _loc_5:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_6:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            switch(_loc_3)
            {
                case ControllBarDef.NOTIFIC_ADD_STATUS:
                {
                    this._controllBarView.onAddStatus(int(_loc_2));
                    break;
                }
                case ControllBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._controllBarView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ENJOY_TYPE_INITED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR && this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE) && this.checkFilterBtnState())
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
                        if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))
                        {
                            this._controllBarView.updateFilterBtnType(true);
                            this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
                        }
                        this._controllBarView.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REPLAYED:
                {
                    this.onUpdateContinuePlayBtns();
                    this._filterTimer.stop();
                    this._isTimerRunning = false;
                    sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, false);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ENTER_SKIP_POINT:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this._controllBarProxy.filterBitmapData.loaderImage(false);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_OUT_SKIP_POINT:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR && this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))
                    {
                        if (!this.checkInEnjoyableSkipType(_loc_5.curActor.currentTime))
                        {
                            this._controllBarProxy.filterBitmapData.loaderImage(true, _loc_5.curActor.currentTime, _loc_5.curActor.movieModel.duration);
                            this.onFilterTimerStart(_loc_5.curActor.currentTime);
                        }
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ENTER_LEAVE_SKIP_POINT:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR && this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))
                    {
                        this._controllBarProxy.filterBitmapData.loaderImage(true, _loc_5.curActor.currentTime, _loc_5.curActor.movieModel.duration);
                        sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_FILTER_NEST_ENJOYABLE_TIP);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._controllBarView.onResize(_loc_2.w, _loc_2.h);
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
                    this.onFullScreenSwitch(Boolean(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this.onPlayerSwitchPreActor();
                    break;
                }
                case BodyDef.NOTIFIC_JS_LIGHT_CHANGED:
                {
                    this._controllBarProxy.playerLightOn = Boolean(_loc_2);
                    if (this._controllBarProxy.playerLightOn && !this._controllBarProxy.hasStatus(ControllBarDef.STATUS_SHOW) && SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR))
                    {
                        if (_loc_5.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
                        {
                            Mouse.show();
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
                        }
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_NEXT_VIDEO_INFO:
                {
                    if (Boolean(_loc_2.continuePlay) && this.checkNextBtnShow())
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_CONTINUE_PLAY_STATE:
                {
                    if (Boolean(_loc_2) && this.checkNextBtnShow())
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_LEAVE_STAGE:
                {
                    TweenLite.killTweensOf(this.hideSeekBar);
                    this.hideSeekBar();
                    break;
                }
                case BodyDef.NOTIFIC_MOUSE_LAYER_CLICK:
                {
                    if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc_6.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
                    {
                        if (this._isTimerRunning)
                        {
                            this._filterTimer.stop();
                            this._isTimerRunning = false;
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
                        }
                        else
                        {
                            this._filterTimer.start();
                            this._isTimerRunning = true;
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                        }
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ContinuePlayDef.STATUS_OPEN)
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW);
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED:
                {
                    if (this.checkNextBtnShow())
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    }
                    if (this.checkTvListBtnShow())
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                        if (this.isTvListChannels())
                        {
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                        }
                        else
                        {
                            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                        }
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_CYCLE_PLAY_CHANGED:
                {
                    this._controllBarView.repeatSubBtnVisible = Boolean(_loc_2);
                    break;
                }
                case BodyDef.NOTIFIC_JS_EXPAND_CHANGED:
                {
                    if (Boolean(_loc_2))
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SEEK:
                {
                    this.onPlayerSeeking(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
                {
                    if (_loc_2)
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_OPEN);
                    }
                    else
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    if (!_loc_5.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) && this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && !this._isTimerRunning)
                    {
                        if (!this.checkInEnjoyableSkipType(_loc_2.currentTime))
                        {
                            this._controllBarProxy.filterBitmapData.loaderImage(true, _loc_2.currentTime, _loc_5.curActor.movieModel.duration);
                            this.onFilterTimerStart(_loc_2.currentTime);
                        }
                    }
                    break;
                }
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    this.onADPlayerStatusChanged(int(_loc_2), true);
                    break;
                }
                case ADDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onADPlayerStatusChanged(int(_loc_2), false);
                    break;
                }
                case ADDef.NOTIFIC_AD_RECEIVE_VIEW_POINTS:
                {
                    _loc_7 = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
                    if (_loc_5.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
                    {
                        this._controllBarView.seekBarView.setMerchandiseViewPoints(_loc_7.viewPoints);
                    }
                    break;
                }
                case LoadingDef.NOTIFIC_ADD_STATUS:
                {
                    this.onLoadingStatusChanged(int(_loc_2), true);
                    break;
                }
                case LoadingDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onLoadingStatusChanged(int(_loc_2), false);
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
                case BodyDef.NOTIFIC_JS_CALL_SET_BARRAGE_STATUS:
                {
                    if (_loc_2.isOpen)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_BARRAGE_BTN_OPEN);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_BARRAGE_BTN_OPEN);
                    }
                    break;
                }
                case HintDef.NOTIFIC_ADD_STATUS:
                {
                    this.onHintStatusChanged(int(_loc_2), true);
                    break;
                }
                case HintDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onHintStatusChanged(int(_loc_2), false);
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
            return this.Vector.<int>([SwitchDef.ID_SHOW_CONTROL_BAR, SwitchDef.ID_SHOW_CONTROL_BAR_SEEK_BAR, SwitchDef.ID_SHOW_CONTROL_BAR_LOOP_PLAY_BTN, SwitchDef.ID_SHOW_CONTROL_BAR_NEXT_BTN, SwitchDef.ID_SHOW_CONTROL_BAR_TIME, SwitchDef.ID_SHOW_CONTROL_BAR_VOLUME, SwitchDef.ID_SHOW_CONTROL_BAR_FULLSCREEN, SwitchDef.ID_SHOW_CONTROL_BAR_SETTING, SwitchDef.ID_SHOW_CONTROL_BAR_CAPTURE, SwitchDef.ID_SHOW_CONTROL_BAR_CAPTION, SwitchDef.ID_SHOW_CONTROL_BAR_TRACK, SwitchDef.ID_SHOW_CONTROL_BAR_EXPAND_BTN, SwitchDef.ID_SHOW_CONTROL_BAR_TVLIST_BTN, SwitchDef.ID_SHOW_CONTROL_BAR_3D_BTN, SwitchDef.ID_SHOW_CONTROL_BAR_SKIP_TIP, SwitchDef.ID_SHOW_CONTROL_BAR_VIEW_TIP, SwitchDef.ID_SHOW_CONTROL_BAR_PREVIEW, SwitchDef.ID_SHOW_CONTROL_BAR_FF]);
        }// end function

        public function onSwitchStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case SwitchDef.ID_SHOW_CONTROL_BAR:
                {
                    if (param2)
                    {
                        Mouse.show();
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
                    }
                    else
                    {
                        if (GlobalStage.isFullScreen())
                        {
                            Mouse.hide();
                        }
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_SEEK_BAR:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_LOOP_PLAY_BTN:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_NEXT_BTN:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_TIME:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_TIME_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TIME_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_VOLUME:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_FULLSCREEN:
                {
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_SETTING:
                case SwitchDef.ID_SHOW_CONTROL_BAR_CAPTURE:
                case SwitchDef.ID_SHOW_CONTROL_BAR_CAPTION:
                case SwitchDef.ID_SHOW_CONTROL_BAR_TRACK:
                case SwitchDef.ID_SHOW_CONTROL_BAR_EXPAND_BTN:
                {
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_TVLIST_BTN:
                {
                    if (param2 && this.checkTvListBtnShow())
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                    }
                    else
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                    }
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_3D_BTN:
                {
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_SKIP_TIP:
                {
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_VIEW_TIP:
                {
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_PREVIEW:
                {
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_FF:
                {
                    break;
                }
                case SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE:
                {
                    if (param2)
                    {
                        if (GlobalStage.isFullScreen())
                        {
                            Mouse.hide();
                        }
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SHOW);
                    }
                    else
                    {
                        Mouse.show();
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
                    }
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onControllBarViewOpen(event:ControllBarEvent) : void
        {
            if (!this._controllBarProxy.hasStatus(ControllBarDef.STATUS_OPEN))
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onControllBarViewClose(event:ControllBarEvent) : void
        {
            if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_OPEN))
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onControllBarViewSeek(event:ControllBarEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            this.onPlayerSeeking(int(event.data.time));
            (this._controllBarProxy.seekCount + 1);
            if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && int(event.data.type) != 1)
            {
                if (!this.checkInEnjoyableSkipType(int(event.data.time)))
                {
                    PingBack.getInstance().userActionPing_4_0(PingBackDef.FILTER_SEEK_NOT_ENJOYABLE_SEGMENT);
                }
                else
                {
                    PingBack.getInstance().userActionPing_4_0(PingBackDef.FILTER_SEEK_ENJOYABLE_SEGMENT);
                }
            }
            if (_loc_2.curActor.movieModel && _loc_2.curActor.movieInfo)
            {
                _loc_2.curActor.uploadHistory();
            }
            return;
        }// end function

        private function onImagePreViewGoodsClick(event:ControllBarEvent) : void
        {
            GlobalStage.setNormalScreen();
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_2.callJsFindGoods(int(Number(event.data) / 1000));
            return;
        }// end function

        private function onImagePreviewVedioShow(event:ControllBarEvent) : void
        {
            if (event.data)
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW);
            }
            else
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW);
                TweenLite.killTweensOf(this.hideSeekBar);
                TweenLite.delayedCall(ControllBarDef.SEEKBAR_THIN_DELAY / 1000, this.hideSeekBar);
            }
            return;
        }// end function

        private function onPlayerSeeking(param1:int, param2:int = 0) : void
        {
            var _loc_3:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (_loc_3.hasStatus(ADDef.STATUS_PLAYING) || _loc_3.hasStatus(ADDef.STATUS_PAUSED) || _loc_3.hasStatus(ADDef.STATUS_LOADING))
            {
                return;
            }
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))
            {
                if (!this.checkInEnjoyableSkipType(param1))
                {
                    this._controllBarProxy.filterBitmapData.loaderImage(true, param1, _loc_4.curActor.movieModel.duration);
                    this.onFilterTimerStart(param1);
                    return;
                }
                this._filterTimer.stop();
                this._isTimerRunning = false;
                sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, false);
            }
            if (_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) || _loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || _loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING) || _loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING))
            {
                if (param1 < 0)
                {
                    param1 = 0;
                }
                else if (param1 > _loc_4.curActor.movieModel.duration)
                {
                    param1 = _loc_4.curActor.movieModel.duration;
                }
                PingBack.getInstance().dragActionPing(_loc_4.curActor.currentTime, param1, uint(this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN)));
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
                if (_loc_4.curActor.movieModel.duration - param1 < 2000)
                {
                    param1 = _loc_4.curActor.movieModel.duration - 2000;
                }
                sendNotification(BodyDef.NOTIFIC_PLAYER_SEEK, {time:param1, type:param2});
                if (_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
                    sendNotification(ADDef.NOTIFIC_RESUME);
                    GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
                }
                if (this._controllBarView.seekBarView.seekClickCount == 3)
                {
                    sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_HOT_KEY_FF);
                }
            }
            return;
        }// end function

        private function onVolumeChanged(event:ControllBarEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            Settings.instance.volumn = int(event.data.volume);
            var _loc_3:* = Settings.instance.volumn <= 0;
            Settings.instance.mute = Settings.instance.volumn <= 0;
            _loc_2.mute = _loc_3;
            sendNotification(ADDef.NOTIFIC_AD_VOLUMN_CHANGED);
            if (Boolean(event.data.tip))
            {
                this.addVolumeTip();
            }
            return;
        }// end function

        private function onVolumeMuteChanged(event:ControllBarEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (_loc_2.hasStatus(ADDef.STATUS_PLAYING) || _loc_2.hasStatus(ADDef.STATUS_PAUSED))
            {
                _loc_2.mute = Boolean(event.data);
                if (!_loc_2.mute)
                {
                    Settings.instance.mute = _loc_2.mute;
                    Settings.instance.volumn = this._controllBarView.volumeControlView.currentVolume == 0 ? (60) : (this._controllBarView.volumeControlView.currentVolume);
                }
            }
            else
            {
                var _loc_3:* = Boolean(event.data);
                Settings.instance.mute = Boolean(event.data);
                _loc_2.mute = _loc_3;
                if (!Settings.instance.mute)
                {
                    Settings.instance.volumn = this._controllBarView.volumeControlView.currentVolume == 0 ? (60) : (this._controllBarView.volumeControlView.currentVolume);
                }
                else
                {
                    Settings.instance.volumn = 0;
                }
            }
            sendNotification(ADDef.NOTIFIC_AD_VOLUMN_CHANGED);
            this.addVolumeTip();
            return;
        }// end function

        private function onPlayerSwitchPreActor() : void
        {
            this.onPlayerSwitchStoppedFailedLoaded();
            TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_3:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                PreviewImageLoader.instance.clearImageData();
                this._controllBarView.seekBarView.setTotalTime(_loc_1.curActor.movieModel.duration);
                this._controllBarView.seekBarView.setImagePrePicUrlArr(this.getImageUrlList());
                this._controllBarView.seekBarView.setCurrentTime(0);
                this._controllBarView.seekBarView.setHeadTailPoint(_loc_1.curActor.movieModel.titlesTime, _loc_1.curActor.movieModel.trailerTime);
                this._isTimerRunning = false;
                sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, false);
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_OPEN);
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
                this._controllBarView.seekBarView.setSkipPoints(null);
                this._controllBarProxy.filterBitmapData.destroy();
                this._filterTimer.stop();
                this._controllBarView.currentDefinitionInfo = _loc_1.curActor.movieModel.curDefinitionInfo.type;
                this.onUpdateContinuePlayBtns();
                if (!Settings.instance.mute)
                {
                    this._controllBarView.volumeControlView.updateVolumeControlView(Settings.instance.volumn, false, false);
                }
                this.showExpandBtn();
            }
            this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
            this._controllBarProxy.seekCount = 0;
            this._controllBarProxy.isFirstPlay = true;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                this._controllBarView.seekBarView.setViewPoints(_loc_1.curActor.movieInfo.focusTips);
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
            this._controllBarView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function onPlayBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            var _loc_3:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (!_loc_2.hasStatus(ADDef.STATUS_PLAYING) && !_loc_2.hasStatus(ADDef.STATUS_PAUSED))
            {
                if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc_3.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
                {
                    this._filterTimer.start();
                    this._isTimerRunning = true;
                    this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                }
                else
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_RESUME);
                    GlobalStage.stage.dispatchEvent(new Event("tmp_dis_resume_to_p2p"));
                }
            }
            sendNotification(ADDef.NOTIFIC_RESUME);
            sendNotification(HintDef.NOTIFIC_HINT_RESUME);
            return;
        }// end function

        private function onPauseBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            var _loc_3:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (!_loc_2.hasStatus(ADDef.STATUS_PLAYING) && !_loc_2.hasStatus(ADDef.STATUS_PAUSED))
            {
                if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc_3.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
                {
                    this._filterTimer.stop();
                    this._isTimerRunning = false;
                    this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
                }
                else
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE, PauseTypeEnum.USER);
                    GlobalStage.stage.dispatchEvent(new Event("tmp_dis_pause_to_p2p"));
                }
            }
            sendNotification(ADDef.NOTIFIC_PAUSE);
            sendNotification(HintDef.NOTIFIC_HINT_PAUSE);
            return;
        }// end function

        private function onLoadingBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc_3.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
            {
                this._filterTimer.stop();
                this._isTimerRunning = false;
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
                return;
            }
            if (!_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED) && _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY))
            {
                if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING) || _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING))
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE, PauseTypeEnum.USER);
                    sendNotification(ADDef.NOTIFIC_PAUSE);
                    sendNotification(HintDef.NOTIFIC_HINT_PAUSE);
                    GlobalStage.stage.dispatchEvent(new Event("tmp_dis_pause_to_p2p"));
                }
            }
            return;
        }// end function

        private function onReplayBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (!_loc_2.hasStatus(ADDef.STATUS_PLAYING) && !_loc_2.hasStatus(ADDef.STATUS_PAUSED) && !_loc_2.hasStatus(ADDef.STATUS_LOADING))
            {
                sendNotification(ADDef.NOTIFIC_REQUEST_REPLAY_VIDEO);
                PingBack.getInstance().userActionPing(PingBackDef.REPLAY);
            }
            return;
        }// end function

        private function onUnFoldBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_2.callJsExpand(true);
            PingBack.getInstance().userActionPing(PingBackDef.EXPAND_SCREEN);
            return;
        }// end function

        private function onFoldBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_2.callJsExpand(false);
            PingBack.getInstance().userActionPing(PingBackDef.UN_EXPAND_SCREEN);
            return;
        }// end function

        private function onBarrageBtnClick(event:MouseEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BARRAGE_BTN_OPEN))
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_BARRAGE_BTN_OPEN);
                _loc_2.callJsBarrageStateChange(false);
            }
            else
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_BARRAGE_BTN_OPEN);
                _loc_2.callJsBarrageStateChange(true);
            }
            return;
        }// end function

        private function onRepeatBtnClick(event:ControllBarEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            _loc_2.isCyclePlay = Boolean(event.data);
            if (_loc_2.isCyclePlay)
            {
                sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_LOOP_ON);
                PingBack.getInstance().cyclePlayPing(PingBackDef.USER_ACTION, PingBackDef.USER_ACTION);
            }
            else
            {
                sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_LOOP_OFF);
            }
            return;
        }// end function

        private function onNextVideoBtnClick(event:ControllBarEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_2.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
            sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
            PingBack.getInstance().nextPing();
            return;
        }// end function

        private function onTvListBtnClick(event:ControllBarEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            if (_loc_2.hasStatus(ContinuePlayDef.STATUS_OPEN))
            {
                sendNotification(ContinuePlayDef.NOTIFIC_OPEN_CLOSE, false);
            }
            else
            {
                sendNotification(ContinuePlayDef.NOTIFIC_OPEN_CLOSE, true);
                PingBack.getInstance().userActionPing(PingBackDef.SHOW_TVLIST);
            }
            return;
        }// end function

        private function onD3BtnClick(event:ControllBarEvent) : void
        {
            var _loc_3:LoadMovieParams = null;
            var _loc_4:ScreenInfo = null;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (Boolean(event.data))
            {
                _loc_4 = _loc_2.curActor.get3DScreenInfo();
                if (_loc_4)
                {
                    _loc_3 = _loc_2.curActor.loadMovieParams.clone();
                    _loc_3.tvid = _loc_4.tvid;
                    _loc_3.vid = _loc_4.vid;
                    sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE, ContinuePlayDef.SWITCH_VIDEO_TYPE_2D_3D_BTN);
                    sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE, _loc_3, BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_3D);
                }
            }
            else
            {
                _loc_4 = _loc_2.curActor.get2DScreenInfo();
                if (_loc_4)
                {
                    _loc_3 = _loc_2.curActor.loadMovieParams.clone();
                    _loc_3.tvid = _loc_4.tvid;
                    _loc_3.vid = _loc_4.vid;
                    sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_CHANGE_SWITCH_VIDEO_TYPE, ContinuePlayDef.SWITCH_VIDEO_TYPE_2D_3D_BTN);
                    sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE, _loc_3, BodyDef.LOAD_MOVIE_TYPE_SWITCH_TO_2D);
                }
            }
            return;
        }// end function

        private function onDefinitionBtnClick(event:ControllBarEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc_2.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
            {
                return;
            }
            if (_loc_2.hasStatus(SettingDef.STATUS_DEFINITION_OPEN))
            {
                sendNotification(SettingDef.NOTIFIC_DEFINITION_OPEN_CLOSE, false);
            }
            else
            {
                sendNotification(SettingDef.NOTIFIC_DEFINITION_OPEN_CLOSE, true);
            }
            return;
        }// end function

        private function onDefinitionBtnLocationChange(event:ControllBarEvent) : void
        {
            this._controllBarProxy.definitionBtnX = event.data.x;
            this._controllBarProxy.definitionBtnY = event.data.y;
            sendNotification(ControllBarDef.NOTIFIC_DEF_BTN_POS_CHANGE);
            return;
        }// end function

        private function controllbarChange(event:ControllBarEvent) : void
        {
            this._controllBarProxy.controlbarRect = event.data as Rectangle;
            return;
        }// end function

        private function onFilterBtnClick(event:ControllBarEvent = null) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:Boolean = true;
            _loc_2.curActor.openSelectPlay = true;
            _loc_2.preActor.openSelectPlay = _loc_3;
            this._controllBarProxy.addStatus(ControllBarDef.STATUS_FILTER_OPEN);
            this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
            sendNotification(SettingDef.NOTIFIC_FILTER_OPEN_CLOSE, true);
            PingBack.getInstance().filterPing(PingBackDef.FILTER_OPEN);
            this._controllBarProxy.filterBitmapData.setFilterAnalysisData(_loc_2.curActor.movieModel.getSkipPointAnalysisData());
            if (!this.checkInEnjoyableSkipType(_loc_2.curActor.currentTime))
            {
                this._controllBarProxy.filterBitmapData.loaderImage(true, _loc_2.curActor.currentTime, _loc_2.curActor.movieModel.duration);
                this.onFilterTimerStart(_loc_2.curActor.currentTime);
            }
            else
            {
                this.onPlayerSeeking(_loc_2.curActor.currentTime);
            }
            return;
        }// end function

        private function onFilterSeletedBtnClick(event:ControllBarEvent = null) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            var _loc_4:* = _loc_3.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD) ? (this._controllBarProxy.filterBitmapData.interval * this._controllBarProxy.filterBitmapData.showBmdIndex * 1000) : (_loc_2.curActor.currentTime);
            var _loc_5:Boolean = false;
            _loc_2.curActor.openSelectPlay = false;
            _loc_2.preActor.openSelectPlay = _loc_5;
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_OPEN);
            this._controllBarView.seekBarView.setSkipPoints(null);
            sendNotification(SettingDef.NOTIFIC_FILTER_OPEN_CLOSE, false);
            sendNotification(TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.TIP_ID_FILTER_CLOSE_TIP);
            PingBack.getInstance().filterPing(PingBackDef.FILTER_CLOSE);
            this._controllBarProxy.filterBitmapData.loaderImage(false);
            this._filterTimer.stop();
            this._isTimerRunning = false;
            this.onPlayerSeeking(_loc_4);
            return;
        }// end function

        private function onCaptionOrTrackClick(event:ControllBarEvent) : void
        {
            sendNotification(SettingDef.NOTIFIC_OPEN_CLOSE);
            return;
        }// end function

        private function onEnterFrame(event:Event) : void
        {
            var _loc_2:PlayerProxy = null;
            var _loc_3:SettingProxy = null;
            var _loc_4:String = this;
            var _loc_5:* = this._frameCount + 1;
            _loc_4._frameCount = _loc_5;
            if (this._frameCount % 2 == 0)
            {
                this._frameCount = 0;
                _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                _loc_3 = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
                if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING) || _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING) || _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
                {
                    if (this._isTimerRunning || _loc_3.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
                    {
                        this._controllBarView.onPlayerRunning(this._controllBarProxy.filterBitmapData.interval * this._controllBarProxy.filterBitmapData.showBmdIndex * 1000, _loc_2.curActor.bufferTime, _loc_2.curActor.movieModel.duration, this._controllBarProxy.keyDownSeeking);
                    }
                    else
                    {
                        this._controllBarView.onPlayerRunning(_loc_2.curActor.currentTime, _loc_2.curActor.bufferTime, _loc_2.curActor.movieModel.duration, this._controllBarProxy.keyDownSeeking);
                    }
                }
            }
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            var _loc_8:ContinuePlayProxy = null;
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_5:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_6:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            var _loc_7:LoadingProxy = null;
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    this._isTimerRunning = false;
                    sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, false);
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_OPEN);
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
                    this._controllBarView.seekBarView.setSkipPoints(null);
                    this._controllBarProxy.filterBitmapData.destroy();
                    this._filterTimer.stop();
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                {
                    if (param2)
                    {
                        PreviewImageLoader.instance.clearImageData();
                        this._controllBarView.seekBarView.setTotalTime(_loc_4.curActor.movieModel.duration);
                        this._controllBarView.seekBarView.setImagePrePicUrlArr(this.getImageUrlList());
                        this._controllBarView.seekBarView.setCurrentTime(0);
                        this._controllBarView.seekBarView.setHeadTailPoint(_loc_4.curActor.movieModel.titlesTime, _loc_4.curActor.movieModel.trailerTime);
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_OPEN);
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
                        this._controllBarView.seekBarView.setSkipPoints(null);
                        TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                        this._controllBarView.currentDefinitionInfo = _loc_4.curActor.movieModel.curDefinitionInfo.type;
                        this.onUpdateContinuePlayBtns();
                        this.showExpandBtn();
                        this._controllBarProxy.seekCount = 0;
                        this._controllBarProxy.isFirstPlay = true;
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    if (param2)
                    {
                        this._controllBarView.seekBarView.setViewPoints(_loc_4.curActor.movieInfo.focusTips);
                        if (!Settings.instance.mute)
                        {
                            this._controllBarView.volumeControlView.updateVolumeControlView(Settings.instance.volumn, false, false);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                        if (!this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE))
                        {
                            if (!Settings.instance.mute)
                            {
                                this._controllBarView.volumeControlView.updateVolumeControlView(Settings.instance.volumn, false, false);
                            }
                        }
                        this.initBtns();
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PAUSED:
                {
                    if (param2)
                    {
                        if (this.checkPauseBtnStatus())
                        {
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
                        }
                    }
                    else if (_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING) || _loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING))
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_WAITING:
                case BodyDef.PLAYER_STATUS_SEEKING:
                {
                    if (param2 && !_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
                        _loc_7 = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
                        if (!_loc_7.hasStatus(LoadingDef.STATUS_OPEN))
                        {
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPPING:
                {
                    if (param2)
                    {
                        this.onPlayerSwitchStoppedFailedLoaded();
                        this._controllBarView.adjustDisplayTimeOnStoped();
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2)
                    {
                        this.onPlayerSwitchStoppedFailedLoaded();
                        if (!_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_PAUSED))
                        {
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
                            _loc_7 = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
                            if (!_loc_7.hasStatus(LoadingDef.STATUS_OPEN))
                            {
                                this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
                            }
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        this.onPlayerSwitchStoppedFailedLoaded();
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2 && this.checkShowStatus())
                    {
                        _loc_8 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
                        if (!_loc_8.isContinue)
                        {
                            Mouse.show();
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
                        }
                        else if (_loc_8.isContinue && !_loc_8.findNextContinueInfo(_loc_4.curActor.loadMovieParams.tvid, _loc_4.curActor.loadMovieParams.vid))
                        {
                            Mouse.show();
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_PLAY:
                {
                    if (param2)
                    {
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

        private function onPlayerSwitchStoppedFailedLoaded() : void
        {
            if (this._controllBarView.seekBarView.videoHeadTailTipPanel.parent)
            {
                GlobalStage.stage.removeChild(this._controllBarView.seekBarView.videoHeadTailTipPanel);
            }
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
            this.deinitBtns();
            return;
        }// end function

        private function onADPlayerStatusChanged(param1:int, param2:Boolean) : void
        {
            var _loc_4:PlayerProxy = null;
            var _loc_3:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            switch(param1)
            {
                case ADDef.STATUS_PLAYING:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                        if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE))
                        {
                            this.deinitBtns();
                        }
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TIME_SHOW);
                        this.onUpdateContinuePlayBtns();
                    }
                    break;
                }
                case ADDef.STATUS_PAUSED:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
                    }
                    break;
                }
                case ADDef.STATUS_PLAY_END:
                {
                    _loc_4 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_TIME_SHOW);
                    }
                    _loc_3.mute = Settings.instance.mute;
                    this._controllBarView.volumeControlView.updateVolumeControlView(Settings.instance.mute ? (0) : (Settings.instance.volumn), false, false);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onLoadingStatusChanged(param1:int, param2:Boolean) : void
        {
            var _loc_3:PlayerProxy = null;
            switch(param1)
            {
                case LoadingDef.STATUS_OPEN:
                {
                    if (param2)
                    {
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
                    }
                    else
                    {
                        _loc_3 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                        if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW) && !_loc_3.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
                        {
                            this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
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

        private function onHintStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case HintDef.STATUS_OPEN:
                {
                    if (param2)
                    {
                        if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE))
                        {
                            this.deinitBtns();
                        }
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TIME_SHOW);
                    }
                    break;
                }
                case HintDef.STATUS_PLAYING:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                    }
                    break;
                }
                case HintDef.STATUS_PAUSED:
                {
                    if (param2)
                    {
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
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

        private function onPlayerDefinitionSwitched(param1:int) : void
        {
            if (param1 >= 0)
            {
                TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                TweenLite.delayedCall(param1 / 1000, this.onPlayerDefinitionSwitchComplete);
            }
            return;
        }// end function

        private function onPlayerDefinitionSwitchComplete() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.movieModel && _loc_1.curActor.movieModel.curDefinitionInfo)
            {
                if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_DEFINITION_SHOW))
                {
                    this._controllBarView.updateDefinitionBtn(_loc_1.curActor.movieModel.curDefinitionInfo.type);
                }
                else
                {
                    this._controllBarView.currentDefinitionInfo = _loc_1.curActor.movieModel.curDefinitionInfo.type;
                }
            }
            return;
        }// end function

        private function checkPreviewTipEnable() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = _loc_1.curActor.movieModel;
            if (_loc_2 && !_loc_2.member && FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE)
            {
                return true;
            }
            return false;
        }// end function

        private function initBtns() : void
        {
            if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE))
            {
                return;
            }
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            var _loc_3:* = SwitchManager.getInstance();
            if (_loc_3.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_SEEK_BAR))
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW);
            }
            if (_loc_3.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_LOOP_PLAY_BTN))
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW);
            }
            if (this.checkTvListBtnShow())
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                if (this.isTvListChannels())
                {
                    this._controllBarProxy.addStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                }
                else
                {
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                }
            }
            if (_loc_3.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_3D_BTN))
            {
                if (_loc_1.curActor.get3DScreenInfo() || _loc_1.curActor.get2DScreenInfo())
                {
                    this._controllBarProxy.addStatus(ControllBarDef.STATUS_3D_BTN_SHOW);
                    this._controllBarView.updateD3BtnVisible(_loc_1.curActor.movieModel.screenType == ScreenEnum.THREE_D);
                }
                else
                {
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_3D_BTN_SHOW);
                }
            }
            if (_loc_3.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_TIME))
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_TIME_SHOW);
            }
            if (this.checkFilterBtnState())
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
                if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))
                {
                    this._controllBarView.updateFilterBtnType(true);
                    this._controllBarView.seekBarView.setSkipPoints(this.getAllEnjoyableInfo());
                }
            }
            if (_loc_3.getStatus(SwitchDef.ID_SHOW_DOCK_DEFINITION))
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_DEFINITION_SHOW);
            }
            if (_loc_3.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_CAPTION) && _loc_1.curActor.movieModel.subtitles.length >= 1)
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_CAPTION_BTN_SHOW);
            }
            if (_loc_3.getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_TRACK) && _loc_1.curActor.movieModel.subtitles.length < 1 && _loc_1.curActor.movieModel.audioTrackCount > 1)
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRACK_BTN_SHOW);
            }
            if (_loc_2.barrageProxy.checkShowBarrage() && GlobalStage.isFullScreen())
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_BARRAGE_BTN_SHOW);
            }
            if (FlashVarConfig.openBarrage)
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_BARRAGE_BTN_OPEN);
            }
            this._controllBarProxy.addStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE, false);
            this._controllBarView.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        private function deinitBtns() : void
        {
            var _loc_1:ADProxy = null;
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW);
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW);
            if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW) || this._controllBarProxy.hasStatus(ControllBarDef.STATUS_LIST_BTN_SHOW))
            {
                _loc_1 = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
                if (!_loc_1.hasStatus(ADDef.STATUS_PLAYING) && !_loc_1.hasStatus(ADDef.STATUS_PAUSED))
                {
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                }
            }
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TIME_SHOW);
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_3D_BTN_SHOW);
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_CAPTION_BTN_SHOW);
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TRACK_BTN_SHOW);
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FILTER_BTN_SHOW);
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_DEFINITION_SHOW);
            this._controllBarProxy.removeStatus(ControllBarDef.STATUS_BTNS_INIT_ENABLE, false);
            return;
        }// end function

        private function onFullScreenSwitch(param1:Boolean) : void
        {
            var _loc_4:Point = null;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            if (param1)
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
                this._controllBarView.backGround.alpha = 0.8;
            }
            else
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
                this._controllBarView.backGround.alpha = 1;
            }
            if (_loc_3.barrageProxy.checkShowBarrage() && param1)
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_BARRAGE_BTN_SHOW);
            }
            else
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_BARRAGE_BTN_SHOW);
            }
            if (this.checkTvListBtnShow())
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                if (this.isTvListChannels())
                {
                    this._controllBarProxy.addStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                }
                else
                {
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                }
            }
            else
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
            }
            this.showExpandBtn();
            if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR) && !this._controllBarProxy.hasStatus(ControllBarDef.STATUS_SHOW))
            {
                Mouse.show();
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
            }
            if (this._controllBarProxy.isFullScreen == param1)
            {
                this._controllBarView.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            }
            else
            {
                this._controllBarProxy.isFullScreen = param1;
            }
            if (!param1)
            {
                this._controllBarView.seekBarView.hideImagePreview();
            }
            if (GlobalStage.stage.focus == null)
            {
                GlobalStage.stage.focus = GlobalStage.stage;
            }
            if (this._controllBarView.volumeControlView.volumeTip.parent)
            {
                _loc_4 = this._controllBarView.volumeControlView.localToGlobal(new Point(this._controllBarView.volumeControlView.tipX, this._controllBarView.volumeControlView.tipY));
                this._controllBarView.volumeControlView.volumeTip.x = _loc_4.x;
                this._controllBarView.volumeControlView.volumeTip.y = _loc_4.y;
            }
            return;
        }// end function

        private function showExpandBtn() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_EXPAND_BTN))
            {
                if (!GlobalStage.isFullScreen() && !_loc_1.curActor.isTryWatch)
                {
                    this._controllBarProxy.addStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW);
                }
                else
                {
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW);
                }
            }
            return;
        }// end function

        private function checkShowStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if ((GlobalStage.isFullScreen() || !this._controllBarProxy.playerLightOn || SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE)) && SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                return true;
            }
            return false;
        }// end function

        private function checkPauseBtnStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            var _loc_2:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (_loc_1.hasStatus(ADDef.STATUS_PLAYING) || this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc_2.hasStatus(SettingDef.STATUS_FILTER_SHOW_BMD))
            {
                return false;
            }
            return true;
        }// end function

        private function onStageMouseMove(event:MouseEvent = null) : void
        {
            this._controllBarProxy.addStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
            if (this.checkShowStatus())
            {
                Mouse.show();
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_SHOW);
            }
            TweenLite.killTweensOf(this.hideSeekBar);
            TweenLite.delayedCall(ControllBarDef.SEEKBAR_THIN_DELAY / 1000, this.hideSeekBar);
            return;
        }// end function

        private function hideSeekBar() : void
        {
            var _loc_1:ADProxy = null;
            var _loc_2:PlayerProxy = null;
            if (!this._controllBarView.seekBarView.isMouseIn && !this._controllBarProxy.hasStatus(ControllBarDef.STATUS_IMAGE_PREVIEW_SHOW))
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
                if (GlobalStage.isFullScreen() || !this._controllBarProxy.playerLightOn || SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE))
                {
                    _loc_2 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (!_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED))
                    {
                        if (GlobalStage.isFullScreen())
                        {
                            Mouse.hide();
                        }
                        this._controllBarProxy.removeStatus(ControllBarDef.STATUS_SHOW);
                    }
                }
                _loc_1 = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
                if (_loc_1.hasStatus(ADDef.STATUS_PLAYING) || _loc_1.hasStatus(ADDef.STATUS_PAUSED) || _loc_1.hasStatus(ADDef.STATUS_LOADING))
                {
                    this._controllBarProxy.addStatus(ControllBarDef.STATUS_SEEK_BAR_THICK);
                    TweenLite.killTweensOf(this.hideSeekBar);
                    TweenLite.delayedCall(ControllBarDef.SEEKBAR_THIN_DELAY / 1000, this.hideSeekBar);
                }
            }
            return;
        }// end function

        private function checkNextBtnShow() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (_loc_1.continueInfoCount > 0 && SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_NEXT_BTN) && _loc_2.curActor.loadMovieParams)
            {
                if (_loc_1.findNextContinueInfo(_loc_2.curActor.loadMovieParams.tvid, _loc_2.curActor.loadMovieParams.vid) != null)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function checkTvListBtnShow() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            if ((GlobalStage.isFullScreen() || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT) && _loc_1.isContinue && SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_TVLIST_BTN) && _loc_1.continueInfoCount > 0 && !_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED))
            {
                return true;
            }
            return false;
        }// end function

        private function onUpdateContinuePlayBtns() : void
        {
            if (this.checkNextBtnShow())
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
            }
            else
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_NEXT_BTN_SHOW);
            }
            if (this.checkTvListBtnShow())
            {
                this._controllBarProxy.addStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                if (this.isTvListChannels())
                {
                    this._controllBarProxy.addStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                }
                else
                {
                    this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
                }
            }
            else
            {
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_LIST_BTN_SHOW);
                this._controllBarProxy.removeStatus(ControllBarDef.STATUS_TVLIST_BTN_SHOW);
            }
            return;
        }// end function

        private function onKeyDown(event:KeyboardEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.smallWindowMode && event.keyLocation != int.MAX_VALUE)
            {
                return;
            }
            switch(event.keyCode)
            {
                case 37:
                {
                    if (!this.isAllowKeyAction() || this._isTimerRunning)
                    {
                        return;
                    }
                    if (this._controllBarProxy.keyDownSeeking == false)
                    {
                        this._controllBarView.seekBarView.seekTime = _loc_2.curActor.currentTime - 15000;
                        this._controllBarProxy.keyDownSeeking = true;
                    }
                    else
                    {
                        this._controllBarView.seekBarView.seekTime = this._controllBarView.seekBarView.seekTime - 15000;
                    }
                    this._controllBarView.seekBarView.updateSeekBarView();
                    break;
                }
                case 38:
                {
                    this._controllBarProxy.keyDownVolume = true;
                    this.increaseVolume();
                    break;
                }
                case 39:
                {
                    if (!this.isAllowKeyAction() || this._isTimerRunning)
                    {
                        return;
                    }
                    if (this._controllBarProxy.keyDownSeeking == false)
                    {
                        this._controllBarView.seekBarView.seekTime = _loc_2.curActor.currentTime + 15000;
                        this._controllBarProxy.keyDownSeeking = true;
                    }
                    else
                    {
                        this._controllBarView.seekBarView.seekTime = this._controllBarView.seekBarView.seekTime + 15000;
                    }
                    this._controllBarView.seekBarView.updateSeekBarView();
                    break;
                }
                case 40:
                {
                    this._controllBarProxy.keyDownVolume = true;
                    this.decreaseVolume();
                    break;
                }
                default:
                {
                    return;
                    break;
                }
            }
            return;
        }// end function

        private function onKeyUp(event:KeyboardEvent) : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.smallWindowMode && event.keyLocation != int.MAX_VALUE)
            {
                return;
            }
            switch(event.keyCode)
            {
                case 32:
                {
                    if (!this.isAllowKeyAction())
                    {
                        return;
                    }
                    if (this._controllBarView.playBtn.visible)
                    {
                        this.onPlayBtnClick(null);
                    }
                    else if (this._controllBarView.pauseBtn.visible)
                    {
                        this.onPauseBtnClick(null);
                    }
                    break;
                }
                case 37:
                {
                    if (this._controllBarProxy.keyDownSeeking)
                    {
                        this._controllBarProxy.keyDownSeeking = false;
                        _loc_3 = this._isTimerRunning ? (this._controllBarProxy.filterBitmapData.interval * this._controllBarProxy.filterBitmapData.showBmdIndex * 1000) : (this._controllBarView.seekBarView.seekTime);
                        this.onPlayerSeeking(_loc_3);
                        _loc_2.curActor.uploadHistory();
                        (this._controllBarProxy.seekCount + 1);
                        this._controllBarView.seekBarView.hideImagePreview();
                        if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))
                        {
                            PingBack.getInstance().userActionPing_4_0(PingBackDef.FILTER_FAST_REWIND);
                        }
                    }
                    break;
                }
                case 38:
                {
                    this._controllBarProxy.keyDownVolume = false;
                    break;
                }
                case 39:
                {
                    if (this._controllBarProxy.keyDownSeeking)
                    {
                        this._controllBarProxy.keyDownSeeking = false;
                        _loc_4 = this._isTimerRunning ? (this._controllBarProxy.filterBitmapData.interval * this._controllBarProxy.filterBitmapData.showBmdIndex * 1000) : (this._controllBarView.seekBarView.seekTime);
                        this.onPlayerSeeking(_loc_4);
                        _loc_2.curActor.uploadHistory();
                        (this._controllBarProxy.seekCount + 1);
                        this._controllBarView.seekBarView.hideImagePreview();
                        if (this._controllBarProxy.hasStatus(ControllBarDef.STATUS_FILTER_OPEN))
                        {
                            PingBack.getInstance().userActionPing_4_0(PingBackDef.FILTER_FAST_FORWARD);
                        }
                    }
                    break;
                }
                case 40:
                {
                    this._controllBarProxy.keyDownVolume = false;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function isAllowKeyAction() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_PLAY) && !_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPPING) && !_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_STOPED) && !_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_FAILED) && !_loc_2.hasStatus(ADDef.STATUS_LOADING) && !_loc_2.hasStatus(ADDef.STATUS_PLAYING) && !_loc_2.hasStatus(ADDef.STATUS_PAUSED))
            {
                return true;
            }
            return false;
        }// end function

        private function increaseVolume() : void
        {
            if (this._controllBarView.volumeControlView.currentVolume < 100)
            {
                this._controllBarView.volumeControlView.adjustVolume = this._controllBarView.volumeControlView.currentVolume + 10;
                if (this._controllBarView.volumeControlView.adjustVolume > 100)
                {
                    this._controllBarView.volumeControlView.adjustVolume = 100;
                }
            }
            else
            {
                this._controllBarView.volumeControlView.adjustVolume = this._controllBarView.volumeControlView.currentVolume + 50;
                if (this._controllBarView.volumeControlView.adjustVolume > 500)
                {
                    this._controllBarView.volumeControlView.adjustVolume = 500;
                }
            }
            this._controllBarView.volumeControlView.updateVolumeControlView(this._controllBarView.volumeControlView.adjustVolume, this._controllBarProxy.keyDownVolume);
            return;
        }// end function

        private function decreaseVolume() : void
        {
            if (this._controllBarView.volumeControlView.currentVolume <= 100)
            {
                this._controllBarView.volumeControlView.adjustVolume = this._controllBarView.volumeControlView.currentVolume - 10;
                if (this._controllBarView.volumeControlView.adjustVolume < 0)
                {
                    this._controllBarView.volumeControlView.adjustVolume = 0;
                }
            }
            else
            {
                this._controllBarView.volumeControlView.adjustVolume = this._controllBarView.volumeControlView.currentVolume - 50;
            }
            this._controllBarView.volumeControlView.updateVolumeControlView(this._controllBarView.volumeControlView.adjustVolume, this._controllBarProxy.keyDownVolume);
            return;
        }// end function

        private function addVolumeTip(param1:Boolean = false) : void
        {
            TweenLite.killTweensOf(this.removeVolumeTip);
            var _loc_2:* = this._controllBarView.volumeControlView.localToGlobal(new Point(this._controllBarView.volumeControlView.tipX, this._controllBarView.volumeControlView.tipY));
            this._controllBarView.volumeControlView.volumeTip.x = _loc_2.x;
            this._controllBarView.volumeControlView.volumeTip.y = _loc_2.y;
            if (this._controllBarView.volumeControlView.volumeTip.parent == null)
            {
                GlobalStage.stage.addChild(this._controllBarView.volumeControlView.volumeTip);
            }
            TweenLite.delayedCall(ControllBarDef.VOLUMETIP_DISAPPEARE_DELAY / 1000, this.removeVolumeTip);
            return;
        }// end function

        private function removeVolumeTip() : void
        {
            if (this._controllBarView.volumeControlView.volumeTip.parent)
            {
                GlobalStage.stage.removeChild(this._controllBarView.volumeControlView.volumeTip);
                TweenLite.killTweensOf(this.removeVolumeTip);
            }
            return;
        }// end function

        private function isTvListChannels() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            if (_loc_2.dataSource != ContinuePlayDef.SOURCE_QIYU_VALUE)
            {
                return true;
            }
            return false;
        }// end function

        private function checkFilterBtnState() : Boolean
        {
            var _loc_2:uint = 0;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && !LocalizaEnum.isTWLocalize(FlashVarConfig.localize))
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_1.curActor.movieModel.skipPointInfoCount)
                {
                    
                    if (_loc_1.curActor.movieModel.getSkipPointInfoAt(_loc_2).skipPointType == SkipPointEnum.ENJOYABLE)
                    {
                        return true;
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            return false;
        }// end function

        private function checkHasNestEnjoableSkip(param1:int) : ISkipPointInfo
        {
            var _loc_3:uint = 0;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2.curActor.movieModel.skipPointInfoCount)
                {
                    
                    if (_loc_2.curActor.movieModel.getSkipPointInfoAt(_loc_3).skipPointType == SkipPointEnum.ENJOYABLE)
                    {
                        if (param1 < _loc_2.curActor.movieModel.getSkipPointInfoAt(_loc_3).endTime)
                        {
                            return _loc_2.curActor.movieModel.getSkipPointInfoAt(_loc_3);
                        }
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return null;
        }// end function

        private function checkInEnjoyableSkipType(param1:int) : Boolean
        {
            var _loc_3:uint = 0;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2.curActor.movieModel.skipPointInfoCount)
                {
                    
                    if (_loc_2.curActor.movieModel.getSkipPointInfoAt(_loc_3).skipPointType == SkipPointEnum.ENJOYABLE)
                    {
                        if (param1 >= _loc_2.curActor.movieModel.getSkipPointInfoAt(_loc_3).startTime && param1 < _loc_2.curActor.movieModel.getSkipPointInfoAt(_loc_3).endTime)
                        {
                            return true;
                        }
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return false;
        }// end function

        private function getAllEnjoyableInfo() : Vector.<ISkipPointInfo>
        {
            var _loc_2:Vector.<ISkipPointInfo> = null;
            var _loc_3:uint = 0;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY))
            {
                _loc_2 = new Vector.<ISkipPointInfo>;
                _loc_3 = 0;
                while (_loc_3 < _loc_1.curActor.movieModel.skipPointInfoCount)
                {
                    
                    if (_loc_1.curActor.movieModel.getSkipPointInfoAt(_loc_3).skipPointType == SkipPointEnum.ENJOYABLE)
                    {
                        _loc_2.push(_loc_1.curActor.movieModel.getSkipPointInfoAt(_loc_3));
                    }
                    _loc_3 = _loc_3 + 1;
                }
                if (_loc_2.length > 0)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        private function getImageUrlList() : Array
        {
            var _loc_4:uint = 0;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:String = "";
            var _loc_3:Array = [];
            if (_loc_1.curActor.movieInfo && _loc_1.curActor.movieInfo.previewImageUrl != "")
            {
                _loc_4 = 0;
                while (_loc_4 < Math.ceil(_loc_1.curActor.movieModel.duration / 1000 / 1000))
                {
                    
                    _loc_2 = _loc_1.curActor.movieInfo.previewImageUrl.replace(".jpg", "_160_90_" + (_loc_4 + 1) + ".jpg");
                    _loc_3.push(_loc_2);
                    _loc_4 = _loc_4 + 1;
                }
            }
            return _loc_3;
        }// end function

        private function onFilterTimerStart(param1:int) : void
        {
            this._controllBarProxy.filterBitmapData.showBmdIndex = Math.floor(param1 / 1000 / this._controllBarProxy.filterBitmapData.interval);
            this._filterTimer.start();
            this._isTimerRunning = true;
            this._bmdNullTimes = 0;
            return;
        }// end function

        private function onFilterTimer(event:TimerEvent) : void
        {
            var _loc_3:int = 0;
            var _loc_4:ISkipPointInfo = null;
            var _loc_5:ISkipPointInfo = null;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                (this._controllBarProxy.filterBitmapData.showBmdIndex + 1);
                _loc_3 = this._controllBarProxy.filterBitmapData.showBmdIndex * 1000 * this._controllBarProxy.filterBitmapData.interval;
                if (!this.checkInEnjoyableSkipType(_loc_3))
                {
                    if (_loc_3 >= _loc_2.curActor.movieModel.duration)
                    {
                        this._filterTimer.stop();
                        this._isTimerRunning = false;
                        this.onFilterSeletedBtnClick();
                        sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, false);
                        sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
                    }
                    else
                    {
                        sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, true);
                        sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
                    }
                    if (this._controllBarProxy.filterBitmapData.getFilterbmd(this._controllBarProxy.filterBitmapData.showBmdIndex) == null)
                    {
                        var _loc_6:String = this;
                        var _loc_7:* = this._bmdNullTimes + 1;
                        _loc_6._bmdNullTimes = _loc_7;
                        if (this._bmdNullTimes >= 5)
                        {
                            _loc_4 = this.checkHasNestEnjoableSkip(_loc_3);
                            if (_loc_4 != null)
                            {
                                this.onPlayerSeeking(_loc_4.startTime, SeekTypeEnum.SKIP_ENJOYABLE_POINT);
                            }
                            else
                            {
                                this._filterTimer.stop();
                                this._isTimerRunning = false;
                                this.onFilterSeletedBtnClick();
                                sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, false);
                                sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
                            }
                        }
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
                    }
                    else
                    {
                        this._bmdNullTimes = 0;
                        this._controllBarProxy.addStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                    }
                }
                else
                {
                    this._filterTimer.stop();
                    this._isTimerRunning = false;
                    sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, false);
                    _loc_5 = this.checkHasNestEnjoableSkip(_loc_3);
                    if (_loc_5 != null)
                    {
                        this.onPlayerSeeking(_loc_5.startTime, SeekTypeEnum.SKIP_ENJOYABLE_POINT);
                    }
                }
            }
            else
            {
                this._filterTimer.stop();
                this._isTimerRunning = false;
                sendNotification(SettingDef.NOTIFIC_FILTER_SHOW_BMD, false);
            }
            return;
        }// end function

    }
}
