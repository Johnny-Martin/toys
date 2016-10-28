package com.qiyi.player.wonder.body.controller.usercommand
{
    import com.qiyi.player.wonder.body.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class CheckUserCommand extends SimpleCommand
    {

        public function CheckUserCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            _loc_2.checkUser();
            return;
        }// end function

    }
}
