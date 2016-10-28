package com.qiyi.player.wonder.body.model.remote
{
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.common.config.*;
    import flash.events.*;
    import flash.net.*;

    public class BonusRemote extends Object
    {
        private var _urlLoader:URLLoader;

        public function BonusRemote()
        {
            return;
        }// end function

        public function sendOneMinute(param1:String, param2:String, param3:int, param4:String, param5:String) : void
        {
            var _loc_6:String = "";
            _loc_6 = SystemConfig.BONUS_API_URL + "?eventid=" + "view_video" + "&count=1" + "&pid=0" + "&cid=0" + "&uuid=" + param1 + "&tvid=" + param2 + "&channelid=" + param3 + "&vvsourceid=" + param5 + "&albumid=" + param4;
            this.startService(_loc_6);
            return;
        }// end function

        public function sendPlayOver(param1:String, param2:String, param3:int, param4:String, param5:String) : void
        {
            var _loc_6:String = "";
            _loc_6 = SystemConfig.BONUS_API_URL + "?eventid=" + "view_video" + "&count=1" + "&pid=0" + "&cid=0" + "&uuid=" + param1 + "&tvid=" + param2 + "&channelid=" + param3 + "&vvsourceid=" + param5 + "&albumid=" + param4;
            this.startService(_loc_6);
            return;
        }// end function

        public function sendSavedTotalBonus(param1:uint, param2:String, param3:String) : void
        {
            var _loc_4:* = param1 / BodyDef.BONUS_DEFAULT_COUNT_ONCE;
            var _loc_5:String = "";
            _loc_5 = SystemConfig.BONUS_API_URL + "?eventid=" + "nologin_import" + "&count=" + _loc_4 + "&pid=0" + "&cid=0" + "&vvsourceid=" + param3 + "&uuid=" + param2;
            this.startService(_loc_5);
            return;
        }// end function

        private function startService(param1:String) : void
        {
            if (this._urlLoader)
            {
                this._urlLoader.removeEventListener(Event.COMPLETE, this.onCompleteHandler);
                this._urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler);
                this._urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityErrorHandler);
                try
                {
                    this._urlLoader.close();
                }
                catch (e:Error)
                {
                }
            }
            var _loc_2:* = new URLRequest(param1 + "&n=" + Math.random());
            this._urlLoader = new URLLoader();
            this._urlLoader.addEventListener(Event.COMPLETE, this.onCompleteHandler);
            this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onIOErrorHandler);
            this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityErrorHandler);
            this._urlLoader.load(_loc_2);
            return;
        }// end function

        private function onCompleteHandler(event:Event) : void
        {
            return;
        }// end function

        private function onIOErrorHandler(event:IOErrorEvent) : void
        {
            return;
        }// end function

        private function onSecurityErrorHandler(event:Event) : void
        {
            return;
        }// end function

    }
}
