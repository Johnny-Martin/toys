package com.qiyi.player.core.history.parts
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.history.events.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.player.events.*;
    import com.qiyi.player.user.*;
    import flash.events.*;

    public class UnLoginUserHistory extends EventDispatcher
    {
        private var _holder:ICorePlayer;
        private var _user:IUser = null;
        private var _firstUpdate:Boolean = false;
        private var _tvid:String;
        private var _videoPlayTime:int;
        private var _lastUploadTime:int = -2147483648;
        private var _ready:Boolean;
        private var _uploadServer:UploadServer;
        private var _log:ILogger;
        static const DEFAULT_HISTORY_TIME:int = -1000;

        public function UnLoginUserHistory(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.history.parts.UnLoginUserHistory");
            this._ready = false;
            this._firstUpdate = false;
            this._videoPlayTime = DEFAULT_HISTORY_TIME;
            this._holder = param1;
            this._holder.addEventListener(PlayerEvent.Evt_StatusChanged, this.onVideoStatusChanged);
            return;
        }// end function

        public function getReady() : Boolean
        {
            return this._ready;
        }// end function

        public function get videoPlayTime() : int
        {
            return this._videoPlayTime;
        }// end function

        public function loadRecord(param1:String) : void
        {
            if (this._tvid == param1)
            {
                return;
            }
            this._tvid = param1;
            this._ready = true;
            this.update(LocalHistorySO.readHistoryTime(this._tvid));
            dispatchEvent(new HistoryEvent(HistoryEvent.Evt_Ready, this._tvid));
            return;
        }// end function

        public function reset() : void
        {
            this._tvid = null;
            this._ready = false;
            this._firstUpdate = false;
            this._videoPlayTime = DEFAULT_HISTORY_TIME;
            this._lastUploadTime = int.MIN_VALUE;
            return;
        }// end function

        public function load(param1:IUser) : void
        {
            this._user = param1;
            if (this._holder.hasStatus(StatusEnum.ALREADY_PLAY) && !this._holder.hasStatus(StatusEnum.STOPED) && !this._holder.hasStatus(StatusEnum.FAILED))
            {
                this.update(this._holder.currentTime);
                this.upload();
            }
            return;
        }// end function

        public function update(param1:int) : void
        {
            if (this._tvid == null)
            {
                return;
            }
            if (this._holder.hasStatus(StatusEnum.STOPPING))
            {
                this._videoPlayTime = 0;
            }
            else
            {
                this._videoPlayTime = param1 >= LoginUserHistory.MIN_HISTORY_TIME ? (param1) : (DEFAULT_HISTORY_TIME);
            }
            return;
        }// end function

        public function upload() : void
        {
            var _loc_1:Object = null;
            if (this._holder && this._holder.runtimeData.recordHistory && !this._holder.isPreload)
            {
                if (this._lastUploadTime != this._videoPlayTime)
                {
                    if (this._uploadServer)
                    {
                        this._uploadServer.destroy();
                    }
                    _loc_1 = new Object();
                    _loc_1.tvId = this._tvid;
                    _loc_1.terminalId = LoginUserHistory.TERMINAL_ID;
                    _loc_1.videoPlayTime = this._videoPlayTime;
                    LocalHistorySO.writeHistoryTime(this._tvid, this._videoPlayTime);
                    this._uploadServer = new UploadServer(this._holder.uuid, _loc_1);
                    this._uploadServer.initialize();
                    this._lastUploadTime = this._videoPlayTime;
                }
            }
            return;
        }// end function

        public function destroy() : void
        {
            this.reset();
            if (this._uploadServer)
            {
                this._uploadServer.destroy();
                this._uploadServer = null;
            }
            if (this._holder)
            {
                this._holder.removeEventListener(PlayerEvent.Evt_StatusChanged, this.onVideoStatusChanged);
                this._holder = null;
            }
            return;
        }// end function

        private function onFirstUpdate() : void
        {
            if (!this._firstUpdate)
            {
                this._firstUpdate = true;
                this.upload();
            }
            return;
        }// end function

        private function onVideoStatusChanged(event:PlayerEvent) : void
        {
            if (this._holder.runtimeData.recordHistory && this._holder.hasStatus(StatusEnum.ALREADY_PLAY) && Boolean(event.data.isAdd))
            {
                switch(event.data.status)
                {
                    case StatusEnum.PAUSED:
                    case StatusEnum.FAILED:
                    {
                        if (this._holder.currentTime >= LoginUserHistory.MIN_HISTORY_TIME)
                        {
                            this._videoPlayTime = this._holder.currentTime;
                        }
                        this.upload();
                        break;
                    }
                    case StatusEnum.PLAYING:
                    {
                        this.onFirstUpdate();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

    }
}

class UploadServer extends BaseRemoteObject
{
    private var _updateData:Object;
    private var _log:ILogger;

    function UploadServer(param1:Object)
    {
        this._log = Log.getLogger("com.qiyi.player.core.history");
        super(0, "LoginUserHistoryUploadServer");
        this._updateData = param1;
        _retryMaxCount = 5;
        return;
    }// end function

    override protected function getRequest() : URLRequest
    {
        var _loc_1:* = new URLRequest(Config.HISTORY_LOGIN_USER_UPLOAD_URL);
        _loc_1.method = URLRequestMethod.POST;
        var _loc_2:* = new URLVariables();
        _loc_2.tvId = this._updateData.tvId;
        _loc_2.terminalId = this._updateData.terminalId;
        _loc_2.videoPlayTime = int(this._updateData.videoPlayTime / 1000);
        _loc_2.agent_type = 1;
        this._log.debug("upload time:" + _loc_2.videoPlayTime);
        _loc_1.data = _loc_2;
        return _loc_1;
    }// end function

    override protected function onComplete(event:Event) : void
    {
        var obj:Object;
        var event:* = event;
        clearTimeout(_waitingResponse);
        _waitingResponse = 0;
        try
        {
            obj = JSON.decode(_loader.data);
            if (obj.code != "A00000")
            {
                this._log.info("failed to upload history! errorcode: " + obj.code);
            }
            else
            {
                this._log.info("success to upload history!");
            }
            super.onComplete(event);
        }
        catch (e:Error)
        {
            _log.warn(_name + ": failed to parse data--> " + _loader.data.substr(0, 100));
            setStatus(RemoteObjectStatusEnum.DataError);
        }
        return;
    }// end function

}

