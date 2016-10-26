package com.sohu.tv.mediaplayer.video
{
    import com.sohu.tv.mediaplayer.ads.*;
    import ebing.core.*;
    import ebing.events.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.media.*;
    import flash.system.*;
    import flash.utils.*;

    public class TvSohuFlashCore extends FlashCore
    {
        private var _addChildId:Number = 0;
        private var _isVpaidAd:Boolean = false;
        private var _id:int = 0;
        private var _isPIPAd:Boolean = false;
        private var thirdAdsMark:String = "";
        private var _obj:Object;

        public function TvSohuFlashCore(param1:Object)
        {
            this._obj = param1;
            if (param1.index != null)
            {
                this._id = param1.index;
            }
            if (param1.isPIPAd != null)
            {
                this._isPIPAd = param1.isPIPAd;
            }
            if (param1.isThirdAds != null)
            {
                this.thirdAdsMark = param1.isThirdAds;
            }
            super(param1);
            return;
        }// end function

        override public function softInit(param1:Object) : void
        {
            this._isVpaidAd = false;
            if (param1.url.split("?path").length >= 2)
            {
                this._isVpaidAd = true;
            }
            super.softInit(param1);
            return;
        }// end function

        override protected function swfProgressHnadler(event:ProgressEvent) : void
        {
            super.swfProgressHnadler(event);
            return;
        }// end function

        override protected function swfHandler(param1:Object) : void
        {
            if (param1.info == "success")
            {
                _swf = param1.data;
                try
                {
                    var _loc_2:* = _swf.content;
                    _loc_2._swf.content["initData"](this._obj);
                }
                catch (evt)
                {
                }
                if (this._isPIPAd)
                {
                    addChild(_swf);
                    _bg_spr.visible = false;
                    _sysStatus_str = "4";
                    try
                    {
                        LogManager.msg("w666:" + _width_num + " h666:" + _height_num);
                        var _loc_2:* = _swf.content;
                        _loc_2._swf.content["resize"](_width_num, _height_num);
                    }
                    catch (e:Error)
                    {
                    }
                }
                else
                {
                    try
                    {
                        var _loc_2:* = _swf.content;
                        _loc_2._swf.content["init"](LogManager);
                    }
                    catch (e:Error)
                    {
                    }
                    LogManager.msg("w:" + _width_num + " h:" + _height_num);
                    dispatch(MediaEvent.START);
                }
            }
            else if (param1.info == "timeout")
            {
                dispatch(MediaEvent.CONNECT_TIMEOUT);
                _sysStatus_str = "5";
            }
            else
            {
                LogManager.msg("VPAIDDDDDDDDDDStatus:");
                dispatch(MediaEvent.NOTFOUND);
            }
            return;
        }// end function

        public function swfPause() : void
        {
            super.pause();
            return;
        }// end function

        public function swfStart() : void
        {
            super.play();
            if (_swf)
            {
                try
                {
                    var _loc_1:* = _swf.content;
                    _loc_1._swf.content["play"]();
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        public function swfStop() : void
        {
            if (_swf != null)
            {
                try
                {
                    _swf.unloadAndStop(true);
                    _swf = null;
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        public function loadSwf() : void
        {
            new LoaderUtil().load(_timeLimit, this.swfHandler, this.swfProgressHnadler, _url, new LoaderContext(this._isPIPAd));
            return;
        }// end function

        override public function play(param1 = null) : void
        {
            var evt:* = param1;
            if (_sysStatus_str == "5")
            {
                new LoaderUtil().load(_timeLimit, this.swfHandler, this.swfProgressHnadler, _url, new LoaderContext(this._isVpaidAd));
            }
            if (_sysStatus_str == "4")
            {
                this._addChildId = setInterval(function () : void
            {
                if (_swf != null)
                {
                    if (_isPIPAd)
                    {
                        var _loc_2:* = _swf.content;
                        _loc_2._swf.content["playMc"]();
                    }
                    else
                    {
                        addChild(_swf);
                    }
                    if (_swf)
                    {
                        try
                        {
                            var _loc_2:* = _swf.content;
                            _loc_2._swf.content["resize"](_width_num, _height_num);
                        }
                        catch (e:Error)
                        {
                            resize(_width_num, _height_num);
                        }
                        if (_isVpaidAd)
                        {
                            _swf.content.addEventListener("AD_ALL_OVER", closeFlash);
                        }
                        _swf.contentLoaderInfo.sharedEvents.addEventListener("allowDomain", function (event:Event) : void
                {
                    AdLog.msg("收到物料广播事件：allowDomain");
                    dispatchEvent(new MouseEvent("allowFlash"));
                    return;
                }// end function
                );
                        _swf.contentLoaderInfo.sharedEvents.addEventListener("closeFlash", closeFlash);
                        _swf.contentLoaderInfo.sharedEvents.addEventListener("ad_click", function (event:Event) : void
                {
                    AdLog.msg("收到物料广播事件：ad_click");
                    dispatchEvent(new MouseEvent("ad_click"));
                    return;
                }// end function
                );
                        _swf.contentLoaderInfo.sharedEvents.addEventListener("pauseFlash", function (event:Event) : void
                {
                    AdLog.msg("收到物料广播事件：pauseFlash");
                    dispatchEvent(new MouseEvent("pauseFlash"));
                    return;
                }// end function
                );
                        _swf.contentLoaderInfo.sharedEvents.addEventListener("resumeFlash", function (event:Event) : void
                {
                    AdLog.msg("收到物料广播事件：resumeFlash");
                    dispatchEvent(new MouseEvent("resumeFlash"));
                    return;
                }// end function
                );
                        try
                        {
                            _swf.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("callFlash"));
                            _swf.content.addEventListener(TvSohuAdsEvent.SWFAD_ERROR, swfad_error);
                        }
                        catch (e:Error)
                        {
                        }
                    }
                    _timer.start();
                    _getTime = getTimer();
                    clearInterval(_addChildId);
                }
                return;
            }// end function
            , 20);
            }
            _sysStatus_str = "3";
            dispatch(MediaEvent.PLAY);
            return;
        }// end function

        override public function resize(param1:Number, param2:Number) : void
        {
            var _loc_3:* = param1;
            _bg_spr.width = param1;
            _width_num = _loc_3;
            var _loc_3:* = param2;
            _bg_spr.height = param2;
            _height_num = _loc_3;
            if (this._isPIPAd)
            {
                _bg_spr.visible = false;
            }
            if (!this._isVpaidAd && !this._isPIPAd)
            {
                super.resize(param1, param2);
            }
            try
            {
                var _loc_3:* = _swf.content;
                _loc_3._swf.content["resize"](_width_num, _height_num);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        override public function pause(param1 = null) : void
        {
            super.pause();
            if (_swf)
            {
                try
                {
                    var _loc_2:* = _swf.content;
                    _loc_2._swf.content["pause"]();
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        override protected function aboutTime(param1:Number) : void
        {
            if (this.thirdAdsMark != "" && this.thirdAdsMark == "2")
            {
                if (_swf != null && _sysStatus_str == "3")
                {
                    var _loc_2:* = _swf.content;
                    var _loc_2:* = _swf.content;
                    LogManager.msg("VPAIDLOGS11---adRemainingTime:" + _loc_2._swf.content["adRemainingTime"]() + " adPlayedTime:" + _loc_2._swf.content["adPlayedTime"]());
                    var _loc_2:* = _swf.content;
                    var _loc_2:* = _swf.content;
                    if (_loc_2._swf.content["adRemainingTime"]() != undefined && _loc_2._swf.content["adRemainingTime"]() != null)
                    {
                        var _loc_2:* = _swf.content;
                        if (_loc_2._swf.content["adRemainingTime"]() >= 0)
                        {
                            var _loc_2:* = _swf.content;
                            LogManager.msg("VPAIDLOGS---adRemainingTime:" + _loc_2._swf.content["adRemainingTime"]());
                            var _loc_2:* = _swf.content;
                            _filePlayedTime = _fileTotTime - _loc_2._swf.content["adRemainingTime"]() * 1000;
                            LogManager.msg("VPAIDLOGS---_filePlayedTime:" + _filePlayedTime);
                            if (_filePlayedTime < 0)
                            {
                                LogManager.msg("我是大辉狼1");
                                dispatch(MediaEvent.PLAY_ABEND, {playedTime:_filePlayedTime / 1000, totTime:_fileTotTime / 1000});
                                this.stop("noevent");
                            }
                        }
                    }
                    else
                    {
                        var _loc_2:* = _swf.content;
                        if (_loc_2._swf.content["adPlayedTime"]() >= 0)
                        {
                            var _loc_2:* = _swf.content;
                            _filePlayedTime = _loc_2._swf.content["adPlayedTime"]() * 1000;
                        }
                    }
                    dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:_filePlayedTime / 1000, totTime:_fileTotTime / 1000});
                }
            }
            else
            {
                super.aboutTime(param1);
            }
            return;
        }// end function

        private function swfad_error(param1) : void
        {
            AdLog.msg("收到物料广播事件：SWFAD_ERROR");
            var _loc_2:* = new TvSohuAdsEvent(TvSohuAdsEvent.SWFAD_ERROR);
            _loc_2.obj = {errType:param1.obj.errType};
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function closeFlash(event:Event = null) : void
        {
            AdLog.msg("收到物料广播事件：closeFlash");
            dispatchEvent(new MouseEvent("closeFlash"));
            event.target.removeEventListener("closeFlash", this.closeFlash);
            this.stop();
            return;
        }// end function

        override public function stop(param1 = null) : void
        {
            var evt:* = param1;
            _timer.stop();
            _sysStatus_str = "5";
            if (evt != "noevent")
            {
                if (_finish_boo)
                {
                    dispatch(MediaEvent.STOP, {finish:true});
                    _finish_boo = false;
                }
                else
                {
                    dispatch(MediaEvent.STOP, {finish:false});
                }
                try
                {
                    _swf.contentLoaderInfo.sharedEvents.dispatchEvent(new Event("ad_closed"));
                }
                catch (e:Error)
                {
                }
            }
            if (_swf)
            {
                try
                {
                    var _loc_3:* = _swf.content;
                    _loc_3._swf.content["stopAd"]();
                    var _loc_3:* = _swf.content;
                    _loc_3._swf.content["stop"]();
                }
                catch (e:Error)
                {
                }
                _swf.contentLoaderInfo.sharedEvents.removeEventListener("allowDomain", function (event:Event) : void
            {
                dispatchEvent(new MouseEvent("allowFlash"));
                return;
            }// end function
            );
                _swf.contentLoaderInfo.sharedEvents.removeEventListener("closeFlash", this.closeFlash);
                _swf.contentLoaderInfo.sharedEvents.removeEventListener("ad_click", function (event:Event) : void
            {
                dispatchEvent(new MouseEvent("ad_click"));
                return;
            }// end function
            );
                _swf.contentLoaderInfo.sharedEvents.removeEventListener("pauseFlash", function (event:Event) : void
            {
                dispatchEvent(new MouseEvent("pauseFlash"));
                return;
            }// end function
            );
                _swf.contentLoaderInfo.sharedEvents.removeEventListener("resumeFlash", function (event:Event) : void
            {
                dispatchEvent(new MouseEvent("resumeFlash"));
                return;
            }// end function
            );
            }
            this.thirdAdsMark = "";
            return;
        }// end function

        public function get streamState() : String
        {
            var _loc_1:String = null;
            switch(_sysStatus_str)
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

        public function get swf() : Loader
        {
            return _swf;
        }// end function

        public function get id() : int
        {
            return this._id;
        }// end function

        override public function set volume(param1:Number) : void
        {
            super.volume = param1;
            if (_swf)
            {
                try
                {
                    _swf.content["soundTransform"] = new SoundTransform(param1, 0);
                    var _loc_2:* = _swf.content;
                    _loc_2._swf.content["setAdVolume"](param1);
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

    }
}
