package com.sohu.tv.mediaplayer.ads
{
    import flash.display.*;
    import flash.events.*;

    public class EndAd extends StartAd
    {
        private var isEndFinish:Boolean = true;

        public function EndAd(param1:Object)
        {
            super(param1);
            return;
        }// end function

        override protected function checkAdPlayTime(param1:String, param2:String) : void
        {
            AdLog.msg("后贴广告取消时间验证");
            return;
        }// end function

        override protected function close() : void
        {
            super.close();
            if (this.isEndFinish)
            {
                dispatch(TvSohuAdsEvent.ENDFINISH);
            }
            else
            {
                this.isEndFinish = true;
            }
            return;
        }// end function

        override public function destroy() : void
        {
            this.isEndFinish = false;
            this.close();
            sysInit("start");
            _container.visible = false;
            _isShown = false;
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

        override protected function sendAdPlayStock(param1:uint) : void
        {
            var _loc_2:String = null;
            try
            {
                if (!_adList[param1].isSendAdPlayStock && _adList[param1].adStatUrl != "")
                {
                    _loc_2 = _adList[param1].adStatUrl.split("?").length > 1 ? (_adList[param1].adStatUrl.split("?")[1]) : ("");
                    sendAdStock(param1, "ead", "b", _loc_2);
                    _adList[param1].isSendAdPlayStock = true;
                }
            }
            catch (evt)
            {
            }
            return;
        }// end function

        override protected function sendAdStopStock(param1:uint) : void
        {
            var _loc_2:String = null;
            try
            {
                if (!_adList[param1].isSendAdStopStock && _adList[param1].adPath != "" && _adList[param1].adPlayOverStatUrl != "" && !_adList[param1].isLoadErr)
                {
                    _loc_2 = _adList[param1].adPlayOverStatUrl.split("?").length > 1 ? (_adList[param1].adPlayOverStatUrl.split("?")[1]) : ("");
                    sendAdStock(param1, "ead", "a", _loc_2);
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
