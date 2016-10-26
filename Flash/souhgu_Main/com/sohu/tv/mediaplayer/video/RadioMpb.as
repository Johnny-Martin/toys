package com.sohu.tv.mediaplayer.video
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.ads.*;
    import ebing.*;
    import ebing.controls.*;
    import ebing.events.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;

    public class RadioMpb extends TvSohuMediaPlayback
    {
        private var _share2_btn:ButtonUtil;
        private var _collect_btn:ButtonUtil;
        private var _jsNext_btn:ButtonUtil;
        private var _openSeeLater_btn:ButtonUtil;
        private var _closeSeeLater_btn:ButtonUtil;
        private var _collectTipMc:MovieClip;
        private var _closeTimeNum:Number = 0;
        private var _hasCollect:Boolean = false;
        private var _isAllowDelete:Boolean = true;
        private var _nextVideoInfo:Object;
        private var _prSeeLaterPanel:Object;
        private var _prPlayList:PRPlayList;
        private var _isCtrlVisibleInit:Boolean = true;
        private var _listMode:String = "pr";
        private var _isLoadAndPlayEvent:Boolean = false;
        private var _isNextBtnClicked:Boolean = false;
        private var _slTimer:Number;
        private var _collectTimeoutId:Number;
        private var _seeLaterPanelContainer:Sprite;
        private var _titleTextFormatfat:TextFormat;
        private var _videoTitleHtmlTextLink:String = "";
        private var _videoTitleHtmlTextHover:String = "";
        private static var singleton:RadioMpb;

        public function RadioMpb()
        {
            PlayerConfig.showRecommend = false;
            PlayerConfig.showTopBar = true;
            PlayerConfig.topBarNor = true;
            PlayerConfig.topBarFull = true;
            return;
        }// end function

        override protected function newFunc() : void
        {
            super.newFunc();
            this._prPlayList = new PRPlayList();
            this._seeLaterPanelContainer = new Sprite();
            return;
        }// end function

        override protected function loadSkin(param1:String = "") : void
        {
            param1 = PlayerConfig.swfHost + "skins/pr.swf";
            super.loadSkin(param1);
            return;
        }// end function

        override protected function drawSkin() : void
        {
            this._share2_btn = new ButtonUtil({skin:_skin["share2_btn"]});
            this._collect_btn = new ButtonUtil({skin:_skin["collect_btn"]});
            this._collect_btn.skin.tip_mc.visible = false;
            this._collect_btn.skin.collected_mc.visible = false;
            this._jsNext_btn = new ButtonUtil({skin:_skin["js_next_btn"]});
            this._openSeeLater_btn = new ButtonUtil({skin:_skin["openSeeLater_btn"]});
            this._closeSeeLater_btn = new ButtonUtil({skin:_skin["closeSeeLater_btn"]});
            super.drawSkin();
            if (this.getParams("CtrlVisibleInit") == "1" && stage.stageWidth <= 465)
            {
                this.ctrlBarVisible2(this.getParams("showCtrlBar") == "0" ? (true) : (false), 0);
            }
            this._collectTipMc = _skin["collect_tip"];
            addChild(this._collectTipMc);
            _ctrlBtn_sp.addChild(this._collect_btn);
            _ctrlBtn_sp.addChild(this._share2_btn);
            _ctrlBtn_sp.addChild(this._jsNext_btn);
            addChild(this._seeLaterPanelContainer);
            this._collectTipMc.visible = false;
            return;
        }// end function

        private function ctrlBarVisible2(param1:Boolean, param2 = null) : void
        {
            var _loc_3:Boolean = false;
            _topSideBar.visible = false;
            var _loc_3:* = _loc_3;
            _rightSideBar.visible = _loc_3;
            _ctrlBar_c.visible = _loc_3;
            if (_wmTipPanel != null)
            {
                _wmTipPanel.visible = false;
            }
            var _loc_3:Boolean = true;
            _isHide = true;
            PlayerConfig.isHide = _loc_3;
            resize(stage.stageWidth, stage.stageHeight);
            if (param2 != null && param2 == 1)
            {
                if (!param1)
                {
                    var _loc_3:* = param1;
                    _isHide = param1;
                    PlayerConfig.isHide = _loc_3;
                }
                resize(stage.stageWidth, stage.stageHeight);
                var _loc_3:Boolean = true;
                _topSideBar.visible = true;
                var _loc_3:* = _loc_3;
                _rightSideBar.visible = _loc_3;
                _ctrlBar_c.visible = _loc_3;
                if (_wmTipPanel != null)
                {
                    _wmTipPanel.visible = true;
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
                resize(stage.stageWidth, stage.stageHeight);
            }
            this._seeLaterPanelContainer.visible = _ctrlBar_c.visible;
            return;
        }// end function

        override public function ctrlBarVisible(param1:Boolean, param2 = null) : void
        {
            super.ctrlBarVisible(param1, param2);
            if (_ctrlBar_c.visible)
            {
                _topSideBar.visible = true;
                if (_wmTipPanel != null)
                {
                    _wmTipPanel.visible = true;
                }
            }
            else
            {
                _topSideBar.visible = false;
                if (_wmTipPanel != null)
                {
                    _wmTipPanel.visible = false;
                }
            }
            if (this._prSeeLaterPanel != null && this._seeLaterPanelContainer.x == _core.width)
            {
                this._closeSeeLater_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
            }
            this._seeLaterPanelContainer.visible = _ctrlBar_c.visible;
            return;
        }// end function

        private function getParams(param1:String) : String
        {
            var _loc_2:String = "";
            if (stage.loaderInfo.parameters[param1] != null)
            {
                _loc_2 = String(stage.loaderInfo.parameters[param1]);
                _loc_2 = _loc_2.replace(new RegExp("\\^", "g"), "&");
            }
            return _loc_2;
        }// end function

        override protected function setSkinState() : void
        {
            var diff:Number;
            if (_skin != null)
            {
                diff = _core.width - _ctrlBarBg_spr.width;
            }
            super.setSkinState();
            if (_skin != null)
            {
                var _loc_2:int = 8;
                _pause_btn.y = 8;
                var _loc_2:* = _loc_2;
                _play_btn.y = _loc_2;
                _replay_btn.y = _loc_2;
                this._collect_btn.x = 15;
                var _loc_2:* = this._collect_btn.x + this._collect_btn.skin.collected_mc.width + 15;
                _pause_btn.x = this._collect_btn.x + this._collect_btn.skin.collected_mc.width + 15;
                var _loc_2:* = _loc_2;
                _play_btn.x = _loc_2;
                _replay_btn.x = _loc_2;
                var _loc_2:int = 11;
                this._collect_btn.y = 11;
                this._jsNext_btn.y = _loc_2;
                this._jsNext_btn.x = _play_btn.x + _play_btn.width + 15;
                this._share2_btn.x = _fullScreen_btn.x - this._share2_btn.width - 15;
                this._share2_btn.y = _fullScreen_btn.y;
                _definitionBar.x = this._share2_btn.x - _definitionBar.width - 15;
                _volume_sld.x = _definitionBar.x - _volume_sld.width + 28;
                _timeDisplay.x = this._jsNext_btn.x + this._jsNext_btn.width + 10;
                _timeDisplay.y = 19;
                _definitionSlider.x = _definitionBar.x - (_definitionSlider.width - _definitionBar.width) / 2;
                if (this._collectTipMc != null)
                {
                    Utils.setCenter(this._collectTipMc, _hitArea_spr);
                }
                if (this._prSeeLaterPanel != null)
                {
                    setTimeout(function () : void
            {
                _prSeeLaterPanel.resize(260, _core.height);
                return;
            }// end function
            , 300);
                    Utils.setCenterByNumber(this._openSeeLater_btn, 2, _core.height);
                    Utils.setCenterByNumber(this._closeSeeLater_btn, 2, _core.height);
                    var _loc_2:* = -this._openSeeLater_btn.width;
                    this._openSeeLater_btn.x = -this._openSeeLater_btn.width;
                    this._closeSeeLater_btn.x = _loc_2;
                    this._seeLaterPanelContainer.x = this._seeLaterPanelContainer.x + diff;
                }
            }
            return;
        }// end function

        override protected function addEvent() : void
        {
            super.addEvent();
            this._share2_btn.addEventListener(MouseEventUtil.MOUSE_UP, sharePanel);
            this._collect_btn.addEventListener(MouseEventUtil.MOUSE_OVER, function (event:Event) : void
            {
                _collect_btn.skin.tip_mc.tip_txt.htmlText = "";
                _collect_btn.skin.tip_mc.visible = true;
                if (_collect_btn.skin.collected_mc.visible)
                {
                    _collect_btn.skin.tip_mc.tip_txt.htmlText = "取消喜欢";
                }
                else
                {
                    _collect_btn.skin.tip_mc.tip_txt.htmlText = "喜欢这个视频";
                }
                return;
            }// end function
            );
            this._collect_btn.addEventListener(MouseEventUtil.MOUSE_OUT, function (event:Event) : void
            {
                _collect_btn.skin.tip_mc.visible = false;
                return;
            }// end function
            );
            this._collect_btn.addEventListener(MouseEventUtil.MOUSE_UP, function (event:Event) : void
            {
                var url1:String;
                var j:uint;
                var f:Boolean;
                var i:uint;
                var evt:* = event;
                var so:* = SharedObject.getLocal("collect", "/");
                var vidArr:* = so.data.vidarr;
                var flushResult:String;
                if (_collect_btn.skin.collected_mc.visible)
                {
                    if (PlayerConfig.passportMail != "")
                    {
                        url1 = "http://my.tv.sohu.com/user/a/bookmark/removebyvid.do?vid=" + PlayerConfig.hdVid.split("_")[0];
                        new URLLoaderUtil().load(10, function (param1:Object) : void
                {
                    if (param1.info == "success")
                    {
                        _collect_btn.skin.collected_mc.visible = false;
                    }
                    return;
                }// end function
                , url1);
                    }
                    else if (vidArr != null)
                    {
                        j;
                        while (j < vidArr.length)
                        {
                            
                            if (vidArr[j] == PlayerConfig.hdVid)
                            {
                                vidArr.splice(j, 1);
                                so.data.vidarr = vidArr;
                                showCollectBtnTip("已取消喜欢");
                                _collect_btn.skin.collected_mc.visible = false;
                                flushResult = so.flush();
                                if (flushResult == SharedObjectFlushStatus.PENDING)
                                {
                                    so.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent) : void
                {
                    return;
                }// end function
                );
                                }
                                else if (flushResult == SharedObjectFlushStatus.FLUSHED)
                                {
                                }
                                break;
                            }
                            j = (j + 1);
                        }
                    }
                }
                else if (PlayerConfig.passportMail != "")
                {
                    addCollectForDynamicInterface(PlayerConfig.hdVid);
                }
                else
                {
                    f;
                    if (vidArr != null)
                    {
                        if (vidArr.length < 20)
                        {
                            i;
                            while (i < vidArr.length)
                            {
                                
                                if (vidArr[i] == PlayerConfig.hdVid)
                                {
                                    f;
                                    break;
                                }
                                i = (i + 1);
                            }
                            if (f)
                            {
                                showCollectBtnTip("已收藏过");
                                _collect_btn.skin.collected_mc.visible = true;
                                return;
                            }
                            vidArr.push(PlayerConfig.hdVid);
                            so.data.vidarr = vidArr;
                            showCollectBtnTip("已收藏");
                            _collect_btn.skin.collected_mc.visible = true;
                        }
                        else
                        {
                            showCollectBtnTip("登录后收藏");
                            ExternalInterface.call("doLogin()");
                        }
                    }
                    else
                    {
                        vidArr = new Array();
                        vidArr.push(PlayerConfig.hdVid.split("_")[0]);
                        so.data.vidarr = vidArr;
                        showCollectBtnTip("已收藏");
                        _collect_btn.skin.collected_mc.visible = true;
                    }
                    try
                    {
                        flushResult = so.flush();
                        if (flushResult == SharedObjectFlushStatus.PENDING)
                        {
                            so.addEventListener(NetStatusEvent.NET_STATUS, function (event:NetStatusEvent) : void
                {
                    return;
                }// end function
                );
                        }
                        else if (flushResult == SharedObjectFlushStatus.FLUSHED)
                        {
                        }
                    }
                    catch (e:Error)
                    {
                    }
                }
                return;
            }// end function
            );
            this._jsNext_btn.addEventListener(MouseEventUtil.MOUSE_UP, function (event:Event) : void
            {
                if (_prPlayList.hasNext(true))
                {
                    _isNextBtnClicked = true;
                    _jsNext_btn.enabled = false;
                    _prPlayList.nextPlay(true);
                }
                return;
            }// end function
            );
            this._openSeeLater_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.showPRSeeLaterPanel);
            this._closeSeeLater_btn.addEventListener(MouseEventUtil.MOUSE_UP, this.closePRSeeLaterPanel);
            this._openSeeLater_btn.addEventListener(MouseEventUtil.MOUSE_OVER, function (param1:MouseEventUtil) : void
            {
                if (_prSeeLaterPanel != null && _prSeeLaterPanel.visible)
                {
                }
                return;
            }// end function
            );
            this._openSeeLater_btn.addEventListener(MouseEventUtil.MOUSE_OUT, function (param1:MouseEventUtil) : void
            {
                return;
            }// end function
            );
            this._collectTipMc.close_btn.addEventListener(MouseEvent.MOUSE_UP, this.close);
            this._prPlayList.addEventListener("playListVideo", function (event:Event) : void
            {
                dispatchEvent(new Event("playListVideo"));
                return;
            }// end function
            );
            this._prPlayList.addEventListener("dataLoaded", this.setTitle2);
            return;
        }// end function

        private function addCollectForDynamicInterface(param1:String = "") : void
        {
            var url:String;
            var vid:* = param1;
            if (vid != "")
            {
                url = "http://my.tv.sohu.com/user/a/bookmark/save_update.do?vid=" + vid.split("_")[0];
                url = url + ("&pid=" + PlayerConfig.vrsPlayListId);
                url = url + ("&url=" + PlayerConfig.filePrimaryReferer);
                url = url + ("&title=" + encodeURIComponent(PlayerConfig.videoTitle));
                new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                if (param1.info == "success")
                {
                    _loc_2 = new JSON().parse(param1.data);
                    if (_loc_2 != null && _loc_2.status == 1)
                    {
                        showCollectBtnTip("已加入收藏");
                        _collect_btn.skin.collected_mc.visible = true;
                    }
                    else
                    {
                        showCollectBtnTip("收藏失败");
                        _collect_btn.skin.collected_mc.visible = false;
                    }
                }
                else
                {
                    showCollectBtnTip("接口失败");
                    _collect_btn.skin.collected_mc.visible = false;
                }
                return;
            }// end function
            , url);
            }
            return;
        }// end function

        private function showCollectBtnTip(param1:String = "") : void
        {
            var txt:* = param1;
            if (txt != "")
            {
                clearTimeout(this._collectTimeoutId);
                this._collect_btn.skin.tip_mc.tip_txt.htmlText = txt;
                this._collect_btn.skin.tip_mc.visible = true;
                this._collectTimeoutId = setTimeout(function () : void
            {
                _collect_btn.skin.tip_mc.visible = false;
                return;
            }// end function
            , 2000);
            }
            return;
        }// end function

        private function close(param1 = null) : void
        {
            clearTimeout(this._closeTimeNum);
            this._collectTipMc.visible = false;
            return;
        }// end function

        override protected function adPlayProgress(event:TvSohuAdsEvent) : void
        {
            super.adPlayProgress(event);
            if (_skin != null)
            {
                var _loc_2:Boolean = false;
                this._collect_btn.enabled = false;
                this._share2_btn.enabled = _loc_2;
            }
            return;
        }// end function

        override protected function sysInit(param1:String = null) : void
        {
            super.sysInit(param1);
            if (_skin != null)
            {
                if (this._prSeeLaterPanel == null)
                {
                    this._openSeeLater_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
                }
                else if (this._listMode == "pr")
                {
                    this.closePRSeeLaterPanel();
                }
                else if (this._listMode == "sl")
                {
                }
            }
            return;
        }// end function

        override protected function onStart(event:Event = null) : void
        {
            super.onStart();
            var _loc_2:Boolean = false;
            this._isLoadAndPlayEvent = false;
            this._isNextBtnClicked = _loc_2;
            if (_skin != null)
            {
                var _loc_2:Boolean = true;
                this._collect_btn.enabled = true;
                var _loc_2:* = _loc_2;
                this._share2_btn.enabled = _loc_2;
                this._jsNext_btn.enabled = _loc_2;
                if (this._hasCollect)
                {
                    this._collect_btn.enabled = false;
                }
                else
                {
                    this._collect_btn.enabled = true;
                }
            }
            this.checkCollectState();
            if (this.getParams("showLaterPanel") == "1" && this._seeLaterPanelContainer.x != _core.width - 260)
            {
                this._openSeeLater_btn.dispatchEvent(new MouseEventUtil(MouseEventUtil.MOUSE_UP));
                this._prSeeLaterPanel.toSelectItem(PlayerConfig.hdVid.split("_")[0]);
                this._listMode = "sl";
            }
            this.setTitle2();
            return;
        }// end function

        private function checkCollectState() : void
        {
            var url:String;
            var j:uint;
            var i:uint;
            var so:* = SharedObject.getLocal("collect", "/");
            var vidArr:* = so.data.vidarr;
            var flushResult:String;
            if (PlayerConfig.passportMail != "")
            {
                url;
                url = url + ("?vid=" + PlayerConfig.hdVid.split("_")[0]);
                url = url + "&source=mainsite";
                new URLLoaderUtil().load(10, function (param1:Object) : void
            {
                var _loc_2:Object = null;
                if (param1.info == "success")
                {
                    _loc_2 = new JSON().parse(param1.data);
                    if (_loc_2 != null && _loc_2.status == 1)
                    {
                        _collect_btn.skin.collected_mc.visible = true;
                    }
                    else
                    {
                        _collect_btn.skin.collected_mc.visible = false;
                    }
                }
                else
                {
                    _collect_btn.skin.collected_mc.visible = false;
                }
                return;
            }// end function
            , url);
                if (vidArr != null && vidArr.length > 0)
                {
                    j;
                    while (j < vidArr.length)
                    {
                        
                        this.addCollectForDynamicInterface(vidArr[j]);
                        j = (j + 1);
                    }
                    so.data.vidarr = null;
                }
            }
            else if (vidArr != null)
            {
                i;
                while (i < vidArr.length)
                {
                    
                    if (vidArr[i] == PlayerConfig.hdVid)
                    {
                        this._collect_btn.skin.collected_mc.visible = true;
                        break;
                    }
                    else
                    {
                        this._collect_btn.skin.collected_mc.visible = false;
                    }
                    i = (i + 1);
                }
            }
            return;
        }// end function

        override protected function onPlayed(event:Event = null) : void
        {
            super.onPlayed(event);
            return;
        }// end function

        public function setNextVideo(param1:Object) : void
        {
            this._nextVideoInfo = param1;
            if (this._nextVideoInfo.hasNext)
            {
                this._jsNext_btn.enabled = true;
            }
            else
            {
                this._jsNext_btn.enabled = false;
            }
            return;
        }// end function

        public function setBtnState(param1:Object) : void
        {
            if (param1.hasCollect != null)
            {
                this._hasCollect = param1.hasCollect;
                if (TvSohuAds.getInstance().startAd.state != "playing" && TvSohuAds.getInstance().endAd.state != "playing")
                {
                    if (this._hasCollect)
                    {
                        this._collect_btn.enabled = false;
                    }
                    else
                    {
                        this._collect_btn.enabled = true;
                    }
                }
            }
            if (param1.isAllowDelete != null)
            {
                this._isAllowDelete = param1.isAllowDelete;
                if (TvSohuAds.getInstance().startAd.state != "playing" && TvSohuAds.getInstance().endAd.state != "playing")
                {
                }
            }
            return;
        }// end function

        override public function showPlayListPanel(param1:MouseEventUtil = null) : void
        {
            return;
        }// end function

        override protected function showDefinitionSideBar(param1:MouseEventUtil) : void
        {
            var evt:* = param1;
            clearTimeout(_showBsbId);
            _showBsbId = setTimeout(function () : void
            {
                _definitionSlider.visible = true;
                _definitionSlider.open();
                _tween = TweenLite.to(_definitionSlider, 0.3, {alpha:1, ease:Quad.easeOut});
                return;
            }// end function
            , 300);
            return;
        }// end function

        override protected function onStop(param1 = "") : void
        {
            super.onStop(param1);
            if (!TvSohuAds.getInstance().endAd.hasAd)
            {
                this.endAdFinish(null);
            }
            return;
        }// end function

        override protected function endAdFinish(event:TvSohuAdsEvent) : void
        {
            if (this._listMode == "sl")
            {
                if (!this._isLoadAndPlayEvent)
                {
                    if (this._prSeeLaterPanel.hasNext())
                    {
                        this._prSeeLaterPanel.playNextVideo();
                    }
                    else
                    {
                        this.playPRVideo();
                    }
                    this._prSeeLaterPanel.deleteVideo(PlayerConfig.hdVid);
                }
            }
            else if (!this._isNextBtnClicked)
            {
                this.playPRVideo();
            }
            return;
        }// end function

        private function playPRVideo() : void
        {
            this._listMode = "pr";
            if (this._prPlayList.hasNext())
            {
                this._prPlayList.nextPlay();
            }
            else
            {
                ExternalInterface.call("listPlayFinished");
            }
            return;
        }// end function

        override public function setTitle() : void
        {
            return;
        }// end function

        public function setTitle2(event:Event = null) : void
        {
            var evt:* = event;
            if (PlayerConfig.videoTitle != "" && _titleText != null && _topPerSp != null)
            {
                this._videoTitleHtmlTextLink = "<font size=\'14\' face=\'微软雅黑\' color=\'#E5E5E5\'><a href=\'event:1\'>正在播放：" + unescape(PlayerConfig.videoTitle) + "</font></a><font size=\'12\' color=\'#E5E5E5\'  face=\'微软雅黑\'> " + this._prPlayList.getRecommendReason(PlayerConfig.hdVid.split("_")[0]) + "</font>";
                this._videoTitleHtmlTextHover = "<font size=\'14\' color=\'#ff0000\'  face=\'微软雅黑\'><a href=\'event:1\'><u>正在播放：" + unescape(PlayerConfig.videoTitle) + "</u></a></font><font size=\'12\' color=\'#E5E5E5\'  face=\'微软雅黑\'> " + this._prPlayList.getRecommendReason(PlayerConfig.hdVid.split("_")[0]) + "</font>";
                this._titleTextFormatfat = new TextFormat();
                this._titleTextFormatfat.font = "Microsoft YaHei";
                _titleText.htmlText = this._videoTitleHtmlTextLink;
                _titleText.selectable = false;
                _titleText.setTextFormat(this._titleTextFormatfat);
                if (!_titleText.hasEventListener(TextEvent.LINK))
                {
                    _titleText.addEventListener(TextEvent.LINK, function (event:TextEvent) : void
            {
                if (event.text == "1")
                {
                    Utils.openWindow(PlayerConfig.filePrimaryReferer);
                }
                return;
            }// end function
            );
                    _titleText.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                _titleText.htmlText = _videoTitleHtmlTextHover;
                return;
            }// end function
            );
                    _titleText.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                _titleText.htmlText = _videoTitleHtmlTextLink;
                return;
            }// end function
            );
                }
            }
            return;
        }// end function

        override protected function hideDefinitionSideBar(param1 = null) : void
        {
            var evt:* = param1;
            clearTimeout(_showBsbId);
            _showBsbId = setTimeout(function () : void
            {
                if (!_definitionSlider.hitTestPoint(mouseX, mouseY) || _ctrlBar_c.mouseX <= _definitionBar.x || evt != null && evt.stageX <= 0 || mouseX >= stage.stageWidth - 6 || mouseY >= stage.stageHeight - 6)
                {
                    hideBsb();
                }
                return;
            }// end function
            , 300);
            return;
        }// end function

        private function closePRSeeLaterPanel(param1 = null) : void
        {
            TweenLite.to(this._seeLaterPanelContainer, 0.2, {x:_core.width});
            this._closeSeeLater_btn.visible = false;
            this._openSeeLater_btn.visible = true;
            this.setSLTip();
            return;
        }// end function

        private function openPRSeeLaterPanel(param1 = null) : void
        {
            var evt:* = param1;
            TweenLite.to(this._seeLaterPanelContainer, 0.2, {x:_core.width - 260});
            this._closeSeeLater_btn.visible = true;
            this._openSeeLater_btn.visible = false;
            clearTimeout(this._slTimer);
            this._slTimer = setTimeout(function () : void
            {
                closePRSeeLaterPanel();
                return;
            }// end function
            , 10000);
            this.setSLTip();
            return;
        }// end function

        private function showPRSeeLaterPanel(param1:MouseEventUtil) : void
        {
            var evt:* = param1;
            if (this._prSeeLaterPanel == null)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var url:String;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    _prSeeLaterPanel = obj.data.content;
                    url = "http://rc.vrs.sohu.com/laterWatch/list?p=" + PlayerConfig.passportMail + "&u=" + PlayerConfig.userId;
                    _prSeeLaterPanel.init({w:260, h:_core.height, url:url});
                    _prSeeLaterPanel.addEventListener("deleteVideo", function (event:Event) : void
                {
                    var _loc_2:* = String(_prSeeLaterPanel.deleteVideoInfo.vid).split("_")[0];
                    var _loc_3:* = "http://rc.vrs.sohu.com/laterWatch/del?p=" + PlayerConfig.passportMail + "&vid=" + _loc_2 + "&u=" + PlayerConfig.userId + "&y=" + PlayerConfig.yyid + "&pid=" + _prSeeLaterPanel.deleteVideoInfo.pid + "&videoType=" + _prSeeLaterPanel.deleteVideoInfo.type + "&skey=" + Utils.getJSVar("_flash.skey");
                    new URLLoaderUtil().send(_loc_3);
                    ExternalInterface.call("deleteVideo", _loc_2);
                    setSLTip();
                    return;
                }// end function
                );
                    _prSeeLaterPanel.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
                {
                    clearTimeout(_slTimer);
                    return;
                }// end function
                );
                    _prSeeLaterPanel.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
                {
                    var evt:* = event;
                    clearTimeout(_slTimer);
                    _slTimer = setTimeout(function () : void
                    {
                        closePRSeeLaterPanel();
                        return;
                    }// end function
                    , 10000);
                    return;
                }// end function
                );
                    _prSeeLaterPanel.addEventListener("CLOSE_EVT", function (event:Event) : void
                {
                    return;
                }// end function
                );
                    _prSeeLaterPanel.addEventListener("loadAndPlay", function (event:Event) : void
                {
                    _listMode = "sl";
                    _isLoadAndPlayEvent = true;
                    _prPlayList.setVideoInfo(_prSeeLaterPanel.vid, _prSeeLaterPanel.videoType == 1 ? (false) : (true), "稍后看内容", PlayerConfig.videoTitle);
                    _prPlayList.playVideo();
                    return;
                }// end function
                );
                    _seeLaterPanelContainer.y = 0;
                    _seeLaterPanelContainer.x = _core.width;
                    _seeLaterPanelContainer.addChild(_prSeeLaterPanel);
                    _seeLaterPanelContainer.addChild(_openSeeLater_btn);
                    _seeLaterPanelContainer.addChild(_closeSeeLater_btn);
                    setSkinState();
                    _closeSeeLater_btn.visible = false;
                    _openSeeLater_btn.visible = true;
                    ;
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/PRSeeLaterPanel.swf");
            }
            else if (this._seeLaterPanelContainer.x == _core.width - 260)
            {
                this.closePRSeeLaterPanel();
            }
            else
            {
                this.openPRSeeLaterPanel();
            }
            return;
        }// end function

        private function setSLTip(event:Event = null) : void
        {
            return;
        }// end function

        override public function get panel()
        {
            return this._prPlayList;
        }// end function

        public static function getInstance() : RadioMpb
        {
            if (singleton == null)
            {
                singleton = new RadioMpb;
            }
            return singleton;
        }// end function

    }
}

