package com.qiyi.player.wonder.common.utils
{
    import flash.utils.*;

    public class ObjectPool extends Object
    {
        private var _pool:Dictionary;

        public function ObjectPool()
        {
            this._pool = new Dictionary(true);
            return;
        }// end function

        public function push(param1) : void
        {
            this._pool[param1] = null;
            return;
        }// end function

        public function pop() : Object
        {
            var _loc_1:Object = null;
            var _loc_2:* = undefined;
            for (_loc_2 in this._pool)
            {
                
                delete this._pool[_loc_2];
                return _loc_2;
            }
            return null;
        }// end function

        public function get length() : int
        {
            var _loc_2:* = undefined;
            var _loc_1:int = 0;
            for (_loc_2 in this._pool)
            {
                
                _loc_1++;
            }
            _loc_2 = null;
            return _loc_1;
        }// end function

    }
}
