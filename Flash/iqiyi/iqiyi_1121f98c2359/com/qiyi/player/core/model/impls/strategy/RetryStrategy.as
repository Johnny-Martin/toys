package com.qiyi.player.core.model.impls.strategy
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;

    public class RetryStrategy extends Object implements IStrategy
    {
        private var _holder:ICorePlayer;
        private var _log:ILogger;

        public function RetryStrategy(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.strategy.RetryStrategy");
            this._holder = param1;
            this._log.info("RetryStrategy is created.");
            return;
        }// end function

        public function getStartTime() : Number
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            this._holder.runtimeData.startFromHistory = false;
            if (this._holder.runtimeData.isTryWatch)
            {
                _loc_1 = this._holder.runtimeData.originalStartTime;
                if (_loc_1 > 0)
                {
                    return _loc_1;
                }
            }
            else
            {
                _loc_2 = this._holder.history.getMovieHistoryTime();
                if (_loc_2 > 0 && _loc_2 < this._holder.movie.duration)
                {
                    return _loc_2;
                }
            }
            if (Settings.instance.skipTitle && this._holder.movie.titlesTime > 0)
            {
                return this._holder.movie.titlesTime;
            }
            return 0;
        }// end function

    }
}
