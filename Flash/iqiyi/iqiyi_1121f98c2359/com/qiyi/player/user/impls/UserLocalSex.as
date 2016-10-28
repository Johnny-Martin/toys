package com.qiyi.player.user.impls
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.user.*;
    import flash.events.*;
    import flash.net.*;

    public class UserLocalSex extends EventDispatcher
    {
        private const COMMON_COOKIE_NAME:String = "qiyi_player_common";
        private const SO_TIMEOUT_TIME:int = 604800;
        private var _sex:int;
        private var _state:int;
        private var _userLocalSexRemote:UserLocalSexRemote;
        private var _SO:SharedObject;
        private var _log:ILogger;

        public function UserLocalSex()
        {
            this._sex = UserDef.USER_SEX_NONE;
            this._state = UserDef.USER_LOCAL_SEX_STATE_NONE;
            this._log = Log.getLogger("com.qiyi.player.user.impls.UserLocalSex");
            return;
        }// end function

        public function get state() : int
        {
            return this._state;
        }// end function

        public function load() : void
        {
            var _loc_1:int = 0;
            var _loc_2:uint = 0;
            var _loc_3:Date = null;
            var _loc_4:uint = 0;
            var _loc_5:String = null;
            if (this._state == UserDef.USER_LOCAL_SEX_STATE_NONE)
            {
                _loc_1 = -1;
                _loc_2 = 0;
                try
                {
                    if (this._SO == null)
                    {
                        this._SO = SharedObject.getLocal(this.COMMON_COOKIE_NAME, "/");
                    }
                    if (this._SO.size > 0)
                    {
                        if (this._SO.data.user_localSex != undefined && this._SO.data.user_localSexSaveTime != undefined)
                        {
                            _loc_1 = this._SO.data.user_localSex;
                            _loc_2 = this._SO.data.user_localSexSaveTime;
                        }
                    }
                }
                catch (e:Error)
                {
                }
                _loc_3 = new Date();
                _loc_4 = _loc_3.time / 1000;
                if (_loc_1 >= UserDef.USER_SEX_BEGIN && _loc_1 < UserDef.USER_SEX_END && _loc_1 != UserDef.USER_SEX_NONE && _loc_4 - _loc_2 < this.SO_TIMEOUT_TIME)
                {
                    this._sex = _loc_1;
                    this._state = UserDef.USER_LOCAL_SEX_STATE_COMPLETE;
                    this._log.info("local sex from SO! sex is " + this._sex);
                }
                else
                {
                    _loc_5 = UUIDManager.instance.uuid;
                    if (_loc_5)
                    {
                        this._state = UserDef.USER_LOCAL_SEX_STATE_LOADING;
                        this._userLocalSexRemote = new UserLocalSexRemote(_loc_5);
                        this._userLocalSexRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onCheckResult);
                        this._userLocalSexRemote.initialize();
                    }
                    else
                    {
                        this.randomSex();
                        this.saveSex();
                        this._state = UserDef.USER_LOCAL_SEX_STATE_COMPLETE;
                        this._log.info("local sex uuid is none! sex is " + this._sex);
                    }
                }
            }
            return;
        }// end function

        public function getSex() : int
        {
            return this._sex;
        }// end function

        public function setSex(param1:int, param2:Boolean = true) : void
        {
            if (param1 != this._sex && param1 >= UserDef.USER_SEX_BEGIN && param1 < UserDef.USER_SEX_END)
            {
                this._sex = param1;
                this.destroyUserLocalSexRemote();
                if (param2)
                {
                    this.saveSex();
                }
            }
            return;
        }// end function

        private function onCheckResult(event:RemoteObjectEvent) : void
        {
            if (this._userLocalSexRemote.status == RemoteObjectStatusEnum.Success)
            {
                this._sex = this._userLocalSexRemote.sex;
                if (this._sex == UserDef.USER_SEX_NONE)
                {
                    this.randomSex();
                }
            }
            else
            {
                this.randomSex();
            }
            this.saveSex();
            this.destroyUserLocalSexRemote();
            this._state = UserDef.USER_LOCAL_SEX_STATE_COMPLETE;
            dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LocalSexInitComplete));
            return;
        }// end function

        private function randomSex() : void
        {
            if (Math.random() > 0.5)
            {
                this._sex = UserDef.USER_SEX_MALE;
            }
            else
            {
                this._sex = UserDef.USER_SEX_FEMALE;
            }
            return;
        }// end function

        private function saveSex() : void
        {
            var _loc_1:Date = null;
            var _loc_2:uint = 0;
            try
            {
                if (this._SO == null)
                {
                    this._SO = SharedObject.getLocal(this.COMMON_COOKIE_NAME, "/");
                }
                this._SO.data.user_localSex = this._sex;
                _loc_1 = new Date();
                _loc_2 = _loc_1.time / 1000;
                this._SO.data.user_localSexSaveTime = _loc_2;
                this._SO.flush();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function destroyUserLocalSexRemote() : void
        {
            if (this._userLocalSexRemote)
            {
                this._userLocalSexRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onCheckResult);
                this._userLocalSexRemote.destroy();
                this._userLocalSexRemote = null;
            }
            return;
        }// end function

    }
}
