package com.qiyi.player.core.model.impls.strategy
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;

    public class ReplayStrategy extends Object implements IStrategy
    {
        private var _log:ILogger;
        private var _holder:ICorePlayer;

        public function ReplayStrategy(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.strategy.ReplayStrategy");
            this._holder = param1;
            this._log.info("ReplayStrategy is created.");
            return;
        }// end function

        public function getStartTime() : Number
        {
            this._holder.runtimeData.startFromHistory = false;
            var _loc_1:* = this._holder.runtimeData.originalStartTime;
            if (_loc_1 > 0)
            {
                return _loc_1;
            }
            if (Settings.instance.skipTitle && this._holder.movie.titlesTime > 0)
            {
                return this._holder.movie.titlesTime;
            }
            return 0;
        }// end function

    }
}
