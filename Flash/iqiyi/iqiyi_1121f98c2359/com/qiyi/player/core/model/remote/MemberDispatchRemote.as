package com.qiyi.player.core.model.remote
{
    import cmd5.*;
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class MemberDispatchRemote extends BaseRemoteObject
    {
        private var _segment:Segment;
        private var _startPos:int = -1;
        private var _holder:ICorePlayer;
        private var _log:ILogger;

        public function MemberDispatchRemote(param1:Segment, param2:int, param3:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.remote.MemberDispatchRemote");
            super(0, "MemberDispatchRemote");
            this._segment = param1;
            this._startPos = param2;
            this._holder = param3;
            this._holder.runtimeData.authenticationError = false;
            _retryMaxCount = Config.DISPATCH_MAX_RETRY;
            _timeout = Config.DISPATCH_TIMEOUT;
            return;
        }// end function

        override protected function getRequest() : URLRequest
        {
            var _loc_1:* = this._segment.url.split(".f4v").join(".hml");
            var _loc_2:* = this._holder.runtimeData.key + this._segment.rid;
            _loc_1 = _loc_1 + (_loc_1.indexOf("?") == -1 ? ("?") : ("&"));
            _loc_1 = _loc_1 + ("t=" + this._holder.runtimeData.key + "&cid=" + this._holder.runtimeData.communicationlId + "&vid=" + this._holder.runtimeData.vid);
            _loc_1 = _loc_1 + ("&QY00001=" + this._holder.runtimeData.QY00001);
            if (this._startPos == -1)
            {
                if (this._segment.currentKeyframe && this._segment.currentKeyframe.index != 0)
                {
                    _loc_1 = _loc_1 + ("&start=" + this._segment.currentKeyframe.position);
                }
            }
            else if (this._startPos != 0)
            {
                _loc_1 = _loc_1 + ("&start=" + this._startPos.toString());
            }
            if (this._holder.runtimeData.retryCount > 0)
            {
                _loc_1 = _loc_1 + ("&retry=" + this._holder.runtimeData.retryCount.toString());
            }
            _loc_1 = _loc_1 + ("&su=" + UUIDManager.instance.uuid);
            _loc_1 = _loc_1 + ("&client=" + this._holder.runtimeData.currentUserIP);
            _loc_1 = _loc_1 + ("&z=" + this._holder.runtimeData.preDispatchArea);
            _loc_1 = _loc_1 + ("&mi=" + this._holder.runtimeData.movieInfo);
            _loc_1 = _loc_1 + ("&bt=" + this._holder.runtimeData.preDefinition);
            _loc_1 = _loc_1 + ("&ct=" + this._holder.runtimeData.currentDefinition);
            if (this._holder.runtimeData.preAverageSpeed > 0)
            {
                _loc_1 = _loc_1 + ("&s=" + this._holder.runtimeData.preAverageSpeed.toString());
            }
            _loc_1 = _loc_1 + ("&e=" + this._holder.runtimeData.preErrorCode);
            _loc_1 = _loc_1 + ("&qyid=" + UUIDManager.instance.uuid);
            _loc_1 = _loc_1 + "&ib=3";
            _loc_1 = _loc_1 + ("&ptime=" + this._holder.runtimeData.auth_ptime);
            _loc_1 = _loc_1 + ("&ibt=" + calc(_loc_2, _loc_2));
            _loc_1 = _loc_1 + ("&tn=" + getTimer());
            return new URLRequest(_loc_1);
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var s:String;
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            try
            {
                _data = JSON.decode(_loader.data);
                this._holder.runtimeData.userDisInfo[this._segment.index] = {t:_data.t, z:_data.z};
                this._holder.runtimeData.preDispatchArea = _data.z;
                if (this._holder.runtimeData.currentUserIP == "")
                {
                    try
                    {
                        this._holder.runtimeData.currentUserIP = String(_data.t).split("-")[1];
                    }
                    catch (e:Error)
                    {
                    }
                }
                super.onComplete(event);
            }
            catch (e:Error)
            {
                _log.error("MemberDispatch: parse JSON error");
                s = _loader.data;
                if (s)
                {
                    _log.info(s.substr(0, 100));
                }
                this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception, RemoteObjectStatusEnum.DataError));
                setStatus(RemoteObjectStatusEnum.DataError);
            }
            return;
        }// end function

        override protected function setStatus(param1:EnumItem) : void
        {
            var _loc_2:int = 0;
            if (param1 == RemoteObjectStatusEnum.Timeout || param1 == RemoteObjectStatusEnum.ConnectError || param1 == RemoteObjectStatusEnum.DataError || param1 == RemoteObjectStatusEnum.AuthenticationError || param1 == RemoteObjectStatusEnum.SecurityError || param1 == RemoteObjectStatusEnum.UnknownError)
            {
                _loc_2 = ErrorCodeUtils.getErrorCodeByRemoteObject(this, param1);
                this._holder.pingBack.sendError(_loc_2);
                this._holder.runtimeData.errorCode = _loc_2;
            }
            super.setStatus(param1);
            return;
        }// end function

    }
}
