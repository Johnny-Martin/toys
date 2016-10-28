package com.qiyi.player.wonder.plugins.subscribe.model
{
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.subscribe.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class SubscribeProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _subscribeInfo:Object;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.subscribe.model.SubscribeProxy";

        public function SubscribeProxy(param1:Object = null)
        {
            super(NAME, param1);
            this._status = new Status(SubscribeDef.STATUS_BEGIN, SubscribeDef.STATUS_END);
            this._status.addStatus(SubscribeDef.STATUS_VIEW_INIT);
            return;
        }// end function

        public function get subscribeInfo() : Object
        {
            return this._subscribeInfo;
        }// end function

        public function set subscribeInfo(param1:Object) : void
        {
            this._subscribeInfo = param1;
            return;
        }// end function

        public function updateSubscribeInfo(param1:String) : void
        {
            this._subscribeInfo.subState = param1;
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= SubscribeDef.STATUS_BEGIN && param1 < SubscribeDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == SubscribeDef.STATUS_OPEN && !this._status.hasStatus(SubscribeDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(SubscribeDef.STATUS_VIEW_INIT);
                    sendNotification(SubscribeDef.NOTIFIC_ADD_STATUS, SubscribeDef.STATUS_VIEW_INIT);
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(SubscribeDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= SubscribeDef.STATUS_BEGIN && param1 < SubscribeDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(SubscribeDef.NOTIFIC_REMOVE_STATUS, param1);
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
