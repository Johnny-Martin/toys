#include "stdafx.h"
#include"InterfaceDecl.h"

//{00000000-0000-0000-C000-000000000046} 统一的IID_IUnknown,所有COM组件的IID_IUnknown都相同
static const IID IID_IUnknown = {
	0x00000000, 0x0000, 0x0000,{ 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46 }
};

// {2B7846C4-2005-47D9-BFC4-6E9DBF3730D9}
static const IID IID_IDictionary = {
	0x2b7846c4, 0x2005, 0x47d9,{ 0xbf, 0xc4, 0x6e, 0x9d, 0xbf, 0x37, 0x30, 0xd9 }
};

// {687C9920-A4DB-4A57-9126-C5F4044D8704}
static const IID IID_ISpellCheck = {
	0x687c9920, 0xa4db, 0x4a57,{ 0x91, 0x26, 0xc5, 0xf4, 0x4, 0x4d, 0x87, 0x4 }
};


CDictionary::CDictionary() {}
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
	return 0;
}

ULONG _stdcall CDictionary::Releace() {
	std::cout << "CDictionary::Releace" << std::endl;
	return 0;
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