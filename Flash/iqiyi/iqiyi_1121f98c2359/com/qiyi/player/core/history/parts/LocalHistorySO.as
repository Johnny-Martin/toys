package com.qiyi.player.core.history.parts
{
    import flash.net.*;

    public class LocalHistorySO extends Object
    {
        static const DEFAULT_HISTORY_TIME:int = -1000;
        private static var _list:Array;
        private static var _so:SharedObject;
        private static const MAX_RECORDS:int = 20;

        public function LocalHistorySO()
        {
            return;
        }// end function

        private static function update() : void
        {
            try
            {
                _so = SharedObject.getLocal("iqiyi_local_history", "/");
                if (_so.size > 0 && _so.data.historys)
                {
                    _list = _so.data.historys;
                }
                else
                {
                    _list = [];
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public static function readHistoryTime(param1:String) : int
        {
            var _loc_2:Object = null;
            var _loc_3:int = 0;
            update();
            if (_so && param1)
            {
                try
                {
                    if (_list)
                    {
                        _loc_2 = null;
                        _loc_3 = 0;
                        while (_loc_3 < _list.length)
                        {
                            
                            _loc_2 = _list[_loc_3];
                            if (_loc_2.tvid == param1)
                            {
                                return _loc_2.time;
                            }
                            _loc_3++;
                        }
                    }
                }
                catch (e:Error)
                {
                }
            }
            return DEFAULT_HISTORY_TIME;
        }// end function

        public static function writeHistoryTime(param1:String, param2:int) : void
        {
            var _loc_3:Boolean = false;
            var _loc_4:Object = null;
            var _loc_5:int = 0;
            update();
            if (_so && param1)
            {
                try
                {
                    if (_list == null)
                    {
                        _list = [];
                    }
                    _loc_3 = false;
                    _loc_4 = null;
                    _loc_5 = 0;
                    while (_loc_5 < _list.length)
                    {
                        
                        _loc_4 = _list[_loc_5];
                        if (_loc_4.tvid == param1)
                        {
                            _loc_4.time = param2;
                            _loc_3 = true;
                            break;
                        }
                        _loc_5++;
                    }
                    if (!_loc_3)
                    {
                        while (_list.length >= MAX_RECORDS)
                        {
                            
                            _list.shift();
                        }
                        _loc_4 = {};
                        _loc_4.tvid = param1;
                        _loc_4.time = param2;
                        _list.push(_loc_4);
                    }
                    _so.data.historys = _list;
                    _so.flush();
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

    }
}
