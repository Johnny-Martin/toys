package com.qiyi.player.wonder.plugins.share.controller
{
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.plugins.share.*;
    import com.qiyi.player.wonder.plugins.share.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class ShareOpenCloseCommand extends SimpleCommand
    {

        public function ShareOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(ShareProxy.NAME) as ShareProxy;
            if (Boolean(param1.getBody()))
            {
                PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                _loc_2.addStatus(ShareDef.STATUS_OPEN);
            }
            else
            {
                _loc_2.removeStatus(ShareDef.STATUS_OPEN);
            }
            return;
        }// end function

    }
}
