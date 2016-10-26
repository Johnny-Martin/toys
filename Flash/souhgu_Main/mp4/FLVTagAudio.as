﻿package mp4
{
    import flash.utils.*;

    public class FLVTagAudio extends FLVTag
    {
        public static const SOUND_FORMAT_NONE:int = -1;
        public static const SOUND_FORMAT_LINEAR:int = 0;
        public static const SOUND_FORMAT_ADPCM:int = 1;
        public static const SOUND_FORMAT_MP3:int = 2;
        public static const SOUND_FORMAT_LINEAR_LE:int = 3;
        public static const SOUND_FORMAT_NELLYMOSER_16K:int = 4;
        public static const SOUND_FORMAT_NELLYMOSER_8K:int = 5;
        public static const SOUND_FORMAT_NELLYMOSER:int = 6;
        public static const SOUND_FORMAT_G711A:int = 7;
        public static const SOUND_FORMAT_G711U:int = 8;
        public static const SOUND_FORMAT_AAC:int = 10;
        public static const SOUND_FORMAT_SPEEX:int = 11;
        public static const SOUND_FORMAT_MP3_8K:int = 14;
        public static const SOUND_FORMAT_DEVICE_SPECIFIC:int = 15;
        public static const SOUND_RATE_5K:Number = 5512.5;
        public static const SOUND_RATE_11K:Number = 11025;
        public static const SOUND_RATE_22K:Number = 22050;
        public static const SOUND_RATE_44K:Number = 44100;
        public static const SOUND_SIZE_8BITS:int = 8;
        public static const SOUND_SIZE_16BITS:int = 16;
        public static const SOUND_CHANNELS_MONO:int = 1;
        public static const SOUND_CHANNELS_STEREO:int = 2;

        public function FLVTagAudio(param1:int = 8)
        {
            super(param1);
            return;
        }// end function

        public function get soundFormatByte() : int
        {
            return bytes[TAG_HEADER_BYTE_COUNT + 0];
        }// end function

        public function set soundFormatByte(param1:int) : void
        {
            bytes[TAG_HEADER_BYTE_COUNT + 0] = param1;
            return;
        }// end function

        public function get soundFormat() : int
        {
            return bytes[TAG_HEADER_BYTE_COUNT + 0] >> 4 & 15;
        }// end function

        public function set soundFormat(param1:int) : void
        {
            bytes[TAG_HEADER_BYTE_COUNT + 0] = bytes[TAG_HEADER_BYTE_COUNT + 0] & 15;
            bytes[TAG_HEADER_BYTE_COUNT + 0] = bytes[TAG_HEADER_BYTE_COUNT + 0] | param1 << 4 & 240;
            if (param1 == SOUND_FORMAT_AAC)
            {
                this.soundRate = SOUND_RATE_44K;
                this.soundChannels = SOUND_CHANNELS_STEREO;
                this.isAACSequenceHeader = false;
            }
            return;
        }// end function

        public function get soundRate() : Number
        {
            switch(bytes[TAG_HEADER_BYTE_COUNT + 0] >> 2 & 3)
            {
                case 0:
                {
                    return SOUND_RATE_5K;
                }
                case 1:
                {
                    return SOUND_RATE_11K;
                }
                case 2:
                {
                    return SOUND_RATE_22K;
                }
                case 3:
                {
                    return SOUND_RATE_44K;
                }
                default:
                {
                    break;
                }
            }
            throw new Error("get soundRate() a two-bit number wasn\'t 0, 1, 2, or 3. impossible.");
        }// end function

        public function set soundRate(param1:Number) : void
        {
            var _loc_2:int = 0;
            switch(param1)
            {
                case SOUND_RATE_5K:
                {
                    _loc_2 = 0;
                    break;
                }
                case SOUND_RATE_11K:
                {
                    _loc_2 = 1;
                    break;
                }
                case SOUND_RATE_22K:
                {
                    _loc_2 = 2;
                    break;
                }
                case SOUND_RATE_44K:
                {
                    _loc_2 = 3;
                    break;
                }
                default:
                {
                    throw new Error("set soundRate valid values 5512.5, 11025, 22050, 44100");
                    break;
                }
            }
            bytes[TAG_HEADER_BYTE_COUNT + 0] = bytes[TAG_HEADER_BYTE_COUNT + 0] & 243;
            bytes[TAG_HEADER_BYTE_COUNT + 0] = bytes[TAG_HEADER_BYTE_COUNT + 0] | _loc_2 << 2;
            return;
        }// end function

        public function get soundSize() : int
        {
            if (bytes[TAG_HEADER_BYTE_COUNT + 0] >> 1 & 1)
            {
                return SOUND_SIZE_16BITS;
            }
            return SOUND_SIZE_8BITS;
        }// end function

        public function set soundSize(param1:int) : void
        {
            switch(param1)
            {
                case SOUND_SIZE_8BITS:
                {
                    bytes[TAG_HEADER_BYTE_COUNT + 0] = bytes[TAG_HEADER_BYTE_COUNT + 0] & 253;
                    break;
                }
                case SOUND_SIZE_16BITS:
                {
                    bytes[TAG_HEADER_BYTE_COUNT + 0] = bytes[TAG_HEADER_BYTE_COUNT + 0] | 2;
                    break;
                }
                default:
                {
                    throw new Error("set soundSize valid values 8, 16");
                    break;
                }
            }
            return;
        }// end function

        public function get soundChannels() : int
        {
            if (bytes[TAG_HEADER_BYTE_COUNT + 0] & 1)
            {
                return SOUND_CHANNELS_STEREO;
            }
            return SOUND_CHANNELS_MONO;
        }// end function

        public function set soundChannels(param1:int) : void
        {
            switch(param1)
            {
                case SOUND_CHANNELS_MONO:
                {
                    bytes[TAG_HEADER_BYTE_COUNT + 0] = bytes[TAG_HEADER_BYTE_COUNT + 0] & 254;
                    break;
                }
                case SOUND_CHANNELS_STEREO:
                {
                    bytes[TAG_HEADER_BYTE_COUNT + 0] = bytes[TAG_HEADER_BYTE_COUNT + 0] | 1;
                    break;
                }
                default:
                {
                    throw new Error("set soundChannels valid values 1, 2");
                    break;
                }
            }
            return;
        }// end function

        public function get isAACSequenceHeader() : Boolean
        {
            if (this.soundFormat != SOUND_FORMAT_AAC)
            {
                throw new Error("get isAACSequenceHeader not valid if soundFormat != SOUND_FORMAT_AAC");
            }
            if (bytes[(TAG_HEADER_BYTE_COUNT + 1)] == 0)
            {
                return true;
            }
            return false;
        }// end function

        public function set isAACSequenceHeader(param1:Boolean) : void
        {
            if (this.soundFormat != SOUND_FORMAT_AAC)
            {
                throw new Error("set isAACSequenceHeader not valid if soundFormat != SOUND_FORMAT_AAC");
            }
            if (param1)
            {
                bytes[(TAG_HEADER_BYTE_COUNT + 1)] = 0;
            }
            else
            {
                bytes[(TAG_HEADER_BYTE_COUNT + 1)] = 1;
            }
            return;
        }// end function

        public function get isCodecConfiguration() : Boolean
        {
            switch(this.soundFormat)
            {
                case FLVTagAudio.SOUND_FORMAT_AAC:
                {
                    if (this.isAACSequenceHeader)
                    {
                        return true;
                    }
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return false;
        }// end function

        override public function get data() : ByteArray
        {
            var _loc_1:* = new ByteArray();
            if (this.soundFormat == SOUND_FORMAT_AAC)
            {
                _loc_1.writeBytes(bytes, TAG_HEADER_BYTE_COUNT + 2, dataSize - 2);
            }
            else
            {
                _loc_1.writeBytes(bytes, (TAG_HEADER_BYTE_COUNT + 1), (dataSize - 1));
            }
            return _loc_1;
        }// end function

        override public function set data(param1:ByteArray) : void
        {
            if (this.soundFormat == SOUND_FORMAT_AAC)
            {
                bytes.length = TAG_HEADER_BYTE_COUNT + param1.length + 2;
                bytes.position = TAG_HEADER_BYTE_COUNT + 2;
                bytes.writeBytes(param1, 0, param1.length);
                dataSize = param1.length + 2;
            }
            else
            {
                bytes.length = TAG_HEADER_BYTE_COUNT + param1.length + 1;
                bytes.position = TAG_HEADER_BYTE_COUNT + 1;
                bytes.writeBytes(param1, 0, param1.length);
                dataSize = param1.length + 1;
            }
            return;
        }// end function

        override public function writeHeader(param1:ByteArray) : void
        {
            if (this.soundFormat == SOUND_FORMAT_AAC)
            {
                param1.writeBytes(bytes, 0, TAG_HEADER_BYTE_COUNT + 2);
            }
            else
            {
                param1.writeBytes(bytes, 0, (TAG_HEADER_BYTE_COUNT + 1));
            }
            return;
        }// end function

    }
}
