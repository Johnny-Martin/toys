package com.qiyi.player.core.player
{
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;

    public class LoadMovieParams extends Object
    {
        public var tvid:String;
        public var vid:String;
        public var albumId:String;
        public var startTime:int = -1;
        public var endTime:int = -1;
        public var prepareToPlayEnd:int = -1;
        public var prepareToSkipPoint:int = -1;
        public var prepareLeaveSkipPoint:int = -1;
        public var cacheServerIP:String = "";
        public var vrsDomain:String = "";
        public var communicationId:String = "afbe8fd3d73448c9";
        public var movieIsMember:Boolean = false;
        public var recordHistory:Boolean = true;
        public var useHistory:Boolean = true;
        public var tg:String = "";
        public var autoDefinitionlimit:EnumItem;
        public var collectionID:String = "";

        public function LoadMovieParams()
        {
            this.autoDefinitionlimit = DefinitionEnum.HIGH;
            return;
        }// end function

        public function clone() : LoadMovieParams
        {
            var _loc_1:* = new LoadMovieParams();
            _loc_1.tvid = this.tvid;
            _loc_1.vid = this.vid;
            _loc_1.albumId = this.albumId;
            _loc_1.startTime = this.startTime;
            _loc_1.endTime = this.endTime;
            _loc_1.prepareToPlayEnd = this.prepareToPlayEnd;
            _loc_1.prepareToSkipPoint = this.prepareToSkipPoint;
            _loc_1.cacheServerIP = this.cacheServerIP;
            _loc_1.vrsDomain = this.vrsDomain;
            _loc_1.communicationId = this.communicationId;
            _loc_1.movieIsMember = this.movieIsMember;
            _loc_1.recordHistory = this.recordHistory;
            _loc_1.useHistory = this.useHistory;
            _loc_1.tg = this.tg;
            _loc_1.autoDefinitionlimit = this.autoDefinitionlimit;
            _loc_1.collectionID = this.collectionID;
            return _loc_1;
        }// end function

    }
}
