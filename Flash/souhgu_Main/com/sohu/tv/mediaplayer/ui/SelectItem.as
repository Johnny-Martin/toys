package com.sohu.tv.mediaplayer.ui
{
    import com.sohu.tv.mediaplayer.*;
    import ebing.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.text.*;

    public class SelectItem extends Sprite
    {
        private var _sItemObj:Object;
        private var _failIcon:Sprite;
        private var _overIcon:Sprite;
        private var _titleBg:Sprite;
        private var _overSp:Sprite;
        private var _adTitleText:TextField;
        private var _adCon:Sprite;
        private const ADWIDTH:Number = 240;
        private const ADHEIGHT:Number = 155;
        public var aname:String = "";
        private var isfail:Boolean = false;
        private var lc:LoaderContext;

        public function SelectItem(param1:Object)
        {
            this._overSp = new Sprite();
            this._adCon = new Sprite();
            this.lc = new LoaderContext(true);
            this._sItemObj = param1;
            this.init();
            return;
        }// end function

        private function init() : void
        {
            Utils.drawRect(this._adCon, 0, 0, 240, 155, 4079166, 1);
            Utils.drawRect(this._overSp, 0, 0, 240, 155, 0, 0.5);
            new LoaderUtil().load(8, this.adLoadHandler, null, this._sItemObj.img, this.lc);
            this._overIcon = new SoadOverIcon();
            this._failIcon = new SoadFailIcon();
            this._titleBg = new SoadTitleBg();
            this._titleBg.width = this.ADWIDTH;
            this._titleBg.y = this.ADHEIGHT - this._titleBg.height + 1;
            this._failIcon.x = Math.round(this.ADWIDTH - this._failIcon.width) / 2;
            this._overIcon.x = Math.round(this.ADWIDTH - this._overIcon.width) / 2;
            this._failIcon.y = Math.round(this.ADHEIGHT - this._failIcon.height) / 2;
            this._overIcon.y = Math.round(this.ADHEIGHT - this._overIcon.height) / 2;
            this._adCon.width = this.ADWIDTH;
            this._adCon.height = this.ADHEIGHT;
            addChild(this._adCon);
            this._overSp.visible = false;
            this._failIcon.visible = false;
            var _loc_1:* = new TextFormat();
            _loc_1.font = PlayerConfig.MICROSOFT_YAHEI;
            _loc_1.color = 16777215;
            _loc_1.size = 14;
            _loc_1.align = TextFormatAlign.LEFT;
            this._adTitleText = new TextField();
            this._adTitleText.selectable = false;
            this._adTitleText.width = 240;
            this._adTitleText.height = 25;
            this._adTitleText.defaultTextFormat = _loc_1;
            this._adTitleText.text = Utils.maxCharsLimit(unescape(this._sItemObj.title), 26, true);
            this._adTitleText.x = 13;
            this._adTitleText.y = this.ADHEIGHT - this._adTitleText.height;
            this._adCon.addEventListener(MouseEvent.ROLL_OUT, this.rollOutHandler);
            this._adCon.addEventListener(MouseEvent.ROLL_OVER, this.rollOverHandler);
            return;
        }// end function

        private function rollOverHandler(event:MouseEvent) : void
        {
            if (!this.isfail)
            {
                this._overSp.visible = true;
            }
            return;
        }// end function

        private function rollOutHandler(event:MouseEvent) : void
        {
            if (!this.isfail)
            {
                this._overSp.visible = false;
            }
            return;
        }// end function

        private function adLoadHandler(param1:Object) : void
        {
            var _loc_2:Loader = null;
            if (param1.info == "success")
            {
                this.isfail = false;
                param1.data.content.smoothing = true;
                _loc_2 = param1.data;
                _loc_2.width = 240;
                _loc_2.height = 155;
                this._adCon.addChild(_loc_2);
                this._failIcon.visible = false;
            }
            else
            {
                this.isfail = true;
                this._failIcon.visible = true;
            }
            this._adCon.addChild(this._failIcon);
            this._adCon.addChild(this._titleBg);
            this._adCon.addChild(this._adTitleText);
            this._adCon.addChild(this._overSp);
            this._overSp.addChild(this._overIcon);
            return;
        }// end function

    }
}
