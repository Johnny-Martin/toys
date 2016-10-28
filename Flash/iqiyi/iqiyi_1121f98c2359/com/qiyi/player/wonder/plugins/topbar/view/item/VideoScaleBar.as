package com.qiyi.player.wonder.plugins.topbar.view.item
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import com.qiyi.player.wonder.plugins.topbar.view.*;
    import flash.display.*;
    import flash.events.*;

    public class VideoScaleBar extends Sprite
    {
        private var _vsiVector:Vector.<VideoScaleItem>;
        private var _bgShape:Shape;
        private static const SCALE_ARR:Array = ["50%", "75%", "100%", LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOPBAR_VIEW_DES1)];
        private static const SCALE_TYPE_ARR:Array = [TopBarDef.SCALE_VALUE_50, TopBarDef.SCALE_VALUE_75, TopBarDef.SCALE_VALUE_100, TopBarDef.SCALE_VALUE_FULL];

        public function VideoScaleBar()
        {
            var _loc_1:VideoScaleItem = null;
            this._bgShape = new Shape();
            addChild(this._bgShape);
            this._vsiVector = new Vector.<VideoScaleItem>;
            var _loc_2:uint = 0;
            while (_loc_2 < SCALE_ARR.length)
            {
                
                _loc_1 = new VideoScaleItem(SCALE_ARR[_loc_2], SCALE_TYPE_ARR[_loc_2]);
                this._vsiVector.push(_loc_1);
                _loc_1.x = _loc_2 * (_loc_1.width + 5);
                addChild(_loc_1);
                _loc_1.addEventListener(MouseEvent.CLICK, this.onItemClick);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function onItemClick(event:MouseEvent) : void
        {
            var _loc_3:VideoScaleItem = null;
            var _loc_2:* = event.target as VideoScaleItem;
            if (_loc_2)
            {
                for each (_loc_3 in this._vsiVector)
                {
                    
                    _loc_3.isSelected = false;
                }
                dispatchEvent(new TopBarEvent(TopBarEvent.Evt_ScaleClick, _loc_2.type));
            }
            return;
        }// end function

        public function setVideoScale(param1:uint) : void
        {
            var _loc_2:VideoScaleItem = null;
            for each (_loc_2 in this._vsiVector)
            {
                
                if (param1 == _loc_2.type)
                {
                    _loc_2.isSelected = true;
                    this._bgShape.graphics.clear();
                    this._bgShape.graphics.beginFill(5865493);
                    this._bgShape.graphics.drawRoundRect(_loc_2.x, _loc_2.y, _loc_2.width, _loc_2.height, 5);
                    this._bgShape.graphics.endFill();
                }
            }
            return;
        }// end function

    }
}
