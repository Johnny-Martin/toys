package com.qiyi.player.wonder.plugins.loading.view
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.loading.*;
    import com.qiyi.player.wonder.plugins.loading.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class LoadingViewMediator extends Mediator
    {
        private var _loadingProxy:LoadingProxy;
        private var _loadingView:LoadingView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.loading.view.LoadingViewMediator";

        public function LoadingViewMediator(param1:LoadingView)
        {
            super(NAME, param1);
            this._loadingView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._loadingProxy = facade.retrieveProxy(LoadingProxy.NAME) as LoadingProxy;
            this._loadingView.addEventListener(LoadingEvent.Evt_Open, this.onLoadingViewOpen);
            this._loadingView.addEventListener(LoadingEvent.Evt_Close, this.onLoadingViewClose);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [LoadingDef.NOTIFIC_ADD_STATUS, LoadingDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_REMOVE_STATUS, BodyDef.NOTIFIC_PLAYER_START_REFRESH, ADDef.NOTIFIC_ADD_STATUS, ADDef.NOTIFIC_REMOVE_STATUS, HintDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case LoadingDef.NOTIFIC_ADD_STATUS:
                {
                    this._loadingView.onAddStatus(int(_loc_2));
                    break;
                }
                case LoadingDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._loadingView.onRemoveStatus(int(_loc_2));
                    if (int(_loc_2) == LoadingDef.STATUS_OPEN)
                    {
                        this._loadingProxy.isFirstLoading = false;
                    }
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._loadingView.onResize(_loc_2.w, _loc_2.h);
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
                case BodyDef.NOTIFIC_PLAYER_START_REFRESH:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.updatePreloaderURL();
                        this._loadingProxy.addStatus(LoadingDef.STATUS_OPEN);
                    }
                    break;
                }
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    this.onADStatusChanged(int(_loc_2), true);
                    break;
                }
                case ADDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onADStatusChanged(int(_loc_2), false);
                    break;
                }
                case HintDef.NOTIFIC_ADD_STATUS:
                {
                    this.onHintStatusChanged(int(_loc_2));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onLoadingViewOpen(event:LoadingEvent) : void
        {
            if (!this._loadingProxy.hasStatus(LoadingDef.STATUS_OPEN))
            {
                this._loadingProxy.addStatus(LoadingDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onLoadingViewClose(event:LoadingEvent) : void
        {
            if (this._loadingProxy.hasStatus(LoadingDef.STATUS_OPEN))
            {
                this._loadingProxy.removeStatus(LoadingDef.STATUS_OPEN);
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
            this._loadingView.onUserInfoChanged(_loc_2);
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
                        this.updatePreloaderURL();
                        this._loadingProxy.addStatus(LoadingDef.STATUS_OPEN);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        this._loadingProxy.removeStatus(LoadingDef.STATUS_OPEN);
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
                case ADDef.STATUS_LOADING:
                {
                    if (param2)
                    {
                        this.updatePreloaderURL();
                        this._loadingProxy.addStatus(LoadingDef.STATUS_OPEN);
                    }
                    break;
                }
                case ADDef.STATUS_PLAYING:
                {
                    if (param2)
                    {
                        this._loadingProxy.removeStatus(LoadingDef.STATUS_OPEN);
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

        private function onHintStatusChanged(param1:int) : void
        {
            switch(param1)
            {
                case HintDef.STATUS_PLAYING:
                {
                    this._loadingProxy.removeStatus(LoadingDef.STATUS_OPEN);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function updatePreloaderURL() : void
        {
            var _loc_3:ContinueInfo = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            if (_loc_1.curActor && _loc_1.curActor.loadMovieParams)
            {
                if (_loc_1.curActor.loadMovieParams.movieIsMember)
                {
                    this._loadingView.updatePreloaderURL(FlashVarConfig.preloaderVipURL);
                }
                else if (this._loadingProxy.isFirstLoading)
                {
                    if (FlashVarConfig.qiyiProduced == "1" && FlashVarConfig.qiyiProducedPreloader != "")
                    {
                        this._loadingView.updatePreloaderURL(FlashVarConfig.qiyiProducedPreloader);
                    }
                    else if (FlashVarConfig.exclusive == "1" && FlashVarConfig.exclusivePreloader != "")
                    {
                        this._loadingView.updatePreloaderURL(FlashVarConfig.exclusivePreloader);
                    }
                    else
                    {
                        this._loadingView.updatePreloaderURL(FlashVarConfig.preloaderURL);
                    }
                }
                else
                {
                    _loc_3 = _loc_2.findContinueInfo(_loc_1.curActor.loadMovieParams.tvid, _loc_1.curActor.loadMovieParams.vid);
                    if (_loc_3 != null && _loc_3.qiyiProduced == "1" && FlashVarConfig.qiyiProducedPreloader != "")
                    {
                        this._loadingView.updatePreloaderURL(FlashVarConfig.qiyiProducedPreloader);
                    }
                    else if (_loc_3 != null && _loc_3.exclusive == "1" && FlashVarConfig.exclusivePreloader != "")
                    {
                        this._loadingView.updatePreloaderURL(FlashVarConfig.exclusivePreloader);
                    }
                    else
                    {
                        this._loadingView.updatePreloaderURL(FlashVarConfig.preloaderURL);
                    }
                }
            }
            else
            {
                this._loadingView.updatePreloaderURL(FlashVarConfig.preloaderURL);
            }
            return;
        }// end function

    }
}
