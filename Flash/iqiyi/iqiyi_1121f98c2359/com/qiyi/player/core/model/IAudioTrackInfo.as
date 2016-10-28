package com.qiyi.player.core.model
{
    import com.qiyi.player.base.pub.*;

    public interface IAudioTrackInfo
    {

        public function IAudioTrackInfo();

        function get isDefault() : Boolean;

        function get type() : EnumItem;

        function get definitionCount() : int;

        function findDefinitionInfoAt(param1:int) : IDefinitionInfo;

        function findDefinitionInfoByType(param1:EnumItem, param2:Boolean = false) : IDefinitionInfo;

    }
}
