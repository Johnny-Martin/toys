package com.qiyi.player.core.model.impls.subtitle
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.core.model.remote.*;
    import flash.events.*;

    public class SubtitleDummy extends EventDispatcher
    {
        private var _language:Language;
        private var _curSubtitle:SubtitleRemote;
        private var _sentences:Vector.<Sentence>;
        protected var _log:ILogger;

        public function SubtitleDummy()
        {
            this._log = Log.getLogger("com.qiyi.player.core.model.impls.subtitle.SubtitleDummy");
            return;
        }// end function

        public function hasSentence() : Boolean
        {
            return this._sentences != null && this._sentences.length > 0;
        }// end function

        public function clear() : void
        {
            if (this._curSubtitle != null)
            {
                this._curSubtitle.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onStatausChanged);
                this._curSubtitle.destroy();
            }
            this._language = null;
            this._curSubtitle = null;
            this._sentences = null;
            return;
        }// end function

        public function loadLanguage(param1:Language) : void
        {
            if (param1 != null && param1 != this._language)
            {
                this._log.debug("Subtitle URL:" + param1.url);
                this._language = param1;
                if (this._curSubtitle != null)
                {
                    this._curSubtitle.removeEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onStatausChanged);
                    this._curSubtitle.destroy();
                }
                this._curSubtitle = new SubtitleRemote();
                this._curSubtitle.addEventListener(RemoteObjectEvent.Evt_StatusChanged, this.onStatausChanged);
                this._curSubtitle.loadLanguage(param1);
            }
            return;
        }// end function

        public function findSentence(param1:uint) : Sentence
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:Sentence = null;
            if (this.hasSentence())
            {
                _loc_2 = 0;
                _loc_3 = this._sentences.length - 1;
                _loc_4 = 0;
                _loc_5 = null;
                while (_loc_2 <= _loc_3)
                {
                    
                    _loc_4 = (_loc_2 + _loc_3) / 2;
                    _loc_5 = this._sentences[_loc_4];
                    if (param1 >= _loc_5.startTime && param1 <= _loc_5.endTime)
                    {
                        return _loc_5;
                    }
                    if (param1 < _loc_5.startTime)
                    {
                        _loc_3 = _loc_4 - 1;
                        continue;
                    }
                    _loc_2 = _loc_4 + 1;
                }
            }
            return null;
        }// end function

        private function onStatausChanged(event:RemoteObjectEvent) : void
        {
            if (this._curSubtitle.status == RemoteObjectStatusEnum.Success)
            {
                this._sentences = this._curSubtitle.sentences;
            }
            return;
        }// end function

    }
}
