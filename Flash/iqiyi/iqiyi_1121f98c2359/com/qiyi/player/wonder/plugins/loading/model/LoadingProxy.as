package com.qiyi.player.wonder.plugins.loading.model
{
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.loading.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class LoadingProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _isFirstLoading:Boolean = true;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.loading.model.LoadingProxy";

        public function LoadingProxy(param1:Object = null)
        {
            super(NAME, param1);
            this._status = new Status(LoadingDef.STATUS_BEGIN, LoadingDef.STATUS_END);
            this._status.addStatus(LoadingDef.STATUS_VIEW_INIT);
            return;
        }// end function

        public function get isFirstLoading() : Boolean
        {
            return this._isFirstLoading;
        }// end function

        public function set isFirstLoading(param1:Boolean) : void
        {
            this._isFirstLoading = param1;
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (FlashVarConfig.preloaderURL == "")
            {
                return;
            }
            if (param1 >= LoadingDef.STATUS_BEGIN && param1 < LoadingDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == LoadingDef.STATUS_OPEN && !this._status.hasStatus(LoadingDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(LoadingDef.STATUS_VIEW_INIT);
                    sendNotification(LoadingDef.NOTIFIC_ADD_STATUS, LoadingDef.STATUS_VIEW_INIT);
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(LoadingDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= LoadingDef.STATUS_BEGIN && param1 < LoadingDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(LoadingDef.NOTIFIC_REMOVE_STATUS, param1);
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
