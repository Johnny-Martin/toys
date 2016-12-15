package com.qiyi.player.core.model.remote
{
    import __AS3__.vec.*;
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class RequestEnjoyableSkipPointsRemote extends BaseRemoteObject
    {
        private var _holder:ICorePlayer;
        private var _skipPointTypeArr:Array;
        private var _skipPointMap:Dictionary;
        private var _skipPointInfoDurationMap:Dictionary;
        private var _tvid:String;
        private var _log:ILogger;

        public function RequestEnjoyableSkipPointsRemote(param1:ICorePlayer, param2:String)
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.actors.RequestEnjoyableSkipPointsRemote");
            super(0, "RequestEnjoyableSkipPointsRemote");
            _retryMaxCount = Config.requestSkipPointsMaxRetry;
            _timeout = Config.requestSkipPointsTimeout;
            this._holder = param1;
            this._tvid = param2;
            this._skipPointTypeArr = [];
            this._skipPointMap = new Dictionary();
            this._skipPointInfoDurationMap = new Dictionary();
            return;
        }// end function

        public function get skipPointTypeArr() : Array
        {
            return this._skipPointTypeArr;
        }// end function

        public function get skipPointMap() : Dictionary
        {
            return this._skipPointMap;
        }// end function

        public function get skipPointInfoDurationMap() : Dictionary
        {
            return this._skipPointInfoDurationMap;
        }// end function

        override public function destroy() : void
        {
            super.destroy();
            this._skipPointTypeArr = null;
            this._skipPointMap = null;
            this._skipPointInfoDurationMap = null;
            return;
        }// end function

        override protected function getRequest() : URLRequest
        {
            var _loc_1:* = Config.ENJOYABLE_SKIP_POINT_URL + this._tvid + "/";
            return new URLRequest(_loc_1);
        }// end function

        override protected function onComplete(event:Event) : void
        {
            var json:Object;
            var gen:Array;
            var j:int;
            var item:Object;
            var time:Array;
            var gender:EnumItem;
            var timeArr:Array;
            var timeMap:Dictionary;
            var l:int;
            var event:* = event;
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            try
            {
                _data = _loader.data;
                if (_data != null && _data != "")
                {
                    json = JSON.decode(_data as String);
                    if (json.code == "A00000")
                    {
                        gen = json.data as Array;
                        if (gen && gen.length > 0)
                        {
                            j;
                            while (j < gen.length)
                            {
                                
                                item = gen[j];
                                if (item)
                                {
                                    time = item.data as Array;
                                    if (time)
                                    {
                                        gender = this.parseGender(int(item.gender));
                                        this._skipPointTypeArr.push(gender);
                                        timeArr = new Array(time.length);
                                        timeMap = new Dictionary();
                                        l;
                                        while (l < time.length)
                                        {
                                            
                                            timeArr[l] = int(time[l].t) * 1000;
                                            timeMap[timeArr[l]] = this.parseData(time[l].data as Array);
                                            l = (l + 1);
                                        }
                                        this._skipPointMap[gender] = timeMap;
                                        timeArr.sort(Array.NUMERIC);
                                        this._skipPointInfoDurationMap[gender] = timeArr;
                                    }
                                }
                                j = (j + 1);
                            }
                        }
                    }
                    else
                    {
                        this._log.debug("RequestEnjoyableSkipPointsRemote result code: " + json.code);
                    }
                }
                else
                {
                    this._log.debug("RequestEnjoyableSkipPointsRemote result is empty!");
                }
                super.onComplete(event);
            }
            catch (e:Error)
            {
                _log.debug("RequestEnjoyableSkipPointsRemote result DataError!");
                setStatus(RemoteObjectStatusEnum.DataError);
            }
            return;
        }// end function

        private function parseGender(param1:int) : EnumItem
        {
            if (param1 == 1)
            {
                return SkipPointEnum.ENJOYABLE_SUB_MALE;
            }
            if (param1 == -1)
            {
                return SkipPointEnum.ENJOYABLE_SUB_FEMALE;
            }
            return SkipPointEnum.ENJOYABLE_SUB_COMMON;
        }// end function

        private function parseData(param1:Array) : Vector.<SkipPointInfo>
        {
            var _loc_5:Object = null;
            var _loc_2:SkipPointInfo = null;
            var _loc_3:* = new Vector.<SkipPointInfo>;
            var _loc_4:int = 0;
            while (_loc_4 < param1.length)
            {
                
                _loc_5 = param1[_loc_4];
                if (_loc_5)
                {
                    _loc_2 = new SkipPointInfo();
                    if (int(_loc_5.type) == 1)
                    {
                        _loc_2.skipPointType = SkipPointEnum.ENJOYABLE;
                    }
                    _loc_2.startTime = int(_loc_5.start) * 1000;
                    _loc_2.endTime = int(_loc_5.end) * 1000;
                    _loc_3.push(_loc_2);
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

    }
}
