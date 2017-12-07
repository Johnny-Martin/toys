// dllmain.cpp : 定义 DLL 应用程序的入口点。
#include "stdafx.h"
#include "HookDll.h"

extern LPWORD      g_lpdwVirtualKey;    //Keycode 数组的指针     
extern HHOOK       g_hHook;				//钩子句柄   

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		break;
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	case DLL_PROCESS_DETACH:
		delete g_lpdwVirtualKey;
		if (g_hHook != NULL) UnhookWindowsHookEx(g_hHook);
		break;
	}
	return TRUE;
}

