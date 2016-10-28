package com.qiyi.player.core.model
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.impls.*;

    public interface IMovie extends IMovieModel, IEventDispatcher, IDestroy
    {

        public function IMovie();

        function get ver() : String;

        function get ready() : Boolean;

        function get curAudioTrack() : AudioTrack;

        function get curDefinition() : Definition;

        function get curSegment() : Segment;

        function updateCurSubtitlesType(param1:EnumItem) : void;

        function startLoadAddedSkipPoints() : void;

        function setCurAudioTrack(param1:EnumItem, param2:EnumItem) : void;

        function setCurDefinition(param1:EnumItem) : void;

        function getSeekTime() : Number;

        function seek(param1:Number) : void;

        function getSegmentByTime(param1:Number) : Segment;

        function getAudioTrackAt(param1:int) : AudioTrack;

        function getAudioTrackByType(param1:EnumItem) : AudioTrack;

        function setEnjoyableSubType(param1:EnumItem, param2:int = -1) : void;

        function startLoadMeta() : void;

        function startLoadLicense() : void;

        function get renderType() : int;

    }
}
