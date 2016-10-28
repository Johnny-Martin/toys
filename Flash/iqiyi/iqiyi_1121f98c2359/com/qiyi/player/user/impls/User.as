package com.qiyi.player.user.impls
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.user.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class User extends EventDispatcher implements IUser
    {
        private const HEART_BEAT_MIN_TIME:int = 10000;
        private const HEART_BEAT_URL:String = "http://cm.passport.iqiyi.com/apis/cmonitor/keepalive.action";
        private const KEY:String = "jfaljluixn39012$#";
        private var _id:String = "";
        private var _passportID:String = "";
        private var _P00001:String = "";
        private var _profileID:String = "";
        private var _profileCookie:String = "";
        private var _ptid:String = "";
        private var _nickname:String = "";
        private var _type:int;
        private var _level:int;
        private var _limitationType:int;
        private var _userCheckRemote:UserCheckRemote;
        private var _vipFalseReason:Object = "";
        private var _heartBeatTimer:Timer;
        private var _tvid:String = "";
        private var _isActivation:Boolean = false;
        private var _vipuser:Boolean = true;
        private var _log:ILogger;

        public function User(param1:String, param2:String, param3:String, param4:String, param5:String = "", param6:Boolean = true)
        {
            this._type = UserDef.USER_TYPE_QIYI;
            this._level = UserDef.USER_LEVEL_NORMAL;
            this._limitationType = UserDef.USER_LIMITATION_NONE;
            this._log = Log.getLogger("com.qiyi.player.user.impls.User");
            this._passportID = param1;
            this._P00001 = param2;
            this._profileID = param3;
            this._profileCookie = param4;
            this._ptid = param5;
            this._vipuser = param6;
            return;
        }// end function

        public function get vipFalseReason()
        {
            return this._vipFalseReason;
        }// end function

        public function get passportID() : String
        {
            return this._passportID;
        }// end function

        public function get P00001() : String
        {
            return this._P00001;
        }// end function

        public function get profileID() : String
        {
            return this._profileID;
        }// end function

        public function get profileCookie() : String
        {
            return this._profileCookie;
        }// end function

        public function get ptid() : String
        {
            return this._ptid;
        }// end function

        public function get nickName() : String
        {
            return this._nickname;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function get type() : int
        {
            return this._type;
        }// end function

        public function get level() : int
        {
            if (this.vipFalseReason == "timeout")
            {
                return this._vipuser ? (UserDef.USER_LEVEL_PRIMARY) : (UserDef.USER_LEVEL_NORMAL);
            }
            return this._level;
        }// end function

        public function get limitationType() : int
        {
            return this._limitationType;
        }// end function

        public function set tvid(param1:String) : void
        {
            this._tvid = param1;
            return;
        }// end function

        public function checkUser() : void
        {
            if (this._userCheckRemote)
            {
                this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onCheckResult);
                this._userCheckRemote.destroy();
            }
            this._userCheckRemote = new UserCheckRemote(this._passportID, this._P00001, this._ptid);
            this._userCheckRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onCheckResult);
            this._userCheckRemote.initialize();
            return;
        }// end function

        public function openHeartBeat() : void
        {
            if (this._level != UserDef.USER_LEVEL_NORMAL)
            {
                this._isActivation = true;
                if (this._heartBeatTimer && !this._heartBeatTimer.running)
                {
                    this.onHeartBeatTimer();
                    this._heartBeatTimer.start();
                }
            }
            return;
        }// end function

        public function closeHeartBeat() : void
        {
            this._isActivation = false;
            if (this._heartBeatTimer && this._heartBeatTimer.running)
            {
                this._heartBeatTimer.stop();
            }
            return;
        }// end function

        public function destroy() : void
        {
            if (this._userCheckRemote)
            {
                this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onCheckResult);
                this._userCheckRemote.destroy();
                this._userCheckRemote = null;
            }
            if (this._heartBeatTimer)
            {
                this._heartBeatTimer.removeEventListener(TimerEvent.TIMER, this.onHeartBeatTimer);
                this._heartBeatTimer.stop();
                this._heartBeatTimer = null;
            }
            this._isActivation = false;
            return;
        }// end function

        private function onCheckResult(event:RemoteObjectEvent) : void
        {
            var _loc_2:int = 0;
            if (this._userCheckRemote.status == RemoteObjectStatusEnum.Success)
            {
                this._vipFalseReason = this._userCheckRemote.vipFalseReason;
                if (this._userCheckRemote.userLevel == UserDef.USER_LEVEL_NORMAL)
                {
                    this._id = "";
                    this._nickname = "";
                    this._level = UserDef.USER_LEVEL_NORMAL;
                    this._type = UserDef.USER_TYPE_QIYI;
                    this._limitationType = this._userCheckRemote.limitationType;
                }
                else if (this._userCheckRemote.userLevel == UserDef.USER_LEVEL_PRIMARY)
                {
                    this._id = this._userCheckRemote.userID;
                    this._nickname = this._userCheckRemote.userName;
                    this._level = this._userCheckRemote.userLevel;
                    this._type = this._userCheckRemote.userType;
                    _loc_2 = this._userCheckRemote.heartBeatTime;
                    if (_loc_2 > 0)
                    {
                        if (_loc_2 < this.HEART_BEAT_MIN_TIME)
                        {
                            _loc_2 = this.HEART_BEAT_MIN_TIME;
                        }
                        if (this._heartBeatTimer == null)
                        {
                            this._heartBeatTimer = new Timer(_loc_2);
                            this._heartBeatTimer.addEventListener(TimerEvent.TIMER, this.onHeartBeatTimer);
                        }
                        else
                        {
                            this._heartBeatTimer.delay = _loc_2;
                        }
                        if (this._isActivation)
                        {
                            this._heartBeatTimer.start();
                        }
                    }
                }
            }
            else if (this._userCheckRemote.status != RemoteObjectStatusEnum.Processing)
            {
                this._vipFalseReason = this._userCheckRemote.status.name;
            }
            else
            {
                this._vipFalseReason = this._userCheckRemote.status.name;
                return;
            }
            this._log.info("check user complete,userID:" + this._id + ", userName:" + this._nickname + ", userLevel:" + this._level + ", userType:" + this._type + ", limitationType:" + this._limitationType + ", heartBeatTime:" + this._userCheckRemote.heartBeatTime);
            this._userCheckRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onCheckResult);
            this._userCheckRemote.destroy();
            this._userCheckRemote = null;
            dispatchEvent(new UserManagerEvent(UserManagerEvent.Evt_LoginSuccess));
            return;
        }// end function

        private function onHeartBeatTimer(event:Event = null) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Array = null;
            var _loc_4:String = null;
            var _loc_5:uint = 0;
            var _loc_6:String = null;
            var _loc_7:URLRequest = null;
            if (this._level != UserDef.USER_LEVEL_NORMAL)
            {
                _loc_2 = Math.random();
                _loc_3 = new Array();
                _loc_3.push("authcookie=" + this._P00001);
                _loc_3.push("tn=" + _loc_2);
                _loc_3.push("tv_id=" + this._tvid);
                _loc_3.push("device_id=" + UUIDManager.instance.uuid);
                _loc_3.push(("agenttype=" + 1));
                _loc_3.sort();
                _loc_4 = "";
                _loc_5 = 0;
                while (_loc_5 < _loc_3.length)
                {
                    
                    _loc_4 = _loc_4 + (_loc_3[_loc_5] + "|");
                    _loc_5 = _loc_5 + 1;
                }
                _loc_4 = _loc_4 + this.KEY;
                _loc_4 = MD5.calculate(_loc_4);
                _loc_6 = this.HEART_BEAT_URL;
                _loc_6 = _loc_6 + ("?authcookie=" + this._P00001);
                _loc_6 = _loc_6 + ("&agenttype=" + 1);
                _loc_6 = _loc_6 + ("&sign=" + _loc_4);
                _loc_6 = _loc_6 + ("&device_id=" + UUIDManager.instance.uuid);
                _loc_6 = _loc_6 + ("&tv_id=" + this._tvid);
                _loc_6 = _loc_6 + ("&tn=" + _loc_2);
                _loc_7 = new URLRequest(_loc_6);
                sendToURL(_loc_7);
            }
            return;
        }// end function

    }
}
