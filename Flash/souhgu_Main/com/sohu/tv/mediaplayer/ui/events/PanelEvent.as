package com.sohu.tv.mediaplayer.ui.events
{
    import flash.events.*;

    public class PanelEvent extends Event
    {
        public var lightVal:Number = 0;
        public var contrastVal:Number = 0;
        public var scaleRate:Number;
        public var rotateVal:Number;
        public var toStgVd:Boolean = false;
        public static const READY:String = "READY";
        public static const INITED:String = "INITED";
        public static const CLOSED:String = "CLOSED";
        public static const OPEN_LIKE_PANEL:String = "OPEN_LIKE_PANEL";
        public static const LIGHT_VAL_CHANGE:String = "LIGHT_VAL_CHANGE";
        public static const CONTRAST_VAL_CHANGE:String = "CONTRAST_VAL_CHANGE";
        public static const SCALE_SELECTED:String = "SCALE_SELECTED";
        public static const ROTATE_SCR:String = "ROTATE_SCR";
        public static const ACCELERATED_CHANGE:String = "ACCELERATED_CHANGE";

        public function PanelEvent(param1:String, param2:Boolean = true, param3:Boolean = false)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new PanelEvent(type, bubbles, cancelable);
            _loc_1.lightVal = this.lightVal;
            _loc_1.contrastVal = this.contrastVal;
            _loc_1.scaleRate = this.scaleRate;
            _loc_1.rotateVal = this.rotateVal;
            _loc_1.toStgVd = this.toStgVd;
            return _loc_1;
        }// end function

    }
}
