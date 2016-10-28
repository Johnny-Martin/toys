package com.qiyi.player.wonder.plugins.tips.model
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.tips.*;
    import flash.net.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class TipsProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _definitionLagTimesArr:Array;
        private var _isFocusFirstTips:Boolean = false;
        private var _isFocusSecondTips:Boolean = false;
        private var _loader:URLLoader;
        private var _request:URLRequest;
        private var _isLoader:Boolean = false;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.tips.model.TipsProxy";

        public function TipsProxy(param1:Object = null)
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.plugins.tips.model.TipsProxy");
            super(NAME, param1);
            this._status = new Status(TipsDef.STATUS_BEGIN, TipsDef.STATUS_END);
            this._definitionLagTimesArr = [];
            this._status.addStatus(TipsDef.STATUS_VIEW_INIT);
            return;
        }// end function

        public function get isLoader() : Boolean
        {
            return this._isLoader;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= TipsDef.STATUS_BEGIN && param1 < TipsDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == TipsDef.STATUS_OPEN && !this._status.hasStatus(TipsDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(TipsDef.STATUS_VIEW_INIT);
                    sendNotification(TipsDef.NOTIFIC_ADD_STATUS, TipsDef.STATUS_VIEW_INIT);
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(TipsDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= TipsDef.STATUS_BEGIN && param1 < TipsDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(TipsDef.NOTIFIC_REMOVE_STATUS, param1);
                }
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

        public function getHotChatTipsTimesByIndex(param1:uint) : Boolean
        {
            switch(param1)
            {
                case 0:
                {
                    return this._isFocusFirstTips;
                }
                case 1:
                {
                    return this._isFocusSecondTips;
                }
                default:
                {
                    break;
                }
            }
            return true;
        }// end function

        public function setHotChatTipsTimesByIndex(param1:uint) : void
        {
            switch(param1)
            {
                case 0:
                {
                    this._isFocusFirstTips = true;
                    break;
                }
                case 1:
                {
                    this._isFocusSecondTips = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function clearHotChatTipsTimes() : void
        {
            this._isFocusSecondTips = false;
            this._isFocusFirstTips = false;
            return;
        }// end function

        public function lagDownDefinition(param1:int) : Boolean
        {
            var _loc_2:* = new Date().time;
            this._definitionLagTimesArr.push(_loc_2);
            var _loc_3:int = 0;
            while (_loc_3 < this._definitionLagTimesArr.length)
            {
                
                if (_loc_2 - this._definitionLagTimesArr[_loc_3] > param1)
                {
                    this._definitionLagTimesArr.splice(_loc_3, 1);
                }
                _loc_3++;
            }
            if (this._definitionLagTimesArr.length >= TipsDef.MAX_DEFINITION_STUCK)
            {
                this._definitionLagTimesArr.length = 0;
                return true;
            }
            return false;
        }// end function

    }
}
