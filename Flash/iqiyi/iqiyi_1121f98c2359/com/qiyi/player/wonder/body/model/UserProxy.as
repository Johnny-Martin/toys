package com.qiyi.player.wonder.body.model
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.remote.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.lso.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.utils.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class UserProxy extends Proxy
    {
        private var _playerProxy:PlayerProxy;
        private var _isLogin:Boolean = false;
        private var _passportID:String = "";
        private var _P00001:String = "";
        private var _profileID:String = "";
        private var _profileCookie:String = "";
        private var _loginSource:String = "";
        private var _bonusRemote:BonusRemote;
        private var _bonusCompleted:Boolean = false;
        private var _initPlayer:Boolean = false;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.body.model.UserProxy";

        public function UserProxy()
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.body.model.UserProxy");
            super(NAME);
            this._bonusRemote = new BonusRemote();
            UserManager.getInstance().userLocalSex.load();
            return;
        }// end function

        public function get loginSource() : String
        {
            return this._loginSource;
        }// end function

        public function set loginSource(param1:String) : void
        {
            this._loginSource = param1;
            return;
        }// end function

        public function get isLogin() : Boolean
        {
            return this._isLogin;
        }// end function

        public function set isLogin(param1:Boolean) : void
        {
            this._isLogin = param1;
            return;
        }// end function

        public function get passportID() : String
        {
            return this._passportID;
        }// end function

        public function set passportID(param1:String) : void
        {
            this._passportID = param1;
            return;
        }// end function

        public function get P00001() : String
        {
            return this._P00001;
        }// end function

        public function set P00001(param1:String) : void
        {
            this._P00001 = param1;
            return;
        }// end function

        public function get profileID() : String
        {
            return this._profileID;
        }// end function

        public function set profileID(param1:String) : void
        {
            this._profileID = param1;
            return;
        }// end function

        public function get profileCookie() : String
        {
            return this._profileCookie;
        }// end function

        public function set profileCookie(param1:String) : void
        {
            this._profileCookie = param1;
            return;
        }// end function

        public function get userID() : String
        {
            if (UserManager.getInstance().user)
            {
                return UserManager.getInstance().user.id;
            }
            return "";
        }// end function

        public function get userName() : String
        {
            if (UserManager.getInstance().user)
            {
                return UserManager.getInstance().user.nickName;
            }
            return "";
        }// end function

        public function get userLevel() : int
        {
            if (UserManager.getInstance().user)
            {
                if (UserManager.getInstance().user.vipFalseReason == "timeout")
                {
                    return FlashVarConfig.vipuser ? (UserDef.USER_LEVEL_PRIMARY) : (UserDef.USER_LEVEL_NORMAL);
                }
                return UserManager.getInstance().user.level;
            }
            return UserDef.USER_LEVEL_NORMAL;
        }// end function

        public function get userType() : int
        {
            if (UserManager.getInstance().user)
            {
                return UserManager.getInstance().user.type;
            }
            return UserDef.USER_TYPE_QIYI;
        }// end function

        public function get bonusCompleted() : Boolean
        {
            return this._bonusCompleted;
        }// end function

        public function set bonusCompleted(param1:Boolean) : void
        {
            this._bonusCompleted = param1;
            return;
        }// end function

        public function injectPlayerProxy(param1:PlayerProxy) : void
        {
            this._playerProxy = param1;
            return;
        }// end function

        public function checkUser() : void
        {
            var _loc_1:String = null;
            if (this._isLogin)
            {
                UserManager.getInstance().addEventListener(UserManagerEvent.Evt_LoginSuccess, this.onUserLoginSuccess);
                _loc_1 = "";
                if (FlashVarConfig.localize == LocalizaEnum.LOCALIZE_TW_T.name || FlashVarConfig.localize == LocalizaEnum.LOCALIZE_TW_S.name)
                {
                    _loc_1 = "01010021010010000000";
                }
                else
                {
                    _loc_1 = "01010021010000000000";
                }
                UserManager.getInstance().login(this._passportID, this._P00001, this._profileID, this._profileCookie, _loc_1, FlashVarConfig.vipuser);
            }
            else
            {
                UserManager.getInstance().removeEventListener(UserManagerEvent.Evt_LoginSuccess, this.onUserLoginSuccess);
                UserManager.getInstance().logout();
                if (!this._initPlayer)
                {
                    this._initPlayer = true;
                    sendNotification(BodyDef.NOTIFIC_REQUEST_INIT_PLAYER);
                }
                this._log.info("check user complete,userID:" + this.userID + ", userName:" + this.userName + ", userLevel:" + this.userLevel + ", userType:" + this.userType);
                sendNotification(BodyDef.NOTIFIC_CHECK_USER_COMPLETE);
                sendNotification(BodyDef.NOTIFIC_CHECK_TRY_WATCH_REFRESH);
            }
            return;
        }// end function

        public function saveOneMinusBonus(param1:uint) : void
        {
            var _loc_2:String = null;
            if (!this._bonusCompleted)
            {
                if (this._isLogin)
                {
                    _loc_2 = this._playerProxy.curActor.movieInfo && this._playerProxy.curActor.movieInfo.infoJSON.sid != undefined ? (this._playerProxy.curActor.movieInfo.infoJSON.sid) : ("");
                    if (param1 > ConstUtils.MIN_2_MS)
                    {
                        this._bonusRemote.sendOneMinute(this._playerProxy.curActor.uuid, this._playerProxy.curActor.movieModel.tvid, this._playerProxy.curActor.movieModel.channelID, this._playerProxy.curActor.movieModel.albumId, _loc_2);
                        this._bonusCompleted = true;
                    }
                }
                else if (param1 > ConstUtils.MIN_2_MS)
                {
                    LSO.getInstance().addBonus();
                    this._bonusCompleted = true;
                }
            }
            return;
        }// end function

        public function savePlayOverBonus(param1:uint, param2:int) : void
        {
            var _loc_3:String = null;
            if (!this._bonusCompleted)
            {
                if (this._isLogin)
                {
                    _loc_3 = this._playerProxy.curActor.movieInfo && this._playerProxy.curActor.movieInfo.infoJSON.sid != undefined ? (this._playerProxy.curActor.movieInfo.infoJSON.sid) : ("");
                    if (param1 > ConstUtils.MIN_2_MS || param1 <= ConstUtils.MIN_2_MS && param2 <= ConstUtils.MIN_2_MS)
                    {
                        this._bonusRemote.sendPlayOver(this._playerProxy.curActor.uuid, this._playerProxy.curActor.movieModel.tvid, this._playerProxy.curActor.movieModel.channelID, this._playerProxy.curActor.movieModel.albumId, _loc_3);
                        this._bonusCompleted = true;
                    }
                }
                else if (param1 > ConstUtils.MIN_2_MS || param1 <= ConstUtils.MIN_2_MS && param2 <= ConstUtils.MIN_2_MS)
                {
                    LSO.getInstance().addBonus();
                    this._bonusCompleted = true;
                }
            }
            return;
        }// end function

        public function saveTotalBonus(param1:uint, param2:String) : void
        {
            var _loc_3:* = this._playerProxy.curActor.movieInfo && this._playerProxy.curActor.movieInfo.infoJSON.sid != undefined ? (this._playerProxy.curActor.movieInfo.infoJSON.sid) : ("");
            this._bonusRemote.sendSavedTotalBonus(param1, param2, _loc_3);
            return;
        }// end function

        private function onUserLoginSuccess(event:UserManagerEvent) : void
        {
            UserManager.getInstance().removeEventListener(UserManagerEvent.Evt_LoginSuccess, this.onUserLoginSuccess);
            if (!this._initPlayer)
            {
                this._initPlayer = true;
                sendNotification(BodyDef.NOTIFIC_REQUEST_INIT_PLAYER);
            }
            if (UserManager.getInstance().user.vipFalseReason == "timeout")
            {
                PingBack.getInstance().mirrorCheckUser(this._playerProxy.curActor.uuid, this._passportID, this._P00001);
            }
            sendNotification(BodyDef.NOTIFIC_CHECK_USER_COMPLETE);
            sendNotification(BodyDef.NOTIFIC_CHECK_TRY_WATCH_REFRESH);
            return;
        }// end function

    }
}
