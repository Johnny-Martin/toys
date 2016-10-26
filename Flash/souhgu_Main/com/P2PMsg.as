package com
{

    public class P2PMsg extends Object
    {
        public static const P2P_END_UNKNOW:uint = 0;
        public static const P2P_END_CENTER:uint = 1;
        public static const P2P_END_PROXY:uint = 2;
        public static const P2P_END_TRACK:uint = 3;
        public static const P2P_END_GETWAY:uint = 4;
        public static const P2P_END_STAT:uint = 5;
        public static const P2P_END_REGISTER:uint = 6;
        public static const P2P_END_PUSH:uint = 7;
        public static const P2P_END_LND:uint = 8;
        public static const P2P_END_NGNIX:uint = 9;
        public static const P2P_END_ANDROID:uint = 60;
        public static const P2P_END_APPLE:uint = 61;
        public static const P2P_END_FLASH:uint = 62;
        public static const P2P_END_IFOX:uint = 63;
        public static const P2P_MARK:uint = 844125523;
        public static const P2P_RESERVED:uint = 0;
        public static const P2P_REQUEST:uint = 0;
        public static const P2P_RESPONSE:uint = 2.14748e+009;
        public static const P2P_HEART:uint = 1;
        public static const P2P_PROXY_AND_PROXY_ACROSS:uint = 1025;
        public static const P2P_GETWAY_AND_CLIENT_SOURCE:uint = 261;
        public static const P2P_PROXY_AND_CLIENT_LOGIN:uint = 257;
        public static const P2P_PROXY_AND_CLIENT_ADDFILE:uint = 258;
        public static const P2P_PROXY_AND_CLIENT_REMOVEFILE:uint = 259;
        public static const P2P_PROXY_AND_CLIENT_LIVE_PEERS:uint = 260;
        public static const P2P_PROXY_AND_CLIENT_VOD_PEERS:uint = 263;
        public static const P2P_PROXY_AND_CLIENT_STAT:uint = 264;
        public static const P2P_PROXY_AND_CLIENT_MIX_PEERS:uint = 265;
        public static const P2P_PROXY_AND_CLIENT_NAT:uint = 266;

        public function P2PMsg()
        {
            return;
        }// end function

    }
}
