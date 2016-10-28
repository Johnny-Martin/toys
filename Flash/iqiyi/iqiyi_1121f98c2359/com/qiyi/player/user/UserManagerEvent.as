package com.qiyi.player.user
{
    import flash.events.*;

    public class UserManagerEvent extends Event
    {
        private var _code:String;
        public static const Evt_LoginSuccess:String = "loginSuccess";
        public static const Evt_LoginFailed:String = "loginFailed";
        public static const Evt_LogoutSuccess:String = "logoutSuccess";
        public static const Evt_LogoutFailed:String = "logoutFailed";
        public static const Evt_LocalSexInitComplete:String = "localSexInitComplete";

        public function UserManagerEvent(param1:String, param2:String = "", param3:Boolean = false, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this._code = param2;
            return;
        }// end function

        public function get code() : String
        {
            return this._code;
        }// end function

    }
}
