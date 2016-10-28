package com.qiyi.player.wonder.plugins.controllbar.view.controllbar
{
    import com.qiyi.player.wonder.common.ui.*;
    import flash.display.*;
    import flash.text.*;

    public class ControllBarDispalyTime extends Sprite
    {
        private var _curTimeTF:TextField;
        private var _totalTimeTF:TextField;

        public function ControllBarDispalyTime()
        {
            this._curTimeTF = FastCreator.createLabel("00:00:00", 10066329, 12, TextFieldAutoSize.CENTER, false, "Verdana");
            this._totalTimeTF = FastCreator.createLabel(" / 00:00:00", 6710886, 12, TextFieldAutoSize.CENTER, false, "Verdana");
            addChild(this._curTimeTF);
            addChild(this._totalTimeTF);
            return;
        }// end function

        public function updateTime(param1:String, param2:String) : void
        {
            this._curTimeTF.x = 0;
            this._curTimeTF.text = param1.toString();
            this._totalTimeTF.text = " / " + param2 + " ";
            this._totalTimeTF.x = this._curTimeTF.x + this._curTimeTF.textWidth;
            return;
        }// end function

        public function getWidth() : Number
        {
            return this._curTimeTF.textWidth + this._totalTimeTF.textWidth;
        }// end function

    }
}
