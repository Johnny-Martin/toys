package CPlayer.CNetStream.Cipher
{
    import flash.system.*;
    import flash.utils.*;

    public class BinaryData extends ByteArray
    {

        public function BinaryData()
        {
            var _loc_2:String = null;
            var _loc_9:String = null;
            var _loc_5:int = 0;
            var _loc_8:int = 0;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_3:int = 0;
            if (length)
            {
                return;
            }
            var _loc_6:* = CModule.describeType(this);
            var _loc_12:* = CModule.describeType(this)..metadata;
            var _loc_13:int = 0;
            var _loc_15:* = new XMLList("");
            for each (_loc_14 in _loc_12)
            {
                
                with (_loc_12[_loc_13])
                {
                    if (@name == "HexData")
                    {
                        _loc_15[_loc_13] = _loc_14;
                    }
                }
            }
            var _loc_1:* = _loc_15;
            for each (_loc_4 in _loc_1)
            {
                
                var _loc_16:* = _loc_20[_loc_21]..arg;
                var _loc_17:int = 0;
                _loc_12 = new XMLList("");
                for each (_loc_13 in _loc_16)
                {
                    
                    with (_loc_13)
                    {
                        if (@key == "")
                        {
                            _loc_12[_loc_17] = _loc_13;
                        }
                    }
                }
                _loc_2 = _loc_12;
                for each (_loc_7 in _loc_2)
                {
                    
                    _loc_9 = (_loc_18[_loc_19]).@value;
                    _loc_5 = _loc_9.length;
                    _loc_8 = 0;
                    while (_loc_8 < _loc_5)
                    {
                        
                        _loc_10 = _loc_9.charCodeAt(_loc_8);
                        _loc_11 = _loc_9.charCodeAt((_loc_8 + 1));
                        _loc_3 = 0;
                        if (_loc_10 < 58)
                        {
                            _loc_3 = _loc_10 - 48;
                        }
                        else if (_loc_10 < 71)
                        {
                            _loc_3 = 10 + (_loc_10 - 65);
                        }
                        else if (_loc_10 < 103)
                        {
                            _loc_3 = 10 + (_loc_10 - 97);
                        }
                        _loc_3 = _loc_3 * 16;
                        if (_loc_11 < 58)
                        {
                            _loc_3 = _loc_3 + (_loc_11 - 48);
                        }
                        else if (_loc_11 < 71)
                        {
                            _loc_3 = _loc_3 + (10 + (_loc_11 - 65));
                        }
                        else if (_loc_11 < 103)
                        {
                            _loc_3 = _loc_3 + (10 + (_loc_11 - 97));
                        }
                        writeByte(_loc_3);
                        _loc_8 = _loc_8 + 2;
                    }
                }
            }
            position = 0;
            try
            {
                System.disposeXML(_loc_6);
            }
            catch (error)
            {
            }
            _loc_6 = null;
            return;
        }// end function

    }
}
