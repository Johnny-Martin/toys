package com.qiyi.player.wonder.plugins.setting.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import com.qiyi.player.wonder.plugins.setting.view.parts.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import gs.*;

    public class DefinitionView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _bg:CommonBg;
        private var _definitionDataVector:Array;
        private var _itemVector:Vector.<DefinitionItem>;
        private var _currentSelectedItem:EnumItem;
        private var _currendVid:int;
        private var _maskSprite:Sprite;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.view.DefinitionView";

        public function DefinitionView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            type = BodyDef.VIEW_TYPE_POPUP;
            this._bg = new CommonBg();
            this._bg.width = SettingDef.DEFINITION_PANEL_WIDTH;
            addChild(this._bg);
            this._maskSprite = new Sprite();
            addChild(this._maskSprite);
            return;
        }// end function

        public function initUI(param1:Number, param2:Number, param3:Array, param4:Array, param5:EnumItem, param6:int) : void
        {
            var _loc_7:DefinitionItem = null;
            var _loc_10:Boolean = false;
            var _loc_11:uint = 0;
            this._currentSelectedItem = param5;
            this._currendVid = param6;
            this._bg.height = SettingDef.DEFINITION_PANEL_ITEM_HEIGHT * (param3.length + param4.length) + 13;
            this._bg.x = param1;
            this._bg.y = param2 - this._bg.height + 13;
            this._itemVector = new Vector.<DefinitionItem>;
            var _loc_8:uint = 0;
            while (_loc_8 < param4.length)
            {
                
                _loc_7 = new DefinitionItem(param4[_loc_8], true);
                _loc_7.x = param1;
                _loc_7.y = param2 - this._bg.height + 17 + _loc_8 * SettingDef.DEFINITION_PANEL_ITEM_HEIGHT;
                if (this._currentSelectedItem == DefinitionEnum.NONE && param4[_loc_8].id == 0)
                {
                    _loc_7.isSelected = true;
                }
                else if (this._currentSelectedItem == null && param4[_loc_8].id == this._currendVid)
                {
                    _loc_7.isSelected = true;
                }
                else
                {
                    _loc_7.isSelected = false;
                }
                if (this._currendVid == param4[_loc_8].id)
                {
                    _loc_7.isVid = true;
                }
                addChild(_loc_7);
                this._itemVector.push(_loc_7);
                _loc_8 = _loc_8 + 1;
            }
            var _loc_9:uint = 0;
            while (_loc_9 < param3.length)
            {
                
                _loc_10 = false;
                _loc_11 = 0;
                while (_loc_11 < param4.length)
                {
                    
                    if (param3[_loc_9] == param4[_loc_11])
                    {
                        _loc_10 = true;
                    }
                    _loc_11 = _loc_11 + 1;
                }
                _loc_7 = new DefinitionItem(param3[_loc_9], _loc_10);
                _loc_7.x = param1;
                _loc_7.y = param2 - this._bg.height + 17 + (param4.length + _loc_9) * SettingDef.DEFINITION_PANEL_ITEM_HEIGHT;
                if (this._currentSelectedItem == DefinitionEnum.NONE && param3[_loc_9].id == 0)
                {
                    _loc_7.isSelected = true;
                }
                else if (this._currentSelectedItem == null && param3[_loc_9].id == this._currendVid)
                {
                    _loc_7.isSelected = true;
                }
                if (this._currendVid == param3[_loc_9].id)
                {
                    _loc_7.isVid = true;
                }
                addChild(_loc_7);
                this._itemVector.push(_loc_7);
                _loc_9 = _loc_9 + 1;
            }
            return;
        }// end function

        public function setSelectedItem(param1:EnumItem) : void
        {
            var _loc_2:DefinitionItem = null;
            for each (_loc_2 in this._itemVector)
            {
                
                _loc_2.isSelected = false;
                if (param1.id == _loc_2.data.id)
                {
                    _loc_2.isSelected = true;
                }
            }
            return;
        }// end function

        public function setChangeVidComplete(param1:EnumItem) : void
        {
            var _loc_2:DefinitionItem = null;
            if (this._itemVector == null)
            {
                return;
            }
            for each (_loc_2 in this._itemVector)
            {
                
                _loc_2.isVid = false;
                if (param1.id == _loc_2.data.id)
                {
                    _loc_2.isVid = true;
                }
            }
            return;
        }// end function

        private function destroyItem() : void
        {
            var _loc_1:DefinitionItem = null;
            if (this._itemVector == null)
            {
                return;
            }
            for each (_loc_1 in this._itemVector)
            {
                
                _loc_1.destroy();
                removeChild(_loc_1);
                _loc_1 = null;
            }
            this._itemVector.length = 0;
            this._itemVector = null;
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            this._status.addStatus(param1);
            switch(param1)
            {
                case SettingDef.STATUS_DEFINITION_OPEN:
                {
                    this.open();
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
                case SettingDef.STATUS_DEFINITION_OPEN:
                {
                    this.close();
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
                dispatchEvent(new SettingEvent(SettingEvent.Evt_DefinitionOpen));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new SettingEvent(SettingEvent.Evt_DefinitionClose));
            }
            return;
        }// end function

        override protected function onAddToStage() : void
        {
            super.onAddToStage();
            this._maskSprite.graphics.clear();
            this._maskSprite.graphics.beginFill(16711680, 0);
            this._maskSprite.graphics.drawRect(this._bg.x, this._bg.y, SettingDef.DEFINITION_PANEL_WIDTH, this._bg.height + BodyDef.VIDEO_BOTTOM_RESERVE);
            this._maskSprite.graphics.endFill();
            addEventListener(MouseEvent.ROLL_OUT, this.onMaskRollOut);
            addEventListener(MouseEvent.CLICK, this.onViewClick);
            alpha = 0;
            TweenLite.to(this, BodyDef.POPUP_TWEEN_TIME / 1000, {alpha:1});
            return;
        }// end function

        override protected function onRemoveFromStage() : void
        {
            super.onRemoveFromStage();
            this._maskSprite.graphics.clear();
            removeEventListener(MouseEvent.ROLL_OUT, this.onMaskRollOut);
            removeEventListener(MouseEvent.CLICK, this.onViewClick);
            this.destroyItem();
            TweenLite.killTweensOf(this);
            return;
        }// end function

        private function onMaskRollOut(event:MouseEvent) : void
        {
            this.close();
            return;
        }// end function

        private function onViewClick(event:MouseEvent) : void
        {
            if (event.target is DefinitionItem)
            {
                this.setSelectedItem(event.target.data);
                dispatchEvent(new SettingEvent(SettingEvent.Evt_DefinitionChangeClick, event.target.data));
            }
            this.close();
            return;
        }// end function

    }
}
