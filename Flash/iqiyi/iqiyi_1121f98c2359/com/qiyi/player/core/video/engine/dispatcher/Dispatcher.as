package com.qiyi.player.core.video.engine.dispatcher
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.remote.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.video.events.*;
    import flash.events.*;

    public class Dispatcher extends EventDispatcher
    {
        private var _ro:IRemoteObject;
        private var _segment:Segment;
        private var _url:String;
        private var _startPos:int;
        private var _authRetried:Boolean;
        private var _holder:ICorePlayer;
        private var _log:ILogger;

        public function Dispatcher(param1:ICorePlayer)
        {
            this._log = Log.getLogger("com.qiyi.player.core.video.engine.dispatcher.Dispatcher");
            this._authRetried = false;
            this._holder = param1;
            return;
        }// end function

        public function start(param1:Segment, param2:int = -1) : void
        {
            this._log.info("Dispatcher (index: " + param1.index + ") start!");
            this._segment = param1;
            this._startPos = param2;
            if (this._holder.runtimeData.movieIsMember)
            {
                this._ro = new MemberDispatchRemote(this._segment, this._startPos, this._holder);
            }
            else
            {
                this._ro = new FirstDispatchRemote(param1, this._holder);
            }
            this._ro.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onRemoteObjectStatusChanged);
            this._ro.initialize();
            return;
        }// end function

        private function onRemoteObjectStatusChanged(event:RemoteObjectEvent) : void
        {
            if (this._ro == null)
            {
                return;
            }
            this._ro.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onRemoteObjectStatusChanged);
            if (this._ro.status == RemoteObjectStatusEnum.Success)
            {
                if (!this.gotoNextProcess())
                {
                    this._log.info("Dispatcher (index: " + this._segment.index + ") success!");
                    dispatchEvent(new DispatcherEvent(DispatcherEvent.Evt_Success, this._url));
                }
            }
            else if (this._ro is MemberDispatchRemote && !this._authRetried)
            {
                this._authRetried = true;
                this._ro.destroy();
                this._ro = new AuthenticationRemote(this._segment, this._holder);
                this._ro.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onRemoteObjectStatusChanged);
                this._ro.initialize();
            }
            else
            {
                this._log.info("Dispatcher (index: " + this._segment.index + ") failed! errno=" + ErrorCodeUtils.getErrorCodeByRemoteObject(this._ro, this._ro.status));
                dispatchEvent(new DispatcherEvent(DispatcherEvent.Evt_Failed, this._ro));
            }
            return;
        }// end function

        private function gotoNextProcess() : Boolean
        {
            if (this._ro is AuthenticationRemote)
            {
                if (this._ro.getData().code == "A00000")
                {
                    this._ro.destroy();
                    this._ro = new MemberDispatchRemote(this._segment, this._startPos, this._holder);
                    this._ro.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onRemoteObjectStatusChanged);
                    this._ro.initialize();
                }
                else
                {
                    this._log.info("failed to Authentication. code = " + this._ro.getData().code);
                    dispatchEvent(new DispatcherEvent(DispatcherEvent.Evt_Failed, this._ro));
                }
            }
            else if (this._ro is FirstDispatchRemote)
            {
                this._ro.destroy();
                this._ro = new SecondDispatchRemote(this._segment, this._startPos, this._holder);
                this._ro.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onRemoteObjectStatusChanged);
                this._ro.initialize();
            }
            else
            {
                this._url = this._ro.getData().l;
                return false;
            }
            return true;
        }// end function

        public function stop() : void
        {
            if (this._ro)
            {
                this._ro.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onRemoteObjectStatusChanged);
                this._ro.destroy();
                this._ro = null;
                this._log.info("Dispatcher(index: " + this._segment.index + ") stop!");
            }
            this._segment = null;
            this._authRetried = false;
            return;
        }// end function

    }
}
