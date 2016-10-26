package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import ebing.net.*;
    import flash.utils.*;

    public class SogouAd extends PauseAd
    {
        private var _statusID:int = -1;
        private var _hasAd:Boolean = false;

        public function SogouAd()
        {
            new URLLoaderUtil().load(1, function (param1:Object) : void
            {
                if (param1.info != "success")
                {
                    _hasAd = true;
                }
                return;
            }// end function
            , PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
            return;
        }// end function

        override public function play() : void
        {
            super.play();
            _close_btn.visible = false;
            if (_showPause && _adContent != null)
            {
                this.show();
                dispatch(TvSohuAdsEvent.SOGOUSHOWN);
            }
            return;
        }// end function

        override protected function pauseAdHandler(param1:Object) : void
        {
            var obj:* = param1;
            super.pauseAdHandler(obj);
            if (obj.info == "success" && _showPause)
            {
                dispatch(TvSohuAdsEvent.SOGOUSHOWN);
                setTimeout(function () : void
            {
                hide();
                return;
            }// end function
            , 15000);
            }
            return;
        }// end function

        override public function get hasAd() : Boolean
        {
            return this._hasAd;
        }// end function

        override public function get height() : Number
        {
            var _loc_1:int = 0;
            if (_adContent != null)
            {
                _loc_1 = _adContent.contentLoaderInfo.height;
            }
            return _loc_1;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            _width = param1 < 0 ? (0) : (param1);
            _height = param2 < 0 ? (0) : (param2);
            if (_adContent != null)
            {
                _adContent["content"].resize(param1, param2);
            }
            return;
        }// end function

        public function get isShow() : Boolean
        {
            if (_state == "playing" && _container.visible && _adContent != null && _adContent.visible)
            {
                return true;
            }
            return false;
        }// end function

        public function hide() : void
        {
            if (_adContent != null)
            {
                _adContent.visible = false;
            }
            return;
        }// end function

        public function show() : void
        {
            if (_adContent != null)
            {
                _adContent.visible = true;
            }
            return;
        }// end function

    }
}
