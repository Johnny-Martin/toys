package com.sohu.tv.mediaplayer.net
{
    import ebing.net.*;
    import flash.events.*;
    import flash.utils.*;

    public class TvSohuURLLoaderUtil extends URLLoaderUtil
    {
        private var _cdn301TimeLimit:int = 15;
        private var _cdn200TimeLimit:int = 10;
        private var _p2pTimeLimit:int = 20;
        private var _cdnTimeoutId:Number = 0;
        private var _cdnIP:String = "";
        private var _cdnID:String = "";
        private var _errCdnIds:Array;
        private var _hasP2P:Boolean = false;
        private var _urlloader:URLLoaderUtil;
        private var _isnp:Boolean = false;
        private var _isWriteLog:Boolean = false;
        private var _statusCode:int = 0;

        public function TvSohuURLLoaderUtil()
        {
            this._errCdnIds = new Array();
            return;
        }// end function

        override public function multiSend(param1:String) : void
        {
            return;
            if (param1 == null || param1 == "")
            {
                return;
            }
            var _loc_2:* = /http:\/\/atyt.tv.sohu.com""http:\/\/atyt.tv.sohu.com/;
            var _loc_3:* = /http:\/\/atyg.tv.sohu.com""http:\/\/atyg.tv.sohu.com/;
            var _loc_4:* = /http:\/\/aty.tv.sohu.com""http:\/\/aty.tv.sohu.com/;
            var _loc_5:* = param1.split("|http");
            var _loc_6:String = "";
            var _loc_7:int = 0;
            while (_loc_7 < _loc_5.length)
            {
                
                _loc_6 = _loc_7 > 0 ? ("http") : ("");
                _loc_6 = _loc_6 + _loc_5[_loc_7];
                _loc_6 = _loc_2.test(_loc_6) || _loc_3.test(_loc_6) || _loc_4.test(_loc_6) ? (_loc_6 + "&t=" + new Date().time) : (_loc_6);
                send(_loc_6);
                _loc_7++;
            }
            return;
        }// end function

        public function multiSendAndCallBack(param1:String, param2:Function) : void
        {
            return;
            var _loc_10:Boolean = false;
            if (param1 == null || param1 == "")
            {
                return;
            }
            var _loc_3:* = /http:\/\/atyt.tv.sohu.com""http:\/\/atyt.tv.sohu.com/;
            var _loc_4:* = /http:\/\/atyg.tv.sohu.com""http:\/\/atyg.tv.sohu.com/;
            var _loc_5:* = /http:\/\/aty.tv.sohu.com""http:\/\/aty.tv.sohu.com/;
            var _loc_6:* = /http:\/\/vm\.aty\.sohu\.com""http:\/\/vm\.aty\.sohu\.com/;
            var _loc_7:* = param1.split("|http");
            var _loc_8:String = "";
            var _loc_9:int = 0;
            while (_loc_9 < _loc_7.length)
            {
                
                _loc_8 = _loc_9 > 0 ? ("http") : ("");
                _loc_8 = _loc_8 + _loc_7[_loc_9];
                _loc_8 = _loc_3.test(_loc_8) || _loc_4.test(_loc_8) || _loc_5.test(_loc_8) ? (_loc_8 + "&t=" + new Date().time) : (_loc_8);
                _loc_10 = _loc_8.split("http://vm.aty.sohu.com/pvlog?").length > 1;
                if (_loc_10)
                {
                    this.param2(_loc_8);
                }
                else
                {
                    send(_loc_8);
                }
                _loc_9++;
            }
            return;
        }// end function

        override protected function ioErrorHandler(event:IOErrorEvent) : void
        {
            if (!_isDispatched)
            {
                _isDispatched = true;
                close();
                clearTimeout(_setTimeoutId_num);
                _isLoaded_boo = false;
                _spend_num = getTimer() - _spend_num;
                if (this._handler_fun != null)
                {
                    this._handler_fun({info:"ioError", err:event, target:this, status:this._statusCode});
                }
            }
            return;
        }// end function

        override protected function httpStatusHandler(event:HTTPStatusEvent) : void
        {
            this._statusCode = event.status;
            return;
        }// end function

    }
}
