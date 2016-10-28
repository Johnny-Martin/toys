package com.qiyi.player.core.model.utils
{
    import __AS3__.vec.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.player.coreplayer.*;

    public class Capturer extends Object implements IDestroy
    {
        private var _holder:CorePlayer;
        private static const Date_Flag:int = 20101026;

        public function Capturer(param1:CorePlayer)
        {
            this._holder = param1;
            return;
        }// end function

        public function getCaptureURL(param1:Number, param2:int) : String
        {
            return this.getUrl(this._holder.movie, param1, param2);
        }// end function

        private function getUrl(param1:IMovie, param2:Number, param3:int) : String
        {
            var _loc_5:Segment = null;
            var _loc_6:Vector.<Keyframe> = null;
            var _loc_7:int = 0;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Array = null;
            var _loc_4:String = "";
            if (param1 && param1.ready)
            {
                _loc_5 = param1.getSegmentByTime(param2);
                if (_loc_5)
                {
                    _loc_6 = _loc_5.getCaptureKeyFrames(param2);
                    _loc_7 = _loc_6.length;
                    if (_loc_7 > 0)
                    {
                        _loc_8 = 0;
                        _loc_9 = 0;
                        _loc_10 = 0;
                        if (_loc_7 == 1)
                        {
                            _loc_8 = _loc_6[0].position;
                            _loc_9 = _loc_5.totalBytes;
                            _loc_10 = param2 - _loc_6[0].time;
                        }
                        else if (_loc_7 == 2)
                        {
                            _loc_8 = _loc_6[0].position;
                            _loc_9 = _loc_6[1].position;
                            _loc_10 = param2 - _loc_6[0].time;
                        }
                        _loc_4 = _loc_5.url.replace(".f4v", ".jpg");
                        _loc_11 = _loc_4.split("/");
                        _loc_11[2] = Config.CAPTURE_URL;
                        _loc_4 = _loc_11.join("/") + "?";
                        _loc_4 = _loc_4 + ("start=" + _loc_8);
                        _loc_4 = _loc_4 + ("&end=" + _loc_9);
                        _loc_4 = _loc_4 + ("&time=" + _loc_10);
                        _loc_4 = _loc_4 + ("&mode=" + param3);
                    }
                }
            }
            return _loc_4;
        }// end function

        public function destroy() : void
        {
            return;
        }// end function

    }
}
