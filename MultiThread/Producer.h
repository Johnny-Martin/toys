#pragma once
#include "stdafx.h"
#include"define.h"
#include "Log.h"

extern AtomCout atomcout;
extern CSLocker::CriticalSection g_cs;
extern HANDLE hFull;
extern HANDLE hEmpty;
extern HANDLE hMutex;

extern int iRes;

DWORD WINAPI Producer(LPVOID) {
	int count = 50;//让生产者工作5次后结束
	while (count-- > 0) {
		WaitForSingleObject(hEmpty, INFINITE);
		WaitForSingleObject(hMutex, INFINITE);
		atomcout.out("Produc one, ", ++iRes,"\n");
		INFO("Producer a:, b: ");
		ReleaseMutex(hMutex);
		ReleaseSemaphore(hFull, 1, NULL);
	}
	return 0;
}

DWORD WINAPI Customer(LPVOID) {
	int count = 50;//让生产者工作5次后结束
	while (count-- > 0) {
		WaitForSingleObject(hFull, INFINITE);
		WaitForSingleObject(hMutex, INFINITE);
		atomcout.out( "Custom one, ", --iRes, "\n");
		INFO("Customer a:, b: ");
		ReleaseMutex(hMutex);
		ReleaseSemaphore(hEmpty, 1, NULL);
	}
	return 0;
}