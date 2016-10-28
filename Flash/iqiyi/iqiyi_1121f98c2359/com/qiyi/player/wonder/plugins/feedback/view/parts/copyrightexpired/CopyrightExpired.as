package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightexpired
{
    import __AS3__.vec.*;
    import com.adobe.serialization.json.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.feedback.view.*;
    import com.qiyi.player.wonder.plugins.recommend.model.*;
    import feedback.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class CopyrightExpired extends Sprite implements IDestroy
    {
        private var _videoName:String = "";
        private var _searchPart:CopyrightExpiredSearchPart;
        private var _listPart:CopyrightExpiredListPart;
        private var _copyRightExpiredUI:CopyRightExpiredUI;
        private var _titleTF:TextField;
        private var _describeTF:TextField;
        private var _clientExtendTF:TextField;
        private var _downLoadBtn:DownLoadBtn;
        private var _downLoadTF:TextField;
        private var _recommendJson:Object = null;
        private var _recommendVector:Vector.<RecommendVO>;
        private var _errorcode:String = "";
        private var _errocodeTF:TextField;
        private static const TEXT_TITLE_EXPIRE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_EXPIRED_DES1);
        private static const TEXT_TITLE_ERROR:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_EXPIRED_DES2);
        private static const TEXT_CLIENT_EXTEND:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_EXPIRED_DES3);
        private static const TEXT_DOWNLOAD_BTN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_EXPIRED_DES4);
        private static const TEXT_LINK:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_EXPIRED_DES5);
        private static const TEXT_RECOMMEND:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.COPYRIGHT_EXPIRED_DES6);
        private static const STR_ERROR_CODE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.ERROR_CODE_DEFAULT_DES);

        public function CopyrightExpired(param1:String, param2:String, param3:Boolean = true, param4:String = "")
        {
            this._errorcode = param2;
            this._copyRightExpiredUI = new CopyRightExpiredUI();
            addChild(this._copyRightExpiredUI);
            this._videoName = param4 != "" ? (param4) : (this._videoName);
            this._titleTF = param3 ? (FastCreator.createLabel(TEXT_TITLE_EXPIRE, 16777215, 18)) : (FastCreator.createLabel(TEXT_TITLE_ERROR, 16777215, 18));
            this._titleTF.x = (this._copyRightExpiredUI.width - this._titleTF.width) / 2;
            this._titleTF.y = -11;
            this._copyRightExpiredUI.addChild(this._titleTF);
            this._clientExtendTF = FastCreator.createLabel(TEXT_CLIENT_EXTEND, 16777215, 12);
            this._clientExtendTF.htmlText = TEXT_CLIENT_EXTEND;
            this._clientExtendTF.x = (this._copyRightExpiredUI.width - this._clientExtendTF.width) * 0.5;
            this._clientExtendTF.y = this._titleTF.y + this._titleTF.height + 10;
            this._copyRightExpiredUI.addChild(this._clientExtendTF);
            this._downLoadBtn = new DownLoadBtn();
            this._downLoadBtn.x = (this._copyRightExpiredUI.width - this._downLoadBtn.width) * 0.5;
            this._downLoadBtn.y = this._clientExtendTF.y + this._clientExtendTF.height + 20;
            this._copyRightExpiredUI.addChild(this._downLoadBtn);
            this._downLoadTF = FastCreator.createLabel(TEXT_DOWNLOAD_BTN, 16777215, 16);
            var _loc_5:Boolean = false;
            this._downLoadTF.mouseEnabled = false;
            this._downLoadTF.selectable = _loc_5;
            this._downLoadTF.x = this._downLoadBtn.x + 18;
            this._downLoadTF.y = this._downLoadBtn.y + (this._downLoadBtn.height - this._downLoadTF.height) * 0.5;
            this._copyRightExpiredUI.addChild(this._downLoadTF);
            this._describeTF = FastCreator.createLabel(TEXT_LINK, 13421772, 14);
            this._describeTF.x = (this._copyRightExpiredUI.width - this._describeTF.width) / 2;
            this._describeTF.y = this._downLoadBtn.y + this._downLoadBtn.height + 20;
            this._copyRightExpiredUI.addChild(this._describeTF);
            this._searchPart = new CopyrightExpiredSearchPart();
            this._searchPart.videoName = this._videoName;
            this._searchPart.addEventListener(FeedbackEvent.Evt_CopyrightSearchBtnClick, this.onSearchVideoClick);
            addChild(this._searchPart);
            this._listPart = new CopyrightExpiredListPart();
            this._listPart.addEventListener(FeedbackEvent.Evt_CopyrightRecItemClick, this.onEvtItemClick);
            addChild(this._listPart);
            this._errocodeTF = FastCreator.createLabel(STR_ERROR_CODE + this._errorcode, 16777215, 14);
            addChild(this._errocodeTF);
            this.requestRecommendList(param1);
            return;
        }// end function

        public function get downLoadBtn() : DownLoadBtn
        {
            return this._downLoadBtn;
        }// end function

        private function requestRecommendList(param1:String) : void
        {
            var _loc_2:* = new URLLoader();
            _loc_2.addEventListener(Event.COMPLETE, this.onCompleteHandler);
            _loc_2.addEventListener(IOErrorEvent.IO_ERROR, this.onErrorHander);
            _loc_2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHander);
            _loc_2.load(new URLRequest(param1));
            return;
        }// end function

        private function onCompleteHandler(event:Event) : void
        {
            var _loc_3:RecommendVO = null;
            var _loc_4:uint = 0;
            var _loc_2:* = event.target as URLLoader;
            try
            {
                this._recommendVector = new Vector.<RecommendVO>;
                this._recommendJson = JSON.decode(_loc_2.data);
                _loc_4 = 0;
                while (_loc_4 < this._recommendJson.mixinVideos.length)
                {
                    
                    _loc_3 = new RecommendVO(_loc_4, this._recommendJson.mixinVideos[_loc_4]);
                    this._recommendVector.push(_loc_3);
                    _loc_4 = _loc_4 + 1;
                }
                this._listPart.recommendData = this._recommendVector;
                this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            }
            catch (e:Error)
            {
            }
            _loc_2.removeEventListener(Event.COMPLETE, this.onCompleteHandler);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onErrorHander);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHander);
            _loc_2 = null;
            return;
        }// end function

        private function onErrorHander(event:Event) : void
        {
            var _loc_2:* = event.target as URLLoader;
            _loc_2.removeEventListener(Event.COMPLETE, this.onCompleteHandler);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onErrorHander);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHander);
            _loc_2 = null;
            return;
        }// end function

        public function get videoName() : String
        {
            return this._videoName;
        }// end function

        public function set videoName(param1:String) : void
        {
            this._videoName = param1;
            return;
        }// end function

        public function get linkTextField() : TextField
        {
            return this._describeTF;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            graphics.clear();
            graphics.beginFill(0);
            graphics.drawRect(0, 0, param1, param2);
            graphics.endFill();
            this._errocodeTF.x = param1 - this._errocodeTF.width - 45;
            this._errocodeTF.y = param2 - 45;
            this._searchPart.resize(param1, param2);
            this._searchPart.visible = param2 >= FeedbackDef.NUM_HEIGHT_SHOW_SEARCH_PART && param1 >= FeedbackDef.NUM_WIDTH_SHOW_SEARCH_PART ? (true) : (false);
            this._listPart.resize(param1, param2);
            this._listPart.visible = param2 >= FeedbackDef.NUM_HEIGHT_SHOW_LIST_PANEL && param1 >= FeedbackDef.NUM_WIDTH_SHOW_SEARCH_PART ? (true) : (false);
            this._copyRightExpiredUI.x = (param1 - this._copyRightExpiredUI.width) / 2;
            this._copyRightExpiredUI.y = param2 / 2 - this._copyRightExpiredUI.height * 0.5 - this._listPart.height * 0.5 * int(this._listPart.visible) - this._searchPart.height * 0.5 * int(this._searchPart.visible) + 30;
            this._searchPart.y = this._copyRightExpiredUI.y + this._copyRightExpiredUI.height;
            this._listPart.y = this._searchPart.y + 70;
            return;
        }// end function

        private function onEvtItemClick(event:FeedbackEvent) : void
        {
            var _loc_6:Object = null;
            var _loc_2:* = event.data as RecommendVO;
            var _loc_3:String = "";
            var _loc_4:String = "";
            var _loc_5:String = "";
            if (this._recommendJson)
            {
                _loc_6 = this._recommendJson.attribute;
                if (_loc_6 && (_loc_6.bkt != undefined || _loc_6.bucket != undefined))
                {
                    _loc_4 = _loc_6.bkt != undefined ? (_loc_6.bkt) : (_loc_6.bucket);
                }
                if (_loc_6 && _loc_6.event_id != undefined)
                {
                    _loc_3 = _loc_6.event_id;
                }
                if (_loc_6 && _loc_6.area != undefined)
                {
                    _loc_5 = _loc_6.area;
                }
            }
            PingBack.getInstance().recommendClick4QiyuPing(_loc_2.albumID, _loc_3, _loc_4, _loc_5, _loc_2.seatID.toString(), _loc_2.playUrl, _loc_2.channel);
            navigateToURL(new URLRequest(_loc_2.playUrl), "_self");
            return;
        }// end function

        private function onSearchVideoClick(event:FeedbackEvent) : void
        {
            var _loc_2:* = SystemConfig.FEEDBACK_SEARCH_URL + encodeURIComponent(event.data.toString()) + "?source=bqxx";
            navigateToURL(new URLRequest(_loc_2), "_blank");
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:DisplayObject = null;
            if (this._searchPart && this._searchPart.parent)
            {
                this._searchPart.removeEventListener(FeedbackEvent.Evt_CopyrightSearchBtnClick, this.onSearchVideoClick);
                removeChild(this._searchPart);
                this._searchPart.destory();
                this._searchPart = null;
            }
            if (this._listPart && this._listPart.parent)
            {
                this._listPart.removeEventListener(FeedbackEvent.Evt_CopyrightRecItemClick, this.onEvtItemClick);
                removeChild(this._listPart);
                this._listPart.destory();
                this._listPart = null;
            }
            if (this._copyRightExpiredUI && this._copyRightExpiredUI.parent)
            {
                while (this._copyRightExpiredUI.numChildren > 0)
                {
                    
                    _loc_1 = this._copyRightExpiredUI.getChildAt(0);
                    this._copyRightExpiredUI.removeChild(_loc_1);
                    _loc_1 = null;
                }
                removeChild(this._copyRightExpiredUI);
                this._copyRightExpiredUI = null;
            }
            this._recommendJson = null;
            this._recommendVector = null;
            return;
        }// end function

    }
}
