package com.qiyi.player.wonder.plugins.scenetile.view.barragepart.expression
{

    public class ExpImageVO extends Object
    {
        private var _order:uint = 0;
        private var _pID:String = "";
        private var _id:String = "";
        private var _name:String = "";
        private var _type:uint = 1;
        private var _data:Object = null;

        public function ExpImageVO(param1:Object, param2:uint, param3:String = "", param4:String = "", param5:String = "", param6:uint = 0)
        {
            this._data = param1;
            this._type = param2;
            this._pID = param3;
            this._id = param4;
            this._name = param5;
            this._order = param6;
            return;
        }// end function

        public function get pID() : String
        {
            return this._pID;
        }// end function

        public function get order() : uint
        {
            return this._order;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        public function get name() : String
        {
            return this._name;
        }// end function

        public function get type() : uint
        {
            return this._type;
        }// end function

        public function get data() : Object
        {
            return this._data;
        }// end function

    }
}
