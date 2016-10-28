package com.qiyi.player.core.model.impls.pub
{
    import com.qiyi.player.core.*;
    import flash.net.*;
    import flash.utils.*;

    public class Statistics extends Object
    {
        private var _playDuration:int = 0;
        private var _lastModifyDate:Date = null;
        private var _playCount:int = 0;
        private var _dayVV:int = 0;
        private var _currentVV:int = 0;
        private var _updateTimeout:int = 0;
        private static var _instance:Statistics = null;

        public function Statistics(param1:SingletonClass)
        {
            var so:SharedObject;
            var date:Date;
            var obj:Object;
            var cls:* = param1;
            try
            {
                so = SharedObject.getLocal(Config.STATISTICS_COOKIE, "/");
                date = new Date();
                obj = so.data.play;
                if (obj)
                {
                    this._lastModifyDate = new Date(Number(obj.playTime.date));
                    this._playDuration = obj.playTime.duration;
                    this._playCount = obj.playCount;
                    this._dayVV = obj.dayVV;
                    if (date.date != this._lastModifyDate.date || date.month != this._lastModifyDate.month || date.fullYear != this._lastModifyDate.fullYear)
                    {
                        this._lastModifyDate = date;
                        this._playDuration = 0;
                        this._playCount = 0;
                        this._dayVV = 0;
                    }
                    (this._playCount + 1);
                }
                else
                {
                    this._lastModifyDate = date;
                }
            }
            catch (e:Error)
            {
                _lastModifyDate = date;
            }
            return;
        }// end function

        public function get playDuration() : int
        {
            return this._playDuration;
        }// end function

        public function get playCount() : int
        {
            return this._playCount;
        }// end function

        public function get currentVV() : int
        {
            return this._currentVV;
        }// end function

        public function get dayVV() : int
        {
            return this._dayVV;
        }// end function

        public function addVV() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this._currentVV + 1;
            _loc_1._currentVV = _loc_2;
            var _loc_1:String = this;
            var _loc_2:* = this._dayVV + 1;
            _loc_1._dayVV = _loc_2;
            this.update();
            return;
        }// end function

        public function addDuration(param1:int) : void
        {
            var _loc_2:* = new Date();
            if (_loc_2.date != this._lastModifyDate.date && _loc_2.month == this._lastModifyDate.month && _loc_2.fullYear == _loc_2.fullYear)
            {
                this._playDuration = param1;
                this._lastModifyDate = _loc_2;
            }
            else
            {
                this._playDuration = this._playDuration + param1;
            }
            if (this._updateTimeout == 0)
            {
                this._updateTimeout = setTimeout(this.update, 20000);
            }
            return;
        }// end function

        public function clearDuration() : void
        {
            this._updateTimeout = 0;
            this._playDuration = 0;
            this._lastModifyDate = new Date();
            this.update();
            return;
        }// end function

        private function update() : void
        {
            var _loc_1:SharedObject = null;
            var _loc_2:Object = null;
            clearTimeout(this._updateTimeout);
            this._updateTimeout = 0;
            try
            {
                _loc_1 = SharedObject.getLocal(Config.STATISTICS_COOKIE, "/");
                if (_loc_1.data.common == null)
                {
                    _loc_1.data.common = {};
                }
                _loc_2 = _loc_1.data.play;
                if (!_loc_2)
                {
                    _loc_2 = {playTime:{}};
                    _loc_1.data.play = _loc_2;
                }
                _loc_2.playTime.date = new Date().time;
                _loc_2.playTime.duration = this._playDuration;
                _loc_2.playCount = this._playCount;
                _loc_2.dayVV = this._dayVV;
                _loc_1.flush();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public static function loadFromCookie() : void
        {
            _instance = new Statistics(new SingletonClass());
            return;
        }// end function

        public static function get instance() : Statistics
        {
            return _instance;
        }// end function

    }
}

class SingletonClass extends Object
{

    function SingletonClass()
    {
        return;
    }// end function

}

