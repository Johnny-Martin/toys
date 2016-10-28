package com.qiyi.player.wonder.plugins.hint.model
{
    import com.iqiyi.components.panelSystem.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import flash.utils.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class HintProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _log:ILogger;
        public var historyReady:Boolean = false;
        private var _historyInterval:Number = 0;
        public var replay:Boolean = false;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.hint.model.HintProxy";

        public function HintProxy(param1:Object = null)
        {
            this._log = Log.getLogger(NAME);
            super(NAME, param1);
            this._status = new Status(HintDef.STATUS_BEGIN, HintDef.STATUS_END);
            this._status.addStatus(HintDef.STATUS_VIEW_INIT);
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= HintDef.STATUS_BEGIN && param1 < HintDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == HintDef.STATUS_OPEN && !this._status.hasStatus(HintDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(HintDef.STATUS_VIEW_INIT);
                    sendNotification(HintDef.NOTIFIC_ADD_STATUS, HintDef.STATUS_VIEW_INIT);
                    this._log.info("贴片 初始化");
                }
                if ((param1 == HintDef.STATUS_PLAYING || param1 == HintDef.STATUS_PAUSED) && !this.hasStatus(HintDef.STATUS_OPEN))
                {
                    return;
                }
                switch(param1)
                {
                    case HintDef.STATUS_OPEN:
                    {
                        this.removeStatus(HintDef.STATUS_PLAYING);
                        this.removeStatus(HintDef.STATUS_PAUSED);
                        break;
                    }
                    case HintDef.STATUS_PLAYING:
                    {
                        this.removeStatus(HintDef.STATUS_PAUSED);
                        break;
                    }
                    case HintDef.STATUS_PAUSED:
                    {
                        this.removeStatus(HintDef.STATUS_PLAYING);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._log.info("HintProxy add status:" + param1);
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(HintDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= HintDef.STATUS_BEGIN && param1 < HintDef.STATUS_END && this._status.hasStatus(param1))
            {
                switch(param1)
                {
                    case HintDef.STATUS_OPEN:
                    {
                        this.removeStatus(HintDef.STATUS_PLAYING);
                        this.removeStatus(HintDef.STATUS_PAUSED);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._log.info("HintProxy remove status:" + param1);
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(HintDef.NOTIFIC_REMOVE_STATUS, param1);
                }
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

        public function checkPlayOrHint() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            this._log.info("hint check , historyReady:" + this.historyReady + " , replay : " + this.replay + " , time:" + _loc_1.curActor.historyStartTime + " , url:" + (_loc_1.curActor.movieModel.hintUrl != ""));
            clearInterval(this._historyInterval);
            this._historyInterval = 0;
            if (this.replay)
            {
                if (_loc_1.curActor.movieModel.hintUrl != "")
                {
                    this._log.info(" hint ： open hint");
                    sendNotification(HintDef.NOTIFIC_HINT_OPEN_CLOSE, true);
                    PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_END_POPUP);
                }
                else
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_REPLAY);
                }
            }
            else if (this.historyReady)
            {
                if (_loc_1.curActor.historyStartTime <= 0 && _loc_1.curActor.movieModel.hintUrl != "")
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_START_LOAD);
                    this.checkDataReady();
                }
                else
                {
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PLAY);
                }
            }
            else
            {
                this._historyInterval = setTimeout(this.checkPlayOrHint, 100);
            }
            return;
        }// end function

        private function checkDataReady() : void
        {
            clearInterval(this._historyInterval);
            this._historyInterval = 0;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            this._log.info("hint check , p2pready:" + _loc_1.curActor.checkEngineIsReady);
            if (_loc_1.curActor.checkEngineIsReady)
            {
                this._log.info(" hint ： open hint");
                sendNotification(HintDef.NOTIFIC_HINT_OPEN_CLOSE, true);
                PanelManager.getInstance().closeByType(BodyDef.VIEW_TYPE_END_POPUP);
            }
            else
            {
                this._historyInterval = setTimeout(this.checkDataReady, 100);
            }
            return;
        }// end function

    }
}
