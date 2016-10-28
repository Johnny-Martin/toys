package com.qiyi.player.core.video.engine.dm
{
    import cmd5.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.events.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.engine.*;
    import com.qiyi.player.core.video.engine.dm.agents.*;
    import com.qiyi.player.core.video.engine.dm.provider.*;
    import com.qiyi.player.core.video.events.*;
    import com.qiyi.player.core.video.render.*;
    import com.qiyi.player.user.impls.*;
    import flash.events.*;
    import flash.utils.*;
    import loader.vod.*;

    public class DMEngine extends BaseEngine
    {
        private var _provider:Provider;
        private var _providerStateHandler:ProviderStateHandler;
        private var _openCheckDecoderData:Boolean = false;
        private var _rateAgent:RateAgent;
        private var _seeked:Boolean = false;
        private var _timeoutForWaiting:uint = 0;
        private var _timeoutForEmpty:uint = 0;
        private var _provierIsCreated:Boolean;
        private var _definitionIsSwitched:Boolean;

        public function DMEngine(param1:ICorePlayer)
        {
            super(param1);
            this._providerStateHandler = new ProviderStateHandler(param1);
            this._rateAgent = new RateAgent(_holder);
            this._rateAgent.addEventListener(RateAgentEvent.Evt_AudioTrackChanged, this.onAudioTrackChanged);
            this._rateAgent.addEventListener(RateAgentEvent.Evt_DefinitionChanged, this.onDefinitionChanged);
            return;
        }// end function

        public function get provider() : Provider
        {
            return this._provider;
        }// end function

        override public function get currentTime() : int
        {
            if (_decoder)
            {
                return _decoder.time;
            }
            return 0;
        }// end function

        override public function get bufferTime() : int
        {
            if (this._provider)
            {
                return this._provider.bufferLength;
            }
            return 0;
        }// end function

        override public function set openSelectPlay(param1:Boolean) : void
        {
            this.updateSelectFragments();
            return;
        }// end function

        override public function bind(param1:IMovie, param2:IRender) : void
        {
            if (_movie)
            {
                _movie.removeEventListener(MovieEvent.Evt_UpdateSkipPoint, this.onUpdateSkipPoint);
            }
            this._definitionIsSwitched = false;
            super.bind(param1, param2);
            this.destroyProvider();
            this.createDecoder();
            this.openListenDecoder();
            _render.bind(this, _decoder, _movie);
            setStatus(StatusEnum.ALREADY_READY);
            return;
        }// end function

        override public function startLoad() : void
        {
            super.startLoad();
            var _loc_1:* = this.checkEngineIsReady();
            if (!_holder.hasStatus(StatusEnum.ALREADY_PLAY))
            {
                _decoder.play(null);
                if (_loc_1)
                {
                    this.seek(_startTime);
                    this._rateAgent.startAutoAdjustRate();
                }
            }
            if (!_loc_1)
            {
                _holder.addStatus(StatusEnum.WAITING_START_LOAD, false);
                startLoadHistory();
                startLoadMeta();
                startLoadLicense();
                this.startLoadP2PCore();
            }
            this.pause();
            setStatus(StatusEnum.ALREADY_START_LOAD);
            return;
        }// end function

        override public function stopLoad() : void
        {
            super.stopLoad();
            if (this._provider)
            {
                this._provider.setLoadToggle(false);
            }
            return;
        }// end function

        override public function play() : void
        {
            var _loc_1:Boolean = false;
            if (!_holder.hasStatus(StatusEnum.ALREADY_PLAY))
            {
                super.play();
                _loc_1 = this.checkEngineIsReady();
                if (!_holder.hasStatus(StatusEnum.ALREADY_START_LOAD))
                {
                    _decoder.play(null);
                    if (_loc_1)
                    {
                        this.seek(_startTime);
                        this._rateAgent.startAutoAdjustRate();
                    }
                }
                else if (this._provider)
                {
                    this._provider.setLoadToggle(true);
                }
                if (this._provider)
                {
                    this._provider.setOpenPlay(true);
                }
                this.resume();
                if (!_loc_1)
                {
                    _holder.addStatus(StatusEnum.WAITING_PLAY, false);
                    startLoadHistory();
                    startLoadMeta();
                    startLoadLicense();
                    this.startLoadP2PCore();
                }
            }
            return;
        }// end function

        override public function resume() : void
        {
            super.resume();
            if (this._provider)
            {
                this._provider.setUserPauseToggle(false);
            }
            return;
        }// end function

        override public function replay() : void
        {
            if (_holder.hasStatus(StatusEnum.STOPED))
            {
                this.openListenDecoder();
                _decoder.play(null);
                super.replay();
            }
            return;
        }// end function

        override public function seek(param1:uint, param2:int = 0) : void
        {
            if (_movie == null || !_movie.curDefinition)
            {
                return;
            }
            this.openListenDecoder();
            this._seeked = true;
            _seekTime = param1;
            if (this.checkEngineIsReady())
            {
                super.seek(_seekTime, param2);
                this._provider.seek(_seekTime, _movie.curAudioTrack.type.id, _movie.curDefinition.type.id, param2);
                this._openCheckDecoderData = true;
            }
            _decoder.seek(_seekTime == 0 ? (100) : (_seekTime));
            return;
        }// end function

        override public function pause(param1:int = 0) : void
        {
            super.pause(param1);
            if (this._provider && (param1 & PauseTypeEnum.USER) != 0)
            {
                this._provider.setUserPauseToggle(true);
            }
            return;
        }// end function

        override public function stop(param1:EnumItem) : void
        {
            this._openCheckDecoderData = false;
            if (this._provider)
            {
                this._provider.setLoadToggle(false);
            }
            if (this._timeoutForWaiting)
            {
                clearTimeout(this._timeoutForWaiting);
                this._timeoutForWaiting = 0;
            }
            this.closeListenDecoder();
            super.stop(param1);
            return;
        }// end function

        override public function startLoadP2PCore() : void
        {
            _log.info("DMEngine.startLoadP2PCore(" + _holder.runtimeData.flashP2PCoreURL + "), has P2P_CORE_START_LOAD_CALLED:" + _holder.hasStatus(StatusEnum.P2P_CORE_START_LOAD_CALLED) + ", isLoading:" + P2PFileLoader.instance.isLoading + ", isDone:" + P2PFileLoader.instance.loadDone + ", isError:" + P2PFileLoader.instance.loadErr);
            if (_holder.hasStatus(StatusEnum.P2P_CORE_START_LOAD_CALLED))
            {
                return;
            }
            _holder.addStatus(StatusEnum.P2P_CORE_START_LOAD_CALLED, false);
            if (!P2PFileLoader.instance.isLoading)
            {
                if (P2PFileLoader.instance.loadDone)
                {
                    this.onP2PReady(null);
                    return;
                }
                if (P2PFileLoader.instance.loadErr)
                {
                    this.onP2PError(null);
                    return;
                }
            }
            if (ProcessesTimeRecord.STime_P2PCore == 0)
            {
                ProcessesTimeRecord.STime_P2PCore = getTimer();
            }
            P2PFileLoader.instance.addEventListener(P2PFileLoader.Evt_LoadDone, this.onP2PReady);
            P2PFileLoader.instance.addEventListener(P2PFileLoader.Evt_LoadError, this.onP2PError);
            if (!P2PFileLoader.instance.isLoading && !P2PFileLoader.instance.loadDone && !P2PFileLoader.instance.loadErr)
            {
                P2PFileLoader.instance.loadCore(_holder.runtimeData.flashP2PCoreURL);
            }
            return;
        }// end function

        override protected function selfStop(param1:EnumItem) : void
        {
            this._openCheckDecoderData = false;
            if (this._provider)
            {
                this._provider.setLoadToggle(false);
            }
            if (this._timeoutForWaiting)
            {
                clearTimeout(this._timeoutForWaiting);
                this._timeoutForWaiting = 0;
            }
            this.closeListenDecoder();
            super.selfStop(param1);
            return;
        }// end function

        override protected function stopedHandler() : void
        {
            if (_decoder)
            {
                _decoder.stop();
            }
            super.stopedHandler();
            return;
        }// end function

        override protected function onSkipTrailerChanged(event:Event) : void
        {
            var _loc_2:int = 0;
            if (this._provider)
            {
                _loc_2 = 0;
                if (_holder.runtimeData.originalEndTime > 0)
                {
                    _loc_2 = _holder.runtimeData.originalEndTime;
                }
                else if (_movie.trailerTime > 0 && Settings.instance.skipTrailer)
                {
                    _loc_2 = _movie.trailerTime;
                }
                this._provider.setEndTime(_loc_2);
            }
            super.onSkipTrailerChanged(event);
            return;
        }// end function

        override protected function onMovieReady(event:Event) : void
        {
            this.updateProvider();
            super.onMovieReady(event);
            return;
        }// end function

        override protected function checkNeedStartLoad() : void
        {
            if (_holder.hasStatus(StatusEnum.WAITING_START_LOAD) && this.checkEngineIsReady())
            {
                this._rateAgent.startAutoAdjustRate();
            }
            super.checkNeedStartLoad();
            return;
        }// end function

        override protected function checkNeedPlay() : void
        {
            if (_holder.hasStatus(StatusEnum.WAITING_PLAY) && this.checkEngineIsReady())
            {
                this._rateAgent.startAutoAdjustRate();
                if (this._provider)
                {
                    this._provider.setOpenPlay(true);
                }
            }
            super.checkNeedPlay();
            return;
        }// end function

        override public function checkEngineIsReady() : Boolean
        {
            var _loc_1:* = !P2PFileLoader.instance.isLoading && P2PFileLoader.instance.loadDone;
            return _loc_1 && super.checkEngineIsReady();
        }// end function

        override protected function onHistoryReady(event:Event) : void
        {
            super.onHistoryReady(event);
            if (this._provider && _holder.movie)
            {
                this._provider.setStartTime(_holder.strategy.getStartTime());
            }
            return;
        }// end function

        private function createDecoder() : void
        {
            if (_decoder)
            {
                this.closeListenDecoder();
                _decoder.destroy();
            }
            _decoder = new DataModeDecoder(_holder);
            _decoder.bufferTime = Config.STREAM_NORMAL_BUFFER_TIME / 1000;
            return;
        }// end function

        private function openListenDecoder() : void
        {
            if (_decoder)
            {
                _decoder.addEventListener(NetStatusEvent.NET_STATUS, this.onDecoderNetStatus);
                _decoder.addEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
                this.updateStatusByDecoder();
            }
            return;
        }// end function

        private function closeListenDecoder() : void
        {
            if (_decoder)
            {
                _decoder.removeEventListener(NetStatusEvent.NET_STATUS, this.onDecoderNetStatus);
                _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
            }
            return;
        }// end function

        private function createProvider() : void
        {
            _holder.pingBack.stopFlashP2PFailedCDN();
            this._provider = new Provider();
            this._provider.addEventListener(ProviderEvent.Evt_Failed, this.onProviderFailed);
            this._provider.addEventListener(ProviderEvent.Evt_StateChanged, this.onProviderStateChanged);
            var _loc_1:Number = 0;
            if (_holder.runtimeData.dispatcherServerTime > 0)
            {
                _loc_1 = uint(getTimer() / 1000) - _holder.runtimeData.dispatchFlashRunTime + _holder.runtimeData.dispatcherServerTime;
                _loc_1 = _loc_1 * 1000;
            }
            var _loc_2:int = 0;
            if (_holder.runtimeData.originalEndTime > 0)
            {
                _loc_2 = _holder.runtimeData.originalEndTime;
            }
            else if (_movie.trailerTime > 0 && Settings.instance.skipTrailer)
            {
                _loc_2 = _movie.trailerTime;
            }
            var _loc_3:String = "";
            if (_holder.movieInfo)
            {
                _loc_3 = _holder.movieInfo.source;
            }
            var _loc_4:int = -1;
            var _loc_5:* = _holder.history && _holder.history.getReady() || _holder.runtimeData.playerUseType != PlayerUseTypeEnum.MAIN;
            if (_loc_5)
            {
                _loc_4 = _holder.strategy.getStartTime();
            }
            var _loc_6:String = "";
            if (UserManager.getInstance().user)
            {
                _loc_6 = UserManager.getInstance().user.passportID;
            }
            this._provider.initProvider(_decoder, _holder.runtimeData.authentication, _loc_1, this.createVideoInfo(), this.createCurMetaInfo(), _movie.curAudioTrack.type.id, _movie.curDefinition.type.id, _loc_3, _movie.channelID, _movie.albumId, _movie.tvid, _loc_4, _loc_2, _holder.runtimeData.playerType.name, _holder.runtimeData.movieIsMember, _holder.runtimeData.openFlashP2P, _holder.uuid, _loc_6, _holder.runtimeData.userArea, calc, _holder.hasStatus(StatusEnum.ALREADY_PLAY), _holder.runtimeData.platform.id.toString(), _holder.runtimeData.areaPlatform.name.toString());
            _holder.runtimeData.stratusIP = "";
            this.updateSelectFragments();
            _movie.addEventListener(MovieEvent.Evt_UpdateSkipPoint, this.onUpdateSkipPoint, false, 1);
            this._provierIsCreated = true;
            return;
        }// end function

        private function destroyProvider() : void
        {
            if (this._provider)
            {
                this._provider.removeEventListener(ProviderEvent.Evt_Failed, this.onProviderFailed);
                this._provider.removeEventListener(ProviderEvent.Evt_StateChanged, this.onProviderStateChanged);
                this._provider.destroy();
                this._provider = null;
                this._provierIsCreated = false;
            }
            return;
        }// end function

        private function createVideoInfo() : Array
        {
            var _loc_3:AudioTrack = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:Definition = null;
            var _loc_7:int = 0;
            var _loc_8:Array = null;
            var _loc_9:int = 0;
            var _loc_10:Object = null;
            var _loc_11:Segment = null;
            var _loc_1:Array = [];
            var _loc_2:int = 0;
            while (_loc_2 < _movie.audioTrackCount)
            {
                
                _loc_3 = _movie.getAudioTrackAt(_loc_2);
                _loc_4 = _loc_3.definitionCount;
                _loc_5 = 0;
                while (_loc_5 < _loc_4)
                {
                    
                    _loc_6 = _loc_3.findDefinitionAt(_loc_5);
                    _loc_7 = _loc_6.segmentCount;
                    _loc_8 = new Array(_loc_7);
                    _loc_9 = 0;
                    while (_loc_9 < _loc_7)
                    {
                        
                        _loc_11 = _loc_6.findSegmentAt(_loc_9);
                        _loc_8[_loc_9] = {url:_loc_11.url, totalBytes:_loc_11.totalBytes, vid:_loc_11.vid, index:_loc_11.index, startTime:_loc_11.startTime, totalTime:_loc_11.totalTime, e:_loc_11.isDrm};
                        _loc_9++;
                    }
                    _loc_10 = {};
                    _loc_10.lid = _loc_3.type.id;
                    _loc_10.bid = _loc_6.type.id;
                    _loc_10.vid = _loc_6.vid;
                    _loc_10.videoConfigTag = _loc_6.videoConfigTag;
                    _loc_10.audioConfigTag = _loc_6.audioConfigTag;
                    _loc_10.segments = _loc_8;
                    _loc_1.push(_loc_10);
                    _loc_5++;
                }
                _loc_2++;
            }
            return _loc_1;
        }// end function

        private function createCurMetaInfo() : Array
        {
            var _loc_1:Definition = null;
            var _loc_2:int = 0;
            var _loc_3:Array = null;
            var _loc_4:int = 0;
            var _loc_5:Segment = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:int = 0;
            var _loc_9:Object = null;
            if (_movie.curDefinition.metaIsReady)
            {
                _loc_1 = _movie.curDefinition;
                _loc_2 = _loc_1.segmentCount;
                _loc_3 = new Array(_loc_2);
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_5 = _loc_1.findSegmentAt(_loc_4);
                    _loc_6 = new Array((_loc_5.keyframes.length + 1));
                    _loc_7 = new Array((_loc_5.keyframes.length + 1));
                    _loc_6[0] = _loc_5.firstKeyframe.segmentTime;
                    _loc_7[0] = _loc_5.firstKeyframe.position;
                    _loc_8 = 0;
                    while (_loc_8 < _loc_5.keyframes.length)
                    {
                        
                        _loc_6[(_loc_8 + 1)] = _loc_5.keyframes[_loc_8].segmentTime;
                        _loc_7[(_loc_8 + 1)] = _loc_5.keyframes[_loc_8].position;
                        _loc_8++;
                    }
                    _loc_9 = {keyframes:{times:_loc_6, filepositions:_loc_7}, tsc:_loc_1.timestampContinuous};
                    _loc_3[_loc_4] = _loc_9;
                    _loc_4++;
                }
                return _loc_3;
            }
            return null;
        }// end function

        private function updateSelectFragments() : void
        {
            var _loc_1:Array = null;
            var _loc_2:int = 0;
            var _loc_3:ISkipPointInfo = null;
            var _loc_4:Object = null;
            var _loc_5:int = 0;
            if (this._provider)
            {
                if (_holder.runtimeData.openSelectPlay)
                {
                    if (_movie && _movie.curDefinition && _movie.curDefinition.metaIsReady)
                    {
                        _loc_1 = [];
                        _loc_2 = _movie.skipPointInfoCount;
                        _loc_3 = null;
                        _loc_4 = null;
                        _loc_5 = 0;
                        _loc_5 = 0;
                        while (_loc_5 < _loc_2)
                        {
                            
                            _loc_3 = _movie.getSkipPointInfoAt(_loc_5);
                            if (_loc_3.skipPointType == SkipPointEnum.ENJOYABLE)
                            {
                                _loc_4 = new Object();
                                _loc_4.type = 6;
                                _loc_4.startTime = _loc_3.startTime;
                                _loc_4.endTime = _loc_3.endTime;
                                _loc_1.push(_loc_4);
                            }
                            _loc_5++;
                        }
                        if (_loc_1.length > 0)
                        {
                            this._provider.setFragments(_loc_1);
                        }
                    }
                }
                else
                {
                    this._provider.setFragments(null);
                }
            }
            return;
        }// end function

        private function onUpdateSkipPoint(event:MovieEvent) : void
        {
            this.updateSelectFragments();
            return;
        }// end function

        private function onDecoderNetStatus(event:NetStatusEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:EnumItem = null;
            switch(event.info.code)
            {
                case "NetStream.Buffer.Flush":
                {
                    _decoder.bufferTime = Config.STREAM_SHORT_BUFFER_TIME / 1000;
                    if (_decoder.bufferLength > _decoder.bufferTime)
                    {
                        break;
                    }
                }
                case "NetStream.Buffer.Empty":
                {
                    if (_decoder.bufferLength >= _decoder.bufferTime)
                    {
                        break;
                    }
                    if (this._provider.eof)
                    {
                        this.selfStop(StopReasonEnum.STOP);
                    }
                    else
                    {
                        _loc_2 = _holder.runtimeData.endTime;
                        _loc_3 = StopReasonEnum.REACH_ASSIGN;
                        if (_loc_2 == 0 && _holder.runtimeData.skipTrailer)
                        {
                            _loc_2 = _movie.trailerTime;
                            _loc_3 = StopReasonEnum.SKIP_TRAILER;
                        }
                        if (_loc_2 > 0 && Math.abs(_decoder.time - _loc_2) < 1000)
                        {
                            this.selfStop(_loc_3);
                        }
                        else if (this._provider.loadingFailed)
                        {
                            this.executeFail();
                        }
                        else
                        {
                            if (_decoder.status != DecoderStatusEnum.STOPPED)
                            {
                                this.pushDataToDecoder();
                            }
                            if (_decoder.bufferLength < 1)
                            {
                                if (!this._seeked)
                                {
                                    clearTimeout(this._timeoutForEmpty);
                                    this._timeoutForEmpty = setTimeout(this.onBufferEmpty, 500);
                                    dispatchEvent(new EngineEvent(EngineEvent.Evt_Stuck));
                                }
                                if (this._timeoutForWaiting)
                                {
                                    clearTimeout(this._timeoutForWaiting);
                                }
                                this._timeoutForWaiting = setTimeout(this.waitingLongTime, Config.SCREEN_BLANK_MAX);
                            }
                        }
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    clearTimeout(this._timeoutForEmpty);
                    this._timeoutForEmpty = 0;
                    if (this._timeoutForWaiting)
                    {
                        clearTimeout(this._timeoutForWaiting);
                        this._timeoutForWaiting = 0;
                    }
                    this._seeked = false;
                    if (this._provider)
                    {
                        this._provider.setStuckToggle(false);
                    }
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    if (_decoder.status != DecoderStatusEnum.STOPPED)
                    {
                        this.pushDataToDecoder();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onBufferEmpty() : void
        {
            clearTimeout(this._timeoutForEmpty);
            this._timeoutForEmpty = 0;
            if (this._provider)
            {
                this._provider.setStuckToggle(true);
            }
            var _loc_1:* = _holder.runtimeData;
            var _loc_2:* = _holder.runtimeData.bufferEmpty + 1;
            _loc_1.bufferEmpty = _loc_2;
            _holder.pingBack.sendError(4015);
            return;
        }// end function

        private function onDecoderStatusChanged(event:DecoderEvent) : void
        {
            this.updateStatusByDecoder();
            return;
        }// end function

        private function onProviderFailed(event:Event) : void
        {
            this._providerStateHandler.onFinalError(this._provider);
            this.executeFail();
            return;
        }// end function

        private function executeFail() : void
        {
            if (this._provider)
            {
                this._provider.setLoadToggle(false);
            }
            if (this._timeoutForWaiting)
            {
                clearTimeout(this._timeoutForWaiting);
                this._timeoutForWaiting = 0;
            }
            if (_decoder.bufferLength <= _decoder.bufferTime)
            {
                this._openCheckDecoderData = false;
                this.closeListenDecoder();
                setStatus(StatusEnum.FAILED);
                dispatchEvent(new EngineEvent(EngineEvent.Evt_Error));
            }
            return;
        }// end function

        private function waitingLongTime() : void
        {
            clearTimeout(this._timeoutForWaiting);
            this._timeoutForWaiting = 0;
            _holder.pingBack.sendError(4013);
            _holder.runtimeData.errorCode = 4013;
            return;
        }// end function

        private function onAudioTrackChanged(event:RateAgentEvent) : void
        {
            if (_holder.hasStatus(StatusEnum.ALREADY_READY) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
            {
                dispatchEvent(new EngineEvent(EngineEvent.Evt_AudioTrackSwitched, event.data));
                this.prepareSwitchMediaData();
            }
            return;
        }// end function

        private function onDefinitionChanged(event:RateAgentEvent) : void
        {
            if (_holder.hasStatus(StatusEnum.ALREADY_READY) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
            {
                dispatchEvent(new EngineEvent(EngineEvent.Evt_DefinitionSwitched, event.data));
                if (int(event.data) >= 0)
                {
                    this.prepareSwitchMediaData();
                }
            }
            return;
        }// end function

        private function prepareSwitchMediaData() : void
        {
            this._definitionIsSwitched = true;
            if (_movie.curDefinition && _movie.curDefinition.ready)
            {
                this.onMovieLicenseUpdate();
                this.onMovieMetaUpdate();
            }
            else
            {
                this._openCheckDecoderData = false;
                _movie.startLoadMeta();
                _movie.startLoadLicense();
                if (_movie.curDefinition.ready)
                {
                    this.onMovieLicenseUpdate();
                    this.onMovieMetaUpdate();
                }
            }
            return;
        }// end function

        private function onMovieLicenseUpdate() : void
        {
            if (_movie.curDefinition.isDrm)
            {
                _decoder.setLicense(_movie.curDefinition.license);
            }
            return;
        }// end function

        private function onMovieMetaUpdate() : void
        {
            var _loc_1:Number = NaN;
            if (!this._provider.loadingFailed && !_holder.hasStatus(StatusEnum.IDLE) && !_holder.hasStatus(StatusEnum.STOPPING) && !_holder.hasStatus(StatusEnum.STOPED) && !_holder.hasStatus(StatusEnum.FAILED))
            {
                this.openListenDecoder();
                _loc_1 = _decoder.time + _decoder.bufferLength * 1000;
                _movie.seek(_loc_1);
                if (_movie.curSegment.currentKeyframe)
                {
                    _loc_1 = _movie.getSeekTime();
                    this._provider.seek(_loc_1, _movie.curAudioTrack.type.id, _movie.curDefinition.type.id);
                }
                else
                {
                    _loc_1 = _movie.curSegment.startTime;
                    this._provider.seek(_loc_1, _movie.curAudioTrack.type.id, _movie.curDefinition.type.id);
                    _decoder.seek(_loc_1 == 0 ? (100) : (_loc_1));
                }
                this._provider.setMetaInfo(this.createCurMetaInfo());
                this._openCheckDecoderData = true;
            }
            return;
        }// end function

        override protected function updateStatusByDecoder() : void
        {
            if (_decoder)
            {
                switch(_decoder.status)
                {
                    case DecoderStatusEnum.PLAYING:
                    {
                        setStatus(StatusEnum.PLAYING);
                        break;
                    }
                    case DecoderStatusEnum.PAUSED:
                    {
                        setStatus(StatusEnum.PAUSED);
                        break;
                    }
                    case DecoderStatusEnum.SEEKING:
                    {
                        setStatus(StatusEnum.SEEKING);
                        break;
                    }
                    case DecoderStatusEnum.WAITING:
                    {
                        setStatus(StatusEnum.WAITING);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        override protected function onTimer(event:TimerEvent) : void
        {
            if (_holder.hasStatus(StatusEnum.ALREADY_READY) && !_holder.hasStatus(StatusEnum.STOPED) && this._movie && this._movie.curDefinition && _movie.curDefinition.licenseReady)
            {
                super.onTimer(event);
                this.checkDecoderData();
                if (this._provider && this._provider.fileState)
                {
                    _holder.runtimeData.currentSpeed = this._provider.fileState.averageSpeed;
                    _holder.runtimeData.currentAverageSpeed = this._provider.fileState.averageSpeed;
                }
            }
            return;
        }// end function

        private function checkDecoderData() : void
        {
            if (this._openCheckDecoderData)
            {
                if (_decoder && _decoder.status != DecoderStatusEnum.STOPPED && _decoder.bufferLength * 1000 < Config.STREAM_NORMAL_BUFFER_TIME + 2000)
                {
                    this.pushDataToDecoder();
                }
            }
            return;
        }// end function

        private function pushDataToDecoder() : void
        {
            var _loc_1:MediaData = null;
            if (this._provider && _decoder && !this._provider.eof)
            {
                _loc_1 = this._provider.sequenceReadData();
                if (_loc_1)
                {
                    DataModeDecoder(_decoder).appendData(_loc_1);
                    _log.info("decoder bufferLength: " + _decoder.bufferLength * 1000);
                }
                if (this._provider.eof)
                {
                    DataModeDecoder(_decoder).endSequence();
                }
                if (this._provider.loadingFailed)
                {
                    if (_decoder.bufferLength <= _decoder.bufferTime)
                    {
                        _log.debug("DMEngine pushDataToDecoder : provider is failed!");
                        this.executeFail();
                    }
                }
            }
            return;
        }// end function

        private function onProviderStateChanged(event:Event) : void
        {
            this._providerStateHandler.onStateChanged(this._provider);
            return;
        }// end function

        private function onP2PReady(event:Event) : void
        {
            _log.debug("DMEngine.onP2PReady, has status waiting startLoad or play : " + (_holder.hasStatus(StatusEnum.WAITING_START_LOAD) || _holder.hasStatus(StatusEnum.WAITING_PLAY)));
            if (ProcessesTimeRecord.usedTime_P2PCore == 0)
            {
                ProcessesTimeRecord.usedTime_P2PCore = getTimer() - ProcessesTimeRecord.STime_P2PCore;
            }
            if (Version.VERSION_FLASH_P2P == "")
            {
                Version.VERSION_FLASH_P2P = P2PFileLoader.instance.version;
                _log.info("P2P core load success, version: " + Version.VERSION_FLASH_P2P);
            }
            this.updateProvider();
            this.checkNeedStartLoad();
            this.checkNeedPlay();
            return;
        }// end function

        private function onP2PError(event:Event) : void
        {
            if (ProcessesTimeRecord.usedTime_P2PCore == 0)
            {
                ProcessesTimeRecord.usedTime_P2PCore = getTimer() - ProcessesTimeRecord.STime_P2PCore;
            }
            _log.info("P2P core load error!");
            this.executeFail();
            return;
        }// end function

        private function updateProvider() : void
        {
            var _loc_1:* = !P2PFileLoader.instance.isLoading && P2PFileLoader.instance.loadDone;
            var _loc_2:* = _movie && _movie.curDefinition && _movie.curDefinition.ready;
            if (_loc_1 && _loc_2)
            {
                _log.info("DMEngine.updateProvider, holder is preload : " + _holder.isPreload + " , _provider is null : " + !this._provider + " , switch definition : " + this._definitionIsSwitched);
                if (!this._provierIsCreated)
                {
                    this.createProvider();
                    this._rateAgent.bind(_decoder, _render, this._provider, _movie);
                }
                else if (this._definitionIsSwitched)
                {
                    this.onMovieLicenseUpdate();
                    this.onMovieMetaUpdate();
                }
                this._definitionIsSwitched = false;
            }
            return;
        }// end function

        override public function destroy() : void
        {
            if (_holder && _holder.pingBack)
            {
                _holder.pingBack.stopFlashP2PFailedCDN();
            }
            this._rateAgent.removeEventListener(RateAgentEvent.Evt_AudioTrackChanged, this.onAudioTrackChanged);
            this._rateAgent.removeEventListener(RateAgentEvent.Evt_DefinitionChanged, this.onDefinitionChanged);
            this._rateAgent.destroy();
            this._rateAgent = null;
            if (this._provider)
            {
                this._provider.removeEventListener(ProviderEvent.Evt_Failed, this.onProviderFailed);
                this._provider.removeEventListener(ProviderEvent.Evt_StateChanged, this.onProviderStateChanged);
                this._provider.destroy();
                this._provider = null;
            }
            this._providerStateHandler = null;
            if (_movie)
            {
                _movie.removeEventListener(MovieEvent.Evt_UpdateSkipPoint, this.onUpdateSkipPoint);
            }
            if (_decoder)
            {
                _decoder.removeEventListener(NetStatusEvent.NET_STATUS, this.onDecoderNetStatus);
                _decoder.removeEventListener(DecoderEvent.Evt_StatusChanged, this.onDecoderStatusChanged);
                _decoder.destroy();
                _decoder = null;
            }
            if (this._timeoutForWaiting)
            {
                clearTimeout(this._timeoutForWaiting);
                this._timeoutForWaiting = 0;
            }
            if (this._timeoutForEmpty)
            {
                clearTimeout(this._timeoutForEmpty);
                this._timeoutForEmpty = 0;
            }
            P2PFileLoader.instance.removeEventListener(P2PFileLoader.Evt_LoadDone, this.onP2PReady);
            P2PFileLoader.instance.removeEventListener(P2PFileLoader.Evt_LoadError, this.onP2PError);
            super.destroy();
            return;
        }// end function

    }
}
