package com.qiyi.player.wonder.plugins.feedback.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.iqiyi.components.tooltip.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.feedback.view.parts.concurrencylimit.*;
    import com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired.*;
    import com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited.*;
    import com.qiyi.player.wonder.plugins.feedback.view.parts.drmcopyright.*;
    import com.qiyi.player.wonder.plugins.feedback.view.parts.faultfeedback.*;
    import com.qiyi.player.wonder.plugins.feedback.view.parts.maliceerror.*;
    import com.qiyi.player.wonder.plugins.feedback.view.parts.networkfault.*;
    import com.qiyi.player.wonder.plugins.feedback.view.parts.privatevideo.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    import gs.*;

    public class FeedbackView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _netWorkFaultView:NetWorkFaultView;
        private var _netWorkFaultTaiwan:NetWorkFaultViewTaiwan;
        private var _faultFeedBackPanel:FaultFeedBackPanel;
        private var _copyrightExpired:CopyrightExpired;
        private var _copyrightLimited:CopyrightLimited;
        private var _drmCopyrightLimited:DRMCopyrightLimited;
        private var _privateVideo:PrivateVideo;
        private var _concurrencyLimit:ConcurrencyLimit;
        private var _maliceError:MaliceError;
        private var _normalScreenBtn:CommonNormalScreenBtn;
        private var _videoName:String = "";
        private var _submitTime:uint;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.feedback.view.FeedbackView";

        public function FeedbackView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            type = BodyDef.VIEW_TYPE_END_POPUP;
            this._status = param2;
            this._userInfoVO = param3;
            hasCover = true;
            this._normalScreenBtn = new CommonNormalScreenBtn();
            this._normalScreenBtn.addEventListener(MouseEvent.CLICK, this.onNormalScreenBtnClick);
            ToolTip.getInstance().registerComponent(this._normalScreenBtn, "退出全屏");
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function createMaliceErrorView(param1:String) : void
        {
            this._maliceError = new MaliceError(param1);
            addChild(this._maliceError);
            return;
        }// end function

        public function createNetWorkFaultView(param1:String) : void
        {
            if (LocalizaEnum.isTWLocalize(FlashVarConfig.localize))
            {
                this._netWorkFaultTaiwan = new NetWorkFaultViewTaiwan(param1);
                addChild(this._netWorkFaultTaiwan);
                this._netWorkFaultTaiwan.refreshBtn.addEventListener(MouseEvent.CLICK, this.onRefreshClick);
                this._netWorkFaultTaiwan.helpBtn.addEventListener(MouseEvent.CLICK, this.onHelpMouseClick);
            }
            else
            {
                this._netWorkFaultView = new NetWorkFaultView(param1);
                addChild(this._netWorkFaultView);
                this._netWorkFaultView.refreshBtn.addEventListener(MouseEvent.CLICK, this.onRefreshClick);
                this._netWorkFaultView.helpBtn.addEventListener(MouseEvent.CLICK, this.onHelpMouseClick);
                this._netWorkFaultView.downLoadBtn.addEventListener(MouseEvent.CLICK, this.onDownloadBtnClick);
            }
            return;
        }// end function

        public function createCopyrightExpiredView(param1:String, param2:String, param3:Boolean = true, param4:String = "") : void
        {
            this._copyrightExpired = new CopyrightExpired(param1, param2, param3, param4);
            this._copyrightExpired.linkTextField.addEventListener(TextEvent.LINK, this.onOpenFaultFeedbackPanel);
            this._copyrightExpired.downLoadBtn.addEventListener(MouseEvent.CLICK, this.onDownloadBtnClick);
            addChild(this._copyrightExpired);
            return;
        }// end function

        public function createCopyrightLimitedView(param1:uint, param2:String) : void
        {
            this._copyrightLimited = new CopyrightLimited(param1, param2);
            addChild(this._copyrightLimited);
            this._copyrightLimited.linkTextField.addEventListener(TextEvent.LINK, this.onOpenFaultFeedbackPanel);
            this._copyrightLimited.downLoadBtn.addEventListener(MouseEvent.CLICK, this.onDownloadBtnClick);
            return;
        }// end function

        public function createDrmCopyrightLimitedView(param1:String) : void
        {
            this._drmCopyrightLimited = new DRMCopyrightLimited(param1);
            addChild(this._drmCopyrightLimited);
            this._drmCopyrightLimited.linkTextField.addEventListener(TextEvent.LINK, this.onOpenFaultFeedbackPanel);
            return;
        }// end function

        public function createPrivatevideo(param1:uint, param2:Boolean, param3:Boolean) : void
        {
            if (this._privateVideo && this._privateVideo.parent)
            {
                removeChild(this._privateVideo);
                this._privateVideo.destroy();
                this._privateVideo = null;
            }
            this._privateVideo = new PrivateVideo(param1, param2, param3);
            addChild(this._privateVideo);
            this._privateVideo.addEventListener(FeedbackEvent.Evt_PrivateNestVideo, this.onNestVideoLink);
            this._privateVideo.addEventListener(FeedbackEvent.Evt_PrivateConfirmBtnClick, this.onConfirmBtnClick);
            return;
        }// end function

        public function createConcurrencyLimit(param1:Boolean, param2:String) : void
        {
            if (this._concurrencyLimit && this._concurrencyLimit.parent)
            {
                removeChild(this._concurrencyLimit);
                this._concurrencyLimit.destroy();
                this._concurrencyLimit = null;
            }
            this._concurrencyLimit = new ConcurrencyLimit(param1, param2);
            addChild(this._concurrencyLimit);
            this._concurrencyLimit.addEventListener(FeedbackEvent.Evt_SkipMemberAuthBtnClick, this.onSkipMemberAuthBtnClick);
            return;
        }// end function

        public function get videoName() : String
        {
            return this._videoName;
        }// end function

        public function set videoName(param1:String) : void
        {
            this._videoName = param1;
            if (this._copyrightExpired && this._copyrightExpired.parent)
            {
                this._copyrightExpired.videoName = this._videoName;
            }
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
                case FeedbackDef.STATUS_OPEN:
                {
                    this.open();
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
                case FeedbackDef.STATUS_OPEN:
                {
                    this.close();
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
                setCoverArea(new Rectangle(0, 0, param1, param2));
                if (this._faultFeedBackPanel && this._faultFeedBackPanel.parent)
                {
                    this._faultFeedBackPanel.onResize(param1, param2);
                }
                if (this._netWorkFaultView && this._netWorkFaultView.parent)
                {
                    this._netWorkFaultView.onResize(param1, param2);
                }
                if (this._netWorkFaultTaiwan && this._netWorkFaultTaiwan.parent)
                {
                    this._netWorkFaultTaiwan.onResize(param1, param2);
                }
                if (this._copyrightExpired && this._copyrightExpired.parent)
                {
                    this._copyrightExpired.onResize(param1, param2);
                }
                if (this._copyrightLimited && this._copyrightLimited.parent)
                {
                    this._copyrightLimited.onResize(param1, param2);
                }
                if (this._maliceError && this._maliceError.parent)
                {
                    this._maliceError.onResize(param1, param2);
                }
                if (this._privateVideo && this._privateVideo.parent)
                {
                    this._privateVideo.onResize(param1, param2);
                }
                if (this._concurrencyLimit && this._concurrencyLimit.parent)
                {
                    this._concurrencyLimit.onResize(param1, param2);
                }
                if (this._drmCopyrightLimited && this._drmCopyrightLimited.parent)
                {
                    this._drmCopyrightLimited.onResize(param1, param2);
                }
                if (GlobalStage.isFullScreen() && this._faultFeedBackPanel == null)
                {
                    this._normalScreenBtn.x = GlobalStage.stage.stageWidth - this._normalScreenBtn.width;
                    this._normalScreenBtn.y = 8;
                    addChild(this._normalScreenBtn);
                }
                else if (this._faultFeedBackPanel == null && this._normalScreenBtn.parent)
                {
                    removeChild(this._normalScreenBtn);
                }
            }
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_Close));
            }
            return;
        }// end function

        override protected function createCover() : Sprite
        {
            var _loc_1:* = new Sprite();
            _loc_1.graphics.beginFill(0, 1);
            _loc_1.graphics.drawRect(0, 0, 1, 1);
            _loc_1.graphics.endFill();
            return _loc_1;
        }// end function

        override protected function onAddToStage() : void
        {
            super.onAddToStage();
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            setCoverArea(new Rectangle(0, 0, GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight));
            return;
        }// end function

        override protected function onRemoveFromStage() : void
        {
            super.onRemoveFromStage();
            if (this._netWorkFaultView && this._netWorkFaultView.parent)
            {
                this._netWorkFaultView.destroy();
                removeChild(this._netWorkFaultView);
                this._netWorkFaultView = null;
            }
            if (this._netWorkFaultTaiwan && this._netWorkFaultTaiwan.parent)
            {
                this._netWorkFaultTaiwan.destroy();
                removeChild(this._netWorkFaultTaiwan);
                this._netWorkFaultTaiwan = null;
            }
            if (this._copyrightExpired && this._copyrightExpired.parent)
            {
                this._copyrightExpired.linkTextField.removeEventListener(TextEvent.LINK, this.onOpenFaultFeedbackPanel);
                this._copyrightExpired.downLoadBtn.removeEventListener(MouseEvent.CLICK, this.onDownloadBtnClick);
                removeChild(this._copyrightExpired);
                this._copyrightExpired.destroy();
                this._copyrightExpired = null;
            }
            if (this._copyrightLimited && this._copyrightLimited.parent)
            {
                this._copyrightLimited.linkTextField.removeEventListener(TextEvent.LINK, this.onOpenFaultFeedbackPanel);
                this._copyrightLimited.downLoadBtn.removeEventListener(MouseEvent.CLICK, this.onDownloadBtnClick);
                removeChild(this._copyrightLimited);
                this._copyrightLimited.destroy();
                this._copyrightLimited = null;
            }
            if (this._drmCopyrightLimited && this._drmCopyrightLimited.parent)
            {
                this._drmCopyrightLimited.linkTextField.removeEventListener(TextEvent.LINK, this.onOpenFaultFeedbackPanel);
                removeChild(this._drmCopyrightLimited);
                this._drmCopyrightLimited.destroy();
                this._drmCopyrightLimited = null;
            }
            if (this._maliceError && this._maliceError.parent)
            {
                removeChild(this._maliceError);
                this._maliceError.destroy();
                this._maliceError = null;
            }
            if (this._privateVideo && this._privateVideo.parent)
            {
                removeChild(this._privateVideo);
                this._privateVideo.destroy();
                this._privateVideo = null;
            }
            if (this._concurrencyLimit && this._concurrencyLimit.parent)
            {
                removeChild(this._concurrencyLimit);
                this._concurrencyLimit.destroy();
                this._concurrencyLimit = null;
            }
            ToolTip.getInstance().unregisterComponent(this._normalScreenBtn);
            return;
        }// end function

        private function onNormalScreenBtnClick(event:MouseEvent) : void
        {
            GlobalStage.setNormalScreen();
            return;
        }// end function

        private function onRefreshClick(event:MouseEvent) : void
        {
            if (this._netWorkFaultView)
            {
                this._netWorkFaultView.refreshBtn.removeEventListener(MouseEvent.CLICK, this.onRefreshClick);
                this._netWorkFaultView.helpBtn.removeEventListener(MouseEvent.CLICK, this.onHelpMouseClick);
                this._netWorkFaultView.downLoadBtn.removeEventListener(MouseEvent.CLICK, this.onDownloadBtnClick);
            }
            if (this._netWorkFaultTaiwan)
            {
                this._netWorkFaultTaiwan.refreshBtn.removeEventListener(MouseEvent.CLICK, this.onRefreshClick);
                this._netWorkFaultTaiwan.helpBtn.removeEventListener(MouseEvent.CLICK, this.onHelpMouseClick);
            }
            this.close();
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_Refresh));
            return;
        }// end function

        private function onHelpMouseClick(event:MouseEvent) : void
        {
            if (this._netWorkFaultView)
            {
                if (this._netWorkFaultView && this._netWorkFaultView.isFeedBacked)
                {
                    this._netWorkFaultView.isFeedBacked = uint(getTimer() / 1000) - this._submitTime <= FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000;
                }
                else if (this._submitTime)
                {
                    this._netWorkFaultView.isFeedBacked = uint(getTimer() / 1000) - this._submitTime <= FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000;
                }
                if (!this._netWorkFaultView.isFeedBacked)
                {
                    this.onOpenFaultFeedbackPanel(event);
                }
                else
                {
                    this._netWorkFaultView.rejectMsg.visible = true;
                }
            }
            if (this._netWorkFaultTaiwan)
            {
                if (this._netWorkFaultTaiwan.isFeedBacked)
                {
                    this._netWorkFaultTaiwan.isFeedBacked = uint(getTimer() / 1000) - this._submitTime <= FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000;
                }
                else if (this._submitTime)
                {
                    this._netWorkFaultTaiwan.isFeedBacked = uint(getTimer() / 1000) - this._submitTime <= FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000;
                }
                if (!this._netWorkFaultTaiwan.isFeedBacked)
                {
                    this.onOpenFaultFeedbackPanel(event);
                }
                else
                {
                    this._netWorkFaultTaiwan.rejectMsg.visible = true;
                }
            }
            return;
        }// end function

        private function onDownloadBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_DownloadBtnClick));
            return;
        }// end function

        private function onDRMDownloadBtnClick(event:MouseEvent) : void
        {
            var _loc_2:String = "";
            if (Capabilities.version.indexOf("WIN") == 0)
            {
                _loc_2 = SystemConfig.CLIENT_DOWNLOAD_URL + "?id=&pubplatform=" + 1 + "&pubarea=pcltdown_drm" + "&srcchannel=&qipuid=&useragent=&u=&pu=" + "&rn=" + Math.random();
                navigateToURL(new URLRequest(_loc_2), "_blank");
            }
            else
            {
                _loc_2 = SystemConfig.CLIENT_DOWNLOAD_URL + "?id=&pubplatform=" + 6 + "&pubarea=pcltdown_drm" + "&srcchannel=&qipuid=&useragent=&u=&pu=" + "&rn=" + Math.random();
                navigateToURL(new URLRequest(_loc_2), "_blank");
            }
            return;
        }// end function

        private function onOpenFaultFeedbackPanel(event:Event) : void
        {
            if (GlobalStage.isFullScreen())
            {
                GlobalStage.setNormalScreen();
            }
            this._faultFeedBackPanel = new FaultFeedBackPanel();
            this._faultFeedBackPanel.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            this._faultFeedBackPanel.addEventListener(FeedbackEvent.Evt_FaultFeedbackReturn, this.onFeedbackReturn);
            this._faultFeedBackPanel.addEventListener(FeedbackEvent.Evt_FaultFeedBackSuccess, this.onFeedbackOK);
            addChild(this._faultFeedBackPanel);
            return;
        }// end function

        private function onFeedbackOK(event:FeedbackEvent) : void
        {
            if (this._netWorkFaultView)
            {
                this._netWorkFaultView.isFeedBacked = true;
                this._submitTime = uint(getTimer() / 1000);
                TweenLite.delayedCall(FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000, this.hideRejectMsg);
            }
            if (this._netWorkFaultTaiwan)
            {
                this._netWorkFaultTaiwan.isFeedBacked = true;
                this._submitTime = uint(getTimer() / 1000);
                TweenLite.delayedCall(FeedbackDef.FEEDBACK_RESUBMIT_TIME_GAP / 1000, this.hideRejectMsg);
            }
            return;
        }// end function

        private function onFeedbackReturn(event:FeedbackEvent) : void
        {
            if (!this._faultFeedBackPanel)
            {
                return;
            }
            removeChild(this._faultFeedBackPanel);
            this._faultFeedBackPanel.removeEventListener(FeedbackEvent.Evt_FaultFeedbackReturn, this.onFeedbackReturn);
            this._faultFeedBackPanel.removeEventListener(FeedbackEvent.Evt_FaultFeedBackSuccess, this.onFeedbackOK);
            this._faultFeedBackPanel.destroy();
            this._faultFeedBackPanel = null;
            return;
        }// end function

        private function onNestVideoLink(event:FeedbackEvent) : void
        {
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_PrivateNestVideo));
            return;
        }// end function

        private function onConfirmBtnClick(event:FeedbackEvent) : void
        {
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_PrivateConfirmBtnClick, event.data));
            return;
        }// end function

        private function onSkipMemberAuthBtnClick(event:FeedbackEvent) : void
        {
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_SkipMemberAuthBtnClick));
            return;
        }// end function

        private function hideRejectMsg() : void
        {
            if (this._netWorkFaultView)
            {
                this._netWorkFaultView.rejectMsg.visible = false;
            }
            if (this._netWorkFaultTaiwan)
            {
                this._netWorkFaultTaiwan.rejectMsg.visible = false;
            }
            return;
        }// end function

    }
}
