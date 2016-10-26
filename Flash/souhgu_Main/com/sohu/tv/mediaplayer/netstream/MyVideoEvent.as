package com.sohu.tv.mediaplayer.netstream
{
    import flash.events.*;

    public class MyVideoEvent extends Event
    {
        public var param:Object;

        public function MyVideoEvent(param1:String, param2:Object = null)
        {
            this.param = param2;
            super(param1);
            return;
        }// end function

    }
}
