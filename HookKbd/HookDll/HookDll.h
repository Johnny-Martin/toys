#pragma once
#include "stdafx.h"

//ȫ�ֱ���   
extern LPWORD      g_lpdwVirtualKey;    //Keycode �����ָ��   
extern int         g_nLength;          //Keycode ����Ĵ�С   
extern HINSTANCE   g_hInstance;     //ģ��ʵ�����    
extern HHOOK       g_hHook;         //���Ӿ��   

LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam);

_declspec(dllexport)
BOOL WINAPI StartCatch(LPWORD lpdwVirtualKey, int nLength, HWND  pWnd);

_declspec(dllexport)
BOOL WINAPI StopCatch();
