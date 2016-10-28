package continueplay
{
    import flash.display.*;

    dynamic public class ContinueGridItem extends MovieClip
    {
        public var mask4:MovieClip;
        public var normalCover:MovieClip;
        public var blackBar:MovieClip;
        public var playingCover:MovieClip;
        public var mask0:MovieClip;
        public var mask2:MovieClip;

        public function ContinueGridItem()
        {
            addFrameScript(0, this.frame1, 1, this.frame2, 2, this.frame3, 3, this.frame4);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame2()
        {
            stop();
            return;
        }// end function

        function frame3()
        {
            stop();
            return;
        }// end function

        function frame4()
        {
            stop();
            return;
        }// end function

    }
}