class PRPlayList extends EventDispatcher
{
    private var _playList:Array;
    private var _currentIndex:int = 0;
    private var _videoInfoObj:Object;

    function PRPlayList()
    {
        this._playList = [];
        this._videoInfoObj = new Object();
        var _loc_1:* = "http://rc.vrs.sohu.com/personalRc?p=" + PlayerConfig.passportMail + "&u=" + PlayerConfig.userId + "&isPlayer=1";
        this.loadPlayList(_loc_1);
        return;
    }// end function

    private function loadPlayList(param1:String) : void
    {
        var url:* = param1;
        new URLLoaderUtil().load(10, function (param1:Object) : void
        {
            var _loc_2:String = null;
            var _loc_3:Object = null;
            if (param1.info == "success")
            {
                _loc_2 = param1.data;
                _loc_2 = _loc_2.replace("fn&&fn(", "");
                _loc_2 = _loc_2.substring(0, _loc_2.lastIndexOf(")"));
                _loc_3 = new JSON().parse(_loc_2);
                if (_loc_3 != null && _loc_3.status == 1)
                {
                    insertListData(_loc_3);
                    startPlay();
                    ;
                }
                ;
            }
            return;
        }// end function
        , url);
        return;
    }// end function

    private function startPlay() : void
    {
        dispatchEvent(new Event("dataLoaded"));
        return;
    }// end function

