package com.qiyi.player.base.logging.targets
{
    import com.qiyi.player.base.logging.*;

    public class LineFormattedTarget extends AbstractTarget
    {
        public var fieldSeparator:String = " ";
        public var includeCategory:Boolean;
        public var includeDate:Boolean;
        public var includeLevel:Boolean;
        public var includeTime:Boolean;

        public function LineFormattedTarget()
        {
            this.includeTime = false;
            this.includeDate = false;
            this.includeCategory = false;
            this.includeLevel = false;
            return;
        }// end function

        override public function logEvent(event:LogEvent) : void
        {
            var _loc_5:Date = null;
            var _loc_2:String = "";
            if (this.includeDate || this.includeTime)
            {
                _loc_5 = new Date();
                if (this.includeDate)
                {
                    _loc_2 = Number((_loc_5.getMonth() + 1)).toString() + "/" + _loc_5.getDate().toString() + "/" + _loc_5.getFullYear() + this.fieldSeparator;
                }
                if (this.includeTime)
                {
                    _loc_2 = _loc_2 + (this.padTime(_loc_5.getHours()) + ":" + this.padTime(_loc_5.getMinutes()) + ":" + this.padTime(_loc_5.getSeconds()) + "." + this.padTime(_loc_5.getMilliseconds(), true) + this.fieldSeparator);
                }
            }
            var _loc_3:String = "";
            if (this.includeLevel)
            {
                _loc_3 = "[" + LogEvent.getLevelString(event.level) + "]" + this.fieldSeparator;
            }
            var _loc_4:* = this.includeCategory ? (ILogger(event.target).category + this.fieldSeparator) : ("");
            this.internalLog(event.level, _loc_2 + _loc_3 + _loc_4 + event.message);
            return;
        }// end function

        private function padTime(param1:Number, param2:Boolean = false) : String
        {
            if (param2)
            {
                if (param1 < 10)
                {
                    return "00" + param1.toString();
                }
                if (param1 < 100)
                {
                    return "0" + param1.toString();
                }
                return param1.toString();
            }
            else
            {
            }
            return param1 > 9 ? (param1.toString()) : ("0" + param1.toString());
        }// end function

        protected function internalLog(param1:int, param2:String) : void
        {
            return;
        }// end function

    }
}
