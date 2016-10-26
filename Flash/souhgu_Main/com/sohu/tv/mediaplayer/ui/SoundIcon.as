package com.sohu.tv.mediaplayer.ui
{
    import flash.display.*;
    import flash.events.*;

    public class SoundIcon extends Sprite
    {
        private var _soundIcon:Sprite;
        private var _soundIconMute:Sprite;
        private var _soundIconOver:Sprite;
        private var _soundIconMuteOver:Sprite;
        private var _icon:Sprite;
        private var _soundState:Boolean;
        private var _mouseState:Boolean = false;

        public function SoundIcon() : void
        {
            this.init();
            return;
        }// end function

        private function init() : void
        {
            this._soundIcon = new Sount_n();
            this._soundIconMute = new Mute_n();
            this._soundIconOver = new Sound_o();
            this._soundIconMuteOver = new Mute_o();
            this._icon = new Sprite();
            this._icon.addChild(this._soundIcon);
            this._icon.addChild(this._soundIconMute);
            this._icon.addChild(this._soundIconOver);
            this._icon.addChild(this._soundIconMuteOver);
            this._icon.buttonMode = true;
            addChild(this._icon);
            this._soundState = true;
            this.iconStatus();
            this._icon.addEventListener(MouseEvent.MOUSE_DOWN, this.iconClickHandler);
            this._icon.addEventListener(MouseEvent.MOUSE_OVER, this.iconOverHandler);
            this._icon.addEventListener(MouseEvent.MOUSE_OUT, this.iconOutHandler);
            return;
        }// end function

        private function iconOutHandler(event:MouseEvent) : void
        {
            this._mouseState = false;
            this.iconStatus();
            return;
        }// end function

        private function iconOverHandler(event:MouseEvent) : void
        {
            this._mouseState = true;
            this.iconStatus();
            return;
        }// end function

        private function iconClickHandler(event:MouseEvent) : void
        {
            this._soundState = !this._soundState;
            this.iconStatus();
            return;
        }// end function

        private function iconStatus() : void
        {
            if (!this._soundState)
            {
                if (this._mouseState)
                {
                    this._soundIcon.visible = false;
                    this._soundIconMute.visible = false;
                    this._soundIconOver.visible = false;
                    this._soundIconMuteOver.visible = true;
                }
                else
                {
                    this._soundIcon.visible = false;
                    this._soundIconMute.visible = true;
                    this._soundIconOver.visible = false;
                    this._soundIconMuteOver.visible = false;
                }
            }
            else
            {
                if (this._mouseState)
                {
                    this._soundIcon.visible = false;
                    this._soundIconMute.visible = false;
                    this._soundIconOver.visible = true;
                    this._soundIconMuteOver.visible = false;
                }
                else
                {
                    this._soundIcon.visible = true;
                    this._soundIconMute.visible = false;
                    this._soundIconOver.visible = false;
                    this._soundIconMuteOver.visible = false;
                }
                this._soundIconMute.visible = false;
                this._soundIcon.visible = true;
            }
            return;
        }// end function

        public function get soundState() : Boolean
        {
            return this._soundState;
        }// end function

        public function set soundState(param1:Boolean) : void
        {
            this._soundState = param1;
            this.iconStatus();
            return;
        }// end function

    }
}
