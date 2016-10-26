package ebing.media.mpb31
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import ebing.*;
    import ebing.controls.*;
    import ebing.controls.s1.*;
    import ebing.core.vc31.*;
    import ebing.events.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;
    import flash.utils.*;

    public class MediaPlayback extends Sprite
    {
        protected var _width:Number;
        protected var _height:Number;
        protected var _parObj:Object;
        protected var _cover_c:Sprite;
        protected var _core:Object;
        protected var _corePath:String = "";
        protected var _coverImgPath:String = "";
        protected var _skinPath:String = "";
        protected var _isHide:Boolean;
        protected var _seekTime:Number = 0;
        protected var _hardInitHandler:Function;
        protected var _progress_sld:SliderUtil;
        protected var _volume_sld:VolumeBar;
        protected var _play_btn:ButtonUtil;
        protected var _startPlay_btn:ButtonUtil;
        protected var _pause_btn:ButtonUtil;
        protected var _fullScreen_btn:ButtonUtil;
        protected var _normalScreen_btn:ButtonUtil;
        protected var _cinema_btn:ButtonUtil;
        protected var _window_btn:ButtonUtil;
        protected var _ctrlBarBg_spr:Object;
        protected var _timeDisplay:Sprite;
        protected var _tipDisplay:Sprite;
        protected var _skin:Object;
        protected var _skinData:XML;
        protected var _timeout_to:Timeout;
        protected var _hitArea_spr:Sprite;
        protected var _hideTween:TweenLite;
        protected var _showTween:TweenLite;
        protected var _showBar_boo:Boolean = false;
        private var K102606DCD83677FC334392AE66EF40F9806F81373569K:String = "";
        protected var _function:Function;
        protected var _fileNowTime:Number = 0;
        protected var _fileTotTime:Number = 0;
        protected var _ctrlBar_c:Sprite;
        protected var _skinMap:HashMap;
        protected var _isDrag:Boolean = true;
        protected var _tipTextTimeout:uint = 0;
        protected var _skinLoaderInfo:LoaderInfo;

        public function MediaPlayback()
        {
            return;
        }// end function

        public function hardInit(param1:Object) : void
        {
            this._parObj = param1;
            this._width = this._parObj.width;
            this._height = this._parObj.height;
            this._corePath = this._parObj.core;
            this._isHide = this._parObj.isHide;
            this._skinPath = this._parObj.skinPath;
            this._hardInitHandler = this._parObj.hardInitHandler;
            this.registerUi();
            this.loadCore();
            return;
        }// end function

        protected function sysInit(param1:String = null) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
                this.drawSkin();
                this.addEvent();
                this._hardInitHandler({info:"success"});
            }
            this._showBar_boo = false;
            this._seekTime = 0;
            if (this._skin != null)
            {
                this.playProgress({obj:{nowTime:0, totTime:0, isSeek:false}});
                this.loadProgress({obj:{nowSize:0, totSize:0}});
                this._fullScreen_btn.enabled = false;
                this._normalScreen_btn.enabled = false;
                this._volume_sld.rate = this._core.volume;
            }
            return;
        }// end function

        protected function addEvent() : void
        {
            this._core.addEventListener(MediaEvent.PLAY, this.onPlay);
            this._core.addEventListener(MediaEvent.PAUSE, this.onPause);
            this._core.addEventListener(MediaEvent.STOP, this.onStop);
            this._core.addEventListener(MediaEvent.START, this.onStart);
            this._core.addEventListener(MediaEvent.PLAYED, this.onPlayed);
            this._core.addEventListener(MediaEvent.FULL, this.bufferFull);
            this._core.addEventListener(MediaEvent.BUFFER_EMPTY, this.bufferEmpty);
            this._core.addEventListener(MediaEvent.PLAY_PROGRESS, this.playProgress);
            this._core.addEventListener(MediaEvent.LOAD_PROGRESS, this.loadProgress);
            this._core.addEventListener(MediaEvent.NOTFOUND, this.mediaNotfound);
            this._core.addEventListener(MediaEvent.DRAG_START, this.dragStart);
            this._core.addEventListener(MediaEvent.DRAG_END, this.dragEnd);
            this._core.addEventListener(MediaEvent.CONNECTING, this.mediaConnecting);
            this._startPlay_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.startPlayMouseUp);
            this._play_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.playMouseUp);
            this._pause_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.pauseMouseUp);
            this._progress_sld.addEventListener(SliderEventUtil.SLIDER_RATE, this.progressSlide);
            this._progress_sld.addEventListener(SliderEventUtil.SLIDE_START, this.progressSlideStart);
            this._progress_sld.addEventListener(SliderEventUtil.SLIDE_END, this.progressSlideEnd);
            this._volume_sld.slider.addEventListener(SliderEventUtil.SLIDER_RATE, this.volumeSlide);
            this._volume_sld.slider.addEventListener(SliderEventUtil.SLIDE_END, this.volumeSlideEnd);
            this._fullScreen_btn.addEventListener(MouseEventUtil.CLICK, this.fullMouseClick);
            this._normalScreen_btn.addEventListener(MouseEventUtil.CLICK, this.exitFullMouseClick);
            this._hitArea_spr.addEventListener(MouseEvent.CLICK, this.hitAreaClick);
            this._hitArea_spr.addEventListener(MouseEvent.DOUBLE_CLICK, this.hitAreaDClick);
            this._ctrlBarBg_spr.addEventListener(MouseEvent.MOUSE_UP, this.ctrlBarBgUp);
            this._timeout_to.addEventListener(Timeout.TIMEOUT, this.hideBar);
            stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.onFullScreenChange);
            return;
        }// end function

        protected function loadCore() : void
        {
            this.coreHandler({info:"success", data:{content:new VideoCore({doInit:true, width:this._width, height:this._height, buffer:this._parObj.buffer})}});
            return;
        }// end function

        protected function coreHandler(param1:Object) : void
        {
            if (param1.info == "success")
            {
                this._core = param1.data.content;
                this.coreLoadSuccess();
            }
            else if (param1.info == "timeout")
            {
                this.coreLoadTimeout();
            }
            else
            {
                this.coreLoadIoError();
            }
            return;
        }// end function

        protected function coreLoadSuccess() : void
        {
            trace("内核加载成功！");
            this._cover_c = new Sprite();
            addChild(this._core);
            var _loc_1:int = 0;
            this._core.y = 0;
            this._core.x = _loc_1;
            addChild(this._cover_c);
            this.loadSkin();
            return;
        }// end function

        protected function coreLoadTimeout() : void
        {
            trace("内核加载超时！");
            this._hardInitHandler({info:"timeout"});
            return;
        }// end function

        protected function coreLoadIoError() : void
        {
            trace("内核加载IO错误！");
            this._hardInitHandler({info:"ioerror"});
            return;
        }// end function

        protected function onFullScreenChange(event:FullScreenEvent) : void
        {
            return;
        }// end function

        protected function volumeSlideEnd(param1:SliderEventUtil) : void
        {
            this._core.saveVolume();
            return;
        }// end function

        protected function volumeSlide(param1:SliderEventUtil) : void
        {
            this._core.volume = param1.obj.rate;
            return;
        }// end function

        protected function startPlayMouseUp(param1:MouseEventUtil) : void
        {
            this._core.play();
            return;
        }// end function

        protected function playMouseUp(param1:MouseEventUtil) : void
        {
            this._core.play();
            return;
        }// end function

        protected function pauseMouseUp(param1:MouseEventUtil) : void
        {
            this._core.pause(param1);
            return;
        }// end function

        protected function progressSlide(param1:SliderEventUtil) : void
        {
            this.seek(param1);
            return;
        }// end function

        protected function progressSlideStart(param1:SliderEventUtil) : void
        {
            this._core.sleep();
            return;
        }// end function

        protected function progressSlideEnd(param1:SliderEventUtil) : void
        {
            this.seekEnd(param1);
            return;
        }// end function

        protected function fullMouseClick(param1:MouseEventUtil = null) : void
        {
            this._core.changeScreenMode();
            var _loc_2:Boolean = false;
            this._skinMap.getValue("fullScreenBtn").v = false;
            this._skinMap.getValue("fullScreenBtn").e = _loc_2;
            var _loc_2:Boolean = true;
            this._skinMap.getValue("normalScreenBtn").v = true;
            this._skinMap.getValue("normalScreenBtn").e = _loc_2;
            this.setSkinState();
            return;
        }// end function

        protected function exitFullMouseClick(param1:MouseEventUtil = null) : void
        {
            this._core.changeScreenMode();
            var _loc_2:Boolean = true;
            this._skinMap.getValue("fullScreenBtn").v = true;
            this._skinMap.getValue("fullScreenBtn").e = _loc_2;
            var _loc_2:Boolean = false;
            this._skinMap.getValue("normalScreenBtn").v = false;
            this._skinMap.getValue("normalScreenBtn").e = _loc_2;
            this.setSkinState();
            return;
        }// end function

        protected function hitAreaClick(event:MouseEvent) : void
        {
            this._core.playOrPause();
            return;
        }// end function

        protected function hitAreaDClick(event:MouseEvent) : void
        {
            this._hitArea_spr.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            this._core.changeScreenMode();
            return;
        }// end function

        public function seek(param1 = null) : void
        {
            var _loc_2:* = param1 is Number ? (param1) : (param1.obj.rate);
            var _loc_3:* = this._core.fileTotTime;
            var _loc_4:* = Math.round(_loc_3 * _loc_2);
            this._core.dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:_loc_4, totTime:_loc_3, isSeek:true});
            if (!(param1 is Number) && param1.obj.sign == 0)
            {
                if (Math.abs(_loc_4 - this._seekTime) >= 6)
                {
                    this._seekTime = _loc_4;
                    this._core.seek(this._seekTime, param1.obj.sign);
                }
            }
            else
            {
                this._seekTime = _loc_4;
                this._core.seek(this._seekTime);
            }
            return;
        }// end function

        protected function seekEnd(param1:SliderEventUtil) : void
        {
            var _loc_2:Boolean = false;
            var _loc_3:* = param1.obj;
            if (_loc_3.sign == 0)
            {
                this.seek(_loc_3.rate);
            }
            if (!_loc_2)
            {
                _loc_2 = true;
                this._core.play();
            }
            return;
        }// end function

        protected function volumeSeek(param1) : void
        {
            this._core.volume = param1.target.volumeSliderRate;
            return;
        }// end function

        protected function newFunc() : void
        {
            this._timeout_to = new Timeout(3);
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            param1 = param1 < 0 ? (1) : (param1);
            param2 = param2 < 0 ? (1) : (param2);
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            this._width = param1;
            this._height = param2;
            if (stage.displayState == "fullScreen")
            {
                if (this._skin != null)
                {
                    this.startTween();
                }
            }
            else if (this._isHide && this._skin != null)
            {
                this.startTween();
            }
            else if (this._skin != null)
            {
                _loc_4 = param2 - this.ctrlBarBg.height;
                this.stopTween();
            }
            this._core.resize(_loc_3, _loc_4);
            if (this._cover_c.width != 0 && this._cover_c.height != 0)
            {
                Utils.prorata(this._cover_c, _loc_3, _loc_4);
                Utils.setCenter(this._cover_c, this._core);
            }
            this.setSkinState();
            return;
        }// end function

        public function showCover() : void
        {
            trace("showCover method in MediaPlayback", "_coverImgPath:" + this._coverImgPath, "_cover_c.numChildren:" + this._cover_c.numChildren);
            if (this._coverImgPath != "" && this._cover_c.numChildren == 0)
            {
                new LoaderUtil().load(3, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    trace("coverimg load success");
                    _cover_c.addChild(param1.data);
                    _cover_c.visible = true;
                    resize(_width, _height);
                }
                return;
            }// end function
            , null, this._coverImgPath);
            }
            else if (this._cover_c.numChildren > 0)
            {
                this._cover_c.visible = true;
            }
            return;
        }// end function

        public function softInit(param1:Object) : void
        {
            var _loc_2:* = param1.filePath;
            var _loc_3:* = param1.fileTime;
            var _loc_4:* = param1.fileSize;
            var _loc_5:* = param1.skinPath;
            this._isDrag = param1.isDrag;
            this._coverImgPath = param1.cover;
            this._core.initMedia({size:_loc_4, time:_loc_3, flv:_loc_2, isDrag:this._isDrag});
            return;
        }// end function

        protected function loadSkin(param1:String = "") : void
        {
            if (this._skin == null)
            {
                new LoaderUtil().load(20, this.skinHandler, null, param1 == "" ? (this._skinPath) : (param1));
            }
            return;
        }// end function

        protected function registerUi() : void
        {
            this._skinMap = new HashMap();
            this.register("playBtn", {e:true, v:true});
            this.register("startPlayBtn", {e:true, v:true});
            this.register("pauseBtn", {e:false, v:false});
            this.register("progressBar", {e:false, v:true, totTime:0});
            this.register("volumeBar", {e:false, v:true});
            this.register("fullScreenBtn", {e:false, v:true});
            this.register("normalScreenBtn", {e:false, v:false});
            this.register("hitAreaBtn", {e:false, v:true});
            this.register("lightBar", {e:false, v:true});
            this.register("timeDisplay", {e:false, v:true});
            this.register("tipDisplay", {e:false, v:false, text:""});
            return;
        }// end function

        protected function register(param1:String, param2:Object) : void
        {
            if (!this._skinMap.containsKey(param1))
            {
                this._skinMap.put(param1, param2);
            }
            return;
        }// end function

        protected function skinHandler(param1:Object) : void
        {
            if (param1.info == "success")
            {
                trace("皮肤加载成功!");
                if (this._skin != null)
                {
                    this.removeSkin();
                }
                this._skin = param1.data.content;
                this._skinLoaderInfo = param1.loaderinfo;
                this.sysInit("start");
            }
            else if (param1.info == "timeout")
            {
                trace("皮肤加载超时!");
            }
            else
            {
                trace("皮肤加载IoError!");
            }
            return;
        }// end function

        protected function removeSkin() : void
        {
            return;
        }// end function

        protected function drawSkin() : void
        {
            var _loc_6:Object = null;
            var _loc_11:Object = null;
            var _loc_12:* = undefined;
            var _loc_1:* = this._skinMap.keys();
            var _loc_2:uint = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                for (_loc_12 in this._skin.status[_loc_1[_loc_2]])
                {
                    
                    this._skinMap.getValue(_loc_1[_loc_2])[_loc_12] = this._skin.status[_loc_1[_loc_2]][_loc_12];
                }
                _loc_2 = _loc_2 + 1;
            }
            this._ctrlBarBg_spr = this._skin["ctrlBg_mc"];
            this._ctrlBarBg_spr.x = 0;
            this._ctrlBarBg_spr.y = 0;
            this._hitArea_spr = new Sprite();
            Utils.drawRect(this._hitArea_spr, 0, 0, this._width, this._height, 16777215, 0);
            var _loc_13:Boolean = true;
            this._hitArea_spr.useHandCursor = true;
            this._hitArea_spr.buttonMode = _loc_13;
            this._hitArea_spr.useHandCursor = true;
            this._play_btn = new ButtonUtil({skin:this._skin["play_btn"]});
            this._startPlay_btn = new ButtonUtil({skin:this._skin["startPlay_btn"]});
            this._pause_btn = new ButtonUtil({skin:this._skin["pause_btn"]});
            this._fullScreen_btn = new ButtonUtil({skin:this._skin["fullScreen_btn"]});
            this._normalScreen_btn = new ButtonUtil({skin:this._skin["normalScreen_btn"]});
            this._cinema_btn = new ButtonUtil({skin:this._skin["cinema_btn"]});
            this._window_btn = new ButtonUtil({skin:this._skin["window_btn"]});
            this._timeDisplay = this._skin["time_mc"];
            this._tipDisplay = this._skin["status_mc"];
            var _loc_3:* = new ButtonUtil({skin:this._skin["pro_btn"]});
            var _loc_4:* = new ButtonUtil({skin:this._skin["forward_btn"]});
            var _loc_5:* = new ButtonUtil({skin:this._skin["back_btn"]});
            _loc_6 = {top:this._skin["proTop_mc"], middle:this._skin["proMiddle_mc"], bottom:this._skin["proBottom_mc"], dollop:_loc_3};
            this._progress_sld = new SliderUtil({skin:_loc_6, isDrag:this._isDrag});
            var _loc_7:* = new ButtonUtil({skin:this._skin["muteVol_btn"]});
            var _loc_8:* = new ButtonUtil({skin:this._skin["comebackVol_btn"]});
            var _loc_9:* = new ButtonUtil({skin:this._skin["dollopVol_btn"]});
            var _loc_10:* = new ButtonUtil({skin:this._skin["continueVol_btn"]});
            _loc_11 = {top:this._skin["volTop_mc"], middle:this._skin["volMiddle_mc"], bottom:this._skin["volBottom_mc"], previewTip:this._skin["volPeviewTip_mc"], dollop:_loc_9, muteBtn:_loc_7, comebackBtn:_loc_8};
            this._volume_sld = new VolumeBar({skin:_loc_11});
            this._ctrlBar_c = new Sprite();
            addChild(this._hitArea_spr);
            this._ctrlBar_c.addChild(this._ctrlBarBg_spr);
            this._ctrlBar_c.addChild(this._pause_btn);
            this._ctrlBar_c.addChild(this._play_btn);
            this._ctrlBar_c.addChild(this._normalScreen_btn);
            this._ctrlBar_c.addChild(this._fullScreen_btn);
            this._ctrlBar_c.addChild(this._progress_sld);
            this._ctrlBar_c.addChild(this._volume_sld);
            this._ctrlBar_c.addChild(this._tipDisplay);
            this._ctrlBar_c.addChild(this._timeDisplay);
            this._ctrlBar_c.addChild(this._cinema_btn);
            this._ctrlBar_c.addChild(this._window_btn);
            this._ctrlBar_c.addChild(this._startPlay_btn);
            addChild(this._ctrlBar_c);
            this.resize(this._width, this._height);
            return;
        }// end function

        protected function tipText(param1:String, param2:uint = 0) : void
        {
            var msg:* = param1;
            var timeout:* = param2;
            if (msg != "")
            {
                this._tipDisplay["status_txt"].text = msg;
                this._tipDisplay.visible = true;
                if (timeout > 0)
                {
                    clearTimeout(this._tipTextTimeout);
                    this._tipTextTimeout = setTimeout(function () : void
            {
                tipText("");
                return;
            }// end function
            , timeout * 1000);
                }
            }
            else
            {
                this._tipDisplay.visible = false;
            }
            return;
        }// end function

        protected function setSkinState() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (this._skin != null)
            {
                _loc_1 = new Object();
                this._hitArea_spr.width = this._core.width;
                this._hitArea_spr.height = this._core.height;
                this._hitArea_spr.x = this._core.x;
                this._hitArea_spr.y = this._core.y;
                _loc_2 = this._hitArea_spr.width - this._ctrlBarBg_spr.width;
                var _loc_4:* = this._hitArea_spr.width;
                this._ctrlBarBg_spr.width = this._hitArea_spr.width;
                _loc_3 = _loc_4;
                this._ctrlBarBg_spr.y = 0;
                this._ctrlBar_c.x = this._hitArea_spr.x;
                if (!this._showBar_boo)
                {
                    this._ctrlBar_c.y = this._hitArea_spr.y + this._hitArea_spr.height;
                }
                else
                {
                    this._ctrlBar_c.y = this._hitArea_spr.y + this._hitArea_spr.height - this._ctrlBarBg_spr.height;
                }
                _loc_1 = this._skinMap.getValue("playBtn");
                var _loc_4:* = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                _loc_1.x = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                this._play_btn.x = _loc_4;
                this._play_btn.y = _loc_1.y;
                this._play_btn.visible = _loc_1.v && _loc_3 > _loc_1.w;
                this._play_btn.enabled = _loc_1.e;
                _loc_1 = this._skinMap.getValue("startPlayBtn");
                this._startPlay_btn.x = 10;
                this._startPlay_btn.y = -this._startPlay_btn.height - 10;
                this._startPlay_btn.visible = _loc_1.v && _loc_3 > _loc_1.w;
                this._startPlay_btn.enabled = _loc_1.e;
                _loc_1 = this._skinMap.getValue("pauseBtn");
                var _loc_4:* = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                _loc_1.x = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                this._pause_btn.x = _loc_4;
                this._pause_btn.y = _loc_1.y;
                this._pause_btn.visible = _loc_1.v && _loc_3 > _loc_1.w;
                this._pause_btn.enabled = _loc_1.e;
                _loc_1 = this._skinMap.getValue("progressBar");
                var _loc_4:* = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                _loc_1.x = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                this._progress_sld.x = _loc_4;
                this._progress_sld.y = _loc_1.y;
                this._progress_sld.resize(this._progress_sld.width + _loc_2);
                this._progress_sld.enabled = _loc_1.e;
                this._progress_sld.topRate = _loc_1.topRate;
                _loc_1 = this._skinMap.getValue("timeDisplay");
                var _loc_4:* = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                _loc_1.x = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                this._timeDisplay.x = _loc_4;
                this._timeDisplay.y = _loc_1.y;
                _loc_1 = this._skinMap.getValue("tipDisplay");
                var _loc_4:* = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                _loc_1.x = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                this._tipDisplay.x = _loc_4;
                this._tipDisplay.y = _loc_1.y;
                this._tipDisplay.visible = _loc_1.v && _loc_3 > _loc_1.w;
                this._tipDisplay["status_txt"].text = _loc_1.text == null ? ("") : (_loc_1.text);
                _loc_1 = this._skinMap.getValue("volumeBar");
                var _loc_4:* = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                _loc_1.x = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                this._volume_sld.x = _loc_4;
                this._volume_sld.y = _loc_1.y;
                this._volume_sld.visible = _loc_1.v && _loc_3 > _loc_1.w;
                this._volume_sld.enabled = _loc_1.e;
                _loc_1 = this._skinMap.getValue("fullScreenBtn");
                var _loc_4:* = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                _loc_1.x = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                this._fullScreen_btn.x = _loc_4;
                this._fullScreen_btn.y = _loc_1.y;
                this._fullScreen_btn.visible = _loc_1.v && _loc_3 > _loc_1.w;
                this._fullScreen_btn.enabled = _loc_1.e;
                _loc_1 = this._skinMap.getValue("normalScreenBtn");
                var _loc_4:* = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                _loc_1.x = _loc_1.x + (_loc_1.r ? (_loc_2) : (0));
                this._normalScreen_btn.x = _loc_4;
                this._normalScreen_btn.y = _loc_1.y;
                this._normalScreen_btn.visible = _loc_1.v && _loc_3 > _loc_1.w;
                this._normalScreen_btn.enabled = _loc_1.e;
            }
            return;
        }// end function

        protected function hideBar(param1) : void
        {
            var evt:* = param1;
            if (this._skin != null)
            {
                if (!this._ctrlBarBg_spr.hitTestPoint(stage.mouseX, stage.mouseY + 2))
                {
                    Mouse.hide();
                    this._hideTween = TweenLite.to(this._ctrlBar_c, 0.5, {y:this._height, ease:Quad.easeOut, onComplete:function () : void
            {
                _showBar_boo = false;
                return;
            }// end function
            });
                }
            }
            return;
        }// end function

        protected function showBar(event:MouseEvent) : void
        {
            if (this._skin != null)
            {
                this._timeout_to.restart();
                Mouse.show();
                if (!this._showBar_boo)
                {
                    this._showBar_boo = true;
                    this._showTween = TweenLite.to(this._ctrlBar_c, 0.5, {y:this._height - this._ctrlBarBg_spr.height, ease:Quad.easeOut});
                }
            }
            return;
        }// end function

        protected function startTween() : void
        {
            if (!this.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
                this.addEventListener(MouseEvent.MOUSE_MOVE, this.showBar);
                this._timeout_to.start();
            }
            return;
        }// end function

        protected function stopTween() : void
        {
            this._timeout_to.stop();
            this.removeEventListener(MouseEvent.MOUSE_MOVE, this.showBar);
            this._showBar_boo = false;
            Mouse.show();
            try
            {
                TweenLite.killTweensOf(this._ctrlBar_c);
            }
            catch (evt:Error)
            {
                trace("MediaPlayback stopTween");
            }
            return;
        }// end function

        protected function onPlay(event:Event) : void
        {
            var _loc_2:Boolean = false;
            this._skinMap.getValue("playBtn").e = false;
            this._skinMap.getValue("playBtn").v = _loc_2;
            var _loc_2:Boolean = true;
            this._skinMap.getValue("pauseBtn").e = true;
            this._skinMap.getValue("pauseBtn").v = _loc_2;
            var _loc_2:Boolean = false;
            this._skinMap.getValue("startPlayBtn").e = false;
            this._skinMap.getValue("startPlayBtn").v = _loc_2;
            this._skinMap.getValue("tipDisplay").text = "";
            this._skinMap.getValue("tipDisplay").v = false;
            this.setSkinState();
            return;
        }// end function

        protected function onPause(event:Event) : void
        {
            var _loc_2:Boolean = true;
            this._skinMap.getValue("playBtn").e = true;
            this._skinMap.getValue("playBtn").v = _loc_2;
            var _loc_2:Boolean = false;
            this._skinMap.getValue("pauseBtn").e = false;
            this._skinMap.getValue("pauseBtn").v = _loc_2;
            var _loc_2:Boolean = true;
            this._skinMap.getValue("startPlayBtn").e = true;
            this._skinMap.getValue("startPlayBtn").v = _loc_2;
            this._skinMap.getValue("tipDisplay").v = false;
            this._skinMap.getValue("tipDisplay").text = "";
            this.setSkinState();
            return;
        }// end function

        protected function onStop(param1 = "") : void
        {
            var _loc_2:Boolean = true;
            this._skinMap.getValue("playBtn").e = true;
            this._skinMap.getValue("playBtn").v = _loc_2;
            var _loc_2:Boolean = false;
            this._skinMap.getValue("pauseBtn").e = false;
            this._skinMap.getValue("pauseBtn").v = _loc_2;
            var _loc_2:Boolean = true;
            this._skinMap.getValue("startPlayBtn").e = true;
            this._skinMap.getValue("startPlayBtn").v = _loc_2;
            this._skinMap.getValue("tipDisplay").v = true;
            this.setSkinState();
            this.sysInit();
            return;
        }// end function

        protected function onStart(event:Event = null) : void
        {
            this._cover_c.visible = false;
            var _loc_2:* = stage.displayState;
            this._skinMap.getValue("progressBar").e = true;
            this._skinMap.getValue("volumeBar").e = true;
            this._skinMap.getValue("playBtn").e = true;
            this._skinMap.getValue("pauseBtn").e = true;
            this.setSkinState();
            return;
        }// end function

        protected function onPlayed(event:Event = null) : void
        {
            this._skinMap.getValue("tipDisplay").v = false;
            this.onStart();
            return;
        }// end function

        protected function bufferEmpty(event:Event) : void
        {
            return;
        }// end function

        protected function bufferFull(event:Event) : void
        {
            this._skinMap.getValue("tipDisplay").v = false;
            this._skinMap.getValue("tipDisplay").text = "";
            this.setSkinState();
            return;
        }// end function

        protected function dragStart(param1 = null) : void
        {
            this._skinMap.getValue("progressBar").e = false;
            this.setSkinState();
            return;
        }// end function

        protected function dragEnd(param1 = null) : void
        {
            this._skinMap.getValue("progressBar").e = true;
            this.setSkinState();
            return;
        }// end function

        protected function playProgress(param1) : void
        {
            this._skinMap.getValue("progressBar").totTime = param1.obj.totTime;
            if (this._skin != null)
            {
                if (!param1.obj.isSeek)
                {
                    this._progress_sld.topRate = param1.obj.nowTime / param1.obj.totTime;
                }
                this._timeDisplay["time_txt"].text = Utils.fomatTime(Math.round(param1.obj.nowTime)) + "/" + Utils.fomatTime(Math.floor(param1.obj.totTime));
            }
            return;
        }// end function

        protected function loadProgress(param1) : void
        {
            if (this._skin != null)
            {
                this._progress_sld.middleRate = param1.obj.nowSize / param1.obj.totSize;
            }
            return;
        }// end function

        protected function mediaNotfound(param1) : void
        {
            this._skinMap.getValue("tipDisplay").text = "";
            this._skinMap.getValue("tipDisplay").v = true;
            this.setSkinState();
            return;
        }// end function

        protected function mediaConnecting(param1) : void
        {
            return;
        }// end function

        protected function ctrlBarBgUp(event:MouseEvent) : void
        {
            return;
        }// end function

        public function get ctrlBarBg() : DisplayObject
        {
            return this._ctrlBarBg_spr;
        }// end function

        public function get isHide() : Boolean
        {
            return this._isHide;
        }// end function

        public function set isDrag(param1:Boolean) : void
        {
            this._isDrag = param1;
            if (this._skin != null)
            {
                this._progress_sld.isDrag = param1;
            }
            return;
        }// end function

        public function get core()
        {
            return this._core;
        }// end function

    }
}
