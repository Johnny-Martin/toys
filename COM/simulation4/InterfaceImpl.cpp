#include "stdafx.h"
#include"InterfaceDecl.h"

static HMODULE g_hMoudle = NULL;
static long    g_cComponents = 0;
static long    g_cServerLocks = 0;


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



HRESULT _stdcall CFactory::QueryIntertface(const IID& iid, void** ppv) {
	if (IID_IUnknown == iid) {
		*ppv = static_cast<IClassFactory*>(this);
	}
	else if (IID_IClassFactory == iid) {
		*ppv = static_cast<IClassFactory*>(this);
	}
	else {
		*ppv = NULL;
		return E_NOINTERFACE;
	}
	reinterpret_cast<IUnKnown*>(*ppv)->AddRef();
	return S_OK;
}

ULONG _stdcall CFactory::AddRef() {
	std::cout << "CFactory::AddRef" << std::endl;
	return ++m_cRef;
}

ULONG _stdcall CFactory::Releace() {
	std::cout << "CFactory::Releace" << std::endl;
	if (--m_cRef == 0) {
		delete this;
		std::cout << "Destory CFactory" << std::endl;
	}
	return m_cRef;
}

HRESULT _stdcall CFactory::CreateInstance(const IID& iid, void** ppv) {
	return S_OK;
}
HRESULT _stdcall CFactory::LockServer(bool bLock) {
	return S_OK;
}
IUnKnown* CreateInstance() {
	IUnKnown* pRet = static_cast<IDictionary*>(new CDictionary);
	pRet->AddRef();
	return pRet;
}


LSTATUS SetRegValue(HKEY rootKey, std::wstring wsSubKey, std::wstring wsData) {
	HKEY key;
	LSTATUS retValue = RegOpenKeyEx(rootKey, _T(""), 0, KEY_WRITE | KEY_READ, &key);
	if (retValue != ERROR_SUCCESS) {
		std::cout << "打开注册表失败" << std::endl;
		return retValue;
	}

	//依次创建wsSubKey路径中的子键
	std::vector<std::wstring> subKeyVec;
	int newPos = 0;
	int oldPos = 0;
	while (true) {
		newPos = wsSubKey.find(_T("\\"), oldPos);
		if (newPos != std::string::npos) {
			subKeyVec.push_back(wsSubKey.substr(oldPos, newPos - oldPos));
			oldPos = newPos + 1;
		}
		else {
			break;
		}
	}
	if (subKeyVec.size() == 0) {
		return ERROR_INVALID_FUNCTION;
	}

	HKEY fatherKey = key;
	HKEY subKey = 0;
	for (size_t i = 0; i < subKeyVec.size(); ++i) {
		DWORD dw;
		RegCreateKeyEx(fatherKey,
			subKeyVec[i].c_str(),
			NULL,
			NULL,
			REG_OPTION_NON_VOLATILE,
			KEY_WRITE | KEY_READ, NULL,
			&subKey,
			&dw);
		RegCloseKey(fatherKey);
		fatherKey = subKey;
	}

	retValue = RegSetValue(subKey, _T(""), REG_SZ, wsData.c_str(), wsData.length());
	RegCloseKey(subKey);

	return retValue;
}
HRESULT __stdcall DllRegisterServer() {
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

	//static const GUID ComponentCLSID = { 0x354cd5c5, 0x839b, 0x4a1e,{ 0x80, 0x33, 0xe, 0xbc, 0x52, 0x46, 0xa4, 0xef } };
	wchar_t wszCLSID[] = _T("{354CD5C5-839B-4A1E-8033-0EBC5246A4EF}");


	SetRegValue(HKEY_CLASSES_ROOT, _T("CLSID\\{354CD5C5-839B-4A1E-8033-0EBC5246A4EF}\\"), _T("SimulationComObject"));

	wchar_t wszModulePath[MAX_PATH] = { 0 };
	HMODULE hModule;
	GetModuleHandleEx(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS, (LPTSTR)DllRegisterServer, &hModule);
	if (NULL == hModule)
	{
		std::cout << "NULL == hModule";
		return S_OK;
	}
	GetModuleFileName(hModule, wszModulePath, MAX_PATH);
	SetRegValue(HKEY_CLASSES_ROOT, _T("CLSID\\{354CD5C5-839B-4A1E-8033-0EBC5246A4EF}\\InprocServer32\\"), wszModulePath);

	SetRegValue(HKEY_CLASSES_ROOT, _T("CLSID\\{354CD5C5-839B-4A1E-8033-0EBC5246A4EF}\\ProgID\\"), _T("COM.Simulation.1"));

	SetRegValue(HKEY_CLASSES_ROOT, _T("COM.Simulation\\"), _T(""));

	SetRegValue(HKEY_CLASSES_ROOT, _T("COM.Simulation\\CLSID\\"), _T("{354CD5C5-839B-4A1E-8033-0EBC5246A4EF}"));

	SetRegValue(HKEY_CLASSES_ROOT, _T("COM.Simulation\\CurVer\\"), _T("COM.Simulation.1"));

	return S_OK;
}

HRESULT __stdcall DllUnregisterServer() {

	return S_OK;
}

