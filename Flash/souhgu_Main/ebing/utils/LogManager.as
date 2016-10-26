package ebing.utils
{
    import flash.text.*;

    public class LogManager extends Object
    {
        private static var K10260742AC09AE6C564A588BC3336556E49389373570K:String = "";
        private static var K102607284B1F1523614314AE01CF7F584392B3373570K:TextField;

        public function LogManager()
        {
            return;
        }// end function

        public static function msg(... args) : void
        {
            var _loc_3:String = null;
            trace(args);
            args = 0;
            while (args < args.length)
            {
                
                _loc_3 = args[args] + "|" + new Date().toLocaleTimeString() + "\n";
                K10260742AC09AE6C564A588BC3336556E49389373570K = K10260742AC09AE6C564A588BC3336556E49389373570K + _loc_3;
                if (K102607284B1F1523614314AE01CF7F584392B3373570K != null)
                {
                    K10260712F745D019674DAD8B923083D78DA74A373570K(_loc_3);
                }
                args = args + 1;
            }
            return;
        }// end function

        public static function getMsg() : String
        {
            return K10260742AC09AE6C564A588BC3336556E49389373570K;
        }// end function

        private static function K10260712F745D019674DAD8B923083D78DA74A373570K(param1:String) : void
        {
            K102607284B1F1523614314AE01CF7F584392B3373570K.appendText(param1);
            K102607284B1F1523614314AE01CF7F584392B3373570K.scrollV = K102607284B1F1523614314AE01CF7F584392B3373570K.maxScrollV - K102607284B1F1523614314AE01CF7F584392B3373570K.scrollV + 1;
            return;
        }// end function

        public static function set logsText(param1:TextField) : void
        {
            K102607284B1F1523614314AE01CF7F584392B3373570K = param1;
            K10260712F745D019674DAD8B923083D78DA74A373570K(K10260742AC09AE6C564A588BC3336556E49389373570K);
            return;
        }// end function

    }
}
