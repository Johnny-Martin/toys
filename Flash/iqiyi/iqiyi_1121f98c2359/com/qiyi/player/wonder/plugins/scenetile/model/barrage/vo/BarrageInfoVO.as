package com.qiyi.player.wonder.plugins.scenetile.model.barrage.vo
{
    import com.qiyi.player.wonder.plugins.scenetile.*;

    public class BarrageInfoVO extends Object
    {
        private var _dataObj:Object = null;
        private var _contentId:String = "";
        private var _showTime:int = 0;
        private var _content:String = "";
        private var _likes:int = 0;
        private var _userInfo:Object = null;
        private var _fontSize:uint = 30;
        private var _fontColor:String = "ffffff";
        private var _position:uint = 0;
        private var _contentType:uint = 0;
        private var _bgType:uint = 100;
        private var _isReply:Boolean = false;
        private var _replyUserInfo:Object = null;
        private var _replyContent:Object = null;
        private var _barrageSource:String = "";
        private var _reply_content:String = "";
        private var _reply_name:String = "";

        public function BarrageInfoVO()
        {
            return;
        }// end function

        public function get reply_name() : String
        {
            return this._reply_name;
        }// end function

        public function get reply_content() : String
        {
            return this._reply_content;
        }// end function

        public function get barrageSource() : String
        {
            return this._barrageSource;
        }// end function

        public function get replyContent() : Object
        {
            return this._replyContent;
        }// end function

        public function get replyUserInfo() : Object
        {
            return this._replyUserInfo;
        }// end function

        public function get isReply() : Boolean
        {
            return this._isReply;
        }// end function

        public function get dataObj() : Object
        {
            return this._dataObj;
        }// end function

        public function get userInfo() : Object
        {
            return this._userInfo;
        }// end function

        public function get bgType() : uint
        {
            return this._bgType;
        }// end function

        public function get contentType() : uint
        {
            return this._contentType;
        }// end function

        public function get position() : uint
        {
            return this._position;
        }// end function

        public function get fontColor() : String
        {
            return this._fontColor;
        }// end function

        public function get fontSize() : uint
        {
            return this._fontSize;
        }// end function

        public function get likes() : int
        {
            return this._likes;
        }// end function

        public function get content() : String
        {
            return this._content;
        }// end function

        public function get showTime() : int
        {
            return this._showTime;
        }// end function

        public function get contentId() : String
        {
            return this._contentId;
        }// end function

        public function update(param1:Object, param2:String) : void
        {
            this._barrageSource = param2;
            this._dataObj = param1;
            this._contentId = param1.contentId;
            this._showTime = param1.showTime;
            this._content = param1.content;
            this._likes = param1.likes;
            this._fontSize = param1.font == undefined ? (SceneTileDef.BARRAGE_DEFAULT_FONT_SIZE) : (param1.font);
            this._fontColor = param1.color == undefined ? (SceneTileDef.BARRAGE_DEFAULT_FONT_COLOR) : (param1.color);
            this._position = param1.position == undefined ? (SceneTileDef.BARRAGE_POSITION_NONE) : (param1.position);
            this._contentType = param1.contentType == undefined ? (SceneTileDef.BARRAGE_CONTENT_TYPE_NONE) : (param1.contentType);
            this._bgType = param1.background == undefined ? (SceneTileDef.BARRAGE_BG_TYPE_NONE) : (param1.background);
            this._userInfo = param1.userInfo == undefined ? (null) : (param1.userInfo);
            this._isReply = param1.isReply == undefined ? (false) : (param1.isReply == "true" ? (true) : (false));
            this._replyUserInfo = param1.replyUserInfo == undefined ? (null) : (param1.replyUserInfo);
            this._replyContent = param1.replyContent == undefined ? (null) : (param1.replyContent);
            this._reply_content = param1.reply_content == undefined ? ("") : (param1.reply_content);
            this._reply_name = param1.reply_name == undefined ? ("") : (param1.reply_name);
            return;
        }// end function

    }
}
