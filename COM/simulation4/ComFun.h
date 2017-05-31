#pragma once
#include "stdafx.h"
#include "InterfaceDecl.h"
#include "Utils.h"

/*相当于COM库中的CoGetClassObject
*调用组件DLL内的DllGetClassObject方法，获得类厂的接口指针
*外界无需使用MyCoGetClassObject，只需使用MyCoCreateInstance即可
*故此处MyCoGetClassObject是文件作用域
*/
static HRESULT MyCoGetClassObject(const IID& clsid, const IID& iid, void** ppv) {
	//加载组件Dll，获取DllGetClassObject函数地址
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
	//调用DllGetClassObjectFun，返回类厂的接口指针
	HRESULT hr = DllGetClassObjectFun(clsid, iid, ppv);
	return hr;
}


//相当于COM库中的CoCreateInstance
HRESULT MyCoCreateInstance(const IID& clsid, IUnKnown* pUnKnownOuter, const IID& iid, void** ppv) {
	*ppv = NULL;
	IClassFactory* pIClassFactory = NULL;
	//获取clsid对应组件的、类厂的、接口指针
	HRESULT ret = MyCoGetClassObject(clsid, IID_IClassFactory, (void**)pIClassFactory);
	if (SUCCEEDED(ret)) {
		//使用类厂的接口指针，调用CreateInstance方法，产生组件对象，并向对象请求
		//iid对应的接口，存入ppv（CreateInstance无需使用clsid就可创建出对应的组件）
		//（在DllGetClassObject中，会通过判断clsid，产生正确的与之对应的类厂对象）
		ret = pIClassFactory->CreateInstance(pUnKnownOuter, iid, ppv);
		pIClassFactory->Releace();
	}
	return ret;
}

