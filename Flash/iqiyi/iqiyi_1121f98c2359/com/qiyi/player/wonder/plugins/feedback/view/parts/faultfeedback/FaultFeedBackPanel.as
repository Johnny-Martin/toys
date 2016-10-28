package com.qiyi.player.wonder.plugins.feedback.view.parts.faultfeedback
{
    import com.adobe.serialization.json.*;
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.tooltip.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.feedback.*;
    import com.qiyi.player.wonder.plugins.feedback.model.*;
    import com.qiyi.player.wonder.plugins.feedback.view.*;
    import common.*;
    import feedback.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import gs.*;

    public class FaultFeedBackPanel extends Sprite implements IDestroy
    {
        private var _bgShape:Shape;
        private var _normalScreenBtn:CommonNormalScreenBtn;
        private var _feedPanel:FeedPanelUI;
        private var _feedSuccPanel:FeedSuccessPanelUI;
        private var _titleTF:TextField;
        private var _describeTF_1:TextField;
        private var _helpLinkTF:TextField;
        private var _questionInputTF:TextField;
        private var _phoneTF:TextField;
        private var _phoneInputTF:TextField;
        private var _mailTF:TextField;
        private var _mailInputTF:TextField;
        private var _areaTF:TextField;
        private var _areaParamTF:TextField;
        private var _ipTF:TextField;
        private var _ipParamTF:TextField;
        private var _operatorsTF:TextField;
        private var _operatorsParamTF:TextField;
        private var _describeTF_2:TextField;
        private var _countryTF:TextField;
        private var _countryInputTF:TextField;
        private var _provinceTF:TextField;
        private var _provinceInputTF:TextField;
        private var _countyTF:TextField;
        private var _countyInputTF:TextField;
        private var _operatorsInputTF:TextField;
        private var _faultTF:TextField;
        private var _submitBtn:SimpleBtn;
        private var _returnBtn:SimpleBtn;
        private var _succTitleTF:TextField;
        private var _succDescribeTF:TextField;
        private var _succReturnBtn:SimpleBtn;
        private var _isCanFeedBack:Boolean = true;
        private var _loader:URLLoader;
        private static const TEXT_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES1);
        private static const TEXT_DESCRIBE_1:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES2);
        private static const TEXT_LINK:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES3);
        private static const TEXT_QUESTION_INPUT:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES4);
        private static const TEXT_DESCRIBE_2:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES5);
        private static const TEXT_SUCC_TITLE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES6);
        private static const TEXT_SUCC_DESCRIBE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES7);

        public function FaultFeedBackPanel()
        {
            this._normalScreenBtn = new CommonNormalScreenBtn();
            ToolTip.getInstance().registerComponent(this._normalScreenBtn, LocalizationManager.instance.getLanguageStringByName(LocalizationDef.TOOL_TIP_NORMAL_SCREEN_BTN));
            this._normalScreenBtn.addEventListener(MouseEvent.CLICK, this.onNormalScreenBtnClick);
            addChild(this._normalScreenBtn);
            if (FeedbackInfo.instance.entry == "")
            {
                return;
            }
            this.initPanel();
            if (FeedbackInfo.instance.userInfo == null)
            {
                this.requestLocation();
            }
            return;
        }// end function

        private function requestLocation() : void
        {
            var _loc_1:* = new URLLoader();
            _loc_1.addEventListener(Event.COMPLETE, this.onLoaderLocationComplete);
            _loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
            _loc_1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            _loc_1.load(new URLRequest(FeedbackDef.FEEDBACK_GET_LOCATION_URL));
            return;
        }// end function

        private function onLoaderLocationComplete(event:Event) : void
        {
            var _loc_3:String = null;
            var _loc_4:Object = null;
            var _loc_2:* = event.target as URLLoader;
            try
            {
                _loc_3 = _loc_2.data.toString() as String;
                _loc_3 = _loc_3.split("=")[1];
                _loc_4 = JSON.decode(_loc_3, false);
                FeedbackInfo.instance.userInfo = _loc_4;
                this._areaParamTF.text = FeedbackInfo.instance.country;
                this._ipParamTF.text = FeedbackInfo.instance.ip;
                this._operatorsParamTF.text = FeedbackInfo.instance.isp;
            }
            catch (e:Error)
            {
            }
            _loc_2.removeEventListener(Event.COMPLETE, this.onLoaderLocationComplete);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            _loc_2 = null;
            return;
        }// end function

        private function onError(event:Event) : void
        {
            var _loc_2:* = event.target as URLLoader;
            _loc_2.removeEventListener(Event.COMPLETE, this.onLoaderLocationComplete);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            _loc_2 = null;
            return;
        }// end function

        private function initPanel() : void
        {
            if (this._bgShape == null)
            {
                this._bgShape = new Shape();
                this._bgShape.graphics.beginFill(0);
                this._bgShape.graphics.drawRect(0, 0, GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                this._bgShape.graphics.endFill();
                this.addChild(this._bgShape);
            }
            if (this._feedPanel == null)
            {
                this._feedPanel = new FeedPanelUI();
                this._feedPanel.visible = true;
                this.addChild(this._feedPanel);
                this.initFeedPanel();
            }
            if (this._feedSuccPanel == null)
            {
                this._feedSuccPanel = new FeedSuccessPanelUI();
                this._feedSuccPanel.visible = false;
                this.addChild(this._feedSuccPanel);
                this.initFeedSuccPanel();
            }
            this._submitBtn.addEventListener(MouseEvent.CLICK, this.onSubmitClick);
            this._returnBtn.addEventListener(MouseEvent.CLICK, this.onBackBtnClick);
            this._succReturnBtn.addEventListener(MouseEvent.CLICK, this.onBackBtnClick);
            this._helpLinkTF.addEventListener(TextEvent.LINK, this.onHelpLinkClick);
            this._countryInputTF.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._countyInputTF.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._provinceInputTF.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._operatorsInputTF.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._questionInputTF.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._mailInputTF.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._phoneInputTF.addEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            return;
        }// end function

        private function initFeedPanel() : void
        {
            this._titleTF = FastCreator.createLabel(TEXT_TITLE, 16777215, 18);
            this._titleTF.x = (this._feedPanel.width - this._titleTF.width) / 2;
            this._feedPanel.addChild(this._titleTF);
            this._describeTF_1 = FastCreator.createLabel(TEXT_DESCRIBE_1, 16777215, 14);
            this._describeTF_1.x = 0;
            this._describeTF_1.y = 40;
            this._feedPanel.addChild(this._describeTF_1);
            this._helpLinkTF = FastCreator.createLabel(TEXT_LINK, 16777215);
            this._helpLinkTF.y = 40;
            this._helpLinkTF.x = 410;
            this._feedPanel.addChild(this._helpLinkTF);
            this._questionInputTF = FastCreator.createInput(TEXT_QUESTION_INPUT, 4276545);
            this._questionInputTF.y = 66;
            this._questionInputTF.x = 3;
            this._questionInputTF.width = this._feedPanel.width - 6;
            this._questionInputTF.height = 160;
            this._questionInputTF.multiline = true;
            this._questionInputTF.maxChars = FeedbackDef.FEEDBACK_RESUBMIT_INPUT_MAXCHAR;
            this._feedPanel.addChild(this._questionInputTF);
            this._phoneTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES8), 16777215, 14);
            this._phoneTF.y = 240;
            this._phoneTF.x = 0;
            this._feedPanel.addChild(this._phoneTF);
            this._phoneInputTF = FastCreator.createInput("", 3355443, 14);
            this._phoneInputTF.x = 50;
            this._phoneInputTF.y = 240;
            this._phoneInputTF.width = 180;
            this._phoneInputTF.height = 22;
            this._phoneInputTF.maxChars = 11;
            this._phoneInputTF.multiline = false;
            this._feedPanel.addChild(this._phoneInputTF);
            this._mailTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES9), 16777215, 14);
            this._mailTF.x = 266;
            this._mailTF.y = 240;
            this._feedPanel.addChild(this._mailTF);
            this._mailInputTF = FastCreator.createInput("", 3355443, 14);
            this._mailInputTF.x = 317;
            this._mailInputTF.y = 240;
            this._mailInputTF.width = 180;
            this._mailInputTF.height = 22;
            this._mailInputTF.multiline = false;
            this._feedPanel.addChild(this._mailInputTF);
            this._areaTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES10), 13290186);
            this._areaTF.x = 0;
            this._areaTF.y = 268;
            this._feedPanel.addChild(this._areaTF);
            this._areaParamTF = FastCreator.createLabel("", 13290186);
            this._areaParamTF.x = 34;
            this._areaParamTF.y = 268;
            this._areaParamTF.width = 70;
            this._areaParamTF.multiline = false;
            this._areaParamTF.text = FeedbackInfo.instance.country;
            this._feedPanel.addChild(this._areaParamTF);
            this._ipTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES11), 13290186);
            this._ipTF.x = 112;
            this._ipTF.y = 268;
            this._feedPanel.addChild(this._ipTF);
            this._ipParamTF = FastCreator.createLabel("", 13290186);
            this._ipParamTF.x = 142;
            this._ipParamTF.y = 268;
            this._ipParamTF.width = 70;
            this._ipParamTF.multiline = false;
            this._ipParamTF.text = FeedbackInfo.instance.ip;
            this._feedPanel.addChild(this._ipParamTF);
            this._operatorsTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES12), 13290186);
            this._operatorsTF.x = 244;
            this._operatorsTF.y = 268;
            this._feedPanel.addChild(this._operatorsTF);
            this._operatorsParamTF = FastCreator.createLabel("", 13290186);
            this._operatorsParamTF.x = 288;
            this._operatorsParamTF.y = 268;
            this._operatorsParamTF.width = 130;
            this._operatorsParamTF.multiline = false;
            this._operatorsParamTF.text = FeedbackInfo.instance.isp;
            this._feedPanel.addChild(this._operatorsParamTF);
            this._describeTF_2 = FastCreator.createLabel(TEXT_DESCRIBE_2, 13290186);
            this._describeTF_2.y = 288;
            this._describeTF_2.x = 0;
            this._feedPanel.addChild(this._describeTF_2);
            this._countryTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES13), 13290186);
            this._countryTF.x = 60;
            this._countryTF.y = 313;
            this._feedPanel.addChild(this._countryTF);
            this._countryInputTF = FastCreator.createInput(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES14), 3355443);
            this._countryInputTF.x = 2;
            this._countryInputTF.y = 315;
            this._countryInputTF.width = 54;
            this._countryInputTF.multiline = false;
            this._feedPanel.addChild(this._countryInputTF);
            this._provinceTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES15), 13290186);
            this._provinceTF.x = 178;
            this._provinceTF.y = 313;
            this._feedPanel.addChild(this._provinceTF);
            this._provinceInputTF = FastCreator.createInput(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES16), 3355443);
            this._provinceInputTF.x = 120;
            this._provinceInputTF.y = 315;
            this._provinceInputTF.width = 54;
            this._provinceInputTF.multiline = false;
            this._feedPanel.addChild(this._provinceInputTF);
            this._countyTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES17), 13290186);
            this._countyTF.x = 258;
            this._countyTF.y = 313;
            this._feedPanel.addChild(this._countyTF);
            this._countyInputTF = FastCreator.createInput(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES18), 3355443);
            this._countyInputTF.x = 200;
            this._countyInputTF.y = 315;
            this._countyInputTF.width = 54;
            this._countyInputTF.multiline = false;
            this._feedPanel.addChild(this._countyInputTF);
            this._operatorsInputTF = FastCreator.createInput(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES19), 3355443);
            this._operatorsInputTF.x = 315;
            this._operatorsInputTF.y = 315;
            this._operatorsInputTF.width = 64;
            this._operatorsInputTF.multiline = false;
            this._feedPanel.addChild(this._operatorsInputTF);
            this._faultTF = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES20), 10027008, 14);
            this._faultTF.x = 230;
            this._faultTF.y = 358;
            this._faultTF.visible = false;
            this._feedPanel.addChild(this._faultTF);
            this._submitBtn = new SimpleBtn(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES21));
            this._submitBtn.x = this._feedPanel.width / 4 - this._submitBtn.width / 2;
            this._submitBtn.y = 358;
            this._feedPanel.addChild(this._submitBtn);
            this._returnBtn = new SimpleBtn(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES22));
            this._returnBtn.x = this._feedPanel.width / 4 * 3 - this._returnBtn.width / 2;
            this._returnBtn.y = 358;
            this._feedPanel.addChild(this._returnBtn);
            return;
        }// end function

        private function initFeedSuccPanel() : void
        {
            this._succTitleTF = FastCreator.createLabel(TEXT_SUCC_TITLE, 16777215, 18);
            this._succTitleTF.x = (this._feedPanel.width - this._succTitleTF.width) / 2;
            this._succTitleTF.y = 103;
            this._feedSuccPanel.addChild(this._succTitleTF);
            this._succDescribeTF = FastCreator.createLabel(TEXT_SUCC_DESCRIBE, 16777215, 14);
            this._succDescribeTF.x = (this._feedPanel.width - this._succDescribeTF.width) / 2;
            this._succDescribeTF.y = 168;
            this._feedSuccPanel.addChild(this._succDescribeTF);
            this._succReturnBtn = new SimpleBtn(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES23));
            this._succReturnBtn.x = this._feedPanel.width / 2 - this._returnBtn.width / 2;
            this._succReturnBtn.y = 244;
            this._feedSuccPanel.addChild(this._succReturnBtn);
            return;
        }// end function

        private function onSubmitClick(event:MouseEvent) : void
        {
            this._submitBtn.removeEventListener(MouseEvent.CLICK, this.onSubmitClick);
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            while (_loc_3 < this._questionInputTF.text.length)
            {
                
                if (this._questionInputTF.text.charAt(_loc_3) == " ")
                {
                    _loc_2++;
                }
                _loc_3++;
            }
            if (this._isCanFeedBack)
            {
                this._isCanFeedBack = false;
                this.requestTicket();
            }
            return;
        }// end function

        private function getVariables() : URLVariables
        {
            var _loc_1:* = new URLVariables();
            _loc_1.ticket = FeedbackInfo.instance.ticket;
            _loc_1.email = this._mailInputTF.text;
            if (this._questionInputTF.text == TEXT_QUESTION_INPUT)
            {
                _loc_1.content = "";
            }
            else
            {
                _loc_1.content = this._questionInputTF.text;
            }
            _loc_1.entry_class = FeedbackDef.FEEDBACK_RESUBMIT_ENTRY_CLASS;
            _loc_1.phone = this._phoneInputTF.text;
            _loc_1.fb_class = FeedbackDef.FEEDBACK_RESUBMIT_FB_CLASS;
            _loc_1.uplevel_url = "";
            _loc_1.v_id = FeedbackInfo.instance.vid;
            _loc_1.v_title = FeedbackInfo.instance.title;
            _loc_1.flash_sound = FeedbackInfo.instance.volume;
            _loc_1.flash_version = Capabilities.version;
            _loc_1.record = "";
            _loc_1.speed_test = "0@0@0@0@0@ @ @ @" + FeedbackInfo.instance.logCookie;
            _loc_1.login_email = "";
            _loc_1.city = FeedbackInfo.instance.city;
            _loc_1.country = FeedbackInfo.instance.country;
            _loc_1.isp = FeedbackInfo.instance.isp;
            _loc_1.province = "";
            _loc_1.player_version = FeedbackInfo.instance.playerVersion;
            _loc_1.category_id = FeedbackInfo.instance.channelId;
            if (this._countyInputTF.text != LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES18))
            {
                _loc_1.input_city = this._countyInputTF.text;
            }
            if (this._operatorsInputTF.text != LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES19))
            {
                _loc_1.input_isp = this._operatorsInputTF.text;
            }
            if (this._provinceInputTF.text != LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES16))
            {
                _loc_1.input_province = this._provinceInputTF.text;
            }
            return _loc_1;
        }// end function

        private function onNormalScreenBtnClick(event:MouseEvent) : void
        {
            this._normalScreenBtn.visible = false;
            GlobalStage.setNormalScreen();
            return;
        }// end function

        private function onBackBtnClick(event:MouseEvent) : void
        {
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_FaultFeedbackReturn));
            return;
        }// end function

        private function onHelpLinkClick(event:TextEvent) : void
        {
            GlobalStage.setNormalScreen();
            navigateToURL(new URLRequest(FeedbackDef.FEEDBACK_HELP_URL), "_blank");
            return;
        }// end function

        private function onInputTextFocusIn(event:FocusEvent) : void
        {
            switch(event.target)
            {
                case this._countryInputTF:
                {
                    if (this._countryInputTF.text == LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES14))
                    {
                        event.target.text = "";
                    }
                    break;
                }
                case this._provinceInputTF:
                {
                    if (this._provinceInputTF.text == LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES16))
                    {
                        event.target.text = "";
                    }
                    break;
                }
                case this._countyInputTF:
                {
                    if (this._countyInputTF.text == LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES18))
                    {
                        event.target.text = "";
                    }
                    break;
                }
                case this._operatorsInputTF:
                {
                    if (this._operatorsInputTF.text == LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES19))
                    {
                        event.target.text = "";
                    }
                    break;
                }
                case this._questionInputTF:
                {
                    if (this._questionInputTF.text == TEXT_QUESTION_INPUT)
                    {
                        event.target.text = "";
                    }
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            event.target.addEventListener(FocusEvent.FOCUS_OUT, this.onInputTextFocusOut);
            return;
        }// end function

        private function onInputTextFocusOut(event:FocusEvent) : void
        {
            event.target.removeEventListener(FocusEvent.FOCUS_OUT, this.onInputTextFocusOut);
            if (event.target.text != "")
            {
                return;
            }
            switch(event.target)
            {
                case this._countryInputTF:
                {
                    this._countryInputTF.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES14);
                    break;
                }
                case this._provinceInputTF:
                {
                    this._provinceInputTF.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES16);
                    break;
                }
                case this._countyInputTF:
                {
                    this._countyInputTF.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES18);
                    break;
                }
                case this._operatorsInputTF:
                {
                    this._operatorsInputTF.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.FAULT_FEED_BACK_PANEL_DES19);
                    break;
                }
                case this._questionInputTF:
                {
                    this._questionInputTF.text = TEXT_QUESTION_INPUT;
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

        public function onResize(param1:uint, param2:uint) : void
        {
            if (this._bgShape)
            {
                this._bgShape.width = param1;
                this._bgShape.height = param2;
            }
            if (this._feedPanel)
            {
                this._feedPanel.x = (param1 - this._feedPanel.width) / 2;
                this._feedPanel.y = (param2 - this._feedPanel.height) / 2;
            }
            if (this._feedSuccPanel)
            {
                this._feedSuccPanel.x = (param1 - this._feedSuccPanel.width) / 2;
                this._feedSuccPanel.y = (param2 - this._feedSuccPanel.height) / 2;
            }
            if (GlobalStage.isFullScreen())
            {
                this._normalScreenBtn.visible = true;
                this._normalScreenBtn.x = param1 - this._normalScreenBtn.width - 2;
                this._normalScreenBtn.y = 8;
            }
            else
            {
                this._normalScreenBtn.visible = false;
            }
            return;
        }// end function

        private function requestTicket() : void
        {
            var _loc_1:* = new URLLoader();
            _loc_1.addEventListener(Event.COMPLETE, this.onLoaderTicketComplete);
            _loc_1.addEventListener(IOErrorEvent.IO_ERROR, this.onUploadError);
            _loc_1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUploadError);
            _loc_1.load(new URLRequest(FeedbackDef.FEEDBACK_GET_TICKET_URL + "?n=" + Math.random()));
            return;
        }// end function

        private function onLoaderTicketComplete(event:Event) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = event.target as URLLoader;
            try
            {
                _loc_3 = _loc_2.data.toString() as String;
                FeedbackInfo.instance.ticket = _loc_3;
                this.requestUploadError();
            }
            catch (e:Error)
            {
            }
            _loc_2.removeEventListener(Event.COMPLETE, this.onLoaderTicketComplete);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onUploadError);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUploadError);
            _loc_2 = null;
            return;
        }// end function

        private function requestUploadError() : void
        {
            var _loc_1:* = new URLRequest(FeedbackDef.FEEDBACK_FEED_BACK_URL);
            try
            {
                _loc_1.method = URLRequestMethod.POST;
                _loc_1.data = this.getVariables();
            }
            catch (e:Error)
            {
            }
            var _loc_2:* = new URLLoader();
            _loc_2.addEventListener(Event.COMPLETE, this.onUploadErrorComplete);
            _loc_2.addEventListener(IOErrorEvent.IO_ERROR, this.onUploadError);
            _loc_2.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUploadError);
            _loc_2.load(_loc_1);
            return;
        }// end function

        private function onUploadErrorComplete(event:Event) : void
        {
            this._isCanFeedBack = false;
            this._feedPanel.visible = false;
            this._feedSuccPanel.visible = true;
            dispatchEvent(new FeedbackEvent(FeedbackEvent.Evt_FaultFeedBackSuccess));
            var _loc_2:* = event.target as URLLoader;
            _loc_2.removeEventListener(Event.COMPLETE, this.onUploadErrorComplete);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onUploadError);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUploadError);
            _loc_2 = null;
            return;
        }// end function

        private function onUploadError(event:Event) : void
        {
            this._isCanFeedBack = true;
            if (this._faultTF)
            {
                this._faultTF.visible = true;
                TweenLite.killTweensOf(this.removeFailText);
                TweenLite.delayedCall(5, this.removeFailText);
            }
            var _loc_2:* = event.target as URLLoader;
            _loc_2.removeEventListener(Event.COMPLETE, this.onLoaderTicketComplete);
            _loc_2.removeEventListener(Event.COMPLETE, this.onUploadErrorComplete);
            _loc_2.removeEventListener(IOErrorEvent.IO_ERROR, this.onUploadError);
            _loc_2.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUploadError);
            return;
        }// end function

        private function removeFailText() : void
        {
            if (this._feedPanel == null)
            {
                return;
            }
            if (this._faultTF)
            {
                this._faultTF.visible = false;
            }
            if (this._submitBtn)
            {
                this._submitBtn.addEventListener(MouseEvent.CLICK, this.onSubmitClick);
            }
            return;
        }// end function

        public function destroy() : void
        {
            this._submitBtn.removeEventListener(MouseEvent.CLICK, this.onSubmitClick);
            this._returnBtn.removeEventListener(MouseEvent.CLICK, this.onBackBtnClick);
            this._succReturnBtn.removeEventListener(MouseEvent.CLICK, this.onBackBtnClick);
            this._helpLinkTF.removeEventListener(TextEvent.LINK, this.onHelpLinkClick);
            this._normalScreenBtn.removeEventListener(MouseEvent.CLICK, this.onNormalScreenBtnClick);
            this._countryInputTF.removeEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._countyInputTF.removeEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._provinceInputTF.removeEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._operatorsInputTF.removeEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._questionInputTF.removeEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._mailInputTF.removeEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            this._phoneInputTF.removeEventListener(FocusEvent.FOCUS_IN, this.onInputTextFocusIn);
            removeChild(this._normalScreenBtn);
            this._normalScreenBtn = null;
            if (this._bgShape && this._bgShape.parent)
            {
                this._bgShape.graphics.clear();
                removeChild(this._bgShape);
                this._bgShape = null;
            }
            if (this._feedPanel && this._feedPanel.parent)
            {
                removeChild(this._feedPanel);
                FastCreator.removeAllChild(this._feedPanel);
                this._feedPanel = null;
            }
            if (this._feedSuccPanel && this._feedSuccPanel.parent)
            {
                removeChild(this._feedSuccPanel);
                FastCreator.removeAllChild(this._feedSuccPanel);
                this._feedSuccPanel = null;
            }
            return;
        }// end function

    }
}
