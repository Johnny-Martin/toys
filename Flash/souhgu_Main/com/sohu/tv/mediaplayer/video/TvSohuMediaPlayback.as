package com.sohu.tv.mediaplayer.video
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.ads.*;
    import com.sohu.tv.mediaplayer.p2p.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import com.sohu.tv.mediaplayer.ui.*;
    import com.sohu.tv.mediaplayer.ui.events.*;
    import ebing.*;
    import ebing.controls.*;
    import ebing.events.*;
    import ebing.external.*;
    import ebing.media.mpb31.*;
    import ebing.net.*;
    import ebing.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class TvSohuMediaPlayback extends MediaPlayback
    {
        private var _selectorStartAdContainer:Sprite;
        private var _ctrlAdContainer:Sprite;
        private var _topAdContainer:Sprite;
        private var _bottomAdContainer:Sprite;
        private var _startAdContainer:Sprite;
        private var _topLogoAdContainer:Sprite;
        private var _logoAdContainer:Sprite;
        private var _pauseAdContainer:Sprite;
        private var _endAdContainer:Sprite;
        private var _middleAdContainer:Sprite;
        private var _adContainer:Sprite;
        private var _adContainerBg:Sprite;
        private var _sogouAdContainer:Sprite;
        protected var _titleText:TextField;
        protected var _topSideBar:Sprite;
        private var _topSideBarBg:Sprite;
        protected var _topPerSp:Sprite;
        protected var _rightSideBar:Sprite;
        private var _next_btn:ButtonUtil;
        private var _caption_btn:ButtonUtil;
        private var _share_btn:ButtonUtil;
        private var _download_btn:ButtonUtil;
        private var _miniWin_btn:ButtonUtil;
        private var _sharePanel:Object;
        private var _captionPanel:Object;
        private var _likePanel:Object;
        private var _highlightPanel:Object;
        private var _retryPanel:RetryPanel;
        private var _playHistoryPanel:Object;
        private var _transition_mc:MovieClip;
        private var _rightSideBarTimeout_to:Timeout;
        private var _normalScreen3_btn:ButtonUtil;
        private var _sogou_btn:ButtonUtil;
        protected var _tween:TweenLite;
        private var _preLoadPanel:Object;
        private var _isCinema:Boolean = false;
        private var _lightRate:Number = 0.5;
        private var _contrastRate:Number = 0.5;
        private var _saturationRate:Number = 0.5;
        private var _displayRate:Number = 1;
        private var _resetTimeLimit:Timeout;
        protected var _showBsbId:Number = 0;
        private var _showSetPId:Number = 0;
        private var _showSetPAutoId:Number = 0;
        private var _isPreLoadPanel:Boolean = false;
        private var _tipHistory:TipHistory;
        private var _lightBar:ButtonUtil;
        private var _lightSliderRate:Number = 0;
        private var _showBufferRate:Number = 0;
        private var _playedTime1:Number = 0;
        private var _playedTime30:Number = 0;
        private var _playedTime10:Number = 0;
        private var _playedTime3:Number = 0;
        private var _playedTime60:Number = 0;
        private var _playedTime4:Number = 0;
        private var _dfForPlayedTime60:Number = 0;
        private var _playedTime15For56:Number = 0;
        private var _tvSohuLogo_btn:ButtonUtil;
        private var _isFbChecked:Boolean = false;
        private var _videoInfoPanel:VideoInfoPanel;
        private var _settingPanel:Object;
        private var _sogouPanel:Object;
        private var _p2pLogPanel:Object;
        private var _mofunengPanel:Object;
        private var _softInitObj:Object;
        private var _rtmpeUrl:String;
        private var _onPuaeStatId:Number = 0;
        private var _firstPlay:Boolean = false;
        private var _captionBar:CaptionBar;
        private var _watermark_c:Sprite;
        private var _timer_c:Sprite;
        private var _rightBarBg:Sprite;
        private var _danmu:Object;
        private var _tmBarContainer:Sprite;
        private var _loadSkinRetryNum:uint = 3;
        private var _ttttt:TvSohuFMSCore;
        private var _ncConnectError:Boolean = false;
        private var _panelArr:Array;
        private var _filterArr:Array;
        private var _isJumpEndCaption:Boolean = true;
        private var _isJumpStartCaption:Boolean = true;
        private var _isViewTimer:Boolean = true;
        private var _searchBar:Object;
        private var _isCapDrag:Boolean = false;
        private var _firstSet:Boolean = true;
        private var _isFB:String = "";
        private var _showTipTimeout:Number = 0;
        private var _isFirstConnect:Boolean = true;
        private var _notify_buffer:uint = 0;
        private var _num:uint = 0;
        private var _playedTime:Number = 0;
        private var _bfTotNum:Array;
        private var _owner:TvSohuMediaPlayback;
        protected var _definitionBar:TvSohuMultiButton;
        protected var _replay_btn:ButtonUtil;
        private var _langSetBar:ButtonUtil;
        private var _turnOnWider_btn:ButtonUtil;
        private var _turnOffWider_btn:ButtonUtil;
        private var _albumBtn:TvSohuMultiButton;
        private var _playListPanel:Object;
        private var _isPlayListOk:Boolean = false;
        private var _barrageBtn:TvSohuButton;
        private var _broundPageCut:Object;
        private var _topPer50_btn:ButtonUtil;
        private var _topPer75_btn:ButtonUtil;
        private var _topPer100_btn:ButtonUtil;
        private var _isShowNextTitle:Boolean = false;
        private var _saveIsHide:Boolean = false;
        private var _mpbAutoPlay:Boolean = false;
        private var _flatWall3D:Object;
        private var streamState:String = "";
        private var startDragTime:uint = 0;
        protected var _definitionSlider:Object;
        private var _ctrlShow:Bitmap;
        private var slidePreviewTime:uint = 0;
        private var _more:Object;
        private var _liveCoreVersion:String = "";
        protected var _ctrlBtn_sp:Sprite;
        private var _isMyTvRotate:Boolean = false;
        private var _isMyTvDefinition:Boolean = false;
        private var _isShowPreview:Boolean = false;
        private var _func:Function;
        private var _cueTipPanel:Object;
        protected var _wmTipPanel:Object;
        private var _ugcAd:Object;
        private var _isShownLogoAd:Boolean = false;
        private var _isShownBottomAd:Boolean = false;
        private var _stage:Stage;
        private var _isSendDFS:Boolean = false;
        private var _tempDropFrames:uint = 0;
        private var _dropFramesArr:Array;
        private var _isLoadRecomm:Boolean = false;
        private var _isSwitchVideos:Boolean = false;
        private var _isEssenceTip:Boolean = false;
        private var _hisRecommend:Object;
        private var _hisRecommObj:Object;
        private var _isShownPauseAd:Boolean = true;
        private var _isEsc:Boolean = true;
        private var _isUncaught:Boolean = false;
        private var _uncaughtError:String = "";
        private var _dropFramesNum:Number = 0;
        private var _dfForLoadedNum:Number = 0;
        private var _dfForSo:SharedObject;
        private var _isSendDfForSo:Boolean = false;
        private var _addDropFramesNum:Number = 0;
        private var _isSvdUserTip:Boolean = false;
        private var _licenseText:TextField;
        private var _isLoadingDanmu:Boolean = false;
        private var _v360:Object;
        private var _v360Loading:Boolean = false;
        private var _danmuTimer:Timer;
        private var _v360Tnum:Number;
        private var _v360Id:Number = 0;
        private var _dummyPlayedTime:Number;
        private var _dummyTotTime:Number;
        private var _backGroudClearTime:int = 0;
        private var isCuting:Boolean = false;
        private static var singleton:TvSohuMediaPlayback;
        public static const HD_BUTTON_MOUSEUP:String = "hd_button_mouseup";
        public static const COMMON_BUTTON_MOUSEUP:String = "common_button_mouseup";
        public static const SUPER_BUTTON_MOUSEUP:String = "super_button_mouseup";
        public static const ORI_BUTTON_MOUSEUP:String = "ori_button_mouseup";
        public static const EXTREME_BUTTON_MOUSEUP:String = "extreme_button_mouseup";

        public function TvSohuMediaPlayback()
        {
            this._dropFramesArr = new Array();
            this._danmuTimer = new Timer(50);
            this._owner = this;
            return;
        }// end function

        override public function hardInit(param1:Object) : void
        {
            this._selectorStartAdContainer = param1.selectorStartAdContainer;
            this._startAdContainer = param1.startAdContainer;
            this._endAdContainer = param1.endAdContainer;
            this._middleAdContainer = param1.middleAdContainer;
            if (param1.stage != null)
            {
                this._stage = param1.stage;
            }
            super.hardInit(param1);
            return;
        }// end function

        override protected function sysInit(param1:String = null) : void
        {
            super.sysInit(param1);
            if (_skin != null)
            {
                this.playProgress({obj:{nowTime:0, totTime:PlayerConfig.totalDuration, isSeek:false}});
                var _loc_2:Boolean = false;
                this._albumBtn.visible = false;
                var _loc_2:* = _loc_2;
                this._albumBtn.enabled = _loc_2;
                var _loc_2:* = _loc_2;
                this._barrageBtn.enabled = _loc_2;
                var _loc_2:* = _loc_2;
                this._definitionBar.enabled = _loc_2;
                var _loc_2:* = _loc_2;
                this._langSetBar.enabled = _loc_2;
                this._lightBar.enabled = _loc_2;
                var _loc_2:Boolean = true;
                _skinMap.getValue("normalScreenBtn").e = true;
                _skinMap.getValue("fullScreenBtn").e = _loc_2;
                var _loc_2:Boolean = true;
                _normalScreen_btn.enabled = true;
                _fullScreen_btn.enabled = _loc_2;
            }
            return;
        }// end function

        override protected function coreHandler(param1:Object) : void
        {
            var index:int;
            var obj:* = param1;
            this._ctrlAdContainer = new Sprite();
            this._topAdContainer = new Sprite();
            this._bottomAdContainer = new Sprite();
            this._logoAdContainer = new Sprite();
            this._topLogoAdContainer = new Sprite();
            this._pauseAdContainer = new Sprite();
            this._adContainer = new Sprite();
            this._adContainerBg = new Sprite();
            this._sogouAdContainer = new Sprite();
            super.coreHandler(obj);
            if (obj.info == "success")
            {
                addChild(this._adContainer);
                index = this.getChildIndex(core) > 0 ? ((this.getChildIndex(core) - 1)) : (0);
                addChildAt(this._adContainerBg, index);
                this._adContainer.addChild(this._topLogoAdContainer);
                this._adContainer.addChild(this._topAdContainer);
                this._adContainer.addChild(this._endAdContainer);
                this._adContainer.addChild(this._middleAdContainer);
                this._adContainer.addChild(this._selectorStartAdContainer);
                this._adContainer.addChild(this._startAdContainer);
                this._adContainer.addChild(this._pauseAdContainer);
                TvSohuAds.getInstance().logoAd.container = this._logoAdContainer;
                TvSohuAds.getInstance().topLogoAd.container = this._topLogoAdContainer;
                TvSohuAds.getInstance().ctrlBarAd.container = this._ctrlAdContainer;
                TvSohuAds.getInstance().sogouAd.container = this._sogouAdContainer;
                TvSohuAds.getInstance().pauseAd.container = this._pauseAdContainer;
                TvSohuAds.getInstance().topAd.container = this._topAdContainer;
                TvSohuAds.getInstance().bottomAd.container = this._bottomAdContainer;
                TvSohuAds.getInstance().backgroudAd.container = this._adContainerBg;
                TvSohuAds.getInstance().endAd.container = this._endAdContainer;
                TvSohuAds.getInstance().middleAd.container = this._middleAdContainer;
                TvSohuAds.getInstance().pauseAd.addEventListener(TvSohuAdsEvent.PAUSESHOWN, this.pauseAdShown);
                TvSohuAds.getInstance().pauseAd.addEventListener(TvSohuAdsEvent.PAUSECLOSED, this.pauseAdClosed);
                TvSohuAds.getInstance().sogouAd.addEventListener(TvSohuAdsEvent.SOGOUSHOWN, this.sogouAdShown);
                TvSohuAds.getInstance().bottomAd.addEventListener(TvSohuAdsEvent.BOTTOMSHOWN, this.bottomAdShown);
                TvSohuAds.getInstance().bottomAd.addEventListener(TvSohuAdsEvent.BOTTOMHIDE, this.bottomAdHide);
                TvSohuAds.getInstance().topAd.addEventListener(TvSohuAdsEvent.TOPSHOWN, this.setAdsState);
                TvSohuAds.getInstance().ctrlBarAd.addEventListener(TvSohuAdsEvent.CTRLBARSHOWN, this.setAdsState);
                TvSohuAds.getInstance().startAd.addEventListener(TvSohuAdsEvent.SCREEN_PLAY_PROGRESS, this.adPlayProgress);
                TvSohuAds.getInstance().startAd.addEventListener("to_has_sound_icon", this.adsVolume);
                TvSohuAds.getInstance().startAd.addEventListener("to_no_sound_icon", this.adsMute);
                TvSohuAds.getInstance().startAd.addEventListener("openIFoxPanel", this.openIFoxPanel);
                TvSohuAds.getInstance().startAd.addEventListener(TvSohuAdsEvent.SCREENFINISH, this.screenAdFinish);
                TvSohuAds.getInstance().startAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN, this.startAdShown);
                TvSohuAds.getInstance().startAd.addEventListener(TvSohuAdsEvent.SCREEN_LOAD_FAILED, this.adsLoadFailed);
                TvSohuAds.getInstance().selectorStartAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN, this.selectAdShown);
                TvSohuAds.getInstance().selectorStartAd.addEventListener(TvSohuAdsEvent.SELECTOR_PLAY_PROGRESS, this.selectAdadPlayProgress);
                TvSohuAds.getInstance().selectorStartAd.addEventListener("to_has_sound_icon", this.selectorVolume);
                TvSohuAds.getInstance().selectorStartAd.addEventListener("to_no_sound_icon", this.selectorMute);
                TvSohuAds.getInstance().middleAd.addEventListener(TvSohuAdsEvent.MIDDLESHOWN, this.middleAdShown);
                TvSohuAds.getInstance().middleAd.addEventListener(TvSohuAdsEvent.MIDDLEFINISH, this.middleAdFinish);
                TvSohuAds.getInstance().middleAd.addEventListener(TvSohuAdsEvent.SCREEN_LOAD_FAILED, this.adsLoadFailed);
                TvSohuAds.getInstance().middleAd.addEventListener(TvSohuAdsEvent.SCREEN_PLAY_PROGRESS, this.adPlayProgress);
                TvSohuAds.getInstance().middleAd.addEventListener("to_has_sound_icon", this.adsVolume);
                TvSohuAds.getInstance().middleAd.addEventListener("to_no_sound_icon", this.adsMute);
                TvSohuAds.getInstance().endAd.addEventListener("to_has_sound_icon", this.adsVolume);
                TvSohuAds.getInstance().endAd.addEventListener("to_no_sound_icon", this.adsMute);
                TvSohuAds.getInstance().endAd.addEventListener(TvSohuAdsEvent.SCREEN_PLAY_PROGRESS, this.adPlayProgress);
                TvSohuAds.getInstance().endAd.addEventListener(TvSohuAdsEvent.ENDFINISH, this.endAdFinish);
                TvSohuAds.getInstance().endAd.addEventListener(TvSohuAdsEvent.SCREENSHOWN, this.endAdShown);
                TvSohuAds.getInstance().endAd.addEventListener(TvSohuAdsEvent.SCREEN_LOAD_FAILED, this.adsLoadFailed);
                TvSohuAds.getInstance().logoAd.addEventListener(TvSohuAdsEvent.LOGOSHOWN, this.logoAdShown);
                TvSohuAds.getInstance().logoAd.addEventListener(TvSohuAdsEvent.LOGOFINISH, this.logoAdFinish);
                TvSohuAds.getInstance().topLogoAd.addEventListener(TvSohuAdsEvent.LOGOSHOWN, this.setAdsState);
            }
            if (PlayerConfig.watermarkPath != "")
            {
                this._watermark_c = new Sprite();
                addChild(this._watermark_c);
                this._watermark_c.visible = false;
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:uint = 0;
                var _loc_3:uint = 0;
                if (param1.info == "success")
                {
                    _loc_2 = _watermark_c.numChildren;
                    _loc_3 = 0;
                    while (_loc_3 < _loc_2)
                    {
                        
                        _watermark_c.removeChildAt(_loc_3);
                        _loc_3 = _loc_3 + 1;
                    }
                    param1.data.content.smoothing = true;
                    _watermark_c.addChild(param1.data);
                }
                return;
            }// end function
            , null, PlayerConfig.watermarkPath, new LoaderContext(true));
            }
            return;
        }// end function

        private function setWatermark() : void
        {
            var _loc_1:Number = NaN;
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (this._watermark_c != null && this._watermark_c.width != 0 && this._watermark_c.height != 0 && _core.videoContainer.width != 0 && _core.videoContainer.height != 0)
            {
                _loc_1 = _core.videoContainer.width * 0.16;
                _loc_2 = _loc_1 / this._watermark_c.getChildAt(0)["contentLoaderInfo"].width;
                _loc_3 = this._watermark_c.getChildAt(0)["contentLoaderInfo"].height * _loc_2;
                _loc_4 = _loc_3 / this._watermark_c.getChildAt(0)["contentLoaderInfo"].height;
                if (_loc_3 / _core.videoContainer.height > 0.16)
                {
                    _loc_3 = _core.videoContainer.height * 0.16;
                    _loc_4 = _loc_3 / this._watermark_c.getChildAt(0)["contentLoaderInfo"].height;
                    _loc_1 = this._watermark_c.getChildAt(0)["contentLoaderInfo"].width * _loc_4;
                    _loc_2 = _loc_1 / this._watermark_c.getChildAt(0)["contentLoaderInfo"].width;
                }
                this._watermark_c.width = _loc_1;
                this._watermark_c.height = _loc_3;
                if (PlayerConfig.watermarkPos == "left-top")
                {
                    this._watermark_c.x = Math.round(_core.x + _core.videoContainer.x + _loc_2 * (PlayerConfig.vid == PlayerConfig.superVid ? (32) : (20)));
                    this._watermark_c.y = Math.round(_core.y + _core.videoContainer.y + _loc_4 * (PlayerConfig.vid == PlayerConfig.superVid ? (32) : (20)));
                }
                else if (PlayerConfig.watermarkPos == "right-top")
                {
                    this._watermark_c.x = Math.round(_core.x + _core.videoContainer.x + _core.videoContainer.width - (this._watermark_c.width + _loc_2 * (PlayerConfig.vid == PlayerConfig.superVid ? (32) : (20))));
                    this._watermark_c.y = Math.round(_core.y + _core.videoContainer.y + _loc_4 * (PlayerConfig.vid == PlayerConfig.superVid ? (32) : (20)));
                }
                else if (PlayerConfig.watermarkPos == "left-bottom")
                {
                    this._watermark_c.x = Math.round(_core.x + _core.videoContainer.x + _loc_2 * (PlayerConfig.vid == PlayerConfig.superVid ? (32) : (20)));
                    this._watermark_c.y = Math.round(_core.videoContainer.y + _core.videoContainer.height - this._watermark_c.height - _loc_4 * (PlayerConfig.vid == PlayerConfig.superVid ? (32) : (20)));
                }
                else if (PlayerConfig.watermarkPos == "right-bottom")
                {
                    this._watermark_c.x = Math.round(_core.x + _core.videoContainer.x + _core.videoContainer.width - (this._watermark_c.width + _loc_2 * (PlayerConfig.vid == PlayerConfig.superVid ? (32) : (20))));
                    this._watermark_c.y = Math.round(_core.videoContainer.y + _core.videoContainer.height - this._watermark_c.height - _loc_4 * (PlayerConfig.vid == PlayerConfig.superVid ? (32) : (20)));
                }
                this._watermark_c.visible = true;
            }
            return;
        }// end function

        public function setAdsState(event:TvSohuAdsEvent = null) : void
        {
            var _loc_7:Number = NaN;
            var _loc_2:Number = 0;
            var _loc_3:* = _core.width;
            var _loc_4:* = _core.height;
            var _loc_5:* = _core.videoContainer.width;
            var _loc_6:* = _core.videoContainer.height;
            TvSohuAds.getInstance().logoAd.setCoreValue(_loc_5);
            TvSohuAds.getInstance().logoAd.container.x = _core.videoContainer.x + _loc_5 - TvSohuAds.getInstance().logoAd.width - 5;
            TvSohuAds.getInstance().logoAd.container.y = _core.videoContainer.y + _loc_6 - TvSohuAds.getInstance().logoAd.height - 13;
            if (_skin != null)
            {
                if (TvSohuAds.getInstance().logoAd.container.y + TvSohuAds.getInstance().logoAd.height > stage.stageHeight - _ctrlBarBg_spr.height)
                {
                    TvSohuAds.getInstance().logoAd.container.y = stage.stageHeight - _ctrlBarBg_spr.height - TvSohuAds.getInstance().logoAd.height - _progress_sld["sliderDiffHeight"];
                }
            }
            if (PlayerConfig.vrModel == "1" || PlayerConfig.vrModel == "2")
            {
                TvSohuAds.getInstance().logoAd.container.x = _loc_3 - TvSohuAds.getInstance().logoAd.width - 5;
                TvSohuAds.getInstance().logoAd.container.y = _loc_4 - TvSohuAds.getInstance().logoAd.height - 13;
            }
            Utils.debug("vx:" + _core.videoContainer.x + " coreMetaWidth:" + _loc_5 + " logoAd.width:" + TvSohuAds.getInstance().logoAd.width);
            TvSohuAds.getInstance().logoAd.changeAd();
            TvSohuAds.getInstance().topLogoAd.container.x = _loc_3 - TvSohuAds.getInstance().topLogoAd.width - 6;
            if (stage.displayState == StageDisplayState.FULL_SCREEN || PlayerConfig.isBrowserFullScreen)
            {
                if (TvSohuAds.getInstance().topAd.hasAd)
                {
                    TvSohuAds.getInstance().topLogoAd.container.y = TvSohuAds.getInstance().topAd.container.height;
                }
                else
                {
                    TvSohuAds.getInstance().topLogoAd.container.y = 28;
                }
            }
            else
            {
                TvSohuAds.getInstance().topLogoAd.container.y = 6;
            }
            TvSohuAds.getInstance().topLogoAd.changeAd();
            TvSohuAds.getInstance().pauseAd.changeSize(_loc_3, _loc_4);
            TvSohuAds.getInstance().pauseAd.container.x = Math.round(_loc_3 / 2 - TvSohuAds.getInstance().pauseAd.width / 2);
            TvSohuAds.getInstance().pauseAd.container.y = Math.round(_loc_4 / 2 - TvSohuAds.getInstance().pauseAd.height / 2);
            if (TvSohuAds.getInstance().pauseAd.adAlign != "" && TvSohuAds.getInstance().pauseAd.adAlign == "d")
            {
                TvSohuAds.getInstance().pauseAd.container.y = _loc_4 - (TvSohuAds.getInstance().pauseAd.height + (_skin != null && stage.displayState == "fullScreen" ? (_ctrlBarBg_spr.height) : (0)));
            }
            TvSohuAds.getInstance().selectorStartAd.resize(_loc_3, _loc_4);
            TvSohuAds.getInstance().startAd.resize(_loc_3, _loc_4);
            TvSohuAds.getInstance().endAd.resize(_loc_3, _loc_4);
            TvSohuAds.getInstance().middleAd.resize(_loc_3, _loc_4);
            TvSohuAds.getInstance().sogouAd.resize(_loc_3, 0);
            TvSohuAds.getInstance().sogouAd.container.y = -TvSohuAds.getInstance().sogouAd.height;
            TvSohuAds.getInstance().bottomAd.resize(_loc_3, 0);
            TvSohuAds.getInstance().bottomAd.container.y = -TvSohuAds.getInstance().bottomAd.height - 13;
            TvSohuAds.getInstance().topAd.resize(_loc_3, 0);
            if (_skin != null)
            {
                if (TvSohuAds.getInstance().ctrlBarAd.hasAd && TvSohuAds.getInstance().ctrlBarAd.state == "no")
                {
                    TvSohuAds.getInstance().ctrlBarAd.play();
                }
                else
                {
                    TvSohuAds.getInstance().ctrlBarAd.pingback();
                }
                if (TvSohuAds.getInstance().ctrlBarAd.hasAd)
                {
                    TvSohuAds.getInstance().ctrlBarAd.changeAd();
                    _loc_7 = 0;
                    if (this._barrageBtn.visible)
                    {
                        _loc_7 = this._barrageBtn.x - (_timeDisplay.x + _timeDisplay.width);
                    }
                    else
                    {
                        _loc_7 = _volume_sld.x - (_timeDisplay.x + _timeDisplay.width);
                    }
                    if (_ctrlBarBg_spr.height > 20)
                    {
                        if (_loc_7 < TvSohuAds.getInstance().ctrlBarAd.metaWidth)
                        {
                            TvSohuAds.getInstance().ctrlBarAd.width = _loc_7;
                            TvSohuAds.getInstance().ctrlBarAd.normalAd_c.width = TvSohuAds.getInstance().ctrlBarAd.width;
                            TvSohuAds.getInstance().ctrlBarAd.normalAd_c.height = TvSohuAds.getInstance().ctrlBarAd.height;
                            if (_loc_7 < 160)
                            {
                                TvSohuAds.getInstance().ctrlBarAd.container.visible = false;
                                TvSohuAds.getInstance().ctrlBarAd.container.alpha = 0;
                            }
                            else
                            {
                                TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
                                TvSohuAds.getInstance().ctrlBarAd.container.alpha = 1;
                            }
                        }
                        else
                        {
                            TvSohuAds.getInstance().ctrlBarAd.width = TvSohuAds.getInstance().ctrlBarAd.metaWidth;
                            TvSohuAds.getInstance().ctrlBarAd.normalAd_c.width = TvSohuAds.getInstance().ctrlBarAd.width;
                            TvSohuAds.getInstance().ctrlBarAd.normalAd_c.height = TvSohuAds.getInstance().ctrlBarAd.height;
                            TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
                            TvSohuAds.getInstance().ctrlBarAd.container.alpha = 1;
                        }
                    }
                    else
                    {
                        TvSohuAds.getInstance().ctrlBarAd.container.visible = false;
                        TvSohuAds.getInstance().ctrlBarAd.container.alpha = 0;
                    }
                    TvSohuAds.getInstance().ctrlBarAd.container.x = Math.round(_timeDisplay.x + _timeDisplay.width + _loc_7 / 2 - TvSohuAds.getInstance().ctrlBarAd.width / 2);
                    TvSohuAds.getInstance().ctrlBarAd.container.y = _skinMap.getValue("ctrlBarAd").y;
                }
            }
            return;
        }// end function

        private function selectAdadPlayProgress(event:TvSohuAdsEvent) : void
        {
            try
            {
                _volume_sld.rate = event.target.volume;
            }
            catch (e:Error)
            {
            }
            if (_skin != null)
            {
                if (this._playListPanel != null && this._isPlayListOk && this._playListPanel.sourceLength() > 1)
                {
                    this._albumBtn.visible = _skinMap.getValue("albumBtn").v && _ctrlBarBg_spr.width > _skinMap.getValue("albumBtn").w;
                    if (this._albumBtn.btnVisNum == 1)
                    {
                        this._albumBtn.enabled = this._playListPanel.hasNext();
                    }
                    else
                    {
                        this._albumBtn.enabled = true;
                    }
                    _skinMap.getValue("nextBtn").e = this._playListPanel.hasNext();
                }
            }
            return;
        }// end function

        private function selectAdShown(event:TvSohuAdsEvent) : void
        {
            this.setSkinState();
            return;
        }// end function

        private function startAdShown(event:TvSohuAdsEvent) : void
        {
            if (this._playListPanel != null && this._playListPanel.isOpen)
            {
                this._playListPanel.close();
            }
            if (this._settingPanel != null && this._settingPanel.visible)
            {
                this._settingPanel.close();
            }
            this.setSkinState();
            return;
        }// end function

        private function middleAdShown(event:TvSohuAdsEvent) : void
        {
            _core.pause(0);
            this.setAdsState();
            if (this._playListPanel != null && this._playListPanel.isOpen)
            {
                this._playListPanel.close();
            }
            if (this._settingPanel != null && this._settingPanel.visible)
            {
                this._settingPanel.close();
            }
            this.setSkinState();
            if (Eif.available && PlayerConfig.onMAdShown != "")
            {
                LogManager.msg("展示中插广告回调js方法：:" + PlayerConfig.onMAdShown);
                ExternalInterface.call(PlayerConfig.onMAdShown);
            }
            return;
        }// end function

        private function middleAdFinish(event:TvSohuAdsEvent) : void
        {
            PlayerConfig.advolume = null;
            _core.play();
            _volume_sld.rate = _core.volume;
            if (TvSohuAds.getInstance().ctrlBarAd.hasAd)
            {
                TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
                TvSohuAds.getInstance().ctrlBarAd.container.alpha = 1;
            }
            this.setSkinState();
            if (Eif.available && PlayerConfig.onMAdFinish != "")
            {
                LogManager.msg("中插广告播放结束回调js方法：:" + PlayerConfig.onMAdFinish);
                ExternalInterface.call(PlayerConfig.onMAdFinish);
            }
            return;
        }// end function

        private function logoAdShown(event:TvSohuAdsEvent) : void
        {
            this._isShownLogoAd = true;
            if (this._cueTipPanel != null)
            {
                this._cueTipPanel.visible = false;
            }
            this.setSkinState();
            return;
        }// end function

        private function logoAdFinish(event:TvSohuAdsEvent) : void
        {
            this._isShownLogoAd = false;
            if (this._cueTipPanel != null)
            {
                this._cueTipPanel.visible = true;
            }
            this.setSkinState();
            return;
        }// end function

        private function endAdShown(event:TvSohuAdsEvent) : void
        {
            if (this._playListPanel != null && this._playListPanel.isOpen)
            {
                this._playListPanel.close();
            }
            if (this._settingPanel != null && this._settingPanel.visible)
            {
                this._settingPanel.close();
            }
            this.setSkinState();
            return;
        }// end function

        protected function endAdFinish(event:TvSohuAdsEvent) : void
        {
            PlayerConfig.advolume = null;
            _volume_sld.rate = _core.volume;
            if (TvSohuAds.getInstance().ctrlBarAd.hasAd)
            {
                TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
                TvSohuAds.getInstance().ctrlBarAd.container.alpha = 1;
            }
            this.sysInit();
            return;
        }// end function

        override protected function dragStart(param1 = null) : void
        {
            super.dragStart(param1);
            return;
        }// end function

        override protected function dragEnd(param1 = null) : void
        {
            super.dragEnd(param1);
            return;
        }// end function

        private function screenAdFinish(event:TvSohuAdsEvent) : void
        {
            if (_skin != null)
            {
                PlayerConfig.advolume = null;
                _volume_sld.rate = _core.volume;
                if (TvSohuAds.getInstance().ctrlBarAd.hasAd)
                {
                    TvSohuAds.getInstance().ctrlBarAd.container.visible = true;
                    TvSohuAds.getInstance().ctrlBarAd.container.alpha = 1;
                }
                this.setSkinState();
            }
            return;
        }// end function

        private function adsLoadFailed(event:TvSohuAdsEvent) : void
        {
            if (_skin != null)
            {
                PlayerConfig.advolume = null;
                _volume_sld.rate = _core.volume;
            }
            return;
        }// end function

        private function adsVolume(event:Event) : void
        {
            event.target.volume = 0.5;
            if (_skin != null)
            {
                _volume_sld.rate = 0.5;
                this.setSkinState();
            }
            return;
        }// end function

        private function adsMute(event:Event) : void
        {
            event.target.volume = 0;
            if (_skin != null)
            {
                _volume_sld.rate = 0;
                this.setSkinState();
            }
            return;
        }// end function

        private function selectorVolume(event:Event) : void
        {
            event.target.volume = 0.5;
            TvSohuAds.getInstance().startAd.volume = 0.5;
            if (_skin != null)
            {
                _volume_sld.rate = 0.5;
                this.setSkinState();
            }
            return;
        }// end function

        private function selectorMute(event:Event) : void
        {
            event.target.volume = 0;
            TvSohuAds.getInstance().startAd.volume = 0;
            if (_skin != null)
            {
                _volume_sld.rate = 0;
                this.setSkinState();
            }
            return;
        }// end function

        private function openIFoxPanel(event:Event) : void
        {
            if (_skin != null && stage.displayState == "fullScreen")
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            return;
        }// end function

        override protected function onPlayed(event:Event = null) : void
        {
            var jsVideoInfo:Object;
            var so:SharedObject;
            var evt:* = event;
            super.onPlayed(evt);
            if (_skin != null)
            {
                if (PlayerConfig.isSogouAd && !this._tipHistory.isSogouAdTip)
                {
                    this._tipHistory.showSogouAdTip();
                }
                else if (PlayerConfig.h2644kVid == PlayerConfig.currentVid && !this._tipHistory.isExtremeTip && !PlayerConfig.is56)
                {
                    this._tipHistory.showExtremeTip();
                }
                else if (PlayerConfig.isUgcFeeVideo && !PlayerConfig.isUgcPreview && !this._tipHistory.isUgcFeeVideoTip && !PlayerConfig.isMyselfUgcVideo)
                {
                    this._tipHistory.showUgcFeeVideoTip();
                }
                else
                {
                    this._tipHistory.checkAndTip();
                }
            }
            if (this._timer_c.numChildren == 0)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:* = undefined;
                if (param1.info == "success")
                {
                    _loc_2 = param1.data;
                    _loc_2.name = "timeMc";
                    _timer_c.addChild(_loc_2);
                    setSkinState();
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "other/time.swf");
            }
            if (PlayerConfig.cueTipEpInfo != null && PlayerConfig.cueTipEpInfo.length >= 1)
            {
                this.showCueTip();
            }
            if (PlayerConfig.cooperator == "MofunEnglish")
            {
                this.showMofunEnglishPanel();
            }
            if (PlayerConfig.wmDataInfo != null && PlayerConfig.isWmVideo || PlayerConfig.isai != "" && PlayerConfig.isai == "1")
            {
                if (Eif.available)
                {
                    jsVideoInfo = this.getJSVarObj("_videoInfo");
                    PlayerConfig.visitorId = jsVideoInfo != null && jsVideoInfo.visitor_id != null && jsVideoInfo.visitor_id != "" && jsVideoInfo.visitor_id != "0" ? (jsVideoInfo.visitor_id) : ("");
                }
                if (PlayerConfig.showPgcModule)
                {
                    this.showWmTip();
                }
            }
            if (Utils.getBrowserCookie("fee_channel") == "3")
            {
                new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                if (param1.info == "success")
                {
                    _loc_2 = new JSON().parse(param1.data);
                    ;
                }
                return;
            }// end function
            , "http://store.tv.sohu.com/web/speed/tvSpeed.do?nt=" + PlayerConfig.isp);
            }
            if (!TvSohuAds.getInstance().bottomAd.hasAd && !PlayerConfig.is56 && PlayerConfig.showUgcAd)
            {
                so = SharedObject.getLocal("ugcAdMark", "/");
                if (so.data.ts != undefined && so.data.ts != "")
                {
                    LogManager.msg("flashcookie里的ugcAdMark记录的so.data.ts：" + so.data.ts);
                    if (new Date().getTime() - so.data.ts >= 30 * 60 * 1000)
                    {
                        this.showUgcAd();
                    }
                }
                else
                {
                    LogManager.msg("没有记录flashcookie");
                    this.showUgcAd();
                }
            }
            this.gotoShowTanmu();
            return;
        }// end function

        public function gotoShowTanmu() : void
        {
            if (PlayerConfig.isShowTanmu)
            {
                this.showTanmu();
            }
            return;
        }// end function

        private function showTanmu() : void
        {
            var context:LoaderContext;
            var vid:String;
            if (this._danmu != null)
            {
                LogManager.msg("已经存在弹幕组件");
                if (PlayerConfig.vrModel == "1" || PlayerConfig.vrModel == "2")
                {
                    this._owner.setChildIndex(this._danmu, this._owner.getChildIndex(_hitArea_spr) + 2);
                    this._owner.setChildIndex(this._rightSideBar, this._owner.getChildIndex(_hitArea_spr) + 3);
                }
                else
                {
                    this._owner.setChildIndex(this._danmu, (this._owner.getChildIndex(_hitArea_spr) + 1));
                    this._owner.setChildIndex(this._rightSideBar, this._owner.getChildIndex(_hitArea_spr) + 2);
                }
                if (PlayerConfig.allTimeLogo)
                {
                    this._owner.setChildIndex(this._logoAdContainer, this._owner.getChildIndex(this._danmu));
                }
                else
                {
                    this._owner.setChildIndex(this._logoAdContainer, this._owner.getChildIndex(this._rightSideBar));
                }
                return;
            }
            else if (!this._isLoadingDanmu)
            {
                this._isLoadingDanmu = true;
                LogManager.msg("加载弹幕组件");
                context = new LoaderContext();
                context.securityDomain = SecurityDomain.currentDomain;
                context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                vid = PlayerConfig.hdVid != "" ? (PlayerConfig.hdVid) : (PlayerConfig.vid);
                vid = vid.split("_")[0];
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    _danmu = param1.data.content;
                    if (_hitArea_spr != null)
                    {
                        if (PlayerConfig.vrModel == "1" || PlayerConfig.vrModel == "2")
                        {
                            _owner.addChildAt(_danmu, _owner.getChildIndex(_hitArea_spr) + 2);
                        }
                        else
                        {
                            _owner.addChildAt(_danmu, (_owner.getChildIndex(_hitArea_spr) + 1));
                        }
                        if (PlayerConfig.allTimeLogo)
                        {
                            _owner.setChildIndex(_logoAdContainer, _owner.getChildIndex(_danmu));
                        }
                    }
                    else
                    {
                        _owner.addChildAt(_danmu, (_owner.getChildIndex(_core) + 1));
                    }
                    _danmu.init(_core.width, _core.height, vid, PlayerConfig.isMyTvVideo ? ("sohu_ugc_player") : ("sohu_vrs_player"), 3, PlayerConfig.danmuDefaultStatus == "2" ? (true) : (false), PlayerConfig.vrsPlayListId != "" ? (PlayerConfig.vrsPlayListId) : (PlayerConfig.pid), PlayerConfig.passportUID, PlayerConfig.isMyTvVideo ? (PlayerConfig.myTvUserId) : (""), PlayerConfig.totalDuration, "m", 170, PlayerConfig.otherInforSender == "change" || PlayerConfig.otherInforSender == "restart" ? (true) : (false), PlayerConfig.uuid, Number(PlayerConfig.firstReqTanmuTime), TvSohuAds.getInstance().fetchAdsUrl, PlayerConfig.isSohuDomain, PlayerConfig.topBarNor);
                    _danmu.addEventListener("__onTmDataGet", onTmDataComplete);
                    _danmu.addEventListener("__onTmDataErr", onTmDataFailHandler);
                    _danmu.addEventListener("__onTmNoData", onTmDataFailHandler);
                    _danmu.addEventListener("__onTmDataFailed", onTmDataFailHandler);
                    _danmu.addEventListener("__onTmAdClick", onTmAdClickHandler);
                    setSkinState();
                    _danmu.play();
                    ;
                }
                _isLoadingDanmu = false;
                return;
            }// end function
            , null, PlayerConfig.TANMU_SWF_URL, context);
            }
            return;
        }// end function

        private function onTmDataComplete(param1) : void
        {
            LogManager.msg("TTTTTTYYYYYYYUUUUUUUUUUUUUUUUUUUU:" + param1["data"]);
            return;
        }// end function

        private function onTmAdClickHandler(param1) : void
        {
            if (_skin != null && stage.displayState == "fullScreen")
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            return;
        }// end function

        private function onTmDataFailHandler(param1) : void
        {
            LogManager.msg("UUUUUUUUUUUUUUUUUUUUvalue:" + param1.data.value + " text:" + param1.data.text);
            return;
        }// end function

        override protected function volumeSlideEnd(param1:SliderEventUtil) : void
        {
            if (TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing")
            {
                TvSohuAds.getInstance().startAd.saveVolume();
            }
            else if (TvSohuAds.getInstance().endAd.hasAd && TvSohuAds.getInstance().endAd.state == "playing")
            {
                TvSohuAds.getInstance().endAd.saveVolume();
            }
            else if (TvSohuAds.getInstance().middleAd.hasAd && TvSohuAds.getInstance().middleAd.state == "playing")
            {
                TvSohuAds.getInstance().middleAd.saveVolume();
            }
            else
            {
                _core.saveVolume();
            }
            return;
        }// end function

        override protected function volumeSlide(param1:SliderEventUtil) : void
        {
            if (TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing")
            {
                TvSohuAds.getInstance().startAd.volume = param1.obj.rate;
            }
            else if (TvSohuAds.getInstance().endAd.hasAd && TvSohuAds.getInstance().endAd.state == "playing")
            {
                TvSohuAds.getInstance().endAd.volume = param1.obj.rate;
            }
            else if (TvSohuAds.getInstance().middleAd.hasAd && TvSohuAds.getInstance().middleAd.state == "playing")
            {
                TvSohuAds.getInstance().middleAd.volume = param1.obj.rate;
            }
            else if (TvSohuAds.getInstance().selectorStartAd.hasAd && TvSohuAds.getInstance().selectorStartAd.state == "playing")
            {
                TvSohuAds.getInstance().selectorStartAd.volume = param1.obj.rate;
            }
            else
            {
                _core.volume = param1.obj.rate;
            }
            return;
        }// end function

        override protected function loadCore() : void
        {
            var ele:Object;
            var gslbUrl:String;
            ele;
            if (PlayerConfig.isFms)
            {
                gslbUrl = "http://" + PlayerConfig.gslbIp + "/fms?t=" + Math.random();
                LogManager.msg("开始请求FMS调度url:" + gslbUrl);
                new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:String = null;
                var _loc_3:String = null;
                var _loc_4:Array = null;
                if (param1.info == "success")
                {
                    LogManager.msg("FMS调度成功:" + param1.data);
                    _loc_2 = param1.data;
                    _loc_3 = "";
                    _loc_4 = _loc_2.split("|");
                    _loc_3 = _loc_4[0];
                    if (!PlayerConfig.isLive)
                    {
                        _loc_3 = _loc_3.substring(0, (_loc_3.length - 1));
                    }
                    PlayerConfig.cdnIp = _loc_4[0];
                    PlayerConfig.cdnId = _loc_4[1];
                    PlayerConfig.clientIp = _loc_4[2];
                }
                else
                {
                    LogManager.msg("FMS调度失败，失败原因:" + param1.info + " 超时时限：" + param1.target.timeLimit + " FMS连接地址使用：rtmpe://stream.vod.itc.cn");
                    var _loc_5:* = PlayerConfig;
                    var _loc_6:* = PlayerConfig.all700ErrNo + 1;
                    _loc_5.all700ErrNo = _loc_6;
                    if (param1.info == "ioError")
                    {
                        ErrorSenderPQ.getInstance().sendPQStat({error:PlayerConfig.GSLB_ERROR_FAILED, code:PlayerConfig.GSLB_CODE, split:0, dom:gslbUrl, drag:-1, allno:1, all700no:PlayerConfig.all700ErrNo, errno:1, datarate:0});
                    }
                    else if (param1.info == "timeout")
                    {
                        ErrorSenderPQ.getInstance().sendPQStat({error:PlayerConfig.GSLB_ERROR_TIMEOUT, code:PlayerConfig.GSLB_CODE, split:0, dom:gslbUrl, drag:-1, allno:1, all700no:PlayerConfig.all700ErrNo, errno:1, datarate:0});
                    }
                    _loc_3 = "rtmpe://stream.vod.itc.cn";
                }
                if (_loc_3 != "" && _loc_3 != null)
                {
                    ele.doInit = false;
                    ele.rtmpeUrl = _loc_3 + (PlayerConfig.isLive ? ("/live") : (":80/vod/"));
                    _rtmpeUrl = ele.rtmpeUrl;
                    ele.hardInitHandler = onCoreHardInit;
                    _ttttt = new TvSohuFMSCore(ele);
                    PlayerConfig.currentCore = "TvSohuFMSCore";
                    _ttttt.addEventListener(MediaEvent.NC_RETRY_FAILED, ncRetryFailed);
                    _ttttt.hardInit(ele);
                }
                else
                {
                    LogManager.msg("FMS服务器IP异常：" + _loc_3);
                }
                return;
            }// end function
            , gslbUrl);
            }
            else if (PlayerConfig.isAlbumVideo)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:* = undefined;
                if (param1.info == "success")
                {
                    LogManager.msg("*****************AlbumCore加载成功:");
                    _loc_2 = param1.data.content;
                    _loc_2.initData(Model.getInstance().videoInfo.data);
                    coreHandler({info:"success", data:{content:_loc_2}});
                }
                else
                {
                    LogManager.msg("AlbumCore加载失败");
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "otherCore/AlbumCore.swf");
            }
            else if (PlayerConfig.isLive)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var liveCore:*;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    LogManager.msg("LiveCore加载成功:");
                    liveCore = obj.data.content;
                    if (!PlayerConfig.isP2PLive)
                    {
                        liveCore.initP2P(function () : void
                {
                    liveCore.init({buffer:3, width:1, height:1, isWriteLog:true});
                    coreHandler({info:"success", data:{content:liveCore}});
                    return;
                }// end function
                );
                    }
                    else
                    {
                        liveCore.init({buffer:3, width:1, height:1, isWriteLog:true});
                        coreHandler({info:"success", data:{content:liveCore}});
                    }
                    try
                    {
                        if (liveCore.PLCoreVersion != null && liveCore.PLCoreVersion != "")
                        {
                            _liveCoreVersion = liveCore.PLCoreVersion;
                            LogManager.msg("PLCoreVersion:" + _liveCoreVersion);
                            dispatchEvent(new Event("liveCoreVer"));
                        }
                    }
                    catch (evt)
                    {
                    }
                }
                else
                {
                    LogManager.msg("LiveCore加载失败");
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "otherCore/PLVideoCore.swf");
            }
            else
            {
                ele.doInit = true;
                ele.isWriteLog = true;
                PlayerConfig.currentCore = "TvSohuVideoCore";
                this.coreHandler({info:"success", data:{content:new TvSohuVideoCore(ele)}});
            }
            return;
        }// end function

        override protected function coreLoadSuccess() : void
        {
            if (_core != null)
            {
                addChild(_core);
            }
            if (_cover_c == null)
            {
                _cover_c = new Sprite();
                var _loc_1:int = 0;
                _core.y = 0;
                _core.x = _loc_1;
                addChild(_cover_c);
            }
            this.loadSkin();
            return;
        }// end function

        private function onCoreHardInit(param1:Object) : void
        {
            if (param1.info == "success")
            {
                this.coreHandler({info:"success", data:{content:this._ttttt}});
            }
            else if (param1.info == "timeout")
            {
            }
            return;
        }// end function

        override public function softInit(param1:Object) : void
        {
            this._softInitObj = param1;
            var _loc_2:* = param1.filePath;
            var _loc_3:* = param1.fileTime;
            var _loc_4:* = param1.fileSize;
            var _loc_5:* = param1.is200;
            _isDrag = param1.isDrag;
            _coverImgPath = param1.cover;
            this._isPreLoadPanel = false;
            if (_skin != null)
            {
                _progress_sld.isDrag = _isDrag;
            }
            _core.initMedia({size:_loc_4, time:_loc_3, flv:_loc_2, isDrag:_isDrag, is200:_loc_5});
            if (PlayerConfig.myTvRotate != 0 && !this._isMyTvRotate)
            {
                _core.setR(PlayerConfig.myTvRotate);
                this._isMyTvRotate = true;
            }
            else if (PlayerConfig.myTvRotate == 0 && this._isMyTvRotate)
            {
                _core.setR(0);
                this._isMyTvRotate = false;
            }
            if (PlayerConfig.myTvDefinition != "" && PlayerConfig.myTvDefinition == "16:9" && !this._isMyTvDefinition)
            {
                _core.displayTo16_9();
                this._isMyTvDefinition = true;
            }
            else if (PlayerConfig.myTvDefinition != "" && PlayerConfig.myTvDefinition == "4:3")
            {
                _core.displayTo4_3();
                this._isMyTvDefinition = true;
            }
            else if (PlayerConfig.myTvDefinition == "" && this._isMyTvDefinition)
            {
                _core.displayToMeta();
                this._isMyTvDefinition = false;
            }
            var _loc_6:int = 0;
            this._playedTime15For56 = 0;
            var _loc_6:* = _loc_6;
            this._dfForPlayedTime60 = _loc_6;
            var _loc_6:* = _loc_6;
            this._playedTime10 = _loc_6;
            var _loc_6:* = _loc_6;
            this._playedTime60 = _loc_6;
            var _loc_6:* = _loc_6;
            this._playedTime4 = _loc_6;
            var _loc_6:* = _loc_6;
            this._playedTime3 = _loc_6;
            var _loc_6:* = _loc_6;
            this._playedTime30 = _loc_6;
            this._playedTime1 = _loc_6;
            this._dropFramesArr = [];
            var _loc_6:Boolean = false;
            this._isShownBottomAd = false;
            this._isShownLogoAd = _loc_6;
            this._isShownPauseAd = true;
            var _loc_6:Boolean = false;
            this._isLoadingDanmu = false;
            var _loc_6:* = _loc_6;
            this._isSvdUserTip = _loc_6;
            var _loc_6:* = _loc_6;
            this._isSendDfForSo = _loc_6;
            var _loc_6:* = _loc_6;
            this._isUncaught = _loc_6;
            var _loc_6:* = _loc_6;
            this._isEssenceTip = _loc_6;
            this._isSendDFS = _loc_6;
            this._tempDropFrames = 0;
            this._dropFramesNum = 0;
            this._dfForLoadedNum = 0;
            this._addDropFramesNum = 0;
            this._uncaughtError = "";
            return;
        }// end function

        private function playOrPause(event:Event) : void
        {
            var evt:* = event;
            if (_core.streamState == "stop")
            {
                _startPlay_btn.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
            }
            else if (!PlayerConfig.autoPlay && TvSohuAds.getInstance().startAd.hasAd && !TvSohuAds.getInstance().startAd.isAutoPlayAd && !this._mpbAutoPlay && TvSohuAds.getInstance().startAd.state == "no")
            {
                TvSohuAds.getInstance().startAd.play();
                dispatchEvent(new Event("ChangeAutoPlay"));
                this._mpbAutoPlay = true;
            }
            else
            {
                if (_core.streamState == "pause")
                {
                    SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_Play&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                }
                else if (_core.streamState == "play")
                {
                    SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_Pause&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                }
                _core.playOrPause(evt);
            }
            if (PlayerConfig.isJump && PlayerConfig.apiKey == "" && _core.streamState == "pause")
            {
                try
                {
                    if (!PlayerConfig.isPartner)
                    {
                        if (PlayerConfig.filePrimaryReferer != null && PlayerConfig.filePrimaryReferer != "")
                        {
                            Utils.openWindow(PlayerConfig.filePrimaryReferer);
                        }
                        SendRef.getInstance().sendPQVPC("PL_S_GotoTV");
                    }
                }
                catch (evt:SecurityError)
                {
                }
            }
            return;
        }// end function

        override protected function addEvent() : void
        {
            super.addEvent();
            _core.addEventListener(MediaEvent.RETRY_FAILED, this.fileRetryFailed);
            _core.addEventListener("NS.Play.Start", function (event:Event) : void
            {
                if (_core.videoArr[_core.downloadIndex].ns.hasP2P)
                {
                    checkXXX();
                }
                return;
            }// end function
            );
            this._replay_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.replay);
            this._next_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.nextClickHandler);
            this._share_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.sharePanel);
            this._download_btn.addEventListener(MouseEvent.MOUSE_UP, this.downloadVideo);
            this._miniWin_btn.addEventListener(MouseEventUtil.CLICK, this.miniWinMouseClick);
            this._sogou_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.showSogouPanel);
            this._turnOnWider_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.cinemaMouseClick);
            this._turnOffWider_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.windowMouseClick);
            this._rightSideBarTimeout_to.addEventListener(Timeout.TIMEOUT, this.hideSideBar);
            this._caption_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.showCaptionPanel);
            stage.addEventListener(MouseEvent.MOUSE_OUT, this.onStageMouseOut);
            this._resetTimeLimit.addEventListener(Timeout.TIMEOUT, this.resetBuffNum);
            _progress_sld.addEventListener(SliderEventUtil.SLIDER_PREVIEW_RATE, this.progressSlidePreview);
            if (this._captionBar != null)
            {
                this._captionBar.addEventListener(MouseEvent.MOUSE_OVER, this.capBarMouseOver);
                this._captionBar.addEventListener(MouseEvent.MOUSE_OUT, this.capBarMouseOut);
                this._captionBar.addEventListener(MouseEvent.MOUSE_DOWN, this.capBarMouseDown);
                this._captionBar.addEventListener(MouseEvent.MOUSE_UP, this.capBarMouseUp);
            }
            _progress_sld.addEventListener("forward", this.forward);
            _progress_sld.addEventListener("backward", this.backward);
            _progress_sld.addEventListener("dot_seek", this.dotSeek);
            _progress_sld.addEventListener("wall3DOpen", function (event:Event) : void
            {
                showPriviewPic();
                return;
            }// end function
            );
            _progress_sld.addEventListener("newPreOver", function (event:Event) : void
            {
                _isShowPreview = true;
                return;
            }// end function
            );
            _progress_sld.addEventListener("newPreOut", function (event:Event) : void
            {
                _isShowPreview = false;
                return;
            }// end function
            );
            _progress_sld.addEventListener("proKeyboardTip", function (event:Event) : void
            {
                tipProKeyboardCookie();
                return;
            }// end function
            );
            _volume_sld.slider.addEventListener(SliderEventUtil.SLIDER_RATE, this.volumeBarPreview);
            this._definitionSlider.addEventListener(MouseEvent.MOUSE_OUT, this.hideDefinitionSideBar);
            this._definitionBar.addEventListener(MouseEventUtil.MOUSE_OUT, this.hideDefinitionSideBar);
            this._definitionBar.addEventListener(MouseEventUtil.MOUSE_OVER, this.showDefinitionSideBar);
            this._definitionSlider.addEventListener("settingFinish", this.dspSettingFinish);
            this._definitionSlider.addEventListener("settingFinishFor56", this.dspSettingFinishFor56);
            this._lightBar.addEventListener(MouseEventUtil.MOUSE_OVER, this.showSettingPanel);
            this._lightBar.addEventListener(MouseEventUtil.MOUSE_OUT, this.hideSettingPanel);
            this._langSetBar.addEventListener(MouseEventUtil.CLICK, this.langSet);
            this._albumBtn.addEventListener(MouseEventUtil.CLICK, this.showPlayListPanel);
            this._barrageBtn.addEventListener(MouseEventUtil.MOUSE_UP, function (event:Event) : void
            {
                var evt:* = event;
                if (_danmu != null)
                {
                    try
                    {
                        if (_danmu.getTmShow())
                        {
                            evt.target.clicked = false;
                            _danmu.showTanmu(false);
                            if (ExternalInterface.available && PlayerConfig.isSohuDomain && stage.displayState == "fullScreen")
                            {
                                ExternalInterface.call("s2j_dmSwitch", 2);
                            }
                        }
                        else
                        {
                            evt.target.clicked = true;
                            _danmu.showTanmu(true);
                            if (ExternalInterface.available && PlayerConfig.isSohuDomain && stage.displayState == "fullScreen")
                            {
                                ExternalInterface.call("s2j_dmSwitch", 1);
                            }
                        }
                    }
                    catch (evt)
                    {
                    }
                }
                return;
            }// end function
            );
            this._normalScreen3_btn.addEventListener(MouseEventUtil.CLICK, this.exitFullMouseClick);
            _hitArea_spr.removeEventListener(MouseEvent.CLICK, hitAreaClick);
            _hitArea_spr.addEventListener(MouseEvent.CLICK, this.playOrPause);
            this._retryPanel.addEventListener(RetryPanel.RETRY, this.fileRetry);
            this._tipHistory.addEventListener(TipHistory.SEEK, this.historyBreakPoint);
            this._tipHistory.addEventListener(TipHistory.TOSTART_BTN_ONCLICK, this.toStartAndPlay);
            this._tipHistory.addEventListener("cancelJump", this.cancelJump);
            this._tipHistory.addEventListener("setting", this.showOtherSetting);
            this._tipHistory.addEventListener("hdToCommon", function (event:Event) : void
            {
                dispatchEvent(new Event(HD_BUTTON_MOUSEUP));
                return;
            }// end function
            );
            this._tipHistory.addEventListener("commonToHd", function (event:Event) : void
            {
                dispatchEvent(new Event(COMMON_BUTTON_MOUSEUP));
                return;
            }// end function
            );
            this._tipHistory.addEventListener("exitFullScreen", function (event:Event) : void
            {
                if (stage.displayState == "fullScreen")
                {
                    _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
                }
                return;
            }// end function
            );
            this._tipHistory.addEventListener("imovie", function (event:Event) : void
            {
                var _loc_2:Object = null;
                _core.pause();
                if (stage.displayState == "fullScreen")
                {
                    _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
                }
                if (Eif.available)
                {
                    if (PlayerConfig.cooperator == "imovie")
                    {
                        _loc_2 = stage.loaderInfo.parameters;
                        ExternalInterface.call("jQuery.authentication", _loc_2.c, _loc_2.n, "1", "");
                    }
                }
                return;
            }// end function
            );
            this._tipHistory.addEventListener("toSuper", function (event:Event) : void
            {
                dispatchEvent(new Event(SUPER_BUTTON_MOUSEUP));
                return;
            }// end function
            );
            this._tipHistory.addEventListener(Event.OPEN, this.tipPanelOpened);
            this._tipHistory.addEventListener(Event.CLOSE, this.tipPanelClosed);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyboardDownHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.keyboardUpHandler);
            this._tvSohuLogo_btn.addEventListener(MouseEventUtil.CLICK, this.gotoTvSohu);
            _volume_sld.addEventListener("comebackVolume", function (event:Event) : void
            {
                setSkinState();
                return;
            }// end function
            );
            _volume_sld.addEventListener("muteVolume", function (event:Event) : void
            {
                setSkinState();
                return;
            }// end function
            );
            _volume_sld.addEventListener("volKeyboardTip", function (event:Event) : void
            {
                tipVolKeyboardCookie();
                return;
            }// end function
            );
            this._topPer50_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.changeVideoRate);
            this._topPer75_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.changeVideoRate);
            this._topPer100_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.changeVideoRate);
            return;
        }// end function

        private function capBarMouseOver(event:MouseEvent) : void
        {
            this._captionBar.showDragBg();
            return;
        }// end function

        private function capBarMouseOut(event:MouseEvent) : void
        {
            this._captionBar.hideDragBg();
            return;
        }// end function

        private function capBarMouseDown(event:MouseEvent) : void
        {
            this._captionBar.startDrag(false, new Rectangle(0, 0, 0, _core.height - this._captionBar.height));
            this._captionBar.isDragState = true;
            this._isCapDrag = true;
            return;
        }// end function

        private function capBarMouseUp(event:MouseEvent) : void
        {
            this._captionBar.stopDrag();
            this._captionBar.py = (this._captionBar.y - _core.videoContainer.y) / _core.videoContainer.height;
            this._captionBar.isDragState = false;
            return;
        }// end function

        private function onStageMouseOut(event:MouseEvent) : void
        {
            this.hideSideBar(event);
            return;
        }// end function

        public function showCommonProgress() : void
        {
            if (_skin != null)
            {
                var _loc_1:* = _progress_sld;
                _loc_1._progress_sld["onSliderWideStatus"](0);
                if (this._tipHistory != null)
                {
                    if (this._tipHistory.isOpen)
                    {
                        TweenLite.to(this._tipHistory, 0.1, {y:_progress_sld.y - this._tipHistory.height + 1});
                    }
                    else
                    {
                        this._tipHistory.y = _progress_sld.y - this._tipHistory.height + 1;
                    }
                }
            }
            return;
        }// end function

        protected function showMiniProgress() : void
        {
            var _loc_1:* = _progress_sld;
            _loc_1._progress_sld["sliderOutHandler"]();
            var _loc_1:* = _progress_sld;
            _loc_1._progress_sld["onSliderNarrowStatus"](0);
            if (this._tipHistory != null)
            {
                if (this._tipHistory.isOpen)
                {
                    TweenLite.to(this._tipHistory, 0.1, {y:_progress_sld.y - _progress_sld.height - 3 + 10});
                }
                else
                {
                    this._tipHistory.y = _progress_sld.y - _progress_sld.height - 3 + 10;
                }
            }
            return;
        }// end function

        public function pbarDiff() : Number
        {
            if (_progress_sld != null)
            {
                return _ctrlBarBg_spr.height;
            }
            return 0;
        }// end function

        private function checkXXX(event:Event = null) : void
        {
            if (!PlayerConfig.isFms && !this._isPreLoadPanel && !PlayerConfig.isLive)
            {
                this._isPreLoadPanel = true;
                this.startPreLoad();
            }
            return;
        }// end function

        private function tipPanelOpened(event:Event) : void
        {
            this.setSkinState();
            return;
        }// end function

        private function tipPanelClosed(event:Event) : void
        {
            this.setSkinState();
            return;
        }// end function

        private function cancelJump(event:Event) : void
        {
            this._isJumpEndCaption = false;
            return;
        }// end function

        private function showOtherSetting(event:Event) : void
        {
            this.showSettingPanel("CLICK");
            return;
        }// end function

        public function showSettingPanel(param1 = null) : void
        {
            var evt:* = param1;
            clearTimeout(this._showSetPId);
            clearTimeout(this._showSetPAutoId);
            this._showSetPId = setTimeout(function () : void
            {
                loadSettingPanel();
                return;
            }// end function
            , 200);
            if (evt == "CLICK")
            {
                this._showSetPAutoId = setTimeout(function () : void
            {
                hideSettingPanel();
                return;
            }// end function
            , 3000);
            }
            return;
        }// end function

        private function hideSettingPanel(param1 = null) : void
        {
            var evt:* = param1;
            clearTimeout(this._showSetPId);
            clearTimeout(this._showSetPAutoId);
            this._showSetPId = setTimeout(function () : void
            {
                if (_settingPanel != null && (!_settingPanel.hitTestPoint(mouseX, mouseY) || _ctrlBar_c.mouseX <= _settingPanel.x || evt != null && evt.stageX <= 0 || mouseX >= stage.stageWidth - 6 || mouseY >= stage.stageHeight - 6))
                {
                    _settingPanel.close();
                }
                return;
            }// end function
            , 200);
            return;
        }// end function

        private function loadSettingPanel() : void
        {
            var ctx:LoaderContext;
            if (this._settingPanel == null)
            {
                ctx = new LoaderContext();
                ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _settingPanel = obj.data.content;
                    _settingPanel.addEventListener(PanelEvent.LIGHT_VAL_CHANGE, lightSlide);
                    _settingPanel.addEventListener(PanelEvent.CONTRAST_VAL_CHANGE, contrastSlider);
                    _settingPanel.addEventListener(PanelEvent.SCALE_SELECTED, displayZoomSet);
                    _settingPanel.addEventListener(PanelEvent.ROTATE_SCR, displayRotateSet);
                    _settingPanel.addEventListener(PanelEvent.ACCELERATED_CHANGE, acceleratedChange);
                    _settingPanel.addEventListener(PanelEvent.READY, function (event:PanelEvent) : void
                {
                    _settingPanel.init(_owner);
                    setSkinState();
                    loadSettingPanel();
                    return;
                }// end function
                );
                    _settingPanel.addEventListener(MouseEvent.ROLL_OUT, hideSettingPanel);
                    addChild(_settingPanel);
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/SettingPanel.swf", ctx);
            }
            else
            {
                this._settingPanel.open({available:PlayerConfig.availableStvd, isStvd:PlayerConfig.stvdInUse});
                this.setSkinState();
                this.setChildIndex(this._settingPanel, (this.numChildren - 1));
            }
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Set&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            return;
        }// end function

        private function dspSettingFinish(event:Event) : void
        {
            var _loc_2:SharedObject = null;
            var _loc_3:String = "";
            switch(event.target.autoFix)
            {
                case "1":
                {
                    _loc_2 = SharedObject.getLocal("vmsPlayer", "/");
                    var _loc_4:String = "1";
                    _loc_2.data.af = "1";
                    PlayerConfig.autoFix = _loc_4;
                    _loc_2.data.ver = "";
                    try
                    {
                        _loc_3 = _loc_2.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    return;
                }
                case "2":
                {
                    _loc_2 = SharedObject.getLocal("vmsPlayer", "/");
                    var _loc_4:String = "2";
                    _loc_2.data.af = "2";
                    PlayerConfig.autoFix = _loc_4;
                    _loc_2.data.ver = "";
                    try
                    {
                        _loc_3 = _loc_2.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    return;
                }
                default:
                {
                    break;
                }
            }
            switch(event.target.ver)
            {
                case "1":
                {
                    if (PlayerConfig.hdVid != "" && PlayerConfig.hdVid != PlayerConfig.currentVid)
                    {
                        this.stopDanmu();
                        this.stopV360();
                        this._isPreLoadPanel = false;
                        dispatchEvent(new Event(HD_BUTTON_MOUSEUP));
                        this.tipText("切换到高清...");
                    }
                    break;
                }
                case "2":
                {
                    if (PlayerConfig.norVid != "" && PlayerConfig.norVid != PlayerConfig.currentVid)
                    {
                        this.stopDanmu();
                        this.stopV360();
                        this._isPreLoadPanel = false;
                        dispatchEvent(new Event(COMMON_BUTTON_MOUSEUP));
                        this.tipText("切换到标清...");
                    }
                    break;
                }
                case "21":
                {
                    if (PlayerConfig.superVid != "" && PlayerConfig.superVid != PlayerConfig.currentVid)
                    {
                        this.stopDanmu();
                        this.stopV360();
                        this._isPreLoadPanel = false;
                        dispatchEvent(new Event(SUPER_BUTTON_MOUSEUP));
                        this.tipText("切换到超清...");
                    }
                    break;
                }
                case "31":
                {
                    if (PlayerConfig.oriVid != "" && PlayerConfig.oriVid != PlayerConfig.currentVid)
                    {
                        this.stopDanmu();
                        this._isPreLoadPanel = false;
                        dispatchEvent(new Event(ORI_BUTTON_MOUSEUP));
                        this.tipText("切换到原画...");
                    }
                    break;
                }
                case "51":
                {
                    if (PlayerConfig.h2644kVid != "" && PlayerConfig.h2644kVid != PlayerConfig.currentVid)
                    {
                        this.stopDanmu();
                        this._isPreLoadPanel = false;
                        dispatchEvent(new Event(EXTREME_BUTTON_MOUSEUP));
                        this.tipText("切换到极清...");
                        if (this._tipHistory != null)
                        {
                            if (this._tipHistory.isOpen)
                            {
                                this._tipHistory.close();
                            }
                            this._tipHistory.isExtremeTip = false;
                        }
                    }
                    break;
                }
                case "53":
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

        private function dspSettingFinishFor56(event:Event) : void
        {
            var _loc_2:SharedObject = null;
            var _loc_4:int = 0;
            var _loc_3:String = "";
            switch(event.target.ver)
            {
                case "clear":
                {
                    PlayerConfig.rfilesType = "clear";
                    this._isPreLoadPanel = false;
                    dispatchEvent(new Event(HD_BUTTON_MOUSEUP));
                    this.tipText("切换到高清...");
                    _loc_2 = SharedObject.getLocal("vmsPlayer56", "/");
                    _loc_2.data.ver = "clear";
                    try
                    {
                        _loc_3 = _loc_2.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    break;
                }
                case "normal":
                {
                    PlayerConfig.rfilesType = "normal";
                    this._isPreLoadPanel = false;
                    dispatchEvent(new Event(COMMON_BUTTON_MOUSEUP));
                    this.tipText("切换到标清...");
                    _loc_2 = SharedObject.getLocal("vmsPlayer56", "/");
                    _loc_2.data.ver = "normal";
                    try
                    {
                        _loc_3 = _loc_2.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    break;
                }
                case "super":
                {
                    PlayerConfig.rfilesType = "super";
                    this._isPreLoadPanel = false;
                    dispatchEvent(new Event(SUPER_BUTTON_MOUSEUP));
                    this.tipText("切换到超清...");
                    _loc_2 = SharedObject.getLocal("vmsPlayer56", "/");
                    _loc_2.data.ver = "super";
                    try
                    {
                        _loc_3 = _loc_2.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    break;
                }
                case "vga":
                {
                    PlayerConfig.rfilesType = "vga";
                    this._isPreLoadPanel = false;
                    dispatchEvent(new Event(HD_BUTTON_MOUSEUP));
                    this.tipText("切换到高清...");
                    _loc_2 = SharedObject.getLocal("vmsPlayer56", "/");
                    _loc_2.data.ver = "vga";
                    try
                    {
                        _loc_3 = _loc_2.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    break;
                }
                case "qvga":
                {
                    PlayerConfig.rfilesType = "qvga";
                    this._isPreLoadPanel = false;
                    dispatchEvent(new Event(COMMON_BUTTON_MOUSEUP));
                    this.tipText("切换到标清...");
                    _loc_2 = SharedObject.getLocal("vmsPlayer56", "/");
                    _loc_2.data.ver = "qvga";
                    try
                    {
                        _loc_3 = _loc_2.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    break;
                }
                case "wvga":
                {
                    PlayerConfig.rfilesType = "wvga";
                    this._isPreLoadPanel = false;
                    dispatchEvent(new Event(SUPER_BUTTON_MOUSEUP));
                    this.tipText("切换到超清...");
                    _loc_2 = SharedObject.getLocal("vmsPlayer56", "/");
                    _loc_2.data.ver = "wvga";
                    try
                    {
                        _loc_3 = _loc_2.flush();
                        if (_loc_3 == SharedObjectFlushStatus.PENDING)
                        {
                            _loc_2.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                        }
                        else if (_loc_3 == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function onPlay(event:Event) : void
        {
            var evt:* = event;
            var _loc_3:Boolean = false;
            _skinMap.getValue("replayBtn").e = false;
            _skinMap.getValue("replayBtn").v = _loc_3;
            this.clearBlurFilter();
            super.onPlay(evt);
            if (_skin != null)
            {
                if (this._preLoadPanel != null && this._preLoadPanel.isOpen)
                {
                    this._preLoadPanel.ttt();
                }
                if (!PlayerConfig.isSohuDomain && this._searchBar != null && this._topSideBar.y == 0)
                {
                    this._rightSideBarTimeout_to.restart();
                }
                if (_progress_sld != null)
                {
                    _progress_sld["hideNewPreview"] = false;
                }
            }
            this._showTipTimeout = setTimeout(function () : void
            {
                if (_isFB == "f")
                {
                    tipText("快进 " + Utils.fomatTime(_core.filePlayedTime) + "(" + Math.round(_core.filePlayedTime / _core.fileTotTime * 100) + "%)", 2);
                    _isFB = "";
                }
                else if (_isFB == "b")
                {
                    tipText("快退 " + Utils.fomatTime(_core.filePlayedTime) + "(" + Math.round(_core.filePlayedTime / _core.fileTotTime * 100) + "%)", 2);
                    _isFB = "";
                }
                return;
            }// end function
            , 500);
            InforSender.getInstance().sendIRS("play");
            if (this._danmu != null)
            {
                this._danmu.play();
            }
            return;
        }// end function

        override protected function onPause(event:Event) : void
        {
            var evt:* = event;
            var _loc_3:Boolean = false;
            _skinMap.getValue("replayBtn").e = false;
            _skinMap.getValue("replayBtn").v = _loc_3;
            super.onPause(evt);
            if (evt["obj"].isHard)
            {
                this._onPuaeStatId = setTimeout(function () : void
            {
                ErrorSenderPQ.getInstance().sendPQStat({error:0, code:PlayerConfig.ON_VIDEO_PAUSE_CODE});
                return;
            }// end function
            , 500);
            }
            if (_skin != null)
            {
                clearInterval(this._showBufferRate);
                this._transition_mc.visible = false;
                if (!PlayerConfig.isSohuDomain && this._searchBar != null && this._topSideBar.y < 0)
                {
                    TweenLite.to(this._topSideBar, 0.5, {y:0, ease:Quad.easeOut});
                }
            }
            if (Eif.available)
            {
                ExternalInterface.call("flv_playerEvent", "onPause");
            }
            InforSender.getInstance().sendIRS("pause");
            if (this._danmu != null)
            {
                this._danmu.pause();
            }
            return;
        }// end function

        private function forward(event:Event) : void
        {
            var _loc_2:* = _core.filePlayedTime + 20;
            var _loc_3:* = _core.fileTotTime;
            clearTimeout(this._showTipTimeout);
            if (_loc_2 > 0 && _loc_2 < _loc_3)
            {
                _core.seek(_loc_2);
                _progress_sld.topRate = _loc_2 / _loc_3;
                _core.play();
                this._isFB = "f";
            }
            return;
        }// end function

        private function backward(event:Event) : void
        {
            var _loc_2:* = _core.filePlayedTime - 20;
            var _loc_3:* = _core.fileTotTime;
            clearTimeout(this._showTipTimeout);
            if (_loc_2 > 0 && _loc_2 < _loc_3)
            {
                _core.seek(_loc_2);
                _progress_sld.topRate = _loc_2 / _loc_3;
                _core.play();
                this._isFB = "b";
            }
            return;
        }// end function

        private function dotSeek(event:Event) : void
        {
            if (PlayerConfig.uvrInfo != null && !this._isEssenceTip && !this._tipHistory.isOpen)
            {
                this._isEssenceTip = true;
                this._tipHistory.showEssenceTip(PlayerConfig.uvrInfo);
            }
            var _loc_2:* = event.target.dotSeekTime;
            var _loc_3:* = _core.fileTotTime;
            if (_loc_2 > 0 && _loc_2 < _loc_3)
            {
                _core.seek(_loc_2);
                _progress_sld.topRate = _loc_2 / _loc_3;
                _core.play();
            }
            return;
        }// end function

        public function seekTo(param1:Number = 0) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (_core != null && (_core.streamState == "play" || _core.streamState == "pause" || _core.streamState == "stop") && TvSohuAds.getInstance().endAd.state != "playing" && TvSohuAds.getInstance().middleAd.state != "playing" && TvSohuAds.getInstance().startAd.state != "playing")
            {
                _loc_2 = param1;
                _loc_3 = _core.fileTotTime;
                if (_loc_2 > 0 && _loc_2 < _loc_3)
                {
                    _core.seek(_loc_2);
                    _progress_sld.topRate = _loc_2 / _loc_3;
                    _core.play();
                }
                if (Eif.available)
                {
                    ExternalInterface.call("flv_playerEvent", "onSeek", _loc_2);
                }
            }
            return;
        }// end function

        override protected function progressSlideStart(param1:SliderEventUtil) : void
        {
            this.startDragTime = PlayerConfig.playedTime;
            super.progressSlideStart(param1);
            return;
        }// end function

        override public function seek(param1 = null) : void
        {
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_2:* = PlayerConfig.playedTime;
            if (PlayerConfig.startTime != "" && PlayerConfig.endTime != "")
            {
                _loc_6 = uint(PlayerConfig.startTime);
                _loc_7 = uint(PlayerConfig.endTime);
                _loc_8 = _core.fileTotTime;
                _loc_9 = (_loc_7 - _loc_6) / _loc_8;
                if (param1 is Number)
                {
                    param1 = param1 * _loc_9 + _loc_6 / _loc_8;
                }
                else
                {
                    param1.obj.rate = param1.obj.rate * _loc_9 + _loc_6 / _loc_8;
                }
            }
            var _loc_3:* = param1 is Number ? (param1) : (param1.obj.rate);
            var _loc_4:* = _core.fileTotTime;
            var _loc_5:* = Math.round(_loc_4 * _loc_3);
            _core.dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:_loc_5, totTime:_loc_4, isSeek:true});
            if (!(param1 is Number) && param1.obj.sign == 0)
            {
                if (Math.abs(_loc_5 - _seekTime) >= 6)
                {
                    _seekTime = _loc_5;
                    if (!PlayerConfig.isWebP2p)
                    {
                        _core.seek(_seekTime, param1.obj.sign);
                    }
                }
            }
            else
            {
                SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=1009&uid=" + PlayerConfig.userId + "&expand1=" + _loc_5 + "&expand2=" + PlayerConfig.vid + "&expand3=" + (this.startDragTime > 0 ? (this.startDragTime) : (_loc_2)) + "&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                if (PlayerConfig.uvrInfo != null && !this._isEssenceTip && !this._tipHistory.isOpen)
                {
                    this._isEssenceTip = true;
                    this._tipHistory.showEssenceTip(PlayerConfig.uvrInfo);
                }
                this.startDragTime = 0;
                _loc_5 = _loc_5 <= 0 ? (1) : (_loc_5);
                _seekTime = _loc_5;
                _core.seek(_seekTime);
            }
            if (this._danmu != null)
            {
                this._danmu.seek(_seekTime);
            }
            return;
        }// end function

        override protected function onFullScreenChange(event:FullScreenEvent) : void
        {
            var evt:* = event;
            clearTimeout(this._onPuaeStatId);
            super.onFullScreenChange(evt);
            if (evt.fullScreen)
            {
                if (Eif.available)
                {
                    try
                    {
                        fscommand("fullscreen", "1");
                    }
                    catch (evt:Error)
                    {
                    }
                }
                var _loc_3:Boolean = false;
                _skinMap.getValue("fullScreenBtn").v = false;
                _skinMap.getValue("fullScreenBtn").e = _loc_3;
                var _loc_3:Boolean = true;
                _skinMap.getValue("normalScreenBtn").v = true;
                _skinMap.getValue("normalScreenBtn").e = _loc_3;
                if (PlayerConfig.autoFix == "2" && PlayerConfig.relativeId != "" && !PlayerConfig.isHd)
                {
                    setTimeout(function () : void
            {
                dispatchEvent(new Event(HD_BUTTON_MOUSEUP));
                return;
            }// end function
            , 500);
                }
                ErrorSenderPQ.getInstance().sendPQStat({error:0, code:PlayerConfig.ON_VIDEO_FULLSCREEN_CODE});
                this._isEsc = true;
            }
            else
            {
                if (this._playListPanel != null && this._playListPanel.isOpen && PlayerConfig.domainProperty == "0")
                {
                    this._playListPanel.close();
                }
                if (Eif.available)
                {
                    try
                    {
                        ExternalInterface.call("setFullWindowCookie", "0");
                        fscommand("fullscreen", "0");
                    }
                    catch (evt:Error)
                    {
                    }
                }
                var _loc_3:Boolean = true;
                _skinMap.getValue("fullScreenBtn").v = true;
                _skinMap.getValue("fullScreenBtn").e = _loc_3;
                var _loc_3:Boolean = false;
                _skinMap.getValue("normalScreenBtn").v = false;
                _skinMap.getValue("normalScreenBtn").e = _loc_3;
                TvSohuAds.getInstance().ctrlBarAd.dispatchSharedEvent();
                if (stage.displayState != "fullScreen")
                {
                    this._displayRate = 1;
                    _core.displayZoom(this._displayRate);
                    this.setAdsState();
                }
                if (this._isEsc)
                {
                    SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_EscFull&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                }
            }
            if (_skin != null)
            {
                this.setSkinState();
            }
            return;
        }// end function

        override protected function hitAreaDClick(event:MouseEvent) : void
        {
            this._isEsc = false;
            super.hitAreaDClick(event);
            if (stage.displayState == "fullScreen")
            {
                SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_DoubleFull&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            }
            else
            {
                SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_DoubleCom&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            }
            return;
        }// end function

        private function gotoTvSohu(param1:MouseEventUtil) : void
        {
            if (PlayerConfig.isNewsLogo)
            {
                Utils.openWindow("http://tv.sohu.com/news/");
                SendRef.getInstance().sendPQVPC("PL_C_LogoNew");
            }
            else if (PlayerConfig.channel == "s")
            {
                Utils.openWindow("http://tv.sohu.com/sports/");
                SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_LogoSports");
            }
            else if (!PlayerConfig.isPartner)
            {
                Utils.openWindow("http://tv.sohu.com");
                SendRef.getInstance().sendPQVPC("PL_C_Logo");
            }
            return;
        }// end function

        private function keyboardDownHandler(event:KeyboardEvent) : void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyboardDownHandler);
            switch(event.keyCode)
            {
                case 38:
                {
                    if (_volume_sld.slider.enabled && PlayerConfig.isUseSpacebar)
                    {
                        var _loc_2:* = _volume_sld.slider;
                        _loc_2._volume_sld.slider["forward"]();
                        SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_UpVolumeKeyboard");
                    }
                    break;
                }
                case 40:
                {
                    if (_volume_sld.slider.enabled && PlayerConfig.isUseSpacebar)
                    {
                        var _loc_2:* = _volume_sld.slider;
                        _loc_2._volume_sld.slider["backward"]();
                        SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_DownVolumeKeyboard");
                    }
                    break;
                }
                case 39:
                {
                    if (_progress_sld.enabled && PlayerConfig.isUseSpacebar)
                    {
                        var _loc_2:* = _progress_sld;
                        _loc_2._progress_sld["forward"]();
                        SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_ForwardKeyboard");
                    }
                    break;
                }
                case 37:
                {
                    if (_progress_sld.enabled && PlayerConfig.isUseSpacebar)
                    {
                        var _loc_2:* = _progress_sld;
                        _loc_2._progress_sld["backward"]();
                        SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_BackwardKeyboard");
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function keyboardUpHandler(event:KeyboardEvent) : void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyboardDownHandler);
            switch(event.keyCode)
            {
                case 38:
                {
                    if (_volume_sld.slider.enabled && PlayerConfig.isUseSpacebar)
                    {
                        var _loc_2:* = _volume_sld.slider;
                        _loc_2._volume_sld.slider["stopForward"]();
                    }
                    break;
                }
                case 40:
                {
                    if (_volume_sld.slider.enabled && PlayerConfig.isUseSpacebar)
                    {
                        var _loc_2:* = _volume_sld.slider;
                        _loc_2._volume_sld.slider["stopBackward"]();
                    }
                    break;
                }
                case 39:
                {
                    if (PlayerConfig.isUseSpacebar)
                    {
                        var _loc_2:* = _progress_sld;
                        _loc_2._progress_sld["stopForward"]();
                    }
                    break;
                }
                case 37:
                {
                    if (PlayerConfig.isUseSpacebar)
                    {
                        var _loc_2:* = _progress_sld;
                        _loc_2._progress_sld["stopBackward"]();
                    }
                    break;
                }
                case 32:
                {
                    if (!(TvSohuAds.getInstance().endAd.hasAd && TvSohuAds.getInstance().endAd.state == "playing" || TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing"))
                    {
                        if (PlayerConfig.isUseSpacebar)
                        {
                            _core.playOrPause(event);
                        }
                    }
                    break;
                }
                case 13:
                {
                    if (event.ctrlKey && !(TvSohuAds.getInstance().endAd.hasAd && TvSohuAds.getInstance().endAd.state == "playing" || TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing") && _skin != null && stage.displayState != "fullScreen")
                    {
                        _fullScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
                    }
                    break;
                }
                case 79:
                {
                    if (event.ctrlKey && event.shiftKey)
                    {
                        this.showP2PLogPanel();
                    }
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function showP2PLogPanel() : void
        {
            if (this._p2pLogPanel == null)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    _p2pLogPanel = param1.data.content;
                    _p2pLogPanel.close(0);
                    addChild(_p2pLogPanel);
                    showP2PLogPanel();
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/P2PInfoPanel.swf");
            }
            else if (this._p2pLogPanel.isOpen)
            {
                this._p2pLogPanel.close();
            }
            else
            {
                this._p2pLogPanel.open();
            }
            return;
        }// end function

        public function showVideoInfoPanel() : void
        {
            if (this._videoInfoPanel.isOpen)
            {
                this._videoInfoPanel.close();
            }
            else
            {
                this.closePanel();
                this._videoInfoPanel.open();
            }
            return;
        }// end function

        protected function lightSlide(event:PanelEvent) : void
        {
            var _loc_2:* = new ColorMatrix();
            var _loc_7:* = event.lightVal;
            this._lightRate = event.lightVal;
            var _loc_3:* = _loc_7;
            var _loc_4:* = (_loc_3 - 1) * 2 + 1;
            var _loc_5:Array = [];
            _loc_2.adjustBrightness(100 * _loc_4);
            this._filterArr[0] = _loc_4 != 0 ? (new ColorMatrixFilter(_loc_2)) : (_loc_4);
            var _loc_6:uint = 0;
            while (_loc_6 < this._filterArr.length)
            {
                
                if (this._filterArr[_loc_6] != 0 && this._filterArr[_loc_6] != null)
                {
                    _loc_5.push(this._filterArr[_loc_6]);
                }
                _loc_6 = _loc_6 + 1;
            }
            _core.videoContainer.filters = _loc_5;
            return;
        }// end function

        protected function contrastSlider(event:PanelEvent) : void
        {
            var _loc_2:* = new ColorMatrix();
            var _loc_7:* = event.contrastVal;
            this._contrastRate = event.contrastVal;
            var _loc_3:* = _loc_7;
            var _loc_4:* = (_loc_3 - 1) * 2 + 1;
            var _loc_5:Array = [];
            _loc_2.adjustContrast(100 * _loc_4);
            this._filterArr[1] = _loc_4 != 0 ? (new ColorMatrixFilter(_loc_2)) : (_loc_4);
            var _loc_6:uint = 0;
            while (_loc_6 < this._filterArr.length)
            {
                
                if (this._filterArr[_loc_6] != 0 && this._filterArr[_loc_6] != null)
                {
                    _loc_5.push(this._filterArr[_loc_6]);
                }
                _loc_6 = _loc_6 + 1;
            }
            _core.videoContainer.filters = _loc_5;
            return;
        }// end function

        private function displayZoomSet(event:PanelEvent) : void
        {
            if (!PlayerConfig.isBackgorundShowing)
            {
                this._displayRate = event.scaleRate;
                _core.displayZoom(this._displayRate);
                this.setAdsState();
            }
            return;
        }// end function

        private function displayRotateSet(event:PanelEvent) : void
        {
            if (!PlayerConfig.isBackgorundShowing)
            {
                _core.setR(event.rotateVal);
                this.setAdsState();
            }
            return;
        }// end function

        private function acceleratedChange(event:PanelEvent) : void
        {
            if (event.toStgVd && !PlayerConfig.stvdInUse)
            {
                dispatchEvent(new Event("gotoStageVideo"));
            }
            else if (!event.toStgVd && PlayerConfig.stvdInUse)
            {
                dispatchEvent(new Event("gotoVideo"));
            }
            return;
        }// end function

        public function get displayRate() : Number
        {
            return this._displayRate;
        }// end function

        private function toStartAndPlay(event:Event) : void
        {
            var _loc_2:* = PlayerConfig.stTime > 0 ? (PlayerConfig.stTime) : (1);
            var _loc_3:* = _core.fileTotTime;
            if (_loc_2 > 0 && _loc_2 < _loc_3)
            {
                _core.seek(_loc_2);
                _progress_sld.topRate = _loc_2 / _loc_3;
                _core.play();
            }
            _core.play();
            return;
        }// end function

        private function historyBreakPoint(event:Event) : void
        {
            var _loc_2:* = event.target.breakPoint;
            var _loc_3:* = _core.fileTotTime;
            if (_loc_2 > 0 && _loc_2 < _loc_3)
            {
                _core.seek(_loc_2);
                _progress_sld.topRate = _loc_2 / _loc_3;
                _core.play();
            }
            _core.play();
            return;
        }// end function

        private function jumpTo(event:Event) : void
        {
            Utils.openWindow(event.target.url, "_self");
            return;
        }// end function

        private function fileRetryFailed(event:MediaEvent) : void
        {
            this._retryPanel.open();
            ErrorSenderPQ.getInstance().sendPQStat({code:PlayerConfig.RETRY_SHOWN_CODE});
            dispatchEvent(new Event("retryPanel_shown"));
            return;
        }// end function

        private function ncRetryFailed(event:MediaEvent) : void
        {
            this._ncConnectError = true;
            return;
        }// end function

        public function get ncConnectError() : Boolean
        {
            return this._ncConnectError;
        }// end function

        private function fileRetry(event:Event) : void
        {
            _core.retry();
            ErrorSenderPQ.getInstance().sendPQStat({code:PlayerConfig.AFFIRM_RETRY_CODE});
            return;
        }// end function

        private function preLoadFinish(event:Event) : void
        {
            if (this._preLoadPanel != null && this._preLoadPanel.isOpen && this._preLoadPanel.isBackgroundRun)
            {
                this._preLoadPanel.close(0);
                this.setSkinState();
            }
            return;
        }// end function

        private function preLoadPanelBGRun(event:Event) : void
        {
            this.setSkinState();
            return;
        }// end function

        private function preLoadPanelFGRun(event:Event) : void
        {
            this.setSkinState();
            return;
        }// end function

        override protected function exitFullMouseClick(param1:MouseEventUtil = null) : void
        {
            this._isEsc = false;
            if (this._playListPanel != null && this._playListPanel.isOpen && PlayerConfig.domainProperty == "0")
            {
                this._playListPanel.close();
            }
            super.exitFullMouseClick(param1);
            SendRef.getInstance().sendPQVPC("PL_S_ExitFull");
            return;
        }// end function

        private function changeVideoRate(param1:MouseEventUtil) : void
        {
            if (PlayerConfig.isBackgorundShowing)
            {
                return;
            }
            param1.target.enabled = false;
            switch(param1.target)
            {
                case this._topPer50_btn:
                {
                    this._displayRate = 0.5;
                    var _loc_2:Boolean = true;
                    this._topPer100_btn.enabled = true;
                    this._topPer75_btn.enabled = _loc_2;
                    SendRef.getInstance().sendPQVPC("PL_S_50Percent");
                    break;
                }
                case this._topPer75_btn:
                {
                    this._displayRate = 0.75;
                    var _loc_2:Boolean = true;
                    this._topPer100_btn.enabled = true;
                    this._topPer50_btn.enabled = _loc_2;
                    SendRef.getInstance().sendPQVPC("PL_S_75Percent");
                    break;
                }
                case this._topPer100_btn:
                {
                    this._displayRate = 1;
                    var _loc_2:Boolean = true;
                    this._topPer75_btn.enabled = true;
                    this._topPer50_btn.enabled = _loc_2;
                    SendRef.getInstance().sendPQVPC("PL_S_100Percent");
                    break;
                }
                default:
                {
                    break;
                }
            }
            _core.displayZoom(this._displayRate);
            this.setAdsState();
            return;
        }// end function

        public function toCommonMode() : void
        {
            if (PlayerConfig.isBrowserFullScreen || stage.displayState == "fullScreen")
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            return;
        }// end function

        public function toCinemaMode(param1 = null) : void
        {
            if (param1 != null && param1 == 1)
            {
                if (!this._isCinema)
                {
                    this.cinemaMouseClick();
                }
            }
            else if (this._isCinema)
            {
                this._turnOffWider_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            return;
        }// end function

        public function writeBreakpoint() : void
        {
            return;
        }// end function

        private function exitFull3MouseClick(param1:MouseEventUtil) : void
        {
            this._isEsc = false;
            if (this._playListPanel != null && this._playListPanel.isOpen && PlayerConfig.domainProperty == "0")
            {
                this._playListPanel.close();
            }
            super.exitFullMouseClick(param1);
            return;
        }// end function

        private function normalScreenMouseOver(param1:MouseEventUtil) : void
        {
            if (stage.displayState == "fullScreen")
            {
            }
            else
            {
                _fullScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_OVER));
            }
            return;
        }// end function

        override protected function fullMouseClick(param1:MouseEventUtil = null) : void
        {
            if (PlayerConfig.isSohuDomain || PlayerConfig.apiKey != "")
            {
                super.fullMouseClick(param1);
            }
            else if (PlayerConfig.isJump)
            {
                super.fullMouseClick(param1);
            }
            SendRef.getInstance().sendPQVPC("PL_C_FullScreen");
            return;
        }// end function

        private function miniWinMouseClick(param1:MouseEventUtil) : void
        {
            if (stage.displayState == "fullScreen")
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            ExternalInterface.call("_openSmallWin");
            this.setSkinState();
            InforSender.getInstance().sendCustomMesg("http://220.181.61.231/get.gif?type=miniwinmode");
            SendRef.getInstance().sendPQVPC("PL_C_SmallScreen");
            return;
        }// end function

        private function cinemaMouseClick(param1 = null) : void
        {
            if (stage.displayState == "fullScreen")
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            ExternalInterface.call("fullSm", ExternalInterface.objectID);
            this._isCinema = true;
            var _loc_2:Boolean = true;
            this._turnOffWider_btn.enabled = true;
            this._turnOffWider_btn.visible = _loc_2;
            var _loc_2:Boolean = false;
            this._turnOnWider_btn.visible = false;
            this._turnOnWider_btn.enabled = _loc_2;
            ExternalInterface.call("swfWiderMode", "on");
            this.setSkinState();
            if (param1 != null)
            {
                InforSender.getInstance().sendCustomMesg("http://220.181.61.231/get.gif?type=cinemamode");
                SendRef.getInstance().sendPQVPC("PL_C_WideScreen");
            }
            return;
        }// end function

        public function exitFullScreen() : void
        {
            if (stage.displayState == "fullScreen" && _skin != null)
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            return;
        }// end function

        private function windowMouseClick(param1 = null) : void
        {
            if (stage.displayState == "fullScreen")
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            this._isCinema = false;
            var _loc_2:Boolean = true;
            this._turnOnWider_btn.enabled = true;
            this._turnOnWider_btn.visible = _loc_2;
            var _loc_2:Boolean = false;
            this._turnOffWider_btn.enabled = false;
            this._turnOffWider_btn.visible = _loc_2;
            ExternalInterface.call("swfWiderMode", "off");
            var _loc_2:Boolean = true;
            _skinMap.getValue("fullScreenBtn").v = true;
            _skinMap.getValue("fullScreenBtn").e = _loc_2;
            var _loc_2:Boolean = false;
            _skinMap.getValue("normalScreenBtn").v = false;
            _skinMap.getValue("normalScreenBtn").e = _loc_2;
            this.setSkinState();
            return;
        }// end function

        protected function showDefinitionSideBar(param1:MouseEventUtil) : void
        {
            var evt:* = param1;
            clearTimeout(this._showBsbId);
            this._showBsbId = setTimeout(function () : void
            {
                _definitionSlider.visible = true;
                _definitionSlider.open();
                _tween = TweenLite.to(_definitionSlider, 0.3, {alpha:1, ease:Quad.easeOut});
                SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Resolution&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                return;
            }// end function
            , 200);
            return;
        }// end function

        protected function hideDefinitionSideBar(param1 = null) : void
        {
            var evt:* = param1;
            clearTimeout(this._showBsbId);
            this._showBsbId = setTimeout(function () : void
            {
                if (!_definitionSlider.hitTestPoint(mouseX, mouseY) || _ctrlBar_c.mouseX <= _definitionBar.x || evt != null && evt.stageX <= 0 || mouseX >= stage.stageWidth - 6 || mouseY >= stage.stageHeight - 6)
                {
                    hideBsb();
                }
                return;
            }// end function
            , 200);
            return;
        }// end function

        protected function hideBsb(param1 = null) : void
        {
            var evt:* = param1;
            if (this._tween != null)
            {
                this._definitionSlider.visible = true;
                this._tween = TweenLite.to(this._definitionSlider, 0.3, {alpha:0, ease:Quad.easeOut, onComplete:function () : void
            {
                _definitionSlider.visible = false;
                return;
            }// end function
            });
                this._tween = null;
            }
            return;
        }// end function

        private function langSet(param1:MouseEventUtil) : void
        {
            return;
        }// end function

        private function nextClickHandler(param1:MouseEventUtil) : void
        {
            if (PlayerConfig.vrsPlayListId && this._playListPanel != null && this._playListPanel.hasNext())
            {
                this._playListPanel.nextPlay();
            }
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Next&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            return;
        }// end function

        public function showPlayListPanel(param1:MouseEventUtil = null) : void
        {
            var evt:* = param1;
            if (this._playListPanel == null)
            {
                var _loc_3:Boolean = false;
                this._albumBtn.visible = false;
                this._albumBtn.enabled = _loc_3;
                this._next_btn.enabled = false;
                new LoaderUtil().load(15, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _playListPanel = obj.data.content;
                    _panelArr.push(_playListPanel);
                    addChild(_playListPanel);
                    _playListPanel.addEventListener("playVideo", function (event:Event) : void
                {
                    _isSwitchVideos = true;
                    dispatchEvent(new Event("playListVideo"));
                    return;
                }// end function
                );
                    _playListPanel.addEventListener("videoDestroy", function (event:Event) : void
                {
                    dispatchEvent(new Event("videoDestroy"));
                    return;
                }// end function
                );
                    _playListPanel.addEventListener("playListOk", function (event:Event) : void
                {
                    _isPlayListOk = true;
                    if (_playListPanel.hasNext())
                    {
                        _next_btn.enabled = true;
                    }
                    if (_playListPanel.sourceLength() > 1)
                    {
                        var _loc_2:Boolean = true;
                        _skinMap.getValue("albumBtn").v = true;
                        _skinMap.getValue("albumBtn").e = _loc_2;
                    }
                    else
                    {
                        var _loc_2:Boolean = false;
                        _skinMap.getValue("albumBtn").v = false;
                        _skinMap.getValue("albumBtn").e = _loc_2;
                    }
                    setSkinState();
                    return;
                }// end function
                );
                    _playListPanel.init(_core.width, _core.height - (PlayerConfig.isHide ? (0) : (pbarDiff())));
                    _playListPanel.initPlayList(PlayerConfig.vrsPlayListId, InforSender.getInstance().ifltype != "" ? (PlayerConfig.hdVid) : (PlayerConfig.vid));
                    try
                    {
                        VerLog.msg(_playListPanel["version"]);
                    }
                    catch (evt:Error)
                    {
                    }
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/PlayList.swf");
            }
            else if (this._albumBtn.btnVisNum == 0)
            {
                if (this._playListPanel.isOpen)
                {
                    this._playListPanel.close();
                }
                else if (this._preLoadPanel == null || (!this._preLoadPanel.isOpen || this._preLoadPanel.isBackgroundRun))
                {
                    this.closePanel();
                    this._playListPanel.open();
                    this.setChildIndex(this._playListPanel, (this.getChildIndex(_ctrlBar_c) - 1));
                    SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_SelectEpisodes&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                }
            }
            else
            {
                this._next_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
            }
            return;
        }// end function

        private function showSogouPanel(param1:MouseEventUtil) : void
        {
            var evt:* = param1;
            if (this._sogouPanel == null)
            {
                this._sogou_btn.enabled = false;
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    _sogouPanel = param1.data.content;
                    _sogouPanel.close(0);
                    _panelArr.push(_sogouPanel);
                    addChild(_sogouPanel);
                    setSkinState();
                    _sogou_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
                    ;
                }
                _sogou_btn.enabled = true;
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/SogouPanel.swf");
            }
            else if (this._sogouPanel.isOpen)
            {
                this._sogouPanel.close();
            }
            else if (this._preLoadPanel == null || (!this._preLoadPanel.isOpen || this._preLoadPanel.isBackgroundRun))
            {
                this.closePanel();
                this._sogouPanel.open();
                SendRef.getInstance().sendPQVPC("PL_R_Speed");
            }
            return;
        }// end function

        private function get isBrowserFullScreen() : Boolean
        {
            var _loc_2:String = null;
            var _loc_1:Boolean = false;
            if (Eif.available)
            {
                _loc_2 = ExternalInterface.call("isFullWindow");
                if (_loc_2 != null && _loc_2 == "1")
                {
                    _loc_1 = true;
                }
                else
                {
                    _loc_1 = false;
                }
            }
            return _loc_1;
        }// end function

        private function showCueTip() : void
        {
            var loadSucc:Function;
            var ctx:LoaderContext;
            loadSucc = function () : void
            {
                _cueTipPanel.init(PlayerConfig.cueTipEpInfo);
                if (_isShownLogoAd && _cueTipPanel != null)
                {
                    _cueTipPanel.visible = false;
                }
                setSkinState();
                return;
            }// end function
            ;
            if (this._cueTipPanel == null)
            {
                ctx = new LoaderContext();
                ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _cueTipPanel = obj.data.content;
                    _cueTipPanel.addEventListener(PanelEvent.READY, loadSucc);
                    _cueTipPanel.addEventListener("GO_URL_HAPPENS", function (event:Event) : void
                {
                    _core.pause();
                    return;
                }// end function
                );
                    addChild(_cueTipPanel);
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/CueTip.swf", ctx);
            }
            return;
        }// end function

        private function wm1(event:Event) : void
        {
            this._isShownPauseAd = false;
            _core.pause();
            return;
        }// end function

        private function wm2(event:Event) : void
        {
            this._isShownPauseAd = true;
            _core.play();
            return;
        }// end function

        private function wm3(event:Event) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:int = 0;
            var _loc_2:* = event["dat"];
            if (_loc_2 != null)
            {
                _loc_3 = 0;
                while (_loc_3 < _loc_2.length)
                {
                    
                    if (_loc_2[_loc_3].interactionInfo.beginTime / PlayerConfig.totalDuration >= 0 && _loc_2[_loc_3].interactionInfo.beginTime / PlayerConfig.totalDuration <= 1)
                    {
                        _loc_4 = _loc_2[_loc_3].type == 1 ? (_loc_2[_loc_3].interactionInfo.isItem != null && _loc_2[_loc_3].interactionInfo.isItem == 0 ? (0) : (_loc_2[_loc_3].type)) : (_loc_2[_loc_3].type);
                        PlayerConfig.epInfo.push({rate:_loc_2[_loc_3].interactionInfo.beginTime / PlayerConfig.totalDuration, time:_loc_2[_loc_3].interactionInfo.beginTime, type:_loc_4, title:_loc_2[_loc_3].interactionInfo.slogan, isai:"1"});
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            this.setHighDot();
            return;
        }// end function

        private function wm4(event:Event) : void
        {
            if (Eif.available)
            {
                if (PlayerConfig.domainProperty == "3")
                {
                    ExternalInterface.call("show_login()");
                }
                else
                {
                    ExternalInterface.call("sohuHD.showLoginWinbox()");
                }
            }
            if (stage.displayState == "fullScreen")
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            return;
        }// end function

        private function showWmTip() : void
        {
            var ctx:LoaderContext;
            if (this._wmTipPanel == null)
            {
                ctx = new LoaderContext();
                ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var wmDataInfo:Object;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _wmTipPanel = obj.data.content;
                    _wmTipPanel.addEventListener("PAUSE", wm1);
                    _wmTipPanel.addEventListener("RESUME", wm2);
                    _wmTipPanel.addEventListener("DAT_LOADED", wm3);
                    _wmTipPanel.addEventListener("LOGIN", wm4);
                    wmDataInfo = new Object();
                    wmDataInfo.passport = PlayerConfig.passportMail;
                    wmDataInfo.uid = PlayerConfig.visitorId;
                    wmDataInfo.pageName = PlayerConfig.wmDataInfo != null && PlayerConfig.wmDataInfo.wm_username != null ? (PlayerConfig.wmDataInfo.wm_username) : ("");
                    wmDataInfo.pagePhoto = PlayerConfig.wmDataInfo != null && PlayerConfig.wmDataInfo.wm_userphoto != null ? (PlayerConfig.wmDataInfo.wm_userphoto) : ("");
                    wmDataInfo.pageUid = PlayerConfig.myTvUserId;
                    wmDataInfo.vid = PlayerConfig.vid;
                    wmDataInfo.sid = PlayerConfig.sid;
                    wmDataInfo.isact = PlayerConfig.wmDataInfo != null && PlayerConfig.wmDataInfo.wm_isact != null ? (PlayerConfig.wmDataInfo.wm_isact) : (0);
                    wmDataInfo.playtype = PlayerConfig.wmDataInfo != null && PlayerConfig.wmDataInfo.wm_playtype != null ? (PlayerConfig.wmDataInfo.wm_playtype) : (0);
                    wmDataInfo.duration = PlayerConfig.totalDuration;
                    wmDataInfo.isSohuDomain = PlayerConfig.isSohuDomain;
                    wmDataInfo.fuid = PlayerConfig.userId;
                    wmDataInfo.plid = PlayerConfig.vrsPlayListId;
                    wmDataInfo.isai = PlayerConfig.isai != "" && PlayerConfig.isai == "1" ? (true) : (false);
                    wmDataInfo.tvid = PlayerConfig.tvid;
                    wmDataInfo.domainProperty = PlayerConfig.domainProperty;
                    LogManager.msg("自媒体视频信息:passport=" + wmDataInfo.passport + " : : uid=" + wmDataInfo.uid + " : : pageName=" + wmDataInfo.pageName + " : : wmDataInfo.pagePhoto=" + wmDataInfo.pagePhoto + " : : pageUid=" + wmDataInfo.pageUid + " : : vid=" + wmDataInfo.vid + " : : sid=" + wmDataInfo.sid + " : : isact=" + wmDataInfo.isact + " : : playtype=" + wmDataInfo.playtype + " : : duration=" + wmDataInfo.duration + ": : wmDataInfo.isai=" + wmDataInfo.isai + ": : wmDataInfo.tvid=" + wmDataInfo.tvid + ": : isSohuDomain=" + wmDataInfo.isSohuDomain);
                    _wmTipPanel.init(wmDataInfo);
                    addChild(_wmTipPanel);
                    try
                    {
                        VerLog.msg(_wmTipPanel["version"]);
                    }
                    catch (evt:Error)
                    {
                    }
                    setSkinState();
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/ugcmodule.swf", ctx);
            }
            else if (this._isShownLogoAd && this._wmTipPanel != null)
            {
                this._wmTipPanel.visible = false;
            }
            return;
        }// end function

        private function showUgcAd() : void
        {
            if (this._ugcAd == null)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var adDataInfo:Object;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _ugcAd = obj.data.content;
                    addChild(_ugcAd);
                    adDataInfo = new Object();
                    adDataInfo.vid = PlayerConfig.isMyTvVideo ? (Utils.cleanUnderline(PlayerConfig.vid)) : (PlayerConfig.vid);
                    adDataInfo.pid = PlayerConfig.vrsPlayListId;
                    adDataInfo.videoType = PlayerConfig.isMyTvVideo ? (PlayerConfig.wm_user == "20" ? ("2") : ("1")) : ("3");
                    adDataInfo.vrsCate = PlayerConfig.catcode;
                    adDataInfo.isPayVideo = PlayerConfig.isUgcFeeVideo ? ("1") : ("0");
                    _ugcAd.initData(adDataInfo, _core.width, _core.height - (PlayerConfig.isHide ? (0) : (pbarDiff())));
                    _ugcAd.addEventListener("Resize_Over", function (event:Event) : void
                {
                    setSkinState();
                    return;
                }// end function
                );
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/QianFanAdPalyer.swf");
                ;
            }
            return;
        }// end function

        protected function sharePanel(param1:MouseEventUtil) : void
        {
            var evt:* = param1;
            if (this._sharePanel == null)
            {
                this.streamState = _core.streamState;
                this._share_btn.enabled = false;
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _sharePanel = obj.data.content;
                    _sharePanel.init();
                    _sharePanel.close(0);
                    _panelArr.push(_sharePanel);
                    _sharePanel.addEventListener("CLOSE_EVT", function (event:Event) : void
                {
                    if (!(_more != null && _more.visible))
                    {
                        if (streamState == "pause")
                        {
                            _core.pause();
                        }
                        else
                        {
                            _core.play();
                        }
                    }
                    return;
                }// end function
                );
                    _core.dispatch(MediaEvent.PLAY_PROGRESS, {nowTime:_core.filePlayedTime, totTime:_core.fileTotTime, isSeek:false});
                    addChild(_sharePanel);
                    _share_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
                    ;
                }
                _share_btn.enabled = true;
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/SharePanel.swf");
            }
            else if (this._sharePanel.isOpen)
            {
                this._sharePanel.close(evt);
            }
            else if (this._preLoadPanel == null || (!this._preLoadPanel.isOpen || this._preLoadPanel.isBackgroundRun))
            {
                this.streamState = _core.streamState;
                this.closePanel();
                this._sharePanel.open();
                if (this._more != null && this._more.visible)
                {
                    this.setSkinState();
                    this.setChildIndex(this._sharePanel, (this.numChildren - 1));
                }
                else
                {
                    _core.pause();
                    if (stage.displayState == "fullScreen")
                    {
                        _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
                    }
                }
                SendRef.getInstance().sendPQVPC("PL_R_Share");
                try
                {
                    VerLog.msg(this._sharePanel["version"]);
                }
                catch (evt:Error)
                {
                }
            }
            return;
        }// end function

        private function showLike(param1 = null) : void
        {
            var ctx:LoaderContext;
            var evt:* = param1;
            this.streamState = _core.streamState;
            if (this._likePanel == null)
            {
                ctx = new LoaderContext();
                ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _likePanel = obj.data.content;
                    _likePanel.addEventListener(PanelEvent.READY, function (event:PanelEvent) : void
                {
                    var _loc_2:* = new Object();
                    _loc_2.width = _width;
                    _loc_2.height = _core.height - (stage.displayState == "fullScreen" ? (pbarDiff()) : (0));
                    _loc_2.vid = PlayerConfig.vid;
                    _loc_2.coverImg = PlayerConfig.coverImg;
                    _loc_2.videoTitle = PlayerConfig.videoTitle;
                    _loc_2.cid = PlayerConfig.cid;
                    _loc_2.caid = PlayerConfig.caid;
                    _loc_2.url = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
                    _loc_2.refer = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
                    _loc_2.fuid = PlayerConfig.userId;
                    _loc_2.yyid = PlayerConfig.yyid;
                    _loc_2.passport = PlayerConfig.passportMail;
                    _loc_2.sid = PlayerConfig.sid;
                    _loc_2.tvid = PlayerConfig.isMyTvVideo ? (Utils.cleanUnderline(PlayerConfig.vid)) : (PlayerConfig.tvid);
                    _loc_2.pid = PlayerConfig.vrsPlayListId;
                    _loc_2.guid = PlayerConfig.userId;
                    _loc_2.lb = PlayerConfig.lb;
                    _loc_2.isSohu = PlayerConfig.domainProperty;
                    _likePanel.init(_loc_2);
                    _core.pause();
                    if (!_showBar_boo)
                    {
                        showBar2();
                    }
                    if (_progress_sld != null)
                    {
                        _progress_sld["hideNewPreview"] = true;
                    }
                    var _loc_3:Boolean = false;
                    _skinMap.getValue("startPlayBtn").v = false;
                    _startPlay_btn.visible = _loc_3;
                    setSkinState();
                    SendRef.getInstance().sendPQVPC("PL_R_Like");
                    return;
                }// end function
                );
                    addChild(_likePanel);
                    try
                    {
                        VerLog.msg(_likePanel["version"]);
                    }
                    catch (evt:Error)
                    {
                    }
                    _likePanel.x = 0;
                    _likePanel.y = _topSideBarBg.height - 2;
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "recommendGuess.swf", ctx);
            }
            else
            {
                if (this._likePanel.visible)
                {
                    this._likePanel.visible = false;
                    if (this.streamState == "pause")
                    {
                        _core.pause();
                    }
                    else
                    {
                        _core.play();
                    }
                    if (_progress_sld != null)
                    {
                        _progress_sld["hideNewPreview"] = false;
                    }
                    var _loc_3:Boolean = true;
                    _skinMap.getValue("startPlayBtn").v = true;
                    _startPlay_btn.visible = _loc_3;
                }
                else
                {
                    this._likePanel.visible = true;
                    _core.pause();
                    if (_progress_sld != null)
                    {
                        _progress_sld["hideNewPreview"] = true;
                    }
                    var _loc_3:Boolean = false;
                    _skinMap.getValue("startPlayBtn").v = false;
                    _startPlay_btn.visible = _loc_3;
                    SendRef.getInstance().sendPQVPC("PL_R_Like");
                }
                if (!_showBar_boo)
                {
                    this.showBar2();
                }
            }
            return;
        }// end function

        public function loadMore(event:TvSohuAdsEvent = null) : void
        {
            var _loc_2:String = null;
            var _loc_3:LoaderContext = null;
            if (PlayerConfig.isHide)
            {
                this._saveIsHide = PlayerConfig.isHide;
                var _loc_4:Boolean = false;
                _isHide = false;
                PlayerConfig.isHide = _loc_4;
                this.resize(stage.stageWidth, stage.stageHeight);
            }
            if (this._playListPanel != null && this._playListPanel.isOpen)
            {
                this._playListPanel.close();
            }
            if (this._settingPanel != null && this._settingPanel.visible)
            {
                this._settingPanel.close();
            }
            if (this._more == null)
            {
                _loc_2 = PlayerConfig.isSohuDomain ? (PlayerConfig.RECOMMEND_PANEL_PATH) : (PlayerConfig.OUTRECOMMEND_PANEL_PATH);
                _loc_3 = new LoaderContext();
                _loc_3.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                new LoaderUtil().load(5, this.moreHandler, null, PlayerConfig.swfHost + _loc_2, _loc_3);
                SendRef.getInstance().sendPQVPC("PL_R_BVIEW");
            }
            else
            {
                this._more.visible = true;
                SendRef.getInstance().sendPQVPC("PL_R_BVIEW");
                if (_progress_sld != null)
                {
                    _progress_sld["hideNewPreview"] = true;
                }
                if (!_showBar_boo)
                {
                    this.showBar2();
                }
            }
            return;
        }// end function

        private function moreHandler(param1:Object) : void
        {
            var moreH:Number;
            var obj:* = param1;
            if (obj.info == "success")
            {
                this._more = obj.data.content;
                moreH;
                this._more.addEventListener(PanelEvent.READY, function (event:PanelEvent) : void
            {
                var _loc_2:* = new Object();
                _loc_2.width = _width;
                _loc_2.height = _core.height - (stage.displayState == "fullScreen" ? (pbarDiff()) : (0));
                _loc_2.vid = PlayerConfig.vid;
                _loc_2.coverImg = PlayerConfig.coverImg;
                _loc_2.videoTitle = PlayerConfig.videoTitle;
                _loc_2.cid = PlayerConfig.cid;
                _loc_2.caid = PlayerConfig.caid;
                _loc_2.url = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
                _loc_2.refer = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
                _loc_2.fuid = PlayerConfig.userId;
                _loc_2.yyid = PlayerConfig.yyid;
                _loc_2.passport = PlayerConfig.passportMail;
                _loc_2.sid = PlayerConfig.sid;
                _loc_2.tvid = PlayerConfig.isMyTvVideo ? (Utils.cleanUnderline(PlayerConfig.vid)) : (PlayerConfig.tvid);
                _loc_2.pid = PlayerConfig.vrsPlayListId;
                _loc_2.guid = PlayerConfig.userId;
                _loc_2.lb = PlayerConfig.lb;
                _loc_2.isSohu = PlayerConfig.domainProperty;
                _more.init(_loc_2);
                if (_progress_sld != null)
                {
                    _progress_sld["hideNewPreview"] = true;
                }
                if (!_showBar_boo)
                {
                    showBar2();
                }
                setSkinState();
                return;
            }// end function
            );
                this._more.addEventListener("open_share_event", function (event:Event) : void
            {
                _share_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
                return;
            }// end function
            );
                this._more.addEventListener("replay_event", function (event:Event) : void
            {
                _replay_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
                return;
            }// end function
            );
                this._more.addEventListener("SAYSAY_CLICK", function (event:Event) : void
            {
                if (stage.displayState == "fullScreen")
                {
                    _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
                }
                return;
            }// end function
            );
                addChild(this._more);
                try
                {
                    VerLog.msg(this._more["version"]);
                }
                catch (evt:Error)
                {
                }
            }
            return;
        }// end function

        private function downloadVideo(event:MouseEvent) : void
        {
            if (stage.displayState == "fullScreen")
            {
                _normalScreen_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.CLICK));
            }
            ExternalInterface.call("spxzClick", true);
            SendRef.getInstance().sendPQVPC("PL_R_Download");
            return;
        }// end function

        public function ctrlBarVisible(param1:Boolean, param2 = null) : void
        {
            var _loc_3:Boolean = false;
            this._rightSideBar.visible = false;
            var _loc_3:* = _loc_3;
            this._logoAdContainer.visible = _loc_3;
            var _loc_3:* = _loc_3;
            this._adContainer.visible = _loc_3;
            _ctrlBar_c.visible = _loc_3;
            if (this._danmu != null)
            {
                this._danmu.visible = false;
            }
            if (this._v360)
            {
                this._v360.hideCtrlBar();
            }
            var _loc_3:Boolean = true;
            _isHide = true;
            PlayerConfig.isHide = _loc_3;
            this.resize(stage.stageWidth, stage.stageHeight);
            if (param2 != null && param2 == 1)
            {
                if (!param1)
                {
                    var _loc_3:* = param1;
                    _isHide = param1;
                    PlayerConfig.isHide = _loc_3;
                }
                this.resize(stage.stageWidth, stage.stageHeight);
                var _loc_3:Boolean = true;
                this._rightSideBar.visible = true;
                var _loc_3:* = _loc_3;
                this._adContainer.visible = _loc_3;
                _ctrlBar_c.visible = _loc_3;
                if (!PlayerConfig.isBackgorundShowing)
                {
                    this._logoAdContainer.visible = true;
                }
                if (this._danmu != null)
                {
                    this._danmu.visible = true;
                }
                if (this._v360 && PlayerConfig.showV360Bar)
                {
                    this._v360.showCtrlBar();
                }
            }
            else
            {
                if (!param1)
                {
                    var _loc_3:Boolean = true;
                    _isHide = true;
                    PlayerConfig.isHide = _loc_3;
                }
                this.resize(stage.stageWidth, stage.stageHeight);
            }
            return;
        }// end function

        private function showCaptionPanel(event:MouseEvent) : void
        {
            var evt:* = event;
            if (this._captionPanel == null)
            {
                this._caption_btn.enabled = false;
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _captionPanel = obj.data.content;
                    _captionPanel.init(_owner);
                    _captionPanel.close(0);
                    _panelArr.push(_captionPanel);
                    _captionPanel.addEventListener("captionVer", function (event:Event) : void
                {
                    _captionBar.captionVer = event.target.captionVer;
                    return;
                }// end function
                );
                    _captionPanel.addEventListener("captionColor", function (event:Event) : void
                {
                    _captionBar.captionColor = event.target.captionColor;
                    return;
                }// end function
                );
                    _captionPanel.addEventListener("captionSizeRate", function (event:Event) : void
                {
                    _captionBar.captionSizeRate = event.target.captionSizeRate;
                    return;
                }// end function
                );
                    _captionPanel.addEventListener("captionAlpha", function (event:Event) : void
                {
                    _captionBar.captionAlpha = event.target.captionAlpha;
                    return;
                }// end function
                );
                    addChild(_captionPanel);
                    setSkinState();
                    _caption_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
                    ;
                }
                _caption_btn.enabled = true;
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/CaptionPanel.swf");
            }
            else if (this._captionPanel.isOpen)
            {
                this._captionPanel.close();
            }
            else if (this._preLoadPanel == null || (!this._preLoadPanel.isOpen || this._preLoadPanel.isBackgroundRun))
            {
                this.closePanel();
                this._captionPanel.open();
            }
            return;
        }// end function

        public function get captionBar()
        {
            return this._captionBar;
        }// end function

        private function tipVipCookie() : void
        {
            var _loc_4:int = 0;
            var _loc_5:String = null;
            var _loc_1:* = SharedObject.getLocal("tipIFoxVip", "/");
            var _loc_2:* = new Date();
            var _loc_3:* = _loc_2.getFullYear() + "/" + (_loc_2.getMonth() + 1) + "/" + _loc_2.getDate();
            if (_loc_1.data.date != undefined && _loc_1.data.date != "")
            {
                if (_loc_1.data.date == _loc_3)
                {
                    _loc_4 = _loc_1.data.times;
                    if (_loc_1.data.times < 3)
                    {
                        this._tipHistory.showIfoxVipTip();
                        _loc_4++;
                        _loc_1.data.times = _loc_4;
                    }
                }
                else
                {
                    this._tipHistory.showIfoxVipTip();
                    _loc_1.data.date = _loc_3;
                    _loc_1.data.times = 1;
                }
            }
            else
            {
                this._tipHistory.showIfoxVipTip();
                _loc_1.data.date = _loc_3;
                _loc_1.data.times = 1;
            }
            try
            {
                _loc_5 = _loc_1.flush();
                if (_loc_5 == SharedObjectFlushStatus.PENDING)
                {
                    _loc_1.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                }
                else if (_loc_5 == SharedObjectFlushStatus.FLUSHED)
                {
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function tipVolKeyboardCookie() : void
        {
            var _loc_1:* = SharedObject.getLocal("tipVolKeyboard", "/");
            var _loc_2:* = new Date();
            var _loc_3:* = _loc_2.getFullYear() + "-" + _loc_2.getMonth() + "-" + _loc_2.getDate();
            if (_loc_3 != String(_loc_1.data.td) && this._tipHistory != null && !this._tipHistory.isOpen && !this._tipHistory.isShowVolKeyboardTip)
            {
                this._tipHistory.showVolKeyboardTip();
            }
            return;
        }// end function

        private function tipProKeyboardCookie() : void
        {
            var _loc_1:* = SharedObject.getLocal("tipProKeyboard", "/");
            var _loc_2:* = new Date();
            var _loc_3:* = _loc_2.getFullYear() + "-" + _loc_2.getMonth() + "-" + _loc_2.getDate();
            if (_loc_3 != String(_loc_1.data.dt) && this._tipHistory != null && !this._tipHistory.isOpen && !this._tipHistory.isShowProKeyboardTip)
            {
                this._tipHistory.showProKeyboardTip();
            }
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

        override protected function startPlayMouseUp(param1:MouseEventUtil) : void
        {
            if (!PlayerConfig.autoPlay)
            {
                Model.getInstance().sendVV();
            }
            if (this._likePanel != null && this._likePanel.visible)
            {
                this._likePanel.visible = false;
            }
            if (!PlayerConfig.autoPlay && !this._mpbAutoPlay)
            {
                if (TvSohuAds.getInstance().selectorStartAd.hasAd && TvSohuAds.getInstance().selectorStartAd.state == "no")
                {
                    TvSohuAds.getInstance().selectorStartAd.play();
                }
                else if (TvSohuAds.getInstance().startAd.hasAd && !TvSohuAds.getInstance().startAd.isAutoPlayAd && TvSohuAds.getInstance().startAd.state == "no")
                {
                    TvSohuAds.getInstance().startAd.play();
                }
                dispatchEvent(new Event("ChangeAutoPlay"));
                this._mpbAutoPlay = true;
            }
            else if (!PlayerConfig.autoPlay && TvSohuAds.getInstance().startAd.isAutoPlayAd)
            {
                dispatchEvent(new Event("ChangeAutoPlay"));
                if (this._saveIsHide)
                {
                    this.replay(param1);
                }
                else
                {
                    super.startPlayMouseUp(param1);
                }
            }
            else if (this._saveIsHide)
            {
                this.replay(param1);
            }
            else
            {
                super.startPlayMouseUp(param1);
            }
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_S_PlayButton&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            return;
        }// end function

        override protected function playMouseUp(param1:MouseEventUtil) : void
        {
            if (!PlayerConfig.autoPlay)
            {
                Model.getInstance().sendVV();
            }
            if (this._likePanel != null && this._likePanel.visible)
            {
                this._likePanel.visible = false;
            }
            if (!PlayerConfig.autoPlay && TvSohuAds.getInstance().startAd.hasAd && !TvSohuAds.getInstance().startAd.isAutoPlayAd && !this._mpbAutoPlay)
            {
                TvSohuAds.getInstance().startAd.play();
                dispatchEvent(new Event("ChangeAutoPlay"));
                this._mpbAutoPlay = true;
            }
            else if (!PlayerConfig.autoPlay && TvSohuAds.getInstance().startAd.isAutoPlayAd)
            {
                dispatchEvent(new Event("ChangeAutoPlay"));
                if (this._saveIsHide)
                {
                    this.replay(param1);
                }
                else
                {
                    super.playMouseUp(param1);
                }
            }
            else if (this._saveIsHide)
            {
                this.replay(param1);
            }
            else
            {
                super.playMouseUp(param1);
            }
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Play&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            return;
        }// end function

        override protected function pauseMouseUp(param1:MouseEventUtil) : void
        {
            super.pauseMouseUp(param1);
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Pause&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            return;
        }// end function

        private function showPreLoadPanel(param1:Boolean = true) : void
        {
            var url:String;
            var backgroundRun:* = param1;
            if (this._preLoadPanel == null)
            {
                url = PlayerConfig.swfHost + "panel/PreLoadPanel.swf";
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    _preLoadPanel = param1.data.content;
                    _preLoadPanel.close(0);
                    _preLoadPanel.addEventListener("start_pre_load", startPreLoad);
                    _preLoadPanel.addEventListener("backgroundRun", preLoadPanelBGRun);
                    _preLoadPanel.addEventListener("frontrun", preLoadPanelFGRun);
                    _preLoadPanel.addEventListener("pre_load_finish", preLoadFinish);
                    _preLoadPanel.addEventListener("pre_panel_closed", _core.play);
                    _owner.addChildAt(_preLoadPanel, _owner.getChildIndex(_adContainer) - 2);
                    if (backgroundRun)
                    {
                        _preLoadPanel.toBackgroundRun();
                    }
                    if (!PlayerConfig.isCounterfeitFms)
                    {
                        _preLoadPanel.open();
                    }
                    setSkinState();
                    ;
                }
                return;
            }// end function
            , null, url);
            }
            else
            {
                if (backgroundRun)
                {
                    this._preLoadPanel.toBackgroundRun();
                }
                this._preLoadPanel.open();
            }
            return;
        }// end function

        override protected function loadProgress(param1) : void
        {
            super.loadProgress(param1);
            if (_skin != null)
            {
                if (PlayerConfig.isCounterfeitFms || PlayerConfig.startTime != "" && PlayerConfig.endTime != "")
                {
                    _progress_sld.middleRate = 0;
                }
            }
            if (this._preLoadPanel != null)
            {
                this._preLoadPanel.loadProgress(param1);
            }
            return;
        }// end function

        override public function resize(param1:Number, param2:Number) : void
        {
            var _loc_5:Number = NaN;
            param1 = param1 < 0 ? (1) : (param1);
            param2 = param2 < 0 ? (1) : (param2);
            var _loc_3:* = param1;
            var _loc_4:* = param2;
            _width = param1;
            _height = param2;
            if (_core.streamState == "pause" && PlayerConfig.isSohuDomain && !PlayerConfig.isBackgorundShowing && TvSohuAds.getInstance().backgroudAd.prepared && this._displayRate == 1 && _core.rotateType == 0 && stage.stageWidth >= 540 && stage.stageHeight >= 300)
            {
                _loc_5 = PlayerConfig.etTime > 0 ? (PlayerConfig.etTime) : (this._dummyTotTime);
                if (_loc_5 - this._dummyPlayedTime < TvSohuAds.getInstance().backgroudAd.bgAdTime)
                {
                    this.showBackGroudAd();
                    LogManager.msg("打开背景_尺寸缩放触发");
                }
            }
            else if (_core.streamState == "pause" && PlayerConfig.isSohuDomain && PlayerConfig.isBackgorundShowing && (this._stage.stageWidth < 540 || stage.stageHeight < 300))
            {
                this.hideBackGroudAd();
                this.setAdsState();
                LogManager.msg("关闭背景_尺寸缩放触发");
            }
            if (stage.displayState == "fullScreen")
            {
                if (_skin != null)
                {
                    _loc_4 = param2 - (TvSohuAds.getInstance().bottomAd.isFButtomAd ? (0) : (TvSohuAds.getInstance().bottomAd.height));
                }
            }
            else if (_isHide && _skin != null)
            {
            }
            else if (_skin != null)
            {
                _loc_4 = param2 - ctrlBarBg.height - (TvSohuAds.getInstance().bottomAd.isFButtomAd ? (0) : (TvSohuAds.getInstance().bottomAd.height));
                stopTween();
            }
            _core.resize(_loc_3, _loc_4);
            if (_cover_c.width != 0 && _cover_c.height != 0)
            {
                Utils.prorata(_cover_c, _loc_3, _loc_4);
                Utils.setCenter(_cover_c, _core);
            }
            if (this._captionBar != null)
            {
                this._captionBar.resize(_loc_3);
            }
            this.setSkinState();
            if (stage.loaderInfo.parameters["os"] == "android")
            {
                this.setAdsState();
            }
            if (this._danmu != null)
            {
                this._danmu.updateTmLayerSize(_core.width, _core.height - (stage.displayState == "fullScreen" ? (_ctrlBarBg_spr.height) : (0)));
            }
            if (this._v360)
            {
                this._v360.resize(param1, param2);
            }
            this.setTitle();
            if (PlayerConfig.isBackgorundShowing && _ctrlBarBg_spr)
            {
                TvSohuAds.getInstance().backgroudAd.resize(param1, param2 - _ctrlBarBg_spr.height, _core.videoContainer.width, _core.videoContainer.height);
            }
            return;
        }// end function

        override protected function setSkinState() : void
        {
            var obj:Object;
            var bgw:Number;
            var num:int;
            var _h:Number;
            var coreMetaWidth:Number;
            var coreMetaHeight:Number;
            var diff:Number;
            if (_skin != null)
            {
                diff = _core.width - _ctrlBarBg_spr.width;
            }
            this.setWatermark();
            if (this._timer_c != null)
            {
                this._timer_c.y = TvSohuAds.getInstance().topAd.container.height + 8;
                this._timer_c.x = _core.width - this._timer_c.width - 60;
                if (this._isViewTimer && stage.displayState == "fullScreen" && !TvSohuAds.getInstance().topLogoAd.hasAd && !(TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing"))
                {
                    this._timer_c.visible = true;
                }
                else
                {
                    this._timer_c.visible = false;
                }
            }
            if (TvSohuAds.getInstance().endAd.hasAd && TvSohuAds.getInstance().endAd.state == "playing" || TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing" || TvSohuAds.getInstance().bottomAd.hasAd && TvSohuAds.getInstance().bottomAd.isShow && _skinMap.getValue("startPlayBtn").align != "center")
            {
            }
            if (this._tipHistory != null && this._tipHistory.isOpen)
            {
                _skinMap.getValue("tipDisplay").v = false;
            }
            if (stage.displayState == "fullScreen" && this._playListPanel != null)
            {
                if (this._isPlayListOk)
                {
                    if (this._isPlayListOk && this._playListPanel.sourceLength() > 1)
                    {
                        _skinMap.getValue("nextBtn").e = this._playListPanel.hasNext() ? (true) : (false);
                        _skinMap.getValue("nextBtn").v = true;
                    }
                }
            }
            else
            {
                _skinMap.getValue("nextBtn").v = false;
            }
            super.setSkinState();
            if (_skin != null)
            {
                if (stage.displayState == "fullScreen" || PlayerConfig.isHide)
                {
                    _ctrlBarBg_spr.alpha = 0.8;
                    if (_showBar_boo)
                    {
                        _ctrlBar_c.y = _hitArea_spr.y + _hitArea_spr.height + (TvSohuAds.getInstance().bottomAd.isFButtomAd ? (0) : (TvSohuAds.getInstance().bottomAd.height)) - _ctrlBarBg_spr.height;
                    }
                    else
                    {
                        _ctrlBar_c.y = _hitArea_spr.y + _hitArea_spr.height + (TvSohuAds.getInstance().bottomAd.isFButtomAd ? (0) : (TvSohuAds.getInstance().bottomAd.height)) + 2;
                    }
                    if (this._settingPanel != null)
                    {
                        this._settingPanel.y = Math.round(_hitArea_spr.y + _hitArea_spr.height - this._settingPanel.height - _ctrlBarBg_spr.height + 1);
                    }
                }
                else
                {
                    _ctrlBarBg_spr.alpha = 1;
                    _ctrlBar_c.y = _hitArea_spr.y + _hitArea_spr.height + (TvSohuAds.getInstance().bottomAd.isFButtomAd ? (0) : (TvSohuAds.getInstance().bottomAd.height));
                    if (this._settingPanel != null)
                    {
                        this._settingPanel.y = Math.round(_hitArea_spr.y + _hitArea_spr.height - this._settingPanel.height + 1);
                    }
                }
                bgw = _ctrlBarBg_spr.width;
                obj = _skinMap.getValue("tipDisplay");
                var _loc_2:* = obj.x + (obj.r ? (diff) : (0));
                obj.x = obj.x + (obj.r ? (diff) : (0));
                _tipDisplay.x = _loc_2;
                _tipDisplay.y = obj.y;
                obj = _skinMap.getValue("tvSohuLogoBtn");
                if (PlayerConfig.isNewsLogo || PlayerConfig.channel == "s")
                {
                    var _loc_2:* = obj.x + (obj.r ? (diff) : (0));
                    obj.x = obj.x + (obj.r ? (diff) : (0));
                    this._tvSohuLogo_btn.x = _loc_2;
                    this._tvSohuLogo_btn.x = this._tvSohuLogo_btn.x - 40;
                }
                else
                {
                    var _loc_2:* = obj.x + (obj.r ? (diff) : (0));
                    obj.x = obj.x + (obj.r ? (diff) : (0));
                    this._tvSohuLogo_btn.x = _loc_2;
                }
                this._tvSohuLogo_btn.y = obj.y;
                this._tvSohuLogo_btn.visible = obj.v && bgw > obj.w;
                this._tvSohuLogo_btn.enabled = obj.e;
                obj = _skinMap.getValue("lightBar");
                if (!_fullScreen_btn.visible && !_normalScreen_btn.visible)
                {
                    this._lightBar.x = _fullScreen_btn.x + _fullScreen_btn.width - this._lightBar.width;
                }
                else
                {
                    this._lightBar.x = _fullScreen_btn.x - this._lightBar.width;
                }
                this._lightBar.visible = obj.v && bgw > obj.w;
                this._lightBar.y = obj.y;
                this._lightBar.enabled = obj.e;
                obj = _skinMap.getValue("definitionBar");
                switch(PlayerConfig.rfilesType)
                {
                    case "super":
                    {
                        break;
                    }
                    case "clear":
                    {
                        break;
                    }
                    case "normal":
                    {
                        break;
                    }
                    case "wvga":
                    {
                        break;
                    }
                    case "vga":
                    {
                        break;
                    }
                    case "qvga":
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (!this._lightBar.visible)
                {
                    this._definitionBar.x = this._lightBar.x + this._lightBar.width - this._definitionBar.width;
                }
                else
                {
                    this._definitionBar.x = this._lightBar.x - this._definitionBar.width;
                }
                this._definitionBar.visible = obj.v && bgw > obj.w;
                this._definitionBar.y = obj.y;
                this._definitionSlider.y = this._definitionBar.y - this._definitionSlider.height - 9;
                this._definitionBar.enabled = obj.e;
                obj = _skinMap.getValue("langSetBar");
                if (!this._definitionBar.visible)
                {
                    this._langSetBar.x = this._definitionBar.x + this._definitionBar.width - this._langSetBar.width;
                }
                else
                {
                    this._langSetBar.x = this._definitionBar.x - this._langSetBar.width;
                }
                this._langSetBar.visible = obj.v && bgw > obj.w;
                this._langSetBar.y = obj.y;
                this._langSetBar.enabled = obj.e;
                obj = _skinMap.getValue("volumeBar");
                if (!this._langSetBar.visible)
                {
                    _volume_sld.x = this._langSetBar.x + this._langSetBar.width - _volume_sld.width;
                }
                else
                {
                    _volume_sld.x = this._langSetBar.x - _volume_sld.width;
                }
                if (!_volume_sld.visible)
                {
                    this._barrageBtn.x = _volume_sld.x + _volume_sld.width - this._barrageBtn.width;
                }
                else
                {
                    this._barrageBtn.x = _volume_sld.x - this._barrageBtn.width;
                }
                obj = _skinMap.getValue("replayBtn");
                var _loc_2:* = obj.x + (obj.r ? (diff) : (0));
                obj.x = obj.x + (obj.r ? (diff) : (0));
                this._replay_btn.x = _loc_2;
                this._replay_btn.y = obj.y;
                this._replay_btn.visible = obj.v && bgw > obj.w;
                this._replay_btn.enabled = obj.e;
                obj = _skinMap.getValue("albumBtn");
                var _loc_2:* = obj.x + (obj.r ? (diff) : (0));
                obj.x = obj.x + (obj.r ? (diff) : (0));
                this._albumBtn.x = _loc_2;
                this._albumBtn.y = obj.y;
                if (this._playListPanel != null)
                {
                    if (this._isPlayListOk && this._playListPanel.sourceLength() > 1 && bgw)
                    {
                        if (_core.streamState != "stop")
                        {
                            var _loc_2:Boolean = true;
                            _skinMap.getValue("albumBtn").v = true;
                            _skinMap.getValue("albumBtn").e = _loc_2;
                        }
                    }
                    else
                    {
                        var _loc_2:Boolean = false;
                        _skinMap.getValue("albumBtn").v = false;
                        _skinMap.getValue("albumBtn").e = _loc_2;
                    }
                }
                else
                {
                    var _loc_2:Boolean = false;
                    _skinMap.getValue("albumBtn").v = false;
                    _skinMap.getValue("albumBtn").e = _loc_2;
                }
                this._albumBtn.visible = obj.v && bgw > obj.w;
                this._albumBtn.enabled = obj.e;
                this._albumBtn["hasBtnVis"] = PlayerConfig.domainProperty == "0" && stage.displayState != "fullScreen" ? (1) : (0);
                if (this._playListPanel != null && this._isPlayListOk && this._playListPanel.sourceLength() > 1 && this._albumBtn.btnVisNum == 1)
                {
                    this._albumBtn.onlyBtnEnabled(this._albumBtn.btnVisNum, this._playListPanel.hasNext() ? (true) : (false));
                }
                obj = _skinMap.getValue("nextBtn");
                this._next_btn.visible = obj.v;
                this._next_btn.enabled = obj.e;
                var _loc_2:* = obj.x + (obj.r ? (diff) : (0));
                obj.x = obj.x + (obj.r ? (diff) : (0));
                this._next_btn.x = _loc_2;
                this._next_btn.y = obj.y;
                obj = _skinMap.getValue("timeDisplay");
                _timeDisplay.visible = obj.v && bgw > obj.w;
                _timeDisplay.x = this._albumBtn.visible && this._next_btn.visible ? (this._next_btn.x + this._next_btn.width) : (this._albumBtn.visible ? (obj.x + (obj.r ? (diff) : (0))) : (this._albumBtn.x));
                this._normalScreen3_btn.visible = _normalScreen_btn.visible;
                this._normalScreen3_btn.enabled = _normalScreen_btn.enabled;
                this._definitionSlider.x = this._definitionBar.x - (this._definitionSlider.width - this._definitionBar.width) / 2;
                this._rightSideBar.y = Math.round(_hitArea_spr.y + _hitArea_spr.height / 3 - this._rightSideBar.height / 3 + 10);
                if (!this._firstSet)
                {
                    this._rightSideBar.x = this._rightSideBar.x + diff;
                }
                this._firstSet = false;
                this.setAdsState();
                if (this._transition_mc != null)
                {
                    Utils.setCenter(this._transition_mc, _hitArea_spr);
                }
                if (this._sharePanel != null)
                {
                    this._sharePanel.resize(_core.width, _core.height);
                    Utils.setCenter(this._sharePanel, _hitArea_spr);
                }
                if (this._playListPanel != null && this._isPlayListOk)
                {
                    this._playListPanel.resize(_core.width, _core.height - (PlayerConfig.isHide ? (0) : (this.pbarDiff())));
                    this._playListPanel.x = Math.round((_core.width - this._playListPanel.width) / 2);
                    this._playListPanel.y = Math.round(_hitArea_spr.height - this._playListPanel.height - 15 - (stage.displayState == "fullScreen" || PlayerConfig.isHide ? (_ctrlBarBg_spr.height) : (0)));
                }
                if (this._sogouPanel != null)
                {
                    Utils.setCenter(this._sogouPanel, _hitArea_spr);
                }
                if (this._flatWall3D != null)
                {
                    this._flatWall3D.resize(_core.width, _core.height - (stage.displayState == "fullScreen" ? (this.pbarDiff()) : (0)));
                }
                if (this._cueTipPanel != null)
                {
                    if (this._tipHistory.isOpen && TvSohuAds.getInstance().bottomAd.height == 0)
                    {
                        this._cueTipPanel.y = Math.round(_hitArea_spr.height - this._cueTipPanel.height - 6 - this._tipHistory.height - (stage.displayState == "fullScreen" || PlayerConfig.isHide ? (_ctrlBarBg_spr.height) : (0)));
                    }
                    else
                    {
                        this._cueTipPanel.y = Math.round(_hitArea_spr.height - this._cueTipPanel.height - 6 - (stage.displayState == "fullScreen" || PlayerConfig.isHide ? (_ctrlBarBg_spr.height) : (0)));
                    }
                    this._cueTipPanel.x = Math.round(_hitArea_spr.width - this._cueTipPanel.width - 4);
                }
                if (this._wmTipPanel != null)
                {
                    this._wmTipPanel.resize(_core.width, _core.height - (stage.displayState == "fullScreen" ? (this.pbarDiff()) : (0)));
                    if (this._isShownLogoAd)
                    {
                        this._wmTipPanel.specialResize(TvSohuAds.getInstance().logoAd.height, "right");
                    }
                    else
                    {
                        this._wmTipPanel.specialResize(0, "right");
                    }
                    if (this._isShownBottomAd)
                    {
                        this._wmTipPanel.specialResize(TvSohuAds.getInstance().bottomAd.isFButtomAd ? (TvSohuAds.getInstance().bottomAd.height) : (0), "whole");
                    }
                    else
                    {
                        this._wmTipPanel.specialResize(0, "whole");
                    }
                }
                if (this._ugcAd != null)
                {
                    this._ugcAd.setWH(stage.stageWidth, stage.stageHeight);
                    Utils.setCenter(this._ugcAd, _hitArea_spr);
                    _h = this._ugcAd.height + 22;
                    this._ugcAd.y = _core.height - (stage.displayState == "fullScreen" ? (this.pbarDiff() + _h) : (_h));
                    this.setChildIndex(this._ugcAd, (this.numChildren - 1));
                }
                if (this._hisRecommend != null)
                {
                    this._hisRecommend.x = 5;
                    if (this._tipHistory.isOpen && TvSohuAds.getInstance().bottomAd.height == 0)
                    {
                        this._hisRecommend.y = -43 - this._tipHistory.height;
                    }
                    else
                    {
                        this._hisRecommend.y = -43;
                    }
                }
                if (this._captionPanel != null)
                {
                    Utils.setCenter(this._captionPanel, _hitArea_spr);
                }
                if (this._likePanel != null)
                {
                    this._likePanel.resize(_core.width, _core.height - (stage.displayState == "fullScreen" ? (this.pbarDiff()) : (0)) - this._topSideBarBg.height);
                    if (!_showBar_boo)
                    {
                        this.showBar2();
                    }
                }
                this._topSideBarBg.width = _hitArea_spr.width;
                if (this._searchBar != null)
                {
                    this._searchBar.resize(this._topSideBarBg.width, 1);
                }
                Utils.setCenter(this._normalScreen3_btn, this._topSideBarBg);
                this._normalScreen3_btn.x = this._topSideBarBg.width - this._normalScreen3_btn.width;
                if (this._topPerSp.visible)
                {
                    Utils.setCenter(this._topPerSp, this._topSideBarBg);
                }
                if (this._preLoadPanel != null)
                {
                    if (this._preLoadPanel.isBackgroundRun)
                    {
                        if (this._tipHistory.isOpen && TvSohuAds.getInstance().bottomAd.height == 0)
                        {
                            this._preLoadPanel.y = Math.round(_hitArea_spr.height - this._preLoadPanel.height - this._tipHistory.height);
                        }
                        else
                        {
                            this._preLoadPanel.y = Math.round(_hitArea_spr.height - this._preLoadPanel.height - 3);
                        }
                        this._preLoadPanel.x = Math.round(_hitArea_spr.width - this._preLoadPanel.width);
                    }
                    else
                    {
                        Utils.setCenter(this._preLoadPanel, _hitArea_spr);
                    }
                }
                if (_skinMap.getValue("startPlayBtn").align != "center")
                {
                    _startPlay_btn.y = -_startPlay_btn.skin.bg.height - (10 + (this._tipHistory.isOpen && TvSohuAds.getInstance().bottomAd.height == 0 ? (this._tipHistory.height) : (0)));
                }
                else
                {
                    _startPlay_btn.x = Math.round(_hitArea_spr.x + (_hitArea_spr.width - _startPlay_btn.skin.bg.width) / 2);
                    _startPlay_btn.y = Math.round(_hitArea_spr.y + (_hitArea_spr.height - _startPlay_btn.skin.bg.height) / 2);
                }
                Utils.setCenter(this._retryPanel, _hitArea_spr);
                if (this._playHistoryPanel != null)
                {
                    Utils.setCenter(this._playHistoryPanel, _hitArea_spr);
                }
                Utils.setCenter(this._videoInfoPanel, _hitArea_spr);
                if (this._settingPanel != null)
                {
                    if (this._settingPanel.isSpCenter)
                    {
                        Utils.setCenter(this._settingPanel, _hitArea_spr);
                    }
                    else
                    {
                        this._settingPanel.x = Math.round(_hitArea_spr.width - this._settingPanel.width);
                    }
                }
                if (this._more != null)
                {
                    this._more.resize(_core.width, _core.height - (stage.displayState == "fullScreen" ? (this.pbarDiff()) : (0)));
                    if (!_showBar_boo)
                    {
                        this.showBar2();
                    }
                }
                if (this._highlightPanel != null)
                {
                    var _loc_2:int = 0;
                    this._highlightPanel.y = 0;
                    this._highlightPanel.x = _loc_2;
                    this._highlightPanel.resize(_width, _height);
                }
                this._tipHistory.resize(_width);
                if (PlayerConfig.topBarFull && !PlayerConfig.topBarNor)
                {
                    if (stage.displayState == "fullScreen")
                    {
                        this._topSideBar.visible = true;
                        if (this._displayRate != 0.5 && this._displayRate != 0.75 && this._displayRate != 1)
                        {
                            var _loc_2:Boolean = true;
                            this._topPer100_btn.enabled = true;
                            var _loc_2:* = _loc_2;
                            this._topPer75_btn.enabled = _loc_2;
                            this._topPer50_btn.enabled = _loc_2;
                        }
                    }
                    else
                    {
                        this._topSideBar.visible = false;
                    }
                }
                else if (PlayerConfig.topBarNor && !PlayerConfig.topBarFull)
                {
                    if (stage.displayState == "fullScreen")
                    {
                        this._topSideBar.visible = false;
                    }
                    else
                    {
                        this._topSideBar.visible = true;
                        this._topPerSp.visible = false;
                    }
                }
                else if (PlayerConfig.topBarFull && PlayerConfig.topBarNor)
                {
                    if (stage.displayState == "fullScreen" && (PlayerConfig.vrModel == "" && PlayerConfig.vrModel == "0"))
                    {
                        this._topPerSp.visible = true;
                    }
                    else
                    {
                        this._topPerSp.visible = false;
                    }
                }
                else if (!PlayerConfig.topBarFull && !PlayerConfig.topBarNor)
                {
                    this._topSideBar.visible = false;
                }
                else
                {
                    this._topSideBar.visible = false;
                }
                if (!PlayerConfig.isSohuDomain)
                {
                    if (stage.displayState == "fullScreen")
                    {
                        this._titleText.visible = true;
                        this._topPerSp.visible = PlayerConfig.vrModel == "" && PlayerConfig.vrModel == "0" ? (true) : (false);
                        if (this._displayRate != 0.5 && this._displayRate != 0.75 && this._displayRate != 1)
                        {
                            var _loc_2:Boolean = true;
                            this._topPer100_btn.enabled = true;
                            var _loc_2:* = _loc_2;
                            this._topPer75_btn.enabled = _loc_2;
                            this._topPer50_btn.enabled = _loc_2;
                        }
                        if (this._searchBar != null)
                        {
                            this._searchBar.visible = false;
                        }
                    }
                    else
                    {
                        var _loc_2:Boolean = false;
                        this._topPerSp.visible = false;
                        this._titleText.visible = _loc_2;
                        if (this._searchBar != null)
                        {
                            this._searchBar.visible = true;
                        }
                    }
                }
                if (this._topPerSp != null)
                {
                    if (this._displayRate != 0.5 && this._displayRate != 0.75 && this._displayRate != 1)
                    {
                        var _loc_2:Boolean = true;
                        this._topPer100_btn.enabled = true;
                        var _loc_2:* = _loc_2;
                        this._topPer75_btn.enabled = _loc_2;
                        this._topPer50_btn.enabled = _loc_2;
                    }
                    else if (this._displayRate == 0.5)
                    {
                        this._topPer50_btn.enabled = false;
                        var _loc_2:Boolean = true;
                        this._topPer75_btn.enabled = true;
                        this._topPer100_btn.enabled = _loc_2;
                    }
                    else if (this._displayRate == 0.75)
                    {
                        this._topPer75_btn.enabled = false;
                        var _loc_2:Boolean = true;
                        this._topPer100_btn.enabled = true;
                        this._topPer50_btn.enabled = _loc_2;
                    }
                    else if (this._displayRate == 1)
                    {
                        this._topPer100_btn.enabled = false;
                        var _loc_2:Boolean = true;
                        this._topPer75_btn.enabled = true;
                        this._topPer50_btn.enabled = _loc_2;
                    }
                    else
                    {
                        var _loc_2:Boolean = true;
                        this._topPer100_btn.enabled = true;
                        var _loc_2:* = _loc_2;
                        this._topPer75_btn.enabled = _loc_2;
                        this._topPer50_btn.enabled = _loc_2;
                    }
                }
                this.setTitle();
                this.setChildIndex(_ctrlBar_c, (this.numChildren - 1));
                if (PlayerConfig.isUgcPreview)
                {
                    _progress_sld.enabled = false;
                }
            }
            if (this._danmu != null)
            {
                var _loc_2:int = 0;
                this._danmu.y = 0;
                this._danmu.x = _loc_2;
            }
            if (PlayerConfig.isSohuDomain && stage.displayState != StageDisplayState.FULL_SCREEN)
            {
                var _loc_2:Boolean = false;
                _skinMap.getValue("barrageBtn").v = false;
                _skinMap.getValue("barrageBtn").e = _loc_2;
            }
            if (PlayerConfig.isShowTanmu && PlayerConfig.isSohuDomain && stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                _skinMap.getValue("barrageBtn").v = true;
            }
            obj = _skinMap.getValue("barrageBtn");
            if (obj && this._barrageBtn)
            {
                this._barrageBtn.visible = obj.v && bgw > obj.w;
                this._barrageBtn.y = obj.y;
                this._barrageBtn.enabled = obj.e;
            }
            if (_skin != null && (TvSohuAds.getInstance().startAd.state == "playing" || TvSohuAds.getInstance().endAd.state == "playing" || TvSohuAds.getInstance().middleAd.state == "playing" || TvSohuAds.getInstance().selectorStartAd.state == "playing"))
            {
                _progress_sld["isAdMode"] = true;
                _progress_sld.enabled = false;
                _play_btn.enabled = false;
                _pause_btn.enabled = false;
                _tipDisplay.visible = false;
                this._lightBar.enabled = false;
                this._definitionBar.enabled = false;
                this._langSetBar.enabled = false;
                var _loc_2:Boolean = false;
                this._albumBtn.visible = false;
                this._albumBtn.enabled = _loc_2;
                this._barrageBtn.enabled = false;
                _startPlay_btn.visible = false;
            }
            if (this._mofunengPanel != null)
            {
                this._mofunengPanel.resize(_core.width, _core.height);
            }
            if (this._licenseText != null)
            {
                coreMetaWidth = _core.videoContainer.width;
                coreMetaHeight = _core.videoContainer.height;
                this._licenseText.x = _core.videoContainer.x + coreMetaWidth - this._licenseText.width - 10;
                this._licenseText.y = _core.videoContainer.y + coreMetaHeight - this._licenseText.height - 10;
            }
            return;
        }// end function

        public function get preLoadPanel()
        {
            return this._preLoadPanel;
        }// end function

        public function get videoInfoPanel() : VideoInfoPanel
        {
            return this._videoInfoPanel;
        }// end function

        public function get isJumpEndCaption() : Boolean
        {
            return this._isJumpEndCaption;
        }// end function

        public function get isJumpStartCaption() : Boolean
        {
            return this._isJumpStartCaption;
        }// end function

        public function get isShownPauseAd() : Boolean
        {
            return this._isShownPauseAd;
        }// end function

        public function get isViewTimer() : Boolean
        {
            return this._isViewTimer;
        }// end function

        public function set isJumpEndCaption(param1:Boolean) : void
        {
            this._isJumpEndCaption = param1;
            return;
        }// end function

        public function set isSwitchVideos(param1:Boolean) : void
        {
            this._isSwitchVideos = param1;
            return;
        }// end function

        public function set isViewTimer(param1:Boolean) : void
        {
            this._isViewTimer = param1;
            if (this._timer_c != null)
            {
                this._timer_c.visible = this._isViewTimer && stage.displayState == "fullScreen" && !TvSohuAds.getInstance().topLogoAd.hasAd && !(TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing");
            }
            return;
        }// end function

        public function set isJumpStartCaption(param1:Boolean) : void
        {
            this._isJumpStartCaption = param1;
            return;
        }// end function

        override protected function registerUi() : void
        {
            super.registerUi();
            register("shareBtn", {e:false, v:true});
            register("miniWinBtn", {e:false, v:true});
            register("tvSohuLogoBtn", {e:true, v:true});
            register("ctrlBarAd", {e:true, v:true});
            register("replayBtn", {e:false, v:false});
            register("nextBtn", {e:false, v:PlayerConfig.playListId == "" ? (false) : (true)});
            register("definitionBar", {e:false, v:true});
            register("langSetBar", {e:false, v:PlayerConfig.showLangSetBtn});
            register("albumBtn", {e:false, v:false});
            var _loc_1:* = PlayerConfig.isShowTanmu && (!PlayerConfig.isSohuDomain || PlayerConfig.isSohuDomain && stage.displayState == StageDisplayState.FULL_SCREEN);
            register("barrageBtn", {e:false, v:_loc_1});
            _skinMap.getValue("volumeBar").e = true;
            _skinMap.getValue("volumeBar").v = true;
            return;
        }// end function

        override protected function drawSkin() : void
        {
            var arr:Array;
            var i:uint;
            var vSkins_obj:Object;
            var multiBtnSkinArr:Array;
            var t:ButtonUtil;
            var t_show:Boolean;
            var j:*;
            var cap:Array;
            var sc:String;
            var nc:String;
            var ec:String;
            var cec:String;
            var w:uint;
            arr = _skinMap.keys();
            i;
            while (i < arr.length)
            {
                
                var _loc_2:int = 0;
                var _loc_3:* = _skin.status[arr[i]];
                while (_loc_3 in _loc_2)
                {
                    
                    j = _loc_3[_loc_2];
                    _skinMap.getValue(arr[i])[j] = _skin.status[arr[i]][j];
                }
                i = (i + 1);
            }
            _ctrlBarBg_spr = _skin["ctrlBg_mc"];
            _ctrlBarBg_spr.x = 0;
            _ctrlBarBg_spr.y = 0;
            _hitArea_spr = new Sprite();
            Utils.drawRect(_hitArea_spr, 0, 0, _width, _height, 0, 1);
            _hitArea_spr.alpha = 0;
            _hitArea_spr.doubleClickEnabled = true;
            var _loc_2:Boolean = true;
            _hitArea_spr.useHandCursor = true;
            _hitArea_spr.buttonMode = _loc_2;
            _play_btn = new ButtonUtil({skin:_skin["play_btn"], showTip:true});
            _startPlay_btn = new ButtonUtil({skin:_skin["startPlay_btn"]});
            _pause_btn = new ButtonUtil({skin:_skin["pause_btn"], showTip:true});
            this._replay_btn = new ButtonUtil({skin:_skin["replay_btn"], showTip:true});
            _fullScreen_btn = new ButtonUtil({skin:_skin["fullScreen_btn"], showTip:true});
            _normalScreen_btn = new ButtonUtil({skin:_skin["normalScreen_btn"], showTip:true});
            this._normalScreen3_btn = new ButtonUtil({skin:_skin["normalScreen3_btn"]});
            this._topPer50_btn = new ButtonUtil({skin:_skin["topPer50"]});
            this._topPer75_btn = new ButtonUtil({skin:_skin["topPer75"]});
            this._topPer100_btn = new ButtonUtil({skin:_skin["topPer100"]});
            this._tvSohuLogo_btn = PlayerConfig.channel == "s" ? (new ButtonUtil({skin:_skin["sportsLogo_btn"], showTip:true})) : (PlayerConfig.isNewsLogo ? (new ButtonUtil({skin:_skin["tvSohuNewLogo_btn"], showTip:true})) : (new ButtonUtil({skin:_skin["tvSohuLogo_btn"], showTip:true})));
            _timeDisplay = _skin["time_mc"];
            _tipDisplay = _skin["status_mc"];
            var dollop_btn:* = new ButtonUtil({skin:_skin["pro_btn"]});
            var forward_btn:* = new ButtonUtil({skin:_skin["forward_btn"]});
            var back_btn:* = new ButtonUtil({skin:_skin["back_btn"]});
            var dotClass:* = _skinLoaderInfo.applicationDomain.getDefinition("Dot") as Class;
            var sSkins_obj:Object;
            _progress_sld = new TvSohuSliderPreview({skin:sSkins_obj, isDrag:_isDrag});
            if (PlayerConfig.isLive)
            {
                _progress_sld.height = 0;
            }
            var muteVol_btn:* = new ButtonUtil({skin:_skin["muteVol_btn"]});
            var comebackVol_btn:* = new ButtonUtil({skin:_skin["comebackVol_btn"]});
            var dollopVol_btn:* = new ButtonUtil({skin:_skin["dollopVol_btn"]});
            var addVol_btn:* = new ButtonUtil({skin:_skin["addVol_btn"]});
            var subVol_btn:* = new ButtonUtil({skin:_skin["subVol_btn"]});
            vSkins_obj;
            _volume_sld = new TvSohuVolumeBar({skin:vSkins_obj, isDrag:true, isVertical:_skinMap.getValue("volumeBar").isVertical, sliderY:_skinMap.getValue("volumeBar").y});
            this._lightBar = new ButtonUtil({skin:_skin["light_btn"], showTip:true});
            multiBtnSkinArr = new Array();
            if (!PlayerConfig.is56)
            {
                multiBtnSkinArr;
            }
            else
            {
                multiBtnSkinArr;
            }
            this._definitionBar = new TvSohuMultiButton({arrSkin:multiBtnSkinArr});
            this._definitionSlider = PlayerConfig.is56 ? (new DefinitionSettingPanelFor56({skin:_skin["definition_slider"]})) : (new DefinitionSettingPanel({skin:_skin["definition_slider"]}));
            this._langSetBar = new TvSohuButton({skin:_skin["langSet_btn"]});
            this._albumBtn = new TvSohuMultiButton({arrSkin:[_skin["album_btn"], _skin["next_btn2"]]});
            this._barrageBtn = new TvSohuButton({skin:_skin["barrage_btn"], showTip:false});
            _ctrlBar_c = new Sprite();
            this._ctrlBtn_sp = new Sprite();
            TvSohuAds.getInstance().backgroudAd.adIconClass = _skinLoaderInfo.applicationDomain.getDefinition("adIcon") as Class;
            if (PlayerConfig.cap != null && PlayerConfig.cap.length > 0)
            {
                cap = PlayerConfig.cap;
                sc;
                nc;
                ec;
                cec;
                w;
                while (w < cap.length)
                {
                    
                    if (cap[w].ver == "1")
                    {
                        sc = cap[w].cpath;
                    }
                    else if (cap[w].ver == "2")
                    {
                        nc = cap[w].cpath;
                    }
                    else if (cap[w].ver == "3")
                    {
                        ec = cap[w].cpath;
                    }
                    else if (cap[w].ver == "4")
                    {
                        cec = cap[w].cpath;
                    }
                    w = (w + 1);
                }
                this._captionBar = new CaptionBar(sc, nc, ec, cec);
                if (PlayerConfig.hcap == "0")
                {
                    this._captionBar.captionVer = cap[0].ver;
                }
            }
            this.setLicense();
            addChild(_hitArea_spr);
            addChild(this._logoAdContainer);
            this._danmuTimer.addEventListener(TimerEvent.TIMER, this.danmTimerHandler);
            this._danmuTimer.start();
            if (this._captionBar != null)
            {
                addChild(this._captionBar);
            }
            _ctrlBar_c.addChild(_ctrlBarBg_spr);
            this._tipHistory = new TipHistory(_skin["tipHistoryPanel"]);
            this._tipHistory.x = 0;
            this._tipHistory.y = _progress_sld.y - _progress_sld.height - this._tipHistory.height + 2;
            _ctrlBar_c.addChild(_progress_sld);
            _ctrlBar_c.addChild(this._tipHistory);
            _ctrlBar_c.addChild(this._ctrlBtn_sp);
            this._ctrlBtn_sp.addChild(this._tvSohuLogo_btn);
            this._ctrlBtn_sp.addChild(this._replay_btn);
            this._ctrlBtn_sp.addChild(_pause_btn);
            this._ctrlBtn_sp.addChild(_play_btn);
            this._ctrlBtn_sp.addChild(_normalScreen_btn);
            this._ctrlBtn_sp.addChild(_fullScreen_btn);
            this._ctrlBtn_sp.addChild(this._langSetBar);
            this._ctrlBtn_sp.addChild(this._definitionBar);
            this._ctrlBtn_sp.addChild(this._lightBar);
            this._ctrlBtn_sp.addChild(this._definitionSlider);
            this._ctrlBtn_sp.addChild(_volume_sld);
            this._ctrlBtn_sp.addChild(this._barrageBtn);
            this._ctrlBtn_sp.addChild(this._albumBtn);
            this._ctrlBtn_sp.addChild(_timeDisplay);
            if (_skinMap.getValue("startPlayBtn").align == "center")
            {
                addChild(_startPlay_btn);
            }
            else
            {
                _ctrlBar_c.addChild(_startPlay_btn);
            }
            addChild(_ctrlBar_c);
            this._definitionSlider.visible = false;
            _ctrlBar_c.addChild(this._ctrlAdContainer);
            _ctrlBar_c.addChild(this._bottomAdContainer);
            _ctrlBar_c.addChildAt(this._bottomAdContainer, 0);
            _ctrlBar_c.addChildAt(this._sogouAdContainer, 0);
            this._rightSideBar = new Sprite();
            this._share_btn = new ButtonUtil({skin:_skin["share_btn"]});
            this._download_btn = new ButtonUtil({skin:_skin["download_btn"]});
            this._miniWin_btn = new ButtonUtil({skin:_skin["miniWin_btn"]});
            this._sogou_btn = new ButtonUtil({skin:_skin["sogou_btn"]});
            this._turnOnWider_btn = new ButtonUtil({skin:_skin["turnOnWider_btn"]});
            this._turnOffWider_btn = new ButtonUtil({skin:_skin["turnOffWider_btn"]});
            this._next_btn = new ButtonUtil({skin:_skin["next_btn"]});
            this._caption_btn = new ButtonUtil({skin:_skin["caption_btn"]});
            this._rightBarBg = _skin["rightBarBg_mc"];
            var _loc_2:int = 0;
            this._rightBarBg.y = 0;
            this._rightBarBg.x = _loc_2;
            this._rightSideBar.addChild(this._rightBarBg);
            this._rightSideBar.addChild(this._share_btn);
            this._rightSideBar.addChild(this._download_btn);
            this._rightSideBar.addChild(this._miniWin_btn);
            this._rightSideBar.addChild(this._sogou_btn);
            this._rightSideBar.addChild(this._caption_btn);
            this._rightSideBar.addChild(this._turnOnWider_btn);
            this._rightSideBar.addChild(this._turnOffWider_btn);
            this._topSideBar = new Sprite();
            this._topSideBarBg = new Sprite();
            this._topPerSp = new Sprite();
            this._topSideBarBg = _skin["title_newBg"];
            this._topSideBarBg.width = _width;
            var _loc_2:int = 0;
            this._topSideBarBg.x = 0;
            this._topSideBarBg.y = _loc_2;
            addChild(this._rightSideBar);
            this._ctrlBtn_sp.addChild(this._next_btn);
            this._ctrlShow = new Bitmap();
            _ctrlBar_c.addChild(this._ctrlShow);
            this._transition_mc = _skin["transition_mc"];
            this._transition_mc.visible = false;
            addChild(this._transition_mc);
            t;
            var _loc_2:int = 0;
            this._turnOffWider_btn.x = 0;
            var _loc_2:* = _loc_2;
            this._turnOnWider_btn.x = _loc_2;
            var _loc_2:* = _loc_2;
            this._sogou_btn.x = _loc_2;
            var _loc_2:* = _loc_2;
            this._miniWin_btn.x = _loc_2;
            var _loc_2:* = _loc_2;
            this._download_btn.x = _loc_2;
            this._share_btn.x = _loc_2;
            this._share_btn.y = t != null ? (t.y + t.height) : (0);
            this._share_btn.visible = PlayerConfig.showShareBtn;
            if (PlayerConfig.showShareBtn)
            {
                t = this._share_btn;
            }
            var _loc_2:* = t != null ? (t.y + t.height) : (0);
            this._turnOffWider_btn.y = t != null ? (t.y + t.height) : (0);
            this._turnOnWider_btn.y = _loc_2;
            this._turnOnWider_btn.visible = PlayerConfig.showWiderBtn;
            this._turnOffWider_btn.visible = false;
            if (PlayerConfig.showWiderBtn)
            {
                t = this._turnOnWider_btn;
            }
            this._miniWin_btn.y = t != null ? (t.y + t.height) : (0);
            this._miniWin_btn.visible = PlayerConfig.showMiniWinBtn;
            if (PlayerConfig.showMiniWinBtn)
            {
                t = this._miniWin_btn;
            }
            this._caption_btn.y = t != null ? (t.y + t.height) : (0);
            this._caption_btn.visible = PlayerConfig.cap != null && PlayerConfig.cap.length > 0 && !(PlayerConfig.cap.length == 1 && PlayerConfig.cap[0].ver == PlayerConfig.hcap);
            if (this._caption_btn.visible)
            {
                t = this._caption_btn;
            }
            this._download_btn.y = t != null ? (t.y + t.height) : (0);
            this._download_btn.visible = false;
            if (!PlayerConfig.isFms && !PlayerConfig.isCounterfeitFms && PlayerConfig.idDownload)
            {
                if (PlayerConfig.showDownloadBtn)
                {
                    this._download_btn.visible = true;
                    t = this._download_btn;
                }
                if (Eif.available)
                {
                    ExternalInterface.call("showDownload");
                }
            }
            this._sogou_btn.y = t != null ? (t.y + t.height) : (0);
            var re:* = /SE \d+\.X""SE \d+\.X/g;
            if (Eif.available && PlayerConfig.showSogouBtn)
            {
                this._sogou_btn.visible = true;
            }
            else
            {
                this._sogou_btn.visible = false;
            }
            this._rightBarBg.height = this._rightSideBar.height - (!this._sogou_btn.visible ? (this._sogou_btn.height) : (0));
            this._rightBarBg.visible = this._rightBarBg.height < this._sogou_btn.height ? (false) : (true);
            this._rightSideBar.x = _hitArea_spr.width - this._rightSideBar.width;
            this._titleText = new TextField();
            this._titleText.autoSize = TextFieldAutoSize.LEFT;
            this._topSideBar.addChild(this._topSideBarBg);
            this._topSideBar.addChild(this._titleText);
            this._titleText.x = 3;
            this._titleText.y = Math.round(this._topSideBarBg.y + (this._topSideBarBg.height - this._titleText.height) / 2) - 15;
            var _lableText:* = new TextField();
            _lableText.autoSize = TextFieldAutoSize.LEFT;
            var fat2:* = new TextFormat();
            fat2.size = 14;
            fat2.color = 15132390;
            fat2.font = PlayerConfig.MICROSOFT_YAHEI;
            _lableText.text = "画面尺寸";
            _lableText.setTextFormat(fat2);
            this._topPerSp.addChild(_lableText);
            this._topPerSp.addChild(this._topPer50_btn);
            this._topPerSp.addChild(this._topPer75_btn);
            this._topPerSp.addChild(this._topPer100_btn);
            _lableText.width = 100;
            _lableText.height = 20;
            _lableText.x = 0;
            _lableText.y = Math.round(this._topSideBarBg.y + (this._topSideBarBg.height - _lableText.height) / 2) - 13.5;
            this._topPer50_btn.x = _lableText.x + _lableText.width + 10;
            this._topPer75_btn.x = this._topPer50_btn.x + this._topPer50_btn.width + 20;
            this._topPer100_btn.x = this._topPer75_btn.x + this._topPer75_btn.width + 20;
            var _loc_2:* = Math.round(this._topSideBarBg.y + (this._topSideBarBg.height - this._topPer50_btn.height) / 2) - 9;
            this._topPer100_btn.y = Math.round(this._topSideBarBg.y + (this._topSideBarBg.height - this._topPer50_btn.height) / 2) - 9;
            var _loc_2:* = _loc_2;
            this._topPer75_btn.y = _loc_2;
            this._topPer50_btn.y = _loc_2;
            this._topPer100_btn.enabled = false;
            this._topSideBar.addChild(this._topPerSp);
            this.setTitle();
            if (!PlayerConfig.isSohuDomain)
            {
                new LoaderUtil().load(20, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    _searchBar = param1.data.content;
                    _searchBar.init(_topSideBarBg.width, PlayerConfig);
                    var _loc_2:int = 0;
                    _searchBar.y = 0;
                    _searchBar.x = _loc_2;
                    _searchBar.addEventListener(PanelEvent.OPEN_LIKE_PANEL, showLike);
                    _topSideBar.addChild(_searchBar);
                }
                else
                {
                    _titleText.visible = true;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/SearchAndShareForTop.swf");
            }
            this._topSideBar.addChild(this._normalScreen3_btn);
            addChild(_tipDisplay);
            addChild(this._topSideBar);
            this._retryPanel = new RetryPanel(_skin["retryPanel"]);
            this._videoInfoPanel = new VideoInfoPanel(_skin["videoInfoPanel"], this);
            this._videoInfoPanel.close(0);
            this._retryPanel.close();
            addChild(this._retryPanel);
            addChild(this._videoInfoPanel);
            this._timer_c = new Sprite();
            addChild(this._timer_c);
            this._panelArr.push(this._videoInfoPanel);
            this.setChildIndex(this._adContainer, (this.numChildren - 1));
            this.setChildIndex(_ctrlBar_c, (this.numChildren - 1));
            this.setChildIndex(this._transition_mc, (this.getChildIndex(this._adContainer) - 1));
            if (PlayerConfig.domainProperty == "2" || !PlayerConfig.isSohuDomain)
            {
                _skinMap.getValue("volumeBar").x = _skinMap.getValue("volumeBar").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("volumeBar").w = _skinMap.getValue("volumeBar").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("lightBar").x = _skinMap.getValue("lightBar").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("lightBar").w = _skinMap.getValue("lightBar").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("definitionBar").x = _skinMap.getValue("definitionBar").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("definitionBar").w = _skinMap.getValue("definitionBar").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("langSetBar").x = _skinMap.getValue("langSetBar").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("langSetBar").w = _skinMap.getValue("langSetBar").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("fullScreenBtn").x = _skinMap.getValue("fullScreenBtn").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("fullScreenBtn").w = _skinMap.getValue("fullScreenBtn").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("normalScreenBtn").x = _skinMap.getValue("normalScreenBtn").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("normalScreenBtn").w = _skinMap.getValue("normalScreenBtn").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("albumBtn").w = _skinMap.getValue("albumBtn").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("timeDisplay").w = _skinMap.getValue("timeDisplay").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("barrageBtn").x = _skinMap.getValue("barrageBtn").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("barrageBtn").w = _skinMap.getValue("barrageBtn").w + this._tvSohuLogo_btn.width;
            }
            else if (PlayerConfig.isNewsLogo || PlayerConfig.channel == "s")
            {
                _skinMap.getValue("volumeBar").x = _skinMap.getValue("volumeBar").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("volumeBar").w = _skinMap.getValue("volumeBar").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("lightBar").x = _skinMap.getValue("lightBar").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("lightBar").w = _skinMap.getValue("lightBar").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("definitionBar").x = _skinMap.getValue("definitionBar").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("definitionBar").w = _skinMap.getValue("definitionBar").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("langSetBar").x = _skinMap.getValue("langSetBar").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("langSetBar").w = _skinMap.getValue("langSetBar").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("fullScreenBtn").x = _skinMap.getValue("fullScreenBtn").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("fullScreenBtn").w = _skinMap.getValue("fullScreenBtn").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("normalScreenBtn").x = _skinMap.getValue("normalScreenBtn").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("normalScreenBtn").w = _skinMap.getValue("normalScreenBtn").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("albumBtn").w = _skinMap.getValue("albumBtn").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("timeDisplay").w = _skinMap.getValue("timeDisplay").w + this._tvSohuLogo_btn.width;
                _skinMap.getValue("barrageBtn").x = _skinMap.getValue("barrageBtn").x - this._tvSohuLogo_btn.width;
                _skinMap.getValue("barrageBtn").w = _skinMap.getValue("barrageBtn").w + this._tvSohuLogo_btn.width;
            }
            else
            {
                _skinMap.getValue("tvSohuLogoBtn").v = false;
            }
            t_show = PlayerConfig.isShowTanmu && (!PlayerConfig.isSohuDomain || PlayerConfig.isSohuDomain && stage.displayState == StageDisplayState.FULL_SCREEN);
            if (!t_show)
            {
                _skinMap.getValue("albumBtn").w = _skinMap.getValue("albumBtn").w - this._barrageBtn.width;
            }
            this.resize(_width, _height);
            if (PlayerConfig.isUgcPreview)
            {
                this.showMiniProgress();
            }
            return;
        }// end function

        private function danmTimerHandler(event:TimerEvent) : void
        {
            if (this._danmu != null)
            {
                if (PlayerConfig.vrModel == "1" || PlayerConfig.vrModel == "2")
                {
                    this._owner.setChildIndex(this._danmu, this._owner.getChildIndex(_hitArea_spr) + 2);
                    this._owner.setChildIndex(this._rightSideBar, this._owner.getChildIndex(_hitArea_spr) + 3);
                }
                else
                {
                    this._owner.setChildIndex(this._danmu, (this._owner.getChildIndex(_hitArea_spr) + 1));
                    this._owner.setChildIndex(this._rightSideBar, this._owner.getChildIndex(_hitArea_spr) + 2);
                }
                if (PlayerConfig.allTimeLogo)
                {
                    this._owner.setChildIndex(this._logoAdContainer, this._owner.getChildIndex(this._danmu));
                }
                else
                {
                    this._owner.setChildIndex(this._logoAdContainer, this._owner.getChildIndex(this._rightSideBar));
                }
                this._danmuTimer.stop();
                this._danmuTimer.removeEventListener(TimerEvent.TIMER, this.danmTimerHandler);
                this._danmuTimer = null;
            }
            return;
        }// end function

        public function closePanel() : void
        {
            var _loc_1:uint = 0;
            if (this._panelArr != null && this._panelArr.length > 0)
            {
                while (_loc_1 < this._panelArr.length)
                {
                    
                    this._panelArr[_loc_1].close();
                    _loc_1 = _loc_1 + 1;
                }
            }
            return;
        }// end function

        public function get sharePanel2()
        {
            return this._sharePanel;
        }// end function

        public function get lightRate() : Number
        {
            return this._lightRate;
        }// end function

        public function get contrastRate() : Number
        {
            return this._contrastRate;
        }// end function

        public function get saturationRate() : Number
        {
            return this._saturationRate;
        }// end function

        public function get topSideBar()
        {
            return this._topSideBar;
        }// end function

        public function get topPerSp()
        {
            return this._topPerSp;
        }// end function

        override protected function loadSkin(param1:String = "") : void
        {
            var _hitArea:Sprite;
            var url:* = param1;
            if (PlayerConfig.skinNum != "-1")
            {
                super.loadSkin(url);
            }
            else if (stage.loaderInfo.parameters["os"] == "android")
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var android:*;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    android = obj.data.content;
                    addChildAt(android, 0);
                    android.hardInit({width:stage.stageWidth, height:stage.stageHeight, c:_core, isHide:true, hardInitHandler:function (param1:Object) : void
                {
                    return;
                }// end function
                , skinPath:""});
                }
                _hardInitHandler({info:"success"});
                return;
            }// end function
            , null, PlayerConfig.swfHost + "other/android.swf");
            }
            else
            {
                _hardInitHandler({info:"success"});
                _core.addEventListener(MediaEvent.PLAY_PROGRESS, this.noSkinPlayProgress);
                _hitArea = new Sprite();
                Utils.drawRect(_hitArea, 0, 0, _width, _height, 0, 1);
                _hitArea.alpha = 0;
                addChild(_hitArea);
            }
            return;
        }// end function

        override protected function skinHandler(param1:Object) : void
        {
            var _loc_2:String = null;
            PlayerConfig.skinLoadTime = PlayerConfig.skinLoadTime + param1.target.spend;
            super.skinHandler(param1);
            if (param1.info == "success")
            {
                if (TvSohuAds.getInstance().startAd.hasAd && TvSohuAds.getInstance().startAd.state == "playing")
                {
                }
                if (TvSohuAds.getInstance().ctrlBarAd.hasAd)
                {
                    TvSohuAds.getInstance().ctrlBarAd.play();
                }
                else
                {
                    TvSohuAds.getInstance().ctrlBarAd.pingback();
                }
                this.setAdsState();
                this.startSideTween();
                dispatchEvent(new Event("skinLoadSuccess"));
            }
            else if (this._loadSkinRetryNum > 0)
            {
                var _loc_3:String = this;
                var _loc_4:* = this._loadSkinRetryNum - 1;
                _loc_3._loadSkinRetryNum = _loc_4;
                _loc_2 = _skinPath;
                _skinPath = "";
                this.loadSkin(_loc_2 + "?t=" + Math.random());
            }
            else
            {
                ErrorSenderPQ.getInstance().sendPQStat({error:1, allno:0, code:PlayerConfig.SKIN_CODE, utime:0, dom:_skinPath});
                _hardInitHandler({info:"success"});
            }
            return;
        }// end function

        override protected function onStart(event:Event = null) : void
        {
            var _loc_3:Boolean = false;
            var _loc_4:String = null;
            if (Eif.available && PlayerConfig.hasApi && !this._isFbChecked)
            {
                this._isFbChecked = true;
                _loc_4 = ExternalInterface.call("playStart");
                PlayerConfig.isBrowserFullScreen = _loc_4 == "1" ? (true) : (false);
            }
            var _loc_2:* = PlayerConfig.isBrowserFullScreen;
            var _loc_5:* = PlayerConfig.showMiniWinBtn;
            _skinMap.getValue("miniWinBtn").v = PlayerConfig.showMiniWinBtn;
            _skinMap.getValue("miniWinBtn").e = _loc_5;
            var _loc_5:Boolean = true;
            _skinMap.getValue("lightBar").v = true;
            _skinMap.getValue("lightBar").e = _loc_5;
            var _loc_5:Boolean = true;
            _skinMap.getValue("definitionBar").v = true;
            _skinMap.getValue("definitionBar").e = _loc_5;
            var _loc_5:* = PlayerConfig.showLangSetBtn;
            _skinMap.getValue("langSetBar").v = PlayerConfig.showLangSetBtn;
            _skinMap.getValue("langSetBar").e = _loc_5;
            var _loc_5:Boolean = false;
            _skinMap.getValue("albumBtn").v = false;
            _skinMap.getValue("albumBtn").e = _loc_5;
            _loc_3 = PlayerConfig.isShowTanmu && (!PlayerConfig.isSohuDomain || PlayerConfig.isSohuDomain && stage.displayState == StageDisplayState.FULL_SCREEN);
            var _loc_5:* = _loc_3;
            _skinMap.getValue("barrageBtn").v = _loc_3;
            _skinMap.getValue("barrageBtn").e = _loc_5;
            var _loc_5:* = stage.displayState == "fullScreen" ? (false) : (true);
            _skinMap.getValue("fullScreenBtn").e = stage.displayState == "fullScreen" ? (false) : (true);
            _skinMap.getValue("fullScreenBtn").v = _loc_5;
            var _loc_5:* = stage.displayState == "fullScreen" ? (true) : (false);
            _skinMap.getValue("normalScreenBtn").e = stage.displayState == "fullScreen" ? (true) : (false);
            _skinMap.getValue("normalScreenBtn").v = _loc_5;
            super.onStart();
            _skinMap.getValue("replayBtn").e = true;
            if (PlayerConfig.vrModel == "1" || PlayerConfig.vrModel == "2")
            {
                this.showV360();
            }
            return;
        }// end function

        private function showV360() : void
        {
            if (this._v360)
            {
                this._v360.visible = true;
            }
            else if (!this._v360Loading)
            {
                _core.videoContainer.visible = false;
                this._v360Loading = true;
                new LoaderUtil().load(20, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _v360 = obj.data.content;
                    var _loc_3:int = 0;
                    _v360.y = 0;
                    _v360.x = _loc_3;
                    addChildAt(_v360, (_owner.getChildIndex(_hitArea_spr) + 1));
                    _v360Tnum = setInterval(function () : void
                {
                    if (_core.metaWidth != 0 && _core.metaHeight != 0)
                    {
                        clearInterval(_v360Tnum);
                        _v360.init({width:_core.width, height:_core.height, core:_core, vr:PlayerConfig.vrModel});
                        if (!PlayerConfig.showV360Bar)
                        {
                            _v360.hideSwitchBar();
                        }
                        _core.videoContainer.visible = true;
                    }
                    return;
                }// end function
                , 50);
                    if (_danmu != null)
                    {
                        _owner.setChildIndex(_danmu, _owner.getChildIndex(_hitArea_spr) + 2);
                        _owner.setChildIndex(_rightSideBar, _owner.getChildIndex(_hitArea_spr) + 3);
                        if (PlayerConfig.allTimeLogo)
                        {
                            _owner.setChildIndex(_logoAdContainer, _owner.getChildIndex(_danmu));
                        }
                        else
                        {
                            _owner.setChildIndex(_logoAdContainer, _owner.getChildIndex(_rightSideBar));
                        }
                    }
                    LogManager.msg("v360_metaW_H:" + _core.metaWidth + "," + _core.metaHeight);
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/V360.swf");
            }
            return;
        }// end function

        override protected function bufferEmpty(event:Event) : void
        {
            var _loc_2:Number = NaN;
            _loc_2 = _core.filePlayedTime;
            if (this._bfTotNum.length <= 0)
            {
                this._bfTotNum.push(0);
            }
            if (Eif.available)
            {
                ExternalInterface.call("flv_playerEvent", "onbuffering");
            }
            if (Math.abs(_loc_2 - this._bfTotNum[(this._bfTotNum.length - 1)]) >= _core.ns.bufferTime)
            {
                super.bufferEmpty(event);
                this.mediaConnecting({});
                if (!PlayerConfig.isLive && !this._isPreLoadPanel && !PlayerConfig.isFms)
                {
                    this._bfTotNum.push(_loc_2);
                    if (this._bfTotNum.length == 3 && !_core.lastoutBuffer && _skin != null)
                    {
                        if (!P2PExplorer.getInstance().hasP2P)
                        {
                            if (PlayerConfig.isp == "2" && PlayerConfig.area == "40" && Utils.getBrowserCookie("fee_channel") != "3")
                            {
                                this._tipHistory.showNewAddSpeedTip();
                            }
                            else
                            {
                                this._tipHistory.showAddSpeedTip();
                            }
                            this.resetBuffNum();
                        }
                        ErrorSenderPQ.getInstance().sendPQStat({code:PlayerConfig.PRELOAD_SHOWN_CODE});
                    }
                    if (!this._resetTimeLimit.running)
                    {
                        this._resetTimeLimit.start();
                    }
                }
                else if (PlayerConfig.autoFix == "1")
                {
                    if (this._bfTotNum.length >= 2 && this._isPreLoadPanel && PlayerConfig.isHd && PlayerConfig.relativeId != "" && _skin != null && !this._tipHistory.isShowHdToCommonTip)
                    {
                        this.resetBuffNum();
                    }
                    else if (this._bfTotNum.length < 2)
                    {
                        this._bfTotNum.push(_loc_2);
                    }
                }
                else
                {
                    this.resetBuffNum();
                }
            }
            if (!PlayerConfig.isFms && !PlayerConfig.isCounterfeitFms && !PlayerConfig.isLive && PlayerConfig.showIFoxBar && TvSohuAds.getInstance().sogouAd.hasAd && TvSohuAds.getInstance().sogouAd.state == "no" && !TvSohuAds.getInstance().bottomAd.isShow && stage.stageHeight > 300)
            {
                TvSohuAds.getInstance().sogouAd.play();
            }
            return;
        }// end function

        override protected function onStop(param1 = "") : void
        {
            var _loc_2:Object = null;
            super.onStop(param1);
            if (_skin != null)
            {
                this._tipHistory.close();
            }
            if (this._hisRecommend != null)
            {
                _ctrlBar_c.removeChild(this._hisRecommend);
                this._hisRecommend = null;
            }
            PlayerConfig.otherInforSender = "";
            _loc_2 = {totalRAM:System.totalMemory, idleRAMPer:Math.round(System.freeMemory / System.totalMemory), playerRAMPer:Math.round(System.privateMemory / System.totalMemory)};
            InforSender.getInstance().sendMesg(InforSender.END, PlayerConfig.viewTime, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, _loc_2);
            InforSender.getInstance().sendIRS("end");
            this.stopDanmu();
            this.stopWmTip();
            this.stopUgcAd();
            this.stopV360();
            this.stopBackgroudAd();
            _skinMap.getValue("playBtn").e = false;
            var _loc_3:Boolean = false;
            _skinMap.getValue("langSetBar").e = false;
            _skinMap.getValue("barrageBtn").e = _loc_3;
            var _loc_3:Boolean = false;
            _skinMap.getValue("lightBar").e = false;
            _skinMap.getValue("definitionBar").e = _loc_3;
            _skinMap.getValue("startPlayBtn").v = false;
            return;
        }// end function

        public function stopV360() : void
        {
            if (this._v360 != null)
            {
                this._v360Loading = false;
                this._v360.destroy();
                removeChild(this._v360);
                this._v360 = null;
            }
            return;
        }// end function

        private function stopDanmu() : void
        {
            if (this._danmu != null)
            {
                LogManager.msg("卸载弹幕组件");
                if (this._danmu.hasEventListener("__onTmDataGet"))
                {
                    this._danmu.removeEventListener("__onTmDataGet", this.onTmDataComplete);
                    this._danmu.removeEventListener("__onTmDataErr", this.onTmDataFailHandler);
                    this._danmu.removeEventListener("__onTmNoData", this.onTmDataFailHandler);
                    this._danmu.removeEventListener("__onTmDataFailed", this.onTmDataFailHandler);
                }
                this._danmu.stop();
                this._danmu.dispose();
                removeChild(this._danmu);
                this._danmu = null;
            }
            return;
        }// end function

        public function readyReplay() : void
        {
            var _loc_1:Boolean = false;
            _skinMap.getValue("playBtn").e = false;
            _skinMap.getValue("playBtn").v = _loc_1;
            var _loc_1:Boolean = true;
            _skinMap.getValue("replayBtn").e = true;
            _skinMap.getValue("replayBtn").v = _loc_1;
            var _loc_1:Boolean = false;
            _skinMap.getValue("nextBtn").e = false;
            _skinMap.getValue("albumBtn").e = _loc_1;
            if (!PlayerConfig.showRecommend)
            {
                _skinMap.getValue("startPlayBtn").v = true;
            }
            this.setSkinState();
            return;
        }// end function

        private function resetBuffNum(event:Event = null) : void
        {
            this._bfTotNum.splice(0);
            this._resetTimeLimit.stop();
            return;
        }// end function

        override protected function bufferFull(event:Event) : void
        {
            super.bufferFull(event);
            if (_skin != null)
            {
                clearInterval(this._showBufferRate);
                this._transition_mc.visible = false;
                if (this._retryPanel.isOpen)
                {
                    this._retryPanel.close();
                }
            }
            if (Eif.available)
            {
                ExternalInterface.call("flv_playerEvent", "onplaying");
            }
            return;
        }// end function

        public function replay(param1 = null) : void
        {
            if (this._saveIsHide)
            {
                var _loc_2:* = this._saveIsHide;
                _isHide = this._saveIsHide;
                PlayerConfig.isHide = _loc_2;
            }
            this.resize(stage.stageWidth, stage.stageHeight);
            _core.play();
            LogManager.msg("重新播放");
            if (this._tipHistory != null)
            {
                this._tipHistory.isShowPayTip = false;
            }
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_Repeat&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            if (Eif.available && PlayerConfig.is56)
            {
                ExternalInterface.call("s2j_replay");
            }
            return;
        }// end function

        override protected function mediaNotfound(param1) : void
        {
            super.mediaNotfound(param1);
            if (_skin != null)
            {
                clearInterval(this._showBufferRate);
                this._transition_mc.visible = false;
            }
            return;
        }// end function

        override protected function mediaConnecting(param1) : void
        {
            var evt:* = param1;
            if (_skin != null)
            {
                if (!this._isFirstConnect)
                {
                    this._transition_mc.visible = true;
                    this._showBufferRate = setInterval(function () : void
            {
                var _loc_1:* = undefined;
                _loc_1 = 0;
                try
                {
                    _loc_1 = _core.ns.bufferLength / _core.ns.bufferTime;
                }
                catch (err:Error)
                {
                }
                _loc_1 = _loc_1 > 1 ? (1) : (_loc_1);
                _loc_1 = _loc_1 < 0 ? (0) : (_loc_1);
                if (_loc_1 <= 0)
                {
                    _transition_mc.loading_txt.visible = false;
                }
                else
                {
                    _transition_mc.loading_txt.text = Math.round(_loc_1 * 100) + "%";
                    _transition_mc.loading_txt.visible = true;
                }
                if (_loc_1 >= 1)
                {
                    _transition_mc.visible = false;
                    _transition_mc.loading_txt.text = "";
                }
                return;
            }// end function
            , 50);
                }
                else
                {
                    this._isFirstConnect = false;
                }
            }
            return;
        }// end function

        protected function adPlayProgress(event:TvSohuAdsEvent) : void
        {
            if (_skin != null)
            {
                _progress_sld["isAdMode"] = true;
                _progress_sld.enabled = false;
                _play_btn.enabled = false;
                _pause_btn.enabled = false;
                _tipDisplay.visible = false;
                _startPlay_btn.visible = false;
                this._lightBar.enabled = false;
                this._definitionBar.enabled = false;
                this._langSetBar.enabled = false;
                if (this._playListPanel != null && this._isPlayListOk && this._playListPanel.sourceLength() > 1)
                {
                    this._albumBtn.visible = _skinMap.getValue("albumBtn").v && _ctrlBarBg_spr.width > _skinMap.getValue("albumBtn").w;
                    if (this._albumBtn.btnVisNum == 1)
                    {
                        this._albumBtn.enabled = this._playListPanel.hasNext();
                    }
                    else
                    {
                        this._albumBtn.enabled = true;
                    }
                    _skinMap.getValue("nextBtn").e = this._playListPanel.hasNext();
                }
                this._barrageBtn.visible = _skinMap.getValue("barrageBtn").v;
                try
                {
                    _volume_sld.rate = event.target.volume;
                }
                catch (e:Error)
                {
                }
                if (TvSohuAds.getInstance().ctrlBarAd.hasAd && event.target.isExcluded)
                {
                    TvSohuAds.getInstance().ctrlBarAd.container.visible = event.target.isExcluded ? (false) : (true);
                    TvSohuAds.getInstance().ctrlBarAd.container.alpha = event.target.isExcluded ? (0) : (1);
                }
            }
            return;
        }// end function

        override protected function ctrlBarBgUp(event:MouseEvent) : void
        {
            this.hideDefinitionSideBar();
            return;
        }// end function

        private function bottomAdShown(event:TvSohuAdsEvent) : void
        {
            this._isShownBottomAd = true;
            this.resize(_width, _height);
            return;
        }// end function

        private function bottomAdHide(event:TvSohuAdsEvent) : void
        {
            this._isShownBottomAd = false;
            if (_core.streamState == "pause")
            {
                var _loc_2:Boolean = true;
                _skinMap.getValue("startPlayBtn").e = true;
                _skinMap.getValue("startPlayBtn").v = _loc_2;
            }
            this.resize(_width, _height);
            return;
        }// end function

        private function sogouAdShown(event:TvSohuAdsEvent) : void
        {
            if (TvSohuAds.getInstance().bottomAd.isShow)
            {
                TvSohuAds.getInstance().sogouAd.hide();
            }
            this.setAdsState();
            return;
        }// end function

        private function pauseAdShown(event:TvSohuAdsEvent) : void
        {
            this.setAdsState();
            return;
        }// end function

        private function pauseAdClosed(event:TvSohuAdsEvent = null) : void
        {
            return;
        }// end function

        override protected function newFunc() : void
        {
            super.newFunc();
            this._rightSideBarTimeout_to = new Timeout(3);
            this._resetTimeLimit = new Timeout(10 * 60);
            this._panelArr = new Array();
            this._filterArr = new Array();
            this._filterArr = new Array(3);
            this._bfTotNum = new Array();
            this._softInitObj = new Object();
            return;
        }// end function

        protected function progressSlidePreview(param1:SliderEventUtil) : void
        {
            var _loc_2:Number = NaN;
            _loc_2 = param1.obj.rate * _skinMap.getValue("progressBar").totTime;
            var _loc_3:Number = 0;
            param1.target.previewTip = Utils.fomatTime(_loc_2);
            if (PlayerConfig.pvpic != null && PlayerConfig.isPreviewPic)
            {
                var _loc_4:* = Math.floor(_loc_2);
                param1.target.currentTime = Math.floor(_loc_2);
                this.slidePreviewTime = _loc_4;
            }
            return;
        }// end function

        protected function volumeBarPreview(param1:SliderEventUtil) : void
        {
            this.tipText("音量：" + Math.round(param1.obj.rate * 100) + "%", 2);
            return;
        }// end function

        override protected function playProgress(param1) : void
        {
            var playedTime:Number;
            var totTime:Number;
            var t_allTime:Number;
            var time:String;
            var xuid:String;
            var isCurrentVid:Boolean;
            var currDropFrames:uint;
            var isLoading:Boolean;
            var n:int;
            var obj:Object;
            var clipLoadState:String;
            var heartSpend:Number;
            var pbUrl:String;
            var uncaughtUrl:String;
            var _obj:Object;
            var flushResult:String;
            var today_date:Date;
            var today_date_str:String;
            var f:Boolean;
            var i:uint;
            var item:Object;
            var list:Array;
            var callBack:Function;
            var callBack2:Function;
            var nextListName:String;
            var k:int;
            var mc:*;
            var boo:Boolean;
            var evt:* = param1;
            var _loc_3:* = evt.obj.nowTime;
            PlayerConfig.playedTime = evt.obj.nowTime;
            playedTime = _loc_3;
            totTime = evt.obj.totTime;
            this._dummyPlayedTime = playedTime;
            this._dummyTotTime = totTime;
            if (PlayerConfig.startTime != "" && PlayerConfig.endTime != "")
            {
                if (!this._firstPlay && this._dummyPlayedTime > 0)
                {
                    PlayerConfig.startTime = String(this._dummyPlayedTime);
                    this._firstPlay = true;
                }
                this._dummyPlayedTime = playedTime - uint(PlayerConfig.startTime);
                this._dummyPlayedTime = this._dummyPlayedTime < 0 ? (0) : (this._dummyPlayedTime);
                this._dummyTotTime = uint(PlayerConfig.endTime) - uint(PlayerConfig.startTime);
                if (this._dummyPlayedTime >= this._dummyTotTime && !evt.obj.isSeek)
                {
                    this._dummyPlayedTime = this._dummyTotTime;
                    _core.stop();
                }
            }
            _skinMap.getValue("progressBar").totTime = this._dummyTotTime;
            if (_skin != null)
            {
                if (!evt.obj.isSeek)
                {
                    _progress_sld.topRate = this._dummyPlayedTime / this._dummyTotTime;
                }
                time;
                if (!PlayerConfig.isLive)
                {
                    time = Utils.fomatTime(Math.round(this._dummyPlayedTime)) + "<font color=\"#" + _skinMap.getValue("timeDisplay").ttColor + "\"> / " + Utils.fomatTime(Math.floor(this._dummyTotTime)) + "</font>";
                }
                else
                {
                    time;
                }
                _timeDisplay["time_txt"].htmlText = time;
            }
            if (this._tipHistory != null && TvSohuAds.getInstance().startAd.state != "playing" && TvSohuAds.getInstance().endAd.state != "playing")
            {
                this._tipHistory.playProgress(evt);
                if (Math.abs(Math.round(playedTime) - this._playedTime1) >= 1)
                {
                    var _loc_3:* = PlayerConfig;
                    var _loc_4:* = PlayerConfig.viewTime + 1;
                    _loc_3.viewTime = _loc_4;
                    this._playedTime1 = Math.round(playedTime);
                    if (PlayerConfig.viewTime % 300 == 0 && Eif.available)
                    {
                        ExternalInterface.call("palyerInterval", PlayerConfig.userId);
                    }
                    if (Math.abs(playedTime - PlayerConfig.viewTime) > 2)
                    {
                        this._retryPanel.close();
                    }
                    if ((PlayerConfig.viewTime == 5 || PlayerConfig.viewTime - this._playedTime60 >= 60) && (PlayerConfig.passportMail != "" && PlayerConfig.isSohuDomain || !PlayerConfig.isSohuDomain) && !PlayerConfig.isLive)
                    {
                        this._playedTime60 = PlayerConfig.viewTime;
                        xuid = PlayerConfig.xuid != "" ? ("&xuid=" + PlayerConfig.xuid) : ("");
                        isCurrentVid = InforSender.getInstance().ifltype != "" && !PlayerConfig.isLive && PlayerConfig.currentVid != "" ? (true) : (false);
                        if (!PlayerConfig.is56)
                        {
                            InforSender.getInstance().sendCustomMesg("http://his.tv.sohu.com/his/ping.do?vid=" + (isCurrentVid ? (PlayerConfig.currentVid) : (PlayerConfig.vid)) + "&tvid=" + PlayerConfig.tvid + "&sid=" + PlayerConfig.vrsPlayListId + "&uiddd=" + PlayerConfig.passportUID + "&out=" + PlayerConfig.domainProperty + xuid + (!PlayerConfig.isSohuDomain ? ("&from=20") : ("")) + "&t=" + Math.round(playedTime) + "&account_time=" + PlayerConfig.viewTime + "&c=1&tt=" + Math.random() + "&ismytv=" + (PlayerConfig.isMyTvVideo ? ("1") : ("0")) + "&pageurl=" + escape(PlayerConfig.outReferer));
                        }
                        else if (PlayerConfig.passportMail != "")
                        {
                            InforSender.getInstance().sendCustomMesg("http://his.56.com/his/56_ping.do?vid=" + (isCurrentVid ? (PlayerConfig.currentVid) : (PlayerConfig.vid)) + "&tvid=" + PlayerConfig.tvid + "&sid=" + (Utils.getJSVar("videoInfo.aid") == null ? ("") : (Utils.getJSVar("videoInfo.aid"))) + "&uiddd=" + PlayerConfig.passportUID + "&out=" + PlayerConfig.domainProperty + xuid + (!PlayerConfig.isSohuDomain ? ("&from=20") : ("")) + "&t=" + Math.round(playedTime) + "&account_time=" + PlayerConfig.viewTime + "&c=1&tt=" + Math.random() + "&ismytv=" + (PlayerConfig.isMyTvVideo ? ("1") : ("0")) + "&pageurl=" + escape(PlayerConfig.outReferer) + "&videourl=" + escape(PlayerConfig.currentPageUrl) + "&uid=" + PlayerConfig.passportMail);
                        }
                    }
                    if (PlayerConfig.playedTime > 10 && PlayerConfig.viewTime - this._playedTime3 >= 1)
                    {
                        this._playedTime3 = PlayerConfig.viewTime;
                        try
                        {
                            if (_core != null && !PlayerConfig.isThrottle)
                            {
                                currDropFrames = _core.videoArr[_core.curIndex].video.info.getDropFrames();
                                this._dropFramesArr.push(Math.abs(currDropFrames - this._tempDropFrames));
                                if (this._dropFramesArr != null && this._dropFramesArr.length == 5)
                                {
                                    if (this.average(this._dropFramesArr) > 18)
                                    {
                                        if (!this._isSendDFS)
                                        {
                                            this._isSendDFS = true;
                                            obj;
                                            InforSender.getInstance().sendMesg(InforSender.DROPFRAMES, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, obj);
                                        }
                                        var _loc_3:String = this;
                                        var _loc_4:* = this._dropFramesNum + 1;
                                        _loc_3._dropFramesNum = _loc_4;
                                        this._dfForSo = SharedObject.getLocal("dropFrames", "/");
                                        if (!this._isSendDfForSo && this._dropFramesNum >= 3 && this._dfForSo.data.list != undefined && this._dfForSo.data.list != null && this._dfForSo.data.list.length == 2 && this._dfForSo.data.list[0].df * 5 / this._dfForSo.data.list[0].vt >= 0.9)
                                        {
                                            this._isSendDfForSo = true;
                                            if (this._tipHistory.isOpen)
                                            {
                                                this._tipHistory.close();
                                            }
                                            if (!this._tipHistory.isOpenSVDTip && !(PlayerConfig.availableStvd && PlayerConfig.stvdInUse) && !this._isSvdUserTip)
                                            {
                                                if (Number(PlayerConfig.userId.substring((PlayerConfig.userId.length - 1))) % 2 == 0)
                                                {
                                                    InforSender.getInstance().sendMesg(InforSender.DFFORSO, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {totalViewTime:this._dfForSo.data.list[0].vt, totalDropFrames:this._dfForSo.data.list[0].df, stvdInUse:"1"});
                                                    this._tipHistory.showOpenSVDTip();
                                                }
                                                else
                                                {
                                                    InforSender.getInstance().sendMesg(InforSender.DFFORSO, 0, "", "", "http://pb.hd.sohu.com.cn/hdpb.gif", 0, {totalViewTime:this._dfForSo.data.list[0].vt, totalDropFrames:this._dfForSo.data.list[0].df, stvdInUse:"0"});
                                                }
                                            }
                                        }
                                        isLoading;
                                        n;
                                        while (n < _core.videoArr.length)
                                        {
                                            
                                            clipLoadState = _core.videoArr[n].download;
                                            if (clipLoadState == "loading" || clipLoadState == "part_loading")
                                            {
                                                isLoading;
                                            }
                                            n = (n + 1);
                                        }
                                        if (!isLoading)
                                        {
                                            var _loc_3:String = this;
                                            var _loc_4:* = this._dfForLoadedNum + 1;
                                            _loc_3._dfForLoadedNum = _loc_4;
                                        }
                                    }
                                    this._dropFramesArr = [];
                                }
                                this._tempDropFrames = currDropFrames;
                            }
                        }
                        catch (err:Error)
                        {
                        }
                        try
                        {
                        }
                        if (Eif.available && PlayerConfig.viewTime - this._playedTime4 >= 1)
                        {
                            this._playedTime4 = PlayerConfig.viewTime;
                            heartSpend = PlayerConfig.totalDuration > 180 ? (30) : (10);
                            pbUrl = InforSender.getInstance().heartBeat(heartSpend, "http://pb.hd.sohu.com.cn/hdpb.gif?msg=realPlayTime") + "&time=" + PlayerConfig.viewTime + "&dropFramesNum=" + this._dropFramesNum + "&dfForLoadedNum=" + this._dfForLoadedNum;
                            ExternalInterface.call("messagebus.publish", "player.update_time", {time:PlayerConfig.viewTime, pingback:pbUrl});
                            if (this._isUncaught)
                            {
                                uncaughtUrl = InforSender.getInstance().heartBeat(heartSpend, "http://pb.hd.sohu.com.cn/hdpb.gif?msg=performance") + "&totalRAM=" + System.totalMemory + "&idleRAMPer=" + Math.round(System.freeMemory / System.totalMemory) + "&playerRAMPer=" + Math.round(System.privateMemory / System.totalMemory) + "&errorType=" + this._uncaughtError;
                                ExternalInterface.call("messagebus.publish", "player.update_time", {time:PlayerConfig.viewTime, pingback:uncaughtUrl});
                            }
                        }
                    }
                    catch (e:Error)
                    {
                    }
                    if (PlayerConfig.totalDuration > 180 && PlayerConfig.viewTime - this._playedTime30 >= 30)
                    {
                        this._playedTime30 = PlayerConfig.viewTime;
                        InforSender.getInstance().sendCustomMesg(InforSender.getInstance().heartBeat(30, "http://pb.hd.sohu.com.cn/stats.gif?msg=caltime"));
                    }
                    else if (PlayerConfig.totalDuration <= 180 && PlayerConfig.viewTime - this._playedTime10 >= 10)
                    {
                        this._playedTime10 = PlayerConfig.viewTime;
                        InforSender.getInstance().sendCustomMesg(InforSender.getInstance().heartBeat(10, "http://pb.hd.sohu.com.cn/stats.gif?msg=caltime"));
                    }
                    if (PlayerConfig.viewTime - this._playedTime15For56 >= 15)
                    {
                        this._playedTime15For56 = PlayerConfig.viewTime;
                        if (Eif.available && PlayerConfig.is56)
                        {
                            _obj;
                            ExternalInterface.call("s2j_sendTime", _obj);
                        }
                    }
                    if (PlayerConfig.viewTime - this._dfForPlayedTime60 >= 60 && !(PlayerConfig.availableStvd && PlayerConfig.stvdInUse))
                    {
                        this._dfForPlayedTime60 = PlayerConfig.viewTime;
                        this._dfForSo = SharedObject.getLocal("dropFrames", "/");
                        flushResult;
                        today_date = new Date();
                        today_date_str = today_date.getFullYear() + "/" + (today_date.getMonth() + 1) + "/" + today_date.getDate();
                        if (this._dfForSo.data.list != undefined && this._dfForSo.data.list != null)
                        {
                            f;
                            i;
                            while (i < this._dfForSo.data.list.length)
                            {
                                
                                if (this._dfForSo.data.list[i].date == today_date_str)
                                {
                                    f;
                                    this._dfForSo.data.list[i].date = today_date_str;
                                    this._dfForSo.data.list[i].vt = this._dfForSo.data.list[i].vt + 60;
                                    this._dfForSo.data.list[i].df = this._dfForSo.data.list[i].df + (this._dropFramesNum - this._addDropFramesNum);
                                    this._addDropFramesNum = this._dropFramesNum;
                                    try
                                    {
                                        flushResult = this._dfForSo.flush();
                                        if (flushResult == SharedObjectFlushStatus.PENDING)
                                        {
                                            this._dfForSo.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                                        }
                                        else if (flushResult == SharedObjectFlushStatus.FLUSHED)
                                        {
                                        }
                                    }
                                    catch (e:Error)
                                    {
                                    }
                                    break;
                                }
                                i = (i + 1);
                            }
                            if (!f)
                            {
                                item;
                                this._addDropFramesNum = this._dropFramesNum;
                                if (this._dfForSo.data.list.length < 2)
                                {
                                    this._dfForSo.data.list.push(item);
                                    try
                                    {
                                        flushResult = this._dfForSo.flush();
                                        if (flushResult == SharedObjectFlushStatus.PENDING)
                                        {
                                            this._dfForSo.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                                        }
                                        else if (flushResult == SharedObjectFlushStatus.FLUSHED)
                                        {
                                        }
                                    }
                                    catch (e:Error)
                                    {
                                    }
                                }
                                else
                                {
                                    this._dfForSo.data.list.shift();
                                    this._dfForSo.data.list.push(item);
                                    try
                                    {
                                        flushResult = this._dfForSo.flush();
                                        if (flushResult == SharedObjectFlushStatus.PENDING)
                                        {
                                            this._dfForSo.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                                        }
                                        else if (flushResult == SharedObjectFlushStatus.FLUSHED)
                                        {
                                        }
                                    }
                                    catch (e:Error)
                                    {
                                    }
                                }
                            }
                        }
                        else
                        {
                            list;
                            this._addDropFramesNum = this._dropFramesNum;
                            this._dfForSo.data.list = list;
                            try
                            {
                                flushResult = this._dfForSo.flush();
                                if (flushResult == SharedObjectFlushStatus.PENDING)
                                {
                                    this._dfForSo.addEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
                                }
                                else if (flushResult == SharedObjectFlushStatus.FLUSHED)
                                {
                                }
                            }
                            catch (e:Error)
                            {
                            }
                        }
                    }
                }
            }
            if (this._isJumpEndCaption && PlayerConfig.etTime > 0 && this._tipHistory != null)
            {
                if (PlayerConfig.etTime - playedTime <= 20)
                {
                    if (!this._tipHistory.isJECChecked && !this._isShowNextTitle)
                    {
                        this._isShowNextTitle = true;
                        if (PlayerConfig.vrsPlayListId && this._playListPanel != null && this._isPlayListOk && this._playListPanel.hasNext())
                        {
                            callBack = function (param1:String) : void
            {
                _tipHistory.nextTitle = param1;
                _tipHistory.showNextTitle();
                return;
            }// end function
            ;
                            this._playListPanel.getNextTitle(callBack);
                        }
                    }
                    if (playedTime - PlayerConfig.etTime > 2)
                    {
                        if (_core.streamState == "play")
                        {
                            setTimeout(function () : void
            {
                _core.stop();
                return;
            }// end function
            , 100);
                        }
                    }
                }
                else if (this._tipHistory.currentState == "jumpECTip")
                {
                    this._tipHistory.hideJumpEndCaption();
                }
            }
            else if ((!this._isJumpEndCaption || PlayerConfig.etTime <= 0) && totTime != 0 && _core.filePlayedTime != 0 && totTime - _core.filePlayedTime <= 15 && !this._isShowNextTitle)
            {
                this._isShowNextTitle = true;
                if (PlayerConfig.vrsPlayListId && this._playListPanel != null && this._isPlayListOk && this._playListPanel.hasNext())
                {
                    callBack2 = function (param1:String) : void
            {
                _tipHistory.nextTitle = param1;
                _tipHistory.showNextTitle();
                return;
            }// end function
            ;
                    this._playListPanel.getNextTitle(callBack2);
                }
                else if (PlayerConfig.is56 && Eif.available && ExternalInterface.available)
                {
                    nextListName;
                    if (PlayerConfig.acidFor56 != "" || PlayerConfig.midFor56 != "")
                    {
                        nextListName = decodeURIComponent(String(ExternalInterface.call("s2j_playNextName")));
                    }
                    else
                    {
                        nextListName = decodeURIComponent(String(ExternalInterface.call("s2j_onOverPanelPlayNextName")));
                    }
                    if (nextListName != "" && nextListName != "null" && nextListName != "undefined")
                    {
                        this._tipHistory.nextTitle = nextListName;
                    }
                    else
                    {
                        this._tipHistory.nextTitle = PlayerConfig.SHOW_NEXT_PLAY == "on" ? ("正在切换下一视频...") : ("当前为专辑连播状态，即将切换到下一个视频...");
                    }
                    this._tipHistory.showNextTitle();
                }
            }
            if (!this._isLoadRecomm && PlayerConfig.isSohuDomain && (PlayerConfig.caid == "2" || PlayerConfig.caid == "16" || PlayerConfig.caid == "7") && PlayerConfig.vrsPlayListId && this._playListPanel != null && this._isPlayListOk && this._playListPanel.hasNext() == false && !this._isSwitchVideos && PlayerConfig.isListPlay && PlayerConfig.isHisRecomm)
            {
                if (this._isJumpEndCaption && PlayerConfig.etTime > 0)
                {
                    if (PlayerConfig.etTime - playedTime <= 13 && PlayerConfig.etTime - playedTime > 5 && _skin != null)
                    {
                        this.sendAndLoadRecomm();
                    }
                }
                else if ((!this._isJumpEndCaption || PlayerConfig.etTime <= 0) && totTime != 0 && _core.filePlayedTime != 0 && totTime - _core.filePlayedTime <= 15 && totTime - _core.filePlayedTime > 5 && _skin != null)
                {
                    this.sendAndLoadRecomm();
                }
            }
            this.setCaptionBarState(evt);
            if (PlayerConfig.previewTime > 0)
            {
                if (this._dummyPlayedTime >= PlayerConfig.previewTime || Math.abs(this._dummyPlayedTime - PlayerConfig.previewTime) < 2)
                {
                    setTimeout(function () : void
            {
                _core.stop();
                return;
            }// end function
            , 1000);
                }
                if (this._dummyPlayedTime >= 1 && !this._tipHistory.isShowPayTip)
                {
                    if (PlayerConfig.cooperator == "imovie")
                    {
                        this._tipHistory.showIMoviePayTip();
                    }
                    else
                    {
                        this._tipHistory.showPayTip();
                    }
                }
            }
            if (!PlayerConfig.isSogouAd && !PlayerConfig.isBackgorundShowing)
            {
                k;
                while (k < PlayerConfig.midAdTimeArr.length)
                {
                    
                    if (this._dummyTotTime > PlayerConfig.midAdTimeArr[k])
                    {
                        if (Math.round(this._dummyPlayedTime) == PlayerConfig.midAdTimeArr[k] - 5 && TvSohuAds.getInstance().middleAd.state == "no" && !evt.obj.isSeek)
                        {
                            this._tipHistory.isMidAdTip = false;
                            TvSohuAds.getInstance().middleAd.midAdInx = k;
                            TvSohuAds.getInstance().middleAd.play();
                        }
                        if (TvSohuAds.getInstance().middleAd.state == "success")
                        {
                            if (TvSohuAds.getInstance().middleAd.hasMidAd)
                            {
                                if (!TvSohuAds.getInstance().middleAd.isMidAdTip && !this._tipHistory.isMidAdTip)
                                {
                                    this._tipHistory.showMidAdTip();
                                    TvSohuAds.getInstance().middleAd.isMidAdTip = true;
                                }
                                if (Math.round(this._dummyPlayedTime) == PlayerConfig.midAdTimeArr[k])
                                {
                                    if (this._tipHistory != null && this._tipHistory.isOpen)
                                    {
                                        this._tipHistory.close();
                                    }
                                    TvSohuAds.getInstance().middleAd.goToPlayMidAd();
                                }
                            }
                            else if (Math.round(this._dummyPlayedTime) == PlayerConfig.midAdTimeArr[k])
                            {
                                TvSohuAds.getInstance().middleAd.goToPlayMidAd();
                            }
                        }
                    }
                    k = (k + 1);
                }
            }
            try
            {
                if (Utils.getBrowserCookie("fee_ifox") && P2PExplorer.getInstance().hasP2P)
                {
                    if (this._dummyPlayedTime >= 1 && !this._tipHistory.isIfoxVipTip)
                    {
                        this.tipVipCookie();
                    }
                }
            }
            catch (err:Error)
            {
            }
            if (this._licenseText != null)
            {
                if (Math.round(this._dummyPlayedTime) >= 3 && Math.round(this._dummyPlayedTime) <= 6)
                {
                    this._licenseText.visible = true;
                }
                else
                {
                    this._licenseText.visible = false;
                }
            }
            if (this._timer_c != null && this._timer_c.visible)
            {
                mc = this._timer_c.getChildByName("timeMc");
                try
                {
                    mc.content.sec = playedTime;
                    mc.content.total = totTime;
                }
                catch (err:Error)
                {
                }
            }
            if (this._num % 10 == 0)
            {
                boo;
                if (PlayerConfig.isPlayDownSameClip)
                {
                    if (_core.curIndex == _core.downloadIndex)
                    {
                        boo;
                    }
                    else
                    {
                        boo;
                    }
                }
                if (boo && (_core.fileLoadedSize / _core.fileTotSize - playedTime / totTime) * totTime < PlayerConfig.availableTime)
                {
                    if (getTimer() - this._notify_buffer > 5000)
                    {
                        this._notify_buffer = getTimer();
                        new URLLoaderUtil().send("http://127.0.0.1:8828/notify_buffer?uuid=" + PlayerConfig.uuid + "&r=" + Math.random());
                    }
                }
            }
            var _loc_3:String = this;
            var _loc_4:* = this._num + 1;
            _loc_3._num = _loc_4;
            if (this._danmu != null)
            {
                this._danmu.updatePlayTime(this._dummyPlayedTime);
            }
            t_allTime = PlayerConfig.etTime > 0 ? (PlayerConfig.etTime) : (this._dummyTotTime);
            if (PlayerConfig.isSohuDomain && !TvSohuAds.getInstance().backgroudAd.prepared && t_allTime - this._dummyPlayedTime < 120 && t_allTime - this._dummyPlayedTime > 40 && PlayerConfig.vrModel != "1" && PlayerConfig.vrModel != "2")
            {
                TvSohuAds.getInstance().backgroudAd.beginPrepare();
            }
            if (PlayerConfig.isSohuDomain && !PlayerConfig.isBackgorundShowing && TvSohuAds.getInstance().backgroudAd.prepared && this._displayRate == 1 && _core.rotateType == 0 && t_allTime - this._dummyPlayedTime < TvSohuAds.getInstance().backgroudAd.bgAdTime && stage.stageWidth >= 540 && stage.stageHeight >= 300)
            {
                if (this._dummyPlayedTime == 0 || t_allTime == 0)
                {
                    return;
                }
                if (this._backGroudClearTime != 0)
                {
                    return;
                }
                LogManager.msg("背景广告开始延迟100mss" + "__dummyPlayedTime: " + this._dummyPlayedTime + "  time:" + (t_allTime - this._dummyPlayedTime));
                this._backGroudClearTime = setTimeout(function () : void
            {
                if (_backGroudClearTime != 0)
                {
                    clearTimeout(_backGroudClearTime);
                    _backGroudClearTime = 0;
                }
                if (t_allTime - _dummyPlayedTime < TvSohuAds.getInstance().backgroudAd.bgAdTime)
                {
                    showBackGroudAd();
                    resize(_width, _height);
                    LogManager.msg("显示背景_dummyPlayedTime: " + _dummyPlayedTime + "  time:" + (t_allTime - _dummyPlayedTime));
                }
                return;
            }// end function
            , 100);
            }
            else if (PlayerConfig.isSohuDomain && PlayerConfig.isBackgorundShowing && (t_allTime - this._dummyPlayedTime >= TvSohuAds.getInstance().backgroudAd.bgAdTime || this._stage.stageWidth < 540 || stage.stageHeight < 300))
            {
                if (this._backGroudClearTime != 0)
                {
                    clearTimeout(this._backGroudClearTime);
                    this._backGroudClearTime = 0;
                    return;
                }
                if (this._dummyPlayedTime == 0 || t_allTime == 0)
                {
                    return;
                }
                this.hideBackGroudAd();
                this.resize(_width, _height);
                this.setAdsState();
                LogManager.msg("关闭背景_dummyPlayedTime: " + this._dummyPlayedTime + "  time:" + (t_allTime - this._dummyPlayedTime));
            }
            return;
        }// end function

        private function noSkinPlayProgress(param1) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_6:String = null;
            var _loc_7:Boolean = false;
            var _loc_8:* = param1.obj.nowTime;
            PlayerConfig.playedTime = param1.obj.nowTime;
            _loc_2 = _loc_8;
            _loc_3 = param1.obj.totTime;
            var _loc_4:* = _loc_2;
            var _loc_5:* = _loc_3;
            if (TvSohuAds.getInstance().startAd.state != "playing" && TvSohuAds.getInstance().endAd.state != "playing")
            {
                if (Math.abs(Math.round(_loc_2) - this._playedTime1) >= 1)
                {
                    this._playedTime1 = _loc_2;
                    var _loc_8:* = PlayerConfig;
                    var _loc_9:* = PlayerConfig.viewTime + 1;
                    _loc_8.viewTime = _loc_9;
                    if ((PlayerConfig.viewTime == 5 || PlayerConfig.viewTime - this._playedTime60 >= 60) && (PlayerConfig.passportMail != "" && PlayerConfig.isSohuDomain || !PlayerConfig.isSohuDomain) && !PlayerConfig.isLive)
                    {
                        this._playedTime60 = PlayerConfig.viewTime;
                        _loc_6 = PlayerConfig.xuid != "" ? ("&xuid=" + PlayerConfig.xuid) : ("");
                        _loc_7 = InforSender.getInstance().ifltype != "" && !PlayerConfig.isLive && PlayerConfig.currentVid != "" ? (true) : (false);
                        if (!PlayerConfig.is56)
                        {
                            InforSender.getInstance().sendCustomMesg("http://his.tv.sohu.com/his/ping.do?vid=" + (_loc_7 ? (PlayerConfig.currentVid) : (PlayerConfig.vid)) + "&tvid=" + PlayerConfig.tvid + "&sid=" + PlayerConfig.vrsPlayListId + "&uiddd=" + PlayerConfig.passportUID + "&out=" + PlayerConfig.domainProperty + _loc_6 + (!PlayerConfig.isSohuDomain ? ("&from=20") : ("")) + "&t=" + Math.round(_loc_2) + "&account_time=" + PlayerConfig.viewTime + "&c=1&tt=" + Math.random() + "&ismytv=" + (PlayerConfig.isMyTvVideo ? ("1") : ("0")) + "&pageurl=" + escape(PlayerConfig.outReferer));
                        }
                        else if (PlayerConfig.passportMail != "")
                        {
                        }
                    }
                }
            }
            return;
        }// end function

        private function sendAndLoadRecomm() : void
        {
            var videosArr:Array;
            this._isLoadRecomm = true;
            videosArr = new Array();
            var area:String;
            if (Eif.available && ExternalInterface.available)
            {
                area = ExternalInterface.call("window.__findAreaText");
            }
            new URLLoaderUtil().load(5, function (param1:Object) : void
            {
                var json:Object;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    json = new JSON().parse(obj.data.replace("var video_podcast_search_result=", ""));
                    videosArr = json.videos;
                    if (videosArr != null && videosArr.length >= 1)
                    {
                        new LoaderUtil().load(10, function (param1:Object) : void
                {
                    var removeHisRecommend:Function;
                    var url:String;
                    var refer:String;
                    var obj:* = param1;
                    if (obj.info == "success")
                    {
                        removeHisRecommend = function (event:Event) : void
                    {
                        if (_hisRecommend != null)
                        {
                            _ctrlBar_c.removeChild(_hisRecommend);
                        }
                        _hisRecommend = null;
                        _hisRecommObj = {};
                        if (event.type == "clickclose")
                        {
                            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_haoli202921_bfqznlb&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                        }
                        return;
                    }// end function
                    ;
                        _hisRecommend = obj.data.content;
                        _hisRecommend.setData({url:videosArr[0].videoUrl, title:videosArr[0].videoName});
                        _hisRecommend.addEventListener("clickclose", removeHisRecommend);
                        _ctrlBar_c.addChild(_hisRecommend);
                        _hisRecommObj = videosArr[0];
                        SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=PL_S_RecommendPlay_v20141106&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                        url;
                        refer;
                        if (PlayerConfig.lb != null && PlayerConfig.lb != "" && PlayerConfig.lb == "1")
                        {
                            refer = escape(PlayerConfig.lastReferer);
                            url = escape(PlayerConfig.filePrimaryReferer);
                        }
                        else
                        {
                            if (Eif.available && ExternalInterface.available)
                            {
                                try
                                {
                                    refer = escape(ExternalInterface.call("eval", "document.referrer"));
                                }
                                catch (e:Error)
                                {
                                }
                            }
                            url = PlayerConfig.currentPageUrl == "" ? (escape(PlayerConfig.outReferer)) : (escape(PlayerConfig.currentPageUrl));
                        }
                        SendRef.getInstance().sendPQDrog("http://ctr.hd.sohu.com/ctr.gif?fuid=" + PlayerConfig.userId + "&yyid=" + PlayerConfig.yyid + "&passport=" + PlayerConfig.passportMail + "&sid=" + PlayerConfig.sid + "&vid=" + PlayerConfig.vid + "&pid=" + PlayerConfig.vrsPlayListId + "&cid=" + PlayerConfig.caid + "&msg=impression" + "&rec=" + json.callback + "&ab=0&formwork=33&type=100" + "&uuid=" + PlayerConfig.uuid + "&url=" + url + "&refer=" + refer);
                        setSkinState();
                    }
                    return;
                }// end function
                , null, PlayerConfig.swfHost + "panel/HisRecommend.swf");
                    }
                }
                return;
            }// end function
            , "http://rc.vrs.sohu.com/player/continous?pid=" + PlayerConfig.vrsPlayListId + "&cid=" + PlayerConfig.caid + "&vid=" + PlayerConfig.vid + "&p=" + PlayerConfig.passportMail + "&u=" + PlayerConfig.userId + "&y=" + PlayerConfig.yyid + "&r=" + new Date().getTime());
            return;
        }// end function

        public function setCaptionBarState(param1) : void
        {
            var _loc_2:Number = NaN;
            if (this._captionBar != null && _core != null)
            {
                this._captionBar.playProgress(param1);
                this._captionBar.x = 0;
                _loc_2 = Math.round(_core.videoContainer.y + _core.videoContainer.height * this._captionBar.py);
                if (_loc_2 + this._captionBar.height > _core.height)
                {
                    this._captionBar.y = Math.round(_core.videoContainer.y + _core.videoContainer.height - this._captionBar.height - 5);
                }
                else if (!this._captionBar.isDragState)
                {
                    this._captionBar.y = _loc_2;
                }
            }
            return;
        }// end function

        private function hideSideBar(param1) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (_skin != null)
            {
                _loc_2 = stage.mouseX;
                _loc_3 = stage.mouseY;
                if (param1.type != "mouseOut" && !this._rightSideBar.hitTestPoint(_loc_2, _loc_3) || param1.type == "mouseOut" && (param1.stageX <= 0 || param1.stageY <= 0) || param1.type == Event.MOUSE_LEAVE)
                {
                    _showTween = TweenLite.to(this._rightSideBar, 0.5, {x:(_hitArea_spr.width + 1), ease:Quad.easeOut});
                    if (!(!PlayerConfig.isSohuDomain && (_core.streamState == "pause" || PlayerConfig.searchFocusIn && stage.mouseX > 8 && stage.mouseX < stage.stageWidth - 8 && stage.mouseY > 8 && stage.mouseY < this._topSideBarBg.height - 8)))
                    {
                        TweenLite.to(this._topSideBar, 0.5, {y:-this._topSideBarBg.height, ease:Quad.easeOut});
                    }
                    this.hideBar(param1);
                }
            }
            return;
        }// end function

        private function showSideBar(event:MouseEvent) : void
        {
            if (_skin != null)
            {
                if (!_ctrlBarBg_spr.hitTestPoint(mouseX, mouseY + 2))
                {
                    this._rightSideBarTimeout_to.restart();
                }
                if (!_ctrlBarBg_spr.hitTestPoint(mouseX, mouseY))
                {
                    _showTween = TweenLite.to(this._rightSideBar, 0.5, {x:_hitArea_spr.width - this._share_btn.width, ease:Quad.easeOut});
                    this.showBar(event);
                    TweenLite.to(this._topSideBar, 0.5, {y:0, ease:Quad.easeOut});
                }
                if (_ctrlBar_c.hitTestPoint(mouseX, mouseY - 110) && !PlayerConfig.isUgcPreview)
                {
                    if (!PlayerConfig.isLive)
                    {
                        this.showCommonProgress();
                    }
                }
                else
                {
                    this.hideBar2();
                }
            }
            return;
        }// end function

        override protected function seekEnd(param1:SliderEventUtil) : void
        {
            super.seekEnd(param1);
            LogManager.msg("Playback::seekEnd::obj.sign:" + param1.obj.sign);
            return;
        }// end function

        override protected function hideBar(param1) : void
        {
            var evt:* = param1;
            if (_skin != null)
            {
                if (evt.type != "mouseOut" && !_ctrlBarBg_spr.hitTestPoint(stage.mouseX, stage.mouseY + 5) && !this._isShowPreview && !(_volume_sld.slider.visible && _volume_sld.hitTestPoint(stage.mouseX, stage.mouseY)) && !(this._definitionSlider.visible && this._definitionSlider.hitTestPoint(stage.mouseX, stage.mouseY)) && !(this._settingPanel != null && this._settingPanel.visible && this._settingPanel.hitTestPoint(stage.mouseX, stage.mouseY)) || evt.type == "mouseOut" && (evt.stageX <= 0 || evt.stageY <= 0) || evt.type == Event.MOUSE_LEAVE)
                {
                    if (PlayerConfig.isHide || stage.displayState == "fullScreen")
                    {
                        if (stage.displayState == "fullScreen")
                        {
                            Mouse.hide();
                        }
                        _hideTween = TweenLite.to(_ctrlBar_c, 0.5, {y:_height + 2, ease:Quad.easeOut, onComplete:function () : void
            {
                _showBar_boo = false;
                return;
            }// end function
            });
                    }
                    if (!_progress_sld["hitSpr"].hitTestPoint(_progress_sld.mouseX, _progress_sld.mouseY))
                    {
                        this.showMiniProgress();
                    }
                }
            }
            return;
        }// end function

        private function hideBar2(param1 = null) : void
        {
            if (_skin != null)
            {
                if (!_ctrlBarBg_spr.hitTestPoint(stage.mouseX, stage.mouseY + 5) && !this._isShowPreview && !(_volume_sld.slider.visible && _volume_sld.hitTestPoint(stage.mouseX, stage.mouseY)) && !(this._definitionSlider.visible && this._definitionSlider.hitTestPoint(stage.mouseX, stage.mouseY)) && !(this._settingPanel != null && this._settingPanel.visible && this._settingPanel.hitTestPoint(stage.mouseX, stage.mouseY)))
                {
                    if (!_progress_sld["hitSpr"].hitTestPoint(stage.mouseX, stage.mouseY))
                    {
                        this.showMiniProgress();
                    }
                }
            }
            return;
        }// end function

        override protected function showBar(event:MouseEvent) : void
        {
            if (_skin != null && !_showBar_boo)
            {
                TvSohuAds.getInstance().ctrlBarAd.dispatchSharedEvent();
            }
            if (_skin != null)
            {
                Mouse.show();
                _showBar_boo = true;
                _showTween = TweenLite.to(_ctrlBar_c, 0.5, {y:_height - _ctrlBarBg_spr.height, ease:Quad.easeOut});
            }
            return;
        }// end function

        public function videoBlurFilter() : void
        {
            var _loc_1:BlurFilter = null;
            var _loc_2:Array = null;
            var _loc_3:uint = 0;
            _loc_1 = new BlurFilter(12, 12, BitmapFilterQuality.HIGH);
            this._filterArr[2] = _loc_1;
            _loc_2 = [];
            _loc_3 = 0;
            while (_loc_3 < this._filterArr.length)
            {
                
                if (this._filterArr[_loc_3] != 0 && this._filterArr[_loc_3] != null)
                {
                    _loc_2.push(this._filterArr[_loc_3]);
                }
                _loc_3 = _loc_3 + 1;
            }
            _core.videoContainer.filters = _loc_2;
            TweenLite.to(_hitArea_spr, 0.8, {alpha:0.5, ease:Quad.easeOut});
            return;
        }// end function

        public function clearBlurFilter() : void
        {
            var _loc_1:Array = null;
            var _loc_2:uint = 0;
            TweenLite.killTweensOf(_hitArea_spr);
            _hitArea_spr.alpha = 0;
            this._filterArr[2] = null;
            _loc_1 = [];
            _loc_2 = 0;
            while (_loc_2 < this._filterArr.length)
            {
                
                if (this._filterArr[_loc_2] != 0 && this._filterArr[_loc_2] != null)
                {
                    _loc_1.push(this._filterArr[_loc_2]);
                }
                _loc_2 = _loc_2 + 1;
            }
            _core.videoContainer.filters = _loc_1;
            return;
        }// end function

        private function showBar2(event:MouseEvent = null) : void
        {
            if (_skin != null && !_showBar_boo)
            {
                TvSohuAds.getInstance().ctrlBarAd.dispatchSharedEvent();
            }
            if (_skin != null)
            {
                Mouse.show();
                _showBar_boo = true;
                _showTween = TweenLite.to(_ctrlBar_c, 0.5, {y:_height - _ctrlBarBg_spr.height, ease:Quad.easeOut});
            }
            return;
        }// end function

        private function startSideTween() : void
        {
            if (!stage.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
                stage.addEventListener(MouseEvent.MOUSE_MOVE, this.showSideBar);
                stage.addEventListener(Event.MOUSE_LEAVE, function (event:Event) : void
            {
                hideSideBar(event);
                return;
            }// end function
            );
                this._rightSideBarTimeout_to.start();
            }
            return;
        }// end function

        private function startPreLoad(event:Event = null) : void
        {
            LogManager.msg("开启预加载功能！");
            _core.lastoutBuffer = true;
            ErrorSenderPQ.getInstance().sendPQStat({code:PlayerConfig.START_PRELOAD_CODE});
            return;
        }// end function

        public function get v360()
        {
            return this._v360;
        }// end function

        public function get parentClass() : Class
        {
            return MediaPlayback;
        }// end function

        public function get panel()
        {
            return this._playListPanel;
        }// end function

        public function get likePanel()
        {
            return this._likePanel;
        }// end function

        public function get more()
        {
            return this._more;
        }// end function

        public function get flatWall3D()
        {
            return this._flatWall3D;
        }// end function

        public function get skin()
        {
            return _skin;
        }// end function

        public function get liveCoreVer() : String
        {
            return this._liveCoreVersion;
        }// end function

        public function get hisRecommObj() : Object
        {
            return this._hisRecommObj;
        }// end function

        public function setLoadCore(param1:Function) : void
        {
            _skin = null;
            this.loadCore();
            this._func = param1;
            return;
        }// end function

        public function setTitle() : void
        {
            var _loc_1:TextFormat = null;
            var _loc_2:uint = 0;
            if (PlayerConfig.videoTitle != "" && this._titleText != null && this._topPerSp != null)
            {
                _loc_1 = new TextFormat();
                _loc_1.size = 14;
                _loc_1.color = 15066597;
                _loc_1.font = PlayerConfig.MICROSOFT_YAHEI;
                this._titleText.htmlText = unescape(PlayerConfig.videoTitle);
                this._titleText.setTextFormat(_loc_1);
                _loc_2 = 0;
                while (_loc_2 < unescape(PlayerConfig.videoTitle).length * 2)
                {
                    
                    if (stage.displayState == StageDisplayState.FULL_SCREEN)
                    {
                        if (!this._titleText.hitTestObject(this._topPerSp))
                        {
                            break;
                        }
                        else
                        {
                            this._titleText.htmlText = Utils.maxCharsLimit(unescape(PlayerConfig.videoTitle), unescape(PlayerConfig.videoTitle).length * 2 - _loc_2, true);
                        }
                    }
                    else
                    {
                        this._titleText.htmlText = Utils.maxCharsLimit(unescape(PlayerConfig.videoTitle), Math.floor(stage.stageWidth / 14 - 1) * 2, true);
                    }
                    this._titleText.setTextFormat(_loc_1);
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        public function setLicense() : void
        {
            var fat:TextFormat;
            var filter_fk:BitmapFilter;
            var fkFilters:Array;
            var getBitmapFilter:* = function () : BitmapFilter
            {
                var _loc_1:Number = NaN;
                var _loc_2:Number = NaN;
                var _loc_3:Number = NaN;
                var _loc_4:Number = NaN;
                var _loc_5:Number = NaN;
                var _loc_6:Boolean = false;
                var _loc_7:Boolean = false;
                var _loc_8:Number = NaN;
                _loc_1 = 0;
                _loc_2 = 0.8;
                _loc_3 = 6;
                _loc_4 = 6;
                _loc_5 = 2;
                _loc_6 = false;
                _loc_7 = false;
                _loc_8 = BitmapFilterQuality.HIGH;
                return new GlowFilter(_loc_1, _loc_2, _loc_3, _loc_4, _loc_5, _loc_8, _loc_6, _loc_7);
            }// end function
            ;
            if (PlayerConfig.wm_filing != "")
            {
                this._licenseText = new TextField();
                this._licenseText.autoSize = TextFieldAutoSize.RIGHT;
                addChild(this._licenseText);
                fat = new TextFormat();
                fat.size = 18;
                fat.font = PlayerConfig.MICROSOFT_YAHEI;
                fat.color = 16777215;
                this._licenseText.htmlText = "备案号：" + PlayerConfig.wm_filing;
                this._licenseText.setTextFormat(fat);
                filter_fk = this.getBitmapFilter();
                fkFilters = new Array();
                fkFilters.push(filter_fk);
                this._licenseText.filters = fkFilters;
            }
            return;
        }// end function

        public function setHighDot() : void
        {
            if (PlayerConfig.epInfo != null && PlayerConfig.epInfo.length > 0)
            {
                var _loc_1:* = _progress_sld;
                _loc_1._progress_sld["setDots"](PlayerConfig.epInfo);
            }
            return;
        }// end function

        public function setFlatWall3D() : void
        {
            if (this._flatWall3D != null)
            {
                this._flatWall3D.End();
                removeChild(this._flatWall3D);
                this._flatWall3D = null;
            }
            if (_progress_sld != null)
            {
                var _loc_1:* = _progress_sld;
                _loc_1._progress_sld["removeDotsBtn"]();
                var _loc_1:* = _progress_sld;
                _loc_1._progress_sld["clearPreviewPic"]();
            }
            if (this._cueTipPanel != null)
            {
                removeChild(this._cueTipPanel);
                this._cueTipPanel = null;
            }
            return;
        }// end function

        private function stopWmTip() : void
        {
            if (this._wmTipPanel != null)
            {
                this._wmTipPanel.removeEventListener("PAUSE", this.wm1);
                this._wmTipPanel.removeEventListener("RESUME", this.wm2);
                this._wmTipPanel.removeEventListener("DAT_LOADED", this.wm3);
                this._wmTipPanel.removeEventListener("LOGIN", this.wm4);
                this._wmTipPanel.destroy();
                removeChild(this._wmTipPanel);
                this._wmTipPanel = null;
            }
            return;
        }// end function

        private function stopUgcAd() : void
        {
            if (this._ugcAd != null)
            {
                LogManager.msg("播放器强制关闭千帆推广");
                this._ugcAd.destroyAd();
                removeChild(this._ugcAd);
                this._ugcAd = null;
            }
            return;
        }// end function

        private function stopBackgroudAd() : void
        {
            if (PlayerConfig.isBackgorundShowing)
            {
                TvSohuAds.getInstance().backgroudAd.destroy();
                PlayerConfig.isBackgorundShowing = false;
                TvSohuAds.getInstance().pauseAd.loadDataAndShow = true;
                LogManager.msg("播放器销毁背景广告");
            }
            return;
        }// end function

        public function loopInitParams() : void
        {
            this._isLoadRecomm = false;
            this._hisRecommObj = {};
            return;
        }// end function

        public function set isTsp(param1:Boolean) : void
        {
            if (param1)
            {
                if (_progress_sld != null)
                {
                    var _loc_2:* = _progress_sld;
                    _loc_2._progress_sld["downLoadPic"]();
                }
            }
            return;
        }// end function

        public function set isSvdUserTip(param1:Boolean) : void
        {
            this._isSvdUserTip = param1;
            return;
        }// end function

        public function set isUncaught(param1:Boolean) : void
        {
            this._isUncaught = param1;
            return;
        }// end function

        public function set uncaughtError(param1:String) : void
        {
            this._uncaughtError = param1;
            return;
        }// end function

        public function set isShowNextTitle(param1:Boolean) : void
        {
            this._isShowNextTitle = param1;
            return;
        }// end function

        public function set isHide(param1:Boolean) : void
        {
            _isHide = param1;
            return;
        }// end function

        public function showPriviewPic() : void
        {
            var flat3dReady:Function;
            var ctx:LoaderContext;
            flat3dReady = function (event:PanelEvent) : void
            {
                var obj:Object;
                var e:* = event;
                _flatWall3D.addEventListener("SEEK_PLAY_EVT", function (event:Event) : void
                {
                    _flatWall3D.visible = false;
                    seekTo(event.target.nowR);
                    return;
                }// end function
                );
                _flatWall3D.addEventListener("INITED", function (event:Event) : void
                {
                    _flatWall3D.open(PlayerConfig.playedTime, slidePreviewTime);
                    _core.pause();
                    return;
                }// end function
                );
                _flatWall3D.addEventListener("CLOSE_EVT", function (event:Event) : void
                {
                    if (streamState == "pause")
                    {
                        _core.pause();
                    }
                    else
                    {
                        _core.play();
                    }
                    return;
                }// end function
                );
                obj = _progress_sld["allPicObj"];
                obj.width = _core.width;
                obj.height = _core.height - (stage.displayState == "fullScreen" ? (pbarDiff()) : (0));
                _flatWall3D.init(obj);
                setSkinState();
                var _loc_3:Boolean = false;
                _skinMap.getValue("startPlayBtn").v = false;
                _startPlay_btn.visible = _loc_3;
                return;
            }// end function
            ;
            this.streamState = _core.streamState;
            if (_progress_sld != null)
            {
                if (this._flatWall3D == null)
                {
                    ctx = new LoaderContext();
                    ctx.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
                    new LoaderUtil().load(10, function (param1:Object) : void
            {
                if (param1.info === "success")
                {
                    _flatWall3D = param1.data.content;
                    _flatWall3D.addEventListener(PanelEvent.READY, flat3dReady);
                    _panelArr.push(_flatWall3D);
                    addChild(_flatWall3D);
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/FlatWall3D.swf", ctx);
                }
                else if (this._flatWall3D.isOpen)
                {
                    this._flatWall3D.close();
                    var _loc_2:Boolean = true;
                    _skinMap.getValue("startPlayBtn").v = true;
                    _startPlay_btn.visible = _loc_2;
                }
                else if (this._preLoadPanel == null || (!this._preLoadPanel.isOpen || this._preLoadPanel.isBackgroundRun))
                {
                    this.closePanel();
                    this._flatWall3D.open(PlayerConfig.playedTime, this.slidePreviewTime);
                    _core.pause();
                    var _loc_2:Boolean = false;
                    _skinMap.getValue("startPlayBtn").v = false;
                    _startPlay_btn.visible = _loc_2;
                }
                SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=PL_C_PreView&s=" + PlayerConfig.stype + "&r=" + new Date().getTime());
            }
            return;
        }// end function

        public function clearTipText() : void
        {
            this.tipText("");
            return;
        }// end function

        public function updateUserLoginInfo() : void
        {
            if (this._wmTipPanel != null)
            {
                this._wmTipPanel.updateUserLoginInfo({uid:PlayerConfig.visitorId, passport:PlayerConfig.passportMail});
            }
            return;
        }// end function

        override protected function tipText(param1:String, param2:uint = 0) : void
        {
            if (_tipDisplay != null)
            {
                super.tipText(param1, param2);
            }
            return;
        }// end function

        private function average(param1:Array) : Number
        {
            var _loc_2:Number = NaN;
            var _loc_3:uint = 0;
            _loc_2 = 0;
            _loc_3 = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2 = _loc_2 + param1[_loc_3];
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2 / param1.length;
        }// end function

        public function startCutImgToBoundPage() : void
        {
            if (this.isCuting)
            {
                return;
            }
            this.isCuting = true;
            this.streamState = _core.streamState;
            new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _broundPageCut = obj.data.content;
                    with ({})
                    {
                        {}.closeHan = function (event:Event) : void
                {
                    removeChild(_broundPageCut);
                    _broundPageCut.removeEventListener("close", closeHan);
                    _broundPageCut = null;
                    if (streamState == "pause")
                    {
                        _core.pause();
                    }
                    else
                    {
                        _core.play();
                    }
                    isCuting = false;
                    return;
                }// end function
                ;
                    }
                    _broundPageCut.addEventListener("close", function (event:Event) : void
                {
                    removeChild(_broundPageCut);
                    _broundPageCut.removeEventListener("close", closeHan);
                    _broundPageCut = null;
                    if (streamState == "pause")
                    {
                        _core.pause();
                    }
                    else
                    {
                        _core.play();
                    }
                    isCuting = false;
                    return;
                }// end function
                );
                    addChild(_broundPageCut);
                    _broundPageCut.CutImage(_core.videoArr[_core.curIndex].video, PlayerConfig.playedTime, _core.metaWidth, _core.metaHeight);
                }
                else
                {
                    if (streamState == "pause")
                    {
                        _core.pause();
                    }
                    else
                    {
                        _core.play();
                    }
                    isCuting = false;
                    if (Eif.available)
                    {
                        ExternalInterface.call("boundPageCutResult", "", 0);
                    }
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/BountPageCutImage.swf");
            return;
        }// end function

        public function getJSVarObj(param1:Object) : Object
        {
            var vari:* = param1;
            try
            {
                if (Eif.available && ExternalInterface.available)
                {
                    return ExternalInterface.call("function(){return " + vari + ";}", null);
                }
            }
            catch (err:Error)
            {
                return null;
            }
            return null;
        }// end function

        public function showMofunEnglishPanel() : void
        {
            if (this._mofunengPanel == null)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                if (param1.info == "success")
                {
                    _mofunengPanel = param1.data.content;
                    _mofunengPanel.init(TvSohuMediaPlayback.getInstance(), PlayerConfig.videoTitle, PlayerConfig.totalDuration, PlayerConfig.vid, "sohu");
                    addChild(_mofunengPanel);
                    _mofunengPanel.open();
                    setSkinState();
                    showMofunEnglishPanel();
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/MofunEnglish.swf", new LoaderContext(true));
            }
            return;
        }// end function

        private function showBackGroudAd() : void
        {
            PlayerConfig.isBackgorundShowing = true;
            TvSohuAds.getInstance().backgroudAd.resize(_width, _height - _ctrlBarBg_spr.height, _core.videoContainer.width, _core.videoContainer.height);
            TvSohuAds.getInstance().backgroudAd.play();
            TvSohuAds.getInstance().pauseAd.loadDataAndShow = false;
            this._logoAdContainer.visible = false;
            _hitArea_spr.mouseEnabled = false;
            return;
        }// end function

        private function hideBackGroudAd() : void
        {
            PlayerConfig.isBackgorundShowing = false;
            TvSohuAds.getInstance().backgroudAd.hideAd();
            _hitArea_spr.mouseEnabled = true;
            if (stage.stageWidth > 360 && stage.stageHeight > 200)
            {
                this._logoAdContainer.visible = true;
            }
            else
            {
                this._logoAdContainer.visible = false;
            }
            TvSohuAds.getInstance().pauseAd.loadDataAndShow = true;
            return;
        }// end function

        public static function getInstance() : TvSohuMediaPlayback
        {
            if (singleton == null)
            {
                singleton = new TvSohuMediaPlayback;
            }
            return singleton;
        }// end function

    }
}
