package com.qiyi.player.wonder.plugins.ad.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.cupid.adplayer.*;
    import com.qiyi.cupid.adplayer.base.*;
    import com.qiyi.cupid.adplayer.events.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import gs.*;

    public class ADView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _adPlayer:CupidAdPlayer;
        private var _adDepot:String = "0";
        private var _lastMouseMove:int = 0;
        private var _dockShowFlag:Boolean = false;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.ad.view.ADView";

        public function ADView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.plugins.ad.view.ADView");
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function get adDepot() : String
        {
            return this._adDepot;
        }// end function

        public function get adPlayer() : CupidAdPlayer
        {
            return this._adPlayer;
        }// end function

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            this._status.addStatus(param1);
            switch(param1)
            {
                case ADDef.STATUS_OPEN:
                {
                    this.open();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onRemoveStatus(param1:int) : void
        {
            this._status.removeStatus(param1);
            switch(param1)
            {
                case ADDef.STATUS_OPEN:
                {
                    this.close();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            var _loc_3:Object = null;
            if (this._adPlayer)
            {
                _loc_3 = new Object();
                _loc_3.v_x = 0;
                _loc_3.v_y = 0;
                _loc_3.width = param1;
                _loc_3.height = param2;
                _loc_3.v_w = param1;
                _loc_3.v_h = _loc_3.height;
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_CHANGE_SIZE, _loc_3));
            }
            return;
        }// end function

        public function createAdPlayer(param1:CupidParam) : void
        {
            if (this._adPlayer)
            {
                this.unloadAdPlayer();
            }
            this._log.info("loading adplayer...");
            this._adPlayer = new CupidAdPlayer(param1);
            this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_LOADING_SUCCESS, this.onAdLoadSuccess);
            this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_LOADING_FAILURE, this.onAdLoadFailed);
            this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_AD_START, this.onAdStartPlay);
            this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_PAUSE, this.onAdAskVideoPause);
            this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_RESUME, this.onAdAskVideoResume);
            this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_START_LOADING, this.onAdAskVideoStartLoad);
            this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_START, this.onAdAskVideoStartPlay);
            this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_AD_INFO, this.onAdAskPlayerInfo);
            this._adPlayer.addEventListener(AdPlayerEvent.CONTROL_VIDEO_END, this.onAdAskVideoEnd);
            this._adPlayer.addEventListener(AdPlayerEvent.ADPLAYER_AD_BLOCK, this.onAdBlock);
            this._adPlayer.load();
            return;
        }// end function

        public function unloadAdPlayer() : void
        {
            if (this._adPlayer == null)
            {
                return;
            }
            this._log.info("unload adplayer....");
            this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_LOADING_SUCCESS, this.onAdLoadSuccess);
            this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_LOADING_FAILURE, this.onAdLoadFailed);
            this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_AD_START, this.onAdStartPlay);
            this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_PAUSE, this.onAdAskVideoPause);
            this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_RESUME, this.onAdAskVideoResume);
            this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_START_LOADING, this.onAdAskVideoStartLoad);
            this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_START, this.onAdAskVideoStartPlay);
            this._adPlayer.removeEventListener(AdPlayerEvent.CONTROL_VIDEO_END, this.onAdAskVideoEnd);
            this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_AD_INFO, this.onAdAskPlayerInfo);
            this._adPlayer.removeEventListener(AdPlayerEvent.ADPLAYER_AD_BLOCK, this.onAdBlock);
            this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_FORCE_AD_STOP));
            this._adPlayer.destroy();
            this._adPlayer = null;
            GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            TweenLite.killTweensOf(this.showLeftAD);
            dispatchEvent(new ADEvent(ADEvent.Evt_AdUnloaded));
            return;
        }// end function

        public function onUpdateCurrentTime(param1:int) : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_TIME_CHANGE, param1 / 1000));
            }
            return;
        }// end function

        public function onSwitchPre() : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_VIEW_SWITCH));
            }
            return;
        }// end function

        public function onPreloadNextAD(param1:Object) : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.PRELOAD_AD_NEXT, param1));
            }
            return;
        }// end function

        public function onVideoStop() : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_PLAY_OVER));
            }
            return;
        }// end function

        public function onResume() : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_RESUME));
            }
            return;
        }// end function

        public function onPause() : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_PAUSE));
            }
            return;
        }// end function

        public function onLightStateChanged(param1:Boolean) : void
        {
            if (this._adPlayer)
            {
                if (param1)
                {
                    this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_LIGHT_TURN_ON));
                }
                else
                {
                    this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_LIGHT_TURN_OFF));
                }
            }
            return;
        }// end function

        public function onVolumeChanged(param1:int) : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_CHANGE_VOLUME, param1));
            }
            return;
        }// end function

        public function onFullScreenChanged(param1:Boolean) : void
        {
            if (this._adPlayer)
            {
                if (param1)
                {
                    this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_FULLSCREEN));
                }
                else
                {
                    this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_NORMALSCREEN));
                }
            }
            return;
        }// end function

        public function onDockShowChanged(param1:Boolean) : void
        {
            if (this._dockShowFlag == param1)
            {
                return;
            }
            this._dockShowFlag = param1;
            if (this._adPlayer)
            {
                if (param1)
                {
                    this._lastMouseMove = 0;
                    GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
                    TweenLite.delayedCall(1, this.showLeftAD);
                }
                else
                {
                    GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
                    TweenLite.killTweensOf(this.showLeftAD);
                    this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_DOCK_HIDE));
                }
            }
            return;
        }// end function

        private function showLeftAD() : void
        {
            GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            if (this._adPlayer)
            {
                if (getTimer() - this._lastMouseMove < 200)
                {
                    this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_DOCK_SHOW));
                }
            }
            return;
        }// end function

        public function onPopupOpen() : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_DIALOG_POPUP));
            }
            return;
        }// end function

        public function onPopupClose() : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_DIALOG_CLOSE));
            }
            return;
        }// end function

        public function onCurInfoChanged(param1:Object) : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_INFO, param1));
            }
            return;
        }// end function

        public function onPreInfoChanged(param1:Object) : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.NEXT_VIDEO_INFO, param1));
            }
            return;
        }// end function

        public function onSendNotific(param1:Object) : void
        {
            if (this._adPlayer)
            {
                this._adPlayer.dispatchEvent(new AdPlayerEvent(AdPlayerEvent.VIDEO_NOTIFICATION, param1));
            }
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new ADEvent(ADEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new ADEvent(ADEvent.Evt_Close));
            }
            return;
        }// end function

        override protected function onAddToStage() : void
        {
            super.onAddToStage();
            return;
        }// end function

        override protected function onRemoveFromStage() : void
        {
            super.onRemoveFromStage();
            return;
        }// end function

        private function onAdLoadSuccess(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            _loc_2.version = event.data.data;
            dispatchEvent(new ADEvent(ADEvent.Evt_LoadSuccess, _loc_2));
            return;
        }// end function

        private function onAdLoadFailed(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            dispatchEvent(new ADEvent(ADEvent.Evt_LoadFailed, _loc_2));
            return;
        }// end function

        private function onAdStartPlay(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            dispatchEvent(new ADEvent(ADEvent.Evt_StartPlay, _loc_2));
            return;
        }// end function

        private function onAdAskVideoPause(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoPause, _loc_2));
            return;
        }// end function

        private function onAdAskVideoResume(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoResume, _loc_2));
            return;
        }// end function

        private function onAdAskVideoStartLoad(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            _loc_2.delay = event.data.data;
            dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoStartLoad, _loc_2));
            return;
        }// end function

        private function onAdAskVideoStartPlay(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            if (event.data.data)
            {
                _loc_2.viewPoints = event.data.data.viewPoints;
            }
            dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoStartPlay, _loc_2));
            return;
        }// end function

        private function onAdAskVideoEnd(event:AdPlayerEvent) : void
        {
            this._adDepot = event.data.data as String;
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            dispatchEvent(new ADEvent(ADEvent.Evt_AskVideoEnd, _loc_2));
            return;
        }// end function

        private function onAdAskPlayerInfo(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            if (event.data.viewPoints)
            {
                _loc_2.viewPoints = event.data.viewPoints;
            }
            dispatchEvent(new ADEvent(ADEvent.Evt_ViewPoints, _loc_2));
            return;
        }// end function

        private function onAdBlock(event:AdPlayerEvent) : void
        {
            var _loc_2:Object = {};
            _loc_2.tvid = event.data.tvId;
            _loc_2.vid = event.data.videoId;
            if (event.data.hasOwnProperty("isCidErr"))
            {
                _loc_2.isCidErr = Boolean(event.data.isCidErr);
            }
            else
            {
                _loc_2.isCidErr = false;
            }
            dispatchEvent(new ADEvent(ADEvent.Evt_AdBlock, _loc_2));
            return;
        }// end function

        private function onMouseMove(event:MouseEvent) : void
        {
            this._lastMouseMove = getTimer();
            return;
        }// end function

    }
}
