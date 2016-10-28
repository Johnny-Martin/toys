package com.qiyi.player.core.model
{

    public interface IWriteStatus
    {

        public function IWriteStatus();

        function addStatus(param1:int, param2:Boolean = true) : void;

        function removeStatus(param1:int, param2:Boolean = true) : void;

    }
}
