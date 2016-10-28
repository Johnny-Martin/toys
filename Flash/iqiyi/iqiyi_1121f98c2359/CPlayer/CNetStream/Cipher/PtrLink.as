package CPlayer.CNetStream.Cipher
{

    class PtrLink extends Object
    {
        public const ptr:int = 0;
        public var next:PtrLink;

        function PtrLink(param1:int)
        {
            this.ptr = param1;
            return;
        }// end function

    }
}
