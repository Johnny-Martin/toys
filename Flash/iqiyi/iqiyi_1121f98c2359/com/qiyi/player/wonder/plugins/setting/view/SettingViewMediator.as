package com.qiyi.player.wonder.plugins.setting.view
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.impls.subtitle.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class SettingViewMediator extends Mediator
    {
        private var _settingProxy:SettingProxy;
        private var _settingView:SettingView;
        private var _titleSettingMouseOvered:Boolean = false;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.SettingViewMediator";

        public function SettingViewMediator(param1:SettingView)
        {
            super(NAME, param1);
            this._settingView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            this._settingProxy = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            this._settingView.addEventListener(SettingEvent.Evt_Open, this.onSettingViewOpen);
            this._settingView.addEventListener(SettingEvent.Evt_Close, this.onSettingViewClose);
            this._settingView.subtitles.addEventListener(SettingEvent.Evt_TitleLanguageChanged, this.onLanguageChanged);
            this._settingView.subtitles.addEventListener(SettingEvent.Evt_TitleFontColorChanged, this.onFontColorChanged);
            this._settingView.subtitles.addEventListener(SettingEvent.Evt_TitleFontSizeChanged, this.onFontSizeChanged);
            this._settingView.soundTrackLanguage.addEventListener(SettingEvent.Evt_AudioTrackChanged, this.onAudioTrackChanged);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [SettingDef.NOTIFIC_ADD_STATUS, SettingDef.NOTIFIC_REMOVE_STATUS, TopBarDef.NOTIFIC_SCREEN_SCALE_CHANGE, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_CHECK_USER_COMPLETE];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_5:PlayerProxy = null;
            var _loc_6:Vector.<IAudioTrackInfo> = null;
            var _loc_7:Vector.<Language> = null;
            var _loc_8:uint = 0;
            super.handleNotification(param1);
            var _loc_2:* = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case SettingDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == SettingDef.STATUS_OPEN)
                    {
                        _loc_5 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                        _loc_6 = new Vector.<IAudioTrackInfo>;
                        _loc_7 = new Vector.<Language>;
                        _loc_8 = 0;
                        while (_loc_8 < _loc_5.curActor.movieModel.audioTrackCount)
                        {
                            
                            _loc_6.push(_loc_5.curActor.movieModel.getAudioTrackInfoAt(_loc_8));
                            _loc_8 = _loc_8 + 1;
                        }
                        _loc_8 = 0;
                        while (_loc_8 < _loc_5.curActor.movieModel.subtitles.length)
                        {
                            
                            _loc_7.push(_loc_5.curActor.movieModel.subtitles[_loc_8]);
                            _loc_8 = _loc_8 + 1;
                        }
                        this._settingView.setSubtitlesLangType(_loc_5.curActor.movieModel.curSubtitlesType, _loc_7);
                        this._settingView.setSoundTrackLang(_loc_5.curActor.movieModel.curAudioTrackInfo, _loc_6);
                        sendNotification(ADDef.NOTIFIC_POPUP_OPEN);
                    }
                    this._settingView.onAddStatus(int(_loc_2));
                    break;
                }
                case SettingDef.NOTIFIC_REMOVE_STATUS:
                {
                    if (int(_loc_2) == SettingDef.STATUS_OPEN)
                    {
                        sendNotification(ADDef.NOTIFIC_POPUP_CLOSE);
                    }
                    this._settingView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case TopBarDef.NOTIFIC_SCREEN_SCALE_CHANGE:
                {
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._settingView.onResize(_loc_2.w, _loc_2.h);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this._settingProxy.removeStatus(SettingDef.STATUS_OPEN);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
                {
                    this.onPlayerStatusChanged(int(_loc_2), true, _loc_4);
                    break;
                }
                case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
                {
                    this.onCheckUserComplete();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onSettingViewOpen(event:SettingEvent) : void
        {
            if (!this._settingProxy.hasStatus(SettingDef.STATUS_OPEN))
            {
                this._settingProxy.addStatus(SettingDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onSettingViewClose(event:SettingEvent) : void
        {
            if (this._settingProxy.hasStatus(SettingDef.STATUS_OPEN))
            {
                this._settingProxy.removeStatus(SettingDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onLanguageChanged(event:SettingEvent) : void
        {
            Settings.instance.subtitleLang = event.data as EnumItem;
            return;
        }// end function

        private function onFontColorChanged(event:SettingEvent) : void
        {
            Settings.instance.subtitleColor = int(event.data);
            return;
        }// end function

        private function onFontSizeChanged(event:SettingEvent) : void
        {
            Settings.instance.subtitleSize = int(event.data);
            return;
        }// end function

        private function onAudioTrackChanged(event:SettingEvent) : void
        {
            Settings.instance.audioTrack = event.data as EnumItem;
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
            this._settingView.onUserInfoChanged(_loc_2);
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
                case BodyDef.PLAYER_STATUS_FAILED:
                case BodyDef.PLAYER_STATUS_STOPED:
                {
                    if (param2)
                    {
                        this._settingProxy.removeStatus(SettingDef.STATUS_OPEN);
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

    }
}
