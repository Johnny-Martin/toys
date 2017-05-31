#include "stdafx.h"
#include"GUID.h"
#include"InterfaceDecl.h"
#include"Utils.h"

static HMODULE g_hMoudle = NULL;
static long    g_cComponents = 0;
static long    g_cServerLocks = 0;


/****************************************************************
*					�ֵ�����ӿڡ�������ʵ��
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
*					�೧�ӿڡ�������ʵ��
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

/*��һ������pUnKnownOuter��ʱ�ò������ۺ�ʱ�Ż��õ���
*CFactory::CreateInstance��������clsid������Ҳ����
*CFactory::CreateInstanceֻ�ܴ���һ���̶����������
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

	//�೧CreateInstance�����������󣬲�����������iid�ӿ�ָ��
	HRESULT hr = pComponent->QueryIntertface(iid, ppv);
	pComponent->Releace();
	return S_OK;
}

HRESULT _stdcall CFactory::LockServer(bool bLock) {
	return S_OK;
}


/****************************************************************
*					������DLL�ķ�����ʵ��
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
	//ʹ���ֵ������clsid��CLSID_DictionaryComponent��ע�ᵽϵͳ��
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
		//���೧��ָ�뷵�ظ�CoGetClassObject����������MyCoGetClassObject��
		HRESULT hr = pFactory->QueryIntertface(iid, ppv);
		pFactory->Releace();

		return hr;
	}
	else//DLL�ڿ����ж����������Ը���clsid�ж���Ҫ������Ƿ�
	{   //�ڱ�dll�ڣ�������DLL��ֻʵ����һ������Լ���Ӧ��һ���೧
		return CLASS_E_CLASSNOTAVAILABLE;
	}
	return S_OK;
}
