#pragma once
#include "stdafx.h"

class IUnKnown {
public:
	virtual HRESULT _stdcall QueryIntertface(const IID& iid, void** ppv) = 0;
	virtual ULONG   _stdcall AddRef()									 = 0;
	virtual ULONG   _stdcall Releace()									 = 0;
};