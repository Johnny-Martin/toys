package com.qiyi.player.components
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import gs.*;
    import gs.easing.*;

    dynamic public class DefaultLogo extends MovieClip
    {
        public var logo0:MovieClip;
        public var logo1:MovieClip;
        public var logo2:MovieClip;
        public var initLogo:int;
        public var fromLogo:int;
        public var timeOut:uint;
        public var logoArray:Array;
        public var timeLength:Array;
        public var i:Number;
        public var logoName:String;

        public function DefaultLogo()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        public function switchToNext() : void
        {
            clearTimeout(this.timeOut);
            if (this.initLogo == 2)
            {
                this.initLogo = 0;
                this.fromLogo = 2;
            }
            else
            {
                this.fromLogo = this.initLogo;
                var _loc_1:String = this;
                var _loc_2:* = this.initLogo + 1;
                _loc_1.initLogo = _loc_2;
            }
            this.dispatchEvent(new Event("qiyi_logo_changed"));
            this.switchLogo(this["logo" + this.fromLogo], this["logo" + this.initLogo]);
            return;
        }// end function

        public function switchLogo(param1:Sprite, param2:Sprite) : void
        {
            var logo1:* = param1;
            var logo2:* = param2;
            if (logo1 != null || logo2 != null)
            {
                try
                {
                    TweenLite.to(logo1, 1, {delay:0, alpha:0, ease:Linear.easeOut});
                    TweenLite.to(logo2, 1, {delay:0, alpha:1, ease:Linear.easeOut, onComplete:this.onComplete});
                }
                catch (e:Error)
                {
                    trace("error");
                }
            }
            return;
        }// end function

        public function onComplete() : void
        {
            this.timeOut = setTimeout(this.switchToNext, this.timeLength[this.initLogo]);
            return;
        }// end function

        function frame1()
        {
            this.initLogo = 0;
            this.fromLogo = 2;
            this.timeOut = 0;
            this.logoArray = new Array("logo0", "logo1", "logo2");
            this.timeLength = new Array(180000, 120000, 60000);
            this.i = 0;
            while (this.i < this.logoArray.length)
            {
                
                this.logoName = this.logoArray[this.i];
                this[this.logoName].alpha = 0;
                var _loc_1:String = this;
                var _loc_2:* = this.i + 1;
                _loc_1.i = _loc_2;
            }
            this.logo0.alpha = 1;
            this.timeOut = setTimeout(this.switchToNext, this.timeLength[this.initLogo]);
            return;
        }// end function

    }
}
