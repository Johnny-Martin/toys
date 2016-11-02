// MultiThread.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "windows.h"
#include "iostream"
#include "define.h"

using namespace std;

int iRes = 0;
CSLocker::CriticalSection g_cs;
HANDLE hArr[2];
DWORD WINAPI Producer(LPVOID);
DWORD WINAPI Customer(LPVOID);
AtomCout atomcout = AtomCout(&g_cs);

int main(){
	DWORD  idP;
	DWORD  idC;

	hArr[0] = CreateThread(NULL, 0, Producer, 0, 0, &idP);
	hArr[1] = CreateThread(NULL, 0, Customer, 0, 0, &idC);

	WaitForMultipleObjects(2, hArr, true, INFINITE);
    return 0;
}

DWORD WINAPI Producer(LPVOID){
	Helper helper("Producer");
	int count = 5;//�������߹���5�κ����
	while(count-- > 0){ 
		g_cs.Lock();
			iRes++;
			std::cout << iRes << endl;
		g_cs.UnLock();
		Sleep(1000);
	}
	return 0;
}

DWORD WINAPI Customer(LPVOID){
	Helper helper("Customer");
	int errCount = 0;//������ʧ��3�ξ��˳�
	while (true){
		if (iRes > 0){
			g_cs.Lock();
				--iRes;
				std::cout << iRes << "  ����1��" << endl;
			g_cs.UnLock();
			Sleep(1000);
		}else{
			errCount++;
			if (errCount > 3){
				return 0;
			}
			std::cout <<" ��Ŷ����Դ���㣬�ȴ�" << endl;
			Sleep(1000);
		}
	}
	return 0;
}