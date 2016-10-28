package com.qiyi.player.wonder.plugins.hint.controller
{
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.hint.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class HintOpenCloseCommand extends SimpleCommand
    {

        public function HintOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(HintProxy.NAME) as HintProxy;
            if (Boolean(param1.getBody()))
            {
                _loc_2.addStatus(HintDef.STATUS_OPEN);
            }
            else
            {
                _loc_2.removeStatus(HintDef.STATUS_OPEN);
            }
            return;
        }// end function

    }
}
