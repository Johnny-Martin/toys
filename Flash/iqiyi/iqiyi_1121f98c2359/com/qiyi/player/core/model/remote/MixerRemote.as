package com.qiyi.player.core.model.remote
{
    import cmd5.*;
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class MixerRemote extends BaseRemoteObject
    {
        private var _holder:ICorePlayer;
        private var _originalContent:String = "";
        private var _requestDuration:int = 0;
        private var _log:ILogger;
        private var _backupRemote:MixerBackupRemote;
        static var _vmsErrorMap:Dictionary = null;

        public function MixerRemote(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.remote.MixerRemote");
            super(0, "MixerRemote");
            this._holder = param1;
            this._holder.runtimeData.authenticationError = false;
            _timeout = Config.MIXER_TIMEOUT;
            _retryMaxCount = Config.MIXER_MAX_RETRY;
            return;
        }// end function

        public function get originalContent() : String
        {
            return this._originalContent;
        }// end function

        override protected function getRequest() : URLRequest
        {
            var _loc_1:String = null;
            this._requestDuration = getTimer();
            if (this._holder.pingBack)
            {
                this._holder.pingBack.sendStartLoadVrs();
            }
            var _loc_2:int = 0;
            if (this._holder.runtimeData.CDNStatus == -1 && this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
            {
                _loc_2 = 1;
            }
            else
            {
                _loc_2 = 0;
            }
            var _loc_3:* = getTimer();
            var _loc_4:* = MD5.calculate(MD5.calculate(this._holder.runtimeData.ugcAuthKey) + String(_loc_3) + this._holder.runtimeData.tvid);
            var _loc_5:* = Settings.instance.boss ? ("&vv=821d3c731e374feaa629dcdaab7c394b") : ("");
            var _loc_6:* = UserManager.getInstance().user && UserManager.getInstance().user.level != UserDef.USER_LEVEL_NORMAL ? ("1") : ("0");
            var _loc_7:* = "/vms?key=fvip" + "&src=" + (LocalizaEnum.isTWLocalize(this._holder.runtimeData.localize) ? ("01010021010010000000") : ("1702633101b340d8917a69cf8a4b8c7c")) + "&tvId=" + this._holder.runtimeData.tvid + "&vid=" + this._holder.runtimeData.originalVid + "&vinfo=" + _loc_2 + "&tm=" + _loc_3 + "&qyid=" + this._holder.uuid + "&puid=" + (UserManager.getInstance().user ? (UserManager.getInstance().user.passportID) : ("")) + "&authKey=" + _loc_4 + "&um=" + _loc_6 + _loc_5 + "&pf=b6c13e26323c537d" + "&thdk=" + this._holder.runtimeData.thdKey + "&thdt=" + this._holder.runtimeData.thdToken + "&rs=1" + "&k_tag=1" + "&qdv=1";
            if (LocalizaEnum.isComplexFontLocalize(this._holder.runtimeData.localize))
            {
                _loc_7 = _loc_7 + "&locale=zh_tw";
            }
            _loc_1 = Config.MIXER_VX_URL + _loc_7 + "&vf=" + calc(_loc_7, _loc_7);
            this._holder.runtimeData.ugcAuthKey = "";
            return new URLRequest(_loc_1);
        }// end function

        override public function initialize() : void
        {
            ProcessesTimeRecord.STime_vms = getTimer();
            super.initialize();
            return;
        }// end function

        override public function destroy() : void
        {
            if (this._backupRemote != null)
            {
                this._backupRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onBackupRemoteStatusChanged);
                this._backupRemote.destroy();
                this._backupRemote = null;
            }
            super.destroy();
            return;
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var json:Object;
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            ProcessesTimeRecord.usedTime_vms = getTimer() - ProcessesTimeRecord.STime_vms;
            if (this._requestDuration > 0)
            {
                this._requestDuration = getTimer() - this._requestDuration;
                if (this._holder.pingBack)
                {
                    this._holder.pingBack.sendVRSRequestTime(this._requestDuration);
                }
            }
            try
            {
                this._originalContent = _loader.data as String;
                json = JSON.decode(_loader.data);
                if (json && json.code == "A000000" && json.data)
                {
                    _data = new Object();
                    _data.code = json.code;
                    _data.useCache = false;
                    _data.vp = json.data.vp != undefined ? (json.data.vp) : (null);
                    _data.vi = json.data.vi != undefined ? (json.data.vi) : (null);
                    _data.f4v = json.data.f4v != undefined ? (json.data.f4v) : (null);
                    this._holder.runtimeData.movieIsMember = _data.vp && _data.vp.bossStatus > 0;
                    super.onComplete(event);
                }
                else if (json && VMSErrorMap[json.code] != null)
                {
                    _data = new Object();
                    _data.code = json.code;
                    super.onComplete(event);
                }
                else
                {
                    this._log.error("MixerRemote failed to load the mixer data, code: " + (json != null ? (json.code) : ("")));
                    this.setStatus(RemoteObjectStatusEnum.DataError);
                }
            }
            catch (e:Error)
            {
                _log.fatal("MixerRemote, the mixer data is invalid");
                _log.debug("vms invalid json: " + _originalContent);
                if (_loader.data)
                {
                    sendHijackPingBack(_loader.data);
                }
                setStatus(RemoteObjectStatusEnum.DataError);
                return;
            }
            return;
        }// end function

        private function sendHijackPingBack(param1:String) : void
        {
            var _loc_2:URLRequest = null;
            if (param1)
            {
                try
                {
                    _loc_2 = new URLRequest();
                    _loc_2.url = "http://msg.video.qiyi.com/tmpstats.gif?type=isphijack20140210&rt=" + encodeURIComponent(param1.substr(0, 500)) + "&tn=" + Math.random();
                    sendToURL(_loc_2);
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        override protected function setStatus(param1:EnumItem) : void
        {
            var _loc_3:int = 0;
            if (param1 == RemoteObjectStatusEnum.Timeout || param1 == RemoteObjectStatusEnum.ConnectError || param1 == RemoteObjectStatusEnum.DataError || param1 == RemoteObjectStatusEnum.SecurityError)
            {
                this._backupRemote = new MixerBackupRemote(this._holder, ErrorCodeUtils.getErrorCodeByRemoteObject(this, param1));
                this._backupRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onBackupRemoteStatusChanged);
                this._backupRemote.initialize();
                return;
            }
            var _loc_2:Boolean = false;
            if (param1 == RemoteObjectStatusEnum.UnknownError)
            {
                _loc_3 = ErrorCodeUtils.getErrorCodeByRemoteObject(this, param1);
                if (this._holder.pingBack)
                {
                    this._holder.pingBack.sendError(_loc_3);
                    _loc_2 = true;
                }
                this._holder.runtimeData.errorCode = _loc_3;
            }
            super.setStatus(param1);
            if (_loc_2)
            {
                this._holder.pingBack.sendErrorAuto(this._holder.runtimeData.errorCode);
            }
            return;
        }// end function

        private function onBackupRemoteStatusChanged(event:RemoteObjectEvent) : void
        {
            var _loc_2:int = 0;
            if (this._backupRemote.status == RemoteObjectStatusEnum.Success)
            {
                _data = this._backupRemote.getData();
                this._originalContent = this._backupRemote.originalContent;
                this._holder.runtimeData.vmsBackupUsed = true;
                super.setStatus(this._backupRemote.status);
            }
            else
            {
                super.setStatus(_status);
                _loc_2 = ErrorCodeUtils.getErrorCodeByRemoteObject(this, _status);
                this._holder.pingBack.sendErrorAuto(this._holder.runtimeData.errorCode);
            }
            return;
        }// end function

        public static function get VMSErrorMap() : Dictionary
        {
            if (_vmsErrorMap == null)
            {
                _vmsErrorMap = new Dictionary();
                _vmsErrorMap["A000001"] = 707;
                _vmsErrorMap["A000003"] = 708;
                _vmsErrorMap["A000004"] = 709;
            }
            return _vmsErrorMap;
        }// end function

    }
}
