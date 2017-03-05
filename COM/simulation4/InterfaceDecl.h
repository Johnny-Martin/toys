#pragma once
#include "stdafx.h"

class IUnKnown {
public:
	virtual HRESULT _stdcall QueryIntertface(const IID& iid, void** ppv) = 0;
	virtual ULONG   _stdcall AddRef() = 0;
	virtual ULONG   _stdcall Releace() = 0;
};


class IClassFactory : public IUnKnown {
public:
	virtual HRESULT _stdcall CreateInstance(const IID& iid, void** ppv) = 0;
	virtual HRESULT _stdcall LockServer(bool bLock) = 0;
};


class IDictionary : public IUnKnown {
public:
	virtual bool _stdcall Init() = 0;
	virtual bool _stdcall LookupWord(std::string word) = 0;
	virtual bool _stdcall UnInit() = 0;
};

class ISpellCheck : public IUnKnown {
public:
	virtual bool _stdcall CheckSpell(std::string word) = 0;
};

class CDictionary :public IDictionary,
	public ISpellCheck
{
public:
	CDictionary();
	~CDictionary();
public:
	virtual HRESULT _stdcall QueryIntertface(const IID& iid, void** ppv);
	virtual ULONG   _stdcall AddRef();
	virtual ULONG   _stdcall Releace();
	virtual bool    _stdcall Init(void);
	virtual bool    _stdcall LookupWord(std::string word);
	virtual bool    _stdcall UnInit(void);
	virtual bool    _stdcall CheckSpell(std::string word);
private:
	unsigned long m_ref;
};

class CFactory :public IClassFactory
{
public:
	virtual HRESULT _stdcall QueryIntertface(const IID& iid, void** ppv);
	virtual ULONG   _stdcall AddRef();
	virtual ULONG   _stdcall Releace();
	virtual HRESULT _stdcall CreateInstance(const IID& iid, void** ppv);
	virtual HRESULT _stdcall LockServer(bool bLock);

	CFactory() :m_cRef(1) {}
	~CFactory() { std::cout << "CFactory Destoryed" << std::endl; }
private:
	long m_cRef;
};
IUnKnown* CreateInstance(void);
extern"C" HRESULT __stdcall DllRegisterServer();
extern"C" HRESULT __stdcall DllUnregisterServer();

extern const IID IID_IUnknown;
extern const IID IID_IDictionary;
extern const IID IID_ISpellCheck; 
extern const IID IID_IClassFactory;