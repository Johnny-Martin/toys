package com.sohu.tv.mediaplayer.ads
{
    import com.sohu.tv.mediaplayer.*;
    import ebing.events.*;
    import ebing.net.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class MiddleAd extends StartAd
    {
        protected var _midAdInx:int = 0;
        protected var _hasMidAd:Boolean = false;
        protected var _isMidAdTip:Boolean = false;
        private var _isMadPlay:Number = 0;

        public function MiddleAd(param1:Object)
        {
            super(param1);
            return;
        }// end function

        override protected function close() : void
        {
            super.close();
            _isShown = false;
            _state = "no";
            dispatch(TvSohuAdsEvent.MIDDLEFINISH);
            this._hasMidAd = false;
            this._isMidAdTip = false;
            return;
        }// end function

        override public function set detailClass(param1:Class) : void
        {
            var _loc_3:Sprite = null;
            param1 = DetailBtn as Class;
            if (param1 != null)
            {
                _DetailClass = param1;
            }
            var _loc_2:uint = 0;
            while (_loc_2 < _adList.length)
            {
                
                _loc_3 = new _DetailClass();
                if (_isNoDetailClasss || _isVpaidAd || _isPIPAd)
                {
                    _loc_3.visible = false;
                }
                else
                {
                    _loc_3.visible = true;
                }
                _loc_3["plTip_mc"].visible = false;
                _loc_3["skipAdBtn"].visible = false;
                _loc_3["skipAdBtn"].buttonMode = true;
                _loc_3["detail_mc"].buttonMode = true;
                _loc_3["skipAdBtn"].addEventListener(MouseEvent.MOUSE_DOWN, skipBtnHandler);
                _loc_3["skipAdBtn"].addEventListener(MouseEvent.MOUSE_OVER, skipOverHandler);
                _loc_3["skipAdBtn"].addEventListener(MouseEvent.MOUSE_OUT, skipOutHandler);
                _loc_3["detail_mc"].addEventListener(MouseEvent.CLICK, detailClickHandler);
                _loc_3["detail_mc"].addEventListener(MouseEvent.MOUSE_OVER, detailOverHandler);
                _loc_3["detail_mc"].addEventListener(MouseEvent.MOUSE_OUT, detailOutHandler);
                _adList[_loc_2].detail.addChild(_loc_3);
                _loc_2 = _loc_2 + 1;
            }
            resize(_width, _height);
            return;
        }// end function

        override public function play() : void
        {
            _adList = [];
            _state = "loading";
            this.loadAndPlayAd();
            return;
        }// end function

        public function sysInitMid() : void
        {
            this.close();
            sysInit("start");
            _container.visible = false;
            this._hasMidAd = false;
            this._isMidAdTip = false;
            return;
        }// end function

        override protected function adStart(event:MediaEvent) : void
        {
            if (!_isShown)
            {
                _isShown = true;
                dispatch(TvSohuAdsEvent.MIDDLESHOWN);
            }
            return;
        }// end function

        override protected function checkAdPlayTime(param1:String, param2:String) : void
        {
            AdLog.msg("中插广告取消时间验证");
            return;
        }// end function

        private function loadAndPlayAd() : void
        {
            var _loc_1:String = "";
            if (!PlayerConfig.is56)
            {
                if (Model.getInstance().videoInfo.data.adpo != null && PlayerConfig.midAdTimeArr != null && PlayerConfig.midAdTimeArr.length > 0)
                {
                    _loc_1 = "&inx=" + (this._midAdInx + 1) + "&tot=" + PlayerConfig.midAdTimeArr.length + "&ptime=" + PlayerConfig.midAdTimeArr[this._midAdInx];
                }
                else if (PlayerConfig.midAdTimeArr != null && PlayerConfig.midAdTimeArr.length > 0)
                {
                    _loc_1 = "&ptime=" + PlayerConfig.midAdTimeArr[0];
                }
            }
            else
            {
                _loc_1 = "&ptime=" + PlayerConfig.midAdTimeArr[0];
            }
            var _loc_2:* = /&pageUrl=""&pageUrl=/;
            var _loc_3:* = TvSohuAds.getInstance().fetchAdsUrl;
            _loc_3 = _loc_3.replace(_loc_2, "&pt=mad&pageUrl=");
            new URLLoaderUtil().load(5, this.adInfoHandler, _loc_3 + _loc_1 + "&m=" + new Date().getTime());
            return;
        }// end function

        private function adInfoHandler(param1:Object) : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            if (param1.info == "success")
            {
                _loc_2 = new JSON().parse(param1.data);
                AdLog.msg("==========中贴广告信息(json)开始==========");
                AdLog.msg(param1.data);
                AdLog.msg("==========中贴广告信息(json)结束==========");
                if (_loc_2.status == 1)
                {
                    _state = "success";
                    _loc_3 = _loc_2.data.mad;
                    if (this.getPar(_loc_2.data.vuflag) != null && this.getPar(_loc_2.data.vuflag) != "" && this.getPar(_loc_2.data.vuflag) == "1")
                    {
                        _isAdTip = true;
                    }
                    AdLog.msg("==========中插广告部分开始==========");
                    softInit({adPar:_loc_3});
                    AdLog.msg("==========中插广告部分结束==========");
                    this.checkMidAd();
                }
                else
                {
                    _state = "failed";
                    dispatch(TvSohuAdsEvent.MIDDLE_LOAD_FAILED);
                }
            }
            else
            {
                _state = "failed";
                dispatch(TvSohuAdsEvent.MIDDLE_LOAD_FAILED);
            }
            return;
        }// end function

        private function checkMidAd() : void
        {
            var i:uint;
            while (i < _adList.length)
            {
                
                if (_adList[i].adPath != "")
                {
                    this._hasMidAd = true;
                    ;
                }
                i = (i + 1);
            }
            this._isMadPlay = setTimeout(function () : void
            {
                sysInitMid();
                return;
            }// end function
            , 7000);
            return;
        }// end function

        public function goToPlayMidAd() : void
        {
            clearTimeout(this._isMadPlay);
            super.play();
            return;
        }// end function

        public function get midAdInx() : int
        {
            return this._midAdInx;
        }// end function

        public function get hasMidAd() : Boolean
        {
            return false;
        }// end function

        public function set hasMidAd(param1:Boolean) : void
        {
            this._hasMidAd = false;
            return;
        }// end function

        public function get isMidAdTip() : Boolean
        {
            return this._isMidAdTip;
        }// end function

        public function set isMidAdTip(param1:Boolean) : void
        {
            this._isMidAdTip = param1;
            return;
        }// end function

        public function set midAdInx(param1:int) : void
        {
            this._midAdInx = param1;
            return;
        }// end function

        override protected function sendAdPlayStock(param1:uint) : void
        {
            return;
            var _loc_2:String = null;
            try
            {
                if (!_adList[param1].isSendAdPlayStock && _adList[param1].adStatUrl != "")
                {
                    _loc_2 = _adList[param1].adStatUrl.split("?").length > 1 ? (_adList[param1].adStatUrl.split("?")[1]) : ("");
                    sendAdStock(param1, "mad", "b", _loc_2);
                    _adList[param1].isSendAdPlayStock = true;
                }
            }
            catch (evt)
            {
            }
            return;
        }// end function

        private function getPar(param1) : String
        {
            var _loc_2:String = "";
            if (param1 != undefined && param1 != null)
            {
                _loc_2 = String(param1);
            }
            return _loc_2;
        }// end function

        override protected function sendAdStopStock(param1:uint) : void
        {
            return;
            var _loc_2:String = null;
            try
            {
                if (!_adList[param1].isSendAdStopStock && _adList[param1].adPath != "" && _adList[param1].adPlayOverStatUrl != "" && !_adList[param1].isLoadErr)
                {
                    _loc_2 = _adList[param1].adPlayOverStatUrl.split("?").length > 1 ? (_adList[param1].adPlayOverStatUrl.split("?")[1]) : ("");
                    sendAdStock(param1, "mad", "a", _loc_2);
                    _adList[param1].isSendAdStopStock = true;
                }
            }
            catch (evt)
            {
            }
            return;
        }// end function

    }
}
