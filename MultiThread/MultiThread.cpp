// MultiThread.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "windows.h"
#include "iostream"

using namespace std;

int iRes = 0;
DWORD WINAPI Producer(LPVOID);
DWORD WINAPI Customer(LPVOID);

int main()
{
	HANDLE hP;
	DWORD  idP;
	HANDLE hC;
	DWORD  idC;

	hP = CreateThread(NULL, 0, Producer, 0, 0, &idP);
	if (hP)
		CloseHandle(hP);

	hC = CreateThread(NULL, 0, Customer, 0, 0, &idC);
	if (hC)
		CloseHandle(hC);

	Sleep(20 * 1000);
    return 0;
}

DWORD WINAPI Producer(LPVOID)
{
	while(true)
	{
		iRes++;
		cout << iRes << endl;
		Sleep(1000);
	}
	return 0;
}

DWORD WINAPI Customer(LPVOID)
{
	while (true)
	{
		if (iRes > 0)
		{
			--iRes;
			cout << iRes << "  消费1次" << endl;
			Sleep(1000);
		}
		else
		{
			cout <<" 啊哦，资源不足，等待" << endl;
			Sleep(1000);
		}
	}

	return 0;
}