#pragma once
#include "stdafx.h"
#include"define.h"

extern AtomCout atomcout;

struct ResEx {
	ResEx() :data(0), hMutex(NULL) {}
	ResEx(int val) :data(val), hMutex(NULL) {}
	int data;
	HANDLE hMutex;
};

extern ResEx a;
extern ResEx b;
void SwapResDataEx(ResEx& A, ResEx& B) {
	HANDLE hArr[2];
	hArr[0] = A.hMutex;
	hArr[1] = B.hMutex;

	WaitForMultipleObjects(2, hArr, true, INFINITE);
		int tmp = A.data;
		A.data = B.data;
		B.data = tmp;
		atomcout.out("thread: ", ::GetCurrentThreadId(), " swap finished  ", a.data, "==>", b.data, " \n");
	ReleaseMutex(hArr[0]);
	ReleaseMutex(hArr[1]);
}


struct Res {
	Res() :data(0), cs() {}
	Res(int val):data(val), cs(){}
	int data;
	CSLocker::CriticalSection cs;
};

void SwapResData(Res& A, Res& B) {
	A.cs.Lock();
		B.cs.Lock();
			int tmp = A.data;
			A.data = B.data;
			B.data = tmp;
			atomcout.out("thread: ", ::GetCurrentThreadId(), " swap finished \n");
		B.cs.UnLock();
	A.cs.UnLock();
}
