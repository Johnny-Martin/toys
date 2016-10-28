package com.qiyi.player.core.video.engine.http
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.engine.*;
    import com.qiyi.player.core.video.events.*;
    import com.qiyi.player.core.video.render.*;
    import flash.events.*;

    public class HttpEngine extends BaseEngine
    {
        private var _streams:Vector.<HttpStream>;
        private var _loadingStream:HttpStream;
        private var _playingStream:HttpStream;
        private var _paused:Boolean = false;
        private var _definitionIsSwitched:Boolean;

        public function HttpEngine(param1:ICorePlayer)
        {
            super(param1);
            Settings.instance.addEventListener(Settings.Evt_AudioTrackChanged, this.onAudioTrackChanged);
            Settings.instance.addEventListener(Settings.Evt_DefinitionChanged, this.onDefinitionChanged);
            return;
        }// end function

        override public function get bufferTime() : int
        {
            if (this._streams == null || this._playingStream == null)
            {
                return 0;
            }
            if (!this._playingStream.loadComplete)
            {
                return this._playingStream.bufferTime;
            }
            var _loc_1:* = this._playingStream.bufferTime;
            var _loc_2:HttpStream = null;
            var _loc_3:* = this._playingStream.segment.index + 1;
            while (_loc_3 < this._streams.length)
            {
                
                _loc_2 = this._streams[_loc_3];
                if (_loc_2.loadComplete && _loc_2.startTime == 0)
                {
                    _loc_1 = _loc_2.segment.endTime;
                }
                else
                {
                    if (_loc_2 == this._loadingStream)
                    {
                        _loc_1 = this._loadingStream.bufferTime;
                    }
                    break;
                }
                _loc_3++;
            }
            return _loc_1;
        }// end function

        override public function get currentTime() : int
        {
            if (this._playingStream)
            {
                return this._playingStream.time;
            }
            return 0;
        }// end function

        override public function bind(param1:IMovie, param2:IRender) : void
        {
            super.bind(param1, param2);
            this._definitionIsSwitched = false;
            this.createStream();
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

        override public function play() : void
        {
            super.play();
            this.resume();
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
            return;
        }// end function

        override public function pause(param1:int = 0) : void
        {
            this._paused = true;
            if (this._playingStream && !this._playingStream.failed)
            {
                this._playingStream.pause();
            }
            return;
        }// end function

        override public function resume() : void
        {
            this._paused = false;
            if (this._playingStream && !this._playingStream.failed)
            {
                this._playingStream.resume();
            }
            return;
        }// end function

        override public function seek(param1:uint, param2:int = 0) : void
        {
            _seekTime = param1;
            if (this._streams == null)
            {
                this.createStream();
            }
            if (checkEngineIsReady())
            {
                super.seek(_seekTime, param2);
                if (this._loadingStream == null || this._loadingStream.segment != _movie.curSegment)
                {
                    this.switchLoadSegment(this._streams[_movie.curSegment.index]);
                }
                if (this._playingStream == null || this._playingStream.segment != _movie.curSegment)
                {
                    this.switchPlaySegment(this._streams[_movie.curSegment.index]);
                }
                else
                {
                    this._playingStream.seek(_seekTime);
                }
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

        override public function destroy() : void
        {
            if (_decoder)
            {
                _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
                _decoder = null;
            }
            Settings.instance.removeEventListener(Settings.Evt_AudioTrackChanged, this.onAudioTrackChanged);
            Settings.instance.removeEventListener(Settings.Evt_DefinitionChanged, this.onDefinitionChanged);
            this.destroyStream();
            super.destroy();
            return;
        }// end function

        private function createDecoder() : void
        {
            if (_decoder)
            {
                _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
            }
            _decoder = this._playingStream.decoder;
            _decoder.addEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
            return;
        }// end function

        private function createStream() : void
        {
            this.destroyStream();
            this._streams = new Vector.<HttpStream>;
            var _loc_1:Segment = null;
            var _loc_2:HttpStream = null;
            var _loc_3:* = _movie.curDefinition;
            var _loc_4:* = _loc_3.segmentCount;
            this._streams.length = _loc_4;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_1 = _loc_3.findSegmentAt(_loc_5);
                _loc_2 = new HttpStream(_holder, _movie);
                _loc_2.bind(_loc_1);
                this._streams[_loc_5] = _loc_2;
                _loc_5++;
            }
            return;
        }// end function

        private function destroyStream() : void
        {
            var _loc_1:HttpStream = null;
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (this._streams)
            {
                _loc_1 = null;
                _loc_2 = this._streams.length;
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_1 = this._streams[_loc_3];
                    _loc_1.removeEventListener(ProviderEvent.Evt_Stop, this.onPlayingStop);
                    _loc_1.removeEventListener(ProviderEvent.Evt_Connected, this.onPlayingDecoderConnected);
                    _loc_1.removeEventListener(ProviderEvent.Evt_Connected, this.onLoadingDecoderConnected);
                    _loc_1.removeEventListener(ProviderEvent.Evt_Retry, this.onPlayingDecoderChanged);
                    _loc_1.removeEventListener(ProviderEvent.Evt_Failed, this.onPlayingFailed);
                    _loc_1.destroy();
                    _loc_3++;
                }
                this._streams = null;
                this._playingStream = null;
                this._loadingStream = null;
            }
            return;
        }// end function

        private function addPlayingListeners() : void
        {
            if (!this._playingStream.hasEventListener(ProviderEvent.Evt_Stop))
            {
                this._playingStream.addEventListener(ProviderEvent.Evt_Stop, this.onPlayingStop);
                this._playingStream.addEventListener(ProviderEvent.Evt_Connected, this.onPlayingDecoderConnected);
                this._playingStream.addEventListener(ProviderEvent.Evt_Retry, this.onPlayingDecoderChanged);
                this._playingStream.addEventListener(ProviderEvent.Evt_Failed, this.onPlayingFailed);
            }
            return;
        }// end function

        private function removePlayingListeners() : void
        {
            if (this._playingStream)
            {
                this._playingStream.removeEventListener(ProviderEvent.Evt_Stop, this.onPlayingStop);
                this._playingStream.removeEventListener(ProviderEvent.Evt_Connected, this.onPlayingDecoderConnected);
                this._playingStream.removeEventListener(ProviderEvent.Evt_Retry, this.onPlayingDecoderChanged);
                this._playingStream.removeEventListener(ProviderEvent.Evt_Failed, this.onPlayingFailed);
            }
            return;
        }// end function

        private function switchPlaySegment(param1:HttpStream) : void
        {
            if (this._playingStream)
            {
                this.removePlayingListeners();
                if (!this._playingStream.failed)
                {
                    if (_decoder)
                    {
                        _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
                    }
                    this._playingStream.pause();
                }
            }
            this._playingStream = param1;
            this._playingStream.seek();
            this.addPlayingListeners();
            this.onPlayingDecoderChanged(null);
            if (this._playingStream.ready)
            {
                this.onPlayingDecoderConnected(null);
            }
            if (this._playingStream.failed)
            {
                this.onPlayingFailed(null);
            }
            return;
        }// end function

        private function addLoadingListeners() : void
        {
            this._loadingStream.addEventListener(ProviderEvent.Evt_Connected, this.onLoadingDecoderConnected);
            return;
        }// end function

        private function removeLoadingListeners() : void
        {
            if (this._loadingStream)
            {
                this._loadingStream.removeEventListener(ProviderEvent.Evt_Connected, this.onLoadingDecoderConnected);
            }
            return;
        }// end function

        private function switchLoadSegment(param1:HttpStream) : void
        {
            if (this._loadingStream)
            {
                this.removeLoadingListeners();
                if (this._loadingStream != this._playingStream)
                {
                    this._loadingStream.stopLoad();
                }
            }
            this._loadingStream = param1;
            this._loadingStream.seek();
            this.addLoadingListeners();
            if (this._loadingStream.ready)
            {
                this.onLoadingDecoderConnected(null);
            }
            return;
        }// end function

        override protected function onTimer(event:TimerEvent) : void
        {
            var _loc_4:Segment = null;
            var _loc_5:HttpStream = null;
            super.onTimer(event);
            if (this._streams == null || this._playingStream == null || this._playingStream && !this._playingStream.loadComplete)
            {
                return;
            }
            var _loc_2:* = this.currentTime;
            var _loc_3:* = _movie.curDefinition;
            if (this._playingStream.segment.index != (_loc_3.segmentCount - 1) && _loc_2 > this._playingStream.segment.endTime - 120000)
            {
                _loc_4 = _loc_3.findSegmentAt((this._playingStream.segment.index + 1));
                _loc_5 = this._streams[(this._playingStream.segment.index + 1)];
                if (_loc_5.failed)
                {
                    return;
                }
                if (_loc_4.currentKeyframe && _loc_4.currentKeyframe.index != 0)
                {
                    _loc_4.seek(_loc_4.startTime);
                }
                if (this._loadingStream != _loc_5)
                {
                    this.switchLoadSegment(_loc_5);
                }
            }
            return;
        }// end function

        private function onDecoderStatusChanged(event:DecoderEvent) : void
        {
            updateStatusByDecoder();
            return;
        }// end function

        private function onPlayingStop(event:ProviderEvent) : void
        {
            var _loc_2:* = _movie.curDefinition;
            if ((_loc_2.segmentCount - 1) == this._playingStream.segment.index)
            {
                this.selfStop(StopReasonEnum.STOP);
            }
            else
            {
                this.switchPlaySegment(this._streams[(this._playingStream.segment.index + 1)]);
            }
            return;
        }// end function

        private function onPlayingFailed(event:ProviderEvent) : void
        {
            setStatus(StatusEnum.FAILED);
            dispatchEvent(new EngineEvent(EngineEvent.Evt_Error));
            return;
        }// end function

        private function onPlayingDecoderConnected(event:ProviderEvent) : void
        {
            if (this._paused)
            {
                this._playingStream.pause();
            }
            else
            {
                this._playingStream.resume();
            }
            return;
        }// end function

        private function onPlayingDecoderChanged(event:ProviderEvent) : void
        {
            this.createDecoder();
            _render.bind(this, _decoder, _movie);
            updateStatusByDecoder();
            return;
        }// end function

        private function onLoadingDecoderConnected(event:ProviderEvent) : void
        {
            if (this._loadingStream != this._playingStream)
            {
                this._loadingStream.pause();
            }
            return;
        }// end function

        private function onAudioTrackChanged(event:Event) : void
        {
            if (_holder.hasStatus(StatusEnum.ALREADY_READY) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
            {
                _seekTime = this.currentTime;
                this.destroyStream();
                _movie.setCurAudioTrack(Settings.instance.audioTrack, _movie.curDefinition.type);
                if (_movie.curDefinition && _movie.curDefinition.type)
                {
                    _holder.runtimeData.currentDefinition = _movie.curDefinition.type.id.toString();
                }
                _holder.runtimeData.vid = _movie.vid;
                this.seek(_seekTime);
                dispatchEvent(new EngineEvent(EngineEvent.Evt_AudioTrackSwitched, 1));
            }
            return;
        }// end function

        private function onDefinitionChanged(event:Event) : void
        {
            if (_holder.hasStatus(StatusEnum.ALREADY_READY) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
            {
                _seekTime = this.currentTime;
                this.destroyStream();
                _movie.setCurDefinition(Settings.instance.definition);
                if (_movie.curDefinition && _movie.curDefinition.type)
                {
                    _holder.runtimeData.currentDefinition = _movie.curDefinition.type.id.toString();
                }
                _holder.runtimeData.vid = _movie.vid;
                this._definitionIsSwitched = true;
                if (_movie.curDefinition.ready)
                {
                    this.onMovieReady(null);
                }
                else
                {
                    _movie.startLoadMeta();
                    _movie.startLoadLicense();
                    if (_movie.curDefinition.ready)
                    {
                        this.onMovieReady(null);
                    }
                }
            }
            return;
        }// end function

        override protected function onMovieReady(event:Event) : void
        {
            if (this._definitionIsSwitched)
            {
                this.seek(_seekTime);
                dispatchEvent(new EngineEvent(EngineEvent.Evt_DefinitionSwitched, 1));
                this._definitionIsSwitched = false;
            }
            super.onMovieReady(event);
            return;
        }// end function

    }
}
