// COM.cpp : 定义控制台应用程序的入口点。
//
#include "stdafx.h"
#include "InterfaceDecl.h"  

void TestATLProject(void) {
	//CoInitialize(NULL);
	//CLSID clsid;
	//CLSIDFromProgID(OLESTR("SmpMath.1"), &clsid);
	//CComPtr<ISmpMath> pFirstClass;//智能指针  
	//pFirstClass.CoCreateInstance(clsid);
	//long ret = pFirstClass->Add(1, 2);
	//printf("%d\n", ret);
	//pFirstClass.Release();
	//CoUninitialize();
}

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

void TestSimulation2(void) {
	IUnKnown* pIUnknown = CallCreateInstance(_T("simulation2.dll"));
	if (NULL == pIUnknown) {
		std::cout << "NULL == pIUnknown";
		return;
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
}

void RegisterComponent() {
	HINSTANCE hInst = ::LoadLibrary(_T("simulation3.dll"));
	if (NULL == hInst) {
		std::cout << "NULL == hInst";
		return;
	}

	typedef HRESULT (*DLLRegisterServerFunType)();
	DLLRegisterServerFunType DLLRegisterServer = (DLLRegisterServerFunType)::GetProcAddress(hInst, "DllRegisterServer");
	if (NULL == DLLRegisterServer) {
		std::cout << "NULL == CreateInstanceFun";
		return ;
	}
	DLLRegisterServer();
}

LSTATUS GetRegValue(HKEY rootKey, std::wstring wsSubKey, std::wstring& wsData) {
	HKEY key;
	LSTATUS retValue = RegOpenKeyEx(rootKey, wsSubKey.c_str(), 0, KEY_WRITE | KEY_READ, &key);
	if (retValue != ERROR_SUCCESS) {
		std::cout << "打开注册表失败" << std::endl;
		return retValue;
	}

	wchar_t wszCLSID[MAX_PACKAGE_NAME];
	DWORD cnt = MAX_PACKAGE_NAME;
	retValue = RegGetValue(key, _T(""), _T(""), RRF_RT_REG_SZ, NULL, (void*)wszCLSID, &cnt);
	RegCloseKey(key);

	wsData = wszCLSID;
	return retValue;
}

void TestSimulation3(void) {
	//RegisterComponent();//注册这一步也可以使用cmd命令 regsvr32 来完成	
	                      //注册完毕后，只需记住组件名称(COM.Simulation)即可获取组件dll路径、进而加载组件
	std::wstring wsCLSID;
	GetRegValue(HKEY_CLASSES_ROOT, _T("COM.Simulation\\CLSID"), wsCLSID);


	std::wstring wsDllPath;
	std::wstring wsInproc = _T("CLSID\\");
	wsInproc.append(wsCLSID);
	wsInproc.append(_T("\\InprocServer32"));
	GetRegValue(HKEY_CLASSES_ROOT, wsInproc.c_str(), wsDllPath);

	IUnKnown* pIUnknown = CallCreateInstance(const_cast<wchar_t*>(wsDllPath.c_str()));

	if (NULL == pIUnknown) {
		std::cout << "NULL == pIUnknown";
		return;
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
}

int main()
{
	//DLLRegisterServer();
	//TestSimulation2();
	TestSimulation3();
	return 0;
}

