package com.qiyi.player.base.rpc
{
    import flash.events.*;

    public class RemoteObjectEvent extends Event
    {
        private var _data:Object;
        public static const Evt_Retry:String = "retry";
        public static const Evt_Exception:String = "exception";
        public static const Evt_StatusChanged:String = "changed";

        public function RemoteObjectEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this._data = param2;
            return;
        }// end function

        public function get data() : Object
        {
            return this._data;
        }// end function

        override public function clone() : Event
        {
            return new RemoteObjectEvent(type, this.data, bubbles, cancelable);
        }// end function

    }
}
