package com.sohu.tv.mediaplayer.ui
{
    import com.sohu.tv.mediaplayer.*;
    import com.sohu.tv.mediaplayer.stat.*;
    import ebing.controls.*;
    import ebing.events.*;
    import flash.display.*;
    import flash.events.*;

    public class DefinitionSettingPanelFor56 extends Sprite
    {
        private var _super_btn:ButtonUtil;
        private var _hd_btn:ButtonUtil;
        private var _common_btn:ButtonUtil;
        private var _autoFix:String = "";
        private var _ver:String = "";
        private var _more_xml:Object;
        private var _verStr:String = "普清版";
        private var _bandwidth:uint = 0;
        private var _arrBtnVis:Array;
        private var _width:Number = 0;
        private var _height:Number = 0;

        public function DefinitionSettingPanelFor56(param1:Object)
        {
            this.newFunc();
            this.drawSkin(param1.skin);
            this.addEvent();
            return;
        }// end function

        private function newFunc() : void
        {
            return;
        }// end function

        private function drawSkin(param1:MovieClip) : void
        {
            this._super_btn = new ButtonUtil({skin:param1.super_btn});
            this._hd_btn = new ButtonUtil({skin:param1.hd_btn});
            this._common_btn = new ButtonUtil({skin:param1.common_btn});
            addChild(this._super_btn);
            addChild(this._hd_btn);
            addChild(this._common_btn);
            this._width = this._hd_btn.width;
            this._height = 152;
            var _loc_2:Boolean = false;
            this._super_btn.visible = false;
            var _loc_2:* = _loc_2;
            this._common_btn.visible = _loc_2;
            this._hd_btn.visible = _loc_2;
            this._arrBtnVis = new Array();
            this.resize();
            return;
        }// end function

        private function setOk() : void
        {
            this.close();
            dispatchEvent(new Event("settingFinishFor56"));
            return;
        }// end function

        public function resize() : void
        {
            var _loc_3:int = 0;
            this._arrBtnVis = [];
            var _loc_1:int = 0;
            var _loc_2:* = PlayerConfig.definitionArrFor56;
            if (!PlayerConfig.isSohuFor56)
            {
                if (_loc_2.indexOf("super") != -1)
                {
                    this._arrBtnVis[0] = this._super_btn;
                    _loc_2.splice(_loc_2.indexOf("super"));
                }
                _loc_1 = 0;
                while (_loc_1 < _loc_2.length)
                {
                    
                    switch(_loc_2[_loc_1])
                    {
                        case "clear":
                        {
                            this._arrBtnVis.push(this._hd_btn);
                            break;
                        }
                        case "normal":
                        {
                            this._arrBtnVis.push(this._common_btn);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_1++;
                }
            }
            else
            {
                _loc_1 = 0;
                while (_loc_1 < _loc_2.length)
                {
                    
                    switch(_loc_2[_loc_1])
                    {
                        case "qvga":
                        {
                            this._arrBtnVis.push(this._common_btn);
                            break;
                        }
                        case "vga":
                        {
                            this._arrBtnVis.push(this._hd_btn);
                            break;
                        }
                        case "wvga":
                        {
                            this._arrBtnVis.push(this._super_btn);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_1++;
                }
                this._arrBtnVis.reverse();
            }
            if (this._arrBtnVis != null && this._arrBtnVis.length > 0)
            {
                _loc_3 = 0;
                while (_loc_3 < this._arrBtnVis.length)
                {
                    
                    this._arrBtnVis[_loc_3].x = 0;
                    this._arrBtnVis[_loc_3].y = 30 * _loc_3 + 30 * (5 - this._arrBtnVis.length);
                    this._arrBtnVis[_loc_3].visible = true;
                    _loc_3++;
                }
            }
            return;
        }// end function

        private function addEvent() : void
        {
            this._super_btn.addEventListener(MouseEventUtil.CLICK, this.superr);
            this._hd_btn.addEventListener(MouseEventUtil.CLICK, this.hd);
            this._common_btn.addEventListener(MouseEventUtil.CLICK, this.common);
            return;
        }// end function

        private function superr(param1:MouseEventUtil) : void
        {
            param1.target.enabled = false;
            this._hd_btn.enabled = true;
            this._common_btn.enabled = true;
            this._ver = PlayerConfig.isSohuFor56 ? ("wvga") : ("super");
            this.setOk();
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_720P&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            return;
        }// end function

        private function hd(param1:MouseEventUtil) : void
        {
            param1.target.enabled = false;
            this._super_btn.enabled = true;
            this._common_btn.enabled = true;
            this._ver = PlayerConfig.isSohuFor56 ? ("vga") : ("clear");
            this.setOk();
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_480P&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            return;
        }// end function

        private function common(param1:MouseEventUtil) : void
        {
            param1.target.enabled = false;
            this._super_btn.enabled = true;
            this._hd_btn.enabled = true;
            this._ver = PlayerConfig.isSohuFor56 ? ("qvga") : ("normal");
            this.setOk();
            SendRef.getInstance().sendPQDrog("http://click.hd.sohu.com.cn/s.gif?type=fun_yangli205733_PL_C_320P&s=" + PlayerConfig.stype + "&_=" + new Date().getTime());
            return;
        }// end function

        public function get ver() : String
        {
            return this._ver;
        }// end function

        public function get autoFix() : String
        {
            return this._autoFix;
        }// end function

        public function open() : void
        {
            this.resize();
            this.visible = true;
            if (PlayerConfig.rfilesType == "super" || PlayerConfig.rfilesType == "wvga")
            {
                this._super_btn.enabled = false;
                var _loc_1:Boolean = true;
                this._common_btn.enabled = true;
                this._hd_btn.enabled = _loc_1;
            }
            else if (PlayerConfig.rfilesType == "clear" || PlayerConfig.rfilesType == "vga")
            {
                this._hd_btn.enabled = false;
                var _loc_1:Boolean = true;
                this._common_btn.enabled = true;
                this._super_btn.enabled = _loc_1;
            }
            else if (PlayerConfig.rfilesType == "normal" || PlayerConfig.rfilesType == "qvga")
            {
                this._common_btn.enabled = false;
                var _loc_1:Boolean = true;
                this._hd_btn.enabled = true;
                this._super_btn.enabled = _loc_1;
            }
            return;
        }// end function

        public function close() : void
        {
            this.visible = false;
            return;
        }// end function

        private function onStatusShare(event:NetStatusEvent) : void
        {
            if (event.info.code == "SharedObject.Flush.Success")
            {
            }
            else if (event.info.code == "SharedObject.Flush.Failed")
            {
            }
            event.target.removeEventListener(NetStatusEvent.NET_STATUS, this.onStatusShare);
            return;
        }// end function

        override public function get width() : Number
        {
            return this._width;
        }// end function

        override public function get height() : Number
        {
            return this._height;
        }// end function

    }
}
