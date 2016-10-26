package mp4
{

    public class BoxFactory extends Object
    {
        public static const FTYP:String = "ftyp";
        public static const MOOV:String = "moov";
        public static const MVHD:String = "mvhd";
        public static const TRAK:String = "trak";
        public static const TKHD:String = "tkhd";
        public static const MDIA:String = "mdia";
        public static const MDHD:String = "mdhd";
        public static const HDLR:String = "hdlr";
        public static const MINF:String = "minf";
        public static const STBL:String = "stbl";
        public static const STSD:String = "stsd";
        public static const STTS:String = "stts";
        public static const CTTS:String = "ctts";
        public static const STSZ:String = "stsz";
        public static const STCO:String = "stco";
        public static const CO64:String = "co64";
        public static const STSS:String = "stss";
        public static const STSC:String = "stsc";
        public static const AVC1:String = "avc1";
        public static const MP4A:String = "mp4a";
        public static const AVCC:String = "avcC";
        public static const ESDS:String = "esds";
        public static const MDAT:String = "mdat";

        public function BoxFactory()
        {
            return;
        }// end function

        public static function newBox(param1:BoxHeader, param2:Box) : Box
        {
            var _loc_3:Box = null;
            switch(param1.boxType)
            {
                case FTYP:
                {
                    _loc_3 = new FTYPBox(param1, param2);
                    break;
                }
                case MOOV:
                case TRAK:
                case MDIA:
                case MINF:
                case STBL:
                {
                    _loc_3 = new ContainerBox(param1, param2);
                    break;
                }
                case MVHD:
                {
                    _loc_3 = new MVHDBox(param1, param2);
                    break;
                }
                case TKHD:
                {
                    _loc_3 = new TKHDBox(param1, param2);
                    break;
                }
                case MDHD:
                {
                    _loc_3 = new MDHDBox(param1, param2);
                    break;
                }
                case HDLR:
                {
                    _loc_3 = new HDLRBox(param1, param2);
                    break;
                }
                case STTS:
                {
                    _loc_3 = new STTSBox(param1, param2);
                    break;
                }
                case CTTS:
                {
                    _loc_3 = new CTTSBox(param1, param2);
                    break;
                }
                case STSC:
                {
                    _loc_3 = new STSCBox(param1, param2);
                    break;
                }
                case STSZ:
                {
                    _loc_3 = new STSZBox(param1, param2);
                    break;
                }
                case STCO:
                case CO64:
                {
                    _loc_3 = new COBox(param1, param2);
                    break;
                }
                case STSS:
                {
                    _loc_3 = new STSSBox(param1, param2);
                    break;
                }
                case STSD:
                {
                    _loc_3 = new STSDBox(param1, param2);
                    break;
                }
                case MDAT:
                {
                    _loc_3 = new MDATBox(param1, param2);
                    break;
                }
                case AVC1:
                {
                    if (param2.boxType == STSD)
                    {
                        _loc_3 = new VSEBox(param1, param2);
                    }
                    break;
                }
                case MP4A:
                {
                    if (param2.boxType == STSD)
                    {
                        _loc_3 = new ASEBox(param1, param2);
                    }
                    break;
                }
                case AVCC:
                {
                    _loc_3 = new AVCCBox(param1, param2);
                    break;
                }
                case ESDS:
                {
                    _loc_3 = new ESDSBox(param1, param2);
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            if (_loc_3 == null)
            {
                _loc_3 = new UnknownBox(param1, param2);
            }
            return _loc_3;
        }// end function

    }
}
