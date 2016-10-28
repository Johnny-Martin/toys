package com.qiyi.player.user.impls
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.user.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class UserLocalSexRemote extends BaseRemoteObject
    {
        private const REMOTE_URL:String = "http://uaa.iqiyi.com/api/v1/userprofile";
        private var _uuid:String = "";
        private var _sex:int;
        private var _log:ILogger;

        public function UserLocalSexRemote(param1:String)
        {
            this._sex = UserDef.USER_SEX_NONE;
            this._log = Log.getLogger("com.qiyi.player.user.impls.UserLocalSexRemote");
            super(0, "UserLocalSexRemote");
            this._uuid = param1;
            _timeout = 2000;
            _retryMaxCount = 2;
            return;
        }// end function

        public function get sex() : int
        {
            return this._sex;
        }// end function

        override protected function getRequest() : URLRequest
        {
            var _loc_1:* = this.REMOTE_URL + "?platform=1&id=" + this._uuid + "&tn=" + Math.random();
            return new URLRequest(_loc_1);
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            this._log.info("UserLocalSexRemote complete! uuid:" + this._uuid + " result:" + _loader.data);
            try
            {
                _data = JSON.decode(_loader.data as String);
                if (int(_data.code) == 100)
                {
                    if (_data.profile && _data.profile.gender && _data.profile.gender.value)
                    {
                        this._sex = _data.profile.gender.value == "male" ? (UserDef.USER_SEX_MALE) : (UserDef.USER_SEX_FEMALE);
                    }
                    else
                    {
                        this._sex = UserDef.USER_SEX_NONE;
                    }
                }
                else
                {
                    this._sex = UserDef.USER_SEX_NONE;
                }
                super.onComplete(event);
            }
            catch (e:Error)
            {
                _sex = UserDef.USER_SEX_NONE;
                setStatus(RemoteObjectStatusEnum.DataError);
            }
            return;
        }// end function

    }
}
