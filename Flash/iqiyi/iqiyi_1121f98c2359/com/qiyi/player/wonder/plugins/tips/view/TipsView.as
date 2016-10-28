package com.qiyi.player.wonder.plugins.tips.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.tips.*;
    import com.qiyi.player.wonder.plugins.tips.view.parts.*;
    import flash.display.*;
    import gs.*;

    public class TipsView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _tipBar:TipBar;
        private var _gap:int;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.tips.view.TipsView";

        public function TipsView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this._tipBar = new TipBar(FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT);
            this._tipBar.visible = false;
            addChild(this._tipBar);
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function get tipBar() : TipBar
        {
            return this._tipBar;
        }// end function

        public function setCloseBtnVisible(param1:Boolean) : void
        {
            this._tipBar.setCloseBtnVisible(param1);
            return;
        }// end function

        public function setGap(param1:int) : void
        {
            this._gap = param1;
            var _loc_2:* = GlobalStage.stage.stageHeight - this._tipBar.height - this._gap;
            TweenLite.to(this, 0.5, {y:_loc_2, onComplete:this.onTweenComplete});
            return;
        }// end function

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            this._status.addStatus(param1);
            switch(param1)
            {
                case TipsDef.STATUS_OPEN:
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
                case TipsDef.STATUS_OPEN:
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

        public function onResize(param1:int, param2:int) : void
        {
            this._tipBar.resize(param1);
            y = GlobalStage.stage.stageHeight - this._tipBar.height - this._gap;
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new TipsEvent(TipsEvent.Evt_Open));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new TipsEvent(TipsEvent.Evt_Close));
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

        private function onTweenComplete() : void
        {
            y = GlobalStage.stage.stageHeight - this._tipBar.height - this._gap;
            return;
        }// end function

    }
}
