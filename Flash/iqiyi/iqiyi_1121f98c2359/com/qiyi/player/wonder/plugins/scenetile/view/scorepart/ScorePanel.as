package com.qiyi.player.wonder.plugins.scenetile.view.scorepart
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.*;
    import common.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import scenetile.*;

    public class ScorePanel extends Sprite
    {
        private var _bg:CommonBg;
        private var _closeBtn:ScoreCloseBtn;
        private var _tfVideoName:TextField;
        private var _tfCurVideoScore:TextField;
        private var _tfFixed:TextField;
        private var _tfHeartDescribe:TextField;
        private var _tfLevelDescribe:TextField;
        private var _tfScoreExplain:TextField;
        private var _mcScoreHeartVector:Vector.<ScoreHeartItem>;
        private var _videoName:String = "";
        private var _curScoreNum:Number = 0;
        private static const FRAME_NAME_RED_HEART:String = "_redHeart";
        private static const FRAME_NAME_GRAY_HEART:String = "_grayHeart";
        private static const STR_SCORE_DESCRIBE:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_PANEL_DES1);
        private static const STR_SCORE_EXPLAIN:String = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_PANEL_DES2);

        public function ScorePanel(param1:String, param2:Number)
        {
            this._videoName = param1;
            this._curScoreNum = param2;
            this.initPanel();
            return;
        }// end function

        private function initPanel() : void
        {
            var _loc_1:ScoreHeartItem = null;
            this._bg = new CommonBg();
            this._bg.width = 310;
            this._bg.height = 126;
            addChild(this._bg);
            this._tfVideoName = FastCreator.createLabel(this._videoName, 16777215, 16, TextFieldAutoSize.LEFT);
            this._tfVideoName.x = 12;
            this._tfVideoName.y = 17;
            addChild(this._tfVideoName);
            this._tfCurVideoScore = FastCreator.createLabel("8.0", 16711680, 18, TextFieldAutoSize.CENTER);
            this._tfCurVideoScore.x = 200;
            this._tfCurVideoScore.y = 16;
            addChild(this._tfCurVideoScore);
            this._tfFixed = FastCreator.createLabel(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.SCORE_PANEL_DES3), 10066329, 12, TextFieldAutoSize.CENTER);
            this._tfFixed.x = this._tfCurVideoScore.x + this._tfCurVideoScore.width;
            this._tfFixed.y = 21;
            addChild(this._tfFixed);
            this._tfHeartDescribe = FastCreator.createLabel(STR_SCORE_DESCRIBE, 16777215, 14, TextFieldAutoSize.LEFT);
            this._tfHeartDescribe.x = 12;
            this._tfHeartDescribe.y = 52;
            addChild(this._tfHeartDescribe);
            if (this._curScoreNum > 0)
            {
                var _loc_3:Boolean = true;
                this._tfFixed.visible = true;
                this._tfCurVideoScore.visible = _loc_3;
                this._tfCurVideoScore.text = this._curScoreNum.toString();
                this._tfCurVideoScore.x = this._tfVideoName.x + this._tfVideoName.textWidth + 15;
                this._tfFixed.x = this._tfCurVideoScore.x + this._tfCurVideoScore.width;
            }
            else
            {
                var _loc_3:Boolean = false;
                this._tfFixed.visible = false;
                this._tfCurVideoScore.visible = _loc_3;
            }
            this._mcScoreHeartVector = new Vector.<ScoreHeartItem>;
            var _loc_2:uint = 0;
            while (_loc_2 < SceneTileDef.SCORE_MAX_LEVEL)
            {
                
                _loc_1 = new ScoreHeartItem(_loc_2);
                _loc_1.heartState(FRAME_NAME_GRAY_HEART);
                _loc_1.addEventListener(MouseEvent.CLICK, this.onHeartItemClick);
                _loc_1.addEventListener(MouseEvent.ROLL_OVER, this.onHeartItemRollOver);
                _loc_1.addEventListener(MouseEvent.ROLL_OUT, this.onHeartItemRollOut);
                _loc_1.x = this._tfHeartDescribe.x + this._tfHeartDescribe.textWidth + _loc_1.width * _loc_2;
                _loc_1.y = this._tfHeartDescribe.y + (this._tfHeartDescribe.height - _loc_1.height) / 2;
                addChild(_loc_1);
                this._mcScoreHeartVector.push(_loc_1);
                _loc_2 = _loc_2 + 1;
            }
            this._tfLevelDescribe = FastCreator.createLabel(SceneTileDef.SCORE_LEVEL_DESCRIBE[0], 16777215, 12, TextFieldAutoSize.CENTER);
            this._tfLevelDescribe.x = this._mcScoreHeartVector[(SceneTileDef.SCORE_MAX_LEVEL - 1)].x + this._mcScoreHeartVector[(SceneTileDef.SCORE_MAX_LEVEL - 1)].width + 8;
            this._tfLevelDescribe.y = this._tfHeartDescribe.y + 1;
            this._tfLevelDescribe.visible = false;
            addChild(this._tfLevelDescribe);
            this._tfScoreExplain = FastCreator.createLabel(STR_SCORE_EXPLAIN, 16777215, 14);
            this._tfScoreExplain.x = 12;
            this._tfScoreExplain.y = 88;
            addChild(this._tfScoreExplain);
            this._closeBtn = new ScoreCloseBtn();
            this._closeBtn.x = this._bg.width - this._closeBtn.width / 2 - 5;
            this._closeBtn.y = (-this._closeBtn.height) / 2 + 5;
            addChild(this._closeBtn);
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            return;
        }// end function

        private function onHeartItemClick(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as ScoreHeartItem;
            if (_loc_2)
            {
                dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreHeartClick, _loc_2.index));
            }
            dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreClose));
            return;
        }// end function

        private function onHeartItemRollOver(event:MouseEvent) : void
        {
            var _loc_2:* = event.target as ScoreHeartItem;
            if (_loc_2)
            {
                this.updateHeartState(_loc_2.index);
                this._tfLevelDescribe.visible = true;
                this._tfLevelDescribe.text = SceneTileDef.SCORE_LEVEL_DESCRIBE[_loc_2.index];
            }
            return;
        }// end function

        private function onHeartItemRollOut(event:MouseEvent) : void
        {
            var _loc_2:* = event.target as ScoreHeartItem;
            if (_loc_2)
            {
                this.updateHeartState(-1);
                this._tfLevelDescribe.visible = false;
            }
            return;
        }// end function

        private function updateHeartState(param1:int) : void
        {
            var _loc_2:uint = 0;
            while (_loc_2 < SceneTileDef.SCORE_MAX_LEVEL)
            {
                
                if (_loc_2 <= param1)
                {
                    this._mcScoreHeartVector[_loc_2].heartState(FRAME_NAME_RED_HEART);
                }
                else
                {
                    this._mcScoreHeartVector[_loc_2].heartState(FRAME_NAME_GRAY_HEART);
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        private function onCloseBtnClick(event:MouseEvent) : void
        {
            PingBack.getInstance().userActionPing(PingBackDef.SCORE_CLOSE_BTN_CLICK);
            dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ScoreClose));
            return;
        }// end function

        public function destory() : void
        {
            var _loc_1:ScoreHeartItem = null;
            var _loc_2:DisplayObject = null;
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.onCloseBtnClick);
            while (this._mcScoreHeartVector.length > 0)
            {
                
                _loc_1 = this._mcScoreHeartVector.shift();
                _loc_1.removeEventListener(MouseEvent.CLICK, this.onHeartItemClick);
                _loc_1.removeEventListener(MouseEvent.ROLL_OVER, this.onHeartItemRollOver);
                _loc_1.removeEventListener(MouseEvent.ROLL_OUT, this.onHeartItemRollOut);
                _loc_1.destory();
                _loc_1 = null;
            }
            while (numChildren > 0)
            {
                
                _loc_2 = getChildAt(0);
                if (_loc_2.parent)
                {
                    _loc_2.parent.removeChild(_loc_2);
                }
                _loc_2 = null;
            }
            return;
        }// end function

    }
}
