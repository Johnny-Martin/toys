package util
{
    import flash.display.*;

    public class BaseSRPeer extends Sprite
    {
        protected var _fileo:Object;
        public var _newpeer:NewPeer;

        public function BaseSRPeer()
        {
            this._fileo = new Object();
            return;
        }// end function

        public function set fileo(param1:Object) : void
        {
            this._fileo = param1;
            return;
        }// end function

        public function set Peer(param1:NewPeer) : void
        {
            this._newpeer = param1;
            return;
        }// end function

        public function get fileo() : Object
        {
            return this._fileo;
        }// end function

    }
}
