package 
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.tooltip.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.wonder.*;
    import com.qiyi.player.wonder.body.view.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.lso.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.sw.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.system.*;
    import flash.utils.*;

    public class Player extends Sprite
    {
        private var _appView:AppView;

        public function Player()
        {
            if (stage)
            {
                this.onAddToStage();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            }
            return;
        }// end function

        public function get appView() : AppView
        {
            return this._appView;
        }// end function

        private function onAddToStage(event:Event = null) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
            this.initProcessesTimeInfo();
            var _loc_2:String = "";
            if (loaderInfo && loaderInfo.parameters)
            {
                _loc_2 = loaderInfo.parameters.yhls;
            }
            PingBack.getInstance().sendPlayerLoadSuccess(_loc_2);
            this.init();
            return;
        }// end function

        private function init() : void
        {
            this.initFlashVar();
            this.initCore();
            return;
        }// end function

        private function initFlashVar() : void
        {
            FlashVarConfig.init(loaderInfo.parameters);
            SwitchManager.getInstance().initByFlashVar(FlashVarConfig.components);
            LocalizationManager.instance.init(FlashVarConfig.localize);
            return;
        }// end function

        private function initCore() : void
        {
            var _loc_3:SoundTransform = null;
            if (loaderInfo.parameters.hasOwnProperty("masflag") && loaderInfo.parameters.masflag == "true")
            {
                _loc_3 = new SoundTransform();
                _loc_3.volume = 0;
                SoundMixer.soundTransform = _loc_3;
            }
            LogManager.initLog(FlashVarConfig.owner == FlashVarConfig.OWNER_PAGE);
            var _loc_1:String = "";
            if (loaderInfo.parameters.flashP2PCoreUrl)
            {
                _loc_1 = loaderInfo.parameters.flashP2PCoreUrl.toString();
            }
            var _loc_2:* = CoreManager.getInstance().initialize(stage, PlatformEnum.PC, PlayerTypeEnum.MAIN_STATION, _loc_1);
            if (_loc_2)
            {
                this.onCoreInitComplete();
            }
            else
            {
                CoreManager.getInstance().addEventListener(CoreManager.Evt_InitComplete, this.onCoreInitComplete);
            }
            UUIDManager.instance.setWebEventID(FlashVarConfig.webEventID);
            return;
        }// end function

        private function initStage() : void
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            ToolTip.getInstance().init(stage);
            GlobalStage.initStage(stage);
            return;
        }// end function

        private function initLSO() : void
        {
            LSO.getInstance().init();
            return;
        }// end function

        private function initAppView() : void
        {
            this._appView = new AppView();
            addChild(this._appView);
            return;
        }// end function

        private function initProcessesTimeInfo() : void
        {
            var curDate:Date;
            var diff:Number;
            try
            {
                if (loaderInfo.parameters.hasOwnProperty("browserType") && loaderInfo.parameters.browserType != "")
                {
                    ProcessesTimeRecord.browserType = String(loaderInfo.parameters.browserType);
                }
                if (loaderInfo.parameters.hasOwnProperty("pageTmpltType") && loaderInfo.parameters.pageTmpltType != "")
                {
                    ProcessesTimeRecord.pageTmpltType = String(loaderInfo.parameters.pageTmpltType);
                }
                if (loaderInfo.parameters.hasOwnProperty("playerCTime") && Number(loaderInfo.parameters.playerCTime) > 0)
                {
                    curDate = new Date();
                    diff = curDate.getTime() - Number(loaderInfo.parameters.playerCTime);
                    if (diff > 0)
                    {
                        ProcessesTimeRecord.usedTime_selfLoaded = diff;
                    }
                }
            }
            catch (e:Error)
            {
                ProcessesTimeRecord.browserType = "";
                ProcessesTimeRecord.pageTmpltType = "";
                ProcessesTimeRecord.usedTime_selfLoaded = 0;
            }
            return;
        }// end function

        private function onCoreInitComplete(event:Event = null) : void
        {
            this.initStage();
            this.initLSO();
            this.initAppView();
            if (FlashVarConfig.autoPlay)
            {
                ProcessesTimeRecord.STime_showVideo = getTimer();
            }
            else
            {
                ProcessesTimeRecord.needRecord = false;
            }
            AppFacade.getInstance().startup(this);
            return;
        }// end function

    }
}
