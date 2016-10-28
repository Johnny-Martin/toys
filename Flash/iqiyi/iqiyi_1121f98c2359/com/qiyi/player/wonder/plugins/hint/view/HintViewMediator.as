package com.qiyi.player.wonder.plugins.hint.view
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.hint.model.*;
    import flash.events.*;
    import flash.geom.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class HintViewMediator extends Mediator
    {
        private var _hintProxy:HintProxy;
        private var _hintView:HintView;
        private var _log:ILogger;
        private var _playerProxy:PlayerProxy;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.hint.view.HintViewMediator";

        public function HintViewMediator(param1:HintView)
        {
            this._log = Log.getLogger(NAME);
            super(NAME, param1);
            this._hintView = param1;
            this._hintView.addEventListener(HintEvent.Evt_Status_Paused, this.pausedHandler);
            this._hintView.addEventListener(HintEvent.Evt_Status_Playing, this.playingHandler);
            this._hintView.addEventListener(HintEvent.Evt_Status_Stop, this.stopHandler);
            Settings.instance.addEventListener(Settings.Evt_MuteChanged, this.onVolumeChanged);
            Settings.instance.addEventListener(Settings.Evt_VolumeChanged, this.onVolumeChanged);
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._hintProxy = facade.retrieveProxy(HintProxy.NAME) as HintProxy;
            this._playerProxy = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [HintDef.NOTIFIC_ADD_STATUS, HintDef.NOTIFIC_REMOVE_STATUS, HintDef.NOTIFIC_HINT_PAUSE, HintDef.NOTIFIC_HINT_RESUME, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_FULL_SCREEN, BodyDef.NOTIFIC_JS_CALL_PAUSE, BodyDef.NOTIFIC_JS_CALL_RESUME, BodyDef.NOTIFIC_JS_CALL_REPLAY, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE, BodyDef.NOTIFIC_PLAYER_AREA_CHANGED, BodyDef.NOTIFIC_PLAYER_HistoryReady];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case HintDef.NOTIFIC_ADD_STATUS:
                {
                    this._hintView.hintURL = this._playerProxy.curActor.movieModel.hintUrl;
                    this._hintView.onAddStatus(int(_loc_2));
                    if (int(_loc_2) == HintDef.STATUS_OPEN)
                    {
                        this._hintView.onResize(this._playerProxy.curActor.realArea.width > 0 ? (this._playerProxy.curActor.realArea) : (this._playerProxy.curActor.settingArea));
                        this._hintView.onVolumeChanged(Settings.instance.mute, Settings.instance.volumn);
                    }
                    break;
                }
                case HintDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._hintView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_PAUSE:
                {
                    this._hintProxy.addStatus(HintDef.STATUS_PAUSED);
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_RESUME:
                {
                    this._hintProxy.addStatus(HintDef.STATUS_PLAYING);
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._hintView.onResize(this._playerProxy.curActor.realArea.width > 0 ? (this._playerProxy.curActor.realArea) : (this._playerProxy.curActor.settingArea));
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE:
                {
                    this._log.info(" hint ： change movie ,remove hintview");
                    this._hintProxy.removeStatus(HintDef.STATUS_OPEN);
                    this._hintProxy.historyReady = false;
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_AREA_CHANGED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this._hintView.onResize(this._playerProxy.curActor.realArea.width > 0 ? (this._playerProxy.curActor.realArea) : (this._playerProxy.curActor.settingArea));
                    }
                    break;
                }
                case HintDef.NOTIFIC_HINT_PAUSE:
                {
                    this._hintProxy.addStatus(HintDef.STATUS_PAUSED);
                    break;
                }
                case HintDef.NOTIFIC_HINT_RESUME:
                {
                    this._hintProxy.addStatus(HintDef.STATUS_PLAYING);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_HistoryReady:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this._hintProxy.historyReady = true;
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

        private function pausedHandler(event:HintEvent) : void
        {
            this._hintProxy.addStatus(HintDef.STATUS_PAUSED);
            return;
        }// end function

        private function playingHandler(event:HintEvent) : void
        {
            this._hintProxy.addStatus(HintDef.STATUS_PLAYING);
            return;
        }// end function

        private function stopHandler(event:HintEvent) : void
        {
            this._log.info(" hint ： hint stop , remove hintview");
            this._hintProxy.removeStatus(HintDef.STATUS_OPEN);
            if (this._hintProxy.replay)
            {
                sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAY);
            }
            else
            {
                sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
            }
            return;
        }// end function

        private function onVolumeChanged(event:Event = null) : void
        {
            this._hintView.onVolumeChanged(Settings.instance.mute, Settings.instance.volumn);
            return;
        }// end function

    }
}
