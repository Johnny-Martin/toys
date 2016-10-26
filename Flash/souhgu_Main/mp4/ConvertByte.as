package mp4
{
    import flash.utils.*;

    public class ConvertByte extends Object
    {
        private var mp4Parser:MP4Parser;
        private var _isopen:Boolean = false;
        private var _isSeek:Boolean = false;
        private var _metadata:Object = null;
        private var _seekPoint:int = 0;
        private var _seekInfo:Object = null;
        private var buffer:ByteArray;
        private var _status:Object = null;
        public var metadataF:Function = null;
        private var _isfirst:Boolean = false;

        public function ConvertByte()
        {
            this.buffer = new ByteArray();
            return;
        }// end function

        public function openMth() : void
        {
            trace("convertbyte   openMth");
            this.mp4Parser = new MP4Parser();
            this.buffer = new ByteArray();
            this._isopen = true;
            this._isSeek = false;
            this._metadata = null;
            this._seekPoint = 0;
            this._seekInfo = null;
            this._status = null;
            this._isfirst = false;
            return;
        }// end function

        public function closeMth() : void
        {
            trace("convertbyte   closeMth");
            if (this.mp4Parser != null)
            {
                this.mp4Parser.clearBoxes();
                this.mp4Parser.clear();
            }
            this.mp4Parser = null;
            if (this.buffer != null)
            {
                this.buffer.clear();
            }
            this.buffer = null;
            this._isopen = false;
            this._isSeek = false;
            this._metadata = null;
            this._seekPoint = 0;
            this._seekInfo = null;
            this._status = null;
            return;
        }// end function

        public function transferData(param1:ByteArray, param2:Boolean = false, param3:Boolean = false, param4:uint = 0) : ByteArray
        {
            var _loc_5:* = new ByteArray();
            this.buffer.position = this.buffer.length;
            this.buffer.writeBytes(param1, 0, param1.length);
            if (this._metadata == null)
            {
                this.transferHeader(param1);
            }
            if (param3 && this._isfirst == false)
            {
                this._isfirst = param3;
            }
            if (!this._metadata)
            {
                return _loc_5;
            }
            if (!this._status)
            {
                if (this._isfirst)
                {
                    _loc_5.writeBytes(this.mp4Parser.createFLVHeader());
                    _loc_5.writeBytes(this.mp4Parser.createOnMetaDataTag());
                    _loc_5.writeBytes(this.mp4Parser.createSequenceHeaderTags());
                    this._isfirst = false;
                }
                this._status = new Object();
                if (this._seekInfo != null)
                {
                    this._status.nextSampleIndex = this._seekInfo.sampleindex;
                    this._status.offset = this._seekInfo.fileoffset;
                    this._status.dataBuffer = this.buffer;
                    this.mp4Parser.convertSample2(this._status, _loc_5, this._seekInfo.time);
                    this.buffer = this._status.dataBuffer;
                    return _loc_5;
                }
                this._status.nextSampleIndex = 0;
                this._status.offset = 0;
                this._status.dataBuffer = this.buffer;
            }
            if (this._seekInfo != null)
            {
                this.mp4Parser.convertSample2(this._status, _loc_5, this._seekInfo.time);
            }
            else
            {
                this.mp4Parser.convertSample2(this._status, _loc_5, param4);
            }
            this.buffer = this._status.dataBuffer;
            if (param2)
            {
                _loc_5.writeBytes(this.mp4Parser.createLastTag());
            }
            return _loc_5;
        }// end function

        public function getLeftSampleIndexFromTime(param1:int) : Object
        {
            var _loc_2:Object = null;
            if (!this._metadata)
            {
                this._metadata = this.mp4Parser.metadata;
            }
            if (!this._metadata)
            {
                return _loc_2;
            }
            var _loc_3:* = this._metadata.mp4keyframes.times.length - 1;
            while (_loc_3 >= 0)
            {
                
                if (this._metadata.mp4keyframes.times[_loc_3] < param1)
                {
                    _loc_2 = new Object();
                    _loc_2.time = this._metadata.mp4keyframes.times[_loc_3];
                    _loc_2.fileposition = this._metadata.mp4keyframes.filepositions[_loc_3];
                    _loc_2.fileoffset = this._metadata.mp4keyframes.fileoffsets[_loc_3];
                    _loc_2.sampleindex = this._metadata.mp4keyframes.sampleindex[_loc_3];
                    return _loc_2;
                }
                _loc_3 = _loc_3 - 1;
            }
            return _loc_2;
        }// end function

        public function seekMth(param1:int) : Object
        {
            this._seekInfo = this.getLeftSampleIndexFromTime(param1);
            return this._seekInfo;
        }// end function

        public function transferHeader(param1:ByteArray, param2:Boolean = false) : Boolean
        {
            if (param2)
            {
                this.closeMth();
                this.openMth();
            }
            if (this._metadata)
            {
                return true;
            }
            this.mp4Parser.readMP4Boxes(param1);
            this._metadata = this.mp4Parser.metadata;
            if (this._metadata)
            {
                if (this.metadataF != null)
                {
                    this.metadataF(this._metadata.headerba, this._metadata.duration);
                }
                return true;
            }
            return false;
        }// end function

        public function setHeader(param1:Object) : void
        {
            this._metadata = param1;
            this.mp4Parser.samples = param1.samples;
            return;
        }// end function

        public function get isopen() : Boolean
        {
            return this._isopen;
        }// end function

    }
}
