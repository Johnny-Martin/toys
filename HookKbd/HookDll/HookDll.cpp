// HookDll.cpp : ���� DLL Ӧ�ó���ĵ���������
//

#include "stdafx.h"
#include "HookDll.h"
#include <windows.h>
#include <stdlib.h>

#define _WIN32_WINNT  0x0500        //����ϵͳ�汾������ʹ�õײ���̹���  
#define WM_MY_SHORTS (WM_USER + 105)  

//ȫ�ֱ���   
LPWORD      g_lpdwVirtualKey = NULL;    //Keycode �����ָ��   
int         g_nLength = 0;          //Keycode ����Ĵ�С   
HINSTANCE   g_hInstance = NULL;     //ģ��ʵ�����    
HHOOK       g_hHook = NULL;         //���Ӿ��   

LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam)
{
	//�ж��Ƿ�����Ч����  
	if (nCode >= HC_ACTION && wParam == WM_KEYDOWN)
	{
		BOOL bctrl = GetAsyncKeyState(VK_CONTROL) >> ((sizeof(SHORT) * 8) - 1);
		KBDLLHOOKSTRUCT* pStruct = (KBDLLHOOKSTRUCT*)lParam;
		LPWORD tmpVirtualKey = g_lpdwVirtualKey;
		if (pStruct->vkCode == 80 && bctrl) {

		}
		return TRUE;
	}
	//����ϵͳ�е���һ������   
	return CallNextHookEx(g_hHook, nCode, wParam, lParam);
}

_declspec(dllexport)
BOOL WINAPI StartCatch(LPWORD lpdwVirtualKey, int nLength, HWND  pWnd)
{
	//����Ѿ���װ���̹����򷵻� FALSE    
	if (g_hHook != NULL) return FALSE;
	//���û������� keycode ���鱣����ȫ�ֱ�����   
	g_lpdwVirtualKey = (LPWORD)malloc(sizeof(WORD) * nLength);
	LPWORD tmpVirtualKey = g_lpdwVirtualKey;
	for (int i = 0; i < nLength; i++)
	{
		*tmpVirtualKey++ = *lpdwVirtualKey++;
	}
	g_nLength = nLength;
	//��װ�ײ���̹���    
	g_hHook = SetWindowsHookEx(WH_KEYBOARD_LL, LowLevelKeyboardProc, g_hInstance, NULL);
	if (g_hHook == NULL) return FALSE;
	return TRUE;
}

_declspec(dllexport)
BOOL WINAPI StopCatch()
{   //ж�ع���   
	if (UnhookWindowsHookEx(g_hHook) == 0) return FALSE;
	g_hHook = NULL;
	return TRUE;
}
