package com.qiyi.player.wonder.plugins.feedback.view.parts.copyrightlimited
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;

    public class TriangleBtn extends Sprite
    {
        private var _hypotenuse:Number;
        private var _enable:Boolean;
        private var _vertices:Vector.<Number>;
        private var _color:uint;
        public static const FACE_UP:int = 0;
        public static const FACE_DOWN:int = 1;
        public static const FACE_LEFT:int = 2;
        public static const FACE_RIGHT:int = 3;

        public function TriangleBtn(param1:Number, param2:int = 2, param3:Boolean = true)
        {
            buttonMode = true;
            this._hypotenuse = param1;
            switch(param2)
            {
                case FACE_UP:
                {
                    this._vertices = this.Vector.<Number>([0, this._hypotenuse / 2, this._hypotenuse, this._hypotenuse / 2, this._hypotenuse / 2, 0]);
                    break;
                }
                case FACE_DOWN:
                {
                    this._vertices = this.Vector.<Number>([0, 0, 0, this._hypotenuse, this._hypotenuse / 2, this._hypotenuse / 2]);
                    break;
                }
                case FACE_LEFT:
                {
                    this._vertices = this.Vector.<Number>([0, this._hypotenuse / 2, this._hypotenuse / 2, 0, this._hypotenuse / 2, this._hypotenuse]);
                    break;
                }
                case FACE_RIGHT:
                {
                    this._vertices = this.Vector.<Number>([0, 0, this._hypotenuse / 2, this._hypotenuse / 2, 0, this._hypotenuse]);
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.enable = param3;
            return;
        }// end function

        public function get enable() : Boolean
        {
            return this._enable;
        }// end function

        public function set enable(param1:Boolean) : void
        {
            this._enable = param1;
            if (this._enable)
            {
                addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
                this._color = 16777215;
                this.drawUI(16777215);
            }
            else
            {
                removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
                removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
                this._color = 10066329;
                this.drawUI(10066329);
            }
            return;
        }// end function

        private function drawUI(param1:uint) : void
        {
            graphics.clear();
            graphics.beginFill(param1);
            graphics.drawTriangles(this._vertices);
            graphics.endFill();
            return;
        }// end function

        private function onMouseOver(event:MouseEvent) : void
        {
            this._color = 10066329;
            this.drawUI(8562957);
            return;
        }// end function

        private function onMouseOut(event:MouseEvent) : void
        {
            if (this._color != 16777215)
            {
                this.drawUI(16777215);
            }
            return;
        }// end function

    }
}
