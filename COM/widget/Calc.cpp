// Calc.cpp : CCalc 的实现

#include "stdafx.h"
#include "Calc.h"


// CCalc



STDMETHODIMP CCalc::Add(DOUBLE first, DOUBLE second, DOUBLE* out)
{
	// TODO: 在此添加实现代码
	*out = first + second;
	return S_OK;
}
