package com.qiyi.player.wonder.plugins.setting.controller
{
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class FilterOpenCloseCommand extends SimpleCommand
    {

        public function FilterOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(SettingProxy.NAME) as SettingProxy;
            if (Boolean(param1.getBody()))
            {
                PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_POPUP);
                _loc_2.addStatus(SettingDef.STATUS_FILTER_OPEN);
                _loc_2.addStatus(SettingDef.STATUS_FILTER_SHOW_UI);
            }
            else
            {
                _loc_2.removeStatus(SettingDef.STATUS_FILTER_OPEN);
                _loc_2.removeStatus(SettingDef.STATUS_FILTER_SHOW_UI);
            }
            return;
        }// end function

    }
}
