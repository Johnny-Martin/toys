package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import feedback.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import gs.*;
    import gs.easing.*;

    public class CopyrightLimited extends Sprite implements IDestroy
    {
        public var _thisW:int = 596;
        public var _thisH:int = 198;
        private var _overseaUI:OverseaUI;
        private var _titleTF:TextField;
        private var _clientExtendTF:TextField;
        private var _downLoadBtn:DownLoadBtn;
        private var _downLoadTF:TextField;
        private var _linkTF:TextField;
        private var _englistTF:TextField;
        private var _preBtn:TriangleBtn;
        private var _nextBtn:TriangleBtn;
        private var _leftText:TextField;
        private var _rightText:TextField;
        private var _rightTextLink:Sprite;
        private var _videoItemArray:Array = null;
        private var _maskMC:Sprite = null;
        private var _loadInContainer:Sprite = null;
        private var _errorcode:String = "";
        private var _errocodeTF:TextField;
        private static const TEXT_TITLE_PLATFORM_LIMIT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES1);
        private static const TEXT_TITLE_AREA_LIMIT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES2);
        private static const TEXT_CLIENT_EXTEND:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES3);
        private static const TEXT_DOWNLOAD_BTN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES4);
        private static const TEXT_LINK:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES5);
        private static const TEXT_ENGLISH_AREA_LIMIT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES6);
        private static const TEXT_ENGLISH_PLATFORM_LIMIT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES7);
        private static const STR_ERROR_CODE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.ERROR_CODE_DEFAULT_DES);

        public function CopyrightLimited(param1:uint, param2:String)
        {
            this._errorcode = param2;
            this._overseaUI = new OverseaUI();
            switch(param1)
            {
                case FeedbackDef.FEEDBACK_LIMITED_PLATFORM:
                {
                    this._titleTF = FastCreator.createLabel(TEXT_TITLE_PLATFORM_LIMIT, 16777215, 18);
                    this._englistTF = FastCreator.createLabel(TEXT_ENGLISH_PLATFORM_LIMIT, 10066329, 12);
                    break;
                }
                case FeedbackDef.FEEDBACK_LIMITED_AREA:
                {
                    this._titleTF = FastCreator.createLabel(TEXT_TITLE_AREA_LIMIT, 16777215, 18);
                    this._englistTF = FastCreator.createLabel(TEXT_ENGLISH_AREA_LIMIT, 10066329, 12);
                    break;
                }
                default:
                {
                    this._titleTF = FastCreator.createLabel(TEXT_TITLE_AREA_LIMIT, 16777215, 18);
                    this._englistTF = FastCreator.createLabel(TEXT_ENGLISH_AREA_LIMIT, 10066329, 12);
                    break;
                    break;
                }
            }
            this._titleTF.x = (this._overseaUI.width - this._titleTF.width) * 0.5;
            this._overseaUI.addChild(this._titleTF);
            this._clientExtendTF = FastCreator.createLabel(TEXT_CLIENT_EXTEND, 16777215, 12);
            this._clientExtendTF.htmlText = TEXT_CLIENT_EXTEND;
            this._clientExtendTF.x = (this._overseaUI.width - this._clientExtendTF.width) * 0.5;
            this._clientExtendTF.y = 42;
            this._overseaUI.addChild(this._clientExtendTF);
            this._downLoadBtn = new DownLoadBtn();
            this._downLoadBtn.x = (this._overseaUI.width - this._downLoadBtn.width) * 0.5;
            this._downLoadBtn.y = 75;
            this._overseaUI.addChild(this._downLoadBtn);
            this._downLoadTF = FastCreator.createLabel(TEXT_DOWNLOAD_BTN, 16777215, 16);
            var _loc_3:Boolean = false;
            this._downLoadTF.mouseEnabled = false;
            this._downLoadTF.selectable = _loc_3;
            this._downLoadTF.x = this._downLoadBtn.x + 18;
            this._downLoadTF.y = this._downLoadBtn.y + (this._downLoadBtn.height - this._downLoadTF.height) * 0.5;
            this._overseaUI.addChild(this._downLoadTF);
            this._linkTF = FastCreator.createLabel(TEXT_LINK, 10066329);
            this._linkTF.x = (this._overseaUI.width - this._linkTF.width) * 0.5;
            this._linkTF.y = 127;
            this._overseaUI.addChild(this._linkTF);
            this._englistTF.x = (this._overseaUI.width - this._englistTF.width) * 0.5;
            this._englistTF.y = 150;
            this._overseaUI.addChild(this._englistTF);
            this._preBtn = new TriangleBtn(32, TriangleBtn.FACE_LEFT);
            this._nextBtn = new TriangleBtn(32, TriangleBtn.FACE_RIGHT);
            this._leftText = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES8), 10066329, 16, "", true);
            this._rightText = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_LIMITED_DES9), 8562957, 16, "", true);
            this._rightTextLink = new Sprite();
            this._rightTextLink.addChild(this._rightText);
            this._rightTextLink.mouseChildren = false;
            this._rightTextLink.buttonMode = true;
            this._rightTextLink.addEventListener(MouseEvent.CLICK, this.onMoreClick);
            this._rightTextLink.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
            this._rightTextLink.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
            this._preBtn.addEventListener(MouseEvent.CLICK, this.onPreBtnClick);
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.onNextBtnClick);
            this._maskMC = new Sprite();
            this._loadInContainer = new Sprite();
            this._errocodeTF = FastCreator.createLabel(STR_ERROR_CODE + this._errorcode, 16777215, 14);
            this.getVideoData();
            this.initUI();
            return;
        }// end function

        public function get downLoadBtn() : SimpleButton
        {
            return this._downLoadBtn;
        }// end function

        public function get linkTextField() : TextField
        {
            return this._linkTF;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            x = (param1 - this._overseaUI.width) * 0.5;
            y = (param2 - height) / 2 + 15;
            this._errocodeTF.x = param1 - x - this._errocodeTF.width - 45;
            this._errocodeTF.y = param2 - y - 45;
            return;
        }// end function

        private function getVideoData() : void
        {
            var _loc_1:* = FeedbackDef.OPEN_VIDEOS.item.length();
            this._videoItemArray = new Array();
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1)
            {
                
                this._videoItemArray[_loc_2] = new OpenVideoItem(FeedbackDef.OPEN_VIDEOS.item[_loc_2].@video_url, FeedbackDef.OPEN_VIDEOS.item[_loc_2].@pic_url, LocalizationManager.instance.getLanguageStringByName(FeedbackDef.OPEN_VIDEOS.item[_loc_2].@title));
                this._videoItemArray[_loc_2].x = _loc_2 * (this._thisW - 86) / 4;
                this._videoItemArray[_loc_2].y = 0;
                this._loadInContainer.addChild(this._videoItemArray[_loc_2]);
                _loc_2++;
            }
            return;
        }// end function

        private function initUI() : void
        {
            this._leftText.y = this._overseaUI.y + this._overseaUI.height + 20;
            this._rightTextLink.y = this._leftText.y;
            this._loadInContainer.x = this._overseaUI.x;
            this._loadInContainer.y = this._leftText.y + this._leftText.height;
            this._maskMC.x = this._loadInContainer.x;
            this._maskMC.y = this._loadInContainer.y;
            this._maskMC.graphics.beginFill(16711680);
            this._maskMC.graphics.drawRect(0, 0, 504, this._thisH);
            this._maskMC.graphics.endFill();
            this._loadInContainer.mask = this._maskMC;
            this._leftText.x = this._loadInContainer.x;
            this._rightTextLink.x = this._loadInContainer.x + this._overseaUI.width - this._rightTextLink.width + 15;
            this._preBtn.x = this._loadInContainer.x - this._preBtn.width - 10;
            this._preBtn.y = this._loadInContainer.y + (124 - this._preBtn.height) * 0.5;
            this._nextBtn.x = this._loadInContainer.x + this._overseaUI.width + 30;
            this._nextBtn.y = this._preBtn.y;
            addChild(this._loadInContainer);
            addChild(this._overseaUI);
            addChild(this._leftText);
            addChild(this._rightTextLink);
            addChild(this._maskMC);
            addChild(this._preBtn);
            addChild(this._nextBtn);
            addChild(this._errocodeTF);
            return;
        }// end function

        private function onMoreClick(event:MouseEvent) : void
        {
            navigateToURL(new URLRequest(FeedbackDef.OPEN_VIDEOS_LIST_URL), "_blank");
            return;
        }// end function

        private function onRollOver(event:MouseEvent) : void
        {
            this._rightText.setTextFormat(new TextFormat(FastCreator.FONT_MSYH, 16, 10066329, true, null, true));
            return;
        }// end function

        private function onRollOut(event:MouseEvent) : void
        {
            this._rightText.setTextFormat(new TextFormat(FastCreator.FONT_MSYH, 16, 8562957, true, null, true));
            return;
        }// end function

        private function onPreBtnClick(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Object = null;
            if (!this._videoItemArray)
            {
                return;
            }
            if (this._videoItemArray.length > 4)
            {
                _loc_2 = 0;
                while (_loc_2 < 4)
                {
                    
                    _loc_3 = this._videoItemArray.pop();
                    _loc_3.x = this._videoItemArray[0].x - (this._thisW - 86) / 4;
                    this._videoItemArray.unshift(_loc_3);
                    _loc_2++;
                }
                TweenLite.to(this._loadInContainer, 1, {x:this._loadInContainer.x + (this._thisW - 86) / 1, onComplete:this.enableBtns, ease:Back.easeOut});
                this.disableBtns();
            }
            return;
        }// end function

        private function onNextBtnClick(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Object = null;
            if (!this._videoItemArray)
            {
                return;
            }
            if (this._videoItemArray.length > 4)
            {
                _loc_2 = 0;
                while (_loc_2 < 4)
                {
                    
                    _loc_3 = this._videoItemArray.shift();
                    _loc_3.x = this._videoItemArray[(this._videoItemArray.length - 1)].x + (this._thisW - 86) / 4;
                    this._videoItemArray.push(_loc_3);
                    _loc_2++;
                }
                TweenLite.to(this._loadInContainer, 1, {x:this._loadInContainer.x - (this._thisW - 86) / 1, onComplete:this.enableBtns, ease:Back.easeOut});
                this.disableBtns();
            }
            return;
        }// end function

        private function enableBtns() : void
        {
            this._preBtn.addEventListener(MouseEvent.CLICK, this.onPreBtnClick);
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.onNextBtnClick);
            this._preBtn.enable = true;
            this._nextBtn.enable = true;
            return;
        }// end function

        private function disableBtns() : void
        {
            this._preBtn.removeEventListener(MouseEvent.CLICK, this.onPreBtnClick);
            this._nextBtn.removeEventListener(MouseEvent.CLICK, this.onNextBtnClick);
            this._preBtn.enable = false;
            this._nextBtn.enable = false;
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:DisplayObject = null;
            this._preBtn.removeEventListener(MouseEvent.CLICK, this.onPreBtnClick);
            this._nextBtn.removeEventListener(MouseEvent.CLICK, this.onNextBtnClick);
            if (this._overseaUI && this._overseaUI.parent)
            {
                while (this._overseaUI.numChildren > 0)
                {
                    
                    _loc_1 = this._overseaUI.getChildAt(0);
                    this._overseaUI.removeChild(_loc_1);
                    _loc_1 = null;
                }
                removeChild(this._overseaUI);
                this._overseaUI = null;
            }
            while (numChildren > 0)
            {
                
                _loc_1 = getChildAt(0);
                if (_loc_1.parent)
                {
                    removeChild(_loc_1);
                }
                _loc_1 = null;
            }
            return;
        }// end function

    }
}
