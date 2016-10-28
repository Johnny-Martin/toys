package com.qiyi.player.wonder.plugins.videolink.model
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.videolink.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class VideoLinkProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _downLagTimesArr:Array;
        private var _videoLinkVector:Vector.<VideoLinkInfo>;
        private var _isHasLink:Boolean = false;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.videolink.model.VideoLinkProxy";

        public function VideoLinkProxy(param1:Object = null)
        {
            this._downLagTimesArr = [];
            super(NAME, param1);
            this._status = new Status(VideoLinkDef.STATUS_BEGIN, VideoLinkDef.STATUS_END);
            this._status.addStatus(VideoLinkDef.STATUS_VIEW_INIT);
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= VideoLinkDef.STATUS_BEGIN && param1 < VideoLinkDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == VideoLinkDef.STATUS_OPEN && !this._status.hasStatus(VideoLinkDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(VideoLinkDef.STATUS_VIEW_INIT);
                    sendNotification(VideoLinkDef.NOTIFIC_ADD_STATUS, VideoLinkDef.STATUS_VIEW_INIT);
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(VideoLinkDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= VideoLinkDef.STATUS_BEGIN && param1 < VideoLinkDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(VideoLinkDef.NOTIFIC_REMOVE_STATUS, param1);
                }
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

        public function get isHasLink() : Boolean
        {
            return this._isHasLink;
        }// end function

        public function set isHasLink(param1:Boolean) : void
        {
            this._isHasLink = param1;
            return;
        }// end function

        public function addVideoLinkInfo(param1:Vector.<VideoLinkInfo>) : void
        {
            this.clearVideoLinkInfo();
            this._videoLinkVector = param1;
            if (this._videoLinkVector.length > 0)
            {
                this._isHasLink = true;
            }
            return;
        }// end function

        public function getVideoLinkInfoByCurrentTime(param1:int) : VideoLinkInfo
        {
            var _loc_2:VideoLinkInfo = null;
            if (this._videoLinkVector == null)
            {
                return null;
            }
            for each (_loc_2 in this._videoLinkVector)
            {
                
                if (param1 >= int(_loc_2.startTime) && param1 <= int(_loc_2.endTime))
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function resetIsShow() : void
        {
            var _loc_1:VideoLinkInfo = null;
            for each (_loc_1 in this._videoLinkVector)
            {
                
                _loc_1.isShow = false;
            }
            return;
        }// end function

        private function clearVideoLinkInfo() : void
        {
            var _loc_1:VideoLinkInfo = null;
            if (this._videoLinkVector)
            {
                while (this._videoLinkVector.length > 0)
                {
                    
                    _loc_1 = this._videoLinkVector.shift();
                    _loc_1.destroy();
                    _loc_1 = null;
                }
                this._videoLinkVector.length = 0;
                this._videoLinkVector = null;
            }
            return;
        }// end function

        public function lagDownClient(param1:int) : Boolean
        {
            var _loc_2:* = new Date().time;
            this._downLagTimesArr.push(_loc_2);
            var _loc_3:int = 0;
            while (_loc_3 < this._downLagTimesArr.length)
            {
                
                if (_loc_2 - this._downLagTimesArr[_loc_3] > param1)
                {
                    this._downLagTimesArr.splice(_loc_3, 1);
                }
                _loc_3++;
            }
            if (this._downLagTimesArr.length >= VideoLinkDef.MAX_DOWN_CLIENT_STUCK)
            {
                this._downLagTimesArr.length = 0;
                return true;
            }
            return false;
        }// end function

    }
}
