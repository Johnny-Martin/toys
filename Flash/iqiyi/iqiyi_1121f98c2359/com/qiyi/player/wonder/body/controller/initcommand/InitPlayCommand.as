package com.qiyi.player.wonder.body.controller.initcommand
{
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.config.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class InitPlayCommand extends SimpleCommand
    {

        public function InitPlayCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_2:LoadMovieParams = null;
            super.execute(param1);
            if (FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT && FlashVarConfig.vid != "")
            {
                _loc_2 = new LoadMovieParams();
                _loc_2.tvid = FlashVarConfig.tvid;
                _loc_2.vid = FlashVarConfig.vid;
                _loc_2.movieIsMember = FlashVarConfig.isMemberMovie;
                _loc_2.albumId = FlashVarConfig.albumId;
                if (FlashVarConfig.shareStartTime >= 0)
                {
                    _loc_2.startTime = FlashVarConfig.shareStartTime;
                }
                if (FlashVarConfig.shareEndTime > 0)
                {
                    _loc_2.endTime = FlashVarConfig.shareEndTime;
                }
                sendNotification(BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE, _loc_2, BodyDef.LOAD_MOVIE_TYPE_ORIGINAL);
            }
            facade.removeCommand(BodyDef.NOTIFIC_INIT_PLAY);
            return;
        }// end function

    }
}
