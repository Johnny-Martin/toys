// Calc.cpp : CCalc ��ʵ��

#include "stdafx.h"
#include "Calc.h"


// CCalc



STDMETHODIMP CCalc::Add(DOUBLE first, DOUBLE second, DOUBLE* out)
{
	// TODO: �ڴ����ʵ�ִ���
	*out = first + second;
	return S_OK;
}
