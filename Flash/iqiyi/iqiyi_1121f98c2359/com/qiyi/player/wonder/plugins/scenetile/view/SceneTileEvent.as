package com.qiyi.player.wonder.plugins.scenetile.view
{
    import com.qiyi.player.wonder.common.event.*;

    public class SceneTileEvent extends CommonEvent
    {
        public static const Evt_ToolOpen:String = "evtSceneTileToolOpen";
        public static const Evt_ToolClose:String = "evtSceneTileToolClose";
        public static const Evt_ScoreOpen:String = "evtSceneTileScoreOpen";
        public static const Evt_ScoreSuccessOpen:String = "evtSceneTileScoreSuccessOpen";
        public static const Evt_ScoreClose:String = "evtSceneTileScoreClose";
        public static const Evt_ScoreHeartClick:String = "evtScoreHeartClick";
        public static const Evt_PanoramicToolClick:String = "evtPanoramicToolClick";
        public static const Evt_BarrageDeleteInfo:String = "evtBarrageDeleteInfo";
        public static const Evt_BarrageItemClick:String = "evtBarrageItemClick";

        public function SceneTileEvent(param1:String, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
