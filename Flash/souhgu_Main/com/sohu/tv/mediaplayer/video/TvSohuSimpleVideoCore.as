package com.sohu.tv.mediaplayer.video
{
    import ebing.core.*;
    import ebing.events.*;
    import flash.events.*;
    import flash.media.*;
    import flash.utils.*;

    public class TvSohuSimpleVideoCore extends SimpleVideoCore
    {
        private var _id:int = 0;
        private var _mask:String = "n";

        public function TvSohuSimpleVideoCore(param1:Object)
        {
            if (param1.index != null)
            {
                this._id = param1.index;
            }
            super(param1);
            return;
        }// end function

        override protected function newFunc() : void
        {
            _timer = new Timer(100, 0);
            if (!_timer.hasEventListener(TimerEvent.TIMER))
            {
                _timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            }
            _soundTransform = new SoundTransform();
            return;
        }// end function

        public function onLastSecond(param1) : void
        {
            return;
        }// end function

        public function get id() : int
        {
            return this._id;
        }// end function

        override public function softInit(param1:Object) : void
        {
            this._mask = "n";
            super.softInit(param1);
            return;
        }// end function

        override protected function onNetStatus(event:NetStatusEvent) : void
        {
            if (event.info.code == "NetStream.Play.Stop" && Math.abs(_ns.time - _totTime) > 1 && _sysStatus_str == "3")
            {
                _stopFlag_boo = false;
                dispatch(MediaEvent.PLAY_ABEND, {playedTime:_ns.time, totTime:_totTime});
                this.stop("noevent");
            }
            else if (event.info.code == "NetStream.Play.Stop")
            {
                if (_stopFlag_boo)
                {
                    this._mask = this._mask + ("-s2_" + getTimer());
                    this.judgeStop();
                }
                else
                {
                    _stopFlag_boo = true;
                    this._mask = "s1_" + getTimer();
                }
            }
            else
            {
                super.onNetStatus(event);
            }
            return;
        }// end function

        override protected function timerHandler(event:TimerEvent) : void
        {
            aboutTime();
            aboutDownload();
            if (_totTime != 0 && Math.ceil(_ns.time * 10) >= Math.floor(_totTime * 10))
            {
                if (_stopFlag_boo)
                {
                    this._mask = this._mask + ("-t2_" + getTimer());
                    this.judgeStop();
                }
                else
                {
                    _stopFlag_boo = true;
                    this._mask = "t1_" + getTimer();
                }
            }
            event.updateAfterEvent();
            return;
        }// end function

        override public function stop(param1 = null) : void
        {
            if (_sysStatus_str != "5")
            {
                _sysStatus_str = "5";
                _timer.stop();
                _ns.seek(0);
                _ns.close();
                if (param1 != "noevent")
                {
                    if (_finish_boo)
                    {
                        dispatch(MediaEvent.STOP, {finish:true, mask:this._mask});
                        _finish_boo = false;
                    }
                    else
                    {
                        dispatch(MediaEvent.STOP, {finish:false, mask:this._mask});
                    }
                }
            }
            return;
        }// end function

        override protected function judgeStop() : void
        {
            clearTimeout(_stopTimeout);
            if (_sysStatus_str != "5")
            {
                if (_isLoop)
                {
                    setTimeout(function () : void
            {
                seek(0);
                return;
            }// end function
            , 1000);
                }
                else
                {
                    _finish_boo = true;
                    _stopFlag_boo = false;
                    this.stop();
                }
            }
            return;
        }// end function

        public function onPlayStatus(param1:Object) : void
        {
            return;
        }// end function

    }
}
