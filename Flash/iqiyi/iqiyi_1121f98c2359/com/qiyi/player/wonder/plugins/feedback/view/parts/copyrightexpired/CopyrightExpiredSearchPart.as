package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.feedback.view.*;
    import feedback.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class CopyrightExpiredSearchPart extends Sprite
    {
        private var _titleTF:TextField;
        private var _searchTF:TextField;
        private var _titleBg:Shape;
        private var _searchBtn:SearchBtn;
        private var _videoName:String = "";
        private static const TF_TITLE_SHORT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SEARCH_PART_DES1);
        private static const TF_TITLE_LONG:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SEARCH_PART_DES2);

        public function CopyrightExpiredSearchPart()
        {
            this._titleTF = FastCreator.createLabel(TF_TITLE_SHORT, 16777215, 14);
            addChild(this._titleTF);
            this._titleBg = new Shape();
            addChild(this._titleBg);
            this._searchTF = FastCreator.createInput(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SEARCH_PART_DES3), 6710886, 14);
            addChild(this._searchTF);
            this._searchBtn = new SearchBtn();
            addChild(this._searchBtn);
            this._searchBtn.addEventListener(MouseEvent.CLICK, this.onSearchBtnClick);
            GlobalStage.stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            return;
        }// end function

        public function get videoName() : String
        {
            return this._videoName;
        }// end function

        public function set videoName(param1:String) : void
        {
            this._videoName = param1;
            this._searchTF.text = this._videoName;
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            this._titleTF.text = param1 >= FeedbackDef.NUM_WIDTH_SHOW_SEARCH_PART && param2 >= FeedbackDef.NUM_HEIGHT_SHOW_SEARCH_PART ? (TF_TITLE_LONG) : (TF_TITLE_SHORT);
            this._titleTF.x = (param1 - this._titleTF.width) / 2;
            this._titleBg.graphics.clear();
            this._titleBg.graphics.beginFill(16777215);
            this._titleBg.graphics.drawRect(0, 0, param1 >= 1000 ? (500) : (param1 * 0.5), 30);
            this._titleBg.graphics.endFill();
            this._titleBg.y = this._titleTF.height + 10;
            this._titleBg.x = (param1 - this._titleBg.width - this._searchBtn.width) / 2;
            this._searchTF.x = this._titleBg.x + 3;
            this._searchTF.y = this._titleBg.y + 2;
            this._searchTF.width = this._titleBg.width - 6;
            this._searchBtn.x = this._titleBg.x + this._titleBg.width;
            this._searchBtn.y = this._titleBg.y;
            return;
        }// end function

        private function onSearchBtnClick(event:MouseEvent = null) : void
        {
            if (this._searchTF.text == "" || !visible)
            {
                return;
            }
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_CopyrightSearchBtnClick, this._searchTF.text));
            return;
        }// end function

        private function onKeyUp(event:KeyboardEvent) : void
        {
            switch(event.keyCode)
            {
                case 13:
                {
                    this.onSearchBtnClick();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function destory() : void
        {
            this._searchBtn.removeEventListener(MouseEvent.CLICK, this.onSearchBtnClick);
            GlobalStage.stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            removeChild(this._titleTF);
            this._titleTF = null;
            this._titleBg.graphics.clear();
            removeChild(this._titleBg);
            this._titleBg = null;
            removeChild(this._searchTF);
            this._searchTF = null;
            removeChild(this._searchBtn);
            this._searchBtn = null;
            return;
        }// end function

    }
}
