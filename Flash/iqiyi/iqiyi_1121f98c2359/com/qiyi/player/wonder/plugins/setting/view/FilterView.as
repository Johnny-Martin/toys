package com.qiyi.player.wonder.plugins.setting.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import gs.*;

    public class FilterView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _bgSpr:Shape;
        private var _bg:CommonBg;
        private var _title:TextField;
        private var _videoBitmap:Bitmap;
        private var _videoSize:Point;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.FilterView";
        private static const STR_EXPLAIN_TITLE_PART1:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SETTING_FILTER_VIEW_DES10);

        public function FilterView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this._videoSize = new Point();
            this.initUI();
            return;
        }// end function

        private function initUI() : void
        {
            this._bgSpr = new Shape();
            this._bgSpr.visible = false;
            addChild(this._bgSpr);
            this._videoBitmap = new Bitmap();
            this._videoBitmap.visible = false;
            addChild(this._videoBitmap);
            this._bg = new CommonBg();
            this._bg.width = 430;
            this._bg.height = 50;
            addChild(this._bg);
            this._title = FastCreator.createLabel(STR_EXPLAIN_TITLE_PART1, 16777215, 14);
            this._title.x = (this._bg.width - this._title.textWidth) / 2;
            this._title.y = 24;
            addChild(this._title);
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            this._status.addStatus(param1);
            switch(param1)
            {
                case SettingDef.STATUS_FILTER_OPEN:
                {
                    this.open();
                    break;
                }
                case SettingDef.STATUS_FILTER_SHOW_UI:
                {
                    var _loc_2:Boolean = true;
                    this._bg.visible = true;
                    this._title.visible = _loc_2;
                    TweenLite.delayedCall(5, this.onDelayedCall);
                    break;
                }
                case SettingDef.STATUS_FILTER_SHOW_BMD:
                {
                    var _loc_2:Boolean = true;
                    this._videoBitmap.visible = true;
                    this._bgSpr.visible = _loc_2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onRemoveStatus(param1:int) : void
        {
            this._status.removeStatus(param1);
            switch(param1)
            {
                case SettingDef.STATUS_FILTER_OPEN:
                {
                    this.close();
                    break;
                }
                case SettingDef.STATUS_FILTER_SHOW_UI:
                {
                    var _loc_2:Boolean = false;
                    this._bg.visible = false;
                    this._title.visible = _loc_2;
                    break;
                }
                case SettingDef.STATUS_FILTER_SHOW_BMD:
                {
                    var _loc_2:Boolean = false;
                    this._videoBitmap.visible = false;
                    this._bgSpr.visible = _loc_2;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterOpen));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                TweenLite.killDelayedCallsTo();
                dispatchEvent(new SettingEvent(SettingEvent.Evt_FilterClose));
            }
            return;
        }// end function

        override protected function onAddToStage() : void
        {
            super.onAddToStage();
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        override protected function onRemoveFromStage() : void
        {
            super.onRemoveFromStage();
            return;
        }// end function

        public function videoSize(param1:int, param2:int) : void
        {
            if (this._videoSize.x != param1 || this._videoSize.y != param2)
            {
                this._videoSize.x = param1;
                this._videoSize.y = param2;
                this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            }
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            this._bgSpr.graphics.clear();
            this._bgSpr.graphics.beginFill(0);
            this._bgSpr.graphics.drawRect(0, 0, param1, param2);
            this._bgSpr.graphics.endFill();
            this._bg.x = (param1 - this._bg.width) * 0.5;
            this._bg.y = (param2 - this._bg.height) * 0.5;
            this._title.x = (param1 - this._title.textWidth) / 2;
            this._title.y = this._bg.y + (this._bg.height - this._title.height) * 0.5;
            this._videoBitmap.width = this._videoSize.x - 100;
            this._videoBitmap.height = this._videoSize.y - 100;
            this._videoBitmap.x = (param1 - this._videoBitmap.width) * 0.5;
            this._videoBitmap.y = (param2 - this._videoBitmap.height) * 0.5;
            return;
        }// end function

        public function showBmd(param1:BitmapData) : void
        {
            if (param1)
            {
                this._videoBitmap.bitmapData = param1;
                this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            }
            return;
        }// end function

        private function onDelayedCall() : void
        {
            TweenLite.killDelayedCallsTo();
            var _loc_1:Boolean = false;
            this._bg.visible = false;
            this._title.visible = _loc_1;
            return;
        }// end function

        private function onCloseBtnClick(event:MouseEvent = null) : void
        {
            this.close();
            return;
        }// end function

    }
}
