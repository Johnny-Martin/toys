// MultiThread.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "windows.h"
#include "iostream"
#include "define.h"
#include "Producer.h"
#include "DeadLock.h"

using namespace std;

CSLocker::CriticalSection g_cs;
AtomCout atomcout = AtomCout(&g_cs);

HANDLE hArr[2];
DWORD WINAPI Producer(LPVOID);
DWORD WINAPI Customer(LPVOID);
void SwapResData(Res& A, Res& B);

DWORD WINAPI SwaperA(LPVOID);
DWORD WINAPI SwaperB(LPVOID);


ResEx a(5);
ResEx b(1);

int main(){
	DWORD  idP;
	DWORD  idC;
	a.hMutex = CreateMutex(NULL, false, NULL);
	b.hMutex = CreateMutex(NULL, false, NULL);

	hArr[0] = CreateThread(NULL, 0, SwaperA, 0, 0, &idP);
	hArr[1] = CreateThread(NULL, 0, SwaperB, 0, 0, &idC);

	WaitForMultipleObjects(2, hArr, true, INFINITE);
    return 0;
}

DWORD WINAPI SwaperA(LPVOID) {
	while (true) {
		SwapResDataEx(a, b);
		Sleep(1000);
	}
	return 0;
}
DWORD WINAPI SwaperB(LPVOID) {
	while (true) {
		SwapResDataEx(b, a);
		Sleep(1000);
	}
	return 0;
}