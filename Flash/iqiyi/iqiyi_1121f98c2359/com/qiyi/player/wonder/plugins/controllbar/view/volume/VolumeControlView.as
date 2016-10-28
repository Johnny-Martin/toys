package com.qiyi.player.wonder.plugins.controllbar.view.volume
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.tooltip.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.*;
    import controllbar.*;
    import flash.display.*;
    import flash.events.*;

    public class VolumeControlView extends Sprite
    {
        private var _volumeControllerUI:VolumeControllerUI;
        private var _mouseDowned:Boolean = false;
        private var _currentVolume:int = 60;
        private var _adjustVolume:int;
        private var _isMute:Boolean = false;
        private var _volumeTip:DefaultToolTip;
        private var _status:Status;
        private var _tipX:Number;
        private var _tipY:Number;
        private static const VOLUME_TIPS_STR:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VOLUME_VONTROL_VIEW_DES1);

        public function VolumeControlView(param1:Status)
        {
            this._status = param1;
            this._volumeControllerUI = new VolumeControllerUI();
            this._volumeTip = new DefaultToolTip();
            this._volumeControllerUI.volumePanel.volumeBar.mask = this._volumeControllerUI.volumePanel.volumeCover;
            this._volumeControllerUI.speaker.addEventListener(MouseEvent.CLICK, this.onSpeakerClick);
            this._volumeControllerUI.volumePanel.addEventListener(MouseEvent.CLICK, this.onVolumePanelClick);
            this._volumeControllerUI.volumePanel.slider.addEventListener(MouseEvent.MOUSE_DOWN, this.onSliderDown);
            this._volumeControllerUI.volumePanel.volumeBar.mouseChildren = false;
            this._volumeControllerUI.volumePanel.volumeBar.mouseEnabled = false;
            this._volumeControllerUI.volumePanel.volumeCover.mouseChildren = false;
            this._volumeControllerUI.volumePanel.volumeCover.mouseEnabled = false;
            this._volumeControllerUI.speaker.buttonMode = true;
            this._volumeControllerUI.volumePanel.buttonMode = true;
            this.initUI();
            return;
        }// end function

        public function get currentVolume() : Number
        {
            return this._currentVolume;
        }// end function

        public function get adjustVolume() : int
        {
            return this._adjustVolume;
        }// end function

        public function set adjustVolume(param1:int) : void
        {
            this._adjustVolume = param1;
            return;
        }// end function

        public function get speaker() : Sprite
        {
            return this._volumeControllerUI.speaker;
        }// end function

        public function get volumeTip() : DefaultToolTip
        {
            return this._volumeTip;
        }// end function

        public function get tipX() : Number
        {
            return this._tipX;
        }// end function

        public function get tipY() : Number
        {
            this._tipY = this._status.hasStatus(ControllBarDef.STATUS_SHOW) ? (-24) : (-36);
            return this._tipY;
        }// end function

        public function setVolume(param1:int, param2:Boolean) : void
        {
            this._currentVolume = param1;
            this._isMute = param2;
            if (this._currentVolume != 0 && !this._isMute)
            {
                this._volumeControllerUI.speaker.gotoAndStop(this.getSpeakerFrameIndex());
                this._volumeControllerUI.volumePanel.slider.x = 1 * this._currentVolume / 100 * this._volumeControllerUI.volumePanel.volumeBar.width;
                this._volumeControllerUI.volumePanel.volumeBar.mask.width = this._volumeControllerUI.volumePanel.slider.x;
            }
            else
            {
                this._volumeControllerUI.speaker.gotoAndStop(4);
                this._volumeControllerUI.volumePanel.slider.x = 0;
                this._volumeControllerUI.volumePanel.volumeBar.mask.width = 0;
            }
            return;
        }// end function

        public function updateVolumeControlView(param1:int, param2:Boolean = false, param3:Boolean = true) : void
        {
            var _loc_4:Number = NaN;
            if (param1 < 0)
            {
                param1 = 0;
            }
            if (!param2)
            {
                this._currentVolume = param1;
                if (param1 > 100)
                {
                    this._currentVolume = 100;
                }
                _loc_4 = this._currentVolume / 100 * this._volumeControllerUI.volumePanel.volumeBar.width;
                this._volumeControllerUI.volumePanel.slider.x = _loc_4;
                this._volumeControllerUI.volumePanel.volumeBar.mask.width = _loc_4;
                this._volumeTip.text = this._currentVolume + "%";
                if (this._currentVolume == 100)
                {
                    this._volumeTip.text = this._currentVolume + VOLUME_TIPS_STR;
                }
                this._tipX = this._volumeControllerUI.volumePanel.x + this._volumeControllerUI.volumePanel.slider.x - this._volumeTip.width / 2;
                if (this._currentVolume == 100)
                {
                    this._tipX = this._tipX - 30;
                }
            }
            else
            {
                if (param1 > 100)
                {
                    this._volumeControllerUI.volumePanel.slider.x = this._volumeControllerUI.volumePanel.volumeBar.width;
                    this._volumeControllerUI.volumePanel.volumeBar.mask.width = this._volumeControllerUI.volumePanel.volumeBar.width;
                    this._volumeTip.text = param1 + "%";
                    this._tipX = this._volumeControllerUI.volumePanel.x + this._volumeControllerUI.volumePanel.slider.x - this._volumeTip.width / 2;
                }
                else if (param1 == 100)
                {
                    this._volumeControllerUI.volumePanel.slider.x = this._volumeControllerUI.volumePanel.volumeBar.width;
                    this._volumeControllerUI.volumePanel.volumeBar.mask.width = this._volumeControllerUI.volumePanel.volumeBar.width;
                    if (this._currentVolume < param1)
                    {
                        this._volumeTip.text = param1 + VOLUME_TIPS_STR;
                        this._tipX = this._volumeControllerUI.volumePanel.x + this._volumeControllerUI.volumePanel.slider.x - this._volumeTip.width / 2 - 30;
                    }
                    else
                    {
                        this._volumeTip.text = param1 + "%";
                        this._tipX = this._volumeControllerUI.volumePanel.x + this._volumeControllerUI.volumePanel.slider.x - this._volumeTip.width / 2;
                    }
                }
                else
                {
                    _loc_4 = param1 / 100 * this._volumeControllerUI.volumePanel.volumeBar.width;
                    this._volumeControllerUI.volumePanel.slider.x = _loc_4;
                    this._volumeControllerUI.volumePanel.volumeBar.mask.width = _loc_4;
                    this._volumeTip.text = param1 + "%";
                    this._tipX = this._volumeControllerUI.volumePanel.x + this._volumeControllerUI.volumePanel.slider.x - this._volumeTip.width / 2;
                }
                this._currentVolume = param1;
            }
            this._volumeControllerUI.speaker.gotoAndStop(this.getSpeakerFrameIndex());
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_VolumeChanged, {volume:this._currentVolume, tip:param3}));
            return;
        }// end function

        private function onSpeakerClick(event:MouseEvent) : void
        {
            if (this._volumeControllerUI.speaker.currentFrame == 4)
            {
                if (this._currentVolume == 0)
                {
                    this._currentVolume = 60;
                }
                this._volumeControllerUI.speaker.gotoAndStop(this.getSpeakerFrameIndex());
                if (this._currentVolume < 100)
                {
                    this._volumeControllerUI.volumePanel.slider.x = 1 * this._currentVolume / 100 * this._volumeControllerUI.volumePanel.volumeBar.width;
                }
                else
                {
                    this._volumeControllerUI.volumePanel.slider.x = this._volumeControllerUI.volumePanel.volumeBar.width;
                }
                this._volumeControllerUI.volumePanel.volumeBar.mask.width = this._volumeControllerUI.volumePanel.slider.x;
                this._volumeTip.text = this._currentVolume + "%";
                this._tipX = this._volumeControllerUI.volumePanel.x + this._volumeControllerUI.volumePanel.slider.x - this._volumeTip.width / 2;
                dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_VolumeMuteChanged, this._currentVolume == 0));
            }
            else
            {
                this._volumeControllerUI.speaker.gotoAndStop(4);
                this._volumeControllerUI.volumePanel.slider.x = 0;
                this._volumeControllerUI.volumePanel.volumeBar.mask.width = 0;
                this._volumeTip.text = "0%";
                this._tipX = this._volumeControllerUI.volumePanel.x + this._volumeControllerUI.volumePanel.slider.x - this._volumeTip.width / 2;
                dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_VolumeMuteChanged, true));
            }
            return;
        }// end function

        private function getSpeakerFrameIndex() : int
        {
            var _loc_1:int = 0;
            if (this._currentVolume == 0)
            {
                _loc_1 = 4;
            }
            else if (this._currentVolume < 30)
            {
                _loc_1 = 3;
            }
            else if (this._currentVolume <= 60)
            {
                _loc_1 = 2;
            }
            else
            {
                _loc_1 = 1;
            }
            return _loc_1;
        }// end function

        private function onSliderDown(event:MouseEvent) : void
        {
            this._mouseDowned = true;
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onStageMouseMove);
            GlobalStage.stage.addEventListener(MouseEvent.MOUSE_UP, this.onStageMouseUp);
            return;
        }// end function

        private function onVolumePanelClick(event:MouseEvent) : void
        {
            var _loc_2:* = mouseX - this._volumeControllerUI.volumePanel.x;
            this.updateVolumeControlView(100 * _loc_2 / this._volumeControllerUI.volumePanel.volumeBar.width);
            return;
        }// end function

        private function onStageMouseMove(event:MouseEvent) : void
        {
            if (!this._mouseDowned)
            {
                return;
            }
            this.onVolumePanelClick(null);
            return;
        }// end function

        private function onStageMouseUp(event:MouseEvent) : void
        {
            this._mouseDowned = false;
            GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onStageMouseMove);
            GlobalStage.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onStageMouseUp);
            return;
        }// end function

        private function initUI() : void
        {
            this._volumeControllerUI.speaker.x = 0;
            this._volumeControllerUI.volumePanel.x = this._volumeControllerUI.speaker.width + 5;
            this._volumeControllerUI.volumePanel.volumeBar.x = 0;
            this._volumeControllerUI.volumePanel.volumeCover.x = 0;
            this._volumeControllerUI.volumePanel.slider.x = this._currentVolume / 100 * this._volumeControllerUI.volumePanel.volumeBar.width + this._volumeControllerUI.volumePanel.volumeBar.x;
            this._volumeControllerUI.volumePanel.slider.y = -3;
            this._volumeControllerUI.volumePanel.width = this._volumeControllerUI.volumePanel.volumeBar.width;
            addChild(this._volumeControllerUI.speaker);
            addChild(this._volumeControllerUI.volumePanel);
            this._volumeControllerUI.speaker.gotoAndStop(this.getSpeakerFrameIndex());
            return;
        }// end function

    }
}
