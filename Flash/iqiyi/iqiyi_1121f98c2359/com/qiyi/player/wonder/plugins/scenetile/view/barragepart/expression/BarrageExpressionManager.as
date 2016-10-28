package com.qiyi.player.wonder.plugins.scenetile.view.barragepart.expression
{
    import __AS3__.vec.*;
    import com.adobe.serialization.json.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.loader.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class BarrageExpressionManager extends EventDispatcher
    {
        private var _expImageDic:Dictionary;
        private var _expUrlVector:Vector.<String>;
        private var _expConfig:Object = null;
        private var _expConfigDic:Dictionary = null;
        private var _curLoaderExpconfig:Object = null;
        private var _inited:Boolean = false;
        private var _loading:Boolean = false;
        private static var _instance:BarrageExpressionManager;
        public static const EVENT_COMPLETE:String = "";
        private static const STR_PCFLASH_ICON:String = "pc-flash";
        public static const EXP_TYPE_IMAGE:uint = 1;
        public static const EXP_TYPE_GIF:uint = 2;
        public static const EXP_TYPE_STRING:uint = 3;

        public function BarrageExpressionManager()
        {
            return;
        }// end function

        public function init() : void
        {
            if (this._inited)
            {
                return;
            }
            this._expUrlVector = new Vector.<String>;
            this._expImageDic = new Dictionary();
            this._expConfigDic = new Dictionary();
            var _loc_1:* = SystemConfig.BARRAGE_EXPRESSION_CONFIG + "ep_config.json";
            LoaderManager.instance.loader(_loc_1, this.callBackLoadComplete, null, LoaderManager.TYPE_URLlOADER);
            this._inited = true;
            return;
        }// end function

        public function getBitmapdataByContent(param1:String) : ExpImageVO
        {
            var _loc_2:ExpImageVO = null;
            var _loc_3:Object = null;
            if (!this._inited)
            {
                this.init();
            }
            if (this.isFaceContent(param1))
            {
                _loc_2 = this._expImageDic[param1.substr(1, param1.length - 2)];
                if (_loc_2)
                {
                    return _loc_2;
                }
                _loc_3 = this._expConfigDic[param1.substr(1, param1.length - 4)];
                if (_loc_3 && !this._loading && !this.isAlreadyLoader(param1))
                {
                    this._expUrlVector.push(param1);
                    this.requestExpConfig(param1.substr(1, param1.length - 4));
                }
            }
            return null;
        }// end function

        private function callBackLoadComplete(param1) : void
        {
            var _loc_2:Object = null;
            try
            {
                this._expConfig = JSON.decode(param1);
                if (this._expConfig && this._expConfig.packageList)
                {
                    for each (_loc_2 in this._expConfig.packageList)
                    {
                        
                        if (_loc_2 && _loc_2.id)
                        {
                            this._expConfigDic[_loc_2.id] = _loc_2;
                        }
                    }
                }
            }
            catch ($error:Error)
            {
            }
            return;
        }// end function

        private function requestExpConfig(param1:String) : void
        {
            var _loc_2:String = null;
            if (this._expConfig && this._expConfig.path)
            {
                this._loading = true;
                _loc_2 = this._expConfig.path + param1 + "_config.json";
                LoaderManager.instance.loader(_loc_2, this.requestConfigComplete, this.onLoaderError, LoaderManager.TYPE_URLlOADER);
            }
            return;
        }// end function

        private function requestConfigComplete(param1) : void
        {
            var _loc_2:Object = null;
            var _loc_3:Object = null;
            try
            {
                this._curLoaderExpconfig = JSON.decode(param1);
                _loc_2 = this._expConfigDic[this._curLoaderExpconfig.id];
                if (_loc_2 && _loc_2.type)
                {
                    switch(_loc_2.type)
                    {
                        case EXP_TYPE_IMAGE:
                        {
                            _loc_3 = this.getPCFlashImageConfig();
                            if (_loc_3)
                            {
                                LoaderManager.instance.loader(_loc_3.value, this.requestImageComplete, this.onLoaderError);
                            }
                            break;
                        }
                        case EXP_TYPE_STRING:
                        {
                            this.analyzeColorText();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
            }
            catch ($error:Error)
            {
            }
            return;
        }// end function

        private function analyzeColorText() : void
        {
            var _loc_1:ExpImageVO = null;
            var _loc_2:Object = null;
            this._loading = false;
            if (this._curLoaderExpconfig && this._curLoaderExpconfig.id && this._curLoaderExpconfig.emoticonList)
            {
                for each (_loc_2 in this._curLoaderExpconfig.emoticonList)
                {
                    
                    if (_loc_2.id && _loc_2.content)
                    {
                        _loc_1 = new ExpImageVO(_loc_2.content, EXP_TYPE_STRING);
                        this._expImageDic[this._curLoaderExpconfig.id + _loc_2.id] = _loc_1;
                    }
                }
            }
            dispatchEvent(new Event(EVENT_COMPLETE));
            return;
        }// end function

        private function requestImageComplete(param1) : void
        {
            var _loc_2:Bitmap = null;
            var _loc_3:Object = null;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:BitmapData = null;
            var _loc_7:Rectangle = null;
            var _loc_8:Object = null;
            var _loc_9:ExpImageVO = null;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            this._loading = false;
            try
            {
                _loc_2 = param1 as Bitmap;
                _loc_3 = this.getPCFlashImageConfig();
                if (_loc_2 && _loc_3 && _loc_3.eWidth && _loc_3.eHeight && _loc_3.sWidth && _loc_3.sHeight)
                {
                    _loc_4 = Math.floor(_loc_3.eWidth / _loc_3.sWidth);
                    _loc_5 = Math.floor(_loc_3.eHeight / _loc_3.sHeight);
                    _loc_10 = 0;
                    while (_loc_10 < _loc_4)
                    {
                        
                        _loc_11 = 0;
                        while (_loc_11 < _loc_5)
                        {
                            
                            _loc_7 = new Rectangle();
                            _loc_7.x = _loc_10 * _loc_3.sWidth;
                            _loc_7.y = _loc_11 * _loc_3.sHeight;
                            _loc_7.width = _loc_3.sWidth;
                            _loc_7.height = _loc_3.sHeight;
                            _loc_6 = new BitmapData(_loc_3.sWidth, _loc_3.sHeight, true, 0);
                            _loc_6.copyPixels(_loc_2.bitmapData, _loc_7, new Point(0, 0));
                            _loc_8 = this.getConfigInfoByOrder(_loc_10 * _loc_5 + _loc_11 + 1);
                            if (_loc_8)
                            {
                                _loc_9 = new ExpImageVO(_loc_6, EXP_TYPE_IMAGE);
                                this._expImageDic[this._curLoaderExpconfig.id + _loc_8.id] = _loc_9;
                            }
                            _loc_11++;
                        }
                        _loc_10++;
                    }
                }
                dispatchEvent(new Event(EVENT_COMPLETE));
            }
            catch ($error:Error)
            {
            }
            return;
        }// end function

        private function onLoaderError() : void
        {
            this._loading = false;
            return;
        }// end function

        private function getConfigInfoByOrder(param1:uint) : Object
        {
            var _loc_2:Object = null;
            if (this._curLoaderExpconfig && this._curLoaderExpconfig.emoticonList)
            {
                for each (_loc_2 in this._curLoaderExpconfig.emoticonList)
                {
                    
                    if (_loc_2.id && param1 == _loc_2.order)
                    {
                        return _loc_2;
                    }
                }
            }
            return null;
        }// end function

        private function getPCFlashImageConfig() : Object
        {
            var _loc_1:Object = null;
            if (this._curLoaderExpconfig && this._curLoaderExpconfig.eUrl && this._curLoaderExpconfig.eUrl.length > 0)
            {
                for each (_loc_1 in this._curLoaderExpconfig.eUrl)
                {
                    
                    if (_loc_1.platform && _loc_1.platform.search(STR_PCFLASH_ICON) != -1)
                    {
                        return _loc_1;
                    }
                }
            }
            return null;
        }// end function

        public function isFaceContent(param1:String) : Boolean
        {
            if (param1)
            {
                return param1.substr(0, 1) == "[" && param1.substr((param1.length - 1), 1) == "]";
            }
            return false;
        }// end function

        private function isAlreadyLoader(param1:String) : Boolean
        {
            var _loc_2:String = null;
            for each (_loc_2 in this._expUrlVector)
            {
                
                if (param1 == _loc_2)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public static function get instance() : BarrageExpressionManager
        {
            var _loc_1:* = _instance || new BarrageExpressionManager;
            _instance = _instance || new BarrageExpressionManager;
            return _loc_1;
        }// end function

    }
}
