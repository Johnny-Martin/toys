package com.sohu.tv.mediaplayer.ui
{
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.controls.*;
    import ebing.events.*;
    import flash.display.*;
    import flash.events.*;

    public class TvSohuSliderSpeed extends SliderSpeed
    {
        protected var _superRate:Number = 1;
        protected var _time:Number = 0;
        private var _rateTextBar:MovieClip;
        private var _parObj:Object;
        private var _isDivision:Boolean;
        private var _sendPQ:Object;

        public function TvSohuSliderSpeed(param1:Object)
        {
            this._parObj = param1;
            this._isDivision = param1.isDivision;
            this._sendPQ = param1.sendPQ;
            super(param1);
            return;
        }// end function

        override protected function doSlide(param1:Number, param2:Number) : void
        {
            super.doSlide(param1, param2);
            this._superRate = 1;
            this.setRateText(topRate);
            return;
        }// end function

        private function setRateText(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:int = 0;
            if (this._rateTextBar != null)
            {
                _loc_2 = 0;
                if (this._isDivision)
                {
                    _loc_2 = (param1 - 1) * 2 + 1;
                }
                else
                {
                    _loc_2 = param1;
                }
                _loc_3 = Math.round(_loc_2 * 100);
                this._rateTextBar["rate_txt"].text = _loc_3 > 0 ? ("+" + _loc_3) : (_loc_3);
            }
            return;
        }// end function

        override protected function addEvent() : void
        {
            super.addEvent();
            this.addEventListener(FocusEvent.FOCUS_IN, this.onFocusIn);
            this.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusOut);
            return;
        }// end function

        private function onFocusIn(event:FocusEvent) : void
        {
            if (this._rateTextBar != null)
            {
                this._rateTextBar.gotoAndStop(2);
                this._rateTextBar["rate_txt"].textColor = 16777215;
            }
            return;
        }// end function

        private function onFocusOut(event:FocusEvent) : void
        {
            if (this._rateTextBar != null)
            {
                this._rateTextBar.gotoAndStop(1);
                this._rateTextBar["rate_txt"].textColor = 16777215;
            }
            return;
        }// end function

        override protected function drawSkin() : void
        {
            super.drawSkin();
            if (this._parObj.skin != null && this._parObj.skin.rateTextMc != null && this._parObj.skin.rateTextMc != undefined)
            {
                this._rateTextBar = this._parObj.skin.rateTextMc;
                this._rateTextBar.x = this.width + 1;
                this._rateTextBar.y = _container.y;
                this._rateTextBar.gotoAndStop(1);
                addChild(this._rateTextBar);
            }
            return;
        }// end function

        override protected function speedForward(param1:Boolean = false) : void
        {
            if (_seekNum == -1)
            {
                _seekNum = _dollop_btn.x + _dollop_btn.width / 2;
            }
            if (_topRate_num < 1)
            {
                _seekNum = param1 ? (_seekNum + 3) : ((_seekNum + 1));
                this.doSlide(_seekNum, 0);
            }
            else
            {
                var _loc_2:String = this;
                _loc_2._time = this._time + 1;
                if (++this._time % 10 == 9 || param1)
                {
                    this._superRate = this._superRate + 0.5;
                    dispatch(SliderEventUtil.SLIDER_RATE, {rate:this._superRate, sign:1});
                }
            }
            return;
        }// end function

        override protected function speedBack(param1:Boolean = false) : void
        {
            if (_seekNum == -1)
            {
                _seekNum = _dollop_btn.x + _dollop_btn.width / 2;
            }
            if (_topRate_num < 1)
            {
                _seekNum = param1 ? (_seekNum - 3) : ((_seekNum - 1));
                this.doSlide(_seekNum, 0);
            }
            else
            {
                var _loc_2:String = this;
                _loc_2._time = this._time + 1;
                if (++this._time % 10 == 9 || param1)
                {
                    this._superRate = this._superRate - 0.5;
                    if (this._superRate < 1)
                    {
                        var _loc_2:Number = 0.999999;
                        this._superRate = 0.999999;
                        _topRate_num = _loc_2;
                    }
                    dispatch(SliderEventUtil.SLIDER_RATE, {rate:this._superRate, sign:1});
                }
            }
            return;
        }// end function

        override protected function upHandler(param1:MouseEventUtil) : void
        {
            super.upHandler(param1);
            if (this._sendPQ != null)
            {
                switch(param1.target)
                {
                    case _forward_btn:
                    {
                        if (this._sendPQ.forward != null && this._sendPQ.forward != "")
                        {
                            SendRef.getInstance().sendPQVPC(this._sendPQ.forward);
                        }
                        break;
                    }
                    case _back_btn:
                    {
                        if (this._sendPQ.back != null && this._sendPQ.back != "")
                        {
                            SendRef.getInstance().sendPQVPC(this._sendPQ.back);
                        }
                        break;
                    }
                    case _dollop_btn:
                    {
                        if (this._sendPQ.dollop != null && this._sendPQ.dollop != "")
                        {
                            SendRef.getInstance().sendPQVPC(this._sendPQ.dollop);
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        override public function set topRate(param1:Number) : void
        {
            super.topRate = param1;
            this.setRateText(topRate);
            return;
        }// end function

        public function get superRate() : Number
        {
            return this._superRate;
        }// end function

        public function set superRate(param1:Number) : void
        {
            this._superRate = param1;
            return;
        }// end function

    }
}
