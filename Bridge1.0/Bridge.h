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

	//�÷����ڼ���Lua�����֮ǰ�͵õ���
	static void RegisterClass(lua_State* L)
	{
		//ע�ᵽLua�У����ű�������ʱ: local obj = T��paramA, paramB, ...��
		//�ͻ��������ע���Constructor
		lua_register(L, T::szClassName, &Bridge<T>::Constructor);
	}

private:
	static int thunk(lua_State* L){
		//��ջ���󶨵�����upvalue��ȡ��lightuserdata��
		//�Լ�member fun ��RegisterInfo�е�index
		int objUpValueIndex = lua_upvalueindex(1);
		int funIndexUpValueIndex = lua_upvalueindex(2);

		T* obj = (T*)lua_topointer(L, objUpValueIndex);
		int funIndex = (int)lua_tonumber(L, funIndexUpValueIndex);

		//����
		return (obj->*(T::RegisterInfo[funIndex].mFun))(L);
	}

	static int Constructor(lua_State* L){
		T* obj = new T();
		lua_newtable(L);
		for(int i=0; T::RegisterInfo[i].szFunName; ++i){
			lua_pushlightuserdata(L, obj);
			lua_pushnumber(L, i);
			//��obj��ָ����Ϊupvalue�󶨵�mFun���Ա��������ʱʹ��
			lua_pushcclosure(L, thunk, 2);
			lua_setfield(L, -2, T::RegisterInfo[i].szFunName);
		}
		//����table��Ϊ������
		return 1;
	}
};