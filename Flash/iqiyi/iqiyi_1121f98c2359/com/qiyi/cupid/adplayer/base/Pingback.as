package com.qiyi.cupid.adplayer.base
{
    import com.qiyi.cupid.adplayer.utils.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class Pingback extends Object
    {
        private var _pingbackType:String;
        private var _subtype:String;
        private var _uaaUserId:String;
        private var _cupidUserId:String;
        private var _tvId:String;
        private var _albumId:String;
        private var _channelId:String;
        private var _videoEventId:String;
        private var _adPlayerId:String;
        private var _customInfo:String;
        private var _passportId:String;
        private var _isPreload:String;
        private var _flashPlayerVersion:String;
        private var _location:String;
        private var _adClientVersion:String;
        private var _videoClientVersion:String;
        private var _requestDuration:int;
        private var _requestCount:int;
        private var _errCode:int;
        private var _errMsg:String;
        private static var log:Log = new Log("pingback");

        public function Pingback()
        {
            return;
        }// end function

        public function sendVisitPb(param1:Dictionary) : void
        {
            this._pingbackType = PingbackConst.TYPE_VISIT;
            this._subtype = PingbackConst.SUBTYPE_SUCCESS;
            this._tvId = param1["tvId"];
            this._albumId = param1["albumId"];
            this._channelId = param1["channelId"];
            this._isPreload = param1["isPreload"] ? ("1") : ("0");
            this._passportId = param1["passportId"];
            this._customInfo = [param1["videoClientUrl"], param1["adClientUrl"]].join("||");
            this._flashPlayerVersion = Capabilities.version;
            this._location = CupidAdPlayerUtils.getLocation();
            this.send(param1);
            return;
        }// end function

        public function sendPlayerSuccess(param1:Dictionary, param2:int, param3:int) : void
        {
            this._pingbackType = PingbackConst.TYPE_PLAYER;
            this._subtype = PingbackConst.SUBTYPE_SUCCESS;
            this._requestDuration = param2;
            this._requestCount = param3;
            this.send(param1);
            return;
        }// end function

        public function sendPlayerError(param1:Dictionary, param2:int, param3:String, param4:int) : void
        {
            this._pingbackType = PingbackConst.TYPE_PLAYER;
            this._subtype = PingbackConst.SUBTYPE_ERROR;
            this._requestCount = param4;
            this._errCode = param2;
            this._errMsg = param3;
            this.send(param1);
            return;
        }// end function

        public function sendStatisticsAdBlock(param1:Dictionary, param2:int) : void
        {
            this._pingbackType = PingbackConst.TYPE_STATISTICS;
            this._subtype = PingbackConst.SUBTYPE_ADBLOCK;
            this._errCode = param2;
            this.send(param1);
            return;
        }// end function

        private function send(param1:Dictionary) : void
        {
            this._uaaUserId = param1["uaaUserId"];
            this._cupidUserId = param1["cupidUserId"];
            this._videoEventId = param1["videoEventId2"];
            this._adPlayerId = param1["playerId"];
            this._adClientVersion = param1["adClientVersion"];
            this._videoClientVersion = param1["videoClientVersion"];
            this.ping();
            return;
        }// end function

        private function ping() : void
        {
            var urlRequest:URLRequest;
            try
            {
                urlRequest = new URLRequest(this.generateUrl());
                sendToURL(urlRequest);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function generateUrl() : String
        {
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_1:* = new Dictionary();
            _loc_1["p"] = this._pingbackType;
            _loc_1["t"] = this._subtype;
            _loc_1["u"] = this._uaaUserId;
            _loc_1["a"] = this._cupidUserId;
            _loc_1["v"] = this._tvId;
            _loc_1["b"] = this._albumId;
            _loc_1["c"] = this._channelId;
            _loc_1["e"] = this._videoEventId;
            _loc_1["y"] = this._adPlayerId;
            _loc_1["x"] = this._customInfo;
            _loc_1["s"] = new Date().time;
            _loc_1["pp"] = this._passportId;
            _loc_1["pl"] = this._isPreload;
            _loc_1["fp"] = this._flashPlayerVersion;
            _loc_1["lc"] = this._location;
            _loc_1["av"] = this._adClientVersion;
            _loc_1["vv"] = this._videoClientVersion;
            _loc_1["rd"] = this._requestDuration > 0 ? (this._requestDuration.toString()) : ("");
            _loc_1["rc"] = this._requestCount != 0 ? (this._requestCount.toString()) : ("");
            _loc_1["ec"] = this._errCode != 0 ? (this._errCode.toString()) : ("");
            _loc_1["em"] = this._errMsg;
            var _loc_2:* = new Array();
            for (_loc_3 in _loc_1)
            {
                
                _loc_5 = _loc_1[_loc_3];
                if (!StringUtils.isEmpty(_loc_5))
                {
                    if (PingbackConst.ENCODE_FIELDS.indexOf(_loc_3) >= 0)
                    {
                        _loc_5 = encodeURIComponent(_loc_5);
                    }
                    _loc_2.push(_loc_3 + "=" + _loc_5);
                }
            }
            _loc_4 = PingbackConst.SERVICE_URL + _loc_2.join("&");
            log.debug("send", _loc_4);
            return _loc_4;
        }// end function

    }
}
