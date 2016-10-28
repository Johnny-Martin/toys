package com.qiyi.player.wonder.plugins.feedback.model
{

    public class FeedbackInfo extends Object
    {
        private var _entry:String = "";
        private var _vid:String = "";
        private var _title:String = "";
        private var _volume:uint = 0;
        private var _logCookie:String = "";
        private var _playerVersion:String = "";
        private var _channelId:String = "";
        private var _userInfo:Object = null;
        private var _country:String = "";
        private var _city:String = "";
        private var _ip:String = "";
        private var _isp:String = "";
        private var _ticket:String = "";
        private static var _instance:FeedbackInfo;

        public function FeedbackInfo()
        {
            return;
        }// end function

        public function get ticket() : String
        {
            return this._ticket;
        }// end function

        public function set ticket(param1:String) : void
        {
            this._ticket = param1;
            return;
        }// end function

        public function get userInfo() : Object
        {
            return this._userInfo;
        }// end function

        public function set userInfo(param1:Object) : void
        {
            this._ip = param1.data.ip;
            this._country = param1.data.country;
            this._city = param1.data.city;
            this._isp = param1.data.isp;
            this._userInfo = param1;
            return;
        }// end function

        public function updataVideoInfo(param1:String, param2:String, param3:String, param4:uint, param5:String, param6:String, param7:String) : void
        {
            this._entry = param1;
            this._vid = param2;
            this._title = param3;
            this._volume = param4;
            this._logCookie = param5;
            this._playerVersion = param6;
            this._channelId = param7;
            return;
        }// end function

        public function get isp() : String
        {
            return this._isp;
        }// end function

        public function get ip() : String
        {
            return this._ip;
        }// end function

        public function get city() : String
        {
            return this._city;
        }// end function

        public function get country() : String
        {
            return this._country;
        }// end function

        public function get channelId() : String
        {
            return this._channelId;
        }// end function

        public function get playerVersion() : String
        {
            return this._playerVersion;
        }// end function

        public function get logCookie() : String
        {
            return this._logCookie;
        }// end function

        public function get volume() : uint
        {
            return this._volume;
        }// end function

        public function get title() : String
        {
            return this._title;
        }// end function

        public function get vid() : String
        {
            return this._vid;
        }// end function

        public function get entry() : String
        {
            return this._entry;
        }// end function

        public static function get instance() : FeedbackInfo
        {
            var _loc_1:* = _instance || new FeedbackInfo;
            _instance = _instance || new FeedbackInfo;
            return _loc_1;
        }// end function

    }
}
