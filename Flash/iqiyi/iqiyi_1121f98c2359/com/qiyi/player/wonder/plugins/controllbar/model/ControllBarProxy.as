package com.qiyi.player.wonder.plugins.controllbar.model
{
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.view.preview.image.*;
    import flash.geom.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class ControllBarProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _playerLightOn:Boolean = true;
        private var _keyDownSeeking:Boolean = false;
        private var _keyDownVolume:Boolean = false;
        private var _isFullScreen:Boolean = false;
        private var _definitionBtnX:Number;
        private var _filterBtnX:Number;
        private var _definitionBtnY:Number;
        private var _seekCount:uint = 0;
        private var _isFirstPlay:Boolean = false;
        private var _controlbarRect:Rectangle;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.controllbar.model.ControllBarProxy";

        public function ControllBarProxy(param1:Object = null)
        {
            super(NAME, param1);
            this._status = new Status(ControllBarDef.STATUS_BEGIN, ControllBarDef.STATUS_END);
            this._status.addStatus(ControllBarDef.STATUS_VIEW_INIT);
            this._status.addStatus(ControllBarDef.STATUS_FULL_SCREEN_BTN_SHOW);
            PreviewImageLoader.instance.init();
            return;
        }// end function

        public function get isFirstPlay() : Boolean
        {
            return this._isFirstPlay;
        }// end function

        public function set isFirstPlay(param1:Boolean) : void
        {
            this._isFirstPlay = param1;
            return;
        }// end function

        public function get seekCount() : uint
        {
            return this._seekCount;
        }// end function

        public function set seekCount(param1:uint) : void
        {
            this._seekCount = param1;
            return;
        }// end function

        public function get definitionBtnX() : Number
        {
            return this._definitionBtnX;
        }// end function

        public function set definitionBtnX(param1:Number) : void
        {
            this._definitionBtnX = param1;
            return;
        }// end function

        public function get definitionBtnY() : Number
        {
            return this._definitionBtnY;
        }// end function

        public function set definitionBtnY(param1:Number) : void
        {
            this._definitionBtnY = param1;
            return;
        }// end function

        public function get controlbarRect() : Rectangle
        {
            return this._controlbarRect;
        }// end function

        public function set controlbarRect(param1:Rectangle) : void
        {
            this._controlbarRect = param1;
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function get playerLightOn() : Boolean
        {
            return this._playerLightOn;
        }// end function

        public function set playerLightOn(param1:Boolean) : void
        {
            this._playerLightOn = param1;
            return;
        }// end function

        public function get keyDownSeeking() : Boolean
        {
            return this._keyDownSeeking;
        }// end function

        public function set keyDownSeeking(param1:Boolean) : void
        {
            this._keyDownSeeking = param1;
            return;
        }// end function

        public function get keyDownVolume() : Boolean
        {
            return this._keyDownVolume;
        }// end function

        public function set keyDownVolume(param1:Boolean) : void
        {
            this._keyDownVolume = param1;
            return;
        }// end function

        public function get isFullScreen() : Boolean
        {
            return this._isFullScreen;
        }// end function

        public function set isFullScreen(param1:Boolean) : void
        {
            this._isFullScreen = param1;
            return;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= ControllBarDef.STATUS_BEGIN && param1 < ControllBarDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == ControllBarDef.STATUS_OPEN && !this._status.hasStatus(ControllBarDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(ControllBarDef.STATUS_VIEW_INIT);
                    sendNotification(ControllBarDef.NOTIFIC_ADD_STATUS, ControllBarDef.STATUS_VIEW_INIT);
                }
                switch(param1)
                {
                    case ControllBarDef.STATUS_TRIGGER_BTN_SHOW:
                    {
                        this._status.removeStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
                        break;
                    }
                    case ControllBarDef.STATUS_LOAD_BTN_SHOW:
                    {
                        this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
                        this._status.removeStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
                        break;
                    }
                    case ControllBarDef.STATUS_REPLAY_BTN_SHOW:
                    {
                        this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_PAUSE);
                        this._status.removeStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
                        break;
                    }
                    case ControllBarDef.STATUS_TRIGGER_BTN_PAUSE:
                    {
                        this._status.removeStatus(ControllBarDef.STATUS_TRIGGER_BTN_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_LOAD_BTN_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_LOAD_TIPS_SHOW);
                        this._status.removeStatus(ControllBarDef.STATUS_REPLAY_BTN_SHOW);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(ControllBarDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= ControllBarDef.STATUS_BEGIN && param1 < ControllBarDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(ControllBarDef.NOTIFIC_REMOVE_STATUS, param1);
                }
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

    }
}
