// SmpMath.cpp : CSmpMath ��ʵ��

#include "stdafx.h"
#include "SmpMath.h"


// CSmpMath



STDMETHODIMP CSmpMath::Add(DOUBLE f, DOUBLE s, DOUBLE* o)
{
	// TODO: �ڴ����ʵ�ִ���
	*o = f + s;
	return S_OK;
}
