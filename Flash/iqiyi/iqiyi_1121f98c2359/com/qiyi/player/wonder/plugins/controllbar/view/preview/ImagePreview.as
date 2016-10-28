package com.qiyi.player.wonder.plugins.controllbar.view.preview
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;

    public class ImagePreview extends Sprite
    {
        private var _previewItemList:Vector.<ImagePreviewItem>;
        private var _curTime:Number = 0;
        private var _focusTip:String = "";
        private var _imgUrl:String = "";
        private var _isImageListShow:Boolean = false;
        private var _isMouseIn:Boolean = false;
        private var _isHavImageData:Boolean = false;

        public function ImagePreview()
        {
            this.initUI();
            return;
        }// end function

        public function get isHavImageData() : Boolean
        {
            return this._isHavImageData;
        }// end function

        public function set isHavImageData(param1:Boolean) : void
        {
            this._isHavImageData = param1;
            return;
        }// end function

        public function get isMouseIn() : Boolean
        {
            return this._isMouseIn;
        }// end function

        public function set isMouseIn(param1:Boolean) : void
        {
            this._isMouseIn = param1;
            return;
        }// end function

        public function get isImageListShow() : Boolean
        {
            return this._isImageListShow;
        }// end function

        public function set isImageListShow(param1:Boolean) : void
        {
            this._isImageListShow = param1;
            return;
        }// end function

        private function initUI() : void
        {
            this._previewItemList = new Vector.<ImagePreviewItem>;
            return;
        }// end function

        public function hide() : void
        {
            TweenLite.killTweensOf(this);
            this.alpha = 1;
            TweenLite.to(this, 0.1, {alpha:0, y:this.y + 10, onComplete:this.onComplete});
            return;
        }// end function

        private function onComplete() : void
        {
            var _loc_1:ImagePreviewItem = null;
            TweenLite.killTweensOf(this.onDelayedCall);
            this._isImageListShow = false;
            for each (_loc_1 in this._previewItemList)
            {
                
                if (_loc_1 && _loc_1.parent)
                {
                    removeChild(_loc_1);
                }
            }
            return;
        }// end function

        public function updateCurTime(param1:int, param2:String = "", param3:String = "") : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            this._curTime = param1;
            this._focusTip = param2;
            this._imgUrl = param3;
            this.alpha = 1;
            if (this._isImageListShow)
            {
                this.showPreviewItemList();
            }
            else
            {
                TweenLite.killTweensOf(this.onDelayedCall);
                if (this._isHavImageData)
                {
                    TweenLite.delayedCall(ControllBarDef.IMAGE_PRE_DELAYEDCALL / 1000, this.onDelayedCall);
                }
                _loc_4 = Math.floor(this._previewItemList.length / 2);
                _loc_5 = Math.round(this._curTime / 10000);
                this._previewItemList[_loc_4].updateImageIndex(_loc_5, this._focusTip, this._imgUrl, this._curTime);
                this._previewItemList[_loc_4].updateImageState(true, this._isImageListShow);
                this._previewItemList[_loc_4].x = (-this._previewItemList[_loc_4].width) * 0.5 + (ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
                addChild(this._previewItemList[_loc_4]);
            }
            return;
        }// end function

        public function showPreviewItemList(param1:Boolean = false) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:uint = 0;
            if (param1)
            {
                TweenLite.killTweensOf(this);
                TweenLite.killTweensOf(this.onDelayedCall);
                this._isImageListShow = true;
                this.y = this.y + 10;
                this.alpha = 0;
                TweenLite.to(this, 0.2, {alpha:1, y:this.y - 10});
            }
            if (this._previewItemList.length > 0)
            {
                _loc_2 = Math.floor(this._previewItemList.length / 2);
                _loc_3 = Math.round(this._curTime / 10000);
                this._previewItemList[_loc_2].updateImageIndex(_loc_3, this._focusTip, this._imgUrl, this._curTime);
                this._previewItemList[_loc_2].updateImageState(true, this._isImageListShow);
                this._previewItemList[_loc_2].x = (-this._previewItemList[_loc_2].width) * 0.5 + (ControllBarDef.IMAGE_PRE_BIG_WH_SIZE.x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 0.5;
                addChild(this._previewItemList[_loc_2]);
                _loc_4 = 1;
                while (_loc_4 < (_loc_2 + 1))
                {
                    
                    this._previewItemList[_loc_2 - _loc_4].x = this._previewItemList[_loc_2].x - ControllBarDef.IMAGE_PRE_SMALL_SIZE.x * _loc_4;
                    this._previewItemList[_loc_2 - _loc_4].updateImageIndex(_loc_3 - _loc_4);
                    this._previewItemList[_loc_2 - _loc_4].updateImageState(false, this._isImageListShow);
                    addChild(this._previewItemList[_loc_2 - _loc_4]);
                    this._previewItemList[_loc_2 + _loc_4].x = this._previewItemList[_loc_2].x + ControllBarDef.IMAGE_PRE_SMALL_SIZE.x * _loc_4;
                    this._previewItemList[_loc_2 + _loc_4].updateImageIndex(_loc_3 + _loc_4);
                    this._previewItemList[_loc_2 + _loc_4].updateImageState(false, this._isImageListShow);
                    addChild(this._previewItemList[_loc_2 + _loc_4]);
                    _loc_4 = _loc_4 + 1;
                }
                setChildIndex(this._previewItemList[_loc_2], (numChildren - 1));
            }
            return;
        }// end function

        private function onDelayedCall() : void
        {
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewVedioShow, this._focusTip == ""));
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            var _loc_4:ImagePreviewItem = null;
            var _loc_3:* = Math.ceil(param1 / ControllBarDef.IMAGE_PRE_SMALL_SIZE.x) * 2 + 1;
            while (this._previewItemList.length > 0)
            {
                
                _loc_4 = this._previewItemList.pop();
                _loc_4.removeEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver);
                _loc_4.removeEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut);
                _loc_4.removeEventListener(MouseEvent.CLICK, this.onItemClick);
                _loc_4.removeEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick, this.onImagePreviewGoodsImgClick);
                if (_loc_4.parent)
                {
                    _loc_4.parent.removeChild(_loc_4);
                }
                _loc_4.destroy();
                _loc_4 = null;
            }
            var _loc_5:int = 0;
            while (_loc_5 < _loc_3)
            {
                
                _loc_4 = new ImagePreviewItem();
                _loc_4.index = _loc_5;
                this._previewItemList.push(_loc_4);
                _loc_4.addEventListener(MouseEvent.ROLL_OVER, this.onItemRollOver);
                _loc_4.addEventListener(MouseEvent.ROLL_OUT, this.onItemRollOut);
                _loc_4.addEventListener(MouseEvent.CLICK, this.onItemClick);
                _loc_4.addEventListener(ControllBarEvent.Evt_ImagePreViewGoodsClick, this.onImagePreviewGoodsImgClick);
                _loc_5++;
            }
            return;
        }// end function

        private function onItemRollOver(event:MouseEvent) : void
        {
            var _loc_3:int = 0;
            this._isMouseIn = true;
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewMouseStateChange));
            var _loc_2:* = event.target as ImagePreviewItem;
            if (_loc_2)
            {
                _loc_3 = 0;
                this._previewItemList[_loc_2.index].updateImageState(true, this._isImageListShow);
                _loc_3 = _loc_2.index - 1;
                while (_loc_3 > 0)
                {
                    
                    this._previewItemList[_loc_3].updateImageState(false, this._isImageListShow);
                    _loc_3 = _loc_3 - 1;
                }
                _loc_3 = _loc_2.index + 1;
                while (_loc_3 < this._previewItemList.length)
                {
                    
                    this._previewItemList[_loc_3].updateImageState(false, this._isImageListShow);
                    _loc_3++;
                }
                setChildIndex(this._previewItemList[_loc_2.index], (numChildren - 1));
            }
            return;
        }// end function

        private function onItemRollOut(event:MouseEvent) : void
        {
            this._isMouseIn = false;
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreviewMouseStateChange));
            return;
        }// end function

        private function onItemClick(event:MouseEvent) : void
        {
            var _loc_3:Number = NaN;
            this._isMouseIn = false;
            var _loc_2:* = event.currentTarget as ImagePreviewItem;
            if (_loc_2)
            {
                _loc_3 = _loc_2.curTime > 0 ? (_loc_2.curTime) : (_loc_2.imageIndex * 10000);
                dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreItemClick, _loc_3));
            }
            return;
        }// end function

        private function onImagePreviewGoodsImgClick(event:ControllBarEvent) : void
        {
            this._isMouseIn = false;
            dispatchEvent(new ControllBarEvent(ControllBarEvent.Evt_ImagePreViewGoodsClick, event.data));
            return;
        }// end function

    }
}
