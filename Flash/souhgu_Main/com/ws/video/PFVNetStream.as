package com.ws.video
{
    import com.ws.event.*;
    import com.ws.net.*;
    import com.ws.stat.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;

    public class PFVNetStream extends Object
    {
        private var _ns:Object = null;
        private var _nc:NetConnection = null;
        private var _video:Video = null;
        private var _stageVideo:StageVideo = null;
        private var _listenerArray:Array = null;
        private var _isClosed:Boolean = false;
        private var _isPaused:Boolean = false;
        private static var _isPlay:Boolean = false;
        private static var _isFull:Boolean = false;
        private static var _logStat:Statistics = null;
        private static var _isSwitchPlayMode:Boolean = false;
        private static var _isLive:Boolean = false;
        private static var _domain:String = "";
        private static var _token:String = "";
        private static var _playID:String = "";
        private static var _videoID:String = "";
        private static var _factory:VodClassFactory = null;
        private static const LIBRARY_URL:String = "http://www.vod.lxdns.com/pfv/";
        private static const LOAD_DELAY:Number = 10;

        public function PFVNetStream(param1:NetConnection) : void
        {
            this._nc = param1;
            if (ServiceAvailable)
            {
                this._ns = _factory.createNetStream(_isLive);
                this._ns.clientDomain = _domain;
                this._ns.token = _token;
                this._ns.playerGUID = _playID;
                this._ns.addEventListener(PFVEvent.SVC_STATUS, this.onPFVHandler);
            }
            this._listenerArray = new Array();
            return;
        }// end function

        public function get netstream() : NetStream
        {
            return this._ns;
        }// end function

        public function set useTimeShirt(param1:Boolean) : void
        {
            if (this._ns != null)
            {
                this._ns.useTimeShirt = param1;
            }
            return;
        }// end function

        public function set playerGUID(param1:String) : void
        {
            if (this._ns != null)
            {
                this._ns.playerGUID = param1;
            }
            return;
        }// end function

        public function set trackerAddr(param1:String) : void
        {
            if (this._ns != null)
            {
                this._ns.trackerAddr = param1;
            }
            return;
        }// end function

        public function get playInfo() : Object
        {
            if (this._ns != null)
            {
                return this._ns.playInfo;
            }
            return null;
        }// end function

        public function get bufferLength() : Number
        {
            return this._ns.bufferLength;
        }// end function

        public function get bufferTime() : Number
        {
            return this._ns.bufferTime;
        }// end function

        public function set bufferTime(param1:Number) : void
        {
            this._ns.bufferTime = param1;
            return;
        }// end function

        public function get bytesLoaded() : uint
        {
            return this._ns.bytesLoaded;
        }// end function

        public function get bytesTotal() : uint
        {
            return this._ns.bytesTotal;
        }// end function

        public function set checkPolicyFile(param1:Boolean) : void
        {
            this._ns.checkPolicyFile = param1;
            return;
        }// end function

        public function get checkPolicyFile() : Boolean
        {
            return this._ns.checkPolicyFile;
        }// end function

        public function get client() : Object
        {
            return this._ns.client;
        }// end function

        public function set client(param1:Object) : void
        {
            this._ns.client = param1;
            return;
        }// end function

        public function get currentFPS() : Number
        {
            return this._ns.currentFPS;
        }// end function

        public function get decodedFrames() : uint
        {
            return this._ns.decodedFrames;
        }// end function

        public function get liveDelay() : Number
        {
            return this._ns.liveDelay;
        }// end function

        public function get objectEncoding() : uint
        {
            return this._ns.objectEncoding;
        }// end function

        public function get soundTransform() : SoundTransform
        {
            return this._ns.soundTransform;
        }// end function

        public function set soundTransform(param1:SoundTransform) : void
        {
            this._ns.soundTransform = param1;
            return;
        }// end function

        public function get liveTime() : Number
        {
            return this._ns.liveTime;
        }// end function

        public function get time() : Number
        {
            return this._ns.time;
        }// end function

        public function get audioCodec() : uint
        {
            return this._ns.audioCodec;
        }// end function

        public function get videoCodec() : uint
        {
            return this._ns.videoCodec;
        }// end function

        private function dispatcherPFVEvent(param1:String, param2:Number) : void
        {
            var _loc_3:* = new Object();
            _loc_3.code = param1;
            _loc_3.playTime = param2;
            var _loc_4:* = new PFVEvent(PFVEvent.SVC_STATUS, false, false, _loc_3);
            this.dispatchEvent(_loc_4);
            return;
        }// end function

        public function attachAudio(param1:Microphone) : void
        {
            this._ns.attachAudio(param1);
            return;
        }// end function

        public function attachCamera(param1:Camera, param2:int = -1) : void
        {
            this._ns.attachCamera(param1, param2);
            return;
        }// end function

        public function attachVideo(param1:Video) : void
        {
            this._video = param1;
            this._video.attachNetStream(this._ns);
            return;
        }// end function

        public function attachStageVideo(param1:StageVideo) : void
        {
            this._stageVideo = param1;
            this._stageVideo.attachNetStream(this._ns);
            return;
        }// end function

        public function close() : void
        {
            if (this._ns != null)
            {
                this._isClosed = true;
                this._ns.close();
            }
            _isPlay = false;
            _isFull = false;
            return;
        }// end function

        public function pause() : void
        {
            if (this._ns != null)
            {
                this._isPaused = true;
                this._ns.pause();
            }
            return;
        }// end function

        public function play(... args) : void
        {
            this._isClosed = false;
            this._isPaused = false;
            if (this._ns != null)
            {
                this._ns.play(args);
            }
            return;
        }// end function

        public function publish(param1:String = null, param2:String = null) : void
        {
            this._ns.publish(param1, param2);
            return;
        }// end function

        public function receiveAudio(param1:Boolean) : void
        {
            this._ns.receiveAudio(param1);
            return;
        }// end function

        public function receiveVideo(param1:Boolean) : void
        {
            this._ns.receiveVideo(param1);
            return;
        }// end function

        public function receiveVideoFPS(param1:Number) : void
        {
            this._ns.receiveVideoFPS(param1);
            return;
        }// end function

        public function resume() : void
        {
            if (this._ns != null)
            {
                this._isPaused = false;
                this._ns.resume();
            }
            return;
        }// end function

        public function seek(param1:Number) : void
        {
            if (this._ns != null)
            {
                this._ns.seek(param1);
            }
            return;
        }// end function

        public function send(param1:String, ... args) : void
        {
            this._ns.send.apply(param1, args);
            return;
        }// end function

        public function togglePause() : void
        {
            if (this._ns != null)
            {
                this._ns.togglePause();
            }
            return;
        }// end function

        public function draw(param1:BitmapData) : void
        {
            if (this._video == null || this._ns == null || param1 == null || _isLive)
            {
                return;
            }
            this._ns.draw(this._video, param1);
            return;
        }// end function

        public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            this._ns.addEventListener(param1, param2, param3, param4, param5);
            var _loc_6:Object = null;
            var _loc_7:int = 0;
            while (_loc_7 < this._listenerArray.length)
            {
                
                _loc_6 = this._listenerArray[_loc_7];
                if (_loc_6["type"] == param1 && _loc_6["useCapture"] == param3)
                {
                    return;
                }
                _loc_7++;
            }
            _loc_6 = new Object();
            _loc_6["type"] = param1;
            _loc_6["listener"] = param2;
            _loc_6["useCapture"] = param3;
            _loc_6["priority"] = param4;
            _loc_6["useWeakReference"] = param5;
            this._listenerArray.push(_loc_6);
            return;
        }// end function

        public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            this._ns.removeEventListener(param1, param2, param3);
            var _loc_4:Object = null;
            var _loc_5:int = 0;
            while (_loc_5 < this._listenerArray.length)
            {
                
                _loc_4 = this._listenerArray[_loc_5];
                if (_loc_4["type"] == param1 && _loc_4["useCapture"] == param3)
                {
                    this._listenerArray.splice(_loc_5, 1);
                    _loc_4 = null;
                    return;
                }
                _loc_5++;
            }
            return;
        }// end function

        private function onPFVHandler(event:PFVEvent) : void
        {
            switch(event.info.code)
            {
                case "PFVNetStream.Internal.Error":
                {
                    _isSwitchPlayMode = true;
                    this._ns.close();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function hasEventListener(param1:String) : Boolean
        {
            return this._ns.hasEventListener(param1);
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            return this._ns.dispatchEvent(event);
        }// end function

        public function willTrigger(param1:String) : Boolean
        {
            return this._ns.willTrigger(param1);
        }// end function

        public static function Load(param1:Function, param2:String, param3:String, param4:String, param5:Boolean = false, param6:Boolean = false, param7:Number = 10) : void
        {
            _domain = param2;
            _token = param3;
            _isLive = param5;
            _videoID = StringUtil.ltrimBias(param4);
            _playID = PFVNetStream.String(MathUtil.random(100, 65535)) + PFVNetStream.String(MathUtil.random(100, 65535)) + PFVNetStream.String(MathUtil.random(100, 65535));
            _logStat = new Statistics(_domain, _isLive, _playID, _videoID);
            var _loc_8:* = LIBRARY_URL + param2;
            if (param5)
            {
                _loc_8 = _loc_8 + (param6 ? ("/wsUtil.L.unstable") : ("/wsUtil.L.stable"));
            }
            else
            {
                _loc_8 = _loc_8 + (param6 ? ("/wsUtil.V.unstable") : ("/wsUtil.V.stable"));
            }
            var _loc_9:* = new Object();
            new Object().type = "Start";
            _loc_9.time = int(new Date().getTime() / 1000);
            _logStat.reportStatInfo(Statistics.LIB_LOAD, _loc_9);
            _factory = new VodClassFactory(_loc_8, param1, _logStat);
            if (VodClassFactory.checkCompatibility())
            {
                _factory.load(param7 * 1000);
            }
            else
            {
                _loc_9 = new Object();
                _loc_9.type = "Uncompatibility";
                _loc_9.time = int(new Date().getTime() / 1000);
                _logStat.reportStatInfo(Statistics.LIB_LOAD, _loc_9);
                PFVNetStream.param1();
            }
            return;
        }// end function

        public static function get isLive() : Boolean
        {
            return _isLive;
        }// end function

        public static function get ServiceAvailable() : Boolean
        {
            if (_factory == null)
            {
                return false;
            }
            return _factory.isSuccess && !_isSwitchPlayMode;
        }// end function

        public static function set playAction(param1:String) : void
        {
            var _loc_2:* = new Object();
            var _loc_3:* = param1.toLocaleUpperCase();
            if (_factory == null)
            {
                return;
            }
            if (_loc_3 != "PLAY" && _loc_3 != "FULL")
            {
                return;
            }
            if (_loc_3 == "PLAY")
            {
                if (!_isPlay)
                {
                    _isPlay = true;
                    _loc_2.type = "Play";
                }
                else
                {
                    return;
                }
            }
            else if (_loc_3 == "FULL")
            {
                if (!_isFull)
                {
                    _isFull = true;
                    _loc_2.type = "Full";
                }
                else
                {
                    return;
                }
            }
            _loc_2.serviceAvailable = ServiceAvailable;
            _loc_2.isError = _isSwitchPlayMode;
            _loc_2.isSuccess = _factory.isSuccess;
            if (_logStat != null)
            {
                _logStat.reportStatInfo(Statistics.PLAY_ACTION, _loc_2);
            }
            return;
        }// end function

    }
}
