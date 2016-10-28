package com.qiyi.player.wonder.plugins.controllbar.view.seekbar
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import common.*;
    import controllbar.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class VideoHeadTailTipPanel extends Sprite
    {
        private var _bg:CommonBg;
        private var _tipText:TextField = null;
        private var _tfYes:TextField = null;
        private var _tfNo:TextField = null;
        private var _selectStyle:StyleSheet;
        private var _unSelectStyle:StyleSheet;
        private static const TEXT_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TAIL_TIP_PANEL_DES1);
        private static const TEXT_YES_LINK:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TAIL_TIP_PANEL_YES);
        private static const TEXT_NO_LINK:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TAIL_TIP_PANEL_NO);

        public function VideoHeadTailTipPanel()
        {
            this._bg = new CommonBg();
            this._bg.mouseEnabled = false;
            this._bg.mouseChildren = false;
            this._bg.width = 110;
            this._bg.height = 58;
            addChild(this._bg);
            var _loc_1:* = new HighlightLine();
            _loc_1.mouseEnabled = false;
            _loc_1.mouseChildren = false;
            _loc_1.width = this._bg.width;
            addChild(_loc_1);
            this._tipText = FastCreator.createLabel(TEXT_TITLE, 13421772, 14);
            var _loc_2:Boolean = false;
            this._tipText.selectable = false;
            this._tipText.mouseEnabled = _loc_2;
            addChild(this._tipText);
            this._selectStyle = new StyleSheet();
            this._selectStyle.setStyle("a:hover", {color:"#cccccc"});
            this._selectStyle.setStyle("a", {color:"#99cc00"});
            this._unSelectStyle = new StyleSheet();
            this._unSelectStyle.setStyle("a:hover", {color:"#99cc00"});
            this._unSelectStyle.setStyle("a", {color:"#cccccc"});
            this._tfYes = FastCreator.createLabel(TEXT_YES_LINK, 16777215, 14);
            addChild(this._tfYes);
            this._tfNo = FastCreator.createLabel(TEXT_NO_LINK, 16777215, 14);
            addChild(this._tfNo);
            this._tfYes.addEventListener(TextEvent.LINK, this.onTfYesClick);
            this._tfNo.addEventListener(TextEvent.LINK, this.onTfNoClick);
            return;
        }// end function

        private function onTfYesClick(event:TextEvent) : void
        {
            if (this.parent)
            {
                GlobalStage.stage.removeChild(this);
            }
            Settings.instance.skipTrailer = true;
            Settings.instance.skipTitle = true;
            return;
        }// end function

        private function onTfNoClick(event:TextEvent) : void
        {
            if (this.parent)
            {
                GlobalStage.stage.removeChild(this);
            }
            Settings.instance.skipTrailer = false;
            Settings.instance.skipTitle = false;
            return;
        }// end function

        public function updateTip() : void
        {
            this._tipText.x = (this._bg.width - this._tipText.width) / 2;
            this._tipText.y = 5;
            this._tfYes.x = (this._bg.width - this._tfYes.width) * 0.25;
            this._tfNo.x = (this._bg.width - this._tfYes.width) * 0.75;
            var _loc_1:int = 30;
            this._tfYes.y = 30;
            this._tfNo.y = _loc_1;
            if (Settings.instance.skipTrailer)
            {
                this._tfYes.styleSheet = this._selectStyle;
                this._tfNo.styleSheet = this._unSelectStyle;
            }
            else
            {
                this._tfYes.styleSheet = this._unSelectStyle;
                this._tfNo.styleSheet = this._selectStyle;
            }
            if (this.x < 2)
            {
                this.x = 2;
            }
            if (this.x > GlobalStage.stage.stageWidth - this.width)
            {
                this.x = GlobalStage.stage.stageWidth - this.width - 2;
            }
            return;
        }// end function

    }
}
