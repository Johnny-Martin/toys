package com.qiyi.player.wonder.plugins.controllbar.model.filterdata
{
    import com.qiyi.player.wonder.common.loader.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class FilterBitmapData extends Object
    {
        private var _analysisData:Object;
        private var _interval:uint = 8;
        private var _bmdSize:Point;
        private var _mergeCount:Point;
        private var _bmdUrl:String = "";
        private var _imgDic:Dictionary;
        private var _alreadyLoaderList:Dictionary;
        private var _totalTime:int = 0;
        private var _loaderNum:uint = 0;
        private var _notifiLoadIndex:int = 0;
        private var _showBmdIndex:int = 0;
        private var _isLoading:Boolean = false;

        public function FilterBitmapData()
        {
            this._bmdSize = new Point(16, 9);
            this._mergeCount = new Point(3, 5);
            this._imgDic = new Dictionary();
            this._alreadyLoaderList = new Dictionary();
            return;
        }// end function

        public function get showBmdIndex() : int
        {
            return this._showBmdIndex;
        }// end function

        public function set showBmdIndex(param1:int) : void
        {
            this._showBmdIndex = param1;
            return;
        }// end function

        public function get bmdUrl() : String
        {
            return this._bmdUrl;
        }// end function

        public function get mergeCount() : Point
        {
            return this._mergeCount;
        }// end function

        public function get interval() : uint
        {
            return this._interval;
        }// end function

        public function setFilterAnalysisData(param1:Object) : void
        {
            var _loc_2:Array = null;
            var _loc_3:Array = null;
            this._analysisData = param1;
            this._interval = this._analysisData && this._analysisData.interval ? (uint(this._analysisData.interval)) : (8);
            this._bmdUrl = this._analysisData && this._analysisData.url ? (this._analysisData.url) : ("");
            if (this._analysisData && this._analysisData.imageSize)
            {
                _loc_2 = this._analysisData.imageSize.split("-");
                if (_loc_2.length > 1)
                {
                    this._bmdSize.x = _loc_2[0];
                    this._bmdSize.y = _loc_2[1];
                }
            }
            if (this._analysisData && this._analysisData.mergeCount)
            {
                _loc_3 = this._analysisData.mergeCount.split("-");
                if (_loc_3.length > 1)
                {
                    this._mergeCount.x = _loc_3[0];
                    this._mergeCount.y = _loc_3[1];
                }
            }
            return;
        }// end function

        public function loaderImage(param1:Boolean, param2:int = 0, param3:int = 0) : void
        {
            this._totalTime = param3;
            var _loc_4:* = Math.ceil(param2 / 1000 / (this._mergeCount.x * this._mergeCount.y * this._interval));
            if (_loc_4 == 0)
            {
                _loc_4 = 1;
            }
            if (this._isLoading)
            {
                this._isLoading = param1;
                this._notifiLoadIndex = _loc_4;
            }
            else
            {
                this._isLoading = param1;
                if (param1)
                {
                    this._loaderNum = _loc_4;
                    this.startLoader(_loc_4);
                }
            }
            return;
        }// end function

        private function startLoader(param1:int) : void
        {
            this._loaderNum = this.checkAlreadLoad(param1);
            if (this._loaderNum == 0)
            {
                this._isLoading = false;
                return;
            }
            var _loc_2:* = this._bmdUrl;
            _loc_2 = _loc_2.replace(".jpg", "_" + (this._bmdSize.x + "_" + this._bmdSize.y + "_" + this._loaderNum) + ".jpg");
            if (this._isLoading)
            {
                LoaderManager.instance.loader(_loc_2, this.requestImageComplete, this.onLoaderError, LoaderManager.TYPE_LOADER, 2);
            }
            return;
        }// end function

        private function requestImageComplete(param1) : void
        {
            var bitmap:Bitmap;
            var bitmapData:BitmapData;
            var rec:Rectangle;
            var i:int;
            var j:int;
            var $imageObj:* = param1;
            try
            {
                this._alreadyLoaderList[this._loaderNum] = this._loaderNum;
                bitmap = new Bitmap(($imageObj as Bitmap).bitmapData);
                i;
                while (i < this._mergeCount.y)
                {
                    
                    j;
                    while (j < this._mergeCount.x)
                    {
                        
                        rec = new Rectangle();
                        rec.x = j * this._bmdSize.x;
                        rec.y = i * this._bmdSize.y;
                        rec.width = this._bmdSize.x;
                        rec.height = this._bmdSize.y;
                        bitmapData = new BitmapData(this._bmdSize.x, this._bmdSize.y, true, 0);
                        bitmapData.copyPixels(bitmap.bitmapData, rec, new Point(0, 0));
                        this._imgDic[(this._loaderNum - 1) * this._mergeCount.x * this._mergeCount.y + i * this._mergeCount.x + j] = bitmapData;
                        j = (j + 1);
                    }
                    i = (i + 1);
                }
            }
            catch ($error:Error)
            {
            }
            if (this._notifiLoadIndex != 0)
            {
                this.startLoader(this._notifiLoadIndex);
                this._notifiLoadIndex = 0;
            }
            else
            {
                this.startLoader(this._loaderNum);
            }
            return;
        }// end function

        private function onLoaderError() : void
        {
            if (this._notifiLoadIndex != 0)
            {
                this.startLoader(this._notifiLoadIndex);
                this._notifiLoadIndex = 0;
            }
            else
            {
                this.startLoader(this._loaderNum);
            }
            return;
        }// end function

        public function getFilterbmd(param1:uint) : BitmapData
        {
            return this._imgDic[param1];
        }// end function

        private function checkAlreadLoad(param1:uint) : uint
        {
            var _loc_2:* = Math.ceil(this._totalTime / 1000 / this._interval / this._mergeCount.x / this._mergeCount.y);
            var _loc_3:* = param1;
            while (_loc_3 <= _loc_2)
            {
                
                if (this._alreadyLoaderList[_loc_3] == null)
                {
                    this._alreadyLoaderList[_loc_3] = _loc_3;
                    return _loc_3;
                }
                _loc_3 = _loc_3 + 1;
            }
            return 0;
        }// end function

        public function destroy() : void
        {
            var _loc_1:* = undefined;
            var _loc_2:* = undefined;
            for (_loc_1 in this._imgDic)
            {
                
                this._imgDic[_loc_1] = null;
                delete this._imgDic[_loc_1];
            }
            for (_loc_2 in this._alreadyLoaderList)
            {
                
                this._alreadyLoaderList[_loc_2] = null;
                delete this._alreadyLoaderList[_loc_2];
            }
            this._interval = 8;
            this._analysisData = null;
            this._bmdSize.x = 16;
            this._bmdSize.y = 9;
            this._mergeCount.x = 3;
            this._mergeCount.y = 5;
            this._bmdUrl = "";
            this._totalTime = 0;
            this._loaderNum = 0;
            this._notifiLoadIndex = 0;
            this._showBmdIndex = 0;
            this._isLoading = false;
            return;
        }// end function

    }
}
