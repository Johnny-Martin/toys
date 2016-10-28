package com.qiyi.player.wonder.plugins.scenetile.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.scorepart.*;
    import flash.display.*;
    import gs.*;

    public class SceneTileScoreView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _scorePanel:ScorePanel;
        private var _scoreSuccessPanel:ScoreSuccessPanel;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileScoreView";

        public function SceneTileScoreView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            type = BodyDef.VIEW_TYPE_POPUP;
            this._status = param2;
            this._userInfoVO = param3;
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
                case SceneTileDef.STATUS_SCORE_OPEN:
                {
                    TweenLite.delayedCall(SceneTileDef.SCORE_SHOW_TIME, this.close);
                    this.open();
                    dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreOpen));
                    break;
                }
                case SceneTileDef.STATUS_SCORE_SUCCESS_OPEN:
                {
                    TweenLite.delayedCall(3, this.close);
                    this.open();
                    dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreSuccessOpen));
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
                case SceneTileDef.STATUS_SCORE_OPEN:
                {
                    this.destoryPanel();
                    this.close();
                    break;
                }
                case SceneTileDef.STATUS_SCORE_SUCCESS_OPEN:
                {
                    this.destoryPanel();
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
            if (this._scorePanel && this._scorePanel.parent)
            {
                y = param2 - BodyDef.VIDEO_BOTTOM_RESERVE - this._scorePanel.height - 40;
            }
            if (this._scoreSuccessPanel && this._scoreSuccessPanel.parent)
            {
                y = param2 - BodyDef.VIDEO_BOTTOM_RESERVE - this._scoreSuccessPanel.height - 40;
            }
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                TweenLite.killTweensOf(this.close);
                dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreClose));
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

        public function initScorePanel(param1:String, param2:Number) : void
        {
            this.destoryPanel();
            if (!this._scorePanel)
            {
                this._scorePanel = new ScorePanel(param1, param2);
                this._scorePanel.addEventListener(SceneTileEvent.Evt_ScoreClose, this.onScorePanelClose);
                this._scorePanel.addEventListener(SceneTileEvent.Evt_ScoreHeartClick, this.onScoreHeartClick);
                addChild(this._scorePanel);
                this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            }
            return;
        }// end function

        public function initScoreSuccessPanel(param1:Boolean) : void
        {
            this.destoryPanel();
            if (!this._scoreSuccessPanel)
            {
                this._scoreSuccessPanel = new ScoreSuccessPanel(param1);
                this._scoreSuccessPanel.addEventListener(SceneTileEvent.Evt_ScoreClose, this.onScorePanelClose);
                addChild(this._scoreSuccessPanel);
                this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            }
            return;
        }// end function

        private function destoryPanel() : void
        {
            if (this._scorePanel && this._scorePanel.parent)
            {
                this._scorePanel.removeEventListener(SceneTileEvent.Evt_ScoreClose, this.onScorePanelClose);
                this._scorePanel.removeEventListener(SceneTileEvent.Evt_ScoreHeartClick, this.onScoreHeartClick);
                this._scorePanel.destory();
                this._scorePanel.parent.removeChild(this._scorePanel);
                this._scorePanel = null;
            }
            if (this._scoreSuccessPanel && this._scoreSuccessPanel.parent)
            {
                this._scoreSuccessPanel.removeEventListener(SceneTileEvent.Evt_ScoreClose, this.onScorePanelClose);
                this._scoreSuccessPanel.destory();
                this._scoreSuccessPanel.parent.removeChild(this._scoreSuccessPanel);
                this._scoreSuccessPanel = null;
            }
            return;
        }// end function

        private function onScoreHeartClick(event:SceneTileEvent) : void
        {
            dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreHeartClick, event.data));
            return;
        }// end function

        private function onScorePanelClose(event:SceneTileEvent) : void
        {
            this.close();
            return;
        }// end function

    }
}
