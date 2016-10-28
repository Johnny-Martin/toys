package com.qiyi.player.wonder.body.controller
{
    import com.qiyi.player.wonder.body.view.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class PrepViewCommand extends SimpleCommand
    {

        public function PrepViewCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = param1.getBody() as Player;
            if (!facade.hasMediator(AppViewMediator.NAME))
            {
                facade.registerMediator(new AppViewMediator(_loc_2.appView));
            }
            return;
        }// end function

    }
}
