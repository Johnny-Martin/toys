package com.qiyi.player.wonder.plugins.recommend.view.part
{
    import __AS3__.vec.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import com.qiyi.player.wonder.plugins.recommend.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;

    public class PlayFinishRecommend extends Sprite
    {
        private var _song:SoundChannel;
        private var _recommendData:Vector.<RecommendVO>;
        private var _channelID:uint = 0;
        private var _showWidth:Number = 0;
        private var _showHeight:Number = 0;
        private var _recommendVector:Vector.<PlayFinishRecommendItem>;

        public function PlayFinishRecommend(param1:Vector.<RecommendVO>, param2:uint = 0)
        {
            this._recommendVector = new Vector.<PlayFinishRecommendItem>;
            this._recommendData = param1;
            this._channelID = param2;
            if (this._recommendData && this._recommendData.length > 0)
            {
                this.initPanel();
            }
            return;
        }// end function

        public function get showHeight() : Number
        {
            return this._showHeight;
        }// end function

        public function get showWidth() : Number
        {
            return this._showWidth;
        }// end function

        private function initPanel() : void
        {
            var _loc_1:PlayFinishRecommendItem = null;
            var _loc_3:URLRequest = null;
            var _loc_4:Sound = null;
            var _loc_5:Rectangle = null;
            var _loc_6:Boolean = false;
            var _loc_7:Boolean = false;
            try
            {
                _loc_3 = new URLRequest(RecommendDef.SOUND_URL);
                _loc_4 = new Sound();
                _loc_4.load(_loc_3);
                this._song = _loc_4.play();
            }
            catch ($error:Error)
            {
            }
            var _loc_2:uint = 0;
            while (_loc_2 < this._recommendData.length)
            {
                
                _loc_5 = PlayFinishRecommendUtils.getRecommendItemRectangle(_loc_2);
                _loc_6 = _loc_2 == 0 ? (true) : (false);
                if (_loc_2 == (this._recommendData.length - 1) && (this._channelID == ChannelEnum.ENTERTAINMENT.id || this._channelID == ChannelEnum.HUMOR.id || this._channelID == ChannelEnum.NEWS.id || this._channelID == ChannelEnum.FINANCE.id))
                {
                    _loc_7 = true;
                }
                else
                {
                    _loc_7 = false;
                }
                _loc_1 = new PlayFinishRecommendItem(this._recommendData[_loc_2], _loc_5.width, _loc_5.height, _loc_6, _loc_7);
                _loc_1.x = _loc_5.x;
                _loc_1.y = _loc_5.y;
                this._recommendVector.push(_loc_1);
                addChild(_loc_1);
                _loc_1.addEventListener(MouseEvent.CLICK, this.onItemMouseClick);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function onItemMouseClick(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as PlayFinishRecommendItem;
            if (_loc_2.isCustomize)
            {
                dispatchEvent(new RecommendEvent(RecommendEvent.Evt_CustomizeItemClick));
            }
            else
            {
                dispatchEvent(new RecommendEvent(RecommendEvent.Evt_OpenVideo, _loc_2.data));
            }
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            var _loc_3:* = PlayFinishRecommendUtils.getShowPoint(param1, param2);
            this._showHeight = _loc_3.x * (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT + RecommendDef.PLAY_FINISH_ITEM_GAP);
            this._showWidth = _loc_3.y == 0 ? (200) : (_loc_3.y * (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH + RecommendDef.PLAY_FINISH_ITEM_GAP));
            var _loc_4:int = 0;
            while (_loc_4 < this._recommendVector.length)
            {
                
                this._recommendVector[_loc_4].visible = true;
                if (this._recommendVector[_loc_4].row > _loc_3.x || this._recommendVector[_loc_4].col > _loc_3.y)
                {
                    this._recommendVector[_loc_4].visible = false;
                }
                _loc_4++;
            }
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:PlayFinishRecommendItem = null;
            this._song = null;
            this._recommendData = null;
            while (this._recommendVector.length > 0)
            {
                
                _loc_1 = this._recommendVector.shift();
                _loc_1.removeEventListener(MouseEvent.CLICK, this.onItemMouseClick);
                removeChild(_loc_1);
                _loc_1.destroy();
                _loc_1 = null;
            }
            this._recommendVector.length = 0;
            this._recommendVector = null;
            return;
        }// end function

    }
}
