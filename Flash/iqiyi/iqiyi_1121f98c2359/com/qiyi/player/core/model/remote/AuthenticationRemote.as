package com.qiyi.player.core.model.remote
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.user.impls.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class AuthenticationRemote extends BaseRemoteObject
    {
        private var _holder:ICorePlayer;
        private var _segmentIndex:int;
        private var _segment:Segment;
        private var _shareFlag:int = 0;
        private var _log:ILogger;

        public function AuthenticationRemote(param1:Segment, param2:ICorePlayer, param3:int = 0)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.remote.AuthenticationRemote");
            super(0, "AuthenticationRemote");
            this._holder = param2;
            this._segment = param1;
            _timeout = 5000;
            this._shareFlag = param3;
            _retryMaxCount = this._shareFlag == 0 ? (2) : (0);
            return;
        }// end function

        override public function initialize() : void
        {
            super.initialize();
            return;
        }// end function

        override protected function getRequest() : URLRequest
        {
            var request:URLRequest;
            var variables:URLVariables;
            var qd:String;
            var qdItem:Array;
            var i:int;
            var item:String;
            var delim:int;
            try
            {
                this._holder.runtimeData.authenticationError = false;
                request = new URLRequest(Config.VIP_AUTH_URL);
                variables = new URLVariables();
                variables.version = "3.0";
                variables.platform = this._holder.runtimeData.areaPlatform.name;
                variables.aid = this._holder.runtimeData.albumId;
                variables.tvid = this._holder.runtimeData.qipuId;
                variables.uid = UserManager.getInstance().user != null ? (UserManager.getInstance().user.passportID) : ("");
                variables.deviceId = UUIDManager.instance.uuid;
                variables.playType = this._holder.runtimeData.playerType != null ? (this._holder.runtimeData.playerType.name) : ("");
                variables.filename = this._segment.rid;
                variables.shareFlag = this._shareFlag;
                qd = this._segment.url.substr((this._segment.url.indexOf("?") + 1));
                qdItem = qd.split("&");
                i;
                while (i < qdItem.length)
                {
                    
                    item = qdItem[i];
                    delim = item.indexOf("=");
                    variables[item.substr(0, delim)] = item.substr((delim + 1));
                    i = (i + 1);
                }
                request.method = URLRequestMethod.POST;
                request.data = variables;
            }
            catch (e:Error)
            {
                _log.warn("AuthenticationRemote create URLRequest error");
                return null;
            }
            return request;
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var property:String;
            var tryWatchType:EnumItem;
            var s:String;
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            if (this._shareFlag > 0)
            {
                super.onComplete(event);
                this._log.info("AuthenticationRemote result for fgtw completed");
                return;
            }
            try
            {
                this._log.debug("AuthenticationRemote result:" + _loader.data);
                _data = JSON.decode(_loader.data);
                if (_data.code == "A00000")
                {
                    this._holder.runtimeData.key = _data.data.t;
                    this._holder.runtimeData.QY00001 = _data.data.u;
                    this._holder.runtimeData.isTryWatch = _data.data.prv == "1";
                    this._holder.runtimeData.authenticationTipType = int(_data.data.tip_type);
                    this._holder.runtimeData.auth_ttype = int(_data.data.ttype);
                    this._holder.runtimeData.auth_rtime = int(_data.data.rtime) * 60 * 1000;
                    this._holder.runtimeData.auth_ptime = int(_data.data.ptime);
                    if (this._holder.runtimeData.isTryWatch)
                    {
                        if (_data.hasOwnProperty("previewType"))
                        {
                            tryWatchType = Utility.getItemById(TryWatchEnum.ITEMS, int(_data.previewType));
                            if (tryWatchType)
                            {
                                this._holder.runtimeData.tryWatchType = tryWatchType;
                            }
                        }
                        if (_data.hasOwnProperty("previewTime"))
                        {
                            this._holder.runtimeData.tryWatchTime = int(_data.previewTime) * 60 * 1000;
                        }
                        if (_data.hasOwnProperty("previewEpisodes"))
                        {
                        }
                    }
                    this._holder.runtimeData.dispatcherServerTime = Number(_data.data.st);
                    this._holder.runtimeData.dispatchFlashRunTime = int(getTimer() / 1000);
                }
                else
                {
                    this._holder.runtimeData.authenticationError = true;
                }
                var _loc_3:int = 0;
                var _loc_4:* = _data;
                while (_loc_4 in _loc_3)
                {
                    
                    property = _loc_4[_loc_3];
                    this._holder.runtimeData.authentication[property] = _data[property];
                }
                super.onComplete(event);
            }
            catch (e:Error)
            {
                _log.error("AuthenticationRemote parse JSON error");
                s = _loader.data;
                if (s)
                {
                    _log.info(s.substr(0, 100));
                }
                setStatus(RemoteObjectStatusEnum.DataError);
            }
            return;
        }// end function

        override protected function setStatus(param1:EnumItem) : void
        {
            var _loc_2:int = 0;
            if (this._shareFlag > 0)
            {
                super.setStatus(param1);
                return;
            }
            if (param1 == RemoteObjectStatusEnum.Timeout || param1 == RemoteObjectStatusEnum.ConnectError || param1 == RemoteObjectStatusEnum.DataError || param1 == RemoteObjectStatusEnum.AuthenticationError || param1 == RemoteObjectStatusEnum.SecurityError || param1 == RemoteObjectStatusEnum.UnknownError)
            {
                _loc_2 = ErrorCodeUtils.getErrorCodeByRemoteObject(this, param1);
                if (this._holder.pingBack)
                {
                    this._holder.pingBack.sendError(_loc_2);
                }
                this._holder.runtimeData.errorCode = _loc_2;
            }
            super.setStatus(param1);
            return;
        }// end function

    }
}
