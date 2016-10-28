package com.qiyi.player.wonder
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.controller.*;
    import com.qiyi.player.wonder.body.controller.initcommand.*;
    import com.qiyi.player.wonder.body.controller.jscommand.*;
    import com.qiyi.player.wonder.body.controller.playercommand.*;
    import com.qiyi.player.wonder.body.controller.usercommand.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.dock.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.loading.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.share.*;
    import com.qiyi.player.wonder.plugins.subscribe.*;
    import com.qiyi.player.wonder.plugins.tips.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import com.qiyi.player.wonder.plugins.videolink.*;
    import org.puremvc.as3.patterns.facade.*;

    public class AppFacade extends Facade
    {
        public static var _instance:AppFacade;

        public function AppFacade(param1:SingletonClass)
        {
            this.initializePingBack();
            this.initializePlugins();
            return;
        }// end function

        public function startup(param1:Object) : void
        {
            sendNotification(BodyDef.NOTIFIC_STARTUP, param1);
            return;
        }// end function

        override protected function initializeController() : void
        {
            super.initializeController();
            registerCommand(BodyDef.NOTIFIC_STARTUP, StartupCommand);
            registerCommand(BodyDef.NOTIFIC_CHECK_USER, CheckUserCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE, PlayerLoadMovieCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_LOAD_MOVIE, PlayerLoadMovieCommand);
            registerCommand(BodyDef.NOTIFIC_INIT_PLAYER, InitPlayerCommand);
            registerCommand(BodyDef.NOTIFIC_INIT_PLAY, InitPlayCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_PAUSE, PlayerPauseCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_PLAY, PlayerPlayCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_REFRESH, PlayerRefreshCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_REFRESH, PlayerRefreshCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_REPLAY, PlayerReplayCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_RESUME, PlayerResumeCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_SEEK, PlayerSeekCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_START_LOAD, PlayerStartLoadCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_START_LOAD, PlayerStartLoadCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_STOP_LOAD, PlayerStopLoadCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_STOP_LOAD, PlayerStopLoadCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_STOP, PlayerStopCommand);
            registerCommand(BodyDef.NOTIFIC_PLAYER_PRE_STOP, PlayerStopCommand);
            registerCommand(BodyDef.NOTIFIC_CHECK_TRY_WATCH_REFRESH, CheckTryWatchRefreshCommand);
            registerCommand(BodyDef.NOTIFIC_CALL_JS_PLAYER_STATUS, CallJSPlayerStatusCommand);
            ADPlugins.getInstance().initController();
            ContinuePlayPlugins.getInstance().initController();
            ControllBarPlugins.getInstance().initController();
            DockPlugins.getInstance().initController();
            FeedbackPlugins.getInstance().initController();
            LoadingPlugins.getInstance().initController();
            OfflineWatchPlugins.getInstance().initController();
            RecommendPlugins.getInstance().initController();
            SceneTilePlugins.getInstance().initController();
            SettingPlugins.getInstance().initController();
            SharePlugins.getInstance().initController();
            TipsPlugins.getInstance().initController();
            TopBarPlugins.getInstance().initController();
            VideoLinkPlugins.getInstance().initController();
            SubscribePlugins.getInstance().initController();
            HintPlugins.getInstance().initController();
            return;
        }// end function

        private function initializePingBack() : void
        {
            PingBack.getInstance().init(this);
            return;
        }// end function

        private function initializePlugins() : void
        {
            ADPlugins.getInstance().init(this);
            ContinuePlayPlugins.getInstance().init(this);
            ControllBarPlugins.getInstance().init(this);
            DockPlugins.getInstance().init(this);
            FeedbackPlugins.getInstance().init(this);
            LoadingPlugins.getInstance().init(this);
            OfflineWatchPlugins.getInstance().init(this);
            RecommendPlugins.getInstance().init(this);
            SceneTilePlugins.getInstance().init(this);
            SettingPlugins.getInstance().init(this);
            SharePlugins.getInstance().init(this);
            TipsPlugins.getInstance().init(this);
            TopBarPlugins.getInstance().init(this);
            VideoLinkPlugins.getInstance().init(this);
            SubscribePlugins.getInstance().init(this);
            HintPlugins.getInstance().init(this);
            return;
        }// end function

        public static function getInstance() : AppFacade
        {
            if (_instance == null)
            {
                _instance = new AppFacade(new SingletonClass());
            }
            return _instance;
        }// end function

    }
}

class SingletonClass extends Object
{

    function SingletonClass()
    {
        return;
    }// end function

}

