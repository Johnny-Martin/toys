package com.qiyi.player.wonder.body.controller.playercommand
{
    import com.qiyi.player.wonder.body.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class PlayerReplayCommand extends SimpleCommand
    {

        public function PlayerReplayCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_2.curActor.replay();
            return;
        }// end function

    }
}
