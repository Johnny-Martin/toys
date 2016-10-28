package com.qiyi.player.wonder.plugins.recommend.model
{

    public class RecommendVO extends Object
    {
        private var _seatID:uint;
        private var _albumID:String;
        private var _vid:String;
        private var _videoName:String;
        private var _channel:String;
        private var _latestOrder:int;
        private var _updateFlag:int;
        private var _timeLength:Number;
        private var _focus:String;
        private var _picUrl:String;
        private var _playUrl:String;
        private var _tvid:String;
        private var _payType:uint;
        private var _isMemberMovie:Boolean;
        private var _albumName:String;

        public function RecommendVO(param1:uint, param2:Object)
        {
            this._seatID = param1;
            this._albumID = param2.videoType == 1 ? (param2.albumId) : (param2.tvId);
            this._vid = param2.vid;
            this._videoName = param2.name;
            this._channel = param2.channelId;
            this._latestOrder = param2.latestOrder;
            this._updateFlag = param2.updateFlag;
            this._timeLength = param2.duration;
            this._focus = param2.subtitle;
            this._picUrl = param2.imageUrl;
            this._playUrl = param2.url;
            this._tvid = param2.tvId;
            this._payType = param2.isPurchase;
            this._isMemberMovie = param2.isPurchase > 0;
            this._albumName = param2.albumName == undefined ? ("") : (param2.albumName);
            return;
        }// end function

        public function get albumName() : String
        {
            return this._albumName;
        }// end function

        public function get isMemberMovie() : Boolean
        {
            return this._isMemberMovie;
        }// end function

        public function get payType() : uint
        {
            return this._payType;
        }// end function

        public function get tvid() : String
        {
            return this._tvid;
        }// end function

        public function get playUrl() : String
        {
            return this._playUrl;
        }// end function

        public function get picUrl() : String
        {
            return this._picUrl;
        }// end function

        public function get focus() : String
        {
            return this._focus;
        }// end function

        public function get timeLength() : Number
        {
            return this._timeLength;
        }// end function

        public function get updateFlag() : int
        {
            return this._updateFlag;
        }// end function

        public function get latestOrder() : int
        {
            return this._latestOrder;
        }// end function

        public function get channel() : String
        {
            return this._channel;
        }// end function

        public function get videoName() : String
        {
            return this._videoName;
        }// end function

        public function get vid() : String
        {
            return this._vid;
        }// end function

        public function get albumID() : String
        {
            return this._albumID;
        }// end function

        public function get seatID() : uint
        {
            return this._seatID;
        }// end function

        public function destroy() : void
        {
            this._seatID = 0;
            this._albumID = "";
            this._vid = "";
            this._videoName = "";
            this._channel = "";
            this._latestOrder = 0;
            this._updateFlag = 0;
            this._timeLength = 0;
            this._focus = "";
            this._picUrl = "";
            this._playUrl = "";
            this._tvid = "";
            this._payType = 0;
            this._isMemberMovie = false;
            this._albumName = "";
            return;
        }// end function

    }
}
