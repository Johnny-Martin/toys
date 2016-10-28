package com.qiyi.player.core.video.render
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.video.decoder.*;
    import com.qiyi.player.core.video.engine.*;
    import flash.geom.*;

    public interface IRender extends IEventDispatcher, IDestroy
    {

        public function IRender();

        function get accStatus() : EnumItem;

        function bind(param1:IEngine, param2:IDecoder, param3:IMovie) : void;

        function releaseBind() : void;

        function tryUseGPU() : void;

        function tryUpGPUDepth() : void;

        function clearVideo() : void;

        function setRect(param1:int, param2:int, param3:int, param4:int) : void;

        function setZoom(param1:int) : void;

        function getSettingArea() : Rectangle;

        function getRealArea() : Rectangle;

        function setPuman(param1:Boolean) : void;

        function setVideoDisplaySettings(param1:int, param2:int) : void;

        function setVideoRate(param1:int, param2:int) : void;

        function panVideo(param1:Number) : void;

        function tiltVideo(param1:Number) : void;

        function zoomVideo(param1:Number) : void;

    }
}