    private function initPlayList() : void
    {
        return;
    }// end function

    private function insertListData(param1:Object) : void
    {
        var _loc_3:uint = 0;
        var _loc_4:uint = 0;
        var _loc_5:Object = null;
        var _loc_6:uint = 0;
        var _loc_7:String = null;
        var _loc_8:uint = 0;
        var _loc_9:uint = 0;
        var _loc_10:Object = null;
        var _loc_11:uint = 0;
        var _loc_12:String = null;
        if (param1.longVideoTopics != null)
        {
            _loc_3 = 0;
            while (_loc_3 < param1.longVideoTopics.length)
            {
                
                _loc_4 = 0;
                while (_loc_4 < param1.longVideoTopics[_loc_3].videos.length)
                {
                    
                    _loc_5 = param1.longVideoTopics[_loc_3].videos[_loc_4];
                    _loc_6 = 0;
                    while (_loc_6 < _loc_5.playlistVids.length)
                    {
                        
                        _loc_7 = _loc_5.vid == _loc_5.playlistVids[_loc_6] ? (_loc_5.bigPlayerReason) : ("");
                        this._playList.push({vid:_loc_5.playlistVids[_loc_6], videoType:_loc_5.videoType, bigPlayerReason:_loc_7, videoName:_loc_5.videoName, skipNum:1});
                        _loc_6 = _loc_6 + 1;
                    }
                    _loc_4 = _loc_4 + 1;
                }
                _loc_3 = _loc_3 + 1;
            }
        }
        if (param1.shortVideoTopics != null)
        {
            _loc_8 = 0;
            while (_loc_8 < param1.shortVideoTopics.length)
            {
                
                _loc_9 = 0;
                while (_loc_9 < param1.shortVideoTopics[_loc_8].videos.length)
                {
                    
                    _loc_10 = param1.shortVideoTopics[_loc_8].videos[_loc_9];
                    if (_loc_10.playlistVids != null)
                    {
                        _loc_11 = 0;
                        while (_loc_11 < _loc_10.playlistVids.length)
                        {
                            
                            _loc_12 = _loc_10.vid == _loc_10.playlistVids[_loc_11] ? (_loc_10.bigPlayerReason) : ("");
                            this._playList.push({vid:_loc_10.playlistVids[_loc_11], videoType:_loc_10.videoType, bigPlayerReason:_loc_12, videoName:_loc_10.videoName, skipNum:1});
                            _loc_11 = _loc_11 + 1;
                        }
                    }
                    else
                    {
                        this._playList.push({vid:_loc_10.vid, videoType:_loc_10.videoType, bigPlayerReason:_loc_10.bigPlayerReason, videoName:_loc_10.videoName, skipNum:1});
                    }
                    _loc_9 = _loc_9 + 1;
                }
                _loc_8 = _loc_8 + 1;
            }
        }
        var _loc_2:uint = 0;
        while (_loc_2 < this._playList.length)
        {
            
            if (this._playList[_loc_2].vid == PlayerConfig.hdVid.split("_")[0])
            {
                this._currentIndex = _loc_2;
                break;
            }
            _loc_2 = _loc_2 + 1;
        }
        return;
    }// end function

