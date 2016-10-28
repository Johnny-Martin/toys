package com.qiyi.player.core.model.impls
{
    import com.qiyi.player.base.pub.*;

    public class SkipPointInfo extends Object implements ISkipPointInfo
    {
        private var _startTime:int;
        private var _endTime:int;
        private var _skipPointType:EnumItem;
        private var _enterPrepareSkipPointFlag:Boolean = false;
        private var _outPrepareSkipPointFlag:Boolean = false;
        private var _enterSkipPointFlag:Boolean = false;
        private var _outSkipPointFlag:Boolean = false;
        private var _enterPrepareLeaveSkipPointFlag:Boolean = false;
        private var _outPrepareLeaveSkipPointFlag:Boolean = false;
        private var _inCurPrepareSkipPoint:Boolean = false;
        private var _inCurSkipPoint:Boolean = false;
        private var _inCurPrepareLeaveSkipPoint:Boolean = false;

        public function SkipPointInfo()
        {
            return;
        }// end function

        public function get startTime() : int
        {
            return this._startTime;
        }// end function

        public function set startTime(param1:int) : void
        {
            this._startTime = param1;
            return;
        }// end function

        public function get endTime() : int
        {
            return this._endTime;
        }// end function

        public function set endTime(param1:int) : void
        {
            this._endTime = param1;
            return;
        }// end function

        public function get skipPointType() : EnumItem
        {
            return this._skipPointType;
        }// end function

        public function set skipPointType(param1:EnumItem) : void
        {
            this._skipPointType = param1;
            return;
        }// end function

        public function get enterPrepareSkipPointFlag() : Boolean
        {
            return this._enterPrepareSkipPointFlag;
        }// end function

        public function set enterPrepareSkipPointFlag(param1:Boolean) : void
        {
            this._enterPrepareSkipPointFlag = param1;
            return;
        }// end function

        public function get outPrepareSkipPointFlag() : Boolean
        {
            return this._outPrepareSkipPointFlag;
        }// end function

        public function set outPrepareSkipPointFlag(param1:Boolean) : void
        {
            this._outPrepareSkipPointFlag = param1;
            return;
        }// end function

        public function get enterSkipPointFlag() : Boolean
        {
            return this._enterSkipPointFlag;
        }// end function

        public function set enterSkipPointFlag(param1:Boolean) : void
        {
            this._enterSkipPointFlag = param1;
            return;
        }// end function

        public function get outSkipPointFlag() : Boolean
        {
            return this._outSkipPointFlag;
        }// end function

        public function set outSkipPointFlag(param1:Boolean) : void
        {
            this._outSkipPointFlag = param1;
            return;
        }// end function

        public function get enterPrepareLeaveSkipPointFlag() : Boolean
        {
            return this._enterPrepareLeaveSkipPointFlag;
        }// end function

        public function set enterPrepareLeaveSkipPointFlag(param1:Boolean) : void
        {
            this._enterPrepareLeaveSkipPointFlag = param1;
            return;
        }// end function

        public function get outPrepareLeaveSkipPointFlag() : Boolean
        {
            return this._outPrepareLeaveSkipPointFlag;
        }// end function

        public function set outPrepareLeaveSkipPointFlag(param1:Boolean) : void
        {
            this._outPrepareLeaveSkipPointFlag = param1;
            return;
        }// end function

        public function get inCurPrepareSkipPoint() : Boolean
        {
            return this._inCurPrepareSkipPoint;
        }// end function

        public function set inCurPrepareSkipPoint(param1:Boolean) : void
        {
            this._inCurPrepareSkipPoint = param1;
            return;
        }// end function

        public function get inCurSkipPoint() : Boolean
        {
            return this._inCurSkipPoint;
        }// end function

        public function set inCurSkipPoint(param1:Boolean) : void
        {
            this._inCurSkipPoint = param1;
            return;
        }// end function

        public function get inCurPrepareLeaveSkipPoint() : Boolean
        {
            return this._inCurPrepareLeaveSkipPoint;
        }// end function

        public function set inCurPrepareLeaveSkipPoint(param1:Boolean) : void
        {
            this._inCurPrepareLeaveSkipPoint = param1;
            return;
        }// end function

        public function reset() : void
        {
            this._enterPrepareSkipPointFlag = false;
            this._outPrepareSkipPointFlag = false;
            this._enterSkipPointFlag = false;
            this._outSkipPointFlag = false;
            this._enterPrepareLeaveSkipPointFlag = false;
            this._outPrepareLeaveSkipPointFlag = false;
            this._inCurPrepareSkipPoint = false;
            this._inCurSkipPoint = false;
            this._inCurPrepareLeaveSkipPoint = false;
            return;
        }// end function

    }
}
