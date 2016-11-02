#pragma once
#include "stdafx.h"
#include"define.h"

extern AtomCout atomcout;
extern CSLocker::CriticalSection g_cs;
int iRes = 0;

DWORD WINAPI Producer(LPVOID) {
	Helper helper("Producer");
	int count = 5;//�������߹���5�κ����
	while (count-- > 0) {
		g_cs.Lock();
		iRes++;
		std::cout << iRes << std::endl;
		g_cs.UnLock();
		Sleep(1000);
	}
	return 0;
}

DWORD WINAPI Customer(LPVOID) {
	Helper helper("Customer");
	int errCount = 0;//������ʧ��3�ξ��˳�
	while (true) {
		if (iRes > 0) {
			g_cs.Lock();
			--iRes;
			std::cout << iRes << "  ����1��" << std::endl;
			g_cs.UnLock();
			Sleep(1000);
		}
		else {
			errCount++;
			if (errCount > 3) {
				return 0;
			}
			std::cout << " ��Ŷ����Դ���㣬�ȴ�" << std::endl;
			Sleep(1000);
		}
	}
	return 0;
}