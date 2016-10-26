package ebing.net
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class URLLoaderUtil extends Object
    {
        protected var _handler_fun:Function;
        protected var _loader_url:URLLoader;
        protected var _isLoaded_boo:Boolean = false;
        protected var _setTimeoutId_num:Number;
        protected var _spend_num:Number = 0;
        protected var _timeout:Number = 0;
        protected var _obj:Object;
        protected var _url:String = "";
        protected var _isDispatched:Boolean = false;

        public function URLLoaderUtil()
        {
            this._obj = new Object();
            return;
        }// end function

        public function load(param1:Number, param2:Function, param3:String, param4:Object = null, param5:String = "null", param6:Array = null) : void
        {
            var K102607D8EF8BC6FDD448F88BE243DF5073A734373570K:URLRequest;
            var K1026071A844329504142D79D48353D044BBFA7373570K:URLVariables;
            var K10255269C23FDCE8B24503A67C29619F006FF3373515K:*;
            var i:uint;
            var time:* = param1;
            var handler:* = param2;
            var url:* = param3;
            var method:* = param4;
            var df:* = param5;
            var headers:* = param6;
            try
            {
                this._handler_fun = handler;
                this._loader_url = new URLLoader();
                this.addEvent(this._loader_url);
                switch(df)
                {
                    case "text":
                    case "null":
                    {
                        this._loader_url.dataFormat = URLLoaderDataFormat.TEXT;
                        break;
                    }
                    case "binary":
                    {
                        this._loader_url.dataFormat = URLLoaderDataFormat.BINARY;
                        break;
                    }
                    case "var":
                    {
                        this._loader_url.dataFormat = URLLoaderDataFormat.VARIABLES;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._url = url;
                K102607D8EF8BC6FDD448F88BE243DF5073A734373570K = new URLRequest(url);
                if (method != null)
                {
                    K102607D8EF8BC6FDD448F88BE243DF5073A734373570K.method = method.method == "POST" ? (URLRequestMethod.POST) : (URLRequestMethod.GET);
                    switch(method.dataType)
                    {
                        case "u":
                        {
                            K1026071A844329504142D79D48353D044BBFA7373570K = new URLVariables();
                            var _loc_8:int = 0;
                            var _loc_9:* = method.data;
                            while (_loc_9 in _loc_8)
                            {
                                
                                K10255269C23FDCE8B24503A67C29619F006FF3373515K = _loc_9[_loc_8];
                                K1026071A844329504142D79D48353D044BBFA7373570K[K10255269C23FDCE8B24503A67C29619F006FF3373515K] = method.data[K10255269C23FDCE8B24503A67C29619F006FF3373515K];
                            }
                            K102607D8EF8BC6FDD448F88BE243DF5073A734373570K.data = K1026071A844329504142D79D48353D044BBFA7373570K;
                            break;
                        }
                        case "b":
                        {
                            K102607D8EF8BC6FDD448F88BE243DF5073A734373570K.data = method.data;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                if (headers != null)
                {
                    i;
                    while (i < headers.length)
                    {
                        
                        K102607D8EF8BC6FDD448F88BE243DF5073A734373570K.requestHeaders.push(new URLRequestHeader(String(headers[i].name), String(headers[i].value)));
                        i = (i + 1);
                    }
                }
                this._isDispatched = false;
                this._loader_url.load(K102607D8EF8BC6FDD448F88BE243DF5073A734373570K);
                this._spend_num = getTimer();
                this._setTimeoutId_num = setTimeout(this.K102607110A40D4F1854BF6B82416E6749EFB04373570K, time * 1000);
            }
            catch (e)
            {
                trace("error");
            }
            return;
        }// end function

        public function send(param1:String, param2:Object = null) : void
        {
            var _loc_4:URLVariables = null;
            var _loc_5:* = undefined;
            var _loc_3:* = new URLRequest(param1);
            if (param2 != null)
            {
                _loc_3.method = param2.method == "POST" ? (URLRequestMethod.POST) : (URLRequestMethod.GET);
                switch(param2.dataType)
                {
                    case "u":
                    {
                        _loc_4 = new URLVariables();
                        for (_loc_5 in param2.data)
                        {
                            
                            _loc_4[_loc_5] = param2.data[_loc_5];
                        }
                        _loc_3.data = _loc_4;
                        break;
                    }
                    case "b":
                    {
                        _loc_3.data = param2.data;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            sendToURL(_loc_3);
            return;
        }// end function

        public function multiSend(param1:String) : void
        {
            if (param1 == null || param1 == "")
            {
                return;
            }
            var _loc_2:* = param1.split("|http:");
            var _loc_3:String = "";
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_3 = _loc_4 > 0 ? ("http:") : ("");
                _loc_3 = _loc_3 + _loc_2[_loc_4];
                this.send(_loc_3);
                _loc_4++;
            }
            return;
        }// end function

        private function removeEvent(param1:IEventDispatcher) : void
        {
            param1.removeEventListener(Event.COMPLETE, this.K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K);
            param1.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            param1.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
            return;
        }// end function

        private function addEvent(param1:IEventDispatcher) : void
        {
            if (!param1.hasEventListener(Event.COMPLETE))
            {
                param1.addEventListener(Event.COMPLETE, this.K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K);
                param1.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
                param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
                param1.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
            }
            return;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            if (!this._isDispatched)
            {
                this._isDispatched = true;
                this.close();
                clearTimeout(this._setTimeoutId_num);
                this._isLoaded_boo = false;
                this._spend_num = getTimer() - this._spend_num;
                if (this._handler_fun != null)
                {
                    this._handler_fun({info:"securityError", err:event, target:this});
                }
            }
            return;
        }// end function

        private function K10260756E24EB7DF5C44198ED3ECC3A1EBE300373570K(event:Event) : void
        {
            if (!this._isDispatched)
            {
                this._isDispatched = true;
                this.close();
                clearTimeout(this._setTimeoutId_num);
                this._isLoaded_boo = true;
                this._spend_num = getTimer() - this._spend_num;
                if (this._handler_fun != null)
                {
                    this._handler_fun({info:"success", data:event.target.data, target:this, urlloader:event.target});
                }
            }
            return;
        }// end function

        protected function ioErrorHandler(event:IOErrorEvent) : void
        {
            if (!this._isDispatched)
            {
                this._isDispatched = true;
                this.close();
                clearTimeout(this._setTimeoutId_num);
                this._isLoaded_boo = false;
                this._spend_num = getTimer() - this._spend_num;
                if (this._handler_fun != null)
                {
                    this._handler_fun({info:"ioError", err:event, target:this});
                }
            }
            return;
        }// end function

        private function K102607110A40D4F1854BF6B82416E6749EFB04373570K() : void
        {
            if (!this._isDispatched)
            {
                this._isDispatched = true;
                trace("timeout");
                if (!this._isLoaded_boo)
                {
                    this.close();
                    this._spend_num = getTimer() - this._spend_num;
                    if (this._handler_fun != null)
                    {
                        this._handler_fun({info:"timeout", target:this});
                    }
                }
            }
            return;
        }// end function

        protected function httpStatusHandler(event:HTTPStatusEvent) : void
        {
            return;
        }// end function

        public function close() : void
        {
            try
            {
                this._loader_url.close();
            }
            catch (evt)
            {
            }
            this.removeEvent(this._loader_url);
            return;
        }// end function

        public function get spend() : Number
        {
            return this._spend_num;
        }// end function

        public function get timeLimit() : Number
        {
            return this._timeout;
        }// end function

        public function set obj(param1:Object) : void
        {
            this._obj = param1;
            return;
        }// end function

        public function get obj() : Object
        {
            return this._obj;
        }// end function

        public function get url() : String
        {
            return this._url;
        }// end function

    }
}
