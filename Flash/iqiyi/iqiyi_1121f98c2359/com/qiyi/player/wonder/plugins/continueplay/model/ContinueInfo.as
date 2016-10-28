package com.qiyi.player.wonder.plugins.continueplay.model
{
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.wonder.common.config.*;

    public class ContinueInfo extends Object
    {
        private var _loadMovieParams:LoadMovieParams;
        private var _playCount:int = 0;
        private var _isPlaging:Boolean = false;
        private var _imageURL:String = "";
        private var _title:String = "";
        private var _describe:String = "";
        private var _curSet:int = 1;
        private var _cupId:String;
        private var _index:int = 0;
        private var _isAdVideo:Boolean = false;
        private var _publishTime:String = "";
        private var _channelID:uint = 0;
        private var _exclusive:String = "";
        private var _qiyiProduced:String = "";
        private var _vfrm:String = "";
        private var _canScore:Boolean = false;

        public function ContinueInfo()
        {
            this._cupId = FlashVarConfig.cupId;
            this._loadMovieParams = new LoadMovieParams();
            return;
        }// end function

        public function get canScore() : Boolean
        {
            return this._canScore;
        }// end function

        public function set canScore(param1:Boolean) : void
        {
            this._canScore = param1;
            return;
        }// end function

        public function get qiyiProduced() : String
        {
            return this._qiyiProduced;
        }// end function

        public function set qiyiProduced(param1:String) : void
        {
            this._qiyiProduced = param1;
            return;
        }// end function

        public function get vfrm() : String
        {
            return this._vfrm;
        }// end function

        public function set vfrm(param1:String) : void
        {
            this._vfrm = param1;
            return;
        }// end function

        public function get exclusive() : String
        {
            return this._exclusive;
        }// end function

        public function set exclusive(param1:String) : void
        {
            this._exclusive = param1;
            return;
        }// end function

        public function get publishTime() : String
        {
            return this._publishTime;
        }// end function

        public function set publishTime(param1:String) : void
        {
            this._publishTime = param1;
            return;
        }// end function

        public function get loadMovieParams() : LoadMovieParams
        {
            return this._loadMovieParams;
        }// end function

        public function get playCount() : int
        {
            return this._playCount;
        }// end function

        public function get isPlaging() : Boolean
        {
            return this._isPlaging;
        }// end function

        public function set isPlaging(param1:Boolean) : void
        {
            this._isPlaging = param1;
            return;
        }// end function

        public function get imageURL() : String
        {
            return this._imageURL;
        }// end function

        public function set imageURL(param1:String) : void
        {
            this._imageURL = param1;
            return;
        }// end function

        public function get title() : String
        {
            return this._title;
        }// end function

        public function set title(param1:String) : void
        {
            this._title = param1;
            return;
        }// end function

        public function get describe() : String
        {
            return this._describe;
        }// end function

        public function set describe(param1:String) : void
        {
            this._describe = param1;
            return;
        }// end function

        public function get curSet() : int
        {
            return this._curSet;
        }// end function

        public function set curSet(param1:int) : void
        {
            this._curSet = param1;
            return;
        }// end function

        public function get cupId() : String
        {
            return this._cupId;
        }// end function

        public function set cupId(param1:String) : void
        {
            if (param1 == null || param1 == "")
            {
                this._cupId = FlashVarConfig.cupId;
            }
            else
            {
                this._cupId = param1;
            }
            return;
        }// end function

        public function get index() : int
        {
            return this._index;
        }// end function

        public function set index(param1:int) : void
        {
            this._index = param1;
            return;
        }// end function

        public function get isAdVideo() : Boolean
        {
            return this._isAdVideo;
        }// end function

        public function set isAdVideo(param1:Boolean) : void
        {
            this._isAdVideo = param1;
            return;
        }// end function

        public function addPlayCount() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this._playCount + 1;
            _loc_1._playCount = _loc_2;
            return;
        }// end function

        public function get channelID() : uint
        {
            return this._channelID;
        }// end function

        public function set channelID(param1:uint) : void
        {
            this._channelID = param1;
            return;
        }// end function

    }
}
