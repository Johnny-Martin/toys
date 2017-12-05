// HookDll.cpp : 定义 DLL 应用程序的导出函数。
//

#include "stdafx.h"
#include "HookDll.h"
#include <windows.h>
#include <stdlib.h>

#define _WIN32_WINNT  0x0500        //设置系统版本，可以使用底层键盘钩子  
#define WM_MY_SHORTS (WM_USER + 105)  

//全局变量   
LPWORD      g_lpdwVirtualKey = NULL;    //Keycode 数组的指针   
int         g_nLength = 0;          //Keycode 数组的大小   
HINSTANCE   g_hInstance = NULL;     //模块实例句柄    
HHOOK       g_hHook = NULL;         //钩子句柄   

LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam)
{
	//判断是否是有效按键  
	if (nCode >= HC_ACTION && wParam == WM_KEYDOWN)
	{
		BOOL bctrl = GetAsyncKeyState(VK_CONTROL) >> ((sizeof(SHORT) * 8) - 1);
		KBDLLHOOKSTRUCT* pStruct = (KBDLLHOOKSTRUCT*)lParam;
		LPWORD tmpVirtualKey = g_lpdwVirtualKey;
		if (pStruct->vkCode == 80 && bctrl) {

		}
		return TRUE;
	}
	//传给系统中的下一个钩子   
	return CallNextHookEx(g_hHook, nCode, wParam, lParam);
}

_declspec(dllexport)
BOOL WINAPI StartCatch(LPWORD lpdwVirtualKey, int nLength, HWND  pWnd)
{
	//如果已经安装键盘钩子则返回 FALSE    
	if (g_hHook != NULL) return FALSE;
	//将用户传来的 keycode 数组保存在全局变量中   
	g_lpdwVirtualKey = (LPWORD)malloc(sizeof(WORD) * nLength);
	LPWORD tmpVirtualKey = g_lpdwVirtualKey;
	for (int i = 0; i < nLength; i++)
	{
		*tmpVirtualKey++ = *lpdwVirtualKey++;
	}
	g_nLength = nLength;
	//安装底层键盘钩子    
	g_hHook = SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyboardProc, g_hInstance, NULL);
	if (g_hHook == NULL) return FALSE;
	return TRUE;
}

_declspec(dllexport)
BOOL WINAPI StopCatch()
{   //卸载钩子   
	if (UnhookWindowsHookEx(g_hHook) == 0) return FALSE;
	g_hHook = NULL;
	return TRUE;
}
