package com.qiyi.player.core.model.utils
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.logging.targets.*;
    import com.qiyi.player.core.*;
    import flash.system.*;

    public class LogManager extends Object
    {
        public static var _targets:Array = [];

        public function LogManager()
        {
            return;
        }// end function

        public static function initLog(param1:Boolean = true) : void
        {
            var _loc_2:LineFormattedTarget = null;
            _loc_2 = new TraceTarget();
            _loc_2.level = LogEventLevel.DEBUG;
            _loc_2.includeDate = true;
            _loc_2.includeTime = true;
            _loc_2.includeLevel = true;
            _targets.push(_loc_2);
            Log.addTarget(_loc_2);
            if (Capabilities.isDebugger)
            {
                _loc_2 = new DebugTarget();
                _loc_2.level = LogEventLevel.DEBUG;
                _loc_2.includeDate = true;
                _loc_2.includeTime = true;
                _loc_2.includeLevel = true;
                _targets.push(_loc_2);
                Log.addTarget(_loc_2);
            }
            else if (param1)
            {
                _loc_2 = new CookieTarget(Config.LOG_COOKIE, "logs", Config.MAX_LOG_COOKIE_SIZE, 400);
                _loc_2.level = LogEventLevel.INFO;
                _loc_2.includeDate = true;
                _loc_2.includeTime = true;
                _targets.push(_loc_2);
                Log.addTarget(_loc_2);
            }
            return;
        }// end function

        public static function getLifeLogs() : Array
        {
            var _loc_1:int = 0;
            while (_loc_1 < _targets.length)
            {
                
                if (_targets[_loc_1] is TraceTarget)
                {
                    return TraceTarget(_targets[_loc_1]).getLifeLogs();
                }
                _loc_1++;
            }
            return [];
        }// end function

        public static function setTargetFilters(param1:int, param2:Array) : void
        {
            var _loc_4:ILoggingTarget = null;
            var _loc_3:int = 0;
            while (_loc_3 < _targets.length)
            {
                
                _loc_4 = _targets[_loc_3];
                if (_loc_4.level == param1)
                {
                    _loc_4.filters = param2.slice();
                }
                _loc_3++;
            }
            return;
        }// end function

    }
}