    public function setVideoInfo(param1:String, param2:Boolean, param3:String = "", param4:String = "") : void
    {
        this._videoInfoObj = {isMyorVrs:param2, vid:param1, bigPlayerReason:param3, videoName:param4};
        return;
    }// end function

    public function getRecommendReason(param1:String) : String
    {
        var _loc_2:* = undefined;
        for each (_loc_2 in this._playList)
        {
            
            if (String(_loc_2.vid) == String(param1))
            {
                return _loc_2.bigPlayerReason;
            }
        }
        return "";
    }// end function

    public function playVideo() : void
    {
        dispatchEvent(new Event("playListVideo"));
        return;
    }// end function

    public function getVideoInfo() : Object
    {
        return this._videoInfoObj;
    }// end function

    public function hasNext(param1:Boolean = false) : Boolean
    {
        if (param1 && this._playList[this._currentIndex].skipNum != null)
        {
            return this._currentIndex + this._playList[this._currentIndex].skipNum < this._playList.length;
        }
        return (this._currentIndex + 1) < this._playList.length;
    }// end function

    public function nextPlay(param1:Boolean = false) : void
    {
        if (param1 && this._playList[this._currentIndex].skipNum != null)
        {
            this._currentIndex = this._currentIndex + this._playList[this._currentIndex].skipNum;
        }
        else
        {
            var _loc_2:String = this;
            var _loc_3:* = this._currentIndex + 1;
            _loc_2._currentIndex = _loc_3;
        }
        this.setVideoInfo(this._playList[this._currentIndex].vid, this._playList[this._currentIndex].videoType == 1 ? (false) : (true), this._playList[this._currentIndex].bigPlayerReason, this._playList[this._currentIndex].videoName);
        this.playVideo();
        return;
    }// end function

}

