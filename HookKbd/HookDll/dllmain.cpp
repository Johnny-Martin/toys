// dllmain.cpp : ���� DLL Ӧ�ó������ڵ㡣
#include "stdafx.h"
#include "HookDll.h"

extern LPWORD      g_lpdwVirtualKey;    //Keycode �����ָ��     
extern HHOOK       g_hHook;				//���Ӿ��   

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

