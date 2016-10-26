package ebing.utils
{
    import flash.events.*;
    import flash.net.*;

    public class Srt extends Object
    {
        private var K1026087DB5D46CF00E4946ADD70064900AD34A373571K:Array;
        private var K102608C9867403C3624E3DBD55A89C02AEF5A4373571K:uint = 0;
        private var K102608811AE68541504F3689CC25511821DD95373571K:uint = 0;
        private var K10260876D4B11921C04F57B20712418C68CA54373571K:String = "";

        public function Srt()
        {
            this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K = new Array();
            return;
        }// end function

        public function loadSrtFile(param1:String) : void
        {
            var _loc_2:* = new URLRequest(param1);
            var _loc_3:* = new URLLoader();
            _loc_3.addEventListener(Event.COMPLETE, this.K102608F763F30B2D3E4538A2377E80D8A641EF373571K);
            _loc_3.load(_loc_2);
            return;
        }// end function

        private function K102608F763F30B2D3E4538A2377E80D8A641EF373571K(event:Event) : void
        {
            var _loc_4:String = null;
            var _loc_5:RegExp = null;
            var _loc_6:Object = null;
            var _loc_7:Object = null;
            var _loc_2:* = URLLoader(event.target);
            var _loc_3:* = _loc_2.data;
            if (_loc_3 != "")
            {
                _loc_4 = "\\d+\\r\\n(\\d{2}:\\d{2}:\\d{2},\\d{3}) --> (\\d{2}:\\d{2}:\\d{2},\\d{3})\\r\\n(.*?)\\r\\n\\r\\n";
                _loc_5 = new RegExp(_loc_4, "gism");
                _loc_6 = null;
                while (true)
                {
                    
                    _loc_6 = _loc_5.exec(_loc_3);
                    if (_loc_6 != null)
                    {
                        _loc_7 = {bt:this.K10260846A3B017889B42E4A7628EBBBC26469B373571K(_loc_6[1]), et:this.K10260846A3B017889B42E4A7628EBBBC26469B373571K(_loc_6[2]), txt:_loc_6[3]};
                        this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K.push(_loc_7);
                        continue;
                    }
                    break;
                }
            }
            return;
        }// end function

        public function get hasData() : Boolean
        {
            var _loc_1:Boolean = false;
            if (this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K != null && this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K.length > 0)
            {
                _loc_1 = true;
            }
            return _loc_1;
        }// end function

        private function K10260846A3B017889B42E4A7628EBBBC26469B373571K(param1:String) : uint
        {
            var _loc_3:Array = null;
            var _loc_4:uint = 0;
            var _loc_5:Array = null;
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_2:uint = 0;
            if (param1 != "")
            {
                _loc_3 = param1.split(",");
                _loc_4 = parseInt(_loc_3[1]);
                _loc_5 = _loc_3[0].split(":");
                _loc_6 = parseInt(_loc_5[0]);
                _loc_7 = parseInt(_loc_5[1]);
                _loc_8 = parseInt(_loc_5[2]);
                _loc_2 = _loc_2 + _loc_8 * 1000;
                _loc_2 = _loc_2 + _loc_7 * 60 * 1000;
                _loc_2 = _loc_2 + _loc_6 * 60 * 60 * 1000;
                _loc_2 = _loc_2 + _loc_4;
            }
            return _loc_2;
        }// end function

        public function getText(param1:uint) : String
        {
            var _loc_4:Object = null;
            var _loc_2:String = "";
            if (param1 < this.K102608C9867403C3624E3DBD55A89C02AEF5A4373571K)
            {
                this.K102608811AE68541504F3689CC25511821DD95373571K = 0;
            }
            var _loc_3:* = this.K102608811AE68541504F3689CC25511821DD95373571K;
            while (_loc_3 < this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K.length)
            {
                
                _loc_4 = this.K1026087DB5D46CF00E4946ADD70064900AD34A373571K[_loc_3];
                if (_loc_4.bt <= param1 && param1 <= _loc_4.et)
                {
                    _loc_2 = _loc_4.txt;
                    this.K102608C9867403C3624E3DBD55A89C02AEF5A4373571K = _loc_4.bt;
                    this.K102608811AE68541504F3689CC25511821DD95373571K = _loc_3;
                    break;
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

    }
}
