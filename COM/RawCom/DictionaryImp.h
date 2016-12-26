#pragma once
#include "stdafx.h"
#include "IDictionary.h"
#include "ISpellCheck.h"

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
};

IUnKnown* CreateInstance(void);