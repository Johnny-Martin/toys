package com.qiyi.player.core.video.engine
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.video.render.*;
    import flash.net.*;

    public interface IEngine extends IEventDispatcher, IDestroy
    {

        public function IEngine();

        function get movie() : IMovie;

        function get status() : EnumItem;

        function get currentTime() : int;

        function get bufferTime() : int;

        function get playingDuration() : int;

        function get waitingDuration() : int;

        function get stopReason() : EnumItem;

        function get frameRate() : int;

        function get decoderInfo() : NetStreamInfo;

        function set openSelectPlay(param1:Boolean) : void;

        function bind(param1:IMovie, param2:IRender) : void;

        function startLoad() : void;

        function stopLoad() : void;

        function play() : void;

        function replay() : void;

        function pause(param1:int = 0) : void;

        function resume() : void;

        function stop(param1:EnumItem) : void;

        function seek(param1:uint, param2:int = 0) : void;

        function startLoadMeta() : void;

        function startLoadLicense() : void;

        function startLoadHistory() : void;

        function startLoadP2PCore() : void;

        function checkEngineIsReady() : Boolean;

    }
}
