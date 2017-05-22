#pragma once
#pragma warning(disable:4930)
#pragma warning(disable:4101)

#include "stdafx.h"

template<bool>
struct ComplileTimeChecker {
	ComplileTimeChecker(...) {};
};

template<>
struct ComplileTimeChecker<false> {};

#define ASSERT(expr,msg)                                      \
	{                                                          \
		class ERROR_##msg {};                                  \
		ERROR_##msg ObjMaker();                                \
		(void)sizeof(ComplileTimeChecker<(expr)>(ObjMaker())); \
	}