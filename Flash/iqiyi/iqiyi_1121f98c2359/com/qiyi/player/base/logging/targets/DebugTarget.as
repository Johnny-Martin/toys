package com.qiyi.player.base.logging.targets
{
    import com.qiyi.player.base.logging.*;

    public class DebugTarget extends LineFormattedTarget
    {
        private var _flag:String;

        public function DebugTarget(param1:String = "")
        {
            this._flag = param1;
            return;
        }// end function

        override protected function internalLog(param1:int, param2:String) : void
        {
            switch(param1)
            {
                case LogEventLevel.WARN:
                {
                    Debug.warning(param2);
                    break;
                }
                case LogEventLevel.ERROR:
                case LogEventLevel.FATAL:
                {
                    Debug.error(param2);
                    break;
                }
                default:
                {
                    Debug.log(param2);
                    break;
                }
            }
            return;
        }// end function

    }
}
