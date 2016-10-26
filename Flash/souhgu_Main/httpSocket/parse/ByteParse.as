package httpSocket.parse
{
    import flash.utils.*;

    public class ByteParse extends Object
    {

        public function ByteParse()
        {
            return;
        }// end function

        public static function parseHead(param1:ByteArray) : Array
        {
            var strEnd:String;
            var headNew:ByteArray;
            var file:ByteArray;
            var l:int;
            var len:int;
            var nPos:int;
            var btaEnd:ByteArray;
            var strGet:String;
            var ba:* = param1;
            try
            {
                strEnd;
                headNew = new ByteArray();
                file = new ByteArray();
                ba.position = 0;
                l;
                len = ba.length > 1024 ? (1024) : (ba.length);
                while (ba.position < len)
                {
                    
                    nPos = ba.position;
                    btaEnd = new ByteArray();
                    ba.readBytes(btaEnd, 0, l);
                    ba.position = 0;
                    strGet = btaEnd.readUTFBytes(l);
                    btaEnd.position = 0;
                    if (strGet == strEnd)
                    {
                        ba.position = 0;
                        ba.readBytes(headNew, 0, nPos + l);
                        ba.readBytes(file, 0, ba.bytesAvailable);
                        btaEnd.clear();
                        strGet;
                        return [headNew, file];
                    }
                    ba.position = nPos + 1;
                    btaEnd.clear();
                    strGet;
                }
            }
            catch (e:Error)
            {
                return null;
            }
            return null;
        }// end function

    }
}
