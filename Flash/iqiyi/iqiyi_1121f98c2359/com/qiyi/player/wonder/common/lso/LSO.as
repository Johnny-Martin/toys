package com.qiyi.player.wonder.common.lso
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.config.*;
    import flash.net.*;
    import flash.utils.*;

    public class LSO extends Object
    {
        private var _commonSO:SharedObject;
        private var _clientFlashSO:SharedObject;
        private var _commonSOTimeout:uint = 0;
        private var _clientFlashInfoArr:Array;
        private var _totalBonus:uint = 0;
        private var _todayBonus:uint = 0;
        private var _bonusLastDate:Date;
        private var _maxTicketCount:int = 5;
        private var _sttDate:Date;
        private var _sttShowCountOneDay:int = 0;
        private var _sttMaxCount:int = 0;
        private var _log:ILogger;
        private static var _instance:LSO;

        public function LSO(param1:SingletonClass)
        {
            this._clientFlashInfoArr = [];
            this._bonusLastDate = new Date();
            this._sttDate = new Date();
            this._log = Log.getLogger("com.qiyi.player.wonder.common.lso.LSO");
            return;
        }// end function

        public function init() : void
        {
            try
            {
                this._commonSO = SharedObject.getLocal(SystemConfig.COMMON_COOKIE_NAME, "/");
                if (this._commonSO.size > 0)
                {
                    if (this._commonSO.data.bonus && this._commonSO.data.bonus.wonder_todayBonus != undefined)
                    {
                        this._todayBonus = this._commonSO.data.bonus.wonder_todayBonus;
                    }
                    if (this._commonSO.data.bonus && this._commonSO.data.bonus.wonder_totalBonus != undefined)
                    {
                        this._totalBonus = this._commonSO.data.bonus.wonder_totalBonus;
                    }
                    if (this._commonSO.data.bonus && this._commonSO.data.bonus.wonder_bonusLastDate != undefined)
                    {
                        this._bonusLastDate = new Date(Number(this._commonSO.data.bonus.wonder_bonusLastDate));
                    }
                    if (this._commonSO.data.stt && this._commonSO.data.stt.date != undefined)
                    {
                        this._sttDate = this._commonSO.data.stt.date;
                        if (this._sttDate == null)
                        {
                            this._sttDate = new Date();
                        }
                    }
                    if (this._commonSO.data.stt && this._commonSO.data.stt.sttShowCountOneDay != undefined)
                    {
                        this._sttShowCountOneDay = this._commonSO.data.stt.sttShowCountOneDay;
                    }
                    if (this._commonSO.data.stt && this._commonSO.data.stt.sttMaxCount != undefined)
                    {
                        this._sttMaxCount = this._commonSO.data.stt.sttMaxCount;
                    }
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function get maxTicketCount() : int
        {
            return this._maxTicketCount;
        }// end function

        public function get sttDate() : Date
        {
            return this._sttDate;
        }// end function

        public function set sttDate(param1:Date) : void
        {
            this._sttDate = param1;
            this.prepareUpdateCommon();
            return;
        }// end function

        public function get sttShowCountOneDay() : int
        {
            return this._sttShowCountOneDay;
        }// end function

        public function set sttShowCountOneDay(param1:int) : void
        {
            if (param1 != this._sttShowCountOneDay)
            {
                this._sttShowCountOneDay = param1;
                this.prepareUpdateCommon();
            }
            return;
        }// end function

        public function get sttMaxCount() : int
        {
            return this._sttMaxCount;
        }// end function

        public function set sttMaxCount(param1:int) : void
        {
            if (param1 != this.sttMaxCount)
            {
                this._sttMaxCount = param1;
                this.prepareUpdateCommon();
            }
            return;
        }// end function

        public function setClientFlashInfo(param1:Array) : void
        {
            if (param1)
            {
                this._clientFlashInfoArr = param1;
                this.updateClientFlash();
            }
            return;
        }// end function

        public function addBonus() : void
        {
            var _loc_1:Date = null;
            if (this._totalBonus == 0)
            {
                this._totalBonus = BodyDef.BONUS_DEFAULT_COUNT_ONCE;
                this._todayBonus = BodyDef.BONUS_DEFAULT_COUNT_ONCE;
                this._bonusLastDate = new Date();
            }
            else
            {
                _loc_1 = new Date();
                if (_loc_1.date != this._bonusLastDate.date || _loc_1.month != this._bonusLastDate.month || _loc_1.fullYear != this._bonusLastDate.fullYear)
                {
                    this._todayBonus = 0;
                }
                if (this._todayBonus < 50 && this._totalBonus < 100)
                {
                    this._todayBonus = this._todayBonus + BodyDef.BONUS_DEFAULT_COUNT_ONCE;
                    this._totalBonus = this._totalBonus + BodyDef.BONUS_DEFAULT_COUNT_ONCE;
                    this._bonusLastDate = _loc_1;
                }
            }
            this.prepareUpdateCommon();
            return;
        }// end function

        public function takeOutTotalBonus() : uint
        {
            try
            {
                this._commonSO = SharedObject.getLocal(SystemConfig.COMMON_COOKIE_NAME, "/");
                if (this._commonSO.size > 0)
                {
                    if (this._commonSO.data.bonus && this._commonSO.data.bonus.wonder_todayBonus != undefined)
                    {
                        this._todayBonus = this._commonSO.data.bonus.wonder_todayBonus;
                    }
                    if (this._commonSO.data.bonus && this._commonSO.data.bonus.wonder_totalBonus != undefined)
                    {
                        this._totalBonus = this._commonSO.data.bonus.wonder_totalBonus;
                    }
                }
            }
            catch (e:Error)
            {
            }
            var _loc_1:uint = 0;
            if (this._totalBonus != 0)
            {
                _loc_1 = this._totalBonus;
                this._totalBonus = 0;
                this._todayBonus = 0;
                this._bonusLastDate = new Date();
                this.updateCommon();
            }
            else
            {
                _loc_1 = 0;
            }
            return _loc_1;
        }// end function

        private function prepareUpdateCommon() : void
        {
            if (this._commonSOTimeout == 0)
            {
                this._commonSOTimeout = setTimeout(this.updateCommon, 200);
            }
            return;
        }// end function

        private function updateCommon() : void
        {
            var _loc_1:Object = null;
            var _loc_2:Object = null;
            clearTimeout(this._commonSOTimeout);
            this._commonSOTimeout = 0;
            try
            {
                if (this._commonSO == null)
                {
                    this._commonSO = SharedObject.getLocal(SystemConfig.COMMON_COOKIE_NAME, "/");
                }
                _loc_1 = {};
                _loc_1.wonder_todayBonus = this._todayBonus;
                _loc_1.wonder_totalBonus = this._totalBonus;
                _loc_1.wonder_bonusLastDate = this._bonusLastDate;
                this._commonSO.data.bonus = _loc_1;
                _loc_2 = {};
                _loc_2.date = this._sttDate;
                _loc_2.sttShowCountOneDay = this._sttShowCountOneDay;
                _loc_2.sttMaxCount = this._sttMaxCount;
                this._commonSO.data.stt = _loc_2;
                this._commonSO.flush();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function updateClientFlash() : void
        {
            var _loc_1:int = 0;
            var _loc_2:int = 0;
            var _loc_3:Object = null;
            try
            {
                if (this._clientFlashSO == null)
                {
                    this._clientFlashSO = SharedObject.getLocal(SystemConfig.CLIENT_FLASH_COOKIE_NAME, "/");
                }
                if (this._clientFlashSO.data.count == undefined)
                {
                    this._clientFlashSO.data.count = 0;
                }
                _loc_1 = this._clientFlashSO.data.count;
                _loc_2 = 0;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    delete this._clientFlashSO.data["curvideoinfo_" + _loc_2];
                    _loc_2++;
                }
                _loc_3 = null;
                _loc_1 = this._clientFlashInfoArr.length;
                _loc_2 = 0;
                while (_loc_2 < _loc_1)
                {
                    
                    _loc_3 = this._clientFlashInfoArr[_loc_2];
                    _loc_3.action = "down";
                    _loc_3.cursystime = String(new Date().time);
                    this._clientFlashSO.data["curvideoinfo_" + _loc_2] = JSON.encode(_loc_3);
                    _loc_2++;
                }
                this._clientFlashSO.data.count = _loc_1;
                this._clientFlashSO.flush();
                this._clientFlashInfoArr = [];
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public static function getInstance() : LSO
        {
            if (_instance == null)
            {
                _instance = new LSO(new SingletonClass());
            }
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

