package com.qiyi.player.wonder.plugins.offlinewatch.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;
    import offinewatch.*;

    public class OfflineWatchView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _bg:CommonBg;
        private var _downloadUI:OffineDownloadlUI;
        private var _describeTF:TextField;
        private var _countDownTF:TextField;
        private var _closeBtn:CommonCloseBtn;
        private var _countDownTimer:Timer;
        private var _time:uint = 0;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.offlinewatch.view.OfflineWatchView";
        private static const TEXT_DESCRIBE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.OFFLINE_WATCH_VIEW_DES1);
        private static const TEXT_CONFIRM:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.OFFLINE_WATCH_VIEW_DES2);

        public function OfflineWatchView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            type = BodyDef.VIEW_TYPE_POPUP;
            this._status = param2;
            this._userInfoVO = param3;
            this.initUI();
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
                case OfflineWatchDef.STATUS_OPEN:
                {
                    this.open();
                    this._time = OfflineWatchDef.OFFLINEWATCH_PANEL_SHOW_TIME;
                    this._countDownTF.text = this._time + TEXT_CONFIRM;
                    this.creatCountDownTimer();
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
                case OfflineWatchDef.STATUS_OPEN:
                {
                    this.close();
                    this._time = 0;
                    this.clearCountDownTimer();
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
            if (isOnStage)
            {
                x = (param1 - this._bg.width) / 2;
                y = (param2 - this._bg.height) / 2;
            }
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new OfflineWatchEvent(OfflineWatchEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new OfflineWatchEvent(OfflineWatchEvent.Evt_Close));
            }
            return;
        }// end function

        override protected function onAddToStage() : void
        {
            super.onAddToStage();
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            alpha = 0;
            TweenLite.to(this, BodyDef.POPUP_TWEEN_TIME / 1000, {alpha:1});
            return;
        }// end function

        override protected function onRemoveFromStage() : void
        {
            super.onRemoveFromStage();
            TweenLite.killTweensOf(this);
            return;
        }// end function

        private function initUI() : void
        {
            this._bg = new CommonBg();
            this._bg.width = 380;
            this._bg.height = 160;
            addChild(this._bg);
            this._downloadUI = new OffineDownloadlUI();
            addChild(this._downloadUI);
            this._describeTF = FastCreator.createLabel(TEXT_DESCRIBE, 16777215, 14);
            this._describeTF.x = 160;
            this._describeTF.y = 50;
            addChild(this._describeTF);
            this._countDownTF = FastCreator.createLabel(TEXT_CONFIRM, 16777215, 12);
            this._countDownTF.x = 220;
            this._countDownTF.y = 110;
            this._countDownTF.mouseEnabled = false;
            addChild(this._countDownTF);
            this._closeBtn = new CommonCloseBtn();
            this._closeBtn.x = this._bg.width - this._closeBtn.width - 5;
            this._closeBtn.y = 1;
            addChild(this._closeBtn);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            return;
        }// end function

        private function creatCountDownTimer() : void
        {
            this.clearCountDownTimer();
            this._countDownTimer = new Timer(1000, this._time);
            this._countDownTimer.addEventListener(TimerEvent.TIMER, this.onCountDownTimer);
            this._countDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onCountDownTimerComplete);
            this._countDownTimer.start();
            return;
        }// end function

        private function clearCountDownTimer() : void
        {
            if (this._countDownTimer)
            {
                this._countDownTimer.stop();
                this._countDownTimer.removeEventListener(TimerEvent.TIMER, this.onCountDownTimer);
                this._countDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onCountDownTimerComplete);
                this._countDownTimer = null;
            }
            return;
        }// end function

        private function onCountDownTimer(event:TimerEvent) : void
        {
            (this._time - 1);
            this._countDownTF.text = this._time + TEXT_CONFIRM;
            return;
        }// end function

        private function onCountDownTimerComplete(event:TimerEvent) : void
        {
            this.close();
            return;
        }// end function

        private function onCloseBtnClick(event:MouseEvent) : void
        {
            this.close();
            return;
        }// end function

    }
}
