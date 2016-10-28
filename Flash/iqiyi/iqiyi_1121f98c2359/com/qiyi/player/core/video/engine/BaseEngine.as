package com.qiyi.player.core.video.engine
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.history.events.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.events.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.remote.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.events.*;
    import com.qiyi.player.core.video.render.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class BaseEngine extends EventDispatcher implements IEngine
    {
        protected var _holder:ICorePlayer;
        protected var _movie:IMovie;
        protected var _render:IRender;
        protected var _decoder:IDecoder;
        protected var _seekTime:int;
        protected var _startTime:int;
        private var _timer:Timer;
        private var _playingDuration:int = 0;
        private var _playingDurationStartTime:int = 0;
        private var _startPlayTime:int = 0;
        private var _stopPlayTime:int = 0;
        private var _lastDuration:int = 0;
        private var _stopReason:EnumItem;
        private var _stopTimeOut:uint;
        private var _needDispatchPrepareStop:Boolean = true;
        private var _needDispatchPrepareSkipPoint:Boolean = true;
        private var _needDispatchEnterSkipPoint:Boolean = true;
        private var _curSkipPointInfo:SkipPointInfo;
        private var _oldCurrentTime:uint = 0;
        private var _authRemote:AuthenticationRemote;
        private var _authRemoteTriggered:Boolean = false;
        protected var _log:ILogger;

        public function BaseEngine(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.video.engine.BaseEngine");
            this._holder = param1;
            this._timer = new Timer(200);
            this._timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this._timer.start();
            Settings.instance.addEventListener(Settings.Evt_SkipTitleChanged, this.onSkipTitleChanged);
            Settings.instance.addEventListener(Settings.Evt_SkipTrailerChanged, this.onSkipTrailerChanged);
            if (this._holder.history)
            {
                this._holder.history.addEventListener(HistoryEvent.Evt_Ready, this.onHistoryReady);
            }
            return;
        }// end function

        public function get movie() : IMovie
        {
            return this._movie;
        }// end function

        public function get status() : EnumItem
        {
            return null;
        }// end function

        public function get currentTime() : int
        {
            return 0;
        }// end function

        public function get bufferTime() : int
        {
            return 0;
        }// end function

        public function get bufferRate() : Number
        {
            return 0;
        }// end function

        public function get waitingDuration() : int
        {
            if (this._holder.hasStatus(StatusEnum.STOPPING) || this._holder.hasStatus(StatusEnum.STOPED))
            {
                return this._stopPlayTime - this._startPlayTime - this.playingDuration;
            }
            return getTimer() - this.playingDuration - this._startPlayTime;
        }// end function

        public function get playingDuration() : int
        {
            if (this._holder.hasStatus(StatusEnum.PLAYING))
            {
                return this._playingDuration + getTimer() - this._playingDurationStartTime;
            }
            return this._playingDuration;
        }// end function

        public function get stopReason() : EnumItem
        {
            return this._stopReason;
        }// end function

        public function get frameRate() : int
        {
            return this._decoder ? (this._decoder.netstream.currentFPS) : (0);
        }// end function

        public function get decoderInfo() : NetStreamInfo
        {
            try
            {
                return this._decoder ? (this._decoder.netstream.info) : (null);
            }
            catch (error:Error)
            {
            }
            return null;
        }// end function

        public function set openSelectPlay(param1:Boolean) : void
        {
            return;
        }// end function

        public function bind(param1:IMovie, param2:IRender) : void
        {
            if (this._movie)
            {
                this._movie.removeEventListener(MovieEvent.Evt_Ready, this.onMovieReady);
            }
            this._movie = param1;
            this._movie.addEventListener(MovieEvent.Evt_Ready, this.onMovieReady);
            this._render = param2;
            this._startTime = 0;
            this._oldCurrentTime = 0;
            this._seekTime = 0;
            this._holder.runtimeData.currentDefinition = this._movie.curDefinition.type.id.toString();
            this._holder.runtimeData.movieInfo = "tv_" + this._movie.albumId + "_" + this._movie.tvid + "_" + this._movie.vid;
            this._holder.runtimeData.endTime = 0;
            if (this._holder.runtimeData.originalEndTime > 0)
            {
                this._holder.runtimeData.endTime = this._holder.runtimeData.originalEndTime;
                if (this._holder.runtimeData.endTime >= this._movie.duration)
                {
                    this._holder.runtimeData.endTime = 0;
                }
            }
            return;
        }// end function

        public function startLoadMeta() : void
        {
            if (this._holder.hasStatus(StatusEnum.META_START_LOAD_CALLED))
            {
                return;
            }
            this._holder.addStatus(StatusEnum.META_START_LOAD_CALLED, false);
            if (this._movie.curDefinition)
            {
                if (!this._movie.curDefinition.ready)
                {
                    this._movie.startLoadMeta();
                    if (this._movie.curDefinition.ready)
                    {
                        this.onMovieReady(null);
                    }
                }
                else
                {
                    this.onMovieReady(null);
                }
            }
            return;
        }// end function

        public function startLoadLicense() : void
        {
            if (this._movie.curDefinition)
            {
                if (!this._movie.curDefinition.ready)
                {
                    this._movie.startLoadLicense();
                }
                else
                {
                    this.onMovieReady(null);
                }
            }
            return;
        }// end function

        public function startLoadHistory() : void
        {
            if (this._holder.hasStatus(StatusEnum.HISTORY_START_LOAD_CALLED) || this._holder.history == null)
            {
                return;
            }
            if (this._movie.curDefinition)
            {
                this._holder.addStatus(StatusEnum.HISTORY_START_LOAD_CALLED, false);
                if (this._holder.history.getReady() == false)
                {
                    this._holder.history.loadRecord(this._movie.tvid);
                }
                if (this._holder.history.getReady())
                {
                    this.onHistoryReady(null);
                }
            }
            return;
        }// end function

        public function startLoadP2PCore() : void
        {
            return;
        }// end function

        public function startLoad() : void
        {
            if (this._holder.hasStatus(StatusEnum.IDLE))
            {
                throw new Error("please execute function of \'bind\' firstly!");
            }
            if (this._startTime == 0)
            {
                this._startTime = this._holder.strategy.getStartTime();
            }
            this._log.info("Engine:startLoad, startTime(" + this._startTime + ")" + ",preloader(" + this._holder.runtimeData.isPreload + ")");
            return;
        }// end function

        public function stopLoad() : void
        {
            this._holder.removeStatus(StatusEnum.WAITING_START_LOAD, false);
            this._holder.removeStatus(StatusEnum.ALREADY_START_LOAD);
            this._log.info("Engine:stopLoad, preloader(" + this._holder.runtimeData.isPreload + ")");
            return;
        }// end function

        public function play() : void
        {
            if (this._holder.hasStatus(StatusEnum.IDLE))
            {
                throw new Error("please execute function of \'bind\' firstly!");
            }
            if (this._holder.hasStatus(StatusEnum.STOPPING) || this._holder.hasStatus(StatusEnum.STOPED))
            {
                throw new Error("failed to play, the status of engine is stopped");
            }
            this._holder.runtimeData.bufferEmpty = 0;
            this._startPlayTime = getTimer();
            if (this.checkEngineIsReady())
            {
                this.updateVideoStartTime();
                this.onStartPlay();
            }
            this.setStatus(StatusEnum.ALREADY_PLAY);
            this._log.info("Engine:play called");
            return;
        }// end function

        public function replay() : void
        {
            this._startTime = this._holder.strategy.getStartTime();
            this._oldCurrentTime = this._startTime;
            this.seek(this._startTime);
            this.resume();
            return;
        }// end function

        public function pause(param1:int = 0) : void
        {
            if (this._decoder)
            {
                this._decoder.pause();
            }
            return;
        }// end function

        public function resume() : void
        {
            if (this._decoder)
            {
                this._decoder.resume();
            }
            return;
        }// end function

        public function stop(param1:EnumItem) : void
        {
            if (this._holder.hasStatus(StatusEnum.IDLE))
            {
                return;
            }
            this._seekTime = 0;
            if (this._movie)
            {
                this._movie.removeEventListener(MovieEvent.Evt_Ready, this.onMovieReady);
            }
            if (!this._holder.hasStatus(StatusEnum.STOPPING) && !this._holder.hasStatus(StatusEnum.STOPED))
            {
                this._stopReason = param1;
            }
            this.setStatus(StatusEnum.STOPPING);
            this._playingDurationStartTime = 0;
            this._playingDuration = 0;
            this._lastDuration = 0;
            this._stopPlayTime = 0;
            this._startPlayTime = 0;
            this._startTime = 0;
            this._oldCurrentTime = 0;
            this._authRemoteTriggered = false;
            this.stopAuthRemote();
            return;
        }// end function

        public function seek(param1:uint, param2:int = 0) : void
        {
            var _loc_6:Keyframe = null;
            if (this._holder.hasStatus(StatusEnum.IDLE))
            {
                throw new Error("please execute function of \'bind\' firstly!");
            }
            if (this._movie == null || !this._movie.curDefinition)
            {
                return;
            }
            this._log.info("Engine:seek(" + param1 + ")");
            this._movie.seek(param1);
            var _loc_3:* = this._movie.curSegment;
            var _loc_4:* = _loc_3.currentKeyframe;
            if (this._movie.streamType == StreamEnum.HTTP)
            {
                if (_loc_4)
                {
                    if (_loc_3.keyframes.length >= 2 && _loc_4.index == (_loc_3.keyframes.length - 1))
                    {
                        _loc_6 = _loc_3.keyframes[_loc_3.keyframes.length - 2];
                        this._seekTime = _loc_6.time;
                        this._movie.seek(this._seekTime);
                        _loc_3 = this._movie.curSegment;
                        _loc_4 = _loc_3.currentKeyframe;
                        this._seekTime = _loc_4.time;
                    }
                    else
                    {
                        this._seekTime = _loc_4.time;
                    }
                }
                else
                {
                    this._seekTime = _loc_3.startTime;
                }
            }
            else
            {
                this._seekTime = param1;
            }
            if (this._seekTime > this._holder.runtimeData.endTime)
            {
                this._holder.runtimeData.endTime = 0;
            }
            var _loc_5:* = this._holder.runtimeData.endTime > 0 ? (this._holder.runtimeData.endTime) : (this._movie.duration);
            if (_loc_5 - this._seekTime < this._holder.runtimeData.prepareToPlayEnd)
            {
                this._needDispatchPrepareStop = true;
            }
            if (Settings.instance.skipTrailer)
            {
                if (this._movie.streamType == StreamEnum.HTTP)
                {
                    if (this._movie.trailerTime > 0 && _loc_4 && _loc_4.time < this._movie.trailerTime)
                    {
                        this._holder.runtimeData.skipTrailer = true;
                    }
                    else
                    {
                        this._holder.runtimeData.skipTrailer = false;
                    }
                }
                else if (this._movie.trailerTime > 0 && this._seekTime < this._movie.trailerTime)
                {
                    this._holder.runtimeData.skipTrailer = true;
                }
                else
                {
                    this._holder.runtimeData.skipTrailer = false;
                }
            }
            else
            {
                this._holder.runtimeData.skipTrailer = false;
            }
            if (this._decoder)
            {
                if (_loc_5 - this._seekTime < Config.STREAM_NORMAL_BUFFER_TIME && _loc_5 - this._seekTime > 0)
                {
                    this._decoder.bufferTime = Config.STREAM_SHORT_BUFFER_TIME / 1000;
                }
                else
                {
                    this._decoder.bufferTime = Config.STREAM_NORMAL_BUFFER_TIME / 1000;
                }
            }
            return;
        }// end function

        public function destroy() : void
        {
            Settings.instance.removeEventListener(Settings.Evt_SkipTitleChanged, this.onSkipTitleChanged);
            Settings.instance.removeEventListener(Settings.Evt_SkipTrailerChanged, this.onSkipTrailerChanged);
            if (this._movie)
            {
                this._movie.removeEventListener(MovieEvent.Evt_Ready, this.onMovieReady);
                this._movie = null;
            }
            if (this._holder.history)
            {
                this._holder.history.removeEventListener(HistoryEvent.Evt_Ready, this.onHistoryReady);
            }
            this._holder = null;
            this._render = null;
            if (this._stopTimeOut != 0)
            {
                clearTimeout(this._stopTimeOut);
                this._stopTimeOut = 0;
            }
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
            this._timer = null;
            return;
        }// end function

        protected function setStatus(param1:int) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:int = 0;
            if (this._holder.hasStatus(StatusEnum.STOPED) && param1 == StatusEnum.STOPPING)
            {
                return;
            }
            if (!this._holder.hasStatus(param1))
            {
                _loc_2 = 0;
                _loc_3 = getTimer();
                switch(param1)
                {
                    case StatusEnum.ALREADY_READY:
                    {
                        this._holder.removeStatus(StatusEnum.IDLE);
                        this._holder.removeStatus(StatusEnum.ALREADY_LOAD_MOVIE);
                        this._holder.removeStatus(StatusEnum.STOPPING);
                        this._holder.removeStatus(StatusEnum.STOPED);
                        this._log.info("engine status changed: already ready");
                        break;
                    }
                    case StatusEnum.ALREADY_START_LOAD:
                    {
                        this._log.info("engine status changed: already startLoad");
                        break;
                    }
                    case StatusEnum.ALREADY_PLAY:
                    {
                        this._holder.removeStatus(StatusEnum.WAITING_START_LOAD, false);
                        this._log.info("engine status changed: already play");
                        break;
                    }
                    case StatusEnum.PLAYING:
                    {
                        this._holder.removeStatus(StatusEnum.PAUSED);
                        this._holder.removeStatus(StatusEnum.SEEKING);
                        this._holder.removeStatus(StatusEnum.WAITING);
                        this._holder.removeStatus(StatusEnum.STOPPING);
                        this._holder.removeStatus(StatusEnum.STOPED);
                        this._holder.removeStatus(StatusEnum.FAILED);
                        this._log.info("engine status changed: playing");
                        break;
                    }
                    case StatusEnum.PAUSED:
                    {
                        this._holder.removeStatus(StatusEnum.PLAYING);
                        this._holder.removeStatus(StatusEnum.STOPPING);
                        this._holder.removeStatus(StatusEnum.STOPED);
                        this._holder.removeStatus(StatusEnum.FAILED);
                        this._log.info("engine status changed: paused");
                        break;
                    }
                    case StatusEnum.SEEKING:
                    {
                        this._holder.removeStatus(StatusEnum.PLAYING);
                        this._holder.removeStatus(StatusEnum.WAITING);
                        this._holder.removeStatus(StatusEnum.STOPPING);
                        this._holder.removeStatus(StatusEnum.STOPED);
                        this._holder.removeStatus(StatusEnum.FAILED);
                        this._log.info("engine status changed: seeking");
                        break;
                    }
                    case StatusEnum.WAITING:
                    {
                        this._holder.removeStatus(StatusEnum.PLAYING);
                        this._holder.removeStatus(StatusEnum.SEEKING);
                        this._holder.removeStatus(StatusEnum.STOPPING);
                        this._holder.removeStatus(StatusEnum.STOPED);
                        this._holder.removeStatus(StatusEnum.FAILED);
                        this._log.info("engine status changed: waiting");
                        break;
                    }
                    case StatusEnum.STOPPING:
                    {
                        this._holder.removeStatus(StatusEnum.PLAYING);
                        this._holder.removeStatus(StatusEnum.PAUSED);
                        this._holder.removeStatus(StatusEnum.SEEKING);
                        this._holder.removeStatus(StatusEnum.WAITING);
                        this._holder.removeStatus(StatusEnum.STOPED);
                        this._holder.removeStatus(StatusEnum.FAILED);
                        this._holder.removeStatus(StatusEnum.WAITING_START_LOAD, false);
                        this._holder.removeStatus(StatusEnum.WAITING_PLAY, false);
                        this._log.info("engine status changed: stopping");
                        break;
                    }
                    case StatusEnum.STOPED:
                    {
                        this._holder.removeStatus(StatusEnum.PLAYING);
                        this._holder.removeStatus(StatusEnum.PAUSED);
                        this._holder.removeStatus(StatusEnum.SEEKING);
                        this._holder.removeStatus(StatusEnum.WAITING);
                        this._holder.removeStatus(StatusEnum.STOPPING);
                        this._holder.removeStatus(StatusEnum.FAILED);
                        this._holder.removeStatus(StatusEnum.WAITING_START_LOAD, false);
                        this._holder.removeStatus(StatusEnum.WAITING_PLAY, false);
                        this._log.info("engine status changed: stopped");
                        break;
                    }
                    case StatusEnum.FAILED:
                    {
                        this._holder.removeStatus(StatusEnum.PLAYING);
                        this._holder.removeStatus(StatusEnum.PAUSED);
                        this._holder.removeStatus(StatusEnum.SEEKING);
                        this._holder.removeStatus(StatusEnum.WAITING);
                        this._holder.removeStatus(StatusEnum.STOPPING);
                        this._holder.removeStatus(StatusEnum.STOPED);
                        this._holder.removeStatus(StatusEnum.WAITING_START_LOAD, false);
                        this._holder.removeStatus(StatusEnum.WAITING_PLAY, false);
                        this._log.info("engine status changed: failed");
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (param1 == StatusEnum.STOPPING)
                {
                    this._stopPlayTime = _loc_3;
                }
                else
                {
                    this._stopPlayTime = 0;
                }
                this._holder.addStatus(param1);
                if (param1 == StatusEnum.PLAYING)
                {
                    this._playingDurationStartTime = _loc_3;
                    this._seekTime = -1;
                }
                else
                {
                    if (this._playingDurationStartTime > 0)
                    {
                        this._playingDuration = this._playingDuration + (_loc_3 - this._playingDurationStartTime);
                    }
                    this._playingDurationStartTime = 0;
                }
                if (param1 == StatusEnum.STOPPING && this._holder.history)
                {
                    if (this.stopReason == StopReasonEnum.SKIP_TRAILER || this.stopReason == StopReasonEnum.STOP)
                    {
                        this._holder.history.update(0);
                    }
                    this._holder.history.flush();
                    if (this._stopTimeOut != 0)
                    {
                        clearTimeout(this._stopTimeOut);
                        this._stopTimeOut = 0;
                    }
                    this._stopTimeOut = setTimeout(this.stopedHandler, 60);
                }
                else if (this._stopTimeOut != 0)
                {
                    clearTimeout(this._stopTimeOut);
                    this._stopTimeOut = 0;
                }
            }
            return;
        }// end function

        protected function selfStop(param1:EnumItem) : void
        {
            if (this._holder.hasStatus(StatusEnum.IDLE))
            {
                return;
            }
            this._seekTime = 0;
            if (!this._holder.hasStatus(StatusEnum.STOPPING) && !this._holder.hasStatus(StatusEnum.STOPED))
            {
                this._stopReason = param1;
            }
            this.setStatus(StatusEnum.STOPPING);
            this._playingDurationStartTime = 0;
            this._playingDuration = 0;
            this._lastDuration = 0;
            this._stopPlayTime = 0;
            this._startPlayTime = 0;
            this._startTime = 0;
            this._oldCurrentTime = 0;
            this._authRemoteTriggered = false;
            this.stopAuthRemote();
            return;
        }// end function

        protected function updateStatusByDecoder() : void
        {
            if (this._decoder)
            {
                switch(this._decoder.status)
                {
                    case DecoderStatusEnum.PLAYING:
                    {
                        this.setStatus(StatusEnum.PLAYING);
                        break;
                    }
                    case DecoderStatusEnum.PAUSED:
                    {
                        this.setStatus(StatusEnum.PAUSED);
                        break;
                    }
                    case DecoderStatusEnum.SEEKING:
                    {
                        this.setStatus(StatusEnum.SEEKING);
                        break;
                    }
                    case DecoderStatusEnum.WAITING:
                    {
                        this.setStatus(StatusEnum.WAITING);
                        break;
                    }
                    case DecoderStatusEnum.FAILED:
                    {
                        this.setStatus(StatusEnum.FAILED);
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

        protected function onTimer(event:TimerEvent) : void
        {
            if (this._holder.runtimeData.playerUseType != PlayerUseTypeEnum.MAIN)
            {
                return;
            }
            if (this._holder.hasStatus(StatusEnum.STOPPING) || this._holder.hasStatus(StatusEnum.STOPED) || this._holder.hasStatus(StatusEnum.FAILED))
            {
                return;
            }
            var _loc_2:* = this.currentTime;
            if ((this._holder.hasStatus(StatusEnum.PLAYING) || this._holder.hasStatus(StatusEnum.SEEKING) || this._holder.hasStatus(StatusEnum.WAITING)) && this.playingDuration > 1000)
            {
                if (this._holder.runtimeData.recordHistory && _loc_2 > 1000 && this._holder.history && this._holder.hasStatus(StatusEnum.ALREADY_PLAY))
                {
                    this._holder.history.update(_loc_2);
                }
                Statistics.instance.addDuration(this.playingDuration - this._lastDuration);
                this._lastDuration = this.playingDuration;
            }
            if (!this._holder.hasStatus(StatusEnum.PLAYING))
            {
                return;
            }
            this.triggerSecondAuthRemote();
            if (_loc_2 > this._movie.duration + 100000)
            {
                this._log.warn("Decoder currentTime error! currentTime:" + _loc_2 + ",oldCurrentTime:" + this._oldCurrentTime + ",duration:" + this._movie.duration);
                this.seek(this._oldCurrentTime);
                return;
            }
            this._oldCurrentTime = _loc_2;
            var _loc_3:* = this._movie.skipPointInfoCount;
            var _loc_4:SkipPointInfo = null;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_4 = this._movie.getSkipPointInfoAt(_loc_5) as SkipPointInfo;
                if (_loc_4 == null)
                {
                    break;
                }
                if (this._holder.runtimeData.prepareToSkipPoint > 0 && _loc_4.startTime - _loc_2 <= this._holder.runtimeData.prepareToSkipPoint && _loc_4.startTime - _loc_2 > 0)
                {
                    _loc_4.inCurPrepareSkipPoint = true;
                    _loc_4.outPrepareSkipPointFlag = false;
                    if (!_loc_4.enterPrepareSkipPointFlag)
                    {
                        _loc_4.enterPrepareSkipPointFlag = true;
                        dispatchEvent(new EngineEvent(EngineEvent.Evt_EnterPrepareSkipPoint, _loc_4));
                    }
                }
                else
                {
                    if (_loc_4.inCurPrepareSkipPoint)
                    {
                        if (!_loc_4.outPrepareSkipPointFlag)
                        {
                            _loc_4.outPrepareSkipPointFlag = true;
                            dispatchEvent(new EngineEvent(EngineEvent.Evt_OutPrepareSkipPoint, _loc_4));
                        }
                    }
                    _loc_4.inCurPrepareSkipPoint = false;
                    _loc_4.enterPrepareSkipPointFlag = false;
                }
                if (this._holder.runtimeData.prepareLeaveSkipPoint > 0 && _loc_4.endTime - _loc_2 < this._holder.runtimeData.prepareLeaveSkipPoint && _loc_4.endTime - _loc_2 >= 0)
                {
                    _loc_4.inCurPrepareLeaveSkipPoint = true;
                    _loc_4.outPrepareLeaveSkipPointFlag = false;
                    if (!_loc_4.enterPrepareLeaveSkipPointFlag)
                    {
                        _loc_4.enterPrepareLeaveSkipPointFlag = true;
                        dispatchEvent(new EngineEvent(EngineEvent.Evt_EnterPrepareLeaveSkipPoint, _loc_4));
                    }
                }
                else
                {
                    if (_loc_4.inCurPrepareLeaveSkipPoint)
                    {
                        if (!_loc_4.outPrepareLeaveSkipPointFlag)
                        {
                            _loc_4.outPrepareLeaveSkipPointFlag = true;
                            dispatchEvent(new EngineEvent(EngineEvent.Evt_OutPrepareLeaveSkipPoint, _loc_4));
                        }
                    }
                    _loc_4.inCurPrepareLeaveSkipPoint = false;
                    _loc_4.enterPrepareLeaveSkipPointFlag = false;
                }
                if (_loc_2 >= _loc_4.startTime && _loc_2 < _loc_4.endTime)
                {
                    _loc_4.inCurSkipPoint = true;
                    _loc_4.outSkipPointFlag = false;
                    if (!_loc_4.enterSkipPointFlag)
                    {
                        _loc_4.enterSkipPointFlag = true;
                        dispatchEvent(new EngineEvent(EngineEvent.Evt_EnterSkipPoint, _loc_4));
                    }
                }
                else
                {
                    if (_loc_4.inCurSkipPoint)
                    {
                        if (!_loc_4.outSkipPointFlag)
                        {
                            _loc_4.outSkipPointFlag = true;
                            dispatchEvent(new EngineEvent(EngineEvent.Evt_OutSkipPoint, _loc_4));
                        }
                    }
                    _loc_4.inCurSkipPoint = false;
                    _loc_4.enterSkipPointFlag = false;
                }
                _loc_5++;
            }
            if (this._holder.hasStatus(StatusEnum.STOPPING) || this._holder.hasStatus(StatusEnum.STOPED) || this._holder.hasStatus(StatusEnum.FAILED))
            {
                return;
            }
            var _loc_6:int = 0;
            if (this._holder.runtimeData.originalEndTime > 0)
            {
                _loc_6 = this._holder.runtimeData.originalEndTime;
            }
            else if (this._movie.trailerTime > 0 && this._holder.runtimeData.skipTrailer)
            {
                _loc_6 = this._movie.trailerTime;
            }
            else
            {
                _loc_6 = this._movie.duration;
            }
            if (this._holder.runtimeData.prepareToPlayEnd > 0 && _loc_6 - _loc_2 <= this._holder.runtimeData.prepareToPlayEnd)
            {
                if (this._needDispatchPrepareStop)
                {
                    this._needDispatchPrepareStop = false;
                    this._log.info("prepare to end,curTime:" + _loc_2 + ",duration:" + this._movie.duration + ",endTime:" + _loc_6);
                    dispatchEvent(new EngineEvent(EngineEvent.Evt_PreparePlayEnd));
                }
            }
            else
            {
                this._needDispatchPrepareStop = true;
            }
            if (this._holder.runtimeData.originalEndTime > 0)
            {
                if (_loc_2 >= this._holder.runtimeData.originalEndTime)
                {
                    this._log.info("arrive at endTime,curTime:" + _loc_2 + ",duration:" + this._movie.duration + ",appdata.endTime:" + this._holder.runtimeData.originalEndTime);
                    this.selfStop(StopReasonEnum.REACH_ASSIGN);
                }
                return;
            }
            if (this._holder.runtimeData.skipTrailer && this._movie.trailerTime > 0)
            {
                if (_loc_2 >= this._movie.trailerTime)
                {
                    this._log.info("skip trailer,curTime:" + _loc_2 + ",duration:" + this._movie.duration + ",trailerTime:" + this._movie.trailerTime);
                    dispatchEvent(new EngineEvent(EngineEvent.Evt_SkipTrailer));
                    this.selfStop(StopReasonEnum.SKIP_TRAILER);
                }
            }
            return;
        }// end function

        private function triggerSecondAuthRemote() : void
        {
            if (!this._holder.runtimeData.movieIsMember || this.playingDuration < this._holder.runtimeData.auth_rtime)
            {
                return;
            }
            if ((!this._holder.runtimeData.isTryWatch || this._holder.runtimeData.tryWatchType == TryWatchEnum.TOTAL) && !this._authRemoteTriggered)
            {
                this.stopAuthRemote();
                this._authRemoteTriggered = true;
                this._authRemote = new AuthenticationRemote(this._movie.getSegmentByTime(this.currentTime), this._holder, 1);
                this._authRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onAuthRemoteStatusChanged);
                this._authRemote.initialize();
            }
            return;
        }// end function

        protected function stopedHandler() : void
        {
            if (this._stopTimeOut != 0)
            {
                clearTimeout(this._stopTimeOut);
                this._stopTimeOut = 0;
            }
            this.setStatus(StatusEnum.STOPED);
            return;
        }// end function

        protected function onSkipTitleChanged(event:Event) : void
        {
            if (Settings.instance.skipTitle && this.currentTime <= this._movie.titlesTime && this._movie.titlesTime > 0)
            {
                this.seek(this._movie.titlesTime);
            }
            return;
        }// end function

        protected function onSkipTrailerChanged(event:Event) : void
        {
            if (this._holder.hasStatus(StatusEnum.STOPPING) || this._holder.hasStatus(StatusEnum.STOPED) || this._movie == null)
            {
                return;
            }
            if (Settings.instance.skipTrailer && this._movie.trailerTime > 0 && this.currentTime < this._movie.trailerTime)
            {
                this._holder.runtimeData.skipTrailer = true;
            }
            else
            {
                this._holder.runtimeData.skipTrailer = false;
            }
            if (Settings.instance.skipTrailer && this._movie.trailerTime > 0 && this.currentTime >= this._movie.trailerTime)
            {
                dispatchEvent(new EngineEvent(EngineEvent.Evt_SkipTrailer));
                this.selfStop(StopReasonEnum.SKIP_TRAILER);
            }
            return;
        }// end function

        protected function onMovieReady(event:Event) : void
        {
            this._log.debug("Engine.onMovieReady, has status waiting startLoad or play : " + (this._holder.hasStatus(StatusEnum.WAITING_START_LOAD) || this._holder.hasStatus(StatusEnum.WAITING_PLAY)));
            this.checkNeedStartLoad();
            this.checkNeedPlay();
            if (this.movie.curDefinition.isDrm)
            {
                this._decoder.setLicense(this.movie.curDefinition.license);
            }
            return;
        }// end function

        protected function onHistoryReady(event:Event) : void
        {
            this._log.debug("Engine.onHistoryReady, has status waiting startLoad or play : " + (this._holder.hasStatus(StatusEnum.WAITING_START_LOAD) || this._holder.hasStatus(StatusEnum.WAITING_PLAY)));
            this.updateVideoStartTime();
            this.checkNeedStartLoad();
            this.checkNeedPlay();
            return;
        }// end function

        protected function checkNeedStartLoad() : void
        {
            if (this._holder.hasStatus(StatusEnum.WAITING_START_LOAD) && this.checkEngineIsReady())
            {
                this._holder.removeStatus(StatusEnum.WAITING_START_LOAD, false);
                this.seek(this._startTime);
            }
            return;
        }// end function

        protected function checkNeedPlay() : void
        {
            if (this._holder.hasStatus(StatusEnum.WAITING_PLAY) && this.checkEngineIsReady())
            {
                this._holder.removeStatus(StatusEnum.WAITING_PLAY, false);
                this.onStartPlay();
                this._log.info("Engine.checkNeedPlay, startTime = " + (this._seekTime > 0 ? (this._seekTime) : (this._startTime)));
                this.seek(this._seekTime > 0 ? (this._seekTime) : (this._startTime));
            }
            return;
        }// end function

        public function checkEngineIsReady() : Boolean
        {
            var _loc_1:* = this._movie && this._movie.curDefinition && this._movie.curDefinition.ready;
            var _loc_2:* = this._holder.history && this._holder.history.getReady() || this._holder.runtimeData.playerUseType != PlayerUseTypeEnum.MAIN;
            return _loc_1 && _loc_2;
        }// end function

        private function updateVideoStartTime() : void
        {
            if (!this._holder.hasStatus(StatusEnum.ALREADY_READY) || this._holder.movie == null)
            {
                return;
            }
            if (this._startTime == 0)
            {
                this._startTime = this._holder.strategy.getStartTime();
            }
            this._holder.runtimeData.startPlayTime = this._startTime;
            this._oldCurrentTime = this._startTime;
            this._log.info("Engine:updateVideoStartTime, startTime(" + this._startTime + ")");
            return;
        }// end function

        private function onStartPlay() : void
        {
            if (this._holder.runtimeData.startFromHistory)
            {
                dispatchEvent(new EngineEvent(EngineEvent.Evt_StartFromHistory, this._startTime));
            }
            else if (Settings.instance.skipTitle && this._movie.titlesTime > 0 && this._movie.titlesTime == this._startTime)
            {
                dispatchEvent(new EngineEvent(EngineEvent.Evt_SkipTitle));
            }
            return;
        }// end function

        private function stopAuthRemote() : void
        {
            if (this._authRemote)
            {
                this._authRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onAuthRemoteStatusChanged);
                this._authRemote.destroy();
                this._authRemote = null;
            }
            return;
        }// end function

        private function onAuthRemoteStatusChanged(event:RemoteObjectEvent) : void
        {
            this.stopAuthRemote();
            return;
        }// end function

    }
}
