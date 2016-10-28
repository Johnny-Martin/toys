package com.qiyi.player.wonder.plugins.setting.controller
{
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class SettingOpenCloseCommand extends SimpleCommand
    {

        public function SettingOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (_loc_2.hasStatus(SettingDef.STATUS_OPEN))
            {
                _loc_2.removeStatus(SettingDef.STATUS_OPEN);
            }
            else
            {
                PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                _loc_2.addStatus(SettingDef.STATUS_OPEN);
            }
            return;
        }// end function

    }
}
