package CPlayer.CNetStream.Cipher
{

    public class LongJmp extends Object
    {
        public var esp:int;
        public var sjid:int;
        public var retval:int;

        public function LongJmp(param1:int, param2:int, param3:int)
        {
            this.esp = param1;
            this.sjid = param2;
            this.retval = param3;
            return;
        }// end function

    }
}
