package com.sohu.tv.mediaplayer.ui
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;

    public class TvSohuErrorMsg extends Sprite
    {
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _bg:Sprite;
        private var _msg:String = "";
        private var _isPwd:Boolean = false;
        private var _owner:Object;
        private var _isSkin:Boolean = false;
        private var _pwdStr:String = "";
        private var pwdPanel:Object;
        private var errSp:Sprite;
        private var errorRecomm:Object;
        private var _isShowErrRecomm:Boolean = false;
        private var _errTimeout:Number = 0;
        private var _isErrRecommReady:Boolean = false;
        public static var MICROSOFT_YAHEI:String = "Microsoft YaHei";

        public function TvSohuErrorMsg(param1:Number, param2:Number, param3:String, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
        {
            this._owner = this;
            this._width = param1;
            this._msg = param3;
            this._isPwd = param5;
            this._isSkin = param4;
            this._height = this._isSkin ? (param2 - 32) : (param2);
            this._isShowErrRecomm = param6;
            setYaheiFont();
            this.init();
            return;
        }// end function

        private function init() : void
        {
            this.newFunc();
            this.drawSkin();
            this.addEvent();
            return;
        }// end function

        private function newFunc() : void
        {
            return;
        }// end function

        private function drawSkin() : void
        {
            var bitmapData:BitmapData;
            var bit:Bitmap;
            var _errSkin:errMark;
            var _errIco:MovieClip;
            var textArr:Array;
            var text1:TextField;
            var text2:TextField;
            var text3:TextField;
            this._bg = new Sprite();
            if (!this._isSkin)
            {
                bitmapData = new BitmapData(this._width, this._height, true, 4294967295);
                bitmapData.noise(0, 36, 83, 15, false);
                bit = new Bitmap(bitmapData);
                this._bg.addChildAt(bit, 0);
            }
            else
            {
                Utils.drawRect(this._bg, 0, 0, this._width, this._height, 0, 1);
            }
            this._owner.addChild(this._bg);
            var txt:* = this._msg == null || this._msg == "undefined" ? ("  ") : (this._msg);
            if (this._isPwd)
            {
                new LoaderUtil().load(10, function (param1:Object) : void
            {
                var tf:TextFormat;
                var obj:* = param1;
                if (obj.info == "success")
                {
                    pwdPanel = obj.data.content;
                    _owner.addChild(pwdPanel);
                    Utils.setCenterByNumber(pwdPanel, _width, _height);
                    pwdPanel.visible = true;
                    pwdPanel.pwd_txt.displayAsPassword = true;
                    pwdPanel.pwd_txt.maxChars = 25;
                    tf = new TextFormat();
                    tf.font = MICROSOFT_YAHEI;
                    pwdPanel.title_txt.setTextFormat(tf);
                    pwdPanel.pwd_txt.setTextFormat(tf);
                    pwdPanel.tip_txt.setTextFormat(tf);
                    pwdPanel.err_txt.setTextFormat(tf);
                    pwdPanel.pwd_txt.addEventListener(MouseEvent.CLICK, function (param1) : void
                {
                    pwdPanel.tip_txt.text = "";
                    return;
                }// end function
                );
                    pwdPanel.ok_btn.addEventListener(MouseEvent.MOUSE_UP, function (param1) : void
                {
                    _pwdStr = escape(Utils.cleanVar(pwdPanel.pwd_txt.text));
                    dispatchEvent(new Event("loadAndPlay"));
                    var _loc_2:String = "";
                    pwdPanel.err_txt.text = "";
                    pwdPanel.pwd_txt.text = _loc_2;
                    return;
                }// end function
                );
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/PwdPanel.swf");
            }
            else
            {
                this.errSp = new Sprite();
                _errSkin = new errMark();
                _errIco = _errSkin.errIco;
                this.errSp.addChild(_errIco);
                textArr = txt.split("|");
                text1 = new TextField();
                if (textArr.length > 1)
                {
                    text1 = this.setFont(textArr[0], 24, 16777215, 500, 35, TextFormatAlign.CENTER);
                    text2 = this.setFont(textArr[1], 14, 15066597, 500, 25, TextFormatAlign.CENTER);
                    text3 = this.setFont(textArr[2], 14, 15066597, 500, 25, TextFormatAlign.CENTER);
                    this.errSp.addChild(text1);
                    this.errSp.addChild(text2);
                    this.errSp.addChild(text3);
                    text3.addEventListener(TextEvent.LINK, this.linkHandler);
                    text1.x = _errIco.width + 12;
                    var _loc_2:* = (_errIco.width + 12) / 2;
                    text3.x = (_errIco.width + 12) / 2;
                    text2.x = _loc_2;
                    if (text2.text == "")
                    {
                        text3.y = text1.y + text1.textHeight + 4;
                    }
                    else
                    {
                        text2.y = text1.y + text1.textHeight + 4;
                        text3.y = text2.y + text2.textHeight - 6;
                    }
                }
                else
                {
                    if (txt.length > 20)
                    {
                        txt = txt.substring(0, 20);
                    }
                    text1 = this.setFont(txt, 24, 16777215, 500, 35, TextFormatAlign.CENTER);
                    this.errSp.addChild(text1);
                    text1.x = _errIco.width + 12;
                }
                _errIco.x = text1.x + (text1.width - text1.textWidth) / 2 - _errIco.width - 12;
                text1.y = Math.round(_errIco.y + (_errIco.height - text1.textHeight) / 2);
                this._owner.addChild(this.errSp);
            }
            if (this._isShowErrRecomm)
            {
                this.showErrRecomm();
            }
            this.setEleStatus();
            return;
        }// end function

        private function setFont(param1:String, param2:Number = 14, param3:uint = 16777215, param4:Number = 0, param5:Number = 0, param6:String = "center") : TextField
        {
            var _loc_7:* = new TextField();
            var _loc_8:* = new TextFormat();
            new TextFormat().size = param2;
            _loc_8.leading = 6;
            _loc_7.wordWrap = true;
            _loc_8.font = MICROSOFT_YAHEI;
            _loc_8.align = param6;
            _loc_7.textColor = param3;
            _loc_7.htmlText = param1;
            _loc_7.width = param4;
            _loc_7.height = param5;
            _loc_7.setTextFormat(_loc_8);
            return _loc_7;
        }// end function

        private function addEvent() : void
        {
            return;
        }// end function

        private function linkHandler(event:TextEvent) : void
        {
            ErrorSenderPQ.getInstance().sendFeedback();
            return;
        }// end function

        private function showErrRecomm() : void
        {
            new LoaderUtil().load(10, function (param1:Object) : void
            {
                var obj:* = param1;
                if (obj.info == "success")
                {
                    errorRecomm = obj.data.content;
                    _owner.addChild(errorRecomm);
                    errorRecomm.init(_width, _height);
                    errorRecomm.addEventListener("INIT_COMPLETE", function (event:Event) : void
                {
                    var _time:Number;
                    var evt:* = event;
                    _isErrRecommReady = true;
                    clearTimeout(_errTimeout);
                    setEleStatus();
                    _time = setTimeout(function () : void
                    {
                        clearTimeout(_time);
                        dispatchEvent(new Event("resizeErrorRecomm"));
                        return;
                    }// end function
                    , 500);
                    return;
                }// end function
                );
                    _errTimeout = setTimeout(function () : void
                {
                    clearTimeout(_errTimeout);
                    _owner.removeChild(errorRecomm);
                    errorRecomm = null;
                    setEleStatus();
                    return;
                }// end function
                , 1000 * 7);
                    SendRef.getInstance().sendPQVPC("PL_A_503_V");
                    try
                    {
                        VerLog.msg(errorRecomm["version"]);
                    }
                    catch (evt:Error)
                    {
                    }
                }
                return;
            }// end function
            , null, PlayerConfig.swfHost + "panel/ErrorRecommend.swf");
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            this._width = param1;
            this._height = this._isSkin ? (param2 - 32) : (param2);
            this.changeBg();
            this.setEleStatus();
            return;
        }// end function

        private function changeBg() : void
        {
            var _loc_1:BitmapData = null;
            var _loc_2:Bitmap = null;
            if (!this._isSkin)
            {
                while (this._bg.numChildren)
                {
                    
                    this._bg.removeChildAt(0);
                }
                if (this._width > 0 && this._height > 0)
                {
                    _loc_1 = new BitmapData(this._width, this._height, true, 4294967295);
                    _loc_1.noise(0, 36, 83, 15, false);
                    _loc_2 = new Bitmap(_loc_1);
                    this._bg.addChildAt(_loc_2, 0);
                }
            }
            else
            {
                this._bg.width = this._width;
                this._bg.height = this._height;
            }
            return;
        }// end function

        private function setEleStatus() : void
        {
            if (this._isPwd && this.pwdPanel != null)
            {
                if (this._height > this.pwdPanel.height && PlayerConfig.cooperator != "imovie")
                {
                    if (this.errorRecomm != null && this._isErrRecommReady)
                    {
                        this.errorRecomm.resize(this._width, this._height - this.pwdPanel.height);
                        Utils.setCenter(this.errorRecomm, this._bg);
                        Utils.setCenterByNumber(this.pwdPanel, this._width, this._height - this.errorRecomm.height);
                        this.errorRecomm.y = this.pwdPanel.height + this.pwdPanel.y;
                        this.errorRecomm.visible = true;
                    }
                    else
                    {
                        Utils.setCenterByNumber(this.pwdPanel, this._width, this._height);
                    }
                }
                else
                {
                    Utils.setCenterByNumber(this.pwdPanel, this._width, this._height);
                    if (this.errorRecomm != null)
                    {
                        this.errorRecomm.visible = false;
                    }
                }
                this.pwdPanel.visible = true;
            }
            else if (this.errSp != null)
            {
                if (this._height > this.errSp.height && PlayerConfig.cooperator != "imovie")
                {
                    if (this.errorRecomm != null && this._isErrRecommReady)
                    {
                        this.errorRecomm.resize(this._width, this._height - this.errSp.height);
                        Utils.setCenter(this.errorRecomm, this._bg);
                        Utils.setCenterByNumber(this.errSp, this._width, this._height - this.errorRecomm.height);
                        this.errorRecomm.y = this.errSp.height + this.errSp.y;
                        this.errorRecomm.visible = true;
                    }
                    else
                    {
                        Utils.setCenterByNumber(this.errSp, this._width, this._height);
                    }
                }
                else
                {
                    Utils.setCenterByNumber(this.errSp, this._width, this._height);
                    if (this.errorRecomm != null)
                    {
                        this.errorRecomm.visible = false;
                    }
                }
            }
            return;
        }// end function

        public function updateInfo(param1:String) : void
        {
            this._msg = param1;
            if (this._isPwd && this.pwdPanel != null)
            {
                this.pwdPanel.err_txt.text = this._msg;
            }
            return;
        }// end function

        public function get pwdStr() : String
        {
            return this._pwdStr;
        }// end function

        public static function setYaheiFont() : void
        {
            var _loc_1:* = new TextField();
            _loc_1.defaultTextFormat = new TextFormat("Microsoft YaHei", 12, 16777215);
            _loc_1.text = "雅黑";
            var _loc_2:* = new TextField();
            _loc_2.defaultTextFormat = new TextFormat("宋体", 12, 16777215);
            _loc_2.text = "雅黑";
            if (_loc_1.textHeight == _loc_2.textHeight)
            {
                MICROSOFT_YAHEI = "微软雅黑";
            }
            return;
        }// end function

    }
}
