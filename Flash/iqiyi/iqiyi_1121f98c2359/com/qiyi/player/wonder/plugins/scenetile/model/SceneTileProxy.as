package com.qiyi.player.wonder.plugins.scenetile.model
{
    import com.adobe.serialization.json.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.loader.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.scenetile.*;
    import com.qiyi.player.wonder.plugins.scenetile.model.barrage.*;
    import flash.net.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class SceneTileProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _lastPlayingDuration:int = 0;
        private var _lifePlayingDuration:int = 0;
        private var _lotteryShowTime:int = -1;
        private var _log:ILogger;
        private var _barrageProxy:BarrageProxy;
        private var _scoreLoader:URLLoader;
        private var _tvid:String = "";
        private var _ppuid:String = "";
        private var _uid:String = "";
        private var _pru:String = "";
        private var _curScoreNum:Number = 0;
        private var _isOpen:Boolean = false;
        private var _isScored:Boolean = false;
        private var _selectedScore:int = -1;
        private var _limitDifinition:EnumItem = null;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.scenetile.model.SceneTileProxy";

        public function SceneTileProxy(param1:Object = null)
        {
            this._log = Log.getLogger(NAME);
            super(NAME, param1);
            this._status = new Status(SceneTileDef.STATUS_BEGIN, SceneTileDef.STATUS_END);
            this._status.addStatus(SceneTileDef.STATUS_TOOL_VIEW_INIT);
            this._barrageProxy = new BarrageProxy();
            this._status.addStatus(SceneTileDef.STATUS_BARRAGE_VIEW_INIT);
            return;
        }// end function

        public function get barrageProxy() : BarrageProxy
        {
            return this._barrageProxy;
        }// end function

        public function get limitDifinition() : EnumItem
        {
            return this._limitDifinition;
        }// end function

        public function set limitDifinition(param1:EnumItem) : void
        {
            this._limitDifinition = param1;
            return;
        }// end function

        public function get selectedScore() : int
        {
            return this._selectedScore;
        }// end function

        public function set selectedScore(param1:int) : void
        {
            this._selectedScore = param1;
            return;
        }// end function

        public function get isScored() : Boolean
        {
            return this._isScored;
        }// end function

        public function set isScored(param1:Boolean) : void
        {
            this._isScored = param1;
            return;
        }// end function

        public function get isOpen() : Boolean
        {
            return this._isOpen;
        }// end function

        public function set isOpen(param1:Boolean) : void
        {
            this._isOpen = param1;
            return;
        }// end function

        public function get curScoreNum() : Number
        {
            return this._curScoreNum;
        }// end function

        public function get lastPlayingDuration() : int
        {
            return this._lastPlayingDuration;
        }// end function

        public function set lastPlayingDuration(param1:int) : void
        {
            this._lastPlayingDuration = param1;
            return;
        }// end function

        public function get lifePlayingDuration() : int
        {
            return this._lifePlayingDuration;
        }// end function

        public function set lifePlayingDuration(param1:int) : void
        {
            this._lifePlayingDuration = param1;
            return;
        }// end function

        public function get lotteryShowTime() : int
        {
            return this._lotteryShowTime;
        }// end function

        public function set lotteryShowTime(param1:int) : void
        {
            this._lotteryShowTime = param1;
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= SceneTileDef.STATUS_BEGIN && param1 < SceneTileDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == SceneTileDef.STATUS_TOOL_OPEN && !this._status.hasStatus(SceneTileDef.STATUS_TOOL_VIEW_INIT))
                {
                    this._status.addStatus(SceneTileDef.STATUS_TOOL_VIEW_INIT);
                    sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS, SceneTileDef.STATUS_TOOL_VIEW_INIT);
                }
                else if (param1 == SceneTileDef.STATUS_BARRAGE_OPEN && !this._status.hasStatus(SceneTileDef.STATUS_BARRAGE_VIEW_INIT))
                {
                    this._status.addStatus(SceneTileDef.STATUS_BARRAGE_VIEW_INIT);
                    sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS, SceneTileDef.STATUS_BARRAGE_VIEW_INIT);
                }
                else if (param1 == SceneTileDef.STATUS_SCORE_OPEN && !this._status.hasStatus(SceneTileDef.STATUS_SCORE_VIEW_INIT))
                {
                    this._status.addStatus(SceneTileDef.STATUS_SCORE_VIEW_INIT);
                    sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS, SceneTileDef.STATUS_SCORE_VIEW_INIT);
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(SceneTileDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= SceneTileDef.STATUS_BEGIN && param1 < SceneTileDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(SceneTileDef.NOTIFIC_REMOVE_STATUS, param1);
                }
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

        public function requestScored(param1:String, param2:String, param3:String, param4:String, param5:Number) : void
        {
            this._tvid = param1;
            this._ppuid = param2;
            this._uid = param3;
            this._pru = param4;
            var _loc_6:* = SystemConfig.MOVIE_SCORE_URL + "get_user_movie_score" + "?qipu_id=" + this._tvid + "&udid=" + param3 + "&uid=" + param2 + "&appid=21" + "&type=" + param5 + "&pru=" + this._pru + "&rn=" + Math.random();
            this._log.debug("requestScored url = " + _loc_6);
            LoaderManager.instance.loader(_loc_6, this.callbackRequestScoredComplete, null, LoaderManager.TYPE_URLlOADER);
            return;
        }// end function

        private function callbackRequestScoredComplete(param1:Object) : void
        {
            var _loc_2:Object = null;
            try
            {
                _loc_2 = JSON.decode(param1.toString());
                if (_loc_2.code == "A00000")
                {
                    if (_loc_2.data && _loc_2.data.length > 0)
                    {
                        this._curScoreNum = Number(_loc_2.data[0].sns_score);
                        if (_loc_2.data[0].score && _loc_2.data[0].score.length > 0 && _loc_2.data[0].score[0] == -1)
                        {
                            this.addStatus(SceneTileDef.STATUS_SCORE_OPEN);
                        }
                    }
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
