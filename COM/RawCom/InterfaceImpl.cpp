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