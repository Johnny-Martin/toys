// simulation1.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include"InterfaceDecl.h"

int main()
{
	IUnKnown* pIUnknown = CreateInstance();
	IDictionary* pIDictionary;
	ISpellCheck* pISpellCheck;

	HRESULT hr = pIUnknown->QueryIntertface(IID_IDictionary,(void**) &pIDictionary);
	if (SUCCEEDED(hr)) {
		pIDictionary->Init();
		pIDictionary->LookupWord("hello");
		pIDictionary->UnInit();

		//使用pIDictionary 获得 pISpellCheck
		hr = pIDictionary->QueryIntertface(IID_ISpellCheck, (void**)&pISpellCheck);
		if (SUCCEEDED(hr)) {
			std::cout << pISpellCheck << std::endl;
			pISpellCheck->CheckSpell("fuck");
			pISpellCheck->Releace();
			pISpellCheck = NULL;
		}

		pIDictionary->Releace();
		pIDictionary = NULL;
	}

	//使用pIUnknowm 获得 pISpellCheck
	hr = pIUnknown->QueryIntertface(IID_ISpellCheck, (void**)&pISpellCheck);
	if (SUCCEEDED(hr)) {
		std::cout << pISpellCheck << std::endl;
		pISpellCheck->CheckSpell("fuck");
		pISpellCheck->Releace();
		pISpellCheck = NULL;
	}

	pIUnknown->Releace();

    return 0;
}

