#pragma once
#include "stdafx.h"
#include"define.h"

extern AtomCout atomcout;

struct Res {
	Res() :data(0), cs() {}
	Res(int val):data(val), cs(){}
	int data;
	CSLocker::CriticalSection cs;
};

void SwapResData(Res& A, Res& B) {
	A.cs.Lock();
		B.cs.Lock();
			atomcout.out("SwapResData  ", A.data, " && ", B.data, "  ->  ", B.data, " && ", A.data);
			int tmp = A.data;
			A.data = B.data;
			B.data = tmp;
			atomcout.out("  finished \n");
		B.cs.UnLock();
	A.cs.UnLock();

}
