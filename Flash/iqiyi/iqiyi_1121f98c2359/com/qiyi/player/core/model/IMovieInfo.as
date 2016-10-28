package com.qiyi.player.core.model
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.pub.*;

    public interface IMovieInfo
    {

        public function IMovieInfo();

        function get info() : String;

        function get infoJSON() : Object;

        function get share() : Boolean;

        function get fullShare() : Boolean;

        function get subTitle() : String;

        function get chains() : Array;

        function get focusTips() : Vector.<FocusTip>;

        function get channel() : EnumItem;

        function get pageUrl() : String;

        function get ptUrl() : String;

        function get title() : String;

        function get albumName() : String;

        function get albumUrl() : String;

        function get allSet() : int;

        function get allowDownload() : Boolean;

        function get nextUrl() : String;

        function get qiyiProduced() : Boolean;

        function get putBarrage() : Boolean;

        function get source() : String;

        function get ready() : Boolean;

        function get previewImageUrl() : String;

        function get isReward() : Boolean;

        function get commentAllowed() : Boolean;

        function get qtId() : String;

    }
}
