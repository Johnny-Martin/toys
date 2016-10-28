package com.qiyi.cupid.adplayer.view.components
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    dynamic public class AdBlockTips extends MovieClip
    {
        public var _otherBrowserBtn:SimpleButton;
        public var _feedbackBtn:SimpleButton;
        public var _installBtn:SimpleButton;

        public function AdBlockTips()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        public function installBtnMouseClickHandler(event:MouseEvent) : void
        {
            navigateToURL(new URLRequest("http://static.qiyi.com/ext/common/QIYImedia_0_13.exe"), "_self");
            return;
        }// end function

        public function feedbackBtnMouseClickHandler(event:MouseEvent) : void
        {
            navigateToURL(new URLRequest("http://www.iqiyi.com/common/helpandsuggest.html"), "_blank");
            return;
        }// end function

        public function otherBrowserBtnMouseClickHandler(event:MouseEvent) : void
        {
            navigateToURL(new URLRequest("http://www.iqiyi.com/common/helpandsuggest.html#wenti31"), "_blank");
            return;
        }// end function

        function frame1()
        {
            this._installBtn.addEventListener(MouseEvent.CLICK, this.installBtnMouseClickHandler);
            this._feedbackBtn.addEventListener(MouseEvent.CLICK, this.feedbackBtnMouseClickHandler);
            this._otherBrowserBtn.addEventListener(MouseEvent.CLICK, this.otherBrowserBtnMouseClickHandler);
            return;
        }// end function

    }
}
