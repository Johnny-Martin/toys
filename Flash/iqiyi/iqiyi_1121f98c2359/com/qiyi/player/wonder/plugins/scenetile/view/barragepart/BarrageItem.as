package com.qiyi.player.wonder.plugins.scenetile.view.barragepart
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.vo.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.expression.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;
    import scenetile.*;

    public class BarrageItem extends Sprite
    {
        private var _barrageBG:MovieClip;
        private var _barrageBGDec:MovieClip;
        private var _starHeadImgBg:Sprite;
        private var _starHeadImg:Bitmap;
        private var _starHeadImgMask:Sprite;
        private var _depictShape:Shape;
        private var _depictTF:TextField;
        private var _glowFilter:GlowFilter;
        private var _barrageInfo:BarrageInfoVO;
        private var _row:uint = 0;
        private var _isSelfSend:Boolean = false;
        private var _isFilterImage:Boolean = false;
        private var _preBarrageItem:BarrageItem = null;
        private var _isFastComplete:Boolean = false;
        private static const HEAD_SIZE:Point = new Point(46, 46);
        private static const FONT_COLOR:uint = 11003435;
        private static const FONT_SIZE:uint = 24;
        private static const BARRAGE_BG_GAP:int = 10;
        private static const EXP_MIN_CHAR:uint = 5;

        public function BarrageItem()
        {
            this._glowFilter = new GlowFilter(0, 1, 2, 2, 5);
            this.mouseChildren = false;
            return;
        }// end function

        public function get isFilterImage() : Boolean
        {
            return this._isFilterImage;
        }// end function

        public function set isFilterImage(param1:Boolean) : void
        {
            this._isFilterImage = param1;
            return;
        }// end function

        public function get preBarrageItem() : BarrageItem
        {
            return this._preBarrageItem;
        }// end function

        public function set preBarrageItem(param1:BarrageItem) : void
        {
            this._preBarrageItem = param1;
            return;
        }// end function

        public function get isSelfSend() : Boolean
        {
            return this._isSelfSend;
        }// end function

        public function set isSelfSend(param1:Boolean) : void
        {
            this._isSelfSend = param1;
            return;
        }// end function

        public function get row() : uint
        {
            return this._row;
        }// end function

        public function set row(param1:uint) : void
        {
            this._row = param1;
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function get barrageInfo() : BarrageInfoVO
        {
            return this._barrageInfo;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            this.removeDepictLayer();
            if (GlobalStage.isFullScreen())
            {
                this.y = (this._row + 1) * 60 - 20;
            }
            else
            {
                this.y = this._row * 60 - 20;
            }
            return;
        }// end function

        public function set barrageInfo(param1:BarrageInfoVO) : void
        {
            var _loc_2:BitmapData = null;
            var _loc_3:String = null;
            if (this._barrageInfo)
            {
                this._barrageInfo.update(param1.dataObj, param1.barrageSource);
            }
            else
            {
                this._barrageInfo = param1;
            }
            if (this._barrageBGDec)
            {
                if (this._barrageBGDec.parent)
                {
                    this._barrageBGDec.parent.removeChild(this._barrageBGDec);
                }
                this._barrageBGDec = null;
            }
            if (this._barrageBG)
            {
                if (this._barrageBG.parent)
                {
                    this._barrageBG.parent.removeChild(this._barrageBG);
                }
                this._barrageBG = null;
            }
            if (this._starHeadImgBg)
            {
                if (this._starHeadImgBg.parent)
                {
                    this._starHeadImgBg.parent.removeChild(this._starHeadImgBg);
                }
                this._starHeadImgBg = null;
            }
            if (this._starHeadImg)
            {
                if (this._starHeadImg.parent)
                {
                    this._starHeadImg.parent.removeChild(this._starHeadImg);
                }
                this._starHeadImg = null;
            }
            if (this._starHeadImgMask)
            {
                if (this._starHeadImgMask.parent)
                {
                    this._starHeadImgMask.parent.removeChild(this._starHeadImgMask);
                }
                this._starHeadImgMask = null;
            }
            if (this._barrageInfo.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
            {
                _loc_2 = null;
                if (this._barrageInfo.userInfo && this._barrageInfo.userInfo.picS)
                {
                    _loc_2 = BarrageStarHeadImage.instance.getHeadImageByUrl(this._barrageInfo.userInfo.picS);
                }
                this._starHeadImgBg = new Sprite();
                this._starHeadImg = new Bitmap();
                this._starHeadImgMask = new Sprite();
                if (_loc_2)
                {
                    this._starHeadImgBg.graphics.beginFill(this.getColorByType(this._barrageInfo.bgType), 0.8);
                    this._starHeadImgBg.graphics.drawRoundRect(0, 0, HEAD_SIZE.x + 4, HEAD_SIZE.y + 4, 10, 10);
                    this._starHeadImgBg.graphics.endFill();
                    this._starHeadImg.bitmapData = _loc_2;
                    var _loc_4:* = HEAD_SIZE.x;
                    this._starHeadImg.height = HEAD_SIZE.x;
                    this._starHeadImg.width = _loc_4;
                    this._starHeadImgMask.graphics.beginFill(16776960, 0.8);
                    this._starHeadImgMask.graphics.drawRoundRect(2, 2, HEAD_SIZE.x, HEAD_SIZE.y, 10, 10);
                    this._starHeadImgMask.graphics.endFill();
                    this._starHeadImg.mask = this._starHeadImgMask;
                    var _loc_4:int = 2;
                    this._starHeadImg.y = 2;
                    this._starHeadImg.x = _loc_4;
                }
                else
                {
                    BarrageStarHeadImage.instance.addEventListener(BarrageStarHeadImage.COMPLETE, this.onHeadImgComplete);
                }
                this._barrageBG = this.getBGType(this._barrageInfo.bgType);
                if (this._barrageBG && this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_2)
                {
                    this._barrageBG.alpha = 0.8;
                }
                if (this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_0)
                {
                    this._barrageBGDec = new BarrageRainbow();
                }
                else if (this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_1)
                {
                    this._barrageBGDec = new BarrageSpell();
                }
                else if (this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_2)
                {
                    this._barrageBGDec = new BarrageKiwi();
                }
                if (this._barrageInfo.userInfo && this._barrageInfo.userInfo.name)
                {
                    this.update(this._barrageInfo.userInfo.name + ":");
                }
            }
            this.update(this._barrageInfo.content);
            if (this._barrageInfo.isReply)
            {
                if (this._barrageInfo.replyUserInfo && this._barrageInfo.replyUserInfo.name && this._barrageInfo.replyContent)
                {
                    this.update("//");
                    this.update("@" + this._barrageInfo.replyUserInfo.name + ":", true);
                    if (this._barrageInfo.replyContent.content != "" && this._barrageInfo.replyContent.content != undefined)
                    {
                        _loc_3 = this._barrageInfo.replyContent.content;
                    }
                    else if (this._barrageInfo.replyContent.rContent != "" && this._barrageInfo.replyContent.rContent != undefined)
                    {
                        _loc_3 = this._barrageInfo.replyContent.rContent;
                    }
                    this.update(_loc_3);
                }
            }
            if (this._barrageInfo.barrageSource == SceneTileDef.BARRAGE_SOURCE_JS)
            {
                if (this._barrageInfo.reply_content != "" && this._barrageInfo.reply_name != "")
                {
                    this.update("//");
                    this.update("@" + this._barrageInfo.reply_name + ":", true);
                    this.update(this._barrageInfo.reply_content);
                }
            }
            this.layout();
            if (this._barrageInfo.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
            {
                if (this._starHeadImgMask)
                {
                    addChildAt(this._starHeadImgMask, 0);
                }
                if (this._starHeadImg)
                {
                    addChildAt(this._starHeadImg, 0);
                }
                if (this._starHeadImgBg)
                {
                    addChildAt(this._starHeadImgBg, 0);
                }
                if (this._barrageBG)
                {
                    addChildAt(this._barrageBG, 0);
                }
                if (this._barrageBGDec)
                {
                    addChild(this._barrageBGDec);
                }
            }
            graphics.clear();
            if (this._isSelfSend && numChildren > 0)
            {
                graphics.lineStyle(2, FONT_COLOR, 1);
                graphics.drawRect(-2, -2, width + 4, height + 4);
            }
            return;
        }// end function

        private function onHeadImgComplete(event:Event) : void
        {
            var _loc_2:BitmapData = null;
            if (this._barrageInfo && this._barrageInfo.userInfo && this._barrageInfo.userInfo.picS)
            {
                _loc_2 = BarrageStarHeadImage.instance.getHeadImageByUrl(this._barrageInfo.userInfo.picS);
            }
            if (_loc_2)
            {
                BarrageStarHeadImage.instance.removeEventListener(BarrageStarHeadImage.COMPLETE, this.onHeadImgComplete);
                this._starHeadImgBg.graphics.beginFill(this.getColorByType(this._barrageInfo.bgType), 0.8);
                this._starHeadImgBg.graphics.drawRoundRect(0, 0, HEAD_SIZE.x + 4, HEAD_SIZE.y + 4, 10, 10);
                this._starHeadImgBg.graphics.endFill();
                this._starHeadImg.bitmapData = _loc_2;
                var _loc_3:* = HEAD_SIZE.x;
                this._starHeadImg.height = HEAD_SIZE.x;
                this._starHeadImg.width = _loc_3;
                this._starHeadImgMask.graphics.beginFill(16776960, 0.8);
                this._starHeadImgMask.graphics.drawRoundRect(2, 2, HEAD_SIZE.x, HEAD_SIZE.y, 10, 10);
                this._starHeadImgMask.graphics.endFill();
                this._starHeadImg.mask = this._starHeadImgMask;
                var _loc_3:int = 2;
                this._starHeadImg.y = 2;
                this._starHeadImg.x = _loc_3;
            }
            return;
        }// end function

        public function update(param1:String, param2:Boolean = false) : void
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:BitmapData = null;
            var _loc_9:ExpImageVO = null;
            var _loc_10:int = 0;
            var _loc_11:uint = 0;
            if (param1)
            {
                _loc_3 = param1.length;
                _loc_4 = "";
                _loc_5 = "";
                _loc_6 = "";
                _loc_7 = "";
                _loc_8 = null;
                _loc_9 = null;
                _loc_10 = 0;
                while (_loc_10 < _loc_3)
                {
                    
                    _loc_5 = param1.charAt(_loc_10);
                    if (_loc_5 == "[")
                    {
                        _loc_11 = _loc_10;
                        while (_loc_11 < _loc_3)
                        {
                            
                            _loc_7 = param1.charAt(_loc_11);
                            if (_loc_7 == "[")
                            {
                                _loc_4 = _loc_4 + _loc_6;
                                _loc_6 = "";
                                _loc_6 = _loc_6 + _loc_7;
                                _loc_10 = _loc_11;
                            }
                            else if (_loc_7 == "]")
                            {
                                _loc_6 = _loc_6 + _loc_7;
                                if (_loc_6.length >= EXP_MIN_CHAR)
                                {
                                    _loc_9 = BarrageExpressionManager.instance.getBitmapdataByContent(_loc_6);
                                    if (_loc_9)
                                    {
                                        if (_loc_9.type == BarrageExpressionManager.EXP_TYPE_IMAGE)
                                        {
                                            _loc_8 = _loc_9.data as BitmapData;
                                        }
                                        else if (_loc_9.type == BarrageExpressionManager.EXP_TYPE_STRING)
                                        {
                                            _loc_4 = _loc_4 + _loc_9.data.toString();
                                        }
                                    }
                                }
                                else
                                {
                                    _loc_4 = _loc_4 + _loc_6;
                                }
                                _loc_10 = _loc_11;
                                _loc_6 = "";
                                break;
                            }
                            else
                            {
                                _loc_6 = _loc_6 + _loc_7;
                                _loc_10 = _loc_11;
                            }
                            _loc_11 = _loc_11 + 1;
                        }
                        if (_loc_8 && !this._isFilterImage)
                        {
                            if (_loc_4)
                            {
                                this.createTextField(_loc_4, param2);
                                _loc_4 = "";
                            }
                            this.createBitmap(_loc_8);
                            _loc_8 = null;
                        }
                    }
                    else
                    {
                        _loc_4 = _loc_4 + _loc_5;
                    }
                    _loc_10++;
                }
                if (_loc_4)
                {
                    this.createTextField(_loc_4, param2);
                    _loc_4 = "";
                }
            }
            return;
        }// end function

        private function createTextField(param1:String, param2:Boolean = false) : void
        {
            var _loc_3:* = new TextField();
            _loc_3.type = TextFieldType.DYNAMIC;
            _loc_3.selectable = false;
            _loc_3.autoSize = TextFieldAutoSize.LEFT;
            if (param2)
            {
                _loc_3.defaultTextFormat = FastCreator.createTextFormat("微软雅黑", this.getFontSizeBySign(this._barrageInfo.fontSize), "0xff9132", false);
                this._glowFilter.color = 0;
            }
            else
            {
                _loc_3.defaultTextFormat = FastCreator.createTextFormat("微软雅黑", this.getFontSizeBySign(this._barrageInfo.fontSize), "0x" + this._barrageInfo.fontColor, false);
                this._glowFilter.color = this._barrageInfo.fontColor == "000000" || this._barrageInfo.fontColor == "undefined" ? (16777215) : (0);
            }
            _loc_3.text = param1;
            _loc_3.filters = null;
            if (this._barrageInfo.contentType != SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
            {
                _loc_3.filters = [this._glowFilter];
            }
            addChild(_loc_3);
            return;
        }// end function

        private function createBitmap(param1:BitmapData) : void
        {
            var _loc_2:* = new Bitmap(param1);
            addChild(_loc_2);
            return;
        }// end function

        private function layout() : void
        {
            var _loc_1:DisplayObject = null;
            var _loc_2:Number = 0;
            var _loc_3:* = this._barrageInfo.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR ? (BARRAGE_BG_GAP + HEAD_SIZE.x + 10) : (0);
            var _loc_4:int = 0;
            _loc_4 = 0;
            while (_loc_4 < numChildren)
            {
                
                _loc_1 = getChildAt(_loc_4);
                _loc_2 = _loc_2 > _loc_1.height ? (_loc_2) : (_loc_1.height);
                if (this._barrageBG)
                {
                    _loc_2 = _loc_2 > this._barrageBG.height ? (_loc_2) : (this._barrageBG.height);
                }
                _loc_4++;
            }
            _loc_4 = 0;
            while (_loc_4 < numChildren)
            {
                
                _loc_1 = getChildAt(_loc_4);
                _loc_1.x = _loc_3;
                _loc_1.y = (_loc_2 - _loc_1.height) / 2;
                _loc_3 = _loc_3 + _loc_1.width;
                _loc_4++;
            }
            if (this._barrageBG)
            {
                this._barrageBG.x = HEAD_SIZE.x + 5;
                this._barrageBG.width = _loc_3 + BARRAGE_BG_GAP * 2 + (this._barrageBGDec ? (this._barrageBGDec.width) : (0)) - HEAD_SIZE.x;
            }
            if (this._barrageBGDec)
            {
                if (this._barrageInfo.bgType == SceneTileDef.BARRAGE_BG_0)
                {
                    this._barrageBGDec.x = _loc_3 + 37;
                }
                else
                {
                    this._barrageBGDec.x = _loc_3 + 25;
                }
            }
            return;
        }// end function

        public function updateAlpha(param1:uint) : void
        {
            if (param1 > 0)
            {
                this.alpha = param1 / 100;
            }
            else
            {
                this.alpha = SceneTileDef.BARRAGE_DEFAULT_ALPHA / 100;
            }
            return;
        }// end function

        public function updateCoordinateOnStar(param1:Number = -10000) : void
        {
            if (this._barrageInfo.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
            {
                if (this.x > param1)
                {
                    this.x = this.x - SceneTileDef.BARRAGE_ROW_SPEED[(this._row - 1)];
                }
            }
            else
            {
                this.x = this.x - SceneTileDef.BARRAGE_ROW_SPEED[(this._row - 1)];
            }
            return;
        }// end function

        public function updateCoordinate() : void
        {
            var _loc_1:Number = 0;
            var _loc_2:* = GlobalStage.stage.stageWidth / 2 + this.row * 50;
            if (this.x < 0 && Math.abs(this.x) / this.width >= SceneTileDef.BARRAGE_DELETE_PERCENT / 100)
            {
                _loc_1 = SceneTileDef.BARRAGE_OUT_FLY_SPEED;
                this.x = this.x - _loc_1;
                return;
            }
            if (this._preBarrageItem)
            {
                if (this._preBarrageItem.x + this._preBarrageItem.width + SceneTileDef.BARRAGE_ITEM_GAP < GlobalStage.stage.stageWidth / 2)
                {
                    _loc_2 = GlobalStage.stage.stageWidth / 2 + this.row * 50;
                }
                else
                {
                    _loc_2 = this._preBarrageItem.x + this._preBarrageItem.width + SceneTileDef.BARRAGE_ITEM_GAP;
                }
            }
            if (this._isFastComplete)
            {
                _loc_1 = SceneTileDef.BARRAGE_ROW_SPEED[(this._row - 1)];
                this.x = this.x - _loc_1;
                return;
            }
            if (this.x - SceneTileDef.BARRAGE_IN_FLY_SPEED <= _loc_2)
            {
                _loc_1 = this.x - _loc_2;
                this._isFastComplete = true;
                this.x = this.x - _loc_1;
            }
            else
            {
                _loc_1 = SceneTileDef.BARRAGE_IN_FLY_SPEED;
                this.x = this.x - _loc_1;
            }
            return;
        }// end function

        public function addDepictLayer() : void
        {
            if (!this._isSelfSend)
            {
                this._depictTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.BARRAGE_ITEM_CLICK_DES1), 16777215, 18, TextFieldAutoSize.LEFT);
                this._depictTF.x = (this.width - this._depictTF.width) / 2;
                this._depictTF.y = (this.height - this._depictTF.height) / 2;
                var _loc_1:Boolean = false;
                this._depictTF.selectable = false;
                this._depictTF.mouseEnabled = _loc_1;
                this._depictShape = new Shape();
                this._depictShape.graphics.beginFill(0, 0.8);
                this._depictShape.graphics.drawRect(this.width < this._depictTF.width ? (this._depictTF.x) : (0), 0, this.width < this._depictTF.width ? (this._depictTF.width) : (this.width), this.height);
                this._depictShape.graphics.endFill();
                addChild(this._depictShape);
                addChild(this._depictTF);
            }
            return;
        }// end function

        public function removeDepictLayer() : void
        {
            if (this._depictShape && this._depictShape.parent)
            {
                this._depictShape.graphics.clear();
                removeChild(this._depictShape);
                this._depictShape = null;
            }
            if (this._depictTF && this._depictTF.parent)
            {
                removeChild(this._depictTF);
                this._depictTF = null;
            }
            return;
        }// end function

        private function getFontSizeBySign(param1:uint) : uint
        {
            var _loc_2:uint = 0;
            while (_loc_2 < SceneTileDef.BARRAGE_FONT_SIZE_SIGN_ARRAY.length)
            {
                
                if (param1 == SceneTileDef.BARRAGE_FONT_SIZE_SIGN_ARRAY[_loc_2])
                {
                    return SceneTileDef.BARRAGE_FONT_SIZE_ARRAY[_loc_2];
                }
                _loc_2 = _loc_2 + 1;
            }
            return SceneTileDef.BARRAGE_FONT_SIZE_ARRAY[(SceneTileDef.BARRAGE_FONT_SIZE_ARRAY.length - 1)];
        }// end function

        private function getBGType(param1:uint) : MovieClip
        {
            var _loc_2:MovieClip = null;
            switch(param1)
            {
                case SceneTileDef.BARRAGE_BG_0:
                {
                    _loc_2 = new BarrageBGColor0();
                    break;
                }
                case SceneTileDef.BARRAGE_BG_1:
                {
                    _loc_2 = new BarrageBGColor1();
                    break;
                }
                case SceneTileDef.BARRAGE_BG_2:
                {
                    _loc_2 = new BarrageBGColor2();
                    break;
                }
                case SceneTileDef.BARRAGE_BG_3:
                {
                    _loc_2 = new BarrageBGColor3();
                    break;
                }
                case SceneTileDef.BARRAGE_BG_4:
                {
                    _loc_2 = new BarrageBGColor4();
                    break;
                }
                case SceneTileDef.BARRAGE_BG_5:
                {
                    _loc_2 = new BarrageBGColor5();
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return _loc_2;
        }// end function

        private function getColorByType(param1:uint) : uint
        {
            var _loc_2:uint = 0;
            switch(param1)
            {
                case SceneTileDef.BARRAGE_BG_0:
                {
                    _loc_2 = 1144780;
                    break;
                }
                case SceneTileDef.BARRAGE_BG_1:
                {
                    _loc_2 = 16615680;
                    break;
                }
                case SceneTileDef.BARRAGE_BG_2:
                {
                    _loc_2 = 0;
                    break;
                }
                case SceneTileDef.BARRAGE_BG_3:
                {
                    _loc_2 = 12980826;
                    break;
                }
                case SceneTileDef.BARRAGE_BG_4:
                {
                    _loc_2 = 2855636;
                    break;
                }
                case SceneTileDef.BARRAGE_BG_5:
                {
                    _loc_2 = 1738779;
                    break;
                }
                default:
                {
                    _loc_2 = 1738779;
                    break;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function clear() : void
        {
            var _loc_1:DisplayObject = null;
            BarrageStarHeadImage.instance.removeEventListener(BarrageStarHeadImage.COMPLETE, this.onHeadImgComplete);
            this._preBarrageItem = null;
            this._isSelfSend = false;
            this._isFastComplete = false;
            this._barrageInfo = null;
            this._row = 0;
            graphics.clear();
            while (numChildren > 0)
            {
                
                _loc_1 = removeChildAt(0);
                _loc_1 = null;
            }
            return;
        }// end function

    }
}
