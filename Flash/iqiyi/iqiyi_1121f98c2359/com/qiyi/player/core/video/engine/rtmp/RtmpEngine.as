package com.qiyi.player.core.video.engine.rtmp
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.engine.*;
    import com.qiyi.player.core.video.events.*;
    import com.qiyi.player.core.video.render.*;
    import flash.events.*;

    public class RtmpEngine extends BaseEngine implements IDestroy
    {
        private var _stream:RtmpStream;
        private var _paused:Boolean = true;

        public function RtmpEngine(param1:ICorePlayer)
        {
            super(param1);
            Settings.instance.addEventListener(Settings.Evt_AudioTrackChanged, this.onAudioTrackChanged);
            Settings.instance.addEventListener(Settings.Evt_DefinitionChanged, this.onDefinitionChanged);
            return;
        }// end function

        override public function get currentTime() : int
        {
            if (this._stream)
            {
                return this._stream.time;
            }
            return 0;
        }// end function

        override public function get bufferTime() : int
        {
            if (this._stream)
            {
                return this._stream.bufferTime;
            }
            return 0;
        }// end function

        override public function bind(param1:IMovie, param2:IRender) : void
        {
            super.bind(param1, param2);
            this.createStream();
            this._stream.bind(_movie.curDefinition.findSegmentAt(0));
            setStatus(StatusEnum.ALREADY_READY);
            return;
        }// end function

        override public function startLoad() : void
        {
            super.startLoad();
            this.pause();
            if (checkEngineIsReady())
            {
                this.seek(_startTime);
            }
            else
            {
                _holder.addStatus(StatusEnum.WAITING_START_LOAD, false);
                startLoadHistory();
                startLoadMeta();
                startLoadLicense();
            }
            setStatus(StatusEnum.ALREADY_START_LOAD);
            return;
        }// end function

        override public function seek(param1:uint, param2:int = 0) : void
        {
            if (_movie == null)
            {
                throw new Error("RtmpEngine error! bind firstly!");
            }
            if (this._stream == null)
            {
                this.createStream();
                this._stream.bind(_movie.curDefinition.findSegmentAt(0));
            }
            _seekTime = param1;
            if (checkEngineIsReady())
            {
                super.seek(_seekTime, param2);
                this._stream.seek(_seekTime);
            }
            return;
        }// end function

        override public function stop(param1:EnumItem) : void
        {
            if (_decoder)
            {
                _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
                _decoder.stop();
                _decoder = null;
            }
            this.destroyStream();
            super.stop(param1);
            return;
        }// end function

        override protected function selfStop(param1:EnumItem) : void
        {
            if (_decoder)
            {
                _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
                _decoder.stop();
                _decoder = null;
            }
            this.destroyStream();
            super.selfStop(param1);
            return;
        }// end function

        override public function play() : void
        {
            if (!_holder.hasStatus(StatusEnum.ALREADY_PLAY))
            {
                if (_movie == null)
                {
                    throw new Error("RtmpEngine error! bind firstly!");
                }
                super.play();
                if (checkEngineIsReady())
                {
                    this.seek(_startTime);
                }
                else
                {
                    _holder.addStatus(StatusEnum.WAITING_PLAY, false);
                    startLoadHistory();
                    startLoadMeta();
                    startLoadLicense();
                }
                this.resume();
            }
            return;
        }// end function

        override public function pause(param1:int = 0) : void
        {
            this._paused = true;
            if (this._stream)
            {
                this._stream.pause();
            }
            return;
        }// end function

        override public function resume() : void
        {
            this._paused = false;
            if (this._stream)
            {
                this._stream.resume();
            }
            return;
        }// end function

        override public function destroy() : void
        {
            super.destroy();
            Settings.instance.removeEventListener(Settings.Evt_AudioTrackChanged, this.onAudioTrackChanged);
            Settings.instance.removeEventListener(Settings.Evt_DefinitionChanged, this.onDefinitionChanged);
            this.destroyStream();
            if (_decoder)
            {
                _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
                _decoder = null;
            }
            return;
        }// end function

        private function createDecoder() : void
        {
            if (_decoder)
            {
                _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
            }
            _decoder = this._stream.decoder;
            _decoder.addEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
            return;
        }// end function

        private function createStream() : void
        {
            this.destroyStream();
            this._stream = new RtmpStream(_holder);
            this._stream.addEventListener(ProviderEvent.Evt_Failed, this.onStreamFailed);
            this._stream.addEventListener(ProviderEvent.Evt_Connected, this.onStreamConnected);
            this._stream.addEventListener(ProviderEvent.Evt_Stop, this.onStreamStop);
            this._stream.addEventListener(RtmpStream.Evt_Stuck, this.onStreamStuck);
            if (this._paused)
            {
                this._stream.pause();
            }
            else
            {
                this._stream.resume();
            }
            return;
        }// end function

        private function destroyStream() : void
        {
            if (this._stream)
            {
                this._stream.removeEventListener(ProviderEvent.Evt_Failed, this.onStreamFailed);
                this._stream.removeEventListener(ProviderEvent.Evt_Connected, this.onStreamConnected);
                this._stream.removeEventListener(ProviderEvent.Evt_Stop, this.onStreamStop);
                this._stream.removeEventListener(RtmpStream.Evt_Stuck, this.onStreamStuck);
                this._stream.destroy();
                this._stream = null;
            }
            return;
        }// end function

        private function onDecoderStatusChanged(event:DecoderEvent) : void
        {
            updateStatusByDecoder();
            return;
        }// end function

        private function onStreamFailed(event:ProviderEvent) : void
        {
            setStatus(StatusEnum.FAILED);
            dispatchEvent(new EngineEvent(EngineEvent.Evt_Error));
            return;
        }// end function

        private function onStreamConnected(event:ProviderEvent) : void
        {
            this.createDecoder();
            _render.bind(this, _decoder, _movie);
            updateStatusByDecoder();
            return;
        }// end function

        private function onStreamStop(event:ProviderEvent) : void
        {
            this.selfStop(StopReasonEnum.STOP);
            return;
        }// end function

        private function onStreamStuck(event:Event) : void
        {
            dispatchEvent(new EngineEvent(EngineEvent.Evt_Stuck));
            return;
        }// end function

        private function onAudioTrackChanged(event:Event) : void
        {
            var _loc_2:int = 0;
            if (_holder.hasStatus(StatusEnum.ALREADY_READY) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
            {
                _movie.setCurAudioTrack(Settings.instance.audioTrack, DefinitionUtils.getCurrentDefinition(_holder));
                if (_movie.curDefinition && _movie.curDefinition.type)
                {
                    _holder.runtimeData.currentDefinition = _movie.curDefinition.type.id.toString();
                }
                _holder.runtimeData.vid = _movie.vid;
                _loc_2 = this.currentTime;
                this.destroyStream();
                this.seek(_loc_2);
                dispatchEvent(new EngineEvent(EngineEvent.Evt_AudioTrackSwitched, 1));
            }
            return;
        }// end function

        private function onDefinitionChanged(event:Event) : void
        {
            var _loc_2:int = 0;
            if (_holder.hasStatus(StatusEnum.ALREADY_READY) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
            {
                _movie.setCurDefinition(Settings.instance.definition);
                if (_movie.curDefinition && _movie.curDefinition.type)
                {
                    _holder.runtimeData.currentDefinition = _movie.curDefinition.type.id.toString();
                }
                _holder.runtimeData.vid = _movie.vid;
                _loc_2 = this.currentTime;
                this.destroyStream();
                this.seek(_loc_2);
                dispatchEvent(new EngineEvent(EngineEvent.Evt_DefinitionSwitched, 1));
            }
            return;
        }// end function

    }
}
