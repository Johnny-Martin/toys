// simulation1.cpp : �������̨Ӧ�ó������ڵ㡣
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

		//ʹ��pIDictionary ��� pISpellCheck
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

	//ʹ��pIUnknowm ��� pISpellCheck
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

