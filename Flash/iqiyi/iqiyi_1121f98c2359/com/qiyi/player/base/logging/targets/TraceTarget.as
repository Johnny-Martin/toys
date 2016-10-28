package com.qiyi.player.base.logging.targets
{

    public class TraceTarget extends LineFormattedTarget
    {
        private var _flag:String;
        private var _logs:Array;

        public function TraceTarget(param1:String = "")
        {
            this._logs = [];
            this._flag = param1;
            return;
        }// end function

        override protected function internalLog(param1:int, param2:String) : void
        {
            this._logs.push(param2);
            if (this._logs.length > 3000)
            {
                this._logs.shift();
            }
            return;
        }// end function

        public function getLifeLogs() : Array
        {
            return this._logs;
        }// end function

    }
}
