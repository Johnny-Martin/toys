package com.qiyi.player.wonder.body.controller
{
    import com.qiyi.player.wonder.body.model.*;
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
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class PrepModelCommand extends SimpleCommand
    {

        public function PrepModelCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = new JavascriptAPIProxy();
            facade.registerProxy(_loc_2);
            var _loc_3:* = new UserProxy();
            facade.registerProxy(_loc_3);
            var _loc_4:* = new PlayerProxy();
            facade.registerProxy(_loc_4);
            _loc_2.injectUserProxy(_loc_3);
            _loc_2.injectPlayerProxy(_loc_4);
            _loc_3.injectPlayerProxy(_loc_4);
            ADPlugins.getInstance().initModel();
            ContinuePlayPlugins.getInstance().initModel();
            ControllBarPlugins.getInstance().initModel();
            DockPlugins.getInstance().initModel();
            FeedbackPlugins.getInstance().initModel();
            LoadingPlugins.getInstance().initModel();
            OfflineWatchPlugins.getInstance().initModel();
            RecommendPlugins.getInstance().initModel();
            SceneTilePlugins.getInstance().initModel();
            SettingPlugins.getInstance().initModel();
            SharePlugins.getInstance().initModel();
            TipsPlugins.getInstance().initModel();
            TopBarPlugins.getInstance().initModel();
            VideoLinkPlugins.getInstance().initModel();
            SubscribePlugins.getInstance().initModel();
            HintPlugins.getInstance().initModel();
            return;
        }// end function

    }
}
