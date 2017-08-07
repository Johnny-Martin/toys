// MultiThread.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "windows.h"
#include "iostream"
#include "define.h"
#include "Producer.h"
#include "DeadLock.h"
#include "AtomCout.h"
#include "Log.h"

using namespace std;

CSLocker::CriticalSection g_cs;
AtomCout atomcout = AtomCout(&g_cs);

HANDLE hArr[6];
DWORD WINAPI Producer(LPVOID);
DWORD WINAPI Customer(LPVOID);
void SwapResData(Res& A, Res& B);

DWORD WINAPI SwaperA(LPVOID);
DWORD WINAPI SwaperB(LPVOID);

HANDLE hFull;
HANDLE hEmpty;
HANDLE hMutex;

ResEx a(5);
ResEx b(1);
int iRes = 0;

int main(){
	AtomCoutEx << "111 " << 222 << std::endl;
	DWORD  idP;
	DWORD  idC;
	hFull = CreateSemaphore(NULL, 0, 10, NULL);
	hEmpty = CreateSemaphore(NULL, 10, 10, NULL);

	for(int i = 0; i<3; ++i){
		hArr[i+3] = CreateThread(NULL, 0, Producer, 0, 0, &idP);
		hArr[i]   = CreateThread(NULL, 0, Customer, 0, 0, &idC);
	}

	//Sleep(1000*50);
	WaitForMultipleObjects(6, hArr, true, INFINITE);
    return 0;
}

DWORD WINAPI SwaperA(LPVOID) {
	while (true) {
		SwapResDataEx(a, b);
		INFO("SwaperA a: {}, b: {}", a.data, b.data);
		Sleep(1000);
	}
	return 0;
}
DWORD WINAPI SwaperB(LPVOID) {
	while (true) {
		SwapResDataEx(b, a);
		INFO("SwaperA a: {}, b: {}", a.data, b.data);
		Sleep(1000);
	}
	return 0;
}