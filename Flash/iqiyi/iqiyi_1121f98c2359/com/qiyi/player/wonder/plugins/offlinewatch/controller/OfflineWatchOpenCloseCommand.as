package com.qiyi.player.wonder.plugins.offlinewatch.controller
{
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.*;
    import com.qiyi.player.wonder.plugins.offlinewatch.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class OfflineWatchOpenCloseCommand extends SimpleCommand
    {

        public function OfflineWatchOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(OfflineWatchProxy.NAME) as OfflineWatchProxy;
            if (Boolean(param1.getBody()))
            {
                PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                _loc_2.addStatus(OfflineWatchDef.STATUS_OPEN);
            }
            else
            {
                _loc_2.removeStatus(OfflineWatchDef.STATUS_OPEN);
            }
            return;
        }// end function

    }
}
