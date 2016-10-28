package com.qiyi.player.wonder.body.controller.playercommand
{
    import com.qiyi.player.wonder.body.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class PlayerSeekCommand extends SimpleCommand
    {

        public function PlayerSeekCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = int(param1.getBody().time);
            var _loc_3:* = int(param1.getBody().type);
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            _loc_4.curActor.seek(_loc_2, _loc_3);
            return;
        }// end function

    }
}
