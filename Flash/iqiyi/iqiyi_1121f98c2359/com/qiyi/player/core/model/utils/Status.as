package com.qiyi.player.core.model.utils
{
    import __AS3__.vec.*;

    public class Status extends Object
    {
        private var _statusVector:Vector.<Boolean>;
        private var _begin:int;
        private var _end:int;

        public function Status(param1:int, param2:int)
        {
            this._begin = param1;
            this._end = param2;
            this._statusVector = new Vector.<Boolean>(this._end);
            var _loc_3:int = 0;
            while (_loc_3 < this._end)
            {
                
                this._statusVector[_loc_3] = false;
                _loc_3++;
            }
            return;
        }// end function

        public function addStatus(param1:int) : void
        {
            if (param1 >= this._begin && param1 < this._end)
            {
                this._statusVector[param1] = true;
            }
            return;
        }// end function

        public function removeStatus(param1:int) : void
        {
            if (param1 >= this._begin && param1 < this._end)
            {
                this._statusVector[param1] = false;
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            if (param1 >= this._begin && param1 < this._end)
            {
                return this._statusVector[param1];
            }
            return false;
        }// end function

        public function clone() : Status
        {
            var _loc_1:* = new Status(this._begin, this._end);
            var _loc_2:* = this._begin;
            while (_loc_2 < this._end)
            {
                
                if (this.hasStatus(_loc_2))
                {
                    _loc_1.addStatus(_loc_2);
                }
                else
                {
                    _loc_1.removeStatus(_loc_2);
                }
                _loc_2++;
            }
            return _loc_1;
        }// end function

    }
}
