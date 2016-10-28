package com.qiyi.player.core.video.engine.dm.provider
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import flash.utils.*;
    import loader.vod.*;

    public class ProviderStateHandler extends Object
    {
        private var _holder:ICorePlayer;
        private var _log:ILogger;

        public function ProviderStateHandler(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.video.engine.dm.provider.ProviderStateHandler");
            this._holder = param1;
            return;
        }// end function

        public function onStateChanged(param1:Provider) : void
        {
            var _loc_5:Array = null;
            var _loc_6:String = null;
            var _loc_7:EnumItem = null;
            if (param1 == null || param1.fileState == null)
            {
                return;
            }
            var _loc_2:* = param1.fileState.stateCode;
            var _loc_3:* = param1.fileState.data;
            var _loc_4:Object = null;
            if (_loc_2 == FileState.FirstDispatch + FileState.State_Success)
            {
                this._holder.runtimeData.errorCode = 0;
                this._log.debug("Provider.onStateChanged, FirstDispatch, success = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.FirstDispatch + FileState.State_Timeout)
            {
                this._holder.runtimeData.errorCode = 3101;
                this._log.error("Provider.onStateChanged, FirstDispatch, timeout = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.FirstDispatch + FileState.State_ConnectError)
            {
                this._holder.runtimeData.errorCode = 3102;
                this._log.error("Provider.onStateChanged, FirstDispatch, connect error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.FirstDispatch + FileState.State_DataError)
            {
                this._holder.runtimeData.errorCode = 3103;
                this._log.error("Provider.onStateChanged, FirstDispatch, data error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.FirstDispatch + FileState.State_SecurityError)
            {
                this._holder.runtimeData.errorCode = 3105;
                this._log.error("Provider.onStateChanged, FirstDispatch, security error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_Success)
            {
                try
                {
                    this._holder.runtimeData.errorCode = 0;
                    _loc_4 = JSON.decode(_loc_3);
                    this._holder.runtimeData.userDisInfo[param1.fileState.index] = {t:_loc_4.t, z:_loc_4.z};
                    this._holder.runtimeData.preDispatchArea = _loc_4.z;
                    if (UserManager.getInstance().user && UserManager.getInstance().user.level != UserDef.USER_LEVEL_NORMAL)
                    {
                        this._holder.runtimeData.CDNStatus = 0;
                    }
                    else if (_loc_4.hasOwnProperty("s"))
                    {
                        this._holder.runtimeData.CDNStatus = int(_loc_4.s);
                    }
                    if (this._holder.runtimeData.currentUserIP == "")
                    {
                        _loc_5 = String(_loc_4.t).split("-");
                        this._holder.runtimeData.currentUserArea = _loc_5[0];
                        this._holder.runtimeData.currentUserIP = _loc_5[1];
                    }
                    this._log.debug("Provider.onStateChanged, SecondDispatch, success = " + _loc_2);
                }
                catch (e:Error)
                {
                }
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_Timeout)
            {
                this._holder.runtimeData.errorCode = 3201;
                this._log.error("Provider.onStateChanged, SecondDispatch, timeout = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_ConnectError)
            {
                this._holder.runtimeData.errorCode = 3202;
                this._log.error("Provider.onStateChanged, SecondDispatch, connect error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_DataError)
            {
                this._holder.runtimeData.errorCode = 3203;
                this._log.error("Provider.onStateChanged, SecondDispatch, data error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_SecurityError)
            {
                this._holder.runtimeData.errorCode = 3205;
                this._log.error("Provider.onStateChanged, SecondDispatch, security error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_Success || _loc_2 == FileState.AuthChecker + FileState.State_AuthenticationError)
            {
                try
                {
                    this._log.debug("AuthenticationRemote result:" + _loc_3);
                    if (_loc_2 == FileState.AuthChecker + FileState.State_Success)
                    {
                        this._holder.runtimeData.errorCode = 0;
                        this._holder.runtimeData.authenticationError = false;
                        this._log.debug("Provider.onStateChanged, AuthChecker, success = " + _loc_2);
                    }
                    else
                    {
                        this._holder.runtimeData.errorCode = 504;
                        this._log.error("Provider.onStateChanged, AuthChecker, AuthenticationError = " + _loc_2);
                    }
                    _loc_4 = JSON.decode(_loc_3);
                    if (_loc_4.code == "A00000")
                    {
                        this._holder.runtimeData.isTryWatch = _loc_4.data.prv == "1";
                        if (this._holder.runtimeData.isTryWatch)
                        {
                            if (_loc_4.hasOwnProperty("previewType"))
                            {
                                _loc_7 = Utility.getItemById(TryWatchEnum.ITEMS, int(_loc_4.previewType));
                                if (_loc_7)
                                {
                                    this._holder.runtimeData.tryWatchType = _loc_7;
                                }
                            }
                            if (_loc_4.hasOwnProperty("previewTime"))
                            {
                                this._holder.runtimeData.tryWatchTime = int(_loc_4.previewTime) * 60 * 1000;
                            }
                            if (_loc_4.hasOwnProperty("previewEpisodes"))
                            {
                            }
                        }
                        this._holder.runtimeData.dispatcherServerTime = Number(_loc_4.data.st);
                        this._holder.runtimeData.dispatchFlashRunTime = int(getTimer() / 1000);
                    }
                    else
                    {
                        this._holder.runtimeData.authenticationError = true;
                    }
                    for (_loc_6 in _loc_4)
                    {
                        
                        this._holder.runtimeData.authentication[_loc_6] = _loc_4[_loc_6];
                    }
                }
                catch (e:Error)
                {
                }
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_Timeout)
            {
                this._holder.runtimeData.errorCode = 501;
                this._log.error("Provider.onStateChanged, AuthChecker, timeout = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_ConnectError)
            {
                this._holder.runtimeData.errorCode = 502;
                this._log.error("Provider.onStateChanged, AuthChecker, connect error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_DataError)
            {
                this._holder.runtimeData.errorCode = 503;
                this._log.error("Provider.onStateChanged, AuthChecker, data error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_SecurityError)
            {
                this._holder.runtimeData.errorCode = 505;
                this._log.error("Provider.onStateChanged, AuthChecker, security error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_Success)
            {
                this._log.debug("Provider.onStateChanged, AuthDispatch, success = " + _loc_2);
                try
                {
                    this._holder.runtimeData.errorCode = 0;
                    _loc_4 = JSON.decode(_loc_3);
                    this._holder.runtimeData.userDisInfo[param1.fileState.index] = {t:_loc_4.t, z:_loc_4.z};
                    this._holder.runtimeData.preDispatchArea = _loc_4.z;
                    if (this._holder.runtimeData.currentUserIP == "")
                    {
                        this._holder.runtimeData.currentUserIP = String(_loc_4.t).split("-")[1];
                    }
                }
                catch (e:Error)
                {
                }
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_Timeout)
            {
                this._holder.runtimeData.errorCode = 3201;
                this._log.error("Provider.onStateChanged, AuthDispatch, timeout = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_ConnectError)
            {
                this._holder.runtimeData.errorCode = 3202;
                this._log.error("Provider.onStateChanged, AuthDispatch, connect error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_DataError)
            {
                this._holder.runtimeData.errorCode = 3203;
                this._log.error("Provider.onStateChanged, AuthDispatch, data error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_SecurityError)
            {
                this._holder.runtimeData.errorCode = 3205;
                this._log.error("Provider.onStateChanged, AuthDispatch, security error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_Success)
            {
                this._holder.runtimeData.errorCode = 0;
                this._log.debug("Provider.onStateChanged, CDNRequest, success = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_Timeout)
            {
                this._holder.runtimeData.errorCode = 4011;
                this._log.error("Provider.onStateChanged, CDNRequest, timeout = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_ConnectError)
            {
                this._holder.runtimeData.errorCode = 4012;
                this._log.error("Provider.onStateChanged, CDNRequest, connect error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_DataError)
            {
                this._holder.runtimeData.errorCode = 4016;
                this._log.error("Provider.onStateChanged, CDNRequest, data error = " + _loc_2);
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_SecurityError)
            {
                this._holder.runtimeData.errorCode = 4017;
                this._log.error("Provider.onStateChanged, CDNRequest, security error = " + _loc_2);
                return;
            }
            return;
        }// end function

        public function onFinalError(param1:Provider) : void
        {
            if (param1 == null || param1.fileState == null)
            {
                return;
            }
            var _loc_2:* = param1.fileState.stateCode;
            var _loc_3:* = param1.fileState.data;
            this._log.error("Provider.onFinalError, code = " + _loc_2);
            if (_loc_2 == FileState.FirstDispatch + FileState.State_Timeout)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.FirstDispatch + FileState.State_ConnectError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.FirstDispatch + FileState.State_DataError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.FirstDispatch + FileState.State_SecurityError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_Timeout)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_ConnectError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_DataError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.SecondDispatch + FileState.State_SecurityError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_Timeout)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_ConnectError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_DataError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.AuthChecker + FileState.State_SecurityError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_Timeout)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_ConnectError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_DataError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.AuthDispatch + FileState.State_SecurityError)
            {
                this._holder.pingBack.sendError(this._holder.runtimeData.errorCode);
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_Timeout)
            {
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_ConnectError)
            {
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_DataError)
            {
                return;
            }
            if (_loc_2 == FileState.CDNRequest + FileState.State_SecurityError)
            {
                return;
            }
            return;
        }// end function

    }
}
