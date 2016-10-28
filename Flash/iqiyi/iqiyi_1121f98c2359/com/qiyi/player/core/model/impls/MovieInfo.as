package com.qiyi.player.core.model.impls
{
    import __AS3__.vec.*;
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import flash.events.*;
    import flash.utils.*;

    public class MovieInfo extends EventDispatcher implements IMovieInfo, IDestroy
    {
        private var _info:String;
        private var _infoJSON:Object;
        private var _chains:Array;
        private var _focusTips:Vector.<FocusTip>;
        private var _channel:EnumItem;
        private var _pageUrl:String;
        private var _title:String;
        private var _albumName:String;
        private var _albumUrl:String;
        private var _source:String;
        private var _allSet:int;
        private var _allowDownload:Boolean;
        private var _nextUrl:String;
        private var _subTitle:String;
        private var _ptUrl:String;
        private var _isShare:Boolean;
        private var _isFullShare:Boolean;
        private var _qiyiProduced:Boolean;
        private var _putBarrage:Boolean;
        private var _isReward:Boolean = false;
        private var _commentAllowed:Boolean = true;
        private var _qtId:String = "";
        private var _ready:Boolean;
        private var _previewImageUrl:String;
        private var _timer:Timer;
        private var _pingBackFlag:Boolean;
        private var _holder:ICorePlayer;

        public function MovieInfo(param1:ICorePlayer)
        {
            this._ready = false;
            this._pingBackFlag = false;
            this._channel = ChannelEnum.NONE;
            this._pageUrl = "";
            this._ptUrl = "";
            this._title = "";
            this._albumName = "";
            this._albumUrl = "";
            this._nextUrl = "";
            this._subTitle = "";
            this._qiyiProduced = false;
            this._putBarrage = true;
            this._holder = param1;
            return;
        }// end function

        public function get info() : String
        {
            return this._info;
        }// end function

        public function get infoJSON() : Object
        {
            return this._infoJSON;
        }// end function

        public function get share() : Boolean
        {
            return this._isShare;
        }// end function

        public function get fullShare() : Boolean
        {
            return this._isFullShare;
        }// end function

        public function get subTitle() : String
        {
            return this._subTitle;
        }// end function

        public function get chains() : Array
        {
            return this._chains;
        }// end function

        public function get focusTips() : Vector.<FocusTip>
        {
            return this._focusTips;
        }// end function

        public function get channel() : EnumItem
        {
            return this._channel;
        }// end function

        public function get pageUrl() : String
        {
            return this._pageUrl;
        }// end function

        public function get ptUrl() : String
        {
            return this._ptUrl;
        }// end function

        public function get title() : String
        {
            return this._title;
        }// end function

        public function get albumName() : String
        {
            return this._albumName;
        }// end function

        public function get albumUrl() : String
        {
            return this._albumUrl;
        }// end function

        public function get allSet() : int
        {
            return this._allSet;
        }// end function

        public function get allowDownload() : Boolean
        {
            return this._allowDownload;
        }// end function

        public function get nextUrl() : String
        {
            return this._nextUrl;
        }// end function

        public function get qiyiProduced() : Boolean
        {
            return this._qiyiProduced;
        }// end function

        public function get putBarrage() : Boolean
        {
            return this._putBarrage;
        }// end function

        public function get source() : String
        {
            return this._source;
        }// end function

        public function get ready() : Boolean
        {
            return this._ready;
        }// end function

        public function get previewImageUrl() : String
        {
            return this._previewImageUrl;
        }// end function

        public function get isReward() : Boolean
        {
            return this._isReward;
        }// end function

        public function get commentAllowed() : Boolean
        {
            return this._commentAllowed;
        }// end function

        public function get qtId() : String
        {
            return this._qtId;
        }// end function

        public function startInitByInfo(param1:Object) : void
        {
            if (param1)
            {
                this._infoJSON = param1;
                this.parse();
                this._ready = true;
            }
            return;
        }// end function

        private function parse() : void
        {
            var _loc_3:FocusTip = null;
            this._channel = Utility.getItemById(ChannelEnum.ITEMS, int(this._infoJSON.c));
            this._pageUrl = this._infoJSON.vu.toString();
            this._title = this._infoJSON.vn.toString();
            this._albumName = this._infoJSON.an.toString();
            this._albumUrl = this._infoJSON.au.toString();
            this._allSet = int(this._infoJSON.es.toString());
            this._nextUrl = this._infoJSON.nurl.toString();
            this._subTitle = this._infoJSON.subt.toString();
            this._isShare = int(this._infoJSON["is"]) == 1;
            this._isFullShare = int(this._infoJSON.ifs) == 1;
            this._ptUrl = this._infoJSON.pturl.toString();
            this._allowDownload = int(this._infoJSON.idl) != 0;
            this._source = this._infoJSON.hasOwnProperty("s") ? (this._infoJSON.s) : ("");
            this._previewImageUrl = this._infoJSON.hasOwnProperty("previewImageUrl") ? (this._infoJSON.previewImageUrl) : ("");
            if (this._infoJSON.hasOwnProperty("qiyiProduced"))
            {
                this._qiyiProduced = int(this._infoJSON.qiyiProduced) == 1;
            }
            if (this._infoJSON.hasOwnProperty("isPopup"))
            {
                this._putBarrage = int(this._infoJSON.isPopup) == 1;
            }
            else
            {
                this._putBarrage = true;
            }
            if (this._infoJSON.hasOwnProperty("rewardAllowed"))
            {
                this._isReward = int(this._infoJSON.rewardAllowed) == 1;
            }
            if (this._infoJSON.hasOwnProperty("commentAllowed"))
            {
                this._commentAllowed = int(this._infoJSON.commentAllowed) == 1;
            }
            if (this._infoJSON.hasOwnProperty("qtId"))
            {
                this._qtId = this._infoJSON.qtId;
            }
            this._info = JSON.encode(this._infoJSON);
            this._focusTips = new Vector.<FocusTip>;
            var _loc_1:* = this._infoJSON.fl as Array;
            var _loc_2:Object = null;
            for each (_loc_2 in _loc_1)
            {
                
                _loc_3 = new FocusTip();
                _loc_3.index = this._focusTips.length;
                _loc_3.timestamp = Number(_loc_2.t.toString()) * 1000;
                _loc_3.content = _loc_2.c.toString();
                this._focusTips.push(_loc_3);
            }
            if (this._infoJSON.tpl is Array)
            {
                this._chains = this._infoJSON.tpl;
            }
            return;
        }// end function

        public function destroy() : void
        {
            this._info = null;
            this._infoJSON = null;
            this._channel = ChannelEnum.NONE;
            this._chains = null;
            this._focusTips = null;
            this._ready = false;
            this._pingBackFlag = false;
            this._holder = null;
            return;
        }// end function

    }
}
