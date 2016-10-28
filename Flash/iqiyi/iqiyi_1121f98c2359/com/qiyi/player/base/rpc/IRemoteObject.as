package com.qiyi.player.base.rpc
{
    import com.qiyi.player.base.pub.*;

    public interface IRemoteObject extends IEventDispatcher
    {

        public function IRemoteObject();

        function get id() : Number;

        function get name() : String;

        function get retryMaxCount() : int;

        function get retryCount() : int;

        function initialize() : void;

        function update() : void;

        function destroy() : void;

        function getData() : Object;

        function get url() : String;

        function get status() : EnumItem;

    }
}
