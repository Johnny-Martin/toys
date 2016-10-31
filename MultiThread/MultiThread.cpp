// MultiThread.cpp : �������̨Ӧ�ó������ڵ㡣
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
			cout << iRes << "  ����1��" << endl;
			Sleep(1000);
		}
		else
		{
			cout <<" ��Ŷ����Դ���㣬�ȴ�" << endl;
			Sleep(1000);
		}
	}

	return 0;
}