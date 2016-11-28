// SmpMath.cpp : CSmpMath 的实现

#include "stdafx.h"
#include "SmpMath.h"


// CSmpMath



STDMETHODIMP CSmpMath::Add(DOUBLE f, DOUBLE s, DOUBLE* o)
{
	// TODO: 在此添加实现代码
	*o = f + s;
	return S_OK;
}
