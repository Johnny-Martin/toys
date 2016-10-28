package org.puremvc.as3.core
{
    import org.puremvc.as3.interfaces.*;

    public class Model extends Object implements IModel
    {
        protected const SINGLETON_MSG:String = "Model Singleton already constructed!";
        protected var proxyMap:Array;
        static var instance:IModel;

        public function Model()
        {
            if (instance != null)
            {
                throw Error(SINGLETON_MSG);
            }
            instance = this;
            proxyMap = new Array();
            initializeModel();
            return;
        }// end function

        protected function initializeModel() : void
        {
            return;
        }// end function

        public function removeProxy(param1:String) : IProxy
        {
            var _loc_2:* = proxyMap[param1] as IProxy;
            if (_loc_2)
            {
                proxyMap[param1] = null;
                _loc_2.onRemove();
            }
            return _loc_2;
        }// end function

        public function hasProxy(param1:String) : Boolean
        {
            return proxyMap[param1] != null;
        }// end function

        public function retrieveProxy(param1:String) : IProxy
        {
            return proxyMap[param1];
        }// end function

        public function registerProxy(param1:IProxy) : void
        {
            proxyMap[param1.getProxyName()] = param1;
            param1.onRegister();
            return;
        }// end function

        public static function getInstance() : IModel
        {
            if (instance == null)
            {
                instance = new Model;
            }
            return instance;
        }// end function

    }
}
