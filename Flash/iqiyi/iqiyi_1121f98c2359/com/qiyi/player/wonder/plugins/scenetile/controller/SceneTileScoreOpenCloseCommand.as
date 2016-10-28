package com.qiyi.player.wonder.plugins.scenetile.controller
{
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class SceneTileScoreOpenCloseCommand extends SimpleCommand
    {

        public function SceneTileScoreOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_7:String = null;
            var _loc_8:Number = NaN;
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(SceneTileProxy.NAME) as SceneTileProxy;
            var _loc_3:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_4:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            var _loc_5:* = UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("");
            var _loc_6:* = UserManager.getInstance().user ? (UserManager.getInstance().user.profileID) : ("");
            if (_loc_3.curActor.movieModel && Boolean(param1.getBody()) && !LocalizaEnum.isTWLocalize(FlashVarConfig.localize))
            {
                _loc_7 = "";
                if (_loc_3.curActor.movieModel.channelID == ChannelEnum.FILM.id)
                {
                    _loc_7 = _loc_3.curActor.movieModel.tvid;
                    _loc_8 = 2;
                }
                else
                {
                    _loc_7 = _loc_3.curActor.movieModel.albumId;
                    _loc_8 = 1;
                }
                _loc_2.requestScored(_loc_7, _loc_5, _loc_3.curActor.uuid, _loc_6, _loc_8);
            }
            return;
        }// end function

    }
}
