#include"stdafx.h"
#include"DictionaryImp.h"

//{00000000-0000-0000-C000-000000000046} ͳһ��IID_IUnknown,����COM�����IID_IUnknown����ͬ
static const IID IID_IUnknown = {
	0x00000000, 0x0000, 0x0000,{ 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46 }
};

// {2B7846C4-2005-47D9-BFC4-6E9DBF3730D9}
static const IID IID_IDictionary = {
 0x2b7846c4, 0x2005, 0x47d9,{ 0xbf, 0xc4, 0x6e, 0x9d, 0xbf, 0x37, 0x30, 0xd9 }
};

// {687C9920-A4DB-4A57-9126-C5F4044D8704}
static const IID IID_ISpellCheck ={
	0x687c9920, 0xa4db, 0x4a57,{ 0x91, 0x26, 0xc5, 0xf4, 0x4, 0x4d, 0x87, 0x4 }
};


CDictionary::CDictionary(){}
CDictionary::~CDictionary(){}

HRESULT _stdcall CDictionary::QueryIntertface(const IID& iid, void** ppv) {
	if (IID_IUnknown == iid) {
		*ppv = static_cast<IDictionary*>(this);
	}else if (IID_IDictionary == iid) {
		*ppv = static_cast<IDictionary*>(this);
	}else if (IID_ISpellCheck == iid) {
		*ppv = static_cast<ISpellCheck*>(this);
	}else {
		*ppv = NULL;
		return E_NOINTERFACE;
	}
	reinterpret_cast<IUnKnown*>(*ppv)->AddRef();
	return S_OK;
}

ULONG _stdcall CDictionary::AddRef() {
	return 0;
}

ULONG _stdcall CDictionary::Releace() {
	return 0;
}

bool _stdcall CDictionary::Init() {
	return true;
}

bool _stdcall CDictionary::LookupWord(std::string word) {
	return true;
}

bool _stdcall CDictionary::UnInit() {
	return true;
}

bool _stdcall CDictionary::CheckSpell(std::string word) {
	return true;
}

IUnKnown* CreateInstance() {
	IUnKnown* pRet = static_cast<IDictionary*>(new CDictionary);
	pRet->AddRef();
	return pRet;
}