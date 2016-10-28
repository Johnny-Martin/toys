package com.qiyi.player.core.video.engine.dm.provider
{
    import com.iqiyi.components.global.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.events.*;
    import flash.events.*;
    import flash.net.*;
    import loader.vod.*;

    public class Provider extends EventDispatcher implements IDestroy
    {
        private var _file:File;
        private var _loadingFailed:Boolean = false;
        private var _stuckToggle:Boolean = false;
        private var _userPauseToggle:Boolean = false;
        private var _isStopLoadingCalled:Boolean = false;
        private var _log:ILogger;

        public function Provider()
        {
            this._log = Log.getLogger("com.qiyi.player.core.video.provider.Provider");
            return;
        }// end function

        public function get fileState() : FileState
        {
            if (this._file)
            {
                return this._file.fileState;
            }
            return null;
        }// end function

        public function get bufferLength() : int
        {
            if (this._file)
            {
                return this._file.bufferLength;
            }
            return 0;
        }// end function

        public function get eof() : Boolean
        {
            if (this._file)
            {
                return this._file.eof;
            }
            return false;
        }// end function

        public function get loadingFailed() : Boolean
        {
            return this._loadingFailed;
        }// end function

        public function get loadComplete() : Boolean
        {
            if (this._file)
            {
                return this._file.done;
            }
            return false;
        }// end function

        public function initProvider(param1:IDecoder, param2:Object, param3:Number, param4:Array, param5:Array, param6:int, param7:int, param8:String, param9:int, param10:String, param11:String, param12:Number, param13:int, param14:String, param15:Boolean, param16:Boolean, param17:String, param18:String, param19:String, param20:Function, param21:Boolean, param22:String, param23:String) : void
        {
            if (this._file == null)
            {
                this._isStopLoadingCalled = false;
                this._file = P2PFileLoader.instance.getFile();
                this._file.addEventListener(File.Evt_P2P_StateChange, this.onStateChanged);
                this._file.addEventListener(File.Evt_P2P_Final_Error, this.onError);
                this._file.initFile(GlobalStage.stage, param1 as NetStream, param2, param19, param12, param3, param4, param5, param7, param8, param6, param9, param10, param11, param13, param14, param15, param16, param17, param18, this._log, param20, param21, param22, param23);
            }
            return;
        }// end function

        public function setOpenPlay(param1:Boolean) : void
        {
            if (this._file)
            {
                this._log.info("p2p provider setOpenPlay: " + param1);
                this._file.playing = param1;
            }
            return;
        }// end function

        public function setExpectTime(param1:int) : void
        {
            if (this._file)
            {
                this._file.expectPlayTime = param1;
            }
            return;
        }// end function

        public function setMetaInfo(param1:Array) : void
        {
            if (this._file)
            {
                this._file.metaInfo = param1;
            }
            return;
        }// end function

        public function setStartTime(param1:int) : void
        {
            if (this._file)
            {
                this._file.startTime = param1;
            }
            return;
        }// end function

        public function setEndTime(param1:int) : void
        {
            if (this._file)
            {
                this._file.endTime = param1;
            }
            return;
        }// end function

        public function seek(param1:int, param2:int, param3:int, param4:int = 0) : void
        {
            var _loc_5:int = 0;
            if (this._file)
            {
                this._isStopLoadingCalled = false;
                _loc_5 = 0;
                if ((param4 & SeekTypeEnum.SKIP_ENJOYABLE_POINT) != 0)
                {
                    _loc_5 = -1;
                }
                else
                {
                    _loc_5 = 0;
                }
                this._file.seek(param1, param3, param2, _loc_5);
            }
            return;
        }// end function

        public function sequenceReadData() : MediaData
        {
            var _loc_1:VideoData = null;
            var _loc_2:MediaData = null;
            if (this._file)
            {
                _loc_1 = this._file.read();
                if (_loc_1)
                {
                    _loc_2 = new MediaData();
                    _loc_2.headers = _loc_1.headers;
                    _loc_2.duration = _loc_1.duration;
                    _loc_2.time = _loc_1.time;
                    _loc_2.jumpFragment = _loc_1.jumpFragment;
                    _loc_2.bytes = _loc_1.bytes;
                    _loc_2.encode = _loc_1.encode;
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function sequenceReadDataFrom(param1:int) : MediaData
        {
            var _loc_2:VideoData = null;
            var _loc_3:MediaData = null;
            if (this._file)
            {
                _loc_2 = this._file.readFrom(param1);
                if (_loc_2)
                {
                    _loc_3 = new MediaData();
                    _loc_3.headers = _loc_2.headers;
                    _loc_3.duration = _loc_2.duration;
                    _loc_3.time = _loc_2.time;
                    _loc_3.jumpFragment = _loc_2.jumpFragment;
                    _loc_3.bytes = _loc_2.bytes;
                    return _loc_3;
                }
            }
            return null;
        }// end function

        public function setFragments(param1:Array) : void
        {
            if (this._file)
            {
                this._file.fragments = param1;
            }
            return;
        }// end function

        public function setStuckToggle(param1:Boolean) : void
        {
            if (this._stuckToggle != param1)
            {
                this._stuckToggle = param1;
                if (this._file)
                {
                    this._file.lag = param1;
                }
            }
            return;
        }// end function

        public function setUserPauseToggle(param1:Boolean) : void
        {
            if (this._userPauseToggle != param1)
            {
                this._userPauseToggle = param1;
                if (this._file)
                {
                    this._file.userPause = param1;
                }
            }
            return;
        }// end function

        public function setLoadToggle(param1:Boolean) : void
        {
            if (this._isStopLoadingCalled && !param1)
            {
                return;
            }
            if (this._file)
            {
                this._log.info("call setLoadToggle value:" + param1);
                this._isStopLoadingCalled = !param1;
                this._file.setToggleLoading(param1);
            }
            return;
        }// end function

        public function destroy() : void
        {
            if (this._file)
            {
                this._file.removeEventListener(File.Evt_P2P_StateChange, this.onStateChanged);
                this._file.removeEventListener(File.Evt_P2P_Final_Error, this.onError);
                this._file.clear();
                this._file = null;
            }
            return;
        }// end function

        private function onStateChanged(event:Event) : void
        {
            dispatchEvent(new ProviderEvent(ProviderEvent.Evt_StateChanged));
            return;
        }// end function

        private function onError(event:Event) : void
        {
            this._isStopLoadingCalled = false;
            this._loadingFailed = true;
            dispatchEvent(new ProviderEvent(ProviderEvent.Evt_Failed));
            return;
        }// end function

    }
}
