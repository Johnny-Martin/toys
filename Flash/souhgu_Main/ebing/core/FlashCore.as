package ebing.core
{
    import ebing.*;
    import ebing.events.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class FlashCore extends Sprite implements IMediaCore
    {
        protected var _sysStatus_str:String = "5";
        protected var _width_num:Number;
        protected var _height_num:Number;
        protected var _minWidth_num:Number;
        protected var _minHeight_num:Number;
        protected var _skin:Object;
        protected var _frame_c:Sprite;
        protected var _wave_arr:Array;
        protected var _buffer:Number;
        protected var _timeLimit:Number;
        protected var _url:String;
        protected var _nc:NetConnection;
        protected var _ns:NetStream;
        protected var _video:Video;
        protected var _fileTotTime:Number = 0;
        protected var _filePlayedTime:Number = 0;
        protected var _finish_boo:Boolean = false;
        protected var _bg_spr:Sprite;
        protected var _stopFlag_boo:Boolean;
        protected var _timer:Timer;
        protected var _volume:Number;
        protected var _swf:Loader;
        protected var _fileTotSize:Number = 0;
        protected var _fileLoadedSize:Number = 0;
        protected var _getTime:Number = 0;
        protected var _mask:Sprite;
        private var _ttt:Boolean = false;
        protected var _connected:Boolean = false;

        public function FlashCore(param1:Object)
        {
            this.hardInit(param1);
            return;
        }// end function

        public function hardInit(param1:Object) : void
        {
            this._width_num = param1.width;
            this._height_num = param1.height;
            this._timeLimit = param1.limitTime;
            this.sysInit("start");
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            this._url = param1.url;
            this._fileTotTime = param1.time;
            this._fileTotSize = param1.size;
            return;
        }// end function

        protected function sysInit(param1:String = null) : void
        {
            var _loc_2:int = 0;
            this._fileTotTime = 0;
            var _loc_2:* = _loc_2;
            this._filePlayedTime = _loc_2;
            var _loc_2:* = _loc_2;
            this._fileTotSize = _loc_2;
            this._fileLoadedSize = _loc_2;
            this._finish_boo = false;
            this._stopFlag_boo = false;
            if (param1 == "start")
            {
                this.newFunc();
                this.drawSkin();
                this.addEvent();
            }
            this._connected = false;
            return;
        }// end function

        public function seek(param1:Number) : void
        {
            return;
        }// end function

        protected function swfProgressHnadler(event:ProgressEvent) : void
        {
            trace("********************************************************++++++++++++++++++++++++++++++++++++++++evt.target.bytesLoaded:" + event.target.bytesLoaded, "evt.target.bytesTotal:" + event.target.bytesTotal);
            if (event.target.bytesTotal > 0)
            {
                this.dispatch(MediaEvent.LOAD_PROGRESS, {nowSize:event.target.bytesLoaded, totSize:event.target.bytesTotal});
            }
            return;
        }// end function

        protected function swfHandler(param1:Object) : void
        {
            if (param1.info == "success")
            {
                this._swf = param1.data;
                this.dispatch(MediaEvent.START);
                this._timer.start();
                this._getTime = getTimer();
                addChild(this._swf);
                addChild(this._mask);
                this._swf.mask = this._mask;
                this.resize(this._width_num, this._height_num);
            }
            else if (param1.info == "timeout")
            {
                this.dispatch(MediaEvent.CONNECT_TIMEOUT);
                this._sysStatus_str = "5";
            }
            else
            {
                trace("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++***********************************");
                this.dispatch(MediaEvent.NOTFOUND);
            }
            return;
        }// end function

        public function play(param1 = null) : void
        {
            if (this._sysStatus_str == "5")
            {
                new LoaderUtil().load(this._timeLimit, this.swfHandler, this.swfProgressHnadler, this._url);
            }
            if (this._sysStatus_str == "4")
            {
                this._getTime = getTimer() - this._filePlayedTime;
            }
            this._sysStatus_str = "3";
            this.dispatch(MediaEvent.PLAY);
            return;
        }// end function

        public function pause(param1 = null) : void
        {
            this._sysStatus_str = "4";
            if (param1 != "0")
            {
                this.dispatch(MediaEvent.PAUSE, {isHard:param1 == null ? (false) : (true)});
            }
            return;
        }// end function

        public function sleep(param1 = null) : void
        {
            this.pause("0");
            return;
        }// end function

        public function stop(param1 = null) : void
        {
            this._timer.stop();
            this._sysStatus_str = "5";
            if (this._finish_boo)
            {
                this.dispatch(MediaEvent.STOP, {finish:true});
                this._finish_boo = false;
            }
            else
            {
                this.dispatch(MediaEvent.STOP, {finish:false});
            }
            try
            {
                this._swf.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_closed"));
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function playOrPause(param1 = null) : void
        {
            if (this._sysStatus_str == "4")
            {
                this.play();
            }
            else if (this._sysStatus_str == "3")
            {
                this.pause(param1);
            }
            return;
        }// end function

        public function onMetaData(param1:Object) : void
        {
            return;
        }// end function

        protected function timerHandler(event:TimerEvent) : void
        {
            this.aboutTime(event.target.delay);
            this.aboutDownload();
            if (Math.ceil(this._filePlayedTime * 10) >= Math.floor(this._fileTotTime * 10))
            {
                this._finish_boo = true;
                if (this._sysStatus_str != "5")
                {
                    this.stop();
                }
            }
            event.updateAfterEvent();
            return;
        }// end function

        public function destroy() : void
        {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER, this.timerHandler);
            this._timer = null;
            removeChild(this._swf);
            this._swf = null;
            return;
        }// end function

        protected function aboutTime(param1:Number) : void
        {
            if (this._swf != null && this._sysStatus_str == "3")
            {
                this._filePlayedTime = getTimer() - this._getTime;
                this.dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:this._filePlayedTime / 1000, totTime:this._fileTotTime / 1000});
            }
            return;
        }// end function

        protected function aboutDownload() : void
        {
            return;
        }// end function

        protected function newFunc() : void
        {
            this._timer = new Timer(100, 0);
            if (!this._timer.hasEventListener(TimerEvent.TIMER))
            {
                this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            }
            return;
        }// end function

        protected function drawSkin() : void
        {
            this._bg_spr = new Sprite();
            Utils.drawRect(this._bg_spr, 0, 0, this._width_num, this._height_num, 0, 1);
            addChild(this._bg_spr);
            return;
        }// end function

        protected function addEvent() : void
        {
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            var K1026035576CE979F9D4C27894EE6BDE6ED440D373566K:Number;
            var K102603F24F9BF3420149E3AC27B8EA7438E66E373566K:Number;
            var K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K:Number;
            var K1026037850482A38BE4ECEA65CBE571D4C215C373566K:Number;
            var w:* = param1;
            var h:* = param2;
            trace("+++++++++++++++++++---");
            var _loc_4:* = w;
            this._bg_spr.width = w;
            this._width_num = _loc_4;
            var _loc_4:* = h;
            this._bg_spr.height = h;
            this._height_num = _loc_4;
            try
            {
                if (this._swf.contentLoaderInfo != null)
                {
                    K1026035576CE979F9D4C27894EE6BDE6ED440D373566K = this._swf.contentLoaderInfo.width;
                    K102603F24F9BF3420149E3AC27B8EA7438E66E373566K = this._swf.contentLoaderInfo.height;
                    K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K;
                    K1026037850482A38BE4ECEA65CBE571D4C215C373566K;
                    if (!this._ttt)
                    {
                        this._ttt = true;
                        this._mask = new Sprite();
                        Utils.drawRect(this._mask, 0, 0, K1026035576CE979F9D4C27894EE6BDE6ED440D373566K, K102603F24F9BF3420149E3AC27B8EA7438E66E373566K, 0, 0);
                        addChild(this._mask);
                        this._swf.mask = this._mask;
                    }
                    if (K1026035576CE979F9D4C27894EE6BDE6ED440D373566K / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K > this._width_num / this._height_num)
                    {
                        K1026037850482A38BE4ECEA65CBE571D4C215C373566K = this._width_num / K1026035576CE979F9D4C27894EE6BDE6ED440D373566K * K102603F24F9BF3420149E3AC27B8EA7438E66E373566K;
                        K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K = this._width_num;
                    }
                    else if (K1026035576CE979F9D4C27894EE6BDE6ED440D373566K / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K < this._width_num / this._height_num)
                    {
                        K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K = this._height_num / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K * K1026035576CE979F9D4C27894EE6BDE6ED440D373566K;
                        K1026037850482A38BE4ECEA65CBE571D4C215C373566K = this._height_num;
                    }
                    else
                    {
                        K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K = this._width_num;
                        K1026037850482A38BE4ECEA65CBE571D4C215C373566K = this._height_num;
                    }
                    var _loc_4:* = K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K / K1026035576CE979F9D4C27894EE6BDE6ED440D373566K;
                    this._swf.scaleX = K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K / K1026035576CE979F9D4C27894EE6BDE6ED440D373566K;
                    this._mask.scaleX = _loc_4;
                    var _loc_4:* = K1026037850482A38BE4ECEA65CBE571D4C215C373566K / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K;
                    this._swf.scaleY = K1026037850482A38BE4ECEA65CBE571D4C215C373566K / K102603F24F9BF3420149E3AC27B8EA7438E66E373566K;
                    this._mask.scaleY = _loc_4;
                    var _loc_4:* = Math.round(this._width_num - K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K) / 2;
                    this._swf.x = Math.round(this._width_num - K102603F8F23E0F3EBC4A268E1B5613E4FEC487373566K) / 2;
                    this._mask.x = _loc_4;
                    var _loc_4:* = Math.round(this._height_num - K1026037850482A38BE4ECEA65CBE571D4C215C373566K) / 2;
                    this._swf.y = Math.round(this._height_num - K1026037850482A38BE4ECEA65CBE571D4C215C373566K) / 2;
                    this._mask.y = _loc_4;
                }
            }
            catch (evt)
            {
                trace("FlashCore resize" + evt);
            }
            return;
        }// end function

        protected function setEleStatus() : void
        {
            return;
        }// end function

        protected function dispatch(param1:String, param2:Object = null) : void
        {
            var _loc_3:* = new MediaEvent(param1);
            _loc_3.obj = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

        public function get filePlayedTime() : Number
        {
            return this._ns.time;
        }// end function

        public function get fileTotTime() : Number
        {
            return this._fileTotTime;
        }// end function

        public function get fileLoadedSize() : Number
        {
            return this._ns.bytesLoaded;
        }// end function

        public function get fileTotSize() : Number
        {
            return this._ns.bytesTotal;
        }// end function

        public function get volume() : Number
        {
            return this._volume;
        }// end function

        public function set volume(param1:Number) : void
        {
            this._volume = param1;
            return;
        }// end function

    }
}
