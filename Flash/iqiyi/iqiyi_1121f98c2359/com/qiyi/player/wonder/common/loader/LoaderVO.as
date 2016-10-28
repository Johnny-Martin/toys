package com.qiyi.player.wonder.common.loader
{

    public class LoaderVO extends Object
    {
        private var _url:String = "";
        private var _sucFun:Function = null;
        private var _errorFun:Function = null;
        private var _type:String = "";
        private var _retry:uint = 0;
        private var _alreadyTry:uint = 0;

        public function LoaderVO(param1:String, param2:Function, param3:Function, param4:String, param5:uint = 0)
        {
            this._url = param1;
            this._sucFun = param2;
            this._errorFun = param3;
            this._type = param4;
            this._retry = param5;
            return;
        }// end function

        public function get sucFun() : Function
        {
            return this._sucFun;
        }// end function

        public function get errorFun() : Function
        {
            return this._errorFun;
        }// end function

        public function get alreadyTry() : uint
        {
            return this._alreadyTry;
        }// end function

        public function set alreadyTry(param1:uint) : void
        {
            this._alreadyTry = param1;
            return;
        }// end function

        public function get retry() : uint
        {
            return this._retry;
        }// end function

        public function get type() : String
        {
            return this._type;
        }// end function

        public function get url() : String
        {
            return this._url;
        }// end function

        public function destroy() : void
        {
            this._url = null;
            this._sucFun = null;
            this._errorFun = null;
            this._type = null;
            this._retry = 0;
            return;
        }// end function

    }
}
