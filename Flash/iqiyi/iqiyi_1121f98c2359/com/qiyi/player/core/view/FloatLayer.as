package com.qiyi.player.core.view
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.components.*;
    import com.qiyi.player.core.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.model.impls.subtitle.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.*;
    import com.qiyi.player.core.player.coreplayer.*;
    import com.qiyi.player.core.player.def.*;
    import com.qiyi.player.core.player.events.*;
    import com.qiyi.player.core.video.engine.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
    import flash.ui.*;

    public class FloatLayer extends Sprite implements ILayer
    {
        private const BOSS_KEY:String = "QIYICOM";
        private const LOG_KEY:String = "QIYILOG";
        private const EVT_LOGOCHANGED:String = "qiyi_logo_changed";
        private const SUBTITLE_FILTER:Array;
        private var _player:IPlayer;
        private var _movie:IMovie;
        private var _showSubtitle:Boolean = true;
        private var _showLogo:Boolean = true;
        private var _showBrand:Boolean = true;
        private var _showBackground:Boolean = true;
        private var _needMask:Boolean = true;
        private var _key:String = "";
        private var _logKey:String = "";
        private var _subtitleSprite:Sprite;
        private var _subtitleTF:TextField;
        private var _subtitleDummy:SubtitleDummy;
        private var _logoLoader:LogoLoader;
        private var _logo:DisplayObject;
        private var _brand:Loader;
        private var _videoInfo:VideoInfo;
        private var _stage:Stage;
        private var _frameCount:int = 0;

        public function FloatLayer(param1:IPlayer)
        {
            this.SUBTITLE_FILTER = [new DropShadowFilter(2)];
            this._player = param1;
            this._player.addEventListener(PlayerEvent.Evt_StatusChanged, this.onStatusChanged);
            this._player.addEventListener(PlayerEvent.Evt_RenderAreaChanged, this.onRenderAreaChanged);
            this._player.addEventListener(PlayerEvent.Evt_RenderADAreaChanged, this.onRenderADAreaChanged);
            this._subtitleDummy = new SubtitleDummy();
            if (FontUtils.hasFont("微软雅黑"))
            {
                this._subtitleSprite = new YHTF();
                this._subtitleTF = this._subtitleSprite.getChildAt(0) as TextField;
            }
            else
            {
                this._subtitleSprite = new HTTF();
                this._subtitleTF = this._subtitleSprite.getChildAt(0) as TextField;
            }
            this._subtitleTF.wordWrap = true;
            this._subtitleTF.multiline = false;
            this._subtitleTF.selectable = false;
            var _loc_2:* = new TextFormat();
            _loc_2.size = Settings.instance.subtitleSize;
            _loc_2.color = Settings.instance.subtitleColor;
            _loc_2.align = TextFormatAlign.CENTER;
            _loc_2.leading = 0;
            this._subtitleTF.defaultTextFormat = _loc_2;
            this._subtitleTF.filters = this.SUBTITLE_FILTER;
            addChild(this._subtitleSprite);
            this._subtitleSprite.visible = this._showSubtitle;
            this._videoInfo = new VideoInfo(this._player, this);
            Settings.instance.addEventListener(Settings.Evt_SubtitleColor, this.onSubtitleColorChanged);
            Settings.instance.addEventListener(Settings.Evt_SubtitleSize, this.onSubtitleSizeChanged);
            Settings.instance.addEventListener(Settings.Evt_SubtitleLang, this.onSubtitleLangChanged);
            Settings.instance.addEventListener(Settings.Evt_SubtitlePos, this.onSubtitlePosChanged);
            if (stage == null)
            {
                addEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            }
            else
            {
                this.onAddToStage(null);
            }
            this.drawBackground();
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            return;
        }// end function

        public function get movie() : IMovie
        {
            return this._movie;
        }// end function

        public function get subtitleDummy() : SubtitleDummy
        {
            return this._subtitleDummy;
        }// end function

        public function set showSubtitle(param1:Boolean) : void
        {
            this._showSubtitle = param1;
            this._subtitleSprite.visible = this._showSubtitle;
            return;
        }// end function

        public function get showSubtitle() : Boolean
        {
            return this._showSubtitle;
        }// end function

        public function set showSubtitleFilter(param1:Boolean) : void
        {
            this._subtitleTF.filters = param1 ? (this.SUBTITLE_FILTER) : (null);
            return;
        }// end function

        public function get showSubtitleFilter() : Boolean
        {
            return this._subtitleTF.filters != null;
        }// end function

        public function set showLogo(param1:Boolean) : void
        {
            this._showLogo = param1;
            if (this._logo)
            {
                this._logo.visible = this._showLogo;
            }
            return;
        }// end function

        public function get showLogo() : Boolean
        {
            return this._showLogo;
        }// end function

        public function set showBrand(param1:Boolean) : void
        {
            this._showBrand = param1;
            if (this._brand)
            {
                this._brand.visible = this._showBrand;
            }
            return;
        }// end function

        public function get showBrand() : Boolean
        {
            return this._showBrand;
        }// end function

        public function set showBackground(param1:Boolean) : void
        {
            this._showBackground = param1;
            this.drawBackground();
            return;
        }// end function

        public function get showBackground() : Boolean
        {
            return this._showBackground;
        }// end function

        public function bind(param1:IMovie, param2:IEngine) : void
        {
            this._movie = param1;
            this._videoInfo.bind(param2);
            this.setMaskBackground(true);
            if (this._brand && this._brand.parent)
            {
                this._brand.parent.removeChild(this._brand);
            }
            this._subtitleDummy.clear();
            if (this._movie.subtitles && this._movie.hasSubtitle)
            {
                this.tryLoadSubtitle();
                this.adjustSubtitle();
            }
            return;
        }// end function

        public function tryLoadBrandAndLogo() : void
        {
            if (this._player.movieModel && ICorePlayer(this._player).runtimeData.playerUseType == PlayerUseTypeEnum.MAIN)
            {
                this.loadBrand();
                this.loadLogo(this._player.movieModel.logoId);
            }
            return;
        }// end function

        public function toggleVideoInfo() : void
        {
            if (this._videoInfo.parent)
            {
                this._videoInfo.hide();
            }
            else
            {
                this._videoInfo.show();
            }
            return;
        }// end function

        public function loadLogo(param1:String) : void
        {
            this.destroyLogo();
            if (this._logoLoader)
            {
                this._logoLoader.removeEventListener(LogoLoader.Evt_Complete, this.onLogoComplete);
                this._logoLoader = null;
            }
            if (param1 != "" && param1 != "0")
            {
                this._logoLoader = new LogoLoader();
                this._logoLoader.addEventListener(LogoLoader.Evt_Complete, this.onLogoComplete);
                this._logoLoader.load(param1);
            }
            return;
        }// end function

        public function setLogo(param1:DisplayObject) : void
        {
            var _loc_2:Rectangle = null;
            this.destroyLogo();
            this._logo = param1;
            if (this._logo)
            {
                this._logo.addEventListener(this.EVT_LOGOCHANGED, this.onLogoChanged);
                this._logo.visible = this._showLogo;
                _loc_2 = this._player.realArea;
                if (_loc_2 == null)
                {
                    this._logo.visible = false;
                }
                else
                {
                    this.adjustLogo();
                }
                addChild(this._logo);
            }
            return;
        }// end function

        public function clearSubtitle() : void
        {
            this._subtitleDummy.clear();
            this._subtitleTF.text = "";
            return;
        }// end function

        public function destroy() : void
        {
            graphics.clear();
            if (parent)
            {
                parent.removeChild(this);
            }
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            Settings.instance.removeEventListener(Settings.Evt_SubtitleColor, this.onSubtitleColorChanged);
            Settings.instance.removeEventListener(Settings.Evt_SubtitleSize, this.onSubtitleSizeChanged);
            Settings.instance.removeEventListener(Settings.Evt_SubtitleLang, this.onSubtitleLangChanged);
            Settings.instance.removeEventListener(Settings.Evt_SubtitlePos, this.onSubtitlePosChanged);
            this._player.removeEventListener(PlayerEvent.Evt_StatusChanged, this.onStatusChanged);
            this._player.removeEventListener(PlayerEvent.Evt_RenderAreaChanged, this.onRenderAreaChanged);
            this._movie = null;
            this.clearSubtitle();
            if (this._subtitleSprite.parent)
            {
                this._subtitleSprite.parent.removeChild(this._subtitleSprite);
            }
            if (this._logoLoader)
            {
                this._logoLoader.removeEventListener(LogoLoader.Evt_Complete, this.onLogoComplete);
                this._logoLoader = null;
            }
            this.destroyLogo();
            if (this._brand && this._brand.parent)
            {
                this._brand.parent.removeChild(this._brand);
            }
            this._brand = null;
            this._videoInfo.destroy();
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            if (this._stage)
            {
                this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onStageKey);
                this._stage = null;
            }
            return;
        }// end function

        private function destroyLogo() : void
        {
            if (this._logo)
            {
                this._logo.removeEventListener(this.EVT_LOGOCHANGED, this.onLogoChanged);
                if (this._logo.parent)
                {
                    this._logo.parent.removeChild(this._logo);
                }
            }
            this._logo = null;
            return;
        }// end function

        private function setMaskBackground(param1:Boolean) : void
        {
            if (this._needMask != param1)
            {
                this._needMask = param1;
                this.drawBackground();
            }
            return;
        }// end function

        private function drawBackground() : void
        {
            var _loc_1:Rectangle = null;
            var _loc_2:Rectangle = null;
            graphics.clear();
            if (this._showBackground)
            {
                _loc_1 = this._player.settingArea;
                _loc_2 = this._player.realArea;
                if (_loc_2 && _loc_1)
                {
                    graphics.beginFill(0);
                    graphics.drawRect(0, 0, _loc_1.width, _loc_2.y);
                    graphics.drawRect(0, _loc_2.y, _loc_2.x, _loc_2.height);
                    graphics.drawRect(0, _loc_2.bottom, _loc_1.width, _loc_1.height - _loc_2.bottom);
                    graphics.drawRect(_loc_2.right, _loc_2.y, _loc_1.width - _loc_2.right, _loc_2.height);
                    if (this._needMask)
                    {
                        graphics.drawRect(_loc_2.x, _loc_2.y, _loc_2.width, _loc_2.height);
                    }
                    graphics.endFill();
                }
            }
            return;
        }// end function

        private function tryLoadSubtitle() : void
        {
            var _loc_1:Vector.<Language> = null;
            var _loc_2:int = 0;
            var _loc_3:Language = null;
            var _loc_4:int = 0;
            if (this._movie && this._movie.subtitles)
            {
                _loc_1 = this._movie.subtitles;
                _loc_2 = _loc_1.length;
                _loc_3 = null;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_3 = _loc_1[_loc_4];
                    if (_loc_3 != null)
                    {
                        if (Settings.instance.subtitleLang == LanguageEnum.NONE)
                        {
                            if (this._movie.defaultSubtitle && _loc_3.lang == this._movie.defaultSubtitle.lang)
                            {
                                this._subtitleDummy.loadLanguage(_loc_3);
                                this._movie.updateCurSubtitlesType(_loc_3.lang);
                                break;
                            }
                        }
                        else if (Settings.instance.subtitleLang == LanguageEnum.NOTHING)
                        {
                            this.clearSubtitle();
                            this._movie.updateCurSubtitlesType(LanguageEnum.NOTHING);
                            break;
                        }
                        else if (_loc_3.lang == Settings.instance.subtitleLang)
                        {
                            this._subtitleDummy.loadLanguage(_loc_3);
                            this._movie.updateCurSubtitlesType(_loc_3.lang);
                            break;
                        }
                        else if (_loc_4 == (_loc_2 - 1))
                        {
                            if (this._movie.defaultSubtitle)
                            {
                                this._subtitleDummy.loadLanguage(this._movie.defaultSubtitle);
                                this._movie.updateCurSubtitlesType(this._movie.defaultSubtitle.lang);
                                break;
                            }
                            else
                            {
                                this._subtitleDummy.loadLanguage(_loc_1[0]);
                                this._movie.updateCurSubtitlesType(_loc_1[0].lang);
                                break;
                            }
                        }
                    }
                    _loc_4++;
                }
            }
            return;
        }// end function

        private function adjustSubtitle() : void
        {
            var _loc_1:* = this._player.realArea;
            if (_loc_1 != null && _loc_1.width != 0 && _loc_1.height != 0)
            {
                this._subtitleTF.width = _loc_1.width - 20;
                this._subtitleTF.height = this._subtitleTF.textHeight + 10;
                this._subtitleSprite.x = _loc_1.x + 10;
                this._subtitleSprite.y = _loc_1.bottom - Settings.instance.subtitlePos - this._subtitleTF.textHeight;
            }
            else
            {
                this._subtitleTF.text = "";
            }
            return;
        }// end function

        private function loadBrand() : void
        {
            var _loc_1:String = null;
            if (this._player.movieModel && this._player.movieInfo)
            {
                if (this._brand && this._brand.parent)
                {
                    this._brand.parent.removeChild(this._brand);
                }
                _loc_1 = Config.BRAND_URL;
                if (this._player.movieInfo.qiyiProduced)
                {
                    _loc_1 = Config.BRAND_QIYIPRODUCED_URL;
                }
                else if (this._player.movieModel.exclusive)
                {
                    _loc_1 = Config.BRAND_EXCLUSIVE_URL;
                }
                else
                {
                    _loc_1 = Config.BRAND_URL;
                }
                this._brand = new Loader();
                this._brand.visible = this._showBrand;
                this._brand.load(new URLRequest(_loc_1));
                this.adjustBrand();
            }
            return;
        }// end function

        private function adjustLogo() : void
        {
            var _loc_1:Rectangle = null;
            var _loc_2:Number = NaN;
            if (this._logo)
            {
                _loc_1 = this._player.realArea;
                _loc_2 = _loc_1.height / 520;
                _loc_2 = _loc_2 > 1.8 ? (1.8) : (_loc_2);
                var _loc_3:* = _loc_2 * 1;
                this._logo.scaleY = _loc_2 * 1;
                this._logo.scaleX = _loc_3;
                this._logo.x = _loc_1.x + _loc_1.width - this._logo.width - 10;
                this._logo.y = _loc_1.y + 8;
            }
            return;
        }// end function

        private function adjustBrand() : void
        {
            var _loc_1:Rectangle = null;
            var _loc_2:Number = NaN;
            if (this._brand)
            {
                _loc_1 = this._player.realArea;
                _loc_2 = _loc_1.height / 520;
                _loc_2 = _loc_2 > 1.1 ? (1.1) : (_loc_2);
                var _loc_3:* = _loc_1.width / 970;
                this._brand.scaleY = _loc_1.width / 970;
                this._brand.scaleX = _loc_3;
                this._brand.x = _loc_1.x + _loc_1.width - 158 * this._brand.scaleX - 15;
                this._brand.y = _loc_1.y + _loc_1.height - 75 * this._brand.scaleY - 15;
            }
            return;
        }// end function

        private function onSubtitleColorChanged(event:Event) : void
        {
            var _loc_2:* = new TextFormat();
            _loc_2.size = Settings.instance.subtitleSize;
            _loc_2.color = Settings.instance.subtitleColor;
            _loc_2.align = TextFormatAlign.CENTER;
            _loc_2.leading = 0;
            this._subtitleTF.defaultTextFormat = _loc_2;
            this._subtitleTF.setTextFormat(_loc_2);
            return;
        }// end function

        private function onSubtitleSizeChanged(event:Event) : void
        {
            var _loc_2:* = new TextFormat();
            _loc_2.size = Settings.instance.subtitleSize;
            _loc_2.color = Settings.instance.subtitleColor;
            _loc_2.align = TextFormatAlign.CENTER;
            _loc_2.leading = 0;
            this._subtitleTF.defaultTextFormat = _loc_2;
            this._subtitleTF.setTextFormat(_loc_2);
            this.adjustSubtitle();
            return;
        }// end function

        private function onSubtitleLangChanged(event:Event) : void
        {
            if (Settings.instance.subtitleLang == LanguageEnum.NONE)
            {
                if (this._movie && this._movie.defaultSubtitle)
                {
                    this.tryLoadSubtitle();
                }
                else
                {
                    this.clearSubtitle();
                }
            }
            else
            {
                this.tryLoadSubtitle();
            }
            return;
        }// end function

        private function onSubtitlePosChanged(event:Event) : void
        {
            this.adjustSubtitle();
            return;
        }// end function

        private function onStatusChanged(event:PlayerEvent) : void
        {
            if (event.data.isAdd as Boolean)
            {
                switch(event.data.status)
                {
                    case StatusEnum.ALREADY_READY:
                    {
                        this.tryLoadSubtitle();
                        this.adjustSubtitle();
                        break;
                    }
                    case StatusEnum.ALREADY_PLAY:
                    {
                        this._needMask = false;
                        this.drawBackground();
                        break;
                    }
                    case StatusEnum.PLAYING:
                    {
                        this.setMaskBackground(false);
                        break;
                    }
                    case StatusEnum.STOPPING:
                    case StatusEnum.STOPED:
                    {
                        this._subtitleTF.text = "";
                        this.setMaskBackground(false);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        private function onRenderAreaChanged(event:PlayerEvent) : void
        {
            this.adjustSubtitle();
            this.adjustLogo();
            this.adjustBrand();
            this.drawBackground();
            return;
        }// end function

        private function onRenderADAreaChanged(event:PlayerEvent) : void
        {
            this.drawBackground();
            return;
        }// end function

        private function onEnterFrame(event:Event) : void
        {
            var _loc_2:Sentence = null;
            var _loc_3:String = this;
            var _loc_4:* = this._frameCount + 1;
            _loc_3._frameCount = _loc_4;
            if (this._frameCount % 5 == 0)
            {
                this._frameCount = 0;
                if (this._player.hasStatus(StatusEnum.PLAYING) || this._player.hasStatus(StatusEnum.ALREADY_PLAY) && this._player.hasStatus(StatusEnum.PAUSED))
                {
                    if (this._subtitleDummy.hasSentence())
                    {
                        _loc_2 = this._subtitleDummy.findSentence(this._player.currentTime);
                        if (_loc_2 != null && _loc_2.content != null)
                        {
                            if (_loc_2.content != this._subtitleTF.text)
                            {
                                this._subtitleTF.text = _loc_2.content;
                                this.adjustSubtitle();
                            }
                        }
                        else
                        {
                            this._subtitleTF.text = "";
                        }
                    }
                }
            }
            return;
        }// end function

        private function onAddToStage(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddToStage);
            this._stage = stage;
            this._stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onStageKey);
            return;
        }// end function

        private function onStageKey(event:KeyboardEvent) : void
        {
            var _loc_2:FileReference = null;
            var _loc_3:String = null;
            try
            {
                _loc_2 = null;
                _loc_3 = "";
                if (event.altKey && event.ctrlKey && event.keyCode == Keyboard.F8 || event.altKey && event.ctrlKey && event.keyCode == 80)
                {
                    _loc_2 = new FileReference();
                    _loc_3 = LogManager.getLifeLogs().join("\n");
                    _loc_2.save(_loc_3, "Log.txt");
                }
                else
                {
                    this._key = this._key + String.fromCharCode(event.charCode);
                    if (this.BOSS_KEY.indexOf(this._key) == -1)
                    {
                        this._key = "";
                    }
                    else if (this._key == this.BOSS_KEY)
                    {
                        Settings.instance.boss = true;
                    }
                    this._logKey = this._logKey + String.fromCharCode(event.charCode);
                    if (this.LOG_KEY.indexOf(this._logKey) == -1)
                    {
                        this._logKey = "";
                    }
                    else if (this._logKey == this.LOG_KEY)
                    {
                        _loc_2 = new FileReference();
                        _loc_3 = LogManager.getLifeLogs().join("\n");
                        _loc_2.save(_loc_3, "Log.txt");
                    }
                }
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        private function onLogoComplete(event:Event) : void
        {
            this._logoLoader.removeEventListener(LogoLoader.Evt_Complete, this.onLogoComplete);
            this.setLogo(this._logoLoader.getLogo());
            this._logoLoader = null;
            return;
        }// end function

        private function onLogoChanged(event:Event) : void
        {
            var _loc_2:int = 0;
            if (this._brand && this._logo && this._logo is MovieClip)
            {
                if (this._brand.parent)
                {
                    this._brand.parent.removeChild(this._brand);
                }
                _loc_2 = MovieClip(this._logo).initLogo;
                if (_loc_2 == 2)
                {
                    try
                    {
                        MovieClip(this._brand.content).gotoAndPlay(1);
                    }
                    catch (e:Error)
                    {
                    }
                    addChild(this._brand);
                }
            }
            return;
        }// end function

    }
}
