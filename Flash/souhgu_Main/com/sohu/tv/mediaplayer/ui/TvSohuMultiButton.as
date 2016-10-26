package com.sohu.tv.mediaplayer.ui
{
    import ebing.controls.*;
    import flash.display.*;

    public class TvSohuMultiButton extends Sprite
    {
        protected var _enabled_boo:Boolean = true;
        private var _arrSkin:Array;
        private var _arrBtn:Array;
        private var _btnVisNum:Number = 0;

        public function TvSohuMultiButton(param1:Object)
        {
            this._arrSkin = new Array();
            this._arrBtn = new Array();
            this._arrSkin = param1.arrSkin;
            this.newFunc();
            this.drawSkin();
            this.addEvent();
            return;
        }// end function

        private function newFunc() : void
        {
            return;
        }// end function

        private function drawSkin() : void
        {
            var _loc_2:ButtonUtil = null;
            var _loc_1:int = 0;
            while (_loc_1 < this._arrSkin.length)
            {
                
                _loc_2 = new ButtonUtil({skin:this._arrSkin[_loc_1]});
                this._arrBtn.push(_loc_2);
                addChild(_loc_2);
                _loc_2.visible = false;
                _loc_1++;
            }
            return;
        }// end function

        private function addEvent() : void
        {
            return;
        }// end function

        public function set hasBtnVis(param1:int) : void
        {
            this._btnVisNum = param1;
            var _loc_2:int = 0;
            while (_loc_2 < this._arrBtn.length)
            {
                
                if (_loc_2 == param1)
                {
                    this._arrBtn[_loc_2].visible = true;
                }
                else
                {
                    this._arrBtn[_loc_2].visible = false;
                }
                _loc_2++;
            }
            return;
        }// end function

        public function onlyBtnEnabled(param1:int, param2:Boolean) : void
        {
            this._arrBtn[param1].enabled = param2;
            return;
        }// end function

        public function get btnVisNum() : Number
        {
            return this._btnVisNum;
        }// end function

        public function set enabled(param1:Boolean) : void
        {
            var _loc_2:int = 0;
            if (this._enabled_boo != param1)
            {
                this._enabled_boo = param1;
                if (param1)
                {
                    _loc_2 = 0;
                    while (_loc_2 < this._arrBtn.length)
                    {
                        
                        this._arrBtn[_loc_2].enabled = true;
                        _loc_2++;
                    }
                }
                else
                {
                    _loc_2 = 0;
                    while (_loc_2 < this._arrBtn.length)
                    {
                        
                        this._arrBtn[_loc_2].enabled = false;
                        _loc_2++;
                    }
                }
            }
            return;
        }// end function

        public function get enabled() : Boolean
        {
            return this._enabled_boo;
        }// end function

    }
}
