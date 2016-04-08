// AtlNoVtable.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "AtlNoVtable.h"
#include "UseVtable.h"

int _tmain(int argc, _TCHAR* argv[])
{
	Base<Drive>* pBase = new Drive();
	pBase->Func();

	VtbBase* pVtbBase = new VtbDrive();
	pVtbBase->Func();

	cout<<"drive size: "<<sizeof(Drive)<<"  vtbDrive size: "<<sizeof(VtbDrive)<<endl;

	delete pBase;
	delete pVtbBase;

	return 0;
}

