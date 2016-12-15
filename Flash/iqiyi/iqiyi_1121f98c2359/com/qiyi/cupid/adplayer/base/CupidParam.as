package com.qiyi.cupid.adplayer.base
{
    import flash.display.*;
    import flash.events.*;

    public class CupidParam extends Object
    {
        public var videoPlayerVersion:String;
        public var playerUrl:String;
        public var videoId:String;
        public var tvId:String;
        public var channelId:int;
        public var collectionId:String;
        public var playerId:String;
        public var albumId:String;
        public var dispatcher:IEventDispatcher;
        public var cacheMachineIp:String;
        public var adContainer:DisplayObjectContainer;
        public var stageWidth:Number;
        public var stageHeight:Number;
        public var userId:String = "";
        public var webEventId:String = "";
        public var videoEventId:String = "";
        public var vipRight:String = "0";
        public var terminal:String = "";
        public var duration:Number = 0;
        public var passportId:String = "";
        public var passportCookie:String = "";
        public var videoDefinitionId:Number = 0;
        public var passportKey:String = "";
        public var baiduMainVideo:String = "1";
        public var disablePreroll:Boolean = false;
        public var disableSkipAd:Boolean = false;
        public var enableVideoCore:Boolean = false;
        public var volume:Number = 80;
        public var videoIndex:int;
        public var isUGC:Boolean = false;
        public var couponCode:String;
        public var couponVer:String;
        public var videoPlaySecondsOfDay:int;
        public var language:String;
        public var isMuteMode:Boolean = false;
        public var vipFalseReason:Object;

        public function CupidParam()
        {
            return;
        }// end function

        public function toObject() : Object
        {
            var _loc_1:* = "videoPlayerVersion playerUrl videoId tvId channelId collectionId " + "playerId albumId adContainer stageWidth stageHeight userId webEventId dispatcher " + "cacheMachineIp videoEventId vipRight terminal duration passportId passportCookie " + "videoDefinitionId passportKey baiduMainVideo disablePreroll disableSkipAd " + "enableVideoCore volume videoIndex isUGC couponCode couponVer videoPlaySecondsOfDay language isMuteMode vipFalseReason";
            var _loc_2:Object = {};
            var _loc_3:* = _loc_1.split(" ");
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                _loc_2[_loc_3[_loc_4]] = this[_loc_3[_loc_4]] + "";
                _loc_4++;
            }
            return _loc_2;
        }// end function

    }
}
