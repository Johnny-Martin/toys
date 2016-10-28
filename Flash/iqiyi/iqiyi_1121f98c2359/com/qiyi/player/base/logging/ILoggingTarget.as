package com.qiyi.player.base.logging
{

    public interface ILoggingTarget
    {

        public function ILoggingTarget();

        function get filters() : Array;

        function set filters(param1:Array) : void;

        function get level() : int;

        function set level(param1:int) : void;

        function addLogger(param1:ILogger) : void;

        function removeLogger(param1:ILogger) : void;

    }
}
