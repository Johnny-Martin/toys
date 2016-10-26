package ebing.utils
{
    import flash.utils.*;

    public class HashMap extends Object
    {
        private var length:int;
        private var K102607B51541DE7D484BE68D809C6C53683D2A373570K:Dictionary;

        public function HashMap() : void
        {
            this.length = 0;
            this.K102607B51541DE7D484BE68D809C6C53683D2A373570K = new Dictionary();
            return;
        }// end function

        public function size() : int
        {
            return this.length;
        }// end function

        public function isEmpty() : Boolean
        {
            return this.length == 0;
        }// end function

        public function keys() : Array
        {
            var _loc_3:* = undefined;
            var _loc_1:* = new Array(this.length);
            var _loc_2:int = 0;
            for (_loc_3 in this.K102607B51541DE7D484BE68D809C6C53683D2A373570K)
            {
                
                _loc_1[_loc_2] = _loc_3;
                _loc_2++;
            }
            return _loc_1;
        }// end function

        public function values() : Array
        {
            var _loc_3:* = undefined;
            var _loc_1:* = new Array(this.length);
            var _loc_2:int = 0;
            for each (_loc_3 in this.K102607B51541DE7D484BE68D809C6C53683D2A373570K)
            {
                
                _loc_1[_loc_2] = _loc_3;
                _loc_2++;
            }
            return _loc_1;
        }// end function

        public function containValues(param1) : Boolean
        {
            var _loc_2:* = undefined;
            for each (_loc_2 in this.K102607B51541DE7D484BE68D809C6C53683D2A373570K)
            {
                
                if (_loc_2 === param1)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public function containsKey(param1) : Boolean
        {
            if (this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1] != undefined)
            {
                return true;
            }
            return false;
        }// end function

        public function getValue(param1)
        {
            var _loc_2:* = this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1];
            if (_loc_2 !== undefined)
            {
                return _loc_2;
            }
            return null;
        }// end function

        public function put(param1, param2)
        {
            var _loc_3:Boolean = false;
            var _loc_4:* = undefined;
            if (param1 == null)
            {
                return undefined;
            }
            if (param2 == null)
            {
                return this.remove(param1);
            }
            _loc_3 = this.containsKey(param1);
            if (!_loc_3)
            {
                var _loc_5:String = this;
                var _loc_6:* = this.length + 1;
                _loc_5.length = _loc_6;
            }
            _loc_4 = this.getValue(param1);
            this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1] = param2;
            return _loc_4;
        }// end function

        public function remove(param1)
        {
            var _loc_2:* = this.containsKey(param1);
            if (!_loc_2)
            {
                return null;
            }
            var _loc_3:* = this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1];
            delete this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[param1];
            var _loc_4:String = this;
            var _loc_5:* = this.length - 1;
            _loc_4.length = _loc_5;
            return _loc_3;
        }// end function

        public function clear() : void
        {
            this.length = 0;
            this.K102607B51541DE7D484BE68D809C6C53683D2A373570K = new Dictionary();
            return;
        }// end function

        public function clone() : HashMap
        {
            var _loc_2:* = undefined;
            var _loc_1:* = new HashMap();
            for (_loc_2 in this.K102607B51541DE7D484BE68D809C6C53683D2A373570K)
            {
                
                _loc_1.put(_loc_2, this.K102607B51541DE7D484BE68D809C6C53683D2A373570K[_loc_2]);
            }
            return _loc_1;
        }// end function

        public function toString() : String
        {
            var _loc_1:* = this.keys();
            var _loc_2:* = this.values();
            var _loc_3:String = "HashMap Content:\n";
            var _loc_4:int = 0;
            while (_loc_4 < _loc_1.length)
            {
                
                _loc_3 = _loc_3 + (_loc_1[_loc_4] + "->" + _loc_2[_loc_4] + "\n");
                _loc_4++;
            }
            return _loc_3;
        }// end function

    }
}
