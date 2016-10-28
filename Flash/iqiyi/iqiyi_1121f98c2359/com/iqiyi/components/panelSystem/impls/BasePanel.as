package com.iqiyi.components.panelSystem.impls
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class BasePanel extends Sprite implements IPanel
    {
        private var _type:int;
        private var _name:String;
        private var _defaultContainer:DisplayObjectContainer;
        private var _hasCover:Boolean;
        private var _coverArea:Rectangle;
        private var _cover:Sprite;
        protected var _stage:Stage;

        public function BasePanel(param1:String, param2:DisplayObjectContainer)
        {
            this._name = param1;
            this._defaultContainer = param2;
            this._stage = stage;
            this._cover = this.createCover();
            addEventListener(Event.ADDED_TO_STAGE, this.onAddToStageHandler);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoveFromStageHandler);
            return;
        }// end function

        public function get type() : int
        {
            return this._type;
        }// end function

        public function set type(param1:int) : void
        {
            this._type = param1;
            return;
        }// end function

        override public function get name() : String
        {
            return this._name;
        }// end function

        public function get isOpen() : Boolean
        {
            return parent != null;
        }// end function

        public function get isOnStage() : Boolean
        {
            return stage != null;
        }// end function

        public function get hasCover() : Boolean
        {
            return this._hasCover;
        }// end function

        public function set hasCover(param1:Boolean) : void
        {
            if (this._hasCover != param1)
            {
                this._hasCover = param1;
                if (this.isOpen && this._cover)
                {
                    if (this._hasCover)
                    {
                        parent.addChildAt(this._cover, parent.getChildIndex(this));
                    }
                    else
                    {
                        parent.removeChild(this._cover);
                    }
                }
            }
            return;
        }// end function

        public function open(param1:DisplayObjectContainer = null) : void
        {
            if (!this.isOpen)
            {
                if (param1)
                {
                    if (this._hasCover && this._cover)
                    {
                        param1.addChild(this._cover);
                    }
                    param1.addChild(this);
                }
                else
                {
                    if (this._hasCover && this._cover)
                    {
                        this._defaultContainer.addChild(this._cover);
                    }
                    this._defaultContainer.addChild(this);
                }
            }
            return;
        }// end function

        public function close() : void
        {
            if (this.isOpen)
            {
                if (this._hasCover && this._cover)
                {
                    parent.removeChild(this._cover);
                }
                parent.removeChild(this);
            }
            return;
        }// end function

        public function toTop() : void
        {
            if (parent)
            {
                if (this._hasCover && this._cover)
                {
                    parent.setChildIndex(this._cover, (parent.numChildren - 1));
                }
                parent.setChildIndex(this, (parent.numChildren - 1));
            }
            return;
        }// end function

        public function toBottom() : void
        {
            if (parent)
            {
                parent.setChildIndex(this, 0);
                if (this._hasCover && this._cover)
                {
                    parent.setChildIndex(this._cover, 0);
                }
            }
            return;
        }// end function

        public function setPosition(param1:int, param2:int) : void
        {
            x = param1;
            y = param2;
            return;
        }// end function

        public function setSize(param1:int, param2:int) : void
        {
            return;
        }// end function

        public function setCoverArea(param1:Rectangle) : void
        {
            if (param1)
            {
                this._coverArea = param1;
                if (this._cover)
                {
                    this._cover.x = param1.x;
                    this._cover.y = param1.y;
                    this._cover.width = param1.width;
                    this._cover.height = param1.height;
                }
            }
            return;
        }// end function

        protected function createCover() : Sprite
        {
            var _loc_1:* = new Sprite();
            _loc_1.graphics.beginFill(0, 0.4);
            _loc_1.graphics.drawRect(0, 0, 1, 1);
            _loc_1.graphics.endFill();
            return _loc_1;
        }// end function

        protected function onAddToStage() : void
        {
            return;
        }// end function

        protected function onRemoveFromStage() : void
        {
            return;
        }// end function

        private function onAddToStageHandler(event:Event) : void
        {
            this._stage = stage;
            this.onAddToStage();
            return;
        }// end function

        private function onRemoveFromStageHandler(event:Event) : void
        {
            this.onRemoveFromStage();
            return;
        }// end function

        public function destroy() : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddToStageHandler);
            removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemoveFromStageHandler);
            if (this.isOpen)
            {
                parent.removeChild(this);
            }
            if (this._cover && this._cover.parent)
            {
                this._cover.parent.removeChild(this._cover);
            }
            return;
        }// end function

    }
}
