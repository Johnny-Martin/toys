package mp4
{
    import flash.net.*;

    public class FLVTagScriptDataObject extends FLVTag
    {

        public function FLVTagScriptDataObject(param1:int = 18)
        {
            super(param1);
            return;
        }// end function

        public function get objects() : Array
        {
            bytes.objectEncoding = ObjectEncoding.AMF0;
            var _loc_1:* = new Array();
            bytes.position = TAG_HEADER_BYTE_COUNT;
            while (bytes.bytesAvailable)
            {
                
                _loc_1.push(bytes.readObject());
            }
            return _loc_1;
        }// end function

        public function set objects(param1:Array) : void
        {
            var _loc_2:Object = null;
            bytes.objectEncoding = ObjectEncoding.AMF0;
            bytes.length = TAG_HEADER_BYTE_COUNT;
            bytes.position = TAG_HEADER_BYTE_COUNT;
            for each (_loc_2 in param1)
            {
                
                bytes.writeObject(_loc_2);
            }
            dataSize = bytes.length - TAG_HEADER_BYTE_COUNT;
            return;
        }// end function

    }
}
