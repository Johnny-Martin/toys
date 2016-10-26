package com.sohu.tv.mediaplayer.ui
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import flash.display.*;
    import flash.events.*;

    public class RetryPanel extends TvSohuPanel
    {
        public static const RETRY:String = "retry";

        public function RetryPanel(param1:MovieClip)
        {
            _owner = this;
            super(param1);
            this.addEvent();
            return;
        }// end function

        private function addEvent() : void
        {
            _skin.close_btn.addEventListener(MouseEvent.MOUSE_UP, close);
            _skin.retry_btn.addEventListener(MouseEvent.MOUSE_UP, function (event:MouseEvent) : void
            {
                close();
                dispatchEvent(new Event(RETRY));
                return;
            }// end function
            );
            _skin.feedback_btn.addEventListener(MouseEvent.MOUSE_UP, function (event:MouseEvent) : void
            {
                if (!PlayerConfig.isPartner)
                {
                    ErrorSenderPQ.getInstance().sendFeedback();
                }
                return;
            }// end function
            );
            return;
        }// end function

    }
}
