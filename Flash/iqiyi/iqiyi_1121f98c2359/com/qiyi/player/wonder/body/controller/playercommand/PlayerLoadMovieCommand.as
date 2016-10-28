package com.qiyi.player.wonder.body.controller.playercommand
{
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class PlayerLoadMovieCommand extends SimpleCommand
    {

        public function PlayerLoadMovieCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_6:UserProxy = null;
            super.execute(param1);
            var _loc_2:* = (param1.getBody() as LoadMovieParams).clone();
            var _loc_3:* = param1.getType();
            var _loc_4:* = param1.getName();
            var _loc_5:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_6 = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            _loc_2.recordHistory = true;
            _loc_2.prepareToPlayEnd = BodyDef.PLAYER_PREPARE_TO_PLAY_END_TIME;
            _loc_2.prepareLeaveSkipPoint = BodyDef.FILTER_OUT_ENJOYABLE_TIME;
            _loc_2.collectionID = FlashVarConfig.collectionID;
            if (_loc_6.isLogin && _loc_6.userLevel != UserDef.USER_LEVEL_NORMAL)
            {
                _loc_2.autoDefinitionlimit = DefinitionEnum.FULL_HD;
            }
            else
            {
                _loc_2.autoDefinitionlimit = DefinitionEnum.HIGH;
            }
            if (_loc_4 == BodyDef.NOTIFIC_PLAYER_LOAD_MOVIE)
            {
                _loc_5.curActor.loadMovie(_loc_2, _loc_3);
            }
            else if (_loc_4 == BodyDef.NOTIFIC_PLAYER_PRE_LOAD_MOVIE)
            {
                _loc_5.preActor.loadMovie(_loc_2, _loc_3);
            }
            return;
        }// end function

    }
}
