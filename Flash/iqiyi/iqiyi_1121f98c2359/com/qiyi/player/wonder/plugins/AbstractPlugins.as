package com.qiyi.player.wonder.plugins
{
    import __AS3__.vec.*;
    import flash.display.*;
    import org.puremvc.as3.patterns.facade.*;

    public class AbstractPlugins extends Object
    {
        protected var facade:Facade;

        public function AbstractPlugins()
        {
            return;
        }// end function

        public function init(param1:Facade) : void
        {
            this.facade = param1;
            return;
        }// end function

        public function initModel(param1:Vector.<String> = null) : void
        {
            if (this.facade == null)
            {
                throw new Error("facade is null,please call init!");
            }
            return;
        }// end function

        public function initView(param1:DisplayObjectContainer, param2:Vector.<String> = null) : void
        {
            if (this.facade == null)
            {
                throw new Error("facade is null,please call init!");
            }
            return;
        }// end function

        public function initController() : void
        {
            if (this.facade == null)
            {
                throw new Error("facade is null,please call init!");
            }
            return;
        }// end function

        public function checkModelInit(param1:String) : Boolean
        {
            if (this.facade == null)
            {
                throw new Error("facade is null,please call init!");
            }
            return this.facade.hasProxy(param1);
        }// end function

        public function checkViewInit(param1:String) : Boolean
        {
            if (this.facade == null)
            {
                throw new Error("facade is null,please call init!");
            }
            return this.facade.hasMediator(param1);
        }// end function

    }
}
