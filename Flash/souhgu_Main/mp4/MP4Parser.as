package mp4
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.utils.*;

    public class MP4Parser extends EventDispatcher
    {
        private var mp4Stream:MP4Stream;
        private var moovBox:ContainerBox;
        private var moovParseOk:Boolean;
        private var _metadata:Object;
        private var box:Box;
        private var audioTracks:Vector.<MP4Track>;
        private var videoTracks:Vector.<MP4Track>;
        private var aacSequenceHeader:FLVTagAudio;
        private var avcSequenceHeader:FLVTagVideo;
        private var audioSampleSize:uint;
        private var _samples:Array;

        public function MP4Parser()
        {
            this.clear();
            return;
        }// end function

        public function clear() : void
        {
            var _loc_1:int = 0;
            this.moovBox = null;
            this.moovParseOk = false;
            this._metadata = new Object();
            this.box = null;
            this.mp4Stream = new MP4Stream();
            this.aacSequenceHeader = null;
            this.avcSequenceHeader = null;
            this.audioTracks = new Vector.<MP4Track>;
            this.videoTracks = new Vector.<MP4Track>;
            if (this.samples)
            {
                _loc_1 = 0;
                while (_loc_1 < this.samples.length)
                {
                    
                    this.samples[_loc_1] = null;
                    _loc_1++;
                }
            }
            this.samples = new Array();
            return;
        }// end function

        public function clearBoxes() : void
        {
            if (this.moovBox != null)
            {
                this.moovBox.clear();
            }
            return;
        }// end function

        public function readMP4Boxes(param1:ByteArray) : Boolean
        {
            var oldPosition3:uint;
            var oldPosition2:uint;
            var boxHeader:BoxHeader;
            var bytes:* = param1;
            if (this.moovParseOk)
            {
                return this.moovParseOk;
            }
            var oldPosition1:* = this.mp4Stream.position;
            this.mp4Stream.position = this.mp4Stream.length;
            this.mp4Stream.writeBytes(bytes);
            this.mp4Stream.position = oldPosition1;
            while (true)
            {
                
                if (this.box == null)
                {
                    oldPosition2 = this.mp4Stream.position;
                    try
                    {
                        boxHeader = new BoxHeader();
                        boxHeader.read(this.mp4Stream);
                    }
                    catch (err:MP4ParserError)
                    {
                        this.mp4Stream.position = oldPosition2;
                        break;
                    }
                    this.box = BoxFactory.newBox(boxHeader, null);
                }
                if (this.box.payloadSize > this.mp4Stream.bytesAvailable)
                {
                    break;
                }
                oldPosition3 = this.mp4Stream.position;
                this.box.read(this.mp4Stream);
                this.mp4Stream.position = oldPosition3 + this.box.payloadSize;
                if (this.box.boxType == BoxFactory.MOOV)
                {
                    this.moovBox = this.box as ContainerBox;
                    this.parseMoov();
                }
                this.box = null;
            }
            return this.moovParseOk;
        }// end function

        public function get metadata() : Object
        {
            var _loc_1:ByteArray = null;
            if (this.moovParseOk)
            {
                _loc_1 = new ByteArray();
                _loc_1.writeObject(this._metadata);
                _loc_1.position = 0;
                return _loc_1.readObject();
            }
            return null;
        }// end function

        private function parseMoov() : void
        {
            var _loc_4:ContainerBox = null;
            var _loc_1:* = this.moovBox.getBox(BoxFactory.MVHD) as MVHDBox;
            this._metadata.mp4duration = Math.floor(_loc_1.duration / _loc_1.timeScale * 1000) / 1000;
            this._metadata.duration = this._metadata.mp4duration;
            var _loc_2:* = this.moovBox.getBoxes(BoxFactory.TRAK);
            var _loc_3:int = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_4 = _loc_2[_loc_3] as ContainerBox;
                this.parseTrak(_loc_4);
                _loc_3++;
            }
            this.mergeSamples();
            this.moovParseOk = true;
            return;
        }// end function

        private function mergeSamples() : void
        {
            var _loc_16:MP4Track = null;
            var _loc_17:uint = 0;
            var _loc_18:MP4Sample = null;
            var _loc_1:Number = 0;
            var _loc_2:Number = 0;
            var _loc_3:uint = 0;
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            while (_loc_5 < this.audioTracks.length)
            {
                
                _loc_16 = this.audioTracks[_loc_5];
                _loc_2 = _loc_2 + _loc_16.duration / _loc_16.timeScale;
                _loc_17 = 0;
                while (_loc_17 < _loc_16.samples.length)
                {
                    
                    _loc_18 = _loc_16.samples[_loc_17];
                    _loc_18.handlerType = _loc_16.handlerType;
                    _loc_18.decodingTime = uint(_loc_3 * 1000 / _loc_16.timeScale);
                    _loc_3 = _loc_3 + _loc_18.sampleDelta;
                    _loc_1 = _loc_1 + _loc_18.size;
                    this.samples.push(_loc_18);
                    _loc_17 = _loc_17 + 1;
                }
                _loc_5 = _loc_5 + 1;
            }
            if (this.samples.length > 0)
            {
                _loc_4 = this.samples[(this.samples.length - 1)].decodingTime;
            }
            _loc_3 = 0;
            var _loc_6:Number = 0;
            var _loc_7:Number = 0;
            var _loc_8:uint = 0;
            var _loc_9:uint = 0;
            _loc_5 = 0;
            while (_loc_5 < this.videoTracks.length)
            {
                
                _loc_16 = this.videoTracks[_loc_5];
                _loc_8 = _loc_8 + _loc_16.frameCount;
                _loc_7 = _loc_7 + _loc_16.duration / _loc_16.timeScale;
                _loc_17 = 0;
                while (_loc_17 < _loc_16.samples.length)
                {
                    
                    _loc_18 = _loc_16.samples[_loc_17];
                    _loc_18.handlerType = _loc_16.handlerType;
                    _loc_18.decodingTime = uint(_loc_3 * 1000 / _loc_16.timeScale);
                    _loc_3 = _loc_3 + _loc_18.sampleDelta;
                    _loc_6 = _loc_6 + _loc_18.size;
                    this.samples.push(_loc_18);
                    _loc_17 = _loc_17 + 1;
                }
                _loc_5 = _loc_5 + 1;
            }
            if (this.samples.length > 0)
            {
                _loc_9 = this.samples[(this.samples.length - 1)].decodingTime;
            }
            this.samples.sortOn("decodingTime", Array.NUMERIC);
            this._metadata.framerate = _loc_8 / _loc_7;
            this._metadata.audiodatarate = uint(_loc_1 * 8 / _loc_2 / 1000);
            this._metadata.videodatarate = uint(_loc_6 * 8 / _loc_7 / 1000);
            if (_loc_9 > 0)
            {
                this._metadata.lasttimestamp = _loc_9;
            }
            if (_loc_4 > this._metadata.lasttimestamp)
            {
                this._metadata.lasttimestamp = _loc_4;
            }
            var _loc_10:* = Number.MAX_VALUE;
            var _loc_11:* = this.samples.length - 1;
            while (_loc_11 >= 0)
            {
                
                _loc_18 = this.samples[_loc_11] as MP4Sample;
                _loc_10 = _loc_18.offsetInFile < _loc_10 ? (_loc_18.offsetInFile) : (_loc_10);
                _loc_18.offsetPlayFromNow = _loc_10;
                _loc_11 = _loc_11 - 1;
            }
            var _loc_12:* = new Array();
            var _loc_13:* = new Array();
            var _loc_14:* = new Array();
            var _loc_15:* = new Array();
            _loc_5 = 0;
            while (_loc_5 < this.samples.length)
            {
                
                _loc_18 = this.samples[_loc_5] as MP4Sample;
                if (_loc_18.seekable)
                {
                    _loc_12.push(_loc_18.decodingTime);
                    _loc_13.push(_loc_18.offsetInFile);
                    _loc_15.push(_loc_18.offsetPlayFromNow);
                    _loc_14.push(_loc_5);
                }
                _loc_5 = _loc_5 + 1;
            }
            this._metadata.mp4keyframes = new Object();
            this._metadata.mp4keyframes.times = _loc_12;
            this._metadata.mp4keyframes.filepositions = _loc_13;
            this._metadata.mp4keyframes.fileoffsets = _loc_15;
            this._metadata.mp4keyframes.sampleindex = _loc_14;
            this._metadata.headerba = this.mp4Stream;
            return;
        }// end function

        public function convertSample(param1:Object, param2:ByteArray) : int
        {
            param1.offset = 0;
            return this.convertSample2(param1, param2);
        }// end function

        public function convertSample2(param1:Object, param2:ByteArray, param3:uint = 0) : int
        {
            var _loc_11:FLVTagVideo = null;
            var _loc_12:FLVTagAudio = null;
            var _loc_13:ByteArray = null;
            var _loc_4:int = 1;
            var _loc_5:* = param1.nextSampleIndex;
            var _loc_6:* = this.samples.length - 1;
            var _loc_7:* = param1.dataBuffer;
            var _loc_8:* = param1.offset;
            var _loc_9:* = _loc_5;
            var _loc_10:MP4Sample = null;
            while (_loc_9 <= _loc_6)
            {
                
                _loc_10 = this.samples[_loc_9] as MP4Sample;
                if (_loc_10.offsetInFile + _loc_10.size > _loc_8 + _loc_7.length)
                {
                    break;
                }
                if (_loc_10.handlerType == HDLRBox.VIDE)
                {
                    _loc_11 = new FLVTagVideo();
                    _loc_11.timestamp = _loc_10.decodingTime - param3;
                    _loc_11.frameType = _loc_10.seekable ? (FLVTagVideo.FRAME_TYPE_KEYFRAME) : (FLVTagVideo.FRAME_TYPE_INTER);
                    _loc_11.codecID = _loc_10.codecId;
                    _loc_11.avcPacketType = FLVTagVideo.AVC_PACKET_TYPE_NALU;
                    _loc_11.avcCompositionTimeOffset = _loc_10.compositionTimeOffset;
                    _loc_11.dataSize = _loc_10.size + 5;
                    _loc_11.writeHeader(param2);
                    param2.position = param2.length;
                    param2.writeBytes(_loc_7, _loc_10.offsetInFile - _loc_8, _loc_10.size);
                    _loc_11.writePrevTagSize(param2);
                }
                else if (_loc_10.handlerType == HDLRBox.SOUN)
                {
                    _loc_12 = new FLVTagAudio();
                    _loc_12.timestamp = _loc_10.decodingTime - param3;
                    _loc_12.soundFormat = _loc_10.codecId;
                    _loc_12.soundChannels = FLVTagAudio.SOUND_CHANNELS_STEREO;
                    _loc_12.soundRate = FLVTagAudio.SOUND_RATE_44K;
                    if (this._metadata[this.audioSampleSize] != null && this._metadata[this.audioSampleSize] == 8)
                    {
                        _loc_12.soundSize = FLVTagAudio.SOUND_SIZE_8BITS;
                    }
                    else
                    {
                        _loc_12.soundSize = FLVTagAudio.SOUND_SIZE_16BITS;
                    }
                    _loc_12.isAACSequenceHeader = false;
                    _loc_12.dataSize = _loc_10.size + 2;
                    _loc_12.writeHeader(param2);
                    param2.position = param2.length;
                    param2.writeBytes(_loc_7, _loc_10.offsetInFile - _loc_8, _loc_10.size);
                    _loc_12.writePrevTagSize(param2);
                }
                _loc_9++;
            }
            if (_loc_9 > _loc_6)
            {
                _loc_4 = 0;
            }
            param1.nextSampleIndex = _loc_9;
            if (_loc_10 != null && _loc_9 <= _loc_6 && _loc_7.length > 2097152 && _loc_10.offsetPlayFromNow - _loc_8 < _loc_7.length)
            {
                _loc_13 = new ByteArray();
                _loc_13.writeBytes(_loc_7, _loc_10.offsetPlayFromNow - _loc_8);
                _loc_13.position = 0;
                param1.dataBuffer = _loc_13;
                param1.offset = _loc_10.offsetPlayFromNow;
            }
            return _loc_4;
        }// end function

        private function parseTrak(param1:ContainerBox) : void
        {
            var _loc_18:uint = 0;
            var _loc_19:MP4Sample = null;
            var _loc_20:uint = 0;
            var _loc_21:CTTSRecord = null;
            var _loc_2:* = new MP4Track();
            var _loc_3:* = param1.getBox(BoxFactory.TKHD) as TKHDBox;
            var _loc_4:* = param1.getBox(BoxFactory.MDIA) as ContainerBox;
            var _loc_5:* = (param1.getBox(BoxFactory.MDIA) as ContainerBox).getBox(BoxFactory.MDHD) as MDHDBox;
            _loc_2.duration = _loc_5.duration;
            _loc_2.timeScale = _loc_5.timeScale;
            var _loc_6:* = _loc_4.getBox(BoxFactory.HDLR) as HDLRBox;
            _loc_2.handlerType = _loc_6.handlerType;
            if (_loc_6.handlerType != HDLRBox.VIDE && _loc_6.handlerType != HDLRBox.SOUN)
            {
                return;
            }
            var _loc_7:* = _loc_4.getBox(BoxFactory.MINF) as ContainerBox;
            var _loc_8:* = (_loc_4.getBox(BoxFactory.MINF) as ContainerBox).getBox(BoxFactory.STBL) as ContainerBox;
            var _loc_9:* = ((_loc_4.getBox(BoxFactory.MINF) as ContainerBox).getBox(BoxFactory.STBL) as ContainerBox).getBox(BoxFactory.STTS) as STTSBox;
            _loc_2.samples = new Vector.<MP4Sample>;
            var _loc_10:uint = 0;
            while (_loc_10 < _loc_9.count)
            {
                
                _loc_18 = 0;
                while (_loc_18 < _loc_9.entries[_loc_10].sampleCount)
                {
                    
                    _loc_19 = new MP4Sample();
                    _loc_19.handlerType = _loc_2.handlerType;
                    _loc_19.sampleDelta = _loc_9.entries[_loc_10].sampleDelta;
                    _loc_2.samples.push(_loc_19);
                    _loc_18 = _loc_18 + 1;
                }
                _loc_10 = _loc_10 + 1;
            }
            var _loc_11:* = _loc_2.samples.length;
            var _loc_12:* = _loc_8.getBox(BoxFactory.CTTS) as CTTSBox;
            if (_loc_8.getBox(BoxFactory.CTTS) as CTTSBox != null)
            {
                _loc_20 = 0;
                _loc_10 = 0;
                while (_loc_10 < _loc_12.count)
                {
                    
                    _loc_21 = _loc_12.entries[_loc_10];
                    _loc_18 = 0;
                    while (_loc_18 < _loc_21.sampleCount)
                    {
                        
                        if (_loc_20 < _loc_11)
                        {
                            _loc_2.samples[_loc_20].compositionTimeOffset = uint(_loc_21.sampleOffset * 1000 / _loc_2.timeScale);
                            _loc_20 = _loc_20 + 1;
                        }
                        _loc_18 = _loc_18 + 1;
                    }
                    _loc_10 = _loc_10 + 1;
                }
            }
            var _loc_13:* = _loc_8.getBox(BoxFactory.STSZ) as STSZBox;
            _loc_10 = 0;
            while (_loc_10 < _loc_11)
            {
                
                if (_loc_13.constantSize == 0)
                {
                    _loc_2.samples[_loc_10].size = _loc_13.sizeTable[_loc_10];
                }
                else
                {
                    _loc_2.samples[_loc_10].size = _loc_13.constantSize;
                }
                _loc_10 = _loc_10 + 1;
            }
            var _loc_14:* = _loc_8.getBox(BoxFactory.STSD) as STSDBox;
            this.parseStsd(_loc_14, _loc_2);
            var _loc_15:* = _loc_8.getBox(BoxFactory.STSC) as STSCBox;
            var _loc_16:* = _loc_8.getBox(BoxFactory.STCO) as COBox;
            if (_loc_8.getBox(BoxFactory.STCO) as COBox == null)
            {
                _loc_16 = _loc_8.getBox(BoxFactory.CO64) as COBox;
            }
            this.parseStscAndCo(_loc_15, _loc_16, _loc_2);
            var _loc_17:* = _loc_8.getBox(BoxFactory.STSS) as STSSBox;
            this.parseStss(_loc_17, _loc_2);
            if (_loc_2.handlerType == HDLRBox.VIDE)
            {
                this.videoTracks.push(_loc_2);
            }
            else
            {
                this.audioTracks.push(_loc_2);
            }
            return;
        }// end function

        private function parseStsd(param1:STSDBox, param2:MP4Track) : void
        {
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:VSEBox = null;
            var _loc_7:AVCCBox = null;
            var _loc_8:ASEBox = null;
            var _loc_9:ESDSBox = null;
            var _loc_3:* = new Vector.<int>;
            if (param2.handlerType == HDLRBox.VIDE)
            {
                _loc_4 = 0;
                while (_loc_4 < param1.count)
                {
                    
                    _loc_5 = FLVTagVideo.CODEC_ID_NONE;
                    _loc_6 = param1.descriptions[_loc_4] as VSEBox;
                    if (_loc_6.boxType == BoxFactory.AVC1)
                    {
                        if (!this._metadata.hasOwnProperty("width") || this._metadata.width < _loc_6.width)
                        {
                            this._metadata.width = _loc_6.width;
                        }
                        if (!this._metadata.hasOwnProperty("height") || this._metadata.height < _loc_6.height)
                        {
                            this._metadata.height = _loc_6.height;
                        }
                        param2.frameCount = param2.frameCount + _loc_6.frameCount * param2.samples.length;
                        this._metadata.videocodecid = FLVTagVideo.CODEC_ID_AVC;
                        _loc_5 = FLVTagVideo.CODEC_ID_AVC;
                        _loc_7 = _loc_6.getBox(BoxFactory.AVCC) as AVCCBox;
                        if (_loc_7 != null && _loc_7.configRecord.length > 0 && this.avcSequenceHeader == null)
                        {
                            this.avcSequenceHeader = this.createAVCSequenceHeaderTag(_loc_7.configRecord);
                        }
                    }
                    _loc_3.push(_loc_5);
                    _loc_4++;
                }
            }
            else if (param2.handlerType == HDLRBox.SOUN)
            {
                _loc_4 = 0;
                while (_loc_4 < param1.count)
                {
                    
                    _loc_5 = FLVTagAudio.SOUND_FORMAT_NONE;
                    _loc_8 = param1.descriptions[_loc_4] as ASEBox;
                    if (_loc_8.boxType == BoxFactory.MP4A)
                    {
                        this._metadata.stereo = _loc_8.channelCount >= 2 ? (true) : (false);
                        this._metadata.audiosamplesize = _loc_8.sampleSize;
                        this._metadata.audiosamplerate = _loc_8.sampleRate;
                        this._metadata.audiocodecid = FLVTagAudio.SOUND_FORMAT_AAC;
                        _loc_5 = FLVTagAudio.SOUND_FORMAT_AAC;
                        _loc_9 = _loc_8.getBox(BoxFactory.ESDS) as ESDSBox;
                        if (_loc_9 != null && _loc_9.decoderSpecificInfo.length > 0 && this.aacSequenceHeader == null)
                        {
                            this.aacSequenceHeader = this.createAACSequenceHeaderTag(_loc_9.decoderSpecificInfo);
                        }
                    }
                    _loc_3.push(_loc_5);
                    _loc_4++;
                }
            }
            param2.codecs = _loc_3;
            return;
        }// end function

        private function parseStscAndCo(param1:STSCBox, param2:COBox, param3:MP4Track) : void
        {
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:Object = null;
            var _loc_12:int = 0;
            var _loc_13:uint = 0;
            var _loc_14:int = 0;
            var _loc_4:* = param2.offsetCount - 1;
            var _loc_5:* = new Vector.<Object>(param2.offsetCount);
            var _loc_6:* = param1.count - 1;
            while (_loc_6 >= 0)
            {
                
                _loc_9 = param1.entries[_loc_6].firstChunk - 1;
                while (_loc_9 <= _loc_4)
                {
                    
                    _loc_11 = new Object();
                    _loc_11.sampleCount = param1.entries[_loc_6].samplesPerChunk;
                    _loc_11.sampleDescIndex = param1.entries[_loc_6].sampleDescIndex - 1;
                    _loc_11.offsets = param2.offsets[_loc_9];
                    _loc_5[_loc_9] = _loc_11;
                    _loc_9++;
                }
                _loc_4 = --param1.entries[_loc_6].firstChunk - 1;
                _loc_6 = _loc_6 - 1;
            }
            var _loc_7:int = 0;
            var _loc_8:* = param3.samples.length - 1;
            _loc_9 = 0;
            while (_loc_9 < _loc_5.length)
            {
                
                _loc_12 = _loc_7 + _loc_5[_loc_9].sampleCount - 1;
                if (_loc_12 > _loc_8)
                {
                    _loc_12 = _loc_8;
                }
                _loc_13 = _loc_5[_loc_9].offsets;
                _loc_14 = _loc_7;
                while (_loc_14 <= _loc_12)
                {
                    
                    param3.samples[_loc_14].offsetInFile = _loc_13;
                    param3.samples[_loc_14].codecId = param3.codecs[_loc_5[_loc_9].sampleDescIndex];
                    _loc_13 = _loc_13 + param3.samples[_loc_14].size;
                    _loc_14++;
                }
                _loc_7 = _loc_12 + 1;
                _loc_9++;
            }
            return;
        }// end function

        private function parseStss(param1:STSSBox, param2:MP4Track) : void
        {
            var _loc_3:int = 0;
            var _loc_4:uint = 0;
            var _loc_5:MP4Sample = null;
            if (param1 != null)
            {
                _loc_3 = 0;
                while (_loc_3 < param1.syncCount)
                {
                    
                    _loc_4 = param1.syncTable[_loc_3] - 1;
                    _loc_5 = param2.samples[_loc_4];
                    _loc_5.seekable = true;
                    _loc_3++;
                }
            }
            return;
        }// end function

        private function createAACSequenceHeaderTag(param1:ByteArray) : FLVTagAudio
        {
            var _loc_2:* = new FLVTagAudio();
            _loc_2.tagType = FLVTag.TAG_TYPE_AUDIO;
            _loc_2.timestamp = 0;
            _loc_2.soundFormat = FLVTagAudio.SOUND_FORMAT_AAC;
            _loc_2.soundChannels = FLVTagAudio.SOUND_CHANNELS_STEREO;
            _loc_2.soundRate = FLVTagAudio.SOUND_RATE_44K;
            if (this._metadata[this.audioSampleSize] != null && this._metadata[this.audioSampleSize] == 8)
            {
                _loc_2.soundSize = FLVTagAudio.SOUND_SIZE_8BITS;
            }
            else
            {
                _loc_2.soundSize = FLVTagAudio.SOUND_SIZE_16BITS;
            }
            _loc_2.isAACSequenceHeader = true;
            _loc_2.data = param1;
            return _loc_2;
        }// end function

        public function createFLVHeader() : ByteArray
        {
            var _loc_1:* = new FLVHeader();
            _loc_1.hasAudioTags = true;
            _loc_1.hasVideoTags = true;
            var _loc_2:* = new ByteArray();
            _loc_1.write(_loc_2);
            return _loc_2;
        }// end function

        public function createSequenceHeaderTags() : ByteArray
        {
            var _loc_2:FLVTagAudio = null;
            var _loc_3:FLVTagVideo = null;
            var _loc_1:* = new ByteArray();
            if (this.aacSequenceHeader != null)
            {
                _loc_2 = this.aacSequenceHeader;
                _loc_2.write(_loc_1);
            }
            if (this.avcSequenceHeader != null)
            {
                _loc_3 = this.avcSequenceHeader;
                _loc_3.write(_loc_1);
            }
            return _loc_1;
        }// end function

        private function createAVCSequenceHeaderTag(param1:ByteArray) : FLVTagVideo
        {
            var _loc_2:* = new FLVTagVideo();
            _loc_2.tagType = FLVTag.TAG_TYPE_VIDEO;
            _loc_2.timestamp = 0;
            _loc_2.frameType = FLVTagVideo.FRAME_TYPE_KEYFRAME;
            _loc_2.codecID = FLVTagVideo.CODEC_ID_AVC;
            _loc_2.avcPacketType = FLVTagVideo.AVC_PACKET_TYPE_SEQUENCE_HEADER;
            _loc_2.data = param1;
            return _loc_2;
        }// end function

        public function createLastTag() : ByteArray
        {
            var _loc_1:* = new FLVTagScriptDataObject();
            var _loc_2:* = new ByteArray();
            _loc_1.tagType = FLVTag.TAG_TYPE_SCRIPTDATAOBJECT;
            _loc_1.timestamp = this._metadata.mp4duration * 1000;
            var _loc_3:* = new Object();
            _loc_1.objects = ["onPlayComplete", _loc_3];
            _loc_1.write(_loc_2);
            return _loc_2;
        }// end function

        public function createOnMetaDataTag() : ByteArray
        {
            var _loc_1:* = new FLVTagScriptDataObject();
            var _loc_2:* = new ByteArray();
            _loc_1.tagType = FLVTag.TAG_TYPE_SCRIPTDATAOBJECT;
            _loc_1.timestamp = 0;
            _loc_1.objects = ["onMetaData", this._metadata];
            _loc_1.write(_loc_2);
            return _loc_2;
        }// end function

        public function get samples() : Array
        {
            return this._samples;
        }// end function

        public function set samples(param1:Array) : void
        {
            this._samples = param1;
            return;
        }// end function

    }
}
