// CallType.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "InClass_CallType.h"
#include "OutClass_CallType.h"

int main()
{
	CallType callType;
	int tmp = callType.DefaultCall_Get();
	callType.DefaultCall(1, 2);
	callType.CdeclCall(3, 2); 
	callType.StdCall(1, 3);
	callType.ThisCall(2, 2);
	callType.FastCall(2, 3);

	DefaultCall(1, 2);
	CdeclCall(3, 2);
	StdCall(1, 3);
	FastCall(2, 3);

    return 0;
}

