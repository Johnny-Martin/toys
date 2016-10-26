package ebing.net
{
    import ebing.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class NetStreamUtil extends NetStream
    {
        protected const GSLB_TIMEOUT:uint = 6;
        protected var _url:String;
        protected var _gone:String;
        protected var _node:String;
        protected var _checkP2P:URLLoaderUtil;
        protected var _cdnuse:Number = -1;
        protected var _spend_num:Number = 0;
        protected var _gslbUrl:String;
        protected var _isPlay:Boolean = true;
        protected var _location:String = "";
        protected var _playUrl:String = "";
        protected var _parameterString:String = "";
        protected var _parameter:URLVariables;
        protected var _bufferNum:uint = 0;
        protected var _cdnNum:Number = 0;
        protected var _gslbNum:Number = 0;
        protected var _dragTime:Number = 0;
        protected var _isDrag:Boolean = false;
        protected var _is200:Boolean = false;
        protected var _gslbLoader:URLLoaderUtil;
        protected var _clipNo:uint = 0;
        protected var _gotMetaData:Boolean = false;

        public function NetStreamUtil(param1:NetConnection, param2:Boolean = false)
        {
            this._is200 = param2;
            super(param1);
            this.sysInit("start");
            return;
        }// end function

        protected function sysInit(param1:String) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
            }
            return;
        }// end function

        protected function newFunc() : void
        {
            return;
        }// end function

        public function set clipNo(param1:uint) : void
        {
            this._clipNo = param1;
            return;
        }// end function

        protected function doPlay(param1:String) : void
        {
            Utils.debug("_isPlay:" + this._isPlay);
            this._cdnuse = getTimer();
            this.gotMetaData = false;
            if (this._isPlay)
            {
                super.play(param1);
            }
            else
            {
                super.play(param1);
                this.pause();
                seek(0);
            }
            this._playUrl = param1;
            this.bufferNum = 0;
            var _loc_2:* = /start=""start=/;
            this._isDrag = _loc_2.test(param1) ? (true) : (false);
            return;
        }// end function

        public function set gotMetaData(param1:Boolean) : void
        {
            this._gotMetaData = param1;
            return;
        }// end function

        public function get gotMetaData() : Boolean
        {
            return this._gotMetaData;
        }// end function

        override public function play(... args) : void
        {
            args = new activation;
            var p:URLVariables;
            var arguments:* = args;
            this._isPlay = true;
            this._gslbUrl = [0];
            try
            {
                p = new URLVariables(this._gslbUrl.split("?")[1]);
                this._dragTime = start != undefined ? (Number(start)) : (this._dragTime);
            }
            catch (evt:Error)
            {
                _dragTime = 0;
            }
            if (this._is200)
            {
                this.loadLocationAndPlay();
            }
            else
            {
                this.doPlay(this._gslbUrl);
            }
            return;
        }// end function

        override public function close() : void
        {
            super.close();
            this._isPlay = false;
            try
            {
                if (this._gslbLoader != null)
                {
                    this._gslbLoader.close();
                }
            }
            catch (evt:Event)
            {
                trace("NetStreamUtil evt:" + evt);
            }
            return;
        }// end function

        protected function loadLocationAndPlay() : void
        {
            var url:String;
            var K102607C939D77E372B425F9B2092364BF65E81373570K:String;
            var K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K:Boolean;
            var sp:String;
            var K10255269C23FDCE8B24503A67C29619F006FF3373515K:*;
            var p:URLVariables;
            var K102607C6F57607D07E473DAF7A03C59160D558373570K:* = /\?start=""\?start=/;
            var boo:* = K102607C6F57607D07E473DAF7A03C59160D558373570K.test(this._gslbUrl);
            if (this._location == "")
            {
                url = boo ? (this._gslbUrl + "&prot=2") : (this._gslbUrl + "?prot=2");
                this._gslbLoader = new URLLoaderUtil();
                this._gslbLoader.load(this.GSLB_TIMEOUT, function (param1:Object) : void
            {
                var _loc_2:Array = null;
                _spend_num = param1.target.spend;
                if (param1.info == "success")
                {
                    _url = param1.data;
                    _url = _url.split("|")[0];
                    _loc_2 = _url.split("?");
                    _location = _loc_2[0];
                    _parameterString = _loc_2[1];
                    if (_loc_2.length > 1)
                    {
                        _parameter = new URLVariables(_loc_2[1]);
                    }
                    doPlay(_url);
                    dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Success"}));
                }
                else if (param1.info == "timeout")
                {
                    dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"timeout"}));
                }
                else
                {
                    dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code:"GSLB.Failed", reason:"ioerror"}));
                }
                return;
            }// end function
            , url, null);
            }
            else
            {
                this._spend_num = 0;
                K102607C939D77E372B425F9B2092364BF65E81373570K;
                if (boo)
                {
                    K102607C939D77E372B425F9B2092364BF65E81373570K = this._location;
                    K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K;
                    sp;
                    var _loc_2:int = 0;
                    var _loc_3:* = this._parameter;
                    while (_loc_3 in _loc_2)
                    {
                        
                        K10255269C23FDCE8B24503A67C29619F006FF3373515K = _loc_3[_loc_2];
                        if (K10255269C23FDCE8B24503A67C29619F006FF3373515K.toString() != "start")
                        {
                            if (K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K)
                            {
                                K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K;
                                sp;
                            }
                            else
                            {
                                sp;
                            }
                            K102607C939D77E372B425F9B2092364BF65E81373570K = K102607C939D77E372B425F9B2092364BF65E81373570K + (sp + K10255269C23FDCE8B24503A67C29619F006FF3373515K.toString() + "=" + this._parameter[K10255269C23FDCE8B24503A67C29619F006FF3373515K]);
                        }
                    }
                    sp = K1025555F8D5C586B1E4F64BF49F473C1F3B52C373518K ? ("?") : ("&");
                    p = new URLVariables(this._gslbUrl.split("?")[1]);
                    K102607C939D77E372B425F9B2092364BF65E81373570K = K102607C939D77E372B425F9B2092364BF65E81373570K + (sp + "start=" + p.start);
                }
                else
                {
                    K102607C939D77E372B425F9B2092364BF65E81373570K = this._location + "?" + this._parameterString;
                }
                this.doPlay(K102607C939D77E372B425F9B2092364BF65E81373570K);
            }
            return;
        }// end function

        public function retry(param1:String) : void
        {
            this._gslbUrl = param1;
            this.play(this._gslbUrl);
            this.pause();
            return;
        }// end function

        override public function pause() : void
        {
            this._isPlay = false;
            super.pause();
            return;
        }// end function

        override public function resume() : void
        {
            this._isPlay = true;
            super.resume();
            return;
        }// end function

        public function get gone() : String
        {
            return this._gone;
        }// end function

        public function get location() : String
        {
            return this._url;
        }// end function

        public function get node() : String
        {
            return this._node;
        }// end function

        public function get gslbSpendTime() : Number
        {
            return this._spend_num;
        }// end function

        public function destroyLocation() : void
        {
            this._location = "";
            return;
        }// end function

        public function get bufferNum() : uint
        {
            return this._bufferNum;
        }// end function

        public function set bufferNum(param1:uint) : void
        {
            this._bufferNum = param1;
            return;
        }// end function

        public function get playUrl() : String
        {
            return this._playUrl;
        }// end function

        public function get isDrag() : Boolean
        {
            return this._isDrag;
        }// end function

        public function get dragTime() : Number
        {
            return this._dragTime;
        }// end function

        public function set dragTime(param1:Number) : void
        {
            this._dragTime = param1;
            return;
        }// end function

        public function get cdnNum() : Number
        {
            return this._cdnNum;
        }// end function

        public function set cdnNum(param1:Number) : void
        {
            this._cdnNum = param1;
            return;
        }// end function

        public function get gslbNum() : Number
        {
            return this._gslbNum;
        }// end function

        public function set gslbNum(param1:Number) : void
        {
            this._gslbNum = param1;
            return;
        }// end function

        public function get gslbUrl() : String
        {
            return this._gslbUrl;
        }// end function

        public function get cdnuse() : Number
        {
            var _loc_1:* = this._cdnuse != -1 ? (getTimer() - this._cdnuse) : (-1);
            this._cdnuse = -1;
            return _loc_1;
        }// end function

        public function set is200(param1:Boolean) : void
        {
            this._is200 = param1;
            return;
        }// end function

        public function get is200() : Boolean
        {
            return this._is200;
        }// end function

        protected function superPlay(param1) : void
        {
            super.play(param1);
            return;
        }// end function

        public function get isPlay() : Boolean
        {
            return this._isPlay;
        }// end function

    }
}
