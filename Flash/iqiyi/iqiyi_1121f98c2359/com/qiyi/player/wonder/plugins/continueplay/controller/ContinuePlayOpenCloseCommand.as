package com.qiyi.player.wonder.plugins.continueplay.controller
{
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class ContinuePlayOpenCloseCommand extends SimpleCommand
    {

        public function ContinuePlayOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            if (Boolean(param1.getBody()))
            {
                _loc_2.addStatus(ContinuePlayDef.STATUS_OPEN);
            }
            else
            {
                _loc_2.removeStatus(ContinuePlayDef.STATUS_OPEN);
            }
            return;
        }// end function

    }
}
