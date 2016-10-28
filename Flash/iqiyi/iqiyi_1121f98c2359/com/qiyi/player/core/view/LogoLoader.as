package com.qiyi.player.core.view
{
    import com.qiyi.player.components.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.net.*;

    public class LogoLoader extends EventDispatcher
    {
        private const ALPHA:Number = 0.7;
        private const FILTERS:Array;
        private var _logo:DisplayObject;
        public static const Evt_Complete:String = "complete";

        public function LogoLoader()
        {
            this.FILTERS = [new GlowFilter(0, 0.4, 4, 4, 5)];
            return;
        }// end function

        public function getLogo() : DisplayObject
        {
            return this._logo;
        }// end function

        public function load(param1:String) : void
        {
            this._logo = new DefaultLogo();
            this._logo.alpha = this.ALPHA;
            this._logo.filters = this.FILTERS;
            dispatchEvent(new Event(Evt_Complete));
            return;
        }// end function

        private function onUrlComplete(event:Event) : void
        {
            event.target.removeEventListener(Event.COMPLETE, this.onUrlComplete);
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.onUrlError);
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUrlError);
            var _loc_2:* = new Loader();
            _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLogoComplete);
            _loc_2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLogoError);
            _loc_2.load(new URLRequest(event.target.data));
            return;
        }// end function

        private function onUrlError(event:Event) : void
        {
            event.target.removeEventListener(Event.COMPLETE, this.onUrlComplete);
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.onUrlError);
            event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onUrlError);
            this._logo = new DefaultLogo();
            this._logo.alpha = this.ALPHA;
            dispatchEvent(new Event(Evt_Complete));
            return;
        }// end function

        private function onLogoComplete(event:Event) : void
        {
            var cls:Class;
            var event:* = event;
            var loader:* = event.target.loader as Loader;
            event.target.removeEventListener(Event.COMPLETE, this.onLogoComplete);
            event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.onLogoError);
            try
            {
                cls = Class(loader.contentLoaderInfo.applicationDomain.getDefinition("com.qiyi.player.components.ExternalLogo_UI"));
                this._logo = new cls as DisplayObject;
                this._logo.alpha = this.ALPHA;
                dispatchEvent(new Event(Evt_Complete));
            }
            catch (e:Error)
            {
                onLogoError(null);
            }
            return;
        }// end function

        private function onLogoError(event:Event) : void
        {
            if (event)
            {
                event.target.removeEventListener(Event.COMPLETE, this.onLogoComplete);
                event.target.removeEventListener(IOErrorEvent.IO_ERROR, this.onLogoError);
            }
            this._logo = new DefaultLogo();
            this._logo.alpha = this.ALPHA;
            dispatchEvent(new Event(Evt_Complete));
            return;
        }// end function

    }
}
