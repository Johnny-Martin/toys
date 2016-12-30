// COM.cpp : 定义控制台应用程序的入口点。
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

HRESULT __stdcall DLLRegisterServer() {
	/*HKEY_CLASSES_ROOT
	|--CLSID
	|--{354CD5C5-839B-4A1E-8033-0EBC5246A4EF}--SimulationComObject
	|--InprocServer32    --C:\XXX\SSS\simulation3.dll
	|--ProgID            --COM.Simulation.1
	...
	|--COM.Simulation
	|--CLSID--{354CD5C5-839B-4A1E-8033-0EBC5246A4EF}
	|--CurVer--COM.Simulation.1

	*/


	// {354CD5C5-839B-4A1E-8033-0EBC5246A4EF}
	//static const GUID ComponentCLSID = { 0x354cd5c5, 0x839b, 0x4a1e,{ 0x80, 0x33, 0xe, 0xbc, 0x52, 0x46, 0xa4, 0xef } };

	wchar_t wszCLSID[] = _T("{354cd5c5-839b-4a1e-8033-0ebc5246ef}");
	//::StringFromGUID2(ComponentCLSID, wszCLSID, 39);

	HKEY Key;
	DWORD length = sizeof(wszCLSID) / sizeof(wchar_t);

	LSTATUS retValue;
	//将{354。。。}写到CLSID下
	//RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID"), &Key);
	//retValue = RegSetValue(Key, _T(""), REG_SZ, wszCLSID, length);
	//if (ERROR_SUCCESS != retValue) {
	//	std::cout << "写注册表失败" << std::endl;
	//	return;
	//}


	wchar_t wszComponentDesc[] = _T("SimulationComObject");
	length = sizeof(wszComponentDesc) / sizeof(wchar_t);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//{354cd5c5-839b-4a1e-8033-0ebc5246ef}"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszComponentDesc, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "写注册表失败" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	wchar_t wszModulePath[MAX_PATH] = { 0 };
	GetModuleFileName(NULL, wszModulePath, MAX_PATH);
	length = wcslen(wszModulePath);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//{354cd5c5-839b-4a1e-8033-0ebc5246ef}//InprocServer32"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszModulePath, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "写注册表失败" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	wchar_t wszProgID[] = _T("COM.Simulation.1");
	length = sizeof(wszProgID) / sizeof(wchar_t);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//{354cd5c5-839b-4a1e-8033-0ebc5246ef}//ProgID"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszProgID, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "写注册表失败" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	length = sizeof(wszCLSID) / sizeof(wchar_t);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//COM.Simulation//CLSID"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszCLSID, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "写注册表失败" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	length = sizeof(wszProgID) / sizeof(wchar_t);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//COM.Simulation//CurVer"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszProgID, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "写注册表失败" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	return S_OK;
}

int main()
{
	//CoInitialize(NULL);
	//CLSID clsid;
	//CLSIDFromProgID(OLESTR("SmpMath.1"), &clsid);
	//CComPtr<ISmpMath> pFirstClass;//智能指针  
	//pFirstClass.CoCreateInstance(clsid);
	//long ret = pFirstClass->Add(1, 2);
	//printf("%d\n", ret);
	//pFirstClass.Release();
	//CoUninitialize();

	DLLRegisterServer();

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

		//使用pIDictionary 获得 pISpellCheck
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

	//使用pIUnknowm 获得 pISpellCheck
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

