#pragma once
#include "stdafx.h"

//全局变量   
extern LPWORD      g_lpdwVirtualKey;    //Keycode 数组的指针   
extern int         g_nLength;          //Keycode 数组的大小   
extern HINSTANCE   g_hInstance;     //模块实例句柄    
extern HHOOK       g_hHook;         //钩子句柄   

LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam);

_declspec(dllexport)
BOOL WINAPI StartCatch(LPWORD lpdwVirtualKey, int nLength, HWND  pWnd);

_declspec(dllexport)
BOOL WINAPI StopCatch();
