package com.sohu.tv.mediaplayer.ui
{
    import com.sohu.tv.mediaplayer.*;
    import ebing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class TvSohuPicPreview extends Sprite
    {
        protected var _bigImgWidth:Number = 160;
        protected var _bigImgHeight:Number = 68;
        protected var _smallImgWidth:Number = 60;
        protected var _smallImgHeight:Number = 34;
        protected var _timeLimit:Number = 15;
        protected var _bigPicUrl:String = "";
        protected var _smallPicUrl:String = "";
        protected var _arrayBigBlocks:Array;
        protected var _arraySmallBlocks:Array;
        protected var _totalBlocks:Number = 50;
        protected var _MaxBlock:Number = 50;
        private var _bigPicBytes:ByteArray;

        public function TvSohuPicPreview()
        {
            this._arrayBigBlocks = new Array();
            this._arraySmallBlocks = new Array();
            return;
        }// end function

        public function hardInit(param1:Object = null) : void
        {
            if (param1 != null)
            {
                this._bigPicUrl = param1.bigPicUrl;
                this._bigImgWidth = this._bigPicUrl.split(".jpg")[0].split("_")[this._bigPicUrl.split(".jpg")[0].split("_").length - 3];
                this._bigImgHeight = this._bigPicUrl.split(".jpg")[0].split("_")[this._bigPicUrl.split(".jpg")[0].split("_").length - 2];
                this._timeLimit = this._bigPicUrl.split(".jpg")[0].split("_")[(this._bigPicUrl.split(".jpg")[0].split("_").length - 1)];
                this._totalBlocks = Math.ceil(PlayerConfig.totalDuration / this._timeLimit) + 1;
            }
            this.sysInit("start");
            return;
        }// end function

        protected function sysInit(param1:String = null) : void
        {
            if (param1 == "start")
            {
                this.newFunc();
                this.drawSkin();
                this.addEvent();
            }
            return;
        }// end function

        protected function newFunc() : void
        {
            return;
        }// end function

        public function startLoadPic() : void
        {
            this.initPicArr();
            this.sendRequest("big", this._bigPicUrl);
            return;
        }// end function

        public function initPicArr() : void
        {
            this._arrayBigBlocks = [];
            this._arraySmallBlocks = [];
            return;
        }// end function

        private function sendRequest(param1:String, param2:String) : void
        {
            var m_request:URLRequest;
            var m_loader:URLLoader;
            var flag:* = param1;
            var p_url:* = param2;
            try
            {
                m_request = new URLRequest(p_url);
                m_loader = new URLLoader();
                m_loader.dataFormat = URLLoaderDataFormat.BINARY;
                m_loader.addEventListener(Event.COMPLETE, function (param1) : void
            {
                onSendComplete(param1, flag);
                return;
            }// end function
            );
                m_loader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
                m_loader.load(m_request);
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        private function onSendComplete(event:Event, param2:String = null) : void
        {
            var e:* = event;
            var flag:* = param2;
            var m_content:* = e.target.data as ByteArray;
            var _loader:* = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (param1) : void
            {
                onLoadComplete(param1, flag);
                return;
            }// end function
            );
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _loader.loadBytes(m_content);
            var urlLoader:* = URLLoader(e.target);
            urlLoader.removeEventListener(Event.COMPLETE, this.onSendComplete);
            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            return;
        }// end function

        private function onLoadComplete(event:Event, param2:String = null) : void
        {
            var _loc_3:* = (event.target.content as Bitmap).bitmapData;
            if (param2 == "big")
            {
                this._bigPicBytes = new ByteArray();
                this._bigPicBytes = BitmapBytes.encodeByteArray(_loc_3);
                this._arrayBigBlocks = this.getBitMapArr(_loc_3, this._bigImgWidth, this._bigImgHeight);
                dispatchEvent(new Event("bigComplete"));
                this.sendRequest("small", this._bigPicUrl);
            }
            if (param2 == "small")
            {
                this._arraySmallBlocks = this.getBitMapArr(_loc_3, this._bigImgWidth, this._bigImgHeight);
                dispatchEvent(new Event("smallComplete"));
            }
            var _loc_4:* = Loader(event.target.loader);
            Loader(event.target.loader).contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onLoadComplete);
            _loc_4.unloadAndStop();
            _loc_4 = null;
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function getHorNum(param1:Number) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:int = 0;
            while (_loc_3 < param1)
            {
                
                if (_loc_3 == (param1 - 1))
                {
                    _loc_2.push(this._totalBlocks - this._MaxBlock * _loc_3);
                }
                else
                {
                    _loc_2.push(this._MaxBlock);
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        private function getBitMapArr(param1:BitmapData, param2:Number, param3:Number) : Array
        {
            var _loc_8:int = 0;
            var _loc_9:BitmapData = null;
            var _loc_10:Bitmap = null;
            var _loc_4:* = new Array();
            var _loc_5:* = Math.ceil(this._totalBlocks / this._MaxBlock);
            var _loc_6:* = this.getHorNum(_loc_5);
            var _loc_7:int = 0;
            while (_loc_7 < _loc_5)
            {
                
                _loc_8 = 0;
                while (_loc_8 < _loc_6[_loc_7])
                {
                    
                    _loc_9 = new BitmapData(param2, param3);
                    _loc_9.copyPixels(param1, new Rectangle(_loc_8 * param2, _loc_7 * param3, param2, param3), new Point(0, 0));
                    _loc_10 = new Bitmap(_loc_9);
                    _loc_4.push(_loc_10);
                    _loc_8++;
                }
                _loc_7++;
            }
            param1.dispose();
            return _loc_4;
        }// end function

        protected function drawSkin() : void
        {
            return;
        }// end function

        protected function addEvent() : void
        {
            return;
        }// end function

        public function resize(param1:Number, param2:Number) : void
        {
            return;
        }// end function

        protected function setEleStatus() : void
        {
            return;
        }// end function

        public function get arrayBigBlocks() : Array
        {
            return this._arrayBigBlocks;
        }// end function

        public function get arraySmallBlocks() : Array
        {
            return this._arraySmallBlocks;
        }// end function

        public function get totalBlocks() : Number
        {
            return this._totalBlocks;
        }// end function

        public function get timeLimit() : Number
        {
            return this._timeLimit;
        }// end function

        public function get bWidth() : Number
        {
            return this._bigImgWidth;
        }// end function

        public function get bHeight() : Number
        {
            return this._bigImgHeight;
        }// end function

        public function get bigPicBytes() : ByteArray
        {
            return this._bigPicBytes;
        }// end function

    }
}
