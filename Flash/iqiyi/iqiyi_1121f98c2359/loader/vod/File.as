package loader.vod
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;

    public class File extends EventDispatcher
    {
        private var _init:Boolean = false;
        private var _fileState:FileState;
        private var _key:String;
        private var _data:VideoData;
        public static const Evt_P2P_Final_Error:String = "Evt_P2P_Final_Error";
        public static const Evt_P2P_StateChange:String = "Evt_P2P_CDN_Error";

        public function File(param1:String)
        {
            this._key = param1;
            return;
        }// end function

        private function stateChange() : void
        {
            dispatchEvent(new Event(Evt_P2P_StateChange));
            return;
        }// end function

        private function finalFail() : void
        {
            dispatchEvent(new Event(Evt_P2P_Final_Error));
            return;
        }// end function

        public function initFile(param1:DisplayObjectContainer, param2:NetStream, param3:Object, param4:String, param5:Number, param6:Number, param7:Array, param8:Array, param9:Number, param10:String, param11:Number, param12:Number, param13:String, param14:String, param15:Number, param16:String, param17:Boolean, param18:Boolean, param19:String, param20:String, param21:Object, param22, param23:Boolean, param24:String, param25:String) : void
        {
            var $stage:* = param1;
            var $stream:* = param2;
            var $cknsp:* = param3;
            var $userIP:* = param4;
            var $startTime:* = param5;
            var $serverTime:* = param6;
            var $videoInfo:* = param7;
            var $metaInfo:* = param8;
            var $definition:* = param9;
            var $originID:* = param10;
            var $lid:* = param11;
            var $channelID:* = param12;
            var $albumID:* = param13;
            var $tvId:* = param14;
            var $endTime:* = param15;
            var $playType:* = param16;
            var $vip:* = param17;
            var $onP2P:* = param18;
            var $uuid:* = param19;
            var $pid:* = param20;
            var $log:* = param21;
            var $calc:* = param22;
            var $playing:* = param23;
            var $platID:* = param24;
            var $platfrom:* = param25;
            try
            {
                var _loc_27:* = this._file;
                _loc_27.this._file["initFile"](this.finalFail, this.stateChange, $stage, $stream, $cknsp, $userIP, $startTime, $serverTime, $videoInfo, $metaInfo, $definition, $originID, $lid, $channelID, $albumID, $tvId, $endTime, $playType, $vip, $onP2P, $uuid, $pid, $log, $calc, $playing, $platID, $platfrom);
                this._fileState = new FileState(this._key);
            }
            catch ($err:Error)
            {
                var _loc_28:* = $log;
                _loc_28.$log["info"]("__P2P__ : init Error" + " : " + $err.message);
            }
            this._init = true;
            return;
        }// end function

        public function get fileState() : FileState
        {
            if (!this._init)
            {
                return null;
            }
            return this._fileState;
        }// end function

        public function get bufferLength() : int
        {
            if (!this._init)
            {
                return 0;
            }
            return this._file["bufferLength"];
        }// end function

        public function get realBuff() : int
        {
            if (!this._init)
            {
                return 0;
            }
            return this._file["realBuff"];
        }// end function

        public function get eof() : Boolean
        {
            if (!this._init)
            {
                return false;
            }
            return this._file["eof"];
        }// end function

        public function get done() : Boolean
        {
            if (!this._init)
            {
                return false;
            }
            return this._file["done"];
        }// end function

        public function setToggleLoading(param1:Boolean) : void
        {
            if (!this._init)
            {
                return;
            }
            this._file["setToggleLoading"] = param1;
            return;
        }// end function

        public function set startTime(param1:Number) : void
        {
            if (!this._init)
            {
                return;
            }
            this._file["startTime"] = param1;
            return;
        }// end function

        public function set metaInfo(param1:Array) : void
        {
            if (!this._init)
            {
                return;
            }
            this._file["metaInfo"] = param1;
            return;
        }// end function

        public function set endTime(param1:Number) : void
        {
            if (!this._init)
            {
                return;
            }
            this._file["endTime"] = param1;
            return;
        }// end function

        public function set expectPlayTime(param1:uint) : void
        {
            if (!this._init)
            {
                return;
            }
            this._file["expectPlayTime"] = param1;
            return;
        }// end function

        public function read() : VideoData
        {
            if (!this._init)
            {
                return null;
            }
            var _loc_2:* = this._file;
            var _loc_1:* = _loc_2.this._file["read"]();
            if (_loc_1)
            {
                if (!this._data)
                {
                    this._data = new VideoData();
                }
                this._data.data = _loc_1;
                return this._data;
            }
            else
            {
                return null;
            }
        }// end function

        public function readFrom(param1:int) : VideoData
        {
            if (!this._init)
            {
                return null;
            }
            if (!this._data)
            {
                this._data = new VideoData();
            }
            var _loc_3:* = this._file;
            var _loc_2:* = _loc_3.this._file["readFrom"](param1);
            if (_loc_2)
            {
                if (!this._data)
                {
                    this._data = new VideoData();
                }
                this._data.data = _loc_2;
                return this._data;
            }
            else
            {
                return null;
            }
        }// end function

        public function set lag(param1:Boolean) : void
        {
            if (!this._init)
            {
                return;
            }
            this._file["lag"] = param1;
            return;
        }// end function

        public function set fragments(param1:Array) : void
        {
            if (!this._init)
            {
                return;
            }
            this._file["fragments"] = param1;
            return;
        }// end function

        public function set userPause(param1:Boolean) : void
        {
            if (!this._init)
            {
                return;
            }
            this._file["userPause"] = param1;
            return;
        }// end function

        public function clear() : void
        {
            if (!this._init)
            {
                return;
            }
            P2PFileLoader.instance.deleteFile(this._key);
            return;
        }// end function

        public function destroy() : void
        {
            if (!this._init)
            {
                return;
            }
            var _loc_1:* = this._file;
            _loc_1.this._file["destroy"]();
            return;
        }// end function

        public function seek(param1:int, param2:Number, param3:Number, param4:int = 0) : void
        {
            if (!this._init)
            {
                throw "File need be init first!";
            }
            var _loc_5:* = this._file;
            _loc_5.this._file["seek"](param1, param2 + "_" + param3, param4);
            return;
        }// end function

        public function set playing(param1:Boolean) : void
        {
            if (!this._init)
            {
                throw "File need be init first!";
            }
            this._file["playing"] = param1;
            return;
        }// end function

        private function get _file() : Object
        {
            return P2PFileLoader.instance.get(this._key);
        }// end function

    }
}
