package com.qiyi.player.wonder.plugins.scenetile.model.barrage.actor
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.event.*;
    import com.qiyi.player.wonder.common.loader.*;
    import flash.events.*;
    import flash.utils.*;

    public class BarrageStarInteractInfo extends EventDispatcher
    {
        private var _isLoading:Boolean = false;
        private var _isReady:Boolean = false;
        private var _starInteractObj:Object = null;
        private var _starInteractDic:Dictionary;
        public static const Evt_LoaderBarrageInteractInfoComplete:String = "evtLoaderBarrageInteractInfoComplete";

        public function BarrageStarInteractInfo()
        {
            this._starInteractDic = new Dictionary();
            return;
        }// end function

        public function get starInteractObj() : Object
        {
            return this._starInteractObj;
        }// end function

        public function get isLoading() : Boolean
        {
            return this._isLoading;
        }// end function

        public function get isReady() : Boolean
        {
            return this._isReady;
        }// end function

        public function startLoad() : void
        {
            if (this._isLoading)
            {
                return;
            }
            this._isLoading = true;
            this._isReady = false;
            var _loc_1:* = SystemConfig.BARRAGE_STAR_INTERACT_URL + "?rn=" + Math.random();
            LoaderManager.instance.loader(_loc_1, this.callbackLoadComplete, this.callbackLoadError, LoaderManager.TYPE_URLlOADER, 3);
            return;
        }// end function

        private function callbackLoadComplete(param1:Object) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            this._isLoading = false;
            this._isReady = true;
            try
            {
                _loc_2 = JSON.decode(param1.toString());
                for each (_loc_3 in _loc_2.list)
                {
                    
                    if (_loc_3.id && _loc_3.data)
                    {
                        this._starInteractDic[_loc_3.id] = _loc_3.data;
                    }
                }
                this._starInteractObj = _loc_2;
                dispatchEvent(new CommonEvent(Evt_LoaderBarrageInteractInfoComplete, _loc_2));
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function callbackLoadError() : void
        {
            this._isLoading = false;
            this._isReady = true;
            return;
        }// end function

        public function getStarInteractByTvid(param1:String) : Object
        {
            var _loc_2:* = this._starInteractDic[param1];
            return _loc_2;
        }// end function

    }
}
