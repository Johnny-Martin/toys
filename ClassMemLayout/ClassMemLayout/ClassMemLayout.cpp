// ClassMemLayout.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "SimpleClass.h"
#include "SingleInheritance_NoVtb.h"
#include "SingleInheritance_WithVtb.h"
#include "MultiInheritance_NoRepeat.h"
#include "MultiInheritance_WithRepeat.h"

int _tmain(int argc, _TCHAR* argv[])
{
	DriveClass_WithVtb_Multi_WithRepeat drive;
	drive.FunC();
	return 0;
}

