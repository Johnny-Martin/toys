package com.qiyi.player.wonder.plugins.scenetile.view
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.*;
    import com.qiyi.player.wonder.plugins.videolink.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class SceneTileScoreViewMediator extends Mediator
    {
        private var _sceneTileProxy:SceneTileProxy;
        private var _sceneTileScoreView:SceneTileScoreView;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileScoreViewMediator";

        public function SceneTileScoreViewMediator(param1:SceneTileScoreView)
        {
            super(NAME, param1);
            this._sceneTileScoreView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._sceneTileProxy = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            this._sceneTileScoreView.addEventListener(SceneTileEvent.Evt_ScoreOpen, this.onSceneTileScoreViewOpen);
            this._sceneTileScoreView.addEventListener(SceneTileEvent.Evt_ScoreSuccessOpen, this.onSceneTileScoreSuccessViewOpen);
            this._sceneTileScoreView.addEventListener(SceneTileEvent.Evt_ScoreClose, this.onSceneTileScoreViewClose);
            this._sceneTileScoreView.addEventListener(SceneTileEvent.Evt_ScoreHeartClick, this.onScoreHeartClick);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [SceneTileDef.NOTIFIC_ADD_STATUS, SceneTileDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, VideoLinkDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:PlayerProxy = null;
            var _loc_6:String = null;
            var _loc_7:UserProxy = null;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case SceneTileDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == SceneTileDef.STATUS_SCORE_OPEN)
                    {
                        _loc_5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                        if (_loc_5.curActor.movieModel)
                        {
                            _loc_6 = "";
                            if (_loc_5.curActor.movieInfo.channel == ChannelEnum.FILM)
                            {
                                _loc_6 = _loc_5.curActor.movieInfo.title;
                            }
                            else
                            {
                                _loc_6 = _loc_5.curActor.movieInfo.albumName ? (_loc_5.curActor.movieInfo.albumName) : (_loc_5.curActor.movieInfo.title);
                            }
                            this._sceneTileScoreView.initScorePanel(_loc_6, this._sceneTileProxy.curScoreNum);
                        }
                        PingBack.getInstance().userActionPing(PingBackDef.SCORE_PANEL_SHOW);
                    }
                    else if (int(_loc_2) == SceneTileDef.STATUS_SCORE_SUCCESS_OPEN)
                    {
                        _loc_7 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
                        this._sceneTileScoreView.initScoreSuccessPanel(_loc_7.isLogin);
                    }
                    this._sceneTileScoreView.onAddStatus(int(_loc_2));
                    break;
                }
                case SceneTileDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._sceneTileScoreView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._sceneTileScoreView.onResize(_loc_2.w, _loc_2.h);
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
                    this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_OPEN);
                    var _loc_8:Boolean = false;
                    this._sceneTileProxy.isScored = false;
                    this._sceneTileProxy.isOpen = _loc_8;
                    this._sceneTileProxy.selectedScore = -1;
                    break;
                }
                case VideoLinkDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == VideoLinkDef.STATUS_OPEN)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_OPEN);
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

        private function onSceneTileScoreViewOpen(event:SceneTileEvent) : void
        {
            if (!this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_OPEN))
            {
                this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCORE_OPEN);
            }
            return;
        }// end function

        private function onSceneTileScoreSuccessViewOpen(event:SceneTileEvent) : void
        {
            if (!this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN))
            {
                this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
            }
            return;
        }// end function

        private function onSceneTileScoreViewClose(event:SceneTileEvent) : void
        {
            if (this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_OPEN))
            {
                this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_OPEN);
            }
            if (this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN))
            {
                this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
            }
            return;
        }// end function

        private function onScoreHeartClick(event:SceneTileEvent) : void
        {
            this._sceneTileProxy.isScored = true;
            this._sceneTileProxy.selectedScore = int(event.data) + 1;
            PingBack.getInstance().sendFilmScore(this._sceneTileProxy.selectedScore);
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_3:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            if (!_loc_2.isLogin)
            {
                GlobalStage.setNormalScreen();
                _loc_3.callJsShowLoginPanel(BodyDef.JS_LOGIN_STATUS_SOURCE_SCORE);
            }
            else
            {
                PingBack.getInstance().sendFilmScoreRecommend(this._sceneTileProxy.selectedScore);
                if (this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN))
                {
                    this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
                }
                this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
            }
            _loc_3.callJsUserClickScore(this._sceneTileProxy.selectedScore);
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
                case BodyDef.PLAYER_STATUS_STOPED:
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_OPEN);
                        var _loc_4:Boolean = false;
                        this._sceneTileProxy.isScored = false;
                        this._sceneTileProxy.isOpen = _loc_4;
                        this._sceneTileProxy.selectedScore = -1;
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
            if (_loc_1.loginSource == BodyDef.JS_LOGIN_STATUS_SOURCE_SCORE && this._sceneTileProxy.selectedScore > 0)
            {
                _loc_1.loginSource = "";
                PingBack.getInstance().sendFilmScore(this._sceneTileProxy.selectedScore);
                PingBack.getInstance().sendFilmScoreRecommend(this._sceneTileProxy.selectedScore);
                if (this._sceneTileProxy.hasStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN))
                {
                    this._sceneTileProxy.removeStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
                }
                this._sceneTileProxy.addStatus(SceneTileDef.STATUS_SCORE_SUCCESS_OPEN);
            }
            this._sceneTileScoreView.onUserInfoChanged(_loc_2);
            return;
        }// end function

    }
}
