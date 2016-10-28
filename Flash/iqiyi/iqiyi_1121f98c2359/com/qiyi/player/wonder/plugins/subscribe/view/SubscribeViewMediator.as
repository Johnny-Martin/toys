package com.qiyi.player.wonder.plugins.subscribe.view
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.hint.model.*;
    import com.qiyi.player.wonder.plugins.subscribe.*;
    import com.qiyi.player.wonder.plugins.subscribe.model.*;
    import gs.*;
    import gs.easing.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class SubscribeViewMediator extends Mediator
    {
        private var _subscribeProxy:SubscribeProxy;
        private var _playerProxy:PlayerProxy;
        private var _subscribeView:SubscribeView;
        private var _noticeID:String = "";
        public static const NAME:String = "com.qiyi.player.wonder.plugins.subscribe.view.SubscribeViewMediator";

        public function SubscribeViewMediator(param1:SubscribeView)
        {
            super(NAME, param1);
            this._subscribeView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._subscribeProxy = facade.retrieveProxy(SubscribeProxy.NAME) as SubscribeProxy;
            this._playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            this._subscribeView.addEventListener(SubscribeEvent.Evt_Open, this.onSubscribeViewOpen);
            this._subscribeView.addEventListener(SubscribeEvent.Evt_Close, this.onSubscribeViewClose);
            this._subscribeView.addEventListener(SubscribeEvent.Evt_RemovePromptUI, this.onRemovePrompt);
            this._subscribeView.addEventListener(SubscribeEvent.Evt_ShowComplete, this.onShowComplete);
            this._subscribeView.addEventListener(SubscribeEvent.Evt_BtnAndIconClick, this.onBtnAndIconClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [SubscribeDef.NOTIFIC_ADD_STATUS, SubscribeDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_RUNNING, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_JS_CALL_SET_SUBSCRIBE_INFO, BodyDef.NOTIFIC_JS_CALL_SET_SUBSCRIBE_STATE_CHANGE, ControllBarDef.NOTIFIC_ADD_STATUS, ControllBarDef.NOTIFIC_REMOVE_STATUS, ContinuePlayDef.NOTIFIC_ADD_STATUS, ContinuePlayDef.NOTIFIC_REMOVE_STATUS, HintDef.NOTIFIC_ADD_STATUS, HintDef.NOTIFIC_REMOVE_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:Number = NaN;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case SubscribeDef.NOTIFIC_ADD_STATUS:
                {
                    this._subscribeView.onAddStatus(int(_loc_2));
                    if (this._playerProxy && this._playerProxy.curActor.floatLayer && int(_loc_2) == SubscribeDef.STATUS_OPEN)
                    {
                        this._playerProxy.curActor.floatLayer.showBrand = false;
                        this._playerProxy.preActor.floatLayer.showBrand = false;
                    }
                    break;
                }
                case SubscribeDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._subscribeView.onRemoveStatus(int(_loc_2));
                    if (this._playerProxy && this._playerProxy.curActor.floatLayer && int(_loc_2) == SubscribeDef.STATUS_OPEN)
                    {
                        this._playerProxy.curActor.floatLayer.showBrand = true;
                        this._playerProxy.preActor.floatLayer.showBrand = true;
                    }
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._subscribeView.onResize(_loc_2.w, _loc_2.h);
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
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    this.onPlayerRunning(_loc_2.currentTime, _loc_2.bufferTime, _loc_2.duration, _loc_2.playingDuration);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SUBSCRIBE_INFO:
                {
                    this._subscribeProxy.subscribeInfo = _loc_2;
                    this.handleSubscribeStatus();
                    this._subscribeView.setSubscribeInfo(this._subscribeProxy.subscribeInfo);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SUBSCRIBE_STATE_CHANGE:
                {
                    if (this._subscribeProxy.subscribeInfo)
                    {
                        this._subscribeProxy.updateSubscribeInfo(String(_loc_2.subState));
                    }
                    this._subscribeView.setSubscribeInfo(this._subscribeProxy.subscribeInfo);
                    break;
                }
                case ControllBarDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ControllBarDef.STATUS_SEEK_BAR_THICK && !this._subscribeProxy.hasStatus(SubscribeDef.STATUS_SHOW_PROMPT))
                    {
                        TweenLite.killTweensOf(this._subscribeView);
                        TweenLite.to(this._subscribeView, 1, {y:-(ControllBarDef.BAR_WIDTH_WIDE - ControllBarDef.BAR_WIDTH_NARROW), alpha:1, ease:Elastic.easeOut});
                    }
                    break;
                }
                case ControllBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    _loc_5 = 0.3;
                    if (this._subscribeProxy.subscribeInfo && this._subscribeProxy.subscribeInfo.subState == 0)
                    {
                        _loc_5 = 0.3;
                    }
                    else
                    {
                        _loc_5 = 0;
                    }
                    if (int(_loc_2) == ControllBarDef.STATUS_SEEK_BAR_THICK && !this._subscribeView.clipIsOpen && !this._subscribeProxy.hasStatus(SubscribeDef.STATUS_SHOW_PROMPT))
                    {
                        TweenLite.killTweensOf(this._subscribeView);
                        TweenLite.to(this._subscribeView, 0.5, {y:0, alpha:_loc_5});
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == ContinuePlayDef.STATUS_OPEN)
                    {
                        this._subscribeView.removeEvent();
                    }
                    break;
                }
                case ContinuePlayDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == ContinuePlayDef.STATUS_OPEN)
                    {
                        this._subscribeView.addEvent();
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

        private function onSubscribeViewOpen(event:SubscribeEvent) : void
        {
            if (!this._subscribeProxy.hasStatus(SubscribeDef.STATUS_OPEN))
            {
                this._subscribeProxy.addStatus(SubscribeDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onSubscribeViewClose(event:SubscribeEvent) : void
        {
            if (this._subscribeProxy.hasStatus(SubscribeDef.STATUS_OPEN))
            {
                this._subscribeProxy.removeStatus(SubscribeDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onRemovePrompt(event:SubscribeEvent) : void
        {
            if (this._subscribeProxy.hasStatus(SubscribeDef.STATUS_SHOW_PROMPT))
            {
                this._subscribeProxy.removeStatus(SubscribeDef.STATUS_SHOW_PROMPT);
            }
            return;
        }// end function

        private function onShowComplete(event:SubscribeEvent) : void
        {
            var _loc_2:Number = 0.3;
            if (this._subscribeProxy.subscribeInfo && this._subscribeProxy.subscribeInfo.subState == 0)
            {
                _loc_2 = 0.3;
            }
            else
            {
                _loc_2 = 0;
            }
            var _loc_3:* = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            if (!_loc_3.hasStatus(ControllBarDef.STATUS_SEEK_BAR_THICK))
            {
                TweenLite.killTweensOf(this._subscribeView);
                TweenLite.to(this._subscribeView, 0.5, {y:0, alpha:_loc_2});
            }
            return;
        }// end function

        private function onBtnAndIconClick(event:SubscribeEvent) : void
        {
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            if (this._subscribeView.panelType == SubscribeDef.PANEL_TYPE_SUBSCRIBE)
            {
                _loc_2.callJsPgcFollow(0);
            }
            else
            {
                this.sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
                _loc_2.requestReward();
            }
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            var _loc_4:Object = null;
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                {
                    if (param2)
                    {
                        this._subscribeProxy.subscribeInfo = null;
                        this._subscribeProxy.removeStatus(SubscribeDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    if (param2)
                    {
                        this._subscribeProxy.subscribeInfo = null;
                        this._subscribeProxy.removeStatus(SubscribeDef.STATUS_OPEN);
                        _loc_4 = {};
                        _loc_4.canReward = this._playerProxy.curActor.movieInfo.isReward;
                        _loc_4.rewardInfo = this._playerProxy.curActor.movieInfo.infoJSON && this._playerProxy.curActor.movieInfo.infoJSON.rewardMessage ? (this._playerProxy.curActor.movieInfo.infoJSON.rewardMessage) : (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SUBSCRIBE_VIEW_DES5));
                        this._subscribeView.rewardObj = _loc_4;
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
                    if (!param2)
                    {
                        this.handleSubscribeStatus();
                    }
                    else
                    {
                        this._subscribeProxy.removeStatus(SubscribeDef.STATUS_OPEN);
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
            var _loc_1:Object = null;
            if (this._playerProxy.curActor.movieInfo)
            {
                this._subscribeProxy.subscribeInfo = null;
                this._subscribeProxy.removeStatus(SubscribeDef.STATUS_OPEN);
                _loc_1 = {};
                _loc_1.canReward = this._playerProxy.curActor.movieInfo.isReward;
                _loc_1.rewardInfo = this._playerProxy.curActor.movieInfo.infoJSON && this._playerProxy.curActor.movieInfo.infoJSON.rewardMessage ? (this._playerProxy.curActor.movieInfo.infoJSON.rewardMessage) : ("创作不易，喜欢就赏一下哦~");
                this._subscribeView.rewardObj = _loc_1;
            }
            return;
        }// end function

        private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void
        {
            if (this._subscribeView.clipIsOpen)
            {
                return;
            }
            var _loc_5:* = this._playerProxy.curActor.movieModel.trailerTime == 0 ? (param3) : (this._playerProxy.curActor.movieModel.trailerTime);
            if (this._subscribeProxy.subscribeInfo && this._subscribeProxy.subscribeInfo.subState == 0)
            {
                if (param1 >= _loc_5 * SubscribeDef.PROMPT_PLAYING_DURATION - 500 && param1 <= _loc_5 * SubscribeDef.PROMPT_PLAYING_DURATION + 500)
                {
                    this._subscribeView.panelType = SubscribeDef.PANEL_TYPE_SUBSCRIBE;
                    this.checkShowPrompt();
                }
                else if (param1 >= _loc_5 * SubscribeDef.PROMPT_PLAYING_POINT - 500 && param1 <= _loc_5 * SubscribeDef.PROMPT_PLAYING_POINT + 500)
                {
                    if (this._playerProxy.curActor.movieInfo.isReward)
                    {
                        this._subscribeView.panelType = SubscribeDef.PANEL_TYPE_REWARD;
                    }
                    else
                    {
                        this._subscribeView.panelType = SubscribeDef.PANEL_TYPE_SUBSCRIBE;
                    }
                    this.checkShowPrompt();
                }
            }
            else if (this._playerProxy.curActor.movieInfo.isReward)
            {
                if (param1 >= _loc_5 * SubscribeDef.PROMPT_PLAYING_POINT - 500 && param1 <= _loc_5 * SubscribeDef.PROMPT_PLAYING_POINT + 500)
                {
                    this._subscribeView.panelType = SubscribeDef.PANEL_TYPE_REWARD;
                    this.checkShowPrompt();
                }
            }
            else
            {
                this._subscribeProxy.removeStatus(SubscribeDef.STATUS_SHOW_PROMPT);
            }
            return;
        }// end function

        private function checkShowPrompt() : void
        {
            TweenLite.killTweensOf(this._subscribeView);
            TweenLite.to(this._subscribeView, 1, {y:-(ControllBarDef.BAR_WIDTH_WIDE - ControllBarDef.BAR_WIDTH_NARROW), alpha:1, ease:Elastic.easeOut, onComplete:this.onComplete});
            return;
        }// end function

        private function onComplete() : void
        {
            this._subscribeProxy.addStatus(SubscribeDef.STATUS_SHOW_PROMPT);
            return;
        }// end function

        private function checkShowSubscribe() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            var _loc_2:* = facade.retrieveProxy(HintProxy.NAME) as HintProxy;
            if ((!_loc_1.hasStatus(ADDef.STATUS_LOADING) || !_loc_1.hasStatus(ADDef.STATUS_PLAYING) || !_loc_1.hasStatus(ADDef.STATUS_PAUSED)) && !_loc_2.hasStatus(HintDef.STATUS_OPEN) && this._subscribeProxy.subscribeInfo)
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
            this.handleSubscribeStatus();
            this._subscribeView.onUserInfoChanged(_loc_2);
            return;
        }// end function

        private function handleSubscribeStatus() : void
        {
            if (this.checkShowSubscribe())
            {
                this._subscribeProxy.addStatus(SubscribeDef.STATUS_OPEN);
            }
            else
            {
                this._subscribeProxy.removeStatus(SubscribeDef.STATUS_OPEN);
            }
            return;
        }// end function

    }
}
