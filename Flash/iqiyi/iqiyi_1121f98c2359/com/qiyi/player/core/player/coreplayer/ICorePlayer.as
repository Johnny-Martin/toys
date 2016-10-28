package com.qiyi.player.core.player.coreplayer
{
    import com.qiyi.player.core.history.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.*;
    import flash.net.*;

    public interface ICorePlayer extends IPlayer, IWriteStatus
    {

        public function ICorePlayer();

        function get movie() : IMovie;

        function get history() : History;

        function get runtimeData() : RuntimeData;

        function get pingBack() : PingBack;

        function get decoderInfo() : NetStreamInfo;

    }
}
