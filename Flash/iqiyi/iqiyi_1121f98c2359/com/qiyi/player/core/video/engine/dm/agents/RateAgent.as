package com.qiyi.player.core.video.engine.dm.agents
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.engine.dm.provider.*;
    import com.qiyi.player.core.video.events.*;
    import com.qiyi.player.core.video.render.*;
    import flash.events.*;

    public class RateAgent extends EventDispatcher implements IDestroy
    {
        private var _holder:ICorePlayer;
        private var _decoder:IDecoder;
        private var _render:IRender;
        private var _provider:Provider;
        private var _movie:IMovie;
        private var _autoAdjustRateAgent:AutoAdjustRateAgent;
        private var _isBind:Boolean;
        private var _log:ILogger;

        public function RateAgent(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.video.engine.dm.agents.RateAgent");
            this._holder = param1;
            this._isBind = false;
            this._autoAdjustRateAgent = new AutoAdjustRateAgent(this._holder);
            return;
        }// end function

        public function bind(param1:IDecoder, param2:IRender, param3:Provider, param4:IMovie) : void
        {
            this._decoder = param1;
            this._render = param2;
            this._provider = param3;
            this._movie = param4;
            this._autoAdjustRateAgent.bind(param2, param3, this._movie);
            if (!this._isBind)
            {
                Settings.instance.addEventListener(Settings.Evt_AudioTrackChanged, this.onAudioTrackChanged);
                Settings.instance.addEventListener(Settings.Evt_DefinitionChanged, this.onDefinitionChanged);
                Settings.instance.addEventListener(Settings.Evt_AutoMatchChanged, this.onAutoMatchChanged);
                this._autoAdjustRateAgent.addEventListener(RateAgentEvent.Evt_AutoAdjustRate, this.onAutoAdjustRate);
                this._isBind = true;
            }
            return;
        }// end function

        public function startAutoAdjustRate() : void
        {
            if (Settings.instance.autoMatchRate)
            {
                this._autoAdjustRateAgent.start();
            }
            else
            {
                this._autoAdjustRateAgent.stop();
            }
            return;
        }// end function

        public function stopAutoAdjustRate() : void
        {
            this._autoAdjustRateAgent.stop();
            return;
        }// end function

        public function destroy() : void
        {
            this._holder = null;
            this._decoder = null;
            this._render = null;
            this._provider = null;
            this._movie = null;
            this._isBind = false;
            this._autoAdjustRateAgent.removeEventListener(RateAgentEvent.Evt_AutoAdjustRate, this.onAutoAdjustRate);
            this._autoAdjustRateAgent.destroy();
            this._autoAdjustRateAgent = null;
            Settings.instance.removeEventListener(Settings.Evt_AudioTrackChanged, this.onAudioTrackChanged);
            Settings.instance.removeEventListener(Settings.Evt_DefinitionChanged, this.onDefinitionChanged);
            Settings.instance.removeEventListener(Settings.Evt_AutoMatchChanged, this.onAutoMatchChanged);
            return;
        }// end function

        private function onDefinitionChanged(event:Event) : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:IAudioTrackInfo = null;
            var _loc_4:int = 0;
            if (!this._isBind)
            {
                return;
            }
            if (!Settings.instance.autoMatchRate)
            {
                if (this._movie.curDefinition == null || this._movie.curDefinition.type != Settings.instance.definition)
                {
                    _loc_2 = false;
                    if (this._holder && this._holder.runtimeData.needFilterQualityDefinition)
                    {
                        _loc_3 = this._movie.curAudioTrack;
                        if (_loc_3)
                        {
                            _loc_4 = _loc_3.definitionCount;
                            if (_loc_4 > 3)
                            {
                                _loc_2 = true;
                            }
                            else if (_loc_4 == 3)
                            {
                                if (DefinitionUtils.inFilterPPByDefinitionID(_loc_3.findDefinitionInfoAt(0).type.id) && DefinitionUtils.inFilterPPByDefinitionID(_loc_3.findDefinitionInfoAt(1).type.id) && DefinitionUtils.inFilterPPByDefinitionID(_loc_3.findDefinitionInfoAt(2).type.id))
                                {
                                    _loc_2 = false;
                                }
                                else
                                {
                                    _loc_2 = true;
                                }
                            }
                            else if (_loc_4 == 2)
                            {
                                if (DefinitionUtils.inFilterPPByDefinitionID(_loc_3.findDefinitionInfoAt(0).type.id) && DefinitionUtils.inFilterPPByDefinitionID(_loc_3.findDefinitionInfoAt(1).type.id))
                                {
                                    _loc_2 = false;
                                }
                                else
                                {
                                    _loc_2 = true;
                                }
                            }
                            else
                            {
                                _loc_2 = false;
                            }
                        }
                    }
                    if (_loc_2 && Settings.instance.definition && DefinitionUtils.inFilterPPByDefinitionID(Settings.instance.definition.id))
                    {
                        return;
                    }
                    this._log.info("definition changed:definition=" + Settings.instance.definition + ",s=" + this._holder.runtimeData.CDNStatus);
                    this._movie.setCurDefinition(Settings.instance.definition);
                    if (this._movie.curDefinition && this._movie.curDefinition.type)
                    {
                        this._holder.runtimeData.currentDefinition = this._movie.curDefinition.type.id.toString();
                    }
                    this._holder.runtimeData.vid = this._movie.vid;
                    dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_DefinitionChanged, this._decoder.bufferLength * 1000));
                }
            }
            return;
        }// end function

        private function onAutoAdjustRate(event:RateAgentEvent) : void
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            if (!this._isBind)
            {
                return;
            }
            var _loc_2:* = event.data as EnumItem;
            if (this._movie.curDefinition == null || this._movie.curDefinition.type != _loc_2)
            {
                if (this._provider.bufferLength - this._decoder.time > 130000)
                {
                    if (_loc_2 == DefinitionEnum.LIMIT)
                    {
                        dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_DefinitionChanged, -1));
                        return;
                    }
                    if (this._movie.curDefinition && this._movie.curDefinition.type != DefinitionEnum.LIMIT && this._movie.curDefinition.type.id > _loc_2.id)
                    {
                        dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_DefinitionChanged, -1));
                        return;
                    }
                }
                _loc_3 = 0;
                _loc_4 = 0;
                if (this._movie.curDefinition && this._movie.curDefinition.type)
                {
                    _loc_3 = this._movie.curDefinition.type.id;
                }
                this._log.info("auto definition before changed:definition=" + _loc_2 + ",s=" + this._holder.runtimeData.CDNStatus);
                this._movie.setCurDefinition(_loc_2);
                this._log.info("auto definition after changed:definition=" + this._movie.curDefinition.type + ",s=" + this._holder.runtimeData.CDNStatus);
                this._holder.runtimeData.vid = this._movie.vid;
                if (this._movie.curDefinition && this._movie.curDefinition.type)
                {
                    this._holder.runtimeData.currentDefinition = this._movie.curDefinition.type.id.toString();
                    _loc_4 = this._movie.curDefinition.type.id;
                }
                this._holder.pingBack.sendAutoDefinition(_loc_3, _loc_4);
                dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_DefinitionChanged, this._decoder.bufferLength * 1000));
            }
            return;
        }// end function

        private function onAudioTrackChanged(event:Event) : void
        {
            if (!this._isBind)
            {
                return;
            }
            var _loc_2:EnumItem = null;
            if (this._movie.curDefinition && this._movie.curDefinition.type)
            {
                _loc_2 = this._movie.curDefinition.type;
            }
            else
            {
                _loc_2 = DefinitionUtils.getCurrentDefinition(this._holder);
            }
            this._log.info("audioTrack changed:audio=" + Settings.instance.audioTrack + ",definition=" + _loc_2 + ",s=" + this._holder.runtimeData.CDNStatus);
            this._movie.setCurAudioTrack(Settings.instance.audioTrack, _loc_2);
            if (this._movie.curDefinition && this._movie.curDefinition.type)
            {
                this._holder.runtimeData.currentDefinition = this._movie.curDefinition.type.id.toString();
            }
            this._holder.runtimeData.vid = this._movie.vid;
            dispatchEvent(new RateAgentEvent(RateAgentEvent.Evt_AudioTrackChanged, this._decoder.bufferLength * 1000));
            return;
        }// end function

        private function onAutoMatchChanged(event:Event) : void
        {
            if (Settings.instance.autoMatchRate)
            {
                this._autoAdjustRateAgent.start();
            }
            else
            {
                this._autoAdjustRateAgent.stop();
            }
            return;
        }// end function

    }
}
