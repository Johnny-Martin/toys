package com
{
    import flash.utils.*;

    public class BaseMsg extends Object
    {
        public const HEADLENGTH:int = 14;
        public const MARK:uint = 844125523;
        public const RESERVED:uint = 0;
        public var opType:uint;

        public function BaseMsg()
        {
            return;
        }// end function

        protected function getHeader(param1:int, param2:uint) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            _loc_3.writeShort(param1 + this.HEADLENGTH);
            _loc_3.writeUnsignedInt(this.MARK);
            _loc_3.writeUnsignedInt(param2);
            _loc_3.writeUnsignedInt(this.RESERVED);
            return _loc_3;
        }// end function

        protected function getBody(param1:Array) : ByteArray
        {
            var _loc_5:ByteArray = null;
            var _loc_6:ByteArray = null;
            var _loc_7:ByteArray = null;
            var _loc_2:* = new ByteArray();
            var _loc_3:* = param1.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (param1[0] == "getway")
                {
                    if (_loc_4 != 0)
                    {
                        _loc_5 = new ByteArray();
                        _loc_5.writeMultiByte(param1[_loc_4], "us-ascii");
                        _loc_2.writeShort(_loc_5.length);
                        _loc_2.writeBytes(_loc_5);
                        break;
                    }
                }
                else if (param1[0] == "addfile" || param1[0] == "delfile")
                {
                    if (_loc_4 == 0)
                    {
                        _loc_2.writeUnsignedInt(1);
                    }
                    else if (_loc_4 == 1)
                    {
                        _loc_6 = new ByteArray();
                        _loc_6.writeMultiByte(param1[_loc_4], "us-ascii");
                        _loc_2.writeShort(_loc_6.length);
                        _loc_2.writeBytes(_loc_6);
                    }
                    else
                    {
                        _loc_2.writeUnsignedInt(param1[_loc_4]);
                    }
                }
                else if (param1[0] == "addstatic" && _loc_4 != 0)
                {
                    _loc_2.writeUnsignedInt(param1[_loc_4]);
                }
                else if (param1[0] == "addnat" && _loc_4 != 0)
                {
                    _loc_2.writeShort(param1[_loc_4]);
                }
                else if (_loc_4 != 0)
                {
                    if (param1[0] == "login")
                    {
                        if (_loc_4 == 4)
                        {
                            _loc_2.writeUnsignedInt(param1[4]);
                            ;
                        }
                        else if (_loc_4 > 4)
                        {
                            _loc_2.writeShort(param1[_loc_4]);
                            ;
                        }
                    }
                    _loc_7 = new ByteArray();
                    _loc_7.writeMultiByte(param1[_loc_4], "us-ascii");
                    _loc_2.writeShort(_loc_7.length);
                    _loc_2.writeBytes(_loc_7);
                }
                _loc_4++;
            }
            return _loc_2;
        }// end function

        public function P2P_PROC_SERIAL(param1:int) : uint
        {
            return param1 & 65535;
        }// end function

        public function P2P_PROC_PACKAGE(param1:int, param2:int, param3:int, param4:int) : uint
        {
            return param1 | param2 << 22 | param3 << 16 | this.P2P_PROC_SERIAL(param4);
        }// end function

    }
}
