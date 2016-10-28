package com.iqiyi.components.global
{
    import flash.display.*;
    import flash.events.*;

    public class GlobalStage extends Object
    {
        public static const SWITCH_EVENT:String = "stageSwitchedEvent";
        private static var _workable:Boolean = true;
        private static var _isFullScreen:Boolean = false;
        private static var _stage:Stage;
        private static var _customStage:ICustomStage;

        public function GlobalStage()
        {
            return;
        }// end function

        public static function set workable(param1:Boolean) : void
        {
            _workable = param1;
            return;
        }// end function

        public static function get stage() : Stage
        {
            return _stage;
        }// end function

        public static function get customStage() : ICustomStage
        {
            return _customStage;
        }// end function

        public static function isFullScreen() : Boolean
        {
            if (_workable == false)
            {
                return _isFullScreen;
            }
            if (_customStage)
            {
                return _customStage.isFullScreen();
            }
            return _stage.displayState == StageDisplayState.FULL_SCREEN;
        }// end function

        public static function setFullScreen() : void
        {
            if (_workable == false)
            {
                _isFullScreen = true;
                _stage.dispatchEvent(new Event(SWITCH_EVENT));
                return;
            }
            if (_customStage)
            {
                _customStage.setFullScreen();
            }
            else if (_stage.displayState == StageDisplayState.NORMAL)
            {
                _stage.displayState = StageDisplayState.FULL_SCREEN;
            }
            return;
        }// end function

        public static function setNormalScreen() : void
        {
            if (_workable == false)
            {
                _isFullScreen = false;
                _stage.dispatchEvent(new Event(SWITCH_EVENT));
                return;
            }
            if (_customStage)
            {
                _customStage.setNormalScreen();
            }
            else if (_stage.displayState == StageDisplayState.FULL_SCREEN)
            {
                _stage.displayState = StageDisplayState.NORMAL;
            }
            return;
        }// end function

        public static function initStage(param1:Stage) : void
        {
            if (param1)
            {
                _stage = param1;
            }
            return;
        }// end function

        public static function initCustomStage(param1:ICustomStage) : void
        {
            if (param1)
            {
                _customStage = param1;
            }
            return;
        }// end function

    }
}
