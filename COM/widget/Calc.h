// Calc.h : CCalc ������

#pragma once
#include "resource.h"       // ������



#include "widget_i.h"



#if defined(_WIN32_WCE) && !defined(_CE_DCOM) && !defined(_CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA)
#error "Windows CE ƽ̨(�粻�ṩ��ȫ DCOM ֧�ֵ� Windows Mobile ƽ̨)���޷���ȷ֧�ֵ��߳� COM ���󡣶��� _CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA ��ǿ�� ATL ֧�ִ������߳� COM ����ʵ�ֲ�����ʹ���䵥�߳� COM ����ʵ�֡�rgs �ļ��е��߳�ģ���ѱ�����Ϊ��Free����ԭ���Ǹ�ģ���Ƿ� DCOM Windows CE ƽ̨֧�ֵ�Ψһ�߳�ģ�͡�"
#endif

using namespace ATL;


// CCalc

class ATL_NO_VTABLE CCalc :
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CCalc, &CLSID_Calc>,
	public IDispatchImpl<ICalc, &IID_ICalc, &LIBID_widgetLib, /*wMajor =*/ 1, /*wMinor =*/ 0>
{
public:
	CCalc()
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_CALC)


BEGIN_COM_MAP(CCalc)
	COM_INTERFACE_ENTRY(ICalc)
	COM_INTERFACE_ENTRY(IDispatch)
END_COM_MAP()



	DECLARE_PROTECT_FINAL_CONSTRUCT()

	HRESULT FinalConstruct()
	{
		return S_OK;
	}

	void FinalRelease()
	{
	}

public:



	STDMETHOD(Add)(DOUBLE first, DOUBLE second, DOUBLE* out);
};

OBJECT_ENTRY_AUTO(__uuidof(Calc), CCalc)
