package com.sohu.tv.mediaplayer.ui
{
    import flash.text.*;

    public class VerLog extends Object
    {
        private static var _logs:String = "";
        private static var _logsText:TextField;

        public function VerLog()
        {
            return;
        }// end function

        public static function msg(... args) : void
        {
            var _loc_3:String = null;
            args = 0;
            while (args < args.length)
            {
                
                _loc_3 = args[args] + "\n";
                _logs = _logs + _loc_3;
                if (_logsText != null)
                {
                    textAddContent(_loc_3);
                }
                args = args + 1;
            }
            return;
        }// end function

        public static function getMsg() : String
        {
            return _logs;
        }// end function

        private static function textAddContent(param1:String) : void
        {
            _logsText.appendText(param1);
            _logsText.scrollV = _logsText.maxScrollV - _logsText.scrollV + 1;
            return;
        }// end function

        public static function set logsText(param1:TextField) : void
        {
            _logsText = param1;
            textAddContent(_logs);
            return;
        }// end function

    }
}
