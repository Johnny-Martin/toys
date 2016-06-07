extern "C"{
#include"lua/lua.h"
};

template <typename T>
class Bridge11{
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
		lua_register(L, T::szClassName, &Bridge11<T>::Constructor);

		//����Ԫ��member function����Ԫ�������Ǵ���ÿ��table object
		//�������ظ���szClassName��Ҫ��������ײ���Ͳ����ˣ�
		luaL_newmetatable(L, T::szClassName);
		lua_pushcfunction(L, &Bridge11<T>::Destructor);
		lua_setfield(L, -2, "__gc");

		lua_pushvalue(L, -1);//��Ԫ��������һ�ݷŵ�ջ��
		lua_setfield(L, -2, "__index");//Ԫ���__indexԪ����ָ������
		for(int i=0; T::RegisterInfo[i].szFunName; ++i){
			lua_pushnumber(L, i);
			lua_pushcclosure(L,  &Bridge11<T>::thunk, 1);
			lua_setfield(L, -2, T::RegisterInfo[i].szFunName);
		}
	}

private:
	static int thunk(lua_State* L){
		int i = (int) lua_tonumber(L, lua_upvalueindex(1));

		lua_rawgeti(L, 1, 0);
		T** obj = static_cast <T**>(lua_touserdata(L, -1));
		lua_pop(L, 1);
		return ((*obj)->*(T::RegisterInfo[i].mFun)) (L);
	}
	
	static int Constructor(lua_State* L){
		//����table object
		lua_newtable(L);

 		T** a = (T **) lua_newuserdata(L, sizeof(T *));
 		T*  obj = new T();
 		*a = obj;
 		
 		luaL_getmetatable(L, T::szClassName);
 		lua_setmetatable(L, -2);//����userdata��Ԫ������Ԫ��ջ,��ʱջ��Ϊuserdata��
 
 		lua_rawseti(L, -2, 0);//��userdata�ŵ�table object ��[0]; ջ��Ϊtable object

		luaL_getmetatable(L, T::szClassName);
		lua_setmetatable(L, -2);//����table object��Ԫ������Ԫ��ջ,��ʱջ��Ϊtable object��
 		
		//����table��Ϊ������
		return 1;
	}

	static int Destructor(lua_State* L){
		//��table object���ٱ�����ʱ���ᱻ���٣�λ��t[0]���� userdata Ҳ����֮�����٣�����userdata
		//ʱ����ʹ������Ԫ���__gc������Ҳ�������(table object�������ǲ������ǲ��ĵ�)
		//luaL_checkudata(L, index, tname)���������: ջ��index���ǲ���һ��userdata����userdata��
		//Ԫ��������ǲ��ǽ�tname���κ�һ�������ϣ��ͻ�����һ������longjmp?��
		T** obj = static_cast < T ** >(luaL_checkudata(L, -1, T::szClassName));

		if (obj != NULL && *obj != NULL)
			delete(*obj);

		return 0;
	}
};