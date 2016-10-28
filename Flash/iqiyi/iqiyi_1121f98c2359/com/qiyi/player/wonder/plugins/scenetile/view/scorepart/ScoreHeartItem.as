package com.qiyi.player.wonder.plugins.scenetile.view.scorepart
{
    import flash.display.*;
    import scenetile.*;

    public class ScoreHeartItem extends Sprite
    {
        private var _mcScoreHeart:ScoreHeart;
        private var _index:uint = 0;

        public function ScoreHeartItem(param1:uint)
        {
            this._index = param1;
            this._mcScoreHeart = new ScoreHeart();
            addChild(this._mcScoreHeart);
            var _loc_2:Boolean = true;
            this.buttonMode = true;
            this.useHandCursor = _loc_2;
            return;
        }// end function

        public function get index() : uint
        {
            return this._index;
        }// end function

        public function heartState(param1:String) : void
        {
            this._mcScoreHeart.gotoAndStop(param1);
            return;
        }// end function

        public function destory() : void
        {
            this._mcScoreHeart.stop();
            if (this._mcScoreHeart.parent)
            {
                this._mcScoreHeart.parent.removeChild(this._mcScoreHeart);
            }
            this._mcScoreHeart = null;
            return;
        }// end function

    }
}
