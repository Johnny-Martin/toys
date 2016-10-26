package ebing.core
{
    import ebing.*;
    import ebing.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class SimpleVideoCore extends Sprite implements IMediaCore
    {
        protected var _sysStatus_str:String = "5";
        protected var _width_num:Number = 0;
        protected var _height_num:Number = 0;
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
        protected var _totTime:Number;
        protected var _finish_boo:Boolean = false;
        protected var _bg_spr:Sprite;
        protected var _stopFlag_boo:Boolean;
        protected var _timer:Timer;
        protected var _volume:Number = 0;
        protected var _soundTransform:SoundTransform;
        protected var _stopTimeout:Number = 0;
        protected var _metaByTot:Number = 0;
        protected var _isAbendEventSent:Boolean = false;
        protected var _isLoop:Boolean = false;
        protected var _seekpoints:Array;
        protected var _played_boo:Boolean = false;
        protected var _connected:Boolean = false;

        public function SimpleVideoCore(param1:Object)
        {
            this.hardInit(param1);
            return;
        }// end function

        public function hardInit(param1:Object) : void
        {
            this._width_num = param1.width;
            this._height_num = param1.height;
            this._buffer = param1.buffer;
            this._timeLimit = param1.limitTime;
            this.sysInit("start");
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            trace("obj.urllllllllllllllll:" + param1.url);
            this._url = param1.url;
            if (param1.isLoop != null)
            {
                this._isLoop = param1.isLoop;
            }
            return;
        }// end function

        protected function sysInit(param1:String = null) : void
        {
            this._totTime = 0;
            this._finish_boo = false;
            this._stopFlag_boo = false;
            this._totTime = 0;
            if (param1 == "start")
            {
                this.newFunc();
                this.drawSkin();
                this.addEvent();
            }
            this._connected = false;
            this._played_boo = false;
            return;
        }// end function

        public function seek(param1:Number) : void
        {
            this._ns.seek(param1);
            return;
        }// end function

        public function play(param1 = null) : void
        {
            var evt:* = param1;
            if (this._sysStatus_str == "5")
            {
                trace("_urllllllllllllllllllll:" + this._url);
                this._ns.play(this._url);
                this._isAbendEventSent = false;
                setTimeout(function () : void
            {
                if (!_connected)
                {
                    dispatch(MediaEvent.CONNECT_TIMEOUT);
                    if (_ns != null)
                    {
                        _ns.seek(0);
                        _ns.close();
                    }
                    _sysStatus_str = "5";
                }
                return;
            }// end function
            , this._timeLimit * 1000);
            }
            if (this._sysStatus_str == "4")
            {
                this._ns.resume();
            }
            this._sysStatus_str = "3";
            this.dispatch(MediaEvent.PLAY);
            return;
        }// end function

        public function pause(param1 = null) : void
        {
            this._ns.pause();
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
            if (this._sysStatus_str != "5")
            {
                this._sysStatus_str = "5";
                this._timer.stop();
                this._ns.seek(0);
                this._ns.close();
                if (param1 != "noevent")
                {
                    if (this._finish_boo)
                    {
                        this.dispatch(MediaEvent.STOP, {finish:true});
                        this._finish_boo = false;
                    }
                    else
                    {
                        this.dispatch(MediaEvent.STOP, {finish:false});
                    }
                }
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
            this._video.width = param1.width;
            this._video.height = param1.height;
            this._totTime = param1.duration;
            this._metaByTot = this._ns.bytesTotal;
            Utils.prorata(this._video, this._width_num, this._height_num);
            this._video.x = (this._width_num - this._video.width) / 2;
            this._video.y = (this._height_num - this._video.height) / 2;
            if (param1.keyframes != null)
            {
            }
            else if (param1.seekpoints != null)
            {
                this._seekpoints = param1.seekpoints;
            }
            return;
        }// end function

        public function onCuePoint(event:Event) : void
        {
            return;
        }// end function

        public function onXMPData(param1:Object) : void
        {
            Utils.debug("onXMPData Fired");
            return;
        }// end function

        protected function dfdf() : void
        {
            return;
        }// end function

        protected function onNetStatus(event:NetStatusEvent) : void
        {
            var evt:* = event;
            switch(evt.info.code)
            {
                case "NetStream.Play.Start":
                {
                    trace("开始载入数据流");
                    this._connected = true;
                    this.dispatch(MediaEvent.START);
                    this._timer.start();
                    break;
                }
                case "NetStream.Buffer.Empty":
                {
                    trace("缓冲中...");
                    this.dispatch(MediaEvent.BUFFER_EMPTY);
                    if (this._stopFlag_boo)
                    {
                        this.judgeStop();
                    }
                    break;
                }
                case "NetStream.Buffer.Full":
                {
                    trace("播放中...");
                    this.dispatch(MediaEvent.FULL);
                    if (!this._played_boo)
                    {
                        this._played_boo = true;
                        this.dispatch(MediaEvent.PLAYED);
                    }
                    break;
                }
                case "NetStream.Buffer.Flush":
                {
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (this._stopFlag_boo)
                    {
                        this.judgeStop();
                    }
                    else
                    {
                        this._stopFlag_boo = true;
                        clearTimeout(this._stopTimeout);
                        this._stopTimeout = setTimeout(function () : void
            {
                if (_sysStatus_str == "3")
                {
                    dispatch(MediaEvent.PLAY_ABEND, {playedTime:_ns.time, totTime:_totTime});
                    judgeStop();
                }
                return;
            }// end function
            , 1000);
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    trace("视频不存在!");
                    this.dispatch(MediaEvent.NOTFOUND);
                    break;
                }
                case "NetStream.Seek.Notify":
                {
                    break;
                }
                case "NetStream.Seek.InvalidTime":
                {
                    break;
                }
                case "NetStream.Seek.Failed":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function judgeStop() : void
        {
            trace("_sysStatus_strrrrrrrrrrrrrrrrr:" + this._sysStatus_str);
            if (this._sysStatus_str != "5")
            {
                if (this._isLoop)
                {
                    this.seek(0);
                }
                else
                {
                    this._finish_boo = true;
                    this._stopFlag_boo = false;
                    this.stop();
                }
            }
            return;
        }// end function

        protected function timerHandler(event:TimerEvent) : void
        {
            this.aboutTime();
            this.aboutDownload();
            if (this._totTime != 0 && Math.ceil(this._ns.time * 10) >= Math.floor(this._totTime * 10))
            {
                if (this._stopFlag_boo)
                {
                    this.judgeStop();
                }
                else
                {
                    this._stopFlag_boo = true;
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
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            this._ns = null;
            this._nc = null;
            return;
        }// end function

        protected function aboutTime() : void
        {
            this.dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:this._ns.time, totTime:this._totTime});
            return;
        }// end function

        protected function aboutDownload() : void
        {
            var _loc_1:* = this._ns.bytesLoaded;
            var _loc_2:* = this._ns.bytesTotal;
            this.dispatch(MediaEvent.LOAD_PROGRESS, {nowSize:_loc_1, totSize:this._metaByTot});
            if (_loc_1 >= _loc_2 && _loc_2 > 0)
            {
                if (_loc_2 == this._metaByTot)
                {
                    var _loc_3:int = 0;
                    _loc_1 = 0;
                    var _loc_3:* = _loc_3;
                    _loc_2 = _loc_3;
                    this._metaByTot = _loc_3;
                    this.dispatch(MediaEvent.LOAD_FILE_SUC);
                }
                else if (!this._isAbendEventSent)
                {
                    this.dispatch(MediaEvent.LOAD_ABEND);
                }
            }
            return;
        }// end function

        protected function newFunc() : void
        {
            this._timer = new Timer(100, 0);
            if (!this._timer.hasEventListener(TimerEvent.TIMER))
            {
                this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            }
            this._soundTransform = new SoundTransform();
            this._seekpoints = new Array();
            return;
        }// end function

        protected function drawSkin() : void
        {
            this._bg_spr = new Sprite();
            Utils.drawRect(this._bg_spr, 0, 0, 1, 1, 0, 1);
            addChild(this._bg_spr);
            this._video = new Video();
            addChild(this._video);
            this._video.width = this._width_num;
            this._video.height = this._height_num;
            this._nc = new NetConnection();
            this._nc.connect(null);
            this._ns = new NetStream(this._nc);
            this._ns.bufferTime = this._buffer;
            this._ns.client = this;
            this._video.smoothing = true;
            this._video.attachNetStream(this._ns);
            return;
        }// end function

        protected function addEvent() : void
        {
            this._ns.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            this._width_num = param1;
            this._height_num = param2;
            this._bg_spr.width = param1;
            this._bg_spr.height = param2;
            Utils.prorata(this._video, this._bg_spr.width, this._bg_spr.height);
            Utils.setCenter(this._video, this._bg_spr);
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
            return this._totTime;
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

        public function get seekpoints() : Array
        {
            return this._seekpoints;
        }// end function

        public function get streamState() : String
        {
            var _loc_1:String = null;
            switch(this._sysStatus_str)
            {
                case "5":
                {
                    _loc_1 = "stop";
                    break;
                }
                case "4":
                {
                    _loc_1 = "pause";
                    break;
                }
                case "3":
                {
                    _loc_1 = "play";
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_1;
        }// end function

        public function set volume(param1:Number) : void
        {
            var offset:* = param1;
            this._volume = offset;
            try
            {
                this._soundTransform.volume = offset;
                this._ns.soundTransform = this._soundTransform;
            }
            catch (evt:Error)
            {
                trace("SimpleVideoCore volume");
            }
            return;
        }// end function

    }
}
