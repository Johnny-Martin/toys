package ebing.utils
{
    import flash.display.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;

    public class CustomButton extends Sprite
    {
        private var K10260791F47A4F31B24405AB8C5DAE047CE77B373570K:SimpleButton;
        private var K102607FF99360793124B098F9CAB6FC84F9CD8373570K:int;
        private var K102607BE501D1B041B4DDBABF9C149B68FE797373570K:int;
        private var K10260799BAFE9E2C824444B2D3FC04DD8AF088373570K:String;
        private var K1026076AD3D0AECB2042E889B64F37653BA355373570K:Matrix;
        private var K1026079D882316BCD544B2940C2589B01E2832373570K:uint = 3355443;
        private var K10260752434D810B844A5CA9CF93C8B9450FCC373570K:uint = 1052688;
        private var K102607A94E7B46E9BE40BA91D3997D5184CF6C373570K:uint = 11184810;
        private var K1026075F499815925842D48FFE561AED92EE91373570K:TextField;
        private var K102607EC34C74EEA444D17BF978EAB919FCFC0373570K:String = "Button1";

        public function CustomButton(param1:String = "按钮", param2:int = 100, param3:int = 25)
        {
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K = new SimpleButton();
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.mouseEnabled = true;
            this.K10260799BAFE9E2C824444B2D3FC04DD8AF088373570K = param1;
            this.K102607FF99360793124B098F9CAB6FC84F9CD8373570K = param2;
            this.K102607BE501D1B041B4DDBABF9C149B68FE797373570K = param3;
            this.K1026078240147A92D04BFFA054CA2FE112AE01373570K();
            addChild(this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K);
            addChild(this.K10260761AAC9B83D2347E9A00C3B80249DD913373570K());
            return;
        }// end function

        private function K1026078240147A92D04BFFA054CA2FE112AE01373570K() : void
        {
            var _loc_1:* = this.K10260720A8F5DDFF97452EBD28BEFA6B902378373570K(this.K1026079D882316BCD544B2940C2589B01E2832373570K);
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.upState = _loc_1;
            var _loc_2:* = this.K10260720A8F5DDFF97452EBD28BEFA6B902378373570K(this.K10260752434D810B844A5CA9CF93C8B9450FCC373570K);
            _loc_2.filters = [new GlowFilter(3355443, 0.8, 10, 10)];
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.overState = _loc_2;
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.downState = this.K10260720A8F5DDFF97452EBD28BEFA6B902378373570K(this.K102607A94E7B46E9BE40BA91D3997D5184CF6C373570K);
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.hitTestState = this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.upState;
            return;
        }// end function

        private function K10260720A8F5DDFF97452EBD28BEFA6B902378373570K(param1:uint) : Sprite
        {
            this.K1026076AD3D0AECB2042E889B64F37653BA355373570K = new Matrix();
            this.K1026076AD3D0AECB2042E889B64F37653BA355373570K.createGradientBox(this.K102607FF99360793124B098F9CAB6FC84F9CD8373570K, this.K102607BE501D1B041B4DDBABF9C149B68FE797373570K, 4.8, 1, 1);
            var _loc_2:Array = [param1, 1052688];
            var _loc_3:Array = [1, 1];
            var _loc_4:Array = [0, 250];
            var _loc_5:* = new Sprite();
            new Sprite().graphics.lineStyle(1, 3618615);
            _loc_5.graphics.beginGradientFill(GradientType.LINEAR, _loc_2, _loc_3, _loc_4, this.K1026076AD3D0AECB2042E889B64F37653BA355373570K);
            _loc_5.graphics.drawRoundRect(0, 0, this.K102607FF99360793124B098F9CAB6FC84F9CD8373570K, this.K102607BE501D1B041B4DDBABF9C149B68FE797373570K, 8, 8);
            _loc_5.graphics.endFill();
            return _loc_5;
        }// end function

        private function K10260761AAC9B83D2347E9A00C3B80249DD913373570K() : TextField
        {
            var _loc_1:* = new TextFormat();
            _loc_1.size = 12;
            this.K1026075F499815925842D48FFE561AED92EE91373570K = new TextField();
            this.K1026075F499815925842D48FFE561AED92EE91373570K.defaultTextFormat = _loc_1;
            this.K1026075F499815925842D48FFE561AED92EE91373570K.mouseEnabled = false;
            this.K1026075F499815925842D48FFE561AED92EE91373570K.name = "label";
            this.K1026075F499815925842D48FFE561AED92EE91373570K.text = this.K10260799BAFE9E2C824444B2D3FC04DD8AF088373570K;
            this.K1026075F499815925842D48FFE561AED92EE91373570K.width = this.K102607FF99360793124B098F9CAB6FC84F9CD8373570K;
            this.K1026075F499815925842D48FFE561AED92EE91373570K.height = this.K102607BE501D1B041B4DDBABF9C149B68FE797373570K;
            this.K1026075F499815925842D48FFE561AED92EE91373570K.x = (this.width - this.K1026075F499815925842D48FFE561AED92EE91373570K.width) / 2;
            this.K1026075F499815925842D48FFE561AED92EE91373570K.y = (this.height - this.K1026075F499815925842D48FFE561AED92EE91373570K.height) / 2 + 3;
            this.K1026075F499815925842D48FFE561AED92EE91373570K.textColor = 10724259;
            this.K1026075F499815925842D48FFE561AED92EE91373570K.autoSize = "center";
            return this.K1026075F499815925842D48FFE561AED92EE91373570K;
        }// end function

        public function setUpState(param1:DisplayObject) : void
        {
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.upState = param1;
            return;
        }// end function

        public function setOverState(param1:DisplayObject) : void
        {
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.overState = param1;
            return;
        }// end function

        public function setDownState(param1:DisplayObject) : void
        {
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.downState = param1;
            return;
        }// end function

        public function setUpColor(param1:uint) : void
        {
            this.K1026079D882316BCD544B2940C2589B01E2832373570K = param1;
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.upState = this.K10260720A8F5DDFF97452EBD28BEFA6B902378373570K(param1);
            return;
        }// end function

        public function setDownColor(param1:uint) : void
        {
            this.K102607A94E7B46E9BE40BA91D3997D5184CF6C373570K = param1;
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.downState = this.K10260720A8F5DDFF97452EBD28BEFA6B902378373570K(param1);
            return;
        }// end function

        public function setOverColor(param1:uint) : void
        {
            this.K10260752434D810B844A5CA9CF93C8B9450FCC373570K = param1;
            this.K10260791F47A4F31B24405AB8C5DAE047CE77B373570K.overState = this.K10260720A8F5DDFF97452EBD28BEFA6B902378373570K(param1);
            return;
        }// end function

        public function set label(param1:String) : void
        {
            this.K1026075F499815925842D48FFE561AED92EE91373570K.text = param1;
            return;
        }// end function

        public function get label() : String
        {
            return this.K1026075F499815925842D48FFE561AED92EE91373570K.text;
        }// end function

        override public function set name(param1:String) : void
        {
            this.K102607EC34C74EEA444D17BF978EAB919FCFC0373570K = param1;
            return;
        }// end function

        override public function get name() : String
        {
            return this.K102607EC34C74EEA444D17BF978EAB919FCFC0373570K;
        }// end function

    }
}
