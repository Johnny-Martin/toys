package com.qiyi.player.wonder.plugins.recommend.controller
{
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import com.qiyi.player.wonder.plugins.recommend.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class RecommendOpenCloseCommand extends SimpleCommand
    {

        public function RecommendOpenCloseCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(RecommendProxy.NAME) as RecommendProxy;
            if (Boolean(param1.getBody()))
            {
                PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_END_POPUP);
                _loc_2.addStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
                PingBack.getInstance().recommendationPanelPing();
            }
            else
            {
                _loc_2.removeStatus(RecommendDef.STATUS_FINISH_RECOMMEND_OPEN);
            }
            return;
        }// end function

    }
}
