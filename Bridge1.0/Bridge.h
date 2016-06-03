extern "C"{
#include"lua/lua.h"
};

template <typename T>
class Bridge{
public:
	struct RegType{
		const char* szFunName;
		int (T::*mFun)(lua_State*);
	};

	//该方法在加载Lua代码块之前就得调用
	static void RegisterClass(lua_State* L)
	{
		//注册到Lua中，当脚本这样调时: local obj = T（paramA, paramB, ...）
		//就会调到这里注册的Constructor
		lua_register(L, T::szClassName, &Bridge<T>::Constructor);
	}

private:
	static int thunk(lua_State* L){
		//从栈所绑定的两个upvalue中取出lightuserdata、
		//以及member fun 在RegisterInfo中的index
		int objUpValueIndex = lua_upvalueindex(1);
		int funIndexUpValueIndex = lua_upvalueindex(2);

		T* obj = (T*)lua_topointer(L, objUpValueIndex);
		int funIndex = (int)lua_tonumber(L, funIndexUpValueIndex);

		//调用
		return (obj->*(T::RegisterInfo[funIndex].mFun))(L);
	}

	static int Constructor(lua_State* L){
		T* obj = new T();
		lua_newtable(L);
		for(int i=0; T::RegisterInfo[i].szFunName; ++i){
			lua_pushlightuserdata(L, obj);
			lua_pushnumber(L, i);
			//将obj的指针作为upvalue绑定到mFun，以便后来调用时使用
			lua_pushcclosure(L, thunk, 2);
			lua_setfield(L, -2, T::RegisterInfo[i].szFunName);
		}
		//返回table作为“对象”
		return 1;
	}
};