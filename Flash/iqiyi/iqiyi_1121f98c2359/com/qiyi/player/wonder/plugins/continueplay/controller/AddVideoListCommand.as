package com.qiyi.player.wonder.plugins.continueplay.controller
{
    import __AS3__.vec.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class AddVideoListCommand extends SimpleCommand
    {

        public function AddVideoListCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            super.execute(param1);
            var _loc_2:* = param1.getBody().list as Array;
            var _loc_3:* = param1.getBody().index;
            var _loc_4:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            var _loc_5:* = _loc_2.length;
            var _loc_6:Object = null;
            var _loc_7:ContinueInfo = null;
            var _loc_8:* = new Vector.<ContinueInfo>(_loc_5);
            var _loc_9:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_10:Boolean = false;
            if (_loc_9.curActor.movieModel && (_loc_9.curActor.movieModel.channelID == ChannelEnum.FINANCE.id || _loc_9.curActor.movieModel.channelID == ChannelEnum.ENTERTAINMENT.id || _loc_9.curActor.movieModel.channelID == ChannelEnum.LIFE_MICRO_VIDEO.id || _loc_9.curActor.movieModel.channelID == ChannelEnum.FASHION.id || _loc_9.curActor.movieModel.channelID == ChannelEnum.SPORTS.id || _loc_9.curActor.movieModel.channelID == ChannelEnum.NEWS.id))
            {
                _loc_10 = true;
            }
            if (param1.getBody().source == undefined)
            {
                _loc_4.dataSource = ContinuePlayDef.SOURCE_DEFAULT_VALUE;
            }
            else
            {
                _loc_4.dataSource = int(param1.getBody().source) == ContinuePlayDef.SOURCE_QIYU_VALUE ? (ContinuePlayDef.SOURCE_QIYU_VALUE) : (_loc_4.dataSource);
            }
            if (int(param1.getBody().source) != ContinuePlayDef.SOURCE_AD_VALUE)
            {
                _loc_4.taid = param1.getBody().taid == undefined ? ("") : (param1.getBody().taid);
                _loc_4.tcid = param1.getBody().tcid == undefined ? ("") : (param1.getBody().tcid);
            }
            if (_loc_3 == -1)
            {
                _loc_3 = _loc_4.continueInfoCount;
            }
            if (_loc_5)
            {
                if (_loc_3 == 0)
                {
                    _loc_4.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_SUCCESS);
                }
                else
                {
                    _loc_4.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_SUCCESS);
                }
            }
            else
            {
                if (_loc_3 == 0)
                {
                    _loc_4.addStatus(ContinuePlayDef.STATUS_PRE_ASK_VIDEO_LIST_FAILED);
                }
                else
                {
                    _loc_4.addStatus(ContinuePlayDef.STATUS_NEXT_ASK_VIDEO_LIST_FAILED);
                }
                return;
            }
            if (param1.getBody().before != undefined)
            {
                _loc_4.hasPreNeedLoad = String(param1.getBody().before) == "true";
            }
            if (param1.getBody().after != undefined)
            {
                _loc_4.hasNextNeedLoad = String(param1.getBody().after) == "true";
            }
            var _loc_11:int = 0;
            while (_loc_11 < _loc_5)
            {
                
                _loc_6 = _loc_2[_loc_11];
                _loc_7 = new ContinueInfo();
                _loc_7.loadMovieParams.tvid = _loc_6.tvid;
                _loc_7.loadMovieParams.vid = _loc_6.vid;
                _loc_7.loadMovieParams.movieIsMember = _loc_6.isMemberVideo == "true";
                _loc_7.loadMovieParams.albumId = _loc_6.albumId == undefined ? ("") : (_loc_6.albumId);
                _loc_7.imageURL = _loc_6.imageURL == undefined ? ("") : (_loc_6.imageURL);
                _loc_7.title = _loc_6.title == undefined ? ("") : (_loc_6.title);
                _loc_7.describe = _loc_6.describe == undefined ? ("") : (_loc_6.describe);
                _loc_7.channelID = _loc_6.channelId == undefined ? (0) : (_loc_6.channelId);
                _loc_7.exclusive = _loc_6.exclusive == undefined ? ("") : (_loc_6.exclusive);
                _loc_7.vfrm = _loc_6.vfrm == undefined ? ("") : (_loc_6.vfrm);
                _loc_7.canScore = _loc_6.canScore && _loc_6.canScore == 1 ? (true) : (false);
                _loc_7.qiyiProduced = _loc_6.qiyiProduced == undefined ? ("") : (_loc_6.qiyiProduced);
                if (_loc_10)
                {
                    _loc_7.publishTime = _loc_6.publishTime == undefined ? ("") : (_loc_6.publishTime);
                }
                if (_loc_6.isAd != undefined)
                {
                    _loc_7.isAdVideo = _loc_6.isAd == "true";
                }
                if (_loc_6.set == undefined || _loc_6.set == "")
                {
                    _loc_7.curSet = 0;
                }
                else
                {
                    _loc_7.curSet = int(_loc_6.set);
                }
                _loc_7.cupId = _loc_6.cid == undefined ? ("") : (_loc_6.cid);
                _loc_8[_loc_11] = _loc_7;
                _loc_11++;
            }
            _loc_4.addContinueInfoList(_loc_8, _loc_3);
            return;
        }// end function

    }
}
