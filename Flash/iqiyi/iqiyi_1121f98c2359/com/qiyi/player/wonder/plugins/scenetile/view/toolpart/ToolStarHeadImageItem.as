package com.qiyi.player.wonder.plugins.scenetile.view.toolpart
{
    import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import gs.*;
    import scenetile.*;

    public class ToolStarHeadImageItem extends Sprite
    {
        private var _headUrl:String;
        private var _starHeadImg:Bitmap;
        private var _starHeadMC:BarrageStarHeadMC;
        private static const HEAD_SIZE:Point = new Point(46, 46);

        public function ToolStarHeadImageItem(param1:String, param2:uint)
        {
            this._headUrl = param1;
            TweenLite.delayedCall(param2 * 0.1, this.init);
            return;
        }// end function

        private function init() : void
        {
            TweenLite.killTweensOf(this.init);
            this._starHeadMC = new BarrageStarHeadMC();
            addChild(this._starHeadMC);
            this._starHeadImg = new Bitmap();
            var _loc_1:BitmapData = null;
            if (this._headUrl)
            {
                _loc_1 = BarrageStarHeadImage.instance.getHeadImageByUrl(this._headUrl);
            }
            if (_loc_1)
            {
                this._starHeadImg.bitmapData = _loc_1;
                var _loc_2:* = HEAD_SIZE.x;
                this._starHeadImg.height = HEAD_SIZE.x;
                this._starHeadImg.width = _loc_2;
            }
            else
            {
                BarrageStarHeadImage.instance.addEventListener(BarrageStarHeadImage.COMPLETE, this.onHeadImgComplete);
            }
            this._starHeadMC.headContainer.addChild(this._starHeadImg);
            return;
        }// end function

        private function onHeadImgComplete(event:Event) : void
        {
            var _loc_2:BitmapData = null;
            if (this._headUrl)
            {
                _loc_2 = BarrageStarHeadImage.instance.getHeadImageByUrl(this._headUrl);
            }
            if (_loc_2)
            {
                BarrageStarHeadImage.instance.removeEventListener(BarrageStarHeadImage.COMPLETE, this.onHeadImgComplete);
                this._starHeadImg.bitmapData = _loc_2;
                var _loc_3:* = HEAD_SIZE.x;
                this._starHeadImg.height = HEAD_SIZE.x;
                this._starHeadImg.width = _loc_3;
            }
            return;
        }// end function

        public function destroy() : void
        {
            TweenLite.killTweensOf(this.init);
            BarrageStarHeadImage.instance.removeEventListener(BarrageStarHeadImage.COMPLETE, this.onHeadImgComplete);
            if (this._starHeadImg)
            {
                if (this._starHeadImg.parent)
                {
                    this._starHeadImg.parent.removeChild(this._starHeadImg);
                }
                this._starHeadImg.bitmapData = null;
                this._starHeadImg = null;
            }
            if (this._starHeadMC)
            {
                this._starHeadMC.stop();
                if (this._starHeadMC.parent)
                {
                    this._starHeadMC.parent.removeChild(this._starHeadMC);
                }
                this._starHeadMC = null;
            }
            return;
        }// end function

    }
}
