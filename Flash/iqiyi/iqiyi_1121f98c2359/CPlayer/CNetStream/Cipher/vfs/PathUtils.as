package CPlayer.CNetStream.Cipher.vfs
{

    public class PathUtils extends Object
    {

        public function PathUtils()
        {
            return;
        }// end function

        public static function toCanonicalPath(param1:String) : String
        {
            var _loc_4:int = 0;
            var _loc_3:* = param1.replace(/\/""\//, "/");
            while (_loc_3 != param1)
            {
                
                param1 = _loc_3;
                _loc_3 = param1.replace(/\/""\//, "/");
            }
            var _loc_5:* = param1.split("/");
            var _loc_2:Array = [];
            _loc_4 = 0;
            while (_loc_4 < _loc_5.length)
            {
                
                if (_loc_5[_loc_4] == "..")
                {
                    if (_loc_2.length > 0)
                    {
                        _loc_2.pop();
                    }
                }
                else if (_loc_5[_loc_4].length != 0 && _loc_5[_loc_4] != ".")
                {
                    _loc_2.push(_loc_5[_loc_4]);
                }
                _loc_4 = _loc_4 + 1;
            }
            return "/" + _loc_2.join("/");
        }// end function

        public static function getDirectory(param1:String) : String
        {
            param1 = PathUtils.toCanonicalPath(param1);
            var _loc_2:* = param1.lastIndexOf("/");
            if (!_loc_2)
            {
                return "/";
            }
            return param1.substring(0, _loc_2);
        }// end function

    }
}
