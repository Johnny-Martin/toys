// MultiThread.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "windows.h"
#include "iostream"
#include "define.h"

using namespace std;

int iRes = 0;
CRITICAL_SECTION g_CriticalSection;
HANDLE hArr[2];
DWORD WINAPI Producer(LPVOID);
DWORD WINAPI Customer(LPVOID);

int main(){
	HANDLE hP;
	DWORD  idP;
	HANDLE hC;
	DWORD  idC;

	InitializeCriticalSection(&g_CriticalSection);

	hArr[0] = CreateThread(NULL, 0, Producer, 0, 0, &idP);
	hArr[1] = CreateThread(NULL, 0, Customer, 0, 0, &idC);

	WaitForMultipleObjects(2, hArr, true, INFINITE);

	DeleteCriticalSection(&g_CriticalSection);
    return 0;
}

DWORD WINAPI Producer(LPVOID){
	Helper helper("Producer");
	int count = 5;//�������߹���5�κ����
	while(count-- > 0){ 
		EnterCriticalSection(&g_CriticalSection);
			iRes++;
			cout << iRes << endl;
		LeaveCriticalSection(&g_CriticalSection);
		Sleep(1000);
	}
	return 0;
}

DWORD WINAPI Customer(LPVOID){
	Helper helper("Customer");
	int errCount = 0;//������ʧ��3�ξ��˳�
	while (true){
		if (iRes > 0){
			EnterCriticalSection(&g_CriticalSection);
				--iRes;
				cout << iRes << "  ����1��" << endl;
			LeaveCriticalSection(&g_CriticalSection);
			Sleep(1000);
		}else{
			errCount++;
			if (errCount > 3){
				return 0;
			}
			cout <<" ��Ŷ����Դ���㣬�ȴ�" << endl;
			Sleep(1000);
		}
	}
	return 0;
}