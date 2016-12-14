#pragma once
#include "stdafx.h"
#include "IDictionary.h"

class CDictionary :public IDictionary{
public:
	CDictionary();
	~CDictionary();
public:
	virtual HRESULT IUnKnown(const IID& iid, void** ppv);
	virtual ULONG   AddRef();
	virtual ULONG   Releace();
	virtual bool    Init(void);
	virtual bool    LookupWord(std::string word);
	virtual bool    UnInit(void);
};
