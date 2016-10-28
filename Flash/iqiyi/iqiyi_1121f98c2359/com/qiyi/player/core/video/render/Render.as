package com.qiyi.player.core.video.render
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.events.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.engine.*;
    import com.qiyi.player.core.video.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.system.*;
    import gs.*;

    public class Render extends EventDispatcher implements IRender
    {
        protected var _holder:ICorePlayer;
        protected var _parent:Sprite;
        protected var _engine:IEngine;
        protected var _decoder:IDecoder;
        protected var _movie:IMovie;
        protected var _video:Video;
        protected var _settingArea:Rectangle;
        protected var _realArea:Rectangle;
        protected var _360Configed:Boolean = false;
        protected var _360VideoEnable:Boolean;
        protected var _videoLayer:Sprite;
        protected var _isSwitchingDef:Boolean;
        private var _videoStatus:String;
        private var _puman:Boolean = false;
        private var _zoom:int = 100;
        private var _widthRate:int;
        private var _heightRate:int;
        protected var _log:ILogger;

        public function Render(param1:ICorePlayer, param2:Sprite)
        {
            this._360VideoEnable = this._360Configed;
            this._log = Log.getLogger("com.qiyi.player.core.video.render.Render");
            this._holder = param1;
            this._parent = param2;
            this._settingArea = new Rectangle();
            this._realArea = new Rectangle();
            this._video = new Video();
            this._video.addEventListener(RenderEvent.Evt_RenderState, this.onRenderStateChangeEvent);
            this._videoLayer = new Sprite();
            this._videoLayer.addChild(this._video);
            this._parent.addChild(this._videoLayer);
            Settings.instance.addEventListener(Settings.Evt_VideoAttriChanged, this.onVideoAttriChanged);
            Settings.instance.addEventListener(Settings.Evt_VideoRateChanged, this.onVideoRateChanged);
            this.setVideoDisplaySettings(Settings.instance.brightness, Settings.instance.contrast);
            this.setVideoRate(Settings.instance.videoRateWidth, Settings.instance.videoRateHeight);
            return;
        }// end function

        public function get accStatus() : EnumItem
        {
            switch(this._videoStatus)
            {
                case "accelerated":
                {
                    return VideoAccEnum.CPU_ACCELERATED;
                }
                case "software":
                {
                    return VideoAccEnum.CPU_SOFTWARE;
                }
                default:
                {
                    break;
                }
            }
            return VideoAccEnum.UNKNOWN;
        }// end function

        public function bind(param1:IEngine, param2:IDecoder, param3:IMovie) : void
        {
            if (this._engine)
            {
                this._engine.removeEventListener(EngineEvent.Evt_DefinitionSwitched, this.onDefinitionChanged);
                this._engine.removeEventListener(EngineEvent.Evt_AudioTrackSwitched, this.onAudioTrackChanged);
            }
            this._engine = param1;
            this._engine.addEventListener(EngineEvent.Evt_DefinitionSwitched, this.onDefinitionChanged);
            this._engine.addEventListener(EngineEvent.Evt_AudioTrackSwitched, this.onAudioTrackChanged);
            if (this._decoder)
            {
                this._decoder.removeEventListener(DecoderEvent.Evt_MetaData, this.onDecoderMetaData);
            }
            this._decoder = param2;
            this._video.attachNetStream(param2.netstream);
            if (this._movie)
            {
                this._movie.removeEventListener(MovieEvent.Evt_Meta_Ready, this.onMovieMetaReady);
            }
            this._movie = param3;
            this._movie.addEventListener(MovieEvent.Evt_Meta_Ready, this.onMovieMetaReady);
            this.changeVideoSize();
            this.updateSmoothing(this._movie);
            return;
        }// end function

        public function releaseBind() : void
        {
            this._video.attachNetStream(null);
            if (this._movie)
            {
                this._movie.removeEventListener(MovieEvent.Evt_Meta_Ready, this.onMovieMetaReady);
                this._movie = null;
            }
            return;
        }// end function

        public function tryUseGPU() : void
        {
            return;
        }// end function

        public function tryUpGPUDepth() : void
        {
            return;
        }// end function

        public function destroy() : void
        {
            this._holder = null;
            Settings.instance.removeEventListener(Settings.Evt_VideoAttriChanged, this.onVideoAttriChanged);
            Settings.instance.removeEventListener(Settings.Evt_VideoRateChanged, this.onVideoRateChanged);
            if (this._engine)
            {
                this._engine.removeEventListener(EngineEvent.Evt_DefinitionSwitched, this.onDefinitionChanged);
                this._engine.removeEventListener(EngineEvent.Evt_AudioTrackSwitched, this.onAudioTrackChanged);
                this._engine = null;
            }
            if (this._movie)
            {
                this._movie.removeEventListener(MovieEvent.Evt_Meta_Ready, this.onMovieMetaReady);
                this._movie = null;
            }
            if (this._decoder)
            {
                this._decoder.removeEventListener(DecoderEvent.Evt_MetaData, this.onDecoderMetaData);
                this._decoder = null;
            }
            this._video.removeEventListener(RenderEvent.Evt_RenderState, this.onRenderStateChangeEvent);
            this._video.attachNetStream(null);
            if (this._video.parent)
            {
                this._videoLayer.removeChild(this._video);
            }
            if (this._videoLayer.parent)
            {
                this._parent.removeChild(this._videoLayer);
            }
            this._video = null;
            this._videoLayer = null;
            this._parent = null;
            return;
        }// end function

        public function setRect(param1:int, param2:int, param3:int, param4:int) : void
        {
            this._settingArea.x = param1;
            this._settingArea.y = param2;
            this._settingArea.width = param3;
            this._settingArea.height = param4;
            this.changeVideoSize();
            return;
        }// end function

        public function getSettingArea() : Rectangle
        {
            return this._settingArea;
        }// end function

        public function setZoom(param1:int) : void
        {
            if (this._zoom != param1)
            {
                this._zoom = param1;
                this.changeVideoSize();
            }
            return;
        }// end function

        public function getRealArea() : Rectangle
        {
            return this._realArea;
        }// end function

        public function setVideoDisplaySettings(param1:int, param2:int) : void
        {
            var _loc_3:ColorMatrix = null;
            var _loc_4:ColorMatrixFilter = null;
            if (this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
            {
                if (param1 != 50 || param2 != 50)
                {
                    _loc_3 = new ColorMatrix();
                    _loc_3.adjustColor(this.changeBrightnessValue(param1), this.changeBrightnessValue(param2), 0, 0);
                    _loc_4 = new ColorMatrixFilter(_loc_3);
                    if (this._360VideoEnable == false)
                    {
                        this._video.filters = [_loc_4];
                    }
                }
                else
                {
                    this._video.filters = [];
                }
            }
            return;
        }// end function

        public function clearVideo() : void
        {
            this._video.clear();
            return;
        }// end function

        public function setPuman(param1:Boolean) : void
        {
            if (this._puman != param1)
            {
                this._puman = param1;
                this.changeVideoSize();
            }
            return;
        }// end function

        public function setVideoRate(param1:int, param2:int) : void
        {
            if (this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
            {
                if (this._widthRate != param1 || this._heightRate != param2)
                {
                    this._widthRate = param1;
                    this._heightRate = param2;
                    this.changeVideoSize();
                }
            }
            return;
        }// end function

        public function panVideo(param1:Number) : void
        {
            return;
        }// end function

        public function tiltVideo(param1:Number) : void
        {
            return;
        }// end function

        public function zoomVideo(param1:Number) : void
        {
            return;
        }// end function

        protected function changeVideoSize() : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            this._log.info("video size changed: " + this._settingArea.toString());
            if (this._movie == null)
            {
                return;
            }
            if (this._puman)
            {
                this._realArea.height = this._settingArea.height;
                this._realArea.width = this._settingArea.width;
                this._realArea.y = this._settingArea.y;
                this._realArea.x = this._settingArea.x;
                this.updateVideoRect();
                dispatchEvent(new RenderEvent(RenderEvent.Evt_RenderAreaChanged));
                return;
            }
            var _loc_1:Number = 0;
            if (this._widthRate == 0 || this._heightRate == 0)
            {
                if (this._movie.width > 0 && this._movie.height > 0)
                {
                    _loc_1 = this._movie.width / this._movie.height;
                }
                else if (this._decoder.metadata)
                {
                    _loc_1 = this._decoder.metadata.width / this._decoder.metadata.height;
                }
                else
                {
                    this._realArea.height = this._settingArea.height;
                    this._realArea.width = this._settingArea.width;
                    this._realArea.y = this._settingArea.y;
                    this._realArea.x = this._settingArea.x;
                    this.updateVideoRect();
                    dispatchEvent(new RenderEvent(RenderEvent.Evt_RenderAreaChanged));
                    this._log.info("video size : waiting metadata!");
                    if (!this._decoder.hasEventListener(DecoderEvent.Evt_MetaData))
                    {
                        this._decoder.addEventListener(DecoderEvent.Evt_MetaData, this.onDecoderMetaData);
                    }
                    return;
                }
            }
            else
            {
                _loc_1 = this._widthRate / this._heightRate;
            }
            if (_loc_1 <= this._settingArea.width / this._settingArea.height)
            {
                _loc_5 = this._settingArea.height;
                _loc_4 = this._settingArea.height * _loc_1;
            }
            else
            {
                _loc_5 = this._settingArea.width / _loc_1;
                _loc_4 = this._settingArea.width;
            }
            if (this._zoom != 100)
            {
                _loc_5 = _loc_5 * (this._zoom / 100);
                _loc_4 = _loc_4 * (this._zoom / 100);
            }
            _loc_2 = this._settingArea.x + (this._settingArea.width - _loc_4) / 2;
            _loc_3 = this._settingArea.y + (this._settingArea.height - _loc_5) / 2;
            this._realArea.x = _loc_2;
            this._realArea.y = _loc_3;
            this._realArea.width = _loc_4;
            this._realArea.height = _loc_5;
            this.updateVideoRect();
            dispatchEvent(new RenderEvent(RenderEvent.Evt_RenderAreaChanged));
            return;
        }// end function

        protected function runtimeSupports360View() : Boolean
        {
            var _loc_1:* = Capabilities.version;
            if (_loc_1 == null)
            {
                return false;
            }
            var _loc_2:* = _loc_1.split(" ");
            if (_loc_2.length < 2)
            {
                return false;
            }
            var _loc_3:* = _loc_2[0];
            var _loc_4:* = _loc_2[1].split(",");
            if (_loc_4.length < 2)
            {
                return false;
            }
            var _loc_5:* = parseInt(_loc_4[0]);
            var _loc_6:* = parseInt(_loc_4[1]);
            return _loc_5 >= 12 || _loc_5 >= 11 && _loc_6 >= 6;
        }// end function

        protected function checkMultiAngle() : void
        {
            return;
        }// end function

        private function onDecoderMetaData(event:Event) : void
        {
            this._decoder.removeEventListener(DecoderEvent.Evt_MetaData, this.onDecoderMetaData);
            this.changeVideoSize();
            return;
        }// end function

        private function onMovieMetaReady(event:Event) : void
        {
            if (this._360VideoEnable)
            {
                this._video.x = 0;
                this._video.y = 0;
                this._video.scaleX = 1;
                this._video.scaleY = 1;
                this._video.filters = [];
            }
            else
            {
                this.changeVideoSize();
            }
            return;
        }// end function

        private function onRenderStateChangeEvent(param1) : void
        {
            this._log.info("Render State Changed : " + param1.status);
            this._videoStatus = param1.status;
            return;
        }// end function

        private function onDefinitionChanged(event:EngineEvent) : void
        {
            var _loc_2:* = Number(event.data);
            if (_loc_2 >= 0)
            {
                if (this._360VideoEnable)
                {
                    TweenLite.killTweensOf(this.update360Video);
                    TweenLite.delayedCall(_loc_2 / 1000, this.update360Video);
                    this._isSwitchingDef = true;
                }
                this.updateSmoothing(this._movie);
            }
            return;
        }// end function

        private function update360Video() : void
        {
            return;
        }// end function

        private function onAudioTrackChanged(event:EngineEvent) : void
        {
            var _loc_2:* = Number(event.data);
            if (_loc_2 >= 0)
            {
                this.updateSmoothing(this._movie);
            }
            return;
        }// end function

        private function onVideoAttriChanged(event:Event) : void
        {
            this.setVideoDisplaySettings(Settings.instance.brightness, Settings.instance.contrast);
            return;
        }// end function

        private function onVideoRateChanged(event:Event) : void
        {
            this.setVideoRate(Settings.instance.videoRateWidth, Settings.instance.videoRateHeight);
            return;
        }// end function

        private function changeBrightnessValue(param1:int) : int
        {
            return param1 * 2 - 100;
        }// end function

        private function changeContrastValue(param1:int) : int
        {
            return param1 - 50;
        }// end function

        private function updateSmoothing(param1:IMovie) : void
        {
            this._video.smoothing = true;
            return;
        }// end function

        private function updateVideoRect() : void
        {
            if (this._360VideoEnable == false)
            {
                this._video.x = this._realArea.x;
                this._video.y = this._realArea.y;
                this._video.width = this._realArea.width;
                this._video.height = this._realArea.height;
            }
            return;
        }// end function

    }
}
