package com.qiyi.player.wonder.plugins.tips.view.parts
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class TipManager extends EventDispatcher
    {
        private var _enableCookie:Boolean = true;
        private var _model:IPlayer;
        private var _log:ILogger;
        private var _dataXml:XML;
        private var _attribute:Object;
        private var _liveStat:Object;
        private var _external:Object;
        private var _tipStat:Object;
        private var listeners:Array;
        private var _tipBar:TipBar;
        public static const TipStatistics:String = "qiyi_tips_statistics";
        public static const TIP_SHOW_STATUS_OK:int = 0;
        public static const TIP_SHOW_STATUS_FAILED:int = 1;
        public static const TIP_SHOW_STATUS_CONFLICTED:int = 2;
        private static var _enable:Boolean = true;
        private static var _tipStatChanged:Boolean = false;
        private static var loader:URLLoader;
        private static var _playerDuration_subscribeTipShowTime_arr:Array = [];
        private static var conditions:Array = [];
        private static var _startTime:int = 0;
        private static var _endTime:int = 0;
        private static var _currTime:int = 0;
        private static var _totalTime:int = 0;
        private static var _playerDuration:int = 0;
        private static var _subscribeTipShowTime:uint = 0;
        private static var _instance:TipManager;
        private static var _adTipsTimer:Timer;
        private static var _so:Object;
        private static var _valueBiggerThan15Minutes:int = 1000;
        private static var _expiredDateStr:String;
        private static var _enableDebugKey:Boolean = true;

        public function TipManager() : void
        {
            var so:SharedObject;
            var date:Date;
            var stat:Object;
            var _lastModifyDate:Date;
            this._log = Log.getLogger("com.qiyi.components.tips.TipManager");
            this._attribute = new Object();
            this._liveStat = new Object();
            this._external = new Object();
            this.listeners = new Array();
            try
            {
                so = SharedObject.getLocal(TipStatistics, "/");
                date = new Date();
                if (so && so.data.tipStat)
                {
                    stat = so.data.tipStat;
                    _lastModifyDate = new Date(Number(stat.date));
                    if (date.date != _lastModifyDate.date || date.month != _lastModifyDate.month || date.fullYear != _lastModifyDate.fullYear)
                    {
                        stat.date = date;
                        stat.list = new Array();
                        stat.conflict = new Object();
                        so.data.tipStat = stat;
                        so.flush();
                    }
                }
                else
                {
                    stat = new Object();
                    stat.date = date;
                    stat.list = new Array();
                    stat.conflict = new Object();
                    so.data.tipStat = stat;
                    so.flush();
                }
                _tipStatChanged = true;
                this._log.debug("TipManager: new instance");
            }
            catch (e:Error)
            {
                _log.debug("TipManager: init get stat cookie error,unable cookie");
                _enableCookie = false;
                sendErrorEvent(e);
            }
            return;
        }// end function

        public static function get instance() : TipManager
        {
            if (_instance == null)
            {
                _instance = new TipManager;
            }
            return TipManager.TipManager(_instance);
        }// end function

        public static function showTip(param1:String) : int
        {
            var data:XML;
            var itemXml:XML;
            var id:* = param1;
            if (_enable == false)
            {
                return TIP_SHOW_STATUS_FAILED;
            }
            if (playerModel == null)
            {
                return TIP_SHOW_STATUS_FAILED;
            }
            var tipItem:* = getItem(id);
            if (tipItem)
            {
                if (tipItem.type == "1")
                {
                    data = instance._dataXml;
                    var _loc_4:int = 0;
                    var _loc_5:* = data..item;
                    var _loc_3:* = new XMLList("");
                    for each (_loc_6 in _loc_5)
                    {
                        
                        var _loc_7:* = _loc_6;
                        with (_loc_6)
                        {
                            if (@id == id)
                            {
                                _loc_3[_loc_4] = _loc_6;
                            }
                        }
                    }
                    itemXml = _loc_3[0];
                    if (itemXml.conditions[0])
                    {
                        if (checkFrequency(id, itemXml.conditions[0]) == false)
                        {
                            return TIP_SHOW_STATUS_FAILED;
                        }
                        if (checkField(id, itemXml.conditions[0]) == false)
                        {
                            instance._log.debug("Tipmanager: fields don\'t meet");
                            return TIP_SHOW_STATUS_FAILED;
                        }
                    }
                }
                return tipBar.showTip(id);
            }
            return TIP_SHOW_STATUS_FAILED;
        }// end function

        public static function showInstantTip(param1:String, param2:String) : void
        {
            if (_enable == false)
            {
                return;
            }
            if (playerModel == null)
            {
                return;
            }
            if (param1 != "")
            {
                tipBar.showInstantTip(param1, param2);
            }
            return;
        }// end function

        public static function hideTip(param1:String = "") : void
        {
            if (tipBar == null)
            {
                return;
            }
            if (param1 == "" || param1 == tipBar.currentTipId && param1 != "")
            {
                tipBar.hideTip();
            }
            return;
        }// end function

        public static function isShow(param1:String) : Boolean
        {
            if (tipBar)
            {
                return param1 == tipBar.currentTipId;
            }
            return false;
        }// end function

        public static function initialize(param1:TipBar) : void
        {
            instance._tipBar = param1;
            instance._log.debug("TipManager: initialize");
            instance._external.curADState = false;
            return;
        }// end function

        public static function setDataClass(param1:Class) : void
        {
            var _loc_2:* = new param1;
            var _loc_3:* = XML(_loc_2.readUTFBytes(_loc_2.bytesAvailable));
            setData(_loc_3);
            return;
        }// end function

        public static function setPlayerModel(param1:IPlayer) : void
        {
            if (instance._model != param1)
            {
                instance._model = param1;
            }
            return;
        }// end function

        public static function setStartTime(param1:int) : void
        {
            _startTime = param1;
            return;
        }// end function

        public static function setEndTime(param1:int) : void
        {
            _endTime = param1;
            return;
        }// end function

        public static function setCurrTime(param1:int, param2:int = 0) : void
        {
            if (_currTime != param1)
            {
                _currTime = param1;
                _playerDuration = param2;
                checkCondition();
            }
            return;
        }// end function

        private static function checkAdTips() : void
        {
            checkCondition();
            return;
        }// end function

        public static function setTotalTime(param1:int) : void
        {
            _totalTime = param1;
            return;
        }// end function

        public static function setIsLogin(param1:Boolean) : void
        {
            instance._external.login = param1;
            instance._log.info("Tipmanager: set login " + String(param1));
            return;
        }// end function

        public static function setCanSubscribe(param1:Boolean) : void
        {
            instance._external.cansubcribe = param1;
            instance._log.info("Tipmanager: set cansubcribe " + String(param1));
            return;
        }// end function

        public static function setSubscribed(param1:Boolean) : void
        {
            instance._external.issubcribe = param1;
            instance._log.info("Tipmanager: set subdcribed " + String(param1));
            return;
        }// end function

        public static function setIsBD(param1:uint) : void
        {
            instance._external.bd = param1;
            instance._log.info("Tipmanager: set bd " + String(param1));
            return;
        }// end function

        public static function setPassportId(param1:String) : void
        {
            instance._external.passportid = param1;
            instance._log.info("Tipmanager: set passportId " + String(param1));
            return;
        }// end function

        public static function setADState(param1:Boolean) : void
        {
            instance._external.curADState = param1;
            if (param1)
            {
                if (_adTipsTimer == null)
                {
                    _adTipsTimer = new Timer(1000);
                    _adTipsTimer.addEventListener(TimerEvent.TIMER, onAdTipsTimer);
                    _adTipsTimer.start();
                }
            }
            else if (_adTipsTimer)
            {
                _adTipsTimer.stop();
                _adTipsTimer.removeEventListener(TimerEvent.TIMER, onAdTipsTimer);
                _adTipsTimer = null;
            }
            instance._log.info("Tipmanager: set isADState " + String(param1));
            return;
        }// end function

        private static function onAdTipsTimer(event:TimerEvent) : void
        {
            checkAdTips();
            return;
        }// end function

        public static function set enable(param1:Boolean) : void
        {
            _enable = param1;
            return;
        }// end function

        public static function setData(param1:XML) : void
        {
            var _loc_3:XMLList = null;
            var _loc_4:int = 0;
            var _loc_5:XML = null;
            _instance._dataXml = param1;
            var _loc_2:* = getConditions();
            if (_loc_2.length != 0)
            {
                conditions = _loc_2;
                return;
            }
            conditions = new Array();
            try
            {
                param1 = instance._dataXml;
                if (param1)
                {
                    _loc_3 = param1..conditions;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3.length())
                    {
                        
                        _loc_5 = XML(_loc_3[_loc_4]).parent();
                        if (_loc_5.@type == "2")
                        {
                            conditions.push(_loc_5);
                        }
                        _loc_4++;
                    }
                    saveConditions();
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private static function getConditions() : Array
        {
            var so:SharedObject;
            var result:Array;
            try
            {
                so = SharedObject.getLocal(TipStatistics, "/");
                if (so.size != 0)
                {
                    if (so.data.conditions)
                    {
                        result = so.data.conditions;
                    }
                    else
                    {
                        result;
                    }
                }
                _so = so;
            }
            catch (e:Error)
            {
            }
            finally
            {
                var _loc_4:* = result;
                ;
                
                
                return _loc_4;
            }
        }// end function

        private static function saveConditions() : void
        {
            if (conditions == null)
            {
                return;
            }
            try
            {
                if (_so == null)
                {
                    _so = SharedObject.getLocal(TipStatistics, "/");
                }
                _so.data.conditions = conditions;
                _so.flush();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public static function setDataUrl(param1:String) : void
        {
            if (loader)
            {
                removeLoaderListener();
                loader = null;
            }
            var _loc_2:* = new URLRequest(param1 + "?n=" + Math.random());
            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            loader.load(_loc_2);
            return;
        }// end function

        public static function setIsMember(param1:Boolean) : void
        {
            instance._external["member"] = param1;
            instance._log.info("Tipmanager: set member " + String(param1));
            return;
        }// end function

        public static function getItem(param1:String) : Object
        {
            var result:Object;
            var arr:Array;
            var data:XML;
            var len:int;
            var list:XMLList;
            var item:XML;
            var msgs:XMLList;
            var i:int;
            var msg:XML;
            var index:int;
            var id:* = param1;
            try
            {
                arr = new Array();
                data = instance._dataXml;
                if (data)
                {
                    var _loc_4:int = 0;
                    var _loc_5:* = data.item;
                    var _loc_3:* = new XMLList("");
                    for each (_loc_6 in _loc_5)
                    {
                        
                        var _loc_7:* = _loc_6;
                        with (_loc_6)
                        {
                            if (@id == id)
                            {
                                _loc_3[_loc_4] = _loc_6;
                            }
                        }
                    }
                    list = _loc_3;
                    if (list && list.length() > 0)
                    {
                        item = list[0];
                        result = new Object();
                        result.id = item.@id;
                        result.level = item.@level;
                        result.duration = item.@duration;
                        result.type = item.@type;
                        if (item.@force != undefined)
                        {
                            result.force = item.@force;
                        }
                        msgs = item..message;
                        i;
                        while (i < msgs.length())
                        {
                            
                            msg = msgs[i];
                            arr.push(trim(String(msg)));
                            i = (i + 1);
                        }
                    }
                }
                len = arr.length;
                if (len > 0)
                {
                    index = (Math.round(Math.random() * (len - 1)) + 1);
                    result.message = String(arr[(index - 1)]);
                }
            }
            catch (e)
            {
                instance._log.debug("TipManager: get item data error");
                sendErrorEvent(e);
            }
            return result;
        }// end function

        private static function getItems() : Array
        {
            var data:XML;
            var list:XMLList;
            var i:int;
            var arr:* = new Array();
            try
            {
                data = instance._dataXml;
                if (data)
                {
                    list = data..item;
                    i;
                    while (i < list.length())
                    {
                        
                        arr.push(list[i].@id);
                        i = (i + 1);
                    }
                }
            }
            catch (e:Error)
            {
                instance._log.debug("TipManager: get items  error");
            }
            return arr;
        }// end function

        public static function getAttribute() : Object
        {
            return instance._attribute;
        }// end function

        public static function addCountAlbum(param1:String, param2:String) : void
        {
            var _loc_3:SharedObject = null;
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:int = 0;
            try
            {
                _loc_3 = SharedObject.getLocal(TipStatistics, "/");
                _loc_4 = _loc_3.data.tipStat.users;
                _loc_4 = _loc_4 == null ? (new Object()) : (_loc_4);
                _loc_4[param1] = _loc_4[param1] == null ? (new Object()) : (_loc_4[param1]);
                _loc_5 = _loc_4[param1].albums;
                _loc_5 = _loc_5 == null ? (new Object()) : (_loc_5);
                _loc_6 = 0;
                _loc_6 = _loc_5[param2] == null ? (0) : (_loc_5[param2]);
                _loc_6 = _loc_6 + 1;
                _loc_5[param2] = _loc_6;
                _loc_3.data.tipStat.users = _loc_4;
                _loc_3.flush();
                _tipStatChanged = true;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public static function addCount(param1:String) : void
        {
            var _loc_3:Array = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:SharedObject = null;
            var _loc_2:* = tipStat;
            if (_loc_2 && _loc_2.list)
            {
                _loc_3 = _loc_2.list as Array;
                _loc_3 = _loc_3 == null ? (new Array()) : (_loc_3);
                _loc_4 = Statistics.instance.dayVV;
                _loc_5 = Statistics.instance.playCount;
                _loc_6 = instance._external.passportid;
                _loc_6 = _loc_6 == null ? ("") : (_loc_6);
                _loc_7 = "";
                if (playerModel && playerModel.movieModel && playerModel.movieModel.albumId)
                {
                    _loc_7 = playerModel.movieModel.albumId;
                }
                _loc_3.push([param1, _loc_4, _loc_5, _loc_6, _loc_7]);
                try
                {
                    _loc_8 = SharedObject.getLocal(TipStatistics, "/");
                    _loc_8.data.tipStat = _loc_2;
                    _loc_8.flush();
                    _tipStatChanged = true;
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        public static function getShowGroupCount(param1:String, param2:Array) : int
        {
            var isMeet:Boolean;
            var item:Array;
            var dayFlag:Boolean;
            var vvFlag:Boolean;
            var liveFlag:Boolean;
            var userFlag:Boolean;
            var albumFlag:Boolean;
            var id:* = param1;
            var groups:* = param2;
            var hasRestrain:* = function (param1:String) : Boolean
            {
                var _loc_2:int = 0;
                if (groups)
                {
                    _loc_2 = 0;
                    while (_loc_2 < groups.length)
                    {
                        
                        if (groups[_loc_2] == param1)
                        {
                            return true;
                        }
                        _loc_2++;
                    }
                }
                return false;
            }// end function
            ;
            if (groups == null)
            {
                return 0;
            }
            var stat:* = tipStat;
            if (stat == null)
            {
                return -1;
            }
            if (stat.list == null)
            {
                return 0;
            }
            var list:* = stat.list as Array;
            var vvNum:* = Statistics.instance.dayVV;
            var liveNum:* = Statistics.instance.playCount;
            var userId:* = instance._external.passportid;
            userId = userId == null ? ("") : (userId);
            var albumId:String;
            if (playerModel && playerModel.movieModel && playerModel.movieModel.albumId)
            {
                albumId = playerModel.movieModel.albumId;
            }
            var count:int;
            var i:int;
            while (i < list.length)
            {
                
                isMeet;
                item = list[i];
                if (item[0] == id)
                {
                    dayFlag;
                    vvFlag;
                    if (TipManager.hasRestrain("vv"))
                    {
                        if (vvNum != item[1])
                        {
                            vvFlag;
                        }
                    }
                    liveFlag;
                    if (TipManager.hasRestrain("live") && liveNum != item[2])
                    {
                        liveFlag;
                    }
                    userFlag;
                    if (TipManager.hasRestrain("user") && userId != item[3])
                    {
                        userFlag;
                    }
                    albumFlag;
                    if (TipManager.hasRestrain("album") && albumId != item[4])
                    {
                        albumFlag;
                    }
                    if (dayFlag && vvFlag && liveFlag && userFlag && albumFlag)
                    {
                        count = (count + 1);
                    }
                }
                i = (i + 1);
            }
            return count;
        }// end function

        static function addShowCount(param1:String) : void
        {
            addCount(param1);
            return;
        }// end function

        static function checkNextConflict() : void
        {
            checkCondition();
            return;
        }// end function

        public static function addConflict(param1:String) : void
        {
            var conflict:Object;
            var vvNum:int;
            var so:SharedObject;
            var $id:* = param1;
            var stat:* = tipStat;
            if (stat && stat.conflict)
            {
                conflict = stat.conflict;
                conflict = conflict == null ? (new Object()) : (conflict);
                vvNum = Statistics.instance.dayVV;
                conflict[$id] = vvNum;
                try
                {
                    so = SharedObject.getLocal(TipStatistics, "/");
                    so.data.tipStat = stat;
                    so.flush();
                    _tipStatChanged = true;
                }
                catch (e:Error)
                {
                    instance._log.debug("TipManager: addConflict cookie error, unable cookie.");
                    instance._enableCookie = false;
                }
            }
            return;
        }// end function

        public static function clearConflict(param1:String) : void
        {
            var conflict:Object;
            var so:SharedObject;
            var id:* = param1;
            var stat:* = tipStat;
            if (stat && stat.conflict)
            {
                conflict = stat.conflict;
                conflict = conflict == null ? (new Object()) : (conflict);
                if (conflict[id])
                {
                    conflict[id] = -1;
                    try
                    {
                        so = SharedObject.getLocal(TipStatistics, "/");
                        so.data.tipStat = stat;
                        so.flush();
                        _tipStatChanged = true;
                    }
                    catch (e:Error)
                    {
                        instance._log.debug("TipManager: clearConflict cookie error,unable cookie.");
                        instance._enableCookie = false;
                    }
                }
            }
            return;
        }// end function

        public static function getConflictVV(param1:String) : int
        {
            var _loc_2:* = tipStat;
            if (_loc_2 && _loc_2.conflict && _loc_2.conflict[param1] != undefined)
            {
                return _loc_2.conflict[param1];
            }
            return -1;
        }// end function

        private static function checkCondition() : void
        {
            var _loc_3:XML = null;
            var _loc_4:XML = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            var _loc_7:Object = null;
            if (instance._enableCookie == false)
            {
                return;
            }
            if (playerModel == null)
            {
                return;
            }
            var _loc_1:* = new Array();
            if (conditions == null)
            {
                return;
            }
            var _loc_2:int = 0;
            while (_loc_2 < conditions.length)
            {
                
                _loc_3 = conditions[_loc_2];
                if (_loc_3.@type != "2")
                {
                }
                else
                {
                    _loc_4 = _loc_3.conditions[0];
                    if (checkField(_loc_3.@id, _loc_4) == false)
                    {
                    }
                    else if (getConflictVV(_loc_3.@id) == Statistics.instance.dayVV)
                    {
                    }
                    else if (checkFrequency(_loc_3.@id, _loc_4) == false)
                    {
                    }
                    else
                    {
                        _loc_5 = new Object();
                        _loc_5.id = _loc_3.@id;
                        _loc_5.level = Number(_loc_3.@level);
                        _loc_1.push(_loc_5);
                    }
                }
                _loc_2++;
            }
            if (_loc_1.length > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < _loc_1.length)
                {
                    
                    _loc_7 = _loc_1[_loc_2];
                    if (_loc_6 == null)
                    {
                        _loc_6 = _loc_7;
                    }
                    else if (_loc_7.level > _loc_6.level)
                    {
                        _loc_6 = _loc_7;
                    }
                    _loc_2++;
                }
            }
            if (_loc_6)
            {
                showTip(_loc_6.id);
            }
            return;
        }// end function

        private static function checkField(param1:String, param2:XML) : Boolean
        {
            var _loc_5:XMLList = null;
            var _loc_6:int = 0;
            var _loc_7:XML = null;
            var _loc_8:String = null;
            var _loc_9:Object = null;
            var _loc_10:String = null;
            var _loc_11:String = null;
            var _loc_12:String = null;
            var _loc_13:Array = null;
            var _loc_14:String = null;
            var _loc_15:String = null;
            var _loc_16:Array = null;
            var _loc_3:Boolean = false;
            var _loc_4:* = param2.fields[0];
            if (_loc_4)
            {
                _loc_5 = _loc_4..field;
                _loc_6 = 0;
                while (_loc_6 < _loc_5.length())
                {
                    
                    _loc_3 = false;
                    _loc_7 = _loc_5[_loc_6];
                    _loc_8 = _loc_7.@operator;
                    _loc_9 = getFieldValue(_loc_7.@name, param1, param2);
                    if (_loc_8 && _loc_8 != "")
                    {
                        _loc_10 = _loc_7.@value ? (_loc_7.@value) : ("");
                        switch(_loc_8)
                        {
                            case "eq":
                            {
                                if (String(_loc_9) == _loc_10)
                                {
                                    _loc_3 = true;
                                }
                                break;
                            }
                            case "neq":
                            {
                                if (_loc_9 && String(_loc_9) != _loc_10)
                                {
                                    _loc_3 = true;
                                }
                                break;
                            }
                            case "is":
                            {
                                if (_loc_9)
                                {
                                    if (_loc_9 is Array && _loc_9.length > 0)
                                    {
                                        _loc_3 = true;
                                    }
                                    else if (String(_loc_9).length > 0)
                                    {
                                        _loc_3 = true;
                                    }
                                    else
                                    {
                                        _loc_3 = false;
                                    }
                                }
                                break;
                            }
                            case "not":
                            {
                                if (_loc_9 == null)
                                {
                                    _loc_3 = true;
                                }
                                else if (_loc_9 is Array && _loc_9.length == 0)
                                {
                                    _loc_3 = true;
                                }
                                else if (String(_loc_9) == "")
                                {
                                    _loc_3 = true;
                                }
                                break;
                            }
                            case "gt":
                            {
                                if (!isNaN(Number(_loc_9)) && !isNaN(Number(_loc_10)) && Number(_loc_9) > Number(_loc_10))
                                {
                                    _loc_3 = true;
                                }
                                break;
                            }
                            case "lt":
                            {
                                if (!isNaN(Number(_loc_9)) && !isNaN(Number(_loc_10)) && Number(_loc_9) < Number(_loc_10))
                                {
                                    _loc_3 = true;
                                }
                                break;
                            }
                            case "arr":
                            {
                                if (_loc_9 is Array)
                                {
                                    if (_loc_9.length > 1)
                                    {
                                        _loc_3 = true;
                                    }
                                }
                                break;
                            }
                            case "in":
                            {
                                _loc_11 = "," + _loc_10 + ",";
                                _loc_12 = "," + String(_loc_9) + ",";
                                _loc_13 = _loc_11.match(_loc_12);
                                if (_loc_13)
                                {
                                    _loc_3 = true;
                                }
                                break;
                            }
                            case "ex":
                            {
                                _loc_14 = "," + String(_loc_10) + ",";
                                _loc_15 = "," + String(_loc_9) + ",";
                                _loc_16 = _loc_14.match(_loc_15);
                                if (_loc_16 == null)
                                {
                                    _loc_3 = true;
                                }
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    if (_loc_3 == false)
                    {
                        break;
                    }
                    _loc_6++;
                }
            }
            else
            {
                _loc_3 = true;
            }
            return _loc_3;
        }// end function

        private static function checkFrequency(param1:String, param2:XML) : Boolean
        {
            var _loc_4:int = 0;
            var _loc_5:XMLList = null;
            var _loc_6:Array = null;
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:String = null;
            if (instance._enableCookie == false)
            {
                return false;
            }
            var _loc_3:* = param2.frequency[0];
            if (_loc_3)
            {
                _loc_4 = _loc_3.@count;
                _loc_5 = _loc_3..restrain;
                _loc_6 = new Array();
                _loc_7 = 0;
                while (_loc_7 < _loc_5.length())
                {
                    
                    _loc_9 = _loc_5[_loc_7].@name;
                    _loc_6.push(_loc_9);
                    _loc_7++;
                }
                _loc_8 = getShowGroupCount(param1, _loc_6);
                if (_loc_8 < _loc_4)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private static function getFieldValue(param1:String, param2:String = "", param3:XML = null) : Object
        {
            var _loc_4:Object = null;
            var _loc_5:Object = null;
            var _loc_6:Object = null;
            if (playerModel && playerModel.movieModel)
            {
                _loc_4 = playerModel.movieModel.source;
                if (_loc_4 && _loc_4[param1])
                {
                    return _loc_4[param1];
                }
            }
            if (playerModel && playerModel.movieInfo)
            {
                _loc_5 = playerModel.movieInfo.infoJSON;
                if (_loc_5 && _loc_5[param1])
                {
                    return _loc_5[param1];
                }
            }
            if (instance._external)
            {
                _loc_6 = instance._external;
                if (_loc_6[param1] != null)
                {
                    return _loc_6[param1];
                }
            }
            if (Statistics.instance)
            {
                if (param1 == "vv")
                {
                    return Statistics.instance.dayVV;
                }
                if (param1 == "live")
                {
                    return Statistics.instance.currentVV;
                }
                if (param1 == "playtime")
                {
                    return int(Statistics.instance.playDuration / 1000);
                }
                if (param1 == "playcount")
                {
                    return Statistics.instance.playCount;
                }
            }
            if (param1 == "start")
            {
                return _currTime;
            }
            if (param1 == "end")
            {
                return _totalTime - _currTime;
            }
            if (param1 == "startplay")
            {
                return playerModel ? (_currTime - _startTime) : (0);
            }
            if (param1 == "endplay")
            {
                return _endTime - _currTime;
            }
            if (param1 == "curPlayDuration")
            {
                return Math.floor(playerModel.playingDuration / 1000);
            }
            if (param1 == "interval")
            {
                return judgeMeetIntervalReq(param2, "interval", param3);
            }
            if (param1 == "expiredTimeInterval")
            {
                return getRealExpiredTime();
            }
            return null;
        }// end function

        public static function updatePlayTime(param1:int, param2:int) : void
        {
            if (_currTime != param1 || _totalTime != param2)
            {
                _currTime = param1;
                _totalTime = param2;
                checkCondition();
            }
            return;
        }// end function

        public static function updateAttribute(param1:String, param2:String) : void
        {
            instance._attribute[param1] = param2;
            return;
        }// end function

        public static function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            if (param1 == TipEvent.All)
            {
                instance.listeners = new Array();
                TipManager.addEventListener(TipEvent.ASEvent, param2, param3, param4, param5);
                TipManager.addEventListener(TipEvent.JSEvent, param2, param3, param4, param5);
                TipManager.addEventListener(TipEvent.Show, param2, param3, param4, param5);
                TipManager.addEventListener(TipEvent.Hide, param2, param3, param4, param5);
                TipManager.addEventListener(TipEvent.Close, param2, param3, param4, param5);
                TipManager.addEventListener(TipEvent.Error, param2, param3, param4, param5);
                TipManager.addEventListener(TipEvent.LinkEvent, param2, param3, param4, param5);
            }
            else
            {
                TipManager.addLog("TipManager: addEventListener " + param1);
                removeEventListener(param1, param2, param3);
                instance.listeners.push([param1, param2, param3]);
                instance.addEventListener(param1, param2, param3, param4, param5);
            }
            return;
        }// end function

        public static function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            var _loc_4:int = 0;
            if (param1 == TipEvent.All)
            {
                removeAllEventListener();
            }
            else
            {
                _loc_4 = 0;
                while (_loc_4 < instance.listeners.length)
                {
                    
                    if (param1 == instance.listeners[_loc_4][0])
                    {
                        instance.listeners.splice(_loc_4, 1);
                        instance.removeEventListener(param1, param2, param3);
                    }
                    _loc_4++;
                }
            }
            return;
        }// end function

        public static function removeAllEventListener() : void
        {
            var _loc_1:* = instance.listeners;
            var _loc_2:int = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                removeEventListener(_loc_1[0], _loc_1[1], _loc_1[2]);
                _loc_2++;
            }
            _loc_1 = new Array();
            return;
        }// end function

        private static function judgeMeetIntervalReq(param1:String = "", param2:String = "", param3:XML = null) : int
        {
            var so:SharedObject;
            var $tipId:* = param1;
            var $fieldName:* = param2;
            var $xmlCondition:* = param3;
            var returnValue:int;
            try
            {
                so = SharedObject.getLocal(TipStatistics, "/");
                if (so.data.tipStat)
                {
                    if (!so.data.tipStat.hasOwnProperty("subscribeTipShowTime"))
                    {
                        so.data.tipStat.subscribeTipShowTime = 0;
                    }
                    _subscribeTipShowTime = so.data.tipStat.subscribeTipShowTime;
                    if (!so.data.tipStat.hasOwnProperty("playerDuration_subscribeTipShowTime_arr"))
                    {
                        so.data.tipStat.playerDuration_subscribeTipShowTime_arr = [];
                    }
                    _playerDuration_subscribeTipShowTime_arr = so.data.tipStat.playerDuration_subscribeTipShowTime_arr;
                }
            }
            catch ($err:Error)
            {
            }
            if (_subscribeTipShowTime == 0)
            {
                _playerDuration_subscribeTipShowTime_arr.push({time:1, playingDuration:_playerDuration});
                returnValue = _valueBiggerThan15Minutes;
            }
            else if (_playerDuration_subscribeTipShowTime_arr.length >= _subscribeTipShowTime)
            {
                if (_playerDuration - _playerDuration_subscribeTipShowTime_arr[(_subscribeTipShowTime - 1)]["playingDuration"] > 900)
                {
                    _playerDuration_subscribeTipShowTime_arr.push({time:(_subscribeTipShowTime + 1), playingDuration:_playerDuration});
                }
                returnValue = _playerDuration - _playerDuration_subscribeTipShowTime_arr[(_subscribeTipShowTime - 1)]["playingDuration"];
            }
            savePlayerDuration_subscribeTipShowTime_arr();
            return returnValue;
        }// end function

        static function addProSubUpdateTipCount(param1:String) : void
        {
            if (param1 == "ProSubUpdate")
            {
                addSubscribeTipShowTime();
            }
            return;
        }// end function

        private static function savePlayerDuration_subscribeTipShowTime_arr() : void
        {
            var so:SharedObject;
            try
            {
                so = SharedObject.getLocal(TipStatistics, "/");
                if (so.data.tipStat && !so.data.tipStat.playerDuration_subscribeTipShowTime_arr)
                {
                    so.data.tipStat.playerDuration_subscribeTipShowTime_arr = [];
                }
                else
                {
                    so.data.tipStat.playerDuration_subscribeTipShowTime_arr = _playerDuration_subscribeTipShowTime_arr;
                }
                so.flush();
                instance._log.debug("just saved subscribeTipShowTime to local lso ：" + so.data.tipStat.playerDuration_subscribeTipShowTime_arr);
            }
            catch (e:Error)
            {
                instance._log.debug("TipManager : addSubscribeTipShowTime error");
            }
            return;
        }// end function

        private static function getPlayerDuration_subscribeTipShowTime_arr() : Array
        {
            var so:SharedObject;
            var result:Array;
            try
            {
                so = SharedObject.getLocal(TipStatistics, "/");
                if (so.data.tipStat && so.data.tipStat.playerDuration_subscribeTipShowTime_arr)
                {
                    result = so.data.tipStat.playerDuration_subscribeTipShowTime_arr;
                }
                else
                {
                    so.data.tipStat.playerDuration_subscribeTipShowTime_arr = [];
                    result;
                    so.flush();
                }
                instance._log.debug("get lso local playerDuration_subscribeTipShowTime_arr" + result);
            }
            catch ($e:Error)
            {
                instance._log.debug("TipManager : playerDuration_subscribeTipShowTime_arr error");
            }
            finally
            {
                instance._log.debug("finally get lso local playerDuration_subscribeTipShowTime_arr ：" + result);
                var _loc_4:* = result;
                ;
                
                
                return _loc_4;
            }
        }// end function

        private static function getSubscribeTipShowTime() : uint
        {
            var so:SharedObject;
            var result:uint;
            try
            {
                so = SharedObject.getLocal(TipStatistics, "/");
                if (so.data.tipStat && so.data.tipStat.subscribeTipShowTime)
                {
                    result = so.data.tipStat.subscribeTipShowTime;
                }
                else
                {
                    so.data.tipStat.subscribeTipShowTime = 0;
                    result;
                    so.flush();
                }
                instance._log.debug("get lso local _subscribeTipShowTime：" + result);
            }
            catch ($e:Error)
            {
                instance._log.debug("TipManager : _subscribeTipShowTime： error");
            }
            finally
            {
                instance._log.debug("finally get lso local _subscribeTipShowTime ：" + result);
                var _loc_4:* = result;
                ;
                
                
                return _loc_4;
            }
        }// end function

        private static function addSubscribeTipShowTime() : void
        {
            var so:SharedObject;
            try
            {
                so = SharedObject.getLocal(TipStatistics, "/");
                if (so.data.tipStat && !so.data.tipStat.subscribeTipShowTime)
                {
                    so.data.tipStat.subscribeTipShowTime = 1;
                }
                else
                {
                    (so.data.tipStat.subscribeTipShowTime + 1);
                }
                so.flush();
                instance._log.debug("just saved subscribeTipShowTime to local lso ：" + so.data.tipStat.subscribeTipShowTime);
            }
            catch (e:Error)
            {
                instance._log.debug("TipManager : addSubscribeTipShowTime error");
            }
            return;
        }// end function

        private static function get tipStat() : Object
        {
            var _loc_1:SharedObject = null;
            if (_tipStatChanged)
            {
                try
                {
                    _loc_1 = SharedObject.getLocal(TipStatistics, "/");
                    instance._tipStat = _loc_1.data.tipStat;
                }
                catch (e:Error)
                {
                }
                _tipStatChanged = false;
            }
            if (instance._tipStat == null)
            {
                instance._log.debug("TipManager: get stat cookie error,unable cookie.");
                instance._enableCookie = false;
            }
            return instance._tipStat;
        }// end function

        private static function trim(param1:String) : String
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = /^\s*""^\s*/;
            param1 = param1.replace(_loc_2, "");
            _loc_2 = /\s*$""\s*$/;
            return param1.replace(_loc_2, "");
        }// end function

        private static function getRealExpiredTime() : int
        {
            var _loc_2:Number = NaN;
            var _loc_3:Date = null;
            var _loc_4:Date = null;
            var _loc_1:String = "";
            if (playerModel.movieInfo && playerModel.movieInfo.infoJSON && playerModel.movieInfo.infoJSON.hasOwnProperty("etm"))
            {
                _loc_1 = playerModel.movieInfo.infoJSON.etm;
            }
            if (_loc_1 == "")
            {
                _loc_2 = 100;
            }
            else
            {
                _loc_3 = produceDate(_loc_1);
                _loc_4 = new Date();
                _loc_2 = Math.ceil((_loc_3.getTime() - _loc_4.getTime()) / 1000 / 864000 * 10);
            }
            return _loc_2;
        }// end function

        private static function produceDate(param1:String) : Date
        {
            var _loc_2:* = new Date();
            _loc_2.fullYear = Number(param1.substr(0, 4));
            _loc_2.month = Number(param1.substr(4, 2)) - 1;
            _loc_2.date = Number(param1.substr(6, 2));
            _expiredDateStr = _loc_2.fullYear + "年" + (_loc_2.month + 1) + "月" + _loc_2.date + "日";
            updateAttribute("expiredTime", _expiredDateStr);
            updateAttribute("videoName", remainWord(playerModel.movieInfo.albumName, 22));
            return _loc_2;
        }// end function

        static function addLog(param1:String) : void
        {
            instance._log.debug(param1);
            return;
        }// end function

        static function TipDebugInfo() : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            if (_enableDebugKey == false)
            {
                instance._log.debug("TipManager : unenable DebugKey");
                return;
            }
            var _loc_1:String = "--------TipDebugInfo----------";
            try
            {
                _loc_2 = instance._external;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1 = _loc_1 + "\n" + _loc_3 + ":" + _loc_2[_loc_3];
                }
            }
            catch (e:Error)
            {
                try
                {
                }
                _loc_2 = playerModel.movieModel.source;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1 = _loc_1 + "\n" + _loc_3 + ":" + _loc_2[_loc_3];
                }
            }
            catch (e:Error)
            {
                try
                {
                }
                _loc_2 = playerModel.movieInfo.infoJSON;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1 = _loc_1 + "\n" + _loc_3 + ":" + _loc_2[_loc_3];
                }
            }
            catch (e:Error)
            {
                try
                {
                }
                _loc_1 = _loc_1 + "\n";
                _loc_4 = 0;
                _loc_5 = tipStat.list as Array;
                _loc_4 = 0;
                while (_loc_4 < _loc_5.length)
                {
                    
                    _loc_2 = tipStat.list[_loc_4];
                    for (_loc_3 in _loc_2)
                    {
                        
                        _loc_1 = _loc_1 + "\t" + _loc_3 + ":" + _loc_2[_loc_3];
                    }
                    _loc_1 = _loc_1 + "\n";
                    _loc_4++;
                }
                _loc_1 = _loc_1 + "\n";
                _loc_6 = tipStat.conflict as Array;
                _loc_4 = 0;
                while (_loc_4 < _loc_6.length)
                {
                    
                    _loc_2 = tipStat.conflict[_loc_4];
                    for (_loc_3 in _loc_2)
                    {
                        
                        _loc_1 = _loc_1 + "\t" + _loc_3 + ":" + _loc_2[_loc_3];
                    }
                    _loc_1 = _loc_1 + "\n";
                    _loc_4++;
                }
            }
            catch (e:Error)
            {
                try
                {
                }
                _loc_1 = _loc_1 + "\n start:" + String(getFieldValue("start"));
                _loc_1 = _loc_1 + "\n end:" + String(getFieldValue("end"));
                _loc_1 = _loc_1 + "\n startplay:" + String(getFieldValue("startplay"));
                _loc_1 = _loc_1 + "\n endplay:" + String(getFieldValue("endplay"));
            }
            catch (e:Error)
            {
            }
            _loc_1 = _loc_1 + "\n----------TipDebugInfo------------";
            instance._log.debug(_loc_1);
            return;
        }// end function

        public static function enableDebugKey(param1:Boolean) : void
        {
            _enableDebugKey = param1;
            return;
        }// end function

        public static function get tipBar() : TipBar
        {
            return instance._tipBar;
        }// end function

        public static function get playerModel() : IPlayer
        {
            return instance._model;
        }// end function

        private static function onComplete(event:Event) : void
        {
            var loader:URLLoader;
            var dataXML:XML;
            var event:* = event;
            try
            {
                loader = URLLoader(event.target);
                dataXML = XML(loader.data);
                setData(dataXML);
                removeLoaderListener();
            }
            catch (e:Error)
            {
                instance._log.warn("TipManager: load xml error" + e.errorID);
            }
            return;
        }// end function

        private static function onIOError(event:IOErrorEvent) : void
        {
            removeLoaderListener();
            instance._log.warn("TipManager: get data url ioError");
            return;
        }// end function

        private static function onSecurityError(event:SecurityErrorEvent) : void
        {
            removeLoaderListener();
            instance._log.debug("TipManager: get data url securityError");
            return;
        }// end function

        private static function removeLoaderListener() : void
        {
            loader.removeEventListener(Event.COMPLETE, onComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            return;
        }// end function

        private static function sendErrorEvent(param1) : void
        {
            var _loc_2:* = new TipEvent(TipEvent.Error);
            _loc_2.error = param1;
            instance.dispatchEvent(_loc_2);
            return;
        }// end function

        public static function remainWord(param1:String, param2:uint) : String
        {
            var _loc_3:String = "";
            if (param1.length > param2)
            {
                _loc_3 = param1.substr(0, param2) + "...";
            }
            else
            {
                _loc_3 = param1;
            }
            return _loc_3;
        }// end function

    }
}
