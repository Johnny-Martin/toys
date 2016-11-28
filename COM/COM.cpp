// COM.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"

//widget.dll

#include "atlcomcli.h"  
#import "Debug\\ATLProject.dll" no_namespace  

int main()
{
	CoInitialize(NULL);
	CLSID clsid;
	CLSIDFromProgID(OLESTR("SmpMath.1"), &clsid);
	CComPtr<ISmpMath> pFirstClass;//智能指针  
	pFirstClass.CoCreateInstance(clsid);
	long ret = pFirstClass->Add(1, 2);
	printf("%d\n", ret);
	pFirstClass.Release();
	CoUninitialize();

	return 0;
}

