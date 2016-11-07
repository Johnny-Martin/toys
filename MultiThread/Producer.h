#pragma once
#include "stdafx.h"
#include"define.h"

extern AtomCout atomcout;
extern CSLocker::CriticalSection g_cs;
extern HANDLE hFull;
extern HANDLE hEmpty;
extern HANDLE hMutex;

extern int iRes;

DWORD WINAPI Producer(LPVOID) {
	int count = 5;//让生产者工作5次后结束
	while (count-- > 0) {
		WaitForSingleObject(hEmpty, INFINITE);
		WaitForSingleObject(hMutex, INFINITE);
		atomcout.out("生产一次, ", ++iRes,"\n");
		ReleaseMutex(hMutex);
		ReleaseSemaphore(hFull, 1, NULL);
	}
	return 0;
}

DWORD WINAPI Customer(LPVOID) {
	int count = 5;//让生产者工作5次后结束
	while (count-- > 0) {
		WaitForSingleObject(hFull, INFINITE);
		WaitForSingleObject(hMutex, INFINITE);
		atomcout.out( "消费一次, ", --iRes, "\n");
		ReleaseMutex(hMutex);
		ReleaseSemaphore(hEmpty, 1, NULL);
	}
	return 0;
}