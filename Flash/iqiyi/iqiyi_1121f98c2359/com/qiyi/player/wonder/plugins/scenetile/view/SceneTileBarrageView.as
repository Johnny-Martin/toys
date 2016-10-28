package com.qiyi.player.wonder.plugins.scenetile.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.vo.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.expression.*;
    import flash.display.*;
    import flash.events.*;

    public class SceneTileBarrageView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _barrageItemOP:ObjectPool;
        private var _barrageInfoOP:ObjectPool;
        private var _barrageItemArray:Array;
        private var _bufferBIANone:Array;
        private var _bufferBIANoneSocket:Array;
        private var _bufferBIAStar:Array;
        private var _bufferBIARestar:Array;
        private var _selfSendBarrageInfoVec:Vector.<BarrageInfoVO>;
        private var _rollOverRow:uint = 0;
        private var _isFilterImage:Boolean = false;
        private var _curRowNum:uint = 6;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileBarrageView";

        public function SceneTileBarrageView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this.initUI();
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function set isFilterImage(param1:Boolean) : void
        {
            this._isFilterImage = param1;
            return;
        }// end function

        private function initUI() : void
        {
            var _loc_1:Vector.<BarrageItem> = null;
            var _loc_3:uint = 0;
            var _loc_4:Vector.<BarrageInfoVO> = null;
            this._barrageItemOP = new ObjectPool();
            this._barrageInfoOP = new ObjectPool();
            this._barrageItemArray = new Array();
            var _loc_2:uint = 0;
            while (_loc_2 < SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM)
            {
                
                _loc_1 = new Vector.<BarrageItem>;
                this._barrageItemArray.push(_loc_1);
                _loc_2 = _loc_2 + 1;
            }
            this._bufferBIANone = new Array();
            _loc_3 = 0;
            while (_loc_3 < 4)
            {
                
                _loc_4 = new Vector.<BarrageInfoVO>;
                this._bufferBIANone.push(_loc_4);
                _loc_3 = _loc_3 + 1;
            }
            this._bufferBIANoneSocket = new Array();
            _loc_3 = 0;
            while (_loc_3 < 4)
            {
                
                _loc_4 = new Vector.<BarrageInfoVO>;
                this._bufferBIANoneSocket.push(_loc_4);
                _loc_3 = _loc_3 + 1;
            }
            this._bufferBIAStar = new Array();
            _loc_3 = 0;
            while (_loc_3 < 4)
            {
                
                _loc_4 = new Vector.<BarrageInfoVO>;
                this._bufferBIAStar.push(_loc_4);
                _loc_3 = _loc_3 + 1;
            }
            this._bufferBIARestar = new Array();
            _loc_3 = 0;
            while (_loc_3 < 4)
            {
                
                _loc_4 = new Vector.<BarrageInfoVO>;
                this._bufferBIARestar.push(_loc_4);
                _loc_3 = _loc_3 + 1;
            }
            this._selfSendBarrageInfoVec = new Vector.<BarrageInfoVO>;
            BarrageExpressionManager.instance.addEventListener(BarrageExpressionManager.EVENT_COMPLETE, this.onFaceLoadComplete);
            return;
        }// end function

        public function onAddStatus(param1:int) : void
        {
            this._status.addStatus(param1);
            switch(param1)
            {
                case SceneTileDef.STATUS_BARRAGE_OPEN:
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
                case SceneTileDef.STATUS_BARRAGE_OPEN:
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
            var _loc_3:BarrageItem = null;
            this._curRowNum = (param2 - BodyDef.VIDEO_BOTTOM_RESERVE - 20 * 2) / 60;
            this._curRowNum = this._curRowNum >= SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM ? (SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM) : (Math.floor(this._curRowNum));
            this._curRowNum = this._curRowNum <= SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM ? (SceneTileDef.BARRAGE_MIN_SHOW_ROW_NUM) : (Math.floor(this._curRowNum));
            var _loc_4:uint = 0;
            while (_loc_4 < this._barrageItemArray.length)
            {
                
                for each (_loc_3 in this._barrageItemArray[_loc_4])
                {
                    
                    if (_loc_3.row > this._curRowNum)
                    {
                        _loc_3.visible = false;
                    }
                    _loc_3.onResize(param1, param2);
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        override public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!isOnStage)
            {
                super.open(param1);
                dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ToolOpen));
            }
            return;
        }// end function

        override public function close() : void
        {
            if (isOnStage)
            {
                super.close();
                dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_ToolClose));
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

        public function onUserInfoChanged(param1:UserInfoVO) : void
        {
            this._userInfoVO = param1;
            return;
        }// end function

        public function hideAllBarrageItem(param1:Boolean) : void
        {
            var _loc_2:BarrageItem = null;
            var _loc_3:uint = 0;
            while (_loc_3 < this._barrageItemArray.length)
            {
                
                for each (_loc_2 in this._barrageItemArray[_loc_3])
                {
                    
                    _loc_2.visible = param1;
                    if (_loc_2.row > this._curRowNum)
                    {
                        _loc_2.visible = false;
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function updateAllBarrageItemAlpha(param1:uint) : void
        {
            var _loc_2:BarrageItem = null;
            var _loc_3:uint = 0;
            while (_loc_3 < this._barrageItemArray.length)
            {
                
                for each (_loc_2 in this._barrageItemArray[_loc_3])
                {
                    
                    _loc_2.updateAlpha(param1);
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function clearAllBarrageItem() : void
        {
            var _loc_1:BarrageItem = null;
            var _loc_3:Vector.<BarrageInfoVO> = null;
            var _loc_4:BarrageInfoVO = null;
            var _loc_2:uint = 0;
            while (_loc_2 < this._barrageItemArray.length)
            {
                
                while (this._barrageItemArray[_loc_2].length > 0)
                {
                    
                    _loc_1 = this._barrageItemArray[_loc_2].shift();
                    _loc_1.removeEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
                    _loc_1.removeEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
                    _loc_1.clear();
                    if (_loc_1 && _loc_1.parent)
                    {
                        _loc_1.parent.removeChild(_loc_1);
                    }
                    this._barrageItemOP.push(_loc_1);
                    this._barrageInfoOP.push(_loc_1.barrageInfo);
                }
                _loc_2 = _loc_2 + 1;
            }
            for each (_loc_3 in this._bufferBIANone)
            {
                
                while (_loc_3.length > 0)
                {
                    
                    _loc_4 = _loc_3.pop();
                    this._barrageInfoOP.push(_loc_4);
                }
            }
            for each (_loc_3 in this._bufferBIANoneSocket)
            {
                
                while (_loc_3.length > 0)
                {
                    
                    _loc_4 = _loc_3.pop();
                    this._barrageInfoOP.push(_loc_4);
                }
            }
            for each (_loc_3 in this._bufferBIAStar)
            {
                
                while (_loc_3.length > 0)
                {
                    
                    _loc_4 = _loc_3.pop();
                    this._barrageInfoOP.push(_loc_4);
                }
            }
            for each (_loc_3 in this._bufferBIARestar)
            {
                
                while (_loc_3.length > 0)
                {
                    
                    _loc_4 = _loc_3.pop();
                    this._barrageInfoOP.push(_loc_4);
                }
            }
            return;
        }// end function

        public function updateSelfBarrageInfo(param1:BarrageInfoVO) : void
        {
            this._selfSendBarrageInfoVec.push(param1);
            return;
        }// end function

        public function updateBufferBarrageInfo(param1:Vector.<BarrageInfoVO>, param2:Boolean = false) : void
        {
            var _loc_3:BarrageInfoVO = null;
            var _loc_5:uint = 0;
            if (param1 == null)
            {
                return;
            }
            this.checkBufferIsFull(this._bufferBIANone);
            this.checkBufferIsFull(this._bufferBIANoneSocket);
            this.checkBufferIsFull(this._bufferBIARestar);
            this.checkBufferIsFull(this._bufferBIAStar);
            var _loc_4:uint = 0;
            while (_loc_4 < param1.length)
            {
                
                _loc_3 = this._barrageInfoOP.pop() as BarrageInfoVO;
                if (_loc_3 == null)
                {
                    _loc_3 = new BarrageInfoVO();
                }
                _loc_3.update(param1[_loc_4].dataObj, param1[_loc_4].barrageSource);
                if (_loc_3.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
                {
                    this._bufferBIAStar[_loc_3.position].unshift(_loc_3);
                }
                else if (_loc_3.contentType == SceneTileDef.BARRAGE_CONTENT_TYPE_RESTAR)
                {
                    this._bufferBIARestar[_loc_3.position].unshift(_loc_3);
                }
                else if (param2)
                {
                    this._bufferBIANoneSocket[_loc_3.position].unshift(_loc_3);
                }
                else
                {
                    _loc_5 = _loc_3.position >= this._bufferBIANone.length ? (0) : (_loc_3.position);
                    this._bufferBIANone[_loc_5].unshift(_loc_3);
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        private function checkBufferIsFull(param1:Array) : void
        {
            var _loc_2:BarrageInfoVO = null;
            var _loc_4:Vector.<BarrageInfoVO> = null;
            var _loc_5:uint = 0;
            var _loc_6:Vector.<BarrageInfoVO> = null;
            var _loc_3:uint = 0;
            for each (_loc_4 in param1)
            {
                
                _loc_3 = _loc_3 + _loc_4.length;
            }
            if (_loc_3 >= SceneTileDef.BARRAGE_BUFFER_BARRAGEINFO_NUM)
            {
                _loc_5 = 0;
                for each (_loc_6 in param1)
                {
                    
                    while (_loc_6.length > SceneTileDef.BARRAGE_BUFFER_BARRAGEINFO_NUM / 2)
                    {
                        
                        _loc_2 = _loc_6.pop();
                        this._barrageInfoOP.push(_loc_2);
                        _loc_5 = _loc_5 + 1;
                    }
                }
                dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_BarrageDeleteInfo, _loc_5));
            }
            return;
        }// end function

        public function updateBarrageItemCoordinate(param1:Boolean) : void
        {
            var _loc_2:BarrageItem = null;
            var _loc_4:uint = 0;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_3:uint = 0;
            while (_loc_3 < this._barrageItemArray.length)
            {
                
                if (this._rollOverRow != (_loc_3 + 1))
                {
                    if (param1 && _loc_3 < SceneTileDef.BARRAGE_STAR_ROW_NUM)
                    {
                        _loc_5 = 0;
                        _loc_4 = 0;
                        while (_loc_4 < this._barrageItemArray[_loc_3].length)
                        {
                            
                            _loc_5 = _loc_5 + (this._barrageItemArray[_loc_3][_loc_4].width + SceneTileDef.BARRAGE_ITEM_GAP);
                            _loc_4 = _loc_4 + 1;
                        }
                        _loc_6 = (GlobalStage.stage.stageWidth - _loc_5) / 2;
                        _loc_4 = 0;
                        while (_loc_4 < this._barrageItemArray[_loc_3].length)
                        {
                            
                            if (_loc_5 >= GlobalStage.stage.stageWidth - SceneTileDef.BARRAGE_ITEM_GAP * 2)
                            {
                                _loc_5 = _loc_5 - (this._barrageItemArray[_loc_3][_loc_4].width + SceneTileDef.BARRAGE_ITEM_GAP);
                                _loc_6 = (GlobalStage.stage.stageWidth - _loc_5) / 2;
                                this._barrageItemArray[_loc_3][_loc_4].updateCoordinateOnStar();
                            }
                            else
                            {
                                this._barrageItemArray[_loc_3][_loc_4].updateCoordinateOnStar(_loc_6);
                                _loc_6 = _loc_6 + (this._barrageItemArray[_loc_3][_loc_4].width + SceneTileDef.BARRAGE_ITEM_GAP);
                            }
                            _loc_4 = _loc_4 + 1;
                        }
                    }
                    else
                    {
                        for each (_loc_2 in this._barrageItemArray[_loc_3])
                        {
                            
                            _loc_2.updateCoordinate();
                        }
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function checkAddBarrageItem(param1:Boolean, param2:uint, param3:Boolean) : void
        {
            var _loc_4:uint = 0;
            var _loc_5:Vector.<BarrageInfoVO> = null;
            if (this._selfSendBarrageInfoVec.length > 0)
            {
                _loc_4 = this.getRowByDisplayArea(this._selfSendBarrageInfoVec[0].position, param3);
                this.addBarrageItem(this._selfSendBarrageInfoVec, _loc_4, param2, param1, true, false, param3);
            }
            for each (_loc_5 in this._bufferBIAStar)
            {
                
                if (_loc_5.length > 0)
                {
                    _loc_4 = this.getRowByDisplayArea(_loc_5[0].position, param3, true);
                    this.addBarrageItem(_loc_5, _loc_4, param2, param1, false, this._isFilterImage, param3);
                }
            }
            for each (_loc_5 in this._bufferBIARestar)
            {
                
                if (_loc_5.length > 0)
                {
                    _loc_4 = this.getRowByDisplayArea(_loc_5[0].position, param3);
                    this.addBarrageItem(_loc_5, _loc_4, param2, param1, false, this._isFilterImage, param3);
                }
            }
            for each (_loc_5 in this._bufferBIANoneSocket)
            {
                
                if (_loc_5.length > 0)
                {
                    _loc_4 = this.getRowByDisplayArea(_loc_5[0].position, param3);
                    this.addBarrageItem(_loc_5, _loc_4, param2, param1, false, this._isFilterImage, param3);
                }
            }
            for each (_loc_5 in this._bufferBIANone)
            {
                
                if (_loc_5.length > 0)
                {
                    _loc_4 = this.getRowByDisplayArea(_loc_5[0].position, param3);
                    this.addBarrageItem(_loc_5, _loc_4, param2, param1, false, this._isFilterImage, param3);
                }
            }
            return;
        }// end function

        private function addBarrageItem(param1:Vector.<BarrageInfoVO>, param2:uint, param3:uint, param4:Boolean, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false) : void
        {
            var _loc_9:Number = NaN;
            var _loc_8:* = this._barrageItemArray[(param2 - 1)] as Vector.<BarrageItem>;
            if (_loc_8.length > 0)
            {
                _loc_9 = _loc_8[(_loc_8.length - 1)].x + _loc_8[(_loc_8.length - 1)].width;
                if (param7 && param2 <= SceneTileDef.BARRAGE_STAR_ROW_NUM)
                {
                    if (_loc_9 <= GlobalStage.stage.stageWidth - 100)
                    {
                        this.creatBarrageItem(param1, param2, param3, param4, param5, param6);
                    }
                }
                else if (_loc_9 <= GlobalStage.stage.stageWidth - 300)
                {
                    this.creatBarrageItem(param1, param2, param3, param4, param5, param6);
                }
            }
            else
            {
                this.creatBarrageItem(param1, param2, param3, param4, param5, param6);
            }
            return;
        }// end function

        private function creatBarrageItem(param1:Vector.<BarrageInfoVO>, param2:uint, param3:uint, param4:Boolean, param5:Boolean = false, param6:Boolean = false) : void
        {
            var _loc_7:* = this._barrageItemArray[(param2 - 1)] as Vector.<BarrageItem>;
            var _loc_8:* = this._barrageItemOP.pop() as BarrageItem;
            if (_loc_8 == null)
            {
                _loc_8 = new BarrageItem();
            }
            else
            {
                _loc_8.clear();
            }
            _loc_8.row = param2;
            _loc_8.isSelfSend = param5;
            _loc_8.isFilterImage = param6;
            _loc_8.preBarrageItem = _loc_7.length > 0 ? (_loc_7[(_loc_7.length - 1)]) : (null);
            _loc_8.barrageInfo = param1.shift();
            _loc_8.x = GlobalStage.stage.stageWidth - param2 * 10;
            _loc_8.updateAlpha(param3);
            _loc_8.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
            _loc_8.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
            _loc_8.addEventListener(MouseEvent.CLICK, this.onItemClick);
            _loc_8.visible = param4;
            addChild(_loc_8);
            _loc_7.push(_loc_8);
            return;
        }// end function

        public function checkRemoveBarrageItem() : void
        {
            var _loc_3:BarrageItem = null;
            var _loc_4:Number = NaN;
            var _loc_1:* = Math.ceil(Math.random() * SceneTileDef.BARRAGE_MAX_SHOW_ROW_NUM);
            var _loc_2:* = this._barrageItemArray[(_loc_1 - 1)] as Vector.<BarrageItem>;
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.length > 0)
            {
                _loc_4 = _loc_2[0].x + _loc_2[0].width;
                if (_loc_4 < -10)
                {
                    _loc_3 = _loc_2.shift();
                    _loc_3.removeEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
                    _loc_3.removeEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
                    _loc_3.clear();
                    if (_loc_3 && _loc_3.parent)
                    {
                        _loc_3.parent.removeChild(_loc_3);
                    }
                    this._barrageItemOP.push(_loc_3);
                    this._barrageInfoOP.push(_loc_3.barrageInfo);
                }
            }
            return;
        }// end function

        private function getRowByDisplayArea(param1:uint, param2:Boolean, param3:Boolean = false) : uint
        {
            var _loc_5:uint = 0;
            var _loc_4:uint = 0;
            switch(param1)
            {
                case SceneTileDef.BARRAGE_POSITION_NONE:
                {
                    break;
                }
                case SceneTileDef.BARRAGE_POSITION_UP:
                {
                    break;
                }
                case SceneTileDef.BARRAGE_POSITION_CENTRE:
                {
                    break;
                }
                case SceneTileDef.BARRAGE_POSITION_DOWN:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            switch(param1)
            {
                case SceneTileDef.BARRAGE_POSITION_NONE:
                {
                    break;
                }
                case SceneTileDef.BARRAGE_POSITION_UP:
                {
                    break;
                }
                case SceneTileDef.BARRAGE_POSITION_CENTRE:
                {
                    break;
                }
                case SceneTileDef.BARRAGE_POSITION_DOWN:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return _loc_4 <= 0 ? (1) : (_loc_4);
        }// end function

        private function onRollOver(event:MouseEvent) : void
        {
            var _loc_2:* = event.target as BarrageItem;
            if (_loc_2)
            {
                _loc_2.addDepictLayer();
                this._rollOverRow = _loc_2.row;
            }
            return;
        }// end function

        private function onRollOut(event:MouseEvent) : void
        {
            var _loc_2:* = event.target as BarrageItem;
            if (_loc_2)
            {
                _loc_2.removeDepictLayer();
            }
            this._rollOverRow = 0;
            return;
        }// end function

        private function onItemClick(event:MouseEvent) : void
        {
            var _loc_2:* = event.target as BarrageItem;
            if (_loc_2 && !_loc_2.isSelfSend)
            {
                dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_BarrageItemClick, _loc_2));
            }
            return;
        }// end function

        private function onFaceLoadComplete(event:Event) : void
        {
            return;
        }// end function

    }
}
