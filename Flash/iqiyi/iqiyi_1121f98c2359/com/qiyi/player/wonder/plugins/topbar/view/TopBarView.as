package com.qiyi.player.wonder.plugins.topbar.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.iqiyi.components.tooltip.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import com.qiyi.player.wonder.plugins.topbar.view.item.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;
    import topbar.*;

    public class TopBarView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _bg:TopBarBG;
        private var _titleTF:TextField;
        private var _topBarUI:TopBarUI;
        private var _videoScaleBar:VideoScaleBar;
        private var _timer:Timer;
        private var _showSystemTimeFrame:Boolean = false;
        private var _systemTimeDefaultY:int = 5;
        private var _hasTween:Boolean = true;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.topbar.view.TopBarView";

        public function TopBarView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this.initUI();
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function set hasTween(param1:Boolean) : void
        {
            this._hasTween = param1;
            return;
        }// end function

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            this._status.addStatus(param1);
            switch(param1)
            {
                case TopBarDef.STATUS_OPEN:
                {
                    this.open();
                    break;
                }
                case TopBarDef.STATUS_SHOW:
                {
                    TweenLite.to(this, 0.5, {y:0, onComplete:this.onTweenComplete});
                    this.setShowSystemTimeFrame(this._showSystemTimeFrame);
                    break;
                }
                case TopBarDef.STATUS_SCALE_BAR_SHOW:
                {
                    this._videoScaleBar.visible = true;
                    break;
                }
                case TopBarDef.STATUS_ALLOW_TELL_TIME:
                {
                    this.setShowSystemTimeFrame(this._showSystemTimeFrame);
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
            switch(param1)
            {
                case TopBarDef.STATUS_OPEN:
                {
                    this.close();
                    break;
                }
                case TopBarDef.STATUS_SHOW:
                {
                    if (this._hasTween)
                    {
                        TweenLite.to(this, 0.5, {y:-this._bg.height, onComplete:this.onTweenComplete});
                    }
                    else
                    {
                        this.onTweenComplete();
                    }
                    this.setShowSystemTimeFrame(this._showSystemTimeFrame);
                    break;
                }
                case TopBarDef.STATUS_SCALE_BAR_SHOW:
                {
                    this._videoScaleBar.visible = false;
                    break;
                }
                case TopBarDef.STATUS_ALLOW_TELL_TIME:
                {
                    this.setShowSystemTimeFrame(this._showSystemTimeFrame);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onFullScreenChanged(param1:Boolean) : void
        {
            if (param1)
            {
                this._timer.start();
                this.onTimer();
            }
            else
            {
                this._timer.stop();
                this.setShowSystemTimeFrame(this._showSystemTimeFrame);
            }
            return;
        }// end function

        public function setTitle(param1:String) : void
        {
            this._titleTF.text = param1;
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            this._bg.width = param1;
            this._videoScaleBar.x = (param1 - this._videoScaleBar.width) / 2;
            this._topBarUI.nomalScreenBtn.x = param1 - this._topBarUI.nomalScreenBtn.width - 10;
            this._topBarUI.systemTimeFrame.x = this._topBarUI.nomalScreenBtn.x - this._topBarUI.systemTimeFrame.width;
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new TopBarEvent(TopBarEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new TopBarEvent(TopBarEvent.Evt_Close));
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

        private function initUI() : void
        {
            this._bg = new TopBarBG();
            addChild(this._bg);
            this._titleTF = FastCreator.createLabel("片名", 13421772, 18, TextFieldAutoSize.LEFT);
            this._titleTF.x = 10;
            this._titleTF.y = (this._bg.height - this._titleTF.height) / 2 - 10;
            addChild(this._titleTF);
            this._topBarUI = new TopBarUI();
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                this._topBarUI.systemTimeFrame.removeChild(this._topBarUI.systemTimeFrame.timeTF);
            }
            else
            {
                this._topBarUI.systemTimeFrame.removeChild(this._topBarUI.systemTimeFrame.timeClientTF);
            }
            addChild(this._topBarUI);
            this._videoScaleBar = new VideoScaleBar();
            this._topBarUI.systemTimeFrame.y = (this._bg.height - this._topBarUI.systemTimeFrame.height) / 2 - 10;
            this._topBarUI.nomalScreenBtn.y = (this._bg.height - this._topBarUI.nomalScreenBtn.height) / 2 - 10;
            this._videoScaleBar.y = (this._bg.height - this._videoScaleBar.height) / 2 - 10;
            this._topBarUI.addChild(this._videoScaleBar);
            this._systemTimeDefaultY = this._topBarUI.systemTimeFrame.y;
            y = -this._bg.height;
            this.updateScaleBtn(TopBarDef.SCALE_VALUE_100);
            this._videoScaleBar.addEventListener(TopBarEvent.Evt_ScaleClick, this.onScaleClick);
            this._topBarUI.nomalScreenBtn.addEventListener(MouseEvent.CLICK, this.onQuitFullScreen);
            ToolTip.getInstance().registerComponent(this._topBarUI.nomalScreenBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_NORMAL_SCREEN_BTN));
            return;
        }// end function

        private function onTweenComplete() : void
        {
            if (this._status.hasStatus(TopBarDef.STATUS_SHOW))
            {
                y = 0;
            }
            else
            {
                y = -this._bg.height;
            }
            return;
        }// end function

        private function onQuitFullScreen(event:MouseEvent) : void
        {
            GlobalStage.setNormalScreen();
            return;
        }// end function

        private function onTimer(event:TimerEvent = null) : void
        {
            var _loc_2:* = new Date();
            if (_loc_2.minutes == 59 && _loc_2.seconds >= 31 || _loc_2.minutes == 0 && _loc_2.seconds <= 15)
            {
                this.formatHourMinuteSeconds(_loc_2);
                if (!this._showSystemTimeFrame)
                {
                    this.setShowSystemTimeFrame(true);
                }
            }
            else if (this._showSystemTimeFrame)
            {
                this.setShowSystemTimeFrame(false);
                TweenLite.delayedCall(1, this.formatHourMinute, [_loc_2]);
            }
            else
            {
                this.formatHourMinute(_loc_2);
            }
            return;
        }// end function

        private function formatHourMinute(param1:Date) : void
        {
            var _loc_2:* = (param1.hours > 9 ? (param1.hours) : ("0" + param1.hours)) + ":" + (param1.minutes > 9 ? (param1.minutes) : ("0" + param1.minutes));
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                this._topBarUI.systemTimeFrame.timeClientTF.text = _loc_2;
            }
            else
            {
                this._topBarUI.systemTimeFrame.timeTF.text = _loc_2;
            }
            return;
        }// end function

        private function formatHourMinuteSeconds(param1:Date) : void
        {
            var _loc_2:* = (param1.hours > 9 ? (param1.hours) : ("0" + param1.hours)) + ":" + (param1.minutes > 9 ? (param1.minutes) : ("0" + param1.minutes)) + ":" + (param1.seconds > 9 ? (param1.seconds) : ("0" + param1.seconds));
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                this._topBarUI.systemTimeFrame.timeClientTF.text = _loc_2;
            }
            else
            {
                this._topBarUI.systemTimeFrame.timeTF.text = _loc_2;
            }
            return;
        }// end function

        private function setShowSystemTimeFrame(param1:Boolean) : void
        {
            this._showSystemTimeFrame = param1;
            var _loc_2:Number = 0;
            if (this._showSystemTimeFrame && GlobalStage.isFullScreen() && this._status.hasStatus(TopBarDef.STATUS_ALLOW_TELL_TIME))
            {
                if (this._status.hasStatus(TopBarDef.STATUS_SHOW))
                {
                    _loc_2 = this._systemTimeDefaultY;
                }
                else
                {
                    _loc_2 = this._bg.height;
                }
            }
            else
            {
                _loc_2 = this._systemTimeDefaultY;
            }
            TweenLite.killTweensOf(this._topBarUI.systemTimeFrame, true);
            if (_loc_2 != this._topBarUI.systemTimeFrame.y)
            {
                TweenLite.to(this._topBarUI.systemTimeFrame, 0.4, {y:_loc_2});
            }
            return;
        }// end function

        public function updateScaleBtn(param1:int) : void
        {
            this._videoScaleBar.setVideoScale(param1);
            return;
        }// end function

        private function onScaleClick(event:TopBarEvent) : void
        {
            if (GlobalStage.isFullScreen())
            {
                this.updateScaleBtn(int(event.data));
                dispatchEvent(new TopBarEvent(TopBarEvent.Evt_ScaleClick, event.data));
                PingBack.getInstance().scaleActionPing(int(event.data));
            }
            return;
        }// end function

    }
}
