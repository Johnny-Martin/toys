package com.qiyi.player.base.cookie
{
    import flash.utils.*;

    public class FixedLineCookie extends FixedBaseCookie
    {
        private var _maxLine:int = 0;
        private var _timeout:uint = 0;
        private var _updateDuration:int;
        private var _reverse:Boolean = false;

        public function FixedLineCookie(param1:String, param2:String, param3:int, param4:int, param5:int = 1000, param6:Boolean = false)
        {
            super(param1, param2, param3);
            this._reverse = param6;
            this._maxLine = param4;
            this._updateDuration = param5;
            if (_data == null || !(_data is Array))
            {
                _data = [];
                if (!_forbidden)
                {
                    _so.data[param2] = _data;
                    this.flush();
                }
            }
            return;
        }// end function

        override public function clear() : void
        {
            _data = [];
            if (_forbidden)
            {
                return;
            }
            super.flush();
            return;
        }// end function

        public function get lines() : Array
        {
            var _loc_1:* = data as Array;
            if (_loc_1 == null)
            {
                _loc_1 = [];
            }
            return _loc_1;
        }// end function

        override public function set data(param1:Object) : void
        {
            _data = param1;
            if (_data == null || !(_data is Array))
            {
                _data = [];
            }
            this.flush();
            return;
        }// end function

        public function push(param1:Object) : void
        {
            this.lines.push(param1);
            if (_forbidden)
            {
                return;
            }
            if (this._timeout == 0 && this._updateDuration > 0)
            {
                this._timeout = setTimeout(this.flush, this._updateDuration);
            }
            return;
        }// end function

        override public function destroy() : void
        {
            if (this._timeout)
            {
                clearTimeout(this._timeout);
            }
            this._timeout = 0;
            super.destroy();
            return;
        }// end function

        override public function flush() : void
        {
            if (_forbidden)
            {
                return;
            }
            if (this._timeout)
            {
                clearTimeout(this._timeout);
            }
            this._timeout = 0;
            if (this.lines == null)
            {
                return;
            }
            while (this.lines.length > this._maxLine || _so.size > _maxSize && this.lines.length)
            {
                
                if (this._reverse)
                {
                    this.lines.pop();
                    continue;
                }
                this.lines.shift();
            }
            super.flush();
            return;
        }// end function

    }
}
