package com.qiyi.player.wonder.plugins.scenetile.model.barrage
{
    import __AS3__.vec.*;
    import com.adobe.serialization.json.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.event.*;
    import com.qiyi.player.wonder.common.loader.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.actor.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.socket.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.vo.*;
    import com.qiyi.player.wonder.plugins.scenetile.view.barragepart.expression.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.utils.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class BarrageProxy extends Proxy
    {
        private var _curDataParagraph:uint = 0;
        private var _preLoadDataParagraph:uint = 0;
        private var _isLoading:Boolean = false;
        private var _loader:URLLoader;
        private var _barrageData:Dictionary;
        private var _vecOP:ObjectPool;
        private var _barrageItemOP:ObjectPool;
        private var _curShowTime:int = 0;
        private var _isBarrageOpen:Boolean;
        private var _barrageAlpha:uint = 90;
        private var _barrageIsFilterImage:Boolean = false;
        private var _starInteractInfo:BarrageStarInteractInfo;
        private var _barrageSocket:BarrageSocket;
        private var _isRequestBarrageConfig:Boolean = false;
        private var _barrageConfigObj:Object = null;
        private var _tvid:String = "";
        private var _albumid:String = "";
        private var _cid:int = 0;

        public function BarrageProxy()
        {
            this._barrageData = new Dictionary();
            this._isBarrageOpen = FlashVarConfig.openBarrage;
            this._vecOP = new ObjectPool();
            this._barrageItemOP = new ObjectPool();
            this.getBarrageSettingFromJSCookies();
            this._barrageSocket = new BarrageSocket();
            this._starInteractInfo = new BarrageStarInteractInfo();
            this._starInteractInfo.addEventListener(BarrageStarInteractInfo.Evt_LoaderBarrageInteractInfoComplete, this.onLoaderBIIComplete);
            this._barrageSocket.addEventListener(BarrageSocket.Evt_BarrageSocketReceiveData, this.onReceiveData);
            this._barrageSocket.addEventListener(BarrageSocket.Evt_BarrageSocketConnected, this.onConnected);
            this._barrageSocket.addEventListener(BarrageSocket.Evt_BarrageSocketClose, this.onClose);
            return;
        }// end function

        public function get barrageConfigObj() : Object
        {
            return this._barrageConfigObj;
        }// end function

        public function set barrageConfigObj(param1:Object) : void
        {
            this._barrageConfigObj = param1;
            return;
        }// end function

        public function get isRequestBarrageConfig() : Boolean
        {
            return this._isRequestBarrageConfig;
        }// end function

        public function set isRequestBarrageConfig(param1:Boolean) : void
        {
            this._isRequestBarrageConfig = param1;
            return;
        }// end function

        public function get barrageSocket() : BarrageSocket
        {
            return this._barrageSocket;
        }// end function

        public function get starInteractInfo() : BarrageStarInteractInfo
        {
            return this._starInteractInfo;
        }// end function

        public function get barrageIsFilterImage() : Boolean
        {
            return this._barrageIsFilterImage;
        }// end function

        public function set barrageIsFilterImage(param1:Boolean) : void
        {
            this._barrageIsFilterImage = param1;
            return;
        }// end function

        public function get barrageAlpha() : uint
        {
            return this._barrageAlpha;
        }// end function

        public function set barrageAlpha(param1:uint) : void
        {
            this._barrageAlpha = param1;
            return;
        }// end function

        public function get preLoadDataParagraph() : uint
        {
            return this._preLoadDataParagraph;
        }// end function

        public function set preLoadDataParagraph(param1:uint) : void
        {
            this._preLoadDataParagraph = param1;
            return;
        }// end function

        public function get isBarrageOpen() : Boolean
        {
            return this._isBarrageOpen;
        }// end function

        public function set isBarrageOpen(param1:Boolean) : void
        {
            this._isBarrageOpen = param1;
            sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
            return;
        }// end function

        public function get curDataParagraph() : uint
        {
            return this._curDataParagraph;
        }// end function

        public function set curDataParagraph(param1:uint) : void
        {
            this._curDataParagraph = param1;
            return;
        }// end function

        public function requestBarrageData(param1:uint, param2:String, param3:String, param4:int) : void
        {
            if (this._preLoadDataParagraph == param1)
            {
                return;
            }
            this._preLoadDataParagraph = param1;
            this._tvid = param2;
            this._cid = param4;
            this._albumid = param3;
            var _loc_5:* = SystemConfig.BARRAGE_CONTROL_CONFIG_URL + "business=danmu" + "&is_iqiyi=true" + "&is_video_page=true" + "&tvid=" + param2 + "&albumid=" + param3 + "&categoryid=" + param4 + "&qypid=01010011010000000000" + "&tn=" + Math.random();
            LoaderManager.instance.loader(_loc_5, this.callbackForRequestBarrageData, null, LoaderManager.TYPE_URLlOADER);
            return;
        }// end function

        private function callbackForRequestBarrageData(param1:Object) : void
        {
            var _loc_2:Object = null;
            var _loc_3:JavascriptAPIProxy = null;
            try
            {
                _loc_2 = JSON.decode(param1.toString());
                this._barrageConfigObj = _loc_2;
                this.requestData();
                if (_loc_2 && _loc_2.code == "A00000" && _loc_2.data)
                {
                    _loc_3 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    _loc_3.callJsSetHasBarrageConfigInfo(_loc_2.data);
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function requestData() : void
        {
            try
            {
                if (this._loader)
                {
                    this._loader.removeEventListener(Event.COMPLETE, this.onCompleteHandler);
                    this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onErrorHander);
                    this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHander);
                    this._loader.close();
                    this._loader = null;
                }
            }
            catch (e:Error)
            {
            }
            if (this._curDataParagraph == this._preLoadDataParagraph)
            {
                return;
            }
            BarrageExpressionManager.instance.init();
            this.clearBarrageData();
            var _loc_1:* = "0000" + this._tvid;
            var _loc_2:* = SystemConfig.BARRAGE_DATA_URL + _loc_1.substr(_loc_1.length - 4, 2) + "/" + _loc_1.substr(_loc_1.length - 2, 2) + "/" + this._tvid + "_" + SceneTileDef.BARRAGE_REQUEST_INTERVAL_TIME / 1000 + "_" + this._preLoadDataParagraph + ".z?rn=" + Math.random() + "&business=danmu" + "&is_iqiyi=true" + "&is_video_page=true" + "&tvid=" + this._tvid + "&albumid=" + this._albumid + "&categoryid=" + this._cid + "&qypid=01010011010000000000";
            this._loader = new URLLoader();
            this._loader.dataFormat = URLLoaderDataFormat.BINARY;
            this._loader.addEventListener(Event.COMPLETE, this.onCompleteHandler);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.onErrorHander);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onErrorHander);
            this._loader.load(new URLRequest(_loc_2));
            return;
        }// end function

        private function onCompleteHandler(event:Event) : void
        {
            var _loc_3:String = null;
            var _loc_4:XML = null;
            this._curDataParagraph = this._preLoadDataParagraph;
            var _loc_2:* = this._loader.data as ByteArray;
            try
            {
                _loc_2.uncompress();
                _loc_3 = _loc_2.readMultiByte(_loc_2.length, "utf-8");
                _loc_4 = new XML(_loc_2);
                if (_loc_4.code == "A00000")
                {
                    this.analyzeXmlBarrageData(_loc_4);
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function onErrorHander(param1) : void
        {
            return;
        }// end function

        private function analyzeXmlBarrageData(param1:XML) : void
        {
            var _loc_2:Vector.<BarrageInfoVO> = null;
            var _loc_3:BarrageInfoVO = null;
            var _loc_4:XML = null;
            var _loc_5:XML = null;
            for each (_loc_4 in param1.data.entry)
            {
                
                _loc_2 = this._vecOP.pop() as Vector.<BarrageInfoVO>;
                if (_loc_2 == null)
                {
                    _loc_2 = new Vector.<BarrageInfoVO>;
                }
                for each (_loc_5 in _loc_4.list.bulletInfo)
                {
                    
                    _loc_3 = this._barrageItemOP.pop() as BarrageInfoVO;
                    if (_loc_3 == null)
                    {
                        _loc_3 = new BarrageInfoVO();
                    }
                    _loc_3.update(_loc_5, SceneTileDef.BARRAGE_SOURCE_HTTP);
                    _loc_2.push(_loc_3);
                }
                this._barrageData[uint(_loc_4.int)] = _loc_2;
            }
            return;
        }// end function

        private function clearBarrageData() : void
        {
            var _loc_1:Vector.<BarrageInfoVO> = null;
            var _loc_2:BarrageInfoVO = null;
            var _loc_3:* = undefined;
            for (_loc_3 in this._barrageData)
            {
                
                _loc_1 = this._barrageData[_loc_3] as Vector.<BarrageInfoVO>;
                while (_loc_1.length > 0)
                {
                    
                    _loc_2 = _loc_1.pop();
                    this._barrageItemOP.push(_loc_2);
                }
                this._vecOP.push(_loc_1);
                delete this._barrageData[_loc_3];
            }
            return;
        }// end function

        public function getBarrageData(param1:int) : Vector.<BarrageInfoVO>
        {
            var _loc_3:Vector.<BarrageInfoVO> = null;
            var _loc_4:uint = 0;
            if (this._curShowTime == param1)
            {
                return null;
            }
            this._curShowTime = param1;
            var _loc_2:* = this._barrageData[param1];
            if (_loc_2 && this._barrageSocket.connected)
            {
                _loc_3 = new Vector.<BarrageInfoVO>;
                _loc_4 = 0;
                while (_loc_4 < _loc_2.length)
                {
                    
                    if (_loc_2[_loc_4].contentType != SceneTileDef.BARRAGE_CONTENT_TYPE_STAR)
                    {
                        _loc_3.push(_loc_2[_loc_4]);
                    }
                    _loc_4 = _loc_4 + 1;
                }
                return _loc_3;
            }
            return _loc_2;
        }// end function

        private function onReceiveData(event:CommonEvent) : void
        {
            var _loc_2:Array = null;
            var _loc_3:Vector.<BarrageInfoVO> = null;
            var _loc_4:BarrageInfoVO = null;
            var _loc_5:Object = null;
            var _loc_6:Array = null;
            var _loc_7:Array = null;
            var _loc_8:int = 0;
            var _loc_9:JavascriptAPIProxy = null;
            var _loc_10:uint = 0;
            try
            {
                _loc_2 = event.data as Array;
                if (_loc_2 && _loc_2.length > 0)
                {
                    _loc_3 = new Vector.<BarrageInfoVO>;
                    _loc_7 = new Array();
                    _loc_8 = 0;
                    while (_loc_8 < _loc_2.length)
                    {
                        
                        if (_loc_2[_loc_8].TVLType == BarrageSocket.TVL_TYPE_MULTICAST)
                        {
                            _loc_5 = JSON.decode(_loc_2[_loc_8].TVLContent);
                            if (_loc_5.data)
                            {
                                _loc_6 = _loc_5.data as Array;
                                _loc_10 = 0;
                                while (_loc_10 < _loc_6.length)
                                {
                                    
                                    _loc_4 = this._barrageItemOP.pop() as BarrageInfoVO;
                                    if (_loc_4 == null)
                                    {
                                        _loc_4 = new BarrageInfoVO();
                                    }
                                    _loc_4.update(_loc_6[_loc_10], SceneTileDef.BARRAGE_SOURCE_HTTP);
                                    _loc_3.push(_loc_4);
                                    _loc_10 = _loc_10 + 1;
                                }
                            }
                            _loc_7.push(_loc_5);
                        }
                        _loc_8++;
                    }
                    _loc_9 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    if (_loc_3.length > 0)
                    {
                        _loc_9.callJsBarrageReceiveData(_loc_7);
                    }
                    sendNotification(SceneTileDef.NOTIFIC_RECEIVE_BARRAGE_INFO, _loc_3);
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

        private function onConnected(event:CommonEvent) : void
        {
            this.onLoaderBIIComplete();
            sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
            return;
        }// end function

        private function onClose(event:CommonEvent) : void
        {
            this.onLoaderBIIComplete();
            sendNotification(SceneTileDef.NOTIFIC_STAR_HEAD_SHOW);
            return;
        }// end function

        private function onLoaderBIIComplete(event:CommonEvent = null) : void
        {
            var _loc_2:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            _loc_2.callJsSetBarrageInteractInfo(this._starInteractInfo.starInteractObj, this._barrageSocket.connected);
            var _loc_3:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_3)
            {
                var _loc_4:* = this._barrageSocket.connected;
                _loc_3.preActor.isStarBarrage = this._barrageSocket.connected;
                _loc_3.curActor.isStarBarrage = _loc_4;
            }
            return;
        }// end function

        public function requestBarrageConfig(param1:String, param2:String, param3:int) : void
        {
            if (this._isRequestBarrageConfig)
            {
                return;
            }
            this._isRequestBarrageConfig = true;
            var _loc_4:* = SystemConfig.BARRAGE_CONTROL_CONFIG_URL + "business=danmu" + "&is_iqiyi=true" + "&is_video_page=true" + "&tvid=" + param1 + "&albumid=" + param2 + "&categoryid=" + param3 + "&qypid=01010011010000000000" + "&tn=" + Math.random();
            LoaderManager.instance.loader(_loc_4, this.callbackForRequestBarrageConfig, null, LoaderManager.TYPE_URLlOADER);
            return;
        }// end function

        private function callbackForRequestBarrageConfig(param1:Object) : void
        {
            var _loc_2:Object = null;
            var _loc_3:JavascriptAPIProxy = null;
            try
            {
                _loc_2 = JSON.decode(param1.toString());
                this._barrageConfigObj = _loc_2;
                if (_loc_2 && _loc_2.code == "A00000" && _loc_2.data)
                {
                    _loc_3 = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
                    _loc_3.callJsSetHasBarrageConfigInfo(_loc_2.data);
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function checkCanBarrageFakeWrite() : Boolean
        {
            if (this._barrageConfigObj && this._barrageConfigObj.data && this._barrageConfigObj.data.fakeWriteEnable && this._barrageConfigObj.data.fakeWriteEnable == true)
            {
                return true;
            }
            return false;
        }// end function

        public function checkShowBarrage() : Boolean
        {
            if (this._barrageConfigObj && this._barrageConfigObj.data && this._barrageConfigObj.data.contentDisplayEnable && this._barrageConfigObj.data.contentDisplayEnable == true && !LocalizaEnum.isTWLocalize(FlashVarConfig.localize))
            {
                return true;
            }
            return false;
        }// end function

        public function getBarrageSettingFromJSCookies() : void
        {
            var _loc_1:String = null;
            var _loc_2:Object = null;
            try
            {
                _loc_1 = ExternalInterface.call("Q.cookie.get", "QC118");
                if (_loc_1)
                {
                    _loc_2 = JSON.decode(_loc_1);
                    if (_loc_2 != null && _loc_2.opacity != null && _loc_2.opacity != undefined)
                    {
                        this._barrageAlpha = uint(_loc_2.opacity) < 50 || uint(_loc_2.opacity) > 100 ? (SceneTileDef.BARRAGE_DEFAULT_ALPHA) : (uint(_loc_2.opacity));
                    }
                    if (_loc_2 != null && _loc_2.isFilterImage != null && _loc_2.isFilterImage != undefined)
                    {
                        this._barrageIsFilterImage = _loc_2.isFilterImage == "1" ? (true) : (false);
                    }
                }
            }
            catch (error:Error)
            {
            }
            return;
        }// end function

    }
}
