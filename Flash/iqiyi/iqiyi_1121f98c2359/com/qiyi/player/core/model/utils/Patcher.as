package com.qiyi.player.core.model.utils
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import flash.events.*;
    import flash.utils.*;

    public class Patcher extends Object implements IDestroy
    {
        private const BLACK_SCREEN_TIME:int = 3000;
        private var _corePlayer:ICorePlayer;
        private var _timer:Timer;
        private var _blackScreenTime:int = 0;
        private var _blackScreenCurTime:int = 0;
        private var _log:ILogger;

        public function Patcher()
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.utils.Patcher");
            this._timer = new Timer(500);
            this._timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this._timer.start();
            return;
        }// end function

        public function initCorePlayer(param1:ICorePlayer) : void
        {
            this._corePlayer = param1;
            return;
        }// end function

        public function monitorBlackScreen(param1:Boolean) : void
        {
            if (param1)
            {
                this._timer.start();
            }
            else
            {
                this._timer.stop();
            }
            return;
        }// end function

        public function destroy() : void
        {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
            this._timer = null;
            this._corePlayer = null;
            return;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            var _loc_2:int = 0;
            if (this._corePlayer)
            {
                if (this._corePlayer.hasStatus(StatusEnum.PLAYING))
                {
                    _loc_2 = this._corePlayer.currentTime;
                    if (_loc_2 != this._blackScreenCurTime)
                    {
                        this._blackScreenCurTime = _loc_2;
                        this._blackScreenTime = 0;
                    }
                    else
                    {
                        this._blackScreenTime = this._blackScreenTime + this._timer.delay;
                    }
                    if (this._blackScreenTime >= this.BLACK_SCREEN_TIME)
                    {
                        this._log.warn("CorePlayer arrive black limit time,execute seek,seek time:" + _loc_2);
                        this._corePlayer.seek(_loc_2);
                        this._blackScreenTime = 0;
                        this._blackScreenCurTime = 0;
                    }
                }
                else
                {
                    this._blackScreenTime = 0;
                    this._blackScreenCurTime = 0;
                }
            }
            return;
        }// end function

    }
}
