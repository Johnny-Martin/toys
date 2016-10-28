package com.qiyi.player.core.video.render
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.engine.*;
    import com.qiyi.player.core.video.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;

    public class StageVideoRender extends Render
    {
        private var _stageVideoInUse:Boolean = false;
        private var _stageVideo:Object = null;
        private var _stageVideoStatus:String = "unknown";
        private var _decoderUpdate:Boolean = false;

        public function StageVideoRender(param1:ICorePlayer, param2:Sprite)
        {
            super(param1, param2);
            StageVideoManager.instance.addEventListener(StageVideoManager.AVAILABILITY, this.onStageVideoAvailability);
            Settings.instance.addEventListener(Settings.Evt_UseGPU, this.onUseGPUChanged);
            return;
        }// end function

        override public function get accStatus() : EnumItem
        {
            if (this._stageVideoInUse)
            {
                switch(this._stageVideoStatus)
                {
                    case "accelerated":
                    {
                        return VideoAccEnum.GPU_ACCELERATED;
                    }
                    case "software":
                    {
                        return VideoAccEnum.GPU_RENDERING;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return super.accStatus;
        }// end function

        override public function setVideoDisplaySettings(param1:int, param2:int) : void
        {
            super.setVideoDisplaySettings(param1, param2);
            this.tryUseGPU();
            return;
        }// end function

        override public function releaseBind() : void
        {
            super.releaseBind();
            if (this._stageVideo)
            {
                this._stageVideo.removeEventListener(RenderEvent.Evt_RenderState, this.onStageVideoRenderStateEvent);
                this._stageVideo.attachNetStream(null);
                StageVideoManager.instance.release(this._stageVideo);
            }
            this._stageVideo = null;
            this._stageVideoInUse = false;
            return;
        }// end function

        override public function destroy() : void
        {
            Settings.instance.removeEventListener(Settings.Evt_UseGPU, this.onUseGPUChanged);
            StageVideoManager.instance.removeEventListener(StageVideoManager.AVAILABILITY, this.onStageVideoAvailability);
            if (this._stageVideo)
            {
                this._stageVideo.removeEventListener(RenderEvent.Evt_RenderState, this.onStageVideoRenderStateEvent);
                this._stageVideo.attachNetStream(null);
                StageVideoManager.instance.release(this._stageVideo);
            }
            this._stageVideo = null;
            this._stageVideoInUse = false;
            this._stageVideoStatus = "";
            super.destroy();
            return;
        }// end function

        override public function bind(param1:IEngine, param2:IDecoder, param3:IMovie) : void
        {
            this._decoderUpdate = _decoder != param2;
            super.bind(param1, param2, param3);
            this.tryUseGPU();
            return;
        }// end function

        override protected function changeVideoSize() : void
        {
            super.changeVideoSize();
            this.trySetViewPort();
            return;
        }// end function

        override public function tryUseGPU() : void
        {
            var _loc_1:Boolean = false;
            if (_holder.runtimeData.supportGPU && _decoder && _360VideoEnable == false)
            {
                _loc_1 = false;
                if (Settings.instance.useGPU && Settings.instance.brightness == 50 && Settings.instance.contrast == 50)
                {
                    _loc_1 = StageVideoManager.instance.stageVideoIsAvailable;
                }
                if (_loc_1 != this._stageVideoInUse)
                {
                    this._stageVideoInUse = _loc_1;
                    this.setUseGPU();
                }
                else if (this._decoderUpdate)
                {
                    if (this._stageVideo)
                    {
                        this._stageVideo.attachNetStream(null);
                        this._stageVideo.attachNetStream(_decoder as NetStream);
                    }
                    else
                    {
                        _video.attachNetStream(null);
                        _video.attachNetStream(_decoder as NetStream);
                    }
                    this._decoderUpdate = false;
                }
            }
            return;
        }// end function

        override public function tryUpGPUDepth() : void
        {
            if (this._stageVideo && !_holder.isPreload)
            {
                this._stageVideo.depth = StageVideoManager.instance.getNewDepth();
                this.trySetViewPort();
            }
            return;
        }// end function

        override protected function checkMultiAngle() : void
        {
            super.checkMultiAngle();
            this._stageVideoInUse = !_360VideoEnable;
            this.setUseGPU();
            return;
        }// end function

        private function setUseGPU() : void
        {
            _log.info((this._stageVideoInUse ? ("start") : ("stop")) + " user GPU!");
            if (this._stageVideoInUse)
            {
                if (this._stageVideo)
                {
                    this._stageVideo.removeEventListener(RenderEvent.Evt_RenderState, this.onStageVideoRenderStateEvent);
                    this._stageVideo.attachNetStream(null);
                    StageVideoManager.instance.release(this._stageVideo);
                }
                this._stageVideo = StageVideoManager.instance.getStageVideo();
                if (this._stageVideo == null)
                {
                    this._stageVideoInUse = false;
                    _video.visible = true;
                    _video.attachNetStream(null);
                    _video.attachNetStream(_decoder as NetStream);
                }
                else
                {
                    if (_holder.isPreload)
                    {
                        this._stageVideo.depth = 0;
                        this._stageVideo.viewPort = new Rectangle(-2, -2, 1, 1);
                    }
                    else
                    {
                        this._stageVideo.depth = StageVideoManager.instance.getNewDepth();
                        this.trySetViewPort();
                    }
                    this._stageVideo.addEventListener(RenderEvent.Evt_RenderState, this.onStageVideoRenderStateEvent);
                    this._stageVideo.attachNetStream(_decoder as NetStream);
                    _video.visible = false;
                }
            }
            else
            {
                if (this._stageVideo)
                {
                    this._stageVideo.removeEventListener(RenderEvent.Evt_RenderState, this.onStageVideoRenderStateEvent);
                    this._stageVideo.attachNetStream(null);
                    StageVideoManager.instance.release(this._stageVideo);
                    this._stageVideo = null;
                }
                _video.visible = true;
                _video.attachNetStream(null);
                _video.attachNetStream(_decoder as NetStream);
            }
            return;
        }// end function

        private function trySetViewPort() : void
        {
            var _loc_1:Point = null;
            if (this._stageVideo && _realArea.width > 0 && _realArea.height > 0 && _360VideoEnable == false)
            {
                _loc_1 = _parent.localToGlobal(new Point(_realArea.x, _realArea.y));
                this._stageVideo.viewPort = new Rectangle(_loc_1.x, _loc_1.y, _realArea.width, _realArea.height);
            }
            return;
        }// end function

        private function onStageVideoRenderStateEvent(param1) : void
        {
            _log.info("StageVideo Render State : " + param1.status);
            this._stageVideoStatus = param1.status;
            if (param1.status != "unavailable")
            {
                this.trySetViewPort();
                dispatchEvent(new RenderEvent(RenderEvent.Evt_GPUChanged, true));
            }
            else
            {
                this._stageVideoInUse = false;
                this.setUseGPU();
                dispatchEvent(new RenderEvent(RenderEvent.Evt_GPUChanged, false));
            }
            return;
        }// end function

        private function onUseGPUChanged(event:Event) : void
        {
            this.tryUseGPU();
            return;
        }// end function

        private function onStageVideoAvailability(event:Event) : void
        {
            this.tryUseGPU();
            return;
        }// end function

    }
}
