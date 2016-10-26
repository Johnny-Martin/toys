package control
{
    import flash.display.*;
    import manager.*;

    public class BaseLoader extends Sprite
    {
        protected var _loadermang:LoaderManager;

        public function BaseLoader()
        {
            return;
        }// end function

        public function get loadermang() : LoaderManager
        {
            return this._loadermang;
        }// end function

        public function set loadermang(param1:LoaderManager) : void
        {
            this._loadermang = param1;
            return;
        }// end function

    }
}
