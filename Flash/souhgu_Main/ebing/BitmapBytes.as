package ebing
{
    import com.adobe.crypto.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class BitmapBytes extends Object
    {

        public function BitmapBytes()
        {
            throw new Error("BitmapBytes类只是一个静态类!");
        }// end function

        public static function encodeByteArray(param1:BitmapData) : ByteArray
        {
            if (param1 == null)
            {
                throw new Error("data参数不能为空!");
            }
            var _loc_2:* = param1.getPixels(param1.rect);
            _loc_2.writeShort(param1.width);
            _loc_2.writeShort(param1.height);
            _loc_2.writeBoolean(param1.transparent);
            _loc_2.compress();
            return _loc_2;
        }// end function

        public static function encodeBase64(param1:BitmapData) : String
        {
            return Base64.encodeByteArray(encodeByteArray(param1));
        }// end function

        public static function decodeByteArray(param1:ByteArray) : BitmapData
        {
            if (param1 == null)
            {
                throw new Error("bytes参数不能为空!");
            }
            param1.uncompress();
            if (param1.length < 6)
            {
                throw new Error("bytes参数为无效值!");
            }
            param1.position = param1.length - 1;
            var _loc_2:* = param1.readBoolean();
            param1.position = param1.length - 3;
            var _loc_3:* = param1.readShort();
            param1.position = param1.length - 5;
            var _loc_4:* = param1.readShort();
            param1.position = 0;
            var _loc_5:* = new ByteArray();
            param1.readBytes(_loc_5, 0, param1.length - 5);
            var _loc_6:* = new BitmapData(_loc_4, _loc_3, _loc_2, 0);
            new BitmapData(_loc_4, _loc_3, _loc_2, 0).setPixels(new Rectangle(0, 0, _loc_4, _loc_3), _loc_5);
            return _loc_6;
        }// end function

        public static function decodeBase64(param1:String) : BitmapData
        {
            return decodeByteArray(Base64.decodeToByteArray(param1));
        }// end function

    }
}
