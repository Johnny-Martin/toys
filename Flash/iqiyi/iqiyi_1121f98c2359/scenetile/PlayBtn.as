package scenetile
{
    import flash.display.*;

    dynamic public class PlayBtn extends MovieClip
    {

        public function PlayBtn()
        {
            addFrameScript(0, this.frame1, 1, this.frame2);
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

    }
}
