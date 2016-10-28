package com.qiyi.player.core.model.remote
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class FirstDispatchRemote extends BaseRemoteObject
    {
        private var _segment:Segment;
        private var _holder:ICorePlayer;
        private var _log:ILogger;

        public function FirstDispatchRemote(param1:Segment, param2:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.remote.FirstDispatchRemote");
            super(0, "FirstDispatchRemote" + Math.random());
            this._segment = param1;
            this._holder = param2;
            _timeout = Config.DISPATCH_TIMEOUT;
            _retryMaxCount = Config.DISPATCH_MAX_RETRY;
            return;
        }// end function

        override protected function getRequest() : URLRequest
        {
            var _loc_1:* = Config.FIRST_DISPATCH_URL + "?tn=" + Math.random();
            return new URLRequest(_loc_1);
        }// end function

        override public function initialize() : void
        {
            if (DispatcherUtils.isNeedDispatch(this._holder) && this._holder.runtimeData.dispatcherServerTime == 0)
            {
                super.initialize();
            }
            else
            {
                this.onComplete(null);
            }
            return;
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var time:uint;
            var s:String;
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            try
            {
                time;
                if (event)
                {
                    _data = JSON.decode(_loader.data);
                    this._holder.runtimeData.dispatchFlashRunTime = int(getTimer() / 1000);
                    this._holder.runtimeData.dispatcherServerTime = uint(_data.t);
                    time = this._holder.runtimeData.dispatcherServerTime;
                }
                else
                {
                    time = uint(getTimer() / 1000) - this._holder.runtimeData.dispatchFlashRunTime + this._holder.runtimeData.dispatcherServerTime;
                }
                this._holder.runtimeData.key = KeyUtils.getDispatchKey(time, this._segment.rid);
                super.onComplete(event);
            }
            catch (e:Error)
            {
                _log.error("FirstDispatch parse JSON error:");
                s = _loader.data;
                if (s)
                {
                    _log.info(s.substr(0, 100));
                }
                this.dispatchEvent(new RemoteObjectEvent(RemoteObjectEvent.Evt_Exception, e));
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
