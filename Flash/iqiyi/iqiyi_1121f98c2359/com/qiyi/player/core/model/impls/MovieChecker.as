package com.qiyi.player.core.model.impls
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.events.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.remote.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.user.impls.*;
    import flash.events.*;
    import flash.utils.*;

    public class MovieChecker extends EventDispatcher
    {
        private var _log:ILogger;
        private var _holder:ICorePlayer;
        private var _movie:IMovie;
        private var _movieInfo:MovieInfo;
        private var _currentTvid:String;
        private var _currentVid:String;
        private var _isSuccess:Boolean;
        private var _mixerRemote:MixerRemote;
        private var _authRemote:AuthenticationRemote;
        private var _failHappened:Boolean;

        public function MovieChecker(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.impls.MovieChecker");
            this._holder = param1;
            this._currentTvid = "";
            this._currentVid = "";
            this._isSuccess = false;
            this._failHappened = false;
            return;
        }// end function

        public function getIsSuccess() : Boolean
        {
            return this._isSuccess;
        }// end function

        public function getMovie() : IMovie
        {
            return this._movie;
        }// end function

        public function getMovieInfo() : IMovieInfo
        {
            return this._movieInfo;
        }// end function

        public function getCurrentTvid() : String
        {
            return this._currentTvid;
        }// end function

        public function getCurrentVid() : String
        {
            return this._currentVid;
        }// end function

        public function clearMovie() : void
        {
            this.stopMixerRemote();
            this.stopAuthRemote();
            if (this._movie)
            {
                this._movie.destroy();
                this._movie = null;
            }
            if (this._movieInfo)
            {
                this._movieInfo.destroy();
                this._movieInfo = null;
            }
            this._currentTvid = "";
            this._currentVid = "";
            this._isSuccess = false;
            this._failHappened = false;
            return;
        }// end function

        public function checkout(param1:String, param2:String) : void
        {
            this.clearMovie();
            this._currentTvid = param1;
            this._currentVid = param2;
            this._holder.runtimeData.isTryWatch = false;
            this._holder.runtimeData.tryWatchType = TryWatchEnum.NONE;
            this._holder.runtimeData.tryWatchTime = 0;
            this._holder.runtimeData.authenticationTipType = -1;
            this._holder.runtimeData.authentication = {};
            this._holder.runtimeData.auth_ttype = 0;
            this._holder.runtimeData.auth_rtime = 0;
            this._holder.runtimeData.auth_ptime = 0;
            this.startMixerRemote();
            return;
        }// end function

        private function startAuthRemote() : void
        {
            var _loc_1:* = this._movie.curDefinition.findSegmentAt(0);
            if (_loc_1 != null)
            {
                this._authRemote = new AuthenticationRemote(_loc_1, this._holder);
                this._authRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onAuthRemoteStatusChanged);
                this._authRemote.initialize();
            }
            else
            {
                this._log.info("segment is null, lead to fail to Authentication");
                this.onFailed();
            }
            return;
        }// end function

        private function stopAuthRemote() : void
        {
            if (this._authRemote)
            {
                this._authRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onAuthRemoteStatusChanged);
                this._authRemote.destroy();
                this._authRemote = null;
            }
            return;
        }// end function

        private function onAuthRemoteStatusChanged(event:RemoteObjectEvent) : void
        {
            var _loc_2:Object = null;
            if (this._authRemote.status == RemoteObjectStatusEnum.Success)
            {
                _loc_2 = this._authRemote.getData();
                if (_loc_2.code == "A00000")
                {
                    this.onSucceeded();
                }
                else
                {
                    this._log.info("failed to Authentication, code = " + _loc_2.code);
                    this._holder.runtimeData.errorCode = 504;
                    this.onFailed();
                }
            }
            else
            {
                this.onFailed();
            }
            return;
        }// end function

        private function startMixerRemote() : void
        {
            this._mixerRemote = new MixerRemote(this._holder);
            this._mixerRemote.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onMixerRemoteStatusChanged);
            this._mixerRemote.initialize();
            return;
        }// end function

        private function stopMixerRemote() : void
        {
            if (this._mixerRemote)
            {
                this._mixerRemote.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onMixerRemoteStatusChanged);
                this._mixerRemote.destroy();
                this._mixerRemote = null;
            }
            return;
        }// end function

        private function onMixerRemoteStatusChanged(event:RemoteObjectEvent) : void
        {
            var _loc_2:String = null;
            if (this._mixerRemote.status == RemoteObjectStatusEnum.Success)
            {
                _loc_2 = this._mixerRemote.getData().code;
                if (_loc_2 == "A000000")
                {
                    this.onMixerRemoteSucceeded();
                }
                else
                {
                    this._holder.runtimeData.errorCode = MixerRemote.VMSErrorMap[_loc_2];
                    this._log.error("vms checked error, code: " + _loc_2);
                    this.onFailed();
                }
            }
            else
            {
                this.onFailed();
            }
            return;
        }// end function

        private function onMixerRemoteSucceeded() : void
        {
            if (this._holder.runtimeData.CDNStatus == -1 && this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
            {
                this.parseF4v();
            }
            if (!this._failHappened)
            {
                this.parseVi();
            }
            if (!this._failHappened)
            {
                this.createMovieInfo();
            }
            if (!this._failHappened)
            {
                this.parseVp();
            }
            if (!this._failHappened)
            {
                this.createMovie();
            }
            if (!this._failHappened)
            {
                if (this._holder.runtimeData.movieIsMember)
                {
                    this.stopAuthRemote();
                    this.startAuthRemote();
                }
                else
                {
                    this.onSucceeded();
                }
            }
            return;
        }// end function

        private function parseF4v() : void
        {
            var area:String;
            var l:String;
            var lArr:Array;
            var lSubArr:Array;
            var f4v:* = this._mixerRemote.getData().f4v;
            if (f4v == null)
            {
                this._log.warn("Vf4v catched error, Vf4v is null");
                return;
            }
            try
            {
                this._log.info("Vf4v Result: " + JSON.encode(f4v));
                if (UserManager.getInstance().user && UserManager.getInstance().user.level != UserDef.USER_LEVEL_NORMAL)
                {
                    this._holder.runtimeData.CDNStatus = 0;
                }
                else
                {
                    this._holder.runtimeData.CDNStatus = f4v.hasOwnProperty("s") ? (int(f4v.s)) : (0);
                }
                if (f4v.hasOwnProperty("r"))
                {
                    this._holder.runtimeData.openFlashP2P = true;
                    this._holder.runtimeData.stratusIP = (f4v.r as String).split("//")[1];
                }
                else
                {
                    this._holder.runtimeData.openFlashP2P = false;
                }
                this._holder.runtimeData.smallOperators = f4v.hasOwnProperty("m") ? (f4v.m == "1") : (false);
                this._holder.runtimeData.dispatcherServerTime = uint(f4v.time);
                this._holder.runtimeData.dispatchFlashRunTime = int(getTimer() / 1000);
                area = (f4v.t as String).split("|")[0];
                this._log.info("the user node is in " + area);
                this._holder.runtimeData.oversea = Settings.instance.boss ? (0) : (area == "OVERSEA" ? (1) : (0));
                this._holder.runtimeData.userArea = f4v.t as String;
                if (f4v.l)
                {
                    l = f4v.l;
                    lArr = l.split("://");
                    if (lArr && lArr.length >= 2)
                    {
                        lSubArr = String(lArr[1]).split("/");
                        if (lSubArr && lSubArr.length > 0 && lSubArr[0])
                        {
                            RuntimeData.VInfoDisIP = String(lSubArr[0]);
                        }
                    }
                }
            }
            catch (e:Error)
            {
                _log.info("parse Vf4v field error:" + e.message);
                pingbackError(403);
            }
            return;
        }// end function

        private function parseVi() : void
        {
            var _loc_1:* = this._mixerRemote.getData().vi;
            var _loc_2:* = this._mixerRemote.getData().f4v;
            if (_loc_1 == null || !_loc_1.hasOwnProperty("st"))
            {
                this._log.debug("vi st is lose: " + this._mixerRemote.originalContent);
                this.pingbackError(603);
                this.onFailed();
                if (this._holder.pingBack)
                {
                    this._holder.pingBack.sendErrorAuto(603, 0, _loc_2);
                }
                return;
            }
            var _loc_3:* = int(_loc_1.st);
            var _loc_4:* = _loc_3 == 200;
            if (!_loc_4)
            {
                this.pingbackError(604);
                this.onFailed();
                if (this._holder.pingBack)
                {
                    this._holder.pingBack.sendErrorAuto(604, _loc_3, _loc_2);
                }
            }
            return;
        }// end function

        private function parseVp() : void
        {
            var _loc_1:* = this._mixerRemote.getData().vp;
            var _loc_2:* = this._mixerRemote.getData().f4v;
            if (_loc_1 == null || !_loc_1.hasOwnProperty("st"))
            {
                this._log.debug("vp st is lose: " + this._mixerRemote.originalContent);
                this.pingbackError(103);
                this.onFailed();
                if (this._holder.pingBack)
                {
                    this._holder.pingBack.sendErrorAuto(103, 0, _loc_2);
                }
                return;
            }
            var _loc_3:* = int(_loc_1.st);
            var _loc_4:* = _loc_3 > 100 && _loc_3 < 200;
            if (!_loc_4)
            {
                this._holder.runtimeData.errorCodeValue = _loc_1;
                this._log.info("vrs status:" + _loc_3);
                this.pingbackError(104);
                this.onFailed();
                if (this._holder.pingBack)
                {
                    this._holder.pingBack.sendErrorAuto(104, _loc_3, _loc_2);
                }
            }
            return;
        }// end function

        private function pingbackError(param1:int) : void
        {
            if (this._holder.pingBack)
            {
                this._holder.pingBack.sendError(param1);
            }
            this._holder.runtimeData.errorCode = param1;
            return;
        }// end function

        private function createMovieInfo() : void
        {
            var f4v:Object;
            try
            {
                this._movieInfo = new MovieInfo(this._holder);
                this._movieInfo.startInitByInfo(this._mixerRemote.getData().vi);
            }
            catch (e:Error)
            {
                _log.debug("vi init model error: " + _mixerRemote.originalContent);
                _log.info("create movieInfo error:" + e.message);
                f4v = _mixerRemote.getData().f4v;
                pingbackError(603);
                onFailed();
                if (_holder.pingBack)
                {
                    _holder.pingBack.sendErrorAuto(603, 0, f4v);
                }
            }
            return;
        }// end function

        private function createMovie() : void
        {
            var definitionType:EnumItem;
            var f4v:Object;
            try
            {
                this._movie = new Movie(this._mixerRemote.getData().vp, this._holder.runtimeData.movieIsMember, this._holder);
                if (this._movie.ipLimited && this._holder.runtimeData.oversea == 1 && !Settings.instance.boss)
                {
                    this.pingbackError(5000);
                    this.onFailed();
                    return;
                }
                definitionType = this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN ? (DefinitionUtils.getCurrentDefinition(this._holder)) : (DefinitionEnum.LIMIT);
                this._movie.setCurAudioTrack(Settings.instance.audioTrack, definitionType);
                if (this._holder.runtimeData.originalEndTime > this._movie.duration)
                {
                    this._holder.runtimeData.originalEndTime = this._movie.duration;
                }
                this._holder.runtimeData.qipuId = this._movie.qipuId;
            }
            catch (e:Error)
            {
                _log.debug("vp init model error: " + _mixerRemote.originalContent);
                _log.info("create movie error:" + e.message);
                f4v = _mixerRemote.getData().f4v;
                pingbackError(103);
                onFailed();
                if (_holder.pingBack)
                {
                    _holder.pingBack.sendErrorAuto(103, 0, f4v);
                }
            }
            return;
        }// end function

        private function onFailed() : void
        {
            this._currentTvid = "";
            this._currentVid = "";
            this._failHappened = true;
            this.stopAuthRemote();
            this.stopMixerRemote();
            dispatchEvent(new MovieEvent(MovieEvent.Evt_Failed));
            return;
        }// end function

        private function onSucceeded() : void
        {
            dispatchEvent(new MovieEvent(MovieEvent.Evt_MovieInfoReady));
            if (this._holder.runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
            {
                this._movie.startLoadAddedSkipPoints();
            }
            this._currentTvid = "";
            this._currentVid = "";
            this._isSuccess = true;
            dispatchEvent(new MovieEvent(MovieEvent.Evt_Success));
            return;
        }// end function

    }
}
