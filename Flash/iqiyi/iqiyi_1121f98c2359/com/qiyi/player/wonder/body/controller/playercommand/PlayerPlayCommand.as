package com.qiyi.player.wonder.body.controller.playercommand
{
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class PlayerPlayCommand extends SimpleCommand
    {

        public function PlayerPlayCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_2.curActor.play();
            PingBack.getInstance().playStartPing();
            PingBack.getInstance().startVisitsPing();
            return;
        }// end function

    }
}
