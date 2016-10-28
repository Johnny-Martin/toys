package com.qiyi.player.wonder.plugins.continueplay.model
{
    import __AS3__.vec.*;
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import flash.external.*;
    import flash.utils.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class ContinuePlayProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _continueInfoList:Vector.<ContinueInfo>;
        private var _continueInfoIndexMap:Dictionary;
        private var _isContinue:Boolean = true;
        private var _isJSContinue:Boolean = false;
        private var _JSContinueTitle:String = "";
        private var _isCyclePlay:Boolean;
        private var _hasPreNeedLoad:Boolean;
        private var _hasNextNeedLoad:Boolean;
        private var _dataSource:uint = 0;
        private var _switchVideoType:int = 0;
        private var _taid:String = "";
        private var _tcid:String = "";
        private var _playerProxy:PlayerProxy;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.continueplay.model.ContinuePlayProxy";

        public function ContinuePlayProxy(param1:Object = null)
        {
            var $data:* = param1;
            this._log = Log.getLogger(NAME);
            super(NAME, $data);
            this._status = new Status(ContinuePlayDef.STATUS_BEGIN, ContinuePlayDef.STATUS_END);
            this._continueInfoList = new Vector.<ContinueInfo>;
            this._continueInfoIndexMap = new Dictionary();
            this._isCyclePlay = FlashVarConfig.cyclePlay;
            this._status.addStatus(ContinuePlayDef.STATUS_VIEW_INIT);
            try
            {
                ExternalInterface.addCallback("getContinueData", this.getContinueData);
                ExternalInterface.addCallback("getSwitchVideoType", this.getSwitchVideoType);
            }
            catch (error:Error)
            {
                _log.warn("ContinuePlayProxy add call back error!");
            }
            return;
        }// end function

        public function get taid() : String
        {
            return this._taid;
        }// end function

        public function set taid(param1:String) : void
        {
            this._taid = param1;
            return;
        }// end function

        public function get tcid() : String
        {
            return this._tcid;
        }// end function

        public function set tcid(param1:String) : void
        {
            this._tcid = param1;
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function get hasPreNeedLoad() : Boolean
        {
            return this._hasPreNeedLoad;
        }// end function

        public function set hasPreNeedLoad(param1:Boolean) : void
        {
            this._hasPreNeedLoad = param1;
            return;
        }// end function

        public function get hasNextNeedLoad() : Boolean
        {
            return this._hasNextNeedLoad;
        }// end function

        public function set hasNextNeedLoad(param1:Boolean) : void
        {
            this._hasNextNeedLoad = param1;
            return;
        }// end function

        public function get continueInfoList() : Vector.<ContinueInfo>
        {
            return this._continueInfoList;
        }// end function

        public function get continueInfoCount() : int
        {
            return this._continueInfoList.length;
        }// end function

        public function get isContinue() : Boolean
        {
            return this._isContinue;
        }// end function

        public function set isContinue(param1:Boolean) : void
        {
            this._isContinue = param1;
            return;
        }// end function

        public function get isJSContinue() : Boolean
        {
            return this._isJSContinue;
        }// end function

        public function set isJSContinue(param1:Boolean) : void
        {
            this._isJSContinue = param1;
            return;
        }// end function

        public function get JSContinueTitle() : String
        {
            return this._JSContinueTitle;
        }// end function

        public function set JSContinueTitle(param1:String) : void
        {
            this._JSContinueTitle = param1;
            return;
        }// end function

        public function get isCyclePlay() : Boolean
        {
            return this._isCyclePlay;
        }// end function

        public function set isCyclePlay(param1:Boolean) : void
        {
            this._isCyclePlay = param1;
            sendNotification(ContinuePlayDef.NOTIFIC_CYCLE_PLAY_CHANGED, this._isCyclePlay);
            return;
        }// end function

        public function get switchVideoType() : int
        {
            return this._switchVideoType;
        }// end function

        public function get dataSource() : uint
        {
            return this._dataSource;
        }// end function

        public function set dataSource(param1:uint) : void
        {
            this._dataSource = param1;
            return;
        }// end function

        public function set switchVideoType(param1:int) : void
        {
            this._switchVideoType = param1;
            sendNotification(ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED, this._switchVideoType);
            return;
        }// end function

        public function injectPlayerProxy(param1:PlayerProxy) : void
        {
            this._playerProxy = param1;
            return;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= ContinuePlayDef.STATUS_BEGIN && param1 < ContinuePlayDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == ContinuePlayDef.STATUS_OPEN && !this._status.hasStatus(ContinuePlayDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(ContinuePlayDef.STATUS_VIEW_INIT);
                    sendNotification(ContinuePlayDef.NOTIFIC_ADD_STATUS, ContinuePlayDef.STATUS_VIEW_INIT);
                }
                switch(param1)
                {
                    case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS:
                    {
                        this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
                        this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
                        break;
                    }
                    case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING:
                    {
                        this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
                        this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
                        break;
                    }
                    case ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED:
                    {
                        this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_LOADING);
                        this._status.removeStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
                        break;
                    }
                    case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS:
                    {
                        this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
                        this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
                        break;
                    }
                    case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING:
                    {
                        this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
                        this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
                        break;
                    }
                    case ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED:
                    {
                        this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_LOADING);
                        this._status.removeStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(ContinuePlayDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= ContinuePlayDef.STATUS_BEGIN && param1 < ContinuePlayDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(ContinuePlayDef.NOTIFIC_REMOVE_STATUS, param1);
                }
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

        public function addContinueInfoList(param1:Vector.<ContinueInfo>, param2:int) : void
        {
            var _loc_3:* = param1.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                this._continueInfoList.splice(param2 + _loc_4, 0, param1[_loc_4]);
                _loc_4++;
            }
            if (this._continueInfoList.length > 0)
            {
                this._isJSContinue = false;
                this._JSContinueTitle = "";
            }
            this.updateContinueInfoIndex();
            sendNotification(ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED, {add:true, addCount:_loc_3});
            return;
        }// end function

        public function removeContinueInfoList(param1:Vector.<String>, param2:Vector.<String>) : void
        {
            var _loc_3:* = param1.length;
            var _loc_4:String = "";
            var _loc_5:String = "";
            var _loc_6:String = "";
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            while (_loc_8 < _loc_3)
            {
                
                _loc_4 = param1[_loc_8];
                _loc_5 = param2[_loc_8];
                _loc_6 = _loc_4 + _loc_5;
                if (this._continueInfoIndexMap[_loc_6] != undefined)
                {
                    _loc_7 = this._continueInfoIndexMap[_loc_6];
                    this._continueInfoList.splice(_loc_7, 1);
                    delete this._continueInfoIndexMap[_loc_6];
                }
                _loc_8++;
            }
            this.updateContinueInfoIndex();
            sendNotification(ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED, {add:false});
            return;
        }// end function

        public function clearContinueInfo() : void
        {
            if (this._continueInfoList.length > 0)
            {
                this._continueInfoList = new Vector.<ContinueInfo>;
                this._continueInfoIndexMap = new Dictionary();
                sendNotification(ContinuePlayDef.NOTIFIC_INFO_LIST_CHANGED, {add:false});
            }
            return;
        }// end function

        public function findContinueInfoAt(param1:int) : ContinueInfo
        {
            if (param1 >= 0 && param1 < this._continueInfoList.length)
            {
                return this._continueInfoList[param1];
            }
            return null;
        }// end function

        public function findContinueInfo(param1:String, param2:String) : ContinueInfo
        {
            var _loc_4:int = 0;
            var _loc_3:* = param1 + param2;
            if (this._continueInfoIndexMap[_loc_3] != undefined)
            {
                _loc_4 = this._continueInfoIndexMap[_loc_3];
                return this._continueInfoList[_loc_4];
            }
            return null;
        }// end function

        public function findNextContinueInfo(param1:String, param2:String) : ContinueInfo
        {
            var _loc_4:int = 0;
            var _loc_3:* = param1 + param2;
            if (this._continueInfoIndexMap[_loc_3] != undefined)
            {
                _loc_4 = this._continueInfoIndexMap[_loc_3];
                if (_loc_4 != (this.continueInfoCount - 1))
                {
                    return this._continueInfoList[(_loc_4 + 1)];
                }
            }
            return null;
        }// end function

        public function findPreContinueInfo(param1:String, param2:String) : ContinueInfo
        {
            var _loc_4:int = 0;
            var _loc_3:* = param1 + param2;
            if (this._continueInfoIndexMap[_loc_3] != undefined)
            {
                _loc_4 = this._continueInfoIndexMap[_loc_3];
                if (_loc_4 > 0)
                {
                    return this._continueInfoList[(_loc_4 - 1)];
                }
            }
            return null;
        }// end function

        public function cloneContinueInfoList() : Vector.<ContinueInfo>
        {
            return this._continueInfoList.concat();
        }// end function

        public function getPageContinueInfoList(param1:int, param2:int) : Vector.<ContinueInfo>
        {
            var _loc_3:* = Math.ceil(this._continueInfoList.length / param1);
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            if (param2 >= _loc_3)
            {
                _loc_4 = (_loc_3 - 1) * param1;
                _loc_5 = this._continueInfoList.length;
            }
            else
            {
                _loc_4 = (param2 - 1) * param1;
                _loc_5 = _loc_4 + param1;
            }
            var _loc_6:* = new Vector.<ContinueInfo>;
            var _loc_7:* = _loc_4;
            while (_loc_7 < _loc_5)
            {
                
                _loc_6.push(this._continueInfoList[_loc_7]);
                _loc_7++;
            }
            return _loc_6;
        }// end function

        private function updateContinueInfoIndex() : void
        {
            var _loc_1:* = this._continueInfoList.length;
            var _loc_2:String = "";
            var _loc_3:int = 0;
            while (_loc_3 < _loc_1)
            {
                
                _loc_2 = this._continueInfoList[_loc_3].loadMovieParams.tvid + this._continueInfoList[_loc_3].loadMovieParams.vid;
                this._continueInfoList[_loc_3].index = _loc_3;
                this._continueInfoIndexMap[_loc_2] = _loc_3;
                _loc_3++;
            }
            return;
        }// end function

        private function getContinueData() : String
        {
            var _loc_5:ContinueInfo = null;
            var _loc_6:ContinueInfo = null;
            var _loc_1:Boolean = false;
            var _loc_2:Boolean = false;
            var _loc_3:* = this._playerProxy.curActor.loadMovieParams;
            if (_loc_3)
            {
                _loc_5 = this.findPreContinueInfo(_loc_3.tvid, _loc_3.vid);
                _loc_1 = _loc_5 != null;
                _loc_6 = this.findNextContinueInfo(_loc_3.tvid, _loc_3.vid);
                _loc_2 = _loc_6 != null;
            }
            var _loc_4:Object = {};
            _loc_4.hasPre = _loc_1 ? ("1") : ("0");
            _loc_4.hasNext = _loc_2 ? ("1") : ("0");
            return JSON.encode(_loc_4);
        }// end function

        private function getSwitchVideoType() : String
        {
            if (this._switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_AUTO)
            {
                return "0";
            }
            if (this._switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_FLASH_LIST)
            {
                return "1";
            }
            if (this._switchVideoType == ContinuePlayDef.SWITCH_VIDEO_TYPE_JS_LIST)
            {
                return "3";
            }
            return "2";
        }// end function

    }
}
