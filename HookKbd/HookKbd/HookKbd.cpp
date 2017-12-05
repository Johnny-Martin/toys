// HookKbd.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include <Windows.h>
#include <iostream>
using namespace std;

LRESULT CALLBACK HookCallback(int code, WPARAM wParam, LPARAM lParam)
{
	KBDLLHOOKSTRUCT *ks = (KBDLLHOOKSTRUCT*)lParam;
	if (ks->vkCode == 'A' &&  wParam == WM_KEYDOWN)
	{
		cout << "������A��" << endl;
		return 1;
	}
	return CallNextHookEx(0, code, wParam, lParam);
}

int main()
{
	HHOOK keyboardHook = SetWindowsHookExA(WH_KEYBOARD_LL, HookCallback, GetModuleHandleA(0), 0);
	if (keyboardHook == 0)
	{
		cout << "Hook����ʧ��" << endl;
		return -1;
	}
	cout << "�ɹ�Hook������Ϣ" << endl;

	MSG msg;
	while (GetMessageA(&msg, 0, 0, 0)){
		TranslateMessage(&msg);
		DispatchMessageW(&msg);
	}

	UnhookWindowsHookEx(keyboardHook);

	cout << "���Hook,���򼴽��˳�" << endl;
	return 0;
}
