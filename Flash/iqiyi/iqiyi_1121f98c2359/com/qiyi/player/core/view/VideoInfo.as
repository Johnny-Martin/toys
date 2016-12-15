package com.qiyi.player.core.view
{
    import com.qiyi.player.components.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.player.events.*;
    import com.qiyi.player.core.video.def.*;
    import com.qiyi.player.core.video.engine.*;
    import com.qiyi.player.core.video.engine.dm.provider.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;

    public class VideoInfo extends Sprite
    {
        private var _player:IPlayer;
        private var _engine:IEngine;
        private var _parent:DisplayObjectContainer;
        private var _frameCount:Number = 0;
        private var _infoTF:TextField;
        private var _blockBar:Shape;
        private var _blockBarW:int;
        private var _blockBarH:int;
        private var _rate:Dictionary;

        public function VideoInfo(param1:IPlayer, param2:DisplayObjectContainer)
        {
            var md:MediaDota;
            var $player:* = param1;
            var $parent:* = param2;
            this._rate = new Dictionary();
            if ($player && $parent)
            {
                this._player = $player;
                this._parent = $parent;
                this._player.addEventListener(PlayerEvent.Evt_StatusChanged, this.onStatusChanged);
                this._player.addEventListener(PlayerEvent.Evt_RenderAreaChanged, this.onVideoResized);
                md;
            }
            this._rate[DefinitionEnum.LIMIT] = "D0";
            this._rate[DefinitionEnum.STANDARD] = "D1";
            this._rate[DefinitionEnum.HIGH] = "D2";
            this._rate[DefinitionEnum.SUPER] = "D3";
            this._rate[DefinitionEnum.SUPER_HIGH] = "P1";
            this._rate[DefinitionEnum.FULL_HD] = "P2";
            this._rate[DefinitionEnum.FOUR_K] = "K1";
            var bg:* = new MovieInfoBg();
            bg.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                hide();
                return;
            }// end function
            );
            bg.alpha = 0.5;
            addChild(bg);
            this._infoTF = new TextField();
            this._infoTF.wordWrap = true;
            this._infoTF.multiline = true;
            this._infoTF.selectable = false;
            this._infoTF.mouseEnabled = false;
            this._infoTF.x = 5;
            this._infoTF.y = 5;
            this._infoTF.width = bg.width - this._infoTF.x * 2;
            this._infoTF.height = bg.height - this._infoTF.y * 2;
            var textFormat:* = new TextFormat();
            textFormat.size = 11;
            textFormat.color = 13421772;
            textFormat.leading = 2;
            textFormat.font = "Arial";
            this._infoTF.defaultTextFormat = textFormat;
            addChild(this._infoTF);
            var closeBtn:* = new MovieInfoCloseBtn();
            closeBtn.x = bg.width - closeBtn.width - 6;
            closeBtn.y = 6;
            closeBtn.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                hide();
                return;
            }// end function
            );
            addChild(closeBtn);
            var blockBarBg:* = new Shape();
            blockBarBg.x = 5;
            blockBarBg.y = bg.height - 15;
            addChild(blockBarBg);
            this._blockBar = new Shape();
            this._blockBar.x = blockBarBg.x;
            this._blockBar.y = blockBarBg.y;
            addChild(this._blockBar);
            this._blockBarW = bg.width - this._blockBar.x * 2;
            this._blockBarH = 4;
            blockBarBg.graphics.beginFill(13421772, 0.3);
            blockBarBg.graphics.drawRect(0, 0, this._blockBarW, this._blockBarH);
            blockBarBg.graphics.endFill();
            var cm:* = new ContextMenu();
            cm.hideBuiltInItems();
            contextMenu = cm;
            return;
        }// end function

        public function bind(param1:IEngine) : void
        {
            this._engine = param1;
            return;
        }// end function

        public function show() : void
        {
            if (this._player && this._parent && this._parent.stage)
            {
                if (!this._player.hasStatus(StatusEnum.STOPPING) && !this._player.hasStatus(StatusEnum.STOPED) && !this._player.hasStatus(StatusEnum.IDLE) && !this._player.hasStatus(StatusEnum.FAILED))
                {
                    this._parent.stage.addChild(this);
                    this.adjust();
                    addEventListener(Event.ENTER_FRAME, this.onEnterFrameHandler);
                }
            }
            return;
        }// end function

        public function hide() : void
        {
            if (parent)
            {
                this._infoTF.text = "";
                parent.removeChild(this);
                removeEventListener(Event.ENTER_FRAME, this.onEnterFrameHandler);
            }
            return;
        }// end function

        private function onStatusChanged(event:PlayerEvent) : void
        {
            if (this._player.hasStatus(StatusEnum.STOPPING) || this._player.hasStatus(StatusEnum.STOPED) || this._player.hasStatus(StatusEnum.IDLE) || this._player.hasStatus(StatusEnum.FAILED))
            {
                this.hide();
            }
            return;
        }// end function

        private function onVideoResized(event:PlayerEvent) : void
        {
            this.adjust();
            return;
        }// end function

        private function adjust() : void
        {
            var _loc_1:Rectangle = null;
            var _loc_2:Point = null;
            if (this._parent && parent)
            {
                if (this._player)
                {
                    _loc_1 = this._player.realArea;
                    if (_loc_1)
                    {
                        _loc_2 = this._parent.localToGlobal(new Point(_loc_1.x, _loc_1.y));
                        x = _loc_2.x + 5;
                        y = _loc_2.y + 25;
                    }
                    else
                    {
                        this.hide();
                    }
                }
                else
                {
                    this.hide();
                }
            }
            return;
        }// end function

        private function onEnterFrameHandler(event:Event) : void
        {
            var _loc_2:String = this;
            _loc_2._frameCount = this._frameCount + 1;
            if (++this._frameCount % 7 == 0 && this._player)
            {
                if (this._player is ICorePlayer)
                {
                    this.drawNormalBar();
                }
                this.buildText();
            }
            return;
        }// end function

        private function buildText() : void
        {
            if (this._player == null || this._player.movieModel == null)
            {
                return;
            }
            var _loc_1:* = this._player.movieModel as IMovie;
            var _loc_2:String = "";
            _loc_2 = _loc_2 + (_loc_1.width + " x " + _loc_1.height);
            if (_loc_1.curDefinition)
            {
                _loc_2 = _loc_2 + (", " + this._rate[_loc_1.curDefinition.type]);
            }
            _loc_2 = _loc_2 + (", " + Settings.instance.volumn + "% volume");
            _loc_2 = _loc_2 + "\n";
            _loc_2 = _loc_2 + (int(this._player.currentSpeed / 1024) + " kbps");
            _loc_2 = _loc_2 + (", " + this._player.frameRate + " fps");
            _loc_2 = _loc_2 + "\n";
            if (_loc_1.streamType == StreamEnum.HTTP)
            {
                _loc_2 = _loc_2 + "HTTP stream ( DGM )";
            }
            else
            {
                _loc_2 = _loc_2 + "RTMP stream";
            }
            _loc_2 = _loc_2 + "\n";
            switch(this._player.accStatus)
            {
                case VideoAccEnum.GPU_ACCELERATED:
                {
                    _loc_2 = _loc_2 + "accelerated video rendering";
                    _loc_2 = _loc_2 + "\n";
                    _loc_2 = _loc_2 + "accelerated video decoding";
                    break;
                }
                case VideoAccEnum.GPU_RENDERING:
                {
                    _loc_2 = _loc_2 + "accelerated video rendering";
                    _loc_2 = _loc_2 + "\n";
                    _loc_2 = _loc_2 + "software video decoding";
                    break;
                }
                case VideoAccEnum.CPU_ACCELERATED:
                {
                    _loc_2 = _loc_2 + "software video rendering";
                    _loc_2 = _loc_2 + "\n";
                    _loc_2 = _loc_2 + "accelerated video decoding";
                    break;
                }
                case VideoAccEnum.CPU_SOFTWARE:
                {
                    _loc_2 = _loc_2 + "software video rendering";
                    _loc_2 = _loc_2 + "\n";
                    _loc_2 = _loc_2 + "software video decoding";
                    break;
                }
                default:
                {
                    _loc_2 = _loc_2 + "unknown video rendering";
                    _loc_2 = _loc_2 + "\n";
                    _loc_2 = _loc_2 + "unknown video decoding";
                    break;
                    break;
                }
            }
            this._infoTF.text = _loc_2;
            return;
        }// end function

        private function drawNormalBar() : void
        {
            this._blockBar.graphics.clear();
            if (this._player == null || this._player.movieModel == null || isNaN(this._player.movieModel.duration))
            {
                return;
            }
            var _loc_1:* = this._player.movieModel.duration;
            if (_loc_1 == 0)
            {
                return;
            }
            var _loc_2:* = this._player.bufferTime / _loc_1 * this._blockBarW;
            this._blockBar.graphics.beginFill(13421772);
            this._blockBar.graphics.drawRect(0, 0, _loc_2, this._blockBarH);
            this._blockBar.graphics.endFill();
            return;
        }// end function

        public function destroy() : void
        {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrameHandler);
            if (parent)
            {
                parent.removeChild(this);
            }
            if (this._player)
            {
                this._player.removeEventListener(PlayerEvent.Evt_StatusChanged, this.onStatusChanged);
                this._player.removeEventListener(PlayerEvent.Evt_RenderAreaChanged, this.onVideoResized);
            }
            this._player = null;
            this._parent = null;
            this._engine = null;
            return;
        }// end function

    }
}
