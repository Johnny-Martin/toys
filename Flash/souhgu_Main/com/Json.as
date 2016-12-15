package com
{

    public class Json extends Object
    {

        public function Json()
        {
            return;
        }// end function

        public static function decode(param1:String) : Object
        {
            var _loc_2:RegExp = null;
            var _loc_3:String = null;
            var _loc_4:Array = null;
            var _loc_5:Object = null;
            var _loc_6:String = null;
            if (param1.substr(0, 1) == "[")
            {
                _loc_2 = /},{""},{/g;
                _loc_3 = param1.substring(1, (param1.length - 1)).replace(_loc_2, "}]{");
                _loc_4 = _loc_3.split("]");
                _loc_5 = new Object();
                _loc_5.cdnlista = new Array();
                for each (_loc_6 in _loc_4)
                {
                    
                    _loc_5.cdnlista.push(decodeDetailMth(_loc_6));
                }
                return _loc_5;
            }
            else
            {
                return decodeDetailMth(param1);
            }
        }// end function

        private static function decodeDetailMth(param1:String) : Object
        {
            var _loc_5:String = null;
            var _loc_6:Array = null;
            var _loc_7:String = null;
            if (param1.substr(0, 1) != "{")
            {
                return null;
            }
            var _loc_2:* = new Object();
            var _loc_3:* = param1.substring(1, (param1.length - 1));
            var _loc_4:* = _loc_3.split(",");
            for each (_loc_5 in _loc_4)
            {
                
                _loc_6 = _loc_5.split("\":\"");
                _loc_7 = _loc_6[0].substring(1, _loc_6[0].length);
                _loc_2[_loc_7] = String(_loc_6[1].substring(0, (_loc_6[1].length - 1)));
            }
            return _loc_2;
        }// end function

        public static function encode(param1:Object) : String
        {
            var _loc_2:String = "";
            return _loc_2;
        }// end function

    }
}
