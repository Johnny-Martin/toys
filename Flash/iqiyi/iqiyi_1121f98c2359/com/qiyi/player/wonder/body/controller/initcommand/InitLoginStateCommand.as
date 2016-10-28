package com.qiyi.player.wonder.body.controller.initcommand
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class InitLoginStateCommand extends SimpleCommand
    {

        public function InitLoginStateCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            if (FlashVarConfig.passportID)
            {
                _loc_2.isLogin = true;
                _loc_2.passportID = FlashVarConfig.passportID;
                _loc_2.P00001 = FlashVarConfig.P00001;
                _loc_2.profileID = FlashVarConfig.profileID;
                _loc_2.profileCookie = FlashVarConfig.profileCookie;
            }
            sendNotification(BodyDef.NOTIFIC_CHECK_USER);
            return;
        }// end function

    }
}
