package com.qiyi.player.base.cookie
{
    import flash.events.*;
    import flash.net.*;

    public class FixedBaseCookie extends Object
    {
        protected var _maxSize:int;
        protected var _so:SharedObject;
        protected var _data:Object;
        protected var _forbidden:Boolean = false;
        protected var _fieldName:String;
        protected var _fileName:String;

        public function FixedBaseCookie(param1:String, param2:String, param3:int)
        {
            var $filename:* = param1;
            var $field:* = param2;
            var $size:* = param3;
            this._maxSize = $size << 10;
            this._fieldName = $field;
            this._fileName = $filename;
            try
            {
                this._so = SharedObject.getLocal($filename, "/");
                this._so.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
                this._data = this._so.data[$field];
            }
            catch (e:Error)
            {
                _forbidden = true;
            }
            return;
        }// end function

        public function destroy() : void
        {
            if (this._so)
            {
                this._so.removeEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
                this._so.close();
                this._so = null;
            }
            return;
        }// end function

        protected function onNetStatus(event:NetStatusEvent) : void
        {
            if (event.info.code == "SharedObject.Flush.Failed")
            {
                this.clear();
            }
            else if (event.info.code == "SharedObject.Flush.Success")
            {
            }
            return;
        }// end function

        public function clear() : void
        {
            return;
        }// end function

        public function get data() : Object
        {
            return this._data;
        }// end function

        public function set data(param1:Object) : void
        {
            this._data = param1;
            return;
        }// end function

        public function flush() : void
        {
            try
            {
                this._so.flush();
            }
            catch (e:Error)
            {
                _forbidden = true;
            }
            return;
        }// end function

    }
}
