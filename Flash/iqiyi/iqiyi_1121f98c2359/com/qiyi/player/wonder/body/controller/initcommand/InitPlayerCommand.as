package com.qiyi.player.wonder.body.controller.initcommand
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.body.view.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class InitPlayerCommand extends SimpleCommand
    {

        public function InitPlayerCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_8:String = null;
            var _loc_9:String = null;
            var _loc_10:String = null;
            var _loc_11:JavascriptAPIProxy = null;
            var _loc_12:String = null;
            var _loc_13:String = null;
            var _loc_14:JavascriptAPIProxy = null;
            super.execute(param1);
            var _loc_2:* = param1.getBody() as AppView;
            var _loc_3:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_4:* = GlobalStage.stage.stageWidth;
            var _loc_5:* = GlobalStage.stage.stageHeight;
            var _loc_6:* = SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_CONTROL_BAR_ISHIDE) ? (_loc_5) : (_loc_5 - BodyDef.VIDEO_BOTTOM_RESERVE);
            _loc_3.curActor.init(_loc_2.curVideoLayer, FlashVarConfig.useGPU);
            _loc_3.curActor.setArea(0, 0, _loc_4, _loc_6);
            _loc_3.preActor.init(_loc_2.preVideoLayer, FlashVarConfig.useGPU);
            _loc_3.preActor.setArea(0, 0, _loc_4, _loc_6);
            if (!SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_LOGO) || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && FlashVarConfig.os == FlashVarConfig.OS_XP)
            {
                _loc_3.curActor.floatLayer.showLogo = false;
                _loc_3.preActor.floatLayer.showLogo = false;
            }
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                _loc_3.curActor.floatLayer.showBrand = false;
                _loc_3.preActor.floatLayer.showBrand = false;
            }
            var _loc_7:* = UserManager.getInstance().user;
            if (_loc_7)
            {
                if (_loc_7.limitationType == UserDef.USER_LIMITATION_UPPER)
                {
                    sendNotification(FeedbackDef.NOTIFIC_OPEN_CLOSE, true);
                }
                else if (_loc_7.limitationType == UserDef.USER_LIMITATION_CLOSING)
                {
                    _loc_8 = "";
                    _loc_9 = "";
                    _loc_10 = "";
                    if (_loc_3.curActor.loadMovieParams)
                    {
                        _loc_8 = _loc_3.curActor.loadMovieParams.tvid;
                        _loc_9 = _loc_3.curActor.loadMovieParams.vid;
                        _loc_10 = _loc_3.curActor.movieModel ? (_loc_3.curActor.movieModel.albumId) : ("");
                    }
                    _loc_11 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    _loc_11.callJsRecharge(_loc_8, _loc_9, _loc_10, "Q00311");
                }
                else if (_loc_7.limitationType == UserDef.USER_LIMITATION_PERMANENT_CLOSING)
                {
                    _loc_12 = "";
                    _loc_13 = "";
                    if (_loc_3.curActor.loadMovieParams)
                    {
                        _loc_12 = _loc_3.curActor.loadMovieParams.tvid;
                        _loc_13 = _loc_3.curActor.loadMovieParams.vid;
                        _loc_10 = _loc_3.curActor.movieModel ? (_loc_3.curActor.movieModel.albumId) : ("");
                    }
                    _loc_14 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    _loc_14.callJsRecharge(_loc_12, _loc_13, _loc_10, "Q00312");
                }
                else if (FlashVarConfig.autoPlay)
                {
                    sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
                }
                else
                {
                    sendNotification(BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE);
                }
            }
            else if (FlashVarConfig.autoPlay)
            {
                sendNotification(BodyDef.NOTIFIC_INIT_PLAY);
            }
            else
            {
                sendNotification(BodyDef.NOTIFIC_VIDEO_REQUEST_IMAGE);
            }
            return;
        }// end function

    }
}
