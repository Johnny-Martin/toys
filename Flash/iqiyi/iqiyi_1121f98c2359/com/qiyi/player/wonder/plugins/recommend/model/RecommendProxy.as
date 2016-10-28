package com.qiyi.player.wonder.plugins.recommend.model
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.recommend.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class RecommendProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _playFinishJson:Object = null;
        private var _playFinishDataVector:Vector.<RecommendVO>;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy";

        public function RecommendProxy(param1:Object = null)
        {
            this._playFinishDataVector = new Vector.<RecommendVO>;
            this._log = Log.getLogger("com.qiyi.player.wonder.plugins.recommend.model.RecommendProxy");
            super(NAME, param1);
            this._status = new Status(RecommendDef.STATUS_BEGIN, RecommendDef.STATUS_END);
            return;
        }// end function

        public function getArea(param1:Object) : String
        {
            if (param1 == null)
            {
                return "";
            }
            var _loc_2:* = param1.attribute;
            if (_loc_2 && _loc_2.area != undefined)
            {
                return _loc_2.area;
            }
            return "";
        }// end function

        public function getBkt(param1:Object) : String
        {
            if (param1 == null)
            {
                return "";
            }
            var _loc_2:* = param1.attribute;
            if (_loc_2 && (_loc_2.bkt != undefined || _loc_2.bucket != undefined))
            {
                return _loc_2.bkt != undefined ? (_loc_2.bkt) : (_loc_2.bucket);
            }
            return "";
        }// end function

        public function getEventID(param1:Object) : String
        {
            if (param1 == null)
            {
                return "";
            }
            var _loc_2:* = param1.attribute;
            if (_loc_2 && _loc_2.eventId != undefined)
            {
                return _loc_2.eventId;
            }
            return "";
        }// end function

        public function getRecommendIDString(param1:Vector.<RecommendVO>) : String
        {
            var _loc_3:uint = 0;
            var _loc_2:String = "";
            if (param1.length > 0)
            {
                _loc_3 = 0;
                while (_loc_3 < param1.length)
                {
                    
                    if (_loc_3 == (param1.length - 1))
                    {
                        _loc_2 = _loc_2 + param1[_loc_3].albumID;
                    }
                    else
                    {
                        _loc_2 = _loc_2 + (param1[_loc_3].albumID + ",");
                    }
                    _loc_3 = _loc_3 + 1;
                }
            }
            return _loc_2;
        }// end function

        public function get playFinishDataVector() : Vector.<RecommendVO>
        {
            return this._playFinishDataVector;
        }// end function

        public function get playFinishJson() : Object
        {
            return this._playFinishJson;
        }// end function

        public function set playFinishJson(param1:Object) : void
        {
            var _loc_2:RecommendVO = null;
            var _loc_4:RecommendVO = null;
            if (this._playFinishDataVector)
            {
                while (this._playFinishDataVector.length > 0)
                {
                    
                    _loc_4 = this._playFinishDataVector.shift();
                    _loc_4.destroy();
                    _loc_4 = null;
                }
            }
            var _loc_3:uint = 0;
            while (_loc_3 < param1.mixinVideos.length)
            {
                
                _loc_2 = new RecommendVO(_loc_3, param1.mixinVideos[_loc_3]);
                this._playFinishDataVector.push(_loc_2);
                _loc_3 = _loc_3 + 1;
            }
            this._playFinishJson = param1;
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= RecommendDef.STATUS_BEGIN && param1 < RecommendDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == RecommendDef.STATUS_FINISH_RECOMMEND_OPEN && !this._status.hasStatus(RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT))
                {
                    this._status.addStatus(RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT);
                    sendNotification(RecommendDef.NOTIFIC_ADD_STATUS, RecommendDef.STATUS_FINISH_RECOMMEND_VIEW_INIT);
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(RecommendDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= RecommendDef.STATUS_BEGIN && param1 < RecommendDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(RecommendDef.NOTIFIC_REMOVE_STATUS, param1);
                }
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

    }
}
