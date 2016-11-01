// MultiThread.cpp : 定义控制台应用程序的入口点。
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
	int count = 5;//让生产者工作5次后结束
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
	int errCount = 0;//消费者失败3次就退出
	while (true){
		if (iRes > 0){
			EnterCriticalSection(&g_CriticalSection);
				--iRes;
				cout << iRes << "  消费1次" << endl;
			LeaveCriticalSection(&g_CriticalSection);
			Sleep(1000);
		}else{
			errCount++;
			if (errCount > 3){
				return 0;
			}
			cout <<" 啊哦，资源不足，等待" << endl;
			Sleep(1000);
		}
	}
	return 0;
}