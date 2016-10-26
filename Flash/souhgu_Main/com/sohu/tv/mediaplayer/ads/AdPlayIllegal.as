package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class AdPlayIllegal extends Sprite
    {
        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _bg:Sprite;
        private var _msg:String = "";
        private var _limit:TextField;
        private var _tf:TextFormat;
        private var errSp:Sprite;
        public static var MICROSOFT_YAHEI:String = "Microsoft YaHei";

        public function AdPlayIllegal(param1:Number, param2:Number, param3:String)
        {
            this._width = param1;
            this._height = param2;
            this._msg = param3;
            setYaheiFont();
            this.init();
            return;
        }// end function

        private function init() : void
        {
            this.drawSkin();
            return;
        }// end function

        private function drawSkin() : void
        {
            this._bg = new Sprite();
            Utils.drawRect(this._bg, 0, 0, this._width, this._height, 0, 1);
            addChild(this._bg);
            this.errSp = new Sprite();
            var _loc_1:* = new errMark();
            var _loc_2:* = _loc_1.errIco;
            this.errSp.addChild(_loc_2);
            var _loc_3:* = this._msg.split("|");
            var _loc_4:* = this.setFont(_loc_3[0], 24, 16777215, 500, 35, TextFormatAlign.CENTER);
            var _loc_5:* = this.setFont(_loc_3[1], 14, 15066597, 500, 25, TextFormatAlign.CENTER);
            var _loc_6:* = this.setFont(_loc_3[2], 14, 15066597, 500, 25, TextFormatAlign.CENTER);
            this.errSp.addChild(_loc_4);
            this.errSp.addChild(_loc_5);
            this.errSp.addChild(_loc_6);
            _loc_5.addEventListener(TextEvent.LINK, this.linkHandler);
            _loc_4.x = _loc_2.width + 12;
            var _loc_7:* = (_loc_2.width + 12) / 2;
            _loc_6.x = (_loc_2.width + 12) / 2;
            _loc_5.x = _loc_7;
            _loc_5.y = _loc_4.y + _loc_4.textHeight + 14;
            _loc_6.y = _loc_5.y + _loc_5.textHeight;
            _loc_2.x = _loc_4.x + (_loc_4.width - _loc_4.textWidth) / 2 - _loc_2.width - 12;
            _loc_4.y = Math.round(_loc_2.y + (_loc_2.height - _loc_4.textHeight) / 2);
            addChild(this.errSp);
            Utils.setCenter(this.errSp, this._bg);
            return;
        }// end function

        private function setFont(param1:String, param2:Number = 14, param3:uint = 16777215, param4:Number = 0, param5:Number = 0, param6:String = "center") : TextField
        {
            var _loc_7:* = new TextField();
            var _loc_8:* = new TextFormat();
            new TextFormat().size = param2;
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

        private function linkHandler(event:TextEvent) : void
        {
            switch(event.text)
            {
                case "1":
                {
                    ErrorSenderPQ.getInstance().sendFeedback();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            this._width = param1;
            this._height = param2;
            this._bg.width = this._width;
            this._bg.height = this._height;
            Utils.setCenter(this.errSp, this._bg);
            return;
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
