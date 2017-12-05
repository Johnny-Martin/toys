// HookKbd.cpp : 定义控制台应用程序的入口点。
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
		cout << "已拦截A键" << endl;
		return 1;
	}
	return CallNextHookEx(0, code, wParam, lParam);
}

int main()
{
	HHOOK keyboardHook = SetWindowsHookExA(WH_KEYBOARD_LL, HookCallback, GetModuleHandleA(0), 0);
	if (keyboardHook == 0)
	{
		cout << "Hook键盘失败" << endl;
		return -1;
	}
	cout << "成功Hook键盘消息" << endl;

	MSG msg;
	while (GetMessageA(&msg, 0, 0, 0)){
		TranslateMessage(&msg);
		DispatchMessageW(&msg);
	}

	UnhookWindowsHookEx(keyboardHook);

	cout << "解除Hook,程序即将退出" << endl;
	return 0;
}
