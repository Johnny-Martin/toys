package CPlayer.CNetStream.Cipher.vfs
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class DefaultVFS extends Object implements IVFS
    {
        private var _bslist:Array;
        private var _fdTable:Array;
        private var _specialFileTable:Object;
        private const consolePath:String = "/dev/tty";

        public function DefaultVFS()
        {
            _bslist = [];
            _fdTable = [null, null, null];
            _specialFileTable = {};
            addBackingStore(new InMemoryBackingStore(), null);
            return;
        }// end function

        private function getBackingStoreForPath(param1:String) : Object
        {
            var _loc_2:int = 0;
            param1 = PathUtils.toCanonicalPath(param1);
            _loc_2 = 0;
            while (_loc_2 < _bslist.length)
            {
                
                if (_bslist[_loc_2].prefix.substr(1) == param1.substr(1, (_bslist[_loc_2].prefix.length - 1)))
                {
                    return {store:_bslist[_loc_2].store, path:PathUtils.toCanonicalPath(param1.substr(_bslist[_loc_2].prefix.length))};
                }
                _loc_2++;
            }
            return null;
        }// end function

        private function getPrefixForBackingStore(param1:IBackingStore) : String
        {
            var _loc_2:int = 0;
            _loc_2 = 0;
            while (_loc_2 < _bslist.length)
            {
                
                if (_bslist[_loc_2].store === param1)
                {
                    return _bslist[_loc_2].prefix;
                }
                _loc_2++;
            }
            return null;
        }// end function

        public function addBackingStore(param1:IBackingStore, param2:String) : void
        {
            bs = param1;
            prefix = param2;
            if (!prefix)
            {
                var prefix:String;
            }
            prefix = PathUtils.toCanonicalPath(prefix);
            var bsdesc:Object;
            if (prefix != "/")
            {
                var a:* = getDirectoryEntries(prefix);
                if (!a || a.length)
                {
                    throw new Error("prefix \'" + prefix + "\' must be an empty directory");
                }
                _bslist.push(bsdesc);
            }
            else
            {
                _bslist = [bsdesc];
            }
            _bslist.sort(function (param1, param2)
            {
                return param2.prefix.length - param1.prefix.length;
            }// end function
            );
            if (!getFileHandleFromPath(prefix))
            {
                addDirectory(prefix);
            }
            return;
        }// end function

        public function addFile(param1:String, param2:ByteArray) : void
        {
            if (!param2)
            {
                throw new Error("data may not be null");
            }
            addFileImpl(param1, param2);
            return;
        }// end function

        public function addDirectory(param1:String) : void
        {
            addFileImpl(param1, null);
            return;
        }// end function

        private function addFileImpl(param1:String, param2:ByteArray) : void
        {
            param1 = PathUtils.toCanonicalPath(param1);
            if (getFileHandleFromPath(param1))
            {
                throw new Error("cannot create \'" + param1 + "\', file exists");
            }
            var _loc_3:* = getBackingStoreForPath(param1);
            if (param2)
            {
                _loc_3.store.addFile(_loc_3.path, param2);
            }
            else
            {
                _loc_3.store.addDirectory(_loc_3.path);
            }
            return;
        }// end function

        public function deleteFile(param1:String) : void
        {
            var _loc_2:* = getFileHandleFromPath(param1);
            if (!_loc_2)
            {
                throw new Error("cannot delete \'" + param1 + "\', file does not exist");
            }
            if (_loc_2.isDirectory && getDirectoryEntries(param1).length)
            {
                throw new Error("cannot delete \'" + param1 + "\', directory not empty");
            }
            _loc_2.backingStore.deleteFile(_loc_2.backingStoreRelativePath);
            return;
        }// end function

        public function set console(param1:ISpecialFile) : void
        {
            if (_fdTable[0])
            {
                closeFile(0);
            }
            if (_fdTable[1])
            {
                closeFile(1);
            }
            if (_fdTable[2])
            {
                closeFile(2);
            }
            addSpecialFile("/dev/tty", param1);
            var _loc_2:* = getFileHandleFromPath("/dev/tty");
            _fdTable[0] = _loc_2;
            _fdTable[1] = _loc_2;
            _fdTable[2] = _loc_2;
            return;
        }// end function

        public function get console() : ISpecialFile
        {
            var _loc_1:* = getFileHandleFromPath("/dev/tty");
            return _loc_1.callback;
        }// end function

        public function addSpecialFile(param1:String, param2:ISpecialFile) : void
        {
            var _loc_3:* = FileHandle.makeSpecialFile(param2);
            _specialFileTable[param1] = _loc_3;
            return;
        }// end function

        public function getDirectoryEntries(param1:String) : Vector.<FileHandle>
        {
            var _loc_3:* = getFileHandleFromPath(param1);
            if (!_loc_3 || !_loc_3.isDirectory)
            {
                return null;
            }
            var _loc_2:* = new Vector.<FileHandle>;
            var _loc_5:* = _loc_3.backingStoreRelativePath + "/";
            var _loc_6:* = getPrefixForBackingStore(_loc_3.backingStore);
            for each (_loc_7 in _loc_3.backingStore.getPaths())
            {
                
                if (_loc_9[_loc_10] && _loc_7.substr(0, _loc_5.length) == _loc_5 && _loc_7.length > _loc_5.length)
                {
                    var _loc_4:* = _loc_7.substr((_loc_3.backingStoreRelativePath.length + 1));
                    if (_loc_7.substr((_loc_3.backingStoreRelativePath.length + 1)).indexOf("/") == -1)
                    {
                        _loc_2.push(getFileHandleFromPath(_loc_6 + "/" + _loc_7));
                    }
                }
            }
            return _loc_2;
        }// end function

        public function getFileHandleFromPath(param1:String) : FileHandle
        {
            param1 = PathUtils.toCanonicalPath(param1);
            if (_specialFileTable.hasOwnProperty(param1))
            {
                return _specialFileTable[param1];
            }
            var _loc_2:* = getBackingStoreForPath(param1);
            var _loc_3:* = _loc_2.store;
            if (!_loc_2)
            {
                return null;
            }
            if (_loc_3.pathExists(_loc_2.path))
            {
                return FileHandle.makeRegularFile(param1, _loc_2.path, _loc_3, _loc_3.getFile(_loc_2.path), _loc_3.isDirectory(_loc_2.path));
            }
            return null;
        }// end function

        public function checkPath(param1:String) : String
        {
            var _loc_3:String = null;
            var _loc_2:String = "pathValid";
            param1 = PathUtils.toCanonicalPath(param1);
            while (param1 != "/")
            {
                
                param1 = PathUtils.getDirectory(param1);
                _loc_3 = getFileHandleFromPath(param1);
                if (!_loc_3)
                {
                    _loc_2 = "pathComponentDoesNotExist";
                    break;
                }
                if (!_loc_3.isDirectory)
                {
                    _loc_2 = "pathComponentIsNotDirectory";
                    break;
                }
            }
            return _loc_2;
        }// end function

        public function openFile(param1:FileHandle, param2:int = -1) : int
        {
            if (param2 == -1)
            {
                return (_fdTable.push(param1) - 1);
            }
            _fdTable[param2] = param1;
            return param2;
        }// end function

        public function closeFile(param1:int) : void
        {
            if (_fdTable[param1].backingStore)
            {
                _fdTable[param1].backingStore.flush();
            }
            _fdTable[param1] = null;
            return;
        }// end function

        public function isValidFileDescriptor(param1:int) : Boolean
        {
            return param1 >= 0 && param1 < _fdTable.length && _fdTable[param1];
        }// end function

        public function getFileHandleFromFileDescriptor(param1:int) : FileHandle
        {
            if (isValidFileDescriptor(param1))
            {
                return _fdTable[param1];
            }
            return null;
        }// end function

    }
}
