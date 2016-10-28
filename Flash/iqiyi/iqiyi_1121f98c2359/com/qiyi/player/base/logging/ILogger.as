package com.qiyi.player.base.logging
{

    public interface ILogger extends IEventDispatcher
    {

        public function ILogger();

        function get category() : String;

        function log(param1:int, param2:String, ... args) : void;

        function debug(param1:String, ... args) : void;

        function error(param1:String, ... args) : void;

        function fatal(param1:String, ... args) : void;

        function info(param1:String, ... args) : void;

        function warn(param1:String, ... args) : void;

    }
}
