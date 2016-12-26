// COM.cpp : �������̨Ӧ�ó������ڵ㡣
//
#include "stdafx.h"
#include "InterfaceDecl.h"  

IUnKnown* CallCreateInstance(TCHAR* name) {
	HINSTANCE hInst = ::LoadLibrary(name);
	if (NULL == hInst) {
		std::cout << "NULL == hInst";
		return NULL;
	}
	typedef IUnKnown* (*CreateInstanceFunType)();
	CreateInstanceFunType CreateInstanceFun = (CreateInstanceFunType)::GetProcAddress(hInst, "CreateInstance");
	if (NULL == CreateInstanceFun) {
		std::cout << "NULL == CreateInstanceFun";
		return NULL;
	}
	return CreateInstanceFun();
}
int main()
{
	//CoInitialize(NULL);
	//CLSID clsid;
	//CLSIDFromProgID(OLESTR("SmpMath.1"), &clsid);
	//CComPtr<ISmpMath> pFirstClass;//����ָ��  
	//pFirstClass.CoCreateInstance(clsid);
	//long ret = pFirstClass->Add(1, 2);
	//printf("%d\n", ret);
	//pFirstClass.Release();
	//CoUninitialize();

	IUnKnown* pIUnknown = CallCreateInstance(_T("simulation2.dll"));
	if (NULL == pIUnknown) {
		std::cout << "NULL == pIUnknown";
		return -1;
	}

	IDictionary* pIDictionary;
	ISpellCheck* pISpellCheck;
	HRESULT hr = pIUnknown->QueryIntertface(IID_IDictionary, (void**)&pIDictionary);
	if (SUCCEEDED(hr)) {
		pIDictionary->Init();
		pIDictionary->LookupWord("hello");
		pIDictionary->UnInit();

		//ʹ��pIDictionary ��� pISpellCheck
		hr = pIDictionary->QueryIntertface(IID_ISpellCheck, (void**)&pISpellCheck);
		if (SUCCEEDED(hr)) {
			std::cout << pISpellCheck << std::endl;
			pISpellCheck->CheckSpell("fuck");
			pISpellCheck->Releace();
			pISpellCheck = NULL;
		}

		pIDictionary->Releace();
		pIDictionary = NULL;
	}

	//ʹ��pIUnknowm ��� pISpellCheck
	hr = pIUnknown->QueryIntertface(IID_ISpellCheck, (void**)&pISpellCheck);
	if (SUCCEEDED(hr)) {
		std::cout << pISpellCheck << std::endl;
		pISpellCheck->CheckSpell("fuck");
		pISpellCheck->Releace();
		pISpellCheck = NULL;
	}

	pIUnknown->Releace();
	return 0;
}

