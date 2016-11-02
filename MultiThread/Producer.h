#pragma once
#include "stdafx.h"
#include"define.h"

extern AtomCout atomcout;
extern CSLocker::CriticalSection g_cs;
int iRes = 0;

DWORD WINAPI Producer(LPVOID) {
	Helper helper("Producer");
	int count = 5;//让生产者工作5次后结束
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
	int errCount = 0;//消费者失败3次就退出
	while (true) {
		if (iRes > 0) {
			g_cs.Lock();
			--iRes;
			std::cout << iRes << "  消费1次" << std::endl;
			g_cs.UnLock();
			Sleep(1000);
		}
		else {
			errCount++;
			if (errCount > 3) {
				return 0;
			}
			std::cout << " 啊哦，资源不足，等待" << std::endl;
			Sleep(1000);
		}
	}
	return 0;
}