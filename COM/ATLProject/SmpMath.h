// SmpMath.h : CSmpMath ������

#pragma once
#include "resource.h"       // ������



#include "ATLProject_i.h"



#if defined(_WIN32_WCE) && !defined(_CE_DCOM) && !defined(_CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA)
#error "Windows CE ƽ̨(�粻�ṩ��ȫ DCOM ֧�ֵ� Windows Mobile ƽ̨)���޷���ȷ֧�ֵ��߳� COM ���󡣶��� _CE_ALLOW_SINGLE_THREADED_OBJECTS_IN_MTA ��ǿ�� ATL ֧�ִ������߳� COM ����ʵ�ֲ�����ʹ���䵥�߳� COM ����ʵ�֡�rgs �ļ��е��߳�ģ���ѱ�����Ϊ��Free����ԭ���Ǹ�ģ���Ƿ� DCOM Windows CE ƽ̨֧�ֵ�Ψһ�߳�ģ�͡�"
#endif

using namespace ATL;


// CSmpMath

class ATL_NO_VTABLE CSmpMath :
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CSmpMath, &CLSID_SmpMath>,
	public IDispatchImpl<ISmpMath, &IID_ISmpMath, &LIBID_ATLProjectLib, /*wMajor =*/ 1, /*wMinor =*/ 0>
{
public:
	CSmpMath()
	{
	}

DECLARE_REGISTRY_RESOURCEID(IDR_SMPMATH)


BEGIN_COM_MAP(CSmpMath)
	COM_INTERFACE_ENTRY(ISmpMath)
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



	STDMETHOD(Add)(DOUBLE f, DOUBLE s, DOUBLE* o);
};

OBJECT_ENTRY_AUTO(__uuidof(SmpMath), CSmpMath)
