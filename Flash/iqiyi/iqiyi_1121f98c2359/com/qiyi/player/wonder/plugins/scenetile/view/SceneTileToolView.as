package com.qiyi.player.wonder.plugins.scenetile.view
{
    import com.iqiyi.components.global.*;
    import com.iqiyi.components.panelSystem.impls.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.toolpart.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import scenetile.*;

    public class SceneTileToolView extends BasePanel
    {
        private var _status:Status;
        private var _userInfoVO:UserInfoVO;
        private var _playBtn:PlayBtn;
        private var _loader:Loader;
        private var _imageContainer:Sprite;
        private var _starHeadContainer:Sprite;
        private var _panoramicTool:ToolPanoramicTool;
        private var _border:Shape;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.view.SceneTileToolView";

        public function SceneTileToolView(param1:DisplayObjectContainer, param2:Status, param3:UserInfoVO)
        {
            super(NAME, param1);
            this._status = param2;
            this._userInfoVO = param3;
            this.initUI();
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function get playBtn() : PlayBtn
        {
            return this._playBtn;
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
                case SceneTileDef.STATUS_TOOL_OPEN:
                {
                    this.open();
                    break;
                }
                case SceneTileDef.STATUS_PLAY_BTN_SHOW:
                {
                    addChild(this._playBtn);
                    break;
                }
                case SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW:
                {
                    addChild(this._panoramicTool);
                    this._panoramicTool.addEventListener(ToolPanoramicTool.POSE_TRIGGER, this.onPanoramicPoseTrigger);
                    break;
                }
                case SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW:
                {
                    this._starHeadContainer.visible = true;
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
                case SceneTileDef.STATUS_TOOL_OPEN:
                {
                    this.close();
                    break;
                }
                case SceneTileDef.STATUS_PLAY_BTN_SHOW:
                {
                    if (this._playBtn.parent)
                    {
                        this._playBtn.gotoAndStop(1);
                        removeChild(this._playBtn);
                    }
                    break;
                }
                case SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW:
                {
                    if (this._panoramicTool.parent)
                    {
                        removeChild(this._panoramicTool);
                        this._panoramicTool.removeEventListener(ToolPanoramicTool.POSE_TRIGGER, this.onPanoramicPoseTrigger);
                    }
                    break;
                }
                case SceneTileDef.STATUS_BARRAGE_STAR_HEAD_SHOW:
                {
                    this._starHeadContainer.visible = false;
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
            this._playBtn.x = 22;
            this._playBtn.y = param2 - 140;
            if (this._imageContainer != null)
            {
                this._imageContainer.width = GlobalStage.stage.stageWidth;
                this._imageContainer.height = GlobalStage.stage.stageHeight;
            }
            if (this._starHeadContainer)
            {
                this._starHeadContainer.x = param1 - this._starHeadContainer.numChildren * 55 - 120;
                this._starHeadContainer.y = param2 - 120;
            }
            if (GlobalStage.isFullScreen())
            {
                var _loc_3:Number = 1.5;
                this._panoramicTool.scaleY = 1.5;
                this._panoramicTool.scaleX = _loc_3;
            }
            else
            {
                var _loc_3:int = 1;
                this._panoramicTool.scaleY = 1;
                this._panoramicTool.scaleX = _loc_3;
            }
            return;
        }// end function

        public function updateStarHeadImage(param1:Object) : void
        {
            var _loc_2:ToolStarHeadImageItem = null;
            var _loc_3:Array = null;
            var _loc_4:ToolStarHeadImageItem = null;
            var _loc_5:int = 0;
            while (this._starHeadContainer.numChildren > 0)
            {
                
                _loc_2 = this._starHeadContainer.removeChildAt(0) as ToolStarHeadImageItem;
                _loc_2.destroy();
                _loc_2 = null;
            }
            if (param1 && param1.stars)
            {
                _loc_3 = param1.stars as Array;
                _loc_5 = 0;
                while (_loc_5 < _loc_3.length)
                {
                    
                    if (_loc_3[_loc_5].icon)
                    {
                        _loc_4 = new ToolStarHeadImageItem(_loc_3[_loc_5].icon, _loc_5);
                        _loc_4.x = _loc_5 * 55;
                        this._starHeadContainer.addChild(_loc_4);
                    }
                    _loc_5++;
                }
            }
            this.onResize(GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
            return;
        }// end function

        public function drawBorder() : void
        {
            this._border.graphics.clear();
            this._border.graphics.lineStyle(1, 1579032);
            this._border.graphics.moveTo(0, 0);
            this._border.graphics.lineTo((GlobalStage.stage.stageWidth - 1), 0);
            this._border.graphics.lineTo((GlobalStage.stage.stageWidth - 1), (GlobalStage.stage.stageHeight - 1));
            this._border.graphics.lineTo(0, (GlobalStage.stage.stageHeight - 1));
            this._border.graphics.lineTo(0, 0);
            return;
        }// end function

        public function clearBorder() : void
        {
            this._border.graphics.clear();
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

        private function initUI() : void
        {
            this._imageContainer = new Sprite();
            if (!FlashVarConfig.autoPlay)
            {
                addChild(this._imageContainer);
                this._imageContainer.graphics.beginFill(0);
                this._imageContainer.graphics.drawRect(0, 0, GlobalStage.stage.stageWidth, GlobalStage.stage.stageHeight);
                this._imageContainer.graphics.endFill();
                var _loc_2:Boolean = false;
                this._imageContainer.mouseChildren = false;
                this._imageContainer.mouseEnabled = _loc_2;
            }
            this._playBtn = new PlayBtn();
            var _loc_2:Boolean = true;
            this._playBtn.useHandCursor = true;
            this._playBtn.buttonMode = _loc_2;
            this._playBtn.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                _playBtn.gotoAndStop(2);
                return;
            }// end function
            );
            this._playBtn.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                _playBtn.gotoAndStop(1);
                return;
            }// end function
            );
            if (this._status.hasStatus(SceneTileDef.STATUS_PLAY_BTN_SHOW))
            {
                addChild(this._playBtn);
            }
            this._panoramicTool = new ToolPanoramicTool();
            this._panoramicTool.y = 40;
            this._panoramicTool.x = 20;
            if (this._status.hasStatus(SceneTileDef.STATUS_PANORAMIC_TOOL_SHOW))
            {
                addChild(this._panoramicTool);
            }
            this._starHeadContainer = new Sprite();
            var _loc_2:Boolean = false;
            this._starHeadContainer.mouseChildren = false;
            this._starHeadContainer.mouseEnabled = _loc_2;
            addChild(this._starHeadContainer);
            this._border = new Shape();
            GlobalStage.stage.addChild(this._border);
            return;
        }// end function

        public function requestUnAutoPlayImage() : void
        {
            if (FlashVarConfig.autoPlay || FlashVarConfig.imageUrl == "")
            {
                return;
            }
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError);
            this._loader.load(new URLRequest(FlashVarConfig.imageUrl));
            return;
        }// end function

        private function onComplete(event:Event) : void
        {
            if (isOnStage)
            {
                this._imageContainer.addChild(this._loader);
                this._loader.width = GlobalStage.stage.stageWidth;
                this._loader.height = GlobalStage.stage.stageHeight;
            }
            return;
        }// end function

        private function onIOError(event:Event) : void
        {
            return;
        }// end function

        public function destroyImageLoader() : void
        {
            if (this._imageContainer != null && this._imageContainer.parent)
            {
                this._imageContainer.graphics.clear();
                removeChild(this._imageContainer);
            }
            if (this._loader == null)
            {
                return;
            }
            if (this._loader.parent)
            {
                this._imageContainer.removeChild(this._loader);
            }
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
            this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onIOError);
            this._loader = null;
            return;
        }// end function

        private function onPanoramicPoseTrigger(event:Event) : void
        {
            dispatchEvent(new SceneTileEvent(SceneTileEvent.Evt_PanoramicToolClick, this._panoramicTool.movePoint));
            return;
        }// end function

    }
}
