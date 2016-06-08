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

	//该方法在加载Lua代码块之前就得调用
	static void RegisterClass(lua_State* L)
	{
		//注册到Lua中，当脚本这样调时: local obj = T（paramA, paramB, ...）
		//就会调到这里注册的Constructor
		lua_register(L, T::szClassName, &Bridge11<T>::Constructor);

		//创建元表，member function存入元表，而不是存入每个table object
		//避免了重复（szClassName不要有重名，撞车就不好了）
		luaL_newmetatable(L, T::szClassName);
		lua_pushcfunction(L, &Bridge11<T>::Destructor);
		lua_setfield(L, -2, "__gc");

		lua_pushvalue(L, -1);//将元表自身复制一份放到栈顶
		lua_setfield(L, -2, "__index");//元表的__index元方法指向自身
		for(int i=0; T::RegisterInfo[i].szFunName; ++i){
			lua_pushnumber(L, i);
			lua_pushcclosure(L,  &Bridge11<T>::thunk, 1);
			lua_setfield(L, -2, T::RegisterInfo[i].szFunName);
		}
	}

private:
	static int thunk(lua_State* L){
		int i = (int) lua_tonumber(L, lua_upvalueindex(1));
		if(LUA_TTABLE != lua_type(L, 1)) 
			return 0;
		//Lua代码必须这样调 obj:Fun(...) 或者obj.Fun(obj, ...) 才行，
		//若只是obj.Fun(...)，obj没压入栈底，这里调不到的.
		lua_rawgeti(L, 1, 0);
		//luaL_checkudata(L, index, tname)检查两件事: 栈的index处是不是一个userdata、该userdata的
		//元表的名字是不是叫tname。任何一个不符合，就会引发一个错误,并将错误信息压栈
		//这里可根据需要使用luaL_checkudata 或者 luaL_testudata，后者只检查，不抛错。
		T** obj = static_cast < T ** >(luaL_checkudata(L, -1, T::szClassName));
		return ((*obj)->*(T::RegisterInfo[i].mFun)) (L);
	}
	
	static int Constructor(lua_State* L){
		//创建table object
		lua_newtable(L);

 		T** a = (T **) lua_newuserdata(L, sizeof(T *));
 		T*  obj = new T();
 		*a = obj;
 		
 		luaL_getmetatable(L, T::szClassName);
 		lua_setmetatable(L, -2);//设置userdata的元表，并将元表弹栈,此时栈顶为userdata。
 
 		lua_rawseti(L, -2, 0);//将userdata放到table object 的[0]; 栈顶为table object

		luaL_getmetatable(L, T::szClassName);
		lua_setmetatable(L, -2);//设置table object的元表，并将元表弹栈,此时栈顶为table object。
 		
		//返回table作为“对象”
		return 1;
	}

	static int Destructor(lua_State* L){
		//当table object不再被引用时，会被销毁，位于t[0]处的 userdata 也会随之被销毁，销毁userdata
		//时，会使用它的元表的__gc方法，也就是这里。(table object的销毁是不用我们操心的)
		//此时栈中只有一个元素:userdata本身
		T** obj = static_cast < T ** >(luaL_checkudata(L, -1, T::szClassName));

		if (obj != NULL && *obj != NULL)
			delete(*obj);

		return 0;
	}
};