package com.sohu.tv.mediaplayer.ui
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import com.sohu.tv.mediaplayer.ads.*;
    import ebing.*;
    import ebing.utils.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;

    public class LogsPanel extends Sprite
    {
        private var _mainLogsText:TextField;
        private var _adLogsText:TextField;
        private var _p2pLogsText:TextField;
        private var _bg:Sprite;
        private var _copyLogs_btn:CustomButton;
        private var _mailTo_btn:CustomButton;
        protected var _owner:Object;
        protected var _isOpen:Boolean = false;
        private var _closeBtnUp:Sprite;
        private var _closeBtnOver:Sprite;
        private var _close_btn:Sprite;
        private var _mainLogs_btn:CustomButton;
        private var _adLogs_btn:CustomButton;
        private var _p2pLogs_btn:CustomButton;

        public function LogsPanel(param1:Number, param2:Number)
        {
            this._copyLogs_btn = new CustomButton("复制全部log");
            this._mailTo_btn = new CustomButton("MailTo:TECH");
            this._mainLogs_btn = new CustomButton("主播放器");
            this._adLogs_btn = new CustomButton("广告");
            this._p2pLogs_btn = new CustomButton("P2P");
            this._mainLogsText = new TextField();
            this._adLogsText = new TextField();
            this._p2pLogsText = new TextField();
            this._bg = new Sprite();
            this._close_btn = new Sprite();
            this._owner = this;
            LogManager.logsText = this._mainLogsText;
            AdLog.logsText = this._adLogsText;
            P2pLog.logsText = this._p2pLogsText;
            this.drawSkin(param1, param2);
            this.addEvent();
            return;
        }// end function

        private function drawSkin(param1:Number, param2:Number) : void
        {
            Utils.drawRect(this._bg, 0, 0, param1, param2, 0, 0.9);
            addChild(this._bg);
            this._closeBtnUp = drawCloseBtn(15, 0, 16777215);
            this._closeBtnOver = drawCloseBtn(15, 0, 16711680);
            this._close_btn.addChild(this._closeBtnUp);
            this._close_btn.addChild(this._closeBtnOver);
            this._closeBtnOver.visible = false;
            var _loc_3:Boolean = true;
            this._close_btn.useHandCursor = true;
            this._close_btn.buttonMode = _loc_3;
            this._close_btn.mouseChildren = false;
            setTextFormat(this._p2pLogsText, 16777215);
            setTextFormat(this._adLogsText, 16777215);
            setTextFormat(this._mainLogsText, 16777215);
            addChild(this._mainLogsText);
            addChild(this._adLogsText);
            addChild(this._p2pLogsText);
            this._close_btn.x = param1 - this._close_btn.width - 5;
            this._close_btn.y = 5;
            addChild(this._close_btn);
            addChild(this._copyLogs_btn);
            addChild(this._mailTo_btn);
            addChild(this._mainLogs_btn);
            addChild(this._adLogs_btn);
            addChild(this._p2pLogs_btn);
            var _loc_3:int = 5;
            this._p2pLogs_btn.y = 5;
            var _loc_3:* = _loc_3;
            this._adLogs_btn.y = _loc_3;
            this._mainLogs_btn.y = _loc_3;
            this._mainLogs_btn.x = 5;
            this._adLogs_btn.x = this._mainLogs_btn.x + this._mainLogs_btn.width;
            this._p2pLogs_btn.x = this._adLogs_btn.x + this._adLogs_btn.width;
            var _loc_3:* = this._mainLogs_btn.y + this._mainLogs_btn.height + 20;
            this._p2pLogsText.y = this._mainLogs_btn.y + this._mainLogs_btn.height + 20;
            var _loc_3:* = _loc_3;
            this._adLogsText.y = _loc_3;
            this._mainLogsText.y = _loc_3;
            var _loc_3:int = 10;
            this._p2pLogsText.x = 10;
            var _loc_3:* = _loc_3;
            this._adLogsText.x = _loc_3;
            this._mainLogsText.x = _loc_3;
            var _loc_3:* = param1 - 10;
            this._p2pLogsText.width = param1 - 10;
            var _loc_3:* = _loc_3;
            this._adLogsText.width = _loc_3;
            this._mainLogsText.width = _loc_3;
            var _loc_3:* = param2 - 60;
            this._p2pLogsText.height = param2 - 60;
            var _loc_3:* = _loc_3;
            this._adLogsText.height = _loc_3;
            this._mainLogsText.height = _loc_3;
            var _loc_3:Boolean = false;
            this._p2pLogsText.visible = false;
            var _loc_3:* = _loc_3;
            this._adLogsText.visible = _loc_3;
            this._mainLogsText.visible = _loc_3;
            return;
        }// end function

        private function addEvent() : void
        {
            this._copyLogs_btn.addEventListener(MouseEvent.CLICK, this.copyLogs);
            this._mailTo_btn.addEventListener(MouseEvent.CLICK, this.mailTo);
            this._mainLogs_btn.addEventListener(MouseEvent.CLICK, this.showMainLogs);
            this._adLogs_btn.addEventListener(MouseEvent.CLICK, this.showAdLogs);
            this._p2pLogs_btn.addEventListener(MouseEvent.CLICK, this.showP2pLogs);
            this._close_btn.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
            this._close_btn.addEventListener(MouseEvent.MOUSE_UP, this.close);
            return;
        }// end function

        private function copyLogs(event:MouseEvent) : void
        {
            this.sumLogs();
            return;
        }// end function

        private function mailTo(event:MouseEvent) : void
        {
            this.sumLogs();
            Utils.openWindow("mailto:tv-tech-flash@sohu-inc.com?subject=SohuTVPlayerLogs(" + new Date().toString() + ")&body=Please paste:");
            return;
        }// end function

        private function sumLogs() : void
        {
            var _loc_1:* = new TextField();
            _loc_1.text = "主播放器日志： " + this._mainLogsText.text + "广告日志：" + this._adLogsText.text + "p2p日志：" + this._p2pLogsText.text;
            System.setClipboard(_loc_1.text);
            LogManager.msg("播放器log已复制！");
            AdLog.msg("广告log已复制！");
            P2pLog.msg("p2plog已复制！");
            return;
        }// end function

        private function showMainLogs(event:MouseEvent) : void
        {
            this._mainLogsText.visible = true;
            var _loc_2:Boolean = false;
            this._p2pLogsText.visible = false;
            this._adLogsText.visible = _loc_2;
            return;
        }// end function

        private function showAdLogs(event:MouseEvent) : void
        {
            this._adLogsText.visible = true;
            var _loc_2:Boolean = false;
            this._p2pLogsText.visible = false;
            this._mainLogsText.visible = _loc_2;
            return;
        }// end function

        private function showP2pLogs(event:MouseEvent) : void
        {
            this._p2pLogsText.visible = true;
            var _loc_2:Boolean = false;
            this._adLogsText.visible = false;
            this._mainLogsText.visible = _loc_2;
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (this._bg != null && this._close_btn != null)
            {
                _loc_3 = param1 - this._bg.width;
                _loc_4 = param2 - this._bg.height;
                this._close_btn.x = this._close_btn.x + _loc_3;
                this._bg.width = param1;
                this._bg.height = param2;
                Utils.setCenter(this._copyLogs_btn, this._bg);
                Utils.setCenter(this._mailTo_btn, this._bg);
                this._copyLogs_btn.x = this._copyLogs_btn.x - this._copyLogs_btn.width / 2 - 5;
                this._mailTo_btn.x = this._mailTo_btn.x + this._mailTo_btn.width / 2 + 5;
                this._copyLogs_btn.y = this._bg.height - this._copyLogs_btn.height - 10;
                this._mailTo_btn.y = this._bg.height - this._mailTo_btn.height - 10;
                this._mainLogsText.width = this._mainLogsText.width + _loc_3;
                this._mainLogsText.height = this._mainLogsText.height + _loc_4;
                var _loc_5:* = this._mainLogsText.width;
                this._adLogsText.width = this._mainLogsText.width;
                this._p2pLogsText.width = _loc_5;
                var _loc_5:* = this._mainLogsText.height;
                this._adLogsText.height = this._mainLogsText.height;
                this._p2pLogsText.height = _loc_5;
            }
            setTextFormat(this._adLogsText, 16777215);
            setTextFormat(this._mainLogsText, 16777215);
            setTextFormat(this._p2pLogsText, 16777215);
            return;
        }// end function

        public function close(param1 = null) : void
        {
            var evt:* = param1;
            var _loc_3:Boolean = false;
            this._p2pLogsText.visible = false;
            var _loc_3:* = _loc_3;
            this._adLogsText.visible = _loc_3;
            this._mainLogsText.visible = _loc_3;
            if (evt != 0 && this._isOpen)
            {
                this._isOpen = false;
                this._owner.visible = true;
                TweenLite.to(this._owner, 0.3, {alpha:0, ease:Quad.easeOut, onComplete:function () : void
            {
                _owner.visible = false;
                return;
            }// end function
            });
            }
            else
            {
                this._owner.visible = false;
                this._owner.alpha = 0;
            }
            return;
        }// end function

        public function open(param1 = null) : void
        {
            this._mainLogsText.visible = true;
            this._isOpen = true;
            this._owner.visible = true;
            TweenLite.to(this._owner, 0.3, {alpha:1, ease:Quad.easeOut});
            return;
        }// end function

        private function mouseOverHandler(event:MouseEvent) : void
        {
            this._closeBtnOver.visible = true;
            this._closeBtnUp.visible = false;
            return;
        }// end function

        private function mouseOutHandler(event:MouseEvent) : void
        {
            this._closeBtnOver.visible = false;
            this._closeBtnUp.visible = true;
            return;
        }// end function

        public function get isOpen() : Boolean
        {
            return this._isOpen;
        }// end function

        override public function get width() : Number
        {
            return this._bg.width;
        }// end function

        override public function get height() : Number
        {
            return this._bg.height;
        }// end function

        public static function setTextFormat(param1:TextField, param2:Number) : void
        {
            var _loc_3:* = new TextFormat();
            _loc_3.size = 12;
            _loc_3.leading = 10;
            _loc_3.font = "微软雅黑";
            _loc_3.align = TextFormatAlign.LEFT;
            param1.wordWrap = true;
            param1.textColor = param2;
            param1.setTextFormat(_loc_3);
            return;
        }// end function

        public static function drawCloseBtn(param1:Number, param2:uint, param3:uint) : Sprite
        {
            var _loc_4:* = int(param1 / 5);
            var _loc_5:* = param1 / 2;
            var _loc_6:* = param1 / 2;
            var _loc_7:* = int(param1 / 5);
            var _loc_8:* = new Sprite();
            var _loc_9:* = new Sprite();
            new Sprite().graphics.beginFill(param2, 0.8);
            _loc_9.graphics.drawCircle(_loc_6, _loc_6, _loc_5);
            _loc_9.graphics.endFill();
            _loc_9.graphics.lineStyle(_loc_4, param3, 1, false, "normal", CapsStyle.NONE);
            _loc_9.graphics.moveTo(_loc_7, _loc_7);
            _loc_9.graphics.lineTo(param1 - _loc_7, param1 - _loc_7);
            _loc_9.graphics.moveTo(_loc_7, param1 - _loc_7);
            _loc_9.graphics.lineTo(param1 - _loc_7, _loc_7);
            _loc_8.addChild(_loc_9);
            _loc_9.x = 1;
            _loc_9.y = (_loc_8.height - _loc_9.height) / 2;
            _loc_8.graphics.beginFill(4473924, 0);
            _loc_8.graphics.drawRect(0, 0, _loc_8.width, _loc_8.height);
            _loc_8.graphics.endFill();
            return _loc_8;
        }// end function

    }
}
