#pragma once
#include "stdafx.h"
#include "IUnKnown.h"
#include "string"

class IDictionary : public IUnKnown {
public:
	virtual bool _stdcall Init()					   = 0;
	virtual bool _stdcall LookupWord(std::string word) = 0;
	virtual bool _stdcall UnInit()                     = 0;
};
