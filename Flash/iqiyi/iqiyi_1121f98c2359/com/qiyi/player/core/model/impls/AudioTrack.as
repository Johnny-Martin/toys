package com.qiyi.player.core.model.impls
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.utils.*;
    import com.qiyi.player.core.player.coreplayer.*;

    public class AudioTrack extends Object implements IDestroy, IAudioTrackInfo
    {
        private var _movie:IMovie;
        private var _source:Object;
        private var _ID:int;
        private var _type:EnumItem;
        private var _isDefault:Boolean;
        private var _definitionVec:Vector.<Definition>;
        private var _holder:ICorePlayer;

        public function AudioTrack(param1:ICorePlayer, param2:IMovie)
        {
            this._holder = param1;
            this._movie = param2;
            return;
        }// end function

        public function get isDefault() : Boolean
        {
            return this._isDefault;
        }// end function

        public function get type() : EnumItem
        {
            return this._type;
        }// end function

        public function get ID() : int
        {
            return this._ID;
        }// end function

        public function get definitionCount() : int
        {
            if (this._definitionVec != null)
            {
                return this._definitionVec.length;
            }
            return 0;
        }// end function

        public function initAudioTrack(param1:Object, param2:String, param3:String, param4:String, param5:Boolean) : void
        {
            var _loc_6:Array = null;
            var _loc_7:int = 0;
            var _loc_8:Definition = null;
            var _loc_9:int = 0;
            var _loc_10:Array = null;
            if (this._source != null)
            {
                return;
            }
            this._source = param1;
            this._ID = param1.id.toString();
            this._type = Utility.getItemById(AudioTrackEnum.ITEMS, int(param1.lid));
            this._isDefault = int(param1.ispre) == 1;
            if (param1.vs)
            {
                _loc_6 = param1.vs as Array;
            }
            else if (param1.bit && param1.bit.drmc)
            {
                _loc_6 = param1.bit.drmc;
            }
            if (_loc_6)
            {
                _loc_7 = _loc_6.length;
                _loc_8 = null;
                this._definitionVec = new Vector.<Definition>;
                _loc_9 = 0;
                while (_loc_9 < _loc_7)
                {
                    
                    _loc_10 = null;
                    if (param5)
                    {
                        _loc_10 = _loc_6[_loc_9].flvs as Array;
                    }
                    else
                    {
                        _loc_10 = _loc_6[_loc_9].fs as Array;
                    }
                    if (_loc_10 && _loc_10.length > 0)
                    {
                        _loc_8 = new Definition(this._holder, this, this._movie);
                        _loc_8.initDefinition(_loc_6[_loc_9], param2, param3, param4, param5);
                        this._definitionVec.push(_loc_8);
                    }
                    _loc_9++;
                }
            }
            return;
        }// end function

        public function findDefinitionAt(param1:int) : Definition
        {
            var _loc_2:int = 0;
            if (this._definitionVec)
            {
                _loc_2 = this.definitionCount;
                if (param1 >= 0 && param1 < _loc_2)
                {
                    return this._definitionVec[param1];
                }
            }
            return null;
        }// end function

        public function findDefinitionInfoAt(param1:int) : IDefinitionInfo
        {
            return this.findDefinitionAt(param1);
        }// end function

        public function findDefinitionByType(param1:EnumItem, param2:Boolean = false) : Definition
        {
            var _loc_3:int = 0;
            var _loc_4:Boolean = false;
            var _loc_5:Definition = null;
            var _loc_6:int = 0;
            var _loc_7:Array = null;
            var _loc_8:int = 0;
            var _loc_9:EnumItem = null;
            var _loc_10:int = 0;
            if (this._definitionVec && param1)
            {
                _loc_3 = this.definitionCount;
                _loc_4 = false;
                if (this._holder && this._holder.runtimeData.needFilterQualityDefinition)
                {
                    if (_loc_3 > 3)
                    {
                        _loc_4 = true;
                    }
                    else if (_loc_3 == 3)
                    {
                        if (DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[0].type.id) && DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[1].type.id) && DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[2].type.id))
                        {
                            _loc_4 = false;
                        }
                        else
                        {
                            _loc_4 = true;
                        }
                    }
                    else if (_loc_3 == 2)
                    {
                        if (DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[0].type.id) && DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[1].type.id))
                        {
                            _loc_4 = false;
                        }
                        else
                        {
                            _loc_4 = true;
                        }
                    }
                    else
                    {
                        _loc_4 = false;
                    }
                }
                _loc_5 = null;
                _loc_6 = 0;
                if (param2)
                {
                    _loc_6 = 0;
                    while (_loc_6 < _loc_3)
                    {
                        
                        _loc_5 = this._definitionVec[_loc_6];
                        if (_loc_4 && DefinitionUtils.inFilterPPByDefinitionID(_loc_5.type.id))
                        {
                        }
                        else if (_loc_5 && _loc_5.type == param1)
                        {
                            return _loc_5;
                        }
                        _loc_6++;
                    }
                }
                else
                {
                    if (_loc_3 == 1)
                    {
                        return this._definitionVec[0];
                    }
                    _loc_7 = DefinitionEnum.ITEMS;
                    _loc_8 = 0;
                    if (param1 == DefinitionEnum.LIMIT)
                    {
                        _loc_8 = 0;
                    }
                    else if (param1 == DefinitionEnum.NONE)
                    {
                        _loc_8 = _loc_7.indexOf(DefinitionEnum.HIGH);
                    }
                    else
                    {
                        _loc_8 = _loc_7.indexOf(param1);
                    }
                    _loc_9 = null;
                    _loc_10 = _loc_8;
                    while (_loc_10 >= 0)
                    {
                        
                        if (_loc_10 == 0)
                        {
                            _loc_9 = DefinitionEnum.LIMIT;
                        }
                        else
                        {
                            _loc_9 = _loc_7[_loc_10];
                        }
                        _loc_10 = _loc_10 - 1;
                        if (_loc_4 && DefinitionUtils.inFilterPPByDefinitionID(_loc_9.id))
                        {
                            continue;
                        }
                        _loc_6 = 0;
                        while (_loc_6 < _loc_3)
                        {
                            
                            _loc_5 = this._definitionVec[_loc_6];
                            if (_loc_5 && _loc_5.type == _loc_9)
                            {
                                return _loc_5;
                            }
                            _loc_6++;
                        }
                    }
                    _loc_10 = _loc_8;
                    while (_loc_10 < _loc_7.length)
                    {
                        
                        if (_loc_10 == 0)
                        {
                            _loc_9 = DefinitionEnum.LIMIT;
                        }
                        else
                        {
                            _loc_9 = _loc_7[_loc_10];
                        }
                        _loc_10++;
                        if (_loc_4 && DefinitionUtils.inFilterPPByDefinitionID(_loc_9.id))
                        {
                            continue;
                        }
                        _loc_6 = 0;
                        while (_loc_6 < _loc_3)
                        {
                            
                            _loc_5 = this._definitionVec[_loc_6];
                            if (_loc_5 && _loc_5.type == _loc_9)
                            {
                                return _loc_5;
                            }
                            _loc_6++;
                        }
                    }
                }
            }
            return null;
        }// end function

        public function findDefinitionInfoByType(param1:EnumItem, param2:Boolean = false) : IDefinitionInfo
        {
            return this.findDefinitionByType(param1, param2);
        }// end function

        public function findDefinitionByVid(param1:String) : Definition
        {
            var _loc_2:int = 0;
            var _loc_3:Definition = null;
            var _loc_4:int = 0;
            if (this._definitionVec)
            {
                _loc_2 = this.definitionCount;
                _loc_3 = null;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_3 = this._definitionVec[_loc_4];
                    if (_loc_3 && _loc_3.vid == param1)
                    {
                        return _loc_3;
                    }
                    _loc_4++;
                }
            }
            return null;
        }// end function

        public function destroy() : void
        {
            var _loc_1:int = 0;
            var _loc_2:Definition = null;
            var _loc_3:int = 0;
            this._movie = null;
            this._source = null;
            this._type = null;
            this._isDefault = false;
            if (this._definitionVec)
            {
                _loc_1 = this.definitionCount;
                _loc_2 = null;
                _loc_3 = 0;
                while (_loc_3 < _loc_1)
                {
                    
                    _loc_2 = this._definitionVec[_loc_3];
                    if (_loc_2)
                    {
                        _loc_2.destroy();
                    }
                    _loc_3++;
                }
                this._definitionVec = null;
            }
            return;
        }// end function

    }
}
