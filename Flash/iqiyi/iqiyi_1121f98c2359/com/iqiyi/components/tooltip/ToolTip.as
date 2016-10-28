package com.iqiyi.components.tooltip
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    final public class ToolTip extends Object
    {
        private var _offest:Point;
        private var _toolTip:DisplayObject;
        private var _defaultToolTip:IDefaultToolTip;
        private var _timer:Timer;
        private var _targetedComponent:InteractiveObject;
        private var _table:Dictionary;
        private var _stage:Stage;
        private static var _instance:ToolTip;

        public function ToolTip(param1:SingletonClass)
        {
            this._timer = new Timer(0, 1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimeOnAction);
            this._table = new Dictionary();
            this._offest = new Point(4, 20);
            this.setDefaultToolTip(new DefaultToolTip());
            return;
        }// end function

        public function init(param1:Stage) : Boolean
        {
            if (this._stage == null)
            {
                this._stage = param1;
                this._stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onCompRollOut);
                return true;
            }
            return false;
        }// end function

        public function setDefaultToolTip(param1:IDefaultToolTip) : void
        {
            if (param1 && param1 is DisplayObject)
            {
                this._defaultToolTip = param1;
            }
            return;
        }// end function

        public function setOffest(param1:int, param2:int) : void
        {
            this._offest.x = param1;
            this._offest.y = param2;
            return;
        }// end function

        public function containsKey(param1:InteractiveObject) : Boolean
        {
            return this._table[param1] != undefined;
        }// end function

        public function isOnStage() : Boolean
        {
            return this._toolTip && this._toolTip.stage;
        }// end function

        public function updateTips(param1:InteractiveObject) : void
        {
            if (param1 != null && this.isOnStage() && this._targetedComponent == param1)
            {
                this.showTips();
            }
            return;
        }// end function

        public function registerComponent(param1:InteractiveObject, param2:Object = null, param3:int = 400, param4:Point = null) : void
        {
            var _loc_5:Info = null;
            if (param1 != null)
            {
                if (param2 == null)
                {
                    this.unregisterComponent(param1);
                }
                else if (!this.containsKey(param1))
                {
                    this.listenOwner(param1);
                    this._table[param1] = new Info(param2, param3, param4);
                }
                else
                {
                    _loc_5 = this._table[param1] as ;
                    _loc_5.showObject = param2;
                    _loc_5.timelag = param3;
                    _loc_5.fixedOffestPosition = param4;
                }
            }
            return;
        }// end function

        public function unregisterComponent(param1:InteractiveObject) : void
        {
            if (param1 && this.containsKey(param1))
            {
                this.unlistenOwner(param1);
                this._table[param1] = null;
                delete this._table[param1];
            }
            return;
        }// end function

        public function updateFixedOffestPosition(param1:InteractiveObject, param2:Point = null) : void
        {
            var _loc_3:Info = null;
            if (param1 != null)
            {
                if (this.containsKey(param1))
                {
                    _loc_3 = this._table[param1] as ;
                    _loc_3.fixedOffestPosition = param2;
                }
            }
            return;
        }// end function

        private function unlistenOwner(param1:InteractiveObject) : void
        {
            param1.removeEventListener(MouseEvent.ROLL_OVER, this.onCompRollOver);
            param1.removeEventListener(MouseEvent.ROLL_OUT, this.onCompRollOut);
            param1.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMoved);
            return;
        }// end function

        private function listenOwner(param1:InteractiveObject) : void
        {
            param1.addEventListener(MouseEvent.ROLL_OVER, this.onCompRollOver);
            param1.addEventListener(MouseEvent.ROLL_OUT, this.onCompRollOut);
            param1.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMoved);
            return;
        }// end function

        private function onTimeOnAction(event:TimerEvent) : void
        {
            this.showTips();
            return;
        }// end function

        private function onCompRollOver(event:MouseEvent) : void
        {
            var _loc_2:Info = null;
            if (this.containsKey(event.target as InteractiveObject))
            {
                this._targetedComponent = event.target as InteractiveObject;
                _loc_2 = this._table[this._targetedComponent] as ;
                if (_loc_2.timelag > 0)
                {
                    this._timer.delay = _loc_2.timelag;
                    if (!this._timer.running)
                    {
                        this._timer.start();
                    }
                }
                else
                {
                    this.showTips();
                }
            }
            return;
        }// end function

        private function onCompRollOut(event:MouseEvent) : void
        {
            if (this._timer.running)
            {
                this._timer.stop();
            }
            if (this._toolTip)
            {
                if (this._stage.contains(this._toolTip))
                {
                    this._stage.removeChild(this._toolTip);
                }
                this._targetedComponent = null;
                this._toolTip = null;
            }
            return;
        }// end function

        private function onMouseMoved(event:MouseEvent) : void
        {
            if (this._toolTip)
            {
                this.updateCoord();
            }
            return;
        }// end function

        private function updateCoord() : void
        {
            var _loc_1:Info = null;
            var _loc_2:Point = null;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            if (this.isOnStage() && this._targetedComponent)
            {
                _loc_1 = this._table[this._targetedComponent] as ;
                _loc_2 = null;
                if (_loc_1 && _loc_1.fixedOffestPosition && this._targetedComponent.parent)
                {
                    _loc_2 = new Point(_loc_1.fixedOffestPosition.x + this._targetedComponent.x, _loc_1.fixedOffestPosition.y + this._targetedComponent.y);
                    _loc_2 = this._targetedComponent.parent.localToGlobal(_loc_2);
                    this._toolTip.x = _loc_2.x;
                    this._toolTip.y = _loc_2.y;
                }
                else
                {
                    _loc_3 = this._stage.stageWidth;
                    _loc_4 = this._stage.stageHeight;
                    _loc_2 = new Point(this._stage.mouseX, this._stage.mouseY);
                    _loc_2.x = _loc_2.x + this._offest.x;
                    _loc_2.y = _loc_2.y + this._offest.y;
                    if (_loc_2.x + this._toolTip.width > _loc_3)
                    {
                        _loc_2.x = _loc_2.x - (this._toolTip.width + this._offest.x * 2);
                    }
                    if (_loc_2.y + this._toolTip.height > _loc_4)
                    {
                        _loc_2.y = _loc_2.y - (this._toolTip.height + this._offest.y + this._offest.x);
                    }
                    if (_loc_2.x < 0)
                    {
                        _loc_2.x = 0;
                    }
                    if (_loc_2.y < 0)
                    {
                        _loc_2.y = 0;
                    }
                    _loc_2 = this._stage.globalToLocal(_loc_2);
                    this._toolTip.x = _loc_2.x;
                    this._toolTip.y = _loc_2.y;
                }
            }
            return;
        }// end function

        private function showTips() : void
        {
            var _loc_1:Info = null;
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            if (this._targetedComponent && this.containsKey(this._targetedComponent) && this._stage)
            {
                _loc_1 = this._table[this._targetedComponent] as ;
                _loc_2 = _loc_1.showObject;
                _loc_3 = null;
                this._defaultToolTip.text = "";
                if (this._toolTip)
                {
                    if (this._stage.contains(this._toolTip))
                    {
                        this._stage.removeChild(this._toolTip);
                    }
                    this._toolTip = null;
                }
                if (_loc_2 is DisplayObject)
                {
                    this._toolTip = _loc_2 as DisplayObject;
                }
                else
                {
                    if (_loc_2 is String)
                    {
                        if (String(_loc_2) == "")
                        {
                            return;
                        }
                        this._defaultToolTip.htmlText = String(_loc_2);
                    }
                    else if (_loc_2 is Function)
                    {
                        _loc_3 = this._loc_2();
                        if (_loc_3 is DisplayObject)
                        {
                            this._toolTip = _loc_3 as DisplayObject;
                        }
                        else if (_loc_3 is String)
                        {
                            if (String(_loc_3) == "")
                            {
                                return;
                            }
                            this._defaultToolTip.htmlText = String(_loc_3);
                        }
                    }
                    if (this._toolTip == null)
                    {
                        this._toolTip = this._defaultToolTip as DisplayObject;
                    }
                }
                this._stage.addChild(this._toolTip);
                this.updateCoord();
            }
            return;
        }// end function

        public static function getInstance() : ToolTip
        {
            if (_instance == null)
            {
                _instance = new ToolTip(new SingletonClass());
            }
            return _instance;
        }// end function

    }
}

class Info extends Object
{
    public var showObject:Object;
    public var timelag:int;
    public var fixedOffestPosition:Point;

    function Info(param1:Object = null, param2:int = 400, param3:Point = null)
    {
        this.showObject = param1;
        this.timelag = param2;
        this.fixedOffestPosition = param3;
        return;
    }// end function

}


class SingletonClass extends Object
{

    function SingletonClass()
    {
        return;
    }// end function

}

