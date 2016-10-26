package com.ws.stat
{
    import flash.events.*;
    import flash.utils.*;

    public class Statistics extends EventDispatcher
    {
        private const REPORT_URL:String = "http://psstatus.lxdns.com/report.php";
        private var _isSending:Boolean = false;
        private var _infoList:Array = null;
        private var _sendTimer:Timer = null;
        private var _eventIndex:int = 0;
        private var _playID:String = "";
        private var _uniteNum:int = 0;
        private var _domain:String = "";
        private var _isLive:Boolean;
        private var _videoID:String;
        public static const VERSION:String = "1.0.1";
        public static const LIB_LOAD:String = "lib-load";
        public static const PLAY_ACTION:String = "play-action";

        public function Statistics(param1:String, param2:Boolean, param3:String, param4:String)
        {
            this._domain = param1;
            this._isLive = param2;
            this._videoID = param4;
            this._playID = param3;
            this._infoList = new Array();
            this._sendTimer = new Timer(2000);
            this._sendTimer.addEventListener(TimerEvent.TIMER, this.onSendTimerHandler);
            this._sendTimer.start();
            return;
        }// end function

        public function reportStatInfo(param1:String, ... args) : void
        {
            args = null;
            var _loc_4:* = new Array();
            new Array().push(int(new Date().getTime() / 1000));
            _loc_4.push(param1);
            var _loc_5:String = this;
            _loc_5._eventIndex = this._eventIndex + 1;
            _loc_4.push(++this._eventIndex);
            args = Object(args[0]);
            switch(param1)
            {
                case LIB_LOAD:
                {
                    _loc_4.push(args.type);
                    _loc_4.push(args.time);
                    break;
                }
                case PLAY_ACTION:
                {
                    _loc_4.push(args.type);
                    _loc_4.push(args.serviceAvailable);
                    _loc_4.push(args.isError);
                    _loc_4.push(args.isSuccess);
                    break;
                }
                default:
                {
                    break;
                }
            }
            this._infoList.push(_loc_4);
            return;
        }// end function

        private function onSendTimerHandler(event:TimerEvent) : void
        {
            var _loc_2:String = null;
            var _loc_3:int = 0;
            var _loc_4:Array = null;
            if (!this._isSending && this._infoList.length > 0)
            {
                _loc_2 = "";
                _loc_2 = _loc_2 + (this._playID + "\t");
                _loc_2 = _loc_2 + ("-" + "\t");
                _loc_2 = _loc_2 + ("http://" + this._domain + "/" + (this._isLive ? ("live") : ("vod")) + "/" + this._videoID + "\t");
                _loc_2 = _loc_2 + VERSION;
                _loc_3 = 0;
                while (_loc_3 < this._infoList.length)
                {
                    
                    _loc_4 = this._infoList[_loc_3] as Array;
                    var _loc_5:String = this;
                    var _loc_6:* = this._uniteNum + 1;
                    _loc_5._uniteNum = _loc_6;
                    _loc_2 = _loc_2 + "\r\n";
                    _loc_2 = _loc_2 + this.urlVariableToString(_loc_4);
                    _loc_3++;
                }
                this._isSending = true;
                NetUtil.sendData(this.REPORT_URL + "?playID=" + this._playID + "&remainNum=" + 0, _loc_2, this.reportResult, this.reportError, true);
            }
            return;
        }// end function

        private function urlVariableToString(param1:Array) : String
        {
            var _loc_2:String = "";
            var _loc_3:int = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_2 = _loc_2 + param1[_loc_3];
                _loc_2 = _loc_2 + "\t";
                _loc_3++;
            }
            return _loc_2;
        }// end function

        protected function reportResult(event:Event) : void
        {
            var _loc_2:Array = null;
            var _loc_3:int = 0;
            while (_loc_3 < this._uniteNum)
            {
                
                if (this._infoList != null && this._infoList.length > 0)
                {
                    _loc_2 = this._infoList.shift();
                    _loc_2.splice(0, _loc_2.length);
                    _loc_2 = null;
                }
                _loc_3++;
            }
            this._uniteNum = 0;
            this._isSending = false;
            return;
        }// end function

        protected function reportError(event:Event) : void
        {
            this._isSending = false;
            return;
        }// end function

    }
}
