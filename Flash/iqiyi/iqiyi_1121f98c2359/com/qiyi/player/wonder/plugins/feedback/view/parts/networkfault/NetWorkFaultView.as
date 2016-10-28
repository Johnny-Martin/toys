package com.qiyi.player.wonder.plugins.feedback.view.parts.networkfault
{
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import feedback.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class NetWorkFaultView extends Sprite implements IDestroy
    {
        private var _titleTF:TextField;
        private var _clientExtendTF:TextField;
        private var _downLoadBtn:DownLoadBtn;
        private var _downLoadTF:TextField;
        private var _refreshBtn:NetworkRefreshBtn;
        private var _refurbishTF:TextField;
        private var _helpBtn:NetworkHelpBtn;
        private var _helpTF:TextField;
        private var _describeTF:TextField;
        private var _errorcode:String = "";
        private var _errocodeTF:TextField;
        private var _isFeedBacked:Boolean;
        private static const TEXT_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.NETWORK_FAULT_VIEW_DES1);
        private static const TEXT_CLIENT_EXTEND:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.NETWORK_FAULT_VIEW_DES2);
        private static const TEXT_HELP_BTN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.NETWORK_FAULT_VIEW_DES3);
        private static const TEXT_REFURBISH_BTN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.NETWORK_FAULT_VIEW_DES4);
        private static const TEXT_DOWNLOAD_BTN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.NETWORK_FAULT_VIEW_DES5);
        private static const TEXT_DESCRIBE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.NETWORK_FAULT_VIEW_DES6);
        private static const STR_ERROR_CODE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.ERROR_CODE_DEFAULT_DES);
        private static const DEFAULT_FONT_COLOR:TextFormat = new TextFormat(null, 16, 16777215);
        private static const HOVER_FONT_COLOR:TextFormat = new TextFormat(null, 16, 6921984);

        public function NetWorkFaultView(param1:String)
        {
            this._errorcode = param1;
            this.initPanel();
            return;
        }// end function

        private function initPanel() : void
        {
            this._titleTF = FastCreator.createLabel(TEXT_TITLE, 16777215, 18);
            addChild(this._titleTF);
            this._clientExtendTF = FastCreator.createLabel(TEXT_CLIENT_EXTEND, 13421772, 14);
            addChild(this._clientExtendTF);
            this._downLoadBtn = new DownLoadBtn();
            addChild(this._downLoadBtn);
            this._downLoadTF = FastCreator.createLabel(TEXT_DOWNLOAD_BTN, 16777215, 16);
            var _loc_1:Boolean = false;
            this._downLoadTF.mouseEnabled = false;
            this._downLoadTF.selectable = _loc_1;
            addChild(this._downLoadTF);
            this._helpBtn = new NetworkHelpBtn();
            addChild(this._helpBtn);
            this._helpTF = FastCreator.createLabel(TEXT_HELP_BTN, 16777215, 16);
            var _loc_1:Boolean = false;
            this._helpTF.mouseEnabled = false;
            this._helpTF.selectable = _loc_1;
            addChild(this._helpTF);
            this._refreshBtn = new NetworkRefreshBtn();
            addChild(this._refreshBtn);
            this._refurbishTF = FastCreator.createLabel(TEXT_REFURBISH_BTN, 16777215, 16);
            var _loc_1:Boolean = false;
            this._refurbishTF.mouseEnabled = false;
            this._refurbishTF.selectable = _loc_1;
            addChild(this._refurbishTF);
            this._describeTF = FastCreator.createLabel(TEXT_DESCRIBE, 10066329, 12);
            addChild(this._describeTF);
            this._errocodeTF = FastCreator.createLabel(STR_ERROR_CODE + this._errorcode, 16777215, 14);
            addChild(this._errocodeTF);
            this._describeTF.visible = false;
            this._refreshBtn.addEventListener(MouseEvent.ROLL_OVER, this.onBtnRollOver);
            this._refreshBtn.addEventListener(MouseEvent.ROLL_OUT, this.onBtnRollOut);
            this._helpBtn.addEventListener(MouseEvent.ROLL_OVER, this.onBtnRollOver);
            this._helpBtn.addEventListener(MouseEvent.ROLL_OUT, this.onBtnRollOut);
            return;
        }// end function

        public function get downLoadBtn() : SimpleButton
        {
            return this._downLoadBtn;
        }// end function

        public function get isFeedBacked() : Boolean
        {
            return this._isFeedBacked;
        }// end function

        public function set isFeedBacked(param1:Boolean) : void
        {
            this._isFeedBacked = param1;
            return;
        }// end function

        public function get helpBtn() : SimpleButton
        {
            return this._helpBtn;
        }// end function

        public function get refreshBtn() : SimpleButton
        {
            return this._refreshBtn;
        }// end function

        public function get rejectMsg() : TextField
        {
            return this._describeTF;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            var _loc_3:Number = 0;
            _loc_3 = _loc_3 + (this._titleTF.height + 10);
            _loc_3 = _loc_3 + (this._clientExtendTF.height + 10);
            _loc_3 = _loc_3 + (this._downLoadBtn.height + 20);
            _loc_3 = _loc_3 + (this._helpBtn.height + 20);
            _loc_3 = _loc_3 + this._describeTF.height;
            this._titleTF.x = (param1 - this._titleTF.width) * 0.5;
            this._titleTF.y = (param2 - _loc_3) * 0.5;
            this._clientExtendTF.x = (param1 - this._clientExtendTF.width) * 0.5;
            this._clientExtendTF.y = this._titleTF.y + this._titleTF.height + 10;
            this._downLoadBtn.x = (param1 - this._downLoadBtn.width) * 0.5;
            this._downLoadBtn.y = this._clientExtendTF.y + this._clientExtendTF.height + 20;
            this._downLoadTF.x = this._downLoadBtn.x + 18;
            this._downLoadTF.y = this._downLoadBtn.y + (this._downLoadBtn.height - this._downLoadTF.height) * 0.5;
            this._helpBtn.x = (param1 - this._helpBtn.width - this._refreshBtn.width) * 0.5 - 25;
            this._helpBtn.y = this._downLoadBtn.y + this._downLoadBtn.height + 20;
            this._helpTF.x = this._helpBtn.x + 18;
            this._helpTF.y = this._helpBtn.y + (this._helpBtn.height - this._helpTF.height) * 0.5;
            this._refreshBtn.x = this._helpBtn.x + this._helpBtn.width + 50;
            this._refreshBtn.y = this._helpBtn.y;
            this._refurbishTF.x = this._refreshBtn.x + 18;
            this._refurbishTF.y = this._refreshBtn.y + (this._refreshBtn.height - this._refurbishTF.height) * 0.5;
            this._describeTF.x = (param1 - this._describeTF.width) * 0.5;
            this._describeTF.y = this._refreshBtn.y + this._refreshBtn.height + 10;
            this._errocodeTF.x = param1 - this._errocodeTF.width - 45;
            this._errocodeTF.y = param2 - 45;
            return;
        }// end function

        private function onBtnRollOver(event:MouseEvent) : void
        {
            switch(event.target)
            {
                case this._helpBtn:
                {
                    this._helpTF.defaultTextFormat = HOVER_FONT_COLOR;
                    this._helpTF.setTextFormat(HOVER_FONT_COLOR);
                    break;
                }
                case this._refreshBtn:
                {
                    this._refurbishTF.defaultTextFormat = HOVER_FONT_COLOR;
                    this._refurbishTF.setTextFormat(HOVER_FONT_COLOR);
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        private function onBtnRollOut(event:MouseEvent) : void
        {
            switch(event.target)
            {
                case this._helpBtn:
                {
                    this._helpTF.defaultTextFormat = DEFAULT_FONT_COLOR;
                    this._helpTF.setTextFormat(DEFAULT_FONT_COLOR);
                    break;
                }
                case this._refreshBtn:
                {
                    this._refurbishTF.defaultTextFormat = DEFAULT_FONT_COLOR;
                    this._refurbishTF.setTextFormat(DEFAULT_FONT_COLOR);
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return;
        }// end function

        public function destroy() : void
        {
            var _loc_1:DisplayObject = null;
            while (numChildren > 0)
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
