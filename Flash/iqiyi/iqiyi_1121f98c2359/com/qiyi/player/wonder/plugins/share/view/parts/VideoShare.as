package com.qiyi.player.wonder.plugins.share.view.parts
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.tooltip.*;
    import com.iqiyi.components.videoshare.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.share.*;
    import com.qiyi.player.wonder.plugins.share.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;

    public class VideoShare extends Sprite
    {
        private var _screenShotTitle:TextField;
        private var _embedCodesTitle:TextField;
        private var _shareBtnsBar:ShareBtnsBarUI;
        private var _embedCodes:EmbedCodesUI;
        private var _copyFlashBtn:SimpleBtn;
        private var _copyVideoBtn:SimpleBtn;
        private var _copyHtmlBtn:SimpleBtn;
        private var _htmlUrl:String;
        private var _swfUrl:String;
        private var _videoUrl:String;
        private var _duration:Number;
        private var _flvTitle:String;
        private var _channel:EnumItem;
        private var _isShowLinkUrl:Boolean = false;
        private static const TEXT_SHOT_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES1);
        private static const TEXT_CODE_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES2);
        private static const TEXT_SINE_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES3);
        private static const TEXT_RENREN_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES4);
        private static const TEXT_TENCENT_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES5);
        private static const TEXT_QZONE_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES6);
        private static const TEXT_COPY_FLASH:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES7);
        private static const TEXT_COPY_VIDEO:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES8);
        private static const TEXT_COPY_HTML:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.VIDEO_SHARE_DES9);

        public function VideoShare(param1:String, param2:String, param3:Number, param4:EnumItem, param5:String, param6:String, param7:Boolean)
        {
            this._htmlUrl = param1;
            this._swfUrl = param2;
            this._duration = param3;
            this._channel = param4;
            this._videoUrl = param5;
            this._flvTitle = param6;
            this._isShowLinkUrl = param7;
            this.initShareBtnsBarPart();
            if (param7)
            {
                this.initCopyUrlPart();
            }
            return;
        }// end function

        private function initCopyUrlPart() : void
        {
            this._embedCodes = new EmbedCodesUI();
            this._embedCodes.copyOK.visible = false;
            addChild(this._embedCodes);
            this._embedCodesTitle = FastCreator.createLabel(TEXT_CODE_TITLE, 13421772);
            this._embedCodesTitle.x = 20;
            this._embedCodesTitle.y = 62;
            addChild(this._embedCodesTitle);
            this._copyFlashBtn = new SimpleBtn(TEXT_COPY_FLASH, 100);
            this._copyFlashBtn.x = this._embedCodesTitle.x;
            addChild(this._copyFlashBtn);
            this._copyVideoBtn = new SimpleBtn(TEXT_COPY_VIDEO, 100);
            this._copyVideoBtn.x = 111 + this._embedCodesTitle.x;
            addChild(this._copyVideoBtn);
            this._copyHtmlBtn = new SimpleBtn(TEXT_COPY_HTML, 100);
            this._copyHtmlBtn.x = 222 + this._embedCodesTitle.x;
            addChild(this._copyHtmlBtn);
            var _loc_1:* = this._embedCodesTitle.y + this._embedCodesTitle.height + 5;
            this._copyHtmlBtn.y = this._embedCodesTitle.y + this._embedCodesTitle.height + 5;
            var _loc_1:* = _loc_1;
            this._copyVideoBtn.y = _loc_1;
            this._copyFlashBtn.y = _loc_1;
            this._copyFlashBtn.addEventListener(MouseEvent.CLICK, this.copyFlashURL);
            this._copyVideoBtn.addEventListener(MouseEvent.CLICK, this.copyVideoURL);
            this._copyHtmlBtn.addEventListener(MouseEvent.CLICK, this.copyHtmlURL);
            return;
        }// end function

        private function initShareBtnsBarPart() : void
        {
            this._shareBtnsBar = new ShareBtnsBarUI();
            this._shareBtnsBar.x = 83;
            this._shareBtnsBar.y = 32;
            addChild(this._shareBtnsBar);
            this._screenShotTitle = FastCreator.createLabel(TEXT_SHOT_TITLE, 13421772);
            this._screenShotTitle.x = 20;
            this._screenShotTitle.y = 33;
            addChild(this._screenShotTitle);
            ToolTip.getInstance().registerComponent(this._shareBtnsBar.sinaBtn, TEXT_SINE_TITLE);
            ToolTip.getInstance().registerComponent(this._shareBtnsBar.qzoneBtn, TEXT_QZONE_TITLE);
            ToolTip.getInstance().registerComponent(this._shareBtnsBar.tencentBtn, TEXT_TENCENT_TITLE);
            ToolTip.getInstance().registerComponent(this._shareBtnsBar.renrenBtn, TEXT_RENREN_TITLE);
            this._shareBtnsBar.renrenBtn.addEventListener(MouseEvent.MOUSE_UP, this.renrenShareHandler);
            this._shareBtnsBar.sinaBtn.addEventListener(MouseEvent.MOUSE_UP, this.sinaShareHandler);
            this._shareBtnsBar.qzoneBtn.addEventListener(MouseEvent.MOUSE_UP, this.qzoneShareHandler);
            this._shareBtnsBar.tencentBtn.addEventListener(MouseEvent.MOUSE_UP, this.tencentShareHandler);
            return;
        }// end function

        private function renrenShareHandler(event:MouseEvent) : void
        {
            var _loc_2:* = ShareDef.SHARE_PLATFORM_RENREN_URI + "?link=" + this.getVideoURL() + "&title=" + encodeURIComponent("【视频：" + this._flvTitle + "】（分享@爱奇艺）");
            this.shareBtnClick(_loc_2, ShareDef.SHARE_TYPE_RENREN);
            return;
        }// end function

        private function sinaShareHandler(event:MouseEvent) : void
        {
            var _loc_2:String = "";
            _loc_2 = ShareDef.SHARE_PLATFORM_SINA_URI + "?appkey=1925825497&url=" + this.getVideoURL() + "&title=" + encodeURIComponent("【视频：" + this._flvTitle + "】") + "&content=utf-8&pic=&ralateUid=1731986465";
            this.shareBtnClick(_loc_2, ShareDef.SHARE_TYPE_SINA);
            return;
        }// end function

        private function qzoneShareHandler(event:MouseEvent) : void
        {
            var _loc_2:* = ShareDef.SHARE_PLATFORM_QQ_URI + "?url=" + this.getVideoURL().split("=").join("%3D");
            this.shareBtnClick(_loc_2, ShareDef.SHARE_TYPE_QQ);
            return;
        }// end function

        private function tencentShareHandler(event:MouseEvent) : void
        {
            var _loc_2:* = ShareDef.SHARE_PLATFORM_TENCENT_URI + "?title=" + encodeURIComponent("【视频：" + this._flvTitle + "】（分享@爱奇艺）") + "&url=" + this.getVideoURL().split("=").join("%3D");
            this.shareBtnClick(_loc_2, ShareDef.SHARE_TYPE_TENCENT);
            return;
        }// end function

        private function getVideoURL() : String
        {
            var _loc_2:RegExp = null;
            var _loc_1:String = "";
            if (this._videoUrl != null)
            {
                _loc_1 = this._videoUrl.indexOf("?") == -1 ? (this._videoUrl + "?" + "share_sTime=" + 0 + "-share_eTime=" + Math.floor(this._duration / 1000) + "-src=sharemodclk131212") : (this._videoUrl + "&" + "share_sTime=" + 0 + "-share_eTime=" + Math.floor(this._duration / 1000) + "-src=sharemodclk131212");
                _loc_2 = /&""&/g;
                _loc_1 = _loc_1.replace(_loc_2, "%26");
            }
            return _loc_1;
        }// end function

        private function shareBtnClick(param1:String, param2:String) : void
        {
            GlobalStage.setNormalScreen();
            navigateToURL(new URLRequest(param1), "_blank");
            var _loc_3:* = new ShareEvent(ShareEvent.Evt_ShareBtnClick);
            _loc_3.data = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

        private function copyFlashURL(event:MouseEvent) : void
        {
            System.setClipboard(this._swfUrl);
            this.playCopySuccess(this._copyFlashBtn.x + 32, this._copyFlashBtn.y + 20);
            return;
        }// end function

        private function copyVideoURL(event:MouseEvent) : void
        {
            var _loc_2:* = /%26""%26/g;
            var _loc_3:* = this.getVideoURL().replace(_loc_2, "&");
            if (_loc_3 == this._videoUrl)
            {
                System.setClipboard(this._videoUrl);
            }
            else
            {
                System.setClipboard(_loc_3);
            }
            this.playCopySuccess(this._copyVideoBtn.x + 32, this._copyVideoBtn.y + 20);
            return;
        }// end function

        private function copyHtmlURL(event:MouseEvent) : void
        {
            System.setClipboard(this._htmlUrl);
            this.playCopySuccess(this._copyHtmlBtn.x + 32, this._copyHtmlBtn.y + 20);
            return;
        }// end function

        private function playCopySuccess(param1:Number, param2:Number) : void
        {
            this._embedCodes.copyOK.x = param1;
            this._embedCodes.copyOK.y = param2;
            this._embedCodes.copyOK.visible = true;
            this._embedCodes.copyOK.gotoAndPlay(2);
            return;
        }// end function

        public function destory() : void
        {
            ToolTip.getInstance().unregisterComponent(this._shareBtnsBar.sinaBtn);
            ToolTip.getInstance().unregisterComponent(this._shareBtnsBar.qzoneBtn);
            ToolTip.getInstance().unregisterComponent(this._shareBtnsBar.tencentBtn);
            ToolTip.getInstance().unregisterComponent(this._shareBtnsBar.renrenBtn);
            this._shareBtnsBar.renrenBtn.removeEventListener(MouseEvent.MOUSE_UP, this.renrenShareHandler);
            this._shareBtnsBar.sinaBtn.removeEventListener(MouseEvent.MOUSE_UP, this.sinaShareHandler);
            this._shareBtnsBar.qzoneBtn.removeEventListener(MouseEvent.MOUSE_UP, this.qzoneShareHandler);
            this._shareBtnsBar.tencentBtn.removeEventListener(MouseEvent.MOUSE_UP, this.tencentShareHandler);
            if (this._screenShotTitle && this._screenShotTitle.parent)
            {
                removeChild(this._screenShotTitle);
                this._screenShotTitle = null;
            }
            if (this._embedCodesTitle && this._embedCodesTitle.parent)
            {
                removeChild(this._embedCodesTitle);
                this._embedCodesTitle = null;
            }
            if (this._shareBtnsBar && this._shareBtnsBar.parent)
            {
                removeChild(this._shareBtnsBar);
                this._shareBtnsBar = null;
            }
            if (this._embedCodes && this._embedCodes.parent)
            {
                removeChild(this._embedCodes);
                this._embedCodes = null;
            }
            if (this._copyFlashBtn && this._copyFlashBtn.parent)
            {
                this._copyFlashBtn.removeEventListener(MouseEvent.CLICK, this.copyFlashURL);
                removeChild(this._copyFlashBtn);
                this._copyFlashBtn = null;
            }
            if (this._copyVideoBtn && this._copyVideoBtn.parent)
            {
                this._copyVideoBtn.removeEventListener(MouseEvent.CLICK, this.copyVideoURL);
                removeChild(this._copyVideoBtn);
                this._copyVideoBtn = null;
            }
            if (this._copyHtmlBtn && this._copyHtmlBtn.parent)
            {
                this._copyHtmlBtn.removeEventListener(MouseEvent.CLICK, this.copyHtmlURL);
                removeChild(this._copyHtmlBtn);
                this._copyHtmlBtn = null;
            }
            this._channel = null;
            return;
        }// end function

    }
}
