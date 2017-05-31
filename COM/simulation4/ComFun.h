#pragma once
#include "stdafx.h"
#include "InterfaceDecl.h"
#include "Utils.h"

/*�൱��COM���е�CoGetClassObject
*�������DLL�ڵ�DllGetClassObject����������೧�Ľӿ�ָ��
*�������ʹ��MyCoGetClassObject��ֻ��ʹ��MyCoCreateInstance����
*�ʴ˴�MyCoGetClassObject���ļ�������
*/
static HRESULT MyCoGetClassObject(const IID& clsid, const IID& iid, void** ppv) {
	//�������Dll����ȡDllGetClassObject������ַ
	std::wstring strDllPath = GetDllPathByCLSID(clsid);
	HINSTANCE hInst = ::LoadLibrary(strDllPath.c_str());
	if (NULL == hInst) {
		std::cout << "NULL == hInst";
		return E_ACCESSDENIED;
	}
	typedef HRESULT(*DllGetClassObject)(const IID& clsid, const IID& iid, void** ppv);
	DllGetClassObject DllGetClassObjectFun = (DllGetClassObject)::GetProcAddress(hInst, "DllGetClassObject");
	if (NULL == DllGetClassObjectFun) {
		std::cout << "NULL == CreateInstanceFun";
		return E_ACCESSDENIED;
	}
	//����DllGetClassObjectFun�������೧�Ľӿ�ָ��
	HRESULT hr = DllGetClassObjectFun(clsid, iid, ppv);
	return hr;
}


//�൱��COM���е�CoCreateInstance
HRESULT MyCoCreateInstance(const IID& clsid, IUnKnown* pUnKnownOuter, const IID& iid, void** ppv) {
	*ppv = NULL;
	IClassFactory* pIClassFactory = NULL;
	//��ȡclsid��Ӧ����ġ��೧�ġ��ӿ�ָ��
	HRESULT ret = MyCoGetClassObject(clsid, IID_IClassFactory, (void**)pIClassFactory);
	if (SUCCEEDED(ret)) {
		//ʹ���೧�Ľӿ�ָ�룬����CreateInstance����������������󣬲����������
		//iid��Ӧ�Ľӿڣ�����ppv��CreateInstance����ʹ��clsid�Ϳɴ�������Ӧ�������
		//����DllGetClassObject�У���ͨ���ж�clsid��������ȷ����֮��Ӧ���೧����
		ret = pIClassFactory->CreateInstance(pUnKnownOuter, iid, ppv);
		pIClassFactory->Releace();
	}
	return ret;
}

