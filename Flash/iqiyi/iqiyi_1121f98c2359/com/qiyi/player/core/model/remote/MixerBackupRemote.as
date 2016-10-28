package com.qiyi.player.core.model.remote
{
    import cmd5.*;
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class MixerBackupRemote extends BaseRemoteObject
    {
        private var _holder:ICorePlayer;
        private var _log:ILogger;
        private var _originalContent:String = "";
        private var _errorCode:int;

        public function MixerBackupRemote(param1:ICorePlayer, param2:int)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.remote.MixerBackupRemote");
            super(0, "MixerBackupRemote");
            this._holder = param1;
            this._errorCode = param2;
            _timeout = Config.MIXER_TIMEOUT / 2;
            _retryMaxCount = 0;
            return;
        }// end function

        public function get originalContent() : String
        {
            return this._originalContent;
        }// end function

        override protected function getRequest() : URLRequest
        {
            var _loc_1:String = null;
            var _loc_2:int = 0;
            if (this._holder.runtimeData.CDNStatus == -1 && this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
            {
                _loc_2 = 1;
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
            _loc_1 = Config.MIXER_BACKUP_URL + _loc_7 + "&vf=" + calc(_loc_7, _loc_7);
            this._holder.runtimeData.ugcAuthKey = "";
            return new URLRequest(_loc_1);
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var json:Object;
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
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
                else if (json && MixerRemote.VMSErrorMap[json.code] != null)
                {
                    _data = new Object();
                    _data.code = json.code;
                    this._log.error("MixerBackupRemote vms error code: " + json.code);
                    super.onComplete(event);
                }
                else
                {
                    this._log.error("MixerBackupRemote failed to load the mixer data, code: " + (json != null ? (json.code) : ("")));
                    setStatus(RemoteObjectStatusEnum.DataError);
                }
            }
            catch (e:Error)
            {
                _log.fatal("MixerBackupRemote, the mixer data is invalid");
                _log.debug("vms invalid json: " + _originalContent);
                setStatus(RemoteObjectStatusEnum.DataError);
                return;
            }
            return;
        }// end function

    }
}
