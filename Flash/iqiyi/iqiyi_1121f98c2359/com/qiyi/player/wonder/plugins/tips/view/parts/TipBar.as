package com.qiyi.player.wonder.plugins.tips.view.parts
{
    import com.qiyi.player.wonder.common.localization.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import gs.*;

    public class TipBar extends Sprite
    {
        private var textCacheAsBitmap:Boolean = false;
        protected var tipContainer:Sprite;
        protected var _btnClose:CommonCloseBtn;
        protected var defaultCSS:String = "p{color:#ffffff;font-size:14;font-family:微软雅黑} .light{color:#83A80B;} a{color:#83A80B;}a:hover{color:#ffffff;text-decoration:underline} a:active{color:#ffffff;text-decoration:underline}";
        private var currTipId:String;
        private var _matrix:Matrix;
        private var hideTimeoutId:int;

        public function TipBar(param1:Boolean = false)
        {
            this._matrix = new Matrix();
            this.textCacheAsBitmap = param1;
            this.tipContainer = new Sprite();
            this.tipContainer.x = 5;
            addChild(this.tipContainer);
            this._btnClose = new CommonCloseBtn();
            this._btnClose.y = 1;
            addChild(this._btnClose);
            this._btnClose.addEventListener(MouseEvent.CLICK, this.onMouseClick);
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddStage);
            return;
        }// end function

        public function setCloseBtnVisible(param1:Boolean) : void
        {
            this._btnClose.visible = param1;
            return;
        }// end function

        private function drawBackGround(param1:Number, param2:Number = 30) : void
        {
            this.graphics.clear();
            this._matrix.createGradientBox(param1, param2);
            var _loc_3:Array = [0, 0];
            var _loc_4:Array = [0.8, 0];
            this.graphics.beginGradientFill(GradientType.LINEAR, _loc_3, _loc_4, null, this._matrix);
            this.graphics.drawRect(0, 0, param1 + 100, param2);
            this.graphics.endFill();
            this._btnClose.x = param1 - this._btnClose.width - 100;
            this.x = -param1;
            TweenLite.killTweensOf(this);
            TweenLite.to(this, 0.5, {x:0, onComplete:this.onMoveComplete});
            return;
        }// end function

        private function onMoveComplete() : void
        {
            TweenLite.killTweensOf(this);
            return;
        }// end function

        public function resize(param1:Number, param2:Number = 30) : void
        {
            return;
        }// end function

        public function destory() : void
        {
            if (stage)
            {
                stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            }
            this._btnClose.removeEventListener(MouseEvent.CLICK, this.onMouseClick);
            this.removeAllTip();
            return;
        }// end function

        function showTip(param1:String) : int
        {
            var _loc_5:String = null;
            var _loc_2:* = TipManager.getItem(param1);
            var _loc_3:* = TipManager.getItem(this.currentTipId);
            var _loc_4:* = this.getMaxLevel();
            if (_loc_2 && int(_loc_2.type) == 1)
            {
                if (_loc_2 && _loc_2.level && int(_loc_2.level) >= _loc_4)
                {
                    this.removeAllTip();
                    if (_loc_2 && LocalizationManager.instance.getLanguageStringByName(_loc_2.message))
                    {
                        TipManager.addLog("TipManager:  show tip " + param1);
                        TipManager.clearConflict(param1);
                        this.createTip(param1, LocalizationManager.instance.getLanguageStringByName(_loc_2.message));
                    }
                    this.visible = true;
                    clearTimeout(this.hideTimeoutId);
                    if (_loc_2.duration && int(_loc_2.duration) == -1)
                    {
                        return TipManager.TIP_SHOW_STATUS_OK;
                    }
                    this.hideTimeoutId = setTimeout(this.hideTip, _loc_2.duration ? (int(_loc_2.duration) * 1000) : (8000));
                    return TipManager.TIP_SHOW_STATUS_OK;
                }
            }
            else if (_loc_2 && int(_loc_2.type) == 2)
            {
                if (_loc_2 && _loc_2.level && int(_loc_2.level) > _loc_4)
                {
                    if (_loc_3 && _loc_3.type && _loc_2.type && int(_loc_3.type) < int(_loc_2.type) && (_loc_2.force == undefined || _loc_2.force != "true"))
                    {
                        TipManager.addLog("TipManager: " + param1 + " conflict because of type");
                        TipManager.addConflict(param1);
                        TipManager.checkNextConflict();
                        return TipManager.TIP_SHOW_STATUS_CONFLICTED;
                    }
                    this.removeAllTip();
                    if (_loc_2 && LocalizationManager.instance.getLanguageStringByName(_loc_2.message))
                    {
                        _loc_5 = "false";
                        if (_loc_3)
                        {
                            _loc_5 = "true";
                        }
                        TipManager.addLog("TipManager:  show tip " + param1 + "maxlevel " + _loc_4 + " curr " + _loc_5);
                        TipManager.clearConflict(param1);
                        this.createTip(param1, LocalizationManager.instance.getLanguageStringByName(_loc_2.message));
                    }
                    this.visible = true;
                    clearTimeout(this.hideTimeoutId);
                    if (_loc_2.duration && int(_loc_2.duration) == -1)
                    {
                        return TipManager.TIP_SHOW_STATUS_OK;
                    }
                    this.hideTimeoutId = setTimeout(this.hideTip, _loc_2.duration ? (int(_loc_2.duration) * 1000) : (8000));
                    return TipManager.TIP_SHOW_STATUS_OK;
                }
                else
                {
                    TipManager.addLog("TipManager: " + param1 + " conflict because of level");
                    TipManager.addConflict(param1);
                    TipManager.checkNextConflict();
                    return TipManager.TIP_SHOW_STATUS_CONFLICTED;
                }
            }
            return TipManager.TIP_SHOW_STATUS_CONFLICTED;
        }// end function

        function hideTip() : void
        {
            var _loc_1:* = new TipEvent(TipEvent.Hide);
            _loc_1.tipId = this.currTipId;
            this.visible = false;
            this.removeAllTip();
            this.currTipId = "";
            TipManager.instance.dispatchEvent(_loc_1);
            return;
        }// end function

        function get currentTipId() : String
        {
            return this.currTipId;
        }// end function

        function showInstantTip(param1:String, param2:String) : void
        {
            this.removeAllTip();
            this.createTip(param1, param2);
            return;
        }// end function

        private function onAddStage(event:Event) : void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddStage);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            return;
        }// end function

        private function onMouseClick(event:MouseEvent) : void
        {
            this.hideTip();
            var _loc_2:* = new TipEvent(TipEvent.Close);
            _loc_2.tipId = this.currTipId;
            TipManager.instance.dispatchEvent(_loc_2);
            return;
        }// end function

        private function onKeyDown(event:KeyboardEvent) : void
        {
            if (event.ctrlKey && event.altKey && event.charCode == 116)
            {
                TipManager.TipDebugInfo();
            }
            return;
        }// end function

        private function onLinkHandler(event:TextEvent) : void
        {
            var _loc_4:TipEvent = null;
            var _loc_5:Object = null;
            var _loc_2:* = event.text;
            var _loc_3:* = this.getEvent(_loc_2);
            if (_loc_2.substr(0, 7) == "ASEvent")
            {
                _loc_4 = new TipEvent(TipEvent.ASEvent, _loc_3);
                _loc_4.tipId = this.currTipId;
            }
            else if (_loc_2.substr(0, 7) == "JSEvent")
            {
                _loc_4 = new TipEvent(TipEvent.JSEvent, _loc_3);
                _loc_4.tipId = this.currTipId;
            }
            else if (_loc_2 != "")
            {
                _loc_5 = new Object();
                _loc_5.url = _loc_2;
                _loc_4 = new TipEvent(TipEvent.LinkEvent, _loc_5);
                _loc_4.tipId = this.currTipId;
            }
            if (_loc_4)
            {
                TipManager.instance.dispatchEvent(_loc_4);
            }
            return;
        }// end function

        private function createTip(param1:String, param2:String) : void
        {
            var _loc_7:String = null;
            if (getChildByName(param1))
            {
                return;
            }
            var _loc_3:* = new TextField();
            if (this.textCacheAsBitmap)
            {
                _loc_3.cacheAsBitmap = true;
            }
            this.tipContainer.addChild(_loc_3);
            _loc_3.name = param1;
            _loc_3.selectable = false;
            var _loc_4:* = new StyleSheet();
            _loc_4.parseCSS(this.defaultCSS);
            _loc_3.styleSheet = _loc_4;
            param2 = "<p>" + param2 + "</p>";
            param2 = param2.replace(/<span>""<span>/g, "<span class=\"light\">");
            param2 = param2.replace(/<a ""<a /g, "<a target=\"_blank\" ");
            var _loc_5:* = TipManager.getAttribute();
            if (_loc_5)
            {
                for (_loc_7 in _loc_5)
                {
                    
                    param2 = param2.replace("#" + _loc_7 + "#", _loc_5[_loc_7]);
                }
            }
            _loc_3.htmlText = param2;
            _loc_3.width = _loc_3.textWidth + 10;
            _loc_3.height = _loc_3.textHeight + 6;
            _loc_3.y = 2;
            _loc_3.addEventListener(TextEvent.LINK, this.onLinkHandler);
            this.currTipId = param1;
            var _loc_6:* = new TipEvent(TipEvent.Show, null);
            _loc_6.tipId = this.currTipId;
            TipManager.instance.dispatchEvent(_loc_6);
            TipManager.addLog("TipManager: show tip is  " + this.currTipId);
            TipManager.addShowCount(this.currTipId);
            TipManager.addProSubUpdateTipCount(this.currTipId);
            this.drawBackGround(_loc_3.width + 200);
            return;
        }// end function

        private function removeAllTip() : void
        {
            var _loc_1:DisplayObject = null;
            while (this.tipContainer.numChildren > 0)
            {
                
                _loc_1 = this.tipContainer.getChildAt(0);
                _loc_1.removeEventListener(TextEvent.LINK, this.onLinkHandler);
                this.tipContainer.removeChild(_loc_1);
                _loc_1 = null;
            }
            return;
        }// end function

        private function getMaxLevel() : int
        {
            var _loc_3:TextField = null;
            var _loc_4:String = null;
            var _loc_5:Object = null;
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            while (_loc_2 < this.tipContainer.numChildren)
            {
                
                _loc_3 = this.tipContainer.getChildAt(_loc_2) as TextField;
                _loc_4 = _loc_3.name;
                _loc_5 = TipManager.getItem(_loc_4);
                if (_loc_5 && _loc_5.level)
                {
                    if (_loc_1 < int(_loc_5.level))
                    {
                        _loc_1 = int(_loc_5.level);
                    }
                }
                _loc_2++;
            }
            return _loc_1;
        }// end function

        private function getEvent(param1:String) : Object
        {
            var _loc_5:String = null;
            var _loc_6:Array = null;
            var _loc_7:String = null;
            var _loc_8:int = 0;
            var _loc_2:* = new Object();
            var _loc_3:* = /\(.*?\)""\(.*?\)/;
            var _loc_4:* = param1.match(_loc_3);
            if (_loc_4 && _loc_4.length > 0)
            {
                _loc_5 = String(_loc_4[0]);
                _loc_5 = _loc_5.replace(/\(""\(/, "");
                _loc_5 = _loc_5.replace(/\)""\)/, "");
                _loc_6 = _loc_5.split(",");
                _loc_7 = _loc_6[0];
                _loc_2.eventName = _loc_7;
                _loc_2.eventParams = "";
                _loc_8 = 1;
                while (_loc_8 < _loc_6.length)
                {
                    
                    _loc_2.eventParams = _loc_2.eventParams + _loc_6[_loc_8];
                    _loc_8++;
                }
            }
            return _loc_2;
        }// end function

    }
}
