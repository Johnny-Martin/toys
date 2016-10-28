package com.qiyi.player.wonder.common.loader
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.common.event.*;

    public class LoaderManager extends Object
    {
        private var _waitLoadVec:Vector.<LoaderVO>;
        private var _commonLoader:CommonLoader;
        private var _inited:Boolean = false;
        private var _loading:Boolean = false;
        private static var _instance:LoaderManager;
        public static const TYPE_LOADER:String = "TYPE_LOADER";
        public static const TYPE_URLlOADER:String = "TYPE_URLlOADER";

        public function LoaderManager()
        {
            return;
        }// end function

        public function init() : void
        {
            if (this._inited)
            {
                return;
            }
            this._waitLoadVec = new Vector.<LoaderVO>;
            this._commonLoader = new CommonLoader();
            this._inited = true;
            return;
        }// end function

        public function loader(param1:String, param2:Function = null, param3:Function = null, param4:String = "TYPE_LOADER", param5:uint = 0) : void
        {
            var _loc_7:uint = 0;
            if (!this._inited)
            {
                this.init();
            }
            var _loc_6:* = new LoaderVO(param1, param2, param3, param4, param5);
            if (!this._loading)
            {
                this.tryLoader(_loc_6);
            }
            else
            {
                _loc_7 = 0;
                while (_loc_7 < this._waitLoadVec.length)
                {
                    
                    if (this._waitLoadVec[_loc_7] == _loc_6)
                    {
                        return;
                    }
                    _loc_7 = _loc_7 + 1;
                }
                this._waitLoadVec.push(_loc_6);
            }
            return;
        }// end function

        private function tryLoader(param1:LoaderVO) : void
        {
            this._loading = true;
            this._commonLoader.startLoad(param1);
            this._commonLoader.addEventListener(CommonLoader.EVENT_COMPLETE, this.onCompleteHandler);
            this._commonLoader.addEventListener(CommonLoader.EVENT_ERROR, this.onErrorHandler);
            return;
        }// end function

        private function onCompleteHandler(event:CommonEvent) : void
        {
            this._loading = false;
            this._commonLoader.removeEventListener(CommonLoader.EVENT_COMPLETE, this.onCompleteHandler);
            this._commonLoader.removeEventListener(CommonLoader.EVENT_ERROR, this.onErrorHandler);
            if (this._waitLoadVec.length > 0)
            {
                this.tryLoader(this._waitLoadVec.pop());
            }
            return;
        }// end function

        private function onErrorHandler(event:CommonEvent) : void
        {
            this._loading = false;
            this._commonLoader.removeEventListener(CommonLoader.EVENT_COMPLETE, this.onCompleteHandler);
            this._commonLoader.removeEventListener(CommonLoader.EVENT_ERROR, this.onErrorHandler);
            if (this._waitLoadVec.length > 0)
            {
                this.tryLoader(this._waitLoadVec.pop());
            }
            return;
        }// end function

        public static function get instance() : LoaderManager
        {
            var _loc_1:* = _instance || new LoaderManager;
            _instance = _instance || new LoaderManager;
            return _loc_1;
        }// end function

    }
}
