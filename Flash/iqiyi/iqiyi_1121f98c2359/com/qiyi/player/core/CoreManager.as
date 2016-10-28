package com.qiyi.player.core
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.uuid.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.video.render.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;

    public class CoreManager extends EventDispatcher
    {
        private var _inited:Boolean = false;
        private var _platform:EnumItem;
        private var _playerType:EnumItem;
        private var _playerVec:Vector.<IPlayer>;
        private var _flashP2PCoreURL:String = "";
        private var _log:ILogger;
        public static const Evt_InitComplete:String = "evtInitComplete";
        private static var _instance:CoreManager;

        public function CoreManager(param1:SingletonClass)
        {
            this._log = Log.getLogger("com.qiyi.player.core.CoreManager");
            this._playerVec = new Vector.<IPlayer>;
            return;
        }// end function

        public function initialize(param1:Stage, param2:EnumItem, param3:EnumItem, param4:String) : Boolean
        {
            if (this._inited)
            {
                return true;
            }
            this._log.info("flash kernel(version: " + Version.VERSION + "." + Version.VERSION_DEV + ") initializing... ");
            var _loc_5:* = "systeminfo: os(" + Capabilities.os;
            _loc_5 = _loc_5 + ("), language(" + Capabilities.language);
            _loc_5 = _loc_5 + ("), flashplayer(" + Capabilities.version);
            _loc_5 = _loc_5 + ("), playerType(" + Capabilities.playerType);
            _loc_5 = _loc_5 + ("), debug(" + Capabilities.isDebugger);
            _loc_5 = _loc_5 + ("), hasStreamingVideo(" + Capabilities.hasStreamingVideo);
            _loc_5 = _loc_5 + ("), hasStreamingAudio(" + Capabilities.hasStreamingAudio);
            _loc_5 = _loc_5 + ("), maxLevelIDC(" + Capabilities.maxLevelIDC);
            _loc_5 = _loc_5 + ("), cpuArchitecture(" + Capabilities.cpuArchitecture);
            _loc_5 = _loc_5 + ")";
            this._log.info(_loc_5);
            this._platform = param2;
            this._playerType = param3;
            this._flashP2PCoreURL = param4;
            if (param1)
            {
                GlobalStage.initStage(param1);
            }
            Settings.loadFromCookies();
            Statistics.loadFromCookie();
            UUIDManager.instance.load();
            StageVideoManager.instance.initialize(param1);
            this._inited = true;
            return true;
        }// end function

        public function createPlayer(param1:EnumItem) : IPlayer
        {
            var _loc_2:ICorePlayer = null;
            if (this._inited)
            {
                this._log.info("Core Create Player");
                _loc_2 = new CorePlayer();
                _loc_2.runtimeData.playerUseType = param1;
                _loc_2.runtimeData.playerType = this._playerType;
                _loc_2.runtimeData.platform = this._platform;
                _loc_2.runtimeData.flashP2PCoreURL = this._flashP2PCoreURL;
                this._playerVec.push(_loc_2);
                return _loc_2;
            }
            return null;
        }// end function

        public function deletePlayer(param1:IPlayer) : void
        {
            var _loc_2:int = 0;
            var _loc_3:IPlayer = null;
            var _loc_4:int = 0;
            if (param1)
            {
                this._log.info("Core Delete Player");
                _loc_2 = this._playerVec.length;
                _loc_3 = null;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_3 = this._playerVec[_loc_4];
                    if (_loc_3 == param1)
                    {
                        this._playerVec.splice(_loc_4, 1);
                        break;
                    }
                    _loc_4++;
                }
                param1.destroy();
            }
            return;
        }// end function

        public function findPlayer(param1:String) : IPlayer
        {
            var _loc_2:* = this._playerVec.length;
            var _loc_3:IPlayer = null;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3 = this._playerVec[_loc_4];
                if (_loc_3 && _loc_3.movieModel && _loc_3.movieModel.tvid == param1)
                {
                    return _loc_3;
                }
                _loc_4++;
            }
            return null;
        }// end function

        private function ll_lll______lllll_____ll_____ll___lll__l___lll__lll___ll_llll_ll_l_l_l_ll_l_lll___l____ll_____lll________llll_l__lllll___l_____lll__lll___ll___ll() : int
        {
            return 1;
        }// end function

        private function ll_l____ll_l____l____lllll___lll____lllllllll__llll_ll_llll_ll____l_ll__ll_ll_lll_ll______llll____lllll_l_llll_l____l_lll_ll_l_l___ll() : int
        {
            return 3;
        }// end function

        private function ll_l_ll___llll____l_l___ll_lll_____lllll________ll__ll___lll______lll_llll_ll_llll_lllllllllllll_llllllll___l_lll_l_lllll___lllllllllllll_l_____() : int
        {
            return 15;
        }// end function

        public static function getInstance() : CoreManager
        {
            if (_instance == null)
            {
                _instance = new CoreManager(new SingletonClass());
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

