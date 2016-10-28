package com.qiyi.player.wonder.body.controller.playercommand
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class PlayerPauseCommand extends SimpleCommand
    {

        public function PlayerPauseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_3:int = 0;
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_PLAYING) || _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_SEEKING) || _loc_2.curActor.hasStatus(BodyDef.PLAYER_STATUS_WAITING))
            {
                _loc_3 = param1.getBody() == null ? (0) : (int(param1.getBody()));
                _loc_2.curActor.pause(_loc_3);
                PingBack.getInstance().userActionPing(PingBackDef.PAUSE, _loc_2.curActor.currentTime);
            }
            return;
        }// end function

    }
}
