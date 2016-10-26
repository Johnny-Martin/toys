package com.sohu.tv.mediaplayer.video
{
    import __AS3__.vec.*;
    import flash.net.*;

    public class TvSohuVideoInfo extends Object
    {
        private var stm:NetStream;
        private var renderStat:String = "unknown";
        private var color:String = "";
        private static var svdLen:int = -1;
        private static var colorSpace:Vector.<String> = new Vector.<String>;

        public function TvSohuVideoInfo()
        {
            return;
        }// end function

        public function getVideoFps() : int
        {
            return this.stm ? (this.stm.currentFPS) : (-1);
        }// end function

        public function getDropFrames() : int
        {
            return this.stm ? (this.stm.info.droppedFrames) : (-1);
        }// end function

        public function getKbps() : String
        {
            var _loc_1:int = 0;
            if (this.stm)
            {
                _loc_1 = this.stm.info.playbackBytesPerSecond / 1000 * 8;
                return _loc_1 + "";
            }
            return "-1";
        }// end function

        public function getColorSpace() : Vector.<String>
        {
            return colorSpace;
        }// end function

        public function getCurColor() : String
        {
            return this.color;
        }// end function

        public function getRenderStat() : String
        {
            return this.renderStat;
        }// end function

        public function getSvdLen() : int
        {
            return svdLen;
        }// end function

        public function dispose() : void
        {
            this.stm = null;
            return;
        }// end function

        protected function _updateTarget(param1:NetStream) : void
        {
            this.stm = param1;
            return;
        }// end function

        protected function _setRenderStat(param1:String) : void
        {
            this.renderStat = param1;
            return;
        }// end function

        protected function _setSvdLen(param1:int) : void
        {
            svdLen = param1;
            return;
        }// end function

        protected function _setCurColor(param1:String) : void
        {
            this.color = param1;
            return;
        }// end function

        protected function _setColorSpace(param1:Vector.<String>) : void
        {
            colorSpace = param1;
            return;
        }// end function

    }
}
