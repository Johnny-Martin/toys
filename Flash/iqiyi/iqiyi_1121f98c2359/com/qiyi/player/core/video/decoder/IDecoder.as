package com.qiyi.player.core.video.decoder
{
    import com.qiyi.player.base.pub.*;
    import flash.net.*;

    public interface IDecoder extends IEventDispatcher, IDestroy
    {

        public function IDecoder();

        function get netstream() : NetStream;

        function get metadata() : Object;

        function get bufferLength() : Number;

        function get time() : Number;

        function get bufferTime() : Number;

        function set bufferTime(param1:Number) : void;

        function get status() : EnumItem;

        function play(... args) : void;

        function stop() : void;

        function seek(param1:Number) : void;

        function pause() : void;

        function resume() : void;

        function setLicense(param1:String) : int;

    }
}
