// Bridge1.0.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

extern "C"{
#include"lua/lua.h"
#include"lua/lualib.h"
#include"lua/lauxlib.h"
};
#include "Bridge.h"
#include "Bridge11.h"

#pragma comment(lib, "lua/lua53.lib")

class Fuck{
	public:
	static const char szClassName[];
	static const Bridge<Fuck>::RegType RegisterInfo[];

	int Holly(lua_State* L){
		lua_pushstring(L,"call Holly");
		return 1;
	}
	int Shit(lua_State* L){
		lua_pushstring(L,"call Shit");
		return 1;
	}
};

const char Fuck::szClassName[] = "Fuck";
const Bridge<Fuck>::RegType Fuck::RegisterInfo[] = {
	{"Holly",  &Fuck::Holly},
	{"Shit", &Fuck::Shit},
	{0}
};


int _tmain(int argc, _TCHAR* argv[])
{
	lua_State* L = luaL_newstate(); 
	if ( L == NULL )
		return -1; 

	luaL_openlibs(L);

	Bridge11<Fuck>::RegisterClass(L);
	luaL_dofile(L, "D:\\code\\toys\\trunk\\Bridge1.0\\test.lua");

	lua_close(L);

	return 0;
}

