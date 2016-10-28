package com.qiyi.player.wonder.plugins.dock.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.dock.*;
    import common.*;
    import dock.*;
    import flash.display.*;
    import gs.*;

    public class DockView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _bg:CommonBg;
        private var _dockUI:DockUI;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.dock.view.DockView";

        public function DockView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this.initUI();
            this.updateLayout();
            return;
        }// end function

        public function get shareBtn() : SimpleButton
        {
            return this._dockUI.shareBtn;
        }// end function

        public function get openLightBtn() : SimpleButton
        {
            return this._dockUI.openLightBtn;
        }// end function

        public function get closeLightBtn() : SimpleButton
        {
            return this._dockUI.closeLightBtn;
        }// end function

        public function get offlineWatchBtn() : SimpleButton
        {
            return this._dockUI.offlineWatchBtn;
        }// end function

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            var _loc_2:int = 0;
            this._status.addStatus(param1);
            switch(param1)
            {
                case DockDef.STATUS_OPEN:
                {
                    this.open();
                    break;
                }
                case DockDef.STATUS_SHOW:
                {
                    _loc_2 = GlobalStage.stage.stageWidth - this._bg.width;
                    TweenLite.to(this, 0.5, {x:_loc_2, onComplete:this.onTweenComplete});
                    break;
                }
                case DockDef.STATUS_OFFLINE_WATCH_ENABLE:
                {
                    this.updateLayout();
                    break;
                }
                case DockDef.STATUS_OFFLINE_WATCH_SHOW:
                {
                    this.updateLayout();
                    break;
                }
                case DockDef.STATUS_LIGHT_SHOW:
                {
                    this.updateLayout();
                    break;
                }
                case DockDef.STATUS_LIGHT_ON:
                {
                    this.updateLayout();
                    break;
                }
                case DockDef.STATUS_SHARE_SHOW:
                {
                    this.updateLayout();
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
            var _loc_2:int = 0;
            this._status.removeStatus(param1);
            switch(param1)
            {
                case DockDef.STATUS_OPEN:
                {
                    this.close();
                    break;
                }
                case DockDef.STATUS_SHOW:
                {
                    _loc_2 = GlobalStage.stage.stageWidth;
                    TweenLite.to(this, 0.5, {x:_loc_2, onComplete:this.onTweenComplete});
                    break;
                }
                case DockDef.STATUS_OFFLINE_WATCH_ENABLE:
                {
                    this.updateLayout();
                    break;
                }
                case DockDef.STATUS_OFFLINE_WATCH_SHOW:
                {
                    this.updateLayout();
                    break;
                }
                case DockDef.STATUS_LIGHT_SHOW:
                {
                    this.updateLayout();
                    break;
                }
                case DockDef.STATUS_LIGHT_ON:
                {
                    this.updateLayout();
                    break;
                }
                case DockDef.STATUS_SHARE_SHOW:
                {
                    this.updateLayout();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function onResize(param1:int, param2:int) : void
        {
            if (this._status.hasStatus(DockDef.STATUS_SHOW))
            {
                x = param1 - this._bg.width;
            }
            else
            {
                x = param1;
            }
            y = param2 / 2 - this._bg.height / 2;
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new DockEvent(DockEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new DockEvent(DockEvent.Evt_Close));
            }
            return;
        }// end function

        override protected function onAddToStage() : void
        {
            super.onAddToStage();
            return;
        }// end function

        override protected function onRemoveFromStage() : void
        {
            super.onRemoveFromStage();
            return;
        }// end function

        private function initUI() : void
        {
            this._bg = new CommonBg();
            this._bg.width = 65;
            addChild(this._bg);
            this._dockUI = new DockUI();
            addChild(this._dockUI);
            return;
        }// end function

        private function updateLayout() : void
        {
            var _loc_1:int = 0;
            var _loc_5:int = 0;
            _loc_1 = 56;
            var _loc_2:int = 2;
            var _loc_3:int = 0;
            var _loc_4:int = 5;
            _loc_5 = 0;
            var _loc_6:int = 1;
            if (this._status.hasStatus(DockDef.STATUS_SHARE_SHOW))
            {
                this._dockUI.shareBtn.visible = true;
                this._dockUI.shareBtn.y = _loc_5;
                _loc_5 = _loc_5 + (_loc_1 + _loc_2 * 2 + _loc_6);
                _loc_3++;
            }
            else
            {
                this._dockUI.shareBtn.visible = false;
            }
            if (this._status.hasStatus(DockDef.STATUS_LIGHT_SHOW))
            {
                if (this._status.hasStatus(DockDef.STATUS_LIGHT_ON))
                {
                    this._dockUI.openLightBtn.visible = false;
                    this._dockUI.closeLightBtn.visible = true;
                }
                else
                {
                    this._dockUI.openLightBtn.visible = true;
                    this._dockUI.closeLightBtn.visible = false;
                }
                this._dockUI.openLightBtn.y = _loc_5;
                this._dockUI.closeLightBtn.y = _loc_5;
                _loc_5 = _loc_5 + (_loc_1 + _loc_2 * 2 + _loc_6);
                _loc_3++;
            }
            else
            {
                this._dockUI.openLightBtn.visible = false;
                this._dockUI.closeLightBtn.visible = false;
            }
            if (this._status.hasStatus(DockDef.STATUS_OFFLINE_WATCH_SHOW))
            {
                if (this._status.hasStatus(DockDef.STATUS_OFFLINE_WATCH_ENABLE))
                {
                    this._dockUI.offlineWatchBtn.visible = true;
                    this._dockUI.copyrightLimitBtn.visible = false;
                }
                else
                {
                    this._dockUI.offlineWatchBtn.visible = false;
                    this._dockUI.copyrightLimitBtn.visible = true;
                }
                this._dockUI.offlineWatchBtn.y = _loc_5;
                this._dockUI.copyrightLimitBtn.y = _loc_5;
                _loc_5 = _loc_5 + (_loc_1 + _loc_2 * 2 + _loc_6);
                _loc_3++;
            }
            else
            {
                this._dockUI.offlineWatchBtn.visible = false;
                this._dockUI.copyrightLimitBtn.visible = false;
            }
            var _loc_7:DisplayObject = null;
            _loc_5 = _loc_1 + _loc_2;
            var _loc_8:int = 0;
            while (_loc_8 < (_loc_4 - 1))
            {
                
                _loc_7 = this._dockUI.getChildByName("line" + _loc_8);
                if (_loc_8 >= (_loc_3 - 1))
                {
                    _loc_7.visible = false;
                }
                else
                {
                    _loc_7.visible = true;
                    _loc_7.y = _loc_5;
                    _loc_5 = _loc_5 + (_loc_1 + _loc_2 * 2 + _loc_6);
                }
                _loc_8++;
            }
            if (_loc_3 <= 0)
            {
                this._bg.height = 0;
            }
            else
            {
                this._bg.height = _loc_3 * (_loc_1 + _loc_2 * 2 + _loc_6) - _loc_2 * 2 - _loc_6;
            }
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        private function onTweenComplete() : void
        {
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

    }
}
