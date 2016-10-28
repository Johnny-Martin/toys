package com.qiyi.player.wonder.plugins.videolink.model
{
    import flash.geom.*;

    public class VideoLinkInfo extends Object
    {
        private var _isShow:Boolean = false;
        private var _videoLinkID:String = "";
        private var _linktype:String = "";
        private var _startTime:String = "";
        private var _endTime:String = "";
        private var _title:String = "";
        private var _titleUrl:String = "";
        private var _picUrl:String = "";
        private var _btnType:String = "";
        private var _subTitle:String = "";
        private var _subTitleUrl:String = "";
        private var _describe:String = "";
        private var _describeUrl:String = "";
        private var _leftArea:Rectangle = null;
        private var _rightArea:Rectangle = null;

        public function VideoLinkInfo(param1:Object)
        {
            if (param1)
            {
                this._videoLinkID = param1.id == undefined ? ("") : (param1.id);
                this._startTime = param1.bt == undefined ? ("") : (param1.bt);
                this._endTime = param1.et == undefined ? ("") : (param1.et);
                this._linktype = param1.tp == undefined ? ("") : (param1.tp);
                this._btnType = param1.bn == undefined ? ("") : (param1.bn);
                if (param1.de)
                {
                    this._title = param1.de.t == undefined ? ("") : (param1.de.t);
                    this._titleUrl = param1.de.tl == undefined ? ("") : (param1.de.tl);
                    this._picUrl = param1.de.pic == undefined ? ("") : (param1.de.pic);
                    this._subTitle = param1.de.st == undefined ? ("") : (param1.de.st);
                    this._subTitleUrl = param1.de.stl == undefined ? ("") : (param1.de.stl);
                    this._describe = param1.de.cm == undefined ? ("") : (param1.de.cm);
                    this._describeUrl = param1.de.cml == undefined ? ("") : (param1.de.cml);
                }
            }
            return;
        }// end function

        public function get isShow() : Boolean
        {
            return this._isShow;
        }// end function

        public function set isShow(param1:Boolean) : void
        {
            this._isShow = param1;
            return;
        }// end function

        public function get startTime() : String
        {
            return this._startTime;
        }// end function

        public function get endTime() : String
        {
            return this._endTime;
        }// end function

        public function get linktype() : String
        {
            return this._linktype;
        }// end function

        public function get title() : String
        {
            return this._title;
        }// end function

        public function get titleUrl() : String
        {
            return this._titleUrl;
        }// end function

        public function get picUrl() : String
        {
            return this._picUrl;
        }// end function

        public function get btnType() : String
        {
            return this._btnType;
        }// end function

        public function get subTitle() : String
        {
            return this._subTitle;
        }// end function

        public function get subTitleUrl() : String
        {
            return this._subTitleUrl;
        }// end function

        public function get describe() : String
        {
            return this._describe;
        }// end function

        public function get describeUrl() : String
        {
            return this._describeUrl;
        }// end function

        public function get leftArea() : Rectangle
        {
            return this._leftArea;
        }// end function

        public function get rightArea() : Rectangle
        {
            return this._rightArea;
        }// end function

        public function destroy() : void
        {
            this._isShow = false;
            return;
        }// end function

    }
}
