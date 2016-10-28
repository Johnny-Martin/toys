package com.qiyi.player.wonder.plugins.videolink.view.part
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.videolink.*;
    import com.qiyi.player.wonder.plugins.videolink.model.*;
    import com.qiyi.player.wonder.plugins.videolink.view.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import videolink.*;

    public class VideoLinkPanel extends Sprite implements IDestroy
    {
        private var _closeBtn:CommonCloseBtn;
        private var _commanBg:CommonBg;
        private var _descriptionTf:TextField;
        private var _linkBtn:VideoLinkBtn;
        private var _linkBtnTF:TextField;
        private var _loader:Loader;
        private static const CONST_DISTANCE:uint = 70;

        public function VideoLinkPanel()
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
            this._descriptionTf = FastCreator.createLabel("123", 16777215, 12, TextFieldAutoSize.LEFT);
            this._descriptionTf.x = 120;
            this._descriptionTf.y = 4;
            this._descriptionTf.width = 140;
            var _loc_1:Boolean = true;
            this._descriptionTf.multiline = true;
            this._descriptionTf.wordWrap = _loc_1;
            addChild(this._descriptionTf);
            this._linkBtn = new VideoLinkBtn();
            this._linkBtn.x = 125;
            this._linkBtn.y = 45;
            addChild(this._linkBtn);
            this._linkBtnTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEOLINK_VIEW_DES5), 16777215, 13, TextFieldAutoSize.LEFT);
            this._linkBtnTF.x = this._linkBtn.x + (this._linkBtn.width - this._linkBtnTF.width) * 0.5;
            this._linkBtnTF.y = this._linkBtn.y + (this._linkBtn.height - this._linkBtnTF.height) * 0.5;
            var _loc_1:Boolean = false;
            this._linkBtnTF.mouseEnabled = false;
            this._linkBtnTF.selectable = _loc_1;
            addChild(this._linkBtnTF);
            this._closeBtn = new CommonCloseBtn();
            this._closeBtn.x = this._commanBg.width - this._closeBtn.width;
            addChild(this._closeBtn);
            this._linkBtn.addEventListener(MouseEvent.CLICK, this.onWatchVideoClick);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            return;
        }// end function

        public function updateInfo(param1:VideoLinkInfo) : void
        {
            this._descriptionTf.text = param1.title;
            this.loaderPNG(param1.picUrl);
            switch(param1.btnType)
            {
                case VideoLinkDef.BTN_TYPE_PLAY:
                {
                    this._linkBtnTF.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEOLINK_VIEW_DES5);
                    break;
                }
                case VideoLinkDef.BTN_TYPE_DOWNLOAD:
                {
                    this._linkBtnTF.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEOLINK_VIEW_DES4);
                    break;
                }
                case VideoLinkDef.BTN_TYPE_INSERT:
                {
                    this._linkBtnTF.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEOLINK_VIEW_DES6);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            return;
        }// end function

        private function loaderPNG(param1:String) : void
        {
            this.destroyUpLoader();
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError);
            this._loader.load(new URLRequest(param1));
            return;
        }// end function

        private function onComplete(event:Event) : void
        {
            addChild(this._loader);
            return;
        }// end function

        private function onIOError(event:Event) : void
        {
            return;
        }// end function

        private function destroyUpLoader() : void
        {
            if (this._loader == null)
            {
                return;
            }
            if (this._loader.parent)
            {
                removeChild(this._loader);
            }
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError);
            this._loader = null;
            return;
        }// end function

        private function onWatchVideoClick(event:MouseEvent) : void
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
            this.destroyUpLoader();
            this._linkBtn.removeEventListener(MouseEvent.CLICK, this.onWatchVideoClick);
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
