package com.qiyi.player.core.model.remote
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.rpc.*;
    import com.qiyi.player.base.rpc.impl.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.impls.subtitle.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class SubtitleRemote extends BaseRemoteObject
    {
        private var _sentences:Vector.<Sentence>;
        private var _language:Language;

        public function SubtitleRemote()
        {
            super(0, "SubtitleRemote");
            _timeout = Config.SUBTITLE_TIMEOUT;
            _retryMaxCount = Config.SUBTITLE_MAX_RETRY;
            return;
        }// end function

        public function loadLanguage(param1:Language) : void
        {
            this._language = param1;
            this.initialize();
            return;
        }// end function

        public function get sentences() : Vector.<Sentence>
        {
            return this._sentences;
        }// end function

        public function get language() : Language
        {
            return this._language;
        }// end function

        override protected function getRequest() : URLRequest
        {
            return new URLRequest(this._language.url + "?tn=" + Math.random());
        }// end function

        private function parser() : Boolean
        {
            var root:XML;
            var items:XMLList;
            var i:int;
            var n:int;
            var item:XML;
            var sentence:Sentence;
            try
            {
                root = new XML(this._loader.data);
                items = root.dia;
                this._sentences = new Vector.<Sentence>(items.length(), true);
                i;
                n = items.length();
                while (i < n)
                {
                    
                    item = items[i];
                    sentence = new Sentence();
                    sentence.startTime = Number(item.st);
                    sentence.endTime = Number(item.et);
                    sentence.content = String(item.sub) ? (String(item.sub).replace("\\n", "\n")) : ("");
                    this._sentences[i] = sentence;
                    i = (i + 1);
                }
                this._sentences = this._sentences.sort(this.compare);
            }
            catch (e:Error)
            {
                return false;
            }
            return true;
        }// end function

        private function compare(param1:Sentence, param2:Sentence) : Number
        {
            return param1.startTime - param2.startTime;
        }// end function

        override protected function onComplete(event:Event) : void
        {
            clearTimeout(_waitingResponse);
            _waitingResponse = 0;
            _data = _loader.data;
            if (this.parser())
            {
                super.onComplete(event);
            }
            else if (!this.exceptionHandler())
            {
                this._status = RemoteObjectStatusEnum.DataError;
            }
            return;
        }// end function

    }
}
