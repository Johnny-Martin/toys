package com.sohu.tv.mediaplayer.ui
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.video.*;
    import ebing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;

    public class VideoInfoPanel extends TvSohuPanel
    {
        private var _timer:Timer;
        private var _beforeSize:Number = 0;
        private var _speed_txt:TextField;
        private var _volume_txt:TextField;
        private var _rate_txt:TextField;
        private var _averageSpeed_txt:TextField;
        private var _bytesTotal_txt:TextField;
        private var _metaSize_txt:TextField;
        private var _currentSize_txt:TextField;
        private var _scale_txt:TextField;
        private var _light_txt:TextField;
        private var _contrast_txt:TextField;
        private var _saturation_txt:TextField;
        private var _fps_txt:TextField;
        private var _loadTime:uint = 0;
        private var _totSpeed:Number = 0;
        private var _totTime:Number = 0;
        private var _averageSpeed:Number = 0;
        private var _time_arr:Array;
        private var _playback:TvSohuMediaPlayback;
        private var _renderStat_txt:TextField;
        private var _kbps_txt:TextField;
        private var _videoFps_txt:TextField;
        private var _dropFrames_txt:TextField;
        private var _mode_txt:TextField;
        private var _svdLen_txt:TextField;
        private var _stvdcolor_txt:TextField;

        public function VideoInfoPanel(param1:MovieClip, param2:TvSohuMediaPlayback)
        {
            this._speed_txt = param1.speed_txt;
            this._volume_txt = param1.volume_txt;
            this._rate_txt = param1.rate_txt;
            this._averageSpeed_txt = param1.averageSpeed_txt;
            this._bytesTotal_txt = param1.bytesTotal_txt;
            this._metaSize_txt = param1.metaSize_txt;
            this._currentSize_txt = param1.currentSize_txt;
            this._scale_txt = param1.scale_txt;
            this._light_txt = param1.light_txt;
            this._contrast_txt = param1.contrast_txt;
            this._saturation_txt = param1.saturation_txt;
            this._fps_txt = param1.fps_txt;
            this._renderStat_txt = param1.renderStat_txt;
            this._kbps_txt = param1.kbps_txt;
            this._videoFps_txt = param1.videoFps_txt;
            this._dropFrames_txt = param1.dropFrames_txt;
            this._mode_txt = param1.mode_txt;
            this._svdLen_txt = param1.svdLen_txt;
            this._stvdcolor_txt = param1.stvdcolor_txt;
            this._playback = param2;
            this.newFunc();
            this.drawSkin();
            this.addEvent();
            super(param1);
            if (this._playback.core != null && this._playback.core != undefined)
            {
                this._beforeSize = this._playback.core.fileLoadedSize;
                this._timer.start();
            }
            return;
        }// end function

        private function newFunc() : void
        {
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
            this._time_arr = new Array();
            return;
        }// end function

        private function drawSkin() : void
        {
            return;
        }// end function

        private function addEvent() : void
        {
            return;
        }// end function

        public function get averageSpeedForNum() : Number
        {
            if (PlayerConfig.isFms)
            {
                this._averageSpeed = 0;
            }
            return this._averageSpeed;
        }// end function

        public function get averageSpeed() : String
        {
            return this._averageSpeed_txt.text;
        }// end function

        public function get speed() : String
        {
            return this._speed_txt.text;
        }// end function

        private function getSpeed(param1:Number) : String
        {
            param1 = isNaN(param1) ? (0) : (param1);
            var _loc_2:* = param1 / 1024;
            var _loc_3:* = _loc_2;
            var _loc_4:String = " KB/S";
            if (_loc_2 > 1024)
            {
                _loc_3 = _loc_2 / 1024;
                _loc_4 = " MB/S";
            }
            return Utils.numberFormat(_loc_3, 2) + _loc_4;
        }// end function

        private function timerHandler(event:TimerEvent) : void
        {
            var by:Number;
            var loadedSize:Number;
            var speed:Number;
            var clipLoadState:String;
            var clipIsErr:Boolean;
            var tsp:Number;
            var asp:Number;
            var i:uint;
            var vrate:Number;
            var vr:String;
            var bt:String;
            var scale:String;
            var so:SharedObject;
            var flushResult:String;
            var evt:* = event;
            if (this._playback.core != null && this._playback.core != undefined)
            {
                by = this._playback.core.videoArr[this._playback.core.loadingClipIndex].ns.bytesLoaded;
                loadedSize = by < 0 ? (0) : (by);
                speed = loadedSize - this._beforeSize < 0 ? (0) : (loadedSize - this._beforeSize);
                if (this._time_arr.length > 10)
                {
                    this._time_arr.shift();
                }
                this._time_arr.push(speed);
                clipLoadState = this._playback.core.videoArr[this._playback.core.loadingClipIndex].download;
                clipIsErr = this._playback.core.videoArr[this._playback.core.loadingClipIndex].iserr;
                tsp;
                asp;
                i;
                while (i < this._time_arr.length)
                {
                    
                    tsp = tsp + this._time_arr[i];
                    i = (i + 1);
                }
                asp = tsp / this._time_arr.length;
                this._speed_txt.text = asp >= 0 ? (this.getSpeed(asp)) : ("-");
                if (clipIsErr)
                {
                    this._speed_txt.text = "本段链接终止";
                }
                else if (clipLoadState == "loaded" || clipLoadState == "part_loaded")
                {
                    this._speed_txt.text = "本段下载完毕";
                }
                else if (speed >= 0)
                {
                    this._totSpeed = this._totSpeed + speed;
                    (this._loadTime + 1);
                }
                this._averageSpeed = this._totSpeed / this._loadTime;
                this._volume_txt.text = String(Math.round(this._playback.core.volume * 100)) + "%";
                vrate = this._playback.core.vrate;
                this._averageSpeed_txt.text = this.getSpeed(this._totSpeed / this._loadTime);
                var _loc_3:String = this;
                var _loc_4:* = this._totTime + 1;
                _loc_3._totTime = _loc_4;
                if (this._totTime % 60 == 0 && !PlayerConfig.isLive)
                {
                    so = SharedObject.getLocal("vmsPlayer", "/");
                    so.data.bw = Math.round(this._totSpeed / this._loadTime / 1024 * 8);
                    try
                    {
                        flushResult = so.flush();
                        if (flushResult == SharedObjectFlushStatus.PENDING)
                        {
                            so.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (flushResult == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                }
                if (PlayerConfig.isFms || PlayerConfig.isCounterfeitFms)
                {
                    var _loc_3:String = "无法测速";
                    this._speed_txt.text = "无法测速";
                    this._averageSpeed_txt.text = _loc_3;
                }
                else if (clipIsErr)
                {
                    this._averageSpeed_txt.text = "链接终止";
                }
                bt = Utils.numberFormat(this._playback.core.fileTotSize / 1024 / 1024, 2) + " MB";
                this._bytesTotal_txt.text = bt;
                this._currentSize_txt.text = String(Math.round(this._playback.core.videoContainer.width)) + "*" + String(Math.round(this._playback.core.videoContainer.height));
                scale;
                switch(this._playback.core.scaleState)
                {
                    case "4_3":
                    {
                        scale;
                        break;
                    }
                    case "16_9":
                    {
                        scale;
                        break;
                    }
                    case "meta":
                    {
                        scale;
                        break;
                    }
                    case "full":
                    {
                        scale;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._scale_txt.text = scale;
                this._light_txt.text = this._playback.lightRate != 0.5 ? (String(Math.round(((this._playback.lightRate - 1) * 2 + 1) * 100)) + "%") : ("原始亮度");
                this._contrast_txt.text = this._playback.contrastRate != 0.5 ? (String(Math.round(((this._playback.contrastRate - 1) * 2 + 1) * 100)) + "%") : ("原始对比度");
                this._saturation_txt.text = this._playback.saturationRate != 0.5 ? (String(Math.round(((this._playback.saturationRate - 1) * 2 + 1) * 100)) + "%") : ("原始饱和度");
                this._fps_txt.text = Utils.numberFormat(this._playback.core.ns.currentFPS, 2) + " Fps";
                this._beforeSize = loadedSize;
                try
                {
                    this._renderStat_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getRenderStat();
                    this._kbps_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getKbps();
                    this._videoFps_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getVideoFps();
                    this._dropFrames_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getDropFrames();
                    this._svdLen_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getSvdLen();
                    this._stvdcolor_txt.text = this._playback.core.videoArr[this._playback.core.curIndex].video.info.getCurColor() + "--" + this._playback.core.videoArr[this._playback.core.curIndex].video.info.getColorSpace();
                }
                catch (evt:Error)
                {
                }
            }
            ;
            var _loc_3:* = new catch2;
            evt;
            return;
        }// end function

        private function onStatusShare(event:NetStatusEvent) : void
        {
            if (event.info.code == "SharedObject.Flush.Success")
            {
            }
            else if (event.info.code == "SharedObject.Flush.Failed")
            {
            }
            event.target.removeEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
            return;
        }// end function

        override public function open(param1 = null) : void
        {
            super.open();
            if (this._playback.core != null && this._playback.core != undefined)
            {
                this._beforeSize = this._playback.core.fileLoadedSize;
            }
            return;
        }// end function

        override public function close(param1 = null) : void
        {
            super.close(param1);
            return;
        }// end function

        public function loadProgress(param1) : void
        {
            return;
        }// end function

    }
}
