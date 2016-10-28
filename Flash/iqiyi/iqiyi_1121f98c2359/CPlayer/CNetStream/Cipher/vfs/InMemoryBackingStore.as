package CPlayer.CNetStream.Cipher.vfs
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.utils.*;

    public class InMemoryBackingStore extends EventDispatcher implements IBackingStore
    {
        private var filemap:Object;

        public function InMemoryBackingStore()
        {
            filemap = {};
            return;
        }// end function

        public function get readOnly() : Boolean
        {
            return false;
        }// end function

        public function getPaths() : Vector.<String>
        {
            var _loc_1:* = new Vector.<String>;
            var _loc_4:int = 0;
            var _loc_3:* = filemap;
            while (_loc_3 in _loc_4)
            {
                
                _loc_1.push(_loc_3[_loc_4]);
            }
            return _loc_1;
        }// end function

        public function flush() : void
        {
            return;
        }// end function

        public function deleteFile(param1:String) : void
        {
            return;
        }// end function

        public function addFile(param1:String, param2:ByteArray) : void
        {
            filemap[param1] = param2;
            return;
        }// end function

        public function addDirectory(param1:String) : void
        {
            if (param1.lastIndexOf("/") == (param1.length - 1) && param1.length > 1)
            {
                param1 = param1.slice(0, (param1.length - 1));
            }
            filemap[param1] = null;
            return;
        }// end function

        public function getFile(param1:String) : ByteArray
        {
            return filemap[param1];
        }// end function

        public function isDirectory(param1:String) : Boolean
        {
            var _loc_2:* = filemap[param1] == null;
            return _loc_2;
        }// end function

        public function pathExists(param1:String) : Boolean
        {
            var _loc_2:* = filemap.hasOwnProperty(param1);
            return _loc_2;
        }// end function

    }
}
