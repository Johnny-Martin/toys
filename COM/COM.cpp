// COM.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

//widget.dll

#include "atlcomcli.h"  
#import "C:\\tmpcode\\toys\\COM\\Debug\\widget.dll" no_namespace  

int main()
{
	CoInitialize(NULL);
	CLSID clsid;
	CLSIDFromProgID(OLESTR("ICalc.1"), &clsid);
	CComPtr<ICalc> pFirstClass;//智能指针  
	pFirstClass.CoCreateInstance(clsid);
	long ret = pFirstClass->Add(1, 2);
	printf("%d\n", ret);
	pFirstClass.Release();
	CoUninitialize();

	return 0;
}

