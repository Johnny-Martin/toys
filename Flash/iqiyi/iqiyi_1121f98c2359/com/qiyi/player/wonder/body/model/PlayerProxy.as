package com.qiyi.player.wonder.body.model
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.actors.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class PlayerProxy extends Proxy
    {
        private var _curActor:PlayerActor;
        private var _preActor:PlayerActor;
        private var _invalid:Boolean = false;
        private var _log:ILogger;
        public static const NAME:String = "com.qiyi.player.wonder.body.model.PlayerProxy";

        public function PlayerProxy(param1:Object = null)
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.body.model.PlayerProxy");
            super(NAME, param1);
            this._curActor = new PlayerActor(facade);
            this._curActor.isPreload = false;
            this._preActor = new PlayerActor(facade);
            this._preActor.isPreload = true;
            return;
        }// end function

        public function get curActor() : PlayerActor
        {
            return this._curActor;
        }// end function

        public function get preActor() : PlayerActor
        {
            return this._preActor;
        }// end function

        public function get invalid() : Boolean
        {
            return this._invalid;
        }// end function

        public function set invalid(param1:Boolean) : void
        {
            this._invalid = param1;
            return;
        }// end function

        public function switchPreActor() : void
        {
            var _loc_1:* = this._curActor;
            this._curActor = this._preActor;
            this._curActor.isPreload = false;
            this._preActor = _loc_1;
            this._preActor.isPreload = true;
            this._preActor.stop();
            this._log.info("switchPreActor,curTvid:" + this._curActor.loadMovieParams.tvid + ", curVid:" + this._curActor.loadMovieParams.vid);
            sendNotification(BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR);
            return;
        }// end function

    }
}
