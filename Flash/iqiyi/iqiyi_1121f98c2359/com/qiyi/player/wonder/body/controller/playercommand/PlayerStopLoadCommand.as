package com.qiyi.player.wonder.body.controller.playercommand
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class PlayerStopLoadCommand extends SimpleCommand
    {

        public function PlayerStopLoadCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = param1.getName();
            var _loc_3:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2 == BodyDef.NOTIFIC_PLAYER_STOP_LOAD)
            {
                _loc_3.curActor.stopLoad();
            }
            else if (_loc_2 == BodyDef.NOTIFIC_PLAYER_PRE_STOP_LOAD)
            {
                _loc_3.preActor.stopLoad();
            }
            return;
        }// end function

    }
}
