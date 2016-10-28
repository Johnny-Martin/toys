package com.qiyi.player.wonder.plugins.controllbar.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.iqiyi.components.tooltip.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.seekbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.volume.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import controllbar.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import gs.*;

    public class ControllBarView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _currentDefinitionInfo:EnumItem;
        private var _seekBarView:SeekBarView;
        private var _volumeControlView:VolumeControlView;
        private var _controlBarUI:ControlBarUI;
        private var _tvListBtnClicked:Boolean = false;
        private var _loadingBtnToolTip:DefaultToolTip;
        private var _filterBtn:ControllBarButton;
        private var _trackBtn:ControllBarButton;
        private var _captionBtn:ControllBarButton;
        private var _d3Btn:ControllBarButton;
        private var _definitionBtn:ControllBarButton;
        private var _likeListBtn:ControllBarButton;
        private var _timeShow:ControllBarDispalyTime;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.controllbar.view.ControllBarView";

        public function ControllBarView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this.initUI();
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function get currentDefinitionInfo() : EnumItem
        {
            return this._currentDefinitionInfo;
        }// end function

        public function set currentDefinitionInfo(param1:EnumItem) : void
        {
            this.updateDefinitionBtn(param1);
            return;
        }// end function

        public function get seekBarView() : SeekBarView
        {
            return this._seekBarView;
        }// end function

        public function get volumeControlView() : VolumeControlView
        {
            return this._volumeControlView;
        }// end function

        public function get playBtn() : SimpleButton
        {
            return this._controlBarUI.triggerBtn.playBtn;
        }// end function

        public function get pauseBtn() : SimpleButton
        {
            return this._controlBarUI.triggerBtn.pauseBtn;
        }// end function

        public function get loadingBtn() : Sprite
        {
            return this._controlBarUI.loadingBtn;
        }// end function

        public function get replayBtn() : SimpleButton
        {
            return this._controlBarUI.replayBtn;
        }// end function

        public function get unFoldBtn() : SimpleButton
        {
            return this._controlBarUI.unFoldBtn;
        }// end function

        public function get foldBtn() : SimpleButton
        {
            return this._controlBarUI.foldBtn;
        }// end function

        public function get barrageBtn() : MovieClip
        {
            return this._controlBarUI.barrageBtn;
        }// end function

        public function get backGround() : Sprite
        {
            return this._controlBarUI.backGround;
        }// end function

        public function updateDefinitionBtn(param1:EnumItem) : void
        {
            this._currentDefinitionInfo = param1;
            if (this._definitionBtn)
            {
                this._definitionBtn.updateBtnText(ChineseNameOfLangAudioDef.getDefinitionName(param1));
            }
            this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function set repeatSubBtnVisible(param1:Boolean) : void
        {
            this._controlBarUI.repeatBtn.openLoopBtn.visible = !param1;
            this._controlBarUI.repeatBtn.closeLoopBtn.visible = param1;
            return;
        }// end function

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Point = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            this._status.addStatus(param1);
            this.seekBarView.onAddStatus(param1);
            switch(param1)
            {
                case ControllBarDef.STATUS_OPEN:
                {
                    this.open();
                    break;
                }
                case ControllBarDef.STATUS_SHOW:
                {
                    _loc_2 = GlobalStage.stage.stageHeight - BodyDef.VIDEO_BOTTOM_RESERVE - 10;
                    TweenLite.to(this, 0.5, {y:_loc_2, onComplete:this.onTweenComplete});
                    break;
                }
                case ControllBarDef.STATUS_TRIGGER_BTN_SHOW:
                {
                    this._controlBarUI.triggerBtn.visible = true;
                    this._controlBarUI.triggerBtn.pauseBtn.visible = true;
                    this._controlBarUI.triggerBtn.playBtn.visible = false;
                    this._controlBarUI.loadingBtn.visible = false;
                    this._controlBarUI.replayBtn.visible = false;
                    if (this._loadingBtnToolTip.parent)
                    {
                        GlobalStage.stage.removeChild(this._loadingBtnToolTip);
                    }
                    break;
                }
                case ControllBarDef.STATUS_TRIGGER_BTN_PAUSE:
                {
                    this._controlBarUI.triggerBtn.visible = true;
                    this._controlBarUI.triggerBtn.pauseBtn.visible = false;
                    this._controlBarUI.triggerBtn.playBtn.visible = true;
                    this._controlBarUI.loadingBtn.visible = false;
                    this._controlBarUI.replayBtn.visible = false;
                    if (this._loadingBtnToolTip.parent)
                    {
                        GlobalStage.stage.removeChild(this._loadingBtnToolTip);
                    }
                    break;
                }
                case ControllBarDef.STATUS_LOAD_TIPS_SHOW:
                {
                    _loc_3 = localToGlobal(new Point(this._controlBarUI.triggerBtn.width / 3, -22));
                    this._loadingBtnToolTip.x = _loc_3.x;
                    this._loadingBtnToolTip.y = _loc_3.y;
                    GlobalStage.stage.addChild(this._loadingBtnToolTip);
                    break;
                }
                case ControllBarDef.STATUS_LOAD_BTN_SHOW:
                {
                    this._controlBarUI.triggerBtn.visible = false;
                    this._controlBarUI.loadingBtn.visible = true;
                    this._controlBarUI.replayBtn.visible = false;
                    break;
                }
                case ControllBarDef.STATUS_REPLAY_BTN_SHOW:
                {
                    this._controlBarUI.triggerBtn.visible = false;
                    this._controlBarUI.loadingBtn.visible = false;
                    this._controlBarUI.replayBtn.visible = true;
                    break;
                }
                case ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW:
                {
                    this._controlBarUI.normalBtn.visible = true;
                    this._controlBarUI.fullscreenBtn.visible = false;
                    break;
                }
                case ControllBarDef.STATUS_TIME_SHOW:
                {
                    if (this._timeShow)
                    {
                        this._timeShow.visible = true;
                    }
                    else
                    {
                        this._timeShow = new ControllBarDispalyTime();
                        this._timeShow.y = (BodyDef.VIDEO_BOTTOM_RESERVE - this._timeShow.height) / 2;
                        this._controlBarUI.addChild(this._timeShow);
                    }
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW:
                {
                    this._controlBarUI.repeatBtn.visible = true;
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_NEXT_BTN_SHOW:
                {
                    this._controlBarUI.nextVideoBtn.visible = true;
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_LIST_BTN_SHOW:
                {
                    _loc_4 = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_LIST_BTN_DES1);
                    if (this._likeListBtn)
                    {
                        this._likeListBtn.updateBtnText(_loc_4);
                        this._likeListBtn.visible = true;
                    }
                    else
                    {
                        this._likeListBtn = new ControllBarButton(_loc_4);
                        this._controlBarUI.addChild(this._likeListBtn);
                        this._likeListBtn.addEventListener(MouseEvent.CLICK, this.onTvListBtnClick);
                    }
                    ToolTip.getInstance().unregisterComponent(this._likeListBtn);
                    ToolTip.getInstance().registerComponent(this._likeListBtn, _loc_4);
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_TVLIST_BTN_SHOW:
                {
                    _loc_5 = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_LIST_BTN_DES2);
                    if (this._likeListBtn)
                    {
                        this._likeListBtn.updateBtnText(_loc_5);
                        this._likeListBtn.visible = true;
                    }
                    else
                    {
                        this._likeListBtn = new ControllBarButton(_loc_5);
                        this._controlBarUI.addChild(this._likeListBtn);
                        this._likeListBtn.addEventListener(MouseEvent.CLICK, this.onTvListBtnClick);
                    }
                    ToolTip.getInstance().unregisterComponent(this._likeListBtn);
                    ToolTip.getInstance().registerComponent(this._likeListBtn, _loc_5);
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_EXPAND_BTN_SHOW:
                {
                    this._controlBarUI.unFoldBtn.visible = !this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
                    this._controlBarUI.foldBtn.visible = this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_EXPAND_UNFOLD:
                {
                    if (this._status.hasStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW))
                    {
                        this._controlBarUI.unFoldBtn.visible = !this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
                        this._controlBarUI.foldBtn.visible = this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
                        this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    }
                    break;
                }
                case ControllBarDef.STATUS_3D_BTN_SHOW:
                {
                    if (this._d3Btn)
                    {
                        this._d3Btn.updateBtnText(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_D3BTN_DES1));
                        this._d3Btn.visible = true;
                    }
                    else
                    {
                        this._d3Btn = new ControllBarButton(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_D3BTN_DES2));
                        this._controlBarUI.addChild(this._d3Btn);
                        ToolTip.getInstance().registerComponent(this._d3Btn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_D3BTN_2));
                        this._d3Btn.addEventListener(MouseEvent.CLICK, this.onD3BtnClick);
                    }
                    break;
                }
                case ControllBarDef.STATUS_CAPTION_BTN_SHOW:
                {
                    if (this._captionBtn)
                    {
                        this._captionBtn.visible = true;
                    }
                    else
                    {
                        this._captionBtn = new ControllBarButton(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_CAPTION_BTN_DES1));
                        this._controlBarUI.addChild(this._captionBtn);
                        ToolTip.getInstance().registerComponent(this._captionBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_CAPTIONBTN));
                        this._captionBtn.addEventListener(MouseEvent.CLICK, this.onCaptionOrTrackBtnClick);
                    }
                    break;
                }
                case ControllBarDef.STATUS_TRACK_BTN_SHOW:
                {
                    if (this._trackBtn)
                    {
                        this._trackBtn.visible = true;
                    }
                    else
                    {
                        this._trackBtn = new ControllBarButton(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_TRACK_BTN_DES1));
                        this._controlBarUI.addChild(this._trackBtn);
                        ToolTip.getInstance().registerComponent(this._trackBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_TRACKBTN));
                        this._trackBtn.addEventListener(MouseEvent.CLICK, this.onCaptionOrTrackBtnClick);
                    }
                    break;
                }
                case ControllBarDef.STATUS_DEFINITION_SHOW:
                {
                    if (this._definitionBtn)
                    {
                        this._definitionBtn.visible = true;
                    }
                    else
                    {
                        this._definitionBtn = new ControllBarButton(ChineseNameOfLangAudioDef.getDefinitionName(this._currentDefinitionInfo));
                        this._controlBarUI.addChild(this._definitionBtn);
                        this._definitionBtn.addEventListener(MouseEvent.CLICK, this.onDefinitionBtnClick);
                    }
                    break;
                }
                case ControllBarDef.STATUS_FILTER_BTN_SHOW:
                {
                    if (this._filterBtn)
                    {
                        this._filterBtn.visible = true;
                    }
                    else
                    {
                        this._filterBtn = new ControllBarButton(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_FILTER_BTN_DES1));
                        this._controlBarUI.addChild(this._filterBtn);
                        this._filterBtn.addEventListener(MouseEvent.CLICK, this.onFilterBtnClick);
                    }
                    ToolTip.getInstance().unregisterComponent(this._filterBtn);
                    ToolTip.getInstance().registerComponent(this._filterBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FILTERBTN_OPEN));
                    this._filterBtn.isSelected = false;
                    break;
                }
                case ControllBarDef.STATUS_FILTER_OPEN:
                {
                    ToolTip.getInstance().unregisterComponent(this._filterBtn);
                    ToolTip.getInstance().registerComponent(this._filterBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FILTERBTN_CLOSE));
                    this._filterBtn.isSelected = true;
                    break;
                }
                case ControllBarDef.STATUS_BARRAGE_BTN_SHOW:
                {
                    this._controlBarUI.barrageBtn.visible = true;
                    break;
                }
                case ControllBarDef.STATUS_BARRAGE_BTN_OPEN:
                {
                    this._controlBarUI.barrageBtn.gotoAndStop("_open");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onRemoveStatus(param1:int) : void
        {
            this._status.removeStatus(param1);
            this.seekBarView.onRemoveStatus(param1);
            switch(param1)
            {
                case ControllBarDef.STATUS_OPEN:
                {
                    this.close();
                    break;
                }
                case ControllBarDef.STATUS_SHOW:
                {
                    TweenLite.to(this, 0.5, {y:GlobalStage.stage.stageHeight, onComplete:this.onTweenComplete});
                    break;
                }
                case ControllBarDef.STATUS_SEEK_BAR_SHOW:
                {
                    this.seekBarView.visible = false;
                    break;
                }
                case ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW:
                {
                    this._controlBarUI.normalBtn.visible = false;
                    this._controlBarUI.fullscreenBtn.visible = true;
                    break;
                }
                case ControllBarDef.STATUS_TIME_SHOW:
                {
                    if (this._timeShow)
                    {
                        this._timeShow.visible = false;
                    }
                    break;
                }
                case ControllBarDef.STATUS_LOOP_PLAY_BTN_SHOW:
                {
                    this._controlBarUI.repeatBtn.visible = false;
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_NEXT_BTN_SHOW:
                {
                    this._controlBarUI.nextVideoBtn.visible = false;
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_LIST_BTN_SHOW:
                {
                    if (this._likeListBtn)
                    {
                        this._likeListBtn.visible = false;
                    }
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_TVLIST_BTN_SHOW:
                {
                    if (this._likeListBtn)
                    {
                        this._likeListBtn.visible = false;
                    }
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_EXPAND_BTN_SHOW:
                {
                    this._controlBarUI.unFoldBtn.visible = false;
                    this._controlBarUI.foldBtn.visible = false;
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_EXPAND_UNFOLD:
                {
                    if (this._status.hasStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW))
                    {
                        this._controlBarUI.unFoldBtn.visible = !this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
                        this._controlBarUI.foldBtn.visible = this._status.hasStatus(ControllBarDef.STATUS_EXPAND_UNFOLD);
                        this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    }
                    break;
                }
                case ControllBarDef.STATUS_3D_BTN_SHOW:
                {
                    if (this._d3Btn)
                    {
                        this._d3Btn.visible = false;
                    }
                    break;
                }
                case ControllBarDef.STATUS_CAPTION_BTN_SHOW:
                {
                    if (this._captionBtn)
                    {
                        this._captionBtn.visible = false;
                    }
                    break;
                }
                case ControllBarDef.STATUS_TRACK_BTN_SHOW:
                {
                    if (this._trackBtn)
                    {
                        this._trackBtn.visible = false;
                    }
                    break;
                }
                case ControllBarDef.STATUS_DEFINITION_SHOW:
                {
                    if (this._definitionBtn)
                    {
                        this._definitionBtn.visible = false;
                    }
                    break;
                }
                case ControllBarDef.STATUS_LOAD_TIPS_SHOW:
                {
                    if (this._loadingBtnToolTip.parent)
                    {
                        GlobalStage.stage.removeChild(this._loadingBtnToolTip);
                    }
                    break;
                }
                case ControllBarDef.STATUS_FILTER_BTN_SHOW:
                {
                    if (this._filterBtn)
                    {
                        this._filterBtn.visible = false;
                    }
                    ToolTip.getInstance().unregisterComponent(this._filterBtn);
                    ToolTip.getInstance().registerComponent(this._filterBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FILTERBTN_OPEN));
                    this._filterBtn.isSelected = false;
                    this.onBtnsResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                    break;
                }
                case ControllBarDef.STATUS_FILTER_OPEN:
                {
                    ToolTip.getInstance().unregisterComponent(this._filterBtn);
                    ToolTip.getInstance().registerComponent(this._filterBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FILTERBTN_OPEN));
                    this._filterBtn.isSelected = false;
                    break;
                }
                case ControllBarDef.STATUS_BARRAGE_BTN_SHOW:
                {
                    this._controlBarUI.barrageBtn.visible = false;
                    break;
                }
                case ControllBarDef.STATUS_BARRAGE_BTN_OPEN:
                {
                    this._controlBarUI.barrageBtn.gotoAndStop("_close");
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            var _loc_3:Point = null;
            x = 0;
            if (this._status.hasStatus(ControllBarDef.STATUS_SHOW))
            {
                y = GlobalStage.stage.stageHeight - BodyDef.VIDEO_BOTTOM_RESERVE - 10;
            }
            else
            {
                y = GlobalStage.stage.stageHeight;
            }
            this._controlBarUI.backGround.width = param1;
            if (this._status.hasStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW))
            {
                this._seekBarView.onResize(param1, param2);
            }
            this._volumeControlView.y = 10;
            this.onBtnsResize(param1, param2);
            if (this._loadingBtnToolTip.parent)
            {
                _loc_3 = localToGlobal(new Point(this._controlBarUI.triggerBtn.width / 3, -22));
                this._loadingBtnToolTip.x = _loc_3.x;
                this._loadingBtnToolTip.y = _loc_3.y;
            }
            return;
        }// end function

        private function onBtnsResize(param1:int, param2:int) : void
        {
            var _loc_3:Number = 0;
            this._controlBarUI.repeatBtn.x = this._controlBarUI.triggerBtn.width + 1;
            this._controlBarUI.nextVideoBtn.x = this._controlBarUI.repeatBtn.x + this._controlBarUI.repeatBtn.width * int(this._controlBarUI.repeatBtn.visible);
            _loc_3 = this._controlBarUI.nextVideoBtn.x + this._controlBarUI.nextVideoBtn.width * int(this._controlBarUI.nextVideoBtn.visible);
            if (this._likeListBtn)
            {
                this._likeListBtn.x = 10 + this._controlBarUI.nextVideoBtn.x + this._controlBarUI.nextVideoBtn.width * int(this._controlBarUI.nextVideoBtn.visible);
                _loc_3 = this._likeListBtn.x + this._likeListBtn.width * int(this._likeListBtn.visible);
            }
            if (this._timeShow)
            {
                this._timeShow.x = _loc_3;
                _loc_3 = this._timeShow.x + this._timeShow.getWidth() * int(this._timeShow.visible);
            }
            this._controlBarUI.barrageBtn.x = _loc_3 + 20;
            _loc_3 = 0;
            this._controlBarUI.fullscreenBtn.x = param1 - this._controlBarUI.fullscreenBtn.width - 2;
            this._controlBarUI.normalBtn.x = this._controlBarUI.fullscreenBtn.x;
            this._controlBarUI.unFoldBtn.x = this._controlBarUI.normalBtn.x - this._controlBarUI.unFoldBtn.width * int(this._status.hasStatus(ControllBarDef.STATUS_EXPAND_BTN_SHOW));
            this._controlBarUI.foldBtn.x = this._controlBarUI.unFoldBtn.x;
            var _loc_4:* = this._status.hasStatus(ControllBarDef.STATUS_VOLUME_BAR_SHOW);
            this._volumeControlView.x = this._controlBarUI.unFoldBtn.x - this._volumeControlView.width * int(_loc_4) - 16;
            _loc_3 = this._volumeControlView.x;
            if (this._definitionBtn)
            {
                this._definitionBtn.x = this._volumeControlView.x - this._definitionBtn.width * int(this._definitionBtn.visible);
                _loc_3 = this._definitionBtn.x;
            }
            if (this._filterBtn)
            {
                this._filterBtn.x = _loc_3 - this._filterBtn.width * int(this._filterBtn.visible);
                _loc_3 = this._filterBtn.x;
            }
            if (this._trackBtn)
            {
                this._trackBtn.x = _loc_3 - this._trackBtn.width * int(this._trackBtn.visible);
                _loc_3 = this._trackBtn.x;
            }
            if (this._captionBtn)
            {
                this._captionBtn.x = _loc_3 - this._captionBtn.width * int(this._captionBtn.visible);
                _loc_3 = this._captionBtn.x;
            }
            if (this._d3Btn)
            {
                this._d3Btn.x = _loc_3 - this._d3Btn.width * int(this._d3Btn.visible);
                _loc_3 = this._d3Btn.x;
            }
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_DefinitionBtnLocationChange, {x:this._definitionBtn ? (this._definitionBtn.x + (this._definitionBtn.width - SettingDef.DEFINITION_PANEL_WIDTH) / 2) : (0), y:this.y, filterBtnX:this._filterBtn ? (this._filterBtn.x) : (0)}));
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ControlBarLocationChange, new Rectangle(this.x, this.y, this.width, this.height)));
            return;
        }// end function

        public function onPlayerRunning(param1:int, param2:int, param3:int, param4:Boolean) : void
        {
            this._seekBarView.onPlayerRunning(param1, param2, param4);
            this.updateDisplayTime(param3, param1);
            return;
        }// end function

        public function adjustDisplayTimeOnStoped() : void
        {
            var _loc_1:* = this._seekBarView.totalTime - this._seekBarView.currentTime;
            if (_loc_1 <= 2000 && _loc_1 != 0)
            {
                this.updateDisplayTime(this._seekBarView.totalTime, this._seekBarView.totalTime);
            }
            return;
        }// end function

        public function updateD3BtnVisible(param1:Boolean) : void
        {
            this._d3Btn.updateBtnText(param1 ? (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_D3BTN_DES1)) : (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_D3BTN_DES2)));
            ToolTip.getInstance().unregisterComponent(this._d3Btn);
            ToolTip.getInstance().registerComponent(this._d3Btn, param1 ? (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_D3BTN_1)) : (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_D3BTN_2)));
            return;
        }// end function

        public function updateFilterBtnType(param1:Boolean) : void
        {
            ToolTip.getInstance().unregisterComponent(this._filterBtn);
            ToolTip.getInstance().registerComponent(this._filterBtn, param1 ? (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FILTERBTN_CLOSE)) : (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FILTERBTN_OPEN)));
            this._filterBtn.isSelected = param1;
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_Close));
            }
            return;
        }// end function

        override protected function onAddToStage() : void
        {
            super.onAddToStage();
            return;
        }// end function

        override protected function onRemoveFromStage() : void
        {
            super.onRemoveFromStage();
            return;
        }// end function

        private function updateDisplayTime(param1:int, param2:int) : void
        {
            var _loc_3:String = "";
            var _loc_4:String = "";
            if (param1 > ConstUtils.H_2_MS)
            {
                _loc_3 = Strings.formatAsTimeCode(param2 / 1000, true);
                _loc_4 = Strings.formatAsTimeCode(param1 / 1000, true);
            }
            else
            {
                _loc_3 = Strings.formatAsTimeCode(param2 / 1000, false);
                _loc_4 = Strings.formatAsTimeCode(param1 / 1000, false);
            }
            if (this._timeShow)
            {
                this._timeShow.updateTime(_loc_3, _loc_4);
                this._controlBarUI.barrageBtn.x = this._timeShow.x + this._timeShow.getWidth() + 20;
            }
            return;
        }// end function

        private function onNormalScreenBtnClick(event:MouseEvent) : void
        {
            GlobalStage.setNormalScreen();
            this._controlBarUI.normalBtn.visible = false;
            this._controlBarUI.fullscreenBtn.visible = true;
            return;
        }// end function

        private function onFullScreenBtnClick(event:MouseEvent) : void
        {
            GlobalStage.setFullScreen();
            this._controlBarUI.normalBtn.visible = true;
            this._controlBarUI.fullscreenBtn.visible = false;
            return;
        }// end function

        private function onRepeatBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_RepeatBtnClicked, this._controlBarUI.repeatBtn.openLoopBtn.visible));
            return;
        }// end function

        private function onNextVideoBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_NextVideoBtnClicked));
            return;
        }// end function

        private function onTvListBtnClick(event:MouseEvent) : void
        {
            this._tvListBtnClicked = !this._tvListBtnClicked;
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_TvListBtnClicked, this._tvListBtnClicked));
            return;
        }// end function

        private function onFilterBtnClick(event:MouseEvent) : void
        {
            if (this._filterBtn.isSelected)
            {
                dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_FilterCloseClick));
            }
            else
            {
                dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_FilterOpenClick));
            }
            return;
        }// end function

        private function onD3BtnClick(event:MouseEvent) : void
        {
            var _loc_2:Boolean = false;
            if (this._d3Btn.text == LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_D3BTN_DES1))
            {
                _loc_2 = true;
            }
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_D3BtnClick, _loc_2));
            return;
        }// end function

        private function onDefinitionBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_DefinitionBtnClicked));
            return;
        }// end function

        private function onCaptionOrTrackBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_CaptionOrTrackBtnClick));
            return;
        }// end function

        private function onTweenComplete() : void
        {
            if (this._status.hasStatus(ControllBarDef.STATUS_SHOW))
            {
                y = GlobalStage.stage.stageHeight - BodyDef.VIDEO_BOTTOM_RESERVE - 10;
            }
            else
            {
                y = GlobalStage.stage.stageHeight;
            }
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_DefinitionBtnLocationChange, {x:this._definitionBtn ? (this._definitionBtn.x + (this._definitionBtn.width - SettingDef.DEFINITION_PANEL_WIDTH) / 2) : (0), y:this.y, filterBtnX:this._filterBtn ? (this._filterBtn.x) : (0)}));
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ControlBarLocationChange, new Rectangle(this.x, this.y, this.stage.width, BodyDef.VIDEO_BOTTOM_RESERVE)));
            return;
        }// end function

        private function initUI() : void
        {
            this._seekBarView = new SeekBarView(this._status);
            this._seekBarView.visible = false;
            this._loadingBtnToolTip = new DefaultToolTip();
            this._loadingBtnToolTip.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_LOADING);
            this._volumeControlView = new VolumeControlView(this._status);
            this._controlBarUI = new ControlBarUI();
            this._controlBarUI.x = 0;
            this._controlBarUI.y = 10;
            this._controlBarUI.triggerBtn.playBtn.visible = false;
            this._controlBarUI.loadingBtn.visible = false;
            this._controlBarUI.loadingBtn.mouseChildren = false;
            this._controlBarUI.loadingBtn.buttonMode = true;
            this._controlBarUI.loadingBtn.useHandCursor = true;
            this._controlBarUI.loadingBtn.graphics.beginFill(0, 0);
            this._controlBarUI.loadingBtn.graphics.drawRect((-this._controlBarUI.loadingBtn.width) / 2, (-this._controlBarUI.loadingBtn.height) / 2, this._controlBarUI.loadingBtn.width, this._controlBarUI.loadingBtn.height);
            this._controlBarUI.loadingBtn.graphics.endFill();
            this._controlBarUI.replayBtn.visible = false;
            this._controlBarUI.normalBtn.visible = !this._status.hasStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
            this._controlBarUI.normalBtn.addEventListener(MouseEvent.CLICK, this.onNormalScreenBtnClick);
            this._controlBarUI.fullscreenBtn.visible = this._status.hasStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
            this._controlBarUI.fullscreenBtn.addEventListener(MouseEvent.CLICK, this.onFullScreenBtnClick);
            this._controlBarUI.repeatBtn.addEventListener(MouseEvent.CLICK, this.onRepeatBtnClick);
            this._controlBarUI.nextVideoBtn.addEventListener(MouseEvent.CLICK, this.onNextVideoBtnClick);
            this._controlBarUI.repeatBtn.visible = false;
            this._controlBarUI.repeatBtn.openLoopBtn.visible = true;
            this._controlBarUI.repeatBtn.closeLoopBtn.visible = false;
            this._controlBarUI.nextVideoBtn.visible = false;
            this._controlBarUI.unFoldBtn.visible = false;
            this._controlBarUI.foldBtn.visible = false;
            this._controlBarUI.barrageBtn.visible = false;
            this._controlBarUI.barrageBtn._tfBarrage.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTROLL_BAR_VIEW_BARRAGE_BTN_DES1);
            addChild(this._seekBarView);
            addChild(this._controlBarUI);
            addChild(this._volumeControlView);
            this.registerToolTip();
            return;
        }// end function

        private function registerToolTip() : void
        {
            ToolTip.getInstance().registerComponent(this._seekBarView.forWardBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FORWARDBTN));
            ToolTip.getInstance().registerComponent(this._seekBarView.backWardBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_BACKWARDBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.triggerBtn.playBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_TRIGGERBTN_PLAYBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.triggerBtn.pauseBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_TRIGGERBTN_PAUSEBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.replayBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_REPLAYBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.nextVideoBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_NEXTVIDEOBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.repeatBtn.openLoopBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_REPEATBTN_OPENLOOPBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.repeatBtn.closeLoopBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_REPEATBTN_CLOSELOOPBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.unFoldBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_UNFOLDBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.foldBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FOLDBTN));
            ToolTip.getInstance().registerComponent(this._volumeControlView.speaker, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_SPEAKER));
            ToolTip.getInstance().registerComponent(this._controlBarUI.normalBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_NORMALBTN));
            ToolTip.getInstance().registerComponent(this._controlBarUI.fullscreenBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_FULLSCREENBTN));
            return;
        }// end function

    }
}
