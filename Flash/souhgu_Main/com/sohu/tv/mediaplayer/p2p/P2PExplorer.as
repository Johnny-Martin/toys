package com.sohu.tv.mediaplayer.p2p
{
    import com.sohu.tv.mediaplayer.*;
    import ebing.net.*;
    import flash.utils.*;

    public class P2PExplorer extends Object
    {
        private var _intervalId:Number = 0;
        private var _hasP2P:Boolean = true;
        private var _p2pStat:Object;
        private var _isFirstTime:Boolean = true;
        private static var singleton:P2PExplorer;

        public function P2PExplorer()
        {
            this._intervalId = setInterval(this.checkP2P, 30000);
            this._p2pStat = new Object();
            return;
        }// end function

        private function checkP2P() : void
        {
            new URLLoaderUtil().load(1, this.handshakeReport, PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
            return;
        }// end function

        private function handshakeReport(param1:Object) : void
        {
            if (param1.info == "success" && !PlayerConfig.isUgcFeeVideo)
            {
                this._hasP2P = true;
            }
            else
            {
                this._hasP2P = false;
            }
            return;
        }// end function

        public function get hasP2P() : Boolean
        {
            return this._hasP2P;
        }// end function

        public function set hasP2P(param1:Boolean) : void
        {
            this._hasP2P = param1;
            return;
        }// end function

        public function callP2P(param1:Function) : void
        {
            if (this._isFirstTime)
            {
                this._isFirstTime = false;
                new URLLoaderUtil().load(2, param1, PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
            }
            else
            {
                new URLLoaderUtil().load(1, param1, PlayerConfig.CHECKP2PPATH + "shakehand" + "?uuid=" + PlayerConfig.uuid + "&vid=" + PlayerConfig.vid + "&r=" + (new Date().getTime() + Math.random()));
            }
            return;
        }// end function

        public function p2pStat(param1:Object) : void
        {
            this._p2pStat = param1;
            return;
        }// end function

        public function get statTotal() : Number
        {
            if (this._p2pStat != null && this._p2pStat.t != null)
            {
                return this._p2pStat.t;
            }
            return 0;
        }// end function

        public function get statCdn() : Number
        {
            if (this._p2pStat != null && this._p2pStat.c != null)
            {
                return this._p2pStat.c;
            }
            return 0;
        }// end function

        public static function getInstance() : P2PExplorer
        {
            if (singleton == null)
            {
                singleton = new P2PExplorer;
            }
            return singleton;
        }// end function

    }
}
