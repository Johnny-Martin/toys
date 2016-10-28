package com.qiyi.player.core.video.render
{
    import com.qiyi.player.base.logging.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class StageVideoManager extends EventDispatcher
    {
        private var _activeStageVideoes:Dictionary;
        private var _stage:Stage;
        private var _stageVideoIsAvailable:Boolean = false;
        private var _log:ILogger;
        public static const AVAILABILITY:String = "availability";
        public static const AVAILABLE:String = "available";
        public static const UNAVAILABLE:String = "unavailable";
        private static var _instance:StageVideoManager = null;
        public static var _curDepth:int = 1;

        public function StageVideoManager(param1:SingletonClass)
        {
            this._activeStageVideoes = new Dictionary(true);
            this._log = Log.getLogger("com.qiyi.player.core.video.video.StageVideoManager");
            return;
        }// end function

        public function initialize(param1:Stage) : void
        {
            if (this._stage)
            {
                return;
            }
            this._stage = param1;
            if (this._stage.hasOwnProperty("stageVideos"))
            {
                this._stage.addEventListener("stageVideoAvailability", this.onStageVideoAvailability);
                this._stageVideoIsAvailable = this._stage["stageVideos"].length > 0;
            }
            return;
        }// end function

        public function get stageVideoIsAvailable() : Boolean
        {
            return this._stageVideoIsAvailable;
        }// end function

        public function getNewDepth() : int
        {
            return ++_curDepth;
        }// end function

        private function onStageVideoAvailability(event:Event) : void
        {
            this._log.info("the stagevideo is " + event[AVAILABILITY]);
            var _loc_2:* = event[AVAILABILITY] == AVAILABLE;
            if (_loc_2 != this._stageVideoIsAvailable)
            {
                this._stageVideoIsAvailable = _loc_2;
            }
            if (!_loc_2)
            {
                this._activeStageVideoes = new Dictionary(true);
            }
            dispatchEvent(new Event(AVAILABILITY));
            return;
        }// end function

        public function get stageVideoCount() : int
        {
            return this._stage ? (this._stage["stageVideos"].length) : (0);
        }// end function

        public function getStageVideo() : Object
        {
            var _loc_3:* = undefined;
            if (!this._stageVideoIsAvailable)
            {
                return null;
            }
            var _loc_1:Object = null;
            var _loc_2:int = 0;
            while (_loc_2 < this._stage["stageVideos"].length)
            {
                
                _loc_1 = this._stage["stageVideos"][_loc_2];
                for (_loc_3 in this._activeStageVideoes)
                {
                    
                    if (_loc_1 == _loc_3)
                    {
                        _loc_1 = null;
                        break;
                    }
                }
                if (_loc_1)
                {
                    break;
                }
                _loc_2++;
            }
            if (_loc_1)
            {
                this._activeStageVideoes[_loc_1] = null;
            }
            return _loc_1;
        }// end function

        public function release(param1:Object) : void
        {
            delete this._activeStageVideoes[param1];
            return;
        }// end function

        private function ll_lll_l___ll____l____ll____lll______l_llll_llllllll_________lllll____llll______l_llllllll_lll__l____llll_l____llllll__lll__lll______l_l_llll_ll_ll() : int
        {
            return 11;
        }// end function

        private function ll_ll_l_l___ll____llllll_llll_lllllll____llll_____l____l__lll___ll__lll_lll_lll________l__lllll__l_l_ll__lll__llll__l_l_l_llllllll() : int
        {
            return 4;
        }// end function

        private function ll_llll_____ll_llllll__lll_lll_l___ll_llll_ll_llllll_llll_llllll_____lllllll___lll___lll_l_l__lll_lllll___lll_____llll_l____l_llllllllll___() : int
        {
            return 0;
        }// end function

        public static function get instance() : StageVideoManager
        {
            if (_instance == null)
            {
                _instance = new StageVideoManager(new SingletonClass());
            }
            return _instance;
        }// end function

    }
}

class SingletonClass extends Object
{

    function SingletonClass()
    {
        return;
    }// end function

}

