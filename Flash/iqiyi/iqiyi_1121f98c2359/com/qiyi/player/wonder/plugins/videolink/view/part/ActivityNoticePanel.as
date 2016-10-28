package com.qiyi.player.wonder.plugins.videolink.view.part
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.videolink.view.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import videolink.*;

    public class ActivityNoticePanel extends Sprite implements IDestroy
    {
        private var _closeBtn:CommonCloseBtn;
        private var _commanBg:CommonBg;
        private var _suona:ActivityNoticeSuona;
        private var _descriptionTf:TextField;
        private var _linkTF:TextField;
        private static const TEXT_LINK:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEOLINK_VIEW_DES1);

        public function ActivityNoticePanel()
        {
            this.initUI();
            return;
        }// end function

        private function initUI() : void
        {
            this._commanBg = new CommonBg();
            this._commanBg.width = 290;
            this._commanBg.height = 70;
            addChild(this._commanBg);
            this._suona = new ActivityNoticeSuona();
            this._suona.x = 15;
            this._suona.y = 25;
            addChild(this._suona);
            this._descriptionTf = FastCreator.createLabel("11111", 16777215, 12, TextFieldAutoSize.LEFT);
            this._descriptionTf.y = 14;
            this._descriptionTf.width = 270;
            var _loc_1:Boolean = true;
            this._descriptionTf.multiline = true;
            this._descriptionTf.wordWrap = _loc_1;
            addChild(this._descriptionTf);
            this._linkTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEOLINK_VIEW_DES2), 16749085, 12, TextFieldAutoSize.LEFT);
            this._linkTF.x = 220;
            this._linkTF.y = 30;
            this._linkTF.htmlText = TEXT_LINK;
            addChild(this._linkTF);
            this._closeBtn = new CommonCloseBtn();
            this._closeBtn.x = this._commanBg.width - this._closeBtn.width;
            addChild(this._closeBtn);
            this._linkTF.addEventListener(TextEvent.LINK, this.onWatchVideoClick);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            return;
        }// end function

        public function updateInfo(param1:String) : void
        {
            this._descriptionTf.text = "      " + param1;
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            return;
        }// end function

        private function onWatchVideoClick(event:TextEvent) : void
        {
            dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_BtnAndIconClick));
            return;
        }// end function

        private function onCloseBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new VideoLinkEvent(VideoLinkEvent.Evt_Close));
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:DisplayObject = null;
            this._linkTF.removeEventListener(TextEvent.LINK, this.onWatchVideoClick);
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            while (numChildren)
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
