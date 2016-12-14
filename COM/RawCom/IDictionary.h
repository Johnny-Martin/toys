#pragma once
#include "stdafx.h"
#include "IUnKnown.h"
#include "string"

class IDictionary : public IUnKnown {
public:
	virtual bool Init(std::string word)       = 0;
	virtual bool LookupWord(std::string word) = 0;
	virtual bool UnInit(std::string word)     = 0;
};
