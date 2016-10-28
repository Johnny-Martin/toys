package com.qiyi.player.user.impls
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.user.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class UserCheckRemote extends BaseRemoteObject
    {
        private const MEMBER_CHECK_URL:String = "https://cmonitor.iqiyi.com/apis/user/check_vip.action";
        private const REQUEST_KEY:String = "w0JD89dhtS7BdPLU2";
        private const RESPONSE_KEY:String = "-0J1d9d^ESd)9jSsja";
        private var _passportID:String = "";
        private var _P00001:String = "";
        private var _ptid:String = "";
        private var _userID:String = "";
        private var _userName:String = "";
        private var _userLevel:int;
        private var _userType:int;
        private var _limitationType:int;
        private var _heartBeatTime:int = 0;
        private var _vipFalseReason:Object = "";
        private var _log:ILogger;

        public function UserCheckRemote(param1:String, param2:String, param3:String = "")
        {
            this._userLevel = UserDef.USER_LEVEL_NORMAL;
            this._userType = UserDef.USER_TYPE_QIYI;
            this._limitationType = UserDef.USER_LIMITATION_NONE;
            this._log = Log.getLogger("com.qiyi.player.wonder.body.model.remote.UserCheckRemote");
            super(0, "UserCheckRemote");
            this._passportID = param1;
            this._P00001 = param2;
            this._ptid = param3;
            _timeout = 4000;
            _retryMaxCount = 1;
            return;
        }// end function

        public function get vipFalseReason()
        {
            return this._vipFalseReason;
        }// end function

        public function get userID() : String
        {
            return this._userID;
        }// end function

        public function get userName() : String
        {
            return this._userName;
        }// end function

        public function get userLevel() : int
        {
            return this._userLevel;
        }// end function

        public function get userType() : int
        {
            return this._userType;
        }// end function

        public function get limitationType() : int
        {
            return this._limitationType;
        }// end function

        public function get heartBeatTime() : int
        {
            return this._heartBeatTime;
        }// end function

        override public function initialize() : void
        {
            ProcessesTimeRecord.STime_userInfo = getTimer();
            super.initialize();
            return;
        }// end function

        override protected function getRequest() : URLRequest
        {
            var _loc_1:String = "";
            try
            {
                _loc_1 = this._P00001.substring(4, 36);
            }
            catch (e:Error)
            {
            }
            var _loc_2:* = this.MEMBER_CHECK_URL;
            _loc_2 = _loc_2 + ("?authcookie=" + this._P00001);
            _loc_2 = _loc_2 + ("&agenttype=" + 1);
            _loc_2 = _loc_2 + ("&sign=" + MD5.calculate(_loc_1 + "|" + "1" + "|" + this.REQUEST_KEY));
            _loc_2 = _loc_2 + ("&ptid=" + this._ptid);
            _loc_2 = _loc_2 + "&version=3";
            _loc_2 = _loc_2 + ("&tn=" + Math.random());
            return new URLRequest(_loc_2);
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            ProcessesTimeRecord.usedTime_userInfo = getTimer() - ProcessesTimeRecord.STime_userInfo;
            this._log.info("Login user check info: " + _loader.data);
            try
            {
                _data = JSON.decode(_loader.data as String);
                this._vipFalseReason = _data;
                if (_data.code == "A00000")
                {
                    if (this.getResultSignVerify(_data))
                    {
                        this._userLevel = UserDef.USER_LEVEL_PRIMARY;
                        if (_data.data && _data.data.keepalive != undefined)
                        {
                            this._heartBeatTime = int(_data.data.keepalive) * 1000;
                        }
                        else
                        {
                            this._heartBeatTime = 0;
                        }
                    }
                    else
                    {
                        this._userLevel = UserDef.USER_LEVEL_NORMAL;
                        this._log.info("Login user check Sign verify error!");
                    }
                }
                else
                {
                    if (_data.code == "A10001")
                    {
                        this._limitationType = UserDef.USER_LIMITATION_UPPER;
                    }
                    else if (_data.code == "A10002")
                    {
                        this._limitationType = UserDef.USER_LIMITATION_CLOSING;
                    }
                    else if (_data.code == "A10004")
                    {
                        this._limitationType = UserDef.USER_LIMITATION_PERMANENT_CLOSING;
                    }
                    this._userLevel = UserDef.USER_LEVEL_NORMAL;
                }
                super.onComplete(event);
            }
            catch (e:Error)
            {
                _userLevel = UserDef.USER_LEVEL_NORMAL;
                _limitationType = UserDef.USER_LIMITATION_NONE;
                _heartBeatTime = 0;
                _vipFalseReason = "data json error";
                setStatus(RemoteObjectStatusEnum.DataError);
            }
            return;
        }// end function

        private function getResultSignVerify(param1:Object) : Boolean
        {
            var _loc_3:String = null;
            var _loc_2:String = "";
            try
            {
                _loc_2 = this._P00001.substring(5, 39);
                _loc_2 = _loc_2.split("").reverse().join("");
                _loc_3 = MD5.calculate(_loc_2 + "<1" + "<" + this.RESPONSE_KEY);
                if (param1.data)
                {
                    if (param1.data.sign == _loc_3)
                    {
                        return true;
                    }
                }
            }
            catch (e:Error)
            {
            }
            return false;
        }// end function

    }
}
