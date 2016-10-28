package com.qiyi.player.wonder.plugins.continueplay.controller
{
    import __AS3__.vec.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;

    public class RemoveVideoListCommand extends SimpleCommand
    {

        public function RemoveVideoListCommand()
        {
            return;
        }// end function

        override public function execute(param1:INotification) : void
        {
            var _loc_3:Array = null;
            var _loc_4:int = 0;
            var _loc_5:Object = null;
            var _loc_6:Vector.<String> = null;
            var _loc_7:Vector.<String> = null;
            var _loc_8:int = 0;
            super.execute(param1);
            var _loc_2:* = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
            if (param1.getBody() == null)
            {
                _loc_2.clearContinueInfo();
            }
            else
            {
                _loc_3 = param1.getBody().list as Array;
                if (_loc_3.length == 0)
                {
                    _loc_2.clearContinueInfo();
                }
                else
                {
                    _loc_4 = _loc_3.length;
                    _loc_5 = null;
                    _loc_6 = new Vector.<String>(_loc_4);
                    _loc_7 = new Vector.<String>(_loc_4);
                    _loc_8 = 0;
                    while (_loc_8 < _loc_4)
                    {
                        
                        _loc_5 = _loc_3[_loc_8];
                        _loc_6[_loc_8] = _loc_5.tvid;
                        _loc_7[_loc_8] = _loc_5.vid;
                        _loc_8++;
                    }
                    _loc_2.removeContinueInfoList(_loc_6, _loc_7);
                }
            }
            return;
        }// end function

    }
}
