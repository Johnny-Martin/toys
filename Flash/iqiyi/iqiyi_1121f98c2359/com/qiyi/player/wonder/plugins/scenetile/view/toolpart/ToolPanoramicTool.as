package com.qiyi.player.wonder.plugins.scenetile.view.toolpart
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class ToolPanoramicTool extends Sprite implements IDestroy
    {
        private var _radius:Number = 27;
        private var _upPose:Sprite;
        private var _downPose:Sprite;
        private var _leftPose:Sprite;
        private var _rightPose:Sprite;
        private var _movePoint:Point;
        private var _unitPoint:Point;
        private var _curPose:Sprite;
        private var _counter:int;
        private var _step:int = 2;
        private var _clickTime:int;
        public static const POSE_TRIGGER:String = "evtPoseTrigger";

        public function ToolPanoramicTool()
        {
            var _loc_1:Vector.<int> = null;
            var _loc_2:Vector.<Number> = null;
            graphics.clear();
            graphics.beginFill(15658734, 0.6);
            graphics.drawCircle(40, 40, this._radius);
            graphics.endFill();
            this._movePoint = new Point();
            this._unitPoint = new Point();
            _loc_1 = new Vector.<int>;
            _loc_1.push(GraphicsPathCommand.MOVE_TO);
            _loc_1.push(GraphicsPathCommand.LINE_TO);
            _loc_1.push(GraphicsPathCommand.LINE_TO);
            _loc_1.push(GraphicsPathCommand.LINE_TO);
            _loc_1.push(GraphicsPathCommand.LINE_TO);
            _loc_1.push(GraphicsPathCommand.LINE_TO);
            _loc_1.push(GraphicsPathCommand.LINE_TO);
            _loc_2 = this.Vector.<Number>([-10, 0, 0, -10, 10, 0, 5, 0, 0, -5, -5, 0, -10, 0]);
            this._upPose = this.createPose(_loc_1, _loc_2);
            this._upPose.x = 40;
            this._upPose.y = 26;
            this.drawHoverArea(this._upPose, Math.PI / 4, 0, 14);
            addChild(this._upPose);
            this._downPose = this.createPose(_loc_1, _loc_2, 1, -1);
            this._downPose.x = 40;
            this._downPose.y = 54;
            this.drawHoverArea(this._downPose, 5 * Math.PI / 4, 0, -14);
            addChild(this._downPose);
            _loc_2 = this.Vector.<Number>([0, -10, -10, 0, 0, 10, 0, 5, -5, 0, 0, -5, 0, -10]);
            this._leftPose = this.createPose(_loc_1, _loc_2);
            this._leftPose.x = 26;
            this._leftPose.y = 40;
            this.drawHoverArea(this._leftPose, 3 * Math.PI / 4, 14, 0);
            addChild(this._leftPose);
            this._rightPose = this.createPose(_loc_1, _loc_2, -1, 1);
            this._rightPose.x = 54;
            this._rightPose.y = 40;
            this.drawHoverArea(this._rightPose, (-Math.PI) / 4, -14, 0);
            addChild(this._rightPose);
            return;
        }// end function

        public function get movePoint() : Point
        {
            return this._movePoint;
        }// end function

        private function createPose(param1:Vector.<int>, param2:Vector.<Number>, param3:Number = 1, param4:Number = 1) : Sprite
        {
            var _loc_5:* = new Shape();
            _loc_5.graphics.clear();
            _loc_5.graphics.beginFill(0, 0.5);
            _loc_5.graphics.drawPath(param1, param2);
            _loc_5.graphics.endFill();
            _loc_5.scaleX = param3;
            _loc_5.scaleY = param4;
            var _loc_6:* = new Sprite();
            _loc_6.addChild(_loc_5);
            _loc_6.useHandCursor = true;
            _loc_6.buttonMode = true;
            _loc_6.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
            _loc_6.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
            _loc_6.addEventListener(MouseEvent.MOUSE_DOWN, this.onPoseDown);
            _loc_6.addEventListener(MouseEvent.MOUSE_UP, this.onPoseUp);
            return _loc_6;
        }// end function

        private function onRollOver(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget;
            switch(_loc_2)
            {
                case this._upPose:
                {
                    this.drawHoverArea(this._upPose, Math.PI / 4, 0, 14, 0.2);
                    break;
                }
                case this._downPose:
                {
                    this.drawHoverArea(this._downPose, 5 * Math.PI / 4, 0, -14, 0.2);
                    break;
                }
                case this._leftPose:
                {
                    this.drawHoverArea(this._leftPose, 3 * Math.PI / 4, 14, 0, 0.2);
                    break;
                }
                case this._rightPose:
                {
                    this.drawHoverArea(this._rightPose, (-Math.PI) / 4, -14, 0, 0.2);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onRollOut(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget;
            switch(_loc_2)
            {
                case this._upPose:
                {
                    this.drawHoverArea(this._upPose, Math.PI / 4, 0, 14);
                    break;
                }
                case this._downPose:
                {
                    this.drawHoverArea(this._downPose, 5 * Math.PI / 4, 0, -14);
                    break;
                }
                case this._leftPose:
                {
                    this.drawHoverArea(this._leftPose, 3 * Math.PI / 4, 14, 0);
                    break;
                }
                case this._rightPose:
                {
                    this.drawHoverArea(this._rightPose, (-Math.PI) / 4, -14, 0);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onPoseDown(event:MouseEvent) : void
        {
            this._counter = 0;
            this._clickTime = getTimer();
            this._curPose = event.currentTarget as Sprite;
            this._curPose.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            switch(this._curPose)
            {
                case this._upPose:
                {
                    this._unitPoint.x = 0;
                    this._unitPoint.y = 1;
                    break;
                }
                case this._downPose:
                {
                    this._unitPoint.x = 0;
                    this._unitPoint.y = -1;
                    break;
                }
                case this._leftPose:
                {
                    this._unitPoint.x = 1;
                    this._unitPoint.y = 0;
                    break;
                }
                case this._rightPose:
                {
                    this._unitPoint.x = -1;
                    this._unitPoint.y = 0;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onPoseUp(event:MouseEvent) : void
        {
            this._curPose = event.currentTarget as Sprite;
            this._curPose.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            if (getTimer() - this._clickTime < 300)
            {
                this._movePoint.x = this._unitPoint.x * (40 - int(this._counter / 2) * this._step);
                this._movePoint.y = this._unitPoint.y * (40 - int(this._counter / 2) * this._step);
                dispatchEvent(new Event(POSE_TRIGGER));
            }
            return;
        }// end function

        private function onEnterFrame(event:Event) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this._counter + 1;
            _loc_2._counter = _loc_3;
            if (this._counter % 2 == 0)
            {
                this._movePoint.x = this._unitPoint.x * this._step;
                this._movePoint.y = this._unitPoint.y * this._step;
                dispatchEvent(new Event(POSE_TRIGGER));
            }
            return;
        }// end function

        private function drawHoverArea(param1:Sprite, param2:Number, param3:int, param4:int, param5:Number = 0) : void
        {
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_6:* = Math.PI / 180;
            param1.graphics.clear();
            param1.graphics.beginFill(6523662, param5);
            param1.graphics.moveTo(param3, param4);
            var _loc_9:int = 0;
            while (_loc_9 < 90)
            {
                
                _loc_7 = param3 + this._radius * Math.cos(param2 + _loc_9 * _loc_6);
                _loc_8 = param4 - this._radius * Math.sin(param2 + _loc_9 * _loc_6);
                param1.graphics.lineTo(_loc_7, _loc_8);
                _loc_9++;
            }
            param1.graphics.lineTo(param3, param4);
            param1.graphics.endFill();
            return;
        }// end function

        public function destroy() : void
        {
            return;
        }// end function

    }
}
