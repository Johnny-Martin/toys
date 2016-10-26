package httpSocket.utils
{

    public class HttpSocketUtil extends Object
    {
        private static const headLimitArr:Array = ["Host", "Accept"];

        public function HttpSocketUtil()
        {
            return;
        }// end function

        public static function checkAddItem(param1:String, param2:String) : Boolean
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            try
            {
                if (param1 == null || param1 == "")
                {
                    return false;
                }
                if (param2 == null || param2 == "")
                {
                    return false;
                }
                _loc_3 = 0;
                while (_loc_3 < headLimitArr.length)
                {
                    
                    _loc_4 = headLimitArr[_loc_3];
                    if (_loc_4 == param1)
                    {
                        return false;
                    }
                    _loc_3++;
                }
                return true;
            }
            catch (e:Error)
            {
            }
            return false;
        }// end function

    }
}
