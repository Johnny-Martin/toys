package com.qiyi.player.core.history.parts
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.history.events.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.player.events.*;
    import com.qiyi.player.user.*;
    import flash.events.*;
    import flash.utils.*;

    public class LoginUserHistory extends EventDispatcher
    {
        private var _holder:ICorePlayer;
        private var _user:IUser = null;
        private var _tvid:String;
        private var _timer:Timer;
        private var _firstUpdate:Boolean;
        private var _ready:Boolean;
        private var _videoPlayTime:int;
        private var _lastUploadTime:int = -2147483648;
        private var _downloadServer:DownloadServer;
        private var _uploadServer:UploadServer;
        private var _log:ILogger;
        static const TERMINAL_ID:String = "11";
        static const MIN_HISTORY_TIME:int = 15000;
        static const DEFAULT_HISTORY_TIME:int = -1000;

        public function LoginUserHistory(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.history.parts.LoginUserHistory");
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
            if (this._downloadServer)
            {
                this._downloadServer.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onDownloadServerStatusChanged);
                this._downloadServer.destroy();
            }
            this._downloadServer = new DownloadServer(this._tvid);
            this._downloadServer.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onDownloadServerStatusChanged);
            this._downloadServer.initialize();
            if (this._timer == null)
            {
                this._timer = new Timer(Config.HISTORY_LOGIN_USER_UPLOAD_RATE);
                this._timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            }
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
                this._videoPlayTime = param1 >= MIN_HISTORY_TIME ? (param1) : (DEFAULT_HISTORY_TIME);
            }
            return;
        }// end function

        public function upload() : void
        {
            var _loc_1:Object = null;
            if (this._lastUploadTime != this._videoPlayTime)
            {
                if (this._uploadServer)
                {
                    this._uploadServer.destroy();
                }
                _loc_1 = new Object();
                _loc_1.tvId = this._tvid;
                _loc_1.terminalId = TERMINAL_ID;
                _loc_1.videoPlayTime = this._videoPlayTime;
                this._uploadServer = new UploadServer(_loc_1);
                this._uploadServer.initialize();
                this._lastUploadTime = this._videoPlayTime;
            }
            return;
        }// end function

        public function reset() : void
        {
            this._tvid = null;
            this._ready = false;
            this._firstUpdate = false;
            this._videoPlayTime = DEFAULT_HISTORY_TIME;
            this._lastUploadTime = int.MIN_VALUE;
            if (this._timer)
            {
                this._timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
                this._timer.stop();
                this._timer = null;
            }
            if (this._downloadServer)
            {
                this._downloadServer.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onDownloadServerStatusChanged);
                this._downloadServer.destroy();
                this._downloadServer = null;
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

        private function onTimer(event:TimerEvent) : void
        {
            this.upload();
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

        private function onDownloadServerStatusChanged(event:RemoteObjectEvent) : void
        {
            var _loc_2:* = event.target as DownloadServer;
            if (_loc_2.status == RemoteObjectStatusEnum.Processing)
            {
                return;
            }
            this._ready = true;
            var _loc_3:* = _loc_2.tvid;
            var _loc_4:* = _loc_2.getData();
            this.update(_loc_4 && _loc_4.hasOwnProperty("tvId") ? (_loc_4.videoPlayTime) : (DEFAULT_HISTORY_TIME));
            _loc_2.destroy();
            _loc_2.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onDownloadServerStatusChanged);
            this._downloadServer = null;
            dispatchEvent(new HistoryEvent(HistoryEvent.Evt_Ready, _loc_3));
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
                        this._timer.stop();
                        if (this._holder.currentTime >= MIN_HISTORY_TIME)
                        {
                            this._videoPlayTime = this._holder.currentTime;
                        }
                        this.upload();
                        break;
                    }
                    case StatusEnum.PLAYING:
                    {
                        this._timer.reset();
                        this._timer.start();
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


class DownloadServer extends BaseRemoteObject
{
    private var _tvid:String;
    private var _log:ILogger;

    function DownloadServer(param1:String)
    {
        this._log = Log.getLogger("com.qiyi.player.core.history");
        super(0, "LoginUserHistoryDownloadServer");
        this._tvid = param1;
        _timeout = 1500;
        return;
    }// end function

    public function get tvid() : String
    {
        return this._tvid;
    }// end function

    override public function initialize() : void
    {
        ProcessesTimeRecord.STime_history = getTimer();
        super.initialize();
        return;
    }// end function

    override protected function getRequest() : URLRequest
    {
        var _loc_1:* = new URLRequest(Config.HISTORY_LOGIN_USER_READ_RECORD);
        _loc_1.method = URLRequestMethod.POST;
        var _loc_2:* = new URLVariables();
        _loc_2.tvId = this._tvid;
        _loc_2.limit = 15;
        _loc_2.agent_type = 1;
        _loc_1.data = _loc_2;
        return _loc_1;
    }// end function

    override protected function onComplete(event:Event) : void
    {
        var obj:Object;
        var historyItem:Object;
        var historyTimeData:Object;
        var event:* = event;
        clearTimeout(_waitingResponse);
        _waitingResponse = 0;
        ProcessesTimeRecord.usedTime_history = getTimer() - ProcessesTimeRecord.STime_history;
        try
        {
            obj = JSON.decode(_loader.data);
            if (obj.code != "A00000")
            {
                this._log.info("LoginUserHistoryDownloadServer failed to load history! errorcode: " + obj.code);
                super.onComplete(event);
            }
            else
            {
                historyItem = obj.data;
                historyTimeData;
                historyTimeData.tvId = historyItem.tvId;
                historyTimeData.videoPlayTime = int(historyItem.videoPlayTime * 1000);
                this._data = historyTimeData;
                this._log.debug("download histroy time:" + historyItem.videoPlayTime);
                super.onComplete(event);
            }
        }
        catch (e:Error)
        {
            _log.warn(_name + ": failed to parse data--> " + _loader.data.substr(0, 100));
            setStatus(RemoteObjectStatusEnum.DataError);
        }
        return;
    }// end function

}

