package control
{
    import flash.display.*;

    public class BaseCtrl extends Sprite
    {
        protected var _p2psohu:P2pSohuLib;

        public function BaseCtrl()
        {
            return;
        }// end function

        public function set p2pSohuLib(param1:P2pSohuLib) : void
        {
            this._p2psohu = param1;
            return;
        }// end function

        public function get p2pSohuLib() : P2pSohuLib
        {
            return this._p2psohu;
        }// end function

    }
}
