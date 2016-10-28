package com.qiyi.player.wonder.plugins.feedback.controller
{
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.feedback.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class FeebackOpenCloseCommand extends SimpleCommand
    {

        public function FeebackOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(FeedbackProxy.NAME) as FeedbackProxy;
            if (Boolean(param1.getBody()))
            {
                PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                _loc_2.addStatus(FeedbackDef.STATUS_OPEN);
            }
            else
            {
                _loc_2.removeStatus(FeedbackDef.STATUS_OPEN);
            }
            return;
        }// end function

    }
}
