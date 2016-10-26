package manager
{
    import control.*;

    public class CodeManager extends BaseCtrl
    {
        private var _codeA:Array;

        public function CodeManager()
        {
            this._codeA = new Array();
            return;
        }// end function

        public function addCode(param1:Number, param2:Boolean, param3:Number) : Boolean
        {
            var _loc_5:Number = NaN;
            var _loc_6:int = 0;
            var _loc_4:* = this._codeA.length;
            if (this._codeA.length == 0)
            {
                this._codeA.push({num:param1, code:0, isfrompeer:param2});
                return false;
            }
            if (this._codeA[(_loc_4 - 1)].isfrompeer != param2)
            {
                this.clearMth();
                this.addCode(param1, param2, param3);
            }
            else
            {
                _loc_5 = 0;
                if (param1 + param3 > this._codeA[(_loc_4 - 1)].num)
                {
                    _loc_5 = 1;
                }
                else if (param1 - param3 < this._codeA[(_loc_4 - 1)].num)
                {
                    _loc_5 = -1;
                }
                if (_loc_4 >= 10)
                {
                    _loc_6 = _loc_4;
                    while (_loc_6 >= 10)
                    {
                        
                        this._codeA.shift();
                        _loc_6 = _loc_6 - 1;
                    }
                }
                this._codeA.push({num:param1, code:_loc_5, isfrompeer:param2});
                if (_loc_4 > this._p2psohu.config.codeNum)
                {
                    return this.addAllCodeMth();
                }
            }
            return false;
        }// end function

        private function addAllCodeMth() : Boolean
        {
            var _loc_2:Object = null;
            var _loc_1:Number = 0;
            for each (_loc_2 in this._codeA)
            {
                
                _loc_1 = _loc_1 + _loc_2.code;
            }
            if (_loc_1 < this._p2psohu.config.codeNum * -1)
            {
                this.clearMth();
                this._p2psohu.showTestInfo("评分人为中断：   isfrompeer:" + _loc_2.isfrompeer);
                return true;
            }
            return false;
        }// end function

        public function clearMth() : void
        {
            this._codeA.splice(0);
            return;
        }// end function

    }
}
