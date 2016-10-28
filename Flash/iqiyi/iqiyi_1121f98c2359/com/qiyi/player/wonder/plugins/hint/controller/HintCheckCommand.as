package com.qiyi.player.wonder.plugins.hint.controller
{
    import com.qiyi.player.wonder.plugins.hint.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class HintCheckCommand extends SimpleCommand
    {

        public function HintCheckCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(HintProxy.NAME) as HintProxy;
            _loc_2.replay = Boolean(param1.getBody());
            _loc_2.checkPlayOrHint();
            return;
        }// end function

    }
}
