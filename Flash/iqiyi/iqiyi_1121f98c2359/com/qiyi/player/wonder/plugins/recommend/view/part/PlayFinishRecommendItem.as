package com.qiyi.player.wonder.plugins.recommend.view.part
{
    import com.qiyi.player.comps.rb.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import com.qiyi.player.wonder.plugins.recommend.model.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import gs.*;

    public class PlayFinishRecommendItem extends Sprite
    {
        private var _data:RecommendVO;
        private var _row:uint = 0;
        private var _col:uint = 0;
        private var _isBig:Boolean = false;
        private var _isCustomize:Boolean = false;
        private var _picLoader:Loader;
        private var _imgContainer:Sprite;
        private var _cover:MovieClip;
        private var _flow:Sprite;
        private var _flowTitleTF:TextField;
        private var _flowSubTitleTF:TextField;
        private var _coverTitleTF:TextField;
        private var _coverTypeTF:TextField;
        private var _coverEpisodeTF:TextField;
        private var _coverSubTitleTF:TextField;
        private var _picLoadingMC:CommonLoadingMC;

        public function PlayFinishRecommendItem(param1:RecommendVO, param2:uint, param3:uint, param4:Boolean = false, param5:Boolean = false)
        {
            this._data = param1;
            this._row = param2;
            this._col = param3;
            this._isBig = param4;
            this._isCustomize = param5;
            this._imgContainer = new Sprite();
            addChild(this._imgContainer);
            this._picLoadingMC = new CommonLoadingMC();
            this._picLoadingMC.x = (this._isBig ? (RecommendDef.PLAY_FINISH_BIG_ITEM_WIDTH) : (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH)) / 2 - this._picLoadingMC.width / 2;
            this._picLoadingMC.y = (this._isBig ? (RecommendDef.PLAY_FINISH_BIG_ITEM_HEIGHT) : (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT)) / 2 - this._picLoadingMC.height / 2;
            if (this._isBig)
            {
                this.initBigItem();
                this._imgContainer.addChild(this._picLoadingMC);
            }
            else if (this._isCustomize)
            {
                this.initCustomizeItem();
            }
            else
            {
                this.initSmallItem();
                this._imgContainer.addChild(this._picLoadingMC);
            }
            return;
        }// end function

        public function get isCustomize() : Boolean
        {
            return this._isCustomize;
        }// end function

        public function get data() : RecommendVO
        {
            return this._data;
        }// end function

        public function get col() : uint
        {
            return this._col;
        }// end function

        public function get row() : uint
        {
            return this._row;
        }// end function

        private function initCustomizeItem() : void
        {
            this._imgContainer.graphics.beginFill(5343488);
            this._imgContainer.graphics.drawRect(0, 0, 160, 90);
            this._imgContainer.graphics.endFill();
            this._coverTitleTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.RECOMMEND_ITEM_DES1), 16777215, 20);
            this._coverTitleTF.x = (160 - this._coverTitleTF.width) / 2;
            this._coverTitleTF.y = (90 - this._coverTitleTF.height) / 2;
            var _loc_1:Boolean = false;
            this._coverTitleTF.mouseEnabled = false;
            this._coverTitleTF.selectable = _loc_1;
            this._imgContainer.addChild(this._coverTitleTF);
            var _loc_1:Boolean = true;
            this._imgContainer.useHandCursor = true;
            this._imgContainer.buttonMode = _loc_1;
            return;
        }// end function

        private function initBigItem() : void
        {
            this.loaderPic(this._data.picUrl == "" ? (SystemConfig.DEFAULT_IMAGE_URL) : (this._data.picUrl));
            var _loc_4:Boolean = true;
            this._imgContainer.useHandCursor = true;
            this._imgContainer.buttonMode = _loc_4;
            this._cover = new BigCover();
            this._cover.y = RecommendDef.PLAY_FINISH_BIG_ITEM_HEIGHT - 20;
            this._cover.mouseChildren = false;
            var _loc_4:Boolean = true;
            this._cover.buttonMode = true;
            this._cover.mouseEnabled = _loc_4;
            addChild(this._cover);
            this._coverTypeTF = FastCreator.createLabel(PlayFinishRecommendUtils.getChannelChineseName(this._data.channel), 16777215, 12, "left");
            this._coverTypeTF.x = 0;
            this._cover.bigCoverMC.addChild(this._coverTypeTF);
            var _loc_1:* = PlayFinishRecommendUtils.getUpdate(this._data.channel, this._data.timeLength, this._data.updateFlag, this._data.latestOrder);
            this._coverEpisodeTF = FastCreator.createLabel(_loc_1, 16777215);
            this._coverEpisodeTF.x = this._cover.width - this._coverEpisodeTF.width;
            this._cover.bigCoverMC.addChild(this._coverEpisodeTF);
            var _loc_2:* = this._data.albumName == "" ? (this._data.videoName) : (this._data.albumName);
            this._coverTitleTF = FastCreator.createLabel("", 16777215);
            this._coverTitleTF.text = _loc_2.length > 14 ? (_loc_2.slice(0, 13) + "...") : (_loc_2);
            this._coverTitleTF.x = this._cover.width / 2 - this._coverTitleTF.width / 2;
            this._cover.bigCoverMC.addChild(this._coverTitleTF);
            var _loc_3:* = this._data.focus.length > 14 ? (this._data.focus.slice(0, 13) + "...") : (this._data.focus);
            this._coverSubTitleTF = FastCreator.createLabel(_loc_3, 16777215);
            this._coverSubTitleTF.x = this._cover.width / 2 - this._coverSubTitleTF.width / 2;
            this._coverSubTitleTF.y = 20;
            this._cover.bigCoverMC.addChild(this._coverSubTitleTF);
            addEventListener(MouseEvent.ROLL_OVER, this.onBigMouseOver);
            addEventListener(MouseEvent.ROLL_OUT, this.onBigMouseOut);
            return;
        }// end function

        private function onBigMouseOver(event:MouseEvent) : void
        {
            TweenLite.killTweensOf(this._cover.bigCoverMC);
            TweenLite.to(this._cover.bigCoverMC, 0.5, {y:-20});
            return;
        }// end function

        private function onBigMouseOut(event:MouseEvent) : void
        {
            TweenLite.killTweensOf(this._cover.bigCoverMC);
            TweenLite.to(this._cover.bigCoverMC, 0.5, {y:0});
            return;
        }// end function

        private function initSmallItem() : void
        {
            this.loaderPic(this._data.picUrl == "" ? (SystemConfig.DEFAULT_IMAGE_URL) : (this._data.picUrl));
            this._cover = new MovieClip();
            this._cover.graphics.beginFill(0, 0.8);
            this._cover.graphics.drawRect(0, 0, RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH, 20);
            this._cover.graphics.endFill();
            this._cover.y = RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT - 19;
            addChild(this._cover);
            this.addFlow();
            var _loc_1:* = this._data.albumName == "" ? (this._data.videoName) : (this._data.albumName);
            this._coverTitleTF = FastCreator.createLabel(_loc_1.length > 11 ? (_loc_1.slice(0, 11) + "...") : (_loc_1), 16777215);
            this._coverTitleTF.x = this._cover.width / 2 - this._coverTitleTF.width / 2;
            this._cover.addChild(this._coverTitleTF);
            addEventListener(MouseEvent.ROLL_OVER, this.onSmallMouseOver);
            addEventListener(MouseEvent.ROLL_OUT, this.onSmallMouseOut);
            return;
        }// end function

        private function addFlow() : void
        {
            var _loc_1:String = null;
            this._flow = new Sprite();
            this._flow.graphics.beginFill(0, 0.7);
            this._flow.graphics.drawRect(0, 0, RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH, RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT);
            this._flow.graphics.endFill();
            var _loc_2:Boolean = false;
            this._flow.mouseChildren = false;
            this._flow.visible = _loc_2;
            var _loc_2:Boolean = true;
            this._flow.buttonMode = true;
            this._flow.mouseEnabled = _loc_2;
            addChild(this._flow);
            _loc_1 = this._data.albumName == "" ? (this._data.videoName) : (this._data.albumName);
            this._flowTitleTF = FastCreator.createLabel("", 16777215, 13);
            this._flowTitleTF.x = 0;
            this._flowTitleTF.width = RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH;
            this._flowTitleTF.wordWrap = true;
            this._flow.addChild(this._flowTitleTF);
            this._flowTitleTF.defaultTextFormat = new TextFormat(FastCreator.FONT_MSYH, 13, 16777215, false, null, null, null, null, "center");
            this._flowTitleTF.text = _loc_1.length > 21 ? (_loc_1.slice(0, 21) + "...") : (_loc_1);
            this._flowTitleTF.y = this._flowTitleTF.numLines > 1 ? (12) : (25);
            this._flowSubTitleTF = FastCreator.createLabel("", 13421772, 12);
            this._flowSubTitleTF.x = 0;
            this._flowSubTitleTF.y = 55;
            this._flowSubTitleTF.width = RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH;
            this._flowSubTitleTF.text = this._data.focus.length > 9 ? (this._data.focus.slice(0, 8) + "...") : (this._data.focus);
            this._flow.addChild(this._flowSubTitleTF);
            return;
        }// end function

        private function onSmallMouseOver(event:MouseEvent) : void
        {
            this._flow.visible = true;
            return;
        }// end function

        private function onSmallMouseOut(event:MouseEvent) : void
        {
            this._flow.visible = false;
            return;
        }// end function

        private function loaderPic(param1:String) : void
        {
            var _loc_2:* = this._isBig ? (284) : (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH);
            var _loc_3:* = this._isBig ? (160) : (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT);
            param1 = param1.replace(".jpg", "_" + _loc_2 + "_" + _loc_3 + ".jpg");
            param1 = param1.replace(".JPG", "_" + _loc_2 + "_" + _loc_3 + ".JPG");
            this._picLoader = new Loader();
            this._picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaderComplete);
            this._picLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoaderError);
            this._picLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onLoaderError);
            this._picLoader.load(new URLRequest(param1), new LoaderContext(true));
            return;
        }// end function

        private function onLoaderComplete(event:Event) : void
        {
            var _loc_2:* = new Bitmap(this._picLoader.content["bitmapData"]);
            _loc_2.smoothing = true;
            _loc_2.width = this._isBig ? (RecommendDef.PLAY_FINISH_BIG_ITEM_WIDTH) : (RecommendDef.PLAY_FINISH_SMALL_ITEM_WIDTH);
            _loc_2.height = this._isBig ? (RecommendDef.PLAY_FINISH_BIG_ITEM_HEIGHT) : (RecommendDef.PLAY_FINISH_SMALL_ITEM_HEIGHT);
            this._imgContainer.addChild(_loc_2);
            this._picLoadingMC.visible = false;
            this.destroyUpLoader();
            return;
        }// end function

        private function onLoaderError(event:Event) : void
        {
            this.destroyUpLoader();
            return;
        }// end function

        private function destroyUpLoader() : void
        {
            if (this._picLoader == null)
            {
                return;
            }
            this._picLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoaderComplete);
            this._picLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoaderError);
            this._picLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onLoaderError);
            this._picLoader = null;
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:DisplayObject = null;
            var _loc_2:DisplayObject = null;
            var _loc_3:DisplayObject = null;
            this.destroyUpLoader();
            this._data = null;
            removeEventListener(MouseEvent.ROLL_OVER, this.onSmallMouseOver);
            removeEventListener(MouseEvent.ROLL_OUT, this.onSmallMouseOut);
            if (this._imgContainer && this._imgContainer.parent)
            {
                while (this._imgContainer.numChildren > 0)
                {
                    
                    _loc_1 = this._imgContainer.getChildAt(0);
                    this._imgContainer.removeChild(_loc_1);
                    _loc_1 = null;
                }
                removeChild(this._imgContainer);
                this._imgContainer = null;
            }
            if (this._flow && this._flow.parent)
            {
                while (this._flow.numChildren > 0)
                {
                    
                    _loc_2 = this._flow.getChildAt(0);
                    this._flow.removeChild(_loc_2);
                    _loc_2 = null;
                }
                removeChild(this._flow);
                this._flow = null;
            }
            if (this._cover && this._cover.parent)
            {
                while (this._cover.numChildren > 0)
                {
                    
                    _loc_3 = this._cover.getChildAt(0);
                    this._cover.removeChild(_loc_3);
                    _loc_3 = null;
                }
                removeChild(this._cover);
                this._cover = null;
            }
            return;
        }// end function

    }
}
