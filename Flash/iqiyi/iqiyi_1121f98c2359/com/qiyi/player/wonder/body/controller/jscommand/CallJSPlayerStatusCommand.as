package com.qiyi.player.wonder.body.controller.jscommand
{
    import com.qiyi.player.wonder.body.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class CallJSPlayerStatusCommand extends SimpleCommand
    {

        public function CallJSPlayerStatusCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_3:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_3.callJsPlayerStateChange(param1.getBody() as String, _loc_2.curActor.loadMovieParams.tvid, _loc_2.curActor.loadMovieParams.vid);
            return;
        }// end function

    }
}
