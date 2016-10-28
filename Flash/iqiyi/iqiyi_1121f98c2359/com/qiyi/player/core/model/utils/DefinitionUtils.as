package com.qiyi.player.core.model.utils
{
    import __AS3__.vec.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.core.player.coreplayer.*;

    public class DefinitionUtils extends Object
    {
        private static var _definitionFilterList:Vector.<EnumItem> = null;

        public function DefinitionUtils()
        {
            return;
        }// end function

        public static function getCurrentDefinition(param1:ICorePlayer) : EnumItem
        {
            var _loc_2:* = Settings.instance.autoMatchRate ? (Settings.instance.detectedRate) : (Settings.instance.definition);
            if (param1.runtimeData.CDNStatus != 0)
            {
                if (param1.runtimeData.CDNStatus == 3)
                {
                    _loc_2 = DefinitionEnum.STANDARD;
                }
                else if (param1.runtimeData.CDNStatus == 4)
                {
                    _loc_2 = DefinitionEnum.LIMIT;
                }
                else if (Settings.instance.definition == DefinitionEnum.NONE || Settings.instance.autoMatchRate)
                {
                    if (param1.runtimeData.CDNStatus == 1)
                    {
                        _loc_2 = DefinitionEnum.STANDARD;
                    }
                    else if (param1.runtimeData.CDNStatus == 2)
                    {
                        _loc_2 = DefinitionEnum.LIMIT;
                    }
                }
            }
            return _loc_2;
        }// end function

        public static function setDefinitionFilterList(param1:Vector.<EnumItem>) : void
        {
            _definitionFilterList = param1;
            return;
        }// end function

        public static function inFilterPPByDefinitionID(param1:int) : Boolean
        {
            var _loc_2:int = 0;
            if (_definitionFilterList)
            {
                _loc_2 = 0;
                while (_loc_2 < _definitionFilterList.length)
                {
                    
                    if (_definitionFilterList[_loc_2].id == param1)
                    {
                        return true;
                    }
                    _loc_2++;
                }
                return false;
            }
            else
            {
                return param1 == DefinitionEnum.SUPER_HIGH.id || param1 == DefinitionEnum.FULL_HD.id || param1 == DefinitionEnum.FOUR_K.id;
            }
        }// end function

    }
}
