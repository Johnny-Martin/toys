package CPlayer.CNetStream.Cipher
{
    import flash.utils.*;

    class ThunkMaker extends Object
    {
        private var modPkgName:String;
        private var thunkSet:Dictionary;
        private var start:int;
        private var end:int;
        private var index:int;

        function ThunkMaker(param1:String, param2:Dictionary, param3:int, param4:int, param5:int) : void
        {
            this.modPkgName = param1;
            this.thunkSet = param2;
            this.start = param3;
            this.end = param4;
            this.index = param5;
            return;
        }// end function

        public function thunk() : void
        {
            var _loc_1:int = 0;
            delete CModule.modThunks[modPkgName];
            var _loc_2:* = CModule.getModuleByPackage(modPkgName);
            _loc_2.getScript();
            _loc_1 = start;
            while (_loc_1 < end)
            {
                
                if (thunkSet[ptr2fun[_loc_1]])
                {
                    delete thunkSet[ptr2fun[_loc_1]];
                    ptr2fun[_loc_1] = null;
                }
                _loc_1++;
            }
            if (index >= 0)
            {
                ptr2fun.ptr2fun[index]();
            }
            return;
        }// end function

    }
}
