package com.qiyi.player.core.video.engine.dm.agents
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.video.engine.dm.provider.*;
    import com.qiyi.player.core.video.events.*;
    import com.qiyi.player.core.video.render.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class AutoAdjustRateAgent extends EventDispatcher implements IDestroy
    {
        private var _holder:ICorePlayer;
        private var _provider:Provider;
        private var _render:IRender;
        private var _movie:IMovie;
        private var _isStart:Boolean;
        private var _timer:Timer;
        private var _timeout:uint;
        private var _curAutoCount:int;
        private var _detectedRate:EnumItem;
        private var _log:ILogger;
        private static const MAX_AUTO_COUNT:int = 5;
        private static const REASON_OPEN:int = 1;
        private static const REASON_VIDEO_RESIZED:int = 2;
        private static const REASON_TIMER_TEST:int = 3;
        private static const REASON_WILL_LOAD:int = 4;

        public function AutoAdjustRateAgent(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.video.engine.dm.agents.AutoAdjustRateAgent");
            this._holder = param1;
            this._isStart = false;
            this._curAutoCount = 0;
            this._timeout = 0;
            this._timer = new Timer(10000);
            this._timer.addEventListener(TimerEvent.TIMER, this.onTimerHandler);
            return;
        }// end function

        public function bind(param1:IRender, param2:Provider, param3:IMovie) : void
        {
            if (this._render)
            {
                this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged, this.onVideoResized);
            }
            if (this._provider)
            {
                this._provider.removeEventListener(ProviderEvent.Evt_WillLoad, this.onFileWillLoad);
            }
            this._render = param1;
            this._provider = param2;
            this._movie = param3;
            if (this._isStart)
            {
                this._render.addEventListener(RenderEvent.Evt_RenderAreaChanged, this.onVideoResized);
                this._provider.addEventListener(ProviderEvent.Evt_WillLoad, this.onFileWillLoad);
            }
            return;
        }// end function

        public function start() : void
        {
            if (!this._isStart && this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
            {
                this._isStart = true;
                this._curAutoCount = 0;
                if (!this._timer.running)
                {
                    this._timer.start();
                }
                if (this._provider)
                {
                    this._provider.addEventListener(ProviderEvent.Evt_WillLoad, this.onFileWillLoad);
                }
                if (this._render)
                {
                    this._render.addEventListener(RenderEvent.Evt_RenderAreaChanged, this.onVideoResized);
                }
                this.updateDefinition(REASON_OPEN);
            }
            return;
        }// end function

        public function stop() : void
        {
            if (this._isStart)
            {
                this._isStart = false;
                this._curAutoCount = 0;
                if (this._timer.running)
                {
                    this._timer.stop();
                }
                if (this._provider)
                {
                    this._provider.removeEventListener(ProviderEvent.Evt_WillLoad, this.onFileWillLoad);
                }
                if (this._render)
                {
                    this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged, this.onVideoResized);
                }
            }
            return;
        }// end function

        private function onVideoResized(event:RenderEvent) : void
        {
            if (this._curAutoCount < MAX_AUTO_COUNT)
            {
                if (this._timeout == 0)
                {
                    this._timeout = setTimeout(this.updateDefinition, 2000, REASON_VIDEO_RESIZED);
                }
            }
            return;
        }// end function

        private function onTimerHandler(event:TimerEvent) : void
        {
            if (this._curAutoCount < MAX_AUTO_COUNT)
            {
                this.updateDefinition(REASON_TIMER_TEST);
            }
            return;
        }// end function

        private function onFileWillLoad(event:Event) : void
        {
            if (this._curAutoCount < MAX_AUTO_COUNT)
            {
                if (this._timeout == 0)
                {
                    this._timeout = setTimeout(this.updateDefinition, 1, REASON_WILL_LOAD);
                }
            }
            return;
        }// end function

        private function updateDefinition(param1:int) : void
        {
            var _loc_3:EnumItem = null;
            if (this._timeout != 0)
            {
                clearTimeout(this._timeout);
                this._timeout = 0;
            }
            this._log.debug("average speed : " + this._holder.runtimeData.currentAverageSpeed + ",s : " + this._holder.runtimeData.CDNStatus + ",allow auto up definition limit: " + this._holder.runtimeData.autoDefinitionlimit + ",smallWindowMode: " + this._holder.runtimeData.smallWindowMode);
            var _loc_2:* = this._holder.runtimeData.currentAverageSpeed;
            if (!this._holder.runtimeData.smallWindowMode && _loc_2 != 0 && this._render && this._provider && this._movie && this._movie.curDefinition && !this._provider.loadingFailed)
            {
                this._detectedRate = null;
                _loc_3 = this.downDefinition();
                if (_loc_3)
                {
                    if (_loc_3 == this._movie.curDefinition.type)
                    {
                        this.checkReason(param1);
                    }
                }
                else
                {
                    _loc_3 = this.upDefinition();
                    if (_loc_3)
                    {
                        if (_loc_3 == this._movie.curDefinition.type)
                        {
                            this.checkReason(param1);
                        }
                    }
                }
                if (this._detectedRate)
                {
                    Settings.instance.detectedRate = this._detectedRate;
                }
            }
            return;
        }// end function

        private function checkReason(param1:int) : void
        {
            if (param1 == REASON_OPEN)
            {
                this._log.info("auto adjust rate success! reason : REASON_OPEN,auto count : " + this._curAutoCount);
            }
            else if (param1 == REASON_VIDEO_RESIZED)
            {
                var _loc_2:String = this;
                var _loc_3:* = this._curAutoCount + 1;
                _loc_2._curAutoCount = _loc_3;
                this._log.info("auto adjust rate success! reason : REASON_VIDEO_RESIZED,auto count : " + this._curAutoCount);
            }
            else if (param1 == REASON_TIMER_TEST)
            {
                var _loc_2:String = this;
                var _loc_3:* = this._curAutoCount + 1;
                _loc_2._curAutoCount = _loc_3;
                this._log.info("auto adjust rate success! reason : REASON_TIMER_TEST,auto count : " + this._curAutoCount);
            }
            else if (param1 == REASON_WILL_LOAD)
            {
                var _loc_2:String = this;
                var _loc_3:* = this._curAutoCount + 1;
                _loc_2._curAutoCount = _loc_3;
                this._log.info("auto adjust rate success! reason : REASON_WILL_LOAD,auto count : " + this._curAutoCount);
            }
            return;
        }// end function

        private function checkAndSetDetectedRate(param1:EnumItem) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (param1 && param1 != DefinitionEnum.NONE)
            {
                if (this._detectedRate)
                {
                    _loc_2 = param1.id;
                    if (param1 == DefinitionEnum.LIMIT)
                    {
                        _loc_2 = 0;
                    }
                    _loc_3 = this._detectedRate.id;
                    if (this._detectedRate == DefinitionEnum.LIMIT)
                    {
                        _loc_3 = 0;
                    }
                    if (_loc_2 > _loc_3)
                    {
                        this._detectedRate = param1;
                    }
                }
                else
                {
                    this._detectedRate = param1;
                }
            }
            return;
        }// end function

        private function upDefinition() : EnumItem
        {
            var _loc_1:EnumItem = null;
            var _loc_2:* = this._holder.runtimeData.autoDefinitionlimit;
            if (this._movie == null || this._movie.curAudioTrack == null || this._movie.curDefinition == null || this._movie.curDefinition.type == null || _loc_2 == null || _loc_2 == DefinitionEnum.NONE)
            {
                return _loc_1;
            }
            var _loc_3:* = this._render.getRealArea();
            var _loc_4:* = this._holder.runtimeData.currentAverageSpeed;
            if (_loc_3 == null || _loc_4 == 0)
            {
                return _loc_1;
            }
            var _loc_5:* = DefinitionEnum.ITEMS;
            var _loc_6:* = _loc_5.indexOf(this._movie.curDefinition.type);
            if (this._movie.curDefinition.type == DefinitionEnum.LIMIT)
            {
                _loc_6 = 0;
            }
            var _loc_7:EnumItem = null;
            var _loc_8:* = _loc_5.indexOf(_loc_2);
            while (_loc_8 >= _loc_6)
            {
                
                if (_loc_8 == 0)
                {
                    _loc_7 = DefinitionEnum.LIMIT;
                }
                else
                {
                    _loc_7 = _loc_5[_loc_8];
                }
                if (_loc_7)
                {
                    if (_loc_4 >= this.getSpeedValue(_loc_7) && this.checkRectangle(_loc_7, _loc_3.width, _loc_3.height))
                    {
                        this.checkAndSetDetectedRate(_loc_7);
                        if (this._movie.curAudioTrack.findDefinitionByType(_loc_7, true))
                        {
                            if (this._holder.runtimeData.CDNStatus == 0 && _loc_7 != this._movie.curDefinition.type)
                            {
                                dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate, _loc_7));
                                _loc_1 = _loc_7;
                            }
                            return _loc_1;
                        }
                    }
                }
                _loc_8 = _loc_8 - 1;
            }
            return _loc_1;
        }// end function

        private function downDefinition() : EnumItem
        {
            var _loc_1:EnumItem = null;
            if (this._movie == null || this._movie.curAudioTrack == null || this._movie.curDefinition == null || this._movie.curDefinition.type == null)
            {
                return _loc_1;
            }
            var _loc_2:* = this._render.getRealArea();
            var _loc_3:* = this._holder.runtimeData.currentAverageSpeed;
            if (_loc_2 == null || _loc_3 == 0)
            {
                return _loc_1;
            }
            var _loc_4:* = DefinitionEnum.ITEMS;
            var _loc_5:* = _loc_4.indexOf(this._movie.curDefinition.type);
            if (this._movie.curDefinition.type == DefinitionEnum.LIMIT)
            {
                _loc_5 = 0;
            }
            var _loc_6:EnumItem = null;
            var _loc_7:EnumItem = null;
            var _loc_8:Boolean = false;
            var _loc_9:* = _loc_5;
            while (_loc_9 >= 0)
            {
                
                if (_loc_9 == 0)
                {
                    _loc_6 = DefinitionEnum.LIMIT;
                }
                else
                {
                    _loc_6 = _loc_4[_loc_9];
                }
                if (_loc_6)
                {
                    _loc_8 = _loc_3 >= this.getSpeedValue(_loc_6) && this.checkRectangle(_loc_6, _loc_2.width, _loc_2.height);
                    if (_loc_8)
                    {
                        this.checkAndSetDetectedRate(_loc_6);
                    }
                    if (this._movie.curAudioTrack.findDefinitionByType(_loc_6, true))
                    {
                        _loc_7 = _loc_6;
                        if (_loc_8)
                        {
                            this._detectedRate = _loc_6;
                            if (_loc_6 != this._movie.curDefinition.type)
                            {
                                dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate, _loc_6));
                                _loc_1 = _loc_6;
                            }
                            return _loc_1;
                        }
                    }
                }
                if (_loc_9 == 0 && _loc_7)
                {
                    if (_loc_7 != this._movie.curDefinition.type)
                    {
                        dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AutoAdjustRate, _loc_7));
                        _loc_1 = _loc_7;
                    }
                    return _loc_1;
                }
                _loc_9 = _loc_9 - 1;
            }
            return _loc_1;
        }// end function

        private function checkRectangle(param1:EnumItem, param2:int, param3:int) : Boolean
        {
            var _loc_4:Boolean = false;
            switch(param1)
            {
                case DefinitionEnum.STANDARD:
                {
                    _loc_4 = param2 >= 480 || 480 - param2 < 80;
                    break;
                }
                case DefinitionEnum.HIGH:
                {
                    _loc_4 = param2 >= 640 || 640 - param2 < 80;
                    break;
                }
                case DefinitionEnum.SUPER:
                {
                    _loc_4 = param2 >= 1280 || 1280 - param2 < 80;
                    break;
                }
                case DefinitionEnum.SUPER_HIGH:
                {
                    _loc_4 = param2 >= 1280 || 1280 - param2 < 80;
                    if (_loc_4)
                    {
                        _loc_4 = param3 >= 720 || 720 - param3 < 80;
                    }
                    break;
                }
                case DefinitionEnum.FULL_HD:
                {
                    _loc_4 = param2 >= 1920 || 1920 - param2 < 80;
                    if (_loc_4)
                    {
                        _loc_4 = param3 >= 1080 || 1080 - param3 < 80;
                    }
                    break;
                }
                case DefinitionEnum.FOUR_K:
                {
                    _loc_4 = param2 >= 4000 || 4000 - param2 < 80;
                    if (_loc_4)
                    {
                        _loc_4 = param3 >= 2000 || 2000 - param3 < 80;
                    }
                    break;
                }
                case DefinitionEnum.LIMIT:
                {
                    _loc_4 = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_4;
        }// end function

        private function getSpeedValue(param1:EnumItem) : Number
        {
            var _loc_2:Number = 0;
            switch(param1)
            {
                case DefinitionEnum.STANDARD:
                {
                    _loc_2 = 300 * 1024 / 8;
                    break;
                }
                case DefinitionEnum.HIGH:
                {
                    _loc_2 = 600 * 1024 / 8;
                    break;
                }
                case DefinitionEnum.SUPER:
                {
                    _loc_2 = 1.1 * 1024 * 1024 / 8;
                    break;
                }
                case DefinitionEnum.SUPER_HIGH:
                {
                    _loc_2 = 1.5 * 1024 * 1024 / 8;
                    break;
                }
                case DefinitionEnum.FULL_HD:
                {
                    _loc_2 = 3 * 1024 * 1024 / 8;
                    break;
                }
                case DefinitionEnum.FOUR_K:
                {
                    _loc_2 = 8 * 1024 * 1024 / 8;
                    break;
                }
                case DefinitionEnum.LIMIT:
                {
                    _loc_2 = 0;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function destroy() : void
        {
            if (this._render)
            {
                this._render.removeEventListener(RenderEvent.Evt_RenderAreaChanged, this.onVideoResized);
                this._render = null;
            }
            this._holder = null;
            this._movie = null;
            if (this._provider)
            {
                this._provider.removeEventListener(ProviderEvent.Evt_WillLoad, this.onFileWillLoad);
                this._provider = null;
            }
            this._isStart = false;
            this._curAutoCount = 0;
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.onTimerHandler);
                if (this._timer.running)
                {
                    this._timer.stop();
                }
            }
            if (this._timeout != 0)
            {
                clearTimeout(this._timeout);
                this._timeout = 0;
            }
            return;
        }// end function

    }
}
