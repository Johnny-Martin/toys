package com.qiyi.player.user.impls
{
    import com.qiyi.player.user.*;
    import flash.events.*;

    public class UserManager extends EventDispatcher
    {
        private var _currentUser:User;
        private var _tmpUser:User;
        private var _userLocalSex:UserLocalSex;
        private static var _instance:UserManager;

        public function UserManager(param1:SingletonClass)
        {
            this._userLocalSex = new UserLocalSex();
            return;
        }// end function

        public function get user() : IUser
        {
            return this._currentUser;
        }// end function

        public function get userLocalSex() : UserLocalSex
        {
            return this._userLocalSex;
        }// end function

        public function login(param1:String, param2:String, param3:String = "", param4:String = "", param5:String = "", param6:Boolean = true) : void
        {
            this.destroyUser();
            this._tmpUser = new User(param1, param2, param3, param4, param5, param6);
            this._tmpUser.addEventListener(UserManagerEvent.Evt_LoginSuccess, this.onLoginSuccess);
            this._tmpUser.checkUser();
            return;
        }// end function

        public function logout() : void
        {
            var _loc_1:* = this._currentUser != null;
            this.destroyUser();
            if (_loc_1)
            {
                dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LogoutSuccess));
            }
            return;
        }// end function

        private function destroyUser() : void
        {
            if (this._currentUser)
            {
                this._currentUser.removeEventListener(UserManagerEvent.Evt_LoginSuccess, this.onLoginSuccess);
                this._currentUser.destroy();
            }
            else if (this._tmpUser)
            {
                this._tmpUser.removeEventListener(UserManagerEvent.Evt_LoginSuccess, this.onLoginSuccess);
                this._tmpUser.destroy();
            }
            this._currentUser = null;
            this._tmpUser = null;
            return;
        }// end function

        private function onLoginSuccess(event:UserManagerEvent) : void
        {
            this._currentUser = this._tmpUser;
            this._tmpUser = null;
            dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LoginSuccess));
            return;
        }// end function

        public static function getInstance() : UserManager
        {
            if (_instance == null)
            {
                _instance = new UserManager(new SingletonClass());
            }
            return _instance;
        }// end function

    }
}

class SingletonClass extends Object
{

    function SingletonClass()
    {
        return;
    }// end function

}

