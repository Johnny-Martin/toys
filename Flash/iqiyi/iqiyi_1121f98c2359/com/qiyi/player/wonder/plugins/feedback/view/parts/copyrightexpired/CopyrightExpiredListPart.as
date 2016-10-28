package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.plugins.feedback.view.*;
    import com.qiyi.player.wonder.plugins.recommend.model.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;

    public class CopyrightExpiredListPart extends Sprite
    {
        private var _recommendData:Vector.<RecommendVO> = null;
        private var _itemVector:Vector.<CopyrightExpiredRecommendItem> = null;
        private var _currPage:uint = 0;
        private var _maxPage:uint = 0;
        private var _maxShowItem:uint = 0;
        private var _leftArrow:CommonPageTurningArrow;
        private var _rightArrow:CommonPageTurningArrow;
        private var _listContainer:Sprite;
        private var _listContainerMask:Sprite;
        private var _isMove:Boolean = false;
        private static const GAP_OF_ITEM:uint = 12;
        private static const GAP_OF_BTN:uint = 50;
        private static const GAP_OF_SIDES:uint = 50;
        private static const ITEM_HEIGHT:uint = 110;
        private static const PAGE_TURNING_TIME:uint = 5;

        public function CopyrightExpiredListPart()
        {
            this._itemVector = new Vector.<CopyrightExpiredRecommendItem>;
            this._recommendData = new Vector.<RecommendVO>;
            this.initPanel();
            return;
        }// end function

        public function get recommendData() : Vector.<RecommendVO>
        {
            return this._recommendData;
        }// end function

        public function set recommendData(param1:Vector.<RecommendVO>) : void
        {
            var _loc_2:CopyrightExpiredRecommendItem = null;
            var _loc_3:uint = 0;
            this._recommendData = param1;
            if (this._recommendData)
            {
                _loc_3 = 0;
                while (_loc_3 < this._recommendData.length)
                {
                    
                    _loc_2 = new CopyrightExpiredRecommendItem(this._recommendData[_loc_3]);
                    _loc_2.x = (_loc_2.width + GAP_OF_ITEM) * _loc_3 + GAP_OF_ITEM * 0.5;
                    this._itemVector.push(_loc_2);
                    this._listContainer.addChild(_loc_2);
                    _loc_2.addEventListener(MouseEvent.CLICK, this.onItemMouseClick);
                    _loc_3 = _loc_3 + 1;
                }
            }
            TweenLite.to(this, PAGE_TURNING_TIME, {onComplete:this.onAutoPageTurn});
            return;
        }// end function

        private function initPanel() : void
        {
            this._listContainer = new Sprite();
            this._listContainer.graphics.beginFill(16711680, 0);
            this._listContainer.graphics.drawRect(0, 0, 1, 1);
            this._listContainer.graphics.endFill();
            addChild(this._listContainer);
            this._listContainerMask = new Sprite();
            this._listContainerMask.graphics.beginFill(16711680, 0.5);
            this._listContainerMask.graphics.drawRect(0, 0, 1, 1);
            this._listContainerMask.graphics.endFill();
            addChild(this._listContainerMask);
            this._listContainer.mask = this._listContainerMask;
            this._leftArrow = new CommonPageTurningArrow();
            this._leftArrow.buttonMode = true;
            this._leftArrow.useHandCursor = true;
            this._leftArrow.addEventListener(MouseEvent.ROLL_OVER, this.onLeftArrowOver);
            this._leftArrow.addEventListener(MouseEvent.ROLL_OUT, this.onLeftArrowOut);
            this._leftArrow.addEventListener(MouseEvent.CLICK, this.onLeftArrowClick);
            this._leftArrow.scaleX = -1;
            addChild(this._leftArrow);
            this._rightArrow = new CommonPageTurningArrow();
            this._rightArrow.buttonMode = true;
            this._rightArrow.useHandCursor = true;
            this._rightArrow.addEventListener(MouseEvent.ROLL_OVER, this.onRightArrowOver);
            this._rightArrow.addEventListener(MouseEvent.ROLL_OUT, this.onRightArrowOut);
            this._rightArrow.addEventListener(MouseEvent.CLICK, this.onRightArrowClick);
            addChild(this._rightArrow);
            return;
        }// end function

        private function onItemMouseClick(event:MouseEvent) : void
        {
            var _loc_2:* = event.target as CopyrightExpiredRecommendItem;
            if (_loc_2)
            {
                dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_CopyrightRecItemClick, _loc_2.data));
            }
            return;
        }// end function

        private function onLeftArrowClick(event:MouseEvent = null) : void
        {
            var _loc_2:int = 0;
            TweenLite.killTweensOf(this);
            if (this._currPage > 0 && !this._isMove)
            {
                (this._currPage - 1);
                this._isMove = true;
                _loc_2 = this._listContainer.x + (CopyrightExpiredRecommendItem.ITEM_WIDTH + GAP_OF_ITEM) * this._maxShowItem;
                TweenLite.to(this._listContainer, 0.5, {x:_loc_2, onComplete:this.onTweenComplete});
            }
            return;
        }// end function

        private function onLeftArrowOver(event:MouseEvent) : void
        {
            this._leftArrow.gotoAndStop(2);
            return;
        }// end function

        private function onLeftArrowOut(event:MouseEvent) : void
        {
            this._leftArrow.gotoAndStop(1);
            return;
        }// end function

        private function onRightArrowClick(event:MouseEvent = null) : void
        {
            var _loc_2:int = 0;
            TweenLite.killTweensOf(this);
            if (this._currPage < this._maxPage && !this._isMove)
            {
                (this._currPage + 1);
                this._isMove = true;
                _loc_2 = this._listContainer.x - (CopyrightExpiredRecommendItem.ITEM_WIDTH + GAP_OF_ITEM) * this._maxShowItem;
                TweenLite.to(this._listContainer, 0.5, {x:_loc_2, onComplete:this.onTweenComplete});
            }
            return;
        }// end function

        private function onRightArrowOver(event:MouseEvent) : void
        {
            this._rightArrow.gotoAndStop(2);
            return;
        }// end function

        private function onRightArrowOut(event:MouseEvent) : void
        {
            this._rightArrow.gotoAndStop(1);
            return;
        }// end function

        private function onTweenComplete() : void
        {
            this._isMove = false;
            TweenLite.killTweensOf(this);
            TweenLite.killTweensOf(this._listContainer);
            if (this._currPage <= 0)
            {
                this.enableLeftArrow(false);
            }
            else
            {
                this.enableLeftArrow(true);
            }
            if (this._currPage >= this._maxPage)
            {
                this.enableRightArrow(false);
            }
            else
            {
                this.enableRightArrow(true);
            }
            TweenLite.to(this, PAGE_TURNING_TIME, {onComplete:this.onAutoPageTurn});
            return;
        }// end function

        private function onAutoPageTurn() : void
        {
            TweenLite.killTweensOf(this);
            this.onRightArrowClick();
            return;
        }// end function

        private function enableLeftArrow(param1:Boolean) : void
        {
            if (param1)
            {
                this._leftArrow.gotoAndStop(1);
                this._leftArrow.mouseChildren = true;
                this._leftArrow.mouseEnabled = true;
                if (!this._leftArrow.hasEventListener(MouseEvent.ROLL_OVER))
                {
                    this._leftArrow.addEventListener(MouseEvent.ROLL_OVER, this.onLeftArrowOver);
                    this._leftArrow.addEventListener(MouseEvent.ROLL_OUT, this.onLeftArrowOut);
                }
            }
            else
            {
                this._leftArrow.removeEventListener(MouseEvent.ROLL_OVER, this.onLeftArrowOver);
                this._leftArrow.removeEventListener(MouseEvent.ROLL_OUT, this.onLeftArrowOut);
                this._leftArrow.mouseChildren = false;
                this._leftArrow.mouseEnabled = false;
                this._leftArrow.gotoAndStop(3);
            }
            return;
        }// end function

        private function enableRightArrow(param1:Boolean) : void
        {
            if (param1)
            {
                this._rightArrow.gotoAndStop(1);
                this._rightArrow.mouseChildren = true;
                this._rightArrow.mouseEnabled = true;
                if (!this._rightArrow.hasEventListener(MouseEvent.ROLL_OVER))
                {
                    this._rightArrow.addEventListener(MouseEvent.ROLL_OVER, this.onRightArrowOver);
                    this._rightArrow.addEventListener(MouseEvent.ROLL_OUT, this.onRightArrowOut);
                }
            }
            else
            {
                this._rightArrow.removeEventListener(MouseEvent.ROLL_OVER, this.onRightArrowOver);
                this._rightArrow.removeEventListener(MouseEvent.ROLL_OUT, this.onRightArrowOut);
                this._rightArrow.mouseChildren = false;
                this._rightArrow.mouseEnabled = false;
                this._rightArrow.gotoAndStop(3);
            }
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            this._isMove = false;
            this._currPage = 0;
            this._maxShowItem = Math.floor((param1 - GAP_OF_SIDES * 2 - GAP_OF_BTN * 2) / (CopyrightExpiredRecommendItem.ITEM_WIDTH + GAP_OF_ITEM));
            var _loc_3:* = GAP_OF_BTN * 2 + this._maxShowItem * (CopyrightExpiredRecommendItem.ITEM_WIDTH + GAP_OF_ITEM);
            var _loc_4:* = (param1 - _loc_3) / 2;
            this._leftArrow.x = _loc_4 + this._leftArrow.width + (GAP_OF_BTN - this._leftArrow.width) / 2;
            this._rightArrow.x = _loc_4 + _loc_3 - this._rightArrow.width - (GAP_OF_BTN - this._leftArrow.width) / 2;
            var _loc_5:* = (ITEM_HEIGHT - this._rightArrow.height) * 0.5 - 5;
            this._rightArrow.y = (ITEM_HEIGHT - this._rightArrow.height) * 0.5 - 5;
            this._leftArrow.y = _loc_5;
            this._listContainer.x = _loc_4 + GAP_OF_BTN;
            this._listContainerMask.x = _loc_4 + GAP_OF_BTN;
            this._listContainerMask.width = _loc_3 - GAP_OF_BTN * 2;
            this._listContainerMask.height = ITEM_HEIGHT;
            this._maxPage = Math.ceil(this._recommendData.length / this._maxShowItem) - 1;
            if (this._currPage <= 0)
            {
                this.enableLeftArrow(false);
            }
            else
            {
                this.enableLeftArrow(true);
            }
            if (this._currPage >= this._maxPage)
            {
                this.enableRightArrow(false);
            }
            else
            {
                this.enableRightArrow(true);
            }
            return;
        }// end function

        public function destory() : void
        {
            var _loc_1:CopyrightExpiredRecommendItem = null;
            TweenLite.killTweensOf(this);
            TweenLite.killTweensOf(this._listContainer);
            if (this._listContainerMask && this._listContainerMask.parent)
            {
                this._listContainerMask.graphics.clear();
                removeChild(this._listContainerMask);
                this._listContainerMask = null;
            }
            if (this._leftArrow && this._leftArrow.parent)
            {
                this._leftArrow.removeEventListener(MouseEvent.ROLL_OVER, this.onLeftArrowOver);
                this._leftArrow.removeEventListener(MouseEvent.ROLL_OUT, this.onLeftArrowOut);
                this._leftArrow.removeEventListener(MouseEvent.CLICK, this.onLeftArrowClick);
                removeChild(this._leftArrow);
                this._leftArrow = null;
            }
            if (this._rightArrow && this._rightArrow.parent)
            {
                this._rightArrow.removeEventListener(MouseEvent.ROLL_OVER, this.onRightArrowOver);
                this._rightArrow.removeEventListener(MouseEvent.ROLL_OUT, this.onRightArrowOut);
                this._rightArrow.removeEventListener(MouseEvent.CLICK, this.onRightArrowClick);
                removeChild(this._rightArrow);
                this._rightArrow = null;
            }
            if (this._itemVector)
            {
                while (this._itemVector.length > 0)
                {
                    
                    _loc_1 = this._itemVector.shift();
                    if (_loc_1.parent)
                    {
                        _loc_1.parent.removeChild(_loc_1);
                    }
                    _loc_1.removeEventListener(MouseEvent.CLICK, this.onItemMouseClick);
                    _loc_1.destroy();
                    _loc_1 = null;
                }
            }
            if (this._listContainer && this._listContainer.parent)
            {
                this._listContainer.graphics.clear();
                removeChild(this._listContainer);
                this._listContainer = null;
            }
            return;
        }// end function

    }
}
