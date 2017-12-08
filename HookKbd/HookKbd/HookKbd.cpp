// HookKbd.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "HookKbd.h"
#include <Windows.h>
#include <iostream>

using namespace std;
KeyLogger* keyLogger = nullptr;
HHOOK keyboardHook = HHOOK{};

LRESULT CALLBACK HookCallback(int code, WPARAM wParam, LPARAM lParam)
{
	KBDLLHOOKSTRUCT *ks = (KBDLLHOOKSTRUCT*)lParam;
	if (wParam == WM_KEYDOWN || wParam == WM_SYSKEYDOWN){
		keyLogger->OnKeyDown(ks->vkCode);
	} else if (wParam == WM_KEYUP || wParam == WM_SYSKEYUP) {
		keyLogger->OnKeyUp(ks->vkCode);
	}
	return CallNextHookEx(0, code, wParam, lParam);
}

BOOL WINAPI ConsoleHandlerRoutine(DWORD dwCtrlType)
{
	if (dwCtrlType == CTRL_CLOSE_EVENT){
		delete keyLogger;
		UnhookWindowsHookEx(keyboardHook);
		cout << "解除Hook,程序即将退出" << endl;
	}

	return FALSE;
}

int main()
{
	keyLogger = KeyLogger::GetInstance();
	SetConsoleCtrlHandler(ConsoleHandlerRoutine, TRUE);
	keyboardHook = SetWindowsHookExA(WH_KEYBOARD_LL, HookCallback, GetModuleHandleA(0), 0);
	if (keyboardHook == 0){
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
