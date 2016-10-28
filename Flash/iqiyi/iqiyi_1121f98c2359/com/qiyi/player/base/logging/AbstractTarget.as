package com.qiyi.player.base.logging
{
    import com.qiyi.player.base.logging.errors.*;

    public class AbstractTarget extends Object implements ILoggingTarget
    {
        private var _loggerCount:uint = 0;
        private var _filters:Array;
        private var _level:int = 0;

        public function AbstractTarget()
        {
            this._filters = ["*"];
            return;
        }// end function

        public function get filters() : Array
        {
            return this._filters;
        }// end function

        public function set filters(param1:Array) : void
        {
            var _loc_2:String = null;
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:uint = 0;
            if (param1 && param1.length > 0)
            {
                _loc_5 = 0;
                while (_loc_5 < param1.length)
                {
                    
                    _loc_2 = param1[_loc_5];
                    if (Log.hasIllegalCharacters(_loc_2))
                    {
                        _loc_4 = "filters has invalide characters";
                        throw new InvalidFilterError(_loc_4);
                    }
                    _loc_3 = _loc_2.indexOf("*");
                    if (_loc_3 >= 0 && _loc_3 != (_loc_2.length - 1))
                    {
                        _loc_4 = "the \"*\" must be in the tail of filter";
                        throw new InvalidFilterError(_loc_4);
                    }
                    _loc_5 = _loc_5 + 1;
                }
            }
            else
            {
                param1 = ["*"];
            }
            if (this._loggerCount > 0)
            {
                Log.removeTarget(this);
                this._filters = param1;
                Log.addTarget(this);
            }
            else
            {
                this._filters = param1;
            }
            return;
        }// end function

        public function get level() : int
        {
            return this._level;
        }// end function

        public function set level(param1:int) : void
        {
            this._level = param1;
            return;
        }// end function

        public function addLogger(param1:ILogger) : void
        {
            if (param1)
            {
                var _loc_2:String = this;
                var _loc_3:* = this._loggerCount + 1;
                _loc_2._loggerCount = _loc_3;
                param1.addEventListener(LogEvent.LOG, this.logHandler);
            }
            return;
        }// end function

        public function removeLogger(param1:ILogger) : void
        {
            if (param1)
            {
                var _loc_2:String = this;
                var _loc_3:* = this._loggerCount - 1;
                _loc_2._loggerCount = _loc_3;
                param1.removeEventListener(LogEvent.LOG, this.logHandler);
            }
            return;
        }// end function

        public function initialized(param1:Object) : void
        {
            Log.addTarget(this);
            return;
        }// end function

        public function logEvent(event:LogEvent) : void
        {
            return;
        }// end function

        private function logHandler(event:LogEvent) : void
        {
            if (event.level >= this.level)
            {
                this.logEvent(event);
            }
            return;
        }// end function

    }
}
