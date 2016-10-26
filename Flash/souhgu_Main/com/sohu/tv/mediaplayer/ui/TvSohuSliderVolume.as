package com.sohu.tv.mediaplayer.ui
{
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.*;
    import ebing.events.*;
    import flash.display.*;
    import flash.events.*;

    public class TvSohuSliderVolume extends TvSohuSliderSpeed
    {
        private var _mask_mc:Sprite;
        private var _topMcWidth:Number;
        private var _tempRate:Number = 0;
        private var _clickTimes:Number = 0;

        public function TvSohuSliderVolume(param1:Object)
        {
            super(param1);
            return;
        }// end function

        override protected function doSlide(param1:Number, param2:Number) : void
        {
            super.doSlide(param1, param2);
            _top_mc.width = _middle_mc.width;
            this._mask_mc.width = _dollop_btn.x + _dollop_btn.width / 2;
            if (_topRate_num == 0)
            {
                this._mask_mc.visible = false;
            }
            else
            {
                this._mask_mc.visible = true;
            }
            return;
        }// end function

        override protected function drawSkin() : void
        {
            this._mask_mc = new Sprite();
            Utils.drawRect(this._mask_mc, 0, 0, _middle_mc.width, _middle_mc.height, 16777215, 1);
            super.drawSkin();
            var _loc_1:* = Utils.getMaxWidth([_top_mc, _middle_mc, _bottom_mc, _dollop_btn, _hit_spr]);
            var _loc_2:* = Utils.getMaxHeight([_top_mc, _middle_mc, _bottom_mc, _dollop_btn, _hit_spr]);
            _container.addChild(_bottom_mc);
            _container.addChild(_middle_mc);
            _container.addChild(_top_mc);
            _container.addChild(this._mask_mc);
            _container.addChild(_hit_spr);
            _container.addChild(_dollop_btn);
            Utils.setCenterByNumber(_bottom_mc, _loc_1, _loc_2);
            Utils.setCenterByNumber(_middle_mc, _loc_1, _loc_2);
            Utils.setCenterByNumber(_dollop_btn, _loc_1, _loc_2);
            Utils.setCenterByNumber(_top_mc, _loc_1, _loc_2);
            Utils.setCenterByNumber(this._mask_mc, _loc_1, _loc_2);
            Utils.setCenterByNumber(_hit_spr, _loc_1, _loc_2);
            var _loc_3:int = 0;
            _hit_spr.x = 0;
            var _loc_3:* = _loc_3;
            _dollop_btn.x = _loc_3;
            var _loc_3:* = _loc_3;
            this._mask_mc.x = _loc_3;
            var _loc_3:* = _loc_3;
            _top_mc.x = _loc_3;
            var _loc_3:* = _loc_3;
            _middle_mc.x = _loc_3;
            _bottom_mc.x = _loc_3;
            _top_mc.mask = this._mask_mc;
            var _loc_3:* = this._mask_mc.width;
            _middle_mc.width = this._mask_mc.width;
            _top_mc.width = _loc_3;
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
            else if (++_time % 10 == 9 || param1)
            {
                if (_superRate < 5)
                {
                    _superRate = _superRate + 0.5;
                }
                dispatch(SliderEventUtil.SLIDER_RATE, {rate:_superRate, sign:1});
            }
            return;
        }// end function

        override protected function speedBack(param1:Boolean = false) : void
        {
            if (_seekNum == -1)
            {
                _seekNum = _dollop_btn.x + _dollop_btn.width / 2;
            }
            if (_topRate_num <= 1 && _superRate <= 1)
            {
                _superRate = 0.999999;
                _seekNum = param1 ? (_seekNum - 3) : ((_seekNum - 1));
                this.doSlide(_seekNum, 0);
            }
            else if (++_time % 10 == 9 || param1)
            {
                _superRate = _superRate - 0.5;
                if (_superRate <= 1)
                {
                    _superRate = 0.999999;
                    dispatch(SliderEventUtil.SLIDER_RATE, {rate:_topRate_num, sign:1});
                }
                else
                {
                    dispatch(SliderEventUtil.SLIDER_RATE, {rate:_superRate, sign:1});
                }
            }
            return;
        }// end function

        override public function set topRate(param1:Number) : void
        {
            super.topRate = param1;
            if (param1 >= 0 && param1 <= 1)
            {
                _topRate_num = param1;
                this._mask_mc.width = _topRate_num * (_bottom_mc.width - _dollop_btn.width) + _dollop_btn.width / 2;
                _dollop_btn.x = Math.floor(this._mask_mc.width - _dollop_btn.width / 2);
                _top_mc.width = _middle_mc.width;
                if (_topRate_num == 0)
                {
                    _top_mc.visible = false;
                }
                else
                {
                    _top_mc.visible = true;
                }
            }
            return;
        }// end function

        override protected function downHandler(param1:MouseEventUtil) : void
        {
            super.downHandler(param1);
            switch(param1.target)
            {
                case _dollop_btn:
                {
                    this._tempRate = _topRate_num;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override protected function upHandler(param1:MouseEventUtil) : void
        {
            super.upHandler(param1);
            switch(param1.target)
            {
                case _dollop_btn:
                {
                    if (_topRate_num - this._tempRate > 0)
                    {
                        SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_UpBar");
                    }
                    else if (_topRate_num - this._tempRate < 0)
                    {
                        SendRef.getInstance().sendPQVPC("fun_yangli205733_PL_C_DownBar");
                    }
                    this._tempRate = _topRate_num;
                    if (this._clickTimes < 2)
                    {
                        var _loc_2:String = this;
                        var _loc_3:* = this._clickTimes + 1;
                        _loc_2._clickTimes = _loc_3;
                    }
                    else
                    {
                        dispatchEvent(new Event("clickTimes"));
                        this._clickTimes = 0;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
