package server
{
    import com.*;
    import configbag.*;
    import flash.net.*;
    import flash.utils.*;

    public class DebugServer extends Object
    {
        private static var paramidip:String;
        private static var peerInfoA:Array = new Array();
        private static var cdnInfoA:Array = new Array();

        public function DebugServer()
        {
            return;
        }// end function

        public static function sendMsg(... args) : void
        {
            args = null;
            if (!Config.getInstance().hasparselog)
            {
                return;
            }
            switch(args[0])
            {
                case "LOGIN":
                {
                    args = "&relogin=" + args[1];
                    break;
                }
                case "SCH":
                {
                    args = "&error=" + args[1] + "&stime=" + args[2] + "&url=" + args[3] + "&http_status=" + args[4];
                }
                case "CDN":
                {
                    args = "&error=" + args[1] + "&stime=" + args[2] + "&url=" + args[3] + (args[4] != null ? ("&http_status=" + args[4]) : (""));
                    break;
                }
                case "SEEK":
                {
                    args = "&peerid=" + DebugServer.pid + "&pip=" + DebugServer.pip + "&nsbuf=" + args[1] + "&nibuf=" + args[2] + "&nvbuf=" + args[3] + "&nabuf=" + args[4] + "&dlinfo=" + args[5];
                    break;
                }
                case "ROLLBACK":
                {
                    args = "&rolltype=" + args[1] + (args[2] == null ? ("") : ("&param=" + args[2]));
                }
                default:
                {
                    break;
                }
            }
            if (args[0] == "SEEK")
            {
                P2pSohuLib.getInstance().showTestInfo("@@@@@ seek" + "&vid=" + Config.getInstance().vid + "&pid=" + Config.getInstance().pid + "&type=" + args[0] + args);
            }
            else
            {
                DebugServer.send("version=" + Config.getInstance().version + "&vid=" + Config.getInstance().vid + "&pid=" + DebugServer.pid + "&pip=" + DebugServer.pip + "&type=" + args[0] + args);
            }
            return;
        }// end function

        private static function savePeerInfo(param1:Array) : void
        {
            if (DebugServer.peerInfoA.length >= 5)
            {
                DebugServer.peerInfoA.shift();
            }
            DebugServer.peerInfoA.push(String(param1[1]));
            return;
        }// end function

        private static function saveCdnInfo(param1:Array) : void
        {
            if (DebugServer.cdnInfoA.length >= 5)
            {
                DebugServer.cdnInfoA.shift();
            }
            DebugServer.cdnInfoA.push(String(param1[1]));
            return;
        }// end function

        private static function getInfo(param1:Array) : String
        {
            var _loc_4:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_2:* = new Dictionary();
            var _loc_3:int = 0;
            while (_loc_3 < param1.length)
            {
                
                if (_loc_2[param1[_loc_3]] == undefined)
                {
                    _loc_2[param1[_loc_3]] = 1;
                }
                _loc_8 = _loc_3 + 1;
                while (_loc_8 < param1.length)
                {
                    
                    if (param1[_loc_3] == param1[_loc_8])
                    {
                        _loc_9 = _loc_2[param1[_loc_3]];
                        _loc_9 = _loc_9 + 1;
                        _loc_2[param1[_loc_3]] = _loc_9;
                    }
                    _loc_8++;
                }
                _loc_3++;
            }
            var _loc_5:int = 1;
            for (_loc_6 in _loc_2)
            {
                
                if (_loc_2[_loc_6] >= 3)
                {
                    _loc_4 = String(_loc_6);
                    break;
                    continue;
                }
                if (_loc_2[_loc_6] == 2)
                {
                    if (_loc_5 < 2)
                    {
                        _loc_4 = null;
                    }
                    _loc_5 = 2;
                    if (_loc_4 == null)
                    {
                        _loc_4 = String(_loc_6);
                    }
                    else
                    {
                        _loc_4 = _loc_4 + ("a" + String(_loc_6));
                    }
                    continue;
                }
                if (_loc_2[_loc_6] == 1 && _loc_5 == 1)
                {
                    if (_loc_4 == null)
                    {
                        _loc_4 = String(_loc_6);
                        continue;
                    }
                    _loc_4 = _loc_4 + ("a" + String(_loc_6));
                }
            }
            param1.splice(0);
            for (_loc_7 in _loc_2)
            {
                
                _loc_2[_loc_7] = null;
                delete _loc_2[_loc_7];
            }
            _loc_2 = new Dictionary();
            if (_loc_4 == null)
            {
                _loc_4 = "0";
            }
            return _loc_4;
        }// end function

        private static function send(param1:String) : void
        {
            var _loc_2:* = DebugServer.createUID();
            var _loc_3:* = new URLRequest("http://220.181.89.72/do/" + _loc_2 + "?" + param1);
            _loc_3.url = encodeURI(_loc_3.url);
            trace(_loc_3.url);
            P2pSohuLib.getInstance().showTestInfo(_loc_3.url);
            try
            {
                sendToURL(_loc_3);
            }
            catch (e:Error)
            {
            }
            param1 = null;
            _loc_3 = null;
            return;
        }// end function

        public static function createUID() : String
        {
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_1:String = "";
            var _loc_2:String = "0123456789abcdef";
            _loc_3 = 0;
            while (_loc_3 < 8)
            {
                
                _loc_1 = _loc_1 + _loc_2.charAt(Math.round(Math.random() * 15));
                _loc_3++;
            }
            _loc_3 = 0;
            while (_loc_3 < 3)
            {
                
                _loc_1 = _loc_1 + "-";
                _loc_4 = 0;
                while (_loc_4 < 4)
                {
                    
                    _loc_1 = _loc_1 + _loc_2.charAt(Math.round(Math.random() * 15));
                    _loc_4++;
                }
                _loc_3++;
            }
            _loc_1 = _loc_1 + "-";
            var _loc_5:* = new Date().getTime();
            _loc_1 = _loc_1 + ("000000000" + _loc_5.toString(16)).substr(-8);
            _loc_3 = 0;
            while (_loc_3 < 4)
            {
                
                _loc_1 = _loc_1 + _loc_2.charAt(Math.round(Math.random() * 15));
                _loc_3++;
            }
            return _loc_1;
        }// end function

        private static function get pid() : String
        {
            return Config.getInstance().peerID;
        }// end function

        private static function get pip() : String
        {
            return LoginMsg._instance.ip;
        }// end function

    }
}
