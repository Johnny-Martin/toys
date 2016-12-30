#include "stdafx.h"
#include"InterfaceDecl.h"

CDictionary::CDictionary():m_ref(0){}
CDictionary::~CDictionary() {}

HRESULT _stdcall CDictionary::QueryIntertface(const IID& iid, void** ppv) {
	if (IID_IUnknown == iid) {
		*ppv = static_cast<IDictionary*>(this);
	}
	else if (IID_IDictionary == iid) {
		*ppv = static_cast<IDictionary*>(this);
	}
	else if (IID_ISpellCheck == iid) {
		*ppv = static_cast<ISpellCheck*>(this);
	}
	else {
		*ppv = NULL;
		return E_NOINTERFACE;
	}
	reinterpret_cast<IUnKnown*>(*ppv)->AddRef();
	return S_OK;
}

ULONG _stdcall CDictionary::AddRef() {
	std::cout << "CDictionary::AddRef" << std::endl;
	return ++m_ref;
}

ULONG _stdcall CDictionary::Releace() {
	std::cout << "CDictionary::Releace" << std::endl;
	if (--m_ref == 0) {
		delete this;
		std::cout << "Destory CDictionary" << std::endl;
	}
	return m_ref;
}

bool _stdcall CDictionary::Init() {
	std::cout << "CDictionary::Init" << std::endl;
	return true;
}

bool _stdcall CDictionary::LookupWord(std::string word) {
	std::cout << "CDictionary::LookupWord : " << word << std::endl;
	return true;
}

bool _stdcall CDictionary::UnInit() {
	std::cout << "CDictionary::UnInit" << std::endl;
	return true;
}

bool _stdcall CDictionary::CheckSpell(std::string word) {
	std::cout << "CDictionary::CheckSpell : " << word << std::endl;
	return true;
}

IUnKnown* CreateInstance() {
	IUnKnown* pRet = static_cast<IDictionary*>(new CDictionary);
	pRet->AddRef();
	return pRet;
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
	//½«{354¡£¡£¡£}Ð´µ½CLSIDÏÂ
	//RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID"), &Key);
	//retValue = RegSetValue(Key, _T(""), REG_SZ, wszCLSID, length);
	//if (ERROR_SUCCESS != retValue) {
	//	std::cout << "Ð´×¢²á±íÊ§°Ü" << std::endl;
	//	return;
	//}
	

	wchar_t wszComponentDesc[] = _T("SimulationComObject");
	length = sizeof(wszComponentDesc) / sizeof(wchar_t);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//{354cd5c5-839b-4a1e-8033-0ebc5246ef}"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszComponentDesc, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "Ð´×¢²á±íÊ§°Ü" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	wchar_t wszModulePath[MAX_PATH] = {0};
	GetModuleFileName(NULL, wszModulePath, MAX_PATH);
	length =wcslen(wszModulePath);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//{354cd5c5-839b-4a1e-8033-0ebc5246ef}//InprocServer32"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszModulePath, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "Ð´×¢²á±íÊ§°Ü" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	wchar_t wszProgID[] = _T("COM.Simulation.1");
	length = sizeof(wszProgID) / sizeof(wchar_t);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//{354cd5c5-839b-4a1e-8033-0ebc5246ef}//ProgID"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszProgID, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "Ð´×¢²á±íÊ§°Ü" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	length = sizeof(wszCLSID) / sizeof(wchar_t);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//COM.Simulation//CLSID"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszCLSID, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "Ð´×¢²á±íÊ§°Ü" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	length = sizeof(wszProgID) / sizeof(wchar_t);
	RegCreateKey(HKEY_CLASSES_ROOT, _T("CLSID//COM.Simulation//CurVer"), &Key);
	retValue = RegSetValue(Key, _T(""), REG_SZ, wszProgID, length);
	if (ERROR_SUCCESS != retValue) {
		std::cout << "Ð´×¢²á±íÊ§°Ü" << std::endl;
		return S_FALSE;
	}
	RegCloseKey(Key);

	return S_OK;
}

HRESULT __stdcall DLLUnregisterServer() {

	return S_OK;
}

