package com.qiyi.player.wonder.plugins.subscribe.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.wonder.common.loader.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.subscribe.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;

    public class SubscribeView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _subscribePanel:SubscribePanel;
        private var _titleTf:TextField;
        private var _subBtnTf:TextField;
        private var _rewardTitleTf:TextField;
        private var _rewardsSubBtnTf:TextField;
        private var _bitmap:Bitmap;
        private var _isNextframe:Boolean = true;
        private var _isShowPoint:Boolean = false;
        private var _clipIsOpen:Boolean = false;
        private var _rewardObj:Object;
        private var _btnType:uint = 0;
        private var _delayCall:TweenLite;
        private var _subInfo:Object;
        private var _panelType:uint = 0;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.subscribe.view.SubscribeView";
        private static const TF_VIEW_UPDATES:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SUBSCRIBE_VIEW_DES1);
        private static const TF_SUBSCRIBE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SUBSCRIBE_VIEW_DES2);
        private static const TF_AR_SUBSCRIBE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SUBSCRIBE_VIEW_DES3);
        private static const TF_REWARD:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SUBSCRIBE_VIEW_DES6);
        public static const BTN_TYPE_SUBSCRIBE:uint = 0;
        public static const BTN_TYPE_AR_SUBSCRIBE:uint = 1;
        public static const BTN_TYPE_REWARD:uint = 2;

        public function SubscribeView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this.initPanel();
            return;
        }// end function

        public function get clipIsOpen() : Boolean
        {
            return this._clipIsOpen;
        }// end function

        public function set clipIsOpen(param1:Boolean) : void
        {
            this._clipIsOpen = param1;
            return;
        }// end function

        public function get rewardObj() : Object
        {
            return this._rewardObj;
        }// end function

        public function set rewardObj(param1:Object) : void
        {
            this._rewardObj = param1;
            return;
        }// end function

        public function get panelType() : uint
        {
            return this._panelType;
        }// end function

        public function set panelType(param1:uint) : void
        {
            this._panelType = param1;
            if (this._panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE && this._subInfo)
            {
                this.btnType = uint(this._subInfo.subState);
                this._titleTf.htmlText = StringUtils.remainWord(this._subInfo.title, 7);
                var _loc_2:Boolean = false;
                this._subscribePanel._rewardPanel.visible = false;
                this._subscribePanel._rewardBtn.visible = _loc_2;
                var _loc_2:Boolean = true;
                this._subscribePanel._desPanel.visible = true;
                this._subscribePanel._subBtn.visible = _loc_2;
            }
            if (this._panelType == SubscribeDef.PANEL_TYPE_REWARD && this._rewardObj)
            {
                this.btnType = BTN_TYPE_REWARD;
                this._rewardTitleTf.htmlText = StringUtils.remainWord(this._rewardObj.rewardInfo, 15);
                var _loc_2:Boolean = true;
                this._subscribePanel._rewardPanel.visible = true;
                this._subscribePanel._rewardBtn.visible = _loc_2;
                var _loc_2:Boolean = false;
                this._subscribePanel._desPanel.visible = false;
                this._subscribePanel._subBtn.visible = _loc_2;
            }
            return;
        }// end function

        public function get btnType() : uint
        {
            return this._btnType;
        }// end function

        public function set btnType(param1:uint) : void
        {
            this._btnType = param1;
            var _loc_2:String = "";
            switch(this._btnType)
            {
                case BTN_TYPE_AR_SUBSCRIBE:
                {
                    _loc_2 = this._panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE ? (TF_AR_SUBSCRIBE) : (TF_REWARD);
                    this._subscribePanel._subBtn.gotoAndStop("_frameClicked");
                    if (this._subscribePanel._subBtn.hasEventListener(MouseEvent.CLICK))
                    {
                        this._subscribePanel._subBtn.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
                    }
                    this._subscribePanel._rewardBtn.gotoAndStop("_frameClicked");
                    if (this._subscribePanel._rewardBtn.hasEventListener(MouseEvent.CLICK))
                    {
                        this._subscribePanel._rewardBtn.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
                    }
                    break;
                }
                case BTN_TYPE_SUBSCRIBE:
                {
                    _loc_2 = this._panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE ? (TF_SUBSCRIBE) : (TF_REWARD);
                    this._subscribePanel._subBtn.gotoAndStop("_frameNormal");
                    if (!this._subscribePanel._subBtn.hasEventListener(MouseEvent.CLICK))
                    {
                        this._subscribePanel._subBtn.addEventListener(MouseEvent.CLICK, this.onMouseClick);
                    }
                    this._subscribePanel._rewardBtn.gotoAndStop("_frameNormal");
                    if (!this._subscribePanel._rewardBtn.hasEventListener(MouseEvent.CLICK))
                    {
                        this._subscribePanel._rewardBtn.addEventListener(MouseEvent.CLICK, this.onMouseClick);
                    }
                    break;
                }
                case BTN_TYPE_REWARD:
                {
                    _loc_2 = TF_REWARD;
                    this._subscribePanel._subBtn.gotoAndStop("_frameNormal");
                    if (!this._subscribePanel._subBtn.hasEventListener(MouseEvent.CLICK))
                    {
                        this._subscribePanel._subBtn.addEventListener(MouseEvent.CLICK, this.onMouseClick);
                    }
                    this._subscribePanel._rewardBtn.gotoAndStop("_frameNormal");
                    if (!this._subscribePanel._rewardBtn.hasEventListener(MouseEvent.CLICK))
                    {
                        this._subscribePanel._rewardBtn.addEventListener(MouseEvent.CLICK, this.onMouseClick);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._subBtnTf.text = _loc_2;
            this._rewardsSubBtnTf.text = _loc_2;
            this._rewardsSubBtnTf.x = (this._subscribePanel._rewardBtn.width - this._rewardsSubBtnTf.width) * 0.5;
            this._rewardsSubBtnTf.y = (this._subscribePanel._rewardBtn.height - this._rewardsSubBtnTf.height) * 0.5;
            this._subBtnTf.x = (this._subscribePanel._subBtn.width - this._subBtnTf.width) * 0.5;
            this._subBtnTf.y = (this._subscribePanel._subBtn.height - this._subBtnTf.height) * 0.5;
            return;
        }// end function

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            if (!this._userInfoVO.isLogin && this._panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE)
            {
                this.btnType = BTN_TYPE_SUBSCRIBE;
            }
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            this._status.addStatus(param1);
            switch(param1)
            {
                case SubscribeDef.STATUS_OPEN:
                {
                    this.open();
                    break;
                }
                case SubscribeDef.STATUS_SHOW_PROMPT:
                {
                    this._isShowPoint = true;
                    this._isNextframe = true;
                    if (!this._subscribePanel.hasEventListener(Event.ENTER_FRAME))
                    {
                        this._subscribePanel.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                    }
                    if (!this._subscribePanel.hasEventListener(MouseEvent.MOUSE_OVER))
                    {
                        this._subscribePanel.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                        this._subscribePanel.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
                    }
                    this._delayCall = TweenLite.delayedCall(6, this.onDelayCallComplete);
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
                case SubscribeDef.STATUS_OPEN:
                {
                    this.close();
                    break;
                }
                case SubscribeDef.STATUS_SHOW_PROMPT:
                {
                    this.onDelayCallComplete();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new SubscribeEvent(SubscribeEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new SubscribeEvent(SubscribeEvent.Evt_Close));
            }
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            this._subscribePanel.x = param1 - this._subscribePanel.width + 85;
            this._subscribePanel.y = param2 - this._subscribePanel.height - 45;
            return;
        }// end function

        private function initPanel() : void
        {
            this._subscribePanel = new SubscribePanel();
            this._titleTf = FastCreator.createLabel(TF_VIEW_UPDATES, 16777215, 11);
            this._subBtnTf = FastCreator.createLabel(TF_VIEW_UPDATES, 16777215, 11);
            this._rewardTitleTf = FastCreator.createLabel(TF_VIEW_UPDATES, 16777215, 11);
            this._rewardsSubBtnTf = FastCreator.createLabel(TF_VIEW_UPDATES, 16777215, 11);
            var _loc_1:int = 4;
            this._titleTf.y = 4;
            this._rewardTitleTf.y = _loc_1;
            this._subscribePanel._desPanel.addChild(this._titleTf);
            this._subscribePanel._rewardPanel.addChild(this._rewardTitleTf);
            this._rewardsSubBtnTf.x = (this._subscribePanel._rewardBtn.width - this._rewardsSubBtnTf.width) * 0.5;
            this._rewardsSubBtnTf.y = (this._subscribePanel._rewardBtn.height - this._rewardsSubBtnTf.height) * 0.5;
            this._subscribePanel._rewardBtn.addChild(this._rewardsSubBtnTf);
            this._subBtnTf.x = (this._subscribePanel._subBtn.width - this._subBtnTf.width) * 0.5;
            this._subBtnTf.y = (this._subscribePanel._subBtn.height - this._subBtnTf.height) * 0.5;
            this._subscribePanel._subBtn.addChild(this._subBtnTf);
            var _loc_1:Boolean = false;
            this._subBtnTf.mouseEnabled = false;
            this._rewardsSubBtnTf.mouseEnabled = _loc_1;
            this._bitmap = new Bitmap();
            this._subscribePanel._head._bitmapContainer.addChild(this._bitmap);
            var _loc_1:Boolean = true;
            this._subscribePanel._head.buttonMode = true;
            this._subscribePanel._head.useHandCursor = _loc_1;
            var _loc_1:Boolean = true;
            this._subscribePanel._subBtn.buttonMode = true;
            this._subscribePanel._subBtn.useHandCursor = _loc_1;
            var _loc_1:Boolean = true;
            this._subscribePanel._rewardBtn.buttonMode = true;
            this._subscribePanel._rewardBtn.useHandCursor = _loc_1;
            this.btnType = this._btnType;
            addChild(this._subscribePanel);
            this.addEvent();
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function addEvent() : void
        {
            this._subscribePanel.gotoAndStop(1);
            this._subscribePanel._head._bitmapContainer.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._subscribePanel._head._mouseLayer.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseLayerMouseOver);
            this._subscribePanel._subBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._subscribePanel._rewardBtn.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._subscribePanel._head._bitmapContainer.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._subscribePanel._head._mouseLayer.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._subscribePanel._subBtn.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._subscribePanel._rewardBtn.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._subscribePanel._head._bitmapContainer.addEventListener(MouseEvent.CLICK, this.onHeadMouseClick);
            return;
        }// end function

        public function removeEvent() : void
        {
            this._subscribePanel.gotoAndStop(1);
            this._subscribePanel._head._bitmapContainer.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._subscribePanel._head._mouseLayer.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseLayerMouseOver);
            this._subscribePanel._subBtn.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._subscribePanel._rewardBtn.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._subscribePanel._head._bitmapContainer.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._subscribePanel._head._mouseLayer.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._subscribePanel._subBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._subscribePanel._rewardBtn.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._subscribePanel._head._bitmapContainer.removeEventListener(MouseEvent.CLICK, this.onHeadMouseClick);
            return;
        }// end function

        public function setSubscribeInfo(param1:Object) : void
        {
            if (param1)
            {
                this._subInfo = param1;
                this._titleTf.htmlText = StringUtils.remainWord(param1.title, 7);
                this._titleTf.x = (this._subscribePanel._desPanel.width - this._titleTf.width) * 0.5;
                this._rewardTitleTf.htmlText = StringUtils.remainWord(this._rewardObj.rewardInfo, 15);
                this._rewardTitleTf.x = (this._subscribePanel._rewardPanel.width - this._rewardTitleTf.width) * 0.5;
                LoaderManager.instance.loader(param1.headUrl, this.imageComplete);
                if (!isNaN(this._subInfo.subState))
                {
                    this.btnType = uint(this._subInfo.subState);
                }
            }
            return;
        }// end function

        private function imageComplete(param1) : void
        {
            this._bitmap.bitmapData = (param1 as Bitmap).bitmapData;
            return;
        }// end function

        private function onDelayCallComplete() : void
        {
            if (this._delayCall)
            {
                TweenLite.killTweensOf(this.onDelayCallComplete, true);
                this._delayCall = null;
                this._isNextframe = false;
                if (!this._subscribePanel.hasEventListener(Event.ENTER_FRAME))
                {
                    this._subscribePanel.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                }
                dispatchEvent(new SubscribeEvent(SubscribeEvent.Evt_RemovePromptUI));
            }
            return;
        }// end function

        private function onEnterFrame(event:Event) : void
        {
            if (this._isNextframe)
            {
                if (this._subscribePanel.currentFrame == 15)
                {
                    return;
                }
                this._subscribePanel.nextFrame();
                if (this._subscribePanel.currentFrame == 15)
                {
                    this._clipIsOpen = true;
                    if (!this._isShowPoint)
                    {
                        if (this._panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE)
                        {
                            PingBack.getInstance().showActionPing_4_0(PingBackDef.SUBSCRIBE_HOVER_FOLLOW);
                        }
                        else
                        {
                            PingBack.getInstance().showActionPing_4_0(PingBackDef.SUBSCRIBE_HOVER_REWARD);
                        }
                    }
                    else if (this._panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE)
                    {
                        PingBack.getInstance().showActionPing_4_0(PingBackDef.SUBSCRIBE_PROMPT_FOLLOW);
                    }
                    else
                    {
                        PingBack.getInstance().showActionPing_4_0(PingBackDef.SUBSCRIBE_PROMPT_REWARD);
                    }
                    this._subscribePanel.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                }
            }
            else
            {
                this._subscribePanel.prevFrame();
                if (this._subscribePanel.currentFrame == 1)
                {
                    this._isShowPoint = false;
                    this._clipIsOpen = false;
                    this._subscribePanel.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
                    if (this._subscribePanel.hasEventListener(MouseEvent.MOUSE_OVER))
                    {
                        this._subscribePanel.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                        this._subscribePanel.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
                        this._subscribePanel._head._bitmapContainer.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                        this._subscribePanel._head._bitmapContainer.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
                        this._subscribePanel._head._mouseLayer.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseLayerMouseOver);
                        this._subscribePanel._head._mouseLayer.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
                    }
                }
            }
            return;
        }// end function

        private function onMouseLayerMouseOver(event:MouseEvent) : void
        {
            if (this._delayCall)
            {
                TweenLite.killDelayedCallsTo(this.onDelayCallComplete);
            }
            return;
        }// end function

        private function onMouseOver(event:MouseEvent) : void
        {
            this._isNextframe = true;
            if (!this._isShowPoint)
            {
                if (uint(this._subInfo.subState) == 1 && this._rewardObj && this._rewardObj.canReward)
                {
                    this.panelType = SubscribeDef.PANEL_TYPE_REWARD;
                }
                else
                {
                    this.panelType = SubscribeDef.PANEL_TYPE_SUBSCRIBE;
                    if (this._btnType == BTN_TYPE_SUBSCRIBE && event.target == this._subscribePanel._subBtn)
                    {
                        this._subscribePanel._subBtn.gotoAndStop("_frameOver");
                    }
                    if (this._btnType == BTN_TYPE_SUBSCRIBE && event.target == this._subscribePanel._rewardBtn)
                    {
                        this._subscribePanel._rewardBtn.gotoAndStop("_frameOver");
                    }
                }
            }
            else
            {
                if (this._btnType == BTN_TYPE_SUBSCRIBE && event.target == this._subscribePanel._subBtn)
                {
                    this._subscribePanel._subBtn.gotoAndStop("_frameOver");
                }
                if (this._btnType == BTN_TYPE_SUBSCRIBE && event.target == this._subscribePanel._rewardBtn)
                {
                    this._subscribePanel._rewardBtn.gotoAndStop("_frameOver");
                }
            }
            if (!this._subscribePanel.hasEventListener(Event.ENTER_FRAME))
            {
                this._subscribePanel.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            }
            this.onDelayCallComplete();
            dispatchEvent(new SubscribeEvent(SubscribeEvent.Evt_RemovePromptUI));
            return;
        }// end function

        private function onMouseOut(event:MouseEvent) : void
        {
            if (this._btnType == BTN_TYPE_SUBSCRIBE && event.target == this._subscribePanel._subBtn)
            {
                this._subscribePanel._subBtn.gotoAndStop("_frameNormal");
            }
            if (this._btnType == BTN_TYPE_SUBSCRIBE && event.target == this._subscribePanel._rewardBtn)
            {
                this._subscribePanel._rewardBtn.gotoAndStop("_frameNormal");
            }
            this._isNextframe = false;
            if (!this._subscribePanel.hasEventListener(Event.ENTER_FRAME))
            {
                this._subscribePanel.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            }
            if (!this._subscribePanel.hasEventListener(MouseEvent.MOUSE_OVER))
            {
                this._subscribePanel.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                this._subscribePanel.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            }
            dispatchEvent(new SubscribeEvent(SubscribeEvent.Evt_RemovePromptUI));
            return;
        }// end function

        private function onMouseClick(event:MouseEvent) : void
        {
            if (this._btnType == BTN_TYPE_AR_SUBSCRIBE)
            {
                return;
            }
            if (this._btnType == BTN_TYPE_SUBSCRIBE)
            {
                if (!this._userInfoVO.isLogin)
                {
                    GlobalStage.setNormalScreen();
                }
                dispatchEvent(new SubscribeEvent(SubscribeEvent.Evt_BtnAndIconClick));
            }
            else if (this._btnType == BTN_TYPE_REWARD)
            {
                GlobalStage.setNormalScreen();
                dispatchEvent(new SubscribeEvent(SubscribeEvent.Evt_BtnAndIconClick));
            }
            if (!this._isShowPoint)
            {
                if (this._panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE)
                {
                    PingBack.getInstance().userActionPing_4_0(PingBackDef.SUBSCRIBE_HOVER_FOLLOW_CLICK);
                }
                else
                {
                    PingBack.getInstance().userActionPing_4_0(PingBackDef.SUBSCRIBE_HOVER_REWARD_CLICK);
                }
            }
            else if (this._panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE)
            {
                PingBack.getInstance().userActionPing_4_0(PingBackDef.SUBSCRIBE_PROMPT_FOLLOW_CLICK);
            }
            else
            {
                PingBack.getInstance().userActionPing_4_0(PingBackDef.SUBSCRIBE_PROMPT_REWARD_CLICK);
            }
            return;
        }// end function

        private function onHeadMouseClick(event:Event) : void
        {
            if (this._subInfo)
            {
                GlobalStage.setNormalScreen();
                navigateToURL(new URLRequest(this._subInfo.profileUrl), "_blank");
                this._delayCall = TweenLite.delayedCall(6, this.onDelayCallComplete);
            }
            return;
        }// end function

    }
}
