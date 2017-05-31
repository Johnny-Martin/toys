#include "stdafx.h"
#include"GUID.h"
#include"InterfaceDecl.h"
#include"Utils.h"

static HMODULE g_hMoudle = NULL;
static long    g_cComponents = 0;
static long    g_cServerLocks = 0;


/****************************************************************
*					字典组件接口、方法的实现
*****************************************************************/
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

/****************************************************************
*					类厂接口、方法的实现
*****************************************************************/
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

/*第一个参数pUnKnownOuter暂时用不到，聚合时才会用到。
*CFactory::CreateInstance并不接受clsid参数，也就是
*CFactory::CreateInstance只能创建一个固定的组件对象
*/
HRESULT _stdcall CFactory::CreateInstance(IUnKnown* pUnKnownOuter, const IID& iid, void** ppv) {
	// Cannot aggregate.
	if (pUnKnownOuter != NULL)
	{
		return CLASS_E_NOAGGREGATION;
	}
	CDictionary* pComponent = new CDictionary();
	if (pComponent == NULL) {
		return E_OUTOFMEMORY;
	}

	//类厂CreateInstance方法创建对象，并且请求对象的iid接口指针
	HRESULT hr = pComponent->QueryIntertface(iid, ppv);
	pComponent->Releace();
	return S_OK;
}

HRESULT _stdcall CFactory::LockServer(bool bLock) {
	return S_OK;
}


/****************************************************************
*					导出到DLL的方法的实现
*****************************************************************/
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
	//使用字典组件的clsid（CLSID_DictionaryComponent）注册到系统中
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

HRESULT __stdcall DllGetClassObject(const IID& clsid, const IID& iid, void** ppv) {
	if (clsid == CLSID_DictionaryComponent) {
		CFactory* pFactory = new CFactory();
		if (pFactory == NULL) {
			return E_OUTOFMEMORY;
		}
		//将类厂的指针返回给CoGetClassObject（本文中是MyCoGetClassObject）
		HRESULT hr = pFactory->QueryIntertface(iid, ppv);
		pFactory->Releace();

		return hr;
	}
	else//DLL内可以有多个组件，可以根据clsid判断想要的组件是否
	{   //在本dll内，本例中DLL内只实现了一个组件以及对应的一个类厂
		return CLASS_E_CLASSNOTAVAILABLE;
	}
	return S_OK;
}
