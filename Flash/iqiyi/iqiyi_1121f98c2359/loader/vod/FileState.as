package loader.vod
{

    public class FileState extends Object
    {
        private var _key:String;
        public static const FirstDispatch:uint = 10;
        public static const SecondDispatch:uint = 20;
        public static const AuthChecker:uint = 30;
        public static const AuthDispatch:uint = 40;
        public static const CDNRequest:uint = 50;
        public static var State_Success:uint = 0;
        public static var State_Timeout:uint = 1;
        public static var State_ConnectError:uint = 2;
        public static var State_DataError:uint = 3;
        public static var State_SecurityError:uint = 4;
        public static var State_AuthenticationError:uint = 5;
        public static var State_UnknownError:uint = 6;

        public function FileState(param1:String) : void
        {
            this._key = param1;
            return;
        }// end function

        public function get stateCode() : int
        {
            return this._data["stateCode"];
        }// end function

        public function get cdnUrl() : String
        {
            return this._data["cdnUrl"];
        }// end function

        public function get index() : uint
        {
            return this._data["segmentIndex"];
        }// end function

        public function get sourceID() : String
        {
            return this._data["sourceID"];
        }// end function

        public function get retryCount() : uint
        {
            return this._data["retryCount"];
        }// end function

        public function get averageSpeed() : int
        {
            return this._data["averageSpeed"];
        }// end function

        public function get data() : String
        {
            return this._data["data"];
        }// end function

        private function get _data() : Object
        {
            return P2PFileLoader.instance.get(this._key)["fileState"];
        }// end function

    }
}
