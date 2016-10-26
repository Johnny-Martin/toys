package server
{
    import com.*;
    import control.*;
    import flash.utils.*;

    public class BaseSocketSohu extends BaseCtrl
    {
        public var socket:HaleSocket;
        protected var _oldba:ByteArray;
        protected var _backba:ByteArray;
        protected var _isBigLen:Boolean = false;
        private var _idx:int = 0;
        protected var _baA:Array;

        public function BaseSocketSohu() : void
        {
            this._oldba = new ByteArray();
            this._backba = new ByteArray();
            this._baA = new Array();
            return;
        }// end function

        protected function backMsgLenMth(param1:ByteArray) : Boolean
        {
            var _loc_3:ByteArray = null;
            var _loc_4:ByteArray = null;
            param1.readBytes(this._oldba, this._oldba.length, param1.bytesAvailable);
            param1.clear();
            this._oldba.position = 0;
            if (this._oldba.length < 2)
            {
                return false;
            }
            var _loc_2:* = this._oldba.readUnsignedShort();
            this._baA.splice(0);
            if (this._oldba.length > _loc_2)
            {
                trace("=");
            }
            while (this._oldba.length >= _loc_2)
            {
                
                this._isBigLen = true;
                _loc_3 = new ByteArray();
                this._oldba.position = 0;
                this._oldba.readBytes(_loc_3, 0, _loc_2);
                this._baA.push(_loc_3);
                _loc_4 = new ByteArray();
                this._oldba.readBytes(_loc_4, 0, this._oldba.bytesAvailable);
                this._oldba.clear();
                this._oldba = _loc_4;
                if (this._oldba.length != 0)
                {
                    _loc_2 = this._oldba.readUnsignedShort();
                }
            }
            if (this._baA.length > 0)
            {
                return true;
            }
            return false;
        }// end function

    }
}
