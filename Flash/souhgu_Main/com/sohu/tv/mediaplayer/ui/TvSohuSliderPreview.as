package com.sohu.tv.mediaplayer.ui
{
    import com.greensock.*;
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.controls.*;
    import ebing.events.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;
    import flash.utils.*;

    public class TvSohuSliderPreview extends SliderPreview
    {
        private var _dotClass:Class;
        private var _dotsBtnArr:Array;
        private var _previewTip2_mc:MovieClip;
        private var _isOver:Boolean = false;
        private var _dotSeekTIme:Number = 0;
        private var _commonPPBg_mc:MovieClip;
        private var _height:Number = 0;
        private var _hidePT2TimeoutId:Number = 0;
        private var _spDotsBtn:Sprite;
        private var _previewPicCore:TvSohuPicPreview;
        private var _currentTime:Number = 0;
        private var _multiImgPreview:MovieClip;
        private var _maskMultiSp:Sprite;
        private var _isShowPic:Boolean = false;
        private var _newPreviewTip:Object;
        private var _allPicObj:Object;
        private var _DotsTimeArr:Array;
        private var prevY:Number = 0;
        private var curY:Number = 0;
        private var _hideNewPreview:Boolean = false;
        private var _isMove:Boolean = true;
        private var _isKeyboard:Boolean = false;
        private var _line:MovieClip;
        private var _width:Number = 0;
        private var tipBgX:Number = 0;
        private var _sliderDiffHeight:Number = 0;
        private var _dotsIsai:Boolean = false;
        private var _sliderOverId:Number = 0;
        private var _isShowPicPreview:Boolean = false;
        private var _isAdMode:Boolean = false;
        private var _clickTimes:Number = 0;
        private static const DOLLOP_WIDTH_WIDE:uint = 15;
        private static const DOLLOP_WIDTH_NARROW:uint = 5;
        private static const DOLLOP_HEIGHT_WIDE:uint = 14;
        private static const DOLLOP_HEIGHT_NARROW:uint = 4;
        private static const DOLLOP_NARROW_Y:int = 10;
        private static const DOLLOP_WIDE_Y:int = 0;
        private static const SLIDER_NARROW_Y:int = 11;
        private static const SLIDER_WIDE_Y:int = 1;
        private static const DOTS_NARROW_Y:int = 9;
        private static const DOTS_WIDE_Y:int = 1;
        private static const DOTS_WIDTH_WIDE:uint = 12;
        private static const DOTS_WIDTH_NARROW:uint = 6;
        private static const TIME_WIDE:Number = 0.1;
        private static const TIME_NARROW:Number = 0.1;
        public static const SLIDER_WIDTH_WIDE:uint = 12;
        public static const SLIDER_WIDTH_NARROW:uint = 2;
        private static const STATUS_SLIDER_THICK:int = 0;
        private static const STATUS_SLIDER_SHOW:int = 1;

        public function TvSohuSliderPreview(param1:Object)
        {
            this._line = new MovieClip();
            this._dotClass = param1.skin.dotClass;
            this._dotsBtnArr = new Array();
            this._spDotsBtn = new Sprite();
            this._previewTip2_mc = param1.skin.previewTip2;
            this._commonPPBg_mc = param1.skin.commonPPBg;
            if (param1.skin.multiImgPreview)
            {
                this._multiImgPreview = param1.skin.multiImgPreview;
            }
            if (param1.skin.newPreviewTip)
            {
                this._newPreviewTip = param1.skin.newPreviewTip;
            }
            if (param1.skin.line)
            {
                this._line = param1.skin.line;
            }
            super(param1);
            if (PlayerConfig.pvpic != null && PlayerConfig.isPreviewPic)
            {
                this._isShowPicPreview = true;
            }
            return;
        }// end function

        override protected function addEvent() : void
        {
            super.addEvent();
            this._previewTip2_mc.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                dotOutHandler();
                dispatchEvent(new Event("newPreOut"));
                return;
            }// end function
            );
            this._previewTip2_mc.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                clearTimeout(_hidePT2TimeoutId);
                dispatchEvent(new Event("newPreOver"));
                return;
            }// end function
            );
            return;
        }// end function

        override protected function newFunc() : void
        {
            super.newFunc();
            return;
        }// end function

        override protected function sysInit(param1:String) : void
        {
            super.sysInit(param1);
            Utils.drawRect(_hit_spr, 0, 0, 1, _middle_mc.height + 11, 16777215, 0);
            _hit_spr.y = _hit_spr.y - 4;
            return;
        }// end function

        public function get hitSpr() : Sprite
        {
            return _hit_spr;
        }// end function

        override protected function drawSkin() : void
        {
            addChild(this._commonPPBg_mc);
            var _loc_3:int = 0;
            this._commonPPBg_mc.y = 0;
            this._commonPPBg_mc.x = _loc_3;
            super.drawSkin();
            if (this._line != null)
            {
                _container.addChild(this._line);
                _container.swapChildren(this._line, _dollop_btn);
                _container.swapChildren(this._line, _hit_spr);
                this._line.y = _hit_spr.y;
            }
            if (this._previewTip2_mc != null)
            {
                addChild(this._previewTip2_mc);
                this._previewTip2_mc.visible = false;
                var _loc_3:int = 0;
                this._previewTip2_mc.y = 0;
                this._previewTip2_mc.x = _loc_3;
                this._previewTip2_mc.title_txt.autoSize = TextFieldAutoSize.LEFT;
            }
            var _loc_1:* = Utils.getMaxWidth([_back_btn, _forward_btn, _container, this._commonPPBg_mc]);
            var _loc_2:* = Utils.getMaxHeight([_back_btn, _forward_btn, _container, this._commonPPBg_mc]);
            Utils.setCenterByNumber(_back_btn, _loc_1, _loc_2);
            Utils.setCenterByNumber(_forward_btn, _loc_1, _loc_2);
            Utils.setCenterByNumber(_container, _loc_1, _loc_2);
            _container.x = 1;
            var _loc_3:Boolean = false;
            _back_btn.visible = false;
            _forward_btn.visible = _loc_3;
            var _loc_3:* = _loc_2;
            this._sliderDiffHeight = _loc_2;
            this._height = _loc_3;
            if (this._newPreviewTip != null)
            {
                addChildAt(this._newPreviewTip, 0);
                this._newPreviewTip.addEventListener(MouseEvent.MOUSE_OVER, this.newPreOver);
                this._newPreviewTip.addEventListener(MouseEvent.MOUSE_OUT, this.newPreOut);
                this._newPreviewTip.visible = false;
                var _loc_3:int = 0;
                this._newPreviewTip.y = 0;
                this._newPreviewTip.x = _loc_3;
                this._previewPicCore = new TvSohuPicPreview();
                if (this._isShowPicPreview)
                {
                    this._previewPicCore.hardInit({bigPicUrl:PlayerConfig.pvpic.big, smallPicUrl:PlayerConfig.pvpic.small});
                }
                else
                {
                    this._previewPicCore.hardInit();
                }
                this._previewPicCore.addEventListener("smallComplete", this.smallComplete);
                this._previewPicCore.addEventListener("bigComplete", this.bigComplete);
                this._newPreviewTip.picPreviewBg.visible = true;
                this._newPreviewTip.isaiMc.visible = false;
                this._newPreviewTip.picPreviewBg.tipBg.width = this._previewPicCore.bWidth + 4;
                this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4;
                var _loc_3:* = this._previewPicCore.bWidth;
                this._newPreviewTip.picPreviewBg.shadowline.width = this._previewPicCore.bWidth;
                this._newPreviewTip.picPreviewBg.shadow.width = _loc_3;
                this._newPreviewTip.picPreviewBg.shadow.height = this._previewPicCore.bHeight;
                this.tipBgX = this._newPreviewTip.picPreviewBg.tipBg.x;
                this._newPreviewTip.picPreviewBg.tipBg.x = this._newPreviewTip.picPreviewBg.tipBg.x + (160 - this._previewPicCore.bWidth) / 2;
                this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                this._newPreviewTip.picPreviewBg.shadow.y = this._newPreviewTip.picPreviewBg.tipBg.y - this._newPreviewTip.picPreviewBg.tipBg.height + 4;
                this._newPreviewTip.picPreviewBg.shadow.addEventListener(MouseEvent.MOUSE_OVER, this.shadowOver);
                this._newPreviewTip.picPreviewBg.shadow.addEventListener(MouseEvent.MOUSE_OUT, this.shadowOut);
                this._newPreviewTip.picPreviewBg.shadow.alpha = 1;
                this._newPreviewTip.picPreviewBg.titleTxt.width = this._previewPicCore.bWidth + 6;
                this._newPreviewTip.picPreviewBg.titleTxt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 12;
                this._newPreviewTip.picPreviewBg.titleTxt.visible = false;
                this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
                if (this._multiImgPreview != null)
                {
                    addChildAt(this._multiImgPreview, 0);
                    this._maskMultiSp = new Sprite();
                    Utils.drawRect(this._maskMultiSp, 0, 0, this._previewPicCore.bWidth, this._previewPicCore.bHeight, 0, 1);
                    this._multiImgPreview.bigPreviewMc.imgBg.width = this._previewPicCore.bHeight + 4;
                    this._multiImgPreview.bigPreviewMc.imgBg.height = this._previewPicCore.bHeight + 4;
                    this._multiImgPreview.bigPreviewMc.addChild(this._maskMultiSp);
                    this._maskMultiSp.x = this._multiImgPreview.bigPreviewMc.imgBg.x + 1.5;
                    this._maskMultiSp.y = this._multiImgPreview.bigPreviewMc.imgBg.y - this._multiImgPreview.bigPreviewMc.imgBg.height + 3;
                    this._multiImgPreview.bigPreviewMc.y = 0;
                    this._multiImgPreview.visible = false;
                    this._multiImgPreview.x = 0;
                    this._multiImgPreview.y = this._newPreviewTip.y + 2;
                    this._multiImgPreview.bigPreviewMc.shadowline.width = this._previewPicCore.bWidth;
                    Utils.setCenter(this._multiImgPreview.bigPreviewMc.time_txt, this._multiImgPreview.bigPreviewMc.shadowline);
                }
            }
            return;
        }// end function

        private function resizeNewPreviewTip() : void
        {
            this._newPreviewTip.picPreviewBg.tipBg.x = this.tipBgX;
            this._newPreviewTip.picPreviewBg.tipBg.width = this._previewPicCore.bWidth + 4;
            this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4;
            var _loc_1:* = this._previewPicCore.bWidth;
            this._newPreviewTip.picPreviewBg.shadowline.width = this._previewPicCore.bWidth;
            this._newPreviewTip.picPreviewBg.shadow.width = _loc_1;
            this._newPreviewTip.picPreviewBg.shadow.height = this._previewPicCore.bHeight;
            this._newPreviewTip.picPreviewBg.tipBg.x = this._newPreviewTip.picPreviewBg.tipBg.x + (160 - this._previewPicCore.bWidth) / 2;
            this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
            this._newPreviewTip.picPreviewBg.shadow.y = this._newPreviewTip.picPreviewBg.tipBg.y - this._newPreviewTip.picPreviewBg.tipBg.height + 4;
            this._newPreviewTip.picPreviewBg.shadow.alpha = 1;
            this._newPreviewTip.picPreviewBg.titleTxt.width = this._previewPicCore.bWidth + 6;
            this._newPreviewTip.picPreviewBg.titleTxt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 12;
            this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
            this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
            this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
            if (this._multiImgPreview != null)
            {
                this._maskMultiSp.width = this._previewPicCore.bWidth;
                this._maskMultiSp.height = this._previewPicCore.bHeight;
                this._multiImgPreview.bigPreviewMc.imgBg.width = this._previewPicCore.bHeight + 4;
                this._multiImgPreview.bigPreviewMc.imgBg.height = this._previewPicCore.bHeight + 4;
                this._maskMultiSp.x = this._multiImgPreview.bigPreviewMc.imgBg.x + 1.5;
                this._maskMultiSp.y = this._multiImgPreview.bigPreviewMc.imgBg.y - this._multiImgPreview.bigPreviewMc.imgBg.height + 3;
                this._multiImgPreview.bigPreviewMc.y = 0;
                this._multiImgPreview.x = 0;
                this._multiImgPreview.y = this._newPreviewTip.y + 2;
                this._multiImgPreview.bigPreviewMc.shadowline.width = this._previewPicCore.bWidth;
                Utils.setCenter(this._multiImgPreview.bigPreviewMc.time_txt, this._multiImgPreview.bigPreviewMc.shadowline);
            }
            return;
        }// end function

        public function downLoadPic() : void
        {
            if (this._previewPicCore != null)
            {
                if (PlayerConfig.pvpic.big != null && PlayerConfig.pvpic.big != "" && PlayerConfig.pvpic.small != null && PlayerConfig.pvpic.small != "")
                {
                    this._previewPicCore.hardInit({bigPicUrl:PlayerConfig.pvpic.big, smallPicUrl:PlayerConfig.pvpic.small});
                    this._previewPicCore.startLoadPic();
                }
                if (this._newPreviewTip != null)
                {
                    this._previewPicCore.initPicArr();
                    var _loc_1:Boolean = false;
                    this._newPreviewTip.picPreviewBg.shadow.useHandCursor = false;
                    this._newPreviewTip.picPreviewBg.shadow.buttonMode = _loc_1;
                    this._newPreviewTip.picPreviewBg.previewMore.removeEventListener(MouseEvent.CLICK, this.goToFlatWall);
                    this._newPreviewTip.picPreviewBg.shadow.removeEventListener(MouseEvent.CLICK, this.goToFlatWall);
                    this.resizeNewPreviewTip();
                }
            }
            return;
        }// end function

        private function shadowOver(event:MouseEvent) : void
        {
            this._newPreviewTip.picPreviewBg.shadow.alpha = 1;
            return;
        }// end function

        private function shadowOut(event:MouseEvent) : void
        {
            this._newPreviewTip.picPreviewBg.shadow.alpha = 1;
            return;
        }// end function

        public function clearPreviewPic() : void
        {
            if (this._multiImgPreview != null)
            {
                while (this._multiImgPreview.smallPreviewMc.numChildren)
                {
                    
                    this._multiImgPreview.smallPreviewMc.removeChildAt(0);
                }
            }
            if (this._newPreviewTip != null)
            {
                this._previewPicCore.initPicArr();
                var _loc_1:Boolean = false;
                this._newPreviewTip.picPreviewBg.shadow.useHandCursor = false;
                this._newPreviewTip.picPreviewBg.shadow.buttonMode = _loc_1;
                this._newPreviewTip.picPreviewBg.previewMore.removeEventListener(MouseEvent.CLICK, this.goToFlatWall);
                this._newPreviewTip.picPreviewBg.shadow.removeEventListener(MouseEvent.CLICK, this.goToFlatWall);
                this.resizeNewPreviewTip();
            }
            return;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            super.enabled = param1;
            var _loc_2:int = 0;
            if (param1)
            {
                _middle_mc.visible = true;
                this._isAdMode = false;
            }
            if (!this._isAdMode)
            {
                if (this._dotsBtnArr.length > 0)
                {
                    _loc_2 = 0;
                    while (_loc_2 < this._dotsBtnArr.length)
                    {
                        
                        this._dotsBtnArr[_loc_2].btn.buttonMode = true;
                        this._dotsBtnArr[_loc_2].btn.useHandCursor = true;
                        this._dotsBtnArr[_loc_2].btn.addEventListener(MouseEventUtil.CLICK, this.dotClickHandler);
                        _loc_2++;
                    }
                }
                if (PlayerConfig.pvpic != null && PlayerConfig.isPreviewPic)
                {
                    this._isShowPicPreview = true;
                    if (_previewTip_mc != null)
                    {
                        _previewTip_mc.visible = false;
                    }
                }
            }
            else
            {
                if (this._dotsBtnArr.length > 0)
                {
                    _loc_2 = 0;
                    while (_loc_2 < this._dotsBtnArr.length)
                    {
                        
                        this._dotsBtnArr[_loc_2].btn.buttonMode = false;
                        this._dotsBtnArr[_loc_2].btn.useHandCursor = false;
                        this._dotsBtnArr[_loc_2].btn.removeEventListener(MouseEventUtil.CLICK, this.dotClickHandler);
                        _loc_2++;
                    }
                }
                this._isShowPicPreview = false;
            }
            return;
        }// end function

        public function set isAdMode(param1:Boolean) : void
        {
            this._isAdMode = param1;
            return;
        }// end function

        override public function backward() : void
        {
            this._isKeyboard = true;
            super.backward();
            return;
        }// end function

        override public function forward() : void
        {
            this._isKeyboard = true;
            super.forward();
            return;
        }// end function

        override protected function downHandler(param1:MouseEventUtil) : void
        {
            super.downHandler(param1);
            switch(param1.target)
            {
                case _forward_btn:
                {
                    if (!this._isKeyboard)
                    {
                        SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_ForwardMouse");
                    }
                    this._isKeyboard = false;
                    break;
                }
                case _back_btn:
                {
                    if (!this._isKeyboard)
                    {
                        SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_BackwardMouse");
                    }
                    this._isKeyboard = false;
                    break;
                }
                case _dollop_btn:
                {
                    if (this._newPreviewTip != null && this._isShowPicPreview)
                    {
                        this._newPreviewTip.visible = false;
                        if (!this._hideNewPreview)
                        {
                            this._multiImgPreview.visible = true;
                        }
                        this.getMultiImgStatus();
                        this.getMultiPositionPic(this._currentTime);
                        this._isOver = true;
                    }
                    SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_ClickDragProgress");
                    this.clickTimes();
                    break;
                }
                case _hit_spr:
                {
                    SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_ClickProgress");
                    this.clickTimes();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function clickTimes() : void
        {
            if (this._clickTimes < 2)
            {
                var _loc_1:String = this;
                var _loc_2:* = this._clickTimes + 1;
                _loc_1._clickTimes = _loc_2;
            }
            else
            {
                dispatchEvent(new Event("proKeyboardTip"));
                this._clickTimes = 0;
            }
            return;
        }// end function

        override protected function upHandler(param1:MouseEventUtil) : void
        {
            switch(param1.target)
            {
                case _dollop_btn:
                {
                    if (this._newPreviewTip != null && this._isShowPicPreview)
                    {
                        this._multiImgPreview.visible = false;
                        while (this._multiImgPreview.bigPreviewMc.bitMapMc.numChildren)
                        {
                            
                            this._multiImgPreview.bigPreviewMc.bitMapMc.removeChildAt(0);
                        }
                        this._isOver = false;
                    }
                    if (!_isSliderEnd)
                    {
                        dispatch(SliderEventUtil.SLIDE_END, {sign:0, rate:_topRate_num});
                    }
                    stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.moveHandler);
                    break;
                }
                case _forward_btn:
                {
                    clearTimeout(_mouseDownId);
                    clearInterval(_exeId);
                    _seekNum = -1;
                    if (!_ttt)
                    {
                        this.speedForward(true);
                    }
                    else
                    {
                        _ttt = false;
                        dispatch(SliderEventUtil.SLIDE_END, {sign:0, rate:_topRate_num});
                    }
                    break;
                }
                case _back_btn:
                {
                    clearTimeout(_mouseDownId);
                    clearInterval(_exeId);
                    _seekNum = -1;
                    if (!_ttt)
                    {
                        this.speedBack(true);
                    }
                    else
                    {
                        _ttt = false;
                        dispatch(SliderEventUtil.SLIDE_END, {sign:0, rate:_topRate_num});
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

        override protected function moveHandler(event:MouseEvent) : void
        {
            super.moveHandler(event);
            var _loc_2:* = _container.mouseX;
            dispatch(SliderEventUtil.SLIDER_PREVIEW_RATE, {rate:getTopRate(_loc_2)});
            if (this._newPreviewTip != null && this._isShowPicPreview)
            {
                if (event.buttonDown)
                {
                    this.getMultiImgStatus();
                    this.getMultiPositionPic(this._currentTime);
                }
            }
            return;
        }// end function

        override protected function speedForward(param1:Boolean = false) : void
        {
            if (_seekNum == -1)
            {
                _seekNum = _dollop_btn.x + _dollop_btn.width / 2;
            }
            _seekNum = param1 ? (_seekNum + 10) : ((_seekNum + 1));
            if (param1)
            {
                dispatchEvent(new Event("forward"));
            }
            else
            {
                doSlide(_seekNum, 0);
            }
            return;
        }// end function

        override protected function speedBack(param1:Boolean = false) : void
        {
            if (_seekNum == -1)
            {
                _seekNum = _dollop_btn.x + _dollop_btn.width / 2;
            }
            _seekNum = param1 ? (_seekNum - 10) : ((_seekNum - 1));
            if (param1)
            {
                dispatchEvent(new Event("backward"));
            }
            else
            {
                doSlide(_seekNum, 0);
            }
            return;
        }// end function

        public function setDots(param1:Array) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            while (this._spDotsBtn.numChildren)
            {
                
                this._spDotsBtn.removeChildAt(0);
            }
            this._DotsTimeArr = new Array();
            if (param1 != null && param1.length >= 1)
            {
                _loc_2 = 0;
                _loc_3 = 0;
                while (_loc_3 < param1.length)
                {
                    
                    this._dotsBtnArr[_loc_3] = {btn:null, rate:0, time:0, id:"", title:"", type:"", isUpOrDown:false};
                    this._DotsTimeArr[_loc_3] = {time:0, type:"", title:"", isai:"0"};
                    this._dotsBtnArr[_loc_3].btn = new ButtonUtil({skin:new this._dotClass()});
                    if (this._dotsBtnArr[_loc_3].btn.skin["num_txt"] != null)
                    {
                        if (param1[_loc_3].type == "s")
                        {
                            this._dotsBtnArr[_loc_3].btn.skin["num_txt"].text = "S";
                        }
                        else if (param1[_loc_3].type == "e")
                        {
                            this._dotsBtnArr[_loc_3].btn.skin["num_txt"].text = "E";
                        }
                    }
                    this._dotsBtnArr[_loc_3].btn.obj = {index:_loc_3};
                    this._dotsBtnArr[_loc_3].btn.addEventListener(MouseEventUtil.CLICK, this.dotClickHandler);
                    this._dotsBtnArr[_loc_3].btn.addEventListener(MouseEventUtil.MOUSE_OVER, this.dotOverHandler);
                    this._dotsBtnArr[_loc_3].btn.addEventListener(MouseEventUtil.MOUSE_OUT, this.dotOutHandler);
                    this._dotsBtnArr[_loc_3].rate = param1[_loc_3].rate;
                    this._dotsBtnArr[_loc_3].time = param1[_loc_3].time;
                    this._dotsBtnArr[_loc_3].id = param1[_loc_3].id;
                    this._dotsBtnArr[_loc_3].title = param1[_loc_3].title;
                    this._dotsBtnArr[_loc_3].type = param1[_loc_3].type;
                    this._dotsBtnArr[_loc_3].isai = param1[_loc_3].isai;
                    this._spDotsBtn.addChildAt(this._dotsBtnArr[_loc_3].btn, 0);
                    Utils.setCenter(this._dotsBtnArr[_loc_3].btn, _bottom_mc);
                    this._dotsBtnArr[_loc_3].btn.x = Math.round(this._dotsBtnArr[_loc_3].rate * _bottom_mc.width + _dollop_btn.width / 2);
                    this._DotsTimeArr[_loc_3].time = param1[_loc_3].time;
                    this._DotsTimeArr[_loc_3].type = param1[_loc_3].type;
                    this._DotsTimeArr[_loc_3].title = param1[_loc_3].title;
                    _loc_3 = _loc_3 + 1;
                }
                _container.addChild(this._spDotsBtn);
                _container.setChildIndex(_dollop_btn, (_container.numChildren - 1));
            }
            return;
        }// end function

        public function removeDotsBtn() : void
        {
            while (this._spDotsBtn.numChildren)
            {
                
                this._spDotsBtn.removeChildAt(0);
            }
            this._DotsTimeArr = [];
            this._allPicObj = null;
            this._isMove = true;
            this._isShowPicPreview = false;
            return;
        }// end function

        public function get allPicObj() : Object
        {
            return this._allPicObj;
        }// end function

        public function get dotSeekTime() : Number
        {
            return this._dotSeekTIme;
        }// end function

        private function dotClickHandler(param1:MouseEventUtil) : void
        {
            this._dotSeekTIme = this._dotsBtnArr[param1.target.obj.index].time;
            dispatchEvent(new Event("dot_seek"));
            return;
        }// end function

        private function dotOverHandler(param1:MouseEventUtil) : void
        {
            var _loc_2:* = new Array();
            var _loc_3:int = 0;
            var _loc_4:* = new MovieClip();
            var _loc_5:* = new MovieClip();
            var _loc_6:* = _container.x + param1.currentTarget.x;
            if (this._newPreviewTip != null && this._isShowPicPreview)
            {
                clearTimeout(this._hidePT2TimeoutId);
                if (this._dotsBtnArr[param1.target.obj.index].isai == "1")
                {
                    this._dotsIsai = true;
                    this._newPreviewTip.picPreviewBg.visible = false;
                    this._newPreviewTip.isaiMc.title_txt.htmlText = Utils.fomatTime(this._dotsBtnArr[param1.target.obj.index].time) + " " + this._dotsBtnArr[param1.target.obj.index].title;
                    if (this._dotsBtnArr[param1.target.obj.index].title.length > 12)
                    {
                        this._newPreviewTip.isaiMc.tipBg.height = this._newPreviewTip.isaiMc.title_txt.textHeight + 25;
                        this._newPreviewTip.isaiMc.title_txt.y = this._newPreviewTip.isaiMc.tipBg.y - this._newPreviewTip.isaiMc.tipBg.height + 11;
                    }
                    else
                    {
                        this._newPreviewTip.isaiMc.tipBg.height = this._newPreviewTip.isaiMc.title_txt.textHeight + 18;
                        this._newPreviewTip.isaiMc.title_txt.y = this._newPreviewTip.isaiMc.tipBg.y - this._newPreviewTip.isaiMc.tipBg.height + 11;
                    }
                    _loc_3 = 0;
                    while (_loc_3 < this._newPreviewTip.isaiMc.typeIcon.numChildren)
                    {
                        
                        _loc_4 = this._newPreviewTip.isaiMc.typeIcon.getChildAt(_loc_3) as MovieClip;
                        _loc_4.visible = false;
                        _loc_2.push(_loc_4);
                        _loc_3++;
                    }
                    _loc_5 = _loc_2[this._dotsBtnArr[param1.target.obj.index].type] as MovieClip;
                    _loc_5.visible = true;
                    this._newPreviewTip.isaiMc.typeIcon.x = this._newPreviewTip.isaiMc.tipBg.x - 13;
                    this._newPreviewTip.isaiMc.typeIcon.y = this._newPreviewTip.isaiMc.tipBg.y - this._newPreviewTip.isaiMc.tipBg.height - 13;
                    this._newPreviewTip.isaiMc.visible = true;
                    SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_bfqhdbjd&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                }
                else
                {
                    this._dotsIsai = false;
                    this._newPreviewTip.picPreviewBg.visible = true;
                    this._newPreviewTip.isaiMc.visible = false;
                    this._newPreviewTip.picPreviewBg.titleTxt.visible = true;
                    this._newPreviewTip.picPreviewBg.titleTxt.htmlText = this._dotsBtnArr[param1.target.obj.index].title;
                    this._newPreviewTip.picPreviewBg.titleTxt.filters = new Array(new GlowFilter(0, 1, 2, 2, 255));
                    if (this._dotsBtnArr[param1.target.obj.index].title.length > 12)
                    {
                        this._newPreviewTip.picPreviewBg.titleTxt.height = this._newPreviewTip.picPreviewBg.titleTxt.textHeight + 12;
                        this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4 + this._newPreviewTip.picPreviewBg.titleTxt.height + 3;
                        Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt, this._newPreviewTip.picPreviewBg.tipBg);
                        this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 8;
                    }
                    else
                    {
                        this._newPreviewTip.picPreviewBg.titleTxt.height = this._newPreviewTip.picPreviewBg.titleTxt.textHeight + 12;
                        this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4 + this._newPreviewTip.picPreviewBg.titleTxt.height;
                        Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt, this._newPreviewTip.picPreviewBg.tipBg);
                        this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 4;
                    }
                }
            }
            else
            {
                this._isOver = true;
                clearTimeout(this._hidePT2TimeoutId);
                if (_loc_6 - this._previewTip2_mc.width / 2 > 0)
                {
                    this._previewTip2_mc.x = _loc_6;
                    if (stage.stageWidth - _loc_6 < this._previewTip2_mc.width / 2)
                    {
                        this._previewTip2_mc.x = stage.stageWidth - this._previewTip2_mc.width / 2 + 5;
                    }
                }
                else if (this._dotsBtnArr[param1.target.obj.index].isai == "1")
                {
                    this._previewTip2_mc.x = this._previewTip2_mc.width / 2 - 5 + 13;
                }
                else
                {
                    this._previewTip2_mc.x = this._previewTip2_mc.width / 2 - 5;
                }
                this._previewTip2_mc.title_txt.htmlText = Utils.fomatTime(this._dotsBtnArr[param1.target.obj.index].time) + " " + this._dotsBtnArr[param1.target.obj.index].title;
                if (this._dotsBtnArr[param1.target.obj.index].title.length > 12)
                {
                    this._previewTip2_mc.title_txt.x = Math.round(this._previewTip2_mc.tipBg.x + (this._previewTip2_mc.tipBg.width - this._previewTip2_mc.title_txt.textWidth) / 2);
                    this._previewTip2_mc.tipBg.height = this._previewTip2_mc.title_txt.textHeight + 25;
                    this._previewTip2_mc.title_txt.y = this._previewTip2_mc.tipBg.y - this._previewTip2_mc.tipBg.height + 11;
                }
                else
                {
                    this._previewTip2_mc.title_txt.x = -76;
                    this._previewTip2_mc.tipBg.height = this._previewTip2_mc.title_txt.textHeight + 18;
                    this._previewTip2_mc.title_txt.y = this._previewTip2_mc.tipBg.y - this._previewTip2_mc.tipBg.height + 11;
                }
                if (this._dotsBtnArr[param1.target.obj.index].isai == "1")
                {
                    _loc_3 = 0;
                    while (_loc_3 < this._previewTip2_mc.typeIcon.numChildren)
                    {
                        
                        _loc_4 = this._previewTip2_mc.typeIcon.getChildAt(_loc_3) as MovieClip;
                        _loc_4.visible = false;
                        _loc_2.push(_loc_4);
                        _loc_3++;
                    }
                    _loc_5 = _loc_2[this._dotsBtnArr[param1.target.obj.index].type] as MovieClip;
                    _loc_5.visible = true;
                    this._previewTip2_mc.typeIcon.x = this._previewTip2_mc.tipBg.x - 13;
                    this._previewTip2_mc.typeIcon.y = this._previewTip2_mc.tipBg.y - this._previewTip2_mc.tipBg.height - 13;
                    this._previewTip2_mc.typeIcon.visible = true;
                    SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_bfqhdbjd&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
                }
                else
                {
                    this._previewTip2_mc.typeIcon.visible = false;
                }
                this.tb();
            }
            return;
        }// end function

        private function tb() : void
        {
            this._previewTip2_mc.visible = true;
            return;
        }// end function

        private function dotOutHandler(param1 = null) : void
        {
            this._dotsIsai = false;
            if (param1 != null && (this._dotsBtnArr[param1.target.obj.index].type == "s" || this._dotsBtnArr[param1.target.obj.index].type == "e"))
            {
                this.hidePreviewTip2();
            }
            else
            {
                clearTimeout(this._hidePT2TimeoutId);
                this._hidePT2TimeoutId = setTimeout(this.hidePreviewTip2, 100);
            }
            return;
        }// end function

        private function hidePreviewTip2() : void
        {
            this._isOver = false;
            this._previewTip2_mc.visible = false;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.sliderMoveHandler);
            stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
            if (this._newPreviewTip != null && PlayerConfig.pvpic != null && PlayerConfig.isPreviewPic)
            {
                this._newPreviewTip.picPreviewBg.tipBg.width = this._previewPicCore.bWidth + 4;
                this._newPreviewTip.picPreviewBg.tipBg.height = this._previewPicCore.bHeight + 4;
                this._newPreviewTip.isaiMc.visible = false;
                this._newPreviewTip.picPreviewBg.titleTxt.visible = false;
                this._newPreviewTip.picPreviewBg.titleTxt.htmlText = "";
                this._newPreviewTip.picPreviewBg.visible = true;
                this._newPreviewTip.visible = false;
            }
            return;
        }// end function

        private function goToFlatWall(event:MouseEvent) : void
        {
            this._newPreviewTip.visible = false;
            dispatchEvent(new Event("wall3DOpen"));
            return;
        }// end function

        private function newPreOver(event:MouseEvent) : void
        {
            clearTimeout(this._hidePT2TimeoutId);
            this._isMove = false;
            if (!this._hideNewPreview)
            {
                this._newPreviewTip.visible = true;
                dispatchEvent(new Event("newPreOver"));
            }
            return;
        }// end function

        private function newPreOut(event:MouseEvent) : void
        {
            this.dotOutHandler();
            this._isMove = true;
            this._newPreviewTip.visible = false;
            dispatchEvent(new Event("newPreOut"));
            return;
        }// end function

        override protected function sliderOverHandler(event:MouseEvent) : void
        {
            var evt:* = event;
            this._sliderOverId = setTimeout(function () : void
            {
                stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMoveHandler);
                stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
                return;
            }// end function
            , 100);
            return;
        }// end function

        override protected function sliderMoveHandler(event:MouseEvent) : void
        {
            if (!enabled)
            {
                return;
            }
            var _loc_2:* = _container.mouseX;
            this.prevY = this.curY;
            this.curY = stage.mouseY;
            if (this._newPreviewTip != null && this._isShowPicPreview)
            {
                this._newPreviewTip.y = _hit_spr.y;
                if (this.mouseX - this._newPreviewTip.width / 2 > 0)
                {
                    this._newPreviewTip.x = this.mouseX;
                    if (stage.stageWidth - this.mouseX < this._newPreviewTip.width / 2)
                    {
                        if (160 - this._previewPicCore.bWidth > 0)
                        {
                            this._newPreviewTip.picPreviewBg.tipBg.x = this.tipBgX + (160 - this._previewPicCore.bWidth);
                            Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt, this._newPreviewTip.picPreviewBg.tipBg);
                            this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 8;
                            this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                            this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                            this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                            this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
                        }
                        this._newPreviewTip.x = stage.stageWidth - this._newPreviewTip.width / 2 + 5;
                    }
                    else if (160 - this._previewPicCore.bWidth > 0)
                    {
                        this._newPreviewTip.picPreviewBg.tipBg.x = this.tipBgX + (160 - this._previewPicCore.bWidth) / 2;
                        Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt, this._newPreviewTip.picPreviewBg.tipBg);
                        this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 8;
                        this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                        this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                        this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                        this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
                    }
                }
                else if (this._dotsIsai)
                {
                    this._newPreviewTip.x = this._newPreviewTip.width / 2 - 5 + 13;
                }
                else
                {
                    if (160 - this._previewPicCore.bWidth > 0)
                    {
                        this._newPreviewTip.picPreviewBg.tipBg.x = this.tipBgX;
                        Utils.setCenter(this._newPreviewTip.picPreviewBg.titleTxt, this._newPreviewTip.picPreviewBg.tipBg);
                        this._newPreviewTip.picPreviewBg.titleTxt.y = this._newPreviewTip.picPreviewBg.shadow.y - this._newPreviewTip.picPreviewBg.titleTxt.textHeight - 8;
                        this._newPreviewTip.picPreviewBg.shadow.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                        this._newPreviewTip.picPreviewBg.shadowline.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                        this._newPreviewTip.picPreviewBg.time_txt.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
                        this._newPreviewTip.picPreviewBg.previewMore.x = this._newPreviewTip.picPreviewBg.shadowline.x + this._newPreviewTip.picPreviewBg.shadow.width - this._newPreviewTip.picPreviewBg.previewMore.width;
                    }
                    this._newPreviewTip.x = this._newPreviewTip.width / 2 - 5;
                }
            }
            else if (this.mouseX - _previewTip_mc.width / 2 > 0)
            {
                if (stage.stageWidth - this.mouseX < _previewTip_mc.width / 2)
                {
                    _previewTip_mc.y = _hit_spr.y;
                    _previewTip_mc.x = this.mouseX - _previewTip_mc.width / 2 + 1;
                }
                else
                {
                    _previewTip_mc.y = _hit_spr.y;
                    _previewTip_mc.x = this.mouseX;
                }
            }
            else
            {
                _previewTip_mc.y = _hit_spr.y;
                _previewTip_mc.x = this.mouseX + _previewTip_mc.width / 2 - 1;
            }
            if (_container.hitTestPoint(stage.mouseX, stage.mouseY) && !this._isOver)
            {
                if (this._line != null)
                {
                    this._line.x = _container.mouseX;
                    this._line.visible = true;
                }
                if (this._newPreviewTip != null && this._isShowPicPreview)
                {
                    _previewTip_mc.visible = false;
                    if (!this._hideNewPreview && !this._newPreviewTip.visible)
                    {
                        this._newPreviewTip.visible = true;
                        this._newPreviewTip.gotoAndPlay(2);
                    }
                    if (this._multiImgPreview != null && this._multiImgPreview.visible)
                    {
                        this._newPreviewTip.visible = false;
                    }
                }
                else if (this._previewTip2_mc.visible)
                {
                    _previewTip_mc.visible = false;
                }
                else
                {
                    _previewTip_mc.visible = true;
                }
            }
            else
            {
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.sliderMoveHandler);
                if (this._line != null)
                {
                    this._line.visible = false;
                }
                if (!this._isShowPicPreview)
                {
                    _previewTip_mc.visible = false;
                }
                else if (this.prevY <= this.curY && this._newPreviewTip != null && this._newPreviewTip.visible)
                {
                    this._newPreviewTip.visible = false;
                    this._newPreviewTip.gotoAndStop(1);
                }
            }
            dispatch(SliderEventUtil.SLIDER_PREVIEW_RATE, {rate:getTopRate(_loc_2)});
            return;
        }// end function

        public function sliderOutHandler() : void
        {
            if (this._line != null)
            {
                this._line.visible = false;
            }
            if (_previewTip_mc != null)
            {
                _previewTip_mc.visible = false;
            }
            if (this._newPreviewTip != null && this._isShowPicPreview)
            {
                this._newPreviewTip.visible = false;
            }
            return;
        }// end function

        private function getPositionPic(param1:Number) : void
        {
            var _loc_2:* = new Bitmap();
            if (this._newPreviewTip.picPreviewBg.bitMapMc.getChildByName("currBitMap") != null)
            {
                this._newPreviewTip.picPreviewBg.bitMapMc.removeChild(this._newPreviewTip.picPreviewBg.bitMapMc.getChildByName("currBitMap"));
            }
            var _loc_3:* = param1;
            var _loc_4:Number = 0;
            if (this._previewPicCore.arrayBigBlocks.length > 0)
            {
                if (PlayerConfig.totalDuration - _loc_3 < this._previewPicCore.timeLimit)
                {
                    _loc_4 = this._previewPicCore.arrayBigBlocks.length - 1;
                }
                else
                {
                    _loc_4 = Math.floor(_loc_3 / this._previewPicCore.timeLimit);
                }
                _loc_2 = this._previewPicCore.arrayBigBlocks[_loc_4];
            }
            _loc_2.name = "currBitMap";
            this._newPreviewTip.picPreviewBg.bitMapMc.addChild(_loc_2);
            this._newPreviewTip.picPreviewBg.bitMapMc.x = this._newPreviewTip.picPreviewBg.tipBg.x + 1;
            this._newPreviewTip.picPreviewBg.bitMapMc.y = this._newPreviewTip.picPreviewBg.tipBg.y - (this._previewPicCore.bHeight + 4) + 4;
            return;
        }// end function

        private function getMultiPositionPic(param1:Number) : void
        {
            var _loc_2:* = new Bitmap();
            var _loc_3:* = param1;
            var _loc_4:Number = 0;
            if (this._previewPicCore.arrayBigBlocks.length > 0)
            {
                if (PlayerConfig.totalDuration - _loc_3 < this._previewPicCore.timeLimit)
                {
                    _loc_4 = this._previewPicCore.arrayBigBlocks.length - 1;
                }
                else
                {
                    _loc_4 = Math.floor(_loc_3 / this._previewPicCore.timeLimit);
                }
                _loc_2 = this._previewPicCore.arrayBigBlocks[_loc_4];
            }
            _loc_2.name = "currBitMap";
            this._multiImgPreview.bigPreviewMc.bitMapMc.addChild(_loc_2);
            this._multiImgPreview.bigPreviewMc.bitMapMc.setChildIndex(_loc_2, (this._multiImgPreview.bigPreviewMc.bitMapMc.numChildren - 1));
            this._multiImgPreview.bigPreviewMc.bitMapMc.x = this._maskMultiSp.x;
            this._multiImgPreview.bigPreviewMc.bitMapMc.y = this._maskMultiSp.y;
            this._multiImgPreview.bigPreviewMc.bitMapMc.mask = this._maskMultiSp;
            this._multiImgPreview.smallPreviewMc.x = this._multiImgPreview.smallPreviewMc.x - _loc_4 * this._previewPicCore.bWidth * 0.8;
            return;
        }// end function

        private function smallComplete(event:Event) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Bitmap = null;
            var _loc_4:Sprite = null;
            if (this._previewPicCore.arraySmallBlocks.length > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this._previewPicCore.totalBlocks)
                {
                    
                    _loc_3 = new Bitmap();
                    _loc_4 = new Sprite();
                    _loc_3 = this._previewPicCore.arraySmallBlocks[_loc_2];
                    Utils.drawRect(_loc_4, 0, 0, _loc_3.width, _loc_3.height + 4, 0, 1);
                    this._multiImgPreview.smallPreviewMc.addChild(_loc_4);
                    this._multiImgPreview.smallPreviewMc.addChild(_loc_3);
                    _loc_3.x = _loc_2 * this._previewPicCore.bWidth;
                    _loc_4.x = _loc_3.x;
                    _loc_4.y = _loc_3.y - 2;
                    _loc_2++;
                }
            }
            var _loc_5:Number = 0.8;
            this._multiImgPreview.smallPreviewMc.scaleY = 0.8;
            this._multiImgPreview.smallPreviewMc.scaleX = _loc_5;
            this._multiImgPreview.smallPreviewMc.y = this._multiImgPreview.bigPreviewMc.y - this._multiImgPreview.bigPreviewMc.imgBg.height + 3 + (this._multiImgPreview.bigPreviewMc.imgBg.height - this._multiImgPreview.smallPreviewMc.height) / 2;
            return;
        }// end function

        private function bigComplete(event:Event) : void
        {
            this._allPicObj = {bytes:this._previewPicCore.bigPicBytes, picW:this._previewPicCore.bWidth, picH:this._previewPicCore.bHeight, timeLimit:this._previewPicCore.timeLimit, totalBlocks:this._previewPicCore.totalBlocks, totalDuration:PlayerConfig.totalDuration, Dots:this._DotsTimeArr};
            if (this._newPreviewTip != null)
            {
                var _loc_2:Boolean = true;
                this._newPreviewTip.picPreviewBg.shadow.useHandCursor = true;
                this._newPreviewTip.picPreviewBg.shadow.buttonMode = _loc_2;
                this._newPreviewTip.picPreviewBg.previewMore.addEventListener(MouseEvent.CLICK, this.goToFlatWall);
                this._newPreviewTip.picPreviewBg.shadow.addEventListener(MouseEvent.CLICK, this.goToFlatWall);
            }
            this.getPositionPic(this._currentTime);
            return;
        }// end function

        override public function set previewTip(param1:String) : void
        {
            if (_previewTip_mc != null)
            {
                _previewTip_mc.time_txt.text = param1;
            }
            if (this._newPreviewTip != null && this._isShowPicPreview)
            {
                this._newPreviewTip.picPreviewBg.time_txt.text = param1;
                if (this._multiImgPreview != null)
                {
                    this._multiImgPreview.bigPreviewMc.time_txt.text = param1;
                }
            }
            return;
        }// end function

        private function getMultiImgStatus() : void
        {
            this._multiImgPreview.bigPreviewMc.x = (stage.stageWidth - this._multiImgPreview.bigPreviewMc.width) / 2;
            this._multiImgPreview.smallPreviewMc.x = this._multiImgPreview.bigPreviewMc.x;
            return;
        }// end function

        public function set currentTime(param1:Number) : void
        {
            this._currentTime = param1;
            try
            {
                if (this._isMove)
                {
                    this.getPositionPic(this._currentTime);
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

        override public function resize(param1:Number) : void
        {
            var _loc_2:uint = 0;
            this._commonPPBg_mc.width = param1;
            super.resize(param1);
            if (this._dotsBtnArr != null && this._dotsBtnArr.length > 0)
            {
                while (_loc_2 < this._dotsBtnArr.length)
                {
                    
                    Utils.setCenter(this._dotsBtnArr[_loc_2].btn, _bottom_mc);
                    this._dotsBtnArr[_loc_2].btn.x = Math.round(this._dotsBtnArr[_loc_2].rate * (_bottom_mc.width - _dollop_btn.width) + _dollop_btn.width / 2);
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        public function onSliderWideStatus(param1:int) : void
        {
            var _loc_2:int = 0;
            switch(param1)
            {
                case STATUS_SLIDER_SHOW:
                {
                    this.visible = true;
                    this.bgResize(stage.stageWidth);
                    break;
                }
                case STATUS_SLIDER_THICK:
                {
                    this.killAllTweens();
                    if (this._dotsBtnArr != null && this._dotsBtnArr.length > 0)
                    {
                        _loc_2 = 0;
                        while (_loc_2 < this._dotsBtnArr.length)
                        {
                            
                            TweenLite.to(this._dotsBtnArr[_loc_2].btn, TIME_WIDE, {y:DOTS_WIDE_Y, width:DOTS_WIDTH_WIDE, height:DOTS_WIDTH_WIDE, onUpdate:this.onSliderHeightChange});
                            _loc_2++;
                        }
                    }
                    TweenLite.to(this._dollop_btn, TIME_WIDE, {alpha:1, y:DOLLOP_WIDE_Y, width:DOLLOP_WIDTH_WIDE, height:DOLLOP_HEIGHT_WIDE, onUpdate:this.onSliderHeightChange});
                    TweenLite.to(this._top_mc, TIME_WIDE, {y:SLIDER_WIDE_Y, height:SLIDER_WIDTH_WIDE, onUpdate:this.onSliderHeightChange});
                    TweenLite.to(this._middle_mc, TIME_WIDE, {y:SLIDER_WIDE_Y, height:SLIDER_WIDTH_WIDE, onUpdate:this.onSliderHeightChange});
                    TweenLite.to(this._bottom_mc, TIME_WIDE, {y:SLIDER_WIDE_Y, height:SLIDER_WIDTH_WIDE, onUpdate:this.onSliderHeightChange, onComplete:this.bgResize, onCompleteParams:[stage.stageWidth]});
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function onSliderNarrowStatus(param1:int) : void
        {
            var _loc_2:int = 0;
            switch(param1)
            {
                case STATUS_SLIDER_SHOW:
                {
                    this.visible = true;
                    this.smResize(stage.stageWidth);
                    break;
                }
                case STATUS_SLIDER_THICK:
                {
                    this._sliderDiffHeight = this._height - SLIDER_WIDTH_NARROW;
                    this.killAllTweens();
                    TweenLite.to(this._dollop_btn, TIME_WIDE, {alpha:0, y:DOLLOP_NARROW_Y, width:DOLLOP_WIDTH_NARROW, height:DOLLOP_HEIGHT_NARROW, onUpdate:this.onSliderHeightChange});
                    if (this._dotsBtnArr != null && this._dotsBtnArr.length > 0)
                    {
                        _loc_2 = 0;
                        while (_loc_2 < this._dotsBtnArr.length)
                        {
                            
                            TweenLite.to(this._dotsBtnArr[_loc_2].btn, TIME_WIDE, {y:DOTS_NARROW_Y, width:DOTS_WIDTH_NARROW, height:DOTS_WIDTH_NARROW, onUpdate:this.onSliderHeightChange});
                            _loc_2++;
                        }
                    }
                    TweenLite.to(this._top_mc, TIME_WIDE, {y:SLIDER_NARROW_Y, height:SLIDER_WIDTH_NARROW, onUpdate:this.onSliderHeightChange});
                    TweenLite.to(this._middle_mc, TIME_WIDE, {y:SLIDER_NARROW_Y, height:SLIDER_WIDTH_NARROW, onUpdate:this.onSliderHeightChange});
                    TweenLite.to(this._bottom_mc, TIME_WIDE, {y:SLIDER_NARROW_Y, height:SLIDER_WIDTH_NARROW, onUpdate:this.onSliderHeightChange, onComplete:this.smResize, onCompleteParams:[stage.stageWidth]});
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function onSliderHeightChange() : void
        {
            this.topRate = topRate;
            middleRate = middleRate;
            return;
        }// end function

        private function bgResize(param1:Number) : void
        {
            var _loc_2:int = 0;
            this._commonPPBg_mc.width = param1;
            _bottom_mc.width = param1;
            var _loc_3:* = SLIDER_WIDTH_WIDE;
            _top_mc.height = SLIDER_WIDTH_WIDE;
            var _loc_3:* = _loc_3;
            _middle_mc.height = _loc_3;
            _bottom_mc.height = _loc_3;
            var _loc_3:int = 0;
            _top_mc.x = 0;
            var _loc_3:* = _loc_3;
            _middle_mc.x = _loc_3;
            _bottom_mc.x = _loc_3;
            var _loc_3:* = SLIDER_WIDE_Y;
            _top_mc.y = SLIDER_WIDE_Y;
            var _loc_3:* = _loc_3;
            _middle_mc.y = _loc_3;
            _bottom_mc.y = _loc_3;
            _dollop_btn.width = DOLLOP_WIDTH_WIDE;
            _dollop_btn.height = DOLLOP_HEIGHT_WIDE;
            _dollop_btn.y = DOLLOP_WIDE_Y;
            _dollop_btn.alpha = 1;
            if (this._dotsBtnArr != null && this._dotsBtnArr.length > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this._dotsBtnArr.length)
                {
                    
                    var _loc_3:* = DOTS_WIDTH_WIDE;
                    this._dotsBtnArr[_loc_2].btn.height = DOTS_WIDTH_WIDE;
                    this._dotsBtnArr[_loc_2].btn.width = _loc_3;
                    this._dotsBtnArr[_loc_2].btn.y = DOTS_WIDE_Y;
                    _loc_2++;
                }
            }
            return;
        }// end function

        private function smResize(param1:Number) : void
        {
            var _loc_2:int = 0;
            this._commonPPBg_mc.width = param1;
            _bottom_mc.width = param1;
            var _loc_3:* = SLIDER_WIDTH_NARROW;
            _top_mc.height = SLIDER_WIDTH_NARROW;
            var _loc_3:* = _loc_3;
            _middle_mc.height = _loc_3;
            _bottom_mc.height = _loc_3;
            var _loc_3:int = 0;
            _top_mc.x = 0;
            var _loc_3:* = _loc_3;
            _middle_mc.x = _loc_3;
            _bottom_mc.x = _loc_3;
            var _loc_3:* = SLIDER_NARROW_Y;
            _top_mc.y = SLIDER_NARROW_Y;
            var _loc_3:* = _loc_3;
            _middle_mc.y = _loc_3;
            _bottom_mc.y = _loc_3;
            _dollop_btn.width = DOLLOP_WIDTH_NARROW;
            _dollop_btn.height = DOLLOP_HEIGHT_NARROW;
            _dollop_btn.y = DOLLOP_NARROW_Y;
            _dollop_btn.alpha = 0;
            if (this._dotsBtnArr != null && this._dotsBtnArr.length > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this._dotsBtnArr.length)
                {
                    
                    var _loc_3:* = DOTS_WIDTH_NARROW;
                    this._dotsBtnArr[_loc_2].btn.height = DOTS_WIDTH_NARROW;
                    this._dotsBtnArr[_loc_2].btn.width = _loc_3;
                    this._dotsBtnArr[_loc_2].btn.y = DOTS_NARROW_Y;
                    _loc_2++;
                }
            }
            return;
        }// end function

        private function killAllTweens() : void
        {
            var _loc_1:int = 0;
            TweenLite.killTweensOf(this._dollop_btn);
            TweenLite.killTweensOf(this._top_mc);
            TweenLite.killTweensOf(this._middle_mc);
            TweenLite.killTweensOf(this._bottom_mc);
            if (this._dotsBtnArr != null && this._dotsBtnArr.length > 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this._dotsBtnArr.length)
                {
                    
                    TweenLite.killTweensOf(this._dotsBtnArr[_loc_1].btn);
                    _loc_1++;
                }
            }
            return;
        }// end function

        override public function set topRate(param1:Number) : void
        {
            super.topRate = param1;
            return;
        }// end function

        public function get dollopBtn() : ButtonUtil
        {
            return _dollop_btn;
        }// end function

        public function get sliderDiffHeight() : Number
        {
            return this._sliderDiffHeight;
        }// end function

        override public function get height() : Number
        {
            return this._height;
        }// end function

        public function set adMode(param1:Boolean) : void
        {
            _middle_mc.visible = !param1;
            return;
        }// end function

        public function set hideNewPreview(param1:Boolean) : void
        {
            this._hideNewPreview = param1;
            return;
        }// end function

        private function drawCloseBtn(param1:Number, param2:Number, param3:uint, param4:uint) : Sprite
        {
            var _loc_5:* = new Sprite();
            var _loc_6:* = new TextField();
            var _loc_7:* = new TextFormat();
            new TextFormat().color = param4;
            _loc_7.size = 12;
            _loc_6.autoSize = TextFieldAutoSize.LEFT;
            _loc_6.defaultTextFormat = _loc_7;
            _loc_6.selectable = false;
            _loc_6.text = "预览墙";
            _loc_5.addChild(_loc_6);
            Utils.drawRoundRect(_loc_5, 0, 0, param1, param2, 6, param3, 0.3);
            Utils.setCenter(_loc_6, _loc_5);
            (_loc_6.y - 1);
            return _loc_5;
        }// end function

        private function getTxtBitmap(param1:TextField) : Bitmap
        {
            var _loc_2:* = new Sprite();
            _loc_2.addChild(param1);
            var _loc_3:* = new BitmapData(param1.width, param1.height, true, 0);
            _loc_3.draw(_loc_2);
            var _loc_4:* = new Bitmap(_loc_3);
            return new Bitmap(_loc_3);
        }// end function

    }
}
